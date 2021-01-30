XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.79747
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 210130-79747
0010               *
0011               * Bank 0 "Jill"
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
**** **** ****     > stevie_b0.asm.79747
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
0185      A01E     tv.cmdb.hcolor    equ  tv.top + 30     ; FG/BG-color command buffer header line
0186      A020     tv.pane.focus     equ  tv.top + 32     ; Identify pane that has focus
0187      A022     tv.task.oneshot   equ  tv.top + 34     ; Pointer to one-shot routine
0188      A024     tv.fj.stackpnt    equ  tv.top + 36     ; Pointer to farjump return stack
0189      A026     tv.error.visible  equ  tv.top + 38     ; Error pane visible
0190      A028     tv.error.msg      equ  tv.top + 40     ; Error message (max. 160 characters)
0191      A0C8     tv.free           equ  tv.top + 200    ; End of structure
0192               *--------------------------------------------------------------
0193               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0194               *--------------------------------------------------------------
0195      A100     fb.struct         equ  >a100           ; Structure begin
0196      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0197      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0198      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0199                                                      ; line X in editor buffer).
0200      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0201                                                      ; (offset 0 .. @fb.scrrows)
0202      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0203      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0204      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0205      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0206      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0207      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0208      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0209      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0210      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0211      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0212      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0213      A11E     fb.free           equ  fb.struct + 30  ; End of structure
0214               *--------------------------------------------------------------
0215               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0216               *--------------------------------------------------------------
0217      A200     edb.struct        equ  >a200           ; Begin structure
0218      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0219      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0220      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0221      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0222      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0223      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0224      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0225      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0226      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0227      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0228                                                      ; with current filename.
0229      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0230                                                      ; with current file type.
0231      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0232      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0233      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0234                                                      ; for filename, but not always used.
0235      A269     edb.free          equ  edb.struct + 105; End of structure
0236               *--------------------------------------------------------------
0237               * Command buffer structure            @>a300-a3ff   (256 bytes)
0238               *--------------------------------------------------------------
0239      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0240      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0241      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0242      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0243      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0244      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0245      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0246      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0247      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0248      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0249      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0250      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0251      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0252      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0253      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0254      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0255      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0256      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0257      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0258      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0259      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0260      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0261      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0262               *--------------------------------------------------------------
0263               * File handle structure               @>a400-a4ff   (256 bytes)
0264               *--------------------------------------------------------------
0265      A400     fh.struct         equ  >a400           ; stevie file handling structures
0266               ;***********************************************************************
0267               ; ATTENTION
0268               ; The dsrlnk variables must form a continuous memory block and keep
0269               ; their order!
0270               ;***********************************************************************
0271      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0272      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0273      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0274      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0275      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0276      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0277      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0278      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0279      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0280      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0281      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0282      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0283      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0284      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0285      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0286      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0287      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0288      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0289      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0290      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0291      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0292      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0293      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0294      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0295      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0296      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0297      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0298      A45A     fh.kilobytes.prev equ  fh.struct + 90  ; Kilobytes processed (previous)
0299      A45C     fh.membuffer      equ  fh.struct + 92  ; 80 bytes file memory buffer
0300      A4AC     fh.free           equ  fh.struct +172  ; End of structure
0301      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0302      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0303               *--------------------------------------------------------------
0304               * Index structure                     @>a500-a5ff   (256 bytes)
0305               *--------------------------------------------------------------
0306      A500     idx.struct        equ  >a500           ; stevie index structure
0307      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0308      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0309      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0310               *--------------------------------------------------------------
0311               * Frame buffer                        @>a600-afff  (2560 bytes)
0312               *--------------------------------------------------------------
0313      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0314      0960     fb.size           equ  80*30           ; Frame buffer size
0315               *--------------------------------------------------------------
0316               * Index                               @>b000-bfff  (4096 bytes)
0317               *--------------------------------------------------------------
0318      B000     idx.top           equ  >b000           ; Top of index
0319      1000     idx.size          equ  4096            ; Index size
0320               *--------------------------------------------------------------
0321               * Editor buffer                       @>c000-cfff  (4096 bytes)
0322               *--------------------------------------------------------------
0323      C000     edb.top           equ  >c000           ; Editor buffer high memory
0324      1000     edb.size          equ  4096            ; Editor buffer size
0325               *--------------------------------------------------------------
0326               * Command history buffer              @>d000-dfff  (4096 bytes)
0327               *--------------------------------------------------------------
0328      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0329      1000     cmdb.size         equ  4096            ; Command buffer size
0330               *--------------------------------------------------------------
0331               * Heap                                @>e000-ebff  (3072 bytes)
0332               *--------------------------------------------------------------
0333      E000     heap.top          equ  >e000           ; Top of heap
0334               *--------------------------------------------------------------
0335               * Farjump return stack                @>ec00-efff  (1024 bytes)
0336               *--------------------------------------------------------------
0337      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b0.asm.79747
0016               
0017               ***************************************************************
0018               * Spectra2 core configuration
0019               ********|*****|*********************|**************************
0020      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0021                                                   ; grows downwards to >2000
0022               ***************************************************************
0023               * BANK 0
0024               ********|*****|*********************|**************************
0025      6000     bankid  equ   bank0                 ; Set bank identifier to current bank
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
**** **** ****     > stevie_b0.asm.79747
0029               
0030               ***************************************************************
0031               * Step 1: Switch to bank 0 (uniform code accross all banks)
0032               ********|*****|*********************|**************************
0033                       aorg  kickstart.code1       ; >6030
0034               kickstart.step1:
0035 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0036               ***************************************************************
0037               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0038               ********|*****|*********************|**************************
0039               kickstart.step2:
0040 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6036 607A 
0041 6038 0201  20         li    r1,>2000
     603A 2000 
0042 603C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     603E 0100 
0043 6040 06A0  32         bl    @kickstart.copy       ; Copy memory
     6042 6064 
0044               ***************************************************************
0045               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0046               ********|*****|*********************|**************************
0047               kickstart.step3:
0048 6044 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     6046 706A 
0049 6048 0201  20         li    r1,>3000
     604A 3000 
0050 604C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     604E 0100 
0051 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6064 
0052               ***************************************************************
0053               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0054               ********|*****|*********************|**************************
0055               kickstart.step4:
0056 6054 0460  28         b     @runlib               ; Start spectra2 library
     6056 2E08 
0057                       ;------------------------------------------------------
0058                       ; Assert. Should not get here! Crash and burn!
0059                       ;------------------------------------------------------
0060 6058 0200  20         li    r0,$                  ; Current location
     605A 6058 
0061 605C C800  38         mov   r0,@>ffce             ; \ Save caller address
     605E FFCE 
0062 6060 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6062 2026 
0063               ***************************************************************
0064               * Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
0065               ********|*****|*********************|**************************
0066                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0067               
0068               ***************************************************************
0069               * Copy routine
0070               ********|*****|*********************|**************************
0071               kickstart.copy:
0072                       ;------------------------------------------------------
0073                       ; Copy memory to destination
0074                       ; r0 = Source CPU address
0075                       ; r1 = Target CPU address
0076                       ; r2 = Bytes to copy/16
0077                       ;------------------------------------------------------
0078 6064 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0079 6066 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0080 6068 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0081 606A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0082 606C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0083 606E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0084 6070 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0085 6072 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0086 6074 0602  14         dec   r2
0087 6076 16F6  14         jne   -!                    ; Loop until done
0088 6078 045B  20         b     *r11                  ; Return to caller
0089               
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
0012 607A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 607C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 607E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6080 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6082 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6084 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6086 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6088 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 608A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 608C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 608E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 6090 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 6092 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6094 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6096 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6098 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 609A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 609C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 609E D000     w$d000  data  >d000                 ; >d000
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
0038 60A0 022B  22         ai    r11,-4                ; Remove opcode offset
     60A2 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60A4 C800  38         mov   r0,@>ffe0
     60A6 FFE0 
0043 60A8 C801  38         mov   r1,@>ffe2
     60AA FFE2 
0044 60AC C802  38         mov   r2,@>ffe4
     60AE FFE4 
0045 60B0 C803  38         mov   r3,@>ffe6
     60B2 FFE6 
0046 60B4 C804  38         mov   r4,@>ffe8
     60B6 FFE8 
0047 60B8 C805  38         mov   r5,@>ffea
     60BA FFEA 
0048 60BC C806  38         mov   r6,@>ffec
     60BE FFEC 
0049 60C0 C807  38         mov   r7,@>ffee
     60C2 FFEE 
0050 60C4 C808  38         mov   r8,@>fff0
     60C6 FFF0 
0051 60C8 C809  38         mov   r9,@>fff2
     60CA FFF2 
0052 60CC C80A  38         mov   r10,@>fff4
     60CE FFF4 
0053 60D0 C80B  38         mov   r11,@>fff6
     60D2 FFF6 
0054 60D4 C80C  38         mov   r12,@>fff8
     60D6 FFF8 
0055 60D8 C80D  38         mov   r13,@>fffa
     60DA FFFA 
0056 60DC C80E  38         mov   r14,@>fffc
     60DE FFFC 
0057 60E0 C80F  38         mov   r15,@>ffff
     60E2 FFFF 
0058 60E4 02A0  12         stwp  r0
0059 60E6 C800  38         mov   r0,@>ffdc
     60E8 FFDC 
0060 60EA 02C0  12         stst  r0
0061 60EC C800  38         mov   r0,@>ffde
     60EE FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60F0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60F2 8300 
0067 60F4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60F6 8302 
0068 60F8 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60FA 4A4A 
0069 60FC 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60FE 2E0C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 6100 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6102 22FA 
0078 6104 21EA                   data graph1           ; Equate selected video mode table
0079               
0080 6106 06A0  32         bl    @ldfnt
     6108 2362 
0081 610A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     610C 000C 
0082               
0083 610E 06A0  32         bl    @filv
     6110 2290 
0084 6112 0380                   data >0380,>f0,32*24  ; Load color table
     6114 00F0 
     6116 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 6118 06A0  32         bl    @putat                ; Show crash message
     611A 2444 
0089 611C 0000                   data >0000,cpu.crash.msg.crashed
     611E 2178 
0090               
0091 6120 06A0  32         bl    @puthex               ; Put hex value on screen
     6122 2990 
0092 6124 0015                   byte 0,21             ; \ i  p0 = YX position
0093 6126 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 6128 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 612A 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 612C 06A0  32         bl    @putat                ; Show caller message
     612E 2444 
0101 6130 0100                   data >0100,cpu.crash.msg.caller
     6132 218E 
0102               
0103 6134 06A0  32         bl    @puthex               ; Put hex value on screen
     6136 2990 
0104 6138 0115                   byte 1,21             ; \ i  p0 = YX position
0105 613A FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 613C 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 613E 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 6140 06A0  32         bl    @putat
     6142 2444 
0113 6144 0300                   byte 3,0
0114 6146 21AA                   data cpu.crash.msg.wp
0115 6148 06A0  32         bl    @putat
     614A 2444 
0116 614C 0400                   byte 4,0
0117 614E 21B0                   data cpu.crash.msg.st
0118 6150 06A0  32         bl    @putat
     6152 2444 
0119 6154 1600                   byte 22,0
0120 6156 21B6                   data cpu.crash.msg.source
0121 6158 06A0  32         bl    @putat
     615A 2444 
0122 615C 1700                   byte 23,0
0123 615E 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 6160 06A0  32         bl    @at                   ; Put cursor at YX
     6162 2694 
0128 6164 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6166 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6168 FFDC 
0132 616A 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 616C C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 616E 0649  14         dect  stack
0138 6170 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 6172 0649  14         dect  stack
0140 6174 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6176 0649  14         dect  stack
0142 6178 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 617A C046  18         mov   tmp2,r1               ; Save register number
0148 617C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     617E 0001 
0149 6180 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 6182 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 6184 06A0  32         bl    @mknum
     6186 299A 
0154 6188 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 618A 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 618C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 618E 06A0  32         bl    @setx                 ; Set cursor X position
     6190 26AA 
0160 6192 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 6194 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6196 2420 
0164 6198 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 619A 06A0  32         bl    @setx                 ; Set cursor X position
     619C 26AA 
0168 619E 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61A0 0281  22         ci    r1,10
     61A2 000A 
0172 61A4 1102  14         jlt   !
0173 61A6 0620  34         dec   @wyx                  ; x=x-1
     61A8 832A 
0174               
0175 61AA 06A0  32 !       bl    @putstr
     61AC 2420 
0176 61AE 21A4                   data cpu.crash.msg.r
0177               
0178 61B0 06A0  32         bl    @mknum
     61B2 299A 
0179 61B4 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61B6 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61B8 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61BA 06A0  32         bl    @mkhex                ; Convert hex word to string
     61BC 290C 
0188 61BE 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61C0 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61C2 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61C4 06A0  32         bl    @setx                 ; Set cursor X position
     61C6 26AA 
0194 61C8 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61CA 06A0  32         bl    @putstr               ; Put '  >'
     61CC 2420 
0198 61CE 21A6                   data cpu.crash.msg.marker
0199               
0200 61D0 06A0  32         bl    @setx                 ; Set cursor X position
     61D2 26AA 
0201 61D4 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61D6 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61D8 2420 
0205 61DA 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61DC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61DE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61E2 06A0  32         bl    @down                 ; y=y+1
     61E4 269A 
0213               
0214 61E6 0586  14         inc   tmp2
0215 61E8 0286  22         ci    tmp2,17
     61EA 0011 
0216 61EC 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61EE 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61F0 2D0A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61F2 1553             byte  21
0225 61F3 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 6208 1543             byte  21
0230 6209 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 621E 0152             byte  1
0235 621F ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 6220 0320             byte  3
0240 6221 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 6224 042A             byte  4
0245 6225 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 622A 042A             byte  4
0250 622B ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6230 1B53             byte  27
0255 6231 ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 624C 1642             byte  22
0260 624D ....             text  'Build-ID  210130-79747'
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
0007 6264 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6266 000E 
     6268 0106 
     626A 0204 
     626C 0020 
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
0032 626E 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6270 000E 
     6272 0106 
     6274 00F4 
     6276 0028 
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
0058 6278 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     627A 003F 
     627C 0240 
     627E 03F4 
     6280 0050 
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
0084 6282 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6284 003F 
     6286 0240 
     6288 03F4 
     628A 0050 
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
0013 628C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 628E 16FD             data  >16fd                 ; |         jne   mcloop
0015 6290 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6292 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6294 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 6296 0201  20         li    r1,mccode             ; Machinecode to patch
     6298 2212 
0037 629A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     629C 8322 
0038 629E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62A0 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62A2 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62A4 045B  20         b     *r11                  ; Return to caller
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
0056 62A6 C0F9  30 popr3   mov   *stack+,r3
0057 62A8 C0B9  30 popr2   mov   *stack+,r2
0058 62AA C079  30 popr1   mov   *stack+,r1
0059 62AC C039  30 popr0   mov   *stack+,r0
0060 62AE C2F9  30 poprt   mov   *stack+,r11
0061 62B0 045B  20         b     *r11
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
0085 62B2 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62B4 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62B6 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 62B8 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62BA 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62BC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62BE FFCE 
0095 62C0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62C2 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62C4 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62C6 830B 
     62C8 830A 
0100               
0101 62CA 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62CC 0001 
0102 62CE 1602  14         jne   filchk2
0103 62D0 DD05  32         movb  tmp1,*tmp0+
0104 62D2 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62D4 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62D6 0002 
0109 62D8 1603  14         jne   filchk3
0110 62DA DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62DC DD05  32         movb  tmp1,*tmp0+
0112 62DE 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62E0 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62E2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62E4 0001 
0118 62E6 1605  14         jne   fil16b
0119 62E8 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62EA 0606  14         dec   tmp2
0121 62EC 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62EE 0002 
0122 62F0 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62F2 C1C6  18 fil16b  mov   tmp2,tmp3
0127 62F4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62F6 0001 
0128 62F8 1301  14         jeq   dofill
0129 62FA 0606  14         dec   tmp2                  ; Make TMP2 even
0130 62FC CD05  34 dofill  mov   tmp1,*tmp0+
0131 62FE 0646  14         dect  tmp2
0132 6300 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 6302 C1C7  18         mov   tmp3,tmp3
0137 6304 1301  14         jeq   fil.exit
0138 6306 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 6308 045B  20         b     *r11
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
0159 630A C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 630C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 630E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 6310 0264  22 xfilv   ori   tmp0,>4000
     6312 4000 
0166 6314 06C4  14         swpb  tmp0
0167 6316 D804  38         movb  tmp0,@vdpa
     6318 8C02 
0168 631A 06C4  14         swpb  tmp0
0169 631C D804  38         movb  tmp0,@vdpa
     631E 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 6320 020F  20         li    r15,vdpw              ; Set VDP write address
     6322 8C00 
0174 6324 06C5  14         swpb  tmp1
0175 6326 C820  54         mov   @filzz,@mcloop        ; Setup move command
     6328 22B6 
     632A 8320 
0176 632C 0460  28         b     @mcloop               ; Write data to VDP
     632E 8320 
0177               *--------------------------------------------------------------
0181 6330 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 6332 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6334 4000 
0202 6336 06C4  14 vdra    swpb  tmp0
0203 6338 D804  38         movb  tmp0,@vdpa
     633A 8C02 
0204 633C 06C4  14         swpb  tmp0
0205 633E D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6340 8C02 
0206 6342 045B  20         b     *r11                  ; Exit
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
0217 6344 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 6346 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6348 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     634A 4000 
0223 634C 06C4  14         swpb  tmp0                  ; \
0224 634E D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6350 8C02 
0225 6352 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 6354 D804  38         movb  tmp0,@vdpa            ; /
     6356 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6358 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 635A D7C5  30         movb  tmp1,*r15             ; Write byte
0232 635C 045B  20         b     *r11                  ; Exit
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
0251 635E C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6360 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 6362 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6364 8C02 
0257 6366 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6368 D804  38         movb  tmp0,@vdpa            ; /
     636A 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 636C D120  34         movb  @vdpr,tmp0            ; Read byte
     636E 8800 
0263 6370 0984  56         srl   tmp0,8                ; Right align
0264 6372 045B  20         b     *r11                  ; Exit
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
0283 6374 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 6376 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 6378 C144  18         mov   tmp0,tmp1
0289 637A 05C5  14         inct  tmp1
0290 637C D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 637E 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6380 FF00 
0292 6382 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 6384 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6386 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 6388 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     638A 8000 
0298 638C 0206  20         li    tmp2,8
     638E 0008 
0299 6390 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6392 830B 
0300 6394 06C5  14         swpb  tmp1
0301 6396 D805  38         movb  tmp1,@vdpa
     6398 8C02 
0302 639A 06C5  14         swpb  tmp1
0303 639C D805  38         movb  tmp1,@vdpa
     639E 8C02 
0304 63A0 0225  22         ai    tmp1,>0100
     63A2 0100 
0305 63A4 0606  14         dec   tmp2
0306 63A6 16F4  14         jne   vidta1                ; Next register
0307 63A8 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63AA 833A 
0308 63AC 045B  20         b     *r11
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
0325 63AE C13B  30 putvr   mov   *r11+,tmp0
0326 63B0 0264  22 putvrx  ori   tmp0,>8000
     63B2 8000 
0327 63B4 06C4  14         swpb  tmp0
0328 63B6 D804  38         movb  tmp0,@vdpa
     63B8 8C02 
0329 63BA 06C4  14         swpb  tmp0
0330 63BC D804  38         movb  tmp0,@vdpa
     63BE 8C02 
0331 63C0 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63C2 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63C4 C10E  18         mov   r14,tmp0
0341 63C6 0984  56         srl   tmp0,8
0342 63C8 06A0  32         bl    @putvrx               ; Write VR#0
     63CA 2336 
0343 63CC 0204  20         li    tmp0,>0100
     63CE 0100 
0344 63D0 D820  54         movb  @r14lb,@tmp0lb
     63D2 831D 
     63D4 8309 
0345 63D6 06A0  32         bl    @putvrx               ; Write VR#1
     63D8 2336 
0346 63DA 0458  20         b     *tmp4                 ; Exit
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
0360 63DC C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63DE 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63E0 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63E2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63E4 7FFF 
0364 63E6 2120  38         coc   @wbit0,tmp0
     63E8 2020 
0365 63EA 1604  14         jne   ldfnt1
0366 63EC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63EE 8000 
0367 63F0 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63F2 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63F4 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63F6 23E4 
0372 63F8 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     63FA 9C02 
0373 63FC 06C4  14         swpb  tmp0
0374 63FE D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6400 9C02 
0375 6402 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6404 9800 
0376 6406 06C5  14         swpb  tmp1
0377 6408 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     640A 9800 
0378 640C 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 640E D805  38         movb  tmp1,@grmwa
     6410 9C02 
0383 6412 06C5  14         swpb  tmp1
0384 6414 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6416 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 6418 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 641A 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     641C 22B8 
0390 641E 05C8  14         inct  tmp4                  ; R11=R11+2
0391 6420 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 6422 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6424 7FFF 
0393 6426 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6428 23E6 
0394 642A C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     642C 23E8 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 642E 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6430 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 6432 D120  34         movb  @grmrd,tmp0
     6434 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 6436 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6438 2020 
0405 643A 1603  14         jne   ldfnt3                ; No, so skip
0406 643C D1C4  18         movb  tmp0,tmp3
0407 643E 0917  56         srl   tmp3,1
0408 6440 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 6442 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6444 8C00 
0413 6446 0606  14         dec   tmp2
0414 6448 16F2  14         jne   ldfnt2
0415 644A 05C8  14         inct  tmp4                  ; R11=R11+2
0416 644C 020F  20         li    r15,vdpw              ; Set VDP write address
     644E 8C00 
0417 6450 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6452 7FFF 
0418 6454 0458  20         b     *tmp4                 ; Exit
0419 6456 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6458 2000 
     645A 8C00 
0420 645C 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 645E 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6460 0200 
     6462 0000 
0425 6464 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6466 01C0 
     6468 0101 
0426 646A 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     646C 02A0 
     646E 0101 
0427 6470 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6472 00E0 
     6474 0101 
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
0445 6476 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 6478 C3A0  34         mov   @wyx,r14              ; Get YX
     647A 832A 
0447 647C 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 647E 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6480 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 6482 C3A0  34         mov   @wyx,r14              ; Get YX
     6484 832A 
0454 6486 024E  22         andi  r14,>00ff             ; Remove Y
     6488 00FF 
0455 648A A3CE  18         a     r14,r15               ; pos = pos + X
0456 648C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     648E 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 6490 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 6492 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 6494 020F  20         li    r15,vdpw              ; VDP write address
     6496 8C00 
0463 6498 045B  20         b     *r11
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
0478 649A C17B  30 putstr  mov   *r11+,tmp1
0479 649C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 649E C1CB  18 xutstr  mov   r11,tmp3
0481 64A0 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64A2 23FC 
0482 64A4 C2C7  18         mov   tmp3,r11
0483 64A6 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 64A8 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 64AA 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 64AC 0286  22         ci    tmp2,255              ; Length > 255 ?
     64AE 00FF 
0491 64B0 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 64B2 0460  28         b     @xpym2v               ; Display string
     64B4 2452 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 64B6 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64B8 FFCE 
0498 64BA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64BC 2026 
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
0514 64BE C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64C0 832A 
0515 64C2 0460  28         b     @putstr
     64C4 2420 
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
0020 64C6 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64C8 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64CA C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 64CC C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64CE 1604  14         jne   !                     ; No, continue
0028               
0029 64D0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64D2 FFCE 
0030 64D4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64D6 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64D8 0264  22 !       ori   tmp0,>4000
     64DA 4000 
0035 64DC 06C4  14         swpb  tmp0
0036 64DE D804  38         movb  tmp0,@vdpa
     64E0 8C02 
0037 64E2 06C4  14         swpb  tmp0
0038 64E4 D804  38         movb  tmp0,@vdpa
     64E6 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64E8 020F  20         li    r15,vdpw              ; Set VDP write address
     64EA 8C00 
0043 64EC C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     64EE 247C 
     64F0 8320 
0044 64F2 0460  28         b     @mcloop               ; Write data to VDP and return
     64F4 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 64F6 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 64F8 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 64FA C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 64FC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 64FE 06C4  14 xpyv2m  swpb  tmp0
0027 6500 D804  38         movb  tmp0,@vdpa
     6502 8C02 
0028 6504 06C4  14         swpb  tmp0
0029 6506 D804  38         movb  tmp0,@vdpa
     6508 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 650A 020F  20         li    r15,vdpr              ; Set VDP read address
     650C 8800 
0034 650E C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6510 249E 
     6512 8320 
0035 6514 0460  28         b     @mcloop               ; Read data from VDP
     6516 8320 
0036 6518 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 651A C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 651C C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 651E C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6520 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6522 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6524 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6526 FFCE 
0034 6528 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     652A 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 652C 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     652E 0001 
0039 6530 1603  14         jne   cpym0                 ; No, continue checking
0040 6532 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6534 04C6  14         clr   tmp2                  ; Reset counter
0042 6536 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6538 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     653A 7FFF 
0047 653C C1C4  18         mov   tmp0,tmp3
0048 653E 0247  22         andi  tmp3,1
     6540 0001 
0049 6542 1618  14         jne   cpyodd                ; Odd source address handling
0050 6544 C1C5  18 cpym1   mov   tmp1,tmp3
0051 6546 0247  22         andi  tmp3,1
     6548 0001 
0052 654A 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 654C 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     654E 2020 
0057 6550 1605  14         jne   cpym3
0058 6552 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     6554 2500 
     6556 8320 
0059 6558 0460  28         b     @mcloop               ; Copy memory and exit
     655A 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 655C C1C6  18 cpym3   mov   tmp2,tmp3
0064 655E 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6560 0001 
0065 6562 1301  14         jeq   cpym4
0066 6564 0606  14         dec   tmp2                  ; Make TMP2 even
0067 6566 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 6568 0646  14         dect  tmp2
0069 656A 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 656C C1C7  18         mov   tmp3,tmp3
0074 656E 1301  14         jeq   cpymz
0075 6570 D554  38         movb  *tmp0,*tmp1
0076 6572 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 6574 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     6576 8000 
0081 6578 10E9  14         jmp   cpym2
0082 657A DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 657C C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 657E 0649  14         dect  stack
0065 6580 C64B  30         mov   r11,*stack            ; Push return address
0066 6582 0649  14         dect  stack
0067 6584 C640  30         mov   r0,*stack             ; Push r0
0068 6586 0649  14         dect  stack
0069 6588 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 658A 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 658C 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 658E 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     6590 4000 
0077 6592 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     6594 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 6596 020C  20         li    r12,>1e00             ; SAMS CRU address
     6598 1E00 
0082 659A 04C0  14         clr   r0
0083 659C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 659E D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65A0 D100  18         movb  r0,tmp0
0086 65A2 0984  56         srl   tmp0,8                ; Right align
0087 65A4 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65A6 833C 
0088 65A8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65AA C339  30         mov   *stack+,r12           ; Pop r12
0094 65AC C039  30         mov   *stack+,r0            ; Pop r0
0095 65AE C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65B0 045B  20         b     *r11                  ; Return to caller
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
0131 65B2 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65B4 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65B6 0649  14         dect  stack
0135 65B8 C64B  30         mov   r11,*stack            ; Push return address
0136 65BA 0649  14         dect  stack
0137 65BC C640  30         mov   r0,*stack             ; Push r0
0138 65BE 0649  14         dect  stack
0139 65C0 C64C  30         mov   r12,*stack            ; Push r12
0140 65C2 0649  14         dect  stack
0141 65C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65C6 0649  14         dect  stack
0143 65C8 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65CA 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65CC 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 65CE 0284  22         ci    tmp0,255              ; Crash if page > 255
     65D0 00FF 
0153 65D2 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 65D4 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65D6 001E 
0158 65D8 150A  14         jgt   !
0159 65DA 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65DC 0004 
0160 65DE 1107  14         jlt   !
0161 65E0 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65E2 0012 
0162 65E4 1508  14         jgt   sams.page.set.switch_page
0163 65E6 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65E8 0006 
0164 65EA 1501  14         jgt   !
0165 65EC 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 65EE C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65F0 FFCE 
0170 65F2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65F4 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 65F6 020C  20         li    r12,>1e00             ; SAMS CRU address
     65F8 1E00 
0176 65FA C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 65FC 06C0  14         swpb  r0                    ; LSB to MSB
0178 65FE 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6600 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6602 4000 
0180 6604 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 6606 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6608 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 660A C339  30         mov   *stack+,r12           ; Pop r12
0188 660C C039  30         mov   *stack+,r0            ; Pop r0
0189 660E C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6610 045B  20         b     *r11                  ; Return to caller
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
0204 6612 020C  20         li    r12,>1e00             ; SAMS CRU address
     6614 1E00 
0205 6616 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6618 045B  20         b     *r11                  ; Return to caller
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
0227 661A 020C  20         li    r12,>1e00             ; SAMS CRU address
     661C 1E00 
0228 661E 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6620 045B  20         b     *r11                  ; Return to caller
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
0260 6622 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 6624 0649  14         dect  stack
0263 6626 C64B  30         mov   r11,*stack            ; Save return address
0264 6628 0649  14         dect  stack
0265 662A C644  30         mov   tmp0,*stack           ; Save tmp0
0266 662C 0649  14         dect  stack
0267 662E C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6630 0649  14         dect  stack
0269 6632 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 6634 0649  14         dect  stack
0271 6636 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6638 0206  20         li    tmp2,8                ; Set loop counter
     663A 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 663C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 663E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6640 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6642 253C 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 6644 0606  14         dec   tmp2                  ; Next iteration
0288 6646 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6648 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     664A 2598 
0294                                                   ; / activating changes.
0295               
0296 664C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 664E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6650 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 6652 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 6654 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 6656 045B  20         b     *r11                  ; Return to caller
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
0318 6658 0649  14         dect  stack
0319 665A C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 665C 06A0  32         bl    @sams.layout
     665E 25A8 
0324 6660 25EC                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 6662 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 6664 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 6666 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6668 0002 
0336 666A 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     666C 0003 
0337 666E A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6670 000A 
0338 6672 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     6674 000B 
0339 6676 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6678 000C 
0340 667A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     667C 000D 
0341 667E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6680 000E 
0342 6682 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     6684 000F 
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
0363 6686 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 6688 0649  14         dect  stack
0366 668A C64B  30         mov   r11,*stack            ; Push return address
0367 668C 0649  14         dect  stack
0368 668E C644  30         mov   tmp0,*stack           ; Push tmp0
0369 6690 0649  14         dect  stack
0370 6692 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 6694 0649  14         dect  stack
0372 6696 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 6698 0649  14         dect  stack
0374 669A C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 669C 0205  20         li    tmp1,sams.layout.copy.data
     669E 2644 
0379 66A0 0206  20         li    tmp2,8                ; Set loop counter
     66A2 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66A4 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66A6 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66A8 2504 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66AA CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66AC 833C 
0390               
0391 66AE 0606  14         dec   tmp2                  ; Next iteration
0392 66B0 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66B2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66BA C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66BC 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66BE 2000             data  >2000                 ; >2000-2fff
0408 66C0 3000             data  >3000                 ; >3000-3fff
0409 66C2 A000             data  >a000                 ; >a000-afff
0410 66C4 B000             data  >b000                 ; >b000-bfff
0411 66C6 C000             data  >c000                 ; >c000-cfff
0412 66C8 D000             data  >d000                 ; >d000-dfff
0413 66CA E000             data  >e000                 ; >e000-efff
0414 66CC F000             data  >f000                 ; >f000-ffff
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
0009 66CE 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66D0 FFBF 
0010 66D2 0460  28         b     @putv01
     66D4 2348 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66D6 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66D8 0040 
0018 66DA 0460  28         b     @putv01
     66DC 2348 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66DE 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66E0 FFDF 
0026 66E2 0460  28         b     @putv01
     66E4 2348 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66E6 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66E8 0020 
0034 66EA 0460  28         b     @putv01
     66EC 2348 
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
0010 66EE 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66F0 FFFE 
0011 66F2 0460  28         b     @putv01
     66F4 2348 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66F6 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     66F8 0001 
0019 66FA 0460  28         b     @putv01
     66FC 2348 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 66FE 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6700 FFFD 
0027 6702 0460  28         b     @putv01
     6704 2348 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6706 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6708 0002 
0035 670A 0460  28         b     @putv01
     670C 2348 
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
0018 670E C83B  50 at      mov   *r11+,@wyx
     6710 832A 
0019 6712 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6714 B820  54 down    ab    @hb$01,@wyx
     6716 2012 
     6718 832A 
0028 671A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 671C 7820  54 up      sb    @hb$01,@wyx
     671E 2012 
     6720 832A 
0037 6722 045B  20         b     *r11
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
0049 6724 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6726 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6728 832A 
0051 672A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     672C 832A 
0052 672E 045B  20         b     *r11
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
0021 6730 C120  34 yx2px   mov   @wyx,tmp0
     6732 832A 
0022 6734 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6736 06C4  14         swpb  tmp0                  ; Y<->X
0024 6738 04C5  14         clr   tmp1                  ; Clear before copy
0025 673A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 673C 20A0  38         coc   @wbit1,config         ; f18a present ?
     673E 201E 
0030 6740 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6742 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6744 833A 
     6746 26F6 
0032 6748 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 674A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 674C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 674E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6750 0500 
0037 6752 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6754 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6756 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6758 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 675A D105  18         movb  tmp1,tmp0
0051 675C 06C4  14         swpb  tmp0                  ; X<->Y
0052 675E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6760 2020 
0053 6762 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6764 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6766 2012 
0059 6768 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     676A 2024 
0060 676C 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 676E 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6770 0050            data   80
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
0013 6772 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6774 06A0  32         bl    @putvr                ; Write once
     6776 2334 
0015 6778 391C             data  >391c                 ; VR1/57, value 00011100
0016 677A 06A0  32         bl    @putvr                ; Write twice
     677C 2334 
0017 677E 391C             data  >391c                 ; VR1/57, value 00011100
0018 6780 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6782 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6784 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6786 2334 
0028 6788 391C             data  >391c
0029 678A 0458  20         b     *tmp4                 ; Exit
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
0040 678C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 678E 06A0  32         bl    @cpym2v
     6790 244C 
0042 6792 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6794 2756 
     6796 0006 
0043 6798 06A0  32         bl    @putvr
     679A 2334 
0044 679C 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 679E 06A0  32         bl    @putvr
     67A0 2334 
0046 67A2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 67A4 0204  20         li    tmp0,>3f00
     67A6 3F00 
0052 67A8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67AA 22BC 
0053 67AC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67AE 8800 
0054 67B0 0984  56         srl   tmp0,8
0055 67B2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67B4 8800 
0056 67B6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 67B8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 67BA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67BC BFFF 
0060 67BE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 67C0 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67C2 4000 
0063               f18chk_exit:
0064 67C4 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     67C6 2290 
0065 67C8 3F00             data  >3f00,>00,6
     67CA 0000 
     67CC 0006 
0066 67CE 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 67D0 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 67D2 3F00             data  >3f00                 ; 3f02 / 3f00
0073 67D4 0340             data  >0340                 ; 3f04   0340  idle
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
0092 67D6 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 67D8 06A0  32         bl    @putvr
     67DA 2334 
0097 67DC 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 67DE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67E0 2334 
0100 67E2 391C             data  >391c                 ; Lock the F18a
0101 67E4 0458  20         b     *tmp4                 ; Exit
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
0120 67E6 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 67E8 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67EA 201E 
0122 67EC 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 67EE C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67F0 8802 
0127 67F2 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67F4 2334 
0128 67F6 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 67F8 04C4  14         clr   tmp0
0130 67FA D120  34         movb  @vdps,tmp0
     67FC 8802 
0131 67FE 0984  56         srl   tmp0,8
0132 6800 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6802 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6804 832A 
0018 6806 D17B  28         movb  *r11+,tmp1
0019 6808 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 680A D1BB  28         movb  *r11+,tmp2
0021 680C 0986  56         srl   tmp2,8                ; Repeat count
0022 680E C1CB  18         mov   r11,tmp3
0023 6810 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6812 23FC 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6814 020B  20         li    r11,hchar1
     6816 27A2 
0028 6818 0460  28         b     @xfilv                ; Draw
     681A 2296 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 681C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     681E 2022 
0033 6820 1302  14         jeq   hchar2                ; Yes, exit
0034 6822 C2C7  18         mov   tmp3,r11
0035 6824 10EE  14         jmp   hchar                 ; Next one
0036 6826 05C7  14 hchar2  inct  tmp3
0037 6828 0457  20         b     *tmp3                 ; Exit
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
0016 682A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     682C 2020 
0017 682E 020C  20         li    r12,>0024
     6830 0024 
0018 6832 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6834 284C 
0019 6836 04C6  14         clr   tmp2
0020 6838 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 683A 04CC  14         clr   r12
0025 683C 1F08  20         tb    >0008                 ; Shift-key ?
0026 683E 1302  14         jeq   realk1                ; No
0027 6840 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6842 287C 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6844 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6846 1302  14         jeq   realk2                ; No
0033 6848 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     684A 28AC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 684C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 684E 1302  14         jeq   realk3                ; No
0039 6850 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6852 28DC 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6854 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     6856 200C 
0044 6858 1E15  20         sbz   >0015                 ; Set P5
0045 685A 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 685C 1302  14         jeq   realk4                ; No
0047 685E E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6860 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 6862 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 6864 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6866 0006 
0053 6868 0606  14 realk5  dec   tmp2
0054 686A 020C  20         li    r12,>24               ; CRU address for P2-P4
     686C 0024 
0055 686E 06C6  14         swpb  tmp2
0056 6870 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 6872 06C6  14         swpb  tmp2
0058 6874 020C  20         li    r12,6                 ; CRU read address
     6876 0006 
0059 6878 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 687A 0547  14         inv   tmp3                  ;
0061 687C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     687E FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6880 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 6882 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 6884 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 6886 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6888 0285  22         ci    tmp1,8
     688A 0008 
0070 688C 1AFA  14         jl    realk6
0071 688E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 6890 1BEB  14         jh    realk5                ; No, next column
0073 6892 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 6894 C206  18 realk8  mov   tmp2,tmp4
0078 6896 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 6898 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 689A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 689C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 689E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 68A0 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 68A2 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     68A4 200C 
0089 68A6 1608  14         jne   realka                ; No, continue saving key
0090 68A8 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     68AA 2876 
0091 68AC 1A05  14         jl    realka
0092 68AE 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     68B0 2874 
0093 68B2 1B02  14         jh    realka                ; No, continue
0094 68B4 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     68B6 E000 
0095 68B8 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     68BA 833C 
0096 68BC E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     68BE 200A 
0097 68C0 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     68C2 8C00 
0098                                                   ; / using R15 as temp storage
0099 68C4 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 68C6 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     68C8 0000 
     68CA FF0D 
     68CC 203D 
0102 68CE ....             text  'xws29ol.'
0103 68D6 ....             text  'ced38ik,'
0104 68DE ....             text  'vrf47ujm'
0105 68E6 ....             text  'btg56yhn'
0106 68EE ....             text  'zqa10p;/'
0107 68F6 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     68F8 0000 
     68FA FF0D 
     68FC 202B 
0108 68FE ....             text  'XWS@(OL>'
0109 6906 ....             text  'CED#*IK<'
0110 690E ....             text  'VRF$&UJM'
0111 6916 ....             text  'BTG%^YHN'
0112 691E ....             text  'ZQA!)P:-'
0113 6926 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6928 0000 
     692A FF0D 
     692C 2005 
0114 692E 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6930 0804 
     6932 0F27 
     6934 C2B9 
0115 6936 600B             data  >600b,>0907,>063f,>c1B8
     6938 0907 
     693A 063F 
     693C C1B8 
0116 693E 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6940 7B02 
     6942 015F 
     6944 C0C3 
0117 6946 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6948 7D0E 
     694A 0CC6 
     694C BFC4 
0118 694E 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6950 7C03 
     6952 BC22 
     6954 BDBA 
0119 6956 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6958 0000 
     695A FF0D 
     695C 209D 
0120 695E 9897             data  >9897,>93b2,>9f8f,>8c9B
     6960 93B2 
     6962 9F8F 
     6964 8C9B 
0121 6966 8385             data  >8385,>84b3,>9e89,>8b80
     6968 84B3 
     696A 9E89 
     696C 8B80 
0122 696E 9692             data  >9692,>86b4,>b795,>8a8D
     6970 86B4 
     6972 B795 
     6974 8A8D 
0123 6976 8294             data  >8294,>87b5,>b698,>888E
     6978 87B5 
     697A B698 
     697C 888E 
0124 697E 9A91             data  >9a91,>81b1,>b090,>9cBB
     6980 81B1 
     6982 B090 
     6984 9CBB 
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
0023 6986 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6988 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     698A 8340 
0025 698C 04E0  34         clr   @waux1
     698E 833C 
0026 6990 04E0  34         clr   @waux2
     6992 833E 
0027 6994 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6996 833C 
0028 6998 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 699A 0205  20         li    tmp1,4                ; 4 nibbles
     699C 0004 
0033 699E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 69A0 0246  22         andi  tmp2,>000f            ; Only keep LSN
     69A2 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 69A4 0286  22         ci    tmp2,>000a
     69A6 000A 
0039 69A8 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 69AA C21B  26         mov   *r11,tmp4
0045 69AC 0988  56         srl   tmp4,8                ; Right justify
0046 69AE 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     69B0 FFF6 
0047 69B2 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 69B4 C21B  26         mov   *r11,tmp4
0054 69B6 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     69B8 00FF 
0055               
0056 69BA A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 69BC 06C6  14         swpb  tmp2
0058 69BE DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 69C0 0944  56         srl   tmp0,4                ; Next nibble
0060 69C2 0605  14         dec   tmp1
0061 69C4 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 69C6 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     69C8 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 69CA C160  34         mov   @waux3,tmp1           ; Get pointer
     69CC 8340 
0067 69CE 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 69D0 0585  14         inc   tmp1                  ; Next byte, not word!
0069 69D2 C120  34         mov   @waux2,tmp0
     69D4 833E 
0070 69D6 06C4  14         swpb  tmp0
0071 69D8 DD44  32         movb  tmp0,*tmp1+
0072 69DA 06C4  14         swpb  tmp0
0073 69DC DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 69DE C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     69E0 8340 
0078 69E2 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     69E4 2016 
0079 69E6 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 69E8 C120  34         mov   @waux1,tmp0
     69EA 833C 
0084 69EC 06C4  14         swpb  tmp0
0085 69EE DD44  32         movb  tmp0,*tmp1+
0086 69F0 06C4  14         swpb  tmp0
0087 69F2 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 69F4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     69F6 2020 
0092 69F8 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 69FA 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 69FC 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     69FE 7FFF 
0098 6A00 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A02 8340 
0099 6A04 0460  28         b     @xutst0               ; Display string
     6A06 2422 
0100 6A08 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A0A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A0C 832A 
0122 6A0E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A10 8000 
0123 6A12 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A14 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A16 0005 
0020 6A18 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A1A C155  26         mov   *tmp1,tmp1            ; /
0022 6A1C C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A1E 0228  22         ai    tmp4,4                ; Get end of buffer
     6A20 0004 
0024 6A22 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A24 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A26 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A28 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A2A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A2C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A2E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A30 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A32 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A34 0607  14         dec   tmp3                  ; Decrease counter
0036 6A36 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A38 0207  20         li    tmp3,4                ; Check first 4 digits
     6A3A 0004 
0041 6A3C 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A3E C11B  26         mov   *r11,tmp0
0043 6A40 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A42 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6A44 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6A46 05CB  14 mknum3  inct  r11
0047 6A48 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A4A 2020 
0048 6A4C 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6A4E 045B  20         b     *r11                  ; Exit
0050 6A50 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6A52 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6A54 13F8  14         jeq   mknum3                ; Yes, exit
0053 6A56 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6A58 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6A5A 7FFF 
0058 6A5C C10B  18         mov   r11,tmp0
0059 6A5E 0224  22         ai    tmp0,-4
     6A60 FFFC 
0060 6A62 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6A64 0206  20         li    tmp2,>0500            ; String length = 5
     6A66 0500 
0062 6A68 0460  28         b     @xutstr               ; Display string
     6A6A 2424 
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
0093 6A6C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 6A6E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 6A70 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 6A72 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 6A74 0207  20         li    tmp3,5                ; Set counter
     6A76 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 6A78 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 6A7A 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 6A7C 0584  14         inc   tmp0                  ; Next character
0105 6A7E 0607  14         dec   tmp3                  ; Last digit reached ?
0106 6A80 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 6A82 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 6A84 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 6A86 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 6A88 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 6A8A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 6A8C 0607  14         dec   tmp3                  ; Last character ?
0121 6A8E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 6A90 045B  20         b     *r11                  ; Return
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
0139 6A92 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6A94 832A 
0140 6A96 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A98 8000 
0141 6A9A 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6A9C 0649  14         dect  stack
0023 6A9E C64B  30         mov   r11,*stack            ; Save return address
0024 6AA0 0649  14         dect  stack
0025 6AA2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6AA4 0649  14         dect  stack
0027 6AA6 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6AA8 0649  14         dect  stack
0029 6AAA C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6AAC 0649  14         dect  stack
0031 6AAE C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6AB0 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6AB2 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6AB4 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6AB6 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6AB8 0649  14         dect  stack
0044 6ABA C64B  30         mov   r11,*stack            ; Save return address
0045 6ABC 0649  14         dect  stack
0046 6ABE C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6AC0 0649  14         dect  stack
0048 6AC2 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6AC4 0649  14         dect  stack
0050 6AC6 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6AC8 0649  14         dect  stack
0052 6ACA C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6ACC C1D4  26 !       mov   *tmp0,tmp3
0057 6ACE 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6AD0 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6AD2 00FF 
0059 6AD4 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6AD6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6AD8 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6ADA 0584  14         inc   tmp0                  ; Next byte
0067 6ADC 0607  14         dec   tmp3                  ; Shorten string length
0068 6ADE 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6AE0 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6AE2 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6AE4 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6AE6 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6AE8 C187  18         mov   tmp3,tmp2
0078 6AEA 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6AEC DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6AEE 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6AF0 24A6 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6AF2 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6AF4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AF6 FFCE 
0090 6AF8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AFA 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6AFC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6AFE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B00 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B04 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B06 045B  20         b     *r11                  ; Return to caller
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
0123 6B08 0649  14         dect  stack
0124 6B0A C64B  30         mov   r11,*stack            ; Save return address
0125 6B0C 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B0E 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B10 0649  14         dect  stack
0128 6B12 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B14 0649  14         dect  stack
0130 6B16 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B18 0649  14         dect  stack
0132 6B1A C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B1C C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B1E C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B20 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B22 0649  14         dect  stack
0144 6B24 C64B  30         mov   r11,*stack            ; Save return address
0145 6B26 0649  14         dect  stack
0146 6B28 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B2A 0649  14         dect  stack
0148 6B2C C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B2E 0649  14         dect  stack
0150 6B30 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B32 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B34 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B36 0586  14         inc   tmp2
0161 6B38 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B3A 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 6B3C 0286  22         ci    tmp2,255
     6B3E 00FF 
0167 6B40 1505  14         jgt   string.getlenc.panic
0168 6B42 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6B44 0606  14         dec   tmp2                  ; One time adjustment
0174 6B46 C806  38         mov   tmp2,@waux1           ; Store length
     6B48 833C 
0175 6B4A 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6B4C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B4E FFCE 
0181 6B50 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B52 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6B54 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6B56 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6B58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6B5A C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6B5C 045B  20         b     *r11                  ; Return to caller
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
0056 6B5E A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6B60 2AE8             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6B62 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6B64 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6B66 A428 
0064 6B68 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6B6A 201C 
0065 6B6C C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6B6E 8356 
0066 6B70 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6B72 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6B74 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6B76 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6B78 A434 
0073                       ;---------------------------; Inline VSBR start
0074 6B7A 06C0  14         swpb  r0                    ;
0075 6B7C D800  38         movb  r0,@vdpa              ; Send low byte
     6B7E 8C02 
0076 6B80 06C0  14         swpb  r0                    ;
0077 6B82 D800  38         movb  r0,@vdpa              ; Send high byte
     6B84 8C02 
0078 6B86 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6B88 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6B8A 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6B8C 0704  14         seto  r4                    ; Init counter
0086 6B8E 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B90 A420 
0087 6B92 0580  14 !       inc   r0                    ; Point to next char of name
0088 6B94 0584  14         inc   r4                    ; Increment char counter
0089 6B96 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6B98 0007 
0090 6B9A 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6B9C 80C4  18         c     r4,r3                 ; End of name?
0093 6B9E 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6BA0 06C0  14         swpb  r0                    ;
0098 6BA2 D800  38         movb  r0,@vdpa              ; Send low byte
     6BA4 8C02 
0099 6BA6 06C0  14         swpb  r0                    ;
0100 6BA8 D800  38         movb  r0,@vdpa              ; Send high byte
     6BAA 8C02 
0101 6BAC D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6BAE 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6BB0 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6BB2 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6BB4 2C50 
0109 6BB6 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6BB8 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6BBA 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6BBC 04E0  34         clr   @>83d0
     6BBE 83D0 
0118 6BC0 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6BC2 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6BC4 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6BC6 A432 
0121               
0122 6BC8 0584  14         inc   r4                    ; Adjust for dot
0123 6BCA A804  38         a     r4,@>8356             ; Point to position after name
     6BCC 8356 
0124 6BCE C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6BD0 8356 
     6BD2 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6BD4 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6BD6 83E0 
0130 6BD8 04C1  14         clr   r1                    ; Version found of dsr
0131 6BDA 020C  20         li    r12,>0f00             ; Init cru address
     6BDC 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6BDE C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6BE0 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6BE2 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6BE4 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6BE6 0100 
0145 6BE8 04E0  34         clr   @>83d0                ; Clear in case we are done
     6BEA 83D0 
0146 6BEC 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6BEE 2000 
0147 6BF0 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6BF2 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6BF4 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6BF6 1D00  20         sbo   0                     ; Turn on ROM
0154 6BF8 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6BFA 4000 
0155 6BFC 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6BFE 2C4C 
0156 6C00 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C02 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C04 A40A 
0166 6C06 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C08 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C0A 83D2 
0172                                                   ; subprogram
0173               
0174 6C0C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C0E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C10 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C12 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C14 83D2 
0183                                                   ; subprogram
0184               
0185 6C16 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C18 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C1A 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C1C D160  34         movb  @>8355,r5             ; Get length as counter
     6C1E 8355 
0195 6C20 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C22 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C24 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C26 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C28 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C2A A420 
0206 6C2C 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C2E 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C30 0605  14         dec   r5                    ; Update loop counter
0211 6C32 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6C34 0581  14         inc   r1                    ; Next version found
0217 6C36 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6C38 A42A 
0218 6C3A C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6C3C A42C 
0219 6C3E C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6C40 A430 
0220               
0221 6C42 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6C44 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6C46 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6C48 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6C4A 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6C4C 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6C4E A400 
0233 6C50 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6C52 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6C54 A428 
0239                                                   ; (8 or >a)
0240 6C56 0281  22         ci    r1,8                  ; was it 8?
     6C58 0008 
0241 6C5A 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6C5C D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6C5E 8350 
0243                                                   ; Get error byte from @>8350
0244 6C60 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6C62 06C0  14         swpb  r0                    ;
0252 6C64 D800  38         movb  r0,@vdpa              ; send low byte
     6C66 8C02 
0253 6C68 06C0  14         swpb  r0                    ;
0254 6C6A D800  38         movb  r0,@vdpa              ; send high byte
     6C6C 8C02 
0255 6C6E D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6C70 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6C72 09D1  56         srl   r1,13                 ; just keep error bits
0263 6C74 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6C76 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6C78 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6C7A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6C7C A400 
0275               dsrlnk.error.devicename_invalid:
0276 6C7E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6C80 06C1  14         swpb  r1                    ; put error in hi byte
0279 6C82 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6C84 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6C86 201C 
0281                                                   ; / to indicate error
0282 6C88 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6C8A A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6C8C 2C14             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6C8E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C90 83E0 
0316               
0317 6C92 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6C94 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6C96 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6C98 A42A 
0322 6C9A C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6C9C C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6C9E C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6CA0 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6CA2 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6CA4 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6CA6 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6CA8 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CAA 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6CAC 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6CAE 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6CB0 4000 
     6CB2 2C4C 
0337 6CB4 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6CB6 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6CB8 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6CBA 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6CBC 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6CBE A400 
0355 6CC0 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6CC2 A434 
0356               
0357 6CC4 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6CC6 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6CC8 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6CCA ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6CCC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6CCE C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6CD0 0649  14         dect  stack
0052 6CD2 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6CD4 0204  20         li    tmp0,dsrlnk.savcru
     6CD6 A42A 
0057 6CD8 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6CDA 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6CDC 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6CDE 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6CE0 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6CE2 37D7 
0065 6CE4 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6CE6 8370 
0066                                                   ; / location
0067 6CE8 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6CEA A44C 
0068 6CEC 04C5  14         clr   tmp1                  ; io.op.open
0069 6CEE 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6CF0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6CF2 0649  14         dect  stack
0097 6CF4 C64B  30         mov   r11,*stack            ; Save return address
0098 6CF6 0205  20         li    tmp1,io.op.close      ; io.op.close
     6CF8 0001 
0099 6CFA 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6CFC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6CFE 0649  14         dect  stack
0125 6D00 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D02 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D04 0002 
0128 6D06 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D08 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D0A 0649  14         dect  stack
0155 6D0C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D0E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D10 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D12 0005 
0159               
0160 6D14 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D16 A43E 
0161               
0162 6D18 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D1A 22CE 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D1C 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D1E 0003 
0167 6D20 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D22 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D24 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D26 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D28 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D2A 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D2C 1000  14         nop
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
0227 6D2E C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D30 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6D32 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6D34 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6D36 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6D38 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6D3A 22CE 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6D3C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6D3E 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6D40 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6D42 A44C 
0246               
0247 6D44 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6D46 22CE 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6D48 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6D4A 0009 
0254 6D4C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6D4E 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6D50 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6D52 8322 
     6D54 833C 
0259               
0260 6D56 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6D58 A42A 
0261 6D5A 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6D5C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6D5E 2AE4 
0268 6D60 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6D62 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6D64 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6D66 2C10 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6D68 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6D6A C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6D6C 833C 
     6D6E 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6D70 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6D72 A436 
0292 6D74 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6D76 0005 
0293 6D78 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6D7A 22E6 
0294 6D7C C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6D7E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6D80 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6D82 045B  20         b     *r11                  ; Return to caller
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
0020 6D84 0300  24 tmgr    limi  0                     ; No interrupt processing
     6D86 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6D88 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6D8A 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6D8C 2360  38         coc   @wbit2,r13            ; C flag on ?
     6D8E 201C 
0029 6D90 1602  14         jne   tmgr1a                ; No, so move on
0030 6D92 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6D94 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6D96 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6D98 2020 
0035 6D9A 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6D9C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6D9E 2010 
0048 6DA0 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6DA2 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6DA4 200E 
0050 6DA6 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6DA8 0460  28         b     @kthread              ; Run kernel thread
     6DAA 2DA8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6DAC 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6DAE 2014 
0056 6DB0 13EB  14         jeq   tmgr1
0057 6DB2 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6DB4 2012 
0058 6DB6 16E8  14         jne   tmgr1
0059 6DB8 C120  34         mov   @wtiusr,tmp0
     6DBA 832E 
0060 6DBC 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6DBE 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6DC0 2DA6 
0065 6DC2 C10A  18         mov   r10,tmp0
0066 6DC4 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6DC6 00FF 
0067 6DC8 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6DCA 201C 
0068 6DCC 1303  14         jeq   tmgr5
0069 6DCE 0284  22         ci    tmp0,60               ; 1 second reached ?
     6DD0 003C 
0070 6DD2 1002  14         jmp   tmgr6
0071 6DD4 0284  22 tmgr5   ci    tmp0,50
     6DD6 0032 
0072 6DD8 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6DDA 1001  14         jmp   tmgr8
0074 6DDC 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6DDE C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6DE0 832C 
0079 6DE2 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6DE4 FF00 
0080 6DE6 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6DE8 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6DEA 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6DEC 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6DEE C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6DF0 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6DF2 830C 
     6DF4 830D 
0089 6DF6 1608  14         jne   tmgr10                ; No, get next slot
0090 6DF8 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6DFA FF00 
0091 6DFC C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6DFE C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E00 8330 
0096 6E02 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E04 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E06 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E08 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E0A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E0C 8315 
     6E0E 8314 
0103 6E10 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E12 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E14 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E16 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E18 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E1A 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E1C FF00 
0109 6E1E 10B4  14         jmp   tmgr1
0110 6E20 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E22 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E24 2010 
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
0041 6E26 06A0  32         bl    @realkb               ; Scan full keyboard
     6E28 27B0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E2A 0460  28         b     @tmgr3                ; Exit
     6E2C 2D32 
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
0017 6E2E C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E30 832E 
0018 6E32 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E34 2012 
0019 6E36 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D0E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E38 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E3A 832E 
0029 6E3C 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E3E FEFF 
0030 6E40 045B  20         b     *r11                  ; Return
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
0017 6E42 C13B  30 mkslot  mov   *r11+,tmp0
0018 6E44 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E46 C184  18         mov   tmp0,tmp2
0023 6E48 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E4A A1A0  34         a     @wtitab,tmp2          ; Add table base
     6E4C 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6E4E CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6E50 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6E52 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6E54 881B  46         c     *r11,@w$ffff          ; End of list ?
     6E56 2022 
0035 6E58 1301  14         jeq   mkslo1                ; Yes, exit
0036 6E5A 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6E5C 05CB  14 mkslo1  inct  r11
0041 6E5E 045B  20         b     *r11                  ; Exit
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
0052 6E60 C13B  30 clslot  mov   *r11+,tmp0
0053 6E62 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6E64 A120  34         a     @wtitab,tmp0          ; Add table base
     6E66 832C 
0055 6E68 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6E6A 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6E6C 045B  20         b     *r11                  ; Exit
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
0068 6E6E C13B  30 rsslot  mov   *r11+,tmp0
0069 6E70 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6E72 A120  34         a     @wtitab,tmp0          ; Add table base
     6E74 832C 
0071 6E76 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6E78 C154  26         mov   *tmp0,tmp1
0073 6E7A 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6E7C FF00 
0074 6E7E C505  30         mov   tmp1,*tmp0
0075 6E80 045B  20         b     *r11                  ; Exit
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
0260 6E82 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6E84 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 6E86 0300  24 runli1  limi  0                     ; Turn off interrupts
     6E88 0000 
0266 6E8A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6E8C 8300 
0267 6E8E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6E90 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 6E92 0202  20 runli2  li    r2,>8308
     6E94 8308 
0272 6E96 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 6E98 0282  22         ci    r2,>8400
     6E9A 8400 
0274 6E9C 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 6E9E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6EA0 FFFF 
0279 6EA2 1602  14         jne   runli4                ; No, continue
0280 6EA4 0420  54         blwp  @0                    ; Yes, bye bye
     6EA6 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 6EA8 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6EAA 833C 
0285 6EAC 04C1  14         clr   r1                    ; Reset counter
0286 6EAE 0202  20         li    r2,10                 ; We test 10 times
     6EB0 000A 
0287 6EB2 C0E0  34 runli5  mov   @vdps,r3
     6EB4 8802 
0288 6EB6 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6EB8 2020 
0289 6EBA 1302  14         jeq   runli6
0290 6EBC 0581  14         inc   r1                    ; Increase counter
0291 6EBE 10F9  14         jmp   runli5
0292 6EC0 0602  14 runli6  dec   r2                    ; Next test
0293 6EC2 16F7  14         jne   runli5
0294 6EC4 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6EC6 1250 
0295 6EC8 1202  14         jle   runli7                ; No, so it must be NTSC
0296 6ECA 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6ECC 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 6ECE 06A0  32 runli7  bl    @loadmc
     6ED0 221C 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 6ED2 04C1  14 runli9  clr   r1
0305 6ED4 04C2  14         clr   r2
0306 6ED6 04C3  14         clr   r3
0307 6ED8 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6EDA 3000 
0308 6EDC 020F  20         li    r15,vdpw              ; Set VDP write address
     6EDE 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 6EE0 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6EE2 4A4A 
0317 6EE4 1605  14         jne   runlia
0318 6EE6 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6EE8 2290 
0319 6EEA 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6EEC 0000 
     6EEE 3000 
0324 6EF0 06A0  32 runlia  bl    @filv
     6EF2 2290 
0325 6EF4 0FC0             data  pctadr,spfclr,16      ; Load color table
     6EF6 00F4 
     6EF8 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 6EFA 06A0  32         bl    @f18unl               ; Unlock the F18A
     6EFC 26F8 
0333 6EFE 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F00 2712 
0334 6F02 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F04 2708 
0335               
0336 6F06 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F08 2334 
0337 6F0A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 6F0C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F0E 22FA 
0351 6F10 336E             data  spvmod                ; Equate selected video mode table
0352 6F12 0204  20         li    tmp0,spfont           ; Get font option
     6F14 000C 
0353 6F16 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 6F18 1304  14         jeq   runlid                ; Yes, skip it
0355 6F1A 06A0  32         bl    @ldfnt
     6F1C 2362 
0356 6F1E 1100             data  fntadr,spfont         ; Load specified font
     6F20 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 6F22 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F24 4A4A 
0361 6F26 1602  14         jne   runlie                ; No, continue
0362 6F28 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F2A 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 6F2C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F2E 0040 
0367 6F30 0460  28         b     @main                 ; Give control to main program
     6F32 3000 
**** **** ****     > stevie_b0.asm.79747
0098                                                   ; Spectra 2
0099                       ;------------------------------------------------------
0100                       ; End of File marker
0101                       ;------------------------------------------------------
0102 6F34 DEAD             data  >dead,>beef,>dead,>beef
     6F36 BEEF 
     6F38 DEAD 
     6F3A BEEF 
0104               
0108 6F3C 2EC2                   data $                ; Bank 0 ROM size OK.
0110               
0111 6F3E ....             bss  300                    ; Fill remaining space with >00
0112               
0113               ***************************************************************
0114               * Code data: Relocated Stevie modules >3000 - >3fff (4K max)
0115               ********|*****|*********************|**************************
0116               reloc.stevie:
0117                       xorg  >3000                 ; Relocate Stevie modules to >3000
0118                       ;------------------------------------------------------
0119                       ; Activate bank 1 and branch to >6036
0120                       ;------------------------------------------------------
0121               main:
0122 706A 04E0  34         clr   @bank1                ; Activate bank 1 "James"
     706C 6002 
0123 706E 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7070 6036 
0124                       ;------------------------------------------------------
0125                       ; Resident Stevie modules: >3000 - >3fff
0126                       ;------------------------------------------------------
0127                       copy  "ram.resident.3000.asm"
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
0022 7072 C13B  30         mov   *r11+,tmp0            ; P0
0023 7074 C17B  30         mov   *r11+,tmp1            ; P1
0024 7076 C1BB  30         mov   *r11+,tmp2            ; P2
0025                       ;------------------------------------------------------
0026                       ; Push registers to value stack (but not r11!)
0027                       ;------------------------------------------------------
0028               xrom.farjump:
0029 7078 0649  14         dect  stack
0030 707A C644  30         mov   tmp0,*stack           ; Push tmp0
0031 707C 0649  14         dect  stack
0032 707E C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7080 0649  14         dect  stack
0034 7082 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 7084 0649  14         dect  stack
0036 7086 C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Push to farjump return stack
0039                       ;------------------------------------------------------
0040 7088 0284  22         ci    tmp0,>6002            ; Invalid bank write address?
     708A 6002 
0041 708C 110C  14         jlt   rom.farjump.bankswitch.failed1
0042                                                   ; Crash if null value in bank write address
0043               
0044 708E C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     7090 A024 
0045 7092 0647  14         dect  tmp3
0046 7094 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0047 7096 0647  14         dect  tmp3
0048 7098 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0049 709A C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     709C A024 
0050                       ;------------------------------------------------------
0051                       ; Bankswitch to target bank
0052                       ;------------------------------------------------------
0053               rom.farjump.bankswitch:
0054 709E 04D4  26         clr   *tmp0                 ; Switch to target ROM bank
0055 70A0 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0056 70A2 1301  14         jeq   rom.farjump.bankswitch.failed1
0057                                                   ; Crash if null-pointer in vector
0058 70A4 1004  14         jmp   rom.farjump.bankswitch.call
0059                                                   ; Call function in target bank
0060                       ;------------------------------------------------------
0061                       ; Assert 1 failed before bank-switch
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.failed1:
0064 70A6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70A8 FFCE 
0065 70AA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70AC 2026 
0066                       ;------------------------------------------------------
0067                       ; Call function in target bank
0068                       ;------------------------------------------------------
0069               rom.farjump.bankswitch.call:
0070 70AE 0694  24         bl    *tmp0                 ; Call function
0071                       ;------------------------------------------------------
0072                       ; Bankswitch back to source bank
0073                       ;------------------------------------------------------
0074               rom.farjump.return:
0075 70B0 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     70B2 A024 
0076 70B4 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0077 70B6 130D  14         jeq   rom.farjump.bankswitch.failed2
0078                                                   ; Crash if null-pointer in address
0079               
0080 70B8 04F4  30         clr   *tmp0+                ; Remove bank write address from
0081                                                   ; farjump stack
0082               
0083 70BA C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0084               
0085 70BC 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0086                                                   ; farjump stack
0087               
0088 70BE 028B  22         ci    r11,>6000
     70C0 6000 
0089 70C2 1107  14         jlt   rom.farjump.bankswitch.failed2
0090 70C4 028B  22         ci    r11,>7fff
     70C6 7FFF 
0091 70C8 1504  14         jgt   rom.farjump.bankswitch.failed2
0092               
0093 70CA C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     70CC A024 
0094 70CE 04D5  26         clr   *tmp1                 ; Switch to bank of caller
0095 70D0 1004  14         jmp   rom.farjump.exit
0096                       ;------------------------------------------------------
0097                       ; Assert 2 failed after bank-switch
0098                       ;------------------------------------------------------
0099               rom.farjump.bankswitch.failed2:
0100 70D2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D4 FFCE 
0101 70D6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70D8 2026 
0102                       ;-------------------------------------------------------
0103                       ; Exit
0104                       ;-------------------------------------------------------
0105               rom.farjump.exit:
0106 70DA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0107 70DC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0108 70DE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0109 70E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0110 70E2 045B  20         b     *r11                  ; Return to caller
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
0020 70E4 0649  14         dect  stack
0021 70E6 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;------------------------------------------------------
0023                       ; Initialize
0024                       ;------------------------------------------------------
0025 70E8 0204  20         li    tmp0,fb.top
     70EA A600 
0026 70EC C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     70EE A100 
0027 70F0 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     70F2 A104 
0028 70F4 04E0  34         clr   @fb.row               ; Current row=0
     70F6 A106 
0029 70F8 04E0  34         clr   @fb.column            ; Current column=0
     70FA A10C 
0030               
0031 70FC 0204  20         li    tmp0,colrow
     70FE 0050 
0032 7100 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7102 A10E 
0033               
0034 7104 0204  20         li    tmp0,28
     7106 001C 
0035 7108 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 28
     710A A11A 
0036 710C C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     710E A11C 
0037               
0038 7110 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     7112 A020 
0039 7114 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     7116 A110 
0040 7118 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     711A A116 
0041 711C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     711E A118 
0042                       ;------------------------------------------------------
0043                       ; Clear frame buffer
0044                       ;------------------------------------------------------
0045 7120 06A0  32         bl    @film
     7122 2238 
0046 7124 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     7126 0000 
     7128 0960 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               fb.init.exit:
0051 712A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 712C 045B  20         b     *r11                  ; Return to caller
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
0046 712E 0649  14         dect  stack
0047 7130 C64B  30         mov   r11,*stack            ; Save return address
0048 7132 0649  14         dect  stack
0049 7134 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 7136 0204  20         li    tmp0,idx.top
     7138 B000 
0054 713A C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     713C A202 
0055               
0056 713E C120  34         mov   @tv.sams.b000,tmp0
     7140 A006 
0057 7142 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     7144 A500 
0058 7146 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     7148 A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 714A 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     714C 0004 
0063 714E C804  38         mov   tmp0,@idx.sams.hipage ; /
     7150 A504 
0064               
0065 7152 06A0  32         bl    @_idx.sams.mapcolumn.on
     7154 3106 
0066                                                   ; Index in continuous memory region
0067               
0068 7156 06A0  32         bl    @film
     7158 2238 
0069 715A B000                   data idx.top,>00,idx.size * 5
     715C 0000 
     715E 5000 
0070                                                   ; Clear index
0071               
0072 7160 06A0  32         bl    @_idx.sams.mapcolumn.off
     7162 313A 
0073                                                   ; Restore memory window layout
0074               
0075 7164 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     7166 A502 
     7168 A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 716A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 716C C2F9  30         mov   *stack+,r11           ; Pop r11
0083 716E 045B  20         b     *r11                  ; Return to caller
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
0096 7170 0649  14         dect  stack
0097 7172 C64B  30         mov   r11,*stack            ; Push return address
0098 7174 0649  14         dect  stack
0099 7176 C644  30         mov   tmp0,*stack           ; Push tmp0
0100 7178 0649  14         dect  stack
0101 717A C645  30         mov   tmp1,*stack           ; Push tmp1
0102 717C 0649  14         dect  stack
0103 717E C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 7180 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     7182 A502 
0108 7184 0205  20         li    tmp1,idx.top
     7186 B000 
0109 7188 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     718A 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 718C 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     718E 253C 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 7190 0584  14         inc   tmp0                  ; Next SAMS index page
0118 7192 0225  22         ai    tmp1,>1000            ; Next memory region
     7194 1000 
0119 7196 0606  14         dec   tmp2                  ; Update loop counter
0120 7198 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 719A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 719C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 719E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 71A0 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 71A2 045B  20         b     *r11                  ; Return to caller
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
0145 71A4 0649  14         dect  stack
0146 71A6 C64B  30         mov   r11,*stack            ; Push return address
0147 71A8 0649  14         dect  stack
0148 71AA C644  30         mov   tmp0,*stack           ; Push tmp0
0149 71AC 0649  14         dect  stack
0150 71AE C645  30         mov   tmp1,*stack           ; Push tmp1
0151 71B0 0649  14         dect  stack
0152 71B2 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 71B4 0649  14         dect  stack
0154 71B6 C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 71B8 0205  20         li    tmp1,idx.top
     71BA B000 
0159 71BC 0206  20         li    tmp2,5                ; Always 5 pages
     71BE 0005 
0160 71C0 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     71C2 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 71C4 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 71C6 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     71C8 253C 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 71CA 0225  22         ai    tmp1,>1000            ; Next memory region
     71CC 1000 
0171 71CE 0606  14         dec   tmp2                  ; Update loop counter
0172 71D0 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 71D2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 71D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 71D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 71D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 71DA C2F9  30         mov   *stack+,r11           ; Pop return address
0182 71DC 045B  20         b     *r11                  ; Return to caller
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
0206 71DE 0649  14         dect  stack
0207 71E0 C64B  30         mov   r11,*stack            ; Save return address
0208 71E2 0649  14         dect  stack
0209 71E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 71E6 0649  14         dect  stack
0211 71E8 C645  30         mov   tmp1,*stack           ; Push tmp1
0212 71EA 0649  14         dect  stack
0213 71EC C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 71EE C184  18         mov   tmp0,tmp2             ; Line number
0218 71F0 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 71F2 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     71F4 0800 
0220               
0221 71F6 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 71F8 0A16  56         sla   tmp2,1                ; line number * 2
0226 71FA C806  38         mov   tmp2,@outparm1        ; Offset index entry
     71FC 2F30 
0227               
0228 71FE A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     7200 A502 
0229 7202 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     7204 A500 
0230               
0231 7206 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 7208 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     720A A500 
0237 720C C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     720E A006 
0238               
0239 7210 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 7212 0205  20         li    tmp1,>b000            ; Memory window for index page
     7214 B000 
0241               
0242 7216 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     7218 253C 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 721A 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     721C A504 
0249 721E 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 7220 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     7222 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 7224 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 7226 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 7228 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 722A C2F9  30         mov   *stack+,r11           ; Pop r11
0260 722C 045B  20         b     *r11                  ; Return to caller
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
0022 722E 0649  14         dect  stack
0023 7230 C64B  30         mov   r11,*stack            ; Save return address
0024 7232 0649  14         dect  stack
0025 7234 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7236 0204  20         li    tmp0,edb.top          ; \
     7238 C000 
0030 723A C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     723C A200 
0031 723E C804  38         mov   tmp0,@edb.next_free.ptr
     7240 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 7242 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7244 A20A 
0035               
0036 7246 0204  20         li    tmp0,1
     7248 0001 
0037 724A C804  38         mov   tmp0,@edb.lines       ; Lines=1
     724C A204 
0038               
0039 724E 0720  34         seto  @edb.block.m1         ; Reset block start line
     7250 A20C 
0040 7252 0720  34         seto  @edb.block.m2         ; Reset block end line
     7254 A20E 
0041               
0042 7256 0204  20         li    tmp0,txt.newfile      ; "New file"
     7258 3582 
0043 725A C804  38         mov   tmp0,@edb.filename.ptr
     725C A212 
0044               
0045 725E 0204  20         li    tmp0,txt.filetype.none
     7260 35D6 
0046 7262 C804  38         mov   tmp0,@edb.filetype.ptr
     7264 A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 7266 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 7268 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 726A 045B  20         b     *r11                  ; Return to caller
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
0022 726C 0649  14         dect  stack
0023 726E C64B  30         mov   r11,*stack            ; Save return address
0024 7270 0649  14         dect  stack
0025 7272 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7274 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     7276 D000 
0030 7278 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     727A A300 
0031               
0032 727C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     727E A302 
0033 7280 0204  20         li    tmp0,4
     7282 0004 
0034 7284 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     7286 A306 
0035 7288 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     728A A308 
0036               
0037 728C 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     728E A316 
0038 7290 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     7292 A318 
0039 7294 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     7296 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 7298 06A0  32         bl    @film
     729A 2238 
0044 729C D000             data  cmdb.top,>00,cmdb.size
     729E 0000 
     72A0 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 72A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 72A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 72A6 045B  20         b     *r11                  ; Return to caller
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
0022 72A8 0649  14         dect  stack
0023 72AA C64B  30         mov   r11,*stack            ; Save return address
0024 72AC 0649  14         dect  stack
0025 72AE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72B0 04E0  34         clr   @tv.error.visible     ; Set to hidden
     72B2 A026 
0030               
0031 72B4 06A0  32         bl    @film
     72B6 2238 
0032 72B8 A028                   data tv.error.msg,0,160
     72BA 0000 
     72BC 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 72BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 72C0 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 72C2 045B  20         b     *r11                  ; Return to caller
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
0022 72C4 0649  14         dect  stack
0023 72C6 C64B  30         mov   r11,*stack            ; Save return address
0024 72C8 0649  14         dect  stack
0025 72CA C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 72CC 0204  20         li    tmp0,1                ; \ Set default color scheme
     72CE 0001 
0030 72D0 C804  38         mov   tmp0,@tv.colorscheme  ; /
     72D2 A012 
0031               
0032 72D4 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     72D6 A022 
0033 72D8 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     72DA 200C 
0034               
0035 72DC 0204  20         li    tmp0,fj.bottom
     72DE F000 
0036 72E0 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     72E2 A024 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 72E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 72E6 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 72E8 045B  20         b     *r11                  ; Return to caller
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
0065 72EA 0649  14         dect  stack
0066 72EC C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 72EE 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     72F0 3202 
0071 72F2 06A0  32         bl    @edb.init             ; Initialize editor buffer
     72F4 31C4 
0072 72F6 06A0  32         bl    @idx.init             ; Initialize index
     72F8 30C4 
0073 72FA 06A0  32         bl    @fb.init              ; Initialize framebuffer
     72FC 307A 
0074 72FE 06A0  32         bl    @errline.init         ; Initialize error line
     7300 323E 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 7302 06A0  32         bl    @hchar
     7304 2788 
0079 7306 0034                   byte 0,52,32,18           ; Remove markers
     7308 2012 
0080 730A 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     730C 2032 
0081 730E FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 7310 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 7312 045B  20         b     *r11                  ; Return to caller
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
0020 7314 0649  14         dect  stack
0021 7316 C64B  30         mov   r11,*stack            ; Save return address
0022 7318 0649  14         dect  stack
0023 731A C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 731C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     731E 299A 
0028 7320 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 7322 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 7324 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 7326 0204  20         li    tmp0,unpacked.string
     7328 2F44 
0034 732A 04F4  30         clr   *tmp0+                ; Clear string 01
0035 732C 04F4  30         clr   *tmp0+                ; Clear string 23
0036 732E 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 7330 06A0  32         bl    @trimnum              ; Trim unsigned number string
     7332 29F2 
0039 7334 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 7336 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 7338 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 733A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 733C C2F9  30         mov   *stack+,r11           ; Pop r11
0048 733E 045B  20         b     *r11                  ; Return to caller
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
0073 7340 0649  14         dect  stack
0074 7342 C64B  30         mov   r11,*stack            ; Push return address
0075 7344 0649  14         dect  stack
0076 7346 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 7348 0649  14         dect  stack
0078 734A C645  30         mov   tmp1,*stack           ; Push tmp1
0079 734C 0649  14         dect  stack
0080 734E C646  30         mov   tmp2,*stack           ; Push tmp2
0081 7350 0649  14         dect  stack
0082 7352 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 7354 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     7356 2F20 
0087 7358 D194  26         movb  *tmp0,tmp2            ; /
0088 735A 0986  56         srl   tmp2,8                ; Right align
0089 735C C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 735E 8806  38         c     tmp2,@parm2           ; String length > requested length?
     7360 2F22 
0092 7362 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 7364 C120  34         mov   @parm1,tmp0           ; Get source address
     7366 2F20 
0097 7368 C160  34         mov   @parm4,tmp1           ; Get destination address
     736A 2F26 
0098 736C 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 736E 0649  14         dect  stack
0101 7370 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 7372 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     7374 24A6 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 7376 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 7378 C120  34         mov   @parm2,tmp0           ; Get requested length
     737A 2F22 
0113 737C 0A84  56         sla   tmp0,8                ; Left align
0114 737E C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     7380 2F26 
0115 7382 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 7384 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 7386 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 7388 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     738A 2F22 
0122 738C 6187  18         s     tmp3,tmp2             ; |
0123 738E 0586  14         inc   tmp2                  ; /
0124               
0125 7390 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     7392 2F24 
0126 7394 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 7396 DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 7398 0606  14         dec   tmp2                  ; Update loop counter
0133 739A 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 739C C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     739E 2F26 
     73A0 2F30 
0136 73A2 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 73A4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     73A6 FFCE 
0142 73A8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     73AA 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 73AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 73AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 73B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 73B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 73B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 73B6 045B  20         b     *r11                  ; Return to caller
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
0017 73B8 0649  14         dect  stack
0018 73BA C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 73BC 06A0  32         bl    @sams.layout
     73BE 25A8 
0023 73C0 3414                   data mem.sams.layout.data
0024               
0025 73C2 06A0  32         bl    @sams.layout.copy
     73C4 260C 
0026 73C6 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 73C8 C820  54         mov   @tv.sams.c000,@edb.sams.page
     73CA A008 
     73CC A216 
0029 73CE C820  54         mov   @edb.sams.page,@edb.sams.hipage
     73D0 A216 
     73D2 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 73D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 73D6 045B  20         b     *r11                  ; Return to caller
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
0033 73D8 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     73DA 003F 
     73DC 0243 
     73DE 05F4 
     73E0 0050 
0034               
0035               romsat:
0036 73E2 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     73E4 0001 
0037               
0038               cursors:
0039 73E6 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     73E8 0000 
     73EA 0000 
     73EC 001C 
0040 73EE 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     73F0 1010 
     73F2 1010 
     73F4 1000 
0041 73F6 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     73F8 1C1C 
     73FA 1C1C 
     73FC 1C00 
0042               
0043               patterns:
0044 73FE 0000             data  >0000,>0000,>ff00,>0000 ; 01. Single line
     7400 0000 
     7402 FF00 
     7404 0000 
0045 7406 8080             data  >8080,>8080,>ff80,>8080 ; 02. Connector |-
     7408 8080 
     740A FF80 
     740C 8080 
0046 740E 0404             data  >0404,>0404,>ff04,>0404 ; 03. Connector -|
     7410 0404 
     7412 FF04 
     7414 0404 
0047               
0048               patterns.box:
0049 7416 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     7418 0000 
     741A FF80 
     741C BFA0 
0050 741E 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     7420 0000 
     7422 FC04 
     7424 F414 
0051 7426 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7428 A0A0 
     742A A0A0 
     742C A0A0 
0052 742E 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     7430 1414 
     7432 1414 
     7434 1414 
0053 7436 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7438 A0A0 
     743A BF80 
     743C FF00 
0054 743E 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     7440 1414 
     7442 F404 
     7444 FC00 
0055 7446 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7448 C0C0 
     744A C0C0 
     744C 0080 
0056 744E 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     7450 0F0F 
     7452 0F0F 
     7454 0000 
0057               
0058               
0059               patterns.cr:
0060 7456 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     7458 6C48 
     745A 4800 
     745C 7C00 
0061 745E 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     7460 64FC 
     7462 6020 
     7464 0000 
0062               
0063               
0064               alphalock:
0065 7466 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     7468 00E0 
     746A E0E0 
     746C E0E0 
0066 746E 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     7470 E0E0 
     7472 E0E0 
     7474 0000 
0067               
0068               
0069               vertline:
0070 7476 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     7478 1010 
     747A 1010 
     747C 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 747E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7480 0002 
0078 7482 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7484 0003 
0079 7486 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7488 000A 
0080               
0081 748A B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     748C 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 748E C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7490 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 7492 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7494 000D 
0090 7496 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7498 000E 
0091 749A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     749C 000F 
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
0142      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0143               
0144               tv.colorscheme.table:
0145               ;                              ; #
0146               ;       ABCD  EFGH  IJKL  MNOP ; -
0147 749E F417      data  >f417,>f171,>1b1f,>7100 ; 1  White on blue with cyan touch
     74A0 F171 
     74A2 1B1F 
     74A4 7100 
0148 74A6 A11A      data  >a11a,>f0ff,>1f1a,>f100 ; 2  Dark yellow on black
     74A8 F0FF 
     74AA 1F1A 
     74AC F100 
0149 74AE 2112      data  >2112,>f0ff,>1f12,>f100 ; 3  Dark green on black
     74B0 F0FF 
     74B2 1F12 
     74B4 F100 
0150 74B6 F41F      data  >f41f,>1e11,>1a17,>1e00 ; 4  White on blue
     74B8 1E11 
     74BA 1A17 
     74BC 1E00 
0151 74BE E11E      data  >e11e,>e1ff,>1f1e,>e100 ; 5  Grey on black
     74C0 E1FF 
     74C2 1F1E 
     74C4 E100 
0152 74C6 1771      data  >1771,>1016,>1b71,>1700 ; 6  Black on cyan
     74C8 1016 
     74CA 1B71 
     74CC 1700 
0153 74CE 1FF1      data  >1ff1,>1011,>f1f1,>1f00 ; 7  Black on white
     74D0 1011 
     74D2 F1F1 
     74D4 1F00 
0154 74D6 1AF1      data  >1af1,>a1ff,>1f1f,>f100 ; 8  Black on dark yellow
     74D8 A1FF 
     74DA 1F1F 
     74DC F100 
0155 74DE 21F0      data  >21f0,>12ff,>1b12,>1200 ; 9  Dark green on black
     74E0 12FF 
     74E2 1B12 
     74E4 1200 
0156 74E6 F5F1      data  >f5f1,>e1ff,>1b1f,>f100 ; 10 White on light blue
     74E8 E1FF 
     74EA 1B1F 
     74EC F100 
0157               
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
0012 74EE 3253             byte  50
0013 74EF ....             text  'Stevie v1.0 (beta 2)                              '
0014                       even
0015               
0016                                  even
0017               txt.about.build
0018 7522 3042             byte  48
0019 7523 ....             text  'Build: 210130-79747 / 2018-2021 Filip Van Vooren'
0020                       even
0021               
0022               ;--------------------------------------------------------------
0023               ; Strings for status line pane
0024               ;--------------------------------------------------------------
0025               txt.delim
0026 7554 012C             byte  1
0027 7555 ....             text  ','
0028                       even
0029               
0030               txt.bottom
0031 7556 0520             byte  5
0032 7557 ....             text  '  BOT'
0033                       even
0034               
0035               txt.ovrwrite
0036 755C 034F             byte  3
0037 755D ....             text  'OVR'
0038                       even
0039               
0040               txt.insert
0041 7560 0349             byte  3
0042 7561 ....             text  'INS'
0043                       even
0044               
0045               txt.star
0046 7564 012A             byte  1
0047 7565 ....             text  '*'
0048                       even
0049               
0050               txt.loading
0051 7566 0A4C             byte  10
0052 7567 ....             text  'Loading...'
0053                       even
0054               
0055               txt.saving
0056 7572 0A53             byte  10
0057 7573 ....             text  'Saving....'
0058                       even
0059               
0060               txt.block.del
0061 757E 1244             byte  18
0062 757F ....             text  'Deleting block....'
0063                       even
0064               
0065               txt.block.copy
0066 7592 1143             byte  17
0067 7593 ....             text  'Copying block....'
0068                       even
0069               
0070               txt.block.move
0071 75A4 104D             byte  16
0072 75A5 ....             text  'Moving block....'
0073                       even
0074               
0075               txt.block.save
0076 75B6 1D53             byte  29
0077 75B7 ....             text  'Saving block to DV80 file....'
0078                       even
0079               
0080               txt.fastmode
0081 75D4 0846             byte  8
0082 75D5 ....             text  'Fastmode'
0083                       even
0084               
0085               txt.kb
0086 75DE 026B             byte  2
0087 75DF ....             text  'kb'
0088                       even
0089               
0090               txt.lines
0091 75E2 054C             byte  5
0092 75E3 ....             text  'Lines'
0093                       even
0094               
0095               txt.bufnum
0096 75E8 0323             byte  3
0097 75E9 ....             text  '#1 '
0098                       even
0099               
0100               txt.newfile
0101 75EC 0A5B             byte  10
0102 75ED ....             text  '[New file]'
0103                       even
0104               
0105               txt.filetype.dv80
0106 75F8 0444             byte  4
0107 75F9 ....             text  'DV80'
0108                       even
0109               
0110               txt.m1
0111 75FE 034D             byte  3
0112 75FF ....             text  'M1='
0113                       even
0114               
0115               txt.m2
0116 7602 034D             byte  3
0117 7603 ....             text  'M2='
0118                       even
0119               
0120               txt.keys.help
0121 7606 0746             byte  7
0122 7607 ....             text  'F7=Help'
0123                       even
0124               
0125               txt.keys.block
0126 760E 2B5E             byte  43
0127 760F ....             text  '^Del  ^Copy  ^Move  ^Goto M1  ^Reset  ^Save'
0128                       even
0129               
0130                                  even
0131               
0132 763A 010F     txt.alpha.up       data >010f
0133 763C 010E     txt.alpha.down     data >010e
0134 763E 0110     txt.vertline       data >0110
0135               
0136               txt.clear
0137 7640 0420             byte  4
0138 7641 ....             text  '    '
0139                       even
0140               
0141      35D6     txt.filetype.none  equ txt.clear
0142               
0143               
0144               ;--------------------------------------------------------------
0145               ; Dialog Load DV 80 file
0146               ;--------------------------------------------------------------
0147 7646 1301     txt.head.load      byte 19,1,3,32
     7648 0320 
0148 764A ....                        text 'Open DV80 file '
0149                                  byte 2
0150               txt.hint.load
0151 765A 4746             byte  71
0152 765B ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0153                       even
0154               
0155               txt.keys.load
0156 76A2 3946             byte  57
0157 76A3 ....             text  'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
0158                       even
0159               
0160               txt.keys.load2
0161 76DC 3946             byte  57
0162 76DD ....             text  'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'
0163                       even
0164               
0165               
0166               ;--------------------------------------------------------------
0167               ; Dialog Save DV 80 file
0168               ;--------------------------------------------------------------
0169 7716 1301     txt.head.save      byte 19,1,3,32
     7718 0320 
0170 771A ....                        text 'Save DV80 file '
0171                                  byte 2
0172 772A 2301     txt.head.save2     byte 35,1,3,32
     772C 0320 
0173 772E ....                        text 'Save marked block to DV80 file '
0174                                  byte 2
0175               txt.hint.save
0176 774E 0120             byte  1
0177 774F ....             text  ' '
0178                       even
0179               
0180               txt.keys.save
0181 7750 2A46             byte  42
0182 7751 ....             text  'F9=Back    F3=Clear    F-H=Home    F-L=End'
0183                       even
0184               
0185               
0186               ;--------------------------------------------------------------
0187               ; Dialog "Unsaved changes"
0188               ;--------------------------------------------------------------
0189 777C 1401     txt.head.unsaved   byte 20,1,3,32
     777E 0320 
0190 7780 ....                        text 'Unsaved changes '
0191 7790 0232                        byte 2
0192               txt.info.unsaved
0193                       byte  50
0194 7792 ....             text  'You are about to lose changes to the current file!'
0195                       even
0196               
0197               txt.hint.unsaved
0198 77C4 3950             byte  57
0199 77C5 ....             text  'Press F6 to proceed without saving or ENTER to save file.'
0200                       even
0201               
0202               txt.keys.unsaved
0203 77FE 2846             byte  40
0204 77FF ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0205                       even
0206               
0207               
0208               ;--------------------------------------------------------------
0209               ; Dialog "About"
0210               ;--------------------------------------------------------------
0211 7828 0A01     txt.head.about     byte 10,1,3,32
     782A 0320 
0212 782C ....                        text 'About '
0213 7832 0200                        byte 2
0214               
0215               txt.info.about
0216                       byte  0
0217 7834 ....             text
0218                       even
0219               
0220               txt.hint.about
0221 7834 2650             byte  38
0222 7835 ....             text  'Press F9 or ENTER to return to editor.'
0223                       even
0224               
0225 785C 3D46     txt.keys.about     byte 61
0226 785D ....                        text 'F9=Back    ENTER=Back   ALPHA LOCK Up= '
0227 7884 0F20                        byte 15
0228 7885 ....                        text '   ALPHA LOCK Down= '
0229                                  byte 14
0230               
0231               ;--------------------------------------------------------------
0232               ; Strings for error line pane
0233               ;--------------------------------------------------------------
0234               txt.ioerr.load
0235 789A 2049             byte  32
0236 789B ....             text  'I/O error. Failed loading file: '
0237                       even
0238               
0239               txt.ioerr.save
0240 78BC 2049             byte  32
0241 78BD ....             text  'I/O error. Failed saving file:  '
0242                       even
0243               
0244               txt.memfull.load
0245 78DE 4049             byte  64
0246 78DF ....             text  'Index memory full. Could not fully load file into editor buffer.'
0247                       even
0248               
0249               txt.io.nofile
0250 7920 2149             byte  33
0251 7921 ....             text  'I/O error. No filename specified.'
0252                       even
0253               
0254               txt.block.inside
0255 7942 3445             byte  52
0256 7943 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0257                       even
0258               
0259               
0260               
0261               ;--------------------------------------------------------------
0262               ; Strings for command buffer
0263               ;--------------------------------------------------------------
0264               txt.cmdb.title
0265 7978 0E43             byte  14
0266 7979 ....             text  'Command buffer'
0267                       even
0268               
0269               txt.cmdb.prompt
0270 7988 013E             byte  1
0271 7989 ....             text  '>'
0272                       even
0273               
0274               
0275               txt.colorscheme
0276 798A 0D43             byte  13
0277 798B ....             text  'Color scheme:'
0278                       even
0279               
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
0022 7998 DEAD             data  >dead,>beef,>dead,>beef
     799A BEEF 
     799C DEAD 
     799E BEEF 
**** **** ****     > stevie_b0.asm.79747
0128               
0132 79A0 3936                   data $                ; Bank 0 ROM size OK.
0134                       ;-----------------------------------------------------------------------
0135                       ; Bank specific vector table
0136                       ;-----------------------------------------------------------------------
0140 79A2 3938                   data $                ; Bank 0 ROM size OK.
0142                       ;-------------------------------------------------------
0143                       ; Vector table bank 0: >7f9c - >7fff
0144                       ;-------------------------------------------------------
0145                       copy  "rom.vectors.bank0.asm"
**** **** ****     > rom.vectors.bank0.asm
0001               * FILE......: rom.vectors.bank0.asm
0002               * Purpose...: Bank 0 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 2026     vec.1   data  cpu.crash             ;
0010 7F9E 2026     vec.2   data  cpu.crash             ;
0011 7FA0 2026     vec.3   data  cpu.crash             ;
0012 7FA2 2026     vec.4   data  cpu.crash             ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 2026     vec.10  data  cpu.crash             ;
0019 7FB0 2026     vec.11  data  cpu.crash             ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 2026     vec.15  data  cpu.crash             ;
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 2026     vec.19  data  cpu.crash             ;
0028 7FC2 2026     vec.20  data  cpu.crash             ;
0029 7FC4 2026     vec.21  data  cpu.crash             ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 2026     vec.28  data  cpu.crash             ;
0037 7FD4 2026     vec.29  data  cpu.crash             ;
0038 7FD6 2026     vec.30  data  cpu.crash             ;
0039 7FD8 2026     vec.31  data  cpu.crash             ;
0040 7FDA 2026     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b0.asm.79747
0146               
0147               
0148               *--------------------------------------------------------------
0149               * Video mode configuration for SP2
0150               *--------------------------------------------------------------
0151      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0152      0004     spfbck  equ   >04                   ; Screen background color.
0153      336E     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0154      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0155      0050     colrow  equ   80                    ; Columns per row
0156      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0157      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0158      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0159      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

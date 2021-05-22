XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b3.asm.2891045
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b3.asm               ; Version 210522-2891045
0010               *
0011               * Bank 3 "John"
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
0012               
0013      6800     bank0.ram                 equ  >6800   ; Jill
0014      6802     bank1.ram                 equ  >6802   ; James
0015      6804     bank2.ram                 equ  >6804   ; Jacky
0016      6806     bank3.ram                 equ  >6806   ; John
0017      6808     bank4.ram                 equ  >6808   ; Janine
**** **** ****     > stevie_b3.asm.2891045
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
**** **** ****     > stevie_b3.asm.2891045
0016               ***************************************************************
0017               * Spectra2 core configuration
0018               ********|*****|*********************|**************************
0019      3000     sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
0020                                                   ; grows downwards to >2000
0021               ***************************************************************
0022               * BANK 3
0023               ********|*****|*********************|**************************
0024      6006     bankid  equ   bank3                 ; Set bank identifier to current bank
0025                       aorg  >6000
0026                       save  >6000,>7fff           ; Save bank
0027                       copy  "rom.header.asm"      ; Include cartridge header
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
0031 600E 6030             data  kickstart.code1       ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0034               
0035 6010 0B53             byte  11
0036 6011 ....             text  'STEVIE 1.1H'
0037                       even
0038               
**** **** ****     > stevie_b3.asm.2891045
0028               
0029               ***************************************************************
0030               * Step 1: Switch to bank 0 (uniform code accross all banks)
0031               ********|*****|*********************|**************************
0032                       aorg  kickstart.code1       ; >6030
0033 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0034               ***************************************************************
0035               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0036               ********|*****|*********************|**************************
0037                       aorg  >2000
0038                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     2084 2E4A 
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
     20A8 29CE 
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
     20BC 29CE 
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
     210C 29D8 
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
     2138 29D8 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 294A 
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
     2176 2D48 
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
0255 21B7 ....             text  'Source    stevie_b3.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1842             byte  24
0260 21D3 ....             text  'Build-ID  210522-2891045'
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
0525               * bl  @_put.strings
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
0018 2744 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2746 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2748 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     274A 2336 
0028 274C 391C             data  >391c
0029 274E 0458  20         b     *tmp4                 ; Exit
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
0040 2750 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2752 06A0  32         bl    @cpym2v
     2754 248A 
0042 2756 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2758 2794 
     275A 0006 
0043 275C 06A0  32         bl    @putvr
     275E 2336 
0044 2760 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2762 06A0  32         bl    @putvr
     2764 2336 
0046 2766 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2768 0204  20         li    tmp0,>3f00
     276A 3F00 
0052 276C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     276E 22BE 
0053 2770 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2772 8800 
0054 2774 0984  56         srl   tmp0,8
0055 2776 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2778 8800 
0056 277A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 277C 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 277E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2780 BFFF 
0060 2782 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2784 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2786 4000 
0063               f18chk_exit:
0064 2788 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     278A 2292 
0065 278C 3F00             data  >3f00,>00,6
     278E 0000 
     2790 0006 
0066 2792 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2794 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2796 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2798 0340             data  >0340                 ; 3f04   0340  idle
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
0092 279A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 279C 06A0  32         bl    @putvr
     279E 2336 
0097 27A0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 27A2 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     27A4 2336 
0100 27A6 391C             data  >391c                 ; Lock the F18a
0101 27A8 0458  20         b     *tmp4                 ; Exit
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
0120 27AA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 27AC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27AE 201E 
0122 27B0 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 27B2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27B4 8802 
0127 27B6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27B8 2336 
0128 27BA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 27BC 04C4  14         clr   tmp0
0130 27BE D120  34         movb  @vdps,tmp0
     27C0 8802 
0131 27C2 0984  56         srl   tmp0,8
0132 27C4 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 27C6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27C8 832A 
0018 27CA D17B  28         movb  *r11+,tmp1
0019 27CC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27CE D1BB  28         movb  *r11+,tmp2
0021 27D0 0986  56         srl   tmp2,8                ; Repeat count
0022 27D2 C1CB  18         mov   r11,tmp3
0023 27D4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27D6 23FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27D8 020B  20         li    r11,hchar1
     27DA 27E0 
0028 27DC 0460  28         b     @xfilv                ; Draw
     27DE 2298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27E0 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27E2 2022 
0033 27E4 1302  14         jeq   hchar2                ; Yes, exit
0034 27E6 C2C7  18         mov   tmp3,r11
0035 27E8 10EE  14         jmp   hchar                 ; Next one
0036 27EA 05C7  14 hchar2  inct  tmp3
0037 27EC 0457  20         b     *tmp3                 ; Exit
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
0016 27EE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27F0 2020 
0017 27F2 020C  20         li    r12,>0024
     27F4 0024 
0018 27F6 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27F8 288A 
0019 27FA 04C6  14         clr   tmp2
0020 27FC 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27FE 04CC  14         clr   r12
0025 2800 1F08  20         tb    >0008                 ; Shift-key ?
0026 2802 1302  14         jeq   realk1                ; No
0027 2804 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2806 28BA 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 2808 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 280A 1302  14         jeq   realk2                ; No
0033 280C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     280E 28EA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 2810 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 2812 1302  14         jeq   realk3                ; No
0039 2814 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2816 291A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2818 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     281A 200C 
0044 281C 1E15  20         sbz   >0015                 ; Set P5
0045 281E 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 2820 1302  14         jeq   realk4                ; No
0047 2822 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     2824 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 2826 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 2828 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     282A 0006 
0053 282C 0606  14 realk5  dec   tmp2
0054 282E 020C  20         li    r12,>24               ; CRU address for P2-P4
     2830 0024 
0055 2832 06C6  14         swpb  tmp2
0056 2834 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2836 06C6  14         swpb  tmp2
0058 2838 020C  20         li    r12,6                 ; CRU read address
     283A 0006 
0059 283C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 283E 0547  14         inv   tmp3                  ;
0061 2840 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2842 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2844 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2846 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2848 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 284A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 284C 0285  22         ci    tmp1,8
     284E 0008 
0070 2850 1AFA  14         jl    realk6
0071 2852 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2854 1BEB  14         jh    realk5                ; No, next column
0073 2856 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2858 C206  18 realk8  mov   tmp2,tmp4
0078 285A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 285C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 285E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2860 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2862 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2864 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2866 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2868 200C 
0089 286A 1608  14         jne   realka                ; No, continue saving key
0090 286C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     286E 28B4 
0091 2870 1A05  14         jl    realka
0092 2872 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2874 28B2 
0093 2876 1B02  14         jh    realka                ; No, continue
0094 2878 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     287A E000 
0095 287C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     287E 833C 
0096 2880 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2882 200A 
0097 2884 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2886 8C00 
0098                                                   ; / using R15 as temp storage
0099 2888 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 288A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     288C 0000 
     288E FF0D 
     2890 203D 
0102 2892 ....             text  'xws29ol.'
0103 289A ....             text  'ced38ik,'
0104 28A2 ....             text  'vrf47ujm'
0105 28AA ....             text  'btg56yhn'
0106 28B2 ....             text  'zqa10p;/'
0107 28BA FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28BC 0000 
     28BE FF0D 
     28C0 202B 
0108 28C2 ....             text  'XWS@(OL>'
0109 28CA ....             text  'CED#*IK<'
0110 28D2 ....             text  'VRF$&UJM'
0111 28DA ....             text  'BTG%^YHN'
0112 28E2 ....             text  'ZQA!)P:-'
0113 28EA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28EC 0000 
     28EE FF0D 
     28F0 2005 
0114 28F2 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28F4 0804 
     28F6 0F27 
     28F8 C2B9 
0115 28FA 600B             data  >600b,>0907,>063f,>c1B8
     28FC 0907 
     28FE 063F 
     2900 C1B8 
0116 2902 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     2904 7B02 
     2906 015F 
     2908 C0C3 
0117 290A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     290C 7D0E 
     290E 0CC6 
     2910 BFC4 
0118 2912 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     2914 7C03 
     2916 BC22 
     2918 BDBA 
0119 291A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     291C 0000 
     291E FF0D 
     2920 209D 
0120 2922 9897             data  >9897,>93b2,>9f8f,>8c9B
     2924 93B2 
     2926 9F8F 
     2928 8C9B 
0121 292A 8385             data  >8385,>84b3,>9e89,>8b80
     292C 84B3 
     292E 9E89 
     2930 8B80 
0122 2932 9692             data  >9692,>86b4,>b795,>8a8D
     2934 86B4 
     2936 B795 
     2938 8A8D 
0123 293A 8294             data  >8294,>87b5,>b698,>888E
     293C 87B5 
     293E B698 
     2940 888E 
0124 2942 9A91             data  >9a91,>81b1,>b090,>9cBB
     2944 81B1 
     2946 B090 
     2948 9CBB 
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
0023 294A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 294C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     294E 8340 
0025 2950 04E0  34         clr   @waux1
     2952 833C 
0026 2954 04E0  34         clr   @waux2
     2956 833E 
0027 2958 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     295A 833C 
0028 295C C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 295E 0205  20         li    tmp1,4                ; 4 nibbles
     2960 0004 
0033 2962 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2964 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2966 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2968 0286  22         ci    tmp2,>000a
     296A 000A 
0039 296C 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 296E C21B  26         mov   *r11,tmp4
0045 2970 0988  56         srl   tmp4,8                ; Right justify
0046 2972 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2974 FFF6 
0047 2976 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2978 C21B  26         mov   *r11,tmp4
0054 297A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     297C 00FF 
0055               
0056 297E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2980 06C6  14         swpb  tmp2
0058 2982 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2984 0944  56         srl   tmp0,4                ; Next nibble
0060 2986 0605  14         dec   tmp1
0061 2988 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 298A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     298C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 298E C160  34         mov   @waux3,tmp1           ; Get pointer
     2990 8340 
0067 2992 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2994 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2996 C120  34         mov   @waux2,tmp0
     2998 833E 
0070 299A 06C4  14         swpb  tmp0
0071 299C DD44  32         movb  tmp0,*tmp1+
0072 299E 06C4  14         swpb  tmp0
0073 29A0 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 29A2 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     29A4 8340 
0078 29A6 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     29A8 2016 
0079 29AA 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 29AC C120  34         mov   @waux1,tmp0
     29AE 833C 
0084 29B0 06C4  14         swpb  tmp0
0085 29B2 DD44  32         movb  tmp0,*tmp1+
0086 29B4 06C4  14         swpb  tmp0
0087 29B6 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29B8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29BA 2020 
0092 29BC 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29BE 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29C0 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29C2 7FFF 
0098 29C4 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29C6 8340 
0099 29C8 0460  28         b     @xutst0               ; Display string
     29CA 2424 
0100 29CC 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29CE C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29D0 832A 
0122 29D2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29D4 8000 
0123 29D6 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29D8 0207  20 mknum   li    tmp3,5                ; Digit counter
     29DA 0005 
0020 29DC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29DE C155  26         mov   *tmp1,tmp1            ; /
0022 29E0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29E2 0228  22         ai    tmp4,4                ; Get end of buffer
     29E4 0004 
0024 29E6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29E8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29EA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29EC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29EE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29F0 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29F2 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29F4 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29F6 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29F8 0607  14         dec   tmp3                  ; Decrease counter
0036 29FA 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29FC 0207  20         li    tmp3,4                ; Check first 4 digits
     29FE 0004 
0041 2A00 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 2A02 C11B  26         mov   *r11,tmp0
0043 2A04 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 2A06 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2A08 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2A0A 05CB  14 mknum3  inct  r11
0047 2A0C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2A0E 2020 
0048 2A10 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 2A12 045B  20         b     *r11                  ; Exit
0050 2A14 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 2A16 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A18 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A1A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A1C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A1E 7FFF 
0058 2A20 C10B  18         mov   r11,tmp0
0059 2A22 0224  22         ai    tmp0,-4
     2A24 FFFC 
0060 2A26 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A28 0206  20         li    tmp2,>0500            ; String length = 5
     2A2A 0500 
0062 2A2C 0460  28         b     @xutstr               ; Display string
     2A2E 2426 
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
0093 2A30 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A32 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A34 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A36 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A38 0207  20         li    tmp3,5                ; Set counter
     2A3A 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A3C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A3E 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A40 0584  14         inc   tmp0                  ; Next character
0105 2A42 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A44 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A46 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A48 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A4A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A4C 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A4E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A50 0607  14         dec   tmp3                  ; Last character ?
0121 2A52 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A54 045B  20         b     *r11                  ; Return
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
0139 2A56 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A58 832A 
0140 2A5A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A5C 8000 
0141 2A5E 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A60 0649  14         dect  stack
0023 2A62 C64B  30         mov   r11,*stack            ; Save return address
0024 2A64 0649  14         dect  stack
0025 2A66 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A68 0649  14         dect  stack
0027 2A6A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A6C 0649  14         dect  stack
0029 2A6E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A70 0649  14         dect  stack
0031 2A72 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A74 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A76 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A78 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A7A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A7C 0649  14         dect  stack
0044 2A7E C64B  30         mov   r11,*stack            ; Save return address
0045 2A80 0649  14         dect  stack
0046 2A82 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A84 0649  14         dect  stack
0048 2A86 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A88 0649  14         dect  stack
0050 2A8A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A8C 0649  14         dect  stack
0052 2A8E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A90 C1D4  26 !       mov   *tmp0,tmp3
0057 2A92 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A94 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A96 00FF 
0059 2A98 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A9A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A9C 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A9E 0584  14         inc   tmp0                  ; Next byte
0067 2AA0 0607  14         dec   tmp3                  ; Shorten string length
0068 2AA2 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2AA4 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2AA6 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2AA8 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2AAA 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2AAC C187  18         mov   tmp3,tmp2
0078 2AAE 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2AB0 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2AB2 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2AB4 24E4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2AB6 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2AB8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ABA FFCE 
0090 2ABC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2ABE 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AC0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AC2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AC4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2ACA 045B  20         b     *r11                  ; Return to caller
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
0123 2ACC 0649  14         dect  stack
0124 2ACE C64B  30         mov   r11,*stack            ; Save return address
0125 2AD0 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AD2 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AD4 0649  14         dect  stack
0128 2AD6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AD8 0649  14         dect  stack
0130 2ADA C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ADC 0649  14         dect  stack
0132 2ADE C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AE0 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AE2 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AE4 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AE6 0649  14         dect  stack
0144 2AE8 C64B  30         mov   r11,*stack            ; Save return address
0145 2AEA 0649  14         dect  stack
0146 2AEC C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AEE 0649  14         dect  stack
0148 2AF0 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AF2 0649  14         dect  stack
0150 2AF4 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AF6 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AF8 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AFA 0586  14         inc   tmp2
0161 2AFC 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AFE 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2B00 0286  22         ci    tmp2,255
     2B02 00FF 
0167 2B04 1505  14         jgt   string.getlenc.panic
0168 2B06 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2B08 0606  14         dec   tmp2                  ; One time adjustment
0174 2B0A C806  38         mov   tmp2,@waux1           ; Store length
     2B0C 833C 
0175 2B0E 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2B10 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2B12 FFCE 
0181 2B14 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2B16 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2B18 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2B1A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2B1C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B1E C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B20 045B  20         b     *r11                  ; Return to caller
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
0056 2B22 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2B24 2B26             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2B26 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2B28 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2B2A A428 
0064 2B2C 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2B2E 201C 
0065 2B30 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B32 8356 
0066 2B34 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B36 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B38 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B3A C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B3C A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B3E 06C0  14         swpb  r0                    ;
0075 2B40 D800  38         movb  r0,@vdpa              ; Send low byte
     2B42 8C02 
0076 2B44 06C0  14         swpb  r0                    ;
0077 2B46 D800  38         movb  r0,@vdpa              ; Send high byte
     2B48 8C02 
0078 2B4A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B4C 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B4E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B50 0704  14         seto  r4                    ; Init counter
0086 2B52 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B54 A420 
0087 2B56 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B58 0584  14         inc   r4                    ; Increment char counter
0089 2B5A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B5C 0007 
0090 2B5E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B60 80C4  18         c     r4,r3                 ; End of name?
0093 2B62 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B64 06C0  14         swpb  r0                    ;
0098 2B66 D800  38         movb  r0,@vdpa              ; Send low byte
     2B68 8C02 
0099 2B6A 06C0  14         swpb  r0                    ;
0100 2B6C D800  38         movb  r0,@vdpa              ; Send high byte
     2B6E 8C02 
0101 2B70 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B72 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B74 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B76 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B78 2C8E 
0109 2B7A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B7C C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B7E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B80 04E0  34         clr   @>83d0
     2B82 83D0 
0118 2B84 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B86 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B88 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B8A A432 
0121               
0122 2B8C 0584  14         inc   r4                    ; Adjust for dot
0123 2B8E A804  38         a     r4,@>8356             ; Point to position after name
     2B90 8356 
0124 2B92 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B94 8356 
     2B96 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B98 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B9A 83E0 
0130 2B9C 04C1  14         clr   r1                    ; Version found of dsr
0131 2B9E 020C  20         li    r12,>0f00             ; Init cru address
     2BA0 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2BA2 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2BA4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2BA6 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2BA8 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2BAA 0100 
0145 2BAC 04E0  34         clr   @>83d0                ; Clear in case we are done
     2BAE 83D0 
0146 2BB0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BB2 2000 
0147 2BB4 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2BB6 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2BB8 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2BBA 1D00  20         sbo   0                     ; Turn on ROM
0154 2BBC 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2BBE 4000 
0155 2BC0 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2BC2 2C8A 
0156 2BC4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2BC6 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2BC8 A40A 
0166 2BCA 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2BCC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2BCE 83D2 
0172                                                   ; subprogram
0173               
0174 2BD0 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BD2 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BD4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BD6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BD8 83D2 
0183                                                   ; subprogram
0184               
0185 2BDA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BDC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BDE 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BE0 D160  34         movb  @>8355,r5             ; Get length as counter
     2BE2 8355 
0195 2BE4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BE6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BE8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BEA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BEC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BEE A420 
0206 2BF0 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BF2 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BF4 0605  14         dec   r5                    ; Update loop counter
0211 2BF6 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BF8 0581  14         inc   r1                    ; Next version found
0217 2BFA C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BFC A42A 
0218 2BFE C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C00 A42C 
0219 2C02 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C04 A430 
0220               
0221 2C06 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C08 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C0A 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2C0C 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2C0E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2C10 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C12 A400 
0233 2C14 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2C16 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C18 A428 
0239                                                   ; (8 or >a)
0240 2C1A 0281  22         ci    r1,8                  ; was it 8?
     2C1C 0008 
0241 2C1E 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2C20 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C22 8350 
0243                                                   ; Get error byte from @>8350
0244 2C24 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2C26 06C0  14         swpb  r0                    ;
0252 2C28 D800  38         movb  r0,@vdpa              ; send low byte
     2C2A 8C02 
0253 2C2C 06C0  14         swpb  r0                    ;
0254 2C2E D800  38         movb  r0,@vdpa              ; send high byte
     2C30 8C02 
0255 2C32 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C34 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C36 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C38 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C3A 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C3C 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C3E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C40 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C42 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C44 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C46 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C48 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C4A 201C 
0281                                                   ; / to indicate error
0282 2C4C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C4E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C50 2C52             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C52 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C54 83E0 
0316               
0317 2C56 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C58 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C5A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C5C A42A 
0322 2C5E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C60 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C62 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C64 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C66 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C68 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C6A 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C6C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C6E 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C70 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C72 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C74 4000 
     2C76 2C8A 
0337 2C78 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C7A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C7C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C7E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C80 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C82 A400 
0355 2C84 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C86 A434 
0356               
0357 2C88 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C8A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C8C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C8E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C90 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C92 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C94 0649  14         dect  stack
0052 2C96 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C98 0204  20         li    tmp0,dsrlnk.savcru
     2C9A A42A 
0057 2C9C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C9E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2CA0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2CA2 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2CA4 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2CA6 37D7 
0065 2CA8 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2CAA 8370 
0066                                                   ; / location
0067 2CAC C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2CAE A44C 
0068 2CB0 04C5  14         clr   tmp1                  ; io.op.open
0069 2CB2 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2CB4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2CB6 0649  14         dect  stack
0097 2CB8 C64B  30         mov   r11,*stack            ; Save return address
0098 2CBA 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CBC 0001 
0099 2CBE 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2CC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2CC2 0649  14         dect  stack
0125 2CC4 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2CC6 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CC8 0002 
0128 2CCA 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2CCC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2CCE 0649  14         dect  stack
0155 2CD0 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CD2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CD4 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CD6 0005 
0159               
0160 2CD8 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CDA A43E 
0161               
0162 2CDC 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CDE 22D0 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CE0 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CE2 0003 
0167 2CE4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CE6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CE8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CEA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CEC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CEE 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CF0 1000  14         nop
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
0227 2CF2 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CF4 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CF6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CF8 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CFA A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CFC 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CFE 22D0 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D00 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D02 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D04 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D06 A44C 
0246               
0247 2D08 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D0A 22D0 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D0C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D0E 0009 
0254 2D10 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2D12 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2D14 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2D16 8322 
     2D18 833C 
0259               
0260 2D1A C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2D1C A42A 
0261 2D1E 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2D20 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2D22 2B22 
0268 2D24 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2D26 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2D28 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2D2A 2C4E 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2D2C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2D2E C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D30 833C 
     2D32 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D34 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D36 A436 
0292 2D38 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D3A 0005 
0293 2D3C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D3E 22E8 
0294 2D40 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D42 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D44 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D46 045B  20         b     *r11                  ; Return to caller
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
0020 2D48 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D4A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D4C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D4E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D50 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D52 201C 
0029 2D54 1602  14         jne   tmgr1a                ; No, so move on
0030 2D56 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D58 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D5A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D5C 2020 
0035 2D5E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D60 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D62 2010 
0048 2D64 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D66 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D68 200E 
0050 2D6A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D6C 0460  28         b     @kthread              ; Run kernel thread
     2D6E 2DE6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D70 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D72 2014 
0056 2D74 13EB  14         jeq   tmgr1
0057 2D76 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D78 2012 
0058 2D7A 16E8  14         jne   tmgr1
0059 2D7C C120  34         mov   @wtiusr,tmp0
     2D7E 832E 
0060 2D80 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D82 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D84 2DE4 
0065 2D86 C10A  18         mov   r10,tmp0
0066 2D88 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D8A 00FF 
0067 2D8C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D8E 201C 
0068 2D90 1303  14         jeq   tmgr5
0069 2D92 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D94 003C 
0070 2D96 1002  14         jmp   tmgr6
0071 2D98 0284  22 tmgr5   ci    tmp0,50
     2D9A 0032 
0072 2D9C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D9E 1001  14         jmp   tmgr8
0074 2DA0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2DA2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2DA4 832C 
0079 2DA6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2DA8 FF00 
0080 2DAA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2DAC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2DAE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2DB0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2DB2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2DB4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2DB6 830C 
     2DB8 830D 
0089 2DBA 1608  14         jne   tmgr10                ; No, get next slot
0090 2DBC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2DBE FF00 
0091 2DC0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2DC2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2DC4 8330 
0096 2DC6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2DC8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2DCA 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2DCC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DCE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DD0 8315 
     2DD2 8314 
0103 2DD4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DD6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DD8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DDA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DDC 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DDE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DE0 FF00 
0109 2DE2 10B4  14         jmp   tmgr1
0110 2DE4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DE6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DE8 2010 
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
0041 2DEA 06A0  32         bl    @realkb               ; Scan full keyboard
     2DEC 27EE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DEE 0460  28         b     @tmgr3                ; Exit
     2DF0 2D70 
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
0017 2DF2 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DF4 832E 
0018 2DF6 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DF8 2012 
0019 2DFA 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D4C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DFC 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DFE 832E 
0029 2E00 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E02 FEFF 
0030 2E04 045B  20         b     *r11                  ; Return
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
0017 2E06 C13B  30 mkslot  mov   *r11+,tmp0
0018 2E08 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2E0A C184  18         mov   tmp0,tmp2
0023 2E0C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2E0E A1A0  34         a     @wtitab,tmp2          ; Add table base
     2E10 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2E12 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2E14 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2E16 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2E18 881B  46         c     *r11,@w$ffff          ; End of list ?
     2E1A 2022 
0035 2E1C 1301  14         jeq   mkslo1                ; Yes, exit
0036 2E1E 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2E20 05CB  14 mkslo1  inct  r11
0041 2E22 045B  20         b     *r11                  ; Exit
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
0052 2E24 C13B  30 clslot  mov   *r11+,tmp0
0053 2E26 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2E28 A120  34         a     @wtitab,tmp0          ; Add table base
     2E2A 832C 
0055 2E2C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E2E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E30 045B  20         b     *r11                  ; Exit
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
0068 2E32 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E34 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E36 A120  34         a     @wtitab,tmp0          ; Add table base
     2E38 832C 
0071 2E3A 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E3C C154  26         mov   *tmp0,tmp1
0073 2E3E 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E40 FF00 
0074 2E42 C505  30         mov   tmp1,*tmp0
0075 2E44 045B  20         b     *r11                  ; Exit
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
0260 2E46 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E48 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E4A 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E4C 0000 
0266 2E4E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E50 8300 
0267 2E52 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E54 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E56 0202  20 runli2  li    r2,>8308
     2E58 8308 
0272 2E5A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E5C 0282  22         ci    r2,>8400
     2E5E 8400 
0274 2E60 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E62 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E64 FFFF 
0279 2E66 1602  14         jne   runli4                ; No, continue
0280 2E68 0420  54         blwp  @0                    ; Yes, bye bye
     2E6A 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E6C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E6E 833C 
0285 2E70 04C1  14         clr   r1                    ; Reset counter
0286 2E72 0202  20         li    r2,10                 ; We test 10 times
     2E74 000A 
0287 2E76 C0E0  34 runli5  mov   @vdps,r3
     2E78 8802 
0288 2E7A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E7C 2020 
0289 2E7E 1302  14         jeq   runli6
0290 2E80 0581  14         inc   r1                    ; Increase counter
0291 2E82 10F9  14         jmp   runli5
0292 2E84 0602  14 runli6  dec   r2                    ; Next test
0293 2E86 16F7  14         jne   runli5
0294 2E88 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E8A 1250 
0295 2E8C 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E8E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E90 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E92 06A0  32 runli7  bl    @loadmc
     2E94 221E 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E96 04C1  14 runli9  clr   r1
0305 2E98 04C2  14         clr   r2
0306 2E9A 04C3  14         clr   r3
0307 2E9C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E9E 3000 
0308 2EA0 020F  20         li    r15,vdpw              ; Set VDP write address
     2EA2 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2EA4 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2EA6 4A4A 
0317 2EA8 1605  14         jne   runlia
0318 2EAA 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2EAC 2292 
0319 2EAE 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2EB0 0000 
     2EB2 3000 
0324 2EB4 06A0  32 runlia  bl    @filv
     2EB6 2292 
0325 2EB8 0FC0             data  pctadr,spfclr,16      ; Load color table
     2EBA 00F4 
     2EBC 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2EBE 06A0  32         bl    @f18unl               ; Unlock the F18A
     2EC0 2736 
0333 2EC2 06A0  32         bl    @f18chk               ; Check if F18A is there
     2EC4 2750 
0334 2EC6 06A0  32         bl    @f18lck               ; Lock the F18A again
     2EC8 2746 
0335               
0336 2ECA 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2ECC 2336 
0337 2ECE 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2ED0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2ED2 22FC 
0351 2ED4 339E             data  spvmod                ; Equate selected video mode table
0352 2ED6 0204  20         li    tmp0,spfont           ; Get font option
     2ED8 000C 
0353 2EDA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EDC 1304  14         jeq   runlid                ; Yes, skip it
0355 2EDE 06A0  32         bl    @ldfnt
     2EE0 2364 
0356 2EE2 1100             data  fntadr,spfont         ; Load specified font
     2EE4 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EE6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EE8 4A4A 
0361 2EEA 1602  14         jne   runlie                ; No, continue
0362 2EEC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EEE 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EF0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EF2 0040 
0367 2EF4 0460  28         b     @main                 ; Give control to main program
     2EF6 6036 
**** **** ****     > stevie_b3.asm.2891045
0039                                                   ; Relocated spectra2 in low MEMEXP, was
0040                                                   ; copied to >2000 from ROM in bank 0
0041                       ;------------------------------------------------------
0042                       ; End of File marker
0043                       ;------------------------------------------------------
0044 2EF8 DEAD             data >dead,>beef,>dead,>beef
     2EFA BEEF 
     2EFC DEAD 
     2EFE BEEF 
0046               ***************************************************************
0047               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0048               ********|*****|*********************|**************************
0049                       aorg  >3000
0050                       ;------------------------------------------------------
0051                       ; Activate bank 1 and branch to >6036
0052                       ;------------------------------------------------------
0053 3000 04E0  34         clr   @bank1                ; Activate bank 1 "James" ROM
     3002 6002 
0054 3004 04E0  34         clr   @bank1.ram            ; Activate bank 1 "James" RAM
     3006 6802 
0055 3008 0460  28         b     @kickstart.code2      ; Jump to entry routine
     300A 6036 
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
0021 300C C13B  30         mov   *r11+,tmp0            ; P0
0022 300E C17B  30         mov   *r11+,tmp1            ; P1
0023 3010 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 3012 0649  14         dect  stack
0029 3014 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 3016 0649  14         dect  stack
0031 3018 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 301A 0649  14         dect  stack
0033 301C C646  30         mov   tmp2,*stack           ; Push tmp2
0034 301E 0649  14         dect  stack
0035 3020 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 3022 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     3024 6000 
0040 3026 1111  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 3028 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     302A A026 
0044 302C 0647  14         dect  tmp3
0045 302E C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 3030 0647  14         dect  tmp3
0047 3032 C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 3034 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3036 A026 
0049               
0050                       ;jmp   rom.farjump.bankswitch.tgt.advfg99
0051               
0052                       ;------------------------------------------------------
0053                       ; Bankswitch to target 8K ROM bank
0054                       ;------------------------------------------------------
0055               rom.farjump.bankswitch.target.rom8k:
0056 3038 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0057 303A 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0058                       ;------------------------------------------------------
0059                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0060                       ;------------------------------------------------------
0061               rom.farjump.bankswitch.tgt.advfg99:
0062 303C 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0063 303E 0224  22         ai    tmp0,>0800
     3040 0800 
0064 3042 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0065                       ;------------------------------------------------------
0066                       ; Bankswitch to target bank(s) completed
0067                       ;------------------------------------------------------
0068               rom.farjump.bankswitch.tgt.done:
0069 3044 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0070 3046 1301  14         jeq   rom.farjump.bankswitch.failed1
0071                                                   ; Crash if null-pointer in vector
0072 3048 1004  14         jmp   rom.farjump.bankswitch.call
0073                                                   ; Call function in target bank
0074                       ;------------------------------------------------------
0075                       ; Assert 1 failed before bank-switch
0076                       ;------------------------------------------------------
0077               rom.farjump.bankswitch.failed1:
0078 304A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     304C FFCE 
0079 304E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3050 2026 
0080                       ;------------------------------------------------------
0081                       ; Call function in target bank
0082                       ;------------------------------------------------------
0083               rom.farjump.bankswitch.call:
0084 3052 0694  24         bl    *tmp0                 ; Call function
0085                       ;------------------------------------------------------
0086                       ; Bankswitch back to source bank
0087                       ;------------------------------------------------------
0088               rom.farjump.return:
0089 3054 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3056 A026 
0090 3058 C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0091 305A 1312  14         jeq   rom.farjump.bankswitch.failed2
0092                                                   ; Crash if null-pointer in address
0093               
0094 305C 04F4  30         clr   *tmp0+                ; Remove bank write address from
0095                                                   ; farjump stack
0096               
0097 305E C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0098               
0099 3060 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0100                                                   ; farjump stack
0101               
0102 3062 028B  22         ci    r11,>6000
     3064 6000 
0103 3066 110C  14         jlt   rom.farjump.bankswitch.failed2
0104 3068 028B  22         ci    r11,>7fff
     306A 7FFF 
0105 306C 1509  14         jgt   rom.farjump.bankswitch.failed2
0106               
0107 306E C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3070 A026 
0108               
0109                       ;jmp   rom.farjump.bankswitch.src.advfg99
0110               
0111                       ;------------------------------------------------------
0112                       ; Bankswitch to source 8K ROM bank
0113                       ;------------------------------------------------------
0114               rom.farjump.bankswitch.src.rom8k:
0115 3072 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0116 3074 1009  14         jmp   rom.farjump.exit
0117                       ;------------------------------------------------------
0118                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0119                       ;------------------------------------------------------
0120               rom.farjump.bankswitch.src.advfg99:
0121 3076 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0122 3078 0225  22         ai    tmp1,>0800
     307A 0800 
0123 307C 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0124 307E 1004  14         jmp   rom.farjump.exit
0125                       ;------------------------------------------------------
0126                       ; Assert 2 failed after bank-switch
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.failed2:
0129 3080 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3082 FFCE 
0130 3084 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3086 2026 
0131                       ;-------------------------------------------------------
0132                       ; Exit
0133                       ;-------------------------------------------------------
0134               rom.farjump.exit:
0135 3088 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0136 308A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0137 308C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0138 308E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0139 3090 045B  20         b     *r11                  ; Return to caller
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
0020 3092 0649  14         dect  stack
0021 3094 C64B  30         mov   r11,*stack            ; Save return address
0022 3096 0649  14         dect  stack
0023 3098 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 309A 0649  14         dect  stack
0025 309C C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 309E 0204  20         li    tmp0,fb.top
     30A0 A600 
0030 30A2 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     30A4 A100 
0031 30A6 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     30A8 A104 
0032 30AA 04E0  34         clr   @fb.row               ; Current row=0
     30AC A106 
0033 30AE 04E0  34         clr   @fb.column            ; Current column=0
     30B0 A10C 
0034               
0035 30B2 0204  20         li    tmp0,colrow
     30B4 0050 
0036 30B6 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     30B8 A10E 
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 30BA C160  34         mov   @tv.ruler.visible,tmp1
     30BC A010 
0041 30BE 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 30C0 0204  20         li    tmp0,pane.botrow-2
     30C2 001B 
0043 30C4 1002  14         jmp   fb.init.cont
0044 30C6 0204  20 !       li    tmp0,pane.botrow-1
     30C8 001C 
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 30CA C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     30CC A11A 
0050 30CE C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30D0 A11C 
0051               
0052 30D2 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30D4 A022 
0053 30D6 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30D8 A110 
0054 30DA 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30DC A116 
0055 30DE 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30E0 A118 
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 30E2 06A0  32         bl    @film
     30E4 223A 
0060 30E6 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30E8 0000 
     30EA 0960 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 30EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 30EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 30F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 30F2 045B  20         b     *r11                  ; Return to caller
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
0046 30F4 0649  14         dect  stack
0047 30F6 C64B  30         mov   r11,*stack            ; Save return address
0048 30F8 0649  14         dect  stack
0049 30FA C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30FC 0204  20         li    tmp0,idx.top
     30FE B000 
0054 3100 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     3102 A202 
0055               
0056 3104 C120  34         mov   @tv.sams.b000,tmp0
     3106 A006 
0057 3108 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     310A A500 
0058 310C C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     310E A502 
0059                       ;------------------------------------------------------
0060                       ; Clear all index pages
0061                       ;------------------------------------------------------
0062 3110 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     3112 0004 
0063 3114 C804  38         mov   tmp0,@idx.sams.hipage ; /
     3116 A504 
0064               
0065 3118 06A0  32         bl    @_idx.sams.mapcolumn.on
     311A 3136 
0066                                                   ; Index in continuous memory region
0067               
0068 311C 06A0  32         bl    @film
     311E 223A 
0069 3120 B000                   data idx.top,>00,idx.size * 5
     3122 0000 
     3124 5000 
0070                                                   ; Clear index
0071               
0072 3126 06A0  32         bl    @_idx.sams.mapcolumn.off
     3128 316A 
0073                                                   ; Restore memory window layout
0074               
0075 312A C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     312C A502 
     312E A504 
0076                                                   ; Reset last SAMS page
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080               idx.init.exit:
0081 3130 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0082 3132 C2F9  30         mov   *stack+,r11           ; Pop r11
0083 3134 045B  20         b     *r11                  ; Return to caller
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
0096 3136 0649  14         dect  stack
0097 3138 C64B  30         mov   r11,*stack            ; Push return address
0098 313A 0649  14         dect  stack
0099 313C C644  30         mov   tmp0,*stack           ; Push tmp0
0100 313E 0649  14         dect  stack
0101 3140 C645  30         mov   tmp1,*stack           ; Push tmp1
0102 3142 0649  14         dect  stack
0103 3144 C646  30         mov   tmp2,*stack           ; Push tmp2
0104               *--------------------------------------------------------------
0105               * Map index pages into memory window  (b000-ffff)
0106               *--------------------------------------------------------------
0107 3146 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3148 A502 
0108 314A 0205  20         li    tmp1,idx.top
     314C B000 
0109 314E 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3150 0005 
0110                       ;-------------------------------------------------------
0111                       ; Loop over banks
0112                       ;-------------------------------------------------------
0113 3152 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3154 257A 
0114                                                   ; \ i  tmp0  = SAMS page number
0115                                                   ; / i  tmp1  = Memory address
0116               
0117 3156 0584  14         inc   tmp0                  ; Next SAMS index page
0118 3158 0225  22         ai    tmp1,>1000            ; Next memory region
     315A 1000 
0119 315C 0606  14         dec   tmp2                  ; Update loop counter
0120 315E 15F9  14         jgt   -!                    ; Next iteration
0121               *--------------------------------------------------------------
0122               * Exit
0123               *--------------------------------------------------------------
0124               _idx.sams.mapcolumn.on.exit:
0125 3160 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0126 3162 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0127 3164 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 3166 C2F9  30         mov   *stack+,r11           ; Pop return address
0129 3168 045B  20         b     *r11                  ; Return to caller
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
0145 316A 0649  14         dect  stack
0146 316C C64B  30         mov   r11,*stack            ; Push return address
0147 316E 0649  14         dect  stack
0148 3170 C644  30         mov   tmp0,*stack           ; Push tmp0
0149 3172 0649  14         dect  stack
0150 3174 C645  30         mov   tmp1,*stack           ; Push tmp1
0151 3176 0649  14         dect  stack
0152 3178 C646  30         mov   tmp2,*stack           ; Push tmp2
0153 317A 0649  14         dect  stack
0154 317C C647  30         mov   tmp3,*stack           ; Push tmp3
0155               *--------------------------------------------------------------
0156               * Map index pages into memory window  (b000-????)
0157               *--------------------------------------------------------------
0158 317E 0205  20         li    tmp1,idx.top
     3180 B000 
0159 3182 0206  20         li    tmp2,5                ; Always 5 pages
     3184 0005 
0160 3186 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3188 A006 
0161                       ;-------------------------------------------------------
0162                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0163                       ;-------------------------------------------------------
0164 318A C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0165               
0166 318C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     318E 257A 
0167                                                   ; \ i  tmp0  = SAMS page number
0168                                                   ; / i  tmp1  = Memory address
0169               
0170 3190 0225  22         ai    tmp1,>1000            ; Next memory region
     3192 1000 
0171 3194 0606  14         dec   tmp2                  ; Update loop counter
0172 3196 15F9  14         jgt   -!                    ; Next iteration
0173               *--------------------------------------------------------------
0174               * Exit
0175               *--------------------------------------------------------------
0176               _idx.sams.mapcolumn.off.exit:
0177 3198 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0178 319A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 319C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 319E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 31A0 C2F9  30         mov   *stack+,r11           ; Pop return address
0182 31A2 045B  20         b     *r11                  ; Return to caller
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
0206 31A4 0649  14         dect  stack
0207 31A6 C64B  30         mov   r11,*stack            ; Save return address
0208 31A8 0649  14         dect  stack
0209 31AA C644  30         mov   tmp0,*stack           ; Push tmp0
0210 31AC 0649  14         dect  stack
0211 31AE C645  30         mov   tmp1,*stack           ; Push tmp1
0212 31B0 0649  14         dect  stack
0213 31B2 C646  30         mov   tmp2,*stack           ; Push tmp2
0214                       ;------------------------------------------------------
0215                       ; Determine SAMS index page
0216                       ;------------------------------------------------------
0217 31B4 C184  18         mov   tmp0,tmp2             ; Line number
0218 31B6 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0219 31B8 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     31BA 0800 
0220               
0221 31BC 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0222                                                   ; | tmp1 = quotient  (SAMS page offset)
0223                                                   ; / tmp2 = remainder
0224               
0225 31BE 0A16  56         sla   tmp2,1                ; line number * 2
0226 31C0 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     31C2 2F30 
0227               
0228 31C4 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     31C6 A502 
0229 31C8 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     31CA A500 
0230               
0231 31CC 130E  14         jeq   _idx.samspage.get.exit
0232                                                   ; Yes, so exit
0233                       ;------------------------------------------------------
0234                       ; Activate SAMS index page
0235                       ;------------------------------------------------------
0236 31CE C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31D0 A500 
0237 31D2 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31D4 A006 
0238               
0239 31D6 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0240 31D8 0205  20         li    tmp1,>b000            ; Memory window for index page
     31DA B000 
0241               
0242 31DC 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31DE 257A 
0243                                                   ; \ i  tmp0 = SAMS page
0244                                                   ; / i  tmp1 = Memory address
0245                       ;------------------------------------------------------
0246                       ; Check if new highest SAMS index page
0247                       ;------------------------------------------------------
0248 31E0 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31E2 A504 
0249 31E4 1202  14         jle   _idx.samspage.get.exit
0250                                                   ; No, exit
0251 31E6 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31E8 A504 
0252                       ;------------------------------------------------------
0253                       ; Exit
0254                       ;------------------------------------------------------
0255               _idx.samspage.get.exit:
0256 31EA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0257 31EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0258 31EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0259 31F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0260 31F2 045B  20         b     *r11                  ; Return to caller
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
0022 31F4 0649  14         dect  stack
0023 31F6 C64B  30         mov   r11,*stack            ; Save return address
0024 31F8 0649  14         dect  stack
0025 31FA C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31FC 0204  20         li    tmp0,edb.top          ; \
     31FE C000 
0030 3200 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3202 A200 
0031 3204 C804  38         mov   tmp0,@edb.next_free.ptr
     3206 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 3208 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     320A A20A 
0035               
0036 320C 0204  20         li    tmp0,1
     320E 0001 
0037 3210 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     3212 A204 
0038               
0039 3214 0720  34         seto  @edb.block.m1         ; Reset block start line
     3216 A20C 
0040 3218 0720  34         seto  @edb.block.m2         ; Reset block end line
     321A A20E 
0041               
0042 321C 0204  20         li    tmp0,txt.newfile      ; "New file"
     321E 352C 
0043 3220 C804  38         mov   tmp0,@edb.filename.ptr
     3222 A212 
0044               
0045 3224 0204  20         li    tmp0,txt.filetype.none
     3226 35E6 
0046 3228 C804  38         mov   tmp0,@edb.filetype.ptr
     322A A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 322C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 322E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3230 045B  20         b     *r11                  ; Return to caller
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
0022 3232 0649  14         dect  stack
0023 3234 C64B  30         mov   r11,*stack            ; Save return address
0024 3236 0649  14         dect  stack
0025 3238 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 323A 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     323C D000 
0030 323E C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3240 A300 
0031               
0032 3242 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3244 A302 
0033 3246 0204  20         li    tmp0,4
     3248 0004 
0034 324A C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     324C A306 
0035 324E C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3250 A308 
0036               
0037 3252 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3254 A316 
0038 3256 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3258 A318 
0039 325A 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     325C A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 325E 06A0  32         bl    @film
     3260 223A 
0044 3262 D000             data  cmdb.top,>00,cmdb.size
     3264 0000 
     3266 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3268 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 326A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 326C 045B  20         b     *r11                  ; Return to caller
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
0022 326E 0649  14         dect  stack
0023 3270 C64B  30         mov   r11,*stack            ; Save return address
0024 3272 0649  14         dect  stack
0025 3274 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3276 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3278 A028 
0030               
0031 327A 06A0  32         bl    @film
     327C 223A 
0032 327E A02A                   data tv.error.msg,0,160
     3280 0000 
     3282 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3284 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3286 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3288 045B  20         b     *r11                  ; Return to caller
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
0022 328A 0649  14         dect  stack
0023 328C C64B  30         mov   r11,*stack            ; Save return address
0024 328E 0649  14         dect  stack
0025 3290 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3292 0204  20         li    tmp0,1                ; \ Set default color scheme
     3294 0001 
0030 3296 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3298 A012 
0031               
0032 329A 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     329C A024 
0033 329E E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     32A0 200C 
0034               
0035 32A2 0204  20         li    tmp0,fj.bottom
     32A4 F000 
0036 32A6 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32A8 A026 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 32AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 32AC C2F9  30         mov   *stack+,r11           ; Pop R11
0043 32AE 045B  20         b     *r11                  ; Return to caller
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
0065 32B0 0649  14         dect  stack
0066 32B2 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 32B4 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32B6 3232 
0071 32B8 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32BA 31F4 
0072 32BC 06A0  32         bl    @idx.init             ; Initialize index
     32BE 30F4 
0073 32C0 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32C2 3092 
0074 32C4 06A0  32         bl    @errline.init         ; Initialize error line
     32C6 326E 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 32C8 06A0  32         bl    @hchar
     32CA 27C6 
0079 32CC 0034                   byte 0,52,32,18           ; Remove markers
     32CE 2012 
0080 32D0 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     32D2 2032 
0081 32D4 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32D6 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32D8 045B  20         b     *r11                  ; Return to caller
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
0020 32DA 0649  14         dect  stack
0021 32DC C64B  30         mov   r11,*stack            ; Save return address
0022 32DE 0649  14         dect  stack
0023 32E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32E2 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32E4 29D8 
0028 32E6 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32E8 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32EA 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32EC 0204  20         li    tmp0,unpacked.string
     32EE 2F44 
0034 32F0 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32F2 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32F4 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32F6 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32F8 2A30 
0039 32FA 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32FC 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32FE 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 3300 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 3302 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3304 045B  20         b     *r11                  ; Return to caller
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
0073 3306 0649  14         dect  stack
0074 3308 C64B  30         mov   r11,*stack            ; Push return address
0075 330A 0649  14         dect  stack
0076 330C C644  30         mov   tmp0,*stack           ; Push tmp0
0077 330E 0649  14         dect  stack
0078 3310 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 3312 0649  14         dect  stack
0080 3314 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 3316 0649  14         dect  stack
0082 3318 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Asserts
0085                       ;------------------------------------------------------
0086 331A C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     331C 2F20 
0087 331E D194  26         movb  *tmp0,tmp2            ; /
0088 3320 0986  56         srl   tmp2,8                ; Right align
0089 3322 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 3324 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3326 2F22 
0092 3328 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 332A C120  34         mov   @parm1,tmp0           ; Get source address
     332C 2F20 
0097 332E C160  34         mov   @parm4,tmp1           ; Get destination address
     3330 2F26 
0098 3332 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3334 0649  14         dect  stack
0101 3336 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 3338 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     333A 24E4 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 333C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 333E C120  34         mov   @parm2,tmp0           ; Get requested length
     3340 2F22 
0113 3342 0A84  56         sla   tmp0,8                ; Left align
0114 3344 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3346 2F26 
0115 3348 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 334A A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 334C 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 334E C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3350 2F22 
0122 3352 6187  18         s     tmp3,tmp2             ; |
0123 3354 0586  14         inc   tmp2                  ; /
0124               
0125 3356 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3358 2F24 
0126 335A 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 335C DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 335E 0606  14         dec   tmp2                  ; Update loop counter
0133 3360 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 3362 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3364 2F26 
     3366 2F30 
0136 3368 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 336A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     336C FFCE 
0142 336E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3370 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 3372 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3374 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3376 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 3378 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 337A C2F9  30         mov   *stack+,r11           ; Pop r11
0152 337C 045B  20         b     *r11                  ; Return to caller
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
0017 337E 0649  14         dect  stack
0018 3380 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 3382 06A0  32         bl    @sams.layout
     3384 25E6 
0023 3386 33B6                   data mem.sams.layout.data
0024               
0025 3388 06A0  32         bl    @sams.layout.copy
     338A 264A 
0026 338C A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 338E C820  54         mov   @tv.sams.c000,@edb.sams.page
     3390 A008 
     3392 A216 
0029 3394 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     3396 A216 
     3398 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 339A C2F9  30         mov   *stack+,r11           ; Pop r11
0036 339C 045B  20         b     *r11                  ; Return to caller
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
0033 339E 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     33A0 003F 
     33A2 0243 
     33A4 05F4 
     33A6 0050 
0034               
0035               romsat:
0036 33A8 0000             data  >0000,>0001             ; Cursor YX, initial shape and colour
     33AA 0001 
0037 33AC 0000             data  >0000,>0301             ; Current line indicator
     33AE 0301 
0038 33B0 0820             data  >0820,>0401             ; Current line indicator
     33B2 0401 
0039               nosprite:
0040 33B4 D000             data  >d000                   ; End-of-Sprites list
0041               
0042               
0043               ***************************************************************
0044               * SAMS page layout table for Stevie (16 words)
0045               *--------------------------------------------------------------
0046               mem.sams.layout.data:
0047 33B6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33B8 0002 
0048 33BA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33BC 0003 
0049 33BE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     33C0 000A 
0050               
0051 33C2 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     33C4 0010 
0052                                                   ; \ The index can allocate
0053                                                   ; / pages >10 to >2f.
0054               
0055 33C6 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     33C8 0030 
0056                                                   ; \ Editor buffer can allocate
0057                                                   ; / pages >30 to >ff.
0058               
0059 33CA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     33CC 000D 
0060 33CE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     33D0 000E 
0061 33D2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     33D4 000F 
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
0117 33D6 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     33D8 F171 
     33DA 1B1F 
     33DC 71B1 
0118 33DE A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     33E0 F0FF 
     33E2 1F1A 
     33E4 F1FF 
0119 33E6 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     33E8 F0FF 
     33EA 1F12 
     33EC F1F6 
0120 33EE F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     33F0 1E11 
     33F2 1A17 
     33F4 1E11 
0121 33F6 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     33F8 E1FF 
     33FA 1F1E 
     33FC E1FF 
0122 33FE 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     3400 1016 
     3402 1B71 
     3404 1711 
0123 3406 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     3408 1011 
     340A F1F1 
     340C 1F11 
0124 340E 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     3410 A1FF 
     3412 1F1F 
     3414 F11F 
0125 3416 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     3418 12FF 
     341A 1B12 
     341C 12FF 
0126 341E F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     3420 E1FF 
     3422 1B1F 
     3424 F131 
0127                       even
0128               
0129               tv.tabs.table:
0130 3426 0007             byte  0,7,12,25               ; \   Default tab positions as used
     3428 0C19 
0131 342A 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     342C 3B4F 
0132 342E FF00             byte  >ff,0,0,0               ; |
     3430 0000 
0133 3432 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     3434 0000 
0134 3436 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     3438 0000 
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
0012 343A 0B53             byte  11
0013 343B ....             text  'STEVIE 1.1H'
0014                       even
0015               
0016               txt.about.build
0017 3446 4C42             byte  76
0018 3447 ....             text  'Build: 210522-2891045 / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
0019                       even
0020               
0021               
0022               txt.delim
0023 3494 012C             byte  1
0024 3495 ....             text  ','
0025                       even
0026               
0027               txt.bottom
0028 3496 0520             byte  5
0029 3497 ....             text  '  BOT'
0030                       even
0031               
0032               txt.ovrwrite
0033 349C 034F             byte  3
0034 349D ....             text  'OVR'
0035                       even
0036               
0037               txt.insert
0038 34A0 0349             byte  3
0039 34A1 ....             text  'INS'
0040                       even
0041               
0042               txt.star
0043 34A4 012A             byte  1
0044 34A5 ....             text  '*'
0045                       even
0046               
0047               txt.loading
0048 34A6 0A4C             byte  10
0049 34A7 ....             text  'Loading...'
0050                       even
0051               
0052               txt.saving
0053 34B2 0A53             byte  10
0054 34B3 ....             text  'Saving....'
0055                       even
0056               
0057               txt.block.del
0058 34BE 1244             byte  18
0059 34BF ....             text  'Deleting block....'
0060                       even
0061               
0062               txt.block.copy
0063 34D2 1143             byte  17
0064 34D3 ....             text  'Copying block....'
0065                       even
0066               
0067               txt.block.move
0068 34E4 104D             byte  16
0069 34E5 ....             text  'Moving block....'
0070                       even
0071               
0072               txt.block.save
0073 34F6 1D53             byte  29
0074 34F7 ....             text  'Saving block to DV80 file....'
0075                       even
0076               
0077               txt.fastmode
0078 3514 0846             byte  8
0079 3515 ....             text  'Fastmode'
0080                       even
0081               
0082               txt.kb
0083 351E 026B             byte  2
0084 351F ....             text  'kb'
0085                       even
0086               
0087               txt.lines
0088 3522 054C             byte  5
0089 3523 ....             text  'Lines'
0090                       even
0091               
0092               txt.bufnum
0093 3528 0323             byte  3
0094 3529 ....             text  '#1 '
0095                       even
0096               
0097               txt.newfile
0098 352C 0A5B             byte  10
0099 352D ....             text  '[New file]'
0100                       even
0101               
0102               txt.filetype.dv80
0103 3538 0444             byte  4
0104 3539 ....             text  'DV80'
0105                       even
0106               
0107               txt.m1
0108 353E 034D             byte  3
0109 353F ....             text  'M1='
0110                       even
0111               
0112               txt.m2
0113 3542 034D             byte  3
0114 3543 ....             text  'M2='
0115                       even
0116               
0117               txt.keys.default
0118 3546 135E             byte  19
0119 3547 ....             text  '^Help, ^Open, ^Save'
0120                       even
0121               
0122               txt.keys.block
0123 355A 2B5E             byte  43
0124 355B ....             text  '^Del, ^Copy, ^Move, ^Goto M1, ^Reset, ^Save'
0125                       even
0126               
0127 3586 ....     txt.ruler          text    '.........'
0128                                  byte    18
0129 3590 ....                        text    '.........'
0130                                  byte    19
0131 359A ....                        text    '.........'
0132                                  byte    20
0133 35A4 ....                        text    '.........'
0134                                  byte    21
0135 35AE ....                        text    '.........'
0136                                  byte    22
0137 35B8 ....                        text    '.........'
0138                                  byte    23
0139 35C2 ....                        text    '.........'
0140                                  byte    24
0141 35CC ....                        text    '.........'
0142                                  byte    25
0143                                  even
0144               
0145 35D6 020E     txt.alpha.down     data >020e,>0f00
     35D8 0F00 
0146 35DA 0110     txt.vertline       data >0110
0147               
0148               txt.ws1
0149 35DC 0120             byte  1
0150 35DD ....             text  ' '
0151                       even
0152               
0153               txt.ws2
0154 35DE 0220             byte  2
0155 35DF ....             text  '  '
0156                       even
0157               
0158               txt.ws3
0159 35E2 0320             byte  3
0160 35E3 ....             text  '   '
0161                       even
0162               
0163               txt.ws4
0164 35E6 0420             byte  4
0165 35E7 ....             text  '    '
0166                       even
0167               
0168               txt.ws5
0169 35EC 0520             byte  5
0170 35ED ....             text  '     '
0171                       even
0172               
0173      35E6     txt.filetype.none  equ txt.ws4
0174               
0175               
0176               ;--------------------------------------------------------------
0177               ; Dialog Load DV 80 file
0178               ;--------------------------------------------------------------
0179 35F2 1301     txt.head.load      byte 19,1,3,32
     35F4 0320 
0180 35F6 ....                        text 'Open DV80 file '
0181                                  byte 2
0182               txt.hint.load
0183 3606 4746             byte  71
0184 3607 ....             text  'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0185                       even
0186               
0187               txt.keys.load
0188 364E 3246             byte  50
0189 364F ....             text  'F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '
0190                       even
0191               
0192               txt.keys.load2
0193 3682 3246             byte  50
0194 3683 ....             text  'F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End'
0195                       even
0196               
0197               
0198               ;--------------------------------------------------------------
0199               ; Dialog Save DV 80 file
0200               ;--------------------------------------------------------------
0201 36B6 1301     txt.head.save      byte 19,1,3,32
     36B8 0320 
0202 36BA ....                        text 'Save DV80 file '
0203                                  byte 2
0204 36CA 2301     txt.head.save2     byte 35,1,3,32
     36CC 0320 
0205 36CE ....                        text 'Save marked block to DV80 file '
0206                                  byte 2
0207               txt.hint.save
0208 36EE 0120             byte  1
0209 36EF ....             text  ' '
0210                       even
0211               
0212               txt.keys.save
0213 36F0 2446             byte  36
0214 36F1 ....             text  'F9=Back, F3=Clear, F-H=Home, F-L=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog "Unsaved changes"
0220               ;--------------------------------------------------------------
0221 3716 1401     txt.head.unsaved   byte 20,1,3,32
     3718 0320 
0222 371A ....                        text 'Unsaved changes '
0223 372A 0221                        byte 2
0224               txt.info.unsaved
0225                       byte  33
0226 372C ....             text  'Warning! Unsaved changes in file.'
0227                       even
0228               
0229               txt.hint.unsaved
0230 374E 2A50             byte  42
0231 374F ....             text  'Press F6 to proceed or ENTER to save file.'
0232                       even
0233               
0234               txt.keys.unsaved
0235 377A 2446             byte  36
0236 377B ....             text  'F9=Back, F6=Proceed, ENTER=Save file'
0237                       even
0238               
0239               
0240               ;--------------------------------------------------------------
0241               ; Dialog "About"
0242               ;--------------------------------------------------------------
0243 37A0 0A01     txt.head.about     byte 10,1,3,32
     37A2 0320 
0244 37A4 ....                        text 'About '
0245 37AA 0200                        byte 2
0246               
0247               txt.info.about
0248                       byte  0
0249 37AC ....             text
0250                       even
0251               
0252               txt.hint.about
0253 37AC 2650             byte  38
0254 37AD ....             text  'Press F9 or ENTER to return to editor.'
0255                       even
0256               
0257 37D4 2746     txt.keys.about     byte 39
0258 37D5 ....                        text 'F9=Back, ENTER=Back, '
0259 37EA 0E0F                        byte 14,15
0260 37EC ....                        text '=Alpha Lock down'
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for error line pane
0264               ;--------------------------------------------------------------
0265               txt.ioerr.load
0266 37FC 2049             byte  32
0267 37FD ....             text  'I/O error. Failed loading file: '
0268                       even
0269               
0270               txt.ioerr.save
0271 381E 2049             byte  32
0272 381F ....             text  'I/O error. Failed saving file:  '
0273                       even
0274               
0275               txt.memfull.load
0276 3840 4049             byte  64
0277 3841 ....             text  'Index memory full. Could not fully load file into editor buffer.'
0278                       even
0279               
0280               txt.io.nofile
0281 3882 2149             byte  33
0282 3883 ....             text  'I/O error. No filename specified.'
0283                       even
0284               
0285               txt.block.inside
0286 38A4 3445             byte  52
0287 38A5 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0288                       even
0289               
0290               
0291               ;--------------------------------------------------------------
0292               ; Strings for command buffer
0293               ;--------------------------------------------------------------
0294               txt.cmdb.prompt
0295 38DA 013E             byte  1
0296 38DB ....             text  '>'
0297                       even
0298               
0299               txt.colorscheme
0300 38DC 0D43             byte  13
0301 38DD ....             text  'Color scheme:'
0302                       even
0303               
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
0022 38EA DEAD             data  >dead,>beef,>dead,>beef
     38EC BEEF 
     38EE DEAD 
     38F0 BEEF 
**** **** ****     > stevie_b3.asm.2891045
0060               ***************************************************************
0061               * Step 4: Include main editor modules
0062               ********|*****|*********************|**************************
0063               main:
0064                       aorg  kickstart.code2       ; >6036
0065 6036 06A0  32         bl    @cpu.crash            ; Should never get here
     6038 2026 
0066                       ;-----------------------------------------------------------------------
0067                       ; Include files - Shared code
0068                       ;-----------------------------------------------------------------------
0069               
0070                       ;-----------------------------------------------------------------------
0071                       ; Include files - Dialogs
0072                       ;-----------------------------------------------------------------------
0073                       copy  "dialog.about.asm"    ; Dialog "About"
**** **** ****     > dialog.about.asm
0001               * FILE......: dialog.about.asm
0002               * Purpose...: Stevie Editor - About dialog
0003               
0004               *---------------------------------------------------------------
0005               * Show Stevie welcome/about dialog
0006               *---------------------------------------------------------------
0007               dialog.about:
0008 603A 0649  14         dect  stack
0009 603C C64B  30         mov   r11,*stack            ; Save return address
0010                       ;-------------------------------------------------------
0011                       ; Setup dialog
0012                       ;-------------------------------------------------------
0013 603E 06A0  32         bl    @scroff               ; turn screen off
     6040 2692 
0014               
0015 6042 0204  20         li    tmp0,id.dialog.about
     6044 0067 
0016 6046 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6048 A31A 
0017               
0018 604A 06A0  32         bl    @dialog.about.content ; display content in modal dialog
     604C 6076 
0019               
0020 604E 0204  20         li    tmp0,txt.head.about
     6050 37A0 
0021 6052 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6054 A31C 
0022               
0023 6056 0204  20         li    tmp0,txt.about.build
     6058 3446 
0024 605A C804  38         mov   tmp0,@cmdb.paninfo    ; Info line
     605C A31E 
0025               
0026 605E 0204  20         li    tmp0,txt.hint.about
     6060 37AC 
0027 6062 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6064 A320 
0028               
0029 6066 0204  20         li    tmp0,txt.keys.about
     6068 37D4 
0030 606A C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     606C A322 
0031               
0032 606E 06A0  32         bl    @scron                ; Turn screen on
     6070 269A 
0033                       ;------------------------------------------------------
0034                       ; Exit
0035                       ;------------------------------------------------------
0036               dialog.about.exit:
0037 6072 C2F9  30         mov   *stack+,r11           ; Pop r11
0038 6074 045B  20         b     *r11                  ; Return
0039               
0040               
0041               
0042               ***************************************************************
0043               * dialog.about.content
0044               * Show content in modal dialog
0045               ***************************************************************
0046               * bl  @dialog.about.content
0047               *--------------------------------------------------------------
0048               * OUTPUT
0049               * none
0050               *--------------------------------------------------------------
0051               * Register usage
0052               * tmp0
0053               ********|*****|*********************|**************************
0054               dialog.about.content:
0055 6076 0649  14         dect  stack
0056 6078 C64B  30         mov   r11,*stack            ; Save return address
0057 607A 0649  14         dect  stack
0058 607C C644  30         mov   tmp0,*stack           ; Push tmp0
0059 607E 0649  14         dect  stack
0060 6080 C645  30         mov   tmp1,*stack           ; Push tmp1
0061 6082 0649  14         dect  stack
0062 6084 C646  30         mov   tmp2,*stack           ; Push tmp2
0063 6086 0649  14         dect  stack
0064 6088 C660  46         mov   @wyx,*stack           ; Push cursor position
     608A 832A 
0065                       ;------------------------------------------------------
0066                       ; Show About dialog
0067                       ;------------------------------------------------------
0068 608C 06A0  32         bl    @hchar
     608E 27C6 
0069 6090 0000                   byte 0,0,32,50
     6092 2032 
0070 6094 FFFF                   data eol              ; Clear filename
0071               
0072 6096 06A0  32         bl    @putat
     6098 2446 
0073 609A 0000                   byte   0,0
0074 609C 343A                   data   txt.stevie     ; Show Stevie version
0075               
0076 609E 06A0  32         bl    @filv
     60A0 2292 
0077 60A2 0050                   data vdp.fb.toprow.sit,32,vdp.sit.size.80x30 - 160
     60A4 0020 
     60A6 08C0 
0078                                                   ; Clear screen
0079               
0080 60A8 06A0  32         bl    @filv
     60AA 2292 
0081 60AC 2180                   data sprsat,0,32      ; Turn off sprites
     60AE 0000 
     60B0 0020 
0082               
0083                       ;------------------------------------------------------
0084                       ; Display keyboard shortcuts (part 1)
0085                       ;------------------------------------------------------
0086 60B2 0204  20         li    tmp0,>0200            ; Y=2, X=0
     60B4 0200 
0087 60B6 C804  38         mov   tmp0,@wyx             ; Set cursor position
     60B8 832A 
0088 60BA 0205  20         li    tmp1,dialog.about.help.part1
     60BC 60E8 
0089                                                   ; Pointer to string
0090 60BE 0206  20         li    tmp2,21               ; Set loop counter
     60C0 0015 
0091               
0092 60C2 06A0  32         bl    @putlst               ; Loop over string list and display
     60C4 244E 
0093                                                   ; \ i  @wyx = Cursor position
0094                                                   ; | i  tmp1 = Pointer to first length-
0095                                                   ; |           prefixed string in list
0096                                                   ; / i  tmp2 = Number of strings to display
0097               
0098                       ;------------------------------------------------------
0099                       ; Display keyboard shortcuts (part 2)
0100                       ;------------------------------------------------------
0101 60C6 0204  20         li    tmp0,>032c            ; Y=3, X=44
     60C8 032C 
0102 60CA C804  38         mov   tmp0,@wyx             ; Set cursor position
     60CC 832A 
0103 60CE 0205  20         li    tmp1,dialog.about.help.part2
     60D0 634E 
0104                                                   ; Pointer to string
0105 60D2 0206  20         li    tmp2,19               ; Set loop counter
     60D4 0013 
0106               
0107 60D6 06A0  32         bl    @putlst               ; Loop over string list and display
     60D8 244E 
0108                                                   ; \ i  @wyx = Cursor position
0109                                                   ; | i  tmp1 = Pointer to first length-
0110                                                   ; |           prefixed string in list
0111                                                   ; / i  tmp2 = Number of strings to display
0112               
0113                       ;------------------------------------------------------
0114                       ; Exit
0115                       ;------------------------------------------------------
0116               dialog.about.content.exit:
0117 60DA C839  50         mov   *stack+,@wyx          ; Pop cursor position
     60DC 832A 
0118 60DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0119 60E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0120 60E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0121 60E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0122 60E6 045B  20         b     *r11                  ; Return
0123               
0124               
0125               
0126               dialog.about.help.part1:
0127               
0128 60E8 0E4D             byte  14
0129 60E9 ....             text  'Movement keys:'
0130                       even
0131               
0132               
0133 60F8 1C20             byte  28
0134 60F9 ....             text  '   Fctn S        Cursor left'
0135                       even
0136               
0137               
0138 6116 1D20             byte  29
0139 6117 ....             text  '   Fctn D        Cursor right'
0140                       even
0141               
0142               
0143 6134 1A20             byte  26
0144 6135 ....             text  '   Fctn E        Cursor up'
0145                       even
0146               
0147               
0148 6150 1C20             byte  28
0149 6151 ....             text  '   Fctn X        Cursor down'
0150                       even
0151               
0152               
0153 616E 1C20             byte  28
0154 616F ....             text  '   Fctn H        Cursor home'
0155                       even
0156               
0157               
0158 618C 2520             byte  37
0159 618D ....             text  '   Fctn J        Cursor to prev. word'
0160                       even
0161               
0162               
0163 61B2 2420             byte  36
0164 61B3 ....             text  '   Fctn K        Cursor to next word'
0165                       even
0166               
0167               
0168 61D8 1E20             byte  30
0169 61D9 ....             text  '   Fctn L        Cursor to end'
0170                       even
0171               
0172               
0173 61F8 1820             byte  24
0174 61F9 ....             text  '   Ctrl E  (^e)  Page up'
0175                       even
0176               
0177               
0178 6212 1A20             byte  26
0179 6213 ....             text  '   Ctrl X  (^x)  Page down'
0180                       even
0181               
0182               
0183 622E 1920             byte  25
0184 622F ....             text  '   Ctrl T  (^t)  File top'
0185                       even
0186               
0187               
0188 6248 1C20             byte  28
0189 6249 ....             text  '   Ctrl B  (^b)  File bottom'
0190                       even
0191               
0192               
0193 6266 0120             byte  1
0194 6267 ....             text  ' '
0195                       even
0196               
0197               
0198 6268 0C41             byte  12
0199 6269 ....             text  'Action keys:'
0200                       even
0201               
0202               
0203 6276 1620             byte  22
0204 6277 ....             text  '   Fctn +         Quit'
0205                       even
0206               
0207               
0208 628E 1620             byte  22
0209 628F ....             text  '   Ctrl h (^h)    Help'
0210                       even
0211               
0212               
0213 62A6 1B20             byte  27
0214 62A7 ....             text  '   Ctrl o (^o)    Open file'
0215                       even
0216               
0217               
0218 62C2 1B20             byte  27
0219 62C3 ....             text  '   Ctrl s (^s)    Save file'
0220                       even
0221               
0222               
0223 62DE 2220             byte  34
0224 62DF ....             text  '   Ctrl v (^v)    Set M1/M2 marker'
0225                       even
0226               
0227               
0228 6302 2520             byte  37
0229 6303 ....             text  '   Ctrl r (^r)    Reset M1/M2 markers'
0230                       even
0231               
0232               
0233 6328 2520             byte  37
0234 6329 ....             text  '   Ctrl z (^z)    Cycle color schemes'
0235                       even
0236               
0237               
0238               dialog.about.help.part2:
0239               
0240 634E 2420             byte  36
0241 634F ....             text  '   Ctrl , (^,)    Load previous file'
0242                       even
0243               
0244               
0245 6374 2020             byte  32
0246 6375 ....             text  '   Ctrl . (^.)    Load next file'
0247                       even
0248               
0249               
0250 6396 1E20             byte  30
0251 6397 ....             text  '   ctrl u (^u)    Toggle ruler'
0252                       even
0253               
0254               
0255 63B6 0120             byte  1
0256 63B7 ....             text  ' '
0257                       even
0258               
0259               
0260 63B8 1142             byte  17
0261 63B9 ....             text  'Block operations:'
0262                       even
0263               
0264               
0265 63CA 1D20             byte  29
0266 63CB ....             text  '   Ctrl d (^d)   Delete block'
0267                       even
0268               
0269               
0270 63E8 1B20             byte  27
0271 63E9 ....             text  '   Ctrl c (^c)   Copy block'
0272                       even
0273               
0274               
0275 6404 1F20             byte  31
0276 6405 ....             text  '   Ctrl g (^g)   Goto marker M1'
0277                       even
0278               
0279               
0280 6424 1B20             byte  27
0281 6425 ....             text  '   Ctrl m (^m)   Move block'
0282                       even
0283               
0284               
0285 6440 2320             byte  35
0286 6441 ....             text  '   Ctrl s (^s)   Save block to file'
0287                       even
0288               
0289               
0290 6464 0120             byte  1
0291 6465 ....             text  ' '
0292                       even
0293               
0294               
0295 6466 0E4D             byte  14
0296 6467 ....             text  'Modifier keys:'
0297                       even
0298               
0299               
0300 6476 1C20             byte  28
0301 6477 ....             text  '   Fctn 1   Delete character'
0302                       even
0303               
0304               
0305 6494 1C20             byte  28
0306 6495 ....             text  '   Fctn 2   Insert character'
0307                       even
0308               
0309               
0310 64B2 1720             byte  23
0311 64B3 ....             text  '   Fctn 3   Delete line'
0312                       even
0313               
0314               
0315 64CA 1E20             byte  30
0316 64CB ....             text  '   Fctn 4   Delete end of line'
0317                       even
0318               
0319               
0320 64EA 1720             byte  23
0321 64EB ....             text  '   Fctn 5   Insert line'
0322                       even
0323               
0324               
0325 6502 1C20             byte  28
0326 6503 ....             text  '   Fctn 7   Move to next tab'
0327                       even
0328               
0329               
0330 6520 2320             byte  35
0331 6521 ....             text  '   Fctn .   Toggle Insert/Overwrite'
0332                       even
0333               
0334               
**** **** ****     > stevie_b3.asm.2891045
0074                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
**** **** ****     > dialog.load.asm
0001               * FILE......: dialog.load.asm
0002               * Purpose...: Dialog "Load DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.load
0006               * Open Dialog for loading DV 80 file
0007               ***************************************************************
0008               * b @dialog.load
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
0020               ********|*****|*********************|**************************
0021               dialog.load:
0022 6544 0649  14         dect  stack
0023 6546 C64B  30         mov   r11,*stack            ; Save return address
0024 6548 0649  14         dect  stack
0025 654A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Show dialog "Unsaved changes" if editor buffer dirty
0028                       ;-------------------------------------------------------
0029 654C C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     654E A206 
0030 6550 1303  14         jeq   dialog.load.setup     ; No, skip "Unsaved changes"
0031               
0032 6552 06A0  32         bl    @dialog.unsaved       ; Show dialog
     6554 6612 
0033 6556 1021  14         jmp   dialog.load.exit      ; Exit early
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037               dialog.load.setup:
0038 6558 0204  20         li    tmp0,id.dialog.load
     655A 000A 
0039 655C C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     655E A31A 
0040               
0041 6560 0204  20         li    tmp0,txt.head.load
     6562 35F2 
0042 6564 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6566 A31C 
0043               
0044 6568 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     656A A31E 
0045               
0046 656C 0204  20         li    tmp0,txt.hint.load
     656E 3606 
0047 6570 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     6572 A320 
0048               
0049 6574 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     6576 A44E 
0050 6578 1303  14         jeq   !
0051                       ;-------------------------------------------------------
0052                       ; Show that FastMode is on
0053                       ;-------------------------------------------------------
0054 657A 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     657C 3682 
0055 657E 1002  14         jmp   dialog.load.keylist
0056                       ;-------------------------------------------------------
0057                       ; Show that FastMode is off
0058                       ;-------------------------------------------------------
0059 6580 0204  20 !       li    tmp0,txt.keys.load
     6582 364E 
0060                       ;-------------------------------------------------------
0061                       ; Show dialog
0062                       ;-------------------------------------------------------
0063               dialog.load.keylist:
0064 6584 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6586 A322 
0065                       ;-------------------------------------------------------
0066                       ; Set cursor shape
0067                       ;-------------------------------------------------------
0068 6588 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     658A 6682 
0069 658C 0204  20         li    tmp0,>0100            ; Cursor CMDB insert mode
     658E 0100 
0070 6590 D804  38         movb  tmp0,@tv.curshape     ; Save cursor shape
     6592 A014 
0071 6594 C820  54         mov   @tv.curshape,@ramsat+2
     6596 A014 
     6598 2F5C 
0072                                                   ; Get cursor shape and color
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               dialog.load.exit:
0077 659A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0078 659C C2F9  30         mov   *stack+,r11           ; Pop R11
0079 659E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b3.asm.2891045
0075                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
**** **** ****     > dialog.save.asm
0001               * FILE......: dialog.save.asm
0002               * Purpose...: Dialog "Save DV80 file"
0003               
0004               ***************************************************************
0005               * dialog.save
0006               * Open Dialog for saving file
0007               ***************************************************************
0008               * b @dialog.save
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
0020               ********|*****|*********************|**************************
0021               dialog.save:
0022 65A0 0649  14         dect  stack
0023 65A2 C64B  30         mov   r11,*stack            ; Save return address
0024 65A4 0649  14         dect  stack
0025 65A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029 65A8 8820  54         c     @fb.row.dirty,@w$ffff
     65AA A10A 
     65AC 2022 
0030 65AE 1604  14         jne   !                     ; Skip crunching if clean
0031 65B0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65B2 664C 
0032 65B4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65B6 A10A 
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036 65B8 8820  54 !       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     65BA A20E 
     65BC 2022 
0037 65BE 1309  14         jeq   dialog.save.default   ; Yes, so show default dialog
0038                       ;-------------------------------------------------------
0039                       ; Setup dialog title
0040                       ;-------------------------------------------------------
0041 65C0 06A0  32         bl    @cmdb.cmd.clear       ; Clear current CMDB command
     65C2 6670 
0042               
0043 65C4 0204  20         li    tmp0,id.dialog.saveblock
     65C6 000C 
0044 65C8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     65CA A31A 
0045 65CC 0204  20         li    tmp0,txt.head.save2   ; Title "Save code block to DV80 file"
     65CE 36CA 
0046               
0047 65D0 1006  14         jmp   dialog.save.header
0048                       ;-------------------------------------------------------
0049                       ; Default dialog
0050                       ;-------------------------------------------------------
0051               dialog.save.default:
0052 65D2 0204  20         li    tmp0,id.dialog.save
     65D4 000B 
0053 65D6 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     65D8 A31A 
0054 65DA 0204  20         li    tmp0,txt.head.save    ; Title "Save DV80 file"
     65DC 36B6 
0055                       ;-------------------------------------------------------
0056                       ; Setup header
0057                       ;-------------------------------------------------------
0058               dialog.save.header:
0059 65DE C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     65E0 A31C 
0060               
0061 65E2 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     65E4 A31E 
0062               
0063 65E6 0204  20         li    tmp0,txt.hint.save
     65E8 36EE 
0064 65EA C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     65EC A320 
0065               
0066 65EE 0204  20         li    tmp0,txt.keys.save
     65F0 36F0 
0067 65F2 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     65F4 A322 
0068               
0069 65F6 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     65F8 A44E 
0070                       ;-------------------------------------------------------
0071                       ; Set cursor shape
0072                       ;-------------------------------------------------------
0073 65FA 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     65FC 6682 
0074 65FE 0204  20         li    tmp0,>0100            ; Cursor CMDB insert mode
     6600 0100 
0075 6602 D804  38         movb  tmp0,@tv.curshape     ; Save cursor shape
     6604 A014 
0076 6606 C820  54         mov   @tv.curshape,@ramsat+2
     6608 A014 
     660A 2F5C 
0077                                                   ; Get cursor shape and color
0078                       ;-------------------------------------------------------
0079                       ; Exit
0080                       ;-------------------------------------------------------
0081               dialog.save.exit:
0082 660C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0083 660E C2F9  30         mov   *stack+,r11           ; Pop R11
0084 6610 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b3.asm.2891045
0076                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
**** **** ****     > dialog.unsaved.asm
0001               * FILE......: dialog.unsaved.asm
0002               * Purpose...: Dialog "Unsaved changes"
0003               
0004               ***************************************************************
0005               * dialog.unsaved
0006               * Open Dialog "Unsaved changes"
0007               ***************************************************************
0008               * b @dialog.unsaved
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
0020               ********|*****|*********************|**************************
0021               dialog.unsaved:
0022 6612 0649  14         dect  stack
0023 6614 C64B  30         mov   r11,*stack            ; Save return address
0024 6616 0649  14         dect  stack
0025 6618 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;-------------------------------------------------------
0027                       ; Setup dialog
0028                       ;-------------------------------------------------------
0029 661A 0204  20         li    tmp0,id.dialog.unsaved
     661C 0065 
0030 661E C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     6620 A31A 
0031               
0032 6622 0204  20         li    tmp0,txt.head.unsaved
     6624 3716 
0033 6626 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     6628 A31C 
0034               
0035 662A 0204  20         li    tmp0,txt.info.unsaved
     662C 372B 
0036 662E C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     6630 A31E 
0037               
0038 6632 0204  20         li    tmp0,txt.hint.unsaved
     6634 374E 
0039 6636 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     6638 A320 
0040               
0041 663A 0204  20         li    tmp0,txt.keys.unsaved
     663C 377A 
0042 663E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     6640 A322 
0043               
0044 6642 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     6644 6694 
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               dialog.unsaved.exit:
0049 6646 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0050 6648 C2F9  30         mov   *stack+,r11           ; Pop R11
0051 664A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b3.asm.2891045
0077                       ;-----------------------------------------------------------------------
0078                       ; Stubs using trampoline
0079                       ;-----------------------------------------------------------------------
0080                       copy  "rom.stubs.bank3.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank3.asm
0001               * FILE......: rom.stubs.bank3.asm
0002               * Purpose...: Bank 3 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "edb.line.pack"
0006               * bank1 vec.10
0007               ********|*****|*********************|**************************
0008               edb.line.pack:
0009 664C 0649  14         dect  stack
0010 664E C64B  30         mov   r11,*stack            ; Save return address
0011                       ;------------------------------------------------------
0012                       ; Call function in bank 1
0013                       ;------------------------------------------------------
0014 6650 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6652 300C 
0015 6654 6002                   data bank1            ; | i  p0 = bank address
0016 6656 7FAE                   data vec.10           ; | i  p1 = Vector with target address
0017 6658 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0018                       ;------------------------------------------------------
0019                       ; Exit
0020                       ;------------------------------------------------------
0021 665A C2F9  30         mov   *stack+,r11           ; Pop r11
0022 665C 045B  20         b     *r11                  ; Return to caller
0023               
0024               
0025               ***************************************************************
0026               * Stub for "edkey.action.cmdb.show"
0027               * bank1 vec.15
0028               ********|*****|*********************|**************************
0029               edkey.action.cmdb.show:
0030 665E 0649  14         dect  stack
0031 6660 C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Call function in bank 1
0034                       ;------------------------------------------------------
0035 6662 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6664 300C 
0036 6666 6002                   data bank1            ; | i  p0 = bank address
0037 6668 7FB8                   data vec.15           ; | i  p1 = Vector with target address
0038 666A 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042 666C C2F9  30         mov   *stack+,r11           ; Pop r11
0043 666E 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               ***************************************************************
0047               * Stub for "cmdb.cmd.clear"
0048               * bank1 vec.19
0049               ********|*****|*********************|**************************
0050               cmdb.cmd.clear:
0051 6670 0649  14         dect  stack
0052 6672 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Call function in bank 1
0055                       ;------------------------------------------------------
0056 6674 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6676 300C 
0057 6678 6002                   data bank1            ; | i  p0 = bank address
0058 667A 7FC0                   data vec.19           ; | i  p1 = Vector with target address
0059 667C 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 667E C2F9  30         mov   *stack+,r11           ; Pop r11
0064 6680 045B  20         b     *r11                  ; Return to caller
0065               
0066               
0067               ***************************************************************
0068               * Stub for "pane.cursor.blink"
0069               * bank1 vec.28
0070               ********|*****|*********************|**************************
0071               pane.cursor.blink:
0072 6682 0649  14         dect  stack
0073 6684 C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Call function in bank 1
0076                       ;------------------------------------------------------
0077 6686 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6688 300C 
0078 668A 6002                   data bank1            ; | i  p0 = bank address
0079 668C 7FD2                   data vec.28           ; | i  p1 = Vector with target address
0080 668E 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084 6690 C2F9  30         mov   *stack+,r11           ; Pop r11
0085 6692 045B  20         b     *r11                  ; Return to caller
0086               
0087               ***************************************************************
0088               * Stub for "pane.cursor.hide"
0089               * bank1 vec.29
0090               ********|*****|*********************|**************************
0091               pane.cursor.hide:
0092 6694 0649  14         dect  stack
0093 6696 C64B  30         mov   r11,*stack            ; Save return address
0094                       ;------------------------------------------------------
0095                       ; Call function in bank 1
0096                       ;------------------------------------------------------
0097 6698 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     669A 300C 
0098 669C 6002                   data bank1            ; | i  p0 = bank address
0099 669E 7FD4                   data vec.29           ; | i  p1 = Vector with target address
0100 66A0 6006                   data bankid           ; / i  p2 = Source ROM bank for return
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104 66A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0105 66A4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b3.asm.2891045
0081                       ;-----------------------------------------------------------------------
0082                       ; Bank specific vector table
0083                       ;-----------------------------------------------------------------------
0087 66A6 66A6                   data $                ; Bank 1 ROM size OK.
0089                       ;-------------------------------------------------------
0090                       ; Vector table bank 3: >7f9c - >7fff
0091                       ;-------------------------------------------------------
0092                       copy  "rom.vectors.bank3.asm"
**** **** ****     > rom.vectors.bank3.asm
0001               * FILE......: rom.vectors.bank3.asm
0002               * Purpose...: Bank 3 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 603A     vec.1   data  dialog.about          ; Dialog "About"
0010 7F9E 6544     vec.2   data  dialog.load           ; Dialog "Load DV80 file"
0011 7FA0 65A0     vec.3   data  dialog.save           ; Dialog "Save DV80 file"
0012 7FA2 6612     vec.4   data  dialog.unsaved        ; Dialog "Unsaved changes"
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
**** **** ****     > stevie_b3.asm.2891045
0093               
0094               *--------------------------------------------------------------
0095               * Video mode configuration
0096               *--------------------------------------------------------------
0097      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0098      0004     spfbck  equ   >04                   ; Screen background color.
0099      339E     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0100      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0101      0050     colrow  equ   80                    ; Columns per row
0102      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0103      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0104      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0105      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

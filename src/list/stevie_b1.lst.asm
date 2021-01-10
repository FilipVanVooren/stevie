XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.395472
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 210110-395472
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
**** **** ****     > stevie_b1.asm.395472
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
0068               * VDP RAM
0069               *
0070               *     Mem range   Bytes    Hex    Purpose
0071               *     =========   =====   =====   =================================
0072               *     0000-095f    2400   >0960   PNT - Pattern Name Table
0073               *     0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0074               *     0fc0                        PCT - Pattern Color Table
0075               *     1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0076               *     1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0077               *     2180                        SAT - Sprite Attribute List
0078               *     2800                        SPT - Sprite Pattern Table. On 2K boundary
0079               *
0080               *===============================================================================
0081               
0082               *--------------------------------------------------------------
0083               * Skip unused spectra2 code modules for reduced code size
0084               *--------------------------------------------------------------
0085      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0086      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0087      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0088      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0089      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0090      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0091      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0092      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0093      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0094      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0095      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0096      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0097      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0098      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0099      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0100      0001     skip_random_generator     equ  1       ; Skip random functions
0101      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0102      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0103               *--------------------------------------------------------------
0104               * Stevie specific equates
0105               *--------------------------------------------------------------
0106      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0107      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0108      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0109      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0110      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0111      1FD0     vdp.cmdb.toprow.tat       equ  >1fd0   ; VDP TAT address of 1st CMDB row
0112      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0113      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0114               *--------------------------------------------------------------
0115               * Stevie Dialog / Pane specific equates
0116               *--------------------------------------------------------------
0117      001D     pane.botrow               equ  29      ; Bottom row on screen
0118      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0119      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0120               ;-----------------------------------------------------------------
0121               ;   Dialog ID's >= 100 indicate that command prompt should be
0122               ;   hidden and no characters added to CMDB keyboard buffer
0123               ;-----------------------------------------------------------------
0124      000A     id.dialog.load            equ  10      ; ID dialog "Load DV80 file"
0125      000B     id.dialog.save            equ  11      ; ID dialog "Save DV80 file"
0126      000C     id.dialog.saveblock       equ  12      ; ID dialog "Save codeblock to DV80 file"
0127      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0128      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0129      0067     id.dialog.about           equ  103     ; ID dialog "About"
0130               *--------------------------------------------------------------
0131               * SPECTRA2 / Stevie startup options
0132               *--------------------------------------------------------------
0133      0001     debug                     equ  1       ; Turn on spectra2 debugging
0134      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0135      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0136      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0137               *--------------------------------------------------------------
0138               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0139               *--------------------------------------------------------------
0140      2F20     parm1             equ  >2f20           ; Function parameter 1
0141      2F22     parm2             equ  >2f22           ; Function parameter 2
0142      2F24     parm3             equ  >2f24           ; Function parameter 3
0143      2F26     parm4             equ  >2f26           ; Function parameter 4
0144      2F28     parm5             equ  >2f28           ; Function parameter 5
0145      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0146      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0147      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0148      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0149      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0150      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0151      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0152      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0153      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0154      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0155      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0156      2F40     keycode1          equ  >2f40           ; Current key scanned
0157      2F42     keycode2          equ  >2f42           ; Previous key scanned
0158      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0159      2F4A     timers            equ  >2f4a           ; Timer table
0160      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0161      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0162               *--------------------------------------------------------------
0163               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0164               *--------------------------------------------------------------
0165      A000     tv.top            equ  >a000           ; Structure begin
0166      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0167      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0168      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0169      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0170      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0171      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0172      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0173      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0174      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0175      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0176      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0177      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0178      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebufffer + bottom line
0179      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0180      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0181      A01E     tv.pane.focus     equ  tv.top + 30     ; Identify pane that has focus
0182      A020     tv.task.oneshot   equ  tv.top + 32     ; Pointer to one-shot routine
0183      A022     tv.fj.stackpnt    equ  tv.top + 34     ; Pointer to farjump return stack
0184      A024     tv.error.visible  equ  tv.top + 36     ; Error pane visible
0185      A026     tv.error.msg      equ  tv.top + 38     ; Error message (max. 160 characters)
0186      A0C6     tv.free           equ  tv.top + 198    ; End of structure
0187               *--------------------------------------------------------------
0188               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0189               *--------------------------------------------------------------
0190      A100     fb.struct         equ  >a100           ; Structure begin
0191      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0192      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0193      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0194                                                      ; line X in editor buffer).
0195      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0196                                                      ; (offset 0 .. @fb.scrrows)
0197      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0198      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0199      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0200      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0201      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0202      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0203      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0204      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0205      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0206      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0207      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0208      A11E     fb.free           equ  fb.struct + 30  ; End of structure
0209               *--------------------------------------------------------------
0210               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0211               *--------------------------------------------------------------
0212      A200     edb.struct        equ  >a200           ; Begin structure
0213      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0214      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0215      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0216      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0217      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0218      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0219      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0220      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0221      A210     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0222      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0223                                                      ; with current filename.
0224      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0225                                                      ; with current file type.
0226      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0227      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0228      A21A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0229                                                      ; for filename, but not always used.
0230      A269     edb.free          equ  edb.struct + 105; End of structure
0231               *--------------------------------------------------------------
0232               * Command buffer structure            @>a300-a3ff   (256 bytes)
0233               *--------------------------------------------------------------
0234      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0235      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0236      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0237      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0238      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0239      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0240      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0241      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0242      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0243      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0244      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0245      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0246      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0247      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0248      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0249      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0250      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0251      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0252      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0253      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0254      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0255      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0256      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0257               *--------------------------------------------------------------
0258               * File handle structure               @>a400-a4ff   (256 bytes)
0259               *--------------------------------------------------------------
0260      A400     fh.struct         equ  >a400           ; stevie file handling structures
0261               ;***********************************************************************
0262               ; ATTENTION
0263               ; The dsrlnk variables must form a continuous memory block and keep
0264               ; their order!
0265               ;***********************************************************************
0266      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0267      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0268      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0269      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0270      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0271      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0272      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0273      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0274      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0275      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0276      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0277      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0278      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0279      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0280      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0281      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0282      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0283      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0284      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0285      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0286      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0287      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0288      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0289      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0290      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0291      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0292      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0293      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0294      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0295      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0296      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0297               *--------------------------------------------------------------
0298               * Index structure                     @>a500-a5ff   (256 bytes)
0299               *--------------------------------------------------------------
0300      A500     idx.struct        equ  >a500           ; stevie index structure
0301      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0302      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0303      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0304               *--------------------------------------------------------------
0305               * Frame buffer                        @>a600-afff  (2560 bytes)
0306               *--------------------------------------------------------------
0307      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0308      0960     fb.size           equ  80*30           ; Frame buffer size
0309               *--------------------------------------------------------------
0310               * Index                               @>b000-bfff  (4096 bytes)
0311               *--------------------------------------------------------------
0312      B000     idx.top           equ  >b000           ; Top of index
0313      1000     idx.size          equ  4096            ; Index size
0314               *--------------------------------------------------------------
0315               * Editor buffer                       @>c000-cfff  (4096 bytes)
0316               *--------------------------------------------------------------
0317      C000     edb.top           equ  >c000           ; Editor buffer high memory
0318      1000     edb.size          equ  4096            ; Editor buffer size
0319               *--------------------------------------------------------------
0320               * Command history buffer              @>d000-dfff  (4096 bytes)
0321               *--------------------------------------------------------------
0322      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0323      1000     cmdb.size         equ  4096            ; Command buffer size
0324               *--------------------------------------------------------------
0325               * Heap                                @>e000-ebff  (3072 bytes)
0326               *--------------------------------------------------------------
0327      E000     heap.top          equ  >e000           ; Top of heap
0328               *--------------------------------------------------------------
0329               * Farjump return stack                @>ec00-efff  (1024 bytes)
0330               *--------------------------------------------------------------
0331      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b1.asm.395472
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
0027                       save  >6000,>7fff           ; Save bank 1
0028               *--------------------------------------------------------------
0029               * Cartridge header
0030               ********|*****|*********************|**************************
0031 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0032 6006 6010             data  $+10
0033 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0034 6010 0000             data  0                     ; No more items following
0035 6012 6030             data  kickstart.code1
0036               
0038               
0039 6014 0C53             byte  12
0040 6015 ....             text  'STEVIE V0.1I'
0041                       even
0042               
0050               
0051               ***************************************************************
0052               * Step 1: Switch to bank 0 (uniform code accross all banks)
0053               ********|*****|*********************|**************************
0054                       aorg  kickstart.code1       ; >6030
0055 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0056               ***************************************************************
0057               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0058               ********|*****|*********************|**************************
0059                       aorg  >2000
0060                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0260 21D3 ....             text  'Build-ID  210110-395472'
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
0089               * Sanity check
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
0024               *    Sanity check
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
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2554 0284  22         ci    tmp0,255              ; Crash if page > 255
     2556 00FF 
0153 2558 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
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
0164                       ; Sanity check on string length
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
0351 2E96 3350             data  spvmod                ; Equate selected video mode table
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
**** **** ****     > stevie_b1.asm.395472
0061                                                   ; Relocated spectra2 in low MEMEXP, was
0062                                                   ; copied to >2000 from ROM in bank 0
0063                       ;------------------------------------------------------
0064                       ; End of File marker
0065                       ;------------------------------------------------------
0066 2EBA DEAD             data >dead,>beef,>dead,>beef
     2EBC BEEF 
     2EBE DEAD 
     2EC0 BEEF 
0068               ***************************************************************
0069               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0070               ********|*****|*********************|**************************
0071                       aorg  >3000
0072                       ;------------------------------------------------------
0073                       ; Activate bank 1 and branch to  >6036
0074                       ;------------------------------------------------------
0075 3000 04E0  34         clr   @bank1                ; Activate bank 1 "James"
     3002 6002 
0076 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0077                       ;------------------------------------------------------
0078                       ; Resident Stevie modules: >3000 - >3fff
0079                       ;------------------------------------------------------
0080                       copy  "ram.resident.3000.asm"
**** **** ****     > ram.resident.3000.asm
0001               * FILE......: ram.resident.3000.asm
0002               * Purpose...: Resident modules at RAM >3000 callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules >3000 - >3fff
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"     ; ROM bankswitch trampoline
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
0061                       ; Sanity check 1 failed before bank-switch
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
0097                       ; Sanity check 2 failed after bank-switch
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
0008                       copy  "fb.asm"              ; Framebuffer
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
0009                       copy  "idx.asm"             ; Index management
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
0059 30E0 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     30E2 A504 
0060                       ;------------------------------------------------------
0061                       ; Clear index page
0062                       ;------------------------------------------------------
0063 30E4 06A0  32         bl    @film
     30E6 2238 
0064 30E8 B000                   data idx.top,>00,idx.size
     30EA 0000 
     30EC 1000 
0065                                                   ; Clear index
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               idx.init.exit:
0070 30EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0071 30F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0072 30F2 045B  20         b     *r11                  ; Return to caller
0073               
0074               
0075               
0076               ***************************************************************
0077               * _idx.sams.mapcolumn.on
0078               * Flatten SAMS index pages into continuous memory region.
0079               * Gives 20 KB of index space (2048 * 5 = 10240 lines for each
0080               * editor buffer).
0081               *
0082               * >b000  1st index page
0083               * >c000  2nd index page
0084               * >d000  3rd index page
0085               * >e000  4th index page
0086               * >f000  5th index page
0087               ***************************************************************
0088               * bl @_idx.sams.mapcolumn.on
0089               *--------------------------------------------------------------
0090               * Register usage
0091               * tmp0, tmp1, tmp2
0092               *--------------------------------------------------------------
0093               *  Remarks
0094               *  Private, only to be called from inside idx module
0095               ********|*****|*********************|**************************
0096               _idx.sams.mapcolumn.on:
0097 30F4 0649  14         dect  stack
0098 30F6 C64B  30         mov   r11,*stack            ; Push return address
0099 30F8 0649  14         dect  stack
0100 30FA C644  30         mov   tmp0,*stack           ; Push tmp0
0101 30FC 0649  14         dect  stack
0102 30FE C645  30         mov   tmp1,*stack           ; Push tmp1
0103 3100 0649  14         dect  stack
0104 3102 C646  30         mov   tmp2,*stack           ; Push tmp2
0105               *--------------------------------------------------------------
0106               * Map index pages into memory window  (b000-ffff)
0107               *--------------------------------------------------------------
0108 3104 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3106 A502 
0109 3108 0205  20         li    tmp1,idx.top
     310A B000 
0110               
0111 310C C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     310E A504 
0112 3110 0586  14         inc   tmp2                  ; +1 loop adjustment
0113 3112 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     3114 A502 
0114                       ;-------------------------------------------------------
0115                       ; Sanity check
0116                       ;-------------------------------------------------------
0117 3116 0286  22         ci    tmp2,5                ; Crash if too many index pages
     3118 0005 
0118 311A 1104  14         jlt   !
0119 311C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     311E FFCE 
0120 3120 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3122 2026 
0121                       ;-------------------------------------------------------
0122                       ; Loop over banks
0123                       ;-------------------------------------------------------
0124 3124 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3126 253C 
0125                                                   ; \ i  tmp0  = SAMS page number
0126                                                   ; / i  tmp1  = Memory address
0127               
0128 3128 0584  14         inc   tmp0                  ; Next SAMS index page
0129 312A 0225  22         ai    tmp1,>1000            ; Next memory region
     312C 1000 
0130 312E 0606  14         dec   tmp2                  ; Update loop counter
0131 3130 15F9  14         jgt   -!                    ; Next iteration
0132               *--------------------------------------------------------------
0133               * Exit
0134               *--------------------------------------------------------------
0135               _idx.sams.mapcolumn.on.exit:
0136 3132 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0137 3134 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0138 3136 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0139 3138 C2F9  30         mov   *stack+,r11           ; Pop return address
0140 313A 045B  20         b     *r11                  ; Return to caller
0141               
0142               
0143               ***************************************************************
0144               * _idx.sams.mapcolumn.off
0145               * Restore normal SAMS layout again (single index page)
0146               ***************************************************************
0147               * bl @_idx.sams.mapcolumn.off
0148               *--------------------------------------------------------------
0149               * Register usage
0150               * tmp0, tmp1, tmp2, tmp3
0151               *--------------------------------------------------------------
0152               *  Remarks
0153               *  Private, only to be called from inside idx module
0154               ********|*****|*********************|**************************
0155               _idx.sams.mapcolumn.off:
0156 313C 0649  14         dect  stack
0157 313E C64B  30         mov   r11,*stack            ; Push return address
0158 3140 0649  14         dect  stack
0159 3142 C644  30         mov   tmp0,*stack           ; Push tmp0
0160 3144 0649  14         dect  stack
0161 3146 C645  30         mov   tmp1,*stack           ; Push tmp1
0162 3148 0649  14         dect  stack
0163 314A C646  30         mov   tmp2,*stack           ; Push tmp2
0164 314C 0649  14         dect  stack
0165 314E C647  30         mov   tmp3,*stack           ; Push tmp3
0166               *--------------------------------------------------------------
0167               * Map index pages into memory window  (b000-?????)
0168               *--------------------------------------------------------------
0169 3150 0205  20         li    tmp1,idx.top
     3152 B000 
0170 3154 0206  20         li    tmp2,5                ; Always 5 pages
     3156 0005 
0171 3158 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     315A A006 
0172                       ;-------------------------------------------------------
0173                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0174                       ;-------------------------------------------------------
0175 315C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0176               
0177 315E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3160 253C 
0178                                                   ; \ i  tmp0  = SAMS page number
0179                                                   ; / i  tmp1  = Memory address
0180               
0181 3162 0225  22         ai    tmp1,>1000            ; Next memory region
     3164 1000 
0182 3166 0606  14         dec   tmp2                  ; Update loop counter
0183 3168 15F9  14         jgt   -!                    ; Next iteration
0184               *--------------------------------------------------------------
0185               * Exit
0186               *--------------------------------------------------------------
0187               _idx.sams.mapcolumn.off.exit:
0188 316A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0189 316C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0190 316E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0191 3170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0192 3172 C2F9  30         mov   *stack+,r11           ; Pop return address
0193 3174 045B  20         b     *r11                  ; Return to caller
0194               
0195               
0196               
0197               ***************************************************************
0198               * _idx.samspage.get
0199               * Get SAMS page for index
0200               ***************************************************************
0201               * bl @_idx.samspage.get
0202               *--------------------------------------------------------------
0203               * INPUT
0204               * tmp0 = Line number
0205               *--------------------------------------------------------------
0206               * OUTPUT
0207               * @outparm1 = Offset for index entry in index SAMS page
0208               *--------------------------------------------------------------
0209               * Register usage
0210               * tmp0, tmp1, tmp2
0211               *--------------------------------------------------------------
0212               *  Remarks
0213               *  Private, only to be called from inside idx module.
0214               *  Activates SAMS page containing required index slot entry.
0215               ********|*****|*********************|**************************
0216               _idx.samspage.get:
0217 3176 0649  14         dect  stack
0218 3178 C64B  30         mov   r11,*stack            ; Save return address
0219 317A 0649  14         dect  stack
0220 317C C644  30         mov   tmp0,*stack           ; Push tmp0
0221 317E 0649  14         dect  stack
0222 3180 C645  30         mov   tmp1,*stack           ; Push tmp1
0223 3182 0649  14         dect  stack
0224 3184 C646  30         mov   tmp2,*stack           ; Push tmp2
0225                       ;------------------------------------------------------
0226                       ; Determine SAMS index page
0227                       ;------------------------------------------------------
0228 3186 C184  18         mov   tmp0,tmp2             ; Line number
0229 3188 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0230 318A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     318C 0800 
0231               
0232 318E 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0233                                                   ; | tmp1 = quotient  (SAMS page offset)
0234                                                   ; / tmp2 = remainder
0235               
0236 3190 0A16  56         sla   tmp2,1                ; line number * 2
0237 3192 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3194 2F30 
0238               
0239 3196 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3198 A502 
0240 319A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     319C A500 
0241               
0242 319E 130E  14         jeq   _idx.samspage.get.exit
0243                                                   ; Yes, so exit
0244                       ;------------------------------------------------------
0245                       ; Activate SAMS index page
0246                       ;------------------------------------------------------
0247 31A0 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31A2 A500 
0248 31A4 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31A6 A006 
0249               
0250 31A8 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0251 31AA 0205  20         li    tmp1,>b000            ; Memory window for index page
     31AC B000 
0252               
0253 31AE 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31B0 253C 
0254                                                   ; \ i  tmp0 = SAMS page
0255                                                   ; / i  tmp1 = Memory address
0256                       ;------------------------------------------------------
0257                       ; Check if new highest SAMS index page
0258                       ;------------------------------------------------------
0259 31B2 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31B4 A504 
0260 31B6 1202  14         jle   _idx.samspage.get.exit
0261                                                   ; No, exit
0262 31B8 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31BA A504 
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266               _idx.samspage.get.exit:
0267 31BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0268 31BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0269 31C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0270 31C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0271 31C4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0010                       copy  "edb.asm"             ; Editor Buffer
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
0022 31C6 0649  14         dect  stack
0023 31C8 C64B  30         mov   r11,*stack            ; Save return address
0024 31CA 0649  14         dect  stack
0025 31CC C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31CE 0204  20         li    tmp0,edb.top          ; \
     31D0 C000 
0030 31D2 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31D4 A200 
0031 31D6 C804  38         mov   tmp0,@edb.next_free.ptr
     31D8 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 31DA 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31DC A20A 
0035               
0036 31DE 0204  20         li    tmp0,1
     31E0 0001 
0037 31E2 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31E4 A204 
0038               
0039 31E6 0720  34         seto  @edb.block.m1         ; Reset block start line
     31E8 A20C 
0040 31EA 0720  34         seto  @edb.block.m2         ; Reset block end line
     31EC A20E 
0041               
0042 31EE 0204  20         li    tmp0,txt.newfile      ; "New file"
     31F0 3674 
0043 31F2 C804  38         mov   tmp0,@edb.filename.ptr
     31F4 A212 
0044               
0045 31F6 0204  20         li    tmp0,txt.filetype.none
     31F8 36C2 
0046 31FA C804  38         mov   tmp0,@edb.filetype.ptr
     31FC A214 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 31FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 3200 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3202 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
**** **** ****     > ram.resident.3000.asm
0011                       copy  "cmdb.asm"            ; Command buffer
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
0022 3204 0649  14         dect  stack
0023 3206 C64B  30         mov   r11,*stack            ; Save return address
0024 3208 0649  14         dect  stack
0025 320A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 320C 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     320E D000 
0030 3210 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3212 A300 
0031               
0032 3214 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3216 A302 
0033 3218 0204  20         li    tmp0,4
     321A 0004 
0034 321C C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     321E A306 
0035 3220 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3222 A308 
0036               
0037 3224 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3226 A316 
0038 3228 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     322A A318 
0039 322C 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     322E A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 3230 06A0  32         bl    @film
     3232 2238 
0044 3234 D000             data  cmdb.top,>00,cmdb.size
     3236 0000 
     3238 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 323A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 323C C2F9  30         mov   *stack+,r11           ; Pop r11
0052 323E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0012                       copy  "errline.asm"         ; Error line
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
0022 3240 0649  14         dect  stack
0023 3242 C64B  30         mov   r11,*stack            ; Save return address
0024 3244 0649  14         dect  stack
0025 3246 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3248 04E0  34         clr   @tv.error.visible     ; Set to hidden
     324A A024 
0030               
0031 324C 06A0  32         bl    @film
     324E 2238 
0032 3250 A026                   data tv.error.msg,0,160
     3252 0000 
     3254 00A0 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               errline.exit:
0037 3256 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0038 3258 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 325A 045B  20         b     *r11                  ; Return to caller
0040               
**** **** ****     > ram.resident.3000.asm
0013                       copy  "tv.asm"              ; Main editor configuration
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
0022 325C 0649  14         dect  stack
0023 325E C64B  30         mov   r11,*stack            ; Save return address
0024 3260 0649  14         dect  stack
0025 3262 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3264 0204  20         li    tmp0,1                ; \ Set default color scheme
     3266 0001 
0030 3268 C804  38         mov   tmp0,@tv.colorscheme  ; /
     326A A012 
0031               
0032 326C 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     326E A020 
0033 3270 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3272 200C 
0034               
0035 3274 0204  20         li    tmp0,fj.bottom
     3276 F000 
0036 3278 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     327A A022 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 327C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 327E C2F9  30         mov   *stack+,r11           ; Pop R11
0043 3280 045B  20         b     *r11                  ; Return to caller
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
0065 3282 0649  14         dect  stack
0066 3284 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 3286 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3288 3204 
0071 328A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     328C 31C6 
0072 328E 06A0  32         bl    @idx.init             ; Initialize index
     3290 30C4 
0073 3292 06A0  32         bl    @fb.init              ; Initialize framebuffer
     3294 307A 
0074 3296 06A0  32         bl    @errline.init         ; Initialize error line
     3298 3240 
0075                       ;------------------------------------------------------
0076                       ; Remove markers and shortcuts
0077                       ;------------------------------------------------------
0078 329A 06A0  32         bl    @hchar
     329C 2788 
0079 329E 0034                   byte 0,52,32,18           ; Remove markers
     32A0 2012 
0080 32A2 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     32A4 2032 
0081 32A6 FFFF                   data eol
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               tv.reset.exit:
0086 32A8 C2F9  30         mov   *stack+,r11           ; Pop R11
0087 32AA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0014                       copy  "tv.utils.asm"        ; General purpose utility functions
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
0020 32AC 0649  14         dect  stack
0021 32AE C64B  30         mov   r11,*stack            ; Save return address
0022 32B0 0649  14         dect  stack
0023 32B2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32B4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32B6 299A 
0028 32B8 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32BA 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32BC 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32BE 0204  20         li    tmp0,unpacked.string
     32C0 2F44 
0034 32C2 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32C4 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32C6 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32C8 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32CA 29F2 
0039 32CC 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32CE 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32D0 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32D6 045B  20         b     *r11                  ; Return to caller
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
0073 32D8 0649  14         dect  stack
0074 32DA C64B  30         mov   r11,*stack            ; Push return address
0075 32DC 0649  14         dect  stack
0076 32DE C644  30         mov   tmp0,*stack           ; Push tmp0
0077 32E0 0649  14         dect  stack
0078 32E2 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 32E4 0649  14         dect  stack
0080 32E6 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 32E8 0649  14         dect  stack
0082 32EA C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Sanity checks
0085                       ;------------------------------------------------------
0086 32EC C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     32EE 2F20 
0087 32F0 D194  26         movb  *tmp0,tmp2            ; /
0088 32F2 0986  56         srl   tmp2,8                ; Right align
0089 32F4 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0090               
0091 32F6 8806  38         c     tmp2,@parm2           ; String length > requested length?
     32F8 2F22 
0092 32FA 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0093                       ;------------------------------------------------------
0094                       ; Copy string to buffer
0095                       ;------------------------------------------------------
0096 32FC C120  34         mov   @parm1,tmp0           ; Get source address
     32FE 2F20 
0097 3300 C160  34         mov   @parm4,tmp1           ; Get destination address
     3302 2F26 
0098 3304 0586  14         inc   tmp2                  ; Also include length-byte in copy
0099               
0100 3306 0649  14         dect  stack
0101 3308 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0102               
0103 330A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     330C 24A6 
0104                                                   ; \ i  tmp0 = Source CPU memory address
0105                                                   ; | i  tmp1 = Target CPU memory address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107               
0108 330E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0109                       ;------------------------------------------------------
0110                       ; Set length of new string
0111                       ;------------------------------------------------------
0112 3310 C120  34         mov   @parm2,tmp0           ; Get requested length
     3312 2F22 
0113 3314 0A84  56         sla   tmp0,8                ; Left align
0114 3316 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3318 2F26 
0115 331A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0116 331C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0117 331E 0585  14         inc   tmp1                  ; /
0118                       ;------------------------------------------------------
0119                       ; Prepare for padding string
0120                       ;------------------------------------------------------
0121 3320 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3322 2F22 
0122 3324 6187  18         s     tmp3,tmp2             ; |
0123 3326 0586  14         inc   tmp2                  ; /
0124               
0125 3328 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     332A 2F24 
0126 332C 0A84  56         sla   tmp0,8                ; Left align
0127                       ;------------------------------------------------------
0128                       ; Right-pad string to destination length
0129                       ;------------------------------------------------------
0130               tv.pad.string.loop:
0131 332E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0132 3330 0606  14         dec   tmp2                  ; Update loop counter
0133 3332 15FD  14         jgt   tv.pad.string.loop    ; Next character
0134               
0135 3334 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3336 2F26 
     3338 2F30 
0136 333A 1004  14         jmp   tv.pad.string.exit    ; Exit
0137                       ;-----------------------------------------------------------------------
0138                       ; CPU crash
0139                       ;-----------------------------------------------------------------------
0140               tv.pad.string.panic:
0141 333C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     333E FFCE 
0142 3340 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3342 2026 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               tv.pad.string.exit:
0147 3344 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0148 3346 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 3348 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 334A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 334C C2F9  30         mov   *stack+,r11           ; Pop r11
0152 334E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > ram.resident.3000.asm
0015                       copy  "data.constants.asm"  ; Data Constants
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
0033 3350 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3352 003F 
     3354 0243 
     3356 05F4 
     3358 0050 
0034               
0035               romsat:
0036 335A 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     335C 0001 
0037               
0038               cursors:
0039 335E 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     3360 0000 
     3362 0000 
     3364 001C 
0040 3366 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     3368 1010 
     336A 1010 
     336C 1000 
0041 336E 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     3370 1C1C 
     3372 1C1C 
     3374 1C00 
0042               
0043               patterns:
0044 3376 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     3378 0000 
     337A 00FF 
     337C 0000 
0045 337E 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     3380 0000 
     3382 FF00 
     3384 FF00 
0046               
0047               patterns.box:
0048 3386 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     3388 0000 
     338A FF00 
     338C FF00 
0049 338E 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     3390 0000 
     3392 FF80 
     3394 BFA0 
0050 3396 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     3398 0000 
     339A FC04 
     339C F414 
0051 339E A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     33A0 A0A0 
     33A2 A0A0 
     33A4 A0A0 
0052 33A6 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     33A8 1414 
     33AA 1414 
     33AC 1414 
0053 33AE A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     33B0 A0A0 
     33B2 BF80 
     33B4 FF00 
0054 33B6 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     33B8 1414 
     33BA F404 
     33BC FC00 
0055 33BE 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     33C0 C0C0 
     33C2 C0C0 
     33C4 0080 
0056 33C6 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     33C8 0F0F 
     33CA 0F0F 
     33CC 0000 
0057               
0058               
0059               patterns.cr:
0060 33CE 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     33D0 6C48 
     33D2 4800 
     33D4 7C00 
0061 33D6 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     33D8 64FC 
     33DA 6020 
     33DC 0000 
0062               
0063               
0064               alphalock:
0065 33DE 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     33E0 00E0 
     33E2 E0E0 
     33E4 E0E0 
0066 33E6 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     33E8 E0E0 
     33EA E0E0 
     33EC 0000 
0067               
0068               
0069               vertline:
0070 33EE 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     33F0 1010 
     33F2 1010 
     33F4 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 33F6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     33F8 0002 
0078 33FA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     33FC 0003 
0079 33FE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3400 000A 
0080               
0081 3402 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     3404 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 3406 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     3408 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 340A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     340C 000D 
0090 340E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     3410 000E 
0091 3412 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     3414 000F 
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
0147 3416 F417      data  >f417,>f171,>1b1f,>0000 ; 1  White on blue with inversed cyan border
     3418 F171 
     341A 1B1F 
     341C 0000 
0148 341E F41F      data  >f41f,>f011,>1a17,>0000 ; 2  White on blue with inversed white border
     3420 F011 
     3422 1A17 
     3424 0000 
0149 3426 A11A      data  >a11a,>f0ff,>1f1a,>0000 ; 3  Dark yellow on black with inversed border
     3428 F0FF 
     342A 1F1A 
     342C 0000 
0150 342E 2112      data  >2112,>f0ff,>1b12,>0000 ; 4  Dark green on black with inversed border
     3430 F0FF 
     3432 1B12 
     3434 0000 
0151 3436 E11E      data  >e11e,>f00f,>1b1e,>0000 ; 5  Grey on black with inversed grey border
     3438 F00F 
     343A 1B1E 
     343C 0000 
0152 343E 1771      data  >1771,>1006,>1b71,>0000 ; 6  Black on cyan with inversed black border
     3440 1006 
     3442 1B71 
     3444 0000 
0153 3446 1FF1      data  >1ff1,>1001,>1bf1,>0000 ; 7  Black on white with inversed black border
     3448 1001 
     344A 1BF1 
     344C 0000 
0154 344E A1F0      data  >a1f0,>1a0f,>1b1a,>0000 ; 8  Dark yellow on black with white border
     3450 1A0F 
     3452 1B1A 
     3454 0000 
0155 3456 21F0      data  >21f0,>f20f,>1b12,>0000 ; 9  Dark green on black with white border
     3458 F20F 
     345A 1B12 
     345C 0000 
0156               
**** **** ****     > ram.resident.3000.asm
0016                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 345E 0C53             byte  12
0013 345F ....             text  'Stevie V0.1I'
0014                       even
0015               
0016               txt.about.purpose
0017 346C 2350             byte  35
0018 346D ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 3490 1D32             byte  29
0023 3491 ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 34AE 1B68             byte  27
0028 34AF ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 34CA 1442             byte  20
0033 34CB ....             text  'Build: 210110-395472'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 34E0 2466             byte  36
0039 34E1 ....             text  'fctn-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 3506 2266             byte  34
0044 3507 ....             text  'fctn-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 352A 1966             byte  25
0049 352B ....             text  'fctn-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 3544 1C43             byte  28
0054 3545 ....             text  'CTRL-O (^O)   Open DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 3562 1C43             byte  28
0059 3563 ....             text  'CTRL-S (^S)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 3580 1A43             byte  26
0064 3581 ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 359C 380F     txt.about.msg7     byte    56,15
0069 359E ....                        text    ' ALPHA LOCK up     '
0070                                  byte    14
0071 35B2 ....                        text    ' ALPHA LOCK down   '
0072 35C5 ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 35D6 ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 35D8 052A             byte  5
0085 35D9 ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 35DE 0520             byte  5
0090 35DF ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 35E4 034F             byte  3
0095 35E5 ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 35E8 0349             byte  3
0100 35E9 ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 35EC 012A             byte  1
0105 35ED ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 35EE 0A4C             byte  10
0110 35EF ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 35FA 0A53             byte  10
0115 35FB ....             text  'Saving....'
0116                       even
0117               
0118               txt.block.del
0119 3606 1244             byte  18
0120 3607 ....             text  'Deleting block....'
0121                       even
0122               
0123               txt.block.copy
0124 361A 1143             byte  17
0125 361B ....             text  'Copying block....'
0126                       even
0127               
0128               txt.block.move
0129 362C 104D             byte  16
0130 362D ....             text  'Moving block....'
0131                       even
0132               
0133               txt.block.save
0134 363E 1D53             byte  29
0135 363F ....             text  'Saving block to DV80 file....'
0136                       even
0137               
0138               txt.fastmode
0139 365C 0846             byte  8
0140 365D ....             text  'Fastmode'
0141                       even
0142               
0143               txt.kb
0144 3666 026B             byte  2
0145 3667 ....             text  'kb'
0146                       even
0147               
0148               txt.lines
0149 366A 054C             byte  5
0150 366B ....             text  'Lines'
0151                       even
0152               
0153               txt.bufnum
0154 3670 0323             byte  3
0155 3671 ....             text  '#1 '
0156                       even
0157               
0158               txt.newfile
0159 3674 0A5B             byte  10
0160 3675 ....             text  '[New file]'
0161                       even
0162               
0163               txt.filetype.dv80
0164 3680 0444             byte  4
0165 3681 ....             text  'DV80'
0166                       even
0167               
0168               txt.m1
0169 3686 034D             byte  3
0170 3687 ....             text  'M1='
0171                       even
0172               
0173               txt.m2
0174 368A 034D             byte  3
0175 368B ....             text  'M2='
0176                       even
0177               
0178               
0179 368E 2D5E     txt.keys.block     byte    45
0180 368F ....                        text    '^Del  ^Copy  ^N=Move  ^Goto M1  ^Reset  ^Save'
0181               
0182 36BC 010F     txt.alpha.up       data >010f
0183 36BE 010E     txt.alpha.down     data >010e
0184 36C0 0110     txt.vertline       data >0110
0185               
0186               txt.clear
0187 36C2 0420             byte  4
0188 36C3 ....             text  '    '
0189                       even
0190               
0191      36C2     txt.filetype.none  equ txt.clear
0192               
0193               
0194               ;--------------------------------------------------------------
0195               ; Dialog Load DV 80 file
0196               ;--------------------------------------------------------------
0197               txt.head.load
0198 36C8 0F4F             byte  15
0199 36C9 ....             text  'Open DV80 file '
0200                       even
0201               
0202               txt.hint.load
0203 36D8 4D48             byte  77
0204 36D9 ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0205                       even
0206               
0207               txt.keys.load
0208 3726 3946             byte  57
0209 3727 ....             text  'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
0210                       even
0211               
0212               txt.keys.load2
0213 3760 3946             byte  57
0214 3761 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog Save DV 80 file
0220               ;--------------------------------------------------------------
0221               txt.head.save
0222 379A 0F53             byte  15
0223 379B ....             text  'Save DV80 file '
0224                       even
0225               
0226               txt.head.save2
0227 37AA 1D53             byte  29
0228 37AB ....             text  'Save code block to DV80 file '
0229                       even
0230               
0231               txt.hint.save
0232 37C8 3F48             byte  63
0233 37C9 ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0234                       even
0235               
0236               txt.keys.save
0237 3808 3046             byte  48
0238 3809 ....             text  'F9=Back    F3=Clear    Fctn-H=Home    Fctn-L=End'
0239                       even
0240               
0241               
0242               ;--------------------------------------------------------------
0243               ; Dialog "Unsaved changes"
0244               ;--------------------------------------------------------------
0245               txt.head.unsaved
0246 383A 1055             byte  16
0247 383B ....             text  'Unsaved changes '
0248                       even
0249               
0250               txt.info.unsaved
0251 384C 3259             byte  50
0252 384D ....             text  'You are about to lose changes to the current file!'
0253                       even
0254               
0255               txt.hint.unsaved
0256 3880 3F48             byte  63
0257 3881 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0258                       even
0259               
0260               txt.keys.unsaved
0261 38C0 2846             byte  40
0262 38C1 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0263                       even
0264               
0265               
0266               ;--------------------------------------------------------------
0267               ; Dialog "About"
0268               ;--------------------------------------------------------------
0269               txt.head.about
0270 38EA 0D41             byte  13
0271 38EB ....             text  'About Stevie '
0272                       even
0273               
0274               txt.hint.about
0275 38F8 2C48             byte  44
0276 38F9 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0277                       even
0278               
0279               txt.keys.about
0280 3926 1546             byte  21
0281 3927 ....             text  'F9=Back    ENTER=Back'
0282                       even
0283               
0284               
0285               ;--------------------------------------------------------------
0286               ; Strings for error line pane
0287               ;--------------------------------------------------------------
0288               txt.ioerr.load
0289 393C 2049             byte  32
0290 393D ....             text  'I/O error. Failed loading file: '
0291                       even
0292               
0293               txt.ioerr.save
0294 395E 1F49             byte  31
0295 395F ....             text  'I/O error. Failed saving file: '
0296                       even
0297               
0298               txt.io.nofile
0299 397E 2149             byte  33
0300 397F ....             text  'I/O error. No filename specified.'
0301                       even
0302               
0303               txt.block.inside
0304 39A0 3445             byte  52
0305 39A1 ....             text  'Error. Copy/Move target must be outside block M1-M2.'
0306                       even
0307               
0308               
0309               
0310               ;--------------------------------------------------------------
0311               ; Strings for command buffer
0312               ;--------------------------------------------------------------
0313               txt.cmdb.title
0314 39D6 0E43             byte  14
0315 39D7 ....             text  'Command buffer'
0316                       even
0317               
0318               txt.cmdb.prompt
0319 39E6 013E             byte  1
0320 39E7 ....             text  '>'
0321                       even
0322               
0323               
0324 39E8 0C0A     txt.stevie         byte    12
0325                                  byte    10
0326 39EA ....                        text    'stevie V0.1I'
0327 39F6 0B00                        byte    11
0328                                  even
0329               
0330               txt.colorscheme
0331 39F8 0D43             byte  13
0332 39F9 ....             text  'Color scheme:'
0333                       even
0334               
**** **** ****     > ram.resident.3000.asm
0017                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard mapping)
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
0018                       ;------------------------------------------------------
0019                       ; End of File marker
0020                       ;------------------------------------------------------
0021 3A06 DEAD             data  >dead,>beef,>dead,>beef
     3A08 BEEF 
     3A0A DEAD 
     3A0C BEEF 
**** **** ****     > stevie_b1.asm.395472
0081               ***************************************************************
0082               * Step 4: Include main editor modules
0083               ********|*****|*********************|**************************
0084               main:
0085                       aorg  kickstart.code2       ; >6036
0086 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0087                       ;-----------------------------------------------------------------------
0088                       ; Include files
0089                       ;-----------------------------------------------------------------------
0090                       copy  "main.asm"            ; Main file (entrypoint)
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
0051 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0052                       ;------------------------------------------------------
0053                       ; Initialize high memory expansion
0054                       ;------------------------------------------------------
0055 6068 06A0  32         bl    @film
     606A 2238 
0056 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0057                       ;------------------------------------------------------
0058                       ; Setup SAMS windows
0059                       ;------------------------------------------------------
0060 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 69BE 
0061                       ;------------------------------------------------------
0062                       ; Setup cursor, screen, etc.
0063                       ;------------------------------------------------------
0064 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2674 
0065 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2684 
0066               
0067 607E 06A0  32         bl    @cpym2m
     6080 24A0 
0068 6082 335A                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F5A 
     6086 0004 
0069               
0070 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 335C 
     608C A014 
0071                                                   ; Save cursor shape & color
0072               
0073 608E 06A0  32         bl    @cpym2v
     6090 244C 
0074 6092 2800                   data sprpdt,cursors,3*8
     6094 335E 
     6096 0018 
0075                                                   ; Load sprite cursor patterns
0076               
0077 6098 06A0  32         bl    @cpym2v
     609A 244C 
0078 609C 1008                   data >1008,patterns,16*8
     609E 3376 
     60A0 0080 
0079                                                   ; Load character patterns
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 325C 
0084 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 3282 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 77D2 
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
     60B8 2694 
0097 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60BC 0204  20         li    tmp0,timers
     60BE 2F4A 
0100 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0101               
0102 60C4 06A0  32         bl    @mkslot
     60C6 2DC8 
0103 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 7524 
0104 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
     60CE 75FE 
0105 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60D2 765C 
0106 60D4 0330                   data >0330,task.oneshot      ; Task 3 - One shot task
     60D6 76A0 
0107 60D8 FFFF                   data eol
0108               
0109 60DA 06A0  32         bl    @mkhook
     60DC 2DB4 
0110 60DE 74E6                   data hook.keyscan     ; Setup user hook
0111               
0112 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D0A 
**** **** ****     > stevie_b1.asm.395472
0091                       ;-----------------------------------------------------------------------
0092                       ; Keyboard actions
0093                       ;-----------------------------------------------------------------------
0094                       copy  "edkey.key.process.asm"    ; Process keyboard actions
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
     6108 7DE6 
0032 610A 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7EA2 
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
     6150 66E6 
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
     6164 6882 
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
     6170 7518 
**** **** ****     > stevie_b1.asm.395472
0095                       ;-----------------------------------------------------------------------
0096                       ; Keyboard actions - Framebuffer
0097                       ;-----------------------------------------------------------------------
0098                       copy  "edkey.fb.mov.leftright.asm"
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
     618A 7518 
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
     61A6 7518 
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
     61BE 69F8 
0052 61C0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     61C2 A118 
0053                       ;-------------------------------------------------------
0054                       ; Exit
0055                       ;-------------------------------------------------------
0056 61C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C6 7518 
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
     61E4 69F8 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077 61E6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61E8 7518 
**** **** ****     > stevie_b1.asm.395472
0099                                                        ; Move left / right / home / end
0100                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
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
     623A 69F8 
0069 623C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     623E 7518 
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
     629E 69F8 
0153 62A0 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62A2 7518 
0154               
0155               
**** **** ****     > stevie_b1.asm.395472
0101                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
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
     62B2 6DFE 
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
     62CC 6A68 
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
     62DE 6FBA 
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
     62F8 69F8 
0065 62FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62FC 7518 
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
0074 6304 1334  14         jeq   !                     ; Yes, skip further processing
0075 6306 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6308 A118 
0076                       ;-------------------------------------------------------
0077                       ; Crunch current row if dirty
0078                       ;-------------------------------------------------------
0079 630A 8820  54         c     @fb.row.dirty,@w$ffff
     630C A10A 
     630E 2022 
0080 6310 1604  14         jne   edkey.action.down.move
0081 6312 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6314 6DFE 
0082 6316 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6318 A10A 
0083                       ;-------------------------------------------------------
0084                       ; Move cursor
0085                       ;-------------------------------------------------------
0086               edkey.action.down.move:
0087                       ;-------------------------------------------------------
0088                       ; EOF reached?
0089                       ;-------------------------------------------------------
0090 631A C120  34         mov   @fb.topline,tmp0
     631C A104 
0091 631E A120  34         a     @fb.row,tmp0
     6320 A106 
0092 6322 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6324 A204 
0093 6326 1314  14         jeq   edkey.action.down.set_cursorx
0094                                                   ; Yes, only position cursor X
0095                       ;-------------------------------------------------------
0096                       ; Check if scrolling required
0097                       ;-------------------------------------------------------
0098 6328 C120  34         mov   @fb.scrrows,tmp0
     632A A11A 
0099 632C 0604  14         dec   tmp0
0100 632E 8120  34         c     @fb.row,tmp0
     6330 A106 
0101 6332 110A  14         jlt   edkey.action.down.cursor
0102                       ;-------------------------------------------------------
0103                       ; Scroll 1 line
0104                       ;-------------------------------------------------------
0105 6334 C820  54         mov   @fb.topline,@parm1
     6336 A104 
     6338 2F20 
0106 633A 05A0  34         inc   @parm1
     633C 2F20 
0107               
0108 633E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6340 6A68 
0109                                                   ; | i  @parm1 = Line to start with
0110                                                   ; /             (becomes @fb.topline)
0111               
0112 6342 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6344 A110 
0113 6346 1004  14         jmp   edkey.action.down.set_cursorx
0114                       ;-------------------------------------------------------
0115                       ; Move cursor down a row, there are still rows left
0116                       ;-------------------------------------------------------
0117               edkey.action.down.cursor:
0118 6348 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     634A A106 
0119 634C 06A0  32         bl    @down                 ; Row++ VDP cursor
     634E 269A 
0120                       ;-------------------------------------------------------
0121                       ; Check line length and position cursor
0122                       ;-------------------------------------------------------
0123               edkey.action.down.set_cursorx:
0124 6350 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6352 6FBA 
0125                                                   ; | i  @fb.row        = Row in frame buffer
0126                                                   ; / o  @fb.row.length = Length of row
0127               
0128 6354 8820  54         c     @fb.column,@fb.row.length
     6356 A10C 
     6358 A108 
0129 635A 1207  14         jle   edkey.action.down.exit
0130                                                   ; Exit
0131                       ;-------------------------------------------------------
0132                       ; Adjust cursor column position
0133                       ;-------------------------------------------------------
0134 635C C820  54         mov   @fb.row.length,@fb.column
     635E A108 
     6360 A10C 
0135 6362 C120  34         mov   @fb.column,tmp0
     6364 A10C 
0136 6366 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6368 26AC 
0137                       ;-------------------------------------------------------
0138                       ; Exit
0139                       ;-------------------------------------------------------
0140               edkey.action.down.exit:
0141 636A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     636C 69F8 
0142 636E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6370 7518 
**** **** ****     > stevie_b1.asm.395472
0102                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
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
     6380 6DFE 
0015 6382 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6384 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Sanity check
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
     63AC 7518 
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
     63BC 6DFE 
0063 63BE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63C0 A10A 
0064                       ;-------------------------------------------------------
0065                       ; Sanity check
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
     63E6 7518 
**** **** ****     > stevie_b1.asm.395472
0103                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
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
     63F2 6DFE 
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
     640E 6DFE 
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
     6432 7518 
**** **** ****     > stevie_b1.asm.395472
0104                       copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
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
     643A 6A68 
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
     644A 69F8 
0037               
0038 644C 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     644E 6FBA 
0039                                                   ; | i  @fb.row        = Row in frame buffer
0040                                                   ; / o  @fb.row.length = Length of row
0041               
0042 6450 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6452 7518 
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
     6464 6DFE 
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
**** **** ****     > stevie_b1.asm.395472
0105                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
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
     647C 69F8 
0010                       ;-------------------------------------------------------
0011                       ; Sanity check 1 - Empty line
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
0020                       ; Sanity check 2 - Already at EOL
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
0039                       ; Sanity check 3 - Abort if row length > 80
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
     64F2 7518 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 64F4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64F6 A206 
0102 64F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64FA 69F8 
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
     6526 7518 
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
     652A 69F8 
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
0149 6540 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     6542 70BE 
0150                                                   ; \ i  @parm1 = Line number to delete
0151                                                   ; /
0152                       ;-------------------------------------------------------
0153                       ; Get length of current row in frame buffer
0154                       ;-------------------------------------------------------
0155 6544 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     6546 6FBA 
0156                                                   ; \ i  @fb.row        = Current row
0157                                                   ; / o  @fb.row.length = Length of row
0158                       ;-------------------------------------------------------
0159                       ; Refresh frame buffer
0160                       ;-------------------------------------------------------
0161 6548 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     654A A104 
     654C 2F20 
0162               
0163 654E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     6550 6A68 
0164                                                   ; \ i  @parm1 = Line to start with
0165                                                   ; /
0166               
0167 6552 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6554 A206 
0168                       ;-------------------------------------------------------
0169                       ; Special treatment if current line was last line
0170                       ;-------------------------------------------------------
0171 6556 C120  34         mov   @fb.topline,tmp0
     6558 A104 
0172 655A A120  34         a     @fb.row,tmp0
     655C A106 
0173               
0174 655E 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6560 A204 
0175 6562 1102  14         jlt   edkey.action.del_line.exit
0176               
0177 6564 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6566 62A4 
0178                       ;-------------------------------------------------------
0179                       ; Exit
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.exit:
0182 6568 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     656A 61A8 
**** **** ****     > stevie_b1.asm.395472
0106                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 656C 0204  20         li    tmp0,>2000            ; White space
     656E 2000 
0011 6570 C804  38         mov   tmp0,@parm1
     6572 2F20 
0012               edkey.action.ins_char:
0013 6574 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6576 A206 
0014 6578 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     657A 69F8 
0015                       ;-------------------------------------------------------
0016                       ; Sanity check 1 - Empty line
0017                       ;-------------------------------------------------------
0018 657C C120  34         mov   @fb.current,tmp0      ; Get pointer
     657E A102 
0019 6580 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6582 A108 
0020 6584 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Sanity check 2 - EOL
0024                       ;-------------------------------------------------------
0025 6586 8820  54         c     @fb.column,@fb.row.length
     6588 A10C 
     658A A108 
0026 658C 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Sanity check 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 658E C160  34         mov   @fb.column,tmp1
     6590 A10C 
0032 6592 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     6594 004F 
0033 6596 1102  14         jlt   !
0034 6598 0460  28         b     @edkey.action.char.overwrite
     659A 670C 
0035                       ;-------------------------------------------------------
0036                       ; Sanity check 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 659C C160  34 !       mov   @fb.row.length,tmp1
     659E A108 
0039 65A0 0285  22         ci    tmp1,colrow
     65A2 0050 
0040 65A4 1101  14         jlt   edkey.action.ins_char.prep
0041 65A6 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 65A8 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 65AA 61E0  34         s     @fb.column,tmp3
     65AC A10C 
0048 65AE 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 65B0 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 65B2 C144  18         mov   tmp0,tmp1
0051 65B4 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 65B6 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     65B8 A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 65BA D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 65BC 0604  14         dec   tmp0
0059 65BE 0605  14         dec   tmp1
0060 65C0 0606  14         dec   tmp2
0061 65C2 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 65C4 D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     65C6 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 65C8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65CA A10A 
0070 65CC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65CE A116 
0071 65D0 05A0  34         inc   @fb.column
     65D2 A10C 
0072 65D4 05A0  34         inc   @wyx
     65D6 832A 
0073 65D8 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65DA A108 
0074 65DC 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65DE 0460  28         b     @edkey.action.char.overwrite
     65E0 670C 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 65E2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65E4 7518 
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
0095 65E6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65E8 A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 65EA 8820  54         c     @fb.row.dirty,@w$ffff
     65EC A10A 
     65EE 2022 
0100 65F0 1604  14         jne   edkey.action.ins_line.insert
0101 65F2 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     65F4 6DFE 
0102 65F6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65F8 A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 65FA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65FC 69F8 
0108 65FE C820  54         mov   @fb.topline,@parm1
     6600 A104 
     6602 2F20 
0109 6604 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6606 A106 
     6608 2F20 
0110 660A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     660C A204 
     660E 2F22 
0111               
0112 6610 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6612 6D16 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 6614 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6616 A204 
0117                       ;-------------------------------------------------------
0118                       ; Check/Adjust marker M1
0119                       ;-------------------------------------------------------
0120               edkey.action.ins_line.m1:
0121 6618 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     661A A20C 
     661C 2022 
0122 661E 1308  14         jeq   edkey.action.ins_line.m2
0123                                                   ; Yes, skip to M2 check
0124               
0125 6620 8820  54         c     @parm1,@edb.block.m1
     6622 2F20 
     6624 A20C 
0126 6626 1504  14         jgt   edkey.action.ins_line.m2
0127 6628 05A0  34         inc   @edb.block.m1         ; M1++
     662A A20C 
0128 662C 0720  34         seto  @fb.colorize          ; Set colorize flag
     662E A110 
0129                       ;-------------------------------------------------------
0130                       ; Check/Adjust marker M2
0131                       ;-------------------------------------------------------
0132               edkey.action.ins_line.m2:
0133 6630 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6632 A20E 
     6634 2022 
0134 6636 1308  14         jeq   edkey.action.ins_line.refresh
0135                                                   ; Yes, skip to refresh frame buffer
0136               
0137 6638 8820  54         c     @parm1,@edb.block.m2
     663A 2F20 
     663C A20E 
0138 663E 1504  14         jgt   edkey.action.ins_line.refresh
0139 6640 05A0  34         inc   @edb.block.m2         ; M2++
     6642 A20E 
0140 6644 0720  34         seto  @fb.colorize          ; Set colorize flag
     6646 A110 
0141                       ;-------------------------------------------------------
0142                       ; Refresh frame buffer and physical screen
0143                       ;-------------------------------------------------------
0144               edkey.action.ins_line.refresh:
0145 6648 C820  54         mov   @fb.topline,@parm1
     664A A104 
     664C 2F20 
0146               
0147 664E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6650 6A68 
0148                                                   ; | i  @parm1 = Line to start with
0149                                                   ; /             (becomes @fb.topline)
0150               
0151 6652 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6654 A116 
0152                       ;-------------------------------------------------------
0153                       ; Exit
0154                       ;-------------------------------------------------------
0155               edkey.action.ins_line.exit:
0156 6656 0460  28         b     @edkey.action.home    ; Position cursor at home
     6658 61A8 
0157               
**** **** ****     > stevie_b1.asm.395472
0107                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 665A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     665C A118 
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 665E 8820  54         c     @fb.row.dirty,@w$ffff
     6660 A10A 
     6662 2022 
0013 6664 1606  14         jne   edkey.action.enter.upd_counter
0014 6666 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6668 A206 
0015 666A 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     666C 6DFE 
0016 666E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6670 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6672 C120  34         mov   @fb.topline,tmp0
     6674 A104 
0022 6676 A120  34         a     @fb.row,tmp0
     6678 A106 
0023 667A 0584  14         inc   tmp0
0024 667C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     667E A204 
0025 6680 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6682 05A0  34         inc   @edb.lines            ; Total lines++
     6684 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6686 C120  34         mov   @fb.scrrows,tmp0
     6688 A11A 
0035 668A 0604  14         dec   tmp0
0036 668C 8120  34         c     @fb.row,tmp0
     668E A106 
0037 6690 110C  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 6692 C120  34         mov   @fb.scrrows,tmp0
     6694 A11A 
0042 6696 C820  54         mov   @fb.topline,@parm1
     6698 A104 
     669A 2F20 
0043 669C 05A0  34         inc   @parm1
     669E 2F20 
0044 66A0 06A0  32         bl    @fb.refresh
     66A2 6A68 
0045 66A4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     66A6 A110 
0046 66A8 1004  14         jmp   edkey.action.newline.rest
0047                       ;-------------------------------------------------------
0048                       ; Move cursor down a row, there are still rows left
0049                       ;-------------------------------------------------------
0050               edkey.action.newline.down:
0051 66AA 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     66AC A106 
0052 66AE 06A0  32         bl    @down                 ; Row++ VDP cursor
     66B0 269A 
0053                       ;-------------------------------------------------------
0054                       ; Set VDP cursor and save variables
0055                       ;-------------------------------------------------------
0056               edkey.action.newline.rest:
0057 66B2 06A0  32         bl    @fb.get.firstnonblank
     66B4 6A20 
0058 66B6 C120  34         mov   @outparm1,tmp0
     66B8 2F30 
0059 66BA C804  38         mov   tmp0,@fb.column
     66BC A10C 
0060 66BE 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     66C0 26AC 
0061 66C2 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     66C4 6FBA 
0062 66C6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66C8 69F8 
0063 66CA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66CC A116 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.newline.exit:
0068 66CE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D0 7518 
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Toggle insert/overwrite mode
0075               *---------------------------------------------------------------
0076               edkey.action.ins_onoff:
0077 66D2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66D4 A118 
0078 66D6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     66D8 A20A 
0079                       ;-------------------------------------------------------
0080                       ; Delay
0081                       ;-------------------------------------------------------
0082 66DA 0204  20         li    tmp0,2000
     66DC 07D0 
0083               edkey.action.ins_onoff.loop:
0084 66DE 0604  14         dec   tmp0
0085 66E0 16FE  14         jne   edkey.action.ins_onoff.loop
0086                       ;-------------------------------------------------------
0087                       ; Exit
0088                       ;-------------------------------------------------------
0089               edkey.action.ins_onoff.exit:
0090 66E2 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     66E4 765C 
0091               
0092               
0093               
0094               
0095               *---------------------------------------------------------------
0096               * Add character (frame buffer)
0097               *---------------------------------------------------------------
0098               edkey.action.char:
0099 66E6 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66E8 A118 
0100                       ;-------------------------------------------------------
0101                       ; Sanity checks
0102                       ;-------------------------------------------------------
0103 66EA D105  18         movb  tmp1,tmp0             ; Get keycode
0104 66EC 0984  56         srl   tmp0,8                ; MSB to LSB
0105               
0106 66EE 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66F0 0020 
0107 66F2 112B  14         jlt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109               
0110 66F4 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     66F6 007E 
0111 66F8 1528  14         jgt   edkey.action.char.exit
0112                                                   ; Yes, skip
0113                       ;-------------------------------------------------------
0114                       ; Setup
0115                       ;-------------------------------------------------------
0116 66FA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     66FC A206 
0117 66FE D805  38         movb  tmp1,@parm1           ; Store character for insert
     6700 2F20 
0118 6702 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6704 A20A 
0119 6706 1302  14         jeq   edkey.action.char.overwrite
0120                       ;-------------------------------------------------------
0121                       ; Insert mode
0122                       ;-------------------------------------------------------
0123               edkey.action.char.insert:
0124 6708 0460  28         b     @edkey.action.ins_char
     670A 6574 
0125                       ;-------------------------------------------------------
0126                       ; Overwrite mode - Write character
0127                       ;-------------------------------------------------------
0128               edkey.action.char.overwrite:
0129 670C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     670E 69F8 
0130 6710 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6712 A102 
0131               
0132 6714 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6716 2F20 
0133 6718 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     671A A10A 
0134 671C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     671E A116 
0135                       ;-------------------------------------------------------
0136                       ; Last column on screen reached?
0137                       ;-------------------------------------------------------
0138 6720 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6722 A10C 
0139 6724 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     6726 004F 
0140 6728 1105  14         jlt   edkey.action.char.overwrite.incx
0141                                                   ; No, increase X position
0142               
0143 672A 0205  20         li    tmp1,colrow           ; \
     672C 0050 
0144 672E C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     6730 A108 
0145 6732 100B  14         jmp   edkey.action.char.exit
0146                       ;-------------------------------------------------------
0147                       ; Increase column
0148                       ;-------------------------------------------------------
0149               edkey.action.char.overwrite.incx:
0150 6734 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6736 A10C 
0151 6738 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     673A 832A 
0152                       ;-------------------------------------------------------
0153                       ; Update line length in frame buffer
0154                       ;-------------------------------------------------------
0155 673C 8820  54         c     @fb.column,@fb.row.length
     673E A10C 
     6740 A108 
0156                                                   ; column < line length ?
0157 6742 1103  14         jlt   edkey.action.char.exit
0158                                                   ; Yes, don't update row length
0159 6744 C820  54         mov   @fb.column,@fb.row.length
     6746 A10C 
     6748 A108 
0160                                                   ; Set row length
0161                       ;-------------------------------------------------------
0162                       ; Exit
0163                       ;-------------------------------------------------------
0164               edkey.action.char.exit:
0165 674A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     674C 7518 
**** **** ****     > stevie_b1.asm.395472
0108                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 674E C120  34         mov   @edb.dirty,tmp0
     6750 A206 
0012 6752 1302  14         jeq   !
0013 6754 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6756 7DC2 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 6758 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     675A 275C 
0018 675C 0420  54         blwp  @0                    ; Exit
     675E 0000 
**** **** ****     > stevie_b1.asm.395472
0109                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 6760 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6762 A444 
     6764 2F20 
0018 6766 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6768 2F22 
0019 676A 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 676C C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     676E A444 
     6770 2F20 
0023 6772 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     6774 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Sanity check
0028                       ;------------------------------------------------------
0029 6776 C120  34         mov   @parm1,tmp0
     6778 2F20 
0030 677A 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 677C C120  34         mov   @edb.dirty,tmp0
     677E A206 
0036 6780 1302  14         jeq   !
0037 6782 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6784 7DC2 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 6786 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     6788 7432 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 678A 0204  20         li    tmp0,heap.top         ; 1st line in heap
     678C E000 
0047 678E 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6790 7D54 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 6792 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6794 63E8 
**** **** ****     > stevie_b1.asm.395472
0110                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 6796 06A0  32         bl    @edb.block.mark.m1    ; Set M1 marker
     6798 714E 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 679A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     679C 7518 
0013               
0014               
0015               
0016               *---------------------------------------------------------------
0017               * Mark line M2
0018               ********|*****|*********************|**************************
0019               edkey.action.block.mark.m2:
0020 679E 06A0  32         bl    @edb.block.mark.m2    ; Set M2 marker
     67A0 7176 
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 67A2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67A4 7518 
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Mark line M1 or M2
0029               ********|*****|*********************|**************************
0030               edkey.action.block.mark:
0031 67A6 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     67A8 719E 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035 67AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67AC 7518 
0036               
0037               
0038               *---------------------------------------------------------------
0039               * Reset block markers M1/M2
0040               ********|*****|*********************|**************************
0041               edkey.action.block.reset:
0042 67AE 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67B0 7BD8 
0043 67B2 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     67B4 71D8 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047 67B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67B8 7518 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Copy code block
0052               ********|*****|*********************|**************************
0053               edkey.action.block.copy:
0054                       ;-------------------------------------------------------
0055                       ; Exit early if nothing to do
0056                       ;-------------------------------------------------------
0057 67BA 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67BC A20E 
     67BE 2022 
0058 67C0 1313  14         jeq   edkey.action.block.copy.exit
0059                                                   ; Yes, exit early
0060                       ;-------------------------------------------------------
0061                       ; Init
0062                       ;-------------------------------------------------------
0063 67C2 C120  34         mov   @wyx,tmp0             ; Get cursor position
     67C4 832A 
0064 67C6 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     67C8 FF00 
0065 67CA C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     67CC A114 
0066                       ;-------------------------------------------------------
0067                       ; Copy
0068                       ;-------------------------------------------------------
0069 67CE 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     67D0 7BD8 
0070               
0071 67D2 06A0  32         bl    @edb.block.copy       ; Copy code block
     67D4 721E 
0072               
0073 67D6 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     67D8 2F30 
     67DA 2000 
0074 67DC 1305  14         jeq   edkey.action.block.copy.exit
0075               
0076 67DE C820  54         mov   @fb.yxsave,@parm1
     67E0 A114 
     67E2 2F20 
0077 67E4 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     67E6 6B92 
0078                                                   ; \ i  @parm1 = cursor YX position
0079                       ;-------------------------------------------------------
0080                       ; Exit
0081                       ;-------------------------------------------------------
0082               edkey.action.block.copy.exit:
0083 67E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67EA 7518 
0084               
0085               
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete code block
0090               ********|*****|*********************|**************************
0091               edkey.action.block.delete:
0092                       ;-------------------------------------------------------
0093                       ; Exit early if nothing to do
0094                       ;-------------------------------------------------------
0095 67EC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     67EE A20E 
     67F0 2022 
0096 67F2 1304  14         jeq   edkey.action.block.delete.exit
0097                                                   ; Yes, exit early
0098                       ;-------------------------------------------------------
0099                       ; Delete
0100                       ;-------------------------------------------------------
0101 67F4 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     67F6 7BD8 
0102               
0103 67F8 06A0  32         bl    @edb.block.delete     ; Delete code block
     67FA 72F4 
0104                       ;-------------------------------------------------------
0105                       ; Exit
0106                       ;-------------------------------------------------------
0107               edkey.action.block.delete.exit:
0108 67FC C820  54         mov   @fb.topline,@parm1
     67FE A104 
     6800 2F20 
0109 6802 0460  28         b     @_edkey.goto.fb.toprow
     6804 6434 
0110                                                   ; Position on top row in frame buffer
0111                                                   ; \ i  @parm1 = Line to display as top row
0112                                                   ; /
0113               
0114               
0115               *---------------------------------------------------------------
0116               * Goto marker M1
0117               ********|*****|*********************|**************************
0118               edkey.action.block.goto.m1:
0119 6806 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6808 A20C 
     680A 2022 
0120 680C 1307  14         jeq   edkey.action.block.goto.m1.exit
0121                                                   ; Yes, exit early
0122                       ;-------------------------------------------------------
0123                       ; Goto marker M1
0124                       ;-------------------------------------------------------
0125 680E C820  54         mov   @edb.block.m1,@parm1
     6810 A20C 
     6812 2F20 
0126 6814 0620  34         dec   @parm1                ; Base 0 offset
     6816 2F20 
0127               
0128 6818 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     681A 6454 
0129                                                   ; \ i @parm1 = Target line in EB
0130                                                   ; /
0131                       ;-------------------------------------------------------
0132                       ; Exit
0133                       ;-------------------------------------------------------
0134               edkey.action.block.goto.m1.exit:
0135 681C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     681E 7518 
**** **** ****     > stevie_b1.asm.395472
0111                       ;-----------------------------------------------------------------------
0112                       ; Keyboard actions - Command Buffer
0113                       ;-----------------------------------------------------------------------
0114                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 6820 C120  34         mov   @cmdb.column,tmp0
     6822 A312 
0009 6824 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6826 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6828 A312 
0014 682A 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     682C A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 682E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6830 7518 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 6832 06A0  32         bl    @cmdb.cmd.getlength
     6834 7404 
0026 6836 8820  54         c     @cmdb.column,@outparm1
     6838 A312 
     683A 2F30 
0027 683C 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 683E 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     6840 A312 
0032 6842 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     6844 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 6846 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6848 7518 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 684A 04C4  14         clr   tmp0
0045 684C C804  38         mov   tmp0,@cmdb.column      ; First column
     684E A312 
0046 6850 0584  14         inc   tmp0
0047 6852 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     6854 A30A 
0048 6856 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     6858 A30A 
0049               
0050 685A 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     685C 7518 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 685E D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     6860 A326 
0057 6862 0984  56         srl   tmp0,8                 ; Right justify
0058 6864 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6866 A312 
0059 6868 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 686A 0224  22         ai    tmp0,>1a00             ; Y=26
     686C 1A00 
0061 686E C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     6870 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 6872 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6874 7518 
**** **** ****     > stevie_b1.asm.395472
0115                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 6876 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6878 73D2 
0026 687A 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     687C A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 687E 0460  28         b     @edkey.action.cmdb.home
     6880 684A 
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
0058                       ; Sanity checks
0059                       ;-------------------------------------------------------
0060 6882 D105  18         movb  tmp1,tmp0             ; Get keycode
0061 6884 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6886 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6888 0020 
0064 688A 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 688C 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     688E 007E 
0068 6890 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 6892 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6894 A318 
0074               
0075 6896 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6898 A327 
0076 689A A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     689C A312 
0077 689E D505  30         movb  tmp1,*tmp0            ; Add character
0078 68A0 05A0  34         inc   @cmdb.column          ; Next column
     68A2 A312 
0079 68A4 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     68A6 A30A 
0080               
0081 68A8 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68AA 7404 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 68AC C120  34         mov   @outparm1,tmp0
     68AE 2F30 
0088 68B0 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 68B2 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68B4 A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 68B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68B8 7518 
**** **** ****     > stevie_b1.asm.395472
0116                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 68BA C120  34         mov   @cmdb.visible,tmp0
     68BC A302 
0009 68BE 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 68C0 04E0  34         clr   @cmdb.column          ; Column = 0
     68C2 A312 
0015 68C4 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     68C6 7948 
0016 68C8 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 68CA 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     68CC 7998 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 68CE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     68D0 7518 
**** **** ****     > stevie_b1.asm.395472
0117                       copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
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
0011 68D2 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     68D4 7998 
0012               
0013 68D6 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     68D8 7404 
0014 68DA C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     68DC 2F30 
0015 68DE 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 68E0 06A0  32         bl    @pane.errline.show    ; Show error line
     68E2 7B70 
0020               
0021 68E4 06A0  32         bl    @pane.show_hint
     68E6 7722 
0022 68E8 1C00                   byte pane.botrow-1,0
0023 68EA 397E                   data txt.io.nofile
0024               
0025 68EC 1012  14         jmp   edkey.action.cmdb.load.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 68EE 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 68F0 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     68F2 A326 
0031               
0032 68F4 06A0  32         bl    @cpym2m
     68F6 24A0 
0033 68F8 A326                   data cmdb.cmdlen,heap.top,80
     68FA E000 
     68FC 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 68FE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6900 E000 
0039 6902 C804  38         mov   tmp0,@parm1
     6904 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Load file
0042                       ;-------------------------------------------------------
0043               edkey.action.cmdb.load.file:
0044 6906 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6908 E000 
0045 690A C804  38         mov   tmp0,@parm1
     690C 2F20 
0046               
0047 690E 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6910 7D54 
0048                                                   ; \ i  parm1 = Pointer to length-prefixed
0049                                                   ; /            device/filename string
0050                       ;-------------------------------------------------------
0051                       ; Exit
0052                       ;-------------------------------------------------------
0053               edkey.action.cmdb.load.exit:
0054 6912 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6914 63E8 
**** **** ****     > stevie_b1.asm.395472
0118                       copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
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
0011 6916 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6918 7998 
0012               
0013 691A 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     691C 7404 
0014 691E C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6920 2F30 
0015 6922 1607  14         jne   !                     ; No, prepare for save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6924 06A0  32         bl    @pane.errline.show    ; Show error line
     6926 7B70 
0020               
0021 6928 06A0  32         bl    @pane.show_hint
     692A 7722 
0022 692C 1C00                   byte pane.botrow-1,0
0023 692E 397E                   data txt.io.nofile
0024               
0025 6930 101F  14         jmp   edkey.action.cmdb.save.exit
0026                       ;-------------------------------------------------------
0027                       ; Get filename
0028                       ;-------------------------------------------------------
0029 6932 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 6934 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6936 A326 
0031               
0032 6938 06A0  32         bl    @cpym2m
     693A 24A0 
0033 693C A326                   data cmdb.cmdlen,heap.top,80
     693E E000 
     6940 0050 
0034                                                   ; Copy filename from command line to buffer
0035                       ;-------------------------------------------------------
0036                       ; Pass filename as parm1
0037                       ;-------------------------------------------------------
0038 6942 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6944 E000 
0039 6946 C804  38         mov   tmp0,@parm1
     6948 2F20 
0040                       ;-------------------------------------------------------
0041                       ; Save all lines in editor buffer?
0042                       ;-------------------------------------------------------
0043 694A C120  34         mov   @edb.block.m2,tmp0    ; Marker M2 set?
     694C A20E 
0044 694E 1309  14         jeq   edkey.action.cmdb.save.all
0045                                                   ; No, so save all lines in editor buffer
0046                       ;-------------------------------------------------------
0047                       ; Only save code block M1-M2
0048                       ;-------------------------------------------------------
0049 6950 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6952 A20C 
     6954 2F22 
0050 6956 0620  34         dec   @parm2                ; /
     6958 2F22 
0051               
0052 695A C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     695C A20E 
     695E 2F24 
0053               
0054 6960 1005  14         jmp   edkey.action.cmdb.save.file
0055                       ;-------------------------------------------------------
0056                       ; Save all lines in editor buffer
0057                       ;-------------------------------------------------------
0058               edkey.action.cmdb.save.all:
0059 6962 04E0  34         clr   @parm2                ; First line to save
     6964 2F22 
0060 6966 C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6968 A204 
     696A 2F24 
0061                       ;-------------------------------------------------------
0062                       ; Save file
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.file:
0065 696C 06A0  32         bl    @fm.savefile          ; Save DV80 file
     696E 7D7A 
0066                                                   ; \ i  parm1 = Pointer to length-prefixed
0067                                                   ; |            device/filename string
0068                                                   ; | i  parm2 = First line to save (base 0)
0069                                                   ; | i  parm3 = Last line to save  (base 0)
0070                                                   ; /
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               edkey.action.cmdb.save.exit:
0075 6970 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6972 63E8 
**** **** ****     > stevie_b1.asm.395472
0119                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 6974 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6976 A206 
0021 6978 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     697A 7754 
0022 697C 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     697E 73D2 
0023 6980 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6982 A324 
0024                       ;-------------------------------------------------------
0025                       ; Sanity checks
0026                       ;-------------------------------------------------------
0027 6984 0284  22         ci    tmp0,>2000
     6986 2000 
0028 6988 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 698A 0284  22         ci    tmp0,>7fff
     698C 7FFF 
0031 698E 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All sanity checks passed
0034                       ;------------------------------------------------------
0035 6990 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Sanity checks failed
0038                       ;------------------------------------------------------
0039 6992 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6994 FFCE 
0040 6996 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6998 2026 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 699A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     699C 7518 
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
0063 699E 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     69A0 74B4 
0064 69A2 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     69A4 A318 
0065 69A6 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     69A8 7518 
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
0086 69AA 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     69AC A31A 
0087 69AE 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     69B0 7754 
0088 69B2 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     69B4 7998 
0089 69B6 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     69B8 A118 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.close.dialog.exit:
0094 69BA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     69BC 7518 
**** **** ****     > stevie_b1.asm.395472
0120                       ;-----------------------------------------------------------------------
0121                       ; Logic for SAMS memory
0122                       ;-----------------------------------------------------------------------
0123                       copy  "mem.asm"             ; SAMS Memory Management
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
0017 69BE 0649  14         dect  stack
0018 69C0 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 69C2 06A0  32         bl    @sams.layout
     69C4 25A8 
0023 69C6 33F6                   data mem.sams.layout.data
0024               
0025 69C8 06A0  32         bl    @sams.layout.copy
     69CA 260C 
0026 69CC A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 69CE C820  54         mov   @tv.sams.c000,@edb.sams.page
     69D0 A008 
     69D2 A216 
0029 69D4 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     69D6 A216 
     69D8 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 69DA C2F9  30         mov   *stack+,r11           ; Pop r11
0036 69DC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0124                       ;-----------------------------------------------------------------------
0125                       ; Logic for Framebuffer
0126                       ;-----------------------------------------------------------------------
0127                       copy  "fb.utils.asm"        ; Framebuffer utilities
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
0024 69DE 0649  14         dect  stack
0025 69E0 C64B  30         mov   r11,*stack            ; Save return address
0026 69E2 0649  14         dect  stack
0027 69E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 69E6 C120  34         mov   @parm1,tmp0
     69E8 2F20 
0032 69EA A120  34         a     @fb.topline,tmp0
     69EC A104 
0033 69EE C804  38         mov   tmp0,@outparm1
     69F0 2F30 
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 69F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 69F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 69F6 045B  20         b     *r11                  ; Return to caller
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
0068 69F8 0649  14         dect  stack
0069 69FA C64B  30         mov   r11,*stack            ; Save return address
0070 69FC 0649  14         dect  stack
0071 69FE C644  30         mov   tmp0,*stack           ; Push tmp0
0072 6A00 0649  14         dect  stack
0073 6A02 C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 6A04 C120  34         mov   @fb.row,tmp0
     6A06 A106 
0078 6A08 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6A0A A10E 
0079 6A0C A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6A0E A10C 
0080 6A10 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6A12 A100 
0081 6A14 C805  38         mov   tmp1,@fb.current
     6A16 A102 
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 6A18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 6A1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6A1C C2F9  30         mov   *stack+,r11           ; Pop r11
0089 6A1E 045B  20         b     *r11                  ; Return to caller
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
0108 6A20 0649  14         dect  stack
0109 6A22 C64B  30         mov   r11,*stack            ; Save return address
0110                       ;------------------------------------------------------
0111                       ; Prepare for scanning
0112                       ;------------------------------------------------------
0113 6A24 04E0  34         clr   @fb.column
     6A26 A10C 
0114 6A28 06A0  32         bl    @fb.calc_pointer
     6A2A 69F8 
0115 6A2C 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6A2E 6FBA 
0116 6A30 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6A32 A108 
0117 6A34 1313  14         jeq   fb.get.firstnonblank.nomatch
0118                                                   ; Exit if empty line
0119 6A36 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6A38 A102 
0120 6A3A 04C5  14         clr   tmp1
0121                       ;------------------------------------------------------
0122                       ; Scan line for non-blank character
0123                       ;------------------------------------------------------
0124               fb.get.firstnonblank.loop:
0125 6A3C D174  28         movb  *tmp0+,tmp1           ; Get character
0126 6A3E 130E  14         jeq   fb.get.firstnonblank.nomatch
0127                                                   ; Exit if empty line
0128 6A40 0285  22         ci    tmp1,>2000            ; Whitespace?
     6A42 2000 
0129 6A44 1503  14         jgt   fb.get.firstnonblank.match
0130 6A46 0606  14         dec   tmp2                  ; Counter--
0131 6A48 16F9  14         jne   fb.get.firstnonblank.loop
0132 6A4A 1008  14         jmp   fb.get.firstnonblank.nomatch
0133                       ;------------------------------------------------------
0134                       ; Non-blank character found
0135                       ;------------------------------------------------------
0136               fb.get.firstnonblank.match:
0137 6A4C 6120  34         s     @fb.current,tmp0      ; Calculate column
     6A4E A102 
0138 6A50 0604  14         dec   tmp0
0139 6A52 C804  38         mov   tmp0,@outparm1        ; Save column
     6A54 2F30 
0140 6A56 D805  38         movb  tmp1,@outparm2        ; Save character
     6A58 2F32 
0141 6A5A 1004  14         jmp   fb.get.firstnonblank.exit
0142                       ;------------------------------------------------------
0143                       ; No non-blank character found
0144                       ;------------------------------------------------------
0145               fb.get.firstnonblank.nomatch:
0146 6A5C 04E0  34         clr   @outparm1             ; X=0
     6A5E 2F30 
0147 6A60 04E0  34         clr   @outparm2             ; Null
     6A62 2F32 
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151               fb.get.firstnonblank.exit:
0152 6A64 C2F9  30         mov   *stack+,r11           ; Pop r11
0153 6A66 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0128                       copy  "fb.refresh.asm"      ; Refresh framebuffer
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
0020 6A68 0649  14         dect  stack
0021 6A6A C64B  30         mov   r11,*stack            ; Push return address
0022 6A6C 0649  14         dect  stack
0023 6A6E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6A70 0649  14         dect  stack
0025 6A72 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6A74 0649  14         dect  stack
0027 6A76 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6A78 C820  54         mov   @parm1,@fb.topline
     6A7A 2F20 
     6A7C A104 
0032 6A7E 04E0  34         clr   @parm2                ; Target row in frame buffer
     6A80 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6A82 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6A84 2F20 
     6A86 A204 
0037 6A88 130A  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6A8A 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6A8C 6EC8 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6A8E 05A0  34         inc   @parm1                ; Next line in editor buffer
     6A90 2F20 
0048 6A92 05A0  34         inc   @parm2                ; Next row in frame buffer
     6A94 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6A96 8820  54         c     @parm1,@edb.lines
     6A98 2F20 
     6A9A A204 
0053 6A9C 1212  14         jle   !                     ; no, do next check
0054                                                   ; yes, erase until end of frame buffer
0055                       ;------------------------------------------------------
0056                       ; Erase until end of frame buffer
0057                       ;------------------------------------------------------
0058               fb.refresh.erase_eob:
0059 6A9E C120  34         mov   @parm2,tmp0           ; Current row
     6AA0 2F22 
0060 6AA2 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6AA4 A11A 
0061 6AA6 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0062 6AA8 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6AAA A10E 
0063               
0064 6AAC C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0065 6AAE 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0066               
0067 6AB0 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6AB2 A10E 
0068 6AB4 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6AB6 A100 
0069               
0070 6AB8 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0071 6ABA 04C5  14         clr   tmp1                  ; Clear with >00 character
0072               
0073 6ABC 06A0  32         bl    @xfilm                ; \ Fill memory
     6ABE 223E 
0074                                                   ; | i  tmp0 = Memory start address
0075                                                   ; | i  tmp1 = Byte to fill
0076                                                   ; / i  tmp2 = Number of bytes to fill
0077 6AC0 1004  14         jmp   fb.refresh.exit
0078                       ;------------------------------------------------------
0079                       ; Bottom row in frame buffer reached ?
0080                       ;------------------------------------------------------
0081 6AC2 8820  54 !       c     @parm2,@fb.scrrows
     6AC4 2F22 
     6AC6 A11A 
0082 6AC8 11E0  14         jlt   fb.refresh.unpack_line
0083                                                   ; No, unpack next line
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               fb.refresh.exit:
0088 6ACA 0720  34         seto  @fb.dirty             ; Refresh screen
     6ACC A116 
0089 6ACE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 6AD0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091 6AD2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0092 6AD4 C2F9  30         mov   *stack+,r11           ; Pop r11
0093 6AD6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0129                       copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
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
0012               * @parm1 = Number of lines to copy
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               fb.vdpdump:
0021 6AD8 0649  14         dect  stack
0022 6ADA C64B  30         mov   r11,*stack            ; Save return address
0023 6ADC 0649  14         dect  stack
0024 6ADE C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6AE0 0649  14         dect  stack
0026 6AE2 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6AE4 0649  14         dect  stack
0028 6AE6 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Refresh VDP content with framebuffer
0031                       ;------------------------------------------------------
0032 6AE8 0204  20         li    tmp0,vdp.fb.toprow.sit
     6AEA 0050 
0033                                                   ; VDP target address (2nd line on screen!)
0034               
0035 6AEC C160  34         mov   @parm1,tmp1
     6AEE 2F20 
0036 6AF0 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * number of rows in parm1
     6AF2 A10E 
0037                                                   ; 16 bit part is in tmp2!
0038 6AF4 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6AF6 A100 
0039               
0040 6AF8 0286  22         ci    tmp2,0                ; \ Exit early if nothing to copy
     6AFA 0000 
0041 6AFC 1304  14         jeq   fb.vdpdump.exit       ; /
0042               
0043 6AFE 06A0  32         bl    @xpym2v               ; Copy to VDP
     6B00 2452 
0044                                                   ; \ i  tmp0 = VDP target address
0045                                                   ; | i  tmp1 = RAM source address
0046                                                   ; / i  tmp2 = Bytes to copy
0047               
0048 6B02 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6B04 A116 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.vdpdump.exit:
0053 6B06 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 6B08 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 6B0A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 6B0C C2F9  30         mov   *stack+,r11           ; Pop r11
0057 6B0E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0130                       copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer
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
0020 6B10 0649  14         dect  stack
0021 6B12 C64B  30         mov   r11,*stack            ; Save return address
0022 6B14 0649  14         dect  stack
0023 6B16 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6B18 0649  14         dect  stack
0025 6B1A C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6B1C 0649  14         dect  stack
0027 6B1E C646  30         mov   tmp2,*stack           ; Push tmp2
0028 6B20 0649  14         dect  stack
0029 6B22 C647  30         mov   tmp3,*stack           ; Push tmp3
0030 6B24 0649  14         dect  stack
0031 6B26 C648  30         mov   tmp4,*stack           ; Push tmp4
0032                       ;------------------------------------------------------
0033                       ; Force refresh flag set
0034                       ;------------------------------------------------------
0035 6B28 C120  34         mov   @parm1,tmp0           ; \ Force refresh flag set?
     6B2A 2F20 
0036 6B2C 0284  22         ci    tmp0,>ffff            ; /
     6B2E FFFF 
0037 6B30 1309  14         jeq   !                     ; Yes, so skip sanity checks
0038                       ;------------------------------------------------------
0039                       ; Sanity check
0040                       ;------------------------------------------------------
0041 6B32 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     6B34 A110 
0042 6B36 1324  14         jeq   fb.colorlines.exit    ; Exit if nothing to do.
0043                       ;------------------------------------------------------
0044                       ; Speedup screen refresh dramatically
0045                       ;------------------------------------------------------
0046 6B38 C120  34         mov   @edb.block.m1,tmp0
     6B3A A20C 
0047 6B3C 1321  14         jeq   fb.colorlines.exit    ; Exit if marker M1 unset
0048 6B3E C120  34         mov   @edb.block.m2,tmp0
     6B40 A20E 
0049 6B42 131E  14         jeq   fb.colorlines.exit    ; Exit if marker M2 unset
0050                       ;------------------------------------------------------
0051                       ; Color the lines in the framebuffer (TAT)
0052                       ;------------------------------------------------------
0053 6B44 0204  20 !       li    tmp0,vdp.fb.toprow.tat
     6B46 1850 
0054                                                   ; VDP start address
0055 6B48 C1E0  34         mov   @fb.scrrows,tmp3      ; Set loop counter
     6B4A A11A 
0056 6B4C C220  34         mov   @fb.topline,tmp4      ; Position in editor buffer
     6B4E A104 
0057 6B50 0588  14         inc   tmp4                  ; M1/M2 use base 1 offset
0058                       ;------------------------------------------------------
0059                       ; 1. Set color for each line in framebuffer
0060                       ;------------------------------------------------------
0061               fb.colorlines.loop:
0062 6B52 C1A0  34         mov   @edb.block.m1,tmp2
     6B54 A20C 
0063 6B56 8206  18         c     tmp2,tmp4             ; M1 > current line
0064 6B58 1507  14         jgt   fb.colorlines.normal  ; Yes, skip marking color
0065               
0066 6B5A C1A0  34         mov   @edb.block.m2,tmp2
     6B5C A20E 
0067 6B5E 8206  18         c     tmp2,tmp4             ; M2 < current line
0068 6B60 1103  14         jlt   fb.colorlines.normal  ; Yes, skip marking color
0069                       ;------------------------------------------------------
0070                       ; 1a. Set marking color
0071                       ;------------------------------------------------------
0072 6B62 C160  34         mov   @tv.markcolor,tmp1
     6B64 A01A 
0073 6B66 1003  14         jmp   fb.colorlines.fill
0074                       ;------------------------------------------------------
0075                       ; 1b. Set normal text color
0076                       ;------------------------------------------------------
0077               fb.colorlines.normal:
0078 6B68 C160  34         mov   @tv.color,tmp1
     6B6A A018 
0079 6B6C 0985  56         srl   tmp1,8
0080                       ;------------------------------------------------------
0081                       ; 1c. Fill line with selected color
0082                       ;------------------------------------------------------
0083               fb.colorlines.fill:
0084 6B6E 0206  20         li    tmp2,80               ; 80 characters to fill
     6B70 0050 
0085               
0086 6B72 06A0  32         bl    @xfilv                ; Fill VDP VRAM
     6B74 2296 
0087                                                   ; \ i  tmp0 = VDP start address
0088                                                   ; | i  tmp1 = Byte to fill
0089                                                   ; / i  tmp2 = count
0090               
0091 6B76 0224  22         ai    tmp0,80               ; Next line
     6B78 0050 
0092 6B7A 0588  14         inc   tmp4
0093 6B7C 0607  14         dec   tmp3                  ; Update loop counter
0094 6B7E 15E9  14         jgt   fb.colorlines.loop    ; Back to (1)
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               fb.colorlines.exit
0099 6B80 04E0  34         clr   @fb.colorize          ; Reset colorize flag
     6B82 A110 
0100 6B84 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0101 6B86 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0102 6B88 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0103 6B8A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 6B8C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 6B8E C2F9  30         mov   *stack+,r11           ; Pop r11
0106 6B90 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.395472
0131                       copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
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
0021 6B92 0649  14         dect  stack
0022 6B94 C64B  30         mov   r11,*stack            ; Save return address
0023 6B96 0649  14         dect  stack
0024 6B98 C660  46         mov   @parm1,*stack         ; Push @parm1
     6B9A 2F20 
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 6B9C C820  54         mov   @fb.topline,@parm1
     6B9E A104 
     6BA0 2F20 
0029 6BA2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     6BA4 6A68 
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 6BA6 0720  34         seto  @parm1                ; Skip sanity checks
     6BA8 2F20 
0035 6BAA 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     6BAC 6B10 
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 6BAE C820  54         mov   @tv.color,@parm1      ; Set normal color
     6BB0 A018 
     6BB2 2F20 
0042 6BB4 06A0  32         bl    @pane.action.colorscheme.statlines
     6BB6 78E4 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 6BB8 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     6BBA A118 
0050               
0051 6BBC 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6BBE 7754 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 6BC0 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6BC2 2F20 
0057 6BC4 C820  54         mov   @parm1,@wyx           ; Set cursor position
     6BC6 2F20 
     6BC8 832A 
0058 6BCA C2F9  30         mov   *stack+,r11           ; Pop R11
0059 6BCC 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.395472
0132                       ;-----------------------------------------------------------------------
0133                       ; Logic for Index management
0134                       ;-----------------------------------------------------------------------
0135                       copy  "idx.update.asm"      ; Index management - Update entry
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
0022 6BCE 0649  14         dect  stack
0023 6BD0 C64B  30         mov   r11,*stack            ; Save return address
0024 6BD2 0649  14         dect  stack
0025 6BD4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6BD6 0649  14         dect  stack
0027 6BD8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6BDA C120  34         mov   @parm1,tmp0           ; Get line number
     6BDC 2F20 
0032 6BDE C160  34         mov   @parm2,tmp1           ; Get pointer
     6BE0 2F22 
0033 6BE2 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6BE4 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6BE6 0FFF 
0039 6BE8 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6BEA 06E0  34         swpb  @parm3
     6BEC 2F24 
0044 6BEE D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6BF0 2F24 
0045 6BF2 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6BF4 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6BF6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BF8 3176 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6BFA C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6BFC 2F30 
0056 6BFE C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6C00 B000 
0057 6C02 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C04 2F30 
0058 6C06 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6C08 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C0A 3176 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6C0C C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6C0E 2F30 
0068 6C10 04E4  34         clr   @idx.top(tmp0)        ; /
     6C12 B000 
0069 6C14 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6C16 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6C18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6C1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6C1C C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6C1E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0136                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
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
0021 6C20 0649  14         dect  stack
0022 6C22 C64B  30         mov   r11,*stack            ; Save return address
0023 6C24 0649  14         dect  stack
0024 6C26 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6C28 0649  14         dect  stack
0026 6C2A C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6C2C 0649  14         dect  stack
0028 6C2E C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6C30 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C32 2F20 
0033               
0034 6C34 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6C36 3176 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6C38 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6C3A 2F30 
0039 6C3C C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6C3E B000 
0040               
0041 6C40 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6C42 C185  18         mov   tmp1,tmp2             ; \
0047 6C44 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6C46 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6C48 00FF 
0052 6C4A 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6C4C 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6C4E C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6C50 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6C52 2F30 
0059 6C54 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6C56 2F32 
0060 6C58 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6C5A 04E0  34         clr   @outparm1
     6C5C 2F30 
0066 6C5E 04E0  34         clr   @outparm2
     6C60 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6C62 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6C64 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6C66 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6C68 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6C6A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0137                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0017 6C6C 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6C6E B000 
0018 6C70 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6C72 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6C74 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6C76 0606  14         dec   tmp2                  ; tmp2--
0026 6C78 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6C7A 045B  20         b     *r11                  ; Return to caller
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
0046 6C7C 0649  14         dect  stack
0047 6C7E C64B  30         mov   r11,*stack            ; Save return address
0048 6C80 0649  14         dect  stack
0049 6C82 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6C84 0649  14         dect  stack
0051 6C86 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6C88 0649  14         dect  stack
0053 6C8A C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6C8C 0649  14         dect  stack
0055 6C8E C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6C90 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6C92 2F20 
0060               
0061 6C94 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C96 3176 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6C98 C120  34         mov   @outparm1,tmp0        ; Index offset
     6C9A 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6C9C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C9E 2F22 
0070 6CA0 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6CA2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6CA4 2F20 
0074 6CA6 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6CA8 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6CAA B000 
0081 6CAC 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6CAE 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6CB0 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6CB2 2F22 
0088 6CB4 0287  22         ci    tmp3,2048
     6CB6 0800 
0089 6CB8 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6CBA 06A0  32         bl    @_idx.sams.mapcolumn.on
     6CBC 30F4 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6CBE C120  34         mov   @parm1,tmp0           ; Restore line number
     6CC0 2F20 
0103 6CC2 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6CC4 06A0  32         bl    @_idx.entry.delete.reorg
     6CC6 6C6C 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6CC8 06A0  32         bl    @_idx.sams.mapcolumn.off
     6CCA 313C 
0111                                                   ; Restore memory window layout
0112               
0113 6CCC 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6CCE 06A0  32         bl    @_idx.entry.delete.reorg
     6CD0 6C6C 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6CD2 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6CD4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6CD6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6CD8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6CDA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6CDC C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6CDE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0138                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0015                       ; sanity check 1
0016                       ;------------------------------------------------------
0017 6CE0 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6CE2 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6CE4 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6CE6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CE8 FFCE 
0026 6CEA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CEC 2026 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6CEE 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6CF0 B000 
0031 6CF2 C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6CF4 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6CF6 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Sanity check 2
0036                       ;------------------------------------------------------
0037 6CF8 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6CFA 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6CFC 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6CFE A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6D00 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6D02 AFFE 
0042 6D04 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6D06 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6D08 0644  14         dect  tmp0                  ; Move pointer up
0050 6D0A 0645  14         dect  tmp1                  ; Move pointer up
0051 6D0C 0606  14         dec   tmp2                  ; Next index entry
0052 6D0E 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6D10 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6D12 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6D14 045B  20         b     *r11                  ; Return to caller
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
0082 6D16 0649  14         dect  stack
0083 6D18 C64B  30         mov   r11,*stack            ; Save return address
0084 6D1A 0649  14         dect  stack
0085 6D1C C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D1E 0649  14         dect  stack
0087 6D20 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D22 0649  14         dect  stack
0089 6D24 C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6D26 0649  14         dect  stack
0091 6D28 C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6D2A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6D2C 2F22 
0096 6D2E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6D30 2F20 
0097 6D32 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6D34 C1E0  34         mov   @parm2,tmp3
     6D36 2F22 
0104 6D38 0287  22         ci    tmp3,2048
     6D3A 0800 
0105 6D3C 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6D3E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6D40 30F4 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6D42 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D44 2F22 
0117 6D46 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6D48 06A0  32         bl    @_idx.entry.insert.reorg
     6D4A 6CE0 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6D4C 06A0  32         bl    @_idx.sams.mapcolumn.off
     6D4E 313C 
0125                                                   ; Restore memory window layout
0126               
0127 6D50 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6D52 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6D54 2F22 
0133               
0134 6D56 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6D58 3176 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6D5A C120  34         mov   @outparm1,tmp0        ; Index offset
     6D5C 2F30 
0139               
0140 6D5E 06A0  32         bl    @_idx.entry.insert.reorg
     6D60 6CE0 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6D62 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6D64 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6D66 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6D68 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6D6A C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6D6C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0139                       ;-----------------------------------------------------------------------
0140                       ; Logic for Editor Buffer
0141                       ;-----------------------------------------------------------------------
0142                       copy  "edb.utils.asm"          ; Editor buffer utilities
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
0020 6D6E 0649  14         dect  stack
0021 6D70 C64B  30         mov   r11,*stack            ; Save return address
0022 6D72 0649  14         dect  stack
0023 6D74 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6D76 0649  14         dect  stack
0025 6D78 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a: Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.adjust.hipage.check_setpage:
0030 6D7A C120  34         mov   @edb.next_free.ptr,tmp0
     6D7C A208 
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 6D7E 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6D80 0FFF 
0035 6D82 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6D84 0052 
0036 6D86 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D88 0FF0 
0037 6D8A 1105  14         jlt   edb.adjust.hipage.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b: Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 6D8C 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D8E A218 
0043 6D90 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D92 A200 
     6D94 A208 
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c: Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.adjust.hipage.setpage:
0049 6D96 C120  34         mov   @edb.sams.hipage,tmp0
     6D98 A218 
0050 6D9A C160  34         mov   @edb.top.ptr,tmp1
     6D9C A200 
0051 6D9E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6DA0 253C 
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 6DA2 1004  14         jmp   edb.adjust.hipage.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.adjust.hipage.crash:
0060 6DA4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DA6 FFCE 
0061 6DA8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DAA 2026 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.adjust.hipage.exit:
0066 6DAC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 6DAE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 6DB0 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 6DB2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0143                       copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
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
0021 6DB4 0649  14         dect  stack
0022 6DB6 C64B  30         mov   r11,*stack            ; Push return address
0023 6DB8 0649  14         dect  stack
0024 6DBA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6DBC 0649  14         dect  stack
0026 6DBE C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Sanity check
0029                       ;------------------------------------------------------
0030 6DC0 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6DC2 A204 
0031 6DC4 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Sanity check failed
0035                                                   ;--------------------------
0036 6DC6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DC8 FFCE 
0037 6DCA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DCC 2026 
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 6DCE C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     6DD0 2F20 
0043               
0044 6DD2 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6DD4 6C20 
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 6DD6 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6DD8 2F32 
0050 6DDA C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6DDC 2F30 
0051 6DDE 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 6DE0 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6DE2 A008 
0057 6DE4 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 6DE6 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6DE8 253C 
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 6DEA C820  54         mov   @outparm2,@tv.sams.c000
     6DEC 2F32 
     6DEE A008 
0066                                                   ; Set page in shadow registers
0067               
0068 6DF0 C820  54         mov   @outparm2,@edb.sams.page
     6DF2 2F32 
     6DF4 A216 
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 6DF6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6DF8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6DFA C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6DFC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0144                       copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
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
0027 6DFE 0649  14         dect  stack
0028 6E00 C64B  30         mov   r11,*stack            ; Save return address
0029 6E02 0649  14         dect  stack
0030 6E04 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6E06 0649  14         dect  stack
0032 6E08 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6E0A 0649  14         dect  stack
0034 6E0C C646  30         mov   tmp2,*stack           ; Push tmp2
0035                       ;------------------------------------------------------
0036                       ; Get values
0037                       ;------------------------------------------------------
0038 6E0E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6E10 A10C 
     6E12 2F6A 
0039 6E14 04E0  34         clr   @fb.column
     6E16 A10C 
0040 6E18 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6E1A 69F8 
0041                       ;------------------------------------------------------
0042                       ; Prepare scan
0043                       ;------------------------------------------------------
0044 6E1C 04C4  14         clr   tmp0                  ; Counter
0045 6E1E C160  34         mov   @fb.current,tmp1      ; Get position
     6E20 A102 
0046 6E22 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6E24 2F6C 
0047                       ;------------------------------------------------------
0048                       ; Scan line for >00 byte termination
0049                       ;------------------------------------------------------
0050               edb.line.pack.fb.scan:
0051 6E26 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0052 6E28 0986  56         srl   tmp2,8                ; Right justify
0053 6E2A 1309  14         jeq   edb.line.pack.fb.check_setpage
0054                                                   ; Stop scan if >00 found
0055 6E2C 0584  14         inc   tmp0                  ; Increase string length
0056                       ;------------------------------------------------------
0057                       ; Not more than 80 characters
0058                       ;------------------------------------------------------
0059 6E2E 0284  22         ci    tmp0,colrow
     6E30 0050 
0060 6E32 1305  14         jeq   edb.line.pack.fb.check_setpage
0061                                                   ; Stop scan if 80 characters processed
0062 6E34 10F8  14         jmp   edb.line.pack.fb.scan ; Next character
0063                       ;------------------------------------------------------
0064                       ; Check failed, crash CPU!
0065                       ;------------------------------------------------------
0066               edb.line.pack.fb.crash:
0067 6E36 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E38 FFCE 
0068 6E3A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E3C 2026 
0069                       ;------------------------------------------------------
0070                       ; Check if highest SAMS page needs to be increased
0071                       ;------------------------------------------------------
0072               edb.line.pack.fb.check_setpage:
0073 6E3E C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6E40 2F6E 
0074               
0075 6E42 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     6E44 6D6E 
0076                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0077                                                   ; /                         free line
0078                       ;------------------------------------------------------
0079                       ; Step 2: Prepare for storing line
0080                       ;------------------------------------------------------
0081               edb.line.pack.fb.prepare:
0082 6E46 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6E48 A104 
     6E4A 2F20 
0083 6E4C A820  54         a     @fb.row,@parm1        ; /
     6E4E A106 
     6E50 2F20 
0084                       ;------------------------------------------------------
0085                       ; 2a. Update index
0086                       ;------------------------------------------------------
0087               edb.line.pack.fb.update_index:
0088 6E52 C820  54         mov   @edb.next_free.ptr,@parm2
     6E54 A208 
     6E56 2F22 
0089                                                   ; Pointer to new line
0090 6E58 C820  54         mov   @edb.sams.hipage,@parm3
     6E5A A218 
     6E5C 2F24 
0091                                                   ; SAMS page to use
0092               
0093 6E5E 06A0  32         bl    @idx.entry.update     ; Update index
     6E60 6BCE 
0094                                                   ; \ i  parm1 = Line number in editor buffer
0095                                                   ; | i  parm2 = pointer to line in
0096                                                   ; |            editor buffer
0097                                                   ; / i  parm3 = SAMS page
0098                       ;------------------------------------------------------
0099                       ; 3. Set line prefix in editor buffer
0100                       ;------------------------------------------------------
0101 6E62 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6E64 2F6C 
0102 6E66 C160  34         mov   @edb.next_free.ptr,tmp1
     6E68 A208 
0103                                                   ; Address of line in editor buffer
0104               
0105 6E6A 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6E6C A208 
0106               
0107 6E6E C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6E70 2F6E 
0108 6E72 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0109 6E74 1317  14         jeq   edb.line.pack.fb.prepexit
0110                                                   ; Nothing to copy if empty line
0111                       ;------------------------------------------------------
0112                       ; 4. Copy line from framebuffer to editor buffer
0113                       ;------------------------------------------------------
0114               edb.line.pack.fb.copyline:
0115 6E76 0286  22         ci    tmp2,2
     6E78 0002 
0116 6E7A 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0117 6E7C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0118 6E7E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0119 6E80 1007  14         jmp   edb.line.pack.fb.copyline.align16
0120               
0121               edb.line.pack.fb.copyline.checkbyte:
0122 6E82 0286  22         ci    tmp2,1
     6E84 0001 
0123 6E86 1602  14         jne   edb.line.pack.fb.copyline.block
0124 6E88 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0125 6E8A 1002  14         jmp   edb.line.pack.fb.copyline.align16
0126               
0127               edb.line.pack.fb.copyline.block:
0128 6E8C 06A0  32         bl    @xpym2m               ; Copy memory block
     6E8E 24A6 
0129                                                   ; \ i  tmp0 = source
0130                                                   ; | i  tmp1 = destination
0131                                                   ; / i  tmp2 = bytes to copy
0132                       ;------------------------------------------------------
0133                       ; 5: Align pointer to multiple of 16 memory address
0134                       ;------------------------------------------------------
0135               edb.line.pack.fb.copyline.align16:
0136 6E90 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6E92 2F6E 
     6E94 A208 
0137                                                      ; Add length of line
0138               
0139 6E96 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6E98 A208 
0140 6E9A 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0141 6E9C 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6E9E 000F 
0142 6EA0 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6EA2 A208 
0143                       ;------------------------------------------------------
0144                       ; 6: Restore SAMS page and prepare for exit
0145                       ;------------------------------------------------------
0146               edb.line.pack.fb.prepexit:
0147 6EA4 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6EA6 2F6A 
     6EA8 A10C 
0148               
0149 6EAA 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6EAC A218 
     6EAE A216 
0150 6EB0 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0151               
0152 6EB2 C120  34         mov   @edb.sams.page,tmp0
     6EB4 A216 
0153 6EB6 C160  34         mov   @edb.top.ptr,tmp1
     6EB8 A200 
0154 6EBA 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EBC 253C 
0155                                                   ; \ i  tmp0 = SAMS page number
0156                                                   ; / i  tmp1 = Memory address
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               edb.line.pack.fb.exit:
0161 6EBE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0162 6EC0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0163 6EC2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0164 6EC4 C2F9  30         mov   *stack+,r11           ; Pop R11
0165 6EC6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0145                       copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
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
0011               * @parm1 = Line to unpack in editor buffer
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
0028 6EC8 0649  14         dect  stack
0029 6ECA C64B  30         mov   r11,*stack            ; Save return address
0030 6ECC 0649  14         dect  stack
0031 6ECE C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6ED0 0649  14         dect  stack
0033 6ED2 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6ED4 0649  14         dect  stack
0035 6ED6 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Sanity check
0038                       ;------------------------------------------------------
0039 6ED8 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6EDA 2F20 
     6EDC A204 
0040 6EDE 1204  14         jle   !
0041 6EE0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6EE2 FFCE 
0042 6EE4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6EE6 2026 
0043                       ;------------------------------------------------------
0044                       ; Save parameters
0045                       ;------------------------------------------------------
0046 6EE8 C820  54 !       mov   @parm1,@rambuf
     6EEA 2F20 
     6EEC 2F6A 
0047 6EEE C820  54         mov   @parm2,@rambuf+2
     6EF0 2F22 
     6EF2 2F6C 
0048                       ;------------------------------------------------------
0049                       ; Calculate offset in frame buffer
0050                       ;------------------------------------------------------
0051 6EF4 C120  34         mov   @fb.colsline,tmp0
     6EF6 A10E 
0052 6EF8 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6EFA 2F22 
0053 6EFC C1A0  34         mov   @fb.top.ptr,tmp2
     6EFE A100 
0054 6F00 A146  18         a     tmp2,tmp1             ; Add base to offset
0055 6F02 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6F04 2F70 
0056                       ;------------------------------------------------------
0057                       ; Get pointer to line & page-in editor buffer page
0058                       ;------------------------------------------------------
0059 6F06 C120  34         mov   @parm1,tmp0
     6F08 2F20 
0060 6F0A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F0C 6DB4 
0061                                                   ; \ i  tmp0     = Line number
0062                                                   ; | o  outparm1 = Pointer to line
0063                                                   ; / o  outparm2 = SAMS page
0064                       ;------------------------------------------------------
0065                       ; Handle empty line
0066                       ;------------------------------------------------------
0067 6F0E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6F10 2F30 
0068 6F12 1603  14         jne   edb.line.unpack.fb.getlen
0069                                                   ; Continue if pointer is set
0070               
0071 6F14 04E0  34         clr   @rambuf+8             ; Set length=0
     6F16 2F72 
0072 6F18 100C  14         jmp   edb.line.unpack.fb.clear
0073                       ;------------------------------------------------------
0074                       ; Get line length
0075                       ;------------------------------------------------------
0076               edb.line.unpack.fb.getlen:
0077 6F1A C174  30         mov   *tmp0+,tmp1           ; Get line length
0078 6F1C C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6F1E 2F6E 
0079 6F20 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6F22 2F72 
0080                       ;------------------------------------------------------
0081                       ; Sanity check on line length
0082                       ;------------------------------------------------------
0083 6F24 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6F26 0050 
0084                                                   ; /
0085 6F28 1204  14         jle   edb.line.unpack.fb.clear
0086                       ;------------------------------------------------------
0087                       ; Crash the system
0088                       ;------------------------------------------------------
0089 6F2A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F2C FFCE 
0090 6F2E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F30 2026 
0091                       ;------------------------------------------------------
0092                       ; Erase chars from last column until column 80
0093                       ;------------------------------------------------------
0094               edb.line.unpack.fb.clear:
0095 6F32 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6F34 2F70 
0096 6F36 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6F38 2F72 
0097               
0098 6F3A 04C5  14         clr   tmp1                  ; Fill with >00
0099 6F3C C1A0  34         mov   @fb.colsline,tmp2
     6F3E A10E 
0100 6F40 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6F42 2F72 
0101 6F44 0586  14         inc   tmp2
0102               
0103 6F46 06A0  32         bl    @xfilm                ; Fill CPU memory
     6F48 223E 
0104                                                   ; \ i  tmp0 = Target address
0105                                                   ; | i  tmp1 = Byte to fill
0106                                                   ; / i  tmp2 = Repeat count
0107                       ;------------------------------------------------------
0108                       ; Prepare for unpacking data
0109                       ;------------------------------------------------------
0110               edb.line.unpack.fb.prepare:
0111 6F4A C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6F4C 2F72 
0112 6F4E 130F  14         jeq   edb.line.unpack.fb.exit
0113                                                   ; Exit if length = 0
0114 6F50 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6F52 2F6E 
0115 6F54 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6F56 2F70 
0116                       ;------------------------------------------------------
0117                       ; Sanity check on line length
0118                       ;------------------------------------------------------
0119               edb.line.unpack.fb.copy:
0120 6F58 0286  22         ci    tmp2,80               ; Check line length
     6F5A 0050 
0121 6F5C 1204  14         jle   !
0122                       ;------------------------------------------------------
0123                       ; Crash the system
0124                       ;------------------------------------------------------
0125 6F5E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F60 FFCE 
0126 6F62 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F64 2026 
0127                       ;------------------------------------------------------
0128                       ; Copy memory block
0129                       ;------------------------------------------------------
0130 6F66 C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6F68 2F30 
0131               
0132 6F6A 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6F6C 24A6 
0133                                                   ; \ i  tmp0 = Source address
0134                                                   ; | i  tmp1 = Target address
0135                                                   ; / i  tmp2 = Bytes to copy
0136                       ;------------------------------------------------------
0137                       ; Exit
0138                       ;------------------------------------------------------
0139               edb.line.unpack.fb.exit:
0140 6F6E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 6F70 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 6F72 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 6F74 C2F9  30         mov   *stack+,r11           ; Pop r11
0144 6F76 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0146                       copy  "edb.line.getlen.asm"    ; Get line length
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
0011               * @parm1 = Line number
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Length of line
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1
0019               ********|*****|*********************|**************************
0020               edb.line.getlength:
0021 6F78 0649  14         dect  stack
0022 6F7A C64B  30         mov   r11,*stack            ; Push return address
0023 6F7C 0649  14         dect  stack
0024 6F7E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6F80 0649  14         dect  stack
0026 6F82 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6F84 04E0  34         clr   @outparm1             ; Reset length
     6F86 2F30 
0031 6F88 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6F8A 2F32 
0032                       ;------------------------------------------------------
0033                       ; Map SAMS page
0034                       ;------------------------------------------------------
0035 6F8C C120  34         mov   @parm1,tmp0           ; Get line
     6F8E 2F20 
0036               
0037 6F90 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     6F92 6DB4 
0038                                                   ; \ i  tmp0     = Line number
0039                                                   ; | o  outparm1 = Pointer to line
0040                                                   ; / o  outparm2 = SAMS page
0041               
0042 6F94 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6F96 2F30 
0043 6F98 130A  14         jeq   edb.line.getlength.null
0044                                                   ; Set length to 0 if null-pointer
0045                       ;------------------------------------------------------
0046                       ; Process line prefix
0047                       ;------------------------------------------------------
0048 6F9A C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0049 6F9C C805  38         mov   tmp1,@outparm1        ; Save length
     6F9E 2F30 
0050                       ;------------------------------------------------------
0051                       ; Sanity check
0052                       ;------------------------------------------------------
0053 6FA0 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6FA2 0050 
0054 6FA4 1206  14         jle   edb.line.getlength.exit
0055                                                   ; Yes, exit
0056                       ;------------------------------------------------------
0057                       ; Crash the system
0058                       ;------------------------------------------------------
0059 6FA6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FA8 FFCE 
0060 6FAA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FAC 2026 
0061                       ;------------------------------------------------------
0062                       ; Set length to 0 if null-pointer
0063                       ;------------------------------------------------------
0064               edb.line.getlength.null:
0065 6FAE 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6FB0 2F30 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               edb.line.getlength.exit:
0070 6FB2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 6FB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 6FB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 6FB8 045B  20         b     *r11                  ; Return to caller
0074               
0075               
0076               
0077               ***************************************************************
0078               * edb.line.getlength2
0079               * Get length of current row (as seen from editor buffer side)
0080               ***************************************************************
0081               *  bl   @edb.line.getlength2
0082               *--------------------------------------------------------------
0083               * INPUT
0084               * @fb.row = Row in frame buffer
0085               *--------------------------------------------------------------
0086               * OUTPUT
0087               * @fb.row.length = Length of row
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0
0091               ********|*****|*********************|**************************
0092               edb.line.getlength2:
0093 6FBA 0649  14         dect  stack
0094 6FBC C64B  30         mov   r11,*stack            ; Save return address
0095 6FBE 0649  14         dect  stack
0096 6FC0 C644  30         mov   tmp0,*stack           ; Push tmp0
0097                       ;------------------------------------------------------
0098                       ; Calculate line in editor buffer
0099                       ;------------------------------------------------------
0100 6FC2 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6FC4 A104 
0101 6FC6 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6FC8 A106 
0102                       ;------------------------------------------------------
0103                       ; Get length
0104                       ;------------------------------------------------------
0105 6FCA C804  38         mov   tmp0,@parm1
     6FCC 2F20 
0106 6FCE 06A0  32         bl    @edb.line.getlength
     6FD0 6F78 
0107 6FD2 C820  54         mov   @outparm1,@fb.row.length
     6FD4 2F30 
     6FD6 A108 
0108                                                   ; Save row length
0109                       ;------------------------------------------------------
0110                       ; Exit
0111                       ;------------------------------------------------------
0112               edb.line.getlength2.exit:
0113 6FD8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 6FDA C2F9  30         mov   *stack+,r11           ; Pop R11
0115 6FDC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0147                       copy  "edb.line.copy.asm"      ; Copy line
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
0031 6FDE 0649  14         dect  stack
0032 6FE0 C64B  30         mov   r11,*stack            ; Save return address
0033 6FE2 0649  14         dect  stack
0034 6FE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0035 6FE6 0649  14         dect  stack
0036 6FE8 C645  30         mov   tmp1,*stack           ; Push tmp1
0037 6FEA 0649  14         dect  stack
0038 6FEC C646  30         mov   tmp2,*stack           ; Push tmp2
0039                       ;------------------------------------------------------
0040                       ; Sanity check
0041                       ;------------------------------------------------------
0042 6FEE 8820  54         c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
     6FF0 2F20 
     6FF2 A204 
0043 6FF4 1204  14         jle   !
0044 6FF6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FF8 FFCE 
0045 6FFA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FFC 2026 
0046                       ;------------------------------------------------------
0047                       ; Initialize
0048                       ;------------------------------------------------------
0049 6FFE C120  34 !       mov   @parm2,tmp0           ; Get target line number
     7000 2F22 
0050 7002 0604  14         dec   tmp0                  ; Base 0
0051 7004 C804  38         mov   tmp0,@rambuf+2        ; Save target line number
     7006 2F6C 
0052 7008 04E0  34         clr   @rambuf               ; Set source line length=0
     700A 2F6A 
0053 700C 04E0  34         clr   @rambuf+4             ; Nill-pointer source line
     700E 2F6E 
0054 7010 04E0  34         clr   @rambuf+6             ; Nill-pointer target line
     7012 2F70 
0055                       ;------------------------------------------------------
0056                       ; Get pointer to source line & page-in editor buffer SAMS page
0057                       ;------------------------------------------------------
0058 7014 C120  34         mov   @parm1,tmp0           ; Get source line number
     7016 2F20 
0059 7018 0604  14         dec   tmp0                  ; Base 0
0060               
0061 701A 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     701C 6DB4 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty source line
0067                       ;------------------------------------------------------
0068 701E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     7020 2F30 
0069 7022 1601  14         jne   edb.line.copy.getlen  ; Only continue if pointer is set
0070 7024 103C  14         jmp   edb.line.copy.index   ; Skip copy stuff, only update index
0071                       ;------------------------------------------------------
0072                       ; Get source line length
0073                       ;------------------------------------------------------
0074               edb.line.copy.getlen:
0075 7026 C154  26         mov   *tmp0,tmp1            ; Get line length
0076 7028 C805  38         mov   tmp1,@rambuf          ; Save length of line
     702A 2F6A 
0077 702C C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     702E 2F6E 
0078                       ;------------------------------------------------------
0079                       ; Sanity check on line length
0080                       ;------------------------------------------------------
0081 7030 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     7032 0050 
0082 7034 1204  14         jle   edb.line.copy.prepare ; /
0083                       ;------------------------------------------------------
0084                       ; Crash the system
0085                       ;------------------------------------------------------
0086 7036 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7038 FFCE 
0087 703A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     703C 2026 
0088                       ;------------------------------------------------------
0089                       ; 1: Prepare pointers for editor buffer in d000-dfff
0090                       ;------------------------------------------------------
0091               edb.line.copy.prepare:
0092 703E A820  54         a     @w$1000,@edb.top.ptr
     7040 201A 
     7042 A200 
0093 7044 A820  54         a     @w$1000,@edb.next_free.ptr
     7046 201A 
     7048 A208 
0094                                                   ; The editor buffer SAMS page for the target
0095                                                   ; line will be mapped into memory region
0096                                                   ; d000-dfff (instead of usual c000-cfff)
0097                                                   ;
0098                                                   ; This allows normal memory copy routine
0099                                                   ; to copy source line to target line.
0100                       ;------------------------------------------------------
0101                       ; 2: Check if highest SAMS page needs to be increased
0102                       ;------------------------------------------------------
0103 704A 06A0  32         bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
     704C 6D6E 
0104                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0105                                                   ; /                         free line
0106                       ;------------------------------------------------------
0107                       ; 3: Set parameters for copy line
0108                       ;------------------------------------------------------
0109 704E C120  34         mov   @rambuf+4,tmp0        ; Pointer to source line
     7050 2F6E 
0110 7052 C160  34         mov   @edb.next_free.ptr,tmp1
     7054 A208 
0111                                                   ; Pointer to space for new target line
0112               
0113 7056 C1A0  34         mov   @rambuf,tmp2          ; \ Set number of bytes to copy
     7058 2F6A 
0114 705A 05C6  14         inct  tmp2                  ; / (include line prefix word)
0115                       ;------------------------------------------------------
0116                       ; 4: Copy line
0117                       ;------------------------------------------------------
0118               edb.line.copy.line:
0119 705C 06A0  32         bl    @xpym2m               ; Copy memory block
     705E 24A6 
0120                                                   ; \ i  tmp0 = source
0121                                                   ; | i  tmp1 = destination
0122                                                   ; / i  tmp2 = bytes to copy
0123                       ;------------------------------------------------------
0124                       ; 5: Restore pointers to default memory region
0125                       ;------------------------------------------------------
0126 7060 6820  54         s     @w$1000,@edb.top.ptr
     7062 201A 
     7064 A200 
0127 7066 6820  54         s     @w$1000,@edb.next_free.ptr
     7068 201A 
     706A A208 
0128                                                   ; Restore memory c000-cfff region for
0129                                                   ; pointers to top of editor buffer and
0130                                                   ; next line
0131               
0132 706C C820  54         mov   @edb.next_free.ptr,@rambuf+6
     706E A208 
     7070 2F70 
0133                                                   ; Save pointer to target line
0134                       ;------------------------------------------------------
0135                       ; 6: Restore SAMS page c000-cfff as before copy
0136                       ;------------------------------------------------------
0137 7072 C120  34         mov   @edb.sams.page,tmp0
     7074 A216 
0138 7076 C160  34         mov   @edb.top.ptr,tmp1
     7078 A200 
0139 707A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     707C 253C 
0140                                                   ; \ i  tmp0 = SAMS page number
0141                                                   ; / i  tmp1 = Memory address
0142                       ;------------------------------------------------------
0143                       ; 7: Restore SAMS page d000-dfff as before copy
0144                       ;------------------------------------------------------
0145 707E C120  34         mov   @tv.sams.d000,tmp0
     7080 A00A 
0146 7082 0205  20         li    tmp1,>d000
     7084 D000 
0147 7086 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7088 253C 
0148                                                   ; \ i  tmp0 = SAMS page number
0149                                                   ; / i  tmp1 = Memory address
0150                       ;------------------------------------------------------
0151                       ; 8: Align pointer to multiple of 16 memory address
0152                       ;------------------------------------------------------
0153 708A A820  54         a     @rambuf,@edb.next_free.ptr
     708C 2F6A 
     708E A208 
0154                                                      ; Add length of line
0155               
0156 7090 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7092 A208 
0157 7094 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0158 7096 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7098 000F 
0159 709A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     709C A208 
0160                       ;------------------------------------------------------
0161                       ; 9: Update index
0162                       ;------------------------------------------------------
0163               edb.line.copy.index:
0164 709E C820  54         mov   @rambuf+2,@parm1      ; Line number of target line
     70A0 2F6C 
     70A2 2F20 
0165 70A4 C820  54         mov   @rambuf+6,@parm2      ; Pointer to new line
     70A6 2F70 
     70A8 2F22 
0166 70AA C820  54         mov   @edb.sams.hipage,@parm3
     70AC A218 
     70AE 2F24 
0167                                                   ; SAMS page to use
0168               
0169 70B0 06A0  32         bl    @idx.entry.update     ; Update index
     70B2 6BCE 
0170                                                   ; \ i  parm1 = Line number in editor buffer
0171                                                   ; | i  parm2 = pointer to line in
0172                                                   ; |            editor buffer
0173                                                   ; / i  parm3 = SAMS page
0174                       ;------------------------------------------------------
0175                       ; Exit
0176                       ;------------------------------------------------------
0177               edb.line.copy.exit:
0178 70B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0179 70B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0180 70B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0181 70BA C2F9  30         mov   *stack+,r11           ; Pop r11
0182 70BC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0148                       copy  "edb.line.del.asm"       ; Delete line
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
0024 70BE 0649  14         dect  stack
0025 70C0 C64B  30         mov   r11,*stack            ; Save return address
0026 70C2 0649  14         dect  stack
0027 70C4 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Sanity check
0030                       ;------------------------------------------------------
0031 70C6 8820  54         c     @parm1,@edb.lines     ; Line beyond editor buffer ?
     70C8 2F20 
     70CA A204 
0032 70CC 1204  14         jle   !
0033 70CE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70D0 FFCE 
0034 70D2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     70D4 2026 
0035                       ;------------------------------------------------------
0036                       ; Initialize
0037                       ;------------------------------------------------------
0038 70D6 0720  34 !       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70D8 A206 
0039                       ;-------------------------------------------------------
0040                       ; Special treatment if only 1 line in editor buffer
0041                       ;-------------------------------------------------------
0042 70DA C120  34          mov   @edb.lines,tmp0      ; \
     70DC A204 
0043 70DE 0284  22          ci    tmp0,1               ; | Only single line?
     70E0 0001 
0044 70E2 132C  14          jeq   edb.line.del.1stline ; / Yes, handle single line and exit
0045                       ;-------------------------------------------------------
0046                       ; Delete entry in index
0047                       ;-------------------------------------------------------
0048 70E4 0620  34         dec   @parm1                ; Base 0
     70E6 2F20 
0049 70E8 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     70EA A204 
     70EC 2F22 
0050               
0051 70EE 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     70F0 6C7C 
0052                                                   ; \ i  @parm1 = Line in editor buffer
0053                                                   ; / i  @parm2 = Last line for index reorg
0054               
0055 70F2 0620  34         dec   @edb.lines            ; One line less in editor buffer
     70F4 A204 
0056                       ;-------------------------------------------------------
0057                       ; Adjust M1 if set and line number < M1
0058                       ;-------------------------------------------------------
0059               edb.line.del.m1:
0060 70F6 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     70F8 A20C 
     70FA 2022 
0061 70FC 130D  14         jeq   edb.line.del.m2       ; Yes, skip to M2
0062               
0063 70FE 8820  54         c     @parm1,@edb.block.m1  ; \
     7100 2F20 
     7102 A20C 
0064 7104 1309  14         jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
0065 7106 1508  14         jgt   edb.line.del.m2       ; /
0066               
0067 7108 8820  54         c     @edb.block.m1,@w$0001 ; \
     710A A20C 
     710C 2002 
0068 710E 1304  14         jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1
0069               
0070 7110 0620  34         dec   @edb.block.m1         ; M1--
     7112 A20C 
0071 7114 0720  34         seto  @fb.colorize          ; Set colorize flag
     7116 A110 
0072                       ;-------------------------------------------------------
0073                       ; Adjust M2 if set and line number < M2
0074                       ;-------------------------------------------------------
0075               edb.line.del.m2:
0076 7118 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     711A A20E 
     711C 2022 
0077 711E 1314  14         jeq   edb.line.del.exit     ; Yes, exit early
0078               
0079 7120 8820  54         c     @parm1,@edb.block.m2  ; \
     7122 2F20 
     7124 A20E 
0080 7126 1310  14         jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
0081 7128 150F  14         jgt   edb.line.del.exit     ; /
0082               
0083 712A 8820  54         c     @edb.block.m2,@w$0001 ; \
     712C A20E 
     712E 2002 
0084 7130 130B  14         jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1
0085               
0086 7132 0620  34         dec   @edb.block.m2         ; M2--
     7134 A20E 
0087 7136 0720  34         seto  @fb.colorize          ; Set colorize flag
     7138 A110 
0088 713A 1006  14         jmp   edb.line.del.exit     ; Exit early
0089                       ;-------------------------------------------------------
0090                       ; Special treatment if only 1 line in editor buffer
0091                       ;-------------------------------------------------------
0092               edb.line.del.1stline:
0093 713C 04E0  34         clr   @parm1                ; 1st line
     713E 2F20 
0094 7140 04E0  34         clr   @parm2                ; 1st line
     7142 2F22 
0095               
0096 7144 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     7146 6C7C 
0097                                                   ; \ i  @parm1 = Line in editor buffer
0098                                                   ; / i  @parm2 = Last line for index reorg
0099                       ;------------------------------------------------------
0100                       ; Exit
0101                       ;------------------------------------------------------
0102               edb.line.del.exit:
0103 7148 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 714A C2F9  30         mov   *stack+,r11           ; Pop r11
0105 714C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0149                       copy  "edb.block.mark.asm"     ; Mark code block
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
0020 714E 0649  14         dect  stack
0021 7150 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 7152 C820  54         mov   @fb.row,@parm1
     7154 A106 
     7156 2F20 
0026 7158 06A0  32         bl    @fb.row2line          ; Row to editor line
     715A 69DE 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 715C 05A0  34         inc   @outparm1             ; Add base 1
     715E 2F30 
0032               
0033 7160 C820  54         mov   @outparm1,@edb.block.m1
     7162 2F30 
     7164 A20C 
0034                                                   ; Set block marker M1
0035 7166 0720  34         seto  @fb.colorize          ; Set colorize flag
     7168 A110 
0036 716A 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     716C A116 
0037 716E 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7170 A118 
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041               edb.block.mark.m1.exit:
0042 7172 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 7174 045B  20         b     *r11                  ; Return to caller
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
0062 7176 0649  14         dect  stack
0063 7178 C64B  30         mov   r11,*stack            ; Push return address
0064                       ;------------------------------------------------------
0065                       ; Initialisation
0066                       ;------------------------------------------------------
0067 717A C820  54         mov   @fb.row,@parm1
     717C A106 
     717E 2F20 
0068 7180 06A0  32         bl    @fb.row2line          ; Row to editor line
     7182 69DE 
0069                                                   ; \ i @fb.topline = Top line in frame buffer
0070                                                   ; | i @parm1      = Row in frame buffer
0071                                                   ; / o @outparm1   = Matching line in EB
0072               
0073 7184 05A0  34         inc   @outparm1             ; Add base 1
     7186 2F30 
0074               
0075 7188 C820  54         mov   @outparm1,@edb.block.m2
     718A 2F30 
     718C A20E 
0076                                                   ; Set block marker M2
0077               
0078 718E 0720  34         seto  @fb.colorize          ; Set colorize flag
     7190 A110 
0079 7192 0720  34         seto  @fb.dirty             ; Trigger refresh
     7194 A116 
0080 7196 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     7198 A118 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edb.block.mark.m2.exit:
0085 719A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 719C 045B  20         b     *r11                  ; Return to caller
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
0106 719E 0649  14         dect  stack
0107 71A0 C64B  30         mov   r11,*stack            ; Push return address
0108 71A2 0649  14         dect  stack
0109 71A4 C644  30         mov   tmp0,*stack           ; Push tmp0
0110 71A6 0649  14         dect  stack
0111 71A8 C645  30         mov   tmp1,*stack           ; Push tmp1
0112                       ;------------------------------------------------------
0113                       ; Get current line position in editor buffer
0114                       ;------------------------------------------------------
0115 71AA C820  54         mov   @fb.row,@parm1
     71AC A106 
     71AE 2F20 
0116 71B0 06A0  32         bl    @fb.row2line          ; Row to editor line
     71B2 69DE 
0117                                                   ; \ i @fb.topline = Top line in frame buffer
0118                                                   ; | i @parm1      = Row in frame buffer
0119                                                   ; / o @outparm1   = Matching line in EB
0120               
0121 71B4 C160  34         mov   @outparm1,tmp1        ; Current line position in editor buffer
     71B6 2F30 
0122 71B8 0585  14         inc   tmp1                  ; Add base 1
0123                       ;------------------------------------------------------
0124                       ; Check if M1 is set
0125                       ;------------------------------------------------------
0126 71BA C120  34         mov   @edb.block.m1,tmp0
     71BC A20C 
0127 71BE 0584  14         inc   tmp0
0128 71C0 1603  14         jne   edb.block.mark.is_line_m1
0129                       ;------------------------------------------------------
0130                       ; Set M1 and exit
0131                       ;------------------------------------------------------
0132               _edb.block.mark.m1.set:
0133 71C2 06A0  32         bl    @edb.block.mark.m1    ; Set marker M1
     71C4 714E 
0134 71C6 1004  14         jmp   edb.block.mark.exit   ; Exit now
0135                       ;------------------------------------------------------
0136                       ; Update M1 if current line < M1
0137                       ;------------------------------------------------------
0138               edb.block.mark.is_line_m1:
0139 71C8 8144  18         c     tmp0,tmp1             ; M1 > current line ?
0140 71CA 15FB  14         jgt   _edb.block.mark.m1.set
0141                                                   ; Set M1 to current line and exit
0142                       ;------------------------------------------------------
0143                       ; Set marker M2
0144                       ;------------------------------------------------------
0145 71CC 06A0  32         bl    @edb.block.mark.m2    ; Set marker M2
     71CE 7176 
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149               edb.block.mark.exit:
0150 71D0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0151 71D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0152 71D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0153 71D6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0150                       copy  "edb.block.reset.asm"    ; Reset markers
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
0017 71D8 0649  14         dect  stack
0018 71DA C64B  30         mov   r11,*stack            ; Push return address
0019 71DC 0649  14         dect  stack
0020 71DE C660  46         mov   @wyx,*stack           ; Push cursor position
     71E0 832A 
0021                       ;------------------------------------------------------
0022                       ; Clear markers
0023                       ;------------------------------------------------------
0024 71E2 0720  34         seto  @edb.block.m1         ; \ Remove markers M1 and M2
     71E4 A20C 
0025 71E6 0720  34         seto  @edb.block.m2         ; /
     71E8 A20E 
0026               
0027 71EA 0720  34         seto  @fb.colorize          ; Set colorize flag
     71EC A110 
0028 71EE 0720  34         seto  @fb.dirty             ; Trigger refresh
     71F0 A116 
0029 71F2 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     71F4 A118 
0030                       ;------------------------------------------------------
0031                       ; Reload color scheme
0032                       ;------------------------------------------------------
0033 71F6 0720  34         seto  @parm1
     71F8 2F20 
0034 71FA 06A0  32         bl    @pane.action.colorscheme.load
     71FC 77D2 
0035                                                   ; Reload color scheme
0036                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Remove markers
0040                       ;------------------------------------------------------
0041 71FE C820  54         mov   @tv.color,@parm1      ; Set normal color
     7200 A018 
     7202 2F20 
0042 7204 06A0  32         bl    @pane.action.colorscheme.statlines
     7206 78E4 
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046               
0047 7208 06A0  32         bl    @hchar
     720A 2788 
0048 720C 0034                   byte 0,52,32,18           ; Remove markers
     720E 2012 
0049 7210 1D00                   byte pane.botrow,0,32,50  ; Remove block shortcuts
     7212 2032 
0050 7214 FFFF                   data eol
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054               edb.block.reset.exit:
0055 7216 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7218 832A 
0056 721A C2F9  30         mov   *stack+,r11           ; Pop r11
0057 721C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0151                       copy  "edb.block.copy.asm"     ; Copy code block
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
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = success (>ffff), no action (>0000)
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2,tmp3
0018               *--------------------------------------------------------------
0019               * Remarks
0020               * For simplicity reasons we're assuming base 1 during copy
0021               * (first line starts at 1 instead of 0).
0022               * Makes it easier when comparing values.
0023               ********|*****|*********************|**************************
0024               edb.block.copy:
0025 721E 0649  14         dect  stack
0026 7220 C64B  30         mov   r11,*stack            ; Save return address
0027 7222 0649  14         dect  stack
0028 7224 C644  30         mov   tmp0,*stack           ; Push tmp0
0029 7226 0649  14         dect  stack
0030 7228 C645  30         mov   tmp1,*stack           ; Push tmp1
0031 722A 0649  14         dect  stack
0032 722C C646  30         mov   tmp2,*stack           ; Push tmp2
0033               
0034 722E 04E0  34         clr   @outparm1             ; No action (>0000)
     7230 2F30 
0035                       ;------------------------------------------------------
0036                       ; Sanity checks
0037                       ;------------------------------------------------------
0038 7232 C120  34         mov   @edb.block.m1,tmp0    ; M1 unset?
     7234 A20C 
0039 7236 1359  14         jeq   edb.block.copy.exit   ; Yes, exit early
0040               
0041 7238 C160  34         mov   @edb.block.m2,tmp1    ; M2 unset?
     723A A20E 
0042 723C 1356  14         jeq   edb.block.copy.exit   ; Yes, exit early
0043               
0044 723E 8144  18         c     tmp0,tmp1             ; M1 > M2
0045 7240 1554  14         jgt   edb.block.copy.exit   ; Yes, exit early
0046                       ;------------------------------------------------------
0047                       ; Get current line position in editor buffer
0048                       ;------------------------------------------------------
0049 7242 C820  54         mov   @fb.row,@parm1
     7244 A106 
     7246 2F20 
0050 7248 06A0  32         bl    @fb.row2line          ; Row to editor line
     724A 69DE 
0051                                                   ; \ i @fb.topline = Top line in frame buffer
0052                                                   ; | i @parm1      = Row in frame buffer
0053                                                   ; / o @outparm1   = Matching line in EB
0054               
0055 724C C120  34         mov   @outparm1,tmp0        ; \
     724E 2F30 
0056 7250 0584  14         inc   tmp0                  ; | Base 1 for current line in editor buffer
0057 7252 C804  38         mov   tmp0,@edb.block.var   ; / and store for later use
     7254 A210 
0058                       ;------------------------------------------------------
0059                       ; Show error and exit if M1 < current line < M2
0060                       ;------------------------------------------------------
0061 7256 8120  34         c     @outparm1,tmp0        ; Current line < M1 ?
     7258 2F30 
0062 725A 110D  14         jlt   !                     ; Yes, skip check
0063               
0064 725C 8160  34         c     @outparm1,tmp1        ; Current line > M2 ?
     725E 2F30 
0065 7260 150A  14         jgt   !                     ; Yes, skip check
0066               
0067 7262 06A0  32         bl    @cpym2m
     7264 24A0 
0068 7266 39A0                   data txt.block.inside,tv.error.msg,53
     7268 A026 
     726A 0035 
0069               
0070 726C 06A0  32         bl    @pane.errline.show    ; Show error line
     726E 7B70 
0071               
0072 7270 04E0  34         clr   @outparm1             ; No action (>0000)
     7272 2F30 
0073 7274 103A  14         jmp   edb.block.copy.exit   ; Exit early
0074                       ;------------------------------------------------------
0075                       ; Display "Copying...."
0076                       ;------------------------------------------------------
0077 7276 C820  54 !       mov   @tv.busycolor,@parm1  ; Get busy color
     7278 A01C 
     727A 2F20 
0078 727C 06A0  32         bl    @pane.action.colorscheme.statlines
     727E 78E4 
0079                                                   ; Set color combination for status lines
0080                                                   ; \ i  @parm1 = Color combination
0081                                                   ; /
0082               
0083 7280 06A0  32         bl    @hchar
     7282 2788 
0084 7284 1D00                   byte pane.botrow,0,32,50
     7286 2032 
0085 7288 FFFF                   data eol              ; Remove markers and block shortcuts
0086               
0087 728A 06A0  32         bl    @putat
     728C 2444 
0088 728E 1D00                   byte pane.botrow,0
0089 7290 361A                   data txt.block.copy   ; Display "Copying block...."
0090                       ;------------------------------------------------------
0091                       ; Prepare for copy
0092                       ;------------------------------------------------------
0093 7292 C120  34         mov   @edb.block.m1,tmp0    ; M1
     7294 A20C 
0094 7296 C1A0  34         mov   @edb.block.m2,tmp2    ; \
     7298 A20E 
0095 729A 6184  18         s     tmp0,tmp2             ; | Loop counter = M2-M1
0096 729C 0586  14         inc   tmp2                  ; /
0097               
0098 729E C160  34         mov   @edb.block.var,tmp1   ; Current line in editor buffer
     72A0 A210 
0099                       ;------------------------------------------------------
0100                       ; Copy code block
0101                       ;------------------------------------------------------
0102               edb.block.copy.loop:
0103 72A2 C805  38         mov   tmp1,@parm1           ; Target line for insert (current line)
     72A4 2F20 
0104 72A6 0620  34         dec   @parm1                ; Base 0 offset for index required
     72A8 2F20 
0105 72AA C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72AC A204 
     72AE 2F22 
0106               
0107 72B0 06A0  32         bl    @idx.entry.insert     ; Reorganize index, insert new line
     72B2 6D16 
0108                                                   ; \ i  @parm1 = Line for insert
0109                                                   ; / i  @parm2 = Last line to reorg
0110                       ;------------------------------------------------------
0111                       ; Increase M1-M2 block if target line before M1
0112                       ;------------------------------------------------------
0113 72B4 8805  38         c     tmp1,@edb.block.m1
     72B6 A20C 
0114 72B8 1506  14         jgt   edb.block.copy.loop.docopy
0115 72BA 1305  14         jeq   edb.block.copy.loop.docopy
0116               
0117 72BC 05A0  34         inc   @edb.block.m1         ; M1++
     72BE A20C 
0118 72C0 05A0  34         inc   @edb.block.m2         ; M2++
     72C2 A20E 
0119 72C4 0584  14         inc   tmp0                  ; Increase source line number too!
0120                       ;------------------------------------------------------
0121                       ; Copy line
0122                       ;------------------------------------------------------
0123               edb.block.copy.loop.docopy:
0124 72C6 C804  38         mov   tmp0,@parm1           ; Source line for copy
     72C8 2F20 
0125 72CA C805  38         mov   tmp1,@parm2           ; Target line for copy
     72CC 2F22 
0126               
0127 72CE 06A0  32         bl    @edb.line.copy        ; Copy line
     72D0 6FDE 
0128                                                   ; \ i  @parm1 = Source line in editor buffer
0129                                                   ; / i  @parm2 = Target line in editor buffer
0130                       ;------------------------------------------------------
0131                       ; Housekeeping for next copy
0132                       ;------------------------------------------------------
0133 72D2 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     72D4 A204 
0134 72D6 0584  14         inc   tmp0                  ; Next source line
0135 72D8 0585  14         inc   tmp1                  ; Next target line
0136 72DA 0606  14         dec   tmp2                  ; Update ĺoop counter
0137 72DC 15E2  14         jgt   edb.block.copy.loop   ; Next line
0138                       ;------------------------------------------------------
0139                       ; Copy loop completed
0140                       ;------------------------------------------------------
0141 72DE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72E0 A206 
0142 72E2 0720  34         seto  @fb.dirty             ; Frame buffer dirty
     72E4 A116 
0143 72E6 0720  34         seto  @outparm1             ; Copy completed
     72E8 2F30 
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               edb.block.copy.exit:
0148 72EA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0149 72EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 72EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 72F0 C2F9  30         mov   *stack+,r11           ; Pop R11
0152 72F2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0152                       copy  "edb.block.del.asm"      ; Delete code block
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
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Remarks
0020               * For simplicity reasons we're assuming base 1 during copy
0021               * (first line starts at 1 instead of 0).
0022               * Makes it easier when comparing values.
0023               ********|*****|*********************|**************************
0024               edb.block.delete:
0025 72F4 0649  14         dect  stack
0026 72F6 C64B  30         mov   r11,*stack            ; Save return address
0027 72F8 0649  14         dect  stack
0028 72FA C644  30         mov   tmp0,*stack           ; Push tmp0
0029 72FC 0649  14         dect  stack
0030 72FE C645  30         mov   tmp1,*stack           ; Push tmp1
0031 7300 0649  14         dect  stack
0032 7302 C646  30         mov   tmp2,*stack           ; Push tmp2
0033                       ;------------------------------------------------------
0034                       ; Sanity checks
0035                       ;------------------------------------------------------
0036 7304 C120  34         mov   @edb.block.m1,tmp0    ; \
     7306 A20C 
0037 7308 0584  14         inc   tmp0                  ; | M1 unset?
0038 730A 133A  14         jeq   edb.block.delete.exit ; / Yes, exit early
0039               
0040 730C C160  34         mov   @edb.block.m2,tmp1    ; \
     730E A20E 
0041 7310 0584  14         inc   tmp0                  ; | M2 unset?
0042 7312 1336  14         jeq   edb.block.delete.exit ; / Yes, exit early
0043                       ;------------------------------------------------------
0044                       ; Display "Deleting...."
0045                       ;------------------------------------------------------
0046 7314 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     7316 A01C 
     7318 2F20 
0047               
0048 731A 06A0  32         bl    @pane.action.colorscheme.statlines
     731C 78E4 
0049                                                   ; Set color combination for status lines
0050                                                   ; \ i  @parm1 = Color combination
0051                                                   ; /
0052               
0053 731E 06A0  32         bl    @hchar
     7320 2788 
0054 7322 1D00                   byte pane.botrow,0,32,50
     7324 2032 
0055 7326 FFFF                   data eol              ; Remove markers and block shortcuts
0056               
0057 7328 06A0  32         bl    @putat
     732A 2444 
0058 732C 1D00                   byte pane.botrow,0
0059 732E 3606                   data txt.block.del    ; Display "Deleting block...."
0060                       ;------------------------------------------------------
0061                       ; Prepare for delete
0062                       ;------------------------------------------------------
0063 7330 C120  34         mov   @edb.block.m1,tmp0    ; Get M1
     7332 A20C 
0064 7334 0604  14         dec   tmp0                  ; Base 0
0065               
0066 7336 C160  34         mov   @edb.block.m2,tmp1    ; Get M2
     7338 A20E 
0067 733A 0605  14         dec   tmp1                  ; Base 0
0068               
0069 733C C804  38         mov   tmp0,@parm1           ; Delete line on M1
     733E 2F20 
0070 7340 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7342 A204 
     7344 2F22 
0071 7346 0620  34         dec   @parm2                ; Base 0
     7348 2F22 
0072               
0073 734A C185  18         mov   tmp1,tmp2             ; \
0074 734C 6184  18         s     tmp0,tmp2             ; | Setup loop counter
0075 734E 0586  14         inc   tmp2                  ; /
0076                       ;------------------------------------------------------
0077                       ; Delete block
0078                       ;------------------------------------------------------
0079               edb.block.delete.loop:
0080 7350 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7352 6C7C 
0081                                                   ; \ i  @parm1 = Line in editor buffer
0082                                                   ; / i  @parm2 = Last line for index reorg
0083               
0084 7354 0620  34         dec   @edb.lines            ; \ One line removed from editor buffer
     7356 A204 
0085 7358 0620  34         dec   @parm2                ; /
     735A 2F22 
0086               
0087 735C 0606  14         dec   tmp2
0088 735E 15F8  14         jgt   edb.block.delete.loop ; Next line
0089 7360 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7362 A206 
0090                       ;------------------------------------------------------
0091                       ; Set topline for framebuffer refresh
0092                       ;------------------------------------------------------
0093 7364 8820  54         c     @fb.topline,@edb.lines
     7366 A104 
     7368 A204 
0094                                                   ; Beyond editor buffer?
0095 736A 1504  14         jgt   !                     ; Yes, goto line 1
0096               
0097 736C C820  54         mov   @fb.topline,@parm1    ; Set line to start with
     736E A104 
     7370 2F20 
0098 7372 1002  14         jmp   edb.block.delete.fb.refresh
0099 7374 04E0  34 !       clr   @parm1                ; Set line to start with
     7376 2F20 
0100                       ;------------------------------------------------------
0101                       ; Refresh framebuffer and reset block markers
0102                       ;------------------------------------------------------
0103               edb.block.delete.fb.refresh:
0104 7378 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     737A 6A68 
0105                                                   ; | i  @parm1 = Line to start with
0106                                                   ; /             (becomes @fb.topline)
0107               
0108 737C 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     737E 71D8 
0109                       ;------------------------------------------------------
0110                       ; Exit
0111                       ;------------------------------------------------------
0112               edb.block.delete.exit:
0113 7380 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0114 7382 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0115 7384 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0116 7386 C2F9  30         mov   *stack+,r11           ; Pop R11
**** **** ****     > stevie_b1.asm.395472
0153                       ;-----------------------------------------------------------------------
0154                       ; Command buffer handling
0155                       ;-----------------------------------------------------------------------
0156                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 7388 0649  14         dect  stack
0023 738A C64B  30         mov   r11,*stack            ; Save return address
0024 738C 0649  14         dect  stack
0025 738E C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7390 0649  14         dect  stack
0027 7392 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 7394 0649  14         dect  stack
0029 7396 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 7398 0649  14         dect  stack
0031 739A C660  46         mov   @wyx,*stack           ; Push cursor position
     739C 832A 
0032                       ;------------------------------------------------------
0033                       ; Dump Command buffer content
0034                       ;------------------------------------------------------
0035 739E C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     73A0 A310 
     73A2 832A 
0036               
0037 73A4 05A0  34         inc   @wyx                  ; X +1 for prompt
     73A6 832A 
0038               
0039 73A8 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     73AA 23FC 
0040                                                   ; \ i  @wyx = Cursor position
0041                                                   ; / o  tmp0 = VDP target address
0042               
0043 73AC 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     73AE A327 
0044 73B0 0206  20         li    tmp2,1*79             ; Command length
     73B2 004F 
0045               
0046 73B4 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     73B6 2452 
0047                                                   ; | i  tmp0 = VDP target address
0048                                                   ; | i  tmp1 = RAM source address
0049                                                   ; / i  tmp2 = Number of bytes to copy
0050                       ;------------------------------------------------------
0051                       ; Show command buffer prompt
0052                       ;------------------------------------------------------
0053 73B8 C820  54         mov   @cmdb.yxprompt,@wyx
     73BA A310 
     73BC 832A 
0054 73BE 06A0  32         bl    @putstr
     73C0 2420 
0055 73C2 39E6                   data txt.cmdb.prompt
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cmdb.refresh.exit:
0060 73C4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     73C6 832A 
0061 73C8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0062 73CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0063 73CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 73CE C2F9  30         mov   *stack+,r11           ; Pop r11
0065 73D0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0157                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 73D2 0649  14         dect  stack
0023 73D4 C64B  30         mov   r11,*stack            ; Save return address
0024 73D6 0649  14         dect  stack
0025 73D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 73DA 0649  14         dect  stack
0027 73DC C645  30         mov   tmp1,*stack           ; Push tmp1
0028 73DE 0649  14         dect  stack
0029 73E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 73E2 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     73E4 A326 
0034 73E6 06A0  32         bl    @film                 ; Clear command
     73E8 2238 
0035 73EA A327                   data  cmdb.cmd,>00,80
     73EC 0000 
     73EE 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 73F0 C120  34         mov   @cmdb.yxprompt,tmp0
     73F2 A310 
0040 73F4 0584  14         inc   tmp0
0041 73F6 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     73F8 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 73FA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 73FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 73FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 7400 C2F9  30         mov   *stack+,r11           ; Pop r11
0050 7402 045B  20         b     *r11                  ; Return to caller
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
0075 7404 0649  14         dect  stack
0076 7406 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 7408 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     740A 2A8E 
0081 740C A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     740E 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 7410 C820  54         mov   @waux1,@outparm1     ; Save length of string
     7412 833C 
     7414 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 7416 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 7418 045B  20         b     *r11                  ; Return to caller
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
0115 741A 0649  14         dect  stack
0116 741C C64B  30         mov   r11,*stack            ; Save return address
0117 741E 0649  14         dect  stack
0118 7420 C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 7422 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     7424 7404 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Sanity check
0125                       ;------------------------------------------------------
0126 7426 C120  34         mov   @outparm1,tmp0        ; Check length
     7428 2F30 
0127 742A 1300  14         jeq   cmdb.cmd.history.add.exit
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
0139 742C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 742E C2F9  30         mov   *stack+,r11           ; Pop r11
0141 7430 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0158                       ;-----------------------------------------------------------------------
0159                       ; File handling
0160                       ;-----------------------------------------------------------------------
0161                       copy  "fm.browse.asm"       ; File manager browse support routines
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
0017 7432 0649  14         dect  stack
0018 7434 C64B  30         mov   r11,*stack            ; Save return address
0019 7436 0649  14         dect  stack
0020 7438 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 743A 0649  14         dect  stack
0022 743C C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Sanity check
0025                       ;------------------------------------------------------
0026 743E C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     7440 2F20 
0027 7442 1334  14         jeq   fm.browse.fname.suffix.exit
0028                                                   ; Exit early if pointer is nill
0029               
0030 7444 0284  22         ci    tmp0,txt.newfile
     7446 3674 
0031 7448 1331  14         jeq   fm.browse.fname.suffix.exit
0032                                                   ; Exit early if "New file"
0033                       ;------------------------------------------------------
0034                       ; Get last character in filename
0035                       ;------------------------------------------------------
0036 744A D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0037 744C 0985  56         srl   tmp1,8                ; MSB to LSB
0038               
0039 744E A105  18         a     tmp1,tmp0             ; Move to last character
0040 7450 04C5  14         clr   tmp1
0041 7452 D154  26         movb  *tmp0,tmp1            ; Get character
0042 7454 0985  56         srl   tmp1,8                ; MSB to LSB
0043 7456 132A  14         jeq   fm.browse.fname.suffix.exit
0044                                                   ; Exit early if empty filename
0045                       ;------------------------------------------------------
0046                       ; Check mode (increase/decrease) character ASCII value
0047                       ;------------------------------------------------------
0048 7458 C1A0  34         mov   @parm2,tmp2           ; Get mode
     745A 2F22 
0049 745C 1314  14         jeq   fm.browse.fname.suffix.dec
0050                                                   ; Decrease ASCII if mode = 0
0051                       ;------------------------------------------------------
0052                       ; Increase ASCII value last character in filename
0053                       ;------------------------------------------------------
0054               fm.browse.fname.suffix.inc:
0055 745E 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     7460 0030 
0056 7462 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0057 7464 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7466 0039 
0058 7468 1109  14         jlt   !                     ; Next character
0059 746A 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0060                                                   ; Swith to alpha range A..Z
0061 746C 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     746E 005A 
0062 7470 131D  14         jeq   fm.browse.fname.suffix.exit
0063                                                   ; Already last alpha character, so exit
0064 7472 1104  14         jlt   !                     ; Next character
0065                       ;------------------------------------------------------
0066                       ; Invalid character, crash and burn
0067                       ;------------------------------------------------------
0068               fm.browse.fname.suffix.inc.crash:
0069 7474 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7476 FFCE 
0070 7478 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     747A 2026 
0071                       ;------------------------------------------------------
0072                       ; Increase ASCII value last character in filename
0073                       ;------------------------------------------------------
0074 747C 0585  14 !       inc   tmp1                  ; Increase ASCII value
0075 747E 1014  14         jmp   fm.browse.fname.suffix.store
0076               fm.browse.fname.suffix.inc.alpha:
0077 7480 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     7482 0041 
0078 7484 1011  14         jmp   fm.browse.fname.suffix.store
0079                       ;------------------------------------------------------
0080                       ; Decrease ASCII value last character in filename
0081                       ;------------------------------------------------------
0082               fm.browse.fname.suffix.dec:
0083 7486 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     7488 0030 
0084 748A 1310  14         jeq   fm.browse.fname.suffix.exit
0085                                                   ; Already first numeric character, so exit
0086 748C 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     748E 0039 
0087 7490 1207  14         jle   !                     ; Previous character
0088 7492 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     7494 0041 
0089 7496 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0090                                                   ; Switch to numeric range 0..9
0091 7498 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0092                                                   ; Invalid character
0093 749A 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     749C 0084 
0094 749E 1306  14         jeq   fm.browse.fname.suffix.exit
0095 74A0 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0096 74A2 1002  14         jmp   fm.browse.fname.suffix.store
0097               fm.browse.fname.suffix.dec.numeric:
0098 74A4 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     74A6 0039 
0099                       ;------------------------------------------------------
0100                       ; Store updatec character
0101                       ;------------------------------------------------------
0102               fm.browse.fname.suffix.store:
0103 74A8 0A85  56         sla   tmp1,8                ; LSB to MSB
0104 74AA D505  30         movb  tmp1,*tmp0            ; Store updated character
0105                       ;------------------------------------------------------
0106                       ; Exit
0107                       ;------------------------------------------------------
0108               fm.browse.fname.suffix.exit:
0109 74AC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0110 74AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111 74B0 C2F9  30         mov   *stack+,r11           ; Pop R11
0112 74B2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0162                       copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation
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
0020 74B4 0649  14         dect  stack
0021 74B6 C64B  30         mov   r11,*stack            ; Save return address
0022 74B8 0649  14         dect  stack
0023 74BA C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 74BC C120  34         mov   @fh.offsetopcode,tmp0
     74BE A44E 
0026 74C0 1307  14         jeq   !
0027                       ;------------------------------------------------------
0028                       ; Turn fast mode off
0029                       ;------------------------------------------------------
0030 74C2 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     74C4 A44E 
0031 74C6 0204  20         li    tmp0,txt.keys.load
     74C8 3726 
0032 74CA C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     74CC A322 
0033 74CE 1008  14         jmp   fm.fastmode.exit
0034                       ;------------------------------------------------------
0035                       ; Turn fast mode on
0036                       ;------------------------------------------------------
0037 74D0 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     74D2 0040 
0038 74D4 C804  38         mov   tmp0,@fh.offsetopcode
     74D6 A44E 
0039 74D8 0204  20         li    tmp0,txt.keys.load2
     74DA 3760 
0040 74DC C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     74DE A322 
0041               *--------------------------------------------------------------
0042               * Exit
0043               *--------------------------------------------------------------
0044               fm.fastmode.exit:
0045 74E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 74E2 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 74E4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0163                       ;-----------------------------------------------------------------------
0164                       ; User hook, background tasks
0165                       ;-----------------------------------------------------------------------
0166                       copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 74E6 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     74E8 200A 
0009 74EA 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 74EC C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     74EE 833C 
     74F0 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 74F2 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     74F4 200A 
0016 74F6 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     74F8 2F40 
     74FA 2F42 
0017 74FC 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 74FE 0204  20         li    tmp0,500              ; \
     7500 01F4 
0022 7502 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 7504 16FE  14         jne   -!                    ; /
0024 7506 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     7508 2F40 
     750A 2F42 
0025 750C 0460  28         b     @edkey.key.process    ; Process key
     750E 60E4 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 7510 04E0  34         clr   @keycode1
     7512 2F40 
0031 7514 04E0  34         clr   @keycode2
     7516 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 7518 0204  20         li    tmp0,2000             ; Avoid key bouncing
     751A 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 751C 0604  14         dec   tmp0
0042 751E 16FE  14         jne   hook.keyscan.bounce.loop
0043 7520 0460  28         b     @hookok               ; Return
     7522 2D0E 
0044               
**** **** ****     > stevie_b1.asm.395472
0167                       copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 7524 0649  14         dect  stack
0009 7526 C64B  30         mov   r11,*stack            ; Save return address
0010 7528 0649  14         dect  stack
0011 752A C644  30         mov   tmp0,*stack           ; Push tmp0
0012 752C 0649  14         dect  stack
0013 752E C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7530 0649  14         dect  stack
0015 7532 C646  30         mov   tmp2,*stack           ; Push tmp2
0016 7534 0649  14         dect  stack
0017 7536 C660  46         mov   @wyx,*stack           ; Push cursor position
     7538 832A 
0018                       ;------------------------------------------------------
0019                       ; ALPHA-Lock key down?
0020                       ;------------------------------------------------------
0021               task.vdp.panes.alpha_lock:
0022 753A 20A0  38         coc   @wbit10,config
     753C 200C 
0023 753E 1305  14         jeq   task.vdp.panes.alpha_lock.down
0024                       ;------------------------------------------------------
0025                       ; AlPHA-Lock is up
0026                       ;------------------------------------------------------
0027 7540 06A0  32         bl    @putat
     7542 2444 
0028 7544 1D4F                   byte   pane.botrow,79
0029 7546 36BC                   data   txt.alpha.up
0030 7548 1004  14         jmp   task.vdp.panes.cmdb.check
0031                       ;------------------------------------------------------
0032                       ; AlPHA-Lock is down
0033                       ;------------------------------------------------------
0034               task.vdp.panes.alpha_lock.down:
0035 754A 06A0  32         bl    @putat
     754C 2444 
0036 754E 1D4F                   byte   pane.botrow,79
0037 7550 36BE                   data   txt.alpha.down
0038                       ;------------------------------------------------------
0039                       ; Command buffer visible ?
0040                       ;------------------------------------------------------
0041               task.vdp.panes.cmdb.check
0042 7552 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7554 A302 
0043 7556 1308  14         jeq   !                     ; No, skip CMDB pane
0044                       ;-------------------------------------------------------
0045                       ; Draw command buffer pane if dirty
0046                       ;-------------------------------------------------------
0047               task.vdp.panes.cmdb.draw:
0048 7558 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     755A A318 
0049 755C 1348  14         jeq   task.vdp.panes.exit   ; No, skip update
0050               
0051 755E 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     7560 79DA 
0052 7562 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7564 A318 
0053 7566 1043  14         jmp   task.vdp.panes.exit   ; Exit early
0054                       ;-------------------------------------------------------
0055                       ; Check if frame buffer dirty
0056                       ;-------------------------------------------------------
0057 7568 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     756A A116 
0058 756C 1337  14         jeq   task.vdp.panes.botline
0059                                                   ; No, skip update
0060                       ;------------------------------------------------------
0061                       ; Determine how many rows to copy
0062                       ;------------------------------------------------------
0063 756E 8820  54         c     @edb.lines,@fb.scrrows
     7570 A204 
     7572 A11A 
0064 7574 1103  14         jlt   task.vdp.panes.setrows.small
0065 7576 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7578 A11A 
0066 757A 1003  14         jmp   task.vdp.panes.copy.fb
0067                       ;------------------------------------------------------
0068                       ; Less lines in editor buffer as rows in frame buffer
0069                       ;------------------------------------------------------
0070               task.vdp.panes.setrows.small:
0071 757C C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     757E A204 
0072 7580 0585  14         inc   tmp1
0073                       ;------------------------------------------------------
0074                       ; Determine area to copy
0075                       ;------------------------------------------------------
0076               task.vdp.panes.copy.fb:
0077 7582 C805  38         mov   tmp1,@parm1
     7584 2F20 
0078 7586 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     7588 6AD8 
0079                                                   ; \ i  @parm1 = number of lines to dump
0080                                                   ; /
0081                       ;------------------------------------------------------
0082                       ; Color the lines in the framebuffer (TAT)
0083                       ;------------------------------------------------------
0084 758A C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     758C A110 
0085 758E 1302  14         jeq   task.vdp.panes.copy.eof
0086                                                   ; Skip if flag reset
0087               
0088 7590 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7592 6B10 
0089                       ;-------------------------------------------------------
0090                       ; Draw EOF marker at end-of-file
0091                       ;-------------------------------------------------------
0092               task.vdp.panes.copy.eof:
0093 7594 8820  54         c     @edb.lines,@fb.scrrows
     7596 A204 
     7598 A11A 
0094                                                   ; On last screen page?
0095 759A 1520  14         jgt   task.vdp.panes.botline
0096                                                   ; Skip drawing EOF maker
0097 759C C120  34         mov   @edb.lines,tmp0
     759E A204 
0098 75A0 0584  14         inc   tmp0
0099                       ;-------------------------------------------------------
0100                       ; Do actual drawing of EOF marker
0101                       ;-------------------------------------------------------
0102               task.vdp.panes.draw_marker:
0103 75A2 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0104 75A4 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     75A6 832A 
0105               
0106 75A8 06A0  32         bl    @putstr
     75AA 2420 
0107 75AC 35D8                   data txt.marker       ; Display *EOF*
0108               
0109 75AE 06A0  32         bl    @setx
     75B0 26AA 
0110 75B2 0005                   data 5                ; Cursor after *EOF* string
0111                       ;-------------------------------------------------------
0112                       ; Clear rest of screen
0113                       ;-------------------------------------------------------
0114               task.vdp.panes.clear_screen:
0115 75B4 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     75B6 A10E 
0116               
0117 75B8 C160  34         mov   @wyx,tmp1             ;
     75BA 832A 
0118 75BC 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0119 75BE 0505  16         neg   tmp1                  ; tmp1 = -Y position
0120 75C0 A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     75C2 A11A 
0121               
0122 75C4 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0123 75C6 0226  22         ai    tmp2, -5              ; Adjust offset (because of *EOF* string)
     75C8 FFFB 
0124               
0125 75CA 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     75CC 23FC 
0126                                                   ; \ i  @wyx = Cursor position
0127                                                   ; / o  tmp0 = VDP address
0128               
0129 75CE 04C5  14         clr   tmp1                  ; Character to write (null!)
0130 75D0 06A0  32         bl    @xfilv                ; Fill VDP memory
     75D2 2296 
0131                                                   ; \ i  tmp0 = VDP destination
0132                                                   ; | i  tmp1 = byte to write
0133                                                   ; / i  tmp2 = Number of bytes to write
0134                       ;-------------------------------------------------------
0135                       ; Finished with frame buffer
0136                       ;-------------------------------------------------------
0137 75D4 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     75D6 A116 
0138 75D8 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     75DA A118 
0139                       ;-------------------------------------------------------
0140                       ; Refresh top and bottom line
0141                       ;-------------------------------------------------------
0142               task.vdp.panes.botline:
0143 75DC C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     75DE A118 
0144 75E0 1306  14         jeq   task.vdp.panes.exit   ; No, skip update
0145               
0146 75E2 06A0  32         bl    @pane.topline         ; Draw top line
     75E4 7ABE 
0147 75E6 06A0  32         bl    @pane.botline         ; Draw bottom line
     75E8 7C0A 
0148 75EA 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     75EC A118 
0149                       ;------------------------------------------------------
0150                       ; Exit task
0151                       ;------------------------------------------------------
0152               task.vdp.panes.exit:
0153 75EE C839  50         mov   *stack+,@wyx          ; Pop cursor position
     75F0 832A 
0154 75F2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 75F4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 75F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 75F8 C2F9  30         mov   *stack+,r11           ; Pop r11
0158 75FA 0460  28         b     @slotok
     75FC 2D8A 
**** **** ****     > stevie_b1.asm.395472
0168                       copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
**** **** ****     > task.vdp.cursor.sat.asm
0001               * FILE......: task.vdp.cursor.sat.asm
0002               * Purpose...: Copy cursor SAT to VDP
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 75FE 0649  14         dect  stack
0009 7600 C64B  30         mov   r11,*stack            ; Save return address
0010 7602 0649  14         dect  stack
0011 7604 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7606 0649  14         dect  stack
0013 7608 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 760A 0649  14         dect  stack
0015 760C C646  30         mov   tmp2,*stack           ; Push tmp2
0016                       ;------------------------------------------------------
0017                       ; Get pane with focus
0018                       ;------------------------------------------------------
0019 760E C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7610 A01E 
0020               
0021 7612 0284  22         ci    tmp0,pane.focus.fb
     7614 0000 
0022 7616 130F  14         jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus
0023               
0024 7618 0284  22         ci    tmp0,pane.focus.cmdb
     761A 0001 
0025 761C 1304  14         jeq   task.vdp.copy.sat.cmdb
0026                                                   ; CMDB buffer has focus
0027                       ;------------------------------------------------------
0028                       ; Assert failed. Invalid value
0029                       ;------------------------------------------------------
0030 761E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7620 FFCE 
0031 7622 06A0  32         bl    @cpu.crash            ; / Halt system.
     7624 2026 
0032                       ;------------------------------------------------------
0033                       ; CMDB buffer has focus, position cursor
0034                       ;------------------------------------------------------
0035               task.vdp.copy.sat.cmdb:
0036 7626 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7628 A30A 
     762A 832A 
0037 762C E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     762E 2020 
0038 7630 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7632 26B6 
0039                                                   ; | i  @WYX = Cursor YX
0040                                                   ; / o  tmp0 = Pixel YX
0041               
0042 7634 1006  14         jmp   task.vdp.copy.sat.write
0043                       ;------------------------------------------------------
0044                       ; Frame buffer has focus, position cursor
0045                       ;------------------------------------------------------
0046               task.vdp.copy.sat.fb:
0047 7636 E0A0  34         soc   @wbit0,config         ; Sprite adjustment on
     7638 2020 
0048 763A 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     763C 26B6 
0049                                                   ; | i  @WYX = Cursor YX
0050                                                   ; / o  tmp0 = Pixel YX
0051               
0052 763E 0224  22         ai    tmp0,>0800            ; Adjust VDP cursor because of topline bar
     7640 0800 
0053                       ;------------------------------------------------------
0054                       ; Dump sprite attribute table
0055                       ;------------------------------------------------------
0056               task.vdp.copy.sat.write:
0057 7642 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7644 2F5A 
0058               
0059 7646 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7648 244C 
0060 764A 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     764C 2F5A 
     764E 0004 
0061                                                   ; | i  tmp1 = ROM/RAM source
0062                                                   ; / i  tmp2 = Number of bytes to write
0063                       ;------------------------------------------------------
0064                       ; Exit
0065                       ;------------------------------------------------------
0066               task.vdp.copy.sat.exit:
0067 7650 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0068 7652 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0069 7654 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 7656 C2F9  30         mov   *stack+,r11           ; Pop r11
0071 7658 0460  28         b     @slotok               ; Exit task
     765A 2D8A 
**** **** ****     > stevie_b1.asm.395472
0169                       copy  "task.vdp.cursor.blink.asm"  ; Set cursor shape in VDP (blink)
**** **** ****     > task.vdp.cursor.blink.asm
0001               * FILE......: task.vdp.cursor.blink.asm
0002               * Purpose...: VDP sprite cursor shape
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ***************************************************************
0007               task.vdp.cursor:
0008 765C 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     765E A112 
0009 7660 1303  14         jeq   task.vdp.cursor.visible
0010 7662 04E0  34         clr   @ramsat+2              ; Hide cursor
     7664 2F5C 
0011 7666 1015  14         jmp   task.vdp.cursor.copy.sat
0012                                                    ; Update VDP SAT and exit task
0013               task.vdp.cursor.visible:
0014 7668 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     766A A20A 
0015 766C 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0016                       ;------------------------------------------------------
0017                       ; Cursor in insert mode
0018                       ;------------------------------------------------------
0019               task.vdp.cursor.visible.insert_mode:
0020 766E C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7670 A01E 
0021 7672 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0022                                                    ; Framebuffer has focus
0023 7674 0284  22         ci    tmp0,pane.focus.cmdb
     7676 0001 
0024 7678 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0025                       ;------------------------------------------------------
0026                       ; Editor cursor (insert mode)
0027                       ;------------------------------------------------------
0028               task.vdp.cursor.visible.insert_mode.fb:
0029 767A 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0030 767C 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0031                       ;------------------------------------------------------
0032                       ; Command buffer cursor (insert mode)
0033                       ;------------------------------------------------------
0034               task.vdp.cursor.visible.insert_mode.cmdb:
0035 767E 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7680 0100 
0036 7682 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0037                       ;------------------------------------------------------
0038                       ; Cursor in overwrite mode
0039                       ;------------------------------------------------------
0040               task.vdp.cursor.visible.overwrite_mode:
0041 7684 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7686 0200 
0042                       ;------------------------------------------------------
0043                       ; Set cursor shape
0044                       ;------------------------------------------------------
0045               task.vdp.cursor.visible.cursorshape:
0046 7688 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     768A A014 
0047 768C C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     768E A014 
     7690 2F5C 
0048                       ;------------------------------------------------------
0049                       ; Copy SAT
0050                       ;------------------------------------------------------
0051               task.vdp.cursor.copy.sat:
0052 7692 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7694 244C 
0053 7696 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     7698 2F5A 
     769A 0004 
0054                                                    ; | i  p1 = ROM/RAM source
0055                                                    ; / i  p2 = Number of bytes to write
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               task.vdp.cursor.exit:
0060 769C 0460  28         b     @slotok                ; Exit task
     769E 2D8A 
**** **** ****     > stevie_b1.asm.395472
0170                       copy  "task.oneshot.asm"           ; Run "one shot" task
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 76A0 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     76A2 A020 
0010 76A4 1301  14         jeq   task.oneshot.exit
0011               
0012 76A6 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 76A8 0460  28         b     @slotok                ; Exit task
     76AA 2D8A 
**** **** ****     > stevie_b1.asm.395472
0171                       ;-----------------------------------------------------------------------
0172                       ; Screen pane utilities
0173                       ;-----------------------------------------------------------------------
0174                       copy  "pane.utils.asm"             ; Pane utility functions
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
0020 76AC 0649  14         dect  stack
0021 76AE C64B  30         mov   r11,*stack            ; Push return address
0022 76B0 0649  14         dect  stack
0023 76B2 C660  46         mov   @wyx,*stack           ; Push cursor position
     76B4 832A 
0024                       ;-------------------------------------------------------
0025                       ; Clear message
0026                       ;-------------------------------------------------------
0027 76B6 06A0  32         bl    @hchar
     76B8 2788 
0028 76BA 0034                   byte 0,52,32,18
     76BC 2012 
0029 76BE FFFF                   data EOL              ; Clear message
0030               
0031 76C0 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     76C2 A020 
0032                       ;-------------------------------------------------------
0033                       ; Exit
0034                       ;-------------------------------------------------------
0035               pane.clearmsg.task.callback.exit:
0036 76C4 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     76C6 832A 
0037 76C8 C2F9  30         mov   *stack+,r11           ; Pop R11
0038 76CA 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.395472
0175                       copy  "pane.utils.hint.asm"        ; Show hint in pane
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
0021 76CC 0649  14         dect  stack
0022 76CE C64B  30         mov   r11,*stack            ; Save return address
0023 76D0 0649  14         dect  stack
0024 76D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 76D4 0649  14         dect  stack
0026 76D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 76D8 0649  14         dect  stack
0028 76DA C646  30         mov   tmp2,*stack           ; Push tmp2
0029 76DC 0649  14         dect  stack
0030 76DE C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 76E0 C820  54         mov   @parm1,@wyx           ; Set cursor
     76E2 2F20 
     76E4 832A 
0035 76E6 C160  34         mov   @parm2,tmp1           ; Get string to display
     76E8 2F22 
0036 76EA 06A0  32         bl    @xutst0               ; Display string
     76EC 2422 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 76EE C120  34         mov   @parm2,tmp0
     76F0 2F22 
0041 76F2 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 76F4 0984  56         srl   tmp0,8                ; Right justify
0043 76F6 C184  18         mov   tmp0,tmp2
0044 76F8 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 76FA 0506  16         neg   tmp2
0046 76FC 0226  22         ai    tmp2,80               ; Number of bytes to fill
     76FE 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 7700 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7702 2F20 
0051 7704 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 7706 C804  38         mov   tmp0,@wyx             ; / Set cursor
     7708 832A 
0053               
0054 770A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     770C 23FC 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 770E 0205  20         li    tmp1,32               ; Byte to fill
     7710 0020 
0059               
0060 7712 06A0  32         bl    @xfilv                ; Clear line
     7714 2296 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 7716 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 7718 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 771A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 771C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 771E C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7720 045B  20         b     *r11                  ; Return to caller
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
0095 7722 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7724 2F20 
0096 7726 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7728 2F22 
0097 772A 0649  14         dect  stack
0098 772C C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 772E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7730 76CC 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 7732 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 7734 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0176                       copy  "pane.utils.cursor.asm"      ; Cursor utility functions
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
0020 7736 0649  14         dect  stack
0021 7738 C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 773A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     773C 2290 
0026 773E 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7740 0000 
     7742 0004 
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 7744 06A0  32         bl    @clslot
     7746 2DE6 
0031 7748 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 774A 06A0  32         bl    @clslot
     774C 2DE6 
0034 774E 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 7750 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 7752 045B  20         b     *r11                  ; Return to caller
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
0060 7754 0649  14         dect  stack
0061 7756 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 7758 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     775A 2290 
0066 775C 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     775E 0000 
     7760 0004 
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0070 7762 06A0  32         bl    @mkslot
     7764 2DC8 
0071 7766 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7768 75FE 
0072 776A 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     776C 765C 
0073 776E FFFF                   data eol
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               pane.cursor.blink.exit:
0078 7770 C2F9  30         mov   *stack+,r11           ; Pop R11
0079 7772 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0177                       copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes
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
0017 7774 0649  14         dect  stack
0018 7776 C64B  30         mov   r11,*stack            ; Push return address
0019 7778 0649  14         dect  stack
0020 777A C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 777C C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     777E A012 
0023 7780 0284  22         ci    tmp0,tv.colorscheme.entries
     7782 0009 
0024                                                   ; Last entry reached?
0025 7784 1103  14         jlt   !
0026 7786 0204  20         li    tmp0,1                ; Reset color scheme index
     7788 0001 
0027 778A 1001  14         jmp   pane.action.colorscheme.switch
0028 778C 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 778E C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7790 A012 
0034               
0035 7792 06A0  32         bl    @pane.action.colorscheme.load
     7794 77D2 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 7796 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     7798 832A 
     779A 833C 
0041               
0042 779C 06A0  32         bl    @putnum
     779E 2A18 
0043 77A0 003E                   byte 0,62
0044 77A2 A012                   data tv.colorscheme,rambuf,>3020
     77A4 2F6A 
     77A6 3020 
0045               
0046 77A8 06A0  32         bl    @putat
     77AA 2444 
0047 77AC 0034                   byte 0,52
0048 77AE 39F8                   data txt.colorscheme  ; Show color palette message
0049               
0050 77B0 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     77B2 833C 
     77B4 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 77B6 0204  20         li    tmp0,12000
     77B8 2EE0 
0055 77BA 0604  14 !       dec   tmp0
0056 77BC 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 77BE 0204  20         li    tmp0,pane.clearmsg.task.callback
     77C0 76AC 
0061 77C2 C804  38         mov   tmp0,@tv.task.oneshot
     77C4 A020 
0062               
0063 77C6 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     77C8 2DF4 
0064 77CA 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 77CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 77CE C2F9  30         mov   *stack+,r11           ; Pop R11
0071 77D0 045B  20         b     *r11                  ; Return to caller
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
0092 77D2 0649  14         dect  stack
0093 77D4 C64B  30         mov   r11,*stack            ; Save return address
0094 77D6 0649  14         dect  stack
0095 77D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0096 77DA 0649  14         dect  stack
0097 77DC C645  30         mov   tmp1,*stack           ; Push tmp1
0098 77DE 0649  14         dect  stack
0099 77E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0100 77E2 0649  14         dect  stack
0101 77E4 C647  30         mov   tmp3,*stack           ; Push tmp3
0102 77E6 0649  14         dect  stack
0103 77E8 C648  30         mov   tmp4,*stack           ; Push tmp4
0104 77EA 0649  14         dect  stack
0105 77EC C660  46         mov   @parm1,*stack         ; Push parm1
     77EE 2F20 
0106                       ;-------------------------------------------------------
0107                       ; Turn screen of
0108                       ;-------------------------------------------------------
0109 77F0 C120  34         mov   @parm1,tmp0
     77F2 2F20 
0110 77F4 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     77F6 FFFF 
0111 77F8 1302  14         jeq   !                     ; Yes, so skip screen off
0112 77FA 06A0  32         bl    @scroff               ; Turn screen off
     77FC 2654 
0113                       ;-------------------------------------------------------
0114                       ; Get FG/BG colors framebuffer text
0115                       ;-------------------------------------------------------
0116 77FE C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7800 A012 
0117 7802 0604  14         dec   tmp0                  ; Internally work with base 0
0118               
0119 7804 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0120 7806 0224  22         ai    tmp0,tv.colorscheme.table
     7808 3416 
0121                                                   ; Add base for color scheme data table
0122 780A C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0123 780C C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     780E A018 
0124                       ;-------------------------------------------------------
0125                       ; Get and save cursor color
0126                       ;-------------------------------------------------------
0127 7810 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0128 7812 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7814 00FF 
0129 7816 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7818 A016 
0130                       ;-------------------------------------------------------
0131                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0132                       ;-------------------------------------------------------
0133 781A C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0134 781C 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     781E FF00 
0135 7820 0988  56         srl   tmp4,8                ; MSB to LSB
0136               
0137 7822 C134  30         mov   *tmp0+,tmp0           ; Get colors IJKL
0138               
0139 7824 C144  18         mov   tmp0,tmp1             ; \ Right align IJ and
0140 7826 0985  56         srl   tmp1,8                ; | save to @tv.busycolor
0141 7828 C805  38         mov   tmp1,@tv.busycolor    ; /
     782A A01C 
0142               
0143 782C C144  18         mov   tmp0,tmp1             ; \ Right align KL and
0144 782E 0245  22         andi  tmp1,>00ff            ; | save to @tv.markcolor
     7830 00FF 
0145 7832 C805  38         mov   tmp1,@tv.markcolor    ; /
     7834 A01A 
0146               
0147                       ;-------------------------------------------------------
0148                       ; Dump colors to VDP register 7 (text mode)
0149                       ;-------------------------------------------------------
0150 7836 C147  18         mov   tmp3,tmp1             ; Get work copy
0151 7838 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0152 783A 0265  22         ori   tmp1,>0700
     783C 0700 
0153 783E C105  18         mov   tmp1,tmp0
0154 7840 06A0  32         bl    @putvrx               ; Write VDP register
     7842 2336 
0155                       ;-------------------------------------------------------
0156                       ; Dump colors for frame buffer pane (TAT)
0157                       ;-------------------------------------------------------
0158 7844 0204  20         li    tmp0,vdp.fb.toprow.tat
     7846 1850 
0159                                                   ; VDP start address (frame buffer area)
0160 7848 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0161 784A 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0162 784C 0206  20         li    tmp2,(pane.botrow-1)*80
     784E 08C0 
0163                                                   ; Number of bytes to fill
0164 7850 06A0  32         bl    @xfilv                ; Fill colors
     7852 2296 
0165                                                   ; i \  tmp0 = start address
0166                                                   ; i |  tmp1 = byte to fill
0167                                                   ; i /  tmp2 = number of bytes to fill
0168               
0169 7854 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7856 A110 
0170 7858 06A0  32         bl    @fb.colorlines
     785A 6B10 
0171                       ;-------------------------------------------------------
0172                       ; Dump colors for CMDB pane (TAT)
0173                       ;-------------------------------------------------------
0174               pane.action.colorscheme.cmdbpane:
0175 785C C120  34         mov   @cmdb.visible,tmp0
     785E A302 
0176 7860 1307  14         jeq   pane.action.colorscheme.errpane
0177                                                   ; Skip if CMDB pane is hidden
0178               
0179 7862 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7864 1FD0 
0180                                                   ; VDP start address (CMDB top line)
0181 7866 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0182 7868 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     786A 0190 
0183 786C 06A0  32         bl    @xfilv                ; Fill colors
     786E 2296 
0184                                                   ; i \  tmp0 = start address
0185                                                   ; i |  tmp1 = byte to fill
0186                                                   ; i /  tmp2 = number of bytes to fill
0187                       ;-------------------------------------------------------
0188                       ; Dump colors for error line (TAT)
0189                       ;-------------------------------------------------------
0190               pane.action.colorscheme.errpane:
0191 7870 C120  34         mov   @tv.error.visible,tmp0
     7872 A024 
0192 7874 130A  14         jeq   pane.action.colorscheme.statline
0193                                                   ; Skip if error line pane is hidden
0194               
0195 7876 0205  20         li    tmp1,>00f6            ; White on dark red
     7878 00F6 
0196 787A C805  38         mov   tmp1,@parm1           ; Pass color combination
     787C 2F20 
0197               
0198 787E 0205  20         li    tmp1,pane.botrow-1    ;
     7880 001C 
0199 7882 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7884 2F22 
0200               
0201 7886 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7888 78FE 
0202                                                   ; \ i  @parm1 = Color combination
0203                                                   ; / i  @parm2 = Row on physical screen
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for top line and bottom line (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.statline:
0208 788A C160  34         mov   @tv.color,tmp1
     788C A018 
0209 788E 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7890 00FF 
0210 7892 C805  38         mov   tmp1,@parm1           ; Set color combination
     7894 2F20 
0211               
0212               
0213 7896 04E0  34         clr   @parm2                ; Top row on screen
     7898 2F22 
0214 789A 06A0  32         bl    @colors.line.set      ; Load color combination for line
     789C 78FE 
0215                                                   ; \ i  @parm1 = Color combination
0216                                                   ; / i  @parm2 = Row on physical screen
0217               
0218 789E 0205  20         li    tmp1,pane.botrow
     78A0 001D 
0219 78A2 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     78A4 2F22 
0220 78A6 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78A8 78FE 
0221                                                   ; \ i  @parm1 = Color combination
0222                                                   ; / i  @parm2 = Row on physical screen
0223                       ;-------------------------------------------------------
0224                       ; Dump cursor FG color to sprite table (SAT)
0225                       ;-------------------------------------------------------
0226               pane.action.colorscheme.cursorcolor:
0227 78AA C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     78AC A016 
0228               
0229 78AE C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     78B0 A01E 
0230 78B2 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     78B4 0000 
0231 78B6 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0232                                                   ; Yes, set cursor color
0233               
0234               pane.action.colorscheme.cursorcolor.cmdb:
0235 78B8 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     78BA 00F0 
0236 78BC 0A48  56         sla   tmp4,4                ; Move to MSB
0237 78BE 1003  14         jmp   !
0238               
0239               pane.action.colorscheme.cursorcolor.fb:
0240 78C0 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     78C2 000F 
0241 78C4 0A88  56         sla   tmp4,8                ; Move to MSB
0242               
0243 78C6 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     78C8 2F5D 
0244 78CA D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     78CC A015 
0245                       ;-------------------------------------------------------
0246                       ; Exit
0247                       ;-------------------------------------------------------
0248               pane.action.colorscheme.load.exit:
0249 78CE 06A0  32         bl    @scron                ; Turn screen on
     78D0 265C 
0250 78D2 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78D4 2F20 
0251 78D6 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0252 78D8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0253 78DA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0254 78DC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0255 78DE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0256 78E0 C2F9  30         mov   *stack+,r11           ; Pop R11
0257 78E2 045B  20         b     *r11                  ; Return to caller
0258               
0259               
0260               
0261               ***************************************************************
0262               * pane.action.colorscheme.statline
0263               * Set color combination for bottom status line
0264               ***************************************************************
0265               * bl @pane.action.colorscheme.statlines
0266               *--------------------------------------------------------------
0267               * INPUT
0268               * @parm1 = Color combination to set
0269               *--------------------------------------------------------------
0270               * OUTPUT
0271               * none
0272               *--------------------------------------------------------------
0273               * Register usage
0274               * tmp0, tmp1, tmp2
0275               ********|*****|*********************|**************************
0276               pane.action.colorscheme.statlines:
0277 78E4 0649  14         dect  stack
0278 78E6 C64B  30         mov   r11,*stack            ; Save return address
0279 78E8 0649  14         dect  stack
0280 78EA C644  30         mov   tmp0,*stack           ; Push tmp0
0281                       ;------------------------------------------------------
0282                       ; Bottom line
0283                       ;------------------------------------------------------
0284 78EC 0204  20         li    tmp0,pane.botrow
     78EE 001D 
0285 78F0 C804  38         mov   tmp0,@parm2           ; Last row on screen
     78F2 2F22 
0286 78F4 06A0  32         bl    @colors.line.set      ; Load color combination for line
     78F6 78FE 
0287                                                   ; \ i  @parm1 = Color combination
0288                                                   ; / i  @parm2 = Row on physical screen
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               pane.action.colorscheme.statlines.exit:
0293 78F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0294 78FA C2F9  30         mov   *stack+,r11           ; Pop R11
0295 78FC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0178                       ;-----------------------------------------------------------------------
0179                       ; Screen panes
0180                       ;-----------------------------------------------------------------------
0181                       copy  "colors.line.set.asm" ; Set color combination for line
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
0021 78FE 0649  14         dect  stack
0022 7900 C64B  30         mov   r11,*stack            ; Save return address
0023 7902 0649  14         dect  stack
0024 7904 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7906 0649  14         dect  stack
0026 7908 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 790A 0649  14         dect  stack
0028 790C C646  30         mov   tmp2,*stack           ; Push tmp2
0029 790E 0649  14         dect  stack
0030 7910 C660  46         mov   @parm1,*stack         ; Push parm1
     7912 2F20 
0031 7914 0649  14         dect  stack
0032 7916 C660  46         mov   @parm2,*stack         ; Push parm2
     7918 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 791A C120  34         mov   @parm2,tmp0           ; Get target line
     791C 2F22 
0037 791E 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7920 0050 
0038 7922 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 7924 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 7926 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     7928 1800 
0042 792A C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     792C 2F20 
0043 792E 0206  20         li    tmp2,80               ; Number of bytes to fill
     7930 0050 
0044               
0045 7932 06A0  32         bl    @xfilv                ; Fill colors
     7934 2296 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 7936 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     7938 2F22 
0054 793A C839  50         mov   *stack+,@parm1        ; Pop @parm1
     793C 2F20 
0055 793E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7940 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7942 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7944 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 7946 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0182                       copy  "pane.cmdb.asm"       ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.395472
0183                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
**** **** ****     > pane.cmdb.show.asm
0001               * FILE......: pane.cmdb.show.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
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
0022 7948 0649  14         dect  stack
0023 794A C64B  30         mov   r11,*stack            ; Save return address
0024 794C 0649  14         dect  stack
0025 794E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7950 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7952 832A 
     7954 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 7956 0204  20         li    tmp0,pane.botrow
     7958 001D 
0033 795A 6120  34         s     @cmdb.scrrows,tmp0
     795C A306 
0034 795E C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7960 A11A 
0035               
0036 7962 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7964 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7966 A30E 
0038               
0039 7968 0224  22         ai    tmp0,>0100
     796A 0100 
0040 796C C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     796E A310 
0041 7970 0584  14         inc   tmp0
0042 7972 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7974 A30A 
0043               
0044 7976 0720  34         seto  @cmdb.visible         ; Show pane
     7978 A302 
0045 797A 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     797C A318 
0046               
0047 797E 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7980 0001 
0048 7982 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7984 A01E 
0049               
0050 7986 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7988 7BD8 
0051               
0052 798A 0720  34         seto  @parm1                ; Do not turn screen off while
     798C 2F20 
0053                                                   ; reloading color scheme
0054               
0055 798E 06A0  32         bl    @pane.action.colorscheme.load
     7990 77D2 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 7992 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7994 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7996 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0184                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 7998 0649  14         dect  stack
0024 799A C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 799C C820  54         mov   @fb.scrrows.max,@fb.scrrows
     799E A11C 
     79A0 A11A 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 79A2 C820  54         mov   @tv.error.visible,@tv.error.visible
     79A4 A024 
     79A6 A024 
0033 79A8 1302  14         jeq   !
0034 79AA 0620  34         dec   @fb.scrrows
     79AC A11A 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 79AE 06A0  32 !       bl    @hchar
     79B0 2788 
0039 79B2 1C00                   byte pane.botrow-1,0,32,80*2
     79B4 20A0 
0040 79B6 FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Hide command buffer pane (rest)
0043                       ;------------------------------------------------------
0044 79B8 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     79BA A304 
     79BC 832A 
0045 79BE 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     79C0 A302 
0046 79C2 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     79C4 A116 
0047 79C6 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     79C8 A01E 
0048                       ;------------------------------------------------------
0049                       ; Reload current color scheme
0050                       ;------------------------------------------------------
0051 79CA 0720  34         seto  @parm1                ; Do not turn screen off while
     79CC 2F20 
0052                                                   ; reloading color scheme
0053               
0054 79CE 06A0  32         bl    @pane.action.colorscheme.load
     79D0 77D2 
0055                                                   ; Reload color scheme
0056                                                   ; i  parm1 = Skip screen off if >FFFF
0057                       ;------------------------------------------------------
0058                       ; Show cursor again
0059                       ;------------------------------------------------------
0060 79D2 06A0  32         bl    @pane.cursor.blink
     79D4 7754 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               pane.cmdb.hide.exit:
0065 79D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0066 79D8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0185                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0017 79DA 0649  14         dect  stack
0018 79DC C64B  30         mov   r11,*stack            ; Save return address
0019 79DE 0649  14         dect  stack
0020 79E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 79E2 0649  14         dect  stack
0022 79E4 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 79E6 0649  14         dect  stack
0024 79E8 C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 79EA C820  54         mov   @cmdb.panhead,@parm1  ; Get string to display
     79EC A31C 
     79EE 2F20 
0029 79F0 0204  20         li    tmp0,80
     79F2 0050 
0030 79F4 C804  38         mov   tmp0,@parm2           ; Set requested length
     79F6 2F22 
0031 79F8 0204  20         li    tmp0,1
     79FA 0001 
0032 79FC C804  38         mov   tmp0,@parm3           ; Set character to fill
     79FE 2F24 
0033 7A00 0204  20         li    tmp0,rambuf
     7A02 2F6A 
0034 7A04 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7A06 2F26 
0035               
0036               
0037 7A08 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7A0A 32D8 
0038                                                   ; \ i  @parm1 = Pointer to string
0039                                                   ; | i  @parm2 = Requested length
0040                                                   ; | i  @parm3 = Fill characgter
0041                                                   ; | i  @parm4 = Pointer to buffer with
0042                                                   ; /             output string
0043               
0044 7A0C C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7A0E A30E 
     7A10 832A 
0045 7A12 C160  34         mov   @outparm1,tmp1        ; | Display pane header
     7A14 2F30 
0046 7A16 06A0  32         bl    @xutst0               ; /
     7A18 2422 
0047                       ;------------------------------------------------------
0048                       ; Check dialog id
0049                       ;------------------------------------------------------
0050 7A1A 04E0  34         clr   @waux1                ; Default is show prompt
     7A1C 833C 
0051               
0052 7A1E C120  34         mov   @cmdb.dialog,tmp0
     7A20 A31A 
0053 7A22 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     7A24 0063 
0054 7A26 120E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0055 7A28 0720  34         seto  @waux1                ; /
     7A2A 833C 
0056                       ;------------------------------------------------------
0057                       ; Show info message instead of prompt
0058                       ;------------------------------------------------------
0059 7A2C C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     7A2E A31E 
0060 7A30 1309  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0061               
0062 7A32 06A0  32         bl    @at
     7A34 2694 
0063 7A36 1A00                   byte pane.botrow-3,0  ; Position cursor
0064               
0065 7A38 D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     7A3A A326 
0066 7A3C D195  26         movb  *tmp1,tmp2            ; |
0067 7A3E 0986  56         srl   tmp2,8                ; |
0068 7A40 06A0  32         bl    @xutst0               ; /  Display info message
     7A42 2422 
0069                       ;------------------------------------------------------
0070                       ; Clear lines after prompt in command buffer
0071                       ;------------------------------------------------------
0072               pane.cmdb.draw.clear:
0073 7A44 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7A46 A326 
0074 7A48 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0075 7A4A A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7A4C A310 
0076 7A4E C804  38         mov   tmp0,@wyx             ; /
     7A50 832A 
0077               
0078 7A52 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7A54 23FC 
0079                                                   ; \ i  @wyx = Cursor position
0080                                                   ; / o  tmp0 = VDP target address
0081               
0082 7A56 0205  20         li    tmp1,32
     7A58 0020 
0083               
0084 7A5A C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7A5C A326 
0085 7A5E 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0086 7A60 0506  16         neg   tmp2                  ; | Based on command & prompt length
0087 7A62 0226  22         ai    tmp2,2*80 - 1         ; /
     7A64 009F 
0088               
0089 7A66 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7A68 2296 
0090                                                   ; | i  tmp0 = VDP target address
0091                                                   ; | i  tmp1 = Byte to fill
0092                                                   ; / i  tmp2 = Number of bytes to fill
0093                       ;------------------------------------------------------
0094                       ; Display pane hint in command buffer
0095                       ;------------------------------------------------------
0096               pane.cmdb.draw.hint:
0097 7A6A 0204  20         li    tmp0,pane.botrow - 1  ; \
     7A6C 001C 
0098 7A6E 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0099 7A70 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A72 2F20 
0100 7A74 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7A76 A320 
     7A78 2F22 
0101               
0102 7A7A 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A7C 76CC 
0103                                                   ; \ i  parm1 = Pointer to string with hint
0104                                                   ; / i  parm2 = YX position
0105                       ;------------------------------------------------------
0106                       ; Display keys in status line
0107                       ;------------------------------------------------------
0108 7A7E 0204  20         li    tmp0,pane.botrow      ; \
     7A80 001D 
0109 7A82 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0110 7A84 C804  38         mov   tmp0,@parm1           ; Set parameter
     7A86 2F20 
0111 7A88 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7A8A A322 
     7A8C 2F22 
0112               
0113 7A8E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7A90 76CC 
0114                                                   ; \ i  parm1 = Pointer to string with hint
0115                                                   ; / i  parm2 = YX position
0116                       ;------------------------------------------------------
0117                       ; ALPHA-Lock key down?
0118                       ;------------------------------------------------------
0119 7A92 20A0  38         coc   @wbit10,config
     7A94 200C 
0120 7A96 1305  14         jeq   pane.cmdb.draw.alpha.down
0121                       ;------------------------------------------------------
0122                       ; AlPHA-Lock is up
0123                       ;------------------------------------------------------
0124 7A98 06A0  32         bl    @putat
     7A9A 2444 
0125 7A9C 1D4F                   byte   pane.botrow,79
0126 7A9E 36BC                   data   txt.alpha.up
0127               
0128 7AA0 1004  14         jmp   pane.cmdb.draw.promptcmd
0129                       ;------------------------------------------------------
0130                       ; AlPHA-Lock is down
0131                       ;------------------------------------------------------
0132               pane.cmdb.draw.alpha.down:
0133 7AA2 06A0  32         bl    @putat
     7AA4 2444 
0134 7AA6 1D4F                   byte   pane.botrow,79
0135 7AA8 36BE                   data   txt.alpha.down
0136                       ;------------------------------------------------------
0137                       ; Command buffer content
0138                       ;------------------------------------------------------
0139               pane.cmdb.draw.promptcmd:
0140 7AAA C120  34         mov   @waux1,tmp0           ; Flag set?
     7AAC 833C 
0141 7AAE 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0142 7AB0 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7AB2 7388 
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               pane.cmdb.draw.exit:
0147 7AB4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0148 7AB6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0149 7AB8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 7ABA C2F9  30         mov   *stack+,r11           ; Pop r11
0151 7ABC 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.395472
0186               
0187                       copy  "pane.topline.asm"    ; Top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: Pane top line of screen
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
0017 7ABE 0649  14         dect  stack
0018 7AC0 C64B  30         mov   r11,*stack            ; Save return address
0019 7AC2 0649  14         dect  stack
0020 7AC4 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7AC6 0649  14         dect  stack
0022 7AC8 C660  46         mov   @wyx,*stack           ; Push cursor position
     7ACA 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7ACC 06A0  32         bl    @hchar
     7ACE 2788 
0027 7AD0 0032                   byte 0,50,16,1        ; Vertical line 1
     7AD2 1001 
0028 7AD4 0046                   byte 0,70,16,1        ; Vertical line 2
     7AD6 1001 
0029 7AD8 FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show buffer number
0032                       ;------------------------------------------------------
0033 7ADA 06A0  32         bl    @putat
     7ADC 2444 
0034 7ADE 0000                   byte  0,0
0035 7AE0 3670                   data  txt.bufnum
0036                       ;------------------------------------------------------
0037                       ; Show current file
0038                       ;------------------------------------------------------
0039 7AE2 C820  54         mov   @edb.filename.ptr,@parm1
     7AE4 A212 
     7AE6 2F20 
0040                                                   ; Get string to display
0041 7AE8 0204  20         li    tmp0,47
     7AEA 002F 
0042 7AEC C804  38         mov   tmp0,@parm2           ; Set requested length
     7AEE 2F22 
0043 7AF0 0204  20         li    tmp0,32
     7AF2 0020 
0044 7AF4 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7AF6 2F24 
0045 7AF8 0204  20         li    tmp0,rambuf
     7AFA 2F6A 
0046 7AFC C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7AFE 2F26 
0047               
0048               
0049 7B00 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7B02 32D8 
0050                                                   ; \ i  @parm1 = Pointer to string
0051                                                   ; | i  @parm2 = Requested length
0052                                                   ; | i  @parm3 = Fill characgter
0053                                                   ; | i  @parm4 = Pointer to buffer with
0054                                                   ; /             output string
0055               
0056 7B04 06A0  32         bl    @setx
     7B06 26AA 
0057 7B08 0003                   data 3                ; Position cursor
0058               
0059 7B0A C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     7B0C 2F30 
0060 7B0E 06A0  32         bl    @xutst0               ; /
     7B10 2422 
0061                       ;------------------------------------------------------
0062                       ; Show M1 marker
0063                       ;------------------------------------------------------
0064 7B12 C120  34         mov   @edb.block.m1,tmp0    ; \
     7B14 A20C 
0065 7B16 0584  14         inc   tmp0                  ; | Exit early if M1 unset (>ffff)
0066 7B18 1326  14         jeq   pane.topline.exit     ; /
0067               
0068 7B1A 06A0  32         bl    @putat
     7B1C 2444 
0069 7B1E 0034                   byte 0,52
0070 7B20 3686                   data txt.m1           ; Show M1 marker message
0071               
0072 7B22 C820  54         mov   @edb.block.m1,@parm1
     7B24 A20C 
     7B26 2F20 
0073 7B28 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B2A 32AC 
0074                                                   ; \ i @parm1           = uint16
0075                                                   ; / o @unpacked.string = Output string
0076               
0077 7B2C 0204  20         li    tmp0,>0500
     7B2E 0500 
0078 7B30 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B32 2F44 
0079               
0080 7B34 06A0  32         bl    @putat
     7B36 2444 
0081 7B38 0037                   byte 0,55
0082 7B3A 2F44                   data unpacked.string  ; Show M1 value
0083                       ;------------------------------------------------------
0084                       ; Show M2 marker
0085                       ;------------------------------------------------------
0086 7B3C C120  34         mov   @edb.block.m2,tmp0    ; \
     7B3E A20E 
0087 7B40 0584  14         inc   tmp0                  ; | Exit early if M2 unset (>ffff)
0088 7B42 1311  14         jeq   pane.topline.exit     ; /
0089               
0090 7B44 06A0  32         bl    @putat
     7B46 2444 
0091 7B48 003E                   byte 0,62
0092 7B4A 368A                   data txt.m2           ; Show M2 marker message
0093               
0094 7B4C C820  54         mov   @edb.block.m2,@parm1
     7B4E A20E 
     7B50 2F20 
0095 7B52 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7B54 32AC 
0096                                                   ; \ i @parm1           = uint16
0097                                                   ; / o @unpacked.string = Output string
0098               
0099               
0100 7B56 0204  20         li    tmp0,>0500
     7B58 0500 
0101 7B5A D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     7B5C 2F44 
0102               
0103 7B5E 06A0  32         bl    @putat
     7B60 2444 
0104 7B62 0041                   byte 0,65
0105 7B64 2F44                   data unpacked.string  ; Show M2 value
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               pane.topline.exit:
0110 7B66 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7B68 832A 
0111 7B6A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 7B6C C2F9  30         mov   *stack+,r11           ; Pop r11
0113 7B6E 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.395472
0188                       copy  "pane.errline.asm"    ; Error line
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
0022 7B70 0649  14         dect  stack
0023 7B72 C64B  30         mov   r11,*stack            ; Save return address
0024 7B74 0649  14         dect  stack
0025 7B76 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7B78 0649  14         dect  stack
0027 7B7A C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7B7C 0205  20         li    tmp1,>00f6            ; White on dark red
     7B7E 00F6 
0030 7B80 C805  38         mov   tmp1,@parm1
     7B82 2F20 
0031               
0032 7B84 0205  20         li    tmp1,pane.botrow-1    ;
     7B86 001C 
0033 7B88 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7B8A 2F22 
0034               
0035 7B8C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7B8E 78FE 
0036                                                   ; \ i  @parm1 = Color combination
0037                                                   ; / i  @parm2 = Row on physical screen
0038               
0039                       ;------------------------------------------------------
0040                       ; Pad error message to 80 characters
0041                       ;------------------------------------------------------
0042 7B90 0204  20         li    tmp0,tv.error.msg
     7B92 A026 
0043 7B94 C804  38         mov   tmp0,@parm1           ; Get pointer to string
     7B96 2F20 
0044               
0045 7B98 0204  20         li    tmp0,80
     7B9A 0050 
0046 7B9C C804  38         mov   tmp0,@parm2           ; Set requested length
     7B9E 2F22 
0047               
0048 7BA0 0204  20         li    tmp0,32
     7BA2 0020 
0049 7BA4 C804  38         mov   tmp0,@parm3           ; Set character to fill
     7BA6 2F24 
0050               
0051 7BA8 0204  20         li    tmp0,rambuf
     7BAA 2F6A 
0052 7BAC C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     7BAE 2F26 
0053               
0054 7BB0 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     7BB2 32D8 
0055                                                   ; \ i  @parm1 = Pointer to string
0056                                                   ; | i  @parm2 = Requested length
0057                                                   ; | i  @parm3 = Fill characgter
0058                                                   ; | i  @parm4 = Pointer to buffer with
0059                                                   ; /             output string
0060                       ;------------------------------------------------------
0061                       ; Show error message
0062                       ;------------------------------------------------------
0063 7BB4 06A0  32         bl    @at
     7BB6 2694 
0064 7BB8 1C00                   byte pane.botrow-1,0  ; Set cursor
0065               
0066 7BBA C160  34         mov   @outparm1,tmp1        ; \ Display error message
     7BBC 2F30 
0067 7BBE 06A0  32         bl    @xutst0               ; /
     7BC0 2422 
0068               
0069 7BC2 C120  34         mov   @fb.scrrows.max,tmp0
     7BC4 A11C 
0070 7BC6 0604  14         dec   tmp0
0071 7BC8 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7BCA A11A 
0072               
0073 7BCC 0720  34         seto  @tv.error.visible     ; Error line is visible
     7BCE A024 
0074                       ;------------------------------------------------------
0075                       ; Exit
0076                       ;------------------------------------------------------
0077               pane.errline.show.exit:
0078 7BD0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 7BD2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 7BD4 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 7BD6 045B  20         b     *r11                  ; Return to caller
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
0103 7BD8 0649  14         dect  stack
0104 7BDA C64B  30         mov   r11,*stack            ; Save return address
0105 7BDC 0649  14         dect  stack
0106 7BDE C644  30         mov   tmp0,*stack           ; Push tmp0
0107                       ;------------------------------------------------------
0108                       ; Hide command buffer pane
0109                       ;------------------------------------------------------
0110 7BE0 06A0  32         bl    @errline.init         ; Clear error line
     7BE2 3240 
0111               
0112 7BE4 C120  34         mov   @tv.color,tmp0        ; Get colors
     7BE6 A018 
0113 7BE8 0984  56         srl   tmp0,8                ; Right aligns
0114 7BEA C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7BEC 2F20 
0115               
0116               
0117 7BEE 0205  20         li    tmp1,pane.botrow-1    ;
     7BF0 001C 
0118 7BF2 C805  38         mov   tmp1,@parm2           ; Error line on screen
     7BF4 2F22 
0119               
0120 7BF6 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7BF8 78FE 
0121                                                   ; \ i  @parm1 = Color combination
0122                                                   ; / i  @parm2 = Row on physical screen
0123               
0124 7BFA 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     7BFC A024 
0125 7BFE C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7C00 A11C 
     7C02 A11A 
0126                                                   ; Set frame buffer to full size again
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130               pane.errline.hide.exit:
0131 7C04 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0132 7C06 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7C08 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.395472
0189                       copy  "pane.botline.asm"    ; Bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Pane status bottom line
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
0017 7C0A 0649  14         dect  stack
0018 7C0C C64B  30         mov   r11,*stack            ; Save return address
0019 7C0E 0649  14         dect  stack
0020 7C10 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7C12 0649  14         dect  stack
0022 7C14 C660  46         mov   @wyx,*stack           ; Push cursor position
     7C16 832A 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7C18 06A0  32         bl    @hchar
     7C1A 2788 
0027 7C1C 1D32                   byte pane.botrow,50,16,1       ; Vertical line 1
     7C1E 1001 
0028 7C20 1D47                   byte pane.botrow,71,16,1       ; Vertical line 2
     7C22 1001 
0029 7C24 FFFF                   data eol
0030                       ;------------------------------------------------------
0031                       ; Show block shortcuts if set
0032                       ;------------------------------------------------------
0033 7C26 C120  34         mov   @edb.block.m2,tmp0    ; \
     7C28 A20E 
0034 7C2A 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0035                                                   ; /
0036 7C2C 1304  14         jeq   pane.botline.show_mode
0037               
0038 7C2E 06A0  32         bl    @putat
     7C30 2444 
0039 7C32 1D00                   byte pane.botrow,0
0040 7C34 368E                   data txt.keys.block   ; Show block shortcuts
0041                       ;------------------------------------------------------
0042                       ; Show text editing mode
0043                       ;------------------------------------------------------
0044               pane.botline.show_mode:
0045 7C36 C120  34         mov   @edb.insmode,tmp0
     7C38 A20A 
0046 7C3A 1605  14         jne   pane.botline.show_mode.insert
0047                       ;------------------------------------------------------
0048                       ; Overwrite mode
0049                       ;------------------------------------------------------
0050 7C3C 06A0  32         bl    @putat
     7C3E 2444 
0051 7C40 1D34                   byte  pane.botrow,52
0052 7C42 35E4                   data  txt.ovrwrite
0053 7C44 1004  14         jmp   pane.botline.show_changed
0054                       ;------------------------------------------------------
0055                       ; Insert  mode
0056                       ;------------------------------------------------------
0057               pane.botline.show_mode.insert:
0058 7C46 06A0  32         bl    @putat
     7C48 2444 
0059 7C4A 1D34                   byte  pane.botrow,52
0060 7C4C 35E8                   data  txt.insert
0061                       ;------------------------------------------------------
0062                       ; Show if text was changed in editor buffer
0063                       ;------------------------------------------------------
0064               pane.botline.show_changed:
0065 7C4E C120  34         mov   @edb.dirty,tmp0
     7C50 A206 
0066 7C52 1305  14         jeq   pane.botline.show_linecol
0067                       ;------------------------------------------------------
0068                       ; Show "*"
0069                       ;------------------------------------------------------
0070 7C54 06A0  32         bl    @putat
     7C56 2444 
0071 7C58 1D38                   byte pane.botrow,56
0072 7C5A 35EC                   data txt.star
0073 7C5C 1000  14         jmp   pane.botline.show_linecol
0074                       ;------------------------------------------------------
0075                       ; Show "line,column"
0076                       ;------------------------------------------------------
0077               pane.botline.show_linecol:
0078 7C5E C820  54         mov   @fb.row,@parm1
     7C60 A106 
     7C62 2F20 
0079 7C64 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C66 69DE 
0080                                                   ; \ i @fb.topline = Top line in frame buffer
0081                                                   ; | i @parm1      = Row in frame buffer
0082                                                   ; / o @outparm1   = Matching line in EB
0083               
0084 7C68 05A0  34         inc   @outparm1             ; Add base 1
     7C6A 2F30 
0085                       ;------------------------------------------------------
0086                       ; Show line
0087                       ;------------------------------------------------------
0088 7C6C 06A0  32         bl    @putnum
     7C6E 2A18 
0089 7C70 1D3B                   byte  pane.botrow,59  ; YX
0090 7C72 2F30                   data  outparm1,rambuf
     7C74 2F6A 
0091 7C76 3020                   byte  48              ; ASCII offset
0092                             byte  32              ; Padding character
0093                       ;------------------------------------------------------
0094                       ; Show comma
0095                       ;------------------------------------------------------
0096 7C78 06A0  32         bl    @putat
     7C7A 2444 
0097 7C7C 1D40                   byte  pane.botrow,64
0098 7C7E 35D5                   data  txt.delim
0099                       ;------------------------------------------------------
0100                       ; Show column
0101                       ;------------------------------------------------------
0102 7C80 06A0  32         bl    @film
     7C82 2238 
0103 7C84 2F6F                   data rambuf+5,32,12   ; Clear work buffer with space character
     7C86 0020 
     7C88 000C 
0104               
0105 7C8A C820  54         mov   @fb.column,@waux1
     7C8C A10C 
     7C8E 833C 
0106 7C90 05A0  34         inc   @waux1                ; Offset 1
     7C92 833C 
0107               
0108 7C94 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7C96 299A 
0109 7C98 833C                   data  waux1,rambuf
     7C9A 2F6A 
0110 7C9C 3020                   byte  48              ; ASCII offset
0111                             byte  32              ; Fill character
0112               
0113 7C9E 06A0  32         bl    @trimnum              ; Trim number to the left
     7CA0 29F2 
0114 7CA2 2F6A                   data  rambuf,rambuf+5,32
     7CA4 2F6F 
     7CA6 0020 
0115               
0116 7CA8 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7CAA 0600 
0117 7CAC D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7CAE 2F6F 
0118               
0119                       ;------------------------------------------------------
0120                       ; Decide if row length is to be shown
0121                       ;------------------------------------------------------
0122 7CB0 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7CB2 A10C 
0123 7CB4 0584  14         inc   tmp0                  ; /
0124 7CB6 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7CB8 A108 
0125 7CBA 1101  14         jlt   pane.botline.show_linecol.linelen
0126 7CBC 102B  14         jmp   pane.botline.show_linecol.colstring
0127                                                   ; Yes, skip showing row length
0128                       ;------------------------------------------------------
0129                       ; Add '/' delimiter and length of line to string
0130                       ;------------------------------------------------------
0131               pane.botline.show_linecol.linelen:
0132 7CBE C120  34         mov   @fb.column,tmp0       ; \
     7CC0 A10C 
0133 7CC2 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CC4 2F71 
0134 7CC6 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7CC8 0009 
0135 7CCA 1101  14         jlt   !                     ; | column.
0136 7CCC 0585  14         inc   tmp1                  ; /
0137               
0138 7CCE 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7CD0 2D00 
0139 7CD2 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0140               
0141 7CD4 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7CD6 833C 
0142               
0143 7CD8 06A0  32         bl    @mknum
     7CDA 299A 
0144 7CDC A108                   data  fb.row.length,rambuf
     7CDE 2F6A 
0145 7CE0 3020                   byte  48              ; ASCII offset
0146                             byte  32              ; Padding character
0147               
0148 7CE2 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7CE4 833C 
0149               
0150 7CE6 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7CE8 A108 
0151 7CEA 0284  22         ci    tmp0,10               ; /
     7CEC 000A 
0152 7CEE 110B  14         jlt   pane.botline.show_line.1digit
0153                       ;------------------------------------------------------
0154                       ; Sanity check
0155                       ;------------------------------------------------------
0156 7CF0 0284  22         ci    tmp0,80
     7CF2 0050 
0157 7CF4 1204  14         jle   pane.botline.show_line.2digits
0158                       ;------------------------------------------------------
0159                       ; Sanity checks failed
0160                       ;------------------------------------------------------
0161 7CF6 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7CF8 FFCE 
0162 7CFA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7CFC 2026 
0163                       ;------------------------------------------------------
0164                       ; Show length of line (2 digits)
0165                       ;------------------------------------------------------
0166               pane.botline.show_line.2digits:
0167 7CFE 0204  20         li    tmp0,rambuf+3
     7D00 2F6D 
0168 7D02 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0169 7D04 1002  14         jmp   pane.botline.show_line.rest
0170                       ;------------------------------------------------------
0171                       ; Show length of line (1 digits)
0172                       ;------------------------------------------------------
0173               pane.botline.show_line.1digit:
0174 7D06 0204  20         li    tmp0,rambuf+4
     7D08 2F6E 
0175               pane.botline.show_line.rest:
0176 7D0A DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0177 7D0C DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D0E 2F6A 
0178 7D10 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D12 2F6A 
0179                       ;------------------------------------------------------
0180                       ; Show column string
0181                       ;------------------------------------------------------
0182               pane.botline.show_linecol.colstring:
0183 7D14 06A0  32         bl    @putat
     7D16 2444 
0184 7D18 1D41                   byte pane.botrow,65
0185 7D1A 2F6F                   data rambuf+5         ; Show string
0186                       ;------------------------------------------------------
0187                       ; Show lines in buffer unless on last line in file
0188                       ;------------------------------------------------------
0189 7D1C C820  54         mov   @fb.row,@parm1
     7D1E A106 
     7D20 2F20 
0190 7D22 06A0  32         bl    @fb.row2line
     7D24 69DE 
0191 7D26 8820  54         c     @edb.lines,@outparm1
     7D28 A204 
     7D2A 2F30 
0192 7D2C 1605  14         jne   pane.botline.show_lines_in_buffer
0193               
0194 7D2E 06A0  32         bl    @putat
     7D30 2444 
0195 7D32 1D49                   byte pane.botrow,73
0196 7D34 35DE                   data txt.bottom
0197               
0198 7D36 1009  14         jmp   pane.botline.exit
0199                       ;------------------------------------------------------
0200                       ; Show lines in buffer
0201                       ;------------------------------------------------------
0202               pane.botline.show_lines_in_buffer:
0203 7D38 C820  54         mov   @edb.lines,@waux1
     7D3A A204 
     7D3C 833C 
0204               
0205 7D3E 06A0  32         bl    @putnum
     7D40 2A18 
0206 7D42 1D49                   byte pane.botrow,73   ; YX
0207 7D44 833C                   data waux1,rambuf
     7D46 2F6A 
0208 7D48 3020                   byte 48
0209                             byte 32
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213               pane.botline.exit:
0214 7D4A C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7D4C 832A 
0215 7D4E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0216 7D50 C2F9  30         mov   *stack+,r11           ; Pop r11
0217 7D52 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.395472
0190                       ;-----------------------------------------------------------------------
0191                       ; Stubs using trampoline
0192                       ;-----------------------------------------------------------------------
0193                       copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "fm.loadfile"
0006               * bank2 vec.1
0007               ********|*****|*********************|**************************
0008               fm.loadfile:
0009 7D54 0649  14         dect  stack
0010 7D56 C64B  30         mov   r11,*stack            ; Save return address
0011 7D58 0649  14         dect  stack
0012 7D5A C644  30         mov   tmp0,*stack           ; Push tmp0
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 7D5C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D5E 3008 
0017 7D60 6004                   data bank2            ; | i  p0 = bank address
0018 7D62 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0019 7D64 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Show "Unsaved changes" dialog if editor buffer dirty
0022                       ;------------------------------------------------------
0023 7D66 C120  34         mov   @outparm1,tmp0
     7D68 2F30 
0024 7D6A 1304  14         jeq   fm.loadfile.exit
0025               
0026 7D6C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0027 7D6E C2F9  30         mov   *stack+,r11           ; Pop r11
0028 7D70 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D72 7DC2 
0029                       ;------------------------------------------------------
0030                       ; Exit
0031                       ;------------------------------------------------------
0032               fm.loadfile.exit:
0033 7D74 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 7D76 C2F9  30         mov   *stack+,r11           ; Pop r11
0035 7D78 045B  20         b     *r11                  ; Return to caller
0036               
0037               
0038               ***************************************************************
0039               * Stub for "fm.savefile"
0040               * bank2 vec.2
0041               ********|*****|*********************|**************************
0042               fm.savefile:
0043 7D7A 0649  14         dect  stack
0044 7D7C C64B  30         mov   r11,*stack            ; Save return address
0045                       ;------------------------------------------------------
0046                       ; Call function in bank 1
0047                       ;------------------------------------------------------
0048 7D7E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D80 3008 
0049 7D82 6004                   data bank2            ; | i  p0 = bank address
0050 7D84 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0051 7D86 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 7D88 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 7D8A 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               ***************************************************************
0060               * Stub for "About dialog"
0061               * bank3 vec.1
0062               ********|*****|*********************|**************************
0063               edkey.action.about:
0064 7D8C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D8E 7736 
0065                       ;------------------------------------------------------
0066                       ; Show dialog
0067                       ;------------------------------------------------------
0068 7D90 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7D92 3008 
0069 7D94 6006                   data bank3            ; | i  p0 = bank address
0070 7D96 7F9C                   data vec.1            ; | i  p1 = Vector with target address
0071 7D98 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075 7D9A 0460  28         b     @edkey.action.cmdb.show
     7D9C 68C0 
0076                                                   ; Show dialog in CMDB pane
0077               
0078               
0079               ***************************************************************
0080               * Stub for "Load DV80 file"
0081               * bank3 vec.2
0082               ********|*****|*********************|**************************
0083               dialog.load:
0084 7D9E 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DA0 7736 
0085                       ;------------------------------------------------------
0086                       ; Show dialog
0087                       ;------------------------------------------------------
0088 7DA2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DA4 3008 
0089 7DA6 6006                   data bank3            ; | i  p0 = bank address
0090 7DA8 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0091 7DAA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0092                       ;------------------------------------------------------
0093                       ; Exit
0094                       ;------------------------------------------------------
0095 7DAC 0460  28         b     @edkey.action.cmdb.show
     7DAE 68C0 
0096                                                   ; Show dialog in CMDB pane
0097               
0098               
0099               ***************************************************************
0100               * Stub for "Save DV80 file"
0101               * bank3 vec.3
0102               ********|*****|*********************|**************************
0103               dialog.save:
0104 7DB0 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DB2 7736 
0105                       ;------------------------------------------------------
0106                       ; Show dialog
0107                       ;------------------------------------------------------
0108 7DB4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DB6 3008 
0109 7DB8 6006                   data bank3            ; | i  p0 = bank address
0110 7DBA 7FA0                   data vec.3            ; | i  p1 = Vector with target address
0111 7DBC 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115 7DBE 0460  28         b     @edkey.action.cmdb.show
     7DC0 68C0 
0116                                                   ; Show dialog in CMDB pane
0117               
0118               
0119               ***************************************************************
0120               * Stub for "Unsaved Changes"
0121               * bank3 vec.4
0122               ********|*****|*********************|**************************
0123               dialog.unsaved:
0124 7DC2 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DC4 7736 
0125                       ;------------------------------------------------------
0126                       ; Show dialog
0127                       ;------------------------------------------------------
0128 7DC6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DC8 3008 
0129 7DCA 6006                   data bank3            ; | i  p0 = bank address
0130 7DCC 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0131 7DCE 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135 7DD0 0460  28         b     @edkey.action.cmdb.show
     7DD2 68C0 
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
0146 7DD4 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DD6 7736 
0147                       ;------------------------------------------------------
0148                       ; Show dialog
0149                       ;------------------------------------------------------
0150 7DD8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7DDA 3008 
0151 7DDC 6006                   data bank3            ; | i  p0 = bank address
0152 7DDE 7FA4                   data vec.5            ; | i  p1 = Vector with target address
0153 7DE0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157 7DE2 0460  28         b     @edkey.action.cmdb.show
     7DE4 68C0 
0158                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.395472
0194                       ;-----------------------------------------------------------------------
0195                       ; Program data
0196                       ;-----------------------------------------------------------------------
0197                       copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
**** **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard actions)
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7DE6 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7DE8 0000 
     7DEA 665A 
0012 7DEC 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7DEE 0000 
     7DF0 6172 
0013 7DF2 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7DF4 0000 
     7DF6 618C 
0014 7DF8 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7DFA 0000 
     7DFC 62A4 
0015 7DFE 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E00 0000 
     7E02 62FE 
0016 7E04 BF00             data  key.fctn.h, pane.focus.fb, edkey.action.home
     7E06 0000 
     7E08 61A8 
0017 7E0A C000             data  key.fctn.j, pane.focus.fb, edkey.action.pword
     7E0C 0000 
     7E0E 61EA 
0018 7E10 C100             data  key.fctn.k, pane.focus.fb, edkey.action.nword
     7E12 0000 
     7E14 6240 
0019 7E16 C200             data  key.fctn.l, pane.focus.fb, edkey.action.end
     7E18 0000 
     7E1A 61C8 
0020 7E1C 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E1E 0000 
     7E20 6372 
0021 7E22 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7E24 0000 
     7E26 63AE 
0022 7E28 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7E2A 0000 
     7E2C 63E8 
0023 7E2E 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7E30 0000 
     7E32 6404 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7E34 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7E36 0000 
     7E38 6476 
0028 7E3A 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7E3C 0000 
     7E3E 6528 
0029 7E40 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7E42 0000 
     7E44 64F4 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7E46 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7E48 0000 
     7E4A 656C 
0034 7E4C B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7E4E 0000 
     7E50 66D2 
0035 7E52 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7E54 0000 
     7E56 65E6 
0036                       ;-------------------------------------------------------
0037                       ; Block marking/modifier
0038                       ;-------------------------------------------------------
0039 7E58 8D00             data  key.ctrl.m, pane.focus.fb, edkey.action.block.mark
     7E5A 0000 
     7E5C 67A6 
0040 7E5E 9200             data  key.ctrl.r, pane.focus.fb, edkey.action.block.reset
     7E60 0000 
     7E62 67AE 
0041 7E64 8300             data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
     7E66 0000 
     7E68 67BA 
0042 7E6A 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
     7E6C 0000 
     7E6E 67EC 
0043 7E70 8700             data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
     7E72 0000 
     7E74 6806 
0044                       ;-------------------------------------------------------
0045                       ; Other action keys
0046                       ;-------------------------------------------------------
0047 7E76 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7E78 0000 
     7E7A 674E 
0048 7E7C 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7E7E 0000 
     7E80 7774 
0049                       ;-------------------------------------------------------
0050                       ; Dialog keys
0051                       ;-------------------------------------------------------
0052 7E82 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7E84 0000 
     7E86 6760 
0053 7E88 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7E8A 0000 
     7E8C 676C 
0054 7E8E 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7E90 0000 
     7E92 7D8C 
0055 7E94 9300             data  key.ctrl.s, pane.focus.fb, dialog.save
     7E96 0000 
     7E98 7DB0 
0056 7E9A 8F00             data  key.ctrl.o, pane.focus.fb, dialog.load
     7E9C 0000 
     7E9E 7D9E 
0057                       ;-------------------------------------------------------
0058                       ; End of list
0059                       ;-------------------------------------------------------
0060 7EA0 FFFF             data  EOL                           ; EOL
0061               
0062               
0063               
0064               
0065               *---------------------------------------------------------------
0066               * Action keys mapping table: Command Buffer (CMDB)
0067               *---------------------------------------------------------------
0068               keymap_actions.cmdb:
0069                       ;-------------------------------------------------------
0070                       ; Dialog specific: File load
0071                       ;-------------------------------------------------------
0072 7EA2 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7EA4 000A 
     7EA6 699E 
0073 7EA8 0D00             data  key.enter, id.dialog.load, edkey.action.cmdb.load
     7EAA 000A 
     7EAC 68D2 
0074                       ;-------------------------------------------------------
0075                       ; Dialog specific: Unsaved changes
0076                       ;-------------------------------------------------------
0077 7EAE 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7EB0 0065 
     7EB2 6974 
0078 7EB4 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7EB6 0065 
     7EB8 7DB0 
0079                       ;-------------------------------------------------------
0080                       ; Dialog specific: File save
0081                       ;-------------------------------------------------------
0082 7EBA 0D00             data  key.enter, id.dialog.save, edkey.action.cmdb.save
     7EBC 000B 
     7EBE 6916 
0083 7EC0 0D00             data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
     7EC2 000C 
     7EC4 6916 
0084                       ;-------------------------------------------------------
0085                       ; Dialog specific: About
0086                       ;-------------------------------------------------------
0087 7EC6 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7EC8 0067 
     7ECA 69AA 
0088                       ;-------------------------------------------------------
0089                       ; Movement keys
0090                       ;-------------------------------------------------------
0091 7ECC 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7ECE 0001 
     7ED0 6820 
0092 7ED2 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7ED4 0001 
     7ED6 6832 
0093 7ED8 BF00             data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
     7EDA 0001 
     7EDC 684A 
0094 7EDE C200             data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
     7EE0 0001 
     7EE2 685E 
0095                       ;-------------------------------------------------------
0096                       ; Modifier keys
0097                       ;-------------------------------------------------------
0098 7EE4 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7EE6 0001 
     7EE8 6876 
0099                       ;-------------------------------------------------------
0100                       ; Other action keys
0101                       ;-------------------------------------------------------
0102 7EEA 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7EEC 0001 
     7EEE 69AA 
0103 7EF0 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7EF2 0001 
     7EF4 674E 
0104 7EF6 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7EF8 0001 
     7EFA 7774 
0105                       ;------------------------------------------------------
0106                       ; End of list
0107                       ;-------------------------------------------------------
0108 7EFC FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.395472
0198                       ;-----------------------------------------------------------------------
0199                       ; Bank specific vector table
0200                       ;-----------------------------------------------------------------------
0204 7EFE 7EFE                   data $                ; Bank 1 ROM size OK.
0206                       ;-------------------------------------------------------
0207                       ; Vector table bank 1: >7f9c - >7fff
0208                       ;-------------------------------------------------------
0209                       copy  "rom.vectors.bank1.asm"
**** **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6D16     vec.1   data  idx.entry.insert      ;   Vectors 1 - 9 reserved
0010 7F9E 6BCE     vec.2   data  idx.entry.update      ;    for index functions.
0011 7FA0 6C7C     vec.3   data  idx.entry.delete      ;
0012 7FA2 6C20     vec.4   data  idx.pointer.get       ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 6DFE     vec.10  data  edb.line.pack.fb      ;
0019 7FB0 6EC8     vec.11  data  edb.line.unpack.fb    ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 68C0     vec.15  data  edkey.action.cmdb.show
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 73D2     vec.19  data  cmdb.cmd.clear        ;
0028 7FC2 6A68     vec.20  data  fb.refresh            ;
0029 7FC4 6AD8     vec.21  data  fb.vdpdump            ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 7754     vec.28  data  pane.cursor.blink     ;
0037 7FD4 7736     vec.29  data  pane.cursor.hide      ;
0038 7FD6 7B70     vec.30  data  pane.errline.show     ;
0039 7FD8 77D2     vec.31  data  pane.action.colorscheme.load
0040 7FDA 78E4     vec.32  data  pane.action.colorscheme.statlines
**** **** ****     > stevie_b1.asm.395472
0210               
0211               
0212               
0213               
0214               *--------------------------------------------------------------
0215               * Video mode configuration
0216               *--------------------------------------------------------------
0217      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0218      0004     spfbck  equ   >04                   ; Screen background color.
0219      3350     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0220      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0221      0050     colrow  equ   80                    ; Columns per row
0222      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0223      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0224      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0225      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

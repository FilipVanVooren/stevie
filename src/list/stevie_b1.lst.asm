XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.358778
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 201126-358778
0010               *
0011               * Bank 1 "James"
0012               *
0013               ***************************************************************
0014                       copy  "bank.noninverted.asm"
**** **** ****     > bank.noninverted.asm
0001               *--------------------------------------------------------------
0002               * Bank order (non-inverted)
0003               *--------------------------------------------------------------
0004      6000     bank0                     equ  >6000   ; Jill
0005      6002     bank1                     equ  >6002   ; James
0006      6004     bank2                     equ  >6004   ; Jacky
0007      6006     bank3                     equ  >6006   ; John
**** **** ****     > stevie_b1.asm.358778
0015                                                   ; Bank order "non-inverted"
0016                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.equ                 ; Version 201126-358778
0010               *--------------------------------------------------------------
0011               * Stevie memory map
0012               *
0013               *
0014               * LOW MEMORY EXPANSION (2000-2fff)
0015               *
0016               * Mem range   Bytes    SAMS   Purpose
0017               * =========   =====    ====   ==================================
0018               * 2000-2eff    3840           SP2 library
0019               * 2f00-2fff     256           SP2 work memory
0020               *
0021               * LOW MEMORY EXPANSION (3000-3fff)
0022               *
0023               * Mem range   Bytes    SAMS   Purpose
0024               * =========   =====    ====   ==================================
0025               * 3000-3fff    4096           Resident Stevie Modules
0026               *
0027               *
0028               * CARTRIDGE SPACE (6000-7fff)
0029               *
0030               * Mem range   Bytes    BANK   Purpose
0031               * =========   =====    ====   ==================================
0032               * 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
0033               * 6000-7fff    8192       1   Stevie program code
0034               *
0035               *
0036               * HIGH MEMORY EXPANSION (a000-ffff)
0037               *
0038               * Mem range   Bytes    SAMS   Purpose
0039               * =========   =====    ====   ==================================
0040               * a000-a0ff     256           Stevie Editor shared structure
0041               * a100-a1ff     256           Framebuffer structure
0042               * a200-a2ff     256           Editor buffer structure
0043               * a300-a3ff     256           Command buffer structure
0044               * a400-a4ff     256           File handle structure
0045               * a500-a5ff     256           Index structure
0046               * a600-af5f    2400           Frame buffer
0047               * af60-afff     ???           *FREE*
0048               *
0049               * b000-bfff    4096           Index buffer page
0050               * c000-cfff    4096           Editor buffer page
0051               * d000-dfff    4096           Command history buffer
0052               * e000-efff    4096           Heap
0053               * f000-ffff    4096           *FREE*
0054               *
0055               *
0056               * VDP RAM
0057               *
0058               * Mem range   Bytes    Hex    Purpose
0059               * =========   =====   =====   =================================
0060               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0061               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0062               * 0fc0                        PCT - Pattern Color Table
0063               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0064               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0065               * 2180                        SAT - Sprite Attribute List
0066               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0067               *--------------------------------------------------------------
0068               * Skip unused spectra2 code modules for reduced code size
0069               *--------------------------------------------------------------
0070      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0071      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0072      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0073      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0074      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0075      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0076      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0077      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0078      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0079      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0080      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0081      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0082      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0083      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0084      0001     skip_random_generator     equ  1       ; Skip random functions
0085      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0086      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0087               *--------------------------------------------------------------
0088               * Stevie specific equates
0089               *--------------------------------------------------------------
0090      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0091      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0092      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0093               *--------------------------------------------------------------
0094               * Stevie Dialog / Pane specific equates
0095               *--------------------------------------------------------------
0096      001D     pane.botrow               equ  29      ; Bottom row on screen
0097      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0098      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0099               ;-----------------------------------------------------------------
0100               ;   Dialog ID's >= 100 indicate that command prompt should be
0101               ;   hidden and no characters added to CMDB keyboard buffer
0102               ;-----------------------------------------------------------------
0103      000A     id.dialog.load            equ  10      ; ID dialog "Load DV 80 file"
0104      000B     id.dialog.save            equ  11      ; ID dialog "Save DV 80 file"
0105      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0106      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0107      0067     id.dialog.about           equ  103     ; ID dialog "About"
0108               *--------------------------------------------------------------
0109               * SPECTRA2 / Stevie startup options
0110               *--------------------------------------------------------------
0111      0001     debug                     equ  1       ; Turn on spectra2 debugging
0112      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0113      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0114      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0115               *--------------------------------------------------------------
0116               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0117               *--------------------------------------------------------------
0118      2F20     parm1             equ  >2f20           ; Function parameter 1
0119      2F22     parm2             equ  >2f22           ; Function parameter 2
0120      2F24     parm3             equ  >2f24           ; Function parameter 3
0121      2F26     parm4             equ  >2f26           ; Function parameter 4
0122      2F28     parm5             equ  >2f28           ; Function parameter 5
0123      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0124      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0125      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0126      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0127      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0128      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0129      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0130      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0131      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0132      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0133      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0134      2F40     keycode1          equ  >2f40           ; Current key scanned
0135      2F42     keycode2          equ  >2f42           ; Previous key scanned
0136      2F44     timers            equ  >2f44           ; Timer table
0137      2F54     ramsat            equ  >2f54           ; Sprite Attribute Table in RAM
0138      2F64     rambuf            equ  >2f64           ; RAM workbuffer 1
0139               *--------------------------------------------------------------
0140               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0141               *--------------------------------------------------------------
0142      A000     tv.top            equ  >a000           ; Structure begin
0143      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0144      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0145      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0146      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0147      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0148      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0149      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0150      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0151      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0152      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0153      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0154      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0155      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebufffer + bottom line
0156      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0157      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0158      A01E     tv.pane.focus     equ  tv.top + 30     ; Identify pane that has focus
0159      A020     tv.task.oneshot   equ  tv.top + 32     ; Pointer to one-shot routine
0160      A022     tv.bank.return    equ  tv.top + 34     ; Return address for bank-switch
0161      A024     tv.error.visible  equ  tv.top + 36     ; Error pane visible
0162      A026     tv.error.msg      equ  tv.top + 38     ; Error message (max. 160 characters)
0163      A0C6     tv.free           equ  tv.top + 198    ; End of structure
0164               *--------------------------------------------------------------
0165               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0166               *--------------------------------------------------------------
0167      A100     fb.struct         equ  >a100           ; Structure begin
0168      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0169      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0170      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0171                                                      ; line X in editor buffer).
0172      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0173                                                      ; (offset 0 .. @fb.scrrows)
0174      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0175      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0176      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0177      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0178      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0179      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0180      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0181      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0182      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0183      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0184      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0185               *--------------------------------------------------------------
0186               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0187               *--------------------------------------------------------------
0188      A200     edb.struct        equ  >a200           ; Begin structure
0189      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0190      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0191      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0192      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0193      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0194      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0195      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker
0196      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker
0197      A210     edb.block.m3      equ  edb.struct + 16 ; Block operation target line
0198      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0199                                                      ; with current filename.
0200      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0201                                                      ; with current file type.
0202      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0203      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0204      A21A     edb.free          equ  edb.struct + 26 ; End of structure
0205               *--------------------------------------------------------------
0206               * Command buffer structure            @>a300-a3ff   (256 bytes)
0207               *--------------------------------------------------------------
0208      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0209      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0210      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0211      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0212      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0213      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0214      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0215      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0216      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0217      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0218      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0219      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0220      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0221      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0222      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0223      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0224      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0225      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0226      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0227      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0228      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0229      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0230      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0231               *--------------------------------------------------------------
0232               * File handle structure               @>a400-a4ff   (256 bytes)
0233               *--------------------------------------------------------------
0234      A400     fh.struct         equ  >a400           ; stevie file handling structures
0235               ;***********************************************************************
0236               ; ATTENTION
0237               ; The dsrlnk variables must form a continuous memory block and keep
0238               ; their order!
0239               ;***********************************************************************
0240      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0241      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0242      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0243      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0244      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0245      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0246      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0247      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0248      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0249      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0250      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0251      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0252      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0253      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0254      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0255      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0256      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0257      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0258      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0259      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0260      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0261      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0262      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0263      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0264      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0265      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0266      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0267      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0268      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0269      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0270      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0271               *--------------------------------------------------------------
0272               * Index structure                     @>a500-a5ff   (256 bytes)
0273               *--------------------------------------------------------------
0274      A500     idx.struct        equ  >a500           ; stevie index structure
0275      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0276      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0277      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0278               *--------------------------------------------------------------
0279               * Frame buffer                        @>a600-afff  (2560 bytes)
0280               *--------------------------------------------------------------
0281      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0282      0960     fb.size           equ  80*30           ; Frame buffer size
0283               *--------------------------------------------------------------
0284               * Index                               @>b000-bfff  (4096 bytes)
0285               *--------------------------------------------------------------
0286      B000     idx.top           equ  >b000           ; Top of index
0287      1000     idx.size          equ  4096            ; Index size
0288               *--------------------------------------------------------------
0289               * Editor buffer                       @>c000-cfff  (4096 bytes)
0290               *--------------------------------------------------------------
0291      C000     edb.top           equ  >c000           ; Editor buffer high memory
0292      1000     edb.size          equ  4096            ; Editor buffer size
0293               *--------------------------------------------------------------
0294               * Command history buffer              @>d000-dfff  (4096 bytes)
0295               *--------------------------------------------------------------
0296      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0297      1000     cmdb.size         equ  4096            ; Command buffer size
0298               *--------------------------------------------------------------
0299               * Heap                                @>e000-efff  (4096 bytes)
0300               *--------------------------------------------------------------
0301      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b1.asm.358778
0017               
0018               ***************************************************************
0019               * Spectra2 core configuration
0020               ********|*****|*********************|**************************
0021      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff
0022                                                   ; and grows downwards
0023               
0024               ***************************************************************
0025               * BANK 1
0026               ********|*****|*********************|**************************
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank 1
0029               *--------------------------------------------------------------
0030               * Cartridge header
0031               ********|*****|*********************|**************************
0032 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0033 6006 6010             data  $+10
0034 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0035 6010 0000             data  0                     ; No more items following
0036 6012 6030             data  kickstart.code1
0037               
0039               
0040 6014 0C53             byte  12
0041 6015 ....             text  'STEVIE V0.1F'
0042                       even
0043               
0051               
0052               ***************************************************************
0053               * Step 1: Switch to bank 0 (uniform code accross all banks)
0054               ********|*****|*********************|**************************
0055                       aorg  kickstart.code1       ; >6030
0056 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0057               ***************************************************************
0058               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0059               ********|*****|*********************|**************************
0060                       aorg  >2000
0061                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0083                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 2000 C13B  30 swbnk   mov   *r11+,tmp0
0026 2002 C17B  30         mov   *r11+,tmp1
0027 2004 04D4  26         clr   *tmp0                 ; Select bank in TMP0
0028 2006 C155  26         mov   *tmp1,tmp1
0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0030               
0031 200A 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0032 200C 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0033               
0034               
0035               
**** **** ****     > runlib.asm
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
0012 200E 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 2010 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 2012 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2014 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2016 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 2018 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 201A 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 201C 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 201E 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 2020 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 2022 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2024 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2026 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 2028 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 202A 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 202C 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 202E 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 2030 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 2032 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      200E     hb$00   equ   w$0000                ; >0000
0035      2020     hb$01   equ   w$0100                ; >0100
0036      2022     hb$02   equ   w$0200                ; >0200
0037      2024     hb$04   equ   w$0400                ; >0400
0038      2026     hb$08   equ   w$0800                ; >0800
0039      2028     hb$10   equ   w$1000                ; >1000
0040      202A     hb$20   equ   w$2000                ; >2000
0041      202C     hb$40   equ   w$4000                ; >4000
0042      202E     hb$80   equ   w$8000                ; >8000
0043      2032     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      200E     lb$00   equ   w$0000                ; >0000
0048      2010     lb$01   equ   w$0001                ; >0001
0049      2012     lb$02   equ   w$0002                ; >0002
0050      2014     lb$04   equ   w$0004                ; >0004
0051      2016     lb$08   equ   w$0008                ; >0008
0052      2018     lb$10   equ   w$0010                ; >0010
0053      201A     lb$20   equ   w$0020                ; >0020
0054      201C     lb$40   equ   w$0040                ; >0040
0055      201E     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      2010     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      2012     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2014     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2016     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      2018     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      201A     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      201C     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      201E     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      2020     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      2022     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2024     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2026     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      2028     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      202A     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      202C     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      202E     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      202A     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2020     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      201C     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      2018     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0038 2034 022B  22         ai    r11,-4                ; Remove opcode offset
     2036 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 2038 C800  38         mov   r0,@>ffe0
     203A FFE0 
0043 203C C801  38         mov   r1,@>ffe2
     203E FFE2 
0044 2040 C802  38         mov   r2,@>ffe4
     2042 FFE4 
0045 2044 C803  38         mov   r3,@>ffe6
     2046 FFE6 
0046 2048 C804  38         mov   r4,@>ffe8
     204A FFE8 
0047 204C C805  38         mov   r5,@>ffea
     204E FFEA 
0048 2050 C806  38         mov   r6,@>ffec
     2052 FFEC 
0049 2054 C807  38         mov   r7,@>ffee
     2056 FFEE 
0050 2058 C808  38         mov   r8,@>fff0
     205A FFF0 
0051 205C C809  38         mov   r9,@>fff2
     205E FFF2 
0052 2060 C80A  38         mov   r10,@>fff4
     2062 FFF4 
0053 2064 C80B  38         mov   r11,@>fff6
     2066 FFF6 
0054 2068 C80C  38         mov   r12,@>fff8
     206A FFF8 
0055 206C C80D  38         mov   r13,@>fffa
     206E FFFA 
0056 2070 C80E  38         mov   r14,@>fffc
     2072 FFFC 
0057 2074 C80F  38         mov   r15,@>ffff
     2076 FFFF 
0058 2078 02A0  12         stwp  r0
0059 207A C800  38         mov   r0,@>ffdc
     207C FFDC 
0060 207E 02C0  12         stst  r0
0061 2080 C800  38         mov   r0,@>ffde
     2082 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2084 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2086 8300 
0067 2088 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     208A 8302 
0068 208C 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     208E 4A4A 
0069 2090 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     2092 2E1A 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2094 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2096 2308 
0078 2098 21F8                   data graph1           ; Equate selected video mode table
0079               
0080 209A 06A0  32         bl    @ldfnt
     209C 2370 
0081 209E 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     20A0 000C 
0082               
0083 20A2 06A0  32         bl    @filv
     20A4 229E 
0084 20A6 0380                   data >0380,>f0,32*24  ; Load color table
     20A8 00F0 
     20AA 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20AC 06A0  32         bl    @putat                ; Show crash message
     20AE 2452 
0089 20B0 0000                   data >0000,cpu.crash.msg.crashed
     20B2 2186 
0090               
0091 20B4 06A0  32         bl    @puthex               ; Put hex value on screen
     20B6 299E 
0092 20B8 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20BA FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20BC 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20C0 06A0  32         bl    @putat                ; Show caller message
     20C2 2452 
0101 20C4 0100                   data >0100,cpu.crash.msg.caller
     20C6 219C 
0102               
0103 20C8 06A0  32         bl    @puthex               ; Put hex value on screen
     20CA 299E 
0104 20CC 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CE FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20D0 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20D2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D4 06A0  32         bl    @putat
     20D6 2452 
0113 20D8 0300                   byte 3,0
0114 20DA 21B8                   data cpu.crash.msg.wp
0115 20DC 06A0  32         bl    @putat
     20DE 2452 
0116 20E0 0400                   byte 4,0
0117 20E2 21BE                   data cpu.crash.msg.st
0118 20E4 06A0  32         bl    @putat
     20E6 2452 
0119 20E8 1600                   byte 22,0
0120 20EA 21C4                   data cpu.crash.msg.source
0121 20EC 06A0  32         bl    @putat
     20EE 2452 
0122 20F0 1700                   byte 23,0
0123 20F2 21E0                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F4 06A0  32         bl    @at                   ; Put cursor at YX
     20F6 26A2 
0128 20F8 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20FA 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20FC FFDC 
0132 20FE 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 2100 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 2102 0649  14         dect  stack
0138 2104 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 2106 0649  14         dect  stack
0140 2108 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 210A 0649  14         dect  stack
0142 210C C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 210E C046  18         mov   tmp2,r1               ; Save register number
0148 2110 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     2112 0001 
0149 2114 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2116 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 2118 06A0  32         bl    @mknum
     211A 29A8 
0154 211C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211E 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2120 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2122 06A0  32         bl    @setx                 ; Set cursor X position
     2124 26B8 
0160 2126 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2128 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     212A 242E 
0164 212C 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212E 06A0  32         bl    @setx                 ; Set cursor X position
     2130 26B8 
0168 2132 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2134 0281  22         ci    r1,10
     2136 000A 
0172 2138 1102  14         jlt   !
0173 213A 0620  34         dec   @wyx                  ; x=x-1
     213C 832A 
0174               
0175 213E 06A0  32 !       bl    @putstr
     2140 242E 
0176 2142 21B2                   data cpu.crash.msg.r
0177               
0178 2144 06A0  32         bl    @mknum
     2146 29A8 
0179 2148 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 214A 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 214C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214E 06A0  32         bl    @mkhex                ; Convert hex word to string
     2150 291A 
0188 2152 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2154 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2156 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2158 06A0  32         bl    @setx                 ; Set cursor X position
     215A 26B8 
0194 215C 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215E 06A0  32         bl    @putstr               ; Put '  >'
     2160 242E 
0198 2162 21B4                   data cpu.crash.msg.marker
0199               
0200 2164 06A0  32         bl    @setx                 ; Set cursor X position
     2166 26B8 
0201 2168 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 216A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     216C 242E 
0205 216E 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2170 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2172 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2174 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2176 06A0  32         bl    @down                 ; y=y+1
     2178 26A8 
0213               
0214 217A 0586  14         inc   tmp2
0215 217C 0286  22         ci    tmp2,17
     217E 0011 
0216 2180 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2182 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2184 2D18 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2186 1553             byte  21
0225 2187 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 219C 1543             byte  21
0230 219D ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21B2 0152             byte  1
0235 21B3 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21B4 0320             byte  3
0240 21B5 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21B8 042A             byte  4
0245 21B9 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21BE 042A             byte  4
0250 21BF ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21C4 1B53             byte  27
0255 21C5 ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21E0 1742             byte  23
0260 21E1 ....             text  'Build-ID  201126-358778'
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
0007 21F8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21FA 000E 
     21FC 0106 
     21FE 0204 
     2200 0020 
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
0032 2202 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2204 000E 
     2206 0106 
     2208 00F4 
     220A 0028 
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
0058 220C 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220E 003F 
     2210 0240 
     2212 03F4 
     2214 0050 
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
0084 2216 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2218 003F 
     221A 0240 
     221C 03F4 
     221E 0050 
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
0013 2220 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2222 16FD             data  >16fd                 ; |         jne   mcloop
0015 2224 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2226 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2228 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 222A 0201  20         li    r1,mccode             ; Machinecode to patch
     222C 2220 
0037 222E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2230 8322 
0038 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2234 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2236 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2238 045B  20         b     *r11                  ; Return to caller
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
0056 223A C0F9  30 popr3   mov   *stack+,r3
0057 223C C0B9  30 popr2   mov   *stack+,r2
0058 223E C079  30 popr1   mov   *stack+,r1
0059 2240 C039  30 popr0   mov   *stack+,r0
0060 2242 C2F9  30 poprt   mov   *stack+,r11
0061 2244 045B  20         b     *r11
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
0085 2246 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2248 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 224A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 224C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224E 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2250 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2252 FFCE 
0095 2254 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2256 2034 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2258 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     225A 830B 
     225C 830A 
0100               
0101 225E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2260 0001 
0102 2262 1602  14         jne   filchk2
0103 2264 DD05  32         movb  tmp1,*tmp0+
0104 2266 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2268 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     226A 0002 
0109 226C 1603  14         jne   filchk3
0110 226E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2270 DD05  32         movb  tmp1,*tmp0+
0112 2272 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2274 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2276 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2278 0001 
0118 227A 1605  14         jne   fil16b
0119 227C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227E 0606  14         dec   tmp2
0121 2280 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2282 0002 
0122 2284 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2286 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2288 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     228A 0001 
0128 228C 1301  14         jeq   dofill
0129 228E 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2290 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2292 0646  14         dect  tmp2
0132 2294 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2296 C1C7  18         mov   tmp3,tmp3
0137 2298 1301  14         jeq   fil.exit
0138 229A DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 229C 045B  20         b     *r11
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
0159 229E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 22A0 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 22A2 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A4 0264  22 xfilv   ori   tmp0,>4000
     22A6 4000 
0166 22A8 06C4  14         swpb  tmp0
0167 22AA D804  38         movb  tmp0,@vdpa
     22AC 8C02 
0168 22AE 06C4  14         swpb  tmp0
0169 22B0 D804  38         movb  tmp0,@vdpa
     22B2 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B4 020F  20         li    r15,vdpw              ; Set VDP write address
     22B6 8C00 
0174 22B8 06C5  14         swpb  tmp1
0175 22BA C820  54         mov   @filzz,@mcloop        ; Setup move command
     22BC 22C4 
     22BE 8320 
0176 22C0 0460  28         b     @mcloop               ; Write data to VDP
     22C2 8320 
0177               *--------------------------------------------------------------
0181 22C4 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C6 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C8 4000 
0202 22CA 06C4  14 vdra    swpb  tmp0
0203 22CC D804  38         movb  tmp0,@vdpa
     22CE 8C02 
0204 22D0 06C4  14         swpb  tmp0
0205 22D2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D4 8C02 
0206 22D6 045B  20         b     *r11                  ; Exit
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
0217 22D8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22DA C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22DC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DE 4000 
0223 22E0 06C4  14         swpb  tmp0                  ; \
0224 22E2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E4 8C02 
0225 22E6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E8 D804  38         movb  tmp0,@vdpa            ; /
     22EA 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22EC 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EE D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22F0 045B  20         b     *r11                  ; Exit
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
0251 22F2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F4 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F8 8C02 
0257 22FA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22FC D804  38         movb  tmp0,@vdpa            ; /
     22FE 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 2300 D120  34         movb  @vdpr,tmp0            ; Read byte
     2302 8800 
0263 2304 0984  56         srl   tmp0,8                ; Right align
0264 2306 045B  20         b     *r11                  ; Exit
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
0283 2308 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 230A C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 230C C144  18         mov   tmp0,tmp1
0289 230E 05C5  14         inct  tmp1
0290 2310 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2312 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2314 FF00 
0292 2316 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2318 C805  38         mov   tmp1,@wbase           ; Store calculated base
     231A 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 231C 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231E 8000 
0298 2320 0206  20         li    tmp2,8
     2322 0008 
0299 2324 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2326 830B 
0300 2328 06C5  14         swpb  tmp1
0301 232A D805  38         movb  tmp1,@vdpa
     232C 8C02 
0302 232E 06C5  14         swpb  tmp1
0303 2330 D805  38         movb  tmp1,@vdpa
     2332 8C02 
0304 2334 0225  22         ai    tmp1,>0100
     2336 0100 
0305 2338 0606  14         dec   tmp2
0306 233A 16F4  14         jne   vidta1                ; Next register
0307 233C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233E 833A 
0308 2340 045B  20         b     *r11
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
0325 2342 C13B  30 putvr   mov   *r11+,tmp0
0326 2344 0264  22 putvrx  ori   tmp0,>8000
     2346 8000 
0327 2348 06C4  14         swpb  tmp0
0328 234A D804  38         movb  tmp0,@vdpa
     234C 8C02 
0329 234E 06C4  14         swpb  tmp0
0330 2350 D804  38         movb  tmp0,@vdpa
     2352 8C02 
0331 2354 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2356 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2358 C10E  18         mov   r14,tmp0
0341 235A 0984  56         srl   tmp0,8
0342 235C 06A0  32         bl    @putvrx               ; Write VR#0
     235E 2344 
0343 2360 0204  20         li    tmp0,>0100
     2362 0100 
0344 2364 D820  54         movb  @r14lb,@tmp0lb
     2366 831D 
     2368 8309 
0345 236A 06A0  32         bl    @putvrx               ; Write VR#1
     236C 2344 
0346 236E 0458  20         b     *tmp4                 ; Exit
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
0360 2370 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2372 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2374 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2376 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2378 7FFF 
0364 237A 2120  38         coc   @wbit0,tmp0
     237C 202E 
0365 237E 1604  14         jne   ldfnt1
0366 2380 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2382 8000 
0367 2384 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2386 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2388 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     238A 23F2 
0372 238C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238E 9C02 
0373 2390 06C4  14         swpb  tmp0
0374 2392 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2394 9C02 
0375 2396 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2398 9800 
0376 239A 06C5  14         swpb  tmp1
0377 239C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239E 9800 
0378 23A0 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 23A2 D805  38         movb  tmp1,@grmwa
     23A4 9C02 
0383 23A6 06C5  14         swpb  tmp1
0384 23A8 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23AA 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23AC C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AE 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23B0 22C6 
0390 23B2 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B4 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B6 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B8 7FFF 
0393 23BA C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23BC 23F4 
0394 23BE C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23C0 23F6 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23C2 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C4 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C6 D120  34         movb  @grmrd,tmp0
     23C8 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23CA 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23CC 202E 
0405 23CE 1603  14         jne   ldfnt3                ; No, so skip
0406 23D0 D1C4  18         movb  tmp0,tmp3
0407 23D2 0917  56         srl   tmp3,1
0408 23D4 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D8 8C00 
0413 23DA 0606  14         dec   tmp2
0414 23DC 16F2  14         jne   ldfnt2
0415 23DE 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23E0 020F  20         li    r15,vdpw              ; Set VDP write address
     23E2 8C00 
0417 23E4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E6 7FFF 
0418 23E8 0458  20         b     *tmp4                 ; Exit
0419 23EA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23EC 200E 
     23EE 8C00 
0420 23F0 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23F2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F4 0200 
     23F6 0000 
0425 23F8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23FA 01C0 
     23FC 0101 
0426 23FE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     2400 02A0 
     2402 0101 
0427 2404 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2406 00E0 
     2408 0101 
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
0445 240A C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 240C C3A0  34         mov   @wyx,r14              ; Get YX
     240E 832A 
0447 2410 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2412 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2414 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2416 C3A0  34         mov   @wyx,r14              ; Get YX
     2418 832A 
0454 241A 024E  22         andi  r14,>00ff             ; Remove Y
     241C 00FF 
0455 241E A3CE  18         a     r14,r15               ; pos = pos + X
0456 2420 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2422 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2424 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2426 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2428 020F  20         li    r15,vdpw              ; VDP write address
     242A 8C00 
0463 242C 045B  20         b     *r11
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
0478 242E C17B  30 putstr  mov   *r11+,tmp1
0479 2430 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 2432 C1CB  18 xutstr  mov   r11,tmp3
0481 2434 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2436 240A 
0482 2438 C2C7  18         mov   tmp3,r11
0483 243A 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 243C C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 243E 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 2440 0286  22         ci    tmp2,255              ; Length > 255 ?
     2442 00FF 
0491 2444 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2446 0460  28         b     @xpym2v               ; Display string
     2448 2460 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 244A C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     244C FFCE 
0498 244E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2450 2034 
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
0514 2452 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2454 832A 
0515 2456 0460  28         b     @putstr
     2458 242E 
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
0020 245A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 245C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 245E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 2460 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2462 1604  14         jne   !                     ; No, continue
0028               
0029 2464 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2466 FFCE 
0030 2468 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     246A 2034 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 246C 0264  22 !       ori   tmp0,>4000
     246E 4000 
0035 2470 06C4  14         swpb  tmp0
0036 2472 D804  38         movb  tmp0,@vdpa
     2474 8C02 
0037 2476 06C4  14         swpb  tmp0
0038 2478 D804  38         movb  tmp0,@vdpa
     247A 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 247C 020F  20         li    r15,vdpw              ; Set VDP write address
     247E 8C00 
0043 2480 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2482 248A 
     2484 8320 
0044 2486 0460  28         b     @mcloop               ; Write data to VDP and return
     2488 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 248A D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 248C C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 248E C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2490 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2492 06C4  14 xpyv2m  swpb  tmp0
0027 2494 D804  38         movb  tmp0,@vdpa
     2496 8C02 
0028 2498 06C4  14         swpb  tmp0
0029 249A D804  38         movb  tmp0,@vdpa
     249C 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 249E 020F  20         li    r15,vdpr              ; Set VDP read address
     24A0 8800 
0034 24A2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24A4 24AC 
     24A6 8320 
0035 24A8 0460  28         b     @mcloop               ; Read data from VDP
     24AA 8320 
0036 24AC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24AE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24B0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24B2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24B4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24B6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24B8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24BA FFCE 
0034 24BC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24BE 2034 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24C0 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24C2 0001 
0039 24C4 1603  14         jne   cpym0                 ; No, continue checking
0040 24C6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24C8 04C6  14         clr   tmp2                  ; Reset counter
0042 24CA 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24CC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24CE 7FFF 
0047 24D0 C1C4  18         mov   tmp0,tmp3
0048 24D2 0247  22         andi  tmp3,1
     24D4 0001 
0049 24D6 1618  14         jne   cpyodd                ; Odd source address handling
0050 24D8 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24DA 0247  22         andi  tmp3,1
     24DC 0001 
0052 24DE 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24E0 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24E2 202E 
0057 24E4 1605  14         jne   cpym3
0058 24E6 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24E8 250E 
     24EA 8320 
0059 24EC 0460  28         b     @mcloop               ; Copy memory and exit
     24EE 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24F0 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24F2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24F4 0001 
0065 24F6 1301  14         jeq   cpym4
0066 24F8 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24FA CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24FC 0646  14         dect  tmp2
0069 24FE 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2500 C1C7  18         mov   tmp3,tmp3
0074 2502 1301  14         jeq   cpymz
0075 2504 D554  38         movb  *tmp0,*tmp1
0076 2506 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2508 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     250A 8000 
0081 250C 10E9  14         jmp   cpym2
0082 250E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 2510 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2512 0649  14         dect  stack
0065 2514 C64B  30         mov   r11,*stack            ; Push return address
0066 2516 0649  14         dect  stack
0067 2518 C640  30         mov   r0,*stack             ; Push r0
0068 251A 0649  14         dect  stack
0069 251C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 251E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2520 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2522 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2524 4000 
0077 2526 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2528 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 252A 020C  20         li    r12,>1e00             ; SAMS CRU address
     252C 1E00 
0082 252E 04C0  14         clr   r0
0083 2530 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2532 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2534 D100  18         movb  r0,tmp0
0086 2536 0984  56         srl   tmp0,8                ; Right align
0087 2538 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     253A 833C 
0088 253C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 253E C339  30         mov   *stack+,r12           ; Pop r12
0094 2540 C039  30         mov   *stack+,r0            ; Pop r0
0095 2542 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2544 045B  20         b     *r11                  ; Return to caller
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
0131 2546 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2548 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 254A 0649  14         dect  stack
0135 254C C64B  30         mov   r11,*stack            ; Push return address
0136 254E 0649  14         dect  stack
0137 2550 C640  30         mov   r0,*stack             ; Push r0
0138 2552 0649  14         dect  stack
0139 2554 C64C  30         mov   r12,*stack            ; Push r12
0140 2556 0649  14         dect  stack
0141 2558 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 255A 0649  14         dect  stack
0143 255C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 255E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2560 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2562 0284  22         ci    tmp0,255              ; Crash if page > 255
     2564 00FF 
0153 2566 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2568 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     256A 001E 
0158 256C 150A  14         jgt   !
0159 256E 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     2570 0004 
0160 2572 1107  14         jlt   !
0161 2574 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2576 0012 
0162 2578 1508  14         jgt   sams.page.set.switch_page
0163 257A 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     257C 0006 
0164 257E 1501  14         jgt   !
0165 2580 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2582 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2584 FFCE 
0170 2586 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2588 2034 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 258A 020C  20         li    r12,>1e00             ; SAMS CRU address
     258C 1E00 
0176 258E C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 2590 06C0  14         swpb  r0                    ; LSB to MSB
0178 2592 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2594 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2596 4000 
0180 2598 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 259A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 259C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 259E C339  30         mov   *stack+,r12           ; Pop r12
0188 25A0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25A2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25A4 045B  20         b     *r11                  ; Return to caller
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
0204 25A6 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A8 1E00 
0205 25AA 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25AC 045B  20         b     *r11                  ; Return to caller
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
0227 25AE 020C  20         li    r12,>1e00             ; SAMS CRU address
     25B0 1E00 
0228 25B2 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25B4 045B  20         b     *r11                  ; Return to caller
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
0260 25B6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25B8 0649  14         dect  stack
0263 25BA C64B  30         mov   r11,*stack            ; Save return address
0264 25BC 0649  14         dect  stack
0265 25BE C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25C0 0649  14         dect  stack
0267 25C2 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25C4 0649  14         dect  stack
0269 25C6 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25C8 0649  14         dect  stack
0271 25CA C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25CC 0206  20         li    tmp2,8                ; Set loop counter
     25CE 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25D0 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25D2 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25D4 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25D6 254A 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25D8 0606  14         dec   tmp2                  ; Next iteration
0288 25DA 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25DC 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25DE 25A6 
0294                                                   ; / activating changes.
0295               
0296 25E0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25EA 045B  20         b     *r11                  ; Return to caller
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
0318 25EC 0649  14         dect  stack
0319 25EE C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25F0 06A0  32         bl    @sams.layout
     25F2 25B6 
0324 25F4 25FA                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25F8 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25FA 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25FC 0002 
0336 25FE 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     2600 0003 
0337 2602 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2604 000A 
0338 2606 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2608 000B 
0339 260A C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     260C 000C 
0340 260E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2610 000D 
0341 2612 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2614 000E 
0342 2616 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2618 000F 
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
0363 261A C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 261C 0649  14         dect  stack
0366 261E C64B  30         mov   r11,*stack            ; Push return address
0367 2620 0649  14         dect  stack
0368 2622 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2624 0649  14         dect  stack
0370 2626 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2628 0649  14         dect  stack
0372 262A C646  30         mov   tmp2,*stack           ; Push tmp2
0373 262C 0649  14         dect  stack
0374 262E C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2630 0205  20         li    tmp1,sams.layout.copy.data
     2632 2652 
0379 2634 0206  20         li    tmp2,8                ; Set loop counter
     2636 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2638 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 263A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     263C 2512 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 263E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2640 833C 
0390               
0391 2642 0606  14         dec   tmp2                  ; Next iteration
0392 2644 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2646 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2648 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 264A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 264C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 264E C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2650 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2652 2000             data  >2000                 ; >2000-2fff
0408 2654 3000             data  >3000                 ; >3000-3fff
0409 2656 A000             data  >a000                 ; >a000-afff
0410 2658 B000             data  >b000                 ; >b000-bfff
0411 265A C000             data  >c000                 ; >c000-cfff
0412 265C D000             data  >d000                 ; >d000-dfff
0413 265E E000             data  >e000                 ; >e000-efff
0414 2660 F000             data  >f000                 ; >f000-ffff
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
0009 2662 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2664 FFBF 
0010 2666 0460  28         b     @putv01
     2668 2356 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 266A 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     266C 0040 
0018 266E 0460  28         b     @putv01
     2670 2356 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2672 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2674 FFDF 
0026 2676 0460  28         b     @putv01
     2678 2356 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 267A 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     267C 0020 
0034 267E 0460  28         b     @putv01
     2680 2356 
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
0010 2682 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2684 FFFE 
0011 2686 0460  28         b     @putv01
     2688 2356 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 268A 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     268C 0001 
0019 268E 0460  28         b     @putv01
     2690 2356 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2692 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2694 FFFD 
0027 2696 0460  28         b     @putv01
     2698 2356 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 269A 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     269C 0002 
0035 269E 0460  28         b     @putv01
     26A0 2356 
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
0018 26A2 C83B  50 at      mov   *r11+,@wyx
     26A4 832A 
0019 26A6 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26A8 B820  54 down    ab    @hb$01,@wyx
     26AA 2020 
     26AC 832A 
0028 26AE 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26B0 7820  54 up      sb    @hb$01,@wyx
     26B2 2020 
     26B4 832A 
0037 26B6 045B  20         b     *r11
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
0049 26B8 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26BA D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26BC 832A 
0051 26BE C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26C0 832A 
0052 26C2 045B  20         b     *r11
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
0021 26C4 C120  34 yx2px   mov   @wyx,tmp0
     26C6 832A 
0022 26C8 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26CA 06C4  14         swpb  tmp0                  ; Y<->X
0024 26CC 04C5  14         clr   tmp1                  ; Clear before copy
0025 26CE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26D0 20A0  38         coc   @wbit1,config         ; f18a present ?
     26D2 202C 
0030 26D4 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26D6 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26D8 833A 
     26DA 2704 
0032 26DC 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26DE 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26E0 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26E2 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26E4 0500 
0037 26E6 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26E8 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26EA 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26EC 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26EE D105  18         movb  tmp1,tmp0
0051 26F0 06C4  14         swpb  tmp0                  ; X<->Y
0052 26F2 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26F4 202E 
0053 26F6 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26F8 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26FA 2020 
0059 26FC 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26FE 2032 
0060 2700 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2702 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2704 0050            data   80
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
0013 2706 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2708 06A0  32         bl    @putvr                ; Write once
     270A 2342 
0015 270C 391C             data  >391c                 ; VR1/57, value 00011100
0016 270E 06A0  32         bl    @putvr                ; Write twice
     2710 2342 
0017 2712 391C             data  >391c                 ; VR1/57, value 00011100
0018 2714 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2716 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2718 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     271A 2342 
0028 271C 391C             data  >391c
0029 271E 0458  20         b     *tmp4                 ; Exit
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
0040 2720 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2722 06A0  32         bl    @cpym2v
     2724 245A 
0042 2726 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2728 2764 
     272A 0006 
0043 272C 06A0  32         bl    @putvr
     272E 2342 
0044 2730 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2732 06A0  32         bl    @putvr
     2734 2342 
0046 2736 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2738 0204  20         li    tmp0,>3f00
     273A 3F00 
0052 273C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     273E 22CA 
0053 2740 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2742 8800 
0054 2744 0984  56         srl   tmp0,8
0055 2746 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2748 8800 
0056 274A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 274C 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 274E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2750 BFFF 
0060 2752 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2754 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2756 4000 
0063               f18chk_exit:
0064 2758 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     275A 229E 
0065 275C 3F00             data  >3f00,>00,6
     275E 0000 
     2760 0006 
0066 2762 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2764 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2766 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2768 0340             data  >0340                 ; 3f04   0340  idle
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
0092 276A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 276C 06A0  32         bl    @putvr
     276E 2342 
0097 2770 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2772 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2774 2342 
0100 2776 391C             data  >391c                 ; Lock the F18a
0101 2778 0458  20         b     *tmp4                 ; Exit
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
0120 277A C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 277C 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     277E 202C 
0122 2780 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2782 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2784 8802 
0127 2786 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2788 2342 
0128 278A 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 278C 04C4  14         clr   tmp0
0130 278E D120  34         movb  @vdps,tmp0
     2790 8802 
0131 2792 0984  56         srl   tmp0,8
0132 2794 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2796 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2798 832A 
0018 279A D17B  28         movb  *r11+,tmp1
0019 279C 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 279E D1BB  28         movb  *r11+,tmp2
0021 27A0 0986  56         srl   tmp2,8                ; Repeat count
0022 27A2 C1CB  18         mov   r11,tmp3
0023 27A4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A6 240A 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27A8 020B  20         li    r11,hchar1
     27AA 27B0 
0028 27AC 0460  28         b     @xfilv                ; Draw
     27AE 22A4 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27B0 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27B2 2030 
0033 27B4 1302  14         jeq   hchar2                ; Yes, exit
0034 27B6 C2C7  18         mov   tmp3,r11
0035 27B8 10EE  14         jmp   hchar                 ; Next one
0036 27BA 05C7  14 hchar2  inct  tmp3
0037 27BC 0457  20         b     *tmp3                 ; Exit
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
0016 27BE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27C0 202E 
0017 27C2 020C  20         li    r12,>0024
     27C4 0024 
0018 27C6 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C8 285A 
0019 27CA 04C6  14         clr   tmp2
0020 27CC 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CE 04CC  14         clr   r12
0025 27D0 1F08  20         tb    >0008                 ; Shift-key ?
0026 27D2 1302  14         jeq   realk1                ; No
0027 27D4 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D6 288A 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D8 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27DA 1302  14         jeq   realk2                ; No
0033 27DC 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DE 28BA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27E0 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27E2 1302  14         jeq   realk3                ; No
0039 27E4 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E6 28EA 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E8 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27EA 201A 
0044 27EC 1E15  20         sbz   >0015                 ; Set P5
0045 27EE 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27F0 1302  14         jeq   realk4                ; No
0047 27F2 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27F4 201A 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27F6 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27F8 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27FA 0006 
0053 27FC 0606  14 realk5  dec   tmp2
0054 27FE 020C  20         li    r12,>24               ; CRU address for P2-P4
     2800 0024 
0055 2802 06C6  14         swpb  tmp2
0056 2804 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2806 06C6  14         swpb  tmp2
0058 2808 020C  20         li    r12,6                 ; CRU read address
     280A 0006 
0059 280C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 280E 0547  14         inv   tmp3                  ;
0061 2810 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2812 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2814 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2816 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2818 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 281A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 281C 0285  22         ci    tmp1,8
     281E 0008 
0070 2820 1AFA  14         jl    realk6
0071 2822 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2824 1BEB  14         jh    realk5                ; No, next column
0073 2826 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2828 C206  18 realk8  mov   tmp2,tmp4
0078 282A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 282C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 282E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2830 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2832 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2834 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2836 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2838 201A 
0089 283A 1608  14         jne   realka                ; No, continue saving key
0090 283C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     283E 2884 
0091 2840 1A05  14         jl    realka
0092 2842 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2844 2882 
0093 2846 1B02  14         jh    realka                ; No, continue
0094 2848 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     284A E000 
0095 284C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     284E 833C 
0096 2850 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2852 2018 
0097 2854 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2856 8C00 
0098                                                   ; / using R15 as temp storage
0099 2858 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 285A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     285C 0000 
     285E FF0D 
     2860 203D 
0102 2862 ....             text  'xws29ol.'
0103 286A ....             text  'ced38ik,'
0104 2872 ....             text  'vrf47ujm'
0105 287A ....             text  'btg56yhn'
0106 2882 ....             text  'zqa10p;/'
0107 288A FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     288C 0000 
     288E FF0D 
     2890 202B 
0108 2892 ....             text  'XWS@(OL>'
0109 289A ....             text  'CED#*IK<'
0110 28A2 ....             text  'VRF$&UJM'
0111 28AA ....             text  'BTG%^YHN'
0112 28B2 ....             text  'ZQA!)P:-'
0113 28BA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28BC 0000 
     28BE FF0D 
     28C0 2005 
0114 28C2 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28C4 0804 
     28C6 0F27 
     28C8 C2B9 
0115 28CA 600B             data  >600b,>0907,>063f,>c1B8
     28CC 0907 
     28CE 063F 
     28D0 C1B8 
0116 28D2 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28D4 7B02 
     28D6 015F 
     28D8 C0C3 
0117 28DA BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28DC 7D0E 
     28DE 0CC6 
     28E0 BFC4 
0118 28E2 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28E4 7C03 
     28E6 BC22 
     28E8 BDBA 
0119 28EA FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28EC 0000 
     28EE FF0D 
     28F0 209D 
0120 28F2 9897             data  >9897,>93b2,>9f8f,>8c9B
     28F4 93B2 
     28F6 9F8F 
     28F8 8C9B 
0121 28FA 8385             data  >8385,>84b3,>9e89,>8b80
     28FC 84B3 
     28FE 9E89 
     2900 8B80 
0122 2902 9692             data  >9692,>86b4,>b795,>8a8D
     2904 86B4 
     2906 B795 
     2908 8A8D 
0123 290A 8294             data  >8294,>87b5,>b698,>888E
     290C 87B5 
     290E B698 
     2910 888E 
0124 2912 9A91             data  >9a91,>81b1,>b090,>9cBB
     2914 81B1 
     2916 B090 
     2918 9CBB 
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
0023 291A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 291C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     291E 8340 
0025 2920 04E0  34         clr   @waux1
     2922 833C 
0026 2924 04E0  34         clr   @waux2
     2926 833E 
0027 2928 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     292A 833C 
0028 292C C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 292E 0205  20         li    tmp1,4                ; 4 nibbles
     2930 0004 
0033 2932 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2934 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2936 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2938 0286  22         ci    tmp2,>000a
     293A 000A 
0039 293C 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 293E C21B  26         mov   *r11,tmp4
0045 2940 0988  56         srl   tmp4,8                ; Right justify
0046 2942 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2944 FFF6 
0047 2946 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2948 C21B  26         mov   *r11,tmp4
0054 294A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     294C 00FF 
0055               
0056 294E A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2950 06C6  14         swpb  tmp2
0058 2952 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2954 0944  56         srl   tmp0,4                ; Next nibble
0060 2956 0605  14         dec   tmp1
0061 2958 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 295A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     295C BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 295E C160  34         mov   @waux3,tmp1           ; Get pointer
     2960 8340 
0067 2962 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2964 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2966 C120  34         mov   @waux2,tmp0
     2968 833E 
0070 296A 06C4  14         swpb  tmp0
0071 296C DD44  32         movb  tmp0,*tmp1+
0072 296E 06C4  14         swpb  tmp0
0073 2970 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2972 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2974 8340 
0078 2976 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2978 2024 
0079 297A 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 297C C120  34         mov   @waux1,tmp0
     297E 833C 
0084 2980 06C4  14         swpb  tmp0
0085 2982 DD44  32         movb  tmp0,*tmp1+
0086 2984 06C4  14         swpb  tmp0
0087 2986 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2988 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     298A 202E 
0092 298C 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 298E 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2990 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2992 7FFF 
0098 2994 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2996 8340 
0099 2998 0460  28         b     @xutst0               ; Display string
     299A 2430 
0100 299C 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 299E C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29A0 832A 
0122 29A2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29A4 8000 
0123 29A6 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A8 0207  20 mknum   li    tmp3,5                ; Digit counter
     29AA 0005 
0020 29AC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29AE C155  26         mov   *tmp1,tmp1            ; /
0022 29B0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29B2 0228  22         ai    tmp4,4                ; Get end of buffer
     29B4 0004 
0024 29B6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29BA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29BC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29BE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29C0 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29C2 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29C4 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29C6 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C8 0607  14         dec   tmp3                  ; Decrease counter
0036 29CA 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29CC 0207  20         li    tmp3,4                ; Check first 4 digits
     29CE 0004 
0041 29D0 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29D2 C11B  26         mov   *r11,tmp0
0043 29D4 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29D6 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D8 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29DA 05CB  14 mknum3  inct  r11
0047 29DC 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29DE 202E 
0048 29E0 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29E2 045B  20         b     *r11                  ; Exit
0050 29E4 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29E6 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E8 13F8  14         jeq   mknum3                ; Yes, exit
0053 29EA 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29EC 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29EE 7FFF 
0058 29F0 C10B  18         mov   r11,tmp0
0059 29F2 0224  22         ai    tmp0,-4
     29F4 FFFC 
0060 29F6 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F8 0206  20         li    tmp2,>0500            ; String length = 5
     29FA 0500 
0062 29FC 0460  28         b     @xutstr               ; Display string
     29FE 2432 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1
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
0093 2A00 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A02 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A04 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A06 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A08 0207  20         li    tmp3,5                ; Set counter
     2A0A 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A0C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A0E 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A10 0584  14         inc   tmp0                  ; Next character
0105 2A12 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A14 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A16 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A18 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A1A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A1C 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill
0119 2A1E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A20 0607  14         dec   tmp3                  ; Last character ?
0121 2A22 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A24 045B  20         b     *r11                  ; Return
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
0139 2A26 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A28 832A 
0140 2A2A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A2C 8000 
0141 2A2E 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A30 0649  14         dect  stack
0023 2A32 C64B  30         mov   r11,*stack            ; Save return address
0024 2A34 0649  14         dect  stack
0025 2A36 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A38 0649  14         dect  stack
0027 2A3A C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A3C 0649  14         dect  stack
0029 2A3E C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A40 0649  14         dect  stack
0031 2A42 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A44 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A46 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A48 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A4A 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A4C 0649  14         dect  stack
0044 2A4E C64B  30         mov   r11,*stack            ; Save return address
0045 2A50 0649  14         dect  stack
0046 2A52 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A54 0649  14         dect  stack
0048 2A56 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A58 0649  14         dect  stack
0050 2A5A C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A5C 0649  14         dect  stack
0052 2A5E C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A60 C1D4  26 !       mov   *tmp0,tmp3
0057 2A62 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A64 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A66 00FF 
0059 2A68 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A6A 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A6C 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A6E 0584  14         inc   tmp0                  ; Next byte
0067 2A70 0607  14         dec   tmp3                  ; Shorten string length
0068 2A72 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A74 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A76 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A78 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A7A 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A7C C187  18         mov   tmp3,tmp2
0078 2A7E 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A80 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A82 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A84 24B4 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A86 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A88 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A8A FFCE 
0090 2A8C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A8E 2034 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A90 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A92 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A94 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A96 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A98 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A9A 045B  20         b     *r11                  ; Return to caller
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
0123 2A9C 0649  14         dect  stack
0124 2A9E C64B  30         mov   r11,*stack            ; Save return address
0125 2AA0 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AA2 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AA4 0649  14         dect  stack
0128 2AA6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AA8 0649  14         dect  stack
0130 2AAA C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AAC 0649  14         dect  stack
0132 2AAE C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AB0 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AB2 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AB4 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AB6 0649  14         dect  stack
0144 2AB8 C64B  30         mov   r11,*stack            ; Save return address
0145 2ABA 0649  14         dect  stack
0146 2ABC C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2ABE 0649  14         dect  stack
0148 2AC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AC2 0649  14         dect  stack
0150 2AC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AC6 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AC8 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ACA 0586  14         inc   tmp2
0161 2ACC 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2ACE 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2AD0 0286  22         ci    tmp2,255
     2AD2 00FF 
0167 2AD4 1505  14         jgt   string.getlenc.panic
0168 2AD6 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AD8 0606  14         dec   tmp2                  ; One time adjustment
0174 2ADA C806  38         mov   tmp2,@waux1           ; Store length
     2ADC 833C 
0175 2ADE 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AE0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AE2 FFCE 
0181 2AE4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AE6 2034 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AE8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AEA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AEC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AEE C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AF0 045B  20         b     *r11                  ; Return to caller
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
0056 2AF2 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AF4 2AF6             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AF6 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AF8 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AFA A428 
0064 2AFC 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AFE 202A 
0065 2B00 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B02 8356 
0066 2B04 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B06 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B08 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B0A C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B0C A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B0E 06C0  14         swpb  r0                    ;
0075 2B10 D800  38         movb  r0,@vdpa              ; Send low byte
     2B12 8C02 
0076 2B14 06C0  14         swpb  r0                    ;
0077 2B16 D800  38         movb  r0,@vdpa              ; Send high byte
     2B18 8C02 
0078 2B1A D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B1C 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B1E 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B20 0704  14         seto  r4                    ; Init counter
0086 2B22 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B24 A420 
0087 2B26 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B28 0584  14         inc   r4                    ; Increment char counter
0089 2B2A 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B2C 0007 
0090 2B2E 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B30 80C4  18         c     r4,r3                 ; End of name?
0093 2B32 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B34 06C0  14         swpb  r0                    ;
0098 2B36 D800  38         movb  r0,@vdpa              ; Send low byte
     2B38 8C02 
0099 2B3A 06C0  14         swpb  r0                    ;
0100 2B3C D800  38         movb  r0,@vdpa              ; Send high byte
     2B3E 8C02 
0101 2B40 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B42 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B44 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B46 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B48 2C5E 
0109 2B4A 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B4C C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B4E 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B50 04E0  34         clr   @>83d0
     2B52 83D0 
0118 2B54 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B56 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B58 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B5A A432 
0121               
0122 2B5C 0584  14         inc   r4                    ; Adjust for dot
0123 2B5E A804  38         a     r4,@>8356             ; Point to position after name
     2B60 8356 
0124 2B62 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B64 8356 
     2B66 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B68 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B6A 83E0 
0130 2B6C 04C1  14         clr   r1                    ; Version found of dsr
0131 2B6E 020C  20         li    r12,>0f00             ; Init cru address
     2B70 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B72 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B74 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B76 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B78 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B7A 0100 
0145 2B7C 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B7E 83D0 
0146 2B80 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B82 2000 
0147 2B84 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B86 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B88 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B8A 1D00  20         sbo   0                     ; Turn on ROM
0154 2B8C 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B8E 4000 
0155 2B90 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B92 2C5A 
0156 2B94 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B96 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B98 A40A 
0166 2B9A 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B9C C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B9E 83D2 
0172                                                   ; subprogram
0173               
0174 2BA0 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BA2 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BA4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BA6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BA8 83D2 
0183                                                   ; subprogram
0184               
0185 2BAA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BAC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BAE 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BB0 D160  34         movb  @>8355,r5             ; Get length as counter
     2BB2 8355 
0195 2BB4 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BB6 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BB8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BBA 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BBC 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BBE A420 
0206 2BC0 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BC2 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BC4 0605  14         dec   r5                    ; Update loop counter
0211 2BC6 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BC8 0581  14         inc   r1                    ; Next version found
0217 2BCA C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BCC A42A 
0218 2BCE C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BD0 A42C 
0219 2BD2 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BD4 A430 
0220               
0221 2BD6 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BD8 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BDA 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BDC 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BDE 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BE0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BE2 A400 
0233 2BE4 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BE6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BE8 A428 
0239                                                   ; (8 or >a)
0240 2BEA 0281  22         ci    r1,8                  ; was it 8?
     2BEC 0008 
0241 2BEE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BF0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BF2 8350 
0243                                                   ; Get error byte from @>8350
0244 2BF4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BF6 06C0  14         swpb  r0                    ;
0252 2BF8 D800  38         movb  r0,@vdpa              ; send low byte
     2BFA 8C02 
0253 2BFC 06C0  14         swpb  r0                    ;
0254 2BFE D800  38         movb  r0,@vdpa              ; send high byte
     2C00 8C02 
0255 2C02 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C04 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C06 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C08 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C0A 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C0C 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C0E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C10 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C12 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C14 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C16 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C18 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C1A 202A 
0281                                                   ; / to indicate error
0282 2C1C 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C1E A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C20 2C22             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C22 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C24 83E0 
0316               
0317 2C26 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C28 202A 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C2A 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C2C A42A 
0322 2C2E C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C30 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C32 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C34 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C36 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C38 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C3A 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C3C 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C3E 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C40 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C42 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C44 4000 
     2C46 2C5A 
0337 2C48 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C4A 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C4C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C4E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C50 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C52 A400 
0355 2C54 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C56 A434 
0356               
0357 2C58 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C5A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C5C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C5E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C60 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C62 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C64 0649  14         dect  stack
0052 2C66 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C68 0204  20         li    tmp0,dsrlnk.savcru
     2C6A A42A 
0057 2C6C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C6E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C70 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C72 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C74 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C76 37D7 
0065 2C78 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C7A 8370 
0066                                                   ; / location
0067 2C7C C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C7E A44C 
0068 2C80 04C5  14         clr   tmp1                  ; io.op.open
0069 2C82 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2C84 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C86 0649  14         dect  stack
0097 2C88 C64B  30         mov   r11,*stack            ; Save return address
0098 2C8A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C8C 0001 
0099 2C8E 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2C90 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C92 0649  14         dect  stack
0125 2C94 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C96 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C98 0002 
0128 2C9A 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2C9C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C9E 0649  14         dect  stack
0155 2CA0 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CA2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CA4 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CA6 0005 
0159               
0160 2CA8 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CAA A43E 
0161               
0162 2CAC 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CAE 22DC 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CB0 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CB2 0003 
0167 2CB4 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CB6 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CB8 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CBA 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CBC 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CBE 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CC0 1000  14         nop
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
0227 2CC2 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CC4 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CC6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CC8 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CCA A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CCC 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CCE 22DC 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CD0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CD2 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CD4 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CD6 A44C 
0246               
0247 2CD8 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CDA 22DC 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CDC 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CDE 0009 
0254 2CE0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CE2 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CE4 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CE6 8322 
     2CE8 833C 
0259               
0260 2CEA C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CEC A42A 
0261 2CEE 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CF0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CF2 2AF2 
0268 2CF4 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CF6 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CF8 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CFA 2C1E 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CFC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CFE C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2D00 833C 
     2D02 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D04 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D06 A436 
0292 2D08 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D0A 0005 
0293 2D0C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D0E 22F4 
0294 2D10 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D12 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D14 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D16 045B  20         b     *r11                  ; Return to caller
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
0020 2D18 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D1A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D1C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D1E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D20 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D22 202A 
0029 2D24 1602  14         jne   tmgr1a                ; No, so move on
0030 2D26 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D28 2016 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D2A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D2C 202E 
0035 2D2E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D30 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D32 201E 
0048 2D34 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D36 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D38 201C 
0050 2D3A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D3C 0460  28         b     @kthread              ; Run kernel thread
     2D3E 2DB6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D40 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D42 2022 
0056 2D44 13EB  14         jeq   tmgr1
0057 2D46 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D48 2020 
0058 2D4A 16E8  14         jne   tmgr1
0059 2D4C C120  34         mov   @wtiusr,tmp0
     2D4E 832E 
0060 2D50 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D52 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D54 2DB4 
0065 2D56 C10A  18         mov   r10,tmp0
0066 2D58 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D5A 00FF 
0067 2D5C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D5E 202A 
0068 2D60 1303  14         jeq   tmgr5
0069 2D62 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D64 003C 
0070 2D66 1002  14         jmp   tmgr6
0071 2D68 0284  22 tmgr5   ci    tmp0,50
     2D6A 0032 
0072 2D6C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D6E 1001  14         jmp   tmgr8
0074 2D70 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D72 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D74 832C 
0079 2D76 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D78 FF00 
0080 2D7A C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D7C 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D7E 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D80 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D82 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D84 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D86 830C 
     2D88 830D 
0089 2D8A 1608  14         jne   tmgr10                ; No, get next slot
0090 2D8C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D8E FF00 
0091 2D90 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D92 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D94 8330 
0096 2D96 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D98 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D9A 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D9C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D9E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DA0 8315 
     2DA2 8314 
0103 2DA4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DA8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DAA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DAC 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DAE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DB0 FF00 
0109 2DB2 10B4  14         jmp   tmgr1
0110 2DB4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DB6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DB8 201E 
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
0041 2DBA 06A0  32         bl    @realkb               ; Scan full keyboard
     2DBC 27BE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DBE 0460  28         b     @tmgr3                ; Exit
     2DC0 2D40 
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
0017 2DC2 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DC4 832E 
0018 2DC6 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DC8 2020 
0019 2DCA 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D1C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DCC 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DCE 832E 
0029 2DD0 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DD2 FEFF 
0030 2DD4 045B  20         b     *r11                  ; Return
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
0017 2DD6 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DD8 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DDA C184  18         mov   tmp0,tmp2
0023 2DDC 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DDE A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DE0 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DE2 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DE4 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE6 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DE8 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DEA 2030 
0035 2DEC 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DEE 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DF0 05CB  14 mkslo1  inct  r11
0041 2DF2 045B  20         b     *r11                  ; Exit
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
0052 2DF4 C13B  30 clslot  mov   *r11+,tmp0
0053 2DF6 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DF8 A120  34         a     @wtitab,tmp0          ; Add table base
     2DFA 832C 
0055 2DFC 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DFE 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E00 045B  20         b     *r11                  ; Exit
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
0068 2E02 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E04 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E06 A120  34         a     @wtitab,tmp0          ; Add table base
     2E08 832C 
0071 2E0A 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E0C C154  26         mov   *tmp0,tmp1
0073 2E0E 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E10 FF00 
0074 2E12 C505  30         mov   tmp1,*tmp0
0075 2E14 045B  20         b     *r11                  ; Exit
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
0260 2E16 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E18 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E1A 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E1C 0000 
0266 2E1E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E20 8300 
0267 2E22 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E24 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E26 0202  20 runli2  li    r2,>8308
     2E28 8308 
0272 2E2A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E2C 0282  22         ci    r2,>8400
     2E2E 8400 
0274 2E30 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E32 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E34 FFFF 
0279 2E36 1602  14         jne   runli4                ; No, continue
0280 2E38 0420  54         blwp  @0                    ; Yes, bye bye
     2E3A 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E3C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E3E 833C 
0285 2E40 04C1  14         clr   r1                    ; Reset counter
0286 2E42 0202  20         li    r2,10                 ; We test 10 times
     2E44 000A 
0287 2E46 C0E0  34 runli5  mov   @vdps,r3
     2E48 8802 
0288 2E4A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E4C 202E 
0289 2E4E 1302  14         jeq   runli6
0290 2E50 0581  14         inc   r1                    ; Increase counter
0291 2E52 10F9  14         jmp   runli5
0292 2E54 0602  14 runli6  dec   r2                    ; Next test
0293 2E56 16F7  14         jne   runli5
0294 2E58 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E5A 1250 
0295 2E5C 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E5E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E60 202A 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E62 06A0  32 runli7  bl    @loadmc
     2E64 222A 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E66 04C1  14 runli9  clr   r1
0305 2E68 04C2  14         clr   r2
0306 2E6A 04C3  14         clr   r3
0307 2E6C 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E6E 3000 
0308 2E70 020F  20         li    r15,vdpw              ; Set VDP write address
     2E72 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E74 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E76 4A4A 
0317 2E78 1605  14         jne   runlia
0318 2E7A 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E7C 229E 
0319 2E7E 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E80 0000 
     2E82 3000 
0324 2E84 06A0  32 runlia  bl    @filv
     2E86 229E 
0325 2E88 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E8A 00F4 
     2E8C 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E8E 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E90 2706 
0333 2E92 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E94 2720 
0334 2E96 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E98 2716 
0335               
0336 2E9A 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E9C 2342 
0337 2E9E 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2EA0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2EA2 2308 
0351 2EA4 322C             data  spvmod                ; Equate selected video mode table
0352 2EA6 0204  20         li    tmp0,spfont           ; Get font option
     2EA8 000C 
0353 2EAA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EAC 1304  14         jeq   runlid                ; Yes, skip it
0355 2EAE 06A0  32         bl    @ldfnt
     2EB0 2370 
0356 2EB2 1100             data  fntadr,spfont         ; Load specified font
     2EB4 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EB6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EB8 4A4A 
0361 2EBA 1602  14         jne   runlie                ; No, continue
0362 2EBC 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EBE 2094 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EC0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EC2 0040 
0367 2EC4 0460  28         b     @main                 ; Give control to main program
     2EC6 6036 
**** **** ****     > stevie_b1.asm.358778
0062                                                   ; Relocated spectra2 in low MEMEXP, was
0063                                                   ; copied to >2000 from ROM in bank 0
0064                       ;------------------------------------------------------
0065                       ; End of File marker
0066                       ;------------------------------------------------------
0067 2EC8 DEAD             data >dead,>beef,>dead,>beef
     2ECA BEEF 
     2ECC DEAD 
     2ECE BEEF 
0069               ***************************************************************
0070               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0071               ********|*****|*********************|**************************
0072                       aorg  >3000
0073                       ;------------------------------------------------------
0074                       ; Activate bank 1 and branch to  >6036
0075                       ;------------------------------------------------------
0076 3000 04E0  34         clr   @bank1                ; Activate bank 1 "James"
     3002 6002 
0077 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0078                       ;------------------------------------------------------
0079                       ; Resident Stevie modules >3000 - >3fff
0080                       ;------------------------------------------------------
0081                       copy  "fb.asm"              ; Framebuffer
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
0020 3008 0649  14         dect  stack
0021 300A C64B  30         mov   r11,*stack            ; Save return address
0022                       ;------------------------------------------------------
0023                       ; Initialize
0024                       ;------------------------------------------------------
0025 300C 0204  20         li    tmp0,fb.top
     300E A600 
0026 3010 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3012 A100 
0027 3014 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3016 A104 
0028 3018 04E0  34         clr   @fb.row               ; Current row=0
     301A A106 
0029 301C 04E0  34         clr   @fb.column            ; Current column=0
     301E A10C 
0030               
0031 3020 0204  20         li    tmp0,colrow
     3022 0050 
0032 3024 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3026 A10E 
0033               
0034 3028 0204  20         li    tmp0,29
     302A 001D 
0035 302C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     302E A118 
0036 3030 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3032 A11A 
0037               
0038 3034 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3036 A01E 
0039 3038 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     303A A110 
0040 303C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     303E A116 
0041                       ;------------------------------------------------------
0042                       ; Clear frame buffer
0043                       ;------------------------------------------------------
0044 3040 06A0  32         bl    @film
     3042 2246 
0045 3044 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     3046 0000 
     3048 0960 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               fb.init.exit:
0050 304A C2F9  30         mov   *stack+,r11           ; Pop r11
0051 304C 045B  20         b     *r11                  ; Return to caller
0052               
**** **** ****     > stevie_b1.asm.358778
0082                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Stevie Editor - Index module
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
0046 304E 0649  14         dect  stack
0047 3050 C64B  30         mov   r11,*stack            ; Save return address
0048 3052 0649  14         dect  stack
0049 3054 C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 3056 0204  20         li    tmp0,idx.top
     3058 B000 
0054 305A C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     305C A202 
0055               
0056 305E C120  34         mov   @tv.sams.b000,tmp0
     3060 A006 
0057 3062 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     3064 A500 
0058 3066 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     3068 A502 
0059 306A C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     306C A504 
0060                       ;------------------------------------------------------
0061                       ; Clear index page
0062                       ;------------------------------------------------------
0063 306E 06A0  32         bl    @film
     3070 2246 
0064 3072 B000                   data idx.top,>00,idx.size
     3074 0000 
     3076 1000 
0065                                                   ; Clear index
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               idx.init.exit:
0070 3078 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0071 307A C2F9  30         mov   *stack+,r11           ; Pop r11
0072 307C 045B  20         b     *r11                  ; Return to caller
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
0097 307E 0649  14         dect  stack
0098 3080 C64B  30         mov   r11,*stack            ; Push return address
0099 3082 0649  14         dect  stack
0100 3084 C644  30         mov   tmp0,*stack           ; Push tmp0
0101 3086 0649  14         dect  stack
0102 3088 C645  30         mov   tmp1,*stack           ; Push tmp1
0103 308A 0649  14         dect  stack
0104 308C C646  30         mov   tmp2,*stack           ; Push tmp2
0105               *--------------------------------------------------------------
0106               * Map index pages into memory window  (b000-ffff)
0107               *--------------------------------------------------------------
0108 308E C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3090 A502 
0109 3092 0205  20         li    tmp1,idx.top
     3094 B000 
0110               
0111 3096 C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     3098 A504 
0112 309A 0586  14         inc   tmp2                  ; +1 loop adjustment
0113 309C 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     309E A502 
0114                       ;-------------------------------------------------------
0115                       ; Sanity check
0116                       ;-------------------------------------------------------
0117 30A0 0286  22         ci    tmp2,5                ; Crash if too many index pages
     30A2 0005 
0118 30A4 1104  14         jlt   !
0119 30A6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     30A8 FFCE 
0120 30AA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     30AC 2034 
0121                       ;-------------------------------------------------------
0122                       ; Loop over banks
0123                       ;-------------------------------------------------------
0124 30AE 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     30B0 254A 
0125                                                   ; \ i  tmp0  = SAMS page number
0126                                                   ; / i  tmp1  = Memory address
0127               
0128 30B2 0584  14         inc   tmp0                  ; Next SAMS index page
0129 30B4 0225  22         ai    tmp1,>1000            ; Next memory region
     30B6 1000 
0130 30B8 0606  14         dec   tmp2                  ; Update loop counter
0131 30BA 15F9  14         jgt   -!                    ; Next iteration
0132               *--------------------------------------------------------------
0133               * Exit
0134               *--------------------------------------------------------------
0135               _idx.sams.mapcolumn.on.exit:
0136 30BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0137 30BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0138 30C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0139 30C2 C2F9  30         mov   *stack+,r11           ; Pop return address
0140 30C4 045B  20         b     *r11                  ; Return to caller
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
0156 30C6 0649  14         dect  stack
0157 30C8 C64B  30         mov   r11,*stack            ; Push return address
0158 30CA 0649  14         dect  stack
0159 30CC C644  30         mov   tmp0,*stack           ; Push tmp0
0160 30CE 0649  14         dect  stack
0161 30D0 C645  30         mov   tmp1,*stack           ; Push tmp1
0162 30D2 0649  14         dect  stack
0163 30D4 C646  30         mov   tmp2,*stack           ; Push tmp2
0164 30D6 0649  14         dect  stack
0165 30D8 C647  30         mov   tmp3,*stack           ; Push tmp3
0166               *--------------------------------------------------------------
0167               * Map index pages into memory window  (b000-?????)
0168               *--------------------------------------------------------------
0169 30DA 0205  20         li    tmp1,idx.top
     30DC B000 
0170 30DE 0206  20         li    tmp2,5                ; Always 5 pages
     30E0 0005 
0171 30E2 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     30E4 A006 
0172                       ;-------------------------------------------------------
0173                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0174                       ;-------------------------------------------------------
0175 30E6 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0176               
0177 30E8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     30EA 254A 
0178                                                   ; \ i  tmp0  = SAMS page number
0179                                                   ; / i  tmp1  = Memory address
0180               
0181 30EC 0225  22         ai    tmp1,>1000            ; Next memory region
     30EE 1000 
0182 30F0 0606  14         dec   tmp2                  ; Update loop counter
0183 30F2 15F9  14         jgt   -!                    ; Next iteration
0184               *--------------------------------------------------------------
0185               * Exit
0186               *--------------------------------------------------------------
0187               _idx.sams.mapcolumn.off.exit:
0188 30F4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0189 30F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0190 30F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0191 30FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0192 30FC C2F9  30         mov   *stack+,r11           ; Pop return address
0193 30FE 045B  20         b     *r11                  ; Return to caller
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
0217 3100 0649  14         dect  stack
0218 3102 C64B  30         mov   r11,*stack            ; Save return address
0219 3104 0649  14         dect  stack
0220 3106 C644  30         mov   tmp0,*stack           ; Push tmp0
0221 3108 0649  14         dect  stack
0222 310A C645  30         mov   tmp1,*stack           ; Push tmp1
0223 310C 0649  14         dect  stack
0224 310E C646  30         mov   tmp2,*stack           ; Push tmp2
0225                       ;------------------------------------------------------
0226                       ; Determine SAMS index page
0227                       ;------------------------------------------------------
0228 3110 C184  18         mov   tmp0,tmp2             ; Line number
0229 3112 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0230 3114 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     3116 0800 
0231               
0232 3118 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0233                                                   ; | tmp1 = quotient  (SAMS page offset)
0234                                                   ; / tmp2 = remainder
0235               
0236 311A 0A16  56         sla   tmp2,1                ; line number * 2
0237 311C C806  38         mov   tmp2,@outparm1        ; Offset index entry
     311E 2F30 
0238               
0239 3120 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3122 A502 
0240 3124 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     3126 A500 
0241               
0242 3128 130E  14         jeq   _idx.samspage.get.exit
0243                                                   ; Yes, so exit
0244                       ;------------------------------------------------------
0245                       ; Activate SAMS index page
0246                       ;------------------------------------------------------
0247 312A C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     312C A500 
0248 312E C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3130 A006 
0249               
0250 3132 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0251 3134 0205  20         li    tmp1,>b000            ; Memory window for index page
     3136 B000 
0252               
0253 3138 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     313A 254A 
0254                                                   ; \ i  tmp0 = SAMS page
0255                                                   ; / i  tmp1 = Memory address
0256                       ;------------------------------------------------------
0257                       ; Check if new highest SAMS index page
0258                       ;------------------------------------------------------
0259 313C 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     313E A504 
0260 3140 1202  14         jle   _idx.samspage.get.exit
0261                                                   ; No, exit
0262 3142 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     3144 A504 
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266               _idx.samspage.get.exit:
0267 3146 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0268 3148 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0269 314A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0270 314C C2F9  30         mov   *stack+,r11           ; Pop r11
0271 314E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0083                       copy  "edb.asm"             ; Editor Buffer
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
0022 3150 0649  14         dect  stack
0023 3152 C64B  30         mov   r11,*stack            ; Save return address
0024 3154 0649  14         dect  stack
0025 3156 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3158 0204  20         li    tmp0,edb.top          ; \
     315A C000 
0030 315C C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     315E A200 
0031 3160 C804  38         mov   tmp0,@edb.next_free.ptr
     3162 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 3164 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3166 A20A 
0035               
0036 3168 0204  20         li    tmp0,1
     316A 0001 
0037 316C C804  38         mov   tmp0,@edb.lines       ; Lines=1
     316E A204 
0038               
0039 3170 04E0  34         clr   @edb.block.m1         ; Reset block start line
     3172 A20C 
0040 3174 04E0  34         clr   @edb.block.m2         ; Reset block end line
     3176 A20E 
0041 3178 04E0  34         clr   @edb.block.m3         ; Reset block target line
     317A A210 
0042               
0043 317C 0204  20         li    tmp0,txt.newfile      ; "New file"
     317E 34F8 
0044 3180 C804  38         mov   tmp0,@edb.filename.ptr
     3182 A212 
0045               
0046 3184 0204  20         li    tmp0,txt.filetype.none
     3186 350A 
0047 3188 C804  38         mov   tmp0,@edb.filetype.ptr
     318A A214 
0048               
0049               edb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 318C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0054 318E C2F9  30         mov   *stack+,r11           ; Pop r11
0055 3190 045B  20         b     *r11                  ; Return to caller
0056               
0057               
0058               
0059               
**** **** ****     > stevie_b1.asm.358778
0084                       copy  "cmdb.asm"            ; Command buffer
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
0022 3192 0649  14         dect  stack
0023 3194 C64B  30         mov   r11,*stack            ; Save return address
0024 3196 0649  14         dect  stack
0025 3198 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 319A 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     319C D000 
0030 319E C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     31A0 A300 
0031               
0032 31A2 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     31A4 A302 
0033 31A6 0204  20         li    tmp0,4
     31A8 0004 
0034 31AA C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     31AC A306 
0035 31AE C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     31B0 A308 
0036               
0037 31B2 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     31B4 A316 
0038 31B6 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     31B8 A318 
0039 31BA 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     31BC A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 31BE 06A0  32         bl    @film
     31C0 2246 
0044 31C2 D000             data  cmdb.top,>00,cmdb.size
     31C4 0000 
     31C6 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 31C8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 31CA C2F9  30         mov   *stack+,r11           ; Pop r11
0052 31CC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0085                       copy  "errline.asm"         ; Error line
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
0022 31CE 0649  14         dect  stack
0023 31D0 C64B  30         mov   r11,*stack            ; Save return address
0024 31D2 0649  14         dect  stack
0025 31D4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31D6 04E0  34         clr   @tv.error.visible     ; Set to hidden
     31D8 A024 
0030               
0031 31DA 06A0  32         bl    @film
     31DC 2246 
0032 31DE A026                   data tv.error.msg,0,160
     31E0 0000 
     31E2 00A0 
0033               
0034 31E4 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     31E6 A000 
0035 31E8 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     31EA A026 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039               errline.exit:
0040 31EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0041 31EE C2F9  30         mov   *stack+,r11           ; Pop R11
0042 31F0 045B  20         b     *r11                  ; Return to caller
0043               
**** **** ****     > stevie_b1.asm.358778
0086                       copy  "tv.asm"              ; Main editor configuration
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
0022 31F2 0649  14         dect  stack
0023 31F4 C64B  30         mov   r11,*stack            ; Save return address
0024 31F6 0649  14         dect  stack
0025 31F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31FA 0204  20         li    tmp0,1                ; \ Set default color scheme
     31FC 0001 
0030 31FE C804  38         mov   tmp0,@tv.colorscheme  ; /
     3200 A012 
0031               
0032 3202 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3204 A020 
0033 3206 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3208 201A 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037               tv.init.exit:
0038 320A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 320C C2F9  30         mov   *stack+,r11           ; Pop R11
0040 320E 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               ***************************************************************
0045               * tv.reset
0046               * Reset editor (clear buffer)
0047               ***************************************************************
0048               * bl @tv.reset
0049               *--------------------------------------------------------------
0050               * INPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * Register usage
0057               * r11
0058               *--------------------------------------------------------------
0059               * Notes
0060               ***************************************************************
0061               tv.reset:
0062 3210 0649  14         dect  stack
0063 3212 C64B  30         mov   r11,*stack            ; Save return address
0064                       ;------------------------------------------------------
0065                       ; Reset editor
0066                       ;------------------------------------------------------
0067 3214 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3216 3192 
0068 3218 06A0  32         bl    @edb.init             ; Initialize editor buffer
     321A 3150 
0069 321C 06A0  32         bl    @idx.init             ; Initialize index
     321E 304E 
0070 3220 06A0  32         bl    @fb.init              ; Initialize framebuffer
     3222 3008 
0071 3224 06A0  32         bl    @errline.init         ; Initialize error line
     3226 31CE 
0072                       ;-------------------------------------------------------
0073                       ; Exit
0074                       ;-------------------------------------------------------
0075               tv.reset.exit:
0076 3228 C2F9  30         mov   *stack+,r11           ; Pop R11
0077 322A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0087                       copy  "data.constants.asm"  ; Data Constants
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
0033 322C 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     322E 003F 
     3230 0243 
     3232 05F4 
     3234 0050 
0034               
0035               romsat:
0036 3236 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     3238 0001 
0037               
0038               cursors:
0039 323A 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     323C 0000 
     323E 0000 
     3240 001C 
0040 3242 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     3244 1010 
     3246 1010 
     3248 1000 
0041 324A 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     324C 1C1C 
     324E 1C1C 
     3250 1C00 
0042               
0043               patterns:
0044 3252 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     3254 0000 
     3256 00FF 
     3258 0000 
0045 325A 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     325C 0000 
     325E FF00 
     3260 FF00 
0046               
0047               patterns.box:
0048 3262 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     3264 0000 
     3266 FF00 
     3268 FF00 
0049 326A 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     326C 0000 
     326E FF80 
     3270 BFA0 
0050 3272 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     3274 0000 
     3276 FC04 
     3278 F414 
0051 327A A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     327C A0A0 
     327E A0A0 
     3280 A0A0 
0052 3282 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     3284 1414 
     3286 1414 
     3288 1414 
0053 328A A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     328C A0A0 
     328E BF80 
     3290 FF00 
0054 3292 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     3294 1414 
     3296 F404 
     3298 FC00 
0055 329A 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     329C C0C0 
     329E C0C0 
     32A0 0080 
0056 32A2 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     32A4 0F0F 
     32A6 0F0F 
     32A8 0000 
0057               
0058               
0059               patterns.cr:
0060 32AA 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     32AC 6C48 
     32AE 4800 
     32B0 7C00 
0061 32B2 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     32B4 64FC 
     32B6 6020 
     32B8 0000 
0062               
0063               
0064               alphalock:
0065 32BA 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     32BC 00E0 
     32BE E0E0 
     32C0 E0E0 
0066 32C2 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     32C4 E0E0 
     32C6 E0E0 
     32C8 0000 
0067               
0068               
0069               vertline:
0070 32CA 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     32CC 1010 
     32CE 1010 
     32D0 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 32D2 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     32D4 0002 
0078 32D6 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     32D8 0003 
0079 32DA A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     32DC 000A 
0080               
0081 32DE B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     32E0 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 32E2 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     32E4 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 32E6 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     32E8 000D 
0090 32EA E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     32EC 000E 
0091 32EE F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     32F0 000F 
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
0103               * C  LSB  high-nibble    Foreground color bottom line
0104               * D  LSB  low-nibble     Background color bottom line
0105               *
0106               * Word 2
0107               * E  MSB  high-nibble    Foreground color cmdb pane
0108               * F  MSB  low-nibble     Background color cmdb pane
0109               * G  LSB  high-nibble    0
0110               * H  LSB  low-nibble     Cursor foreground color
0111               *
0112               * Word 3
0113               * I  MSB  high-nibble    Foreground color busy bottom line
0114               * J  MSB  low-nibble     Background color busy bottom line
0115               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0116               * L  LSB  low-nibble     Background color marked line in frame buffer
0117               *
0118               * Word 4
0119               * M  MSB  high-nibble    0
0120               * N  MSB  low-nibble     0
0121               * O  LSB  high-nibble    0
0122               * P  LSB  low-nibble     0
0123               *--------------------------------------------------------------
0124      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0125               
0126               tv.colorscheme.table:
0127               ;                              ; #  AB          | CD          | EF    | GH
0128               ;       ABCD  EFGH  IJKL  MNOP ; ---------------|-------------|-------|---------
0129 32F2 F41F      data  >f41f,>f001,>1b4f,>0000 ; 1  whit/dblue  | black/whit  | whit  | black
     32F4 F001 
     32F6 1B4F 
     32F8 0000 
0130 32FA F41C      data  >f41c,>f00f,>1b4f,>0000 ; 2  whit/dblue  | black/dgreen| whit  | whit
     32FC F00F 
     32FE 1B4F 
     3300 0000 
0131 3302 A11A      data  >a11a,>f00f,>1f1a,>0000 ; 3  yel/black   | black/dyel  | whit  | whit
     3304 F00F 
     3306 1F1A 
     3308 0000 
0132 330A 2112      data  >2112,>f00f,>1b12,>0000 ; 4  mgreen/black| black/mgreen| white | whit
     330C F00F 
     330E 1B12 
     3310 0000 
0133 3312 E11E      data  >e11e,>f00f,>1b1e,>0000 ; 5  grey/black  | black/grey  | white | whit
     3314 F00F 
     3316 1B1E 
     3318 0000 
0134 331A 1771      data  >1771,>1006,>1b71,>0000 ; 6  black/cyan  | cyan/black  | black | ?
     331C 1006 
     331E 1B71 
     3320 0000 
0135 3322 1FF1      data  >1ff1,>1001,>1bf1,>0000 ; 7  black/whit  | whit/black  | black | black
     3324 1001 
     3326 1BF1 
     3328 0000 
0136 332A A1F0      data  >a1f0,>1a0f,>1b1a,>0000 ; 8  dyel/black  | whit/trnsp  | inver | whit
     332C 1A0F 
     332E 1B1A 
     3330 0000 
0137 3332 21F0      data  >21f0,>f20f,>1b12,>0000 ; 9  mgreen/black| whit/trnsp  | inver | whit
     3334 F20F 
     3336 1B12 
     3338 0000 
0138               
**** **** ****     > stevie_b1.asm.358778
0088                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 333A 0C53             byte  12
0013 333B ....             text  'Stevie v0.1F'
0014                       even
0015               
0016               txt.about.purpose
0017 3348 2350             byte  35
0018 3349 ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 336C 1D32             byte  29
0023 336D ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 338A 1B68             byte  27
0028 338B ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 33A6 1442             byte  20
0033 33A7 ....             text  'Build: 201126-358778'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 33BC 2446             byte  36
0039 33BD ....             text  'FCTN-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 33E2 2246             byte  34
0044 33E3 ....             text  'FCTN-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 3406 1946             byte  25
0049 3407 ....             text  'FCTN-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 3420 1C43             byte  28
0054 3421 ....             text  'CTRL-L (^L)   Load DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 343E 1C43             byte  28
0059 343F ....             text  'CTRL-K (^K)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 345C 1A43             byte  26
0064 345D ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 3478 380F     txt.about.msg7     byte    56,15
0069 347A ....                        text    ' ALPHA LOCK up     '
0070                                  byte    14
0071 348E ....                        text    ' ALPHA LOCK down   '
0072 34A1 ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 34B2 ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 34B4 052A             byte  5
0085 34B5 ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 34BA 0520             byte  5
0090 34BB ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 34C0 034F             byte  3
0095 34C1 ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 34C4 0349             byte  3
0100 34C5 ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 34C8 012A             byte  1
0105 34C9 ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 34CA 0A4C             byte  10
0110 34CB ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 34D6 0953             byte  9
0115 34D7 ....             text  'Saving...'
0116                       even
0117               
0118               txt.fastmode
0119 34E0 0846             byte  8
0120 34E1 ....             text  'Fastmode'
0121                       even
0122               
0123               txt.kb
0124 34EA 026B             byte  2
0125 34EB ....             text  'kb'
0126                       even
0127               
0128               txt.lines
0129 34EE 054C             byte  5
0130 34EF ....             text  'Lines'
0131                       even
0132               
0133               txt.bufnum
0134 34F4 0323             byte  3
0135 34F5 ....             text  '#1 '
0136                       even
0137               
0138               txt.newfile
0139 34F8 0A5B             byte  10
0140 34F9 ....             text  '[New file]'
0141                       even
0142               
0143               txt.filetype.dv80
0144 3504 0444             byte  4
0145 3505 ....             text  'DV80'
0146                       even
0147               
0148               txt.filetype.none
0149 350A 0420             byte  4
0150 350B ....             text  '    '
0151                       even
0152               
0153               txt.clear
0154 3510 0820             byte  8
0155 3511 ....             text  '        '
0156                       even
0157               
0158               txt.m1.set
0159 351A 024D             byte  2
0160 351B ....             text  'M1'
0161                       even
0162               
0163               txt.m2.set
0164 351E 024D             byte  2
0165 351F ....             text  'M2'
0166                       even
0167               
0168               
0169               
0170 3522 010F     txt.alpha.up       data >010f
0171 3524 010E     txt.alpha.down     data >010e
0172 3526 0110     txt.vertline       data >0110
0173               
0174               
0175               ;--------------------------------------------------------------
0176               ; Dialog Load DV 80 file
0177               ;--------------------------------------------------------------
0178               txt.head.load
0179 3528 0F4C             byte  15
0180 3529 ....             text  'Load DV80 file '
0181                       even
0182               
0183               txt.hint.load
0184 3538 4D48             byte  77
0185 3539 ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0186                       even
0187               
0188               txt.keys.load
0189 3586 3746             byte  55
0190 3587 ....             text  'F9=Back    F3=Clear    F5=Fastmode    ^A=Home    ^F=End'
0191                       even
0192               
0193               txt.keys.load2
0194 35BE 3746             byte  55
0195 35BF ....             text  'F9=Back    F3=Clear   *F5=Fastmode    ^A=Home    ^F=End'
0196                       even
0197               
0198               
0199               ;--------------------------------------------------------------
0200               ; Dialog Save DV 80 file
0201               ;--------------------------------------------------------------
0202               txt.head.save
0203 35F6 0F53             byte  15
0204 35F7 ....             text  'Save DV80 file '
0205                       even
0206               
0207               txt.hint.save
0208 3606 3F48             byte  63
0209 3607 ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0210                       even
0211               
0212               txt.keys.save
0213 3646 2846             byte  40
0214 3647 ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0215                       even
0216               
0217               
0218               ;--------------------------------------------------------------
0219               ; Dialog "Unsaved changes"
0220               ;--------------------------------------------------------------
0221               txt.head.unsaved
0222 3670 1055             byte  16
0223 3671 ....             text  'Unsaved changes '
0224                       even
0225               
0226               txt.info.unsaved
0227 3682 3259             byte  50
0228 3683 ....             text  'You are about to lose changes to the current file!'
0229                       even
0230               
0231               txt.hint.unsaved
0232 36B6 3F48             byte  63
0233 36B7 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0234                       even
0235               
0236               txt.keys.unsaved
0237 36F6 2846             byte  40
0238 36F7 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0239                       even
0240               
0241               
0242               
0243               
0244               ;--------------------------------------------------------------
0245               ; Dialog "Block move/copy/delete/save"
0246               ;--------------------------------------------------------------
0247               txt.head.block
0248 3720 1C42             byte  28
0249 3721 ....             text  'Block move/copy/delete/save '
0250                       even
0251               
0252               txt.info.block
0253 373E 394D             byte  57
0254 373F ....             text  'M1=[     ] start     M2=[     ] end     M3=[     ] target'
0255                       even
0256               
0257               txt.hint.block
0258 3778 4748             byte  71
0259 3779 ....             text  'HINT: Mark M1 (start) with ^1, M2 (end) with ^2 and M3 (target) with ^3'
0260                       even
0261               
0262               txt.keys.block
0263 37C0 4546             byte  69
0264 37C1 ....             text  'F9=Back   ^M=Move   ^C=Copy   ^D=Delete   ^S=Save   ^R=Reset M1/M2/M3'
0265                       even
0266               
0267               
0268               
0269               ;--------------------------------------------------------------
0270               ; Dialog "About"
0271               ;--------------------------------------------------------------
0272               txt.head.about
0273 3806 0D41             byte  13
0274 3807 ....             text  'About Stevie '
0275                       even
0276               
0277               txt.hint.about
0278 3814 2C48             byte  44
0279 3815 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0280                       even
0281               
0282               txt.keys.about
0283 3842 1546             byte  21
0284 3843 ....             text  'F9=Back    ENTER=Back'
0285                       even
0286               
0287               
0288               ;--------------------------------------------------------------
0289               ; Strings for error line pane
0290               ;--------------------------------------------------------------
0291               txt.ioerr.load
0292 3858 2049             byte  32
0293 3859 ....             text  'I/O error. Failed loading file: '
0294                       even
0295               
0296               txt.ioerr.save
0297 387A 1F49             byte  31
0298 387B ....             text  'I/O error. Failed saving file: '
0299                       even
0300               
0301               txt.io.nofile
0302 389A 2149             byte  33
0303 389B ....             text  'I/O error. No filename specified.'
0304                       even
0305               
0306               
0307               
0308               ;--------------------------------------------------------------
0309               ; Strings for command buffer
0310               ;--------------------------------------------------------------
0311               txt.cmdb.title
0312 38BC 0E43             byte  14
0313 38BD ....             text  'Command buffer'
0314                       even
0315               
0316               txt.cmdb.prompt
0317 38CC 013E             byte  1
0318 38CD ....             text  '>'
0319                       even
0320               
0321               
0322 38CE 0C0A     txt.stevie         byte    12
0323                                  byte    10
0324 38D0 ....                        text    'stevie v0.1F'
0325 38DC 0B00                        byte    11
0326                                  even
0327               
0328               txt.colorscheme
0329 38DE 0643             byte  6
0330 38DF ....             text  'Color:'
0331                       even
0332               
0333               
**** **** ****     > stevie_b1.asm.358778
0089                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      0000     key.fctn.0    equ >0000             ; fctn + 0
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
0018      0000     key.fctn.b    equ >0000             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      0000     key.fctn.h    equ >0000             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      0000     key.fctn.j    equ >0000             ; fctn + j
0027      0000     key.fctn.k    equ >0000             ; fctn + k
0028      0000     key.fctn.l    equ >0000             ; fctn + l
0029      0000     key.fctn.m    equ >0000             ; fctn + m
0030      0000     key.fctn.n    equ >0000             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      0000     key.fctn.q    equ >0000             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      0000     key.fctn.v    equ >0000             ; fctn + v
0039      0000     key.fctn.w    equ >0000             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      0000     key.fctn.y    equ >0000             ; fctn + y
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
0098               
0099               
0100               
0101               *---------------------------------------------------------------
0102               * Keyboard labels - Function keys
0103               *---------------------------------------------------------------
0104               txt.fctn.0
0105 38E6 0866             byte  8
0106 38E7 ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 38F0 0866             byte  8
0111 38F1 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 38FA 0866             byte  8
0116 38FB ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 3904 0866             byte  8
0121 3905 ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 390E 0866             byte  8
0126 390F ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 3918 0866             byte  8
0131 3919 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 3922 0866             byte  8
0136 3923 ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 392C 0866             byte  8
0141 392D ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 3936 0866             byte  8
0146 3937 ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 3940 0866             byte  8
0151 3941 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 394A 0866             byte  8
0156 394B ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 3954 0866             byte  8
0161 3955 ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 395E 0866             byte  8
0166 395F ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 3968 0866             byte  8
0171 3969 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 3972 0866             byte  8
0176 3973 ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 397C 0866             byte  8
0181 397D ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 3986 0866             byte  8
0186 3987 ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 3990 0866             byte  8
0191 3991 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 399A 0866             byte  8
0196 399B ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 39A4 0866             byte  8
0201 39A5 ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 39AE 0866             byte  8
0206 39AF ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 39B8 0866             byte  8
0211 39B9 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 39C2 0866             byte  8
0216 39C3 ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 39CC 0866             byte  8
0221 39CD ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 39D6 0866             byte  8
0226 39D7 ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 39E0 0866             byte  8
0231 39E1 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 39EA 0866             byte  8
0236 39EB ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 39F4 0866             byte  8
0241 39F5 ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 39FE 0866             byte  8
0246 39FF ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 3A08 0866             byte  8
0251 3A09 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 3A12 0866             byte  8
0256 3A13 ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 3A1C 0866             byte  8
0261 3A1D ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 3A26 0866             byte  8
0266 3A27 ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 3A30 0866             byte  8
0271 3A31 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 3A3A 0866             byte  8
0276 3A3B ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 3A44 0866             byte  8
0281 3A45 ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 3A4E 0866             byte  8
0289 3A4F ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 3A58 0866             byte  8
0294 3A59 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 3A62 0863             byte  8
0300 3A63 ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 3A6C 0863             byte  8
0305 3A6D ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 3A76 0863             byte  8
0313 3A77 ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 3A80 0863             byte  8
0318 3A81 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 3A8A 0863             byte  8
0323 3A8B ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 3A94 0863             byte  8
0328 3A95 ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 3A9E 0863             byte  8
0333 3A9F ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 3AA8 0863             byte  8
0338 3AA9 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 3AB2 0863             byte  8
0343 3AB3 ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 3ABC 0863             byte  8
0348 3ABD ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 3AC6 0863             byte  8
0353 3AC7 ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 3AD0 0863             byte  8
0358 3AD1 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 3ADA 0863             byte  8
0363 3ADB ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 3AE4 0863             byte  8
0368 3AE5 ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 3AEE 0863             byte  8
0373 3AEF ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 3AF8 0863             byte  8
0378 3AF9 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 3B02 0863             byte  8
0383 3B03 ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 3B0C 0863             byte  8
0388 3B0D ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 3B16 0863             byte  8
0393 3B17 ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 3B20 0863             byte  8
0398 3B21 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 3B2A 0863             byte  8
0403 3B2B ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 3B34 0863             byte  8
0408 3B35 ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 3B3E 0863             byte  8
0413 3B3F ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 3B48 0863             byte  8
0418 3B49 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 3B52 0863             byte  8
0423 3B53 ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 3B5C 0863             byte  8
0428 3B5D ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 3B66 0863             byte  8
0433 3B67 ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 3B70 0863             byte  8
0438 3B71 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 3B7A 0863             byte  8
0443 3B7B ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 3B84 0863             byte  8
0448 3B85 ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 3B8E 0863             byte  8
0453 3B8F ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 3B98 0863             byte  8
0458 3B99 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 3BA2 0863             byte  8
0463 3BA3 ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 3BAC 0863             byte  8
0468 3BAD ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 3BB6 0863             byte  8
0473 3BB7 ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 3BC0 0863             byte  8
0478 3BC1 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 3BCA 0863             byte  8
0483 3BCB ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 3BD4 0863             byte  8
0488 3BD5 ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 3BDE 0863             byte  8
0496 3BDF ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 3BE8 0565             byte  5
0504 3BE9 ....             text  'enter'
0505                       even
0506               
**** **** ****     > stevie_b1.asm.358778
0090                       ;------------------------------------------------------
0091                       ; End of File marker
0092                       ;------------------------------------------------------
0093 3BEE DEAD             data  >dead,>beef,>dead,>beef
     3BF0 BEEF 
     3BF2 DEAD 
     3BF4 BEEF 
0095               ***************************************************************
0096               * Step 4: Include main editor modules
0097               ********|*****|*********************|**************************
0098               main:
0099                       aorg  kickstart.code2       ; >6036
0100 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0101                       ;-----------------------------------------------------------------------
0102                       ; Include files
0103                       ;-----------------------------------------------------------------------
0104                       copy  "main.asm"            ; Main file (entrypoint)
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
     603C 202C 
0029 603E 1302  14         jeq   main.continue
0030 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0031               
0032               main.continue:
0033                       ;------------------------------------------------------
0034                       ; Setup F18A VDP
0035                       ;------------------------------------------------------
0036 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 2662 
0037               
0038 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2706 
0039 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 2342 
0040 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0041               
0042 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 2342 
0043 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0044               
0045 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 2342 
0046 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0047                       ;------------------------------------------------------
0048                       ; Clear screen (VDP SIT)
0049                       ;------------------------------------------------------
0050 605E 06A0  32         bl    @filv
     6060 229E 
0051 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0052                       ;------------------------------------------------------
0053                       ; Initialize high memory expansion
0054                       ;------------------------------------------------------
0055 6068 06A0  32         bl    @film
     606A 2246 
0056 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0057                       ;------------------------------------------------------
0058                       ; Setup SAMS windows
0059                       ;------------------------------------------------------
0060 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 687E 
0061                       ;------------------------------------------------------
0062                       ; Setup cursor, screen, etc.
0063                       ;------------------------------------------------------
0064 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2682 
0065 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2692 
0066               
0067 607E 06A0  32         bl    @cpym2m
     6080 24AE 
0068 6082 3236                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F54 
     6086 0004 
0069               
0070 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3238 
     608C A014 
0071                                                   ; Save cursor shape & color
0072               
0073 608E 06A0  32         bl    @cpym2v
     6090 245A 
0074 6092 2800                   data sprpdt,cursors,3*8
     6094 323A 
     6096 0018 
0075                                                   ; Load sprite cursor patterns
0076               
0077 6098 06A0  32         bl    @cpym2v
     609A 245A 
0078 609C 1008                   data >1008,patterns,16*8
     609E 3252 
     60A0 0080 
0079                                                   ; Load character patterns
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 31F2 
0084 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 3210 
0085                       ;------------------------------------------------------
0086                       ; Load colorscheme amd turn on screen
0087                       ;------------------------------------------------------
0088 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 78E2 
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
     60B8 26A2 
0097 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0098               
0099 60BC 0204  20         li    tmp0,timers
     60BE 2F44 
0100 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0101               
0102 60C4 06A0  32         bl    @mkslot
     60C6 2DD6 
0103 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 7646 
0104 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 772E 
0105 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 7762 
0106 60D4 0320                   data >0320,task.oneshot      ; Task 3 - One shot task
     60D6 77B0 
0107 60D8 FFFF                   data eol
0108               
0109 60DA 06A0  32         bl    @mkhook
     60DC 2DC2 
0110 60DE 7608                   data hook.keyscan     ; Setup user hook
0111               
0112 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D18 
**** **** ****     > stevie_b1.asm.358778
0105                       ;-----------------------------------------------------------------------
0106                       ; Keyboard actions
0107                       ;-----------------------------------------------------------------------
0108                       copy  "edkey.key.process.asm"
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
     6104 2034 
0027                       ;-------------------------------------------------------
0028                       ; Load Editor keyboard map
0029                       ;-------------------------------------------------------
0030               edkey.key.process.loadmap.editor:
0031 6106 0206  20         li    tmp2,keymap_actions.editor
     6108 7E64 
0032 610A 1003  14         jmp   edkey.key.check.next
0033                       ;-------------------------------------------------------
0034                       ; Load CMDB keyboard map
0035                       ;-------------------------------------------------------
0036               edkey.key.process.loadmap.cmdb:
0037 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7F14 
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
     6150 6670 
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
     6164 678E 
0106                                                   ; Add character to CMDB buffer
0107                       ;-------------------------------------------------------
0108                       ; Crash
0109                       ;-------------------------------------------------------
0110               edkey.key.process.crash:
0111 6166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6168 FFCE 
0112 616A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     616C 2034 
0113                       ;-------------------------------------------------------
0114                       ; Exit
0115                       ;-------------------------------------------------------
0116               edkey.key.process.exit:
0117 616E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6170 763A 
**** **** ****     > stevie_b1.asm.358778
0109                                                   ; Process keyboard actions
0110                       ;-----------------------------------------------------------------------
0111                       ; Keyboard actions - Framebuffer
0112                       ;-----------------------------------------------------------------------
0113                       copy  "edkey.fb.mov.leftright.asm"
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
0009 6176 1306  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6178 0620  34         dec   @fb.column            ; Column-- in screen buffer
     617A A10C 
0014 617C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     617E 832A 
0015 6180 0620  34         dec   @fb.current
     6182 A102 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 6184 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6186 763A 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.right:
0026 6188 8820  54         c     @fb.column,@fb.row.length
     618A A10C 
     618C A108 
0027 618E 1406  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 6190 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6192 A10C 
0032 6194 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6196 832A 
0033 6198 05A0  34         inc   @fb.current
     619A A102 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037 619C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     619E 763A 
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.home:
0044 61A0 C120  34         mov   @wyx,tmp0
     61A2 832A 
0045 61A4 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     61A6 FF00 
0046 61A8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     61AA 832A 
0047 61AC 04E0  34         clr   @fb.column
     61AE A10C 
0048 61B0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61B2 68FA 
0049 61B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61B6 763A 
0050               
0051               *---------------------------------------------------------------
0052               * Cursor end of line
0053               *---------------------------------------------------------------
0054               edkey.action.end:
0055 61B8 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61BA A108 
0056 61BC 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61BE 0050 
0057 61C0 1102  14         jlt   !                     ; | is right of last character on line,
0058 61C2 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61C4 004F 
0059                       ;-------------------------------------------------------
0060                       ; Set cursor X position
0061                       ;-------------------------------------------------------
0062 61C6 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61C8 A10C 
0063 61CA 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61CC 26BA 
0064 61CE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D0 68FA 
0065 61D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61D4 763A 
**** **** ****     > stevie_b1.asm.358778
0114                                                        ; Move left / right / home / end
0115                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 61D6 C120  34         mov   @fb.column,tmp0
     61D8 A10C 
0009 61DA 1324  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Prepare 2 char buffer
0012                       ;-------------------------------------------------------
0013 61DC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61DE A102 
0014 61E0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0015 61E2 1003  14         jmp   edkey.action.pword_scan_char
0016                       ;-------------------------------------------------------
0017                       ; Scan backwards to first character following space
0018                       ;-------------------------------------------------------
0019               edkey.action.pword_scan
0020 61E4 0605  14         dec   tmp1
0021 61E6 0604  14         dec   tmp0                  ; Column-- in screen buffer
0022 61E8 1315  14         jeq   edkey.action.pword_done
0023                                                   ; Column=0 ? Skip further processing
0024                       ;-------------------------------------------------------
0025                       ; Check character
0026                       ;-------------------------------------------------------
0027               edkey.action.pword_scan_char
0028 61EA D195  26         movb  *tmp1,tmp2            ; Get character
0029 61EC 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0030 61EE D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0031 61F0 0986  56         srl   tmp2,8                ; Right justify
0032 61F2 0286  22         ci    tmp2,32               ; Space character found?
     61F4 0020 
0033 61F6 16F6  14         jne   edkey.action.pword_scan
0034                                                   ; No space found, try again
0035                       ;-------------------------------------------------------
0036                       ; Space found, now look closer
0037                       ;-------------------------------------------------------
0038 61F8 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     61FA 2020 
0039 61FC 13F3  14         jeq   edkey.action.pword_scan
0040                                                   ; Yes, so continue scanning
0041 61FE 0287  22         ci    tmp3,>20ff            ; First character is space
     6200 20FF 
0042 6202 13F0  14         jeq   edkey.action.pword_scan
0043                       ;-------------------------------------------------------
0044                       ; Check distance travelled
0045                       ;-------------------------------------------------------
0046 6204 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6206 A10C 
0047 6208 61C4  18         s     tmp0,tmp3
0048 620A 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     620C 0002 
0049 620E 11EA  14         jlt   edkey.action.pword_scan
0050                                                   ; Didn't move enough so keep on scanning
0051                       ;--------------------------------------------------------
0052                       ; Set cursor following space
0053                       ;--------------------------------------------------------
0054 6210 0585  14         inc   tmp1
0055 6212 0584  14         inc   tmp0                  ; Column++ in screen buffer
0056                       ;-------------------------------------------------------
0057                       ; Save position and position hardware cursor
0058                       ;-------------------------------------------------------
0059               edkey.action.pword_done:
0060 6214 C805  38         mov   tmp1,@fb.current
     6216 A102 
0061 6218 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     621A A10C 
0062 621C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     621E 26BA 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 6220 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6222 68FA 
0068 6224 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6226 763A 
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 6228 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0077 622A C120  34         mov   @fb.column,tmp0
     622C A10C 
0078 622E 8804  38         c     tmp0,@fb.row.length
     6230 A108 
0079 6232 1428  14         jhe   !                     ; column=last char ? Skip further processing
0080                       ;-------------------------------------------------------
0081                       ; Prepare 2 char buffer
0082                       ;-------------------------------------------------------
0083 6234 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6236 A102 
0084 6238 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0085 623A 1006  14         jmp   edkey.action.nword_scan_char
0086                       ;-------------------------------------------------------
0087                       ; Multiple spaces mode
0088                       ;-------------------------------------------------------
0089               edkey.action.nword_ms:
0090 623C 0708  14         seto  tmp4                  ; Set multiple spaces mode
0091                       ;-------------------------------------------------------
0092                       ; Scan forward to first character following space
0093                       ;-------------------------------------------------------
0094               edkey.action.nword_scan
0095 623E 0585  14         inc   tmp1
0096 6240 0584  14         inc   tmp0                  ; Column++ in screen buffer
0097 6242 8804  38         c     tmp0,@fb.row.length
     6244 A108 
0098 6246 1316  14         jeq   edkey.action.nword_done
0099                                                   ; Column=last char ? Skip further processing
0100                       ;-------------------------------------------------------
0101                       ; Check character
0102                       ;-------------------------------------------------------
0103               edkey.action.nword_scan_char
0104 6248 D195  26         movb  *tmp1,tmp2            ; Get character
0105 624A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0106 624C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0107 624E 0986  56         srl   tmp2,8                ; Right justify
0108               
0109 6250 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6252 FFFF 
0110 6254 1604  14         jne   edkey.action.nword_scan_char_other
0111                       ;-------------------------------------------------------
0112                       ; Special handling if multiple spaces found
0113                       ;-------------------------------------------------------
0114               edkey.action.nword_scan_char_ms:
0115 6256 0286  22         ci    tmp2,32
     6258 0020 
0116 625A 160C  14         jne   edkey.action.nword_done
0117                                                   ; Exit if non-space found
0118 625C 10F0  14         jmp   edkey.action.nword_scan
0119                       ;-------------------------------------------------------
0120                       ; Normal handling
0121                       ;-------------------------------------------------------
0122               edkey.action.nword_scan_char_other:
0123 625E 0286  22         ci    tmp2,32               ; Space character found?
     6260 0020 
0124 6262 16ED  14         jne   edkey.action.nword_scan
0125                                                   ; No space found, try again
0126                       ;-------------------------------------------------------
0127                       ; Space found, now look closer
0128                       ;-------------------------------------------------------
0129 6264 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6266 2020 
0130 6268 13E9  14         jeq   edkey.action.nword_ms
0131                                                   ; Yes, so continue scanning
0132 626A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     626C 20FF 
0133 626E 13E7  14         jeq   edkey.action.nword_scan
0134                       ;--------------------------------------------------------
0135                       ; Set cursor following space
0136                       ;--------------------------------------------------------
0137 6270 0585  14         inc   tmp1
0138 6272 0584  14         inc   tmp0                  ; Column++ in screen buffer
0139                       ;-------------------------------------------------------
0140                       ; Save position and position hardware cursor
0141                       ;-------------------------------------------------------
0142               edkey.action.nword_done:
0143 6274 C805  38         mov   tmp1,@fb.current
     6276 A102 
0144 6278 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     627A A10C 
0145 627C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     627E 26BA 
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 6280 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6282 68FA 
0151 6284 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6286 763A 
0152               
0153               
**** **** ****     > stevie_b1.asm.358778
0116                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current line if dirty
0010                       ;-------------------------------------------------------
0011 6288 8820  54         c     @fb.row.dirty,@w$ffff
     628A A10A 
     628C 2030 
0012 628E 1604  14         jne   edkey.action.up.cursor
0013 6290 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6292 6BF6 
0014 6294 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6296 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Move cursor
0017                       ;-------------------------------------------------------
0018               edkey.action.up.cursor:
0019 6298 C120  34         mov   @fb.row,tmp0
     629A A106 
0020 629C 1509  14         jgt   edkey.action.up.cursor_up
0021                                                   ; Move cursor up if fb.row > 0
0022 629E C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62A0 A104 
0023 62A2 130A  14         jeq   edkey.action.up.set_cursorx
0024                                                   ; At top, only position cursor X
0025                       ;-------------------------------------------------------
0026                       ; Scroll 1 line
0027                       ;-------------------------------------------------------
0028 62A4 0604  14         dec   tmp0                  ; fb.topline--
0029 62A6 C804  38         mov   tmp0,@parm1
     62A8 2F20 
0030 62AA 06A0  32         bl    @fb.refresh           ; Scroll one line up
     62AC 696A 
0031 62AE 1004  14         jmp   edkey.action.up.set_cursorx
0032                       ;-------------------------------------------------------
0033                       ; Move cursor up
0034                       ;-------------------------------------------------------
0035               edkey.action.up.cursor_up:
0036 62B0 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62B2 A106 
0037 62B4 06A0  32         bl    @up                   ; Row-- VDP cursor
     62B6 26B0 
0038                       ;-------------------------------------------------------
0039                       ; Check line length and position cursor
0040                       ;-------------------------------------------------------
0041               edkey.action.up.set_cursorx:
0042 62B8 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62BA 6DDC 
0043                                                   ; | i  @fb.row        = Row in frame buffer
0044                                                   ; / o  @fb.row.length = Length of row
0045               
0046 62BC 8820  54         c     @fb.column,@fb.row.length
     62BE A10C 
     62C0 A108 
0047 62C2 1207  14         jle   edkey.action.up.exit
0048                       ;-------------------------------------------------------
0049                       ; Adjust cursor column position
0050                       ;-------------------------------------------------------
0051 62C4 C820  54         mov   @fb.row.length,@fb.column
     62C6 A108 
     62C8 A10C 
0052 62CA C120  34         mov   @fb.column,tmp0
     62CC A10C 
0053 62CE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62D0 26BA 
0054                       ;-------------------------------------------------------
0055                       ; Exit
0056                       ;-------------------------------------------------------
0057               edkey.action.up.exit:
0058 62D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62D4 68FA 
0059 62D6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62D8 763A 
0060               
0061               
0062               
0063               *---------------------------------------------------------------
0064               * Cursor down
0065               *---------------------------------------------------------------
0066               edkey.action.down:
0067 62DA 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     62DC A106 
     62DE A204 
0068 62E0 1330  14         jeq   !                     ; Yes, skip further processing
0069                       ;-------------------------------------------------------
0070                       ; Crunch current row if dirty
0071                       ;-------------------------------------------------------
0072 62E2 8820  54         c     @fb.row.dirty,@w$ffff
     62E4 A10A 
     62E6 2030 
0073 62E8 1604  14         jne   edkey.action.down.move
0074 62EA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     62EC 6BF6 
0075 62EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62F0 A10A 
0076                       ;-------------------------------------------------------
0077                       ; Move cursor
0078                       ;-------------------------------------------------------
0079               edkey.action.down.move:
0080                       ;-------------------------------------------------------
0081                       ; EOF reached?
0082                       ;-------------------------------------------------------
0083 62F2 C120  34         mov   @fb.topline,tmp0
     62F4 A104 
0084 62F6 A120  34         a     @fb.row,tmp0
     62F8 A106 
0085 62FA 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     62FC A204 
0086 62FE 1312  14         jeq   edkey.action.down.set_cursorx
0087                                                   ; Yes, only position cursor X
0088                       ;-------------------------------------------------------
0089                       ; Check if scrolling required
0090                       ;-------------------------------------------------------
0091 6300 C120  34         mov   @fb.scrrows,tmp0
     6302 A118 
0092 6304 0604  14         dec   tmp0
0093 6306 8120  34         c     @fb.row,tmp0
     6308 A106 
0094 630A 1108  14         jlt   edkey.action.down.cursor
0095                       ;-------------------------------------------------------
0096                       ; Scroll 1 line
0097                       ;-------------------------------------------------------
0098 630C C820  54         mov   @fb.topline,@parm1
     630E A104 
     6310 2F20 
0099 6312 05A0  34         inc   @parm1
     6314 2F20 
0100 6316 06A0  32         bl    @fb.refresh
     6318 696A 
0101 631A 1004  14         jmp   edkey.action.down.set_cursorx
0102                       ;-------------------------------------------------------
0103                       ; Move cursor down a row, there are still rows left
0104                       ;-------------------------------------------------------
0105               edkey.action.down.cursor:
0106 631C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     631E A106 
0107 6320 06A0  32         bl    @down                 ; Row++ VDP cursor
     6322 26A8 
0108                       ;-------------------------------------------------------
0109                       ; Check line length and position cursor
0110                       ;-------------------------------------------------------
0111               edkey.action.down.set_cursorx:
0112 6324 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6326 6DDC 
0113                                                   ; | i  @fb.row        = Row in frame buffer
0114                                                   ; / o  @fb.row.length = Length of row
0115               
0116 6328 8820  54         c     @fb.column,@fb.row.length
     632A A10C 
     632C A108 
0117 632E 1207  14         jle   edkey.action.down.exit
0118                                                   ; Exit
0119                       ;-------------------------------------------------------
0120                       ; Adjust cursor column position
0121                       ;-------------------------------------------------------
0122 6330 C820  54         mov   @fb.row.length,@fb.column
     6332 A108 
     6334 A10C 
0123 6336 C120  34         mov   @fb.column,tmp0
     6338 A10C 
0124 633A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     633C 26BA 
0125                       ;-------------------------------------------------------
0126                       ; Exit
0127                       ;-------------------------------------------------------
0128               edkey.action.down.exit:
0129 633E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6340 68FA 
0130 6342 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6344 763A 
**** **** ****     > stevie_b1.asm.358778
0117                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current row if dirty
0010                       ;-------------------------------------------------------
0011 6346 8820  54         c     @fb.row.dirty,@w$ffff
     6348 A10A 
     634A 2030 
0012 634C 1604  14         jne   edkey.action.ppage.sanity
0013 634E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6350 6BF6 
0014 6352 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6354 A10A 
0015                       ;-------------------------------------------------------
0016                       ; Sanity check
0017                       ;-------------------------------------------------------
0018               edkey.action.ppage.sanity:
0019 6356 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6358 A104 
0020 635A 130D  14         jeq   edkey.action.ppage.exit
0021                       ;-------------------------------------------------------
0022                       ; Special treatment top page
0023                       ;-------------------------------------------------------
0024 635C 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     635E A118 
0025 6360 1503  14         jgt   edkey.action.ppage.topline
0026 6362 04E0  34         clr   @fb.topline           ; topline = 0
     6364 A104 
0027 6366 1003  14         jmp   edkey.action.ppage.refresh
0028                       ;-------------------------------------------------------
0029                       ; Adjust topline
0030                       ;-------------------------------------------------------
0031               edkey.action.ppage.topline:
0032 6368 6820  54         s     @fb.scrrows,@fb.topline
     636A A118 
     636C A104 
0033                       ;-------------------------------------------------------
0034                       ; Refresh page
0035                       ;-------------------------------------------------------
0036               edkey.action.ppage.refresh:
0037 636E C820  54         mov   @fb.topline,@parm1
     6370 A104 
     6372 2F20 
0038               
0039 6374 101B  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0040                                                   ; / i  @parm1 = Line in editor buffer
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.ppage.exit:
0045 6376 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6378 763A 
0046               
0047               
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Next page
0052               *---------------------------------------------------------------
0053               edkey.action.npage:
0054                       ;-------------------------------------------------------
0055                       ; Crunch current row if dirty
0056                       ;-------------------------------------------------------
0057 637A 8820  54         c     @fb.row.dirty,@w$ffff
     637C A10A 
     637E 2030 
0058 6380 1604  14         jne   edkey.action.npage.sanity
0059 6382 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6384 6BF6 
0060 6386 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6388 A10A 
0061                       ;-------------------------------------------------------
0062                       ; Sanity check
0063                       ;-------------------------------------------------------
0064               edkey.action.npage.sanity:
0065 638A C120  34         mov   @fb.topline,tmp0
     638C A104 
0066 638E A120  34         a     @fb.scrrows,tmp0
     6390 A118 
0067 6392 0584  14         inc   tmp0                  ; Base 1 offset !
0068 6394 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6396 A204 
0069 6398 1507  14         jgt   edkey.action.npage.exit
0070                       ;-------------------------------------------------------
0071                       ; Adjust topline
0072                       ;-------------------------------------------------------
0073               edkey.action.npage.topline:
0074 639A A820  54         a     @fb.scrrows,@fb.topline
     639C A118 
     639E A104 
0075                       ;-------------------------------------------------------
0076                       ; Refresh page
0077                       ;-------------------------------------------------------
0078               edkey.action.npage.refresh:
0079 63A0 C820  54         mov   @fb.topline,@parm1
     63A2 A104 
     63A4 2F20 
0080               
0081 63A6 1002  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0082                                                   ; / i  @parm1 = Line in editor buffer
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.npage.exit:
0087 63A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63AA 763A 
**** **** ****     > stevie_b1.asm.358778
0118                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
**** **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
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
0026 63AC 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63AE 696A 
0027                                                   ; | i  @parm1 = Line to start with
0028                                                   ; /             (becomes @fb.topline)
0029               
0030 63B0 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B2 A106 
0031 63B4 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B6 A10C 
0032 63B8 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63BA 832A 
0033               
0034 63BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BE 68FA 
0035               
0036 63C0 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63C2 6DDC 
0037                                                   ; | i  @fb.row        = Row in frame buffer
0038                                                   ; / o  @fb.row.length = Length of row
0039               
0040 63C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C6 763A 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Goto top of file
0045               *---------------------------------------------------------------
0046               edkey.action.top:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current row if dirty
0049                       ;-------------------------------------------------------
0050 63C8 8820  54         c     @fb.row.dirty,@w$ffff
     63CA A10A 
     63CC 2030 
0051 63CE 1604  14         jne   edkey.action.top.refresh
0052 63D0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63D2 6BF6 
0053 63D4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D6 A10A 
0054                       ;-------------------------------------------------------
0055                       ; Refresh page
0056                       ;-------------------------------------------------------
0057               edkey.action.top.refresh:
0058 63D8 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63DA 2F20 
0059               
0060 63DC 10E7  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0061                                                   ; / i  @parm1 = Line in editor buffer
0062               
0063               
0064               
0065               
0066               *---------------------------------------------------------------
0067               * Goto bottom of file
0068               *---------------------------------------------------------------
0069               edkey.action.bot:
0070                       ;-------------------------------------------------------
0071                       ; Crunch current row if dirty
0072                       ;-------------------------------------------------------
0073 63DE 8820  54         c     @fb.row.dirty,@w$ffff
     63E0 A10A 
     63E2 2030 
0074 63E4 1604  14         jne   edkey.action.bot.refresh
0075 63E6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63E8 6BF6 
0076 63EA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63EC A10A 
0077                       ;-------------------------------------------------------
0078                       ; Refresh page
0079                       ;-------------------------------------------------------
0080               edkey.action.bot.refresh:
0081 63EE 8820  54         c     @edb.lines,@fb.scrrows
     63F0 A204 
     63F2 A118 
0082 63F4 1207  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0083               
0084 63F6 C120  34         mov   @edb.lines,tmp0
     63F8 A204 
0085 63FA 6120  34         s     @fb.scrrows,tmp0
     63FC A118 
0086 63FE C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6400 2F20 
0087               
0088 6402 10D4  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0089                                                   ; / i  @parm1 = Line in editor buffer
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.bot.exit:
0094 6404 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6406 763A 
**** **** ****     > stevie_b1.asm.358778
0119                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 6408 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     640A A206 
0009 640C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     640E 68FA 
0010                       ;-------------------------------------------------------
0011                       ; Sanity check 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 6410 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6412 A108 
0015 6414 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 6416 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6418 A102 
0019                       ;-------------------------------------------------------
0020                       ; Sanity check 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 641A C1C6  18         mov   tmp2,tmp3             ; \
0024 641C 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 641E 81E0  34         c     @fb.column,tmp3
     6420 A10C 
0026 6422 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 6424 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 6426 D505  30         movb  tmp1,*tmp0            ; /
0033 6428 C820  54         mov   @fb.column,@fb.row.length
     642A A10C 
     642C A108 
0034                                                   ; Row length - 1
0035 642E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6430 A10A 
0036 6432 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6434 A116 
0037 6436 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Sanity check 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 6438 0286  22         ci    tmp2,colrow
     643A 0050 
0043 643C 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 643E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6440 FFCE 
0049 6442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6444 2034 
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 6446 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 6448 61E0  34         s     @fb.column,tmp3
     644A A10C 
0056 644C 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 644E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 6450 C144  18         mov   tmp0,tmp1
0059 6452 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 6454 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6456 A10C 
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6458 C120  34         mov   @fb.current,tmp0      ; Get pointer
     645A A102 
0065 645C C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 645E 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 6460 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 6462 0606  14         dec   tmp2
0073 6464 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 6466 0206  20         li    tmp2,colrow
     6468 0050 
0078 646A 81A0  34         c     @fb.row.length,tmp2
     646C A108 
0079 646E 1603  14         jne   edkey.action.del_char.save
0080 6470 0604  14         dec   tmp0                  ; One time adjustment
0081 6472 04C5  14         clr   tmp1
0082 6474 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 6476 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6478 A10A 
0088 647A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     647C A116 
0089 647E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6480 A108 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 6482 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6484 763A 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 6486 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6488 A206 
0102 648A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     648C 68FA 
0103 648E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6490 A108 
0104 6492 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 6494 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6496 A102 
0110 6498 C1A0  34         mov   @fb.colsline,tmp2
     649A A10E 
0111 649C 61A0  34         s     @fb.column,tmp2
     649E A10C 
0112 64A0 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 64A2 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 64A4 0606  14         dec   tmp2
0119 64A6 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 64A8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64AA A10A 
0124 64AC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64AE A116 
0125               
0126 64B0 C820  54         mov   @fb.column,@fb.row.length
     64B2 A10C 
     64B4 A108 
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 64B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64B8 763A 
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139 64BA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64BC A206 
0140                       ;-------------------------------------------------------
0141                       ; Special treatment if only 1 line in editor buffer
0142                       ;-------------------------------------------------------
0143 64BE C120  34          mov   @edb.lines,tmp0      ; \
     64C0 A204 
0144 64C2 0284  22          ci    tmp0,1               ; /  Only a single line?
     64C4 0001 
0145 64C6 1323  14          jeq   edkey.action.del_line.1stline
0146                                                   ; Yes, handle single line and exit
0147                       ;-------------------------------------------------------
0148                       ; Delete entry in index
0149                       ;-------------------------------------------------------
0150 64C8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64CA 68FA 
0151               
0152 64CC 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64CE A10A 
0153               
0154 64D0 C820  54         mov   @fb.topline,@parm1
     64D2 A104 
     64D4 2F20 
0155 64D6 A820  54         a     @fb.row,@parm1        ; Line number to remove
     64D8 A106 
     64DA 2F20 
0156 64DC C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64DE A204 
     64E0 2F22 
0157               
0158 64E2 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     64E4 6B04 
0159                                                   ; \ i  @parm1 = Line in editor buffer
0160                                                   ; / i  @parm2 = Last line for index reorg
0161                       ;-------------------------------------------------------
0162                       ; Get length of current row in framebuffer
0163                       ;-------------------------------------------------------
0164 64E6 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64E8 6DDC 
0165                                                   ; \ i  @fb.row        = Current row
0166                                                   ; / o  @fb.row.length = Length of row
0167                       ;-------------------------------------------------------
0168                       ; Refresh frame buffer and physical screen
0169                       ;-------------------------------------------------------
0170 64EA 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64EC A204 
0171 64EE C820  54         mov   @fb.topline,@parm1
     64F0 A104 
     64F2 2F20 
0172 64F4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64F6 696A 
0173 64F8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FA A116 
0174                       ;-------------------------------------------------------
0175                       ; Special treatment if current line was last line
0176                       ;-------------------------------------------------------
0177 64FC C120  34         mov   @fb.topline,tmp0
     64FE A104 
0178 6500 A120  34         a     @fb.row,tmp0
     6502 A106 
0179 6504 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6506 A204 
0180 6508 1112  14         jlt   edkey.action.del_line.exit
0181 650A 0460  28         b     @edkey.action.up      ; One line up
     650C 6288 
0182                       ;-------------------------------------------------------
0183                       ; Special treatment if only 1 line in editor buffer
0184                       ;-------------------------------------------------------
0185               edkey.action.del_line.1stline:
0186 650E 04E0  34         clr   @fb.column            ; Column 0
     6510 A10C 
0187 6512 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6514 68FA 
0188               
0189 6516 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6518 A10A 
0190 651A 04E0  34         clr   @parm1
     651C 2F20 
0191 651E 04E0  34         clr   @parm2
     6520 2F22 
0192               
0193 6522 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     6524 6B04 
0194                                                   ; \ i  @parm1 = Line in editor buffer
0195                                                   ; / i  @parm2 = Last line for index reorg
0196               
0197 6526 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6528 696A 
0198 652A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     652C A116 
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 652E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6530 61A0 
**** **** ****     > stevie_b1.asm.358778
0120                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
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
0010 6532 0204  20         li    tmp0,>2000            ; White space
     6534 2000 
0011 6536 C804  38         mov   tmp0,@parm1
     6538 2F20 
0012               edkey.action.ins_char:
0013 653A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     653C A206 
0014 653E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6540 68FA 
0015                       ;-------------------------------------------------------
0016                       ; Sanity check 1 - Empty line
0017                       ;-------------------------------------------------------
0018 6542 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6544 A102 
0019 6546 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6548 A108 
0020 654A 132C  14         jeq   edkey.action.ins_char.append
0021                                                   ; Add character in append mode
0022                       ;-------------------------------------------------------
0023                       ; Sanity check 2 - EOL
0024                       ;-------------------------------------------------------
0025 654C 8820  54         c     @fb.column,@fb.row.length
     654E A10C 
     6550 A108 
0026 6552 1328  14         jeq   edkey.action.ins_char.append
0027                                                   ; Add character in append mode
0028                       ;-------------------------------------------------------
0029                       ; Sanity check 3 - Overwrite if at column 80
0030                       ;-------------------------------------------------------
0031 6554 C160  34         mov   @fb.column,tmp1
     6556 A10C 
0032 6558 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     655A 004F 
0033 655C 1102  14         jlt   !
0034 655E 0460  28         b     @edkey.action.char.overwrite
     6560 6692 
0035                       ;-------------------------------------------------------
0036                       ; Sanity check 4 - 80 characters maximum
0037                       ;-------------------------------------------------------
0038 6562 C160  34 !       mov   @fb.row.length,tmp1
     6564 A108 
0039 6566 0285  22         ci    tmp1,colrow
     6568 0050 
0040 656A 1101  14         jlt   edkey.action.ins_char.prep
0041 656C 101D  14         jmp   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Calculate number of characters to move
0044                       ;-------------------------------------------------------
0045               edkey.action.ins_char.prep:
0046 656E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 6570 61E0  34         s     @fb.column,tmp3
     6572 A10C 
0048 6574 0607  14         dec   tmp3                  ; Remove base 1 offset
0049 6576 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0050 6578 C144  18         mov   tmp0,tmp1
0051 657A 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0052 657C 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     657E A10C 
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 6580 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 6582 0604  14         dec   tmp0
0059 6584 0605  14         dec   tmp1
0060 6586 0606  14         dec   tmp2
0061 6588 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Insert specified character at current position
0064                       ;-------------------------------------------------------
0065 658A D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     658C 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 658E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6590 A10A 
0070 6592 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6594 A116 
0071 6596 05A0  34         inc   @fb.column
     6598 A10C 
0072 659A 05A0  34         inc   @wyx
     659C 832A 
0073 659E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65A0 A108 
0074 65A2 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 65A4 0460  28         b     @edkey.action.char.overwrite
     65A6 6692 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 65A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65AA 763A 
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
0095 65AC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65AE A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 65B0 8820  54         c     @fb.row.dirty,@w$ffff
     65B2 A10A 
     65B4 2030 
0100 65B6 1604  14         jne   edkey.action.ins_line.insert
0101 65B8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65BA 6BF6 
0102 65BC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65BE A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 65C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C2 68FA 
0108 65C4 C820  54         mov   @fb.topline,@parm1
     65C6 A104 
     65C8 2F20 
0109 65CA A820  54         a     @fb.row,@parm1        ; Line number to insert
     65CC A106 
     65CE 2F20 
0110 65D0 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     65D2 A204 
     65D4 2F22 
0111               
0112 65D6 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     65D8 6B9E 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 65DA 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     65DC A204 
0117                       ;-------------------------------------------------------
0118                       ; Refresh frame buffer and physical screen
0119                       ;-------------------------------------------------------
0120 65DE C820  54         mov   @fb.topline,@parm1
     65E0 A104 
     65E2 2F20 
0121 65E4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     65E6 696A 
0122 65E8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65EA A116 
0123                       ;-------------------------------------------------------
0124                       ; Exit
0125                       ;-------------------------------------------------------
0126               edkey.action.ins_line.exit:
0127 65EC 0460  28         b     @edkey.action.home    ; Position cursor at home
     65EE 61A0 
0128               
**** **** ****     > stevie_b1.asm.358778
0121                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current line if dirty
0010                       ;-------------------------------------------------------
0011 65F0 8820  54         c     @fb.row.dirty,@w$ffff
     65F2 A10A 
     65F4 2030 
0012 65F6 1606  14         jne   edkey.action.enter.upd_counter
0013 65F8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65FA A206 
0014 65FC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65FE 6BF6 
0015 6600 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6602 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Update line counter
0018                       ;-------------------------------------------------------
0019               edkey.action.enter.upd_counter:
0020 6604 C120  34         mov   @fb.topline,tmp0
     6606 A104 
0021 6608 A120  34         a     @fb.row,tmp0
     660A A106 
0022 660C 0584  14         inc   tmp0
0023 660E 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6610 A204 
0024 6612 1102  14         jlt   edkey.action.newline  ; No, continue newline
0025 6614 05A0  34         inc   @edb.lines            ; Total lines++
     6616 A204 
0026                       ;-------------------------------------------------------
0027                       ; Process newline
0028                       ;-------------------------------------------------------
0029               edkey.action.newline:
0030                       ;-------------------------------------------------------
0031                       ; Scroll 1 line if cursor at bottom row of screen
0032                       ;-------------------------------------------------------
0033 6618 C120  34         mov   @fb.scrrows,tmp0
     661A A118 
0034 661C 0604  14         dec   tmp0
0035 661E 8120  34         c     @fb.row,tmp0
     6620 A106 
0036 6622 110A  14         jlt   edkey.action.newline.down
0037                       ;-------------------------------------------------------
0038                       ; Scroll
0039                       ;-------------------------------------------------------
0040 6624 C120  34         mov   @fb.scrrows,tmp0
     6626 A118 
0041 6628 C820  54         mov   @fb.topline,@parm1
     662A A104 
     662C 2F20 
0042 662E 05A0  34         inc   @parm1
     6630 2F20 
0043 6632 06A0  32         bl    @fb.refresh
     6634 696A 
0044 6636 1004  14         jmp   edkey.action.newline.rest
0045                       ;-------------------------------------------------------
0046                       ; Move cursor down a row, there are still rows left
0047                       ;-------------------------------------------------------
0048               edkey.action.newline.down:
0049 6638 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     663A A106 
0050 663C 06A0  32         bl    @down                 ; Row++ VDP cursor
     663E 26A8 
0051                       ;-------------------------------------------------------
0052                       ; Set VDP cursor and save variables
0053                       ;-------------------------------------------------------
0054               edkey.action.newline.rest:
0055 6640 06A0  32         bl    @fb.get.firstnonblank
     6642 6922 
0056 6644 C120  34         mov   @outparm1,tmp0
     6646 2F30 
0057 6648 C804  38         mov   tmp0,@fb.column
     664A A10C 
0058 664C 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     664E 26BA 
0059 6650 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     6652 6DDC 
0060 6654 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6656 68FA 
0061 6658 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     665A A116 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065               edkey.action.newline.exit:
0066 665C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665E 763A 
0067               
0068               
0069               
0070               
0071               *---------------------------------------------------------------
0072               * Toggle insert/overwrite mode
0073               *---------------------------------------------------------------
0074               edkey.action.ins_onoff:
0075 6660 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     6662 A20A 
0076                       ;-------------------------------------------------------
0077                       ; Delay
0078                       ;-------------------------------------------------------
0079 6664 0204  20         li    tmp0,2000
     6666 07D0 
0080               edkey.action.ins_onoff.loop:
0081 6668 0604  14         dec   tmp0
0082 666A 16FE  14         jne   edkey.action.ins_onoff.loop
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.ins_onoff.exit:
0087 666C 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     666E 7762 
0088               
0089               
0090               
0091               
0092               *---------------------------------------------------------------
0093               * Add character (frame buffer)
0094               *---------------------------------------------------------------
0095               edkey.action.char:
0096                       ;-------------------------------------------------------
0097                       ; Sanity checks
0098                       ;-------------------------------------------------------
0099 6670 D105  18         movb  tmp1,tmp0             ; Get keycode
0100 6672 0984  56         srl   tmp0,8                ; MSB to LSB
0101               
0102 6674 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6676 0020 
0103 6678 112B  14         jlt   edkey.action.char.exit
0104                                                   ; Yes, skip
0105               
0106 667A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     667C 007E 
0107 667E 1528  14         jgt   edkey.action.char.exit
0108                                                   ; Yes, skip
0109                       ;-------------------------------------------------------
0110                       ; Setup
0111                       ;-------------------------------------------------------
0112 6680 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6682 A206 
0113 6684 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6686 2F20 
0114 6688 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     668A A20A 
0115 668C 1302  14         jeq   edkey.action.char.overwrite
0116                       ;-------------------------------------------------------
0117                       ; Insert mode
0118                       ;-------------------------------------------------------
0119               edkey.action.char.insert:
0120 668E 0460  28         b     @edkey.action.ins_char
     6690 653A 
0121                       ;-------------------------------------------------------
0122                       ; Overwrite mode - Write character
0123                       ;-------------------------------------------------------
0124               edkey.action.char.overwrite:
0125 6692 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6694 68FA 
0126 6696 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6698 A102 
0127               
0128 669A D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     669C 2F20 
0129 669E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     66A0 A10A 
0130 66A2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66A4 A116 
0131                       ;-------------------------------------------------------
0132                       ; Last column on screen reached?
0133                       ;-------------------------------------------------------
0134 66A6 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     66A8 A10C 
0135 66AA 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     66AC 004F 
0136 66AE 1105  14         jlt   edkey.action.char.overwrite.incx
0137                                                   ; No, increase X position
0138               
0139 66B0 0205  20         li    tmp1,colrow           ; \
     66B2 0050 
0140 66B4 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     66B6 A108 
0141 66B8 100B  14         jmp   edkey.action.char.exit
0142                       ;-------------------------------------------------------
0143                       ; Increase column
0144                       ;-------------------------------------------------------
0145               edkey.action.char.overwrite.incx:
0146 66BA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     66BC A10C 
0147 66BE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     66C0 832A 
0148                       ;-------------------------------------------------------
0149                       ; Update line length in frame buffer
0150                       ;-------------------------------------------------------
0151 66C2 8820  54         c     @fb.column,@fb.row.length
     66C4 A10C 
     66C6 A108 
0152                                                   ; column < line length ?
0153 66C8 1103  14         jlt   edkey.action.char.exit
0154                                                   ; Yes, don't update row length
0155 66CA C820  54         mov   @fb.column,@fb.row.length
     66CC A10C 
     66CE A108 
0156                                                   ; Set row length
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.char.exit:
0161 66D0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D2 763A 
**** **** ****     > stevie_b1.asm.358778
0122                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
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
0011 66D4 C120  34         mov   @edb.dirty,tmp0
     66D6 A206 
0012 66D8 1302  14         jeq   !
0013 66DA 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66DC 7DF4 
0014                       ;-------------------------------------------------------
0015                       ; Reset and lock F18a
0016                       ;-------------------------------------------------------
0017 66DE 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     66E0 276A 
0018 66E2 0420  54         blwp  @0                    ; Exit
     66E4 0000 
**** **** ****     > stevie_b1.asm.358778
0123                       copy  "edkey.fb.file.asm"        ; File related actions
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
0017 66E6 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66E8 A444 
     66EA 2F20 
0018 66EC 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     66EE 2F22 
0019 66F0 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 66F2 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66F4 A444 
     66F6 2F20 
0023 66F8 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66FA 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Sanity check
0028                       ;------------------------------------------------------
0029 66FC C120  34         mov   @parm1,tmp0
     66FE 2F20 
0030 6700 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 6702 C120  34         mov   @edb.dirty,tmp0
     6704 A206 
0036 6706 1302  14         jeq   !
0037 6708 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     670A 7DF4 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 670C 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     670E 7586 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 6710 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6712 E000 
0047 6714 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6716 72C6 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 6718 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     671A 63C8 
**** **** ****     > stevie_b1.asm.358778
0124                       copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
**** **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark.m1:
0008 671C 06A0  32         bl    @edb.line.mark.m1     ; Set M1 marker
     671E 6E00 
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.block.mark.m1.exit:
0013 6720 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6722 763A 
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Mark line M2
0019               ********|*****|*********************|**************************
0020               edkey.action.block.mark.m2:
0021 6724 06A0  32         bl    @edb.line.mark.m2     ; Set M1 marker
     6726 6E46 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.block.mark.m2.exit:
0026 6728 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     672A 763A 
0027               
0028               
**** **** ****     > stevie_b1.asm.358778
0125                       ;-----------------------------------------------------------------------
0126                       ; Keyboard actions - Command Buffer
0127                       ;-----------------------------------------------------------------------
0128                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 672C C120  34         mov   @cmdb.column,tmp0
     672E A312 
0009 6730 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6732 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6734 A312 
0014 6736 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6738 A30A 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 673A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     673C 763A 
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 673E 06A0  32         bl    @cmdb.cmd.getlength
     6740 6F10 
0026 6742 8820  54         c     @cmdb.column,@outparm1
     6744 A312 
     6746 2F30 
0027 6748 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 674A 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     674C A312 
0032 674E 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     6750 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 6752 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6754 763A 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 6756 04C4  14         clr   tmp0
0045 6758 C804  38         mov   tmp0,@cmdb.column      ; First column
     675A A312 
0046 675C 0584  14         inc   tmp0
0047 675E D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     6760 A30A 
0048 6762 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     6764 A30A 
0049               
0050 6766 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6768 763A 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 676A D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     676C A326 
0057 676E 0984  56         srl   tmp0,8                 ; Right justify
0058 6770 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6772 A312 
0059 6774 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 6776 0224  22         ai    tmp0,>1a00             ; Y=26
     6778 1A00 
0061 677A C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     677C A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 677E 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6780 763A 
**** **** ****     > stevie_b1.asm.358778
0129                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0025 6782 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6784 6EDE 
0026 6786 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6788 A318 
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 678A 0460  28         b     @edkey.action.cmdb.home
     678C 6756 
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
0060 678E D105  18         movb  tmp1,tmp0             ; Get keycode
0061 6790 0984  56         srl   tmp0,8                ; MSB to LSB
0062               
0063 6792 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6794 0020 
0064 6796 1115  14         jlt   edkey.action.cmdb.char.exit
0065                                                   ; Yes, skip
0066               
0067 6798 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     679A 007E 
0068 679C 1512  14         jgt   edkey.action.cmdb.char.exit
0069                                                   ; Yes, skip
0070                       ;-------------------------------------------------------
0071                       ; Add character
0072                       ;-------------------------------------------------------
0073 679E 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     67A0 A318 
0074               
0075 67A2 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     67A4 A327 
0076 67A6 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     67A8 A312 
0077 67AA D505  30         movb  tmp1,*tmp0            ; Add character
0078 67AC 05A0  34         inc   @cmdb.column          ; Next column
     67AE A312 
0079 67B0 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     67B2 A30A 
0080               
0081 67B4 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     67B6 6F10 
0082                                                   ; \ i  @cmdb.cmd = Command string
0083                                                   ; / o  @outparm1 = Length of command
0084                       ;-------------------------------------------------------
0085                       ; Addjust length
0086                       ;-------------------------------------------------------
0087 67B8 C120  34         mov   @outparm1,tmp0
     67BA 2F30 
0088 67BC 0A84  56         sla   tmp0,8               ; LSB to MSB
0089 67BE D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     67C0 A326 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.char.exit:
0094 67C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67C4 763A 
0095               
0096               
0097               
0098               
0099               *---------------------------------------------------------------
0100               * Enter
0101               *---------------------------------------------------------------
0102               edkey.action.cmdb.enter:
0103                       ;-------------------------------------------------------
0104                       ; Show Load or Save dialog depending on current mode
0105                       ;-------------------------------------------------------
0106               edkey.action.cmdb.enter.loadsave:
0107 67C6 0460  28         b     @edkey.action.cmdb.loadsave
     67C8 67E6 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               edkey.action.cmdb.enter.exit:
0112 67CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67CC 763A 
**** **** ****     > stevie_b1.asm.358778
0130                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 67CE C120  34         mov   @cmdb.visible,tmp0
     67D0 A302 
0009 67D2 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 67D4 04E0  34         clr   @cmdb.column          ; Column = 0
     67D6 A312 
0015 67D8 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     67DA 7A2C 
0016 67DC 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 67DE 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     67E0 7A7C 
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 67E2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67E4 763A 
0027               
0028               
0029               
**** **** ****     > stevie_b1.asm.358778
0131                       copy  "edkey.cmdb.file.asm"      ; File related actions
**** **** ****     > edkey.cmdb.file.asm
0001               * FILE......: edkey.cmdb.fíle.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load or save DV 80 file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.loadsave:
0008                       ;-------------------------------------------------------
0009                       ; Load or save file
0010                       ;-------------------------------------------------------
0011 67E6 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     67E8 7A7C 
0012               
0013 67EA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     67EC 6F10 
0014 67EE C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     67F0 2F30 
0015 67F2 1607  14         jne   !                     ; No, prepare for load/save
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 67F4 06A0  32         bl    @pane.errline.show    ; Show error line
     67F6 7BCA 
0020               
0021 67F8 06A0  32         bl    @pane.show_hint
     67FA 7812 
0022 67FC 1C00                   byte 28,0
0023 67FE 389A                   data txt.io.nofile
0024               
0025 6800 1019  14         jmp   edkey.action.cmdb.loadsave.exit
0026                       ;-------------------------------------------------------
0027                       ; Prepare for loading or saving file
0028                       ;-------------------------------------------------------
0029 6802 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0030 6804 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6806 A326 
0031               
0032 6808 06A0  32         bl    @cpym2m
     680A 24AE 
0033 680C A326                   data cmdb.cmdlen,heap.top,80
     680E E000 
     6810 0050 
0034                                                   ; Copy filename from command line to buffer
0035               
0036 6812 C120  34         mov   @cmdb.dialog,tmp0
     6814 A31A 
0037 6816 0284  22         ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
     6818 000A 
0038 681A 1303  14         jeq   edkey.action.cmdb.load.loadfile
0039               
0040 681C 0284  22         ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
     681E 000B 
0041 6820 1305  14         jeq   edkey.action.cmdb.load.savefile
0042                       ;-------------------------------------------------------
0043                       ; Load specified file
0044                       ;-------------------------------------------------------
0045               edkey.action.cmdb.load.loadfile:
0046 6822 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6824 E000 
0047 6826 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6828 72C6 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050 682A 1004  14         jmp   edkey.action.cmdb.loadsave.exit
0051                       ;-------------------------------------------------------
0052                       ; Save specified file
0053                       ;-------------------------------------------------------
0054               edkey.action.cmdb.load.savefile:
0055 682C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     682E E000 
0056 6830 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6832 737E 
0057                                                   ; \ i  tmp0 = Pointer to length-prefixed
0058                                                   ; /           device/filename string
0059                       ;-------------------------------------------------------
0060                       ; Exit
0061                       ;-------------------------------------------------------
0062               edkey.action.cmdb.loadsave.exit:
0063 6834 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6836 63C8 
**** **** ****     > stevie_b1.asm.358778
0132                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
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
0020 6838 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     683A A206 
0021 683C 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     683E 7844 
0022 6840 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6842 6EDE 
0023 6844 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6846 A324 
0024                       ;-------------------------------------------------------
0025                       ; Sanity checks
0026                       ;-------------------------------------------------------
0027 6848 0284  22         ci    tmp0,>2000
     684A 2000 
0028 684C 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 684E 0284  22         ci    tmp0,>7fff
     6850 7FFF 
0031 6852 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All sanity checks passed
0034                       ;------------------------------------------------------
0035 6854 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Sanity checks failed
0038                       ;------------------------------------------------------
0039 6856 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6858 FFCE 
0040 685A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     685C 2034 
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 685E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6860 763A 
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
0062               
0063               edkey.action.cmdb.fastmode.toggle:
0064 6862 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6864 734C 
0065 6866 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6868 A318 
0066 686A 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     686C 763A 
0067               
0068               
0069               
0070               
0071               ***************************************************************
0072               * dialog.close
0073               * Close dialog
0074               ***************************************************************
0075               * b   @edkey.action.cmdb.close.dialog
0076               *--------------------------------------------------------------
0077               * OUTPUT
0078               * none
0079               *--------------------------------------------------------------
0080               * Register usage
0081               * none
0082               ********|*****|*********************|**************************
0083               edkey.action.cmdb.close.dialog:
0084                       ;------------------------------------------------------
0085                       ; Close dialog
0086                       ;------------------------------------------------------
0087 686E 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6870 A31A 
0088 6872 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6874 7844 
0089 6876 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6878 7A7C 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.cmdb.close.dialog.exit:
0094 687A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     687C 763A 
**** **** ****     > stevie_b1.asm.358778
0133                       ;-----------------------------------------------------------------------
0134                       ; Logic for SAMS memory
0135                       ;-----------------------------------------------------------------------
0136                       copy  "mem.asm"             ; SAMS Memory Management
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
0017 687E 0649  14         dect  stack
0018 6880 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 6882 06A0  32         bl    @sams.layout
     6884 25B6 
0023 6886 32D2                   data mem.sams.layout.data
0024               
0025 6888 06A0  32         bl    @sams.layout.copy
     688A 261A 
0026 688C A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 688E C820  54         mov   @tv.sams.c000,@edb.sams.page
     6890 A008 
     6892 A216 
0029 6894 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     6896 A216 
     6898 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 689A C2F9  30         mov   *stack+,r11           ; Pop r11
0036 689C 045B  20         b     *r11                  ; Return to caller
0037               
0038               
0039               
0040               ***************************************************************
0041               * mem.edb.sams.mappage
0042               * Activate editor buffer SAMS page for line
0043               ***************************************************************
0044               * bl  @mem.edb.sams.mappage
0045               *     data p0
0046               *--------------------------------------------------------------
0047               * p0 = Line number in editor buffer
0048               *--------------------------------------------------------------
0049               * bl  @xmem.edb.sams.mappage
0050               *
0051               * tmp0 = Line number in editor buffer
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * outparm1 = Pointer to line in editor buffer
0055               * outparm2 = SAMS page
0056               *--------------------------------------------------------------
0057               * Register usage
0058               * tmp0, tmp1
0059               ***************************************************************
0060               mem.edb.sams.mappage:
0061 689E C13B  30         mov   *r11+,tmp0            ; Get p0
0062               xmem.edb.sams.mappage:
0063 68A0 0649  14         dect  stack
0064 68A2 C64B  30         mov   r11,*stack            ; Push return address
0065 68A4 0649  14         dect  stack
0066 68A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0067 68A8 0649  14         dect  stack
0068 68AA C645  30         mov   tmp1,*stack           ; Push tmp1
0069                       ;------------------------------------------------------
0070                       ; Sanity check
0071                       ;------------------------------------------------------
0072 68AC 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     68AE A204 
0073 68B0 1204  14         jle   mem.edb.sams.mappage.lookup
0074                                                   ; All checks passed, continue
0075                                                   ;--------------------------
0076                                                   ; Sanity check failed
0077                                                   ;--------------------------
0078 68B2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     68B4 FFCE 
0079 68B6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     68B8 2034 
0080                       ;------------------------------------------------------
0081                       ; Lookup SAMS page for line in parm1
0082                       ;------------------------------------------------------
0083               mem.edb.sams.mappage.lookup:
0084 68BA 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     68BC 6AA8 
0085                                                   ; \ i  parm1    = Line number
0086                                                   ; | o  outparm1 = Pointer to line
0087                                                   ; / o  outparm2 = SAMS page
0088               
0089 68BE C120  34         mov   @outparm2,tmp0        ; SAMS page
     68C0 2F32 
0090 68C2 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     68C4 2F30 
0091 68C6 130B  14         jeq   mem.edb.sams.mappage.exit
0092                                                   ; Nothing to page-in if NULL pointer
0093                                                   ; (=empty line)
0094                       ;------------------------------------------------------
0095                       ; Determine if requested SAMS page is already active
0096                       ;------------------------------------------------------
0097 68C8 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     68CA A008 
0098 68CC 1308  14         jeq   mem.edb.sams.mappage.exit
0099                                                   ; Request page already active. Exit.
0100                       ;------------------------------------------------------
0101                       ; Activate requested SAMS page
0102                       ;-----------------------------------------------------
0103 68CE 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     68D0 254A 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106               
0107 68D2 C820  54         mov   @outparm2,@tv.sams.c000
     68D4 2F32 
     68D6 A008 
0108                                                   ; Set page in shadow registers
0109               
0110 68D8 C820  54         mov   @outparm2,@edb.sams.page
     68DA 2F32 
     68DC A216 
0111                                                   ; Set current SAMS page
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 68DE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 68E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 68E2 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 68E4 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.358778
0137                       ;-----------------------------------------------------------------------
0138                       ; Logic for Framebuffer
0139                       ;-----------------------------------------------------------------------
0140                       copy  "fb.util.asm"         ; Framebuffer utilities
**** **** ****     > fb.util.asm
0001               * FILE......: fb.refresh.asm
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
0018               * tmp2,tmp3
0019               *--------------------------------------------------------------
0020               * Formula
0021               * outparm1 = @fb.topline + @parm1
0022               ********|*****|*********************|**************************
0023               fb.row2line:
0024 68E6 0649  14         dect  stack
0025 68E8 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Calculate line in editor buffer
0028                       ;------------------------------------------------------
0029 68EA C120  34         mov   @parm1,tmp0
     68EC 2F20 
0030 68EE A120  34         a     @fb.topline,tmp0
     68F0 A104 
0031 68F2 C804  38         mov   tmp0,@outparm1
     68F4 2F30 
0032                       ;------------------------------------------------------
0033                       ; Exit
0034                       ;------------------------------------------------------
0035               fb.row2line.exit:
0036 68F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0037 68F8 045B  20         b     *r11                  ; Return to caller
0038               
0039               
0040               
0041               
0042               ***************************************************************
0043               * fb.calc_pointer
0044               * Calculate pointer address in frame buffer
0045               ***************************************************************
0046               * bl @fb.calc_pointer
0047               *--------------------------------------------------------------
0048               * INPUT
0049               * @fb.top       = Address of top row in frame buffer
0050               * @fb.topline   = Top line in frame buffer
0051               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0052               * @fb.column    = Current column in frame buffer
0053               * @fb.colsline  = Columns per line in frame buffer
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * @fb.current   = Updated pointer
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * tmp0,tmp1
0060               *--------------------------------------------------------------
0061               * Formula
0062               * pointer = row * colsline + column + deref(@fb.top.ptr)
0063               ********|*****|*********************|**************************
0064               fb.calc_pointer:
0065 68FA 0649  14         dect  stack
0066 68FC C64B  30         mov   r11,*stack            ; Save return address
0067 68FE 0649  14         dect  stack
0068 6900 C644  30         mov   tmp0,*stack           ; Push tmp0
0069 6902 0649  14         dect  stack
0070 6904 C645  30         mov   tmp1,*stack           ; Push tmp1
0071                       ;------------------------------------------------------
0072                       ; Calculate pointer
0073                       ;------------------------------------------------------
0074 6906 C120  34         mov   @fb.row,tmp0
     6908 A106 
0075 690A 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     690C A10E 
0076 690E A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     6910 A10C 
0077 6912 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     6914 A100 
0078 6916 C805  38         mov   tmp1,@fb.current
     6918 A102 
0079                       ;------------------------------------------------------
0080                       ; Exit
0081                       ;------------------------------------------------------
0082               fb.calc_pointer.exit:
0083 691A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0084 691C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0085 691E C2F9  30         mov   *stack+,r11           ; Pop r11
0086 6920 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               
0091               
0092               
0093               
0094               ***************************************************************
0095               * fb.get.firstnonblank
0096               * Get column of first non-blank character in specified line
0097               ***************************************************************
0098               * bl @fb.get.firstnonblank
0099               *--------------------------------------------------------------
0100               * OUTPUT
0101               * @outparm1 = Column containing first non-blank character
0102               * @outparm2 = Character
0103               ********|*****|*********************|**************************
0104               fb.get.firstnonblank:
0105 6922 0649  14         dect  stack
0106 6924 C64B  30         mov   r11,*stack            ; Save return address
0107                       ;------------------------------------------------------
0108                       ; Prepare for scanning
0109                       ;------------------------------------------------------
0110 6926 04E0  34         clr   @fb.column
     6928 A10C 
0111 692A 06A0  32         bl    @fb.calc_pointer
     692C 68FA 
0112 692E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6930 6DDC 
0113 6932 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6934 A108 
0114 6936 1313  14         jeq   fb.get.firstnonblank.nomatch
0115                                                   ; Exit if empty line
0116 6938 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     693A A102 
0117 693C 04C5  14         clr   tmp1
0118                       ;------------------------------------------------------
0119                       ; Scan line for non-blank character
0120                       ;------------------------------------------------------
0121               fb.get.firstnonblank.loop:
0122 693E D174  28         movb  *tmp0+,tmp1           ; Get character
0123 6940 130E  14         jeq   fb.get.firstnonblank.nomatch
0124                                                   ; Exit if empty line
0125 6942 0285  22         ci    tmp1,>2000            ; Whitespace?
     6944 2000 
0126 6946 1503  14         jgt   fb.get.firstnonblank.match
0127 6948 0606  14         dec   tmp2                  ; Counter--
0128 694A 16F9  14         jne   fb.get.firstnonblank.loop
0129 694C 1008  14         jmp   fb.get.firstnonblank.nomatch
0130                       ;------------------------------------------------------
0131                       ; Non-blank character found
0132                       ;------------------------------------------------------
0133               fb.get.firstnonblank.match:
0134 694E 6120  34         s     @fb.current,tmp0      ; Calculate column
     6950 A102 
0135 6952 0604  14         dec   tmp0
0136 6954 C804  38         mov   tmp0,@outparm1        ; Save column
     6956 2F30 
0137 6958 D805  38         movb  tmp1,@outparm2        ; Save character
     695A 2F32 
0138 695C 1004  14         jmp   fb.get.firstnonblank.exit
0139                       ;------------------------------------------------------
0140                       ; No non-blank character found
0141                       ;------------------------------------------------------
0142               fb.get.firstnonblank.nomatch:
0143 695E 04E0  34         clr   @outparm1             ; X=0
     6960 2F30 
0144 6962 04E0  34         clr   @outparm2             ; Null
     6964 2F32 
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fb.get.firstnonblank.exit:
0149 6966 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6968 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0141                       copy  "fb.refresh.asm"      ; Framebuffer refresh
**** **** ****     > fb.refresh.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Stevie Editor - Framebuffer refresh
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
0020 696A 0649  14         dect  stack
0021 696C C64B  30         mov   r11,*stack            ; Push return address
0022 696E 0649  14         dect  stack
0023 6970 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6972 0649  14         dect  stack
0025 6974 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6976 0649  14         dect  stack
0027 6978 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 697A C820  54         mov   @parm1,@fb.topline
     697C 2F20 
     697E A104 
0032 6980 04E0  34         clr   @parm2                ; Target row in frame buffer
     6982 2F22 
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6984 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6986 2F20 
     6988 A204 
0037 698A 130A  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 698C 06A0  32         bl    @edb.line.unpack      ; Unpack line
     698E 6CEA 
0043                                                   ; \ i  parm1    = Line to unpack
0044                                                   ; | i  parm2    = Target row in frame buffer
0045                                                   ; / o  outparm1 = Length of line
0046               
0047 6990 05A0  34         inc   @parm1                ; Next line in editor buffer
     6992 2F20 
0048 6994 05A0  34         inc   @parm2                ; Next row in frame buffer
     6996 2F22 
0049                       ;------------------------------------------------------
0050                       ; Last row in editor buffer reached ?
0051                       ;------------------------------------------------------
0052 6998 8820  54         c     @parm1,@edb.lines
     699A 2F20 
     699C A204 
0053 699E 1212  14         jle   !                     ; no, do next check
0054                                                   ; yes, erase until end of frame buffer
0055                       ;------------------------------------------------------
0056                       ; Erase until end of frame buffer
0057                       ;------------------------------------------------------
0058               fb.refresh.erase_eob:
0059 69A0 C120  34         mov   @parm2,tmp0           ; Current row
     69A2 2F22 
0060 69A4 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     69A6 A118 
0061 69A8 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0062 69AA 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     69AC A10E 
0063               
0064 69AE C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0065 69B0 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0066               
0067 69B2 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     69B4 A10E 
0068 69B6 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     69B8 A100 
0069               
0070 69BA C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0071 69BC 04C5  14         clr   tmp1                  ; Clear with >00 character
0072               
0073 69BE 06A0  32         bl    @xfilm                ; \ Fill memory
     69C0 224C 
0074                                                   ; | i  tmp0 = Memory start address
0075                                                   ; | i  tmp1 = Byte to fill
0076                                                   ; / i  tmp2 = Number of bytes to fill
0077 69C2 1004  14         jmp   fb.refresh.exit
0078                       ;------------------------------------------------------
0079                       ; Bottom row in frame buffer reached ?
0080                       ;------------------------------------------------------
0081 69C4 8820  54 !       c     @parm2,@fb.scrrows
     69C6 2F22 
     69C8 A118 
0082 69CA 11E0  14         jlt   fb.refresh.unpack_line
0083                                                   ; No, unpack next line
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               fb.refresh.exit:
0088 69CC 0720  34         seto  @fb.dirty             ; Refresh screen
     69CE A116 
0089 69D0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 block (if present)
     69D2 A110 
0090 69D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0091 69D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0092 69D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0093 69DA C2F9  30         mov   *stack+,r11           ; Pop r11
0094 69DC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0142                       copy  "fb.colorlines.asm"   ; Framebuffer colorize lines
**** **** ****     > fb.colorlines.asm
0001               * FILE......: fb.colorlines.asm
0002               * Purpose...: Stevie Editor - Framebuffer refresh
0003               
0004               ***************************************************************
0005               * fb.colorlines
0006               * Colorize frame buffer content
0007               ***************************************************************
0008               * bl @fb.colorlines
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2,tmp3,tmp4
0018               ********|*****|*********************|**************************
0019               fb.colorlines:
0020 69DE 0649  14         dect  stack
0021 69E0 C64B  30         mov   r11,*stack            ; Save return address
0022 69E2 0649  14         dect  stack
0023 69E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 69E6 0649  14         dect  stack
0025 69E8 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 69EA 0649  14         dect  stack
0027 69EC C646  30         mov   tmp2,*stack           ; Push tmp2
0028 69EE 0649  14         dect  stack
0029 69F0 C647  30         mov   tmp3,*stack           ; Push tmp3
0030 69F2 0649  14         dect  stack
0031 69F4 C648  30         mov   tmp4,*stack           ; Push tmp4
0032                       ;------------------------------------------------------
0033                       ; Check if anything to do
0034                       ;------------------------------------------------------
0035 69F6 C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     69F8 A110 
0036 69FA 1324  14         jeq   fb.colorlines.exit    ; Exit if nothing to do.
0037               
0038 69FC C120  34         mov   @edb.block.m1,tmp0    ; M1 unset?
     69FE A20C 
0039 6A00 1321  14         jeq   fb.colorlines.exit    ; Yes, skip marking color
0040 6A02 C120  34         mov   @edb.block.m2,tmp0    ; M2 unset?
     6A04 A20E 
0041 6A06 131E  14         jeq   fb.colorlines.exit    ; Yes, skip marking color
0042                       ;------------------------------------------------------
0043                       ; Color the lines in the framebuffer (TAT)
0044                       ;------------------------------------------------------
0045 6A08 0204  20         li    tmp0,>1800            ; VDP start address
     6A0A 1800 
0046 6A0C C1E0  34         mov   @fb.scrrows.max,tmp3  ; Set loop counter
     6A0E A11A 
0047 6A10 C220  34         mov   @fb.topline,tmp4      ; Position in editor buffer
     6A12 A104 
0048 6A14 0588  14         inc   tmp4                  ; M1/M2 use base 1 offset
0049                       ;------------------------------------------------------
0050                       ; 1. Set color for each line in framebuffer
0051                       ;------------------------------------------------------
0052               fb.colorlines.loop:
0053 6A16 C1A0  34         mov   @edb.block.m1,tmp2
     6A18 A20C 
0054 6A1A 8206  18         c     tmp2,tmp4             ; M1 > current line
0055 6A1C 1507  14         jgt   fb.colorlines.normal  ; Yes, skip marking color
0056               
0057 6A1E C1A0  34         mov   @edb.block.m2,tmp2
     6A20 A20E 
0058 6A22 8206  18         c     tmp2,tmp4             ; M2 < current line
0059 6A24 1103  14         jlt   fb.colorlines.normal  ; Yes, skip marking color
0060                       ;------------------------------------------------------
0061                       ; 1a. Set marking color
0062                       ;------------------------------------------------------
0063 6A26 C160  34         mov   @tv.markcolor,tmp1
     6A28 A01A 
0064 6A2A 1003  14         jmp   fb.colorlines.fill
0065                       ;------------------------------------------------------
0066                       ; 1b. Set normal text color
0067                       ;------------------------------------------------------
0068               fb.colorlines.normal:
0069 6A2C C160  34         mov   @tv.color,tmp1
     6A2E A018 
0070 6A30 0985  56         srl   tmp1,8
0071                       ;------------------------------------------------------
0072                       ; 1c. Fill line with selected color
0073                       ;------------------------------------------------------
0074               fb.colorlines.fill:
0075 6A32 0206  20         li    tmp2,80               ; 80 characters to fill
     6A34 0050 
0076               
0077 6A36 06A0  32         bl    @xfilv                ; Fill VDP VRAM
     6A38 22A4 
0078                                                   ; \ i  tmp0 = VDP start address
0079                                                   ; | i  tmp1 = Byte to fill
0080                                                   ; / i  tmp2 = count
0081               
0082 6A3A 0224  22         ai    tmp0,80               ; Next line
     6A3C 0050 
0083 6A3E 0588  14         inc   tmp4
0084 6A40 0607  14         dec   tmp3                  ; Update loop counter
0085 6A42 15E9  14         jgt   fb.colorlines.loop    ; Back to (1)
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.colorlines.exit
0090 6A44 04E0  34         clr   @fb.colorize          ; Reset colorize flag
     6A46 A110 
0091 6A48 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0092 6A4A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0093 6A4C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0094 6A4E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0095 6A50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0096 6A52 C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6A54 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.358778
0143                       ;-----------------------------------------------------------------------
0144                       ; Logic for Index management
0145                       ;-----------------------------------------------------------------------
0146                       copy  "idx.update.asm"      ; Index management - Update entry
**** **** ****     > idx.update.asm
0001               * FILE......: idx.update.asm
0002               * Purpose...: Stevie Editor - Update index entry
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
0022 6A56 0649  14         dect  stack
0023 6A58 C64B  30         mov   r11,*stack            ; Save return address
0024 6A5A 0649  14         dect  stack
0025 6A5C C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6A5E 0649  14         dect  stack
0027 6A60 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 6A62 C120  34         mov   @parm1,tmp0           ; Get line number
     6A64 2F20 
0032 6A66 C160  34         mov   @parm2,tmp1           ; Get pointer
     6A68 2F22 
0033 6A6A 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 6A6C 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6A6E 0FFF 
0039 6A70 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 6A72 06E0  34         swpb  @parm3
     6A74 2F24 
0044 6A76 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6A78 2F24 
0045 6A7A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6A7C 2F24 
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 6A7E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A80 3100 
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 6A82 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6A84 2F30 
0056 6A86 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A88 B000 
0057 6A8A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A8C 2F30 
0058 6A8E 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 6A90 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A92 3100 
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 6A94 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6A96 2F30 
0068 6A98 04E4  34         clr   @idx.top(tmp0)        ; /
     6A9A B000 
0069 6A9C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A9E 2F30 
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 6AA0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 6AA2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 6AA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0077 6AA6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0147                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
**** **** ****     > idx.pointer.asm
0001               * FILE......: idx.pointer.asm
0002               * Purpose...: Stevie Editor - Get pointer to line in editor buffer
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
0021 6AA8 0649  14         dect  stack
0022 6AAA C64B  30         mov   r11,*stack            ; Save return address
0023 6AAC 0649  14         dect  stack
0024 6AAE C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6AB0 0649  14         dect  stack
0026 6AB2 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6AB4 0649  14         dect  stack
0028 6AB6 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 6AB8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6ABA 2F20 
0033               
0034 6ABC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6ABE 3100 
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 6AC0 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6AC2 2F30 
0039 6AC4 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6AC6 B000 
0040               
0041 6AC8 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 6ACA C185  18         mov   tmp1,tmp2             ; \
0047 6ACC 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 6ACE 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6AD0 00FF 
0052 6AD2 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 6AD4 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6AD6 C000 
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 6AD8 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6ADA 2F30 
0059 6ADC C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6ADE 2F32 
0060 6AE0 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 6AE2 04E0  34         clr   @outparm1
     6AE4 2F30 
0066 6AE6 04E0  34         clr   @outparm2
     6AE8 2F32 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 6AEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 6AEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 6AEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 6AF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 6AF2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0148                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Stevie Editor - Delete index slot
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
0017 6AF4 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6AF6 B000 
0018 6AF8 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 6AFA 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 6AFC CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 6AFE 0606  14         dec   tmp2                  ; tmp2--
0026 6B00 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 6B02 045B  20         b     *r11                  ; Return to caller
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
0046 6B04 0649  14         dect  stack
0047 6B06 C64B  30         mov   r11,*stack            ; Save return address
0048 6B08 0649  14         dect  stack
0049 6B0A C644  30         mov   tmp0,*stack           ; Push tmp0
0050 6B0C 0649  14         dect  stack
0051 6B0E C645  30         mov   tmp1,*stack           ; Push tmp1
0052 6B10 0649  14         dect  stack
0053 6B12 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 6B14 0649  14         dect  stack
0055 6B16 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6B18 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B1A 2F20 
0060               
0061 6B1C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B1E 3100 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6B20 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B22 2F30 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6B24 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B26 2F22 
0070 6B28 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 6B2A 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B2C 2F20 
0074 6B2E 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 6B30 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6B32 B000 
0081 6B34 04D4  26         clr   *tmp0                 ; Clear index entry
0082 6B36 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 6B38 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6B3A 2F22 
0088 6B3C 0287  22         ci    tmp3,2048
     6B3E 0800 
0089 6B40 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 6B42 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B44 307E 
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 6B46 C120  34         mov   @parm1,tmp0           ; Restore line number
     6B48 2F20 
0103 6B4A 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 6B4C 06A0  32         bl    @_idx.entry.delete.reorg
     6B4E 6AF4 
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 6B50 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B52 30C6 
0111                                                   ; Restore memory window layout
0112               
0113 6B54 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 6B56 06A0  32         bl    @_idx.entry.delete.reorg
     6B58 6AF4 
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 6B5A 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 6B5C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 6B5E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 6B60 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 6B62 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 6B64 C2F9  30         mov   *stack+,r11           ; Pop r11
0132 6B66 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0149                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Stevie Editor - Insert index slot
0003               
0004               ***************************************************************
0005               * _idx.entry.insert.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.insert.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_delete
0012               ********|*****|*********************|**************************
0013               _idx.entry.insert.reorg:
0014                       ;------------------------------------------------------
0015                       ; sanity check 1
0016                       ;------------------------------------------------------
0017 6B68 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6B6A 2800 
0018                                                   ; (max 5 SAMS pages with 2048 index entries)
0019               
0020 6B6C 1204  14         jle   !                     ; Continue if ok
0021                       ;------------------------------------------------------
0022                       ; Crash and burn
0023                       ;------------------------------------------------------
0024               _idx.entry.insert.reorg.crash:
0025 6B6E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B70 FFCE 
0026 6B72 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B74 2034 
0027                       ;------------------------------------------------------
0028                       ; Reorganize index entries
0029                       ;------------------------------------------------------
0030 6B76 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6B78 B000 
0031 6B7A C144  18         mov   tmp0,tmp1             ; a = current slot
0032 6B7C 05C5  14         inct  tmp1                  ; b = current slot + 2
0033 6B7E 0586  14         inc   tmp2                  ; One time adjustment for current line
0034                       ;------------------------------------------------------
0035                       ; Sanity check 2
0036                       ;------------------------------------------------------
0037 6B80 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0038 6B82 0A17  56         sla   tmp3,1                ; adjust to slot size
0039 6B84 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0040 6B86 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0041 6B88 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6B8A AFFE 
0042 6B8C 11F0  14         jlt   _idx.entry.insert.reorg.crash
0043                                                   ; If yes, crash
0044                       ;------------------------------------------------------
0045                       ; Loop backwards from end of index up to insert point
0046                       ;------------------------------------------------------
0047               _idx.entry.insert.reorg.loop:
0048 6B8E C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0049 6B90 0644  14         dect  tmp0                  ; Move pointer up
0050 6B92 0645  14         dect  tmp1                  ; Move pointer up
0051 6B94 0606  14         dec   tmp2                  ; Next index entry
0052 6B96 15FB  14         jgt   _idx.entry.insert.reorg.loop
0053                                                   ; Repeat until done
0054                       ;------------------------------------------------------
0055                       ; Clear index entry at insert point
0056                       ;------------------------------------------------------
0057 6B98 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0058 6B9A 04D4  26         clr   *tmp0                 ; / following insert point
0059               
0060 6B9C 045B  20         b     *r11                  ; Return to caller
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
0082 6B9E 0649  14         dect  stack
0083 6BA0 C64B  30         mov   r11,*stack            ; Save return address
0084 6BA2 0649  14         dect  stack
0085 6BA4 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6BA6 0649  14         dect  stack
0087 6BA8 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6BAA 0649  14         dect  stack
0089 6BAC C646  30         mov   tmp2,*stack           ; Push tmp2
0090 6BAE 0649  14         dect  stack
0091 6BB0 C647  30         mov   tmp3,*stack           ; Push tmp3
0092                       ;------------------------------------------------------
0093                       ; Prepare for index reorg
0094                       ;------------------------------------------------------
0095 6BB2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6BB4 2F22 
0096 6BB6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BB8 2F20 
0097 6BBA 130F  14         jeq   idx.entry.insert.reorg.simple
0098                                                   ; Special treatment if last line
0099                       ;------------------------------------------------------
0100                       ; Reorganize index entries
0101                       ;------------------------------------------------------
0102               idx.entry.insert.reorg:
0103 6BBC C1E0  34         mov   @parm2,tmp3
     6BBE 2F22 
0104 6BC0 0287  22         ci    tmp3,2048
     6BC2 0800 
0105 6BC4 120A  14         jle   idx.entry.insert.reorg.simple
0106                                                   ; Do simple reorg only if single
0107                                                   ; SAMS index page, otherwise complex reorg.
0108                       ;------------------------------------------------------
0109                       ; Complex index reorganization (multiple SAMS pages)
0110                       ;------------------------------------------------------
0111               idx.entry.insert.reorg.complex:
0112 6BC6 06A0  32         bl    @_idx.sams.mapcolumn.on
     6BC8 307E 
0113                                                   ; Index in continious memory region
0114                                                   ; b000 - ffff (5 SAMS pages)
0115               
0116 6BCA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6BCC 2F22 
0117 6BCE 0A14  56         sla   tmp0,1                ; tmp0 * 2
0118               
0119 6BD0 06A0  32         bl    @_idx.entry.insert.reorg
     6BD2 6B68 
0120                                                   ; Reorganize index
0121                                                   ; \ i  tmp0 = Last line in index
0122                                                   ; / i  tmp2 = Num. of index entries to move
0123               
0124 6BD4 06A0  32         bl    @_idx.sams.mapcolumn.off
     6BD6 30C6 
0125                                                   ; Restore memory window layout
0126               
0127 6BD8 1008  14         jmp   idx.entry.insert.exit
0128                       ;------------------------------------------------------
0129                       ; Simple index reorganization
0130                       ;------------------------------------------------------
0131               idx.entry.insert.reorg.simple:
0132 6BDA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6BDC 2F22 
0133               
0134 6BDE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BE0 3100 
0135                                                   ; \ i  tmp0     = Line number
0136                                                   ; / o  outparm1 = Slot offset in SAMS page
0137               
0138 6BE2 C120  34         mov   @outparm1,tmp0        ; Index offset
     6BE4 2F30 
0139               
0140 6BE6 06A0  32         bl    @_idx.entry.insert.reorg
     6BE8 6B68 
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.insert.exit:
0145 6BEA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6BEC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6BEE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6BF0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149 6BF2 C2F9  30         mov   *stack+,r11           ; Pop r11
0150 6BF4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0150                       ;-----------------------------------------------------------------------
0151                       ; Logic for Editor Buffer
0152                       ;-----------------------------------------------------------------------
0153                       copy  "edb.line.pack.asm"   ; Pack line into editor buffer
**** **** ****     > edb.line.pack.asm
0001               * FILE......: edb.line.pack.asm
0002               * Purpose...: Stevie Editor - Editor Buffer pack line
0003               
0004               ***************************************************************
0005               * edb.line.pack
0006               * Pack current line in framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.pack
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
0026               edb.line.pack:
0027 6BF6 0649  14         dect  stack
0028 6BF8 C64B  30         mov   r11,*stack            ; Save return address
0029 6BFA 0649  14         dect  stack
0030 6BFC C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6BFE 0649  14         dect  stack
0032 6C00 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6C02 0649  14         dect  stack
0034 6C04 C646  30         mov   tmp2,*stack           ; Push tmp2
0035                       ;------------------------------------------------------
0036                       ; Get values
0037                       ;------------------------------------------------------
0038 6C06 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6C08 A10C 
     6C0A 2F64 
0039 6C0C 04E0  34         clr   @fb.column
     6C0E A10C 
0040 6C10 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6C12 68FA 
0041                       ;------------------------------------------------------
0042                       ; Prepare scan
0043                       ;------------------------------------------------------
0044 6C14 04C4  14         clr   tmp0                  ; Counter
0045 6C16 C160  34         mov   @fb.current,tmp1      ; Get position
     6C18 A102 
0046 6C1A C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6C1C 2F66 
0047                       ;------------------------------------------------------
0048                       ; Scan line for >00 byte termination
0049                       ;------------------------------------------------------
0050               edb.line.pack.scan:
0051 6C1E D1B5  28         movb  *tmp1+,tmp2           ; Get char
0052 6C20 0986  56         srl   tmp2,8                ; Right justify
0053 6C22 1309  14         jeq   edb.line.pack.check_setpage
0054                                                   ; Stop scan if >00 found
0055 6C24 0584  14         inc   tmp0                  ; Increase string length
0056                       ;------------------------------------------------------
0057                       ; Not more than 80 characters
0058                       ;------------------------------------------------------
0059 6C26 0284  22         ci    tmp0,colrow
     6C28 0050 
0060 6C2A 1305  14         jeq   edb.line.pack.check_setpage
0061                                                   ; Stop scan if 80 characters processed
0062 6C2C 10F8  14         jmp   edb.line.pack.scan    ; Next character
0063                       ;------------------------------------------------------
0064                       ; Check failed, crash CPU!
0065                       ;------------------------------------------------------
0066               edb.line.pack.crash:
0067 6C2E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C30 FFCE 
0068 6C32 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C34 2034 
0069                       ;------------------------------------------------------
0070                       ; 1a: Check if highest SAMS page needs to be increased
0071                       ;------------------------------------------------------
0072               edb.line.pack.check_setpage:
0073 6C36 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6C38 2F68 
0074 6C3A C120  34         mov   @edb.next_free.ptr,tmp0
     6C3C A208 
0075                                                   ;--------------------------
0076                                                   ; Sanity check
0077                                                   ;--------------------------
0078 6C3E 0284  22         ci    tmp0,edb.top + edb.size
     6C40 D000 
0079                                                   ; Insane address ?
0080 6C42 15F5  14         jgt   edb.line.pack.crash   ; Yes, crash!
0081                                                   ;--------------------------
0082                                                   ; Check for page overflow
0083                                                   ;--------------------------
0084 6C44 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6C46 0FFF 
0085 6C48 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6C4A 0052 
0086 6C4C 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6C4E 0FF0 
0087 6C50 1105  14         jlt   edb.line.pack.setpage ; Not yet, don't increase SAMS page
0088                       ;------------------------------------------------------
0089                       ; 1b: Increase highest SAMS page (copy-on-write!)
0090                       ;------------------------------------------------------
0091 6C52 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6C54 A218 
0092 6C56 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6C58 A200 
     6C5A A208 
0093                                                   ; Start at top of SAMS page again
0094                       ;------------------------------------------------------
0095                       ; 1c: Switch to SAMS page
0096                       ;------------------------------------------------------
0097               edb.line.pack.setpage:
0098 6C5C C120  34         mov   @edb.sams.hipage,tmp0
     6C5E A218 
0099 6C60 C160  34         mov   @edb.top.ptr,tmp1
     6C62 A200 
0100 6C64 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6C66 254A 
0101                                                   ; \ i  tmp0 = SAMS page number
0102                                                   ; / i  tmp1 = Memory address
0103                       ;------------------------------------------------------
0104                       ; Step 2: Prepare for storing line
0105                       ;------------------------------------------------------
0106               edb.line.pack.prepare:
0107 6C68 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6C6A A104 
     6C6C 2F20 
0108 6C6E A820  54         a     @fb.row,@parm1        ; /
     6C70 A106 
     6C72 2F20 
0109                       ;------------------------------------------------------
0110                       ; 2a Update index
0111                       ;------------------------------------------------------
0112               edb.line.pack.update_index:
0113 6C74 C820  54         mov   @edb.next_free.ptr,@parm2
     6C76 A208 
     6C78 2F22 
0114                                                   ; Pointer to new line
0115 6C7A C820  54         mov   @edb.sams.hipage,@parm3
     6C7C A218 
     6C7E 2F24 
0116                                                   ; SAMS page to use
0117               
0118 6C80 06A0  32         bl    @idx.entry.update     ; Update index
     6C82 6A56 
0119                                                   ; \ i  parm1 = Line number in editor buffer
0120                                                   ; | i  parm2 = pointer to line in
0121                                                   ; |            editor buffer
0122                                                   ; / i  parm3 = SAMS page
0123                       ;------------------------------------------------------
0124                       ; 3. Set line prefix in editor buffer
0125                       ;------------------------------------------------------
0126 6C84 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6C86 2F66 
0127 6C88 C160  34         mov   @edb.next_free.ptr,tmp1
     6C8A A208 
0128                                                   ; Address of line in editor buffer
0129               
0130 6C8C 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C8E A208 
0131               
0132 6C90 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C92 2F68 
0133 6C94 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0134 6C96 1317  14         jeq   edb.line.pack.prepexit
0135                                                   ; Nothing to copy if empty line
0136                       ;------------------------------------------------------
0137                       ; 4. Copy line from framebuffer to editor buffer
0138                       ;------------------------------------------------------
0139               edb.line.pack.copyline:
0140 6C98 0286  22         ci    tmp2,2
     6C9A 0002 
0141 6C9C 1603  14         jne   edb.line.pack.copyline.checkbyte
0142 6C9E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0143 6CA0 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0144 6CA2 1007  14         jmp   edb.line.pack.copyline.align16
0145               
0146               edb.line.pack.copyline.checkbyte:
0147 6CA4 0286  22         ci    tmp2,1
     6CA6 0001 
0148 6CA8 1602  14         jne   edb.line.pack.copyline.block
0149 6CAA D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0150 6CAC 1002  14         jmp   edb.line.pack.copyline.align16
0151               
0152               edb.line.pack.copyline.block:
0153 6CAE 06A0  32         bl    @xpym2m               ; Copy memory block
     6CB0 24B4 
0154                                                   ; \ i  tmp0 = source
0155                                                   ; | i  tmp1 = destination
0156                                                   ; / i  tmp2 = bytes to copy
0157                       ;------------------------------------------------------
0158                       ; 5: Align pointer to multiple of 16 memory address
0159                       ;------------------------------------------------------
0160               edb.line.pack.copyline.align16:
0161 6CB2 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6CB4 2F68 
     6CB6 A208 
0162                                                      ; Add length of line
0163               
0164 6CB8 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6CBA A208 
0165 6CBC 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0166 6CBE 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6CC0 000F 
0167 6CC2 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6CC4 A208 
0168                       ;------------------------------------------------------
0169                       ; 6: Restore SAMS page and prepare for exit
0170                       ;------------------------------------------------------
0171               edb.line.pack.prepexit:
0172 6CC6 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6CC8 2F64 
     6CCA A10C 
0173               
0174 6CCC 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6CCE A218 
     6CD0 A216 
0175 6CD2 1306  14         jeq   edb.line.pack.exit    ; Exit early if SAMS page already mapped
0176               
0177 6CD4 C120  34         mov   @edb.sams.page,tmp0
     6CD6 A216 
0178 6CD8 C160  34         mov   @edb.top.ptr,tmp1
     6CDA A200 
0179 6CDC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6CDE 254A 
0180                                                   ; \ i  tmp0 = SAMS page number
0181                                                   ; / i  tmp1 = Memory address
0182                       ;------------------------------------------------------
0183                       ; Exit
0184                       ;------------------------------------------------------
0185               edb.line.pack.exit:
0186 6CE0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6CE2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6CE4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6CE6 C2F9  30         mov   *stack+,r11           ; Pop R11
0190 6CE8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0154                       copy  "edb.line.unpack.asm" ; Unpack line from editor buffer
**** **** ****     > edb.line.unpack.asm
0001               * FILE......: edb.line.unpack.asm
0002               * Purpose...: Stevie Editor - Editor Buffer unpack line
0003               
0004               ***************************************************************
0005               * edb.line.unpack
0006               * Unpack specified line to framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.unpack
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
0021               * rambuf    = Saved @parm1 of edb.line.unpack
0022               * rambuf+2  = Saved @parm2 of edb.line.unpack
0023               * rambuf+4  = Source memory address in editor buffer
0024               * rambuf+6  = Destination memory address in frame buffer
0025               * rambuf+8  = Length of line
0026               ********|*****|*********************|**************************
0027               edb.line.unpack:
0028 6CEA 0649  14         dect  stack
0029 6CEC C64B  30         mov   r11,*stack            ; Save return address
0030 6CEE 0649  14         dect  stack
0031 6CF0 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6CF2 0649  14         dect  stack
0033 6CF4 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6CF6 0649  14         dect  stack
0035 6CF8 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Sanity check
0038                       ;------------------------------------------------------
0039 6CFA 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6CFC 2F20 
     6CFE A204 
0040 6D00 1204  14         jle   !
0041 6D02 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D04 FFCE 
0042 6D06 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D08 2034 
0043                       ;------------------------------------------------------
0044                       ; Save parameters
0045                       ;------------------------------------------------------
0046 6D0A C820  54 !       mov   @parm1,@rambuf
     6D0C 2F20 
     6D0E 2F64 
0047 6D10 C820  54         mov   @parm2,@rambuf+2
     6D12 2F22 
     6D14 2F66 
0048                       ;------------------------------------------------------
0049                       ; Calculate offset in frame buffer
0050                       ;------------------------------------------------------
0051 6D16 C120  34         mov   @fb.colsline,tmp0
     6D18 A10E 
0052 6D1A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6D1C 2F22 
0053 6D1E C1A0  34         mov   @fb.top.ptr,tmp2
     6D20 A100 
0054 6D22 A146  18         a     tmp2,tmp1             ; Add base to offset
0055 6D24 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6D26 2F6A 
0056                       ;------------------------------------------------------
0057                       ; Get pointer to line & page-in editor buffer page
0058                       ;------------------------------------------------------
0059 6D28 C120  34         mov   @parm1,tmp0
     6D2A 2F20 
0060 6D2C 06A0  32         bl    @xmem.edb.sams.mappage
     6D2E 68A0 
0061                                                   ; Activate editor buffer SAMS page for line
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; | o  outparm1 = Pointer to line
0064                                                   ; / o  outparm2 = SAMS page
0065                       ;------------------------------------------------------
0066                       ; Handle empty line
0067                       ;------------------------------------------------------
0068 6D30 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6D32 2F30 
0069 6D34 1603  14         jne   edb.line.unpack.getlen
0070                                                   ; Continue if pointer is set
0071               
0072 6D36 04E0  34         clr   @rambuf+8             ; Set length=0
     6D38 2F6C 
0073 6D3A 100C  14         jmp   edb.line.unpack.clear
0074                       ;------------------------------------------------------
0075                       ; Get line length
0076                       ;------------------------------------------------------
0077               edb.line.unpack.getlen:
0078 6D3C C174  30         mov   *tmp0+,tmp1           ; Get line length
0079 6D3E C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6D40 2F68 
0080 6D42 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6D44 2F6C 
0081                       ;------------------------------------------------------
0082                       ; Sanity check on line length
0083                       ;------------------------------------------------------
0084 6D46 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6D48 0050 
0085 6D4A 1204  14         jle   edb.line.unpack.clear ; /
0086                       ;------------------------------------------------------
0087                       ; Crash the system
0088                       ;------------------------------------------------------
0089 6D4C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D4E FFCE 
0090 6D50 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D52 2034 
0091                       ;------------------------------------------------------
0092                       ; Erase chars from last column until column 80
0093                       ;------------------------------------------------------
0094               edb.line.unpack.clear:
0095 6D54 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6D56 2F6A 
0096 6D58 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6D5A 2F6C 
0097               
0098 6D5C 04C5  14         clr   tmp1                  ; Fill with >00
0099 6D5E C1A0  34         mov   @fb.colsline,tmp2
     6D60 A10E 
0100 6D62 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6D64 2F6C 
0101 6D66 0586  14         inc   tmp2
0102               
0103 6D68 06A0  32         bl    @xfilm                ; Fill CPU memory
     6D6A 224C 
0104                                                   ; \ i  tmp0 = Target address
0105                                                   ; | i  tmp1 = Byte to fill
0106                                                   ; / i  tmp2 = Repeat count
0107                       ;------------------------------------------------------
0108                       ; Prepare for unpacking data
0109                       ;------------------------------------------------------
0110               edb.line.unpack.prepare:
0111 6D6C C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6D6E 2F6C 
0112 6D70 130F  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0113 6D72 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6D74 2F68 
0114 6D76 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6D78 2F6A 
0115                       ;------------------------------------------------------
0116                       ; Sanity check on line length
0117                       ;------------------------------------------------------
0118               edb.line.unpack.copy:
0119 6D7A 0286  22         ci    tmp2,80               ; Check line length
     6D7C 0050 
0120 6D7E 1204  14         jle   !
0121                       ;------------------------------------------------------
0122                       ; Crash the system
0123                       ;------------------------------------------------------
0124 6D80 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D82 FFCE 
0125 6D84 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D86 2034 
0126                       ;------------------------------------------------------
0127                       ; Copy memory block
0128                       ;------------------------------------------------------
0129 6D88 C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6D8A 2F30 
0130               
0131 6D8C 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6D8E 24B4 
0132                                                   ; \ i  tmp0 = Source address
0133                                                   ; | i  tmp1 = Target address
0134                                                   ; / i  tmp2 = Bytes to copy
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138               edb.line.unpack.exit:
0139 6D90 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6D92 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6D94 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6D96 C2F9  30         mov   *stack+,r11           ; Pop r11
0143 6D98 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0155                       copy  "edb.line.getlen.asm" ; Get line length
**** **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Stevie Editor - Editor Buffer get line length
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
0021 6D9A 0649  14         dect  stack
0022 6D9C C64B  30         mov   r11,*stack            ; Push return address
0023 6D9E 0649  14         dect  stack
0024 6DA0 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6DA2 0649  14         dect  stack
0026 6DA4 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 6DA6 04E0  34         clr   @outparm1             ; Reset length
     6DA8 2F30 
0031 6DAA 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6DAC 2F32 
0032                       ;------------------------------------------------------
0033                       ; Map SAMS page
0034                       ;------------------------------------------------------
0035 6DAE C120  34         mov   @parm1,tmp0           ; Get line
     6DB0 2F20 
0036               
0037 6DB2 06A0  32         bl    @xmem.edb.sams.mappage
     6DB4 68A0 
0038                                                   ; Activate editor buffer SAMS page for line
0039                                                   ; \ i  tmp0     = Line number
0040                                                   ; | o  outparm1 = Pointer to line
0041                                                   ; / o  outparm2 = SAMS page
0042               
0043 6DB6 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6DB8 2F30 
0044 6DBA 130A  14         jeq   edb.line.getlength.null
0045                                                   ; Set length to 0 if null-pointer
0046                       ;------------------------------------------------------
0047                       ; Process line prefix
0048                       ;------------------------------------------------------
0049 6DBC C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0050 6DBE C805  38         mov   tmp1,@outparm1        ; Save length
     6DC0 2F30 
0051                       ;------------------------------------------------------
0052                       ; Sanity check
0053                       ;------------------------------------------------------
0054 6DC2 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6DC4 0050 
0055 6DC6 1206  14         jle   edb.line.getlength.exit
0056                                                   ; Yes, exit
0057                       ;------------------------------------------------------
0058                       ; Crash the system
0059                       ;------------------------------------------------------
0060 6DC8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DCA FFCE 
0061 6DCC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DCE 2034 
0062                       ;------------------------------------------------------
0063                       ; Set length to 0 if null-pointer
0064                       ;------------------------------------------------------
0065               edb.line.getlength.null:
0066 6DD0 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6DD2 2F30 
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               edb.line.getlength.exit:
0071 6DD4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0072 6DD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0073 6DD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0074 6DDA 045B  20         b     *r11                  ; Return to caller
0075               
0076               
0077               
0078               ***************************************************************
0079               * edb.line.getlength2
0080               * Get length of current row (as seen from editor buffer side)
0081               ***************************************************************
0082               *  bl   @edb.line.getlength2
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * @fb.row = Row in frame buffer
0086               *--------------------------------------------------------------
0087               * OUTPUT
0088               * @fb.row.length = Length of row
0089               *--------------------------------------------------------------
0090               * Register usage
0091               * tmp0
0092               ********|*****|*********************|**************************
0093               edb.line.getlength2:
0094 6DDC 0649  14         dect  stack
0095 6DDE C64B  30         mov   r11,*stack            ; Save return address
0096 6DE0 0649  14         dect  stack
0097 6DE2 C644  30         mov   tmp0,*stack           ; Push tmp0
0098                       ;------------------------------------------------------
0099                       ; Calculate line in editor buffer
0100                       ;------------------------------------------------------
0101 6DE4 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6DE6 A104 
0102 6DE8 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6DEA A106 
0103                       ;------------------------------------------------------
0104                       ; Get length
0105                       ;------------------------------------------------------
0106 6DEC C804  38         mov   tmp0,@parm1
     6DEE 2F20 
0107 6DF0 06A0  32         bl    @edb.line.getlength
     6DF2 6D9A 
0108 6DF4 C820  54         mov   @outparm1,@fb.row.length
     6DF6 2F30 
     6DF8 A108 
0109                                                   ; Save row length
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               edb.line.getlength2.exit:
0114 6DFA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0115 6DFC C2F9  30         mov   *stack+,r11           ; Pop R11
0116 6DFE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0156                       copy  "edb.block.asm"       ; Block move/copy/delete/save
**** **** ****     > edb.block.asm
0001               * FILE......: edb.line.mark.asm
0002               * Purpose...: Stevie Editor - Mark line for block operation
0003               
0004               ***************************************************************
0005               * edb.line.mark.m1
0006               * Mark M1 line for block operation
0007               ***************************************************************
0008               *  bl   @edb.line.mark.m1
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * NONE
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * NONE
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.line.mark.m1:
0020 6E00 0649  14         dect  stack
0021 6E02 C64B  30         mov   r11,*stack            ; Push return address
0022                       ;------------------------------------------------------
0023                       ; Initialisation
0024                       ;------------------------------------------------------
0025 6E04 C820  54         mov   @fb.row,@parm1
     6E06 A106 
     6E08 2F20 
0026 6E0A 06A0  32         bl    @fb.row2line          ; Row to editor line
     6E0C 68E6 
0027                                                   ; \ i @fb.topline = Top line in frame buffer
0028                                                   ; | i @parm1      = Row in frame buffer
0029                                                   ; / o @outparm1   = Matching line in EB
0030               
0031 6E0E 05A0  34         inc   @outparm1             ; Add base 1
     6E10 2F30 
0032               
0033 6E12 C820  54         mov   @outparm1,@edb.block.m1
     6E14 2F30 
     6E16 A20C 
0034                                                   ; Set block marker M1
0035 6E18 0720  34         seto  @fb.colorize          ; Set colorize flag
     6E1A A110 
0036 6E1C 0720  34         seto  @fb.dirty             ; Trigger refresh
     6E1E A116 
0037               
0038 6E20 C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     6E22 832A 
     6E24 A114 
0039               
0040 6E26 06A0  32         bl    @putat
     6E28 2452 
0041 6E2A 1D34                   byte pane.botrow,52
0042 6E2C 351A                   data txt.m1.set       ; Show M1 marker message
0043               
0044 6E2E C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     6E30 A114 
     6E32 832A 
0045                       ;-------------------------------------------------------
0046                       ; Setup one shot task for removing message
0047                       ;-------------------------------------------------------
0048 6E34 0204  20         li    tmp0,pane.clearmsg.task.callback
     6E36 7864 
0049 6E38 C804  38         mov   tmp0,@tv.task.oneshot
     6E3A A020 
0050               
0051 6E3C 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     6E3E 2E02 
0052 6E40 0003                   data 3                ; / for getting consistent delay
0053                       ;------------------------------------------------------
0054                       ; Exit
0055                       ;------------------------------------------------------
0056               edb.line.mark.m1.exit:
0057 6E42 C2F9  30         mov   *stack+,r11           ; Pop r11
0058 6E44 045B  20         b     *r11                  ; Return to caller
0059               
0060               
0061               ***************************************************************
0062               * edb.line.mark.m2
0063               * Mark M2 line for block operation
0064               ***************************************************************
0065               *  bl   @edb.line.mark.m2
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * NONE
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               * NONE
0072               *--------------------------------------------------------------
0073               * Register usage
0074               * tmp0,tmp1
0075               ********|*****|*********************|**************************
0076               edb.line.mark.m2:
0077 6E46 0649  14         dect  stack
0078 6E48 C64B  30         mov   r11,*stack            ; Push return address
0079                       ;------------------------------------------------------
0080                       ; Initialisation
0081                       ;------------------------------------------------------
0082 6E4A C820  54         mov   @fb.row,@parm1
     6E4C A106 
     6E4E 2F20 
0083 6E50 06A0  32         bl    @fb.row2line          ; Row to editor line
     6E52 68E6 
0084                                                   ; \ i @fb.topline = Top line in frame buffer
0085                                                   ; | i @parm1      = Row in frame buffer
0086                                                   ; / o @outparm1   = Matching line in EB
0087               
0088 6E54 05A0  34         inc   @outparm1             ; Add base 1
     6E56 2F30 
0089               
0090 6E58 C820  54         mov   @outparm1,@edb.block.m2
     6E5A 2F30 
     6E5C A20E 
0091                                                   ; Set block marker M2
0092               
0093 6E5E 0720  34         seto  @fb.colorize          ; Set colorize flag
     6E60 A110 
0094 6E62 0720  34         seto  @fb.dirty             ; Trigger refresh
     6E64 A116 
0095               
0096 6E66 C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     6E68 832A 
     6E6A A114 
0097               
0098 6E6C 06A0  32         bl    @putat
     6E6E 2452 
0099 6E70 1D34                   byte pane.botrow,52
0100 6E72 351E                   data txt.m2.set       ; Show M2 marker message
0101               
0102 6E74 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     6E76 A114 
     6E78 832A 
0103               
0104                       ;-------------------------------------------------------
0105                       ; Setup one shot task for removing message
0106                       ;-------------------------------------------------------
0107 6E7A 0204  20         li    tmp0,pane.clearmsg.task.callback
     6E7C 7864 
0108 6E7E C804  38         mov   tmp0,@tv.task.oneshot
     6E80 A020 
0109               
0110 6E82 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     6E84 2E02 
0111 6E86 0003                   data 3                ; / for getting consistent delay
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               edb.line.mark.m2.exit:
0116 6E88 C2F9  30         mov   *stack+,r11           ; Pop r11
0117 6E8A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0157                       ;-----------------------------------------------------------------------
0158                       ; Command buffer handling
0159                       ;-----------------------------------------------------------------------
0160                       copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
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
0022 6E8C 0649  14         dect  stack
0023 6E8E C64B  30         mov   r11,*stack            ; Save return address
0024 6E90 0649  14         dect  stack
0025 6E92 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6E94 0649  14         dect  stack
0027 6E96 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6E98 0649  14         dect  stack
0029 6E9A C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Dump Command buffer content
0032                       ;------------------------------------------------------
0033 6E9C C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6E9E 832A 
     6EA0 A30C 
0034 6EA2 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6EA4 A310 
     6EA6 832A 
0035               
0036 6EA8 05A0  34         inc   @wyx                  ; X +1 for prompt
     6EAA 832A 
0037               
0038 6EAC 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6EAE 240A 
0039                                                   ; \ i  @wyx = Cursor position
0040                                                   ; / o  tmp0 = VDP target address
0041               
0042 6EB0 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6EB2 A327 
0043 6EB4 0206  20         li    tmp2,1*79             ; Command length
     6EB6 004F 
0044               
0045 6EB8 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6EBA 2460 
0046                                                   ; | i  tmp0 = VDP target address
0047                                                   ; | i  tmp1 = RAM source address
0048                                                   ; / i  tmp2 = Number of bytes to copy
0049                       ;------------------------------------------------------
0050                       ; Show command buffer prompt
0051                       ;------------------------------------------------------
0052 6EBC C820  54         mov   @cmdb.yxprompt,@wyx
     6EBE A310 
     6EC0 832A 
0053 6EC2 06A0  32         bl    @putstr
     6EC4 242E 
0054 6EC6 38CC                   data txt.cmdb.prompt
0055               
0056 6EC8 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6ECA A30C 
     6ECC A114 
0057 6ECE C820  54         mov   @cmdb.yxsave,@wyx
     6ED0 A30C 
     6ED2 832A 
0058                                                   ; Restore YX position
0059                       ;------------------------------------------------------
0060                       ; Exit
0061                       ;------------------------------------------------------
0062               cmdb.refresh.exit:
0063 6ED4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6ED6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0065 6ED8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0066 6EDA C2F9  30         mov   *stack+,r11           ; Pop r11
0067 6EDC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0161                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0022 6EDE 0649  14         dect  stack
0023 6EE0 C64B  30         mov   r11,*stack            ; Save return address
0024 6EE2 0649  14         dect  stack
0025 6EE4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6EE6 0649  14         dect  stack
0027 6EE8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6EEA 0649  14         dect  stack
0029 6EEC C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Clear command
0032                       ;------------------------------------------------------
0033 6EEE 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6EF0 A326 
0034 6EF2 06A0  32         bl    @film                 ; Clear command
     6EF4 2246 
0035 6EF6 A327                   data  cmdb.cmd,>00,80
     6EF8 0000 
     6EFA 0050 
0036                       ;------------------------------------------------------
0037                       ; Put cursor at beginning of line
0038                       ;------------------------------------------------------
0039 6EFC C120  34         mov   @cmdb.yxprompt,tmp0
     6EFE A310 
0040 6F00 0584  14         inc   tmp0
0041 6F02 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6F04 A30A 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               cmdb.cmd.clear.exit:
0046 6F06 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0047 6F08 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0048 6F0A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0049 6F0C C2F9  30         mov   *stack+,r11           ; Pop r11
0050 6F0E 045B  20         b     *r11                  ; Return to caller
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
0075 6F10 0649  14         dect  stack
0076 6F12 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6F14 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6F16 2A9C 
0081 6F18 A327                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6F1A 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6F1C C820  54         mov   @waux1,@outparm1     ; Save length of string
     6F1E 833C 
     6F20 2F30 
0085                       ;------------------------------------------------------
0086                       ; Exit
0087                       ;------------------------------------------------------
0088               cmdb.cmd.getlength.exit:
0089 6F22 C2F9  30         mov   *stack+,r11           ; Pop r11
0090 6F24 045B  20         b     *r11                  ; Return to caller
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
0115 6F26 0649  14         dect  stack
0116 6F28 C64B  30         mov   r11,*stack            ; Save return address
0117 6F2A 0649  14         dect  stack
0118 6F2C C644  30         mov   tmp0,*stack           ; Push tmp0
0119               
0120 6F2E 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6F30 6F10 
0121                                                   ; \ i  @cmdb.cmd
0122                                                   ; / o  @outparm1
0123                       ;------------------------------------------------------
0124                       ; Sanity check
0125                       ;------------------------------------------------------
0126 6F32 C120  34         mov   @outparm1,tmp0        ; Check length
     6F34 2F30 
0127 6F36 1300  14         jeq   cmdb.cmd.history.add.exit
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
0139 6F38 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0140 6F3A C2F9  30         mov   *stack+,r11           ; Pop r11
0141 6F3C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0162                       ;-----------------------------------------------------------------------
0163                       ; File handling
0164                       ;-----------------------------------------------------------------------
0165                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
**** **** ****     > fh.read.edb.asm
0001               * FILE......: fh.read.edb.asm
0002               * Purpose...: File reader module
0003               
0004               ***************************************************************
0005               * fh.file.read.edb
0006               * Read file into editor buffer
0007               ***************************************************************
0008               *  bl   @fh.file.read.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Read line from file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0, tmp1, tmp2
0021               ********|*****|*********************|**************************
0022               fh.file.read.edb:
0023 6F3E 0649  14         dect  stack
0024 6F40 C64B  30         mov   r11,*stack            ; Save return address
0025 6F42 0649  14         dect  stack
0026 6F44 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6F46 0649  14         dect  stack
0028 6F48 C645  30         mov   tmp1,*stack           ; Push tmp1
0029 6F4A 0649  14         dect  stack
0030 6F4C C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 6F4E 04E0  34         clr   @fh.records           ; Reset records counter
     6F50 A43C 
0035 6F52 04E0  34         clr   @fh.counter           ; Clear internal counter
     6F54 A442 
0036 6F56 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6F58 A440 
0037 6F5A 04E0  34         clr   @fh.kilobytes.prev    ; /
     6F5C A458 
0038 6F5E 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6F60 A438 
0039 6F62 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6F64 A43A 
0040               
0041 6F66 C120  34         mov   @edb.top.ptr,tmp0
     6F68 A200 
0042 6F6A 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6F6C 2512 
0043                                                   ; \ i  tmp0  = Memory address
0044                                                   ; | o  waux1 = SAMS page number
0045                                                   ; / o  waux2 = Address of SAMS register
0046               
0047 6F6E C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6F70 833C 
     6F72 A446 
0048 6F74 C820  54         mov   @waux1,@fh.sams.hipage
     6F76 833C 
     6F78 A448 
0049                                                   ; Set highest SAMS page in use
0050                       ;------------------------------------------------------
0051                       ; Save parameters / callback functions
0052                       ;------------------------------------------------------
0053 6F7A 0204  20         li    tmp0,fh.fopmode.readfile
     6F7C 0001 
0054                                                   ; We are going to read a file
0055 6F7E C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     6F80 A44A 
0056               
0057 6F82 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6F84 2F20 
     6F86 A444 
0058 6F88 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6F8A 2F22 
     6F8C A450 
0059 6F8E C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6F90 2F24 
     6F92 A452 
0060 6F94 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6F96 2F26 
     6F98 A454 
0061 6F9A C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6F9C 2F28 
     6F9E A456 
0062                       ;------------------------------------------------------
0063                       ; Sanity checks
0064                       ;------------------------------------------------------
0065 6FA0 C120  34         mov   @fh.callback1,tmp0
     6FA2 A450 
0066 6FA4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FA6 6000 
0067 6FA8 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0068               
0069 6FAA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FAC 7FFF 
0070 6FAE 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0071               
0072 6FB0 C120  34         mov   @fh.callback2,tmp0
     6FB2 A452 
0073 6FB4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FB6 6000 
0074 6FB8 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0075               
0076 6FBA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FBC 7FFF 
0077 6FBE 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0078               
0079 6FC0 C120  34         mov   @fh.callback3,tmp0
     6FC2 A454 
0080 6FC4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FC6 6000 
0081 6FC8 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0082               
0083 6FCA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FCC 7FFF 
0084 6FCE 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0085               
0086 6FD0 1004  14         jmp   fh.file.read.edb.load1
0087                                                   ; All checks passed, continue
0088                       ;------------------------------------------------------
0089                       ; Check failed, crash CPU!
0090                       ;------------------------------------------------------
0091               fh.file.read.crash:
0092 6FD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FD4 FFCE 
0093 6FD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FD8 2034 
0094                       ;------------------------------------------------------
0095                       ; Callback "Before Open file"
0096                       ;------------------------------------------------------
0097               fh.file.read.edb.load1:
0098 6FDA C120  34         mov   @fh.callback1,tmp0
     6FDC A450 
0099 6FDE 0694  24         bl    *tmp0                 ; Run callback function
0100                       ;------------------------------------------------------
0101                       ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103               fh.file.read.edb.pabheader:
0104 6FE0 06A0  32         bl    @cpym2v
     6FE2 245A 
0105 6FE4 0A60                   data fh.vpab,fh.file.pab.header,9
     6FE6 7166 
     6FE8 0009 
0106                                                   ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108                       ; Append file descriptor to PAB header in VDP
0109                       ;------------------------------------------------------
0110 6FEA 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6FEC 0A69 
0111 6FEE C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6FF0 A444 
0112 6FF2 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0113 6FF4 0986  56         srl   tmp2,8                ; Right justify
0114 6FF6 0586  14         inc   tmp2                  ; Include length byte as well
0115               
0116 6FF8 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     6FFA 2460 
0117                                                   ; \ i  tmp0 = VDP destination
0118                                                   ; | i  tmp1 = CPU source
0119                                                   ; / i  tmp2 = Number of bytes to copy
0120                       ;------------------------------------------------------
0121                       ; Open file
0122                       ;------------------------------------------------------
0123 6FFC 06A0  32         bl    @file.open            ; Open file
     6FFE 2C60 
0124 7000 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0125 7002 0014                   data io.seq.inp.dis.var
0126                                                   ; / i  p1 = File type/mode
0127               
0128 7004 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7006 202A 
0129 7008 1602  14         jne   fh.file.read.edb.check_setpage
0130               
0131 700A 0460  28         b     @fh.file.read.edb.error
     700C 711A 
0132                                                   ; Yes, IO error occured
0133                       ;------------------------------------------------------
0134                       ; 1a: Check if SAMS page needs to be increased
0135                       ;------------------------------------------------------
0136               fh.file.read.edb.check_setpage:
0137 700E C120  34         mov   @edb.next_free.ptr,tmp0
     7010 A208 
0138                                                   ;--------------------------
0139                                                   ; Sanity check
0140                                                   ;--------------------------
0141 7012 0284  22         ci    tmp0,edb.top + edb.size
     7014 D000 
0142                                                   ; Insane address ?
0143 7016 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0144                                                   ;--------------------------
0145                                                   ; Check for page overflow
0146                                                   ;--------------------------
0147 7018 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     701A 0FFF 
0148 701C 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     701E 0052 
0149 7020 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     7022 0FF0 
0150 7024 110E  14         jlt   fh.file.read.edb.record
0151                                                   ; Not yet so skip SAMS page switch
0152                       ;------------------------------------------------------
0153                       ; 1b: Increase SAMS page
0154                       ;------------------------------------------------------
0155 7026 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     7028 A446 
0156 702A C820  54         mov   @fh.sams.page,@fh.sams.hipage
     702C A446 
     702E A448 
0157                                                   ; Set highest SAMS page
0158 7030 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     7032 A200 
     7034 A208 
0159                                                   ; Start at top of SAMS page again
0160                       ;------------------------------------------------------
0161                       ; 1c: Switch to SAMS page
0162                       ;------------------------------------------------------
0163 7036 C120  34         mov   @fh.sams.page,tmp0
     7038 A446 
0164 703A C160  34         mov   @edb.top.ptr,tmp1
     703C A200 
0165 703E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7040 254A 
0166                                                   ; \ i  tmp0 = SAMS page number
0167                                                   ; / i  tmp1 = Memory address
0168                       ;------------------------------------------------------
0169                       ; 1d: Fill new SAMS page with garbage (debug only)
0170                       ;------------------------------------------------------
0171                       ; bl  @film
0172                       ;     data >c000,>99,4092
0173                       ;------------------------------------------------------
0174                       ; Step 2: Read file record
0175                       ;------------------------------------------------------
0176               fh.file.read.edb.record:
0177 7042 05A0  34         inc   @fh.records           ; Update counter
     7044 A43C 
0178 7046 04E0  34         clr   @fh.reclen            ; Reset record length
     7048 A43E 
0179               
0180 704A 0760  38         abs   @fh.offsetopcode
     704C A44E 
0181 704E 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0182                       ;------------------------------------------------------
0183                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0184                       ;------------------------------------------------------
0185 7050 C160  34         mov   @edb.next_free.ptr,tmp1
     7052 A208 
0186 7054 05C5  14         inct  tmp1
0187 7056 0204  20         li    tmp0,fh.vpab + 2
     7058 0A62 
0188               
0189 705A 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     705C 4000 
0190 705E 06C4  14         swpb  tmp0                  ; \
0191 7060 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     7062 8C02 
0192 7064 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0193 7066 D804  38         movb  tmp0,@vdpa            ; /
     7068 8C02 
0194               
0195 706A D7C5  30         movb  tmp1,*r15             ; Write MSB
0196 706C 06C5  14         swpb  tmp1
0197 706E D7C5  30         movb  tmp1,*r15             ; Write LSB
0198                       ;------------------------------------------------------
0199                       ; 2b: Read file record
0200                       ;------------------------------------------------------
0201 7070 06A0  32 !       bl    @file.record.read     ; Read file record
     7072 2C90 
0202 7074 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0203                                                   ; |           (without +9 offset!)
0204                                                   ; | o  tmp0 = Status byte
0205                                                   ; | o  tmp1 = Bytes read
0206                                                   ; | o  tmp2 = Status register contents
0207                                                   ; /           upon DSRLNK return
0208               
0209 7076 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     7078 A438 
0210 707A C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     707C A43E 
0211 707E C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7080 A43A 
0212                       ;------------------------------------------------------
0213                       ; 2c: Calculate kilobytes processed
0214                       ;------------------------------------------------------
0215 7082 A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     7084 A442 
0216 7086 C160  34         mov   @fh.counter,tmp1      ;
     7088 A442 
0217 708A 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     708C 0400 
0218 708E 1106  14         jlt   fh.file.read.edb.check_fioerr
0219                                                   ; Not yet, goto (2d)
0220 7090 05A0  34         inc   @fh.kilobytes
     7092 A440 
0221 7094 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     7096 FC00 
0222 7098 C805  38         mov   tmp1,@fh.counter      ; Update counter
     709A A442 
0223                       ;------------------------------------------------------
0224                       ; 2d: Check if a file error occured
0225                       ;------------------------------------------------------
0226               fh.file.read.edb.check_fioerr:
0227 709C C1A0  34         mov   @fh.ioresult,tmp2
     709E A43A 
0228 70A0 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     70A2 202A 
0229 70A4 1602  14         jne   fh.file.read.edb.process_line
0230                                                   ; No, goto (3)
0231 70A6 0460  28         b     @fh.file.read.edb.error
     70A8 711A 
0232                                                   ; Yes, so handle file error
0233                       ;------------------------------------------------------
0234                       ; Step 3: Process line
0235                       ;------------------------------------------------------
0236               fh.file.read.edb.process_line:
0237 70AA 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     70AC 0960 
0238 70AE C160  34         mov   @edb.next_free.ptr,tmp1
     70B0 A208 
0239                                                   ; RAM target in editor buffer
0240               
0241 70B2 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     70B4 2F22 
0242               
0243 70B6 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     70B8 A43E 
0244 70BA 131D  14         jeq   fh.file.read.edb.prepindex.emptyline
0245                                                   ; Handle empty line
0246                       ;------------------------------------------------------
0247                       ; 3a: Set length of line in CPU editor buffer
0248                       ;------------------------------------------------------
0249 70BC 04D5  26         clr   *tmp1                 ; Clear word before string
0250 70BE 0585  14         inc   tmp1                  ; Adjust position for length byte string
0251 70C0 DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     70C2 A43F 
0252               
0253 70C4 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     70C6 A208 
0254 70C8 A806  38         a     tmp2,@edb.next_free.ptr
     70CA A208 
0255                                                   ; Add line length
0256               
0257 70CC 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     70CE A44E 
0258 70D0 1602  14         jne   fh.file.read.edb.preppointer
0259                       ;------------------------------------------------------
0260                       ; 3b: Copy line from VDP to CPU editor buffer
0261                       ;------------------------------------------------------
0262               fh.file.read.edb.vdp2cpu:
0263                       ;
0264                       ; Executed for devices that need their disk buffer in VDP memory
0265                       ; (TI Disk Controller, tipi, nanopeb, ...).
0266                       ;
0267 70D2 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     70D4 2492 
0268                                                   ; \ i  tmp0 = VDP source address
0269                                                   ; | i  tmp1 = RAM target address
0270                                                   ; / i  tmp2 = Bytes to copy
0271                       ;------------------------------------------------------
0272                       ; 3c: Align pointer for next line
0273                       ;------------------------------------------------------
0274               fh.file.read.edb.preppointer:
0275 70D6 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     70D8 A208 
0276 70DA 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0277 70DC 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     70DE 000F 
0278 70E0 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     70E2 A208 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Update index
0281                       ;------------------------------------------------------
0282               fh.file.read.edb.prepindex:
0283 70E4 C820  54         mov   @edb.lines,@parm1     ; \ parm1 = Line number - 1
     70E6 A204 
     70E8 2F20 
0284 70EA 0620  34         dec   @parm1                ; /
     70EC 2F20 
0285               
0286                                                   ; parm2 = Must allready be set!
0287 70EE C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     70F0 A446 
     70F2 2F24 
0288               
0289 70F4 1009  14         jmp   fh.file.read.edb.updindex
0290                                                   ; Update index
0291                       ;------------------------------------------------------
0292                       ; 4a: Special handling for empty line
0293                       ;------------------------------------------------------
0294               fh.file.read.edb.prepindex.emptyline:
0295 70F6 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     70F8 A43C 
     70FA 2F20 
0296 70FC 0620  34         dec   @parm1                ;         Adjust for base 0 index
     70FE 2F20 
0297 7100 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7102 2F22 
0298 7104 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7106 2F24 
0299                       ;------------------------------------------------------
0300                       ; 4b: Do actual index update
0301                       ;------------------------------------------------------
0302               fh.file.read.edb.updindex:
0303 7108 06A0  32         bl    @idx.entry.update     ; Update index
     710A 6A56 
0304                                                   ; \ i  parm1    = Line num in editor buffer
0305                                                   ; | i  parm2    = Pointer to line in editor
0306                                                   ; |               buffer
0307                                                   ; | i  parm3    = SAMS page
0308                                                   ; | o  outparm1 = Pointer to updated index
0309                                                   ; /               entry
0310               
0311 710C 05A0  34         inc   @edb.lines            ; lines=lines+1
     710E A204 
0312                       ;------------------------------------------------------
0313                       ; Step 5: Callback "Read line from file"
0314                       ;------------------------------------------------------
0315               fh.file.read.edb.display:
0316 7110 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     7112 A452 
0317 7114 0694  24         bl    *tmp0                 ; Run callback function
0318                       ;------------------------------------------------------
0319                       ; 5a: Next record
0320                       ;------------------------------------------------------
0321               fh.file.read.edb.next:
0322 7116 0460  28         b     @fh.file.read.edb.check_setpage
     7118 700E 
0323                                                   ; Next record
0324                       ;------------------------------------------------------
0325                       ; Error handler
0326                       ;------------------------------------------------------
0327               fh.file.read.edb.error:
0328 711A C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     711C A438 
0329 711E 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0330 7120 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7122 0005 
0331 7124 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0332                       ;------------------------------------------------------
0333                       ; File error occured
0334                       ;------------------------------------------------------
0335 7126 06A0  32         bl    @file.close           ; Close file
     7128 2C84 
0336 712A 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0337               
0338 712C 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     712E 687E 
0339                       ;------------------------------------------------------
0340                       ; Callback "File I/O error"
0341                       ;------------------------------------------------------
0342 7130 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     7132 A456 
0343 7134 0694  24         bl    *tmp0                 ; Run callback function
0344 7136 100D  14         jmp   fh.file.read.edb.exit
0345                       ;------------------------------------------------------
0346                       ; End-Of-File reached
0347                       ;------------------------------------------------------
0348               fh.file.read.edb.eof:
0349 7138 06A0  32         bl    @file.close           ; Close file
     713A 2C84 
0350 713C 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0351               
0352 713E 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7140 687E 
0353                       ;------------------------------------------------------
0354                       ; Callback "Close file"
0355                       ;------------------------------------------------------
0356 7142 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7144 A454 
0357 7146 0694  24         bl    *tmp0                 ; Run callback function
0358               
0359 7148 C120  34         mov   @edb.lines,tmp0       ; Get number of lines
     714A A204 
0360 714C 1302  14         jeq   fh.file.read.edb.exit ; Exit if lines = 0
0361 714E 0620  34         dec   @edb.lines            ; One-time adjustment
     7150 A204 
0362               *--------------------------------------------------------------
0363               * Exit
0364               *--------------------------------------------------------------
0365               fh.file.read.edb.exit:
0366 7152 C820  54         mov   @fh.sams.hipage,@edb.sams.hipage
     7154 A448 
     7156 A218 
0367                                                   ; Set highest SAMS page in use
0368 7158 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     715A A44A 
0369               
0370 715C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0371 715E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0372 7160 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0373 7162 C2F9  30         mov   *stack+,r11           ; Pop R11
0374 7164 045B  20         b     *r11                  ; Return to caller
0375               
0376               
0377               ***************************************************************
0378               * PAB for accessing DV/80 file
0379               ********|*****|*********************|**************************
0380               fh.file.pab.header:
0381 7166 0014             byte  io.op.open            ;  0    - OPEN
0382                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0383 7168 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0384 716A 5000             byte  80                    ;  4    - Record length (80 chars max)
0385                       byte  00                    ;  5    - Character count
0386 716C 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0387 716E 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0388                       ;------------------------------------------------------
0389                       ; File descriptor part (variable length)
0390                       ;------------------------------------------------------
0391                       ; byte  12                  ;  9    - File descriptor length
0392                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0393                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.358778
0166                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
**** **** ****     > fh.write.edb.asm
0001               * FILE......: fh.write.edb.asm
0002               * Purpose...: File write module
0003               
0004               ***************************************************************
0005               * fh.file.write.edb
0006               * Write editor buffer to file
0007               ***************************************************************
0008               *  bl   @fh.file.write.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Write line to file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0, tmp1, tmp2
0021               ********|*****|*********************|**************************
0022               fh.file.write.edb:
0023 7170 0649  14         dect  stack
0024 7172 C64B  30         mov   r11,*stack            ; Save return address
0025 7174 0649  14         dect  stack
0026 7176 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 7178 0649  14         dect  stack
0028 717A C645  30         mov   tmp1,*stack           ; Push tmp1
0029 717C 0649  14         dect  stack
0030 717E C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 7180 04E0  34         clr   @fh.records           ; Reset records counter
     7182 A43C 
0035 7184 04E0  34         clr   @fh.counter           ; Clear internal counter
     7186 A442 
0036 7188 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     718A A440 
0037 718C 04E0  34         clr   @fh.kilobytes.prev    ; /
     718E A458 
0038 7190 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     7192 A438 
0039 7194 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     7196 A43A 
0040                       ;------------------------------------------------------
0041                       ; Save parameters / callback functions
0042                       ;------------------------------------------------------
0043 7198 0204  20         li    tmp0,fh.fopmode.writefile
     719A 0002 
0044                                                   ; We are going to write to a file
0045 719C C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     719E A44A 
0046               
0047 71A0 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     71A2 2F20 
     71A4 A444 
0048 71A6 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     71A8 2F22 
     71AA A450 
0049 71AC C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     71AE 2F24 
     71B0 A452 
0050 71B2 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     71B4 2F26 
     71B6 A454 
0051 71B8 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     71BA 2F28 
     71BC A456 
0052                       ;------------------------------------------------------
0053                       ; Sanity check
0054                       ;------------------------------------------------------
0055 71BE C120  34         mov   @fh.callback1,tmp0
     71C0 A450 
0056 71C2 0284  22         ci    tmp0,>6000            ; Insane address ?
     71C4 6000 
0057 71C6 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0058               
0059 71C8 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71CA 7FFF 
0060 71CC 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0061               
0062 71CE C120  34         mov   @fh.callback2,tmp0
     71D0 A452 
0063 71D2 0284  22         ci    tmp0,>6000            ; Insane address ?
     71D4 6000 
0064 71D6 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0065               
0066 71D8 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71DA 7FFF 
0067 71DC 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0068               
0069 71DE C120  34         mov   @fh.callback3,tmp0
     71E0 A454 
0070 71E2 0284  22         ci    tmp0,>6000            ; Insane address ?
     71E4 6000 
0071 71E6 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0072               
0073 71E8 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71EA 7FFF 
0074 71EC 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0075               
0076 71EE 1004  14         jmp   fh.file.write.edb.save1
0077                                                   ; All checks passed, continue.
0078                       ;------------------------------------------------------
0079                       ; Check failed, crash CPU!
0080                       ;------------------------------------------------------
0081               fh.file.write.crash:
0082 71F0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     71F2 FFCE 
0083 71F4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     71F6 2034 
0084                       ;------------------------------------------------------
0085                       ; Callback "Before Open file"
0086                       ;------------------------------------------------------
0087               fh.file.write.edb.save1:
0088 71F8 C120  34         mov   @fh.callback1,tmp0
     71FA A450 
0089 71FC 0694  24         bl    *tmp0                 ; Run callback function
0090                       ;------------------------------------------------------
0091                       ; Copy PAB header to VDP
0092                       ;------------------------------------------------------
0093               fh.file.write.edb.pabheader:
0094 71FE 06A0  32         bl    @cpym2v
     7200 245A 
0095 7202 0A60                   data fh.vpab,fh.file.pab.header,9
     7204 7166 
     7206 0009 
0096                                                   ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098                       ; Append file descriptor to PAB header in VDP
0099                       ;------------------------------------------------------
0100 7208 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     720A 0A69 
0101 720C C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     720E A444 
0102 7210 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0103 7212 0986  56         srl   tmp2,8                ; Right justify
0104 7214 0586  14         inc   tmp2                  ; Include length byte as well
0105               
0106 7216 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     7218 2460 
0107                                                   ; \ i  tmp0 = VDP destination
0108                                                   ; | i  tmp1 = CPU source
0109                                                   ; / i  tmp2 = Number of bytes to copy
0110                       ;------------------------------------------------------
0111                       ; Open file
0112                       ;------------------------------------------------------
0113 721A 06A0  32         bl    @file.open            ; Open file
     721C 2C60 
0114 721E 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0115 7220 0012                   data io.seq.out.dis.var
0116                                                   ; / i  p1 = File type/mode
0117               
0118 7222 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7224 202A 
0119 7226 1338  14         jeq   fh.file.write.edb.error
0120                                                   ; Yes, IO error occured
0121                       ;------------------------------------------------------
0122                       ; Step 1: Write file record
0123                       ;------------------------------------------------------
0124               fh.file.write.edb.record:
0125 7228 8820  54         c     @fh.records,@edb.lines
     722A A43C 
     722C A204 
0126 722E 133E  14         jeq   fh.file.write.edb.done
0127                                                   ; Exit when all records processed
0128                       ;------------------------------------------------------
0129                       ; 1a: Unpack current line to framebuffer
0130                       ;------------------------------------------------------
0131 7230 C820  54         mov   @fh.records,@parm1    ; Line to unpack
     7232 A43C 
     7234 2F20 
0132 7236 04E0  34         clr   @parm2                ; 1st row in frame buffer
     7238 2F22 
0133               
0134 723A 06A0  32         bl    @edb.line.unpack      ; Unpack line
     723C 6CEA 
0135                                                   ; \ i  parm1    = Line to unpack
0136                                                   ; | i  parm2    = Target row in frame buffer
0137                                                   ; / o  outparm1 = Length of line
0138                       ;------------------------------------------------------
0139                       ; 1b: Copy unpacked line to VDP memory
0140                       ;------------------------------------------------------
0141 723E 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     7240 0960 
0142 7242 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     7244 A600 
0143               
0144 7246 C1A0  34         mov   @outparm1,tmp2        ; Length of line
     7248 2F30 
0145 724A C806  38         mov   tmp2,@fh.reclen       ; Set record length
     724C A43E 
0146 724E 1302  14         jeq   !                     ; Skip VDP copy if empty line
0147               
0148 7250 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     7252 2460 
0149                                                   ; \ i  tmp0 = VDP target address
0150                                                   ; | i  tmp1 = CPU source address
0151                                                   ; / i  tmp2 = Number of bytes to copy
0152                       ;------------------------------------------------------
0153                       ; 1c: Write file record
0154                       ;------------------------------------------------------
0155 7254 06A0  32 !       bl    @file.record.write    ; Write file record
     7256 2C9C 
0156 7258 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0157                                                   ; |           (without +9 offset!)
0158                                                   ; | o  tmp0 = Status byte
0159                                                   ; | o  tmp1 = ?????
0160                                                   ; | o  tmp2 = Status register contents
0161                                                   ; /           upon DSRLNK return
0162               
0163 725A C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     725C A438 
0164 725E C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7260 A43A 
0165                       ;------------------------------------------------------
0166                       ; 1d: Calculate kilobytes processed
0167                       ;------------------------------------------------------
0168 7262 A820  54         a     @fh.reclen,@fh.counter
     7264 A43E 
     7266 A442 
0169                                                   ; Add record length to counter
0170 7268 C160  34         mov   @fh.counter,tmp1      ;
     726A A442 
0171 726C 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     726E 0400 
0172 7270 1106  14         jlt   fh.file.write.edb.check_fioerr
0173                                                   ; Not yet, goto (1e)
0174 7272 05A0  34         inc   @fh.kilobytes
     7274 A440 
0175 7276 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     7278 FC00 
0176 727A C805  38         mov   tmp1,@fh.counter      ; Update counter
     727C A442 
0177                       ;------------------------------------------------------
0178                       ; 1e: Check if a file error occured
0179                       ;------------------------------------------------------
0180               fh.file.write.edb.check_fioerr:
0181 727E C1A0  34         mov   @fh.ioresult,tmp2
     7280 A43A 
0182 7282 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7284 202A 
0183 7286 1602  14         jne   fh.file.write.edb.display
0184                                                   ; No, goto (2)
0185 7288 0460  28         b     @fh.file.write.edb.error
     728A 7298 
0186                                                   ; Yes, so handle file error
0187                       ;------------------------------------------------------
0188                       ; Step 2: Callback "Write line to  file"
0189                       ;------------------------------------------------------
0190               fh.file.write.edb.display:
0191 728C C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     728E A452 
0192 7290 0694  24         bl    *tmp0                 ; Run callback function
0193                       ;------------------------------------------------------
0194                       ; Step 3: Next record
0195                       ;------------------------------------------------------
0196 7292 05A0  34         inc   @fh.records           ; Update counter
     7294 A43C 
0197 7296 10C8  14         jmp   fh.file.write.edb.record
0198                       ;------------------------------------------------------
0199                       ; Error handler
0200                       ;------------------------------------------------------
0201               fh.file.write.edb.error:
0202 7298 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     729A A438 
0203 729C 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0204                       ;------------------------------------------------------
0205                       ; File error occured
0206                       ;------------------------------------------------------
0207 729E 06A0  32         bl    @file.close           ; Close file
     72A0 2C84 
0208 72A2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0209                       ;------------------------------------------------------
0210                       ; Callback "File I/O error"
0211                       ;------------------------------------------------------
0212 72A4 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     72A6 A456 
0213 72A8 0694  24         bl    *tmp0                 ; Run callback function
0214 72AA 1006  14         jmp   fh.file.write.edb.exit
0215                       ;------------------------------------------------------
0216                       ; All records written. Close file
0217                       ;------------------------------------------------------
0218               fh.file.write.edb.done:
0219 72AC 06A0  32         bl    @file.close           ; Close file
     72AE 2C84 
0220 72B0 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0221                       ;------------------------------------------------------
0222                       ; Callback "Close file"
0223                       ;------------------------------------------------------
0224 72B2 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     72B4 A454 
0225 72B6 0694  24         bl    *tmp0                 ; Run callback function
0226               *--------------------------------------------------------------
0227               * Exit
0228               *--------------------------------------------------------------
0229               fh.file.write.edb.exit:
0230 72B8 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     72BA A44A 
0231 72BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0232 72BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0233 72C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0234 72C2 C2F9  30         mov   *stack+,r11           ; Pop R11
0235 72C4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0167                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
**** **** ****     > fm.load.asm
0001               * FILE......: fm.load.asm
0002               * Purpose...: File Manager - Load file into editor buffer
0003               
0004               ***************************************************************
0005               * fm.loadfile
0006               * Load file into editor buffer
0007               ***************************************************************
0008               * bl  @fm.loadfile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * tmp0  = Pointer to length-prefixed string containing both
0012               *         device and filename
0013               *---------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ********|*****|*********************|**************************
0020               fm.loadfile:
0021 72C6 0649  14         dect  stack
0022 72C8 C64B  30         mov   r11,*stack            ; Save return address
0023 72CA 0649  14         dect  stack
0024 72CC C644  30         mov   tmp0,*stack           ; Push tmp0
0025 72CE 0649  14         dect  stack
0026 72D0 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;-------------------------------------------------------
0028                       ; Show dialog "Unsaved changes" and exit if buffer dirty
0029                       ;-------------------------------------------------------
0030 72D2 C160  34         mov   @edb.dirty,tmp1
     72D4 A206 
0031 72D6 1305  14         jeq   !
0032 72D8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0033 72DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 72DC C2F9  30         mov   *stack+,r11           ; Pop R11
0035 72DE 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     72E0 7DF4 
0036                       ;-------------------------------------------------------
0037                       ; Reset editor
0038                       ;-------------------------------------------------------
0039 72E2 C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     72E4 2F20 
0040 72E6 06A0  32         bl    @tv.reset             ; Reset editor
     72E8 3210 
0041 72EA C820  54         mov   @parm1,@edb.filename.ptr
     72EC 2F20 
     72EE A212 
0042                                                   ; Set filename
0043                       ;-------------------------------------------------------
0044                       ; Clear VDP screen buffer
0045                       ;-------------------------------------------------------
0046 72F0 06A0  32         bl    @filv
     72F2 229E 
0047 72F4 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     72F6 0000 
     72F8 0004 
0048               
0049 72FA C160  34         mov   @fb.scrrows,tmp1
     72FC A118 
0050 72FE 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7300 A10E 
0051                                                   ; 16 bit part is in tmp2!
0052               
0053 7302 06A0  32         bl    @scroff               ; Turn off screen
     7304 2662 
0054               
0055 7306 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0056 7308 0205  20         li    tmp1,32               ; Character to fill
     730A 0020 
0057               
0058 730C 06A0  32         bl    @xfilv                ; Fill VDP memory
     730E 22A4 
0059                                                   ; \ i  tmp0 = VDP target address
0060                                                   ; | i  tmp1 = Byte to fill
0061                                                   ; / i  tmp2 = Bytes to copy
0062               
0063 7310 06A0  32         bl    @pane.action.colorscheme.Load
     7312 78E2 
0064                                                   ; Load color scheme and turn on screen
0065                       ;-------------------------------------------------------
0066                       ; Read DV80 file and display
0067                       ;-------------------------------------------------------
0068 7314 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7316 73D6 
0069 7318 C804  38         mov   tmp0,@parm2           ; Register callback 1
     731A 2F22 
0070               
0071 731C 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     731E 744E 
0072 7320 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7322 2F24 
0073               
0074 7324 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     7326 74C4 
0075 7328 C804  38         mov   tmp0,@parm4           ; Register callback 3
     732A 2F26 
0076               
0077 732C 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     732E 750A 
0078 7330 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7332 2F28 
0079               
0080 7334 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     7336 6F3E 
0081                                                   ; \ i  parm1 = Pointer to length prefixed
0082                                                   ; |            file descriptor
0083                                                   ; | i  parm2 = Pointer to callback
0084                                                   ; |            "loading indicator 1"
0085                                                   ; | i  parm3 = Pointer to callback
0086                                                   ; |            "loading indicator 2"
0087                                                   ; | i  parm4 = Pointer to callback
0088                                                   ; |            "loading indicator 3"
0089                                                   ; | i  parm5 = Pointer to callback
0090                                                   ; /            "File I/O error handler"
0091               
0092 7338 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     733A A206 
0093                                                   ; longer dirty.
0094               
0095 733C 0204  20         li    tmp0,txt.filetype.DV80
     733E 3504 
0096 7340 C804  38         mov   tmp0,@edb.filetype.ptr
     7342 A214 
0097                                                   ; Set filetype display string
0098               *--------------------------------------------------------------
0099               * Exit
0100               *--------------------------------------------------------------
0101               fm.loadfile.exit:
0102 7344 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0103 7346 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0104 7348 C2F9  30         mov   *stack+,r11           ; Pop R11
0105 734A 045B  20         b     *r11                  ; Return to caller
0106               
0107               
0108               ***************************************************************
0109               * fm.fastmode
0110               * Turn on fast mode for supported devices
0111               ***************************************************************
0112               * bl  @fm.fastmode
0113               *--------------------------------------------------------------
0114               * INPUT
0115               * none
0116               *---------------------------------------------------------------
0117               * OUTPUT
0118               * none
0119               *--------------------------------------------------------------
0120               * Register usage
0121               * tmp0, tmp1
0122               ********|*****|*********************|**************************
0123               fm.fastmode:
0124 734C 0649  14         dect  stack
0125 734E C64B  30         mov   r11,*stack            ; Save return address
0126 7350 0649  14         dect  stack
0127 7352 C644  30         mov   tmp0,*stack           ; Push tmp0
0128               
0129 7354 C120  34         mov   @fh.offsetopcode,tmp0
     7356 A44E 
0130 7358 1307  14         jeq   !
0131                       ;------------------------------------------------------
0132                       ; Turn fast mode off
0133                       ;------------------------------------------------------
0134 735A 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     735C A44E 
0135 735E 0204  20         li    tmp0,txt.keys.load
     7360 3586 
0136 7362 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7364 A322 
0137 7366 1008  14         jmp   fm.fastmode.exit
0138                       ;------------------------------------------------------
0139                       ; Turn fast mode on
0140                       ;------------------------------------------------------
0141 7368 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     736A 0040 
0142 736C C804  38         mov   tmp0,@fh.offsetopcode
     736E A44E 
0143 7370 0204  20         li    tmp0,txt.keys.load2
     7372 35BE 
0144 7374 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7376 A322 
0145               *--------------------------------------------------------------
0146               * Exit
0147               *--------------------------------------------------------------
0148               fm.fastmode.exit:
0149 7378 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0150 737A C2F9  30         mov   *stack+,r11           ; Pop R11
0151 737C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0168                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
**** **** ****     > fm.save.asm
0001               * FILE......: fm.save.asm
0002               * Purpose...: File Manager - Save file from editor buffer
0003               
0004               ***************************************************************
0005               * fm.savefile
0006               * Save file from editor buffer
0007               ***************************************************************
0008               * bl  @fm.savefile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * tmp0  = Pointer to length-prefixed string containing both
0012               *         device and filename
0013               *---------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ********|*****|*********************|**************************
0020               fm.savefile:
0021 737E 0649  14         dect  stack
0022 7380 C64B  30         mov   r11,*stack            ; Save return address
0023 7382 0649  14         dect  stack
0024 7384 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7386 0649  14         dect  stack
0026 7388 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;-------------------------------------------------------
0028                       ; Save DV80 file
0029                       ;-------------------------------------------------------
0030 738A C804  38         mov   tmp0,@parm1           ; Set device and filename
     738C 2F20 
0031               
0032 738E 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7390 73D6 
0033 7392 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7394 2F22 
0034               
0035 7396 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     7398 744E 
0036 739A C804  38         mov   tmp0,@parm3           ; Register callback 2
     739C 2F24 
0037               
0038 739E 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     73A0 74C4 
0039 73A2 C804  38         mov   tmp0,@parm4           ; Register callback 3
     73A4 2F26 
0040               
0041 73A6 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     73A8 750A 
0042 73AA C804  38         mov   tmp0,@parm5           ; Register callback 4
     73AC 2F28 
0043               
0044 73AE C820  54         mov   @parm1,@edb.filename.ptr
     73B0 2F20 
     73B2 A212 
0045                                                   ; Set current filename
0046               
0047 73B4 06A0  32         bl    @filv
     73B6 229E 
0048 73B8 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     73BA 0000 
     73BC 0004 
0049               
0050 73BE 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     73C0 7170 
0051                                                   ; \ i  parm1 = Pointer to length prefixed
0052                                                   ; |            file descriptor
0053                                                   ; | i  parm2 = Pointer to callback
0054                                                   ; |            "loading indicator 1"
0055                                                   ; | i  parm3 = Pointer to callback
0056                                                   ; |            "loading indicator 2"
0057                                                   ; | i  parm4 = Pointer to callback
0058                                                   ; |            "loading indicator 3"
0059                                                   ; | i  parm5 = Pointer to callback
0060                                                   ; /            "File I/O error handler"
0061               
0062 73C2 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     73C4 A206 
0063                                                   ; longer dirty.
0064               
0065 73C6 0204  20         li    tmp0,txt.filetype.DV80
     73C8 3504 
0066 73CA C804  38         mov   tmp0,@edb.filetype.ptr
     73CC A214 
0067                                                   ; Set filetype display string
0068               *--------------------------------------------------------------
0069               * Exit
0070               *--------------------------------------------------------------
0071               fm.savefile.exit:
0072 73CE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 73D0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 73D2 C2F9  30         mov   *stack+,r11           ; Pop R11
0075 73D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0169                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
**** **** ****     > fm.callbacks.asm
0001               * FILE......: fm.callbacks.asm
0002               * Purpose...: File Manager - Callbacks for file operations
0003               
0004               *---------------------------------------------------------------
0005               * Callback function "Show loading indicator 1"
0006               * Open file
0007               *---------------------------------------------------------------
0008               * Registered as pointer in @fh.callback1
0009               *---------------------------------------------------------------
0010               fm.loadsave.cb.indicator1:
0011 73D6 0649  14         dect  stack
0012 73D8 C64B  30         mov   r11,*stack            ; Save return address
0013 73DA 0649  14         dect  stack
0014 73DC C644  30         mov   tmp0,*stack           ; Push tmp0
0015 73DE 0649  14         dect  stack
0016 73E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0017 73E2 0649  14         dect  stack
0018 73E4 C660  46         mov   @parm1,*stack         ; Push @parm1
     73E6 2F20 
0019                       ;------------------------------------------------------
0020                       ; Check file operation mode
0021                       ;------------------------------------------------------
0022 73E8 06A0  32         bl    @hchar
     73EA 2796 
0023 73EC 1D00                   byte pane.botrow,0,32,80
     73EE 2050 
0024 73F0 FFFF                   data EOL              ; Clear until end of line
0025               
0026 73F2 C820  54         mov   @tv.busycolor,@parm1
     73F4 A01C 
     73F6 2F20 
0027 73F8 06A0  32         bl    @pane.action.colorcombo.botline
     73FA 79F4 
0028                                                   ; Load color combinaton for bottom line
0029                                                   ; \ i  @parm1 = Color combination
0030                                                   ; /
0031               
0032 73FC C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     73FE A44A 
0033               
0034 7400 0284  22         ci    tmp0,fh.fopmode.writefile
     7402 0002 
0035 7404 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0036                                                   ; Saving file?
0037               
0038 7406 0284  22         ci    tmp0,fh.fopmode.readfile
     7408 0001 
0039 740A 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0040                                                   ; Loading file?
0041                       ;------------------------------------------------------
0042                       ; Display Saving....
0043                       ;------------------------------------------------------
0044               fm.loadsave.cb.indicator1.saving:
0045 740C 06A0  32         bl    @putat
     740E 2452 
0046 7410 1D00                   byte pane.botrow,0
0047 7412 34D6                   data txt.saving       ; Display "Saving...."
0048 7414 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0049                       ;------------------------------------------------------
0050                       ; Display Loading....
0051                       ;------------------------------------------------------
0052               fm.loadsave.cb.indicator1.loading:
0053 7416 06A0  32         bl    @putat
     7418 2452 
0054 741A 1D00                   byte pane.botrow,0
0055 741C 34CA                   data txt.loading      ; Display "Loading...."
0056                       ;------------------------------------------------------
0057                       ; Display device/filename
0058                       ;------------------------------------------------------
0059               fm.loadsave.cb.indicator1.filename:
0060 741E 06A0  32         bl    @at
     7420 26A2 
0061 7422 1D0B                   byte pane.botrow,11   ; Cursor YX position
0062 7424 C160  34         mov   @edb.filename.ptr,tmp1
     7426 A212 
0063                                                   ; Get pointer to file descriptor
0064 7428 06A0  32         bl    @xutst0               ; Display device/filename
     742A 2430 
0065                       ;------------------------------------------------------
0066                       ; Display separators
0067                       ;------------------------------------------------------
0068 742C 06A0  32         bl    @putat
     742E 2452 
0069 7430 1D47                   byte pane.botrow,71
0070 7432 3526                   data txt.vertline     ; Vertical line
0071                       ;------------------------------------------------------
0072                       ; Display fast mode
0073                       ;------------------------------------------------------
0074 7434 0760  38         abs   @fh.offsetopcode
     7436 A44E 
0075 7438 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0076               
0077 743A 06A0  32         bl    @putat
     743C 2452 
0078 743E 1D26                   byte pane.botrow,38
0079 7440 34E0                   data txt.fastmode     ; Display "FastMode"
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               fm.loadsave.cb.indicator1.exit:
0084 7442 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7444 2F20 
0085 7446 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0086 7448 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 744A C2F9  30         mov   *stack+,r11           ; Pop R11
0088 744C 045B  20         b     *r11                  ; Return to caller
0089               
0090               
0091               
0092               
0093               *---------------------------------------------------------------
0094               * Callback function "Show loading indicator 2"
0095               * Read line from file / Write line to file
0096               *---------------------------------------------------------------
0097               * Registered as pointer in @fh.callback2
0098               *---------------------------------------------------------------
0099               fm.loadsave.cb.indicator2:
0100                       ;------------------------------------------------------
0101                       ; Check if first page processed (speedup impression)
0102                       ;------------------------------------------------------
0103 744E 8820  54         c     @fh.records,@fb.scrrows.max
     7450 A43C 
     7452 A11A 
0104 7454 161B  14         jne   fm.loadsave.cb.indicator2.kb
0105                                                   ; Skip framebuffer refresh
0106                       ;------------------------------------------------------
0107                       ; Refresh framebuffer if first page processed
0108                       ;------------------------------------------------------
0109 7456 0649  14         dect  stack
0110 7458 C64B  30         mov   r11,*stack            ; Save return address
0111 745A 0649  14         dect  stack
0112 745C C644  30         mov   tmp0,*stack           ; Push tmp0
0113 745E 0649  14         dect  stack
0114 7460 C645  30         mov   tmp1,*stack           ; Push tmp1
0115 7462 0649  14         dect  stack
0116 7464 C646  30         mov   tmp2,*stack           ; Push tmp2
0117               
0118 7466 04E0  34         clr   @parm1                ;
     7468 2F20 
0119 746A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     746C 696A 
0120                                                   ; \ i  @parm1 = Line to start with
0121                                                   ; /
0122               
0123                       ;------------------------------------------------------
0124                       ; Refresh VDP content with framebuffer
0125                       ;------------------------------------------------------
0126 746E C160  34         mov   @fb.scrrows.max,tmp1
     7470 A11A 
0127 7472 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7474 A10E 
0128                                                   ; 16 bit part is in tmp2!
0129 7476 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0130 7478 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     747A A100 
0131               
0132 747C 06A0  32         bl    @xpym2v               ; Copy to VDP
     747E 2460 
0133                                                   ; \ i  tmp0 = VDP target address
0134                                                   ; | i  tmp1 = RAM source address
0135                                                   ; / i  tmp2 = Bytes to copy
0136               
0137 7480 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7482 A116 
0138               
0139 7484 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 7486 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 7488 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 748A C2F9  30         mov   *stack+,r11           ; Pop R11
0143               
0144                       ;------------------------------------------------------
0145                       ; Check if updated counters should be displayed
0146                       ;------------------------------------------------------
0147               fm.loadsave.cb.indicator2.kb:
0148 748C 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     748E A440 
     7490 A458 
0149 7492 1601  14         jne   !
0150 7494 045B  20         b     *r11                  ; Exit early!
0151                       ;------------------------------------------------------
0152                       ; Display updated counters
0153                       ;------------------------------------------------------
0154 7496 0649  14 !       dect  stack
0155 7498 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 749A C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     749C A440 
     749E A458 
0158                                                   ; Save for compare
0159               
0160 74A0 06A0  32         bl    @putnum
     74A2 2A26 
0161 74A4 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0162 74A6 A440                   data fh.kilobytes,rambuf,>3020
     74A8 2F64 
     74AA 3020 
0163               
0164 74AC 06A0  32         bl    @putat
     74AE 2452 
0165 74B0 1D37                   byte pane.botrow,55
0166 74B2 34EA                   data txt.kb           ; Show "kb" string
0167               
0168 74B4 06A0  32         bl    @putnum
     74B6 2A26 
0169 74B8 1D49                   byte pane.botrow,73   ; Show lines processed
0170 74BA A43C                   data fh.records,rambuf,>3020
     74BC 2F64 
     74BE 3020 
0171                       ;------------------------------------------------------
0172                       ; Exit
0173                       ;------------------------------------------------------
0174               fm.loadsave.cb.indicator2.exit:
0175 74C0 C2F9  30         mov   *stack+,r11           ; Pop R11
0176 74C2 045B  20         b     *r11                  ; Return to caller
0177               
0178               
0179               
0180               
0181               *---------------------------------------------------------------
0182               * Callback function "Show loading indicator 3"
0183               * Close file
0184               *---------------------------------------------------------------
0185               * Registered as pointer in @fh.callback3
0186               *---------------------------------------------------------------
0187               fm.loadsave.cb.indicator3:
0188 74C4 0649  14         dect  stack
0189 74C6 C64B  30         mov   r11,*stack            ; Save return address
0190 74C8 0649  14         dect  stack
0191 74CA C660  46         mov   @parm1,*stack         ; Push @parm1
     74CC 2F20 
0192               
0193 74CE 06A0  32         bl    @hchar
     74D0 2796 
0194 74D2 1D00                   byte pane.botrow,0,32,50
     74D4 2032 
0195 74D6 FFFF                   data EOL              ; Erase loading indicator
0196               
0197 74D8 C820  54         mov   @tv.color,@parm1
     74DA A018 
     74DC 2F20 
0198 74DE 06A0  32         bl    @pane.action.colorcombo.botline
     74E0 79F4 
0199                                                   ; Load color combinaton for bottom line
0200                                                   ; \ i  @parm1 = Color combination
0201                                                   ; /
0202               
0203 74E2 06A0  32         bl    @putnum
     74E4 2A26 
0204 74E6 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0205 74E8 A440                   data fh.kilobytes,rambuf,>3020
     74EA 2F64 
     74EC 3020 
0206               
0207 74EE 06A0  32         bl    @putat
     74F0 2452 
0208 74F2 1D37                   byte pane.botrow,55
0209 74F4 34EA                   data txt.kb           ; Show "kb" string
0210               
0211 74F6 06A0  32         bl    @putnum
     74F8 2A26 
0212 74FA 1D49                   byte pane.botrow,73   ; Show lines processed
0213 74FC A43C                   data fh.records,rambuf,>3020
     74FE 2F64 
     7500 3020 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               fm.loadsave.cb.indicator3.exit:
0218 7502 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7504 2F20 
0219 7506 C2F9  30         mov   *stack+,r11           ; Pop R11
0220 7508 045B  20         b     *r11                  ; Return to caller
0221               
0222               
0223               
0224               *---------------------------------------------------------------
0225               * Callback function "File I/O error handler"
0226               * I/O error
0227               *---------------------------------------------------------------
0228               * Registered as pointer in @fh.callback4
0229               *---------------------------------------------------------------
0230               fm.loadsave.cb.fioerr:
0231 750A 0649  14         dect  stack
0232 750C C64B  30         mov   r11,*stack            ; Save return address
0233 750E 0649  14         dect  stack
0234 7510 C644  30         mov   tmp0,*stack           ; Push tmp0
0235 7512 0649  14         dect  stack
0236 7514 C660  46         mov   @parm1,*stack         ; Push @parm1
     7516 2F20 
0237                       ;------------------------------------------------------
0238                       ; Build I/O error message
0239                       ;------------------------------------------------------
0240 7518 06A0  32         bl    @hchar
     751A 2796 
0241 751C 1D00                   byte pane.botrow,0,32,50
     751E 2032 
0242 7520 FFFF                   data EOL              ; Erase loading indicator
0243               
0244 7522 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7524 A44A 
0245 7526 0284  22         ci    tmp0,fh.fopmode.writefile
     7528 0002 
0246 752A 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0247                       ;------------------------------------------------------
0248                       ; Failed loading file
0249                       ;------------------------------------------------------
0250               fm.loadsave.cb.fioerr.mgs1:
0251 752C 06A0  32         bl    @cpym2m
     752E 24AE 
0252 7530 3859                   data txt.ioerr.load+1
0253 7532 A027                   data tv.error.msg+1
0254 7534 0022                   data 34               ; Error message
0255 7536 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0256                       ;------------------------------------------------------
0257                       ; Failed saving file
0258                       ;------------------------------------------------------
0259               fm.loadsave.cb.fioerr.mgs2:
0260 7538 06A0  32         bl    @cpym2m
     753A 24AE 
0261 753C 387B                   data txt.ioerr.save+1
0262 753E A027                   data tv.error.msg+1
0263 7540 0022                   data 34               ; Error message
0264                       ;------------------------------------------------------
0265                       ; Add filename to error message
0266                       ;------------------------------------------------------
0267               fm.loadsave.cb.fioerr.mgs3:
0268 7542 C120  34         mov   @edb.filename.ptr,tmp0
     7544 A212 
0269 7546 D194  26         movb  *tmp0,tmp2            ; Get length byte
0270 7548 0986  56         srl   tmp2,8                ; Right align
0271 754A 0584  14         inc   tmp0                  ; Skip length byte
0272 754C 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     754E A047 
0273               
0274 7550 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     7552 24B4 
0275                                                   ; | i  tmp0 = ROM/RAM source
0276                                                   ; | i  tmp1 = RAM destination
0277                                                   ; / i  tmp2 = Bytes to copy
0278                       ;------------------------------------------------------
0279                       ; Reset filename to "new file"
0280                       ;------------------------------------------------------
0281 7554 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7556 A44A 
0282               
0283 7558 0284  22         ci    tmp0,fh.fopmode.readfile
     755A 0001 
0284 755C 1608  14         jne   !                     ; Only when reading file
0285               
0286 755E 0204  20         li    tmp0,txt.newfile      ; New file
     7560 34F8 
0287 7562 C804  38         mov   tmp0,@edb.filename.ptr
     7564 A212 
0288               
0289 7566 0204  20         li    tmp0,txt.filetype.none
     7568 350A 
0290 756A C804  38         mov   tmp0,@edb.filetype.ptr
     756C A214 
0291                                                   ; Empty filetype string
0292                       ;------------------------------------------------------
0293                       ; Display I/O error message
0294                       ;------------------------------------------------------
0295 756E 06A0  32 !       bl    @pane.errline.show    ; Show error line
     7570 7BCA 
0296               
0297 7572 C820  54         mov   @tv.color,@parm1      ; Restore "normal" color
     7574 A018 
     7576 2F20 
0298 7578 06A0  32         bl    @pane.action.colorcombo.botline
     757A 79F4 
0299                                                   ; Load color combinaton for bottom line
0300                                                   ; \ i  @parm1 = Color combination
0301                                                   ; /
0302                       ;------------------------------------------------------
0303                       ; Exit
0304                       ;------------------------------------------------------
0305               fm.loadsave.cb.fioerr.exit:
0306 757C C839  50         mov   *stack+,@parm1        ; Pop @parm1
     757E 2F20 
0307 7580 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0308 7582 C2F9  30         mov   *stack+,r11           ; Pop R11
0309 7584 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0170                       copy  "fm.browse.asm"       ; File manager browse support routines
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
0017 7586 0649  14         dect  stack
0018 7588 C64B  30         mov   r11,*stack            ; Save return address
0019 758A 0649  14         dect  stack
0020 758C C644  30         mov   tmp0,*stack           ; Push tmp0
0021 758E 0649  14         dect  stack
0022 7590 C645  30         mov   tmp1,*stack           ; Push tmp1
0023                       ;------------------------------------------------------
0024                       ; Sanity check
0025                       ;------------------------------------------------------
0026 7592 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     7594 2F20 
0027 7596 1334  14         jeq   fm.browse.fname.suffix.exit
0028                                                   ; Exit early if pointer is nill
0029               
0030 7598 0284  22         ci    tmp0,txt.newfile
     759A 34F8 
0031 759C 1331  14         jeq   fm.browse.fname.suffix.exit
0032                                                   ; Exit early if "New file"
0033                       ;------------------------------------------------------
0034                       ; Get last character in filename
0035                       ;------------------------------------------------------
0036 759E D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0037 75A0 0985  56         srl   tmp1,8                ; MSB to LSB
0038               
0039 75A2 A105  18         a     tmp1,tmp0             ; Move to last character
0040 75A4 04C5  14         clr   tmp1
0041 75A6 D154  26         movb  *tmp0,tmp1            ; Get character
0042 75A8 0985  56         srl   tmp1,8                ; MSB to LSB
0043 75AA 132A  14         jeq   fm.browse.fname.suffix.exit
0044                                                   ; Exit early if empty filename
0045                       ;------------------------------------------------------
0046                       ; Check mode (increase/decrease) character ASCII value
0047                       ;------------------------------------------------------
0048 75AC C1A0  34         mov   @parm2,tmp2           ; Get mode
     75AE 2F22 
0049 75B0 1314  14         jeq   fm.browse.fname.suffix.dec
0050                                                   ; Decrease ASCII if mode = 0
0051                       ;------------------------------------------------------
0052                       ; Increase ASCII value last character in filename
0053                       ;------------------------------------------------------
0054               fm.browse.fname.suffix.inc:
0055 75B2 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     75B4 0030 
0056 75B6 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0057 75B8 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     75BA 0039 
0058 75BC 1109  14         jlt   !                     ; Next character
0059 75BE 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0060                                                   ; Swith to alpha range A..Z
0061 75C0 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     75C2 005A 
0062 75C4 131D  14         jeq   fm.browse.fname.suffix.exit
0063                                                   ; Already last alpha character, so exit
0064 75C6 1104  14         jlt   !                     ; Next character
0065                       ;------------------------------------------------------
0066                       ; Invalid character, crash and burn
0067                       ;------------------------------------------------------
0068               fm.browse.fname.suffix.inc.crash:
0069 75C8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     75CA FFCE 
0070 75CC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     75CE 2034 
0071                       ;------------------------------------------------------
0072                       ; Increase ASCII value last character in filename
0073                       ;------------------------------------------------------
0074 75D0 0585  14 !       inc   tmp1                  ; Increase ASCII value
0075 75D2 1014  14         jmp   fm.browse.fname.suffix.store
0076               fm.browse.fname.suffix.inc.alpha:
0077 75D4 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     75D6 0041 
0078 75D8 1011  14         jmp   fm.browse.fname.suffix.store
0079                       ;------------------------------------------------------
0080                       ; Decrease ASCII value last character in filename
0081                       ;------------------------------------------------------
0082               fm.browse.fname.suffix.dec:
0083 75DA 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     75DC 0030 
0084 75DE 1310  14         jeq   fm.browse.fname.suffix.exit
0085                                                   ; Already first numeric character, so exit
0086 75E0 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     75E2 0039 
0087 75E4 1207  14         jle   !                     ; Previous character
0088 75E6 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     75E8 0041 
0089 75EA 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0090                                                   ; Switch to numeric range 0..9
0091 75EC 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0092                                                   ; Invalid character
0093 75EE 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     75F0 0084 
0094 75F2 1306  14         jeq   fm.browse.fname.suffix.exit
0095 75F4 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0096 75F6 1002  14         jmp   fm.browse.fname.suffix.store
0097               fm.browse.fname.suffix.dec.numeric:
0098 75F8 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     75FA 0039 
0099                       ;------------------------------------------------------
0100                       ; Store updatec character
0101                       ;------------------------------------------------------
0102               fm.browse.fname.suffix.store:
0103 75FC 0A85  56         sla   tmp1,8                ; LSB to MSB
0104 75FE D505  30         movb  tmp1,*tmp0            ; Store updated character
0105                       ;------------------------------------------------------
0106                       ; Exit
0107                       ;------------------------------------------------------
0108               fm.browse.fname.suffix.exit:
0109 7600 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0110 7602 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0111 7604 C2F9  30         mov   *stack+,r11           ; Pop R11
0112 7606 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0171                       ;-----------------------------------------------------------------------
0172                       ; User hook, background tasks
0173                       ;-----------------------------------------------------------------------
0174                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               ****************************************************************
0005               * Editor - spectra2 user hook
0006               ****************************************************************
0007               hook.keyscan:
0008 7608 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     760A 2018 
0009 760C 1612  14         jne   hook.keyscan.clear_kbbuffer
0010                                                   ; No, clear buffer and exit
0011 760E C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7610 833C 
     7612 2F40 
0012               *---------------------------------------------------------------
0013               * Identical key pressed ?
0014               *---------------------------------------------------------------
0015 7614 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7616 2018 
0016 7618 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     761A 2F40 
     761C 2F42 
0017 761E 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0018               *--------------------------------------------------------------
0019               * New key pressed
0020               *--------------------------------------------------------------
0021 7620 0204  20         li    tmp0,500              ; \
     7622 01F4 
0022 7624 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0023 7626 16FE  14         jne   -!                    ; /
0024 7628 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     762A 2F40 
     762C 2F42 
0025 762E 0460  28         b     @edkey.key.process    ; Process key
     7630 60E4 
0026               *--------------------------------------------------------------
0027               * Clear keyboard buffer if no key pressed
0028               *--------------------------------------------------------------
0029               hook.keyscan.clear_kbbuffer:
0030 7632 04E0  34         clr   @keycode1
     7634 2F40 
0031 7636 04E0  34         clr   @keycode2
     7638 2F42 
0032               *--------------------------------------------------------------
0033               * Delay to avoid key bouncing
0034               *--------------------------------------------------------------
0035               hook.keyscan.bounce:
0036 763A 0204  20         li    tmp0,2000             ; Avoid key bouncing
     763C 07D0 
0037                       ;------------------------------------------------------
0038                       ; Delay loop
0039                       ;------------------------------------------------------
0040               hook.keyscan.bounce.loop:
0041 763E 0604  14         dec   tmp0
0042 7640 16FE  14         jne   hook.keyscan.bounce.loop
0043 7642 0460  28         b     @hookok               ; Return
     7644 2D1C 
0044               
**** **** ****     > stevie_b1.asm.358778
0175                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 7646 0649  14         dect  stack
0009 7648 C64B  30         mov   r11,*stack            ; Save return address
0010 764A 0649  14         dect  stack
0011 764C C644  30         mov   tmp0,*stack           ; Push tmp0
0012 764E 0649  14         dect  stack
0013 7650 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 7652 0649  14         dect  stack
0015 7654 C646  30         mov   tmp2,*stack           ; Push tmp2
0016 7656 0649  14         dect  stack
0017 7658 C647  30         mov   tmp3,*stack           ; Push tmp3
0018               
0019 765A C820  54         mov   @wyx,@fb.yxsave       ; Backup cursor
     765C 832A 
     765E A114 
0020                       ;------------------------------------------------------
0021                       ; ALPHA-Lock key down?
0022                       ;------------------------------------------------------
0023               task.vdp.panes.alpha_lock:
0024 7660 20A0  38         coc   @wbit10,config
     7662 201A 
0025 7664 1305  14         jeq   task.vdp.panes.alpha_lock.down
0026                       ;------------------------------------------------------
0027                       ; AlPHA-Lock is up
0028                       ;------------------------------------------------------
0029 7666 06A0  32         bl    @putat
     7668 2452 
0030 766A 1D4F                   byte   pane.botrow,79
0031 766C 3522                   data   txt.alpha.up
0032 766E 1004  14         jmp   task.vdp.panes.cmdb.check
0033                       ;------------------------------------------------------
0034                       ; AlPHA-Lock is down
0035                       ;------------------------------------------------------
0036               task.vdp.panes.alpha_lock.down:
0037 7670 06A0  32         bl    @putat
     7672 2452 
0038 7674 1D4F                   byte   pane.botrow,79
0039 7676 3524                   data   txt.alpha.down
0040                       ;------------------------------------------------------
0041                       ; Command buffer visible ?
0042                       ;------------------------------------------------------
0043               task.vdp.panes.cmdb.check
0044 7678 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     767A A114 
     767C 832A 
0045 767E C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7680 A302 
0046 7682 1309  14         jeq   !                     ; No, skip CMDB pane
0047 7684 1000  14         jmp   task.vdp.panes.cmdb.draw
0048                       ;-------------------------------------------------------
0049                       ; Draw command buffer pane if dirty
0050                       ;-------------------------------------------------------
0051               task.vdp.panes.cmdb.draw:
0052 7686 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7688 A318 
0053 768A 134A  14         jeq   task.vdp.panes.exit   ; No, skip update
0054               
0055 768C 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     768E 7ABE 
0056 7690 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7692 A318 
0057 7694 1045  14         jmp   task.vdp.panes.exit   ; Exit early
0058                       ;-------------------------------------------------------
0059                       ; Check if frame buffer dirty
0060                       ;-------------------------------------------------------
0061 7696 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7698 A116 
0062 769A 1340  14         jeq   task.vdp.panes.botline.draw
0063                                                   ; No, skip update
0064               
0065 769C C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     769E 832A 
     76A0 A114 
0066                       ;------------------------------------------------------
0067                       ; Determine how many rows to copy
0068                       ;------------------------------------------------------
0069 76A2 8820  54         c     @edb.lines,@fb.scrrows
     76A4 A204 
     76A6 A118 
0070 76A8 1103  14         jlt   task.vdp.panes.setrows.small
0071 76AA C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     76AC A118 
0072 76AE 1003  14         jmp   task.vdp.panes.copy.framebuffer
0073                       ;------------------------------------------------------
0074                       ; Less lines in editor buffer as rows in frame buffer
0075                       ;------------------------------------------------------
0076               task.vdp.panes.setrows.small:
0077 76B0 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     76B2 A204 
0078 76B4 0585  14         inc   tmp1
0079                       ;------------------------------------------------------
0080                       ; Determine area to copy
0081                       ;------------------------------------------------------
0082               task.vdp.panes.copy.framebuffer:
0083 76B6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     76B8 A10E 
0084                                                   ; 16 bit part is in tmp2!
0085 76BA 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0086 76BC C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     76BE A100 
0087                       ;------------------------------------------------------
0088                       ; Copy memory block (SIT)
0089                       ;------------------------------------------------------
0090 76C0 0286  22         ci    tmp2,0                ; Something to copy?
     76C2 0000 
0091 76C4 1306  14         jeq   task.vdp.panes.copy.eof
0092                                                   ; No, skip copy
0093               
0094 76C6 06A0  32         bl    @xpym2v               ; Copy to VDP
     76C8 2460 
0095                                                   ; \ i  tmp0 = VDP target address
0096                                                   ; | i  tmp1 = RAM source address
0097                                                   ; / i  tmp2 = Bytes to copy
0098                       ;------------------------------------------------------
0099                       ; Color the lines in the framebuffer (TAT)
0100                       ;------------------------------------------------------
0101 76CA 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     76CC 69DE 
0102 76CE 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     76D0 A116 
0103                       ;-------------------------------------------------------
0104                       ; Draw EOF marker at end-of-file
0105                       ;-------------------------------------------------------
0106               task.vdp.panes.copy.eof:
0107 76D2 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     76D4 A116 
0108 76D6 C120  34         mov   @edb.lines,tmp0
     76D8 A204 
0109 76DA 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     76DC A104 
0110               
0111 76DE 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     76E0 A118 
0112 76E2 121C  14         jle   task.vdp.panes.botline.draw
0113                                                   ; Skip drawing EOF maker
0114                       ;-------------------------------------------------------
0115                       ; Do actual drawing of EOF marker
0116                       ;-------------------------------------------------------
0117               task.vdp.panes.draw_marker:
0118 76E4 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0119 76E6 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     76E8 832A 
0120               
0121 76EA 06A0  32         bl    @putstr
     76EC 242E 
0122 76EE 34B4                   data txt.marker       ; Display *EOF*
0123               
0124 76F0 06A0  32         bl    @setx
     76F2 26B8 
0125 76F4 0005                   data 5                ; Cursor after *EOF* string
0126                       ;-------------------------------------------------------
0127                       ; Clear rest of screen
0128                       ;-------------------------------------------------------
0129               task.vdp.panes.clear_screen:
0130 76F6 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     76F8 A10E 
0131               
0132 76FA C160  34         mov   @wyx,tmp1             ;
     76FC 832A 
0133 76FE 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0134 7700 0505  16         neg   tmp1                  ; tmp1 = -Y position
0135 7702 A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     7704 A118 
0136               
0137 7706 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0138 7708 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     770A FFFB 
0139               
0140 770C 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     770E 240A 
0141                                                   ; \ i  @wyx = Cursor position
0142                                                   ; / o  tmp0 = VDP address
0143               
0144 7710 04C5  14         clr   tmp1                  ; Character to write (null!)
0145 7712 06A0  32         bl    @xfilv                ; Fill VDP memory
     7714 22A4 
0146                                                   ; \ i  tmp0 = VDP destination
0147                                                   ; | i  tmp1 = byte to write
0148                                                   ; / i  tmp2 = Number of bytes to write
0149               
0150 7716 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7718 A114 
     771A 832A 
0151                       ;-------------------------------------------------------
0152                       ; Draw status line
0153                       ;-------------------------------------------------------
0154               task.vdp.panes.botline.draw:
0155 771C 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     771E 7C20 
0156                       ;------------------------------------------------------
0157                       ; Exit task
0158                       ;------------------------------------------------------
0159               task.vdp.panes.exit:
0160 7720 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0161 7722 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0162 7724 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0163 7726 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0164 7728 C2F9  30         mov   *stack+,r11           ; Pop r11
0165               
0166 772A 0460  28         b     @slotok
     772C 2D98 
**** **** ****     > stevie_b1.asm.358778
0176                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: Stevie Editor - VDP copy SAT
0003               
0004               ***************************************************************
0005               * Task - Copy Sprite Attribute Table (SAT) to VDP
0006               ********|*****|*********************|**************************
0007               task.vdp.copy.sat:
0008 772E C120  34         mov   @tv.pane.focus,tmp0
     7730 A01E 
0009 7732 130A  14         jeq   !                     ; Frame buffer has focus
0010               
0011 7734 0284  22         ci    tmp0,pane.focus.cmdb
     7736 0001 
0012 7738 1304  14         jeq   task.vdp.copy.sat.cmdb
0013                                                   ; Command buffer has focus
0014                       ;------------------------------------------------------
0015                       ; Assert failed. Invalid value
0016                       ;------------------------------------------------------
0017 773A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     773C FFCE 
0018 773E 06A0  32         bl    @cpu.crash            ; / Halt system.
     7740 2034 
0019                       ;------------------------------------------------------
0020                       ; Command buffer has focus, position cursor
0021                       ;------------------------------------------------------
0022               task.vdp.copy.sat.cmdb:
0023 7742 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7744 A30A 
     7746 832A 
0024                       ;------------------------------------------------------
0025                       ; Position cursor
0026                       ;------------------------------------------------------
0027 7748 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     774A 202E 
0028 774C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     774E 26C4 
0029                                                   ; | i  @WYX = Cursor YX
0030                                                   ; / o  tmp0 = Pixel YX
0031 7750 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7752 2F54 
0032               
0033 7754 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7756 245A 
0034 7758 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     775A 2F54 
     775C 0004 
0035                                                   ; | i  tmp1 = ROM/RAM source
0036                                                   ; / i  tmp2 = Number of bytes to write
0037                       ;------------------------------------------------------
0038                       ; Exit
0039                       ;------------------------------------------------------
0040               task.vdp.copy.sat.exit:
0041 775E 0460  28         b     @slotok               ; Exit task
     7760 2D98 
**** **** ****     > stevie_b1.asm.358778
0177                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: Stevie Editor - VDP sprite cursor
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ***************************************************************
0007               task.vdp.cursor:
0008 7762 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     7764 A112 
0009 7766 1303  14         jeq   task.vdp.cursor.visible
0010 7768 04E0  34         clr   @ramsat+2              ; Hide cursor
     776A 2F56 
0011 776C 1015  14         jmp   task.vdp.cursor.copy.sat
0012                                                    ; Update VDP SAT and exit task
0013               task.vdp.cursor.visible:
0014 776E C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7770 A20A 
0015 7772 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0016                       ;------------------------------------------------------
0017                       ; Cursor in insert mode
0018                       ;------------------------------------------------------
0019               task.vdp.cursor.visible.insert_mode:
0020 7774 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7776 A01E 
0021 7778 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0022                                                    ; Framebuffer has focus
0023 777A 0284  22         ci    tmp0,pane.focus.cmdb
     777C 0001 
0024 777E 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0025                       ;------------------------------------------------------
0026                       ; Editor cursor (insert mode)
0027                       ;------------------------------------------------------
0028               task.vdp.cursor.visible.insert_mode.fb:
0029 7780 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0030 7782 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0031                       ;------------------------------------------------------
0032                       ; Command buffer cursor (insert mode)
0033                       ;------------------------------------------------------
0034               task.vdp.cursor.visible.insert_mode.cmdb:
0035 7784 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7786 0100 
0036 7788 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0037                       ;------------------------------------------------------
0038                       ; Cursor in overwrite mode
0039                       ;------------------------------------------------------
0040               task.vdp.cursor.visible.overwrite_mode:
0041 778A 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     778C 0200 
0042                       ;------------------------------------------------------
0043                       ; Set cursor shape
0044                       ;------------------------------------------------------
0045               task.vdp.cursor.visible.cursorshape:
0046 778E D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7790 A014 
0047 7792 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     7794 A014 
     7796 2F56 
0048                       ;------------------------------------------------------
0049                       ; Copy SAT
0050                       ;------------------------------------------------------
0051               task.vdp.cursor.copy.sat:
0052 7798 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     779A 245A 
0053 779C 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     779E 2F54 
     77A0 0004 
0054                                                    ; | i  p1 = ROM/RAM source
0055                                                    ; / i  p2 = Number of bytes to write
0056                       ;-------------------------------------------------------
0057                       ; Show status bottom line
0058                       ;-------------------------------------------------------
0059 77A2 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     77A4 A302 
0060 77A6 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0061 77A8 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     77AA 7C20 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               task.vdp.cursor.exit:
0066 77AC 0460  28         b     @slotok                ; Exit task
     77AE 2D98 
**** **** ****     > stevie_b1.asm.358778
0178                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 77B0 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     77B2 A020 
0010 77B4 1301  14         jeq   task.oneshot.exit
0011               
0012 77B6 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 77B8 0460  28         b     @slotok                ; Exit task
     77BA 2D98 
**** **** ****     > stevie_b1.asm.358778
0179                       ;-----------------------------------------------------------------------
0180                       ; Screen pane utilities
0181                       ;-----------------------------------------------------------------------
0182                       copy  "pane.utils.asm"      ; Pane utility functions
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
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
0021 77BC 0649  14         dect  stack
0022 77BE C64B  30         mov   r11,*stack            ; Save return address
0023 77C0 0649  14         dect  stack
0024 77C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 77C4 0649  14         dect  stack
0026 77C6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 77C8 0649  14         dect  stack
0028 77CA C646  30         mov   tmp2,*stack           ; Push tmp2
0029 77CC 0649  14         dect  stack
0030 77CE C647  30         mov   tmp3,*stack           ; Push tmp3
0031                       ;-------------------------------------------------------
0032                       ; Display string
0033                       ;-------------------------------------------------------
0034 77D0 C820  54         mov   @parm1,@wyx           ; Set cursor
     77D2 2F20 
     77D4 832A 
0035 77D6 C160  34         mov   @parm2,tmp1           ; Get string to display
     77D8 2F22 
0036 77DA 06A0  32         bl    @xutst0               ; Display string
     77DC 2430 
0037                       ;-------------------------------------------------------
0038                       ; Get number of bytes to fill ...
0039                       ;-------------------------------------------------------
0040 77DE C120  34         mov   @parm2,tmp0
     77E0 2F22 
0041 77E2 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0042 77E4 0984  56         srl   tmp0,8                ; Right justify
0043 77E6 C184  18         mov   tmp0,tmp2
0044 77E8 C1C4  18         mov   tmp0,tmp3             ; Work copy
0045 77EA 0506  16         neg   tmp2
0046 77EC 0226  22         ai    tmp2,80               ; Number of bytes to fill
     77EE 0050 
0047                       ;-------------------------------------------------------
0048                       ; ... and clear until end of line
0049                       ;-------------------------------------------------------
0050 77F0 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     77F2 2F20 
0051 77F4 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0052 77F6 C804  38         mov   tmp0,@wyx             ; / Set cursor
     77F8 832A 
0053               
0054 77FA 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     77FC 240A 
0055                                                   ; \ i  @wyx = Cursor position
0056                                                   ; / o  tmp0 = VDP target address
0057               
0058 77FE 0205  20         li    tmp1,32               ; Byte to fill
     7800 0020 
0059               
0060 7802 06A0  32         bl    @xfilv                ; Clear line
     7804 22A4 
0061                                                   ; i \  tmp0 = start address
0062                                                   ; i |  tmp1 = byte to fill
0063                                                   ; i /  tmp2 = number of bytes to fill
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               pane.show_hintx.exit:
0068 7806 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0069 7808 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0070 780A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 780C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 780E C2F9  30         mov   *stack+,r11           ; Pop R11
0073 7810 045B  20         b     *r11                  ; Return to caller
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
0095 7812 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7814 2F20 
0096 7816 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7818 2F22 
0097 781A 0649  14         dect  stack
0098 781C C64B  30         mov   r11,*stack            ; Save return address
0099                       ;-------------------------------------------------------
0100                       ; Display pane hint
0101                       ;-------------------------------------------------------
0102 781E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7820 77BC 
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               pane.show_hint.exit:
0107 7822 C2F9  30         mov   *stack+,r11           ; Pop R11
0108 7824 045B  20         b     *r11                  ; Return to caller
0109               
0110               
0111               
0112               ***************************************************************
0113               * pane.cursor.hide
0114               * Hide cursor
0115               ***************************************************************
0116               * bl  @pane.cursor.hide
0117               *--------------------------------------------------------------
0118               * INPUT
0119               * none
0120               *--------------------------------------------------------------
0121               * OUTPUT
0122               * none
0123               *--------------------------------------------------------------
0124               * Register usage
0125               * none
0126               ********|*****|*********************|**************************
0127               pane.cursor.hide:
0128 7826 0649  14         dect  stack
0129 7828 C64B  30         mov   r11,*stack            ; Save return address
0130                       ;-------------------------------------------------------
0131                       ; Hide cursor
0132                       ;-------------------------------------------------------
0133 782A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     782C 229E 
0134 782E 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7830 0000 
     7832 0004 
0135                                                   ; | i  p1 = Byte to write
0136                                                   ; / i  p2 = Number of bytes to write
0137               
0138 7834 06A0  32         bl    @clslot
     7836 2DF4 
0139 7838 0001                   data 1                ; Terminate task.vdp.copy.sat
0140               
0141 783A 06A0  32         bl    @clslot
     783C 2DF4 
0142 783E 0002                   data 2                ; Terminate task.vdp.copy.sat
0143               
0144                       ;-------------------------------------------------------
0145                       ; Exit
0146                       ;-------------------------------------------------------
0147               pane.cursor.hide.exit:
0148 7840 C2F9  30         mov   *stack+,r11           ; Pop R11
0149 7842 045B  20         b     *r11                  ; Return to caller
0150               
0151               
0152               
0153               ***************************************************************
0154               * pane.cursor.blink
0155               * Blink cursor
0156               ***************************************************************
0157               * bl  @pane.cursor.blink
0158               *--------------------------------------------------------------
0159               * INPUT
0160               * none
0161               *--------------------------------------------------------------
0162               * OUTPUT
0163               * none
0164               *--------------------------------------------------------------
0165               * Register usage
0166               * none
0167               ********|*****|*********************|**************************
0168               pane.cursor.blink:
0169 7844 0649  14         dect  stack
0170 7846 C64B  30         mov   r11,*stack            ; Save return address
0171                       ;-------------------------------------------------------
0172                       ; Hide cursor
0173                       ;-------------------------------------------------------
0174 7848 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     784A 229E 
0175 784C 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     784E 0000 
     7850 0004 
0176                                                   ; | i  p1 = Byte to write
0177                                                   ; / i  p2 = Number of bytes to write
0178               
0179 7852 06A0  32         bl    @mkslot
     7854 2DD6 
0180 7856 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     7858 772E 
0181 785A 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     785C 7762 
0182 785E FFFF                   data eol
0183                       ;-------------------------------------------------------
0184                       ; Exit
0185                       ;-------------------------------------------------------
0186               pane.cursor.blink.exit:
0187 7860 C2F9  30         mov   *stack+,r11           ; Pop R11
0188 7862 045B  20         b     *r11                  ; Return to caller
0189               
0190               
0191               
0192               
0193               ***************************************************************
0194               * pane.clearmsg.task.callback
0195               * Remove message
0196               ***************************************************************
0197               * Called from one-shot task
0198               *--------------------------------------------------------------
0199               * INPUT
0200               * none
0201               *--------------------------------------------------------------
0202               * OUTPUT
0203               * none
0204               *--------------------------------------------------------------
0205               * Register usage
0206               * none
0207               ********|*****|*********************|**************************
0208               pane.clearmsg.task.callback:
0209 7864 0649  14         dect  stack
0210 7866 C64B  30         mov   r11,*stack            ; Push return address
0211               
0212 7868 C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     786A 832A 
     786C A114 
0213               
0214 786E 06A0  32         bl    @putat
     7870 2452 
0215 7872 1D33                   byte pane.botrow,51
0216 7874 3510                   data txt.clear        ; Clear temporary message
0217               
0218 7876 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     7878 A114 
     787A 832A 
0219               
0220 787C 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     787E A020 
0221                       ;-------------------------------------------------------
0222                       ; Exit
0223                       ;-------------------------------------------------------
0224               pane.clearmsg.task.callback.exit:
0225 7880 C2F9  30         mov   *stack+,r11           ; Pop R11
0226 7882 045B  20         b     *r11                  ; Return to task
**** **** ****     > stevie_b1.asm.358778
0183                       copy  "pane.utils.colorscheme.asm"
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
0017 7884 0649  14         dect  stack
0018 7886 C64B  30         mov   r11,*stack            ; Push return address
0019 7888 0649  14         dect  stack
0020 788A C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 788C C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     788E A012 
0023 7890 0284  22         ci    tmp0,tv.colorscheme.entries
     7892 0009 
0024                                                   ; Last entry reached?
0025 7894 1103  14         jlt   !
0026 7896 0204  20         li    tmp0,1                ; Reset color scheme index
     7898 0001 
0027 789A 1001  14         jmp   pane.action.colorscheme.switch
0028 789C 0584  14 !       inc   tmp0
0029                       ;-------------------------------------------------------
0030                       ; Switch to new color scheme
0031                       ;-------------------------------------------------------
0032               pane.action.colorscheme.switch:
0033 789E C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     78A0 A012 
0034               
0035 78A2 06A0  32         bl    @pane.action.colorscheme.load
     78A4 78E2 
0036                                                   ; Load current color scheme
0037                       ;-------------------------------------------------------
0038                       ; Show current color palette message
0039                       ;-------------------------------------------------------
0040 78A6 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     78A8 832A 
     78AA 833C 
0041               
0042 78AC 06A0  32         bl    @putnum
     78AE 2A26 
0043 78B0 1D36                   byte pane.botrow,54
0044 78B2 A012                   data tv.colorscheme,rambuf,>3020
     78B4 2F64 
     78B6 3020 
0045               
0046 78B8 06A0  32         bl    @putat
     78BA 2452 
0047 78BC 1D34                   byte pane.botrow,52
0048 78BE 38DE                   data txt.colorscheme  ; Show color palette message
0049               
0050 78C0 C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     78C2 833C 
     78C4 832A 
0051                       ;-------------------------------------------------------
0052                       ; Delay
0053                       ;-------------------------------------------------------
0054 78C6 0204  20         li    tmp0,12000
     78C8 2EE0 
0055 78CA 0604  14 !       dec   tmp0
0056 78CC 16FE  14         jne   -!
0057                       ;-------------------------------------------------------
0058                       ; Setup one shot task for removing message
0059                       ;-------------------------------------------------------
0060 78CE 0204  20         li    tmp0,pane.clearmsg.task.callback
     78D0 7864 
0061 78D2 C804  38         mov   tmp0,@tv.task.oneshot
     78D4 A020 
0062               
0063 78D6 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     78D8 2E02 
0064 78DA 0003                   data 3                ; / for getting consistent delay
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               pane.action.colorscheme.cycle.exit:
0069 78DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 78DE C2F9  30         mov   *stack+,r11           ; Pop R11
0071 78E0 045B  20         b     *r11                  ; Return to caller
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
0092 78E2 0649  14         dect  stack
0093 78E4 C64B  30         mov   r11,*stack            ; Save return address
0094 78E6 0649  14         dect  stack
0095 78E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0096 78EA 0649  14         dect  stack
0097 78EC C645  30         mov   tmp1,*stack           ; Push tmp1
0098 78EE 0649  14         dect  stack
0099 78F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0100 78F2 0649  14         dect  stack
0101 78F4 C647  30         mov   tmp3,*stack           ; Push tmp3
0102 78F6 0649  14         dect  stack
0103 78F8 C648  30         mov   tmp4,*stack           ; Push tmp4
0104 78FA 0649  14         dect  stack
0105 78FC C660  46         mov   @parm1,*stack         ; Push parm1
     78FE 2F20 
0106                       ;-------------------------------------------------------
0107                       ; Turn screen of
0108                       ;-------------------------------------------------------
0109 7900 C120  34         mov   @parm1,tmp0
     7902 2F20 
0110 7904 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7906 FFFF 
0111 7908 1302  14         jeq   !                     ; Yes, so skip screen off
0112 790A 06A0  32         bl    @scroff               ; Turn screen off
     790C 2662 
0113                       ;-------------------------------------------------------
0114                       ; Get FG/BG colors framebuffer text
0115                       ;-------------------------------------------------------
0116 790E C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7910 A012 
0117 7912 0604  14         dec   tmp0                  ; Internally work with base 0
0118               
0119 7914 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0120 7916 0224  22         ai    tmp0,tv.colorscheme.table
     7918 32F2 
0121                                                   ; Add base for color scheme data table
0122 791A C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0123 791C C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     791E A018 
0124                       ;-------------------------------------------------------
0125                       ; Get and save cursor color
0126                       ;-------------------------------------------------------
0127 7920 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0128 7922 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7924 00FF 
0129 7926 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7928 A016 
0130                       ;-------------------------------------------------------
0131                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0132                       ;-------------------------------------------------------
0133 792A C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0134 792C 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     792E FF00 
0135 7930 0988  56         srl   tmp4,8                ; MSB to LSB
0136               
0137 7932 C134  30         mov   *tmp0+,tmp0           ; Get colors IJKL
0138               
0139 7934 C144  18         mov   tmp0,tmp1             ; \ Right align IJ and
0140 7936 0985  56         srl   tmp1,8                ; | save to @tv.busycolor
0141 7938 C805  38         mov   tmp1,@tv.busycolor    ; /
     793A A01C 
0142               
0143 793C C144  18         mov   tmp0,tmp1             ; \ Right align KL and
0144 793E 0245  22         andi  tmp1,>00ff            ; | save to @tv.markcolor
     7940 00FF 
0145 7942 C805  38         mov   tmp1,@tv.markcolor    ; /
     7944 A01A 
0146               
0147                       ;-------------------------------------------------------
0148                       ; Dump colors to VDP register 7 (text mode)
0149                       ;-------------------------------------------------------
0150 7946 C147  18         mov   tmp3,tmp1             ; Get work copy
0151 7948 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0152 794A 0265  22         ori   tmp1,>0700
     794C 0700 
0153 794E C105  18         mov   tmp1,tmp0
0154 7950 06A0  32         bl    @putvrx               ; Write VDP register
     7952 2344 
0155                       ;-------------------------------------------------------
0156                       ; Dump colors for frame buffer pane (TAT)
0157                       ;-------------------------------------------------------
0158 7954 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     7956 1800 
0159 7958 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0160 795A 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0161 795C 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     795E 0910 
0162 7960 06A0  32         bl    @xfilv                ; Fill colors
     7962 22A4 
0163                                                   ; i \  tmp0 = start address
0164                                                   ; i |  tmp1 = byte to fill
0165                                                   ; i /  tmp2 = number of bytes to fill
0166               
0167 7964 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     7966 A110 
0168 7968 06A0  32         bl    @fb.colorlines
     796A 69DE 
0169                       ;-------------------------------------------------------
0170                       ; Dump colors for CMDB pane (TAT)
0171                       ;-------------------------------------------------------
0172               pane.action.colorscheme.cmdbpane:
0173 796C C120  34         mov   @cmdb.visible,tmp0
     796E A302 
0174 7970 1307  14         jeq   pane.action.colorscheme.errpane
0175                                                   ; Skip if CMDB pane is hidden
0176               
0177 7972 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     7974 1FD0 
0178 7976 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0179 7978 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     797A 0190 
0180 797C 06A0  32         bl    @xfilv                ; Fill colors
     797E 22A4 
0181                                                   ; i \  tmp0 = start address
0182                                                   ; i |  tmp1 = byte to fill
0183                                                   ; i /  tmp2 = number of bytes to fill
0184                       ;-------------------------------------------------------
0185                       ; Dump fixed colors for error line pane (TAT)
0186                       ;-------------------------------------------------------
0187               pane.action.colorscheme.errpane:
0188 7980 C120  34         mov   @tv.error.visible,tmp0
     7982 A024 
0189 7984 1306  14         jeq   pane.action.colorscheme.statusline
0190                                                   ; Skip if error line pane is hidden
0191               
0192 7986 0205  20         li    tmp1,>00f6            ; White on dark red
     7988 00F6 
0193 798A C805  38         mov   tmp1,@parm1           ; Pass color combination
     798C 2F20 
0194               
0195 798E 06A0  32         bl    @pane.action.colorcombo.errline
     7990 79C0 
0196                                                   ; Load color combination for error line
0197                                                   ; \ i  @parm1 = Color combination
0198                                                   ; /
0199                       ;-------------------------------------------------------
0200                       ; Dump colors for bottom status line pane (TAT)
0201                       ;-------------------------------------------------------
0202               pane.action.colorscheme.statusline:
0203 7992 C820  54         mov   @tv.color,@parm1      ; Pass color combination
     7994 A018 
     7996 2F20 
0204               
0205 7998 06A0  32         bl    @pane.action.colorcombo.botline
     799A 79F4 
0206                                                   ; Load color combination for status line
0207                                                   ; \ i  @parm1 = Color combination
0208                                                   ; /
0209                       ;-------------------------------------------------------
0210                       ; Dump cursor FG color to sprite table (SAT)
0211                       ;-------------------------------------------------------
0212               pane.action.colorscheme.cursorcolor:
0213 799C C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     799E A016 
0214 79A0 0A88  56         sla   tmp4,8                ; Move to MSB
0215 79A2 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     79A4 2F57 
0216 79A6 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     79A8 A015 
0217                       ;-------------------------------------------------------
0218                       ; Exit
0219                       ;-------------------------------------------------------
0220               pane.action.colorscheme.load.exit:
0221 79AA 06A0  32         bl    @scron                ; Turn screen on
     79AC 266A 
0222 79AE C839  50         mov   *stack+,@parm1        ; Pop @parm1
     79B0 2F20 
0223 79B2 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0224 79B4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0225 79B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0226 79B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0227 79BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0228 79BC C2F9  30         mov   *stack+,r11           ; Pop R11
0229 79BE 045B  20         b     *r11                  ; Return to caller
0230               
0231               
0232               
0233               ***************************************************************
0234               * pane.action.colorcombo.errline
0235               * Load color scheme for error line
0236               ***************************************************************
0237               * bl  @pane.action.colorcombo.errline
0238               *--------------------------------------------------------------
0239               * INPUT
0240               * @parm1 = Foreground / Background color
0241               *--------------------------------------------------------------
0242               * OUTPUT
0243               * none
0244               *--------------------------------------------------------------
0245               * Register usage
0246               * tmp0,tmp1,tmp2
0247               ********|*****|*********************|**************************
0248               pane.action.colorcombo.errline:
0249 79C0 0649  14         dect  stack
0250 79C2 C64B  30         mov   r11,*stack            ; Save return address
0251 79C4 0649  14         dect  stack
0252 79C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0253 79C8 0649  14         dect  stack
0254 79CA C645  30         mov   tmp1,*stack           ; Push tmp1
0255 79CC 0649  14         dect  stack
0256 79CE C646  30         mov   tmp2,*stack           ; Push tmp2
0257 79D0 0649  14         dect  stack
0258 79D2 C660  46         mov   @parm1,*stack         ; Push parm1
     79D4 2F20 
0259                       ;-------------------------------------------------------
0260                       ; Load error line colors
0261                       ;-------------------------------------------------------
0262 79D6 C160  34         mov   @parm1,tmp1           ; Get FG/BG color
     79D8 2F20 
0263               
0264 79DA 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     79DC 20C0 
0265 79DE 0206  20         li    tmp2,80               ; Number of bytes to fill
     79E0 0050 
0266 79E2 06A0  32         bl    @xfilv                ; Fill colors
     79E4 22A4 
0267                                                   ; i \  tmp0 = start address
0268                                                   ; i |  tmp1 = byte to fill
0269                                                   ; i /  tmp2 = number of bytes to fill
0270                       ;-------------------------------------------------------
0271                       ; Exit
0272                       ;-------------------------------------------------------
0273               pane.action.colorcombo.errline.exit:
0274 79E6 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     79E8 2F20 
0275 79EA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0276 79EC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0277 79EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0278 79F0 C2F9  30         mov   *stack+,r11           ; Pop R11
0279 79F2 045B  20         b     *r11                  ; Return to caller
0280               
0281               
0282               
0283               
0284               
0285               
0286               ***************************************************************
0287               * pane.action.colorcombo.botline
0288               * Load color combination for error line
0289               ***************************************************************
0290               * bl  @pane.action.colorcombo.botline
0291               *--------------------------------------------------------------
0292               * INPUT
0293               * @parm1 = Foreground / Background color
0294               *--------------------------------------------------------------
0295               * OUTPUT
0296               * none
0297               *--------------------------------------------------------------
0298               * Register usage
0299               * tmp0,tmp1,tmp2
0300               ********|*****|*********************|**************************
0301               pane.action.colorcombo.botline:
0302 79F4 0649  14         dect  stack
0303 79F6 C64B  30         mov   r11,*stack            ; Save return address
0304 79F8 0649  14         dect  stack
0305 79FA C644  30         mov   tmp0,*stack           ; Push tmp0
0306 79FC 0649  14         dect  stack
0307 79FE C645  30         mov   tmp1,*stack           ; Push tmp1
0308 7A00 0649  14         dect  stack
0309 7A02 C646  30         mov   tmp2,*stack           ; Push tmp2
0310 7A04 0649  14         dect  stack
0311 7A06 C660  46         mov   @parm1,*stack         ; Push parm1
     7A08 2F20 
0312                       ;-------------------------------------------------------
0313                       ; Dump colors for bottom status line pane (TAT)
0314                       ;-------------------------------------------------------
0315 7A0A 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     7A0C 2110 
0316 7A0E C160  34         mov   @parm1,tmp1           ; Get color
     7A10 2F20 
0317 7A12 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7A14 00FF 
0318 7A16 0206  20         li    tmp2,80               ; Number of bytes to fill
     7A18 0050 
0319 7A1A 06A0  32         bl    @xfilv                ; Fill colors
     7A1C 22A4 
0320                                                   ; i \  tmp0 = start address
0321                                                   ; i |  tmp1 = byte to fill
0322                                                   ; i /  tmp2 = number of bytes to fill
0323                       ;-------------------------------------------------------
0324                       ; Exit
0325                       ;-------------------------------------------------------
0326               pane.action.colorcombo.botline.exit:
0327 7A1E C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7A20 2F20 
0328 7A22 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0329 7A24 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0330 7A26 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0331 7A28 C2F9  30         mov   *stack+,r11           ; Pop R11
0332 7A2A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0184                                                   ; Colorscheme handling in panes
0185                       ;-----------------------------------------------------------------------
0186                       ; Screen panes
0187                       ;-----------------------------------------------------------------------
0188                       copy  "pane.cmdb.asm"       ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
**** **** ****     > stevie_b1.asm.358778
0189                       copy  "pane.cmdb.show.asm"  ; Show command buffer pane
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
0022 7A2C 0649  14         dect  stack
0023 7A2E C64B  30         mov   r11,*stack            ; Save return address
0024 7A30 0649  14         dect  stack
0025 7A32 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Show command buffer pane
0028                       ;------------------------------------------------------
0029 7A34 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7A36 832A 
     7A38 A304 
0030                                                   ; Save YX position in frame buffer
0031               
0032 7A3A C120  34         mov   @fb.scrrows.max,tmp0
     7A3C A11A 
0033 7A3E 6120  34         s     @cmdb.scrrows,tmp0
     7A40 A306 
0034 7A42 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7A44 A118 
0035               
0036 7A46 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0037 7A48 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7A4A A30E 
0038               
0039 7A4C 0224  22         ai    tmp0,>0100
     7A4E 0100 
0040 7A50 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7A52 A310 
0041 7A54 0584  14         inc   tmp0
0042 7A56 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7A58 A30A 
0043               
0044 7A5A 0720  34         seto  @cmdb.visible         ; Show pane
     7A5C A302 
0045 7A5E 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7A60 A318 
0046               
0047 7A62 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7A64 0001 
0048 7A66 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7A68 A01E 
0049               
0050 7A6A 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7A6C 7C00 
0051               
0052 7A6E 0720  34         seto  @parm1                ; Do not turn screen off while
     7A70 2F20 
0053                                                   ; reloading color scheme
0054               
0055 7A72 06A0  32         bl    @pane.action.colorscheme.load
     7A74 78E2 
0056                                                   ; Reload color scheme
0057                                                   ; i  parm1 = Skip screen off if >FFFF
0058               
0059               pane.cmdb.show.exit:
0060                       ;------------------------------------------------------
0061                       ; Exit
0062                       ;------------------------------------------------------
0063 7A76 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0064 7A78 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 7A7A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0190                       copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
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
0023 7A7C 0649  14         dect  stack
0024 7A7E C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Hide command buffer pane
0027                       ;------------------------------------------------------
0028 7A80 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7A82 A11A 
     7A84 A118 
0029                       ;------------------------------------------------------
0030                       ; Adjust frame buffer size if error pane visible
0031                       ;------------------------------------------------------
0032 7A86 C820  54         mov   @tv.error.visible,@tv.error.visible
     7A88 A024 
     7A8A A024 
0033 7A8C 1302  14         jeq   !
0034 7A8E 0620  34         dec   @fb.scrrows
     7A90 A118 
0035                       ;------------------------------------------------------
0036                       ; Clear error/hint & status line
0037                       ;------------------------------------------------------
0038 7A92 06A0  32 !       bl    @hchar
     7A94 2796 
0039 7A96 1C00                   byte pane.botrow-1,0,32,80*2
     7A98 20A0 
0040 7A9A FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Hide command buffer pane (rest)
0043                       ;------------------------------------------------------
0044 7A9C C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7A9E A304 
     7AA0 832A 
0045 7AA2 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7AA4 A302 
0046 7AA6 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7AA8 A116 
0047 7AAA 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7AAC A01E 
0048                       ;------------------------------------------------------
0049                       ; Reload current color scheme
0050                       ;------------------------------------------------------
0051 7AAE 0720  34         seto  @parm1                ; Do not turn screen off while
     7AB0 2F20 
0052                                                   ; reloading color scheme
0053               
0054 7AB2 06A0  32         bl    @pane.action.colorscheme.load
     7AB4 78E2 
0055                                                   ; Reload color scheme
0056                                                   ; i  parm1 = Skip screen off if >FFFF
0057                       ;------------------------------------------------------
0058                       ; Show cursor again
0059                       ;------------------------------------------------------
0060 7AB6 06A0  32         bl    @pane.cursor.blink
     7AB8 7844 
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               pane.cmdb.hide.exit:
0065 7ABA C2F9  30         mov   *stack+,r11           ; Pop r11
0066 7ABC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0191                       copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
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
0017 7ABE 0649  14         dect  stack
0018 7AC0 C64B  30         mov   r11,*stack            ; Save return address
0019 7AC2 0649  14         dect  stack
0020 7AC4 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7AC6 0649  14         dect  stack
0022 7AC8 C645  30         mov   tmp1,*stack           ; Push tmp1
0023 7ACA 0649  14         dect  stack
0024 7ACC C646  30         mov   tmp2,*stack           ; Push tmp2
0025                       ;------------------------------------------------------
0026                       ; Command buffer header line
0027                       ;------------------------------------------------------
0028 7ACE 06A0  32         bl    @hchar
     7AD0 2796 
0029 7AD2 190F                   byte pane.botrow-4,15,1,65
     7AD4 0141 
0030 7AD6 FFFF                   data eol
0031               
0032 7AD8 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7ADA A30E 
     7ADC 832A 
0033 7ADE C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     7AE0 A31C 
0034 7AE2 06A0  32         bl    @xutst0               ; /
     7AE4 2430 
0035               
0036                       ;------------------------------------------------------
0037                       ; Check dialog id
0038                       ;------------------------------------------------------
0039 7AE6 04E0  34         clr   @waux1                ; Default is show prompt
     7AE8 833C 
0040               
0041 7AEA C120  34         mov   @cmdb.dialog,tmp0
     7AEC A31A 
0042 7AEE 0284  22         ci    tmp0,99               ; \ Hide prompt and no keyboard
     7AF0 0063 
0043 7AF2 122E  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
0044 7AF4 0720  34         seto  @waux1                ; /
     7AF6 833C 
0045                       ;------------------------------------------------------
0046                       ; Show info message instead of prompt
0047                       ;------------------------------------------------------
0048 7AF8 C160  34         mov   @cmdb.paninfo,tmp1    ; Null pointer?
     7AFA A31E 
0049 7AFC 1329  14         jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt
0050               
0051 7AFE 06A0  32         bl    @at
     7B00 26A2 
0052 7B02 1A00                   byte pane.botrow-3,0  ; Position cursor
0053               
0054 7B04 D815  46         movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
     7B06 A326 
0055 7B08 D195  26         movb  *tmp1,tmp2            ; |
0056 7B0A 0986  56         srl   tmp2,8                ; |
0057 7B0C 06A0  32         bl    @xutst0               ; /  Display info message
     7B0E 2430 
0058               
0059                       ;------------------------------------------------------
0060                       ; Show M1, M2, M3 markers
0061                       ;------------------------------------------------------
0062 7B10 C120  34         mov   @cmdb.dialog,tmp0     ; Get dialog ID
     7B12 A31A 
0063 7B14 0284  22         ci    tmp0,id.dialog.block  ; Showing Block operations dialog?
     7B16 0066 
0064 7B18 161B  14         jne   pane.cmdb.draw.clear  ; No, skip markers
0065               
0066 7B1A C120  34         mov   @edb.block.m1,tmp0
     7B1C A20C 
0067 7B1E 1306  14         jeq   pane.cmdb.draw.m2
0068               
0069               pane.cmdb.draw.m1:
0070 7B20 06A0  32         bl    @putnum               ; Show M1 value
     7B22 2A26 
0071 7B24 1A04                   byte pane.botrow-3,4
0072 7B26 A20C                   data edb.block.m1,rambuf,>3020
     7B28 2F64 
     7B2A 3020 
0073               
0074               pane.cmdb.draw.m2:
0075 7B2C C120  34         mov   @edb.block.m2,tmp0
     7B2E A20E 
0076 7B30 1306  14         jeq   pane.cmdb.draw.m3
0077               
0078 7B32 06A0  32         bl    @putnum               ; Show M2 value
     7B34 2A26 
0079 7B36 1A19                   byte pane.botrow-3,25
0080 7B38 A20E                   data edb.block.m2,rambuf,>3020
     7B3A 2F64 
     7B3C 3020 
0081               
0082               pane.cmdb.draw.m3:
0083 7B3E C120  34         mov   @edb.block.m2,tmp0
     7B40 A20E 
0084 7B42 1306  14         jeq   pane.cmdb.draw.clear
0085               
0086 7B44 06A0  32         bl    @putnum               ; Show M3 value
     7B46 2A26 
0087 7B48 1A2C                   byte pane.botrow-3,44
0088 7B4A A20C                   data edb.block.m1,rambuf,>3020
     7B4C 2F64 
     7B4E 3020 
0089                       ;------------------------------------------------------
0090                       ; Clear lines after prompt in command buffer
0091                       ;------------------------------------------------------
0092               pane.cmdb.draw.clear:
0093 7B50 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7B52 A326 
0094 7B54 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0095 7B56 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7B58 A310 
0096 7B5A C804  38         mov   tmp0,@wyx             ; /
     7B5C 832A 
0097               
0098 7B5E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7B60 240A 
0099                                                   ; \ i  @wyx = Cursor position
0100                                                   ; / o  tmp0 = VDP target address
0101               
0102 7B62 0205  20         li    tmp1,32
     7B64 0020 
0103               
0104 7B66 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7B68 A326 
0105 7B6A 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0106 7B6C 0506  16         neg   tmp2                  ; | Based on command & prompt length
0107 7B6E 0226  22         ai    tmp2,2*80 - 1         ; /
     7B70 009F 
0108               
0109 7B72 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7B74 22A4 
0110                                                   ; | i  tmp0 = VDP target address
0111                                                   ; | i  tmp1 = Byte to fill
0112                                                   ; / i  tmp2 = Number of bytes to fill
0113                       ;------------------------------------------------------
0114                       ; Display pane hint in command buffer
0115                       ;------------------------------------------------------
0116               pane.cmdb.draw.hint:
0117 7B76 0204  20         li    tmp0,pane.botrow - 1  ; \
     7B78 001C 
0118 7B7A 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0119 7B7C C804  38         mov   tmp0,@parm1           ; Set parameter
     7B7E 2F20 
0120 7B80 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7B82 A320 
     7B84 2F22 
0121               
0122 7B86 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7B88 77BC 
0123                                                   ; \ i  parm1 = Pointer to string with hint
0124                                                   ; / i  parm2 = YX position
0125                       ;------------------------------------------------------
0126                       ; Display keys in status line
0127                       ;------------------------------------------------------
0128 7B8A 0204  20         li    tmp0,pane.botrow      ; \
     7B8C 001D 
0129 7B8E 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0130 7B90 C804  38         mov   tmp0,@parm1           ; Set parameter
     7B92 2F20 
0131 7B94 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7B96 A322 
     7B98 2F22 
0132               
0133 7B9A 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7B9C 77BC 
0134                                                   ; \ i  parm1 = Pointer to string with hint
0135                                                   ; / i  parm2 = YX position
0136                       ;------------------------------------------------------
0137                       ; ALPHA-Lock key down?
0138                       ;------------------------------------------------------
0139 7B9E 20A0  38         coc   @wbit10,config
     7BA0 201A 
0140 7BA2 1305  14         jeq   pane.cmdb.draw.alpha.down
0141                       ;------------------------------------------------------
0142                       ; AlPHA-Lock is up
0143                       ;------------------------------------------------------
0144 7BA4 06A0  32         bl    @putat
     7BA6 2452 
0145 7BA8 1D4F                   byte   pane.botrow,79
0146 7BAA 3522                   data   txt.alpha.up
0147               
0148 7BAC 1004  14         jmp   pane.cmdb.draw.promptcmd
0149                       ;------------------------------------------------------
0150                       ; AlPHA-Lock is down
0151                       ;------------------------------------------------------
0152               pane.cmdb.draw.alpha.down:
0153 7BAE 06A0  32         bl    @putat
     7BB0 2452 
0154 7BB2 1D4F                   byte   pane.botrow,79
0155 7BB4 3524                   data   txt.alpha.down
0156                       ;------------------------------------------------------
0157                       ; Command buffer content
0158                       ;------------------------------------------------------
0159               pane.cmdb.draw.promptcmd:
0160 7BB6 C120  34         mov   @waux1,tmp0           ; Flag set?
     7BB8 833C 
0161 7BBA 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0162 7BBC 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7BBE 6E8C 
0163                       ;------------------------------------------------------
0164                       ; Exit
0165                       ;------------------------------------------------------
0166               pane.cmdb.draw.exit:
0167 7BC0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0168 7BC2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0169 7BC4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0170 7BC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0171 7BC8 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.358778
0192               
0193                       copy  "pane.errline.asm"    ; Error line
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
0022 7BCA 0649  14         dect  stack
0023 7BCC C64B  30         mov   r11,*stack            ; Save return address
0024 7BCE 0649  14         dect  stack
0025 7BD0 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7BD2 0649  14         dect  stack
0027 7BD4 C645  30         mov   tmp1,*stack           ; Push tmp1
0028               
0029 7BD6 0205  20         li    tmp1,>00f6            ; White on dark red
     7BD8 00F6 
0030 7BDA C805  38         mov   tmp1,@parm1
     7BDC 2F20 
0031               
0032 7BDE 06A0  32         bl    @pane.action.colorcombo.errline
     7BE0 79C0 
0033                                                   ; \ Set colors for error line
0034                                                   ; / i  parm1 = FG/BG color
0035               
0036                       ;------------------------------------------------------
0037                       ; Show error line content
0038                       ;------------------------------------------------------
0039 7BE2 06A0  32         bl    @putat                ; Display error message
     7BE4 2452 
0040 7BE6 1C00                   byte pane.botrow-1,0
0041 7BE8 A026                   data tv.error.msg
0042               
0043 7BEA C120  34         mov   @fb.scrrows.max,tmp0
     7BEC A11A 
0044 7BEE 0604  14         dec   tmp0
0045 7BF0 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7BF2 A118 
0046               
0047 7BF4 0720  34         seto  @tv.error.visible     ; Error line is visible
     7BF6 A024 
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               pane.errline.show.exit:
0052 7BF8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0053 7BFA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0054 7BFC C2F9  30         mov   *stack+,r11           ; Pop r11
0055 7BFE 045B  20         b     *r11                  ; Return to caller
0056               
0057               
0058               
0059               ***************************************************************
0060               * pane.errline.hide
0061               * Hide error line
0062               ***************************************************************
0063               * bl @pane.errline.hide
0064               *--------------------------------------------------------------
0065               * INPUT
0066               * none
0067               *--------------------------------------------------------------
0068               * OUTPUT
0069               * none
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * none
0073               *--------------------------------------------------------------
0074               * Hiding the error line passes pane focus to frame buffer.
0075               ********|*****|*********************|**************************
0076               pane.errline.hide:
0077 7C00 0649  14         dect  stack
0078 7C02 C64B  30         mov   r11,*stack            ; Save return address
0079 7C04 0649  14         dect  stack
0080 7C06 C644  30         mov   tmp0,*stack           ; Push tmp0
0081                       ;------------------------------------------------------
0082                       ; Hide command buffer pane
0083                       ;------------------------------------------------------
0084 7C08 06A0  32 !       bl    @errline.init         ; Clear error line
     7C0A 31CE 
0085               
0086 7C0C C120  34         mov   @tv.color,tmp0        ; Get colors
     7C0E A018 
0087 7C10 0984  56         srl   tmp0,8                ; Right aligns
0088 7C12 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7C14 2F20 
0089               
0090 7C16 06A0  32         bl    @pane.action.colorcombo.errline
     7C18 79C0 
0091                                                   ; \ Set colors for error line
0092                                                   ; / i  parm1 LSB = FG/BG color
0093                       ;------------------------------------------------------
0094                       ; Exit
0095                       ;------------------------------------------------------
0096               pane.errline.hide.exit:
0097 7C1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0098 7C1C C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7C1E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.358778
0194                       copy  "pane.botline.asm"    ; Status line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Stevie Editor - Pane status bottom line
0003               
0004               ***************************************************************
0005               * pane.botline.draw
0006               * Draw Stevie status bottom line
0007               ***************************************************************
0008               * bl  @pane.botline.draw
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.botline.draw:
0017 7C20 0649  14         dect  stack
0018 7C22 C64B  30         mov   r11,*stack            ; Save return address
0019 7C24 0649  14         dect  stack
0020 7C26 C644  30         mov   tmp0,*stack           ; Push tmp0
0021               
0022 7C28 C820  54         mov   @wyx,@fb.yxsave
     7C2A 832A 
     7C2C A114 
0023                       ;------------------------------------------------------
0024                       ; Show separators
0025                       ;------------------------------------------------------
0026 7C2E 06A0  32         bl    @hchar
     7C30 2796 
0027 7C32 1D2A                   byte pane.botrow,42,16,1       ; Vertical line 1
     7C34 1001 
0028 7C36 1D32                   byte pane.botrow,50,16,1       ; Vertical line 2
     7C38 1001 
0029 7C3A 1D47                   byte pane.botrow,71,16,1       ; Vertical line 3
     7C3C 1001 
0030 7C3E FFFF                   data eol
0031                       ;------------------------------------------------------
0032                       ; Show buffer number
0033                       ;------------------------------------------------------
0034               pane.botline.bufnum:
0035 7C40 06A0  32         bl    @putat
     7C42 2452 
0036 7C44 1D00                   byte  pane.botrow,0
0037 7C46 34F4                   data  txt.bufnum
0038                       ;------------------------------------------------------
0039                       ; Show current file
0040                       ;------------------------------------------------------
0041               pane.botline.show_file:
0042 7C48 06A0  32         bl    @at
     7C4A 26A2 
0043 7C4C 1D03                   byte  pane.botrow,3   ; Position cursor
0044 7C4E C160  34         mov   @edb.filename.ptr,tmp1
     7C50 A212 
0045                                                   ; Get string to display
0046 7C52 06A0  32         bl    @xutst0               ; Display string
     7C54 2430 
0047                       ;------------------------------------------------------
0048                       ; Show text editing mode
0049                       ;------------------------------------------------------
0050               pane.botline.show_mode:
0051 7C56 C120  34         mov   @edb.insmode,tmp0
     7C58 A20A 
0052 7C5A 1605  14         jne   pane.botline.show_mode.insert
0053                       ;------------------------------------------------------
0054                       ; Overwrite mode
0055                       ;------------------------------------------------------
0056               pane.botline.show_mode.overwrite:
0057 7C5C 06A0  32         bl    @putat
     7C5E 2452 
0058 7C60 1D2C                   byte  pane.botrow,44
0059 7C62 34C0                   data  txt.ovrwrite
0060 7C64 1004  14         jmp   pane.botline.show_changed
0061                       ;------------------------------------------------------
0062                       ; Insert  mode
0063                       ;------------------------------------------------------
0064               pane.botline.show_mode.insert:
0065 7C66 06A0  32         bl    @putat
     7C68 2452 
0066 7C6A 1D2C                   byte  pane.botrow,44
0067 7C6C 34C4                   data  txt.insert
0068                       ;------------------------------------------------------
0069                       ; Show if text was changed in editor buffer
0070                       ;------------------------------------------------------
0071               pane.botline.show_changed:
0072 7C6E C120  34         mov   @edb.dirty,tmp0
     7C70 A206 
0073 7C72 1305  14         jeq   pane.botline.show_linecol
0074                       ;------------------------------------------------------
0075                       ; Show "*"
0076                       ;------------------------------------------------------
0077 7C74 06A0  32         bl    @putat
     7C76 2452 
0078 7C78 1D30                   byte pane.botrow,48
0079 7C7A 34C8                   data txt.star
0080 7C7C 1000  14         jmp   pane.botline.show_linecol
0081                       ;------------------------------------------------------
0082                       ; Show "line,column"
0083                       ;------------------------------------------------------
0084               pane.botline.show_linecol:
0085 7C7E C820  54         mov   @fb.row,@parm1
     7C80 A106 
     7C82 2F20 
0086 7C84 06A0  32         bl    @fb.row2line          ; Row to editor line
     7C86 68E6 
0087                                                   ; \ i @fb.topline = Top line in frame buffer
0088                                                   ; | i @parm1      = Row in frame buffer
0089                                                   ; / o @outparm1   = Matching line in EB
0090               
0091 7C88 05A0  34         inc   @outparm1             ; Add base 1
     7C8A 2F30 
0092                       ;------------------------------------------------------
0093                       ; Show line
0094                       ;------------------------------------------------------
0095 7C8C 06A0  32         bl    @putnum
     7C8E 2A26 
0096 7C90 1D3B                   byte  pane.botrow,59  ; YX
0097 7C92 2F30                   data  outparm1,rambuf
     7C94 2F64 
0098 7C96 3020                   byte  48              ; ASCII offset
0099                             byte  32              ; Padding character
0100                       ;------------------------------------------------------
0101                       ; Show comma
0102                       ;------------------------------------------------------
0103 7C98 06A0  32         bl    @putat
     7C9A 2452 
0104 7C9C 1D40                   byte  pane.botrow,64
0105 7C9E 34B1                   data  txt.delim
0106                       ;------------------------------------------------------
0107                       ; Show column
0108                       ;------------------------------------------------------
0109 7CA0 06A0  32         bl    @film
     7CA2 2246 
0110 7CA4 2F69                   data rambuf+5,32,12   ; Clear work buffer with space character
     7CA6 0020 
     7CA8 000C 
0111               
0112 7CAA C820  54         mov   @fb.column,@waux1
     7CAC A10C 
     7CAE 833C 
0113 7CB0 05A0  34         inc   @waux1                ; Offset 1
     7CB2 833C 
0114               
0115 7CB4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7CB6 29A8 
0116 7CB8 833C                   data  waux1,rambuf
     7CBA 2F64 
0117 7CBC 3020                   byte  48              ; ASCII offset
0118                             byte  32              ; Fill character
0119               
0120 7CBE 06A0  32         bl    @trimnum              ; Trim number to the left
     7CC0 2A00 
0121 7CC2 2F64                   data  rambuf,rambuf+5,32
     7CC4 2F69 
     7CC6 0020 
0122               
0123 7CC8 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7CCA 0600 
0124 7CCC D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7CCE 2F69 
0125               
0126                       ;------------------------------------------------------
0127                       ; Decide if row length is to be shown
0128                       ;------------------------------------------------------
0129 7CD0 C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7CD2 A10C 
0130 7CD4 0584  14         inc   tmp0                  ; /
0131 7CD6 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7CD8 A108 
0132 7CDA 1101  14         jlt   pane.botline.show_linecol.linelen
0133 7CDC 102B  14         jmp   pane.botline.show_linecol.colstring
0134                                                   ; Yes, skip showing row length
0135                       ;------------------------------------------------------
0136                       ; Add '/' delimiter and length of line to string
0137                       ;------------------------------------------------------
0138               pane.botline.show_linecol.linelen:
0139 7CDE C120  34         mov   @fb.column,tmp0       ; \
     7CE0 A10C 
0140 7CE2 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CE4 2F6B 
0141 7CE6 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7CE8 0009 
0142 7CEA 1101  14         jlt   !                     ; | column.
0143 7CEC 0585  14         inc   tmp1                  ; /
0144               
0145 7CEE 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7CF0 2D00 
0146 7CF2 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0147               
0148 7CF4 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7CF6 833C 
0149               
0150 7CF8 06A0  32         bl    @mknum
     7CFA 29A8 
0151 7CFC A108                   data  fb.row.length,rambuf
     7CFE 2F64 
0152 7D00 3020                   byte  48              ; ASCII offset
0153                             byte  32              ; Padding character
0154               
0155 7D02 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7D04 833C 
0156               
0157 7D06 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7D08 A108 
0158 7D0A 0284  22         ci    tmp0,10               ; /
     7D0C 000A 
0159 7D0E 110B  14         jlt   pane.botline.show_line.1digit
0160                       ;------------------------------------------------------
0161                       ; Sanity check
0162                       ;------------------------------------------------------
0163 7D10 0284  22         ci    tmp0,80
     7D12 0050 
0164 7D14 1204  14         jle   pane.botline.show_line.2digits
0165                       ;------------------------------------------------------
0166                       ; Sanity checks failed
0167                       ;------------------------------------------------------
0168 7D16 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7D18 FFCE 
0169 7D1A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7D1C 2034 
0170                       ;------------------------------------------------------
0171                       ; Show length of line (2 digits)
0172                       ;------------------------------------------------------
0173               pane.botline.show_line.2digits:
0174 7D1E 0204  20         li    tmp0,rambuf+3
     7D20 2F67 
0175 7D22 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0176 7D24 1002  14         jmp   pane.botline.show_line.rest
0177                       ;------------------------------------------------------
0178                       ; Show length of line (1 digits)
0179                       ;------------------------------------------------------
0180               pane.botline.show_line.1digit:
0181 7D26 0204  20         li    tmp0,rambuf+4
     7D28 2F68 
0182               pane.botline.show_line.rest:
0183 7D2A DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0184 7D2C DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D2E 2F64 
0185 7D30 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D32 2F64 
0186                       ;------------------------------------------------------
0187                       ; Show column string
0188                       ;------------------------------------------------------
0189               pane.botline.show_linecol.colstring:
0190 7D34 06A0  32         bl    @putat
     7D36 2452 
0191 7D38 1D41                   byte pane.botrow,65
0192 7D3A 2F69                   data rambuf+5         ; Show string
0193                       ;------------------------------------------------------
0194                       ; Show lines in buffer unless on last line in file
0195                       ;------------------------------------------------------
0196 7D3C C820  54         mov   @fb.row,@parm1
     7D3E A106 
     7D40 2F20 
0197 7D42 06A0  32         bl    @fb.row2line
     7D44 68E6 
0198 7D46 8820  54         c     @edb.lines,@outparm1
     7D48 A204 
     7D4A 2F30 
0199 7D4C 1605  14         jne   pane.botline.show_lines_in_buffer
0200               
0201 7D4E 06A0  32         bl    @putat
     7D50 2452 
0202 7D52 1D49                   byte pane.botrow,73
0203 7D54 34BA                   data txt.bottom
0204               
0205 7D56 1009  14         jmp   pane.botline.exit
0206                       ;------------------------------------------------------
0207                       ; Show lines in buffer
0208                       ;------------------------------------------------------
0209               pane.botline.show_lines_in_buffer:
0210 7D58 C820  54         mov   @edb.lines,@waux1
     7D5A A204 
     7D5C 833C 
0211               
0212 7D5E 06A0  32         bl    @putnum
     7D60 2A26 
0213 7D62 1D49                   byte pane.botrow,73   ; YX
0214 7D64 833C                   data waux1,rambuf
     7D66 2F64 
0215 7D68 3020                   byte 48
0216                             byte 32
0217                       ;------------------------------------------------------
0218                       ; Exit
0219                       ;------------------------------------------------------
0220               pane.botline.exit:
0221 7D6A C820  54         mov   @fb.yxsave,@wyx
     7D6C A114 
     7D6E 832A 
0222 7D70 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0223 7D72 C2F9  30         mov   *stack+,r11           ; Pop r11
0224 7D74 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.358778
0195                       ;-----------------------------------------------------------------------
0196                       ; Dialogs
0197                       ;-----------------------------------------------------------------------
0198                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
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
0022                       ;-------------------------------------------------------
0023                       ; Show dialog "unsaved changes" if editor buffer dirty
0024                       ;-------------------------------------------------------
0025 7D76 C120  34         mov   @edb.dirty,tmp0
     7D78 A206 
0026 7D7A 1302  14         jeq   dialog.load.setup
0027 7D7C 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7D7E 7DF4 
0028                       ;-------------------------------------------------------
0029                       ; Setup dialog
0030                       ;-------------------------------------------------------
0031               dialog.load.setup:
0032 7D80 0204  20         li    tmp0,id.dialog.load
     7D82 000A 
0033 7D84 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7D86 A31A 
0034               
0035 7D88 0204  20         li    tmp0,txt.head.load
     7D8A 3528 
0036 7D8C C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7D8E A31C 
0037               
0038 7D90 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     7D92 A31E 
0039               
0040 7D94 0204  20         li    tmp0,txt.hint.load
     7D96 3538 
0041 7D98 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7D9A A320 
0042               
0043 7D9C 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     7D9E A44E 
0044 7DA0 1303  14         jeq   !
0045                       ;-------------------------------------------------------
0046                       ; Show that FastMode is on
0047                       ;-------------------------------------------------------
0048 7DA2 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     7DA4 35BE 
0049 7DA6 1002  14         jmp   dialog.load.keylist
0050                       ;-------------------------------------------------------
0051                       ; Show that FastMode is off
0052                       ;-------------------------------------------------------
0053 7DA8 0204  20 !       li    tmp0,txt.keys.load
     7DAA 3586 
0054                       ;-------------------------------------------------------
0055                       ; Show dialog
0056                       ;-------------------------------------------------------
0057               dialog.load.keylist:
0058 7DAC C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7DAE A322 
0059               
0060 7DB0 0460  28         b     @edkey.action.cmdb.show
     7DB2 67D4 
0061                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.358778
0199                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
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
0022                       ;-------------------------------------------------------
0023                       ; Crunch current row if dirty
0024                       ;-------------------------------------------------------
0025 7DB4 8820  54         c     @fb.row.dirty,@w$ffff
     7DB6 A10A 
     7DB8 2030 
0026 7DBA 1604  14         jne   !                     ; Skip crunching if clean
0027 7DBC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7DBE 6BF6 
0028 7DC0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7DC2 A10A 
0029                       ;-------------------------------------------------------
0030                       ; Setup dialog
0031                       ;-------------------------------------------------------
0032 7DC4 0204  20 !       li    tmp0,id.dialog.save
     7DC6 000B 
0033 7DC8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7DCA A31A 
0034               
0035 7DCC 0204  20         li    tmp0,txt.head.save
     7DCE 35F6 
0036 7DD0 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7DD2 A31C 
0037               
0038 7DD4 04E0  34         clr   @cmdb.paninfo         ; No info message, do input prompt
     7DD6 A31E 
0039               
0040 7DD8 0204  20         li    tmp0,txt.hint.save
     7DDA 3606 
0041 7DDC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7DDE A320 
0042               
0043 7DE0 0204  20         li    tmp0,txt.keys.save
     7DE2 3646 
0044 7DE4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7DE6 A322 
0045               
0046 7DE8 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     7DEA A44E 
0047               
0048 7DEC 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     7DEE 7844 
0049               
0050 7DF0 0460  28         b     @edkey.action.cmdb.show
     7DF2 67D4 
0051                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.358778
0200                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
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
0022 7DF4 0204  20         li    tmp0,id.dialog.unsaved
     7DF6 0065 
0023 7DF8 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7DFA A31A 
0024               
0025 7DFC 0204  20         li    tmp0,txt.head.unsaved
     7DFE 3670 
0026 7E00 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7E02 A31C 
0027               
0028 7E04 0204  20         li    tmp0,txt.info.unsaved
     7E06 3682 
0029 7E08 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     7E0A A31E 
0030               
0031 7E0C 0204  20         li    tmp0,txt.hint.unsaved
     7E0E 36B6 
0032 7E10 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7E12 A320 
0033               
0034 7E14 0204  20         li    tmp0,txt.keys.unsaved
     7E16 36F6 
0035 7E18 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7E1A A322 
0036               
0037 7E1C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E1E 7826 
0038               
0039 7E20 0460  28         b     @edkey.action.cmdb.show
     7E22 67D4 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.358778
0201                       copy  "dialog.block.asm"    ; Dialog "Move/Copy/Delete block"
**** **** ****     > dialog.block.asm
0001               * FILE......: dialog.block.asm
0002               * Purpose...: Dialog "Block move/copy/delete"
0003               
0004               ***************************************************************
0005               * dialog.block
0006               * Open Dialog for block delete/move/copy
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
0021               dialog.block:
0022 7E24 0204  20         li    tmp0,id.dialog.block
     7E26 0066 
0023 7E28 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7E2A A31A 
0024               
0025 7E2C 0204  20         li    tmp0,txt.head.block
     7E2E 3720 
0026 7E30 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7E32 A31C 
0027               
0028 7E34 0204  20         li    tmp0,txt.info.block
     7E36 373E 
0029 7E38 C804  38         mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
     7E3A A31E 
0030               
0031 7E3C 0204  20         li    tmp0,txt.hint.block
     7E3E 3778 
0032 7E40 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7E42 A320 
0033               
0034 7E44 0204  20         li    tmp0,txt.keys.block
     7E46 37C0 
0035 7E48 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7E4A A322 
0036               
0037 7E4C 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E4E 7826 
0038               
0039 7E50 0460  28         b     @edkey.action.cmdb.show
     7E52 67D4 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.358778
0202                       ;-----------------------------------------------------------------------
0203                       ; Stubs & trampolines
0204                       ;-----------------------------------------------------------------------
0205                       copy  "stubs.bank1.asm"     ; Stubs for functions in other banks
**** **** ****     > stubs.bank1.asm
0001               * FILE......: stubs.bank1.asm
0002               * Purpose...: Stubs for functions in other banks
0003               
0004               
0005               ***************************************************************
0006               * Stub for "About dialog"
0007               ********|*****|*********************|**************************
0008               edkey.action.about:
0009 7E54 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7E56 7826 
0010                       ;------------------------------------------------------
0011                       ; Show dialog
0012                       ;------------------------------------------------------
0013 7E58 06A0  32         bl    @swbnk                ; \ Trampoline jump to bank
     7E5A 2000 
0014 7E5C 6004                   data bank2,vector.1   ; | i  p0 = bank address
     7E5E 7FE2 
0015                                                   ; / i  p1 = Target address in bank
0016                       ;------------------------------------------------------
0017                       ; Exit
0018                       ;------------------------------------------------------
0019 7E60 0460  28         b     @edkey.action.cmdb.show
     7E62 67D4 
0020                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.358778
0206                       ;-----------------------------------------------------------------------
0207                       ; Program data
0208                       ;-----------------------------------------------------------------------
0209                       copy  "data.keymap.actions.asm"
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
0011 7E64 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7E66 0000 
     7E68 65F0 
0012 7E6A 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7E6C 0000 
     7E6E 6172 
0013 7E70 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7E72 0000 
     7E74 6188 
0014 7E76 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7E78 0000 
     7E7A 6288 
0015 7E7C 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7E7E 0000 
     7E80 62DA 
0016 7E82 8100             data  key.ctrl.a, pane.focus.fb, edkey.action.home
     7E84 0000 
     7E86 61A0 
0017 7E88 8600             data  key.ctrl.f, pane.focus.fb, edkey.action.end
     7E8A 0000 
     7E8C 61B8 
0018 7E8E 9300             data  key.ctrl.s, pane.focus.fb, edkey.action.pword
     7E90 0000 
     7E92 61D6 
0019 7E94 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.nword
     7E96 0000 
     7E98 6228 
0020 7E9A 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7E9C 0000 
     7E9E 6346 
0021 7EA0 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7EA2 0000 
     7EA4 637A 
0022 7EA6 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7EA8 0000 
     7EAA 63C8 
0023 7EAC 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7EAE 0000 
     7EB0 63DE 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7EB2 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7EB4 0000 
     7EB6 6408 
0028 7EB8 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7EBA 0000 
     7EBC 64BA 
0029 7EBE 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7EC0 0000 
     7EC2 6486 
0030                       ;-------------------------------------------------------
0031                       ; Modifier keys - Insert
0032                       ;-------------------------------------------------------
0033 7EC4 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7EC6 0000 
     7EC8 6532 
0034 7ECA B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7ECC 0000 
     7ECE 6660 
0035 7ED0 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7ED2 0000 
     7ED4 65AC 
0036                       ;-------------------------------------------------------
0037                       ; Other action keys
0038                       ;-------------------------------------------------------
0039 7ED6 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7ED8 0000 
     7EDA 66D4 
0040 7EDC 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7EDE 0000 
     7EE0 7884 
0041 7EE2 B100             data  key.ctrl.1, pane.focus.fb, edkey.action.block.mark.m1
     7EE4 0000 
     7EE6 671C 
0042 7EE8 B200             data  key.ctrl.2, pane.focus.fb, edkey.action.block.mark.m2
     7EEA 0000 
     7EEC 6724 
0043                       ;-------------------------------------------------------
0044                       ; Dialog keys
0045                       ;-------------------------------------------------------
0046 7EEE 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7EF0 0000 
     7EF2 66E6 
0047 7EF4 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7EF6 0000 
     7EF8 66F2 
0048 7EFA 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7EFC 0000 
     7EFE 7E54 
0049 7F00 8B00             data  key.ctrl.k, pane.focus.fb, dialog.save
     7F02 0000 
     7F04 7DB4 
0050 7F06 8C00             data  key.ctrl.l, pane.focus.fb, dialog.load
     7F08 0000 
     7F0A 7D76 
0051 7F0C 8D00             data  key.ctrl.m, pane.focus.fb, dialog.block
     7F0E 0000 
     7F10 7E24 
0052                       ;-------------------------------------------------------
0053                       ; End of list
0054                       ;-------------------------------------------------------
0055 7F12 FFFF             data  EOL                           ; EOL
0056               
0057               
0058               
0059               
0060               *---------------------------------------------------------------
0061               * Action keys mapping table: Command Buffer (CMDB)
0062               *---------------------------------------------------------------
0063               keymap_actions.cmdb:
0064                       ;-------------------------------------------------------
0065                       ; Dialog specific: File load / save
0066                       ;-------------------------------------------------------
0067 7F14 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7F16 000A 
     7F18 6862 
0068                       ;-------------------------------------------------------
0069                       ; Dialog specific: Unsaved changes
0070                       ;-------------------------------------------------------
0071 7F1A 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7F1C 0065 
     7F1E 6838 
0072 7F20 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7F22 0065 
     7F24 7DB4 
0073                       ;-------------------------------------------------------
0074                       ; Dialog specific: Block move/copy/delete
0075                       ;-------------------------------------------------------
0076 7F26 8500             data  key.ctrl.e, id.dialog.block, edkey.action.ppage
     7F28 0066 
     7F2A 6346 
0077 7F2C 9800             data  key.ctrl.x, id.dialog.block, edkey.action.npage
     7F2E 0066 
     7F30 637A 
0078 7F32 9400             data  key.ctrl.t, id.dialog.block, edkey.action.top
     7F34 0066 
     7F36 63C8 
0079 7F38 8200             data  key.ctrl.b, id.dialog.block, edkey.action.bot
     7F3A 0066 
     7F3C 63DE 
0080                       ;-------------------------------------------------------
0081                       ; Dialog specific: About
0082                       ;-------------------------------------------------------
0083 7F3E 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7F40 0067 
     7F42 686E 
0084                       ;-------------------------------------------------------
0085                       ; Movement keys
0086                       ;-------------------------------------------------------
0087 7F44 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7F46 0001 
     7F48 672C 
0088 7F4A 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7F4C 0001 
     7F4E 673E 
0089 7F50 8100             data  key.ctrl.a, pane.focus.cmdb, edkey.action.cmdb.home
     7F52 0001 
     7F54 6756 
0090 7F56 8600             data  key.ctrl.f, pane.focus.cmdb, edkey.action.cmdb.end
     7F58 0001 
     7F5A 676A 
0091                       ;-------------------------------------------------------
0092                       ; Modifier keys
0093                       ;-------------------------------------------------------
0094 7F5C 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7F5E 0001 
     7F60 6782 
0095 7F62 0D00             data  key.enter, pane.focus.cmdb, edkey.action.cmdb.enter
     7F64 0001 
     7F66 67C6 
0096                       ;-------------------------------------------------------
0097                       ; Other action keys
0098                       ;-------------------------------------------------------
0099 7F68 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7F6A 0001 
     7F6C 686E 
0100 7F6E 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7F70 0001 
     7F72 66D4 
0101 7F74 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7F76 0001 
     7F78 7884 
0102                       ;------------------------------------------------------
0103                       ; End of list
0104                       ;-------------------------------------------------------
0105 7F7A FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.358778
0210                                                   ; Data segment - Keyboard actions
0211               
0212                       ;-----------------------------------------------------------------------
0213                       ; Bank specific vector table
0214                       ;-----------------------------------------------------------------------
0218 7F7C 7F7C                   data $                ; Bank 1 ROM size OK.
0220               
0221                       aorg  >7fe0
0222               
0223 7FE0 7FE0     vector.0   data  $
0224 7FE2 7FE2     vector.1   data  $
0225 7FE4 7FE4     vector.2   data  $
0226 7FE6 7FE6     vector.3   data  $
0227 7FE8 7FE8     vector.4   data  $
0228 7FEA 7FEA     vector.5   data  $
0229 7FEC 7FEC     vector.6   data  $
0230 7FEE 7FEE     vector.7   data  $
0231 7FF0 7FF0     vector.8   data  $
0232 7FF2 7FF2     vector.9   data  $
0233 7FF4 7FF4     vector.a   data  $
0234 7FF6 7FF6     vector.b   data  $
0235 7FF8 7FF8     vector.c   data  $
0236 7FFA 7FFA     vector.d   data  $
0237 7FFC 7FFC     vector.e   data  $
0238 7FFE 7FFE     vector.f   data  $
0239               
0240               *--------------------------------------------------------------
0241               * Video mode configuration
0242               *--------------------------------------------------------------
0243      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0244      0004     spfbck  equ   >04                   ; Screen background color.
0245      322C     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0246      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0247      0050     colrow  equ   80                    ; Columns per row
0248      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0249      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0250      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0251      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

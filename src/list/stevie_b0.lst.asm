XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b0.asm.157677
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b0.asm               ; Version 200906-157677
0010               
0011                       copy  "equates.equ"         ; Equates Stevie configuration
**** **** ****     > equates.equ
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.equ                 ; Version %%build_date%%
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
0090      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0091      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0092      0001     id.dialog.load            equ  1       ; ID for dialog "Load DV 80 file"
0093      0002     id.dialog.save            equ  2       ; ID for dialog "Save DV 80 file"
0094      0003     id.dialog.unsaved         equ  3       ; ID for dialog "Unsaved changes"
0095      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0096      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0097      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0098               *--------------------------------------------------------------
0099               * SPECTRA2 / Stevie startup options
0100               *--------------------------------------------------------------
0101      0001     debug                     equ  1       ; Turn on spectra2 debugging
0102      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0103      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0104      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0105               *--------------------------------------------------------------
0106               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0107               *--------------------------------------------------------------
0108      2F20     parm1             equ  >2f20           ; Function parameter 1
0109      2F22     parm2             equ  >2f22           ; Function parameter 2
0110      2F24     parm3             equ  >2f24           ; Function parameter 3
0111      2F26     parm4             equ  >2f26           ; Function parameter 4
0112      2F28     parm5             equ  >2f28           ; Function parameter 5
0113      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0114      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0115      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0116      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0117      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0118      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0119      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0120      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0121      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0122      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0123      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0124      2F40     timers            equ  >2f40           ; Timer table
0125      2F50     ramsat            equ  >2f50           ; Sprite Attribute Table in RAM
0126      2F60     rambuf            equ  >2f60           ; RAM workbuffer 1
0127               *--------------------------------------------------------------
0128               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0129               *--------------------------------------------------------------
0130      A000     tv.top            equ  >a000           ; Structure begin
0131      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0132      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0133      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0134      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0135      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0136      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0137      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0138      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0139      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0140      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0141      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0142      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0143      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0144      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0145      A01C     tv.pane.welcome   equ  tv.top + 28     ; Welcome pane currently shown
0146      A01E     tv.task.oneshot   equ  tv.top + 30     ; Pointer to one-shot routine
0147      A020     tv.error.visible  equ  tv.top + 32     ; Error pane visible
0148      A022     tv.error.msg      equ  tv.top + 34     ; Error message (max. 160 characters)
0149      A0C2     tv.free           equ  tv.top + 194    ; End of structure
0150               *--------------------------------------------------------------
0151               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0152               *--------------------------------------------------------------
0153      A100     fb.struct         equ  >a100           ; Structure begin
0154      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0155      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0156      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0157                                                      ; line X in editor buffer).
0158      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0159                                                      ; (offset 0 .. @fb.scrrows)
0160      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0161      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0162      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0163      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0164      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0165      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0166      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0167      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0168      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0169      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0170      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0171               *--------------------------------------------------------------
0172               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0173               *--------------------------------------------------------------
0174      A200     edb.struct        equ  >a200           ; Begin structure
0175      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0176      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0177      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0178      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0179      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0180      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0181      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0182      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0183                                                      ; with current filename.
0184      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0185                                                      ; with current file type.
0186      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0187      A214     edb.free          equ  edb.struct + 20 ; End of structure
0188               *--------------------------------------------------------------
0189               * Command buffer structure            @>a300-a3ff   (256 bytes)
0190               *--------------------------------------------------------------
0191      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0192      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0193      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0194      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0195      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0196      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0197      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0198      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0199      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0200      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0201      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0202      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0203      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0204      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0205      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0206      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0207      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0208      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0209      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0210      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0211      A373     cmdb.free         equ  cmdb.struct +115; End of structure
0212               *--------------------------------------------------------------
0213               * File handle structure               @>a400-a4ff   (256 bytes)
0214               *--------------------------------------------------------------
0215      A400     fh.struct         equ  >a400           ; stevie file handling structures
0216               ;***********************************************************************
0217               ; ATTENTION
0218               ; The dsrlnk variables must form a continuous memory block and keep
0219               ; their order!
0220               ;***********************************************************************
0221      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0222      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0223      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0224      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0225      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0226      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0227      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0228      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0229      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0230      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0231      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0232      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0233      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0234      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0235      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0236      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0237      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0238      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0239      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0240      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0241      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0242      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0243      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0244      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0245      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0246      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0247      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0248               
0249      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0250      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0251      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0252      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0253               *--------------------------------------------------------------
0254               * Index structure                     @>a500-a5ff   (256 bytes)
0255               *--------------------------------------------------------------
0256      A500     idx.struct        equ  >a500           ; stevie index structure
0257      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0258      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0259      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0260               *--------------------------------------------------------------
0261               * Frame buffer                        @>a600-afff  (2560 bytes)
0262               *--------------------------------------------------------------
0263      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0264      0960     fb.size           equ  80*30           ; Frame buffer size
0265               *--------------------------------------------------------------
0266               * Index                               @>b000-bfff  (4096 bytes)
0267               *--------------------------------------------------------------
0268      B000     idx.top           equ  >b000           ; Top of index
0269      1000     idx.size          equ  4096            ; Index size
0270               *--------------------------------------------------------------
0271               * Editor buffer                       @>c000-cfff  (4096 bytes)
0272               *--------------------------------------------------------------
0273      C000     edb.top           equ  >c000           ; Editor buffer high memory
0274      1000     edb.size          equ  4096            ; Editor buffer size
0275               *--------------------------------------------------------------
0276               * Command history buffer              @>d000-dfff  (4096 bytes)
0277               *--------------------------------------------------------------
0278      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0279      1000     cmdb.size         equ  4096            ; Command buffer size
0280               *--------------------------------------------------------------
0281               * Heap                                @>e000-efff  (4096 bytes)
0282               *--------------------------------------------------------------
0283      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b0.asm.157677
0012               
0013               ***************************************************************
0014               * Spectra2 core configuration
0015               ********|*****|*********************|**************************
0016      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at >2fff
0017                                                   ; and grows downwards
0018               
0019               
0020               ***************************************************************
0021               * BANK 0 - Setup environment for Stevie
0022               ********|*****|*********************|**************************
0023                       aorg  >6000
0024                       save  >6000,>7fff           ; Save bank 0 (1st bank)
0025               *--------------------------------------------------------------
0026               * Cartridge header
0027               ********|*****|*********************|**************************
0028 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0029 6006 6010             data  $+10
0030 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0031 6010 0000             data  0                     ; No more items following
0032 6012 6030             data  kickstart.code1
0033               
0035               
0036 6014 0653             byte  6
0037 6015 ....             text  'STEVIE'
0038                       even
0039               
0047               
0048               ***************************************************************
0049               * Step 1: Switch to bank 0 (uniform code accross all banks)
0050               ********|*****|*********************|**************************
0051                       aorg  kickstart.code1       ; >6030
0052               kickstart.step1:
0053 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
0054               ***************************************************************
0055               * Step 2: Copy SP2 library from ROM to >2000 - >2fff
0056               ********|*****|*********************|**************************
0057               kickstart.step2:
0058 6034 0200  20         li    r0,reloc.sp2          ; Start of code to relocate
     6036 607A 
0059 6038 0201  20         li    r1,>2000
     603A 2000 
0060 603C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     603E 0100 
0061 6040 06A0  32         bl    @kickstart.copy       ; Copy memory
     6042 6064 
0062               ***************************************************************
0063               * Step 3: Copy Stevie resident modules from ROM to >3000 - >3fff
0064               ********|*****|*********************|**************************
0065               kickstart.step3:
0066 6044 0200  20         li    r0,reloc.stevie       ; Start of code to relocate
     6046 7072 
0067 6048 0201  20         li    r1,>3000
     604A 3000 
0068 604C 0202  20         li    r2,256                ; Copy 4K (256 * 16 bytes)
     604E 0100 
0069 6050 06A0  32         bl    @kickstart.copy       ; Copy memory
     6052 6064 
0070               ***************************************************************
0071               * Step 4: Start SP2 kernel (runs in low MEMEXP)
0072               ********|*****|*********************|**************************
0073               kickstart.step4:
0074 6054 0460  28         b     @runlib               ; Start spectra2 library
     6056 2E10 
0075                       ;------------------------------------------------------
0076                       ; Assert. Should not get here! Crash and burn!
0077                       ;------------------------------------------------------
0078 6058 0200  20         li    r0,$                  ; Current location
     605A 6058 
0079 605C C800  38         mov   r0,@>ffce             ; \ Save caller address
     605E FFCE 
0080 6060 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6062 2030 
0081               ***************************************************************
0082               * Step 5: Handover from SP2 to Stevie "main" in low MEMEXP
0083               ********|*****|*********************|**************************
0084                       ; "main" in low MEMEXP is automatically called by SP2 runlib.
0085               
0086               ***************************************************************
0087               * Copy routine
0088               ********|*****|*********************|**************************
0089               kickstart.copy:
0090                       ;------------------------------------------------------
0091                       ; Copy memory to destination
0092                       ; r0 = Source CPU address
0093                       ; r1 = Target CPU address
0094                       ; r2 = Bytes to copy/16
0095                       ;------------------------------------------------------
0096 6064 CC70  46 !       mov   *r0+,*r1+             ; Copy word 1
0097 6066 CC70  46         mov   *r0+,*r1+             ; Copy word 2
0098 6068 CC70  46         mov   *r0+,*r1+             ; Copy word 3
0099 606A CC70  46         mov   *r0+,*r1+             ; Copy word 4
0100 606C CC70  46         mov   *r0+,*r1+             ; Copy word 5
0101 606E CC70  46         mov   *r0+,*r1+             ; Copy word 6
0102 6070 CC70  46         mov   *r0+,*r1+             ; Copy word 7
0103 6072 CC70  46         mov   *r0+,*r1+             ; Copy word 8
0104 6074 0602  14         dec   r2
0105 6076 16F6  14         jne   -!                    ; Loop until done
0106 6078 045B  20         b     *r11                  ; Return to caller
0107               
0108               
0109               
0110               ***************************************************************
0111               * Code data: Relocated code SP2 >2000 - >2eff (3840 bytes max)
0112               ********|*****|*********************|**************************
0113               reloc.sp2:
0114                       xorg >2000                  ; Relocate SP2 code to >2000
0115                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0025 607A C13B  30 swbnk   mov   *r11+,tmp0
0026 607C C17B  30         mov   *r11+,tmp1
0027 607E 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 6080 C155  26         mov   *tmp1,tmp1
0029 6082 0455  20         b     *tmp1                 ; Switch to routine in TMP1
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
0012 6084 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 6086 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 6088 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 608A 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 608C 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 608E 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6090 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6092 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 6094 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 6096 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 6098 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 609A 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 609C 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 609E 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 60A0 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 60A2 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 60A4 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 60A6 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 60A8 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      200A     hb$00   equ   w$0000                ; >0000
0035      201C     hb$01   equ   w$0100                ; >0100
0036      201E     hb$02   equ   w$0200                ; >0200
0037      2020     hb$04   equ   w$0400                ; >0400
0038      2022     hb$08   equ   w$0800                ; >0800
0039      2024     hb$10   equ   w$1000                ; >1000
0040      2026     hb$20   equ   w$2000                ; >2000
0041      2028     hb$40   equ   w$4000                ; >4000
0042      202A     hb$80   equ   w$8000                ; >8000
0043      202E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      200A     lb$00   equ   w$0000                ; >0000
0048      200C     lb$01   equ   w$0001                ; >0001
0049      200E     lb$02   equ   w$0002                ; >0002
0050      2010     lb$04   equ   w$0004                ; >0004
0051      2012     lb$08   equ   w$0008                ; >0008
0052      2014     lb$10   equ   w$0010                ; >0010
0053      2016     lb$20   equ   w$0020                ; >0020
0054      2018     lb$40   equ   w$0040                ; >0040
0055      201A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0038 60AA 022B  22         ai    r11,-4                ; Remove opcode offset
     60AC FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 60AE C800  38         mov   r0,@>ffe0
     60B0 FFE0 
0043 60B2 C801  38         mov   r1,@>ffe2
     60B4 FFE2 
0044 60B6 C802  38         mov   r2,@>ffe4
     60B8 FFE4 
0045 60BA C803  38         mov   r3,@>ffe6
     60BC FFE6 
0046 60BE C804  38         mov   r4,@>ffe8
     60C0 FFE8 
0047 60C2 C805  38         mov   r5,@>ffea
     60C4 FFEA 
0048 60C6 C806  38         mov   r6,@>ffec
     60C8 FFEC 
0049 60CA C807  38         mov   r7,@>ffee
     60CC FFEE 
0050 60CE C808  38         mov   r8,@>fff0
     60D0 FFF0 
0051 60D2 C809  38         mov   r9,@>fff2
     60D4 FFF2 
0052 60D6 C80A  38         mov   r10,@>fff4
     60D8 FFF4 
0053 60DA C80B  38         mov   r11,@>fff6
     60DC FFF6 
0054 60DE C80C  38         mov   r12,@>fff8
     60E0 FFF8 
0055 60E2 C80D  38         mov   r13,@>fffa
     60E4 FFFA 
0056 60E6 C80E  38         mov   r14,@>fffc
     60E8 FFFC 
0057 60EA C80F  38         mov   r15,@>ffff
     60EC FFFF 
0058 60EE 02A0  12         stwp  r0
0059 60F0 C800  38         mov   r0,@>ffdc
     60F2 FFDC 
0060 60F4 02C0  12         stst  r0
0061 60F6 C800  38         mov   r0,@>ffde
     60F8 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60FA 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60FC 8300 
0067 60FE 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6100 8302 
0068 6102 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     6104 4A4A 
0069 6106 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     6108 2E14 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 610A 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     610C 2302 
0078 610E 21F2                   data graph1           ; Equate selected video mode table
0079               
0080 6110 06A0  32         bl    @ldfnt
     6112 236A 
0081 6114 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     6116 000C 
0082               
0083 6118 06A0  32         bl    @filv
     611A 2298 
0084 611C 0380                   data >0380,>f0,32*24  ; Load color table
     611E 00F0 
     6120 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 6122 06A0  32         bl    @putat                ; Show crash message
     6124 244C 
0089 6126 0000                   data >0000,cpu.crash.msg.crashed
     6128 2182 
0090               
0091 612A 06A0  32         bl    @puthex               ; Put hex value on screen
     612C 2998 
0092 612E 0015                   byte 0,21             ; \ i  p0 = YX position
0093 6130 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 6132 2F60                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 6134 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 6136 06A0  32         bl    @putat                ; Show caller message
     6138 244C 
0101 613A 0100                   data >0100,cpu.crash.msg.caller
     613C 2198 
0102               
0103 613E 06A0  32         bl    @puthex               ; Put hex value on screen
     6140 2998 
0104 6142 0115                   byte 1,21             ; \ i  p0 = YX position
0105 6144 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 6146 2F60                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 6148 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 614A 06A0  32         bl    @putat
     614C 244C 
0113 614E 0300                   byte 3,0
0114 6150 21B2                   data cpu.crash.msg.wp
0115 6152 06A0  32         bl    @putat
     6154 244C 
0116 6156 0400                   byte 4,0
0117 6158 21B8                   data cpu.crash.msg.st
0118 615A 06A0  32         bl    @putat
     615C 244C 
0119 615E 1600                   byte 22,0
0120 6160 21BE                   data cpu.crash.msg.source
0121 6162 06A0  32         bl    @putat
     6164 244C 
0122 6166 1700                   byte 23,0
0123 6168 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 616A 06A0  32         bl    @at                   ; Put cursor at YX
     616C 269C 
0128 616E 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 6170 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6172 FFDC 
0132 6174 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 6176 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 6178 0649  14         dect  stack
0138 617A C644  30         mov   tmp0,*stack           ; Push tmp0
0139 617C 0649  14         dect  stack
0140 617E C645  30         mov   tmp1,*stack           ; Push tmp1
0141 6180 0649  14         dect  stack
0142 6182 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 6184 C046  18         mov   tmp2,r1               ; Save register number
0148 6186 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6188 0001 
0149 618A 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 618C 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 618E 06A0  32         bl    @mknum
     6190 29A2 
0154 6192 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 6194 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 6196 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 6198 06A0  32         bl    @setx                 ; Set cursor X position
     619A 26B2 
0160 619C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 619E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61A0 2428 
0164 61A2 2F60                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 61A4 06A0  32         bl    @setx                 ; Set cursor X position
     61A6 26B2 
0168 61A8 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 61AA 0281  22         ci    r1,10
     61AC 000A 
0172 61AE 1102  14         jlt   !
0173 61B0 0620  34         dec   @wyx                  ; x=x-1
     61B2 832A 
0174               
0175 61B4 06A0  32 !       bl    @putstr
     61B6 2428 
0176 61B8 21AE                   data cpu.crash.msg.r
0177               
0178 61BA 06A0  32         bl    @mknum
     61BC 29A2 
0179 61BE 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 61C0 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 61C2 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 61C4 06A0  32         bl    @mkhex                ; Convert hex word to string
     61C6 2914 
0188 61C8 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 61CA 2F60                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 61CC 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 61CE 06A0  32         bl    @setx                 ; Set cursor X position
     61D0 26B2 
0194 61D2 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 61D4 06A0  32         bl    @putstr
     61D6 2428 
0198 61D8 21B0                   data cpu.crash.msg.marker
0199               
0200 61DA 06A0  32         bl    @setx                 ; Set cursor X position
     61DC 26B2 
0201 61DE 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 61E0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     61E2 2428 
0205 61E4 2F60                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 61E6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 61E8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 61EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 61EC 06A0  32         bl    @down                 ; y=y+1
     61EE 26A2 
0213               
0214 61F0 0586  14         inc   tmp2
0215 61F2 0286  22         ci    tmp2,17
     61F4 0011 
0216 61F6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 61F8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     61FA 2D12 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 61FC 1553             byte  21
0225 61FD ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 6212 1543             byte  21
0230 6213 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 6228 0152             byte  1
0235 6229 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 622A 013E             byte  1
0240 622B ....             text  '>'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 622C 042A             byte  4
0245 622D ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 6232 042A             byte  4
0250 6233 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 6238 1B53             byte  27
0255 6239 ....             text  'Source    stevie_b0.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 6254 1742             byte  23
0260 6255 ....             text  'Build-ID  200906-157677'
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
0007 626C 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     626E 000E 
     6270 0106 
     6272 0204 
     6274 0020 
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
0032 6276 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6278 000E 
     627A 0106 
     627C 00F4 
     627E 0028 
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
0058 6280 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6282 003F 
     6284 0240 
     6286 03F4 
     6288 0050 
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
0084 628A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     628C 003F 
     628E 0240 
     6290 03F4 
     6292 0050 
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
0013 6294 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6296 16FD             data  >16fd                 ; |         jne   mcloop
0015 6298 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 629A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 629C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 629E 0201  20         li    r1,mccode             ; Machinecode to patch
     62A0 221A 
0037 62A2 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     62A4 8322 
0038 62A6 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 62A8 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 62AA CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 62AC 045B  20         b     *r11                  ; Return to caller
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
0056 62AE C0F9  30 popr3   mov   *stack+,r3
0057 62B0 C0B9  30 popr2   mov   *stack+,r2
0058 62B2 C079  30 popr1   mov   *stack+,r1
0059 62B4 C039  30 popr0   mov   *stack+,r0
0060 62B6 C2F9  30 poprt   mov   *stack+,r11
0061 62B8 045B  20         b     *r11
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
0085 62BA C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 62BC C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 62BE C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 62C0 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 62C2 1604  14         jne   filchk                ; No, continue checking
0093               
0094 62C4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     62C6 FFCE 
0095 62C8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     62CA 2030 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 62CC D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     62CE 830B 
     62D0 830A 
0100               
0101 62D2 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     62D4 0001 
0102 62D6 1602  14         jne   filchk2
0103 62D8 DD05  32         movb  tmp1,*tmp0+
0104 62DA 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 62DC 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     62DE 0002 
0109 62E0 1603  14         jne   filchk3
0110 62E2 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 62E4 DD05  32         movb  tmp1,*tmp0+
0112 62E6 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 62E8 C1C4  18 filchk3 mov   tmp0,tmp3
0117 62EA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62EC 0001 
0118 62EE 1605  14         jne   fil16b
0119 62F0 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 62F2 0606  14         dec   tmp2
0121 62F4 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     62F6 0002 
0122 62F8 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 62FA C1C6  18 fil16b  mov   tmp2,tmp3
0127 62FC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62FE 0001 
0128 6300 1301  14         jeq   dofill
0129 6302 0606  14         dec   tmp2                  ; Make TMP2 even
0130 6304 CD05  34 dofill  mov   tmp1,*tmp0+
0131 6306 0646  14         dect  tmp2
0132 6308 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 630A C1C7  18         mov   tmp3,tmp3
0137 630C 1301  14         jeq   fil.exit
0138 630E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 6310 045B  20         b     *r11
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
0159 6312 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 6314 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 6316 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 6318 0264  22 xfilv   ori   tmp0,>4000
     631A 4000 
0166 631C 06C4  14         swpb  tmp0
0167 631E D804  38         movb  tmp0,@vdpa
     6320 8C02 
0168 6322 06C4  14         swpb  tmp0
0169 6324 D804  38         movb  tmp0,@vdpa
     6326 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 6328 020F  20         li    r15,vdpw              ; Set VDP write address
     632A 8C00 
0174 632C 06C5  14         swpb  tmp1
0175 632E C820  54         mov   @filzz,@mcloop        ; Setup move command
     6330 22BE 
     6332 8320 
0176 6334 0460  28         b     @mcloop               ; Write data to VDP
     6336 8320 
0177               *--------------------------------------------------------------
0181 6338 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 633A 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     633C 4000 
0202 633E 06C4  14 vdra    swpb  tmp0
0203 6340 D804  38         movb  tmp0,@vdpa
     6342 8C02 
0204 6344 06C4  14         swpb  tmp0
0205 6346 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6348 8C02 
0206 634A 045B  20         b     *r11                  ; Exit
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
0217 634C C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 634E C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 6350 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6352 4000 
0223 6354 06C4  14         swpb  tmp0                  ; \
0224 6356 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6358 8C02 
0225 635A 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 635C D804  38         movb  tmp0,@vdpa            ; /
     635E 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 6360 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 6362 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 6364 045B  20         b     *r11                  ; Exit
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
0251 6366 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 6368 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 636A D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     636C 8C02 
0257 636E 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 6370 D804  38         movb  tmp0,@vdpa            ; /
     6372 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 6374 D120  34         movb  @vdpr,tmp0            ; Read byte
     6376 8800 
0263 6378 0984  56         srl   tmp0,8                ; Right align
0264 637A 045B  20         b     *r11                  ; Exit
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
0283 637C C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 637E C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 6380 C144  18         mov   tmp0,tmp1
0289 6382 05C5  14         inct  tmp1
0290 6384 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 6386 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6388 FF00 
0292 638A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 638C C805  38         mov   tmp1,@wbase           ; Store calculated base
     638E 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 6390 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6392 8000 
0298 6394 0206  20         li    tmp2,8
     6396 0008 
0299 6398 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     639A 830B 
0300 639C 06C5  14         swpb  tmp1
0301 639E D805  38         movb  tmp1,@vdpa
     63A0 8C02 
0302 63A2 06C5  14         swpb  tmp1
0303 63A4 D805  38         movb  tmp1,@vdpa
     63A6 8C02 
0304 63A8 0225  22         ai    tmp1,>0100
     63AA 0100 
0305 63AC 0606  14         dec   tmp2
0306 63AE 16F4  14         jne   vidta1                ; Next register
0307 63B0 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     63B2 833A 
0308 63B4 045B  20         b     *r11
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
0325 63B6 C13B  30 putvr   mov   *r11+,tmp0
0326 63B8 0264  22 putvrx  ori   tmp0,>8000
     63BA 8000 
0327 63BC 06C4  14         swpb  tmp0
0328 63BE D804  38         movb  tmp0,@vdpa
     63C0 8C02 
0329 63C2 06C4  14         swpb  tmp0
0330 63C4 D804  38         movb  tmp0,@vdpa
     63C6 8C02 
0331 63C8 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 63CA C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 63CC C10E  18         mov   r14,tmp0
0341 63CE 0984  56         srl   tmp0,8
0342 63D0 06A0  32         bl    @putvrx               ; Write VR#0
     63D2 233E 
0343 63D4 0204  20         li    tmp0,>0100
     63D6 0100 
0344 63D8 D820  54         movb  @r14lb,@tmp0lb
     63DA 831D 
     63DC 8309 
0345 63DE 06A0  32         bl    @putvrx               ; Write VR#1
     63E0 233E 
0346 63E2 0458  20         b     *tmp4                 ; Exit
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
0360 63E4 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 63E6 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 63E8 C11B  26         mov   *r11,tmp0             ; Get P0
0363 63EA 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63EC 7FFF 
0364 63EE 2120  38         coc   @wbit0,tmp0
     63F0 202A 
0365 63F2 1604  14         jne   ldfnt1
0366 63F4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     63F6 8000 
0367 63F8 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     63FA 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 63FC C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     63FE 23EC 
0372 6400 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6402 9C02 
0373 6404 06C4  14         swpb  tmp0
0374 6406 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6408 9C02 
0375 640A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     640C 9800 
0376 640E 06C5  14         swpb  tmp1
0377 6410 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6412 9800 
0378 6414 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 6416 D805  38         movb  tmp1,@grmwa
     6418 9C02 
0383 641A 06C5  14         swpb  tmp1
0384 641C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     641E 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 6420 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 6422 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6424 22C0 
0390 6426 05C8  14         inct  tmp4                  ; R11=R11+2
0391 6428 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 642A 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     642C 7FFF 
0393 642E C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6430 23EE 
0394 6432 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6434 23F0 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 6436 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 6438 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 643A D120  34         movb  @grmrd,tmp0
     643C 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 643E 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6440 202A 
0405 6442 1603  14         jne   ldfnt3                ; No, so skip
0406 6444 D1C4  18         movb  tmp0,tmp3
0407 6446 0917  56         srl   tmp3,1
0408 6448 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 644A D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     644C 8C00 
0413 644E 0606  14         dec   tmp2
0414 6450 16F2  14         jne   ldfnt2
0415 6452 05C8  14         inct  tmp4                  ; R11=R11+2
0416 6454 020F  20         li    r15,vdpw              ; Set VDP write address
     6456 8C00 
0417 6458 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     645A 7FFF 
0418 645C 0458  20         b     *tmp4                 ; Exit
0419 645E D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6460 200A 
     6462 8C00 
0420 6464 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 6466 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6468 0200 
     646A 0000 
0425 646C 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     646E 01C0 
     6470 0101 
0426 6472 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6474 02A0 
     6476 0101 
0427 6478 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     647A 00E0 
     647C 0101 
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
0445 647E C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 6480 C3A0  34         mov   @wyx,r14              ; Get YX
     6482 832A 
0447 6484 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 6486 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6488 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 648A C3A0  34         mov   @wyx,r14              ; Get YX
     648C 832A 
0454 648E 024E  22         andi  r14,>00ff             ; Remove Y
     6490 00FF 
0455 6492 A3CE  18         a     r14,r15               ; pos = pos + X
0456 6494 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6496 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 6498 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 649A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 649C 020F  20         li    r15,vdpw              ; VDP write address
     649E 8C00 
0463 64A0 045B  20         b     *r11
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
0478 64A2 C17B  30 putstr  mov   *r11+,tmp1
0479 64A4 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 64A6 C1CB  18 xutstr  mov   r11,tmp3
0481 64A8 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     64AA 2404 
0482 64AC C2C7  18         mov   tmp3,r11
0483 64AE 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 64B0 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 64B2 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 64B4 0286  22         ci    tmp2,255              ; Length > 255 ?
     64B6 00FF 
0491 64B8 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 64BA 0460  28         b     @xpym2v               ; Display string
     64BC 245A 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 64BE C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     64C0 FFCE 
0498 64C2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64C4 2030 
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
0514 64C6 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     64C8 832A 
0515 64CA 0460  28         b     @putstr
     64CC 2428 
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
0020 64CE C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 64D0 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 64D2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 64D4 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 64D6 1604  14         jne   !                     ; No, continue
0028               
0029 64D8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64DA FFCE 
0030 64DC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64DE 2030 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 64E0 0264  22 !       ori   tmp0,>4000
     64E2 4000 
0035 64E4 06C4  14         swpb  tmp0
0036 64E6 D804  38         movb  tmp0,@vdpa
     64E8 8C02 
0037 64EA 06C4  14         swpb  tmp0
0038 64EC D804  38         movb  tmp0,@vdpa
     64EE 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 64F0 020F  20         li    r15,vdpw              ; Set VDP write address
     64F2 8C00 
0043 64F4 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     64F6 2484 
     64F8 8320 
0044 64FA 0460  28         b     @mcloop               ; Write data to VDP and return
     64FC 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 64FE D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6500 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6502 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6504 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6506 06C4  14 xpyv2m  swpb  tmp0
0027 6508 D804  38         movb  tmp0,@vdpa
     650A 8C02 
0028 650C 06C4  14         swpb  tmp0
0029 650E D804  38         movb  tmp0,@vdpa
     6510 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6512 020F  20         li    r15,vdpr              ; Set VDP read address
     6514 8800 
0034 6516 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6518 24A6 
     651A 8320 
0035 651C 0460  28         b     @mcloop               ; Read data from VDP
     651E 8320 
0036 6520 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6522 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6524 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6526 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6528 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 652A 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 652C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     652E FFCE 
0034 6530 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6532 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6534 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6536 0001 
0039 6538 1603  14         jne   cpym0                 ; No, continue checking
0040 653A DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 653C 04C6  14         clr   tmp2                  ; Reset counter
0042 653E 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6540 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6542 7FFF 
0047 6544 C1C4  18         mov   tmp0,tmp3
0048 6546 0247  22         andi  tmp3,1
     6548 0001 
0049 654A 1618  14         jne   cpyodd                ; Odd source address handling
0050 654C C1C5  18 cpym1   mov   tmp1,tmp3
0051 654E 0247  22         andi  tmp3,1
     6550 0001 
0052 6552 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 6554 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6556 202A 
0057 6558 1605  14         jne   cpym3
0058 655A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     655C 2508 
     655E 8320 
0059 6560 0460  28         b     @mcloop               ; Copy memory and exit
     6562 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 6564 C1C6  18 cpym3   mov   tmp2,tmp3
0064 6566 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6568 0001 
0065 656A 1301  14         jeq   cpym4
0066 656C 0606  14         dec   tmp2                  ; Make TMP2 even
0067 656E CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 6570 0646  14         dect  tmp2
0069 6572 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 6574 C1C7  18         mov   tmp3,tmp3
0074 6576 1301  14         jeq   cpymz
0075 6578 D554  38         movb  *tmp0,*tmp1
0076 657A 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 657C 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     657E 8000 
0081 6580 10E9  14         jmp   cpym2
0082 6582 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 6584 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 6586 0649  14         dect  stack
0065 6588 C64B  30         mov   r11,*stack            ; Push return address
0066 658A 0649  14         dect  stack
0067 658C C640  30         mov   r0,*stack             ; Push r0
0068 658E 0649  14         dect  stack
0069 6590 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 6592 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 6594 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 6596 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     6598 4000 
0077 659A C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     659C 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 659E 020C  20         li    r12,>1e00             ; SAMS CRU address
     65A0 1E00 
0082 65A2 04C0  14         clr   r0
0083 65A4 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 65A6 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 65A8 D100  18         movb  r0,tmp0
0086 65AA 0984  56         srl   tmp0,8                ; Right align
0087 65AC C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     65AE 833C 
0088 65B0 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 65B2 C339  30         mov   *stack+,r12           ; Pop r12
0094 65B4 C039  30         mov   *stack+,r0            ; Pop r0
0095 65B6 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 65B8 045B  20         b     *r11                  ; Return to caller
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
0131 65BA C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 65BC C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 65BE 0649  14         dect  stack
0135 65C0 C64B  30         mov   r11,*stack            ; Push return address
0136 65C2 0649  14         dect  stack
0137 65C4 C640  30         mov   r0,*stack             ; Push r0
0138 65C6 0649  14         dect  stack
0139 65C8 C64C  30         mov   r12,*stack            ; Push r12
0140 65CA 0649  14         dect  stack
0141 65CC C644  30         mov   tmp0,*stack           ; Push tmp0
0142 65CE 0649  14         dect  stack
0143 65D0 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 65D2 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 65D4 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 65D6 0284  22         ci    tmp0,255              ; Crash if page > 255
     65D8 00FF 
0153 65DA 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 65DC 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     65DE 001E 
0158 65E0 150A  14         jgt   !
0159 65E2 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     65E4 0004 
0160 65E6 1107  14         jlt   !
0161 65E8 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     65EA 0012 
0162 65EC 1508  14         jgt   sams.page.set.switch_page
0163 65EE 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65F0 0006 
0164 65F2 1501  14         jgt   !
0165 65F4 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 65F6 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65F8 FFCE 
0170 65FA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65FC 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 65FE 020C  20         li    r12,>1e00             ; SAMS CRU address
     6600 1E00 
0176 6602 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 6604 06C0  14         swpb  r0                    ; LSB to MSB
0178 6606 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 6608 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     660A 4000 
0180 660C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 660E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 6610 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 6612 C339  30         mov   *stack+,r12           ; Pop r12
0188 6614 C039  30         mov   *stack+,r0            ; Pop r0
0189 6616 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 6618 045B  20         b     *r11                  ; Return to caller
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
0204 661A 020C  20         li    r12,>1e00             ; SAMS CRU address
     661C 1E00 
0205 661E 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 6620 045B  20         b     *r11                  ; Return to caller
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
0227 6622 020C  20         li    r12,>1e00             ; SAMS CRU address
     6624 1E00 
0228 6626 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 6628 045B  20         b     *r11                  ; Return to caller
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
0260 662A C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 662C 0649  14         dect  stack
0263 662E C64B  30         mov   r11,*stack            ; Save return address
0264 6630 0649  14         dect  stack
0265 6632 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 6634 0649  14         dect  stack
0267 6636 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 6638 0649  14         dect  stack
0269 663A C646  30         mov   tmp2,*stack           ; Save tmp2
0270 663C 0649  14         dect  stack
0271 663E C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 6640 0206  20         li    tmp2,8                ; Set loop counter
     6642 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 6644 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 6646 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 6648 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     664A 2544 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 664C 0606  14         dec   tmp2                  ; Next iteration
0288 664E 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 6650 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6652 25A0 
0294                                                   ; / activating changes.
0295               
0296 6654 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 6656 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 6658 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 665A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 665C C2F9  30         mov   *stack+,r11           ; Pop r11
0301 665E 045B  20         b     *r11                  ; Return to caller
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
0318 6660 0649  14         dect  stack
0319 6662 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 6664 06A0  32         bl    @sams.layout
     6666 25B0 
0324 6668 25F4                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 666A C2F9  30         mov   *stack+,r11           ; Pop r11
0330 666C 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 666E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6670 0002 
0336 6672 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6674 0003 
0337 6676 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6678 000A 
0338 667A B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     667C 000B 
0339 667E C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6680 000C 
0340 6682 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6684 000D 
0341 6686 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6688 000E 
0342 668A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     668C 000F 
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
0363 668E C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 6690 0649  14         dect  stack
0366 6692 C64B  30         mov   r11,*stack            ; Push return address
0367 6694 0649  14         dect  stack
0368 6696 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 6698 0649  14         dect  stack
0370 669A C645  30         mov   tmp1,*stack           ; Push tmp1
0371 669C 0649  14         dect  stack
0372 669E C646  30         mov   tmp2,*stack           ; Push tmp2
0373 66A0 0649  14         dect  stack
0374 66A2 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 66A4 0205  20         li    tmp1,sams.layout.copy.data
     66A6 264C 
0379 66A8 0206  20         li    tmp2,8                ; Set loop counter
     66AA 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 66AC C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 66AE 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     66B0 250C 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 66B2 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     66B4 833C 
0390               
0391 66B6 0606  14         dec   tmp2                  ; Next iteration
0392 66B8 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 66BA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 66BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 66BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 66C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 66C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 66C4 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 66C6 2000             data  >2000                 ; >2000-2fff
0408 66C8 3000             data  >3000                 ; >3000-3fff
0409 66CA A000             data  >a000                 ; >a000-afff
0410 66CC B000             data  >b000                 ; >b000-bfff
0411 66CE C000             data  >c000                 ; >c000-cfff
0412 66D0 D000             data  >d000                 ; >d000-dfff
0413 66D2 E000             data  >e000                 ; >e000-efff
0414 66D4 F000             data  >f000                 ; >f000-ffff
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
0009 66D6 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     66D8 FFBF 
0010 66DA 0460  28         b     @putv01
     66DC 2350 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 66DE 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     66E0 0040 
0018 66E2 0460  28         b     @putv01
     66E4 2350 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 66E6 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     66E8 FFDF 
0026 66EA 0460  28         b     @putv01
     66EC 2350 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 66EE 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66F0 0020 
0034 66F2 0460  28         b     @putv01
     66F4 2350 
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
0010 66F6 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66F8 FFFE 
0011 66FA 0460  28         b     @putv01
     66FC 2350 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66FE 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6700 0001 
0019 6702 0460  28         b     @putv01
     6704 2350 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6706 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6708 FFFD 
0027 670A 0460  28         b     @putv01
     670C 2350 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 670E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6710 0002 
0035 6712 0460  28         b     @putv01
     6714 2350 
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
0018 6716 C83B  50 at      mov   *r11+,@wyx
     6718 832A 
0019 671A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 671C B820  54 down    ab    @hb$01,@wyx
     671E 201C 
     6720 832A 
0028 6722 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6724 7820  54 up      sb    @hb$01,@wyx
     6726 201C 
     6728 832A 
0037 672A 045B  20         b     *r11
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
0049 672C C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 672E D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6730 832A 
0051 6732 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6734 832A 
0052 6736 045B  20         b     *r11
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
0021 6738 C120  34 yx2px   mov   @wyx,tmp0
     673A 832A 
0022 673C C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 673E 06C4  14         swpb  tmp0                  ; Y<->X
0024 6740 04C5  14         clr   tmp1                  ; Clear before copy
0025 6742 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6744 20A0  38         coc   @wbit1,config         ; f18a present ?
     6746 2028 
0030 6748 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 674A 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     674C 833A 
     674E 26FE 
0032 6750 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6752 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6754 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6756 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6758 0500 
0037 675A 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 675C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 675E 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6760 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6762 D105  18         movb  tmp1,tmp0
0051 6764 06C4  14         swpb  tmp0                  ; X<->Y
0052 6766 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6768 202A 
0053 676A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 676C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     676E 201C 
0059 6770 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6772 202E 
0060 6774 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6776 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6778 0050            data   80
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
0013 677A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 677C 06A0  32         bl    @putvr                ; Write once
     677E 233C 
0015 6780 391C             data  >391c                 ; VR1/57, value 00011100
0016 6782 06A0  32         bl    @putvr                ; Write twice
     6784 233C 
0017 6786 391C             data  >391c                 ; VR1/57, value 00011100
0018 6788 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 678A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 678C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     678E 233C 
0028 6790 391C             data  >391c
0029 6792 0458  20         b     *tmp4                 ; Exit
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
0040 6794 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6796 06A0  32         bl    @cpym2v
     6798 2454 
0042 679A 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     679C 275E 
     679E 0006 
0043 67A0 06A0  32         bl    @putvr
     67A2 233C 
0044 67A4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 67A6 06A0  32         bl    @putvr
     67A8 233C 
0046 67AA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 67AC 0204  20         li    tmp0,>3f00
     67AE 3F00 
0052 67B0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67B2 22C4 
0053 67B4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67B6 8800 
0054 67B8 0984  56         srl   tmp0,8
0055 67BA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67BC 8800 
0056 67BE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 67C0 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 67C2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67C4 BFFF 
0060 67C6 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 67C8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67CA 4000 
0063               f18chk_exit:
0064 67CC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     67CE 2298 
0065 67D0 3F00             data  >3f00,>00,6
     67D2 0000 
     67D4 0006 
0066 67D6 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 67D8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 67DA 3F00             data  >3f00                 ; 3f02 / 3f00
0073 67DC 0340             data  >0340                 ; 3f04   0340  idle
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
0092 67DE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 67E0 06A0  32         bl    @putvr
     67E2 233C 
0097 67E4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 67E6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67E8 233C 
0100 67EA 391C             data  >391c                 ; Lock the F18a
0101 67EC 0458  20         b     *tmp4                 ; Exit
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
0120 67EE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 67F0 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67F2 2028 
0122 67F4 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 67F6 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67F8 8802 
0127 67FA 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67FC 233C 
0128 67FE 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6800 04C4  14         clr   tmp0
0130 6802 D120  34         movb  @vdps,tmp0
     6804 8802 
0131 6806 0984  56         srl   tmp0,8
0132 6808 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 680A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     680C 832A 
0018 680E D17B  28         movb  *r11+,tmp1
0019 6810 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6812 D1BB  28         movb  *r11+,tmp2
0021 6814 0986  56         srl   tmp2,8                ; Repeat count
0022 6816 C1CB  18         mov   r11,tmp3
0023 6818 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     681A 2404 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 681C 020B  20         li    r11,hchar1
     681E 27AA 
0028 6820 0460  28         b     @xfilv                ; Draw
     6822 229E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6824 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6826 202C 
0033 6828 1302  14         jeq   hchar2                ; Yes, exit
0034 682A C2C7  18         mov   tmp3,r11
0035 682C 10EE  14         jmp   hchar                 ; Next one
0036 682E 05C7  14 hchar2  inct  tmp3
0037 6830 0457  20         b     *tmp3                 ; Exit
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
0016 6832 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6834 202A 
0017 6836 020C  20         li    r12,>0024
     6838 0024 
0018 683A 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     683C 2854 
0019 683E 04C6  14         clr   tmp2
0020 6840 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6842 04CC  14         clr   r12
0025 6844 1F08  20         tb    >0008                 ; Shift-key ?
0026 6846 1302  14         jeq   realk1                ; No
0027 6848 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     684A 2884 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 684C 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 684E 1302  14         jeq   realk2                ; No
0033 6850 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6852 28B4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6854 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6856 1302  14         jeq   realk3                ; No
0039 6858 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     685A 28E4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 685C 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     685E 2016 
0044 6860 1E15  20         sbz   >0015                 ; Set P5
0045 6862 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 6864 1302  14         jeq   realk4                ; No
0047 6866 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     6868 2016 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 686A 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 686C 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     686E 0006 
0053 6870 0606  14 realk5  dec   tmp2
0054 6872 020C  20         li    r12,>24               ; CRU address for P2-P4
     6874 0024 
0055 6876 06C6  14         swpb  tmp2
0056 6878 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 687A 06C6  14         swpb  tmp2
0058 687C 020C  20         li    r12,6                 ; CRU read address
     687E 0006 
0059 6880 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 6882 0547  14         inv   tmp3                  ;
0061 6884 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6886 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 6888 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 688A 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 688C 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 688E 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 6890 0285  22         ci    tmp1,8
     6892 0008 
0070 6894 1AFA  14         jl    realk6
0071 6896 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 6898 1BEB  14         jh    realk5                ; No, next column
0073 689A 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 689C C206  18 realk8  mov   tmp2,tmp4
0078 689E 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 68A0 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 68A2 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 68A4 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 68A6 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 68A8 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 68AA 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     68AC 2016 
0089 68AE 1608  14         jne   realka                ; No, continue saving key
0090 68B0 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     68B2 287E 
0091 68B4 1A05  14         jl    realka
0092 68B6 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     68B8 287C 
0093 68BA 1B02  14         jh    realka                ; No, continue
0094 68BC 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     68BE E000 
0095 68C0 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     68C2 833C 
0096 68C4 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     68C6 2014 
0097 68C8 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     68CA 8C00 
0098 68CC 045B  20         b     *r11                  ; Exit
0099               ********|*****|*********************|**************************
0100 68CE FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     68D0 0000 
     68D2 FF0D 
     68D4 203D 
0101 68D6 ....             text  'xws29ol.'
0102 68DE ....             text  'ced38ik,'
0103 68E6 ....             text  'vrf47ujm'
0104 68EE ....             text  'btg56yhn'
0105 68F6 ....             text  'zqa10p;/'
0106 68FE FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6900 0000 
     6902 FF0D 
     6904 202B 
0107 6906 ....             text  'XWS@(OL>'
0108 690E ....             text  'CED#*IK<'
0109 6916 ....             text  'VRF$&UJM'
0110 691E ....             text  'BTG%^YHN'
0111 6926 ....             text  'ZQA!)P:-'
0112 692E FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6930 0000 
     6932 FF0D 
     6934 2005 
0113 6936 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6938 0804 
     693A 0F27 
     693C C2B9 
0114 693E 600B             data  >600b,>0907,>063f,>c1B8
     6940 0907 
     6942 063F 
     6944 C1B8 
0115 6946 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6948 7B02 
     694A 015F 
     694C C0C3 
0116 694E BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6950 7D0E 
     6952 0CC6 
     6954 BFC4 
0117 6956 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6958 7C03 
     695A BC22 
     695C BDBA 
0118 695E FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6960 0000 
     6962 FF0D 
     6964 209D 
0119 6966 9897             data  >9897,>93b2,>9f8f,>8c9B
     6968 93B2 
     696A 9F8F 
     696C 8C9B 
0120 696E 8385             data  >8385,>84b3,>9e89,>8b80
     6970 84B3 
     6972 9E89 
     6974 8B80 
0121 6976 9692             data  >9692,>86b4,>b795,>8a8D
     6978 86B4 
     697A B795 
     697C 8A8D 
0122 697E 8294             data  >8294,>87b5,>b698,>888E
     6980 87B5 
     6982 B698 
     6984 888E 
0123 6986 9A91             data  >9a91,>81b1,>b090,>9cBB
     6988 81B1 
     698A B090 
     698C 9CBB 
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
0023 698E C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6990 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6992 8340 
0025 6994 04E0  34         clr   @waux1
     6996 833C 
0026 6998 04E0  34         clr   @waux2
     699A 833E 
0027 699C 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     699E 833C 
0028 69A0 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 69A2 0205  20         li    tmp1,4                ; 4 nibbles
     69A4 0004 
0033 69A6 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 69A8 0246  22         andi  tmp2,>000f            ; Only keep LSN
     69AA 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 69AC 0286  22         ci    tmp2,>000a
     69AE 000A 
0039 69B0 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 69B2 C21B  26         mov   *r11,tmp4
0045 69B4 0988  56         srl   tmp4,8                ; Right justify
0046 69B6 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     69B8 FFF6 
0047 69BA 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 69BC C21B  26         mov   *r11,tmp4
0054 69BE 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     69C0 00FF 
0055               
0056 69C2 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 69C4 06C6  14         swpb  tmp2
0058 69C6 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 69C8 0944  56         srl   tmp0,4                ; Next nibble
0060 69CA 0605  14         dec   tmp1
0061 69CC 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 69CE 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     69D0 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 69D2 C160  34         mov   @waux3,tmp1           ; Get pointer
     69D4 8340 
0067 69D6 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 69D8 0585  14         inc   tmp1                  ; Next byte, not word!
0069 69DA C120  34         mov   @waux2,tmp0
     69DC 833E 
0070 69DE 06C4  14         swpb  tmp0
0071 69E0 DD44  32         movb  tmp0,*tmp1+
0072 69E2 06C4  14         swpb  tmp0
0073 69E4 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 69E6 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     69E8 8340 
0078 69EA D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     69EC 2020 
0079 69EE 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 69F0 C120  34         mov   @waux1,tmp0
     69F2 833C 
0084 69F4 06C4  14         swpb  tmp0
0085 69F6 DD44  32         movb  tmp0,*tmp1+
0086 69F8 06C4  14         swpb  tmp0
0087 69FA DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 69FC 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     69FE 202A 
0092 6A00 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6A02 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6A04 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6A06 7FFF 
0098 6A08 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6A0A 8340 
0099 6A0C 0460  28         b     @xutst0               ; Display string
     6A0E 242A 
0100 6A10 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6A12 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6A14 832A 
0122 6A16 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6A18 8000 
0123 6A1A 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6A1C 0207  20 mknum   li    tmp3,5                ; Digit counter
     6A1E 0005 
0020 6A20 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6A22 C155  26         mov   *tmp1,tmp1            ; /
0022 6A24 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6A26 0228  22         ai    tmp4,4                ; Get end of buffer
     6A28 0004 
0024 6A2A 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6A2C 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6A2E 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6A30 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6A32 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6A34 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6A36 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6A38 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 6A3A 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6A3C 0607  14         dec   tmp3                  ; Decrease counter
0036 6A3E 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6A40 0207  20         li    tmp3,4                ; Check first 4 digits
     6A42 0004 
0041 6A44 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6A46 C11B  26         mov   *r11,tmp0
0043 6A48 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6A4A 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6A4C 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6A4E 05CB  14 mknum3  inct  r11
0047 6A50 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6A52 202A 
0048 6A54 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6A56 045B  20         b     *r11                  ; Exit
0050 6A58 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6A5A 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6A5C 13F8  14         jeq   mknum3                ; Yes, exit
0053 6A5E 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6A60 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6A62 7FFF 
0058 6A64 C10B  18         mov   r11,tmp0
0059 6A66 0224  22         ai    tmp0,-4
     6A68 FFFC 
0060 6A6A C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6A6C 0206  20         li    tmp2,>0500            ; String length = 5
     6A6E 0500 
0062 6A70 0460  28         b     @xutstr               ; Display string
     6A72 242C 
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
0083               *  Before...:   XXXXX
0084               *  After....:   XXXXX|zY       where length byte z=1
0085               *               XXXXX|zYY      where length byte z=2
0086               *                 ..
0087               *               XXXXX|zYYYYY   where length byte z=5
0088               *--------------------------------------------------------------
0089               *  Destroys registers tmp0-tmp3
0090               ********|*****|*********************|**************************
0091               trimnum:
0092 6A74 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6A76 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6A78 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6A7A 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6A7C 0207  20         li    tmp3,5                ; Set counter
     6A7E 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6A80 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6A82 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6A84 0584  14         inc   tmp0                  ; Next character
0104 6A86 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6A88 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6A8A 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6A8C 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6A8E DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6A90 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6A92 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6A94 0607  14         dec   tmp3                  ; Last character ?
0120 6A96 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6A98 045B  20         b     *r11                  ; Return
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * PUTNUM - Put unsigned number on screen
0128               ***************************************************************
0129               *  BL   @PUTNUM
0130               *  DATA P0,P1,P2,P3
0131               *--------------------------------------------------------------
0132               *  P0   = YX position
0133               *  P1   = Pointer to 16 bit unsigned number
0134               *  P2   = Pointer to 5 byte string buffer
0135               *  P3HB = Offset for ASCII digit
0136               *  P3LB = Character for replacing leading 0's
0137               ********|*****|*********************|**************************
0138 6A9A C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6A9C 832A 
0139 6A9E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6AA0 8000 
0140 6AA2 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 6AA4 0649  14         dect  stack
0023 6AA6 C64B  30         mov   r11,*stack            ; Save return address
0024 6AA8 0649  14         dect  stack
0025 6AAA C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6AAC 0649  14         dect  stack
0027 6AAE C645  30         mov   tmp1,*stack           ; Push tmp1
0028 6AB0 0649  14         dect  stack
0029 6AB2 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 6AB4 0649  14         dect  stack
0031 6AB6 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 6AB8 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 6ABA C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 6ABC C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 6ABE 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 6AC0 0649  14         dect  stack
0044 6AC2 C64B  30         mov   r11,*stack            ; Save return address
0045 6AC4 0649  14         dect  stack
0046 6AC6 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 6AC8 0649  14         dect  stack
0048 6ACA C645  30         mov   tmp1,*stack           ; Push tmp1
0049 6ACC 0649  14         dect  stack
0050 6ACE C646  30         mov   tmp2,*stack           ; Push tmp2
0051 6AD0 0649  14         dect  stack
0052 6AD2 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 6AD4 C1D4  26 !       mov   *tmp0,tmp3
0057 6AD6 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 6AD8 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     6ADA 00FF 
0059 6ADC 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 6ADE 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 6AE0 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 6AE2 0584  14         inc   tmp0                  ; Next byte
0067 6AE4 0607  14         dec   tmp3                  ; Shorten string length
0068 6AE6 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 6AE8 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 6AEA 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 6AEC C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 6AEE 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 6AF0 C187  18         mov   tmp3,tmp2
0078 6AF2 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 6AF4 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 6AF6 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     6AF8 24AE 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 6AFA 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 6AFC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AFE FFCE 
0090 6B00 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B02 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 6B04 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 6B06 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 6B08 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 6B0A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 6B0C C2F9  30         mov   *stack+,r11           ; Pop r11
0100 6B0E 045B  20         b     *r11                  ; Return to caller
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
0123 6B10 0649  14         dect  stack
0124 6B12 C64B  30         mov   r11,*stack            ; Save return address
0125 6B14 05D9  26         inct  *stack                ; Skip "data P0"
0126 6B16 05D9  26         inct  *stack                ; Skip "data P1"
0127 6B18 0649  14         dect  stack
0128 6B1A C644  30         mov   tmp0,*stack           ; Push tmp0
0129 6B1C 0649  14         dect  stack
0130 6B1E C645  30         mov   tmp1,*stack           ; Push tmp1
0131 6B20 0649  14         dect  stack
0132 6B22 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 6B24 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 6B26 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 6B28 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 6B2A 0649  14         dect  stack
0144 6B2C C64B  30         mov   r11,*stack            ; Save return address
0145 6B2E 0649  14         dect  stack
0146 6B30 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 6B32 0649  14         dect  stack
0148 6B34 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 6B36 0649  14         dect  stack
0150 6B38 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 6B3A 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 6B3C 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 6B3E 0586  14         inc   tmp2
0161 6B40 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 6B42 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 6B44 0286  22         ci    tmp2,255
     6B46 00FF 
0167 6B48 1505  14         jgt   string.getlenc.panic
0168 6B4A 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 6B4C 0606  14         dec   tmp2                  ; One time adjustment
0174 6B4E C806  38         mov   tmp2,@waux1           ; Store length
     6B50 833C 
0175 6B52 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 6B54 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B56 FFCE 
0181 6B58 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B5A 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 6B5C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 6B5E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 6B60 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 6B62 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 6B64 045B  20         b     *r11                  ; Return to caller
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
0056 6B66 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 6B68 2AF0             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 6B6A C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 6B6C C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     6B6E A428 
0064 6B70 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     6B72 2026 
0065 6B74 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     6B76 8356 
0066 6B78 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 6B7A 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     6B7C FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 6B7E C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     6B80 A434 
0073                       ;---------------------------; Inline VSBR start
0074 6B82 06C0  14         swpb  r0                    ;
0075 6B84 D800  38         movb  r0,@vdpa              ; Send low byte
     6B86 8C02 
0076 6B88 06C0  14         swpb  r0                    ;
0077 6B8A D800  38         movb  r0,@vdpa              ; Send high byte
     6B8C 8C02 
0078 6B8E D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     6B90 8800 
0079                       ;---------------------------; Inline VSBR end
0080 6B92 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 6B94 0704  14         seto  r4                    ; Init counter
0086 6B96 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B98 A420 
0087 6B9A 0580  14 !       inc   r0                    ; Point to next char of name
0088 6B9C 0584  14         inc   r4                    ; Increment char counter
0089 6B9E 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     6BA0 0007 
0090 6BA2 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 6BA4 80C4  18         c     r4,r3                 ; End of name?
0093 6BA6 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 6BA8 06C0  14         swpb  r0                    ;
0098 6BAA D800  38         movb  r0,@vdpa              ; Send low byte
     6BAC 8C02 
0099 6BAE 06C0  14         swpb  r0                    ;
0100 6BB0 D800  38         movb  r0,@vdpa              ; Send high byte
     6BB2 8C02 
0101 6BB4 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     6BB6 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 6BB8 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 6BBA 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     6BBC 2C58 
0109 6BBE 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 6BC0 C104  18         mov   r4,r4                 ; Check if length = 0
0115 6BC2 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 6BC4 04E0  34         clr   @>83d0
     6BC6 83D0 
0118 6BC8 C804  38         mov   r4,@>8354             ; Save name length for search (length
     6BCA 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 6BCC C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     6BCE A432 
0121               
0122 6BD0 0584  14         inc   r4                    ; Adjust for dot
0123 6BD2 A804  38         a     r4,@>8356             ; Point to position after name
     6BD4 8356 
0124 6BD6 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     6BD8 8356 
     6BDA A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 6BDC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6BDE 83E0 
0130 6BE0 04C1  14         clr   r1                    ; Version found of dsr
0131 6BE2 020C  20         li    r12,>0f00             ; Init cru address
     6BE4 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 6BE6 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 6BE8 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 6BEA 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 6BEC 022C  22         ai    r12,>0100             ; Next ROM to turn on
     6BEE 0100 
0145 6BF0 04E0  34         clr   @>83d0                ; Clear in case we are done
     6BF2 83D0 
0146 6BF4 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6BF6 2000 
0147 6BF8 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 6BFA C80C  38         mov   r12,@>83d0            ; Save address of next cru
     6BFC 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 6BFE 1D00  20         sbo   0                     ; Turn on ROM
0154 6C00 0202  20         li    r2,>4000              ; Start at beginning of ROM
     6C02 4000 
0155 6C04 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     6C06 2C54 
0156 6C08 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 6C0A A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     6C0C A40A 
0166 6C0E 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 6C10 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6C12 83D2 
0172                                                   ; subprogram
0173               
0174 6C14 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 6C16 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 6C18 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 6C1A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6C1C 83D2 
0183                                                   ; subprogram
0184               
0185 6C1E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 6C20 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 6C22 04C5  14         clr   r5                    ; Remove any old stuff
0194 6C24 D160  34         movb  @>8355,r5             ; Get length as counter
     6C26 8355 
0195 6C28 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 6C2A 9C85  32         cb    r5,*r2+               ; See if length matches
0200 6C2C 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 6C2E 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 6C30 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6C32 A420 
0206 6C34 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 6C36 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 6C38 0605  14         dec   r5                    ; Update loop counter
0211 6C3A 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 6C3C 0581  14         inc   r1                    ; Next version found
0217 6C3E C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     6C40 A42A 
0218 6C42 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     6C44 A42C 
0219 6C46 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     6C48 A430 
0220               
0221 6C4A 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6C4C 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 6C4E 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 6C50 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 6C52 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 6C54 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6C56 A400 
0233 6C58 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 6C5A C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6C5C A428 
0239                                                   ; (8 or >a)
0240 6C5E 0281  22         ci    r1,8                  ; was it 8?
     6C60 0008 
0241 6C62 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 6C64 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6C66 8350 
0243                                                   ; Get error byte from @>8350
0244 6C68 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 6C6A 06C0  14         swpb  r0                    ;
0252 6C6C D800  38         movb  r0,@vdpa              ; send low byte
     6C6E 8C02 
0253 6C70 06C0  14         swpb  r0                    ;
0254 6C72 D800  38         movb  r0,@vdpa              ; send high byte
     6C74 8C02 
0255 6C76 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6C78 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 6C7A 09D1  56         srl   r1,13                 ; just keep error bits
0263 6C7C 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 6C7E 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 6C80 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 6C82 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6C84 A400 
0275               dsrlnk.error.devicename_invalid:
0276 6C86 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 6C88 06C1  14         swpb  r1                    ; put error in hi byte
0279 6C8A D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 6C8C F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     6C8E 2026 
0281                                                   ; / to indicate error
0282 6C90 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 6C92 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 6C94 2C1C             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 6C96 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6C98 83E0 
0316               
0317 6C9A 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     6C9C 2026 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 6C9E 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     6CA0 A42A 
0322 6CA2 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 6CA4 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 6CA6 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     6CA8 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 6CAA C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 6CAC C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     6CAE 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 6CB0 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     6CB2 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 6CB4 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 6CB6 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     6CB8 4000 
     6CBA 2C54 
0337 6CBC 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 6CBE 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 6CC0 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 6CC2 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 6CC4 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     6CC6 A400 
0355 6CC8 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     6CCA A434 
0356               
0357 6CCC 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 6CCE AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 6CD0 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 6CD2 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 6CD4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 6CD6 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 6CD8 0649  14         dect  stack
0052 6CDA C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 6CDC 0204  20         li    tmp0,dsrlnk.savcru
     6CDE A42A 
0057 6CE0 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 6CE2 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 6CE4 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 6CE6 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 6CE8 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     6CEA 37D7 
0065 6CEC C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     6CEE 8370 
0066                                                   ; / location
0067 6CF0 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     6CF2 A44C 
0068 6CF4 04C5  14         clr   tmp1                  ; io.op.open
0069 6CF6 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 6CF8 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 6CFA 0649  14         dect  stack
0097 6CFC C64B  30         mov   r11,*stack            ; Save return address
0098 6CFE 0205  20         li    tmp1,io.op.close      ; io.op.close
     6D00 0001 
0099 6D02 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 6D04 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 6D06 0649  14         dect  stack
0125 6D08 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 6D0A 0205  20         li    tmp1,io.op.read       ; io.op.read
     6D0C 0002 
0128 6D0E 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 6D10 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 6D12 0649  14         dect  stack
0155 6D14 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 6D16 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 6D18 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     6D1A 0005 
0159               
0160 6D1C C160  34         mov   @fh.reclen,tmp1       ; Get record length
     6D1E A43E 
0161               
0162 6D20 06A0  32         bl    @xvputb               ; Write character count to PAB
     6D22 22D6 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 6D24 0205  20         li    tmp1,io.op.write      ; io.op.write
     6D26 0003 
0167 6D28 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 6D2A 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 6D2C 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 6D2E 1000  14         nop
0181               
0182               
0183               file.delete:
0184 6D30 1000  14         nop
0185               
0186               
0187               file.rename:
0188 6D32 1000  14         nop
0189               
0190               
0191               file.status:
0192 6D34 1000  14         nop
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
0227 6D36 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     6D38 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 6D3A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 6D3C A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     6D3E A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 6D40 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     6D42 22D6 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 6D44 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 6D46 0584  14         inc   tmp0                  ; Next byte in PAB
0245 6D48 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     6D4A A44C 
0246               
0247 6D4C 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     6D4E 22D6 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 6D50 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     6D52 0009 
0254 6D54 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6D56 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 6D58 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     6D5A 8322 
     6D5C 833C 
0259               
0260 6D5E C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     6D60 A42A 
0261 6D62 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 6D64 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6D66 2AEC 
0268 6D68 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 6D6A 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 6D6C 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     6D6E 2C18 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 6D70 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 6D72 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     6D74 833C 
     6D76 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 6D78 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     6D7A A436 
0292 6D7C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6D7E 0005 
0293 6D80 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6D82 22EE 
0294 6D84 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 6D86 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 6D88 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 6D8A 045B  20         b     *r11                  ; Return to caller
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
0011               *  This is basically the kernel keeping everything togehter.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 6D8C 0300  24 tmgr    limi  0                     ; No interrupt processing
     6D8E 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6D90 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6D92 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6D94 2360  38         coc   @wbit2,r13            ; C flag on ?
     6D96 2026 
0029 6D98 1602  14         jne   tmgr1a                ; No, so move on
0030 6D9A E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6D9C 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6D9E 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6DA0 202A 
0035 6DA2 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6DA4 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6DA6 201A 
0048 6DA8 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6DAA 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6DAC 2018 
0050 6DAE 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6DB0 0460  28         b     @kthread              ; Run kernel thread
     6DB2 2DB0 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6DB4 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6DB6 201E 
0056 6DB8 13EB  14         jeq   tmgr1
0057 6DBA 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6DBC 201C 
0058 6DBE 16E8  14         jne   tmgr1
0059 6DC0 C120  34         mov   @wtiusr,tmp0
     6DC2 832E 
0060 6DC4 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6DC6 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6DC8 2DAE 
0065 6DCA C10A  18         mov   r10,tmp0
0066 6DCC 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6DCE 00FF 
0067 6DD0 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6DD2 2026 
0068 6DD4 1303  14         jeq   tmgr5
0069 6DD6 0284  22         ci    tmp0,60               ; 1 second reached ?
     6DD8 003C 
0070 6DDA 1002  14         jmp   tmgr6
0071 6DDC 0284  22 tmgr5   ci    tmp0,50
     6DDE 0032 
0072 6DE0 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6DE2 1001  14         jmp   tmgr8
0074 6DE4 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6DE6 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6DE8 832C 
0079 6DEA 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6DEC FF00 
0080 6DEE C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6DF0 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6DF2 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6DF4 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6DF6 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6DF8 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6DFA 830C 
     6DFC 830D 
0089 6DFE 1608  14         jne   tmgr10                ; No, get next slot
0090 6E00 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E02 FF00 
0091 6E04 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E06 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E08 8330 
0096 6E0A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6E0C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6E0E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6E10 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6E12 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6E14 8315 
     6E16 8314 
0103 6E18 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6E1A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6E1C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6E1E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6E20 10F7  14         jmp   tmgr10                ; Process next slot
0108 6E22 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6E24 FF00 
0109 6E26 10B4  14         jmp   tmgr1
0110 6E28 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6E2A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6E2C 201A 
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
0041 6E2E 06A0  32         bl    @realkb               ; Scan full keyboard
     6E30 27B8 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6E32 0460  28         b     @tmgr3                ; Exit
     6E34 2D3A 
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
0017 6E36 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6E38 832E 
0018 6E3A E0A0  34         soc   @wbit7,config         ; Enable user hook
     6E3C 201C 
0019 6E3E 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D16     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6E40 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6E42 832E 
0029 6E44 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E46 FEFF 
0030 6E48 045B  20         b     *r11                  ; Return
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
0017 6E4A C13B  30 mkslot  mov   *r11+,tmp0
0018 6E4C C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E4E C184  18         mov   tmp0,tmp2
0023 6E50 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E52 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6E54 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6E56 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6E58 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6E5A C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6E5C 881B  46         c     *r11,@w$ffff          ; End of list ?
     6E5E 202C 
0035 6E60 1301  14         jeq   mkslo1                ; Yes, exit
0036 6E62 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6E64 05CB  14 mkslo1  inct  r11
0041 6E66 045B  20         b     *r11                  ; Exit
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
0052 6E68 C13B  30 clslot  mov   *r11+,tmp0
0053 6E6A 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6E6C A120  34         a     @wtitab,tmp0          ; Add table base
     6E6E 832C 
0055 6E70 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6E72 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6E74 045B  20         b     *r11                  ; Exit
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
0068 6E76 C13B  30 rsslot  mov   *r11+,tmp0
0069 6E78 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 6E7A A120  34         a     @wtitab,tmp0          ; Add table base
     6E7C 832C 
0071 6E7E 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 6E80 C154  26         mov   *tmp0,tmp1
0073 6E82 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     6E84 FF00 
0074 6E86 C505  30         mov   tmp1,*tmp0
0075 6E88 045B  20         b     *r11                  ; Exit
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
0260 6E8A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6E8C 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 6E8E 0300  24 runli1  limi  0                     ; Turn off interrupts
     6E90 0000 
0266 6E92 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6E94 8300 
0267 6E96 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6E98 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 6E9A 0202  20 runli2  li    r2,>8308
     6E9C 8308 
0272 6E9E 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 6EA0 0282  22         ci    r2,>8400
     6EA2 8400 
0274 6EA4 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 6EA6 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     6EA8 FFFF 
0279 6EAA 1602  14         jne   runli4                ; No, continue
0280 6EAC 0420  54         blwp  @0                    ; Yes, bye bye
     6EAE 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 6EB0 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6EB2 833C 
0285 6EB4 04C1  14         clr   r1                    ; Reset counter
0286 6EB6 0202  20         li    r2,10                 ; We test 10 times
     6EB8 000A 
0287 6EBA C0E0  34 runli5  mov   @vdps,r3
     6EBC 8802 
0288 6EBE 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6EC0 202A 
0289 6EC2 1302  14         jeq   runli6
0290 6EC4 0581  14         inc   r1                    ; Increase counter
0291 6EC6 10F9  14         jmp   runli5
0292 6EC8 0602  14 runli6  dec   r2                    ; Next test
0293 6ECA 16F7  14         jne   runli5
0294 6ECC 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6ECE 1250 
0295 6ED0 1202  14         jle   runli7                ; No, so it must be NTSC
0296 6ED2 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6ED4 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 6ED6 06A0  32 runli7  bl    @loadmc
     6ED8 2224 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 6EDA 04C1  14 runli9  clr   r1
0305 6EDC 04C2  14         clr   r2
0306 6EDE 04C3  14         clr   r3
0307 6EE0 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     6EE2 3000 
0308 6EE4 020F  20         li    r15,vdpw              ; Set VDP write address
     6EE6 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 6EE8 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6EEA 4A4A 
0317 6EEC 1605  14         jne   runlia
0318 6EEE 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6EF0 2298 
0319 6EF2 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     6EF4 0000 
     6EF6 3000 
0324 6EF8 06A0  32 runlia  bl    @filv
     6EFA 2298 
0325 6EFC 0FC0             data  pctadr,spfclr,16      ; Load color table
     6EFE 00F4 
     6F00 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 6F02 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F04 2700 
0333 6F06 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F08 271A 
0334 6F0A 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F0C 2710 
0335               
0336 6F0E 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     6F10 233C 
0337 6F12 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 6F14 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F16 2302 
0351 6F18 3008             data  spvmod                ; Equate selected video mode table
0352 6F1A 0204  20         li    tmp0,spfont           ; Get font option
     6F1C 000C 
0353 6F1E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 6F20 1304  14         jeq   runlid                ; Yes, skip it
0355 6F22 06A0  32         bl    @ldfnt
     6F24 236A 
0356 6F26 1100             data  fntadr,spfont         ; Load specified font
     6F28 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 6F2A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6F2C 4A4A 
0361 6F2E 1602  14         jne   runlie                ; No, continue
0362 6F30 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6F32 2090 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 6F34 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6F36 0040 
0367 6F38 0460  28         b     @main                 ; Give control to main program
     6F3A 3000 
**** **** ****     > stevie_b0.asm.157677
0116                                                   ; Spectra 2
0117                       ;------------------------------------------------------
0118                       ; End of File marker
0119                       ;------------------------------------------------------
0120 6F3C DEAD             data  >dead,>beef,>dead,>beef
     6F3E BEEF 
     6F40 DEAD 
     6F42 BEEF 
0122               
0126 6F44 2ECA                   data $                ; Bank 0 ROM size OK.
0128               
0129 6F46 ....             bss  300                    ; Fill remaining space with >00
0130               
0131               ***************************************************************
0132               * Code data: Relocated Stevie modules >3000 - >3fff (4K max)
0133               ********|*****|*********************|**************************
0134               reloc.stevie:
0135                       xorg  >3000                 ; Relocate Stevie modules to >3000
0136                       ;------------------------------------------------------
0137                       ; Activate bank 1 and branch to >6036
0138                       ;------------------------------------------------------
0139               main:
0140 7072 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
     7074 6002 
0141 7076 0460  28         b     @kickstart.code2      ; Jump to entry routine
     7078 6036 
0142                       ;------------------------------------------------------
0143                       ; Resident Stevie modules >3000 - >3fff
0144                       ;------------------------------------------------------
0145                       copy  "data.constants.asm"  ; Data Constants
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
0033 707A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     707C 003F 
     707E 0243 
     7080 05F4 
     7082 0050 
0034               
0035               romsat:
0036 7084 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     7086 0001 
0037               
0038               cursors:
0039 7088 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     708A 0000 
     708C 0000 
     708E 001C 
0040 7090 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 2 - Insert mode
     7092 1C1C 
     7094 1C1C 
     7096 1C00 
0041 7098 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     709A 1C1C 
     709C 1C1C 
     709E 1C00 
0042               
0043               patterns:
0044 70A0 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     70A2 0000 
     70A4 00FF 
     70A6 0000 
0045 70A8 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     70AA 0000 
     70AC FF00 
     70AE FF00 
0046               
0047               patterns.box:
0048 70B0 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     70B2 0000 
     70B4 FF00 
     70B6 FF00 
0049 70B8 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     70BA 0000 
     70BC FF80 
     70BE BFA0 
0050 70C0 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     70C2 0000 
     70C4 FC04 
     70C6 F414 
0051 70C8 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     70CA A0A0 
     70CC A0A0 
     70CE A0A0 
0052 70D0 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     70D2 1414 
     70D4 1414 
     70D6 1414 
0053 70D8 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     70DA A0A0 
     70DC BF80 
     70DE FF00 
0054 70E0 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     70E2 1414 
     70E4 F404 
     70E6 FC00 
0055 70E8 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     70EA C0C0 
     70EC C0C0 
     70EE 0080 
0056 70F0 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     70F2 0F0F 
     70F4 0F0F 
     70F6 0000 
0057               
0058               alphalock:
0059 70F8 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 12. down
     70FA 00E0 
     70FC E0E0 
     70FE E0E0 
0060 7100 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 13. up
     7102 E0E0 
     7104 E0E0 
     7106 0000 
0061               
0062               
0063               ***************************************************************
0064               * SAMS page layout table for Stevie (16 words)
0065               *--------------------------------------------------------------
0066               mem.sams.layout.data:
0067 7108 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     710A 0002 
0068 710C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     710E 0003 
0069 7110 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7112 000A 
0070               
0071 7114 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     7116 0010 
0072                                                   ; \ The index can allocate
0073                                                   ; / pages >10 to >2f.
0074               
0075 7118 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     711A 0030 
0076                                                   ; \ Editor buffer can allocate
0077                                                   ; / pages >30 to >ff.
0078               
0079 711C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     711E 000D 
0080 7120 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7122 000E 
0081 7124 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7126 000F 
0082               
0083               
0084               
0085               
0086               
0087               ***************************************************************
0088               * Stevie color schemes table
0089               *--------------------------------------------------------------
0090               * Word 1
0091               *    MSB  high-nibble    Foreground color frame buffer
0092               *    MSB  low-nibble     Background color frame buffer
0093               *    LSB  high-nibble    Foreground color bottom line pane
0094               *    LSB  low-nibble     Background color bottom line pane
0095               *
0096               * Word 2
0097               *    MSB  high-nibble    Foreground color cmdb pane
0098               *    MSB  low-nibble     Background color cmdb pane
0099               *    LSB  high-nibble    0
0100               *    LSB  low-nibble     Cursor foreground color
0101               *--------------------------------------------------------------
0102      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0103               
0104               tv.colorscheme.table:
0105                                        ; #  Framebuffer        | Status line        | CMDB
0106                                        ; ----------------------|--------------------|---------
0107 7128 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     712A F001 
0108 712C F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     712E F00F 
0109 7130 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     7132 F00F 
0110 7134 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     7136 F00F 
0111 7138 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     713A F00F 
0112 713C 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     713E 1006 
0113 7140 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     7142 1001 
0114 7144 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     7146 1A0F 
0115 7148 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     714A F20F 
0116               
**** **** ****     > stevie_b0.asm.157677
0146                       copy  "data.strings.asm"    ; Data segment - Strings
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
0011               txt.wp.program
0012 714C 0C53             byte  12
0013 714D ....             text  'Stevie v0.1a'
0014                       even
0015               
0016               txt.wp.purpose
0017 715A 2350             byte  35
0018 715B ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.wp.author
0022 717E 1D32             byte  29
0023 717F ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.wp.website
0027 719C 1B68             byte  27
0028 719D ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.wp.build
0032 71B8 1442             byte  20
0033 71B9 ....             text  'Build: 200906-157677'
0034                       even
0035               
0036               
0037               txt.wp.msg1
0038 71CE 2446             byte  36
0039 71CF ....             text  'FCTN-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.wp.msg2
0043 71F4 2246             byte  34
0044 71F5 ....             text  'FCTN-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.wp.msg3
0048 7218 1946             byte  25
0049 7219 ....             text  'FCTN-+        Quit Stevie'
0050                       even
0051               
0052               txt.wp.msg4
0053 7232 1C43             byte  28
0054 7233 ....             text  'CTRL-L (^L)   Load DV80 file'
0055                       even
0056               
0057               txt.wp.msg5
0058 7250 1C43             byte  28
0059 7251 ....             text  'CTRL-K (^K)   Save DV80 file'
0060                       even
0061               
0062               txt.wp.msg6
0063 726E 1A43             byte  26
0064 726F ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 728A 380D     txt.wp.msg7        byte    56,13
0069 728C ....                        text    ' ALPHA LOCK up     '
0070                                  byte    12
0071 72A0 ....                        text    ' ALPHA LOCK down   '
0072 72B3 ....                        text    '  * Text changed'
0073               
0074               txt.wp.msg8
0075                       byte  31
0076 72C4 ....             text  'Press ENTER to return to editor'
0077                       even
0078               
0079               
0080               
0081               
0082               ;--------------------------------------------------------------
0083               ; Strings for status line pane
0084               ;--------------------------------------------------------------
0085               txt.delim
0086 72E4 012C             byte  1
0087 72E5 ....             text  ','
0088                       even
0089               
0090               txt.marker
0091 72E6 052A             byte  5
0092 72E7 ....             text  '*EOF*'
0093                       even
0094               
0095               txt.bottom
0096 72EC 0520             byte  5
0097 72ED ....             text  '  BOT'
0098                       even
0099               
0100               txt.ovrwrite
0101 72F2 034F             byte  3
0102 72F3 ....             text  'OVR'
0103                       even
0104               
0105               txt.insert
0106 72F6 0349             byte  3
0107 72F7 ....             text  'INS'
0108                       even
0109               
0110               txt.star
0111 72FA 012A             byte  1
0112 72FB ....             text  '*'
0113                       even
0114               
0115               txt.loading
0116 72FC 0A4C             byte  10
0117 72FD ....             text  'Loading...'
0118                       even
0119               
0120               txt.saving
0121 7308 0953             byte  9
0122 7309 ....             text  'Saving...'
0123                       even
0124               
0125               txt.fastmode
0126 7312 0846             byte  8
0127 7313 ....             text  'FastMode'
0128                       even
0129               
0130               txt.kb
0131 731C 026B             byte  2
0132 731D ....             text  'kb'
0133                       even
0134               
0135               txt.lines
0136 7320 054C             byte  5
0137 7321 ....             text  'Lines'
0138                       even
0139               
0140               txt.bufnum
0141 7326 0323             byte  3
0142 7327 ....             text  '#1 '
0143                       even
0144               
0145               txt.newfile
0146 732A 0A5B             byte  10
0147 732B ....             text  '[New file]'
0148                       even
0149               
0150               txt.filetype.dv80
0151 7336 0444             byte  4
0152 7337 ....             text  'DV80'
0153                       even
0154               
0155               txt.filetype.none
0156 733C 0420             byte  4
0157 733D ....             text  '    '
0158                       even
0159               
0160               
0161 7342 010D     txt.alpha.up       data >010d
0162 7344 010C     txt.alpha.down     data >010c
0163               
0164               
0165               ;--------------------------------------------------------------
0166               ; Dialog Load DV 80 file
0167               ;--------------------------------------------------------------
0168               txt.head.load
0169 7346 0E4C             byte  14
0170 7347 ....             text  'Load DV80 file'
0171                       even
0172               
0173               txt.hint.load
0174 7356 3448             byte  52
0175 7357 ....             text  'HINT: Specify filename and press ENTER to load file.'
0176                       even
0177               
0178               txt.keys.load
0179 738C 4D46             byte  77
0180 738D ....             text  'F9=Back    F3=Clear    F5=FastMode    ^A=Home    ^F=End    ^,=Prev    ^.=Next'
0181                       even
0182               
0183               txt.keys.load2
0184 73DA 4D46             byte  77
0185 73DB ....             text  'F9=Back    F3=Clear   *F5=FastMode    ^A=Home    ^F=End    ^,=Prev    ^.=Next'
0186                       even
0187               
0188               
0189               ;--------------------------------------------------------------
0190               ; Dialog Save DV 80 file
0191               ;--------------------------------------------------------------
0192               txt.head.save
0193 7428 0E53             byte  14
0194 7429 ....             text  'Save DV80 file'
0195                       even
0196               
0197               txt.hint.save
0198 7438 3448             byte  52
0199 7439 ....             text  'HINT: Specify filename and press ENTER to save file.'
0200                       even
0201               
0202               txt.keys.save
0203 746E 2846             byte  40
0204 746F ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0205                       even
0206               
0207               
0208               ;--------------------------------------------------------------
0209               ; Dialog "Unsaved changes"
0210               ;--------------------------------------------------------------
0211               txt.head.unsaved
0212 7498 0F55             byte  15
0213 7499 ....             text  'Unsaved changes'
0214                       even
0215               
0216               txt.hint.unsaved
0217 74A8 2748             byte  39
0218 74A9 ....             text  'HINT: Unsaved changes in editor buffer.'
0219                       even
0220               
0221               txt.keys.unsaved
0222 74D0 2446             byte  36
0223 74D1 ....             text  'F9=Back    F6=Ignore    ^K=Save file'
0224                       even
0225               
0226               
0227               ;--------------------------------------------------------------
0228               ; Strings for error line pane
0229               ;--------------------------------------------------------------
0230               txt.ioerr.load
0231 74F6 2049             byte  32
0232 74F7 ....             text  'I/O error. Failed loading file: '
0233                       even
0234               
0235               txt.ioerr.save
0236 7518 1F49             byte  31
0237 7519 ....             text  'I/O error. Failed saving file: '
0238                       even
0239               
0240               txt.io.nofile
0241 7538 2149             byte  33
0242 7539 ....             text  'I/O error. No filename specified.'
0243                       even
0244               
0245               
0246               
0247               ;--------------------------------------------------------------
0248               ; Strings for command buffer
0249               ;--------------------------------------------------------------
0250               txt.cmdb.title
0251 755A 0E43             byte  14
0252 755B ....             text  'Command buffer'
0253                       even
0254               
0255               txt.cmdb.prompt
0256 756A 013E             byte  1
0257 756B ....             text  '>'
0258                       even
0259               
0260               
0261 756C 4201     txt.cmdb.hbar      byte    66
0262 756E 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     7570 0101 
     7572 0101 
     7574 0101 
     7576 0101 
     7578 0101 
     757A 0101 
     757C 0101 
     757E 0101 
     7580 0101 
0263 7582 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     7584 0101 
     7586 0101 
     7588 0101 
     758A 0101 
     758C 0101 
     758E 0101 
     7590 0101 
     7592 0101 
     7594 0101 
0264 7596 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     7598 0101 
     759A 0101 
     759C 0101 
     759E 0101 
     75A0 0101 
     75A2 0101 
     75A4 0101 
     75A6 0101 
     75A8 0101 
0265 75AA 0101                        byte    1,1,1,1,1,1
     75AC 0101 
     75AE 0100 
0266                                  even
0267               
0268 75B0 0C0A     txt.stevie         byte    12
0269                                  byte    10
0270 75B2 ....                        text    'stevie v1.00'
0271 75BE 0B00                        byte    11
0272                                  even
0273               
0274               txt.colorscheme
0275 75C0 0E43             byte  14
0276 75C1 ....             text  'COLOR SCHEME: '
0277                       even
0278               
0279               
0280               
0281               ;--------------------------------------------------------------
0282               ; Strings for filenames
0283               ;--------------------------------------------------------------
0284               fdname1
0285 75D0 0850             byte  8
0286 75D1 ....             text  'PI.CLOCK'
0287                       even
0288               
0289               fdname2
0290 75DA 0E54             byte  14
0291 75DB ....             text  'TIPI.TIVI.NR80'
0292                       even
0293               
0294               fdname3
0295 75EA 0C44             byte  12
0296 75EB ....             text  'DSK1.XBEADOC'
0297                       even
0298               
0299               fdname4
0300 75F8 1154             byte  17
0301 75F9 ....             text  'TIPI.TIVI.C99MAN1'
0302                       even
0303               
0304               fdname5
0305 760A 1154             byte  17
0306 760B ....             text  'TIPI.TIVI.C99MAN2'
0307                       even
0308               
0309               fdname6
0310 761C 1154             byte  17
0311 761D ....             text  'TIPI.TIVI.C99MAN3'
0312                       even
0313               
0314               fdname7
0315 762E 1254             byte  18
0316 762F ....             text  'TIPI.TIVI.C99SPECS'
0317                       even
0318               
0319               fdname8
0320 7642 1254             byte  18
0321 7643 ....             text  'TIPI.TIVI.RANDOM#C'
0322                       even
0323               
0324               fdname9
0325 7656 0D44             byte  13
0326 7657 ....             text  'DSK1.INVADERS'
0327                       even
0328               
0329               fdname0
0330 7664 0944             byte  9
0331 7665 ....             text  'DSK1.NR80'
0332                       even
0333               
0334               fdname.clock
0335 766E 0850             byte  8
0336 766F ....             text  'PI.CLOCK'
0337                       even
0338               
**** **** ****     > stevie_b0.asm.157677
0147                       ;------------------------------------------------------
0148                       ; End of File marker
0149                       ;------------------------------------------------------
0150 7678 DEAD             data  >dead,>beef,>dead,>beef
     767A BEEF 
     767C DEAD 
     767E BEEF 
0152               
0156 7680 360E                   data $                ; Bank 0 ROM size OK.
0158               
0159               *--------------------------------------------------------------
0160               * Video mode configuration for SP2
0161               *--------------------------------------------------------------
0162      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0163      0004     spfbck  equ   >04                   ; Screen background color.
0164      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0165      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0166      0050     colrow  equ   80                    ; Columns per row
0167      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0168      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0169      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0170      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

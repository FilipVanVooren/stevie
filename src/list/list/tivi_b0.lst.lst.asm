XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b0.lst.asm.4512
0001               XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
0002               **** **** ****     > tivi_b0.asm.13634
0003               0001               ***************************************************************
0004               0002               *                          TiVi Editor
0005               0003               *
0006               0004               *       A 21th century Programming Editor for the 1981
0007               0005               *         Texas Instruments TI-99/4a Home Computer.
0008               0006               *
0009               0007               *              (c)2018-2020 // Filip van Vooren
0010               0008               ***************************************************************
0011               0009               * File: tivi_b0.asm                 ; Version 200322-13634
0012               0010
0013               0011
0014               0012               ***************************************************************
0015               0013               * BANK 0 - Spectra2 library
0016               0014               ********|*****|*********************|**************************
0017               0015                       aorg  >6000
0018               0016                       save  >6000,>7fff           ; Save bank 0 (1st bank)
0019               0017                       copy  "equates.asm"         ; Equates TiVi configuration
0020               **** **** ****     > equates.asm
0021               0001               ***************************************************************
0022               0002               *                          TiVi Editor
0023               0003               *
0024               0004               *       A 21th century Programming Editor for the 1981
0025               0005               *         Texas Instruments TI-99/4a Home Computer.
0026               0006               *
0027               0007               *              (c)2018-2020 // Filip van Vooren
0028               0008               ***************************************************************
0029               0009               * File: equates.asm                 ; Version 200322-13634
0030               0010               *--------------------------------------------------------------
0031               0011               * TiVi memory layout.
0032               0012               * See file "modules/memory.asm" for further details.
0033               0013               *
0034               0014               * Mem range   Bytes    Hex    Purpose
0035               0015               * =========   =====    ===    ==================================
0036               0016               * 2000-3fff   8192     no     TiVi program code
0037               0017               * 6000-7fff   8192     no     Spectra2 library program code (cartridge space)
0038               0018               * a000-afff   4096     no     Scratchpad/GPL backup, TiVi structures
0039               0019               * b000-bfff   4096     no     Command buffer
0040               0020               * c000-cfff   4096     yes    Main index
0041               0021               * d000-dfff   4096     yes    Shadow SAMS pages index
0042               0022               * e000-efff   4096     yes    Editor buffer 4k
0043               0023               * f000-ffff   4096     yes    Editor buffer 4k
0044               0024               *
0045               0025               * TiVi VDP layout
0046               0026               *
0047               0027               * Mem range   Bytes    Hex    Purpose
0048               0028               * =========   =====   ====    =================================
0049               0029               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0050               0030               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0051               0031               * 0fc0                        PCT - Pattern Color Table
0052               0032               * 1000                        PDT - Pattern Descriptor Table
0053               0033               * 1800                        SPT - Sprite Pattern Table
0054               0034               * 2000                        SAT - Sprite Attribute List
0055               0035               *--------------------------------------------------------------
0056               0036               * Skip unused spectra2 code modules for reduced code size
0057               0037               *--------------------------------------------------------------
0058               0038      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0059               0039      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0060               0040      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0061               0041      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0062               0042      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0063               0043      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0064               0044      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0065               0045      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0066               0046      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0067               0047      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0068               0048      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0069               0049      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0070               0050      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0071               0051      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0072               0052      0001     skip_random_generator     equ  1    ; Skip random functions
0073               0053      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0074               0054               *--------------------------------------------------------------
0075               0055               * SPECTRA2 / TiVi startup options
0076               0056               *--------------------------------------------------------------
0077               0057      0001     debug                     equ  1    ; Turn on spectra2 debugging
0078               0058      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0079               0059      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0080               0060      6030     kickstart.code1           equ  >6030; Uniform aorg entry address accross banks
0081               0061      6050     kickstart.code2           equ  >6050; Uniform aorg entry address start of code
0082               0062      A000     cpu.scrpad.tgt            equ  >a000; Destination cpu.scrpad.backup/restore
0083               0063
0084               0064               *--------------------------------------------------------------
0085               0065               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0086               0066               *--------------------------------------------------------------
0087               0067               ;               equ  >8342          ; >8342-834F **free***
0088               0068      8350     parm1           equ  >8350          ; Function parameter 1
0089               0069      8352     parm2           equ  >8352          ; Function parameter 2
0090               0070      8354     parm3           equ  >8354          ; Function parameter 3
0091               0071      8356     parm4           equ  >8356          ; Function parameter 4
0092               0072      8358     parm5           equ  >8358          ; Function parameter 5
0093               0073      835A     parm6           equ  >835a          ; Function parameter 6
0094               0074      835C     parm7           equ  >835c          ; Function parameter 7
0095               0075      835E     parm8           equ  >835e          ; Function parameter 8
0096               0076      8360     outparm1        equ  >8360          ; Function output parameter 1
0097               0077      8362     outparm2        equ  >8362          ; Function output parameter 2
0098               0078      8364     outparm3        equ  >8364          ; Function output parameter 3
0099               0079      8366     outparm4        equ  >8366          ; Function output parameter 4
0100               0080      8368     outparm5        equ  >8368          ; Function output parameter 5
0101               0081      836A     outparm6        equ  >836a          ; Function output parameter 6
0102               0082      836C     outparm7        equ  >836c          ; Function output parameter 7
0103               0083      836E     outparm8        equ  >836e          ; Function output parameter 8
0104               0084      8370     timers          equ  >8370          ; Timer table
0105               0085      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0106               0086      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0107               0087               *--------------------------------------------------------------
0108               0088               * Scratchpad backup 1               @>a000-a0ff     (256 bytes)
0109               0089               * Scratchpad backup 2               @>a100-a1ff     (256 bytes)
0110               0090               *--------------------------------------------------------------
0111               0091      A000     scrpad.backup1  equ  >a000          ; Backup GPL layout
0112               0092      A100     scrpad.backup2  equ  >a100          ; Backup spectra2 layout
0113               0093               *--------------------------------------------------------------
0114               0094               * TiVi Editor shared structures     @>a200-a27f     (128 bytes)
0115               0095               *--------------------------------------------------------------
0116               0096      A200     tv.top          equ  >a200          ; Structure begin
0117               0097      A200     tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
0118               0098      A202     tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
0119               0099      A204     tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
0120               0100      A206     tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
0121               0101      A208     tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
0122               0102      A20A     tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
0123               0103      A20C     tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
0124               0104      A20E     tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
0125               0105      A210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0126               0106      A212     tv.colorscheme  equ  tv.top + 18    ; Current color scheme (0-4)
0127               0107      A214     tv.curshape     equ  tv.top + 20    ; Cursor shape and color
0128               0108      A216     tv.end          equ  tv.top + 22    ; End of structure
0129               0109               *--------------------------------------------------------------
0130               0110               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0131               0111               *--------------------------------------------------------------
0132               0112      A280     fb.struct       equ  >a280          ; Structure begin
0133               0113      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0134               0114      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0135               0115      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0136               0116                                                   ; line X in editor buffer).
0137               0117      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0138               0118                                                   ; (offset 0 .. @fb.scrrows)
0139               0119      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0140               0120      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0141               0121      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0142               0122      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0143               0123      A290     fb.free1        equ  fb.struct + 16 ; **FREE FOR USE**
0144               0124      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0145               0125      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0146               0126      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0147               0127      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0148               0128      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0149               0129      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0150               0130               *--------------------------------------------------------------
0151               0131               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0152               0132               *--------------------------------------------------------------
0153               0133      A300     edb.struct        equ  >a300           ; Begin structure
0154               0134      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0155               0135      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0156               0136      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0157               0137      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0158               0138      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0159               0139      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0160               0140      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0161               0141      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0162               0142                                                      ; with current filename.
0163               0143      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0164               0144                                                      ; with current file type.
0165               0145      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0166               0146      A314     edb.end           equ  edb.struct + 20 ; End of structure
0167               0147               *--------------------------------------------------------------
0168               0148               * File handling structures          @>a400-a4ff     (256 bytes)
0169               0149               *--------------------------------------------------------------
0170               0150      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0171               0151      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0172               0152      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0173               0153      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0174               0154      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0175               0155      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0176               0156      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0177               0157      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0178               0158      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0179               0159      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0180               0160      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0181               0161      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0182               0162      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0183               0163      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0184               0164      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0185               0165      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0186               0166      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0187               0167      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0188               0168      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0189               0169      A496     fh.end            equ  fh.struct +150  ; End of structure
0190               0170      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0191               0171      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0192               0172               *--------------------------------------------------------------
0193               0173               * Command buffer structure          @>a500-a5ff     (256 bytes)
0194               0174               *--------------------------------------------------------------
0195               0175      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0196               0176      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0197               0177      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0198               0178      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0199               0179      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0200               0180      A508     cmdb.yxtop      equ  cmdb.struct + 8   ; Screen YX of 1st row in cmdb pane
0201               0181      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0202               0182      A50C     cmdb.lines      equ  cmdb.struct + 12  ; Total lines in editor buffer
0203               0183      A50E     cmdb.dirty      equ  cmdb.struct + 14  ; Editor buffer dirty (Text changed!)
0204               0184      A510     cmdb.end        equ  cmdb.struct + 16  ; End of structure
0205               0185               *--------------------------------------------------------------
0206               0186               * Free for future use               @>a600-a64f     (80 bytes)
0207               0187               *--------------------------------------------------------------
0208               0188      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0209               0189               *--------------------------------------------------------------
0210               0190               * Frame buffer                      @>a650-afff    (2480 bytes)
0211               0191               *--------------------------------------------------------------
0212               0192      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0213               0193      09B0     fb.size         equ  2480              ; Frame buffer size
0214               0194               *--------------------------------------------------------------
0215               0195               * Command buffer                    @>b000-bfff    (4096 bytes)
0216               0196               *--------------------------------------------------------------
0217               0197      B000     cmdb.top        equ  >b000             ; Top of command buffer
0218               0198      1000     cmdb.size       equ  4096              ; Command buffer size
0219               0199               *--------------------------------------------------------------
0220               0200               * Index                             @>c000-cfff    (4096 bytes)
0221               0201               *--------------------------------------------------------------
0222               0202      C000     idx.top         equ  >c000             ; Top of index
0223               0203      1000     idx.size        equ  4096              ; Index size
0224               0204               *--------------------------------------------------------------
0225               0205               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0226               0206               *--------------------------------------------------------------
0227               0207      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0228               0208      1000     idx.shadow.size equ  4096              ; Shadow index size
0229               0209               *--------------------------------------------------------------
0230               0210               * Editor buffer                     @>e000-efff    (4096 bytes)
0231               0211               *                                   @>f000-ffff    (4096 bytes)
0232               0212               *--------------------------------------------------------------
0233               0213      E000     edb.top         equ  >e000             ; Editor buffer high memory
0234               0214      2000     edb.size        equ  8192              ; Editor buffer size
0235               0215               *--------------------------------------------------------------
0236               **** **** ****     > tivi_b0.asm.13634
0237               0018                       copy  "kickstart.asm"       ; Cartridge header
0238               **** **** ****     > kickstart.asm
0239               0001               * FILE......: kickstart.asm
0240               0002               * Purpose...: Bankswitch routine for starting TiVi
0241               0003
0242               0004               ***************************************************************
0243               0005               * TiVi Cartridge Header & kickstart ROM bank 0
0244               0006               ***************************************************************
0245               0007               *
0246               0008               *--------------------------------------------------------------
0247               0009               * INPUT
0248               0010               * none
0249               0011               *--------------------------------------------------------------
0250               0012               * OUTPUT
0251               0013               * none
0252               0014               *--------------------------------------------------------------
0253               0015               * Register usage
0254               0016               * r0
0255               0017               ***************************************************************
0256               0018
0257               0019               *--------------------------------------------------------------
0258               0020               * Cartridge header
0259               0021               ********|*****|*********************|**************************
0260               0022 6000 AA01             byte  >aa,1,1,0,0,0
0261                    6002 0100
0262                    6004 0000
0263               0023 6006 6010             data  $+10
0264               0024 6008 0000             byte  0,0,0,0,0,0,0,0
0265                    600A 0000
0266                    600C 0000
0267                    600E 0000
0268               0025 6010 0000             data  0                     ; No more items following
0269               0026 6012 6030             data  kickstart.code1
0270               0027
0271               0029
0272               0030 6014 1154             byte  17
0273               0031 6015 ....             text  'TIVI 200322-13634'
0274               0032                       even
0275               0033
0276               0041
0277               0042               *--------------------------------------------------------------
0278               0043               * Kickstart bank 0
0279               0044               ********|*****|*********************|**************************
0280               0045                       aorg  kickstart.code1
0281               0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0282                    6032 6000
0283               **** **** ****     > tivi_b0.asm.13634
0284               0019               ***************************************************************
0285               0020               * Copy runtime library to destination >2000 - >3fff
0286               0021               ********|*****|*********************|**************************
0287               0022               kickstart.init:
0288               0023 6034 0200  20         li    r0,reloc+2            ; Start of code to relocate
0289                    6036 6062
0290               0024 6038 0201  20         li    r1,>2000
0291                    603A 2000
0292               0025 603C 0202  20         li    r2,512                ; Copy 8K (512 * 4 words)
0293                    603E 0200
0294               0026               kickstart.loop:
0295               0027 6040 CC70  46         mov   *r0+,*r1+
0296               0028 6042 CC70  46         mov   *r0+,*r1+
0297               0029 6044 CC70  46         mov   *r0+,*r1+
0298               0030 6046 CC70  46         mov   *r0+,*r1+
0299               0031 6048 0602  14         dec   r2
0300               0032 604A 16FA  14         jne   kickstart.loop
0301               0033 604C 0460  28         b     @runlib               ; Start spectra2 library
0302                    604E 2D10
0303               0034               ***************************************************************
0304               0035               * TiVi entry point after spectra2 initialisation
0305               0036               ********|*****|*********************|**************************
0306               0037                       aorg  kickstart.code2
0307               0038 6050 04E0  34 main    clr   @>6002                ; Jump to bank 1 (2nd bank)
0308                    6052 6002
0309               0039                                                   ;--------------------------
0310               0040                                                   ; Should not get here
0311               0041                                                   ;--------------------------
0312               0042 6054 0200  20         li    r0,main
0313                    6056 6050
0314               0043 6058 C800  38         mov   r0,@>ffce             ; \ Save caller address
0315                    605A FFCE
0316               0044 605C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
0317                    605E 2030
0318               0045               ***************************************************************
0319               0046               * Spectra2 library
0320               0047               ********|*****|*********************|**************************
0321               0048 6060 1000  14 reloc   nop                         ; Anchor for copy command
0322               0049                       xorg >2000                  ; Relocate all spectra2 code to >2000
0323               0050                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
0324               **** **** ****     > runlib.asm
0325               0001               *******************************************************************************
0326               0002               *              ___  ____  ____  ___  ____  ____    __    ___
0327               0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0328               0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0329               0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0330               0006               *
0331               0007               *                TMS9900 Monitor with Arcade Game support
0332               0008               *                                  for
0333               0009               *              the Texas Instruments TI-99/4A Home Computer
0334               0010               *
0335               0011               *                      2010-2020 by Filip Van Vooren
0336               0012               *
0337               0013               *              https://github.com/FilipVanVooren/spectra2.git
0338               0014               *******************************************************************************
0339               0015               * This file: runlib.a99
0340               0016               *******************************************************************************
0341               0017               * Use following equates to skip/exclude support modules and to control startup
0342               0018               * behaviour.
0343               0019               *
0344               0020               * == Memory
0345               0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0346               0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0347               0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0348               0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0349               0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0350               0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0351               0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0352               0028               *
0353               0029               * == VDP
0354               0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0355               0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0356               0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0357               0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0358               0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0359               0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0360               0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0361               0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0362               0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0363               0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0364               0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0365               0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0366               0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0367               0043               *
0368               0044               * == Sound & speech
0369               0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0370               0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0371               0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0372               0048               *
0373               0049               * ==  Keyboard
0374               0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0375               0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0376               0052               *
0377               0053               * == Utilities
0378               0054               * skip_random_generator     equ  1  ; Skip random generator functions
0379               0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0380               0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0381               0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0382               0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0383               0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0384               0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0385               0061               *
0386               0062               * == Kernel/Multitasking
0387               0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0388               0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0389               0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0390               0066               *
0391               0067               * == Startup behaviour
0392               0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0393               0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0394               0070               *******************************************************************************
0395               0071
0396               0072               *//////////////////////////////////////////////////////////////
0397               0073               *                       RUNLIB SETUP
0398               0074               *//////////////////////////////////////////////////////////////
0399               0075
0400               0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
0401               **** **** ****     > equ_memsetup.asm
0402               0001               * FILE......: memsetup.asm
0403               0002               * Purpose...: Equates for spectra2 memory layout
0404               0003
0405               0004               ***************************************************************
0406               0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0407               0006               ********|*****|*********************|**************************
0408               0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0409               0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0410               0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0411               0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0412               0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0413               0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0414               0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0415               0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0416               0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0417               0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0418               0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0419               0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0420               0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0421               0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0422               0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0423               0022               ***************************************************************
0424               0023      832A     by      equ   wyx                   ;      Cursor Y position
0425               0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0426               0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0427               0026               ***************************************************************
0428               **** **** ****     > runlib.asm
0429               0077                       copy  "equ_registers.asm"        ; Equates runlib registers
0430               **** **** ****     > equ_registers.asm
0431               0001               * FILE......: registers.asm
0432               0002               * Purpose...: Equates for registers
0433               0003
0434               0004               ***************************************************************
0435               0005               * Register usage
0436               0006               * R0      **free not used**
0437               0007               * R1      **free not used**
0438               0008               * R2      Config register
0439               0009               * R3      Extended config register
0440               0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0441               0011               * R9      Stack pointer
0442               0012               * R10     Highest slot in use + Timer counter
0443               0013               * R11     Subroutine return address
0444               0014               * R12     CRU
0445               0015               * R13     Copy of VDP status byte and counter for sound player
0446               0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0447               0017               * R15     VDP read/write address
0448               0018               *--------------------------------------------------------------
0449               0019               * Special purpose registers
0450               0020               * R0      shift count
0451               0021               * R12     CRU
0452               0022               * R13     WS     - when using LWPI, BLWP, RTWP
0453               0023               * R14     PC     - when using LWPI, BLWP, RTWP
0454               0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0455               0025               ***************************************************************
0456               0026               * Define registers
0457               0027               ********|*****|*********************|**************************
0458               0028      0000     r0      equ   0
0459               0029      0001     r1      equ   1
0460               0030      0002     r2      equ   2
0461               0031      0003     r3      equ   3
0462               0032      0004     r4      equ   4
0463               0033      0005     r5      equ   5
0464               0034      0006     r6      equ   6
0465               0035      0007     r7      equ   7
0466               0036      0008     r8      equ   8
0467               0037      0009     r9      equ   9
0468               0038      000A     r10     equ   10
0469               0039      000B     r11     equ   11
0470               0040      000C     r12     equ   12
0471               0041      000D     r13     equ   13
0472               0042      000E     r14     equ   14
0473               0043      000F     r15     equ   15
0474               0044               ***************************************************************
0475               0045               * Define register equates
0476               0046               ********|*****|*********************|**************************
0477               0047      0002     config  equ   r2                    ; Config register
0478               0048      0003     xconfig equ   r3                    ; Extended config register
0479               0049      0004     tmp0    equ   r4                    ; Temp register 0
0480               0050      0005     tmp1    equ   r5                    ; Temp register 1
0481               0051      0006     tmp2    equ   r6                    ; Temp register 2
0482               0052      0007     tmp3    equ   r7                    ; Temp register 3
0483               0053      0008     tmp4    equ   r8                    ; Temp register 4
0484               0054      0009     stack   equ   r9                    ; Stack pointer
0485               0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0486               0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0487               0057               ***************************************************************
0488               0058               * Define MSB/LSB equates for registers
0489               0059               ********|*****|*********************|**************************
0490               0060      8300     r0hb    equ   ws1                   ; HI byte R0
0491               0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0492               0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0493               0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0494               0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0495               0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0496               0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0497               0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0498               0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0499               0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0500               0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0501               0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0502               0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0503               0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0504               0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0505               0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0506               0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0507               0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0508               0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0509               0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0510               0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0511               0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0512               0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0513               0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0514               0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0515               0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0516               0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0517               0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0518               0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0519               0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0520               0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0521               0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0522               0092               ********|*****|*********************|**************************
0523               0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0524               0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0525               0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0526               0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0527               0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0528               0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0529               0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0530               0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0531               0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0532               0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0533               0103               ********|*****|*********************|**************************
0534               0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0535               0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0536               0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0537               0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0538               0108               ***************************************************************
0539               **** **** ****     > runlib.asm
0540               0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
0541               **** **** ****     > equ_portaddr.asm
0542               0001               * FILE......: portaddr.asm
0543               0002               * Purpose...: Equates for hardware port addresses
0544               0003
0545               0004               ***************************************************************
0546               0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0547               0006               ********|*****|*********************|**************************
0548               0007      8400     sound   equ   >8400                 ; Sound generator address
0549               0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0550               0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0551               0010      8802     vdps    equ   >8802                 ; VDP status register
0552               0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0553               0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0554               0013      9802     grmra   equ   >9802                 ; GROM set read address
0555               0014      9800     grmrd   equ   >9800                 ; GROM read byte
0556               0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0557               0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0558               0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
0559               **** **** ****     > runlib.asm
0560               0079                       copy  "equ_param.asm"            ; Equates runlib parameters
0561               **** **** ****     > equ_param.asm
0562               0001               * FILE......: param.asm
0563               0002               * Purpose...: Equates used for subroutine parameters
0564               0003
0565               0004               ***************************************************************
0566               0005               * Subroutine parameter equates
0567               0006               ***************************************************************
0568               0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0569               0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0570               0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0571               0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0572               0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0573               0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0574               0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0575               0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0576               0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0577               0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0578               0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0579               0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0580               0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0581               0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0582               0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0583               0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0584               0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0585               0024               *--------------------------------------------------------------
0586               0025               *   Speech player
0587               0026               *--------------------------------------------------------------
0588               0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0589               0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0590               0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0591               0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
0592               **** **** ****     > runlib.asm
0593               0080
0594               0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
0595               **** **** ****     > rom_bankswitch.asm
0596               0001               * FILE......: rom_bankswitch.asm
0597               0002               * Purpose...: ROM bankswitching Support module
0598               0003
0599               0004               *//////////////////////////////////////////////////////////////
0600               0005               *                   BANKSWITCHING FUNCTIONS
0601               0006               *//////////////////////////////////////////////////////////////
0602               0007
0603               0008               ***************************************************************
0604               0009               * SWBNK - Switch ROM bank
0605               0010               ***************************************************************
0606               0011               *  BL   @SWBNK
0607               0012               *  DATA P0,P1
0608               0013               *--------------------------------------------------------------
0609               0014               *  P0 = Bank selection address (>600X)
0610               0015               *  P1 = Vector address
0611               0016               *--------------------------------------------------------------
0612               0017               *  B    @SWBNKX
0613               0018               *
0614               0019               *  TMP0 = Bank selection address (>600X)
0615               0020               *  TMP1 = Vector address
0616               0021               *--------------------------------------------------------------
0617               0022               *  Important! The bank-switch routine must be at the exact
0618               0023               *  same location accross banks
0619               0024               ********|*****|*********************|**************************
0620               0025 6062 C13B  30 swbnk   mov   *r11+,tmp0
0621               0026 6064 C17B  30         mov   *r11+,tmp1
0622               0027 6066 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0623               0028 6068 C155  26         mov   *tmp1,tmp1
0624               0029 606A 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0625               **** **** ****     > runlib.asm
0626               0084
0627               0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
0628               **** **** ****     > cpu_constants.asm
0629               0001               * FILE......: cpu_constants.asm
0630               0002               * Purpose...: Constants used by Spectra2 and for own use
0631               0003
0632               0004               ***************************************************************
0633               0005               *                      Some constants
0634               0006               ********|*****|*********************|**************************
0635               0007
0636               0008               ---------------------------------------------------------------
0637               0009               * Word values
0638               0010               *--------------------------------------------------------------
0639               0011               ;                                   ;       0123456789ABCDEF
0640               0012 606C 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0641               0013 606E 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0642               0014 6070 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0643               0015 6072 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0644               0016 6074 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0645               0017 6076 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0646               0018 6078 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0647               0019 607A 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0648               0020 607C 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0649               0021 607E 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0650               0022 6080 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0651               0023 6082 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0652               0024 6084 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0653               0025 6086 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0654               0026 6088 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0655               0027 608A 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0656               0028 608C 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0657               0029 608E FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0658               0030 6090 D000     w$d000  data  >d000                 ; >d000
0659               0031               *--------------------------------------------------------------
0660               0032               * Byte values - High byte (=MSB) for byte operations
0661               0033               *--------------------------------------------------------------
0662               0034      200A     hb$00   equ   w$0000                ; >0000
0663               0035      201C     hb$01   equ   w$0100                ; >0100
0664               0036      201E     hb$02   equ   w$0200                ; >0200
0665               0037      2020     hb$04   equ   w$0400                ; >0400
0666               0038      2022     hb$08   equ   w$0800                ; >0800
0667               0039      2024     hb$10   equ   w$1000                ; >1000
0668               0040      2026     hb$20   equ   w$2000                ; >2000
0669               0041      2028     hb$40   equ   w$4000                ; >4000
0670               0042      202A     hb$80   equ   w$8000                ; >8000
0671               0043      202E     hb$d0   equ   w$d000                ; >d000
0672               0044               *--------------------------------------------------------------
0673               0045               * Byte values - Low byte (=LSB) for byte operations
0674               0046               *--------------------------------------------------------------
0675               0047      200A     lb$00   equ   w$0000                ; >0000
0676               0048      200C     lb$01   equ   w$0001                ; >0001
0677               0049      200E     lb$02   equ   w$0002                ; >0002
0678               0050      2010     lb$04   equ   w$0004                ; >0004
0679               0051      2012     lb$08   equ   w$0008                ; >0008
0680               0052      2014     lb$10   equ   w$0010                ; >0010
0681               0053      2016     lb$20   equ   w$0020                ; >0020
0682               0054      2018     lb$40   equ   w$0040                ; >0040
0683               0055      201A     lb$80   equ   w$0080                ; >0080
0684               0056               *--------------------------------------------------------------
0685               0057               * Bit values
0686               0058               *--------------------------------------------------------------
0687               0059               ;                                   ;       0123456789ABCDEF
0688               0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0689               0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0690               0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0691               0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0692               0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0693               0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0694               0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0695               0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0696               0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0697               0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0698               0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0699               0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0700               0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0701               0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0702               0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0703               0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
0704               **** **** ****     > runlib.asm
0705               0086                       copy  "equ_config.asm"           ; Equates for bits in config register
0706               **** **** ****     > equ_config.asm
0707               0001               * FILE......: equ_config.asm
0708               0002               * Purpose...: Equates for bits in config register
0709               0003
0710               0004               ***************************************************************
0711               0005               * The config register equates
0712               0006               *--------------------------------------------------------------
0713               0007               * Configuration flags
0714               0008               * ===================
0715               0009               *
0716               0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0717               0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0718               0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0719               0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0720               0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0721               0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0722               0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0723               0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0724               0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0725               0019               * ; 06  Timer: Block user hook          1=yes          0=no
0726               0020               * ; 05  Speech synthesizer present      1=yes          0=no
0727               0021               * ; 04  Speech player: busy             1=yes          0=no
0728               0022               * ; 03  Speech player: enabled          1=yes          0=no
0729               0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0730               0024               * ; 01  F18A present                    1=on           0=off
0731               0025               * ; 00  Subroutine state flag           1=on           0=off
0732               0026               ********|*****|*********************|**************************
0733               0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0734               0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0735               0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0736               0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0737               0031               ***************************************************************
0738               0032
0739               **** **** ****     > runlib.asm
0740               0087                       copy  "cpu_crash.asm"            ; CPU crash handler
0741               **** **** ****     > cpu_crash.asm
0742               0001               * FILE......: cpu_crash.asm
0743               0002               * Purpose...: Custom crash handler module
0744               0003
0745               0004
0746               0005               ***************************************************************
0747               0006               * cpu.crash - CPU program crashed handler
0748               0007               ***************************************************************
0749               0008               *  bl   @cpu.crash
0750               0009               *--------------------------------------------------------------
0751               0010               * Crash and halt system. Upon crash entry register contents are
0752               0011               * copied to the memory region >ffe0 - >fffe and displayed after
0753               0012               * resetting the spectra2 runtime library, video modes, etc.
0754               0013               *
0755               0014               * Diagnostics
0756               0015               * >ffce  caller address
0757               0016               *
0758               0017               * Register contents
0759               0018               * >ffdc  wp
0760               0019               * >ffde  st
0761               0020               * >ffe0  r0
0762               0021               * >ffe2  r1
0763               0022               * >ffe4  r2  (config)
0764               0023               * >ffe6  r3
0765               0024               * >ffe8  r4  (tmp0)
0766               0025               * >ffea  r5  (tmp1)
0767               0026               * >ffec  r6  (tmp2)
0768               0027               * >ffee  r7  (tmp3)
0769               0028               * >fff0  r8  (tmp4)
0770               0029               * >fff2  r9  (stack)
0771               0030               * >fff4  r10
0772               0031               * >fff6  r11
0773               0032               * >fff8  r12
0774               0033               * >fffa  r13
0775               0034               * >fffc  r14
0776               0035               * >fffe  r15
0777               0036               ********|*****|*********************|**************************
0778               0037               cpu.crash:
0779               0038 6092 022B  22         ai    r11,-4                ; Remove opcode offset
0780                    6094 FFFC
0781               0039               *--------------------------------------------------------------
0782               0040               *    Save registers to high memory
0783               0041               *--------------------------------------------------------------
0784               0042 6096 C800  38         mov   r0,@>ffe0
0785                    6098 FFE0
0786               0043 609A C801  38         mov   r1,@>ffe2
0787                    609C FFE2
0788               0044 609E C802  38         mov   r2,@>ffe4
0789                    60A0 FFE4
0790               0045 60A2 C803  38         mov   r3,@>ffe6
0791                    60A4 FFE6
0792               0046 60A6 C804  38         mov   r4,@>ffe8
0793                    60A8 FFE8
0794               0047 60AA C805  38         mov   r5,@>ffea
0795                    60AC FFEA
0796               0048 60AE C806  38         mov   r6,@>ffec
0797                    60B0 FFEC
0798               0049 60B2 C807  38         mov   r7,@>ffee
0799                    60B4 FFEE
0800               0050 60B6 C808  38         mov   r8,@>fff0
0801                    60B8 FFF0
0802               0051 60BA C809  38         mov   r9,@>fff2
0803                    60BC FFF2
0804               0052 60BE C80A  38         mov   r10,@>fff4
0805                    60C0 FFF4
0806               0053 60C2 C80B  38         mov   r11,@>fff6
0807                    60C4 FFF6
0808               0054 60C6 C80C  38         mov   r12,@>fff8
0809                    60C8 FFF8
0810               0055 60CA C80D  38         mov   r13,@>fffa
0811                    60CC FFFA
0812               0056 60CE C80E  38         mov   r14,@>fffc
0813                    60D0 FFFC
0814               0057 60D2 C80F  38         mov   r15,@>ffff
0815                    60D4 FFFF
0816               0058 60D6 02A0  12         stwp  r0
0817               0059 60D8 C800  38         mov   r0,@>ffdc
0818                    60DA FFDC
0819               0060 60DC 02C0  12         stst  r0
0820               0061 60DE C800  38         mov   r0,@>ffde
0821                    60E0 FFDE
0822               0062               *--------------------------------------------------------------
0823               0063               *    Reset system
0824               0064               *--------------------------------------------------------------
0825               0065               cpu.crash.reset:
0826               0066 60E2 02E0  18         lwpi  ws1                   ; Activate workspace 1
0827                    60E4 8300
0828               0067 60E6 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
0829                    60E8 8302
0830               0068 60EA 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
0831                    60EC 4A4A
0832               0069 60EE 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
0833                    60F0 2D18
0834               0070               *--------------------------------------------------------------
0835               0071               *    Show diagnostics after system reset
0836               0072               *--------------------------------------------------------------
0837               0073               cpu.crash.main:
0838               0074                       ;------------------------------------------------------
0839               0075                       ; Show crash details
0840               0076                       ;------------------------------------------------------
0841               0077 60F2 06A0  32         bl    @putat                ; Show crash message
0842                    60F4 2410
0843               0078 60F6 0000                   data >0000,cpu.crash.msg.crashed
0844                    60F8 216A
0845               0079
0846               0080 60FA 06A0  32         bl    @puthex               ; Put hex value on screen
0847                    60FC 2946
0848               0081 60FE 0015                   byte 0,21             ; \ i  p0 = YX position
0849               0082 6100 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0850               0083 6102 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0851               0084 6104 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0852               0085                                                   ; /         LSB offset for ASCII digit 0-9
0853               0086                       ;------------------------------------------------------
0854               0087                       ; Show caller details
0855               0088                       ;------------------------------------------------------
0856               0089 6106 06A0  32         bl    @putat                ; Show caller message
0857                    6108 2410
0858               0090 610A 0100                   data >0100,cpu.crash.msg.caller
0859                    610C 2180
0860               0091
0861               0092 610E 06A0  32         bl    @puthex               ; Put hex value on screen
0862                    6110 2946
0863               0093 6112 0115                   byte 1,21             ; \ i  p0 = YX position
0864               0094 6114 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0865               0095 6116 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0866               0096 6118 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0867               0097                                                   ; /         LSB offset for ASCII digit 0-9
0868               0098                       ;------------------------------------------------------
0869               0099                       ; Display labels
0870               0100                       ;------------------------------------------------------
0871               0101 611A 06A0  32         bl    @putat
0872                    611C 2410
0873               0102 611E 0300                   byte 3,0
0874               0103 6120 219A                   data cpu.crash.msg.wp
0875               0104 6122 06A0  32         bl    @putat
0876                    6124 2410
0877               0105 6126 0400                   byte 4,0
0878               0106 6128 21A0                   data cpu.crash.msg.st
0879               0107 612A 06A0  32         bl    @putat
0880                    612C 2410
0881               0108 612E 1600                   byte 22,0
0882               0109 6130 21A6                   data cpu.crash.msg.source
0883               0110 6132 06A0  32         bl    @putat
0884                    6134 2410
0885               0111 6136 1700                   byte 23,0
0886               0112 6138 21C0                   data cpu.crash.msg.id
0887               0113                       ;------------------------------------------------------
0888               0114                       ; Show crash registers WP, ST, R0 - R15
0889               0115                       ;------------------------------------------------------
0890               0116 613A 06A0  32         bl    @at                   ; Put cursor at YX
0891                    613C 264E
0892               0117 613E 0304                   byte 3,4              ; \ i p0 = YX position
0893               0118                                                   ; /
0894               0119
0895               0120 6140 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
0896                    6142 FFDC
0897               0121 6144 04C6  14         clr   tmp2                  ; Loop counter
0898               0122
0899               0123               cpu.crash.showreg:
0900               0124 6146 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0901               0125
0902               0126 6148 0649  14         dect  stack
0903               0127 614A C644  30         mov   tmp0,*stack           ; Push tmp0
0904               0128 614C 0649  14         dect  stack
0905               0129 614E C645  30         mov   tmp1,*stack           ; Push tmp1
0906               0130 6150 0649  14         dect  stack
0907               0131 6152 C646  30         mov   tmp2,*stack           ; Push tmp2
0908               0132                       ;------------------------------------------------------
0909               0133                       ; Display crash register number
0910               0134                       ;------------------------------------------------------
0911               0135               cpu.crash.showreg.label:
0912               0136 6154 C046  18         mov   tmp2,r1               ; Save register number
0913               0137 6156 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
0914                    6158 0001
0915               0138 615A 121C  14         jle   cpu.crash.showreg.content
0916               0139                                                   ; Yes, skip
0917               0140
0918               0141 615C 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0919               0142 615E 06A0  32         bl    @mknum
0920                    6160 2950
0921               0143 6162 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0922               0144 6164 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0923               0145 6166 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0924               0146                                                   ; /         LSB offset for ASCII digit 0-9
0925               0147
0926               0148 6168 06A0  32         bl    @setx                 ; Set cursor X position
0927                    616A 2664
0928               0149 616C 0000                   data 0                ; \ i  p0 =  Cursor Y position
0929               0150                                                   ; /
0930               0151
0931               0152 616E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
0932                    6170 23FE
0933               0153 6172 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0934               0154                                                   ; /
0935               0155
0936               0156 6174 06A0  32         bl    @setx                 ; Set cursor X position
0937                    6176 2664
0938               0157 6178 0002                   data 2                ; \ i  p0 =  Cursor Y position
0939               0158                                                   ; /
0940               0159
0941               0160 617A 0281  22         ci    r1,10
0942                    617C 000A
0943               0161 617E 1102  14         jlt   !
0944               0162 6180 0620  34         dec   @wyx                  ; x=x-1
0945                    6182 832A
0946               0163
0947               0164 6184 06A0  32 !       bl    @putstr
0948                    6186 23FE
0949               0165 6188 2196                   data cpu.crash.msg.r
0950               0166
0951               0167 618A 06A0  32         bl    @mknum
0952                    618C 2950
0953               0168 618E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0954               0169 6190 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0955               0170 6192 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0956               0171                                                   ; /         LSB offset for ASCII digit 0-9
0957               0172                       ;------------------------------------------------------
0958               0173                       ; Display crash register content
0959               0174                       ;------------------------------------------------------
0960               0175               cpu.crash.showreg.content:
0961               0176 6194 06A0  32         bl    @mkhex                ; Convert hex word to string
0962                    6196 28C2
0963               0177 6198 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0964               0178 619A 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0965               0179 619C 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0966               0180                                                   ; /         LSB offset for ASCII digit 0-9
0967               0181
0968               0182 619E 06A0  32         bl    @setx                 ; Set cursor X position
0969                    61A0 2664
0970               0183 61A2 0006                   data 6                ; \ i  p0 =  Cursor Y position
0971               0184                                                   ; /
0972               0185
0973               0186 61A4 06A0  32         bl    @putstr
0974                    61A6 23FE
0975               0187 61A8 2198                   data cpu.crash.msg.marker
0976               0188
0977               0189 61AA 06A0  32         bl    @setx                 ; Set cursor X position
0978                    61AC 2664
0979               0190 61AE 0007                   data 7                ; \ i  p0 =  Cursor Y position
0980               0191                                                   ; /
0981               0192
0982               0193 61B0 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
0983                    61B2 23FE
0984               0194 61B4 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0985               0195                                                   ; /
0986               0196
0987               0197 61B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0988               0198 61B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0989               0199 61BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0990               0200
0991               0201 61BC 06A0  32         bl    @down                 ; y=y+1
0992                    61BE 2654
0993               0202
0994               0203 61C0 0586  14         inc   tmp2
0995               0204 61C2 0286  22         ci    tmp2,17
0996                    61C4 0011
0997               0205 61C6 12BF  14         jle   cpu.crash.showreg     ; Show next register
0998               0206                       ;------------------------------------------------------
0999               0207                       ; Kernel takes over
1000               0208                       ;------------------------------------------------------
1001               0209 61C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
1002                    61CA 2C26
1003               0210
1004               0211
1005               0212               cpu.crash.msg.crashed
1006               0213 61CC 1553             byte  21
1007               0214 61CD ....             text  'System crashed near >'
1008               0215                       even
1009               0216
1010               0217               cpu.crash.msg.caller
1011               0218 61E2 1543             byte  21
1012               0219 61E3 ....             text  'Caller address near >'
1013               0220                       even
1014               0221
1015               0222               cpu.crash.msg.r
1016               0223 61F8 0152             byte  1
1017               0224 61F9 ....             text  'R'
1018               0225                       even
1019               0226
1020               0227               cpu.crash.msg.marker
1021               0228 61FA 013E             byte  1
1022               0229 61FB ....             text  '>'
1023               0230                       even
1024               0231
1025               0232               cpu.crash.msg.wp
1026               0233 61FC 042A             byte  4
1027               0234 61FD ....             text  '**WP'
1028               0235                       even
1029               0236
1030               0237               cpu.crash.msg.st
1031               0238 6202 042A             byte  4
1032               0239 6203 ....             text  '**ST'
1033               0240                       even
1034               0241
1035               0242               cpu.crash.msg.source
1036               0243 6208 1953             byte  25
1037               0244 6209 ....             text  'Source    tivi_b0.lst.asm'
1038               0245                       even
1039               0246
1040               0247               cpu.crash.msg.id
1041               0248 6222 1642             byte  22
1042               0249 6223 ....             text  'Build-ID  200322-13634'
1043               0250                       even
1044               0251
1045               **** **** ****     > runlib.asm
1046               0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
1047               **** **** ****     > vdp_tables.asm
1048               0001               * FILE......: vdp_tables.a99
1049               0002               * Purpose...: Video mode tables
1050               0003
1051               0004               ***************************************************************
1052               0005               * Graphics mode 1 (32 columns/24 rows)
1053               0006               *--------------------------------------------------------------
1054               0007 623A 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
1055                    623C 000E
1056                    623E 0106
1057                    6240 0204
1058                    6242 0020
1059               0008               *
1060               0009               * ; VDP#0 Control bits
1061               0010               * ;      bit 6=0: M3 | Graphics 1 mode
1062               0011               * ;      bit 7=0: Disable external VDP input
1063               0012               * ; VDP#1 Control bits
1064               0013               * ;      bit 0=1: 16K selection
1065               0014               * ;      bit 1=1: Enable display
1066               0015               * ;      bit 2=1: Enable VDP interrupt
1067               0016               * ;      bit 3=0: M1 \ Graphics 1 mode
1068               0017               * ;      bit 4=0: M2 /
1069               0018               * ;      bit 5=0: reserved
1070               0019               * ;      bit 6=1: 16x16 sprites
1071               0020               * ;      bit 7=0: Sprite magnification (1x)
1072               0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1073               0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1074               0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1075               0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1076               0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
1077               0026               * ; VDP#7 Set screen background color
1078               0027
1079               0028
1080               0029               ***************************************************************
1081               0030               * Textmode (40 columns/24 rows)
1082               0031               *--------------------------------------------------------------
1083               0032 6244 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
1084                    6246 000E
1085                    6248 0106
1086                    624A 00F4
1087                    624C 0028
1088               0033               *
1089               0034               * ; VDP#0 Control bits
1090               0035               * ;      bit 6=0: M3 | Graphics 1 mode
1091               0036               * ;      bit 7=0: Disable external VDP input
1092               0037               * ; VDP#1 Control bits
1093               0038               * ;      bit 0=1: 16K selection
1094               0039               * ;      bit 1=1: Enable display
1095               0040               * ;      bit 2=1: Enable VDP interrupt
1096               0041               * ;      bit 3=1: M1 \ TEXT MODE
1097               0042               * ;      bit 4=0: M2 /
1098               0043               * ;      bit 5=0: reserved
1099               0044               * ;      bit 6=1: 16x16 sprites
1100               0045               * ;      bit 7=0: Sprite magnification (1x)
1101               0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1102               0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1103               0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1104               0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1105               0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
1106               0051               * ; VDP#7 Set foreground/background color
1107               0052               ***************************************************************
1108               0053
1109               0054
1110               0055               ***************************************************************
1111               0056               * Textmode (80 columns, 24 rows) - F18A
1112               0057               *--------------------------------------------------------------
1113               0058 624E 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1114                    6250 003F
1115                    6252 0240
1116                    6254 03F4
1117                    6256 0050
1118               0059               *
1119               0060               * ; VDP#0 Control bits
1120               0061               * ;      bit 6=0: M3 | Graphics 1 mode
1121               0062               * ;      bit 7=0: Disable external VDP input
1122               0063               * ; VDP#1 Control bits
1123               0064               * ;      bit 0=1: 16K selection
1124               0065               * ;      bit 1=1: Enable display
1125               0066               * ;      bit 2=1: Enable VDP interrupt
1126               0067               * ;      bit 3=1: M1 \ TEXT MODE
1127               0068               * ;      bit 4=0: M2 /
1128               0069               * ;      bit 5=0: reserved
1129               0070               * ;      bit 6=0: 8x8 sprites
1130               0071               * ;      bit 7=0: Sprite magnification (1x)
1131               0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1132               0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1133               0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1134               0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1135               0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1136               0077               * ; VDP#7 Set foreground/background color
1137               0078               ***************************************************************
1138               0079
1139               0080
1140               0081               ***************************************************************
1141               0082               * Textmode (80 columns, 30 rows) - F18A
1142               0083               *--------------------------------------------------------------
1143               0084 6258 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1144                    625A 003F
1145                    625C 0240
1146                    625E 03F4
1147                    6260 0050
1148               0085               *
1149               0086               * ; VDP#0 Control bits
1150               0087               * ;      bit 6=0: M3 | Graphics 1 mode
1151               0088               * ;      bit 7=0: Disable external VDP input
1152               0089               * ; VDP#1 Control bits
1153               0090               * ;      bit 0=1: 16K selection
1154               0091               * ;      bit 1=1: Enable display
1155               0092               * ;      bit 2=1: Enable VDP interrupt
1156               0093               * ;      bit 3=1: M1 \ TEXT MODE
1157               0094               * ;      bit 4=0: M2 /
1158               0095               * ;      bit 5=0: reserved
1159               0096               * ;      bit 6=0: 8x8 sprites
1160               0097               * ;      bit 7=0: Sprite magnification (1x)
1161               0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
1162               0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1163               0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1164               0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1165               0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1166               0103               * ; VDP#7 Set foreground/background color
1167               0104               ***************************************************************
1168               **** **** ****     > runlib.asm
1169               0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
1170               **** **** ****     > basic_cpu_vdp.asm
1171               0001               * FILE......: basic_cpu_vdp.asm
1172               0002               * Purpose...: Basic CPU & VDP functions used by other modules
1173               0003
1174               0004               *//////////////////////////////////////////////////////////////
1175               0005               *       Support Machine Code for copy & fill functions
1176               0006               *//////////////////////////////////////////////////////////////
1177               0007
1178               0008               *--------------------------------------------------------------
1179               0009               * ; Machine code for tight loop.
1180               0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
1181               0011               *--------------------------------------------------------------
1182               0012               *       DATA  >????                 ; \ mcloop  mov   ...
1183               0013 6262 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
1184               0014 6264 16FD             data  >16fd                 ; |         jne   mcloop
1185               0015 6266 045B             data  >045b                 ; /         b     *r11
1186               0016               *--------------------------------------------------------------
1187               0017               * ; Machine code for reading from the speech synthesizer
1188               0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
1189               0019               * ; Is required for the 12 uS delay. It destroys R5.
1190               0020               *--------------------------------------------------------------
1191               0021 6268 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
1192               0022 626A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
1193               0023                       even
1194               0024
1195               0025
1196               0026               *//////////////////////////////////////////////////////////////
1197               0027               *                    STACK SUPPORT FUNCTIONS
1198               0028               *//////////////////////////////////////////////////////////////
1199               0029
1200               0030               ***************************************************************
1201               0031               * POPR. - Pop registers & return to caller
1202               0032               ***************************************************************
1203               0033               *  B  @POPRG.
1204               0034               *--------------------------------------------------------------
1205               0035               *  REMARKS
1206               0036               *  R11 must be at stack bottom
1207               0037               ********|*****|*********************|**************************
1208               0038 626C C0F9  30 popr3   mov   *stack+,r3
1209               0039 626E C0B9  30 popr2   mov   *stack+,r2
1210               0040 6270 C079  30 popr1   mov   *stack+,r1
1211               0041 6272 C039  30 popr0   mov   *stack+,r0
1212               0042 6274 C2F9  30 poprt   mov   *stack+,r11
1213               0043 6276 045B  20         b     *r11
1214               0044
1215               0045
1216               0046
1217               0047               *//////////////////////////////////////////////////////////////
1218               0048               *                   MEMORY FILL FUNCTIONS
1219               0049               *//////////////////////////////////////////////////////////////
1220               0050
1221               0051               ***************************************************************
1222               0052               * FILM - Fill CPU memory with byte
1223               0053               ***************************************************************
1224               0054               *  bl   @film
1225               0055               *  data P0,P1,P2
1226               0056               *--------------------------------------------------------------
1227               0057               *  P0 = Memory start address
1228               0058               *  P1 = Byte to fill
1229               0059               *  P2 = Number of bytes to fill
1230               0060               *--------------------------------------------------------------
1231               0061               *  bl   @xfilm
1232               0062               *
1233               0063               *  TMP0 = Memory start address
1234               0064               *  TMP1 = Byte to fill
1235               0065               *  TMP2 = Number of bytes to fill
1236               0066               ********|*****|*********************|**************************
1237               0067 6278 C13B  30 film    mov   *r11+,tmp0            ; Memory start
1238               0068 627A C17B  30         mov   *r11+,tmp1            ; Byte to fill
1239               0069 627C C1BB  30         mov   *r11+,tmp2            ; Repeat count
1240               0070               *--------------------------------------------------------------
1241               0071               * Do some checks first
1242               0072               *--------------------------------------------------------------
1243               0073 627E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
1244               0074 6280 1604  14         jne   filchk                ; No, continue checking
1245               0075
1246               0076 6282 C80B  38         mov   r11,@>ffce            ; \ Save caller address
1247                    6284 FFCE
1248               0077 6286 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1249                    6288 2030
1250               0078               *--------------------------------------------------------------
1251               0079               *       Check: 1 byte fill
1252               0080               *--------------------------------------------------------------
1253               0081 628A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
1254                    628C 830B
1255                    628E 830A
1256               0082
1257               0083 6290 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
1258                    6292 0001
1259               0084 6294 1602  14         jne   filchk2
1260               0085 6296 DD05  32         movb  tmp1,*tmp0+
1261               0086 6298 045B  20         b     *r11                  ; Exit
1262               0087               *--------------------------------------------------------------
1263               0088               *       Check: 2 byte fill
1264               0089               *--------------------------------------------------------------
1265               0090 629A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
1266                    629C 0002
1267               0091 629E 1603  14         jne   filchk3
1268               0092 62A0 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
1269               0093 62A2 DD05  32         movb  tmp1,*tmp0+
1270               0094 62A4 045B  20         b     *r11                  ; Exit
1271               0095               *--------------------------------------------------------------
1272               0096               *       Check: Handle uneven start address
1273               0097               *--------------------------------------------------------------
1274               0098 62A6 C1C4  18 filchk3 mov   tmp0,tmp3
1275               0099 62A8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1276                    62AA 0001
1277               0100 62AC 1605  14         jne   fil16b
1278               0101 62AE DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
1279               0102 62B0 0606  14         dec   tmp2
1280               0103 62B2 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
1281                    62B4 0002
1282               0104 62B6 13F1  14         jeq   filchk2               ; Yes, copy word and exit
1283               0105               *--------------------------------------------------------------
1284               0106               *       Fill memory with 16 bit words
1285               0107               *--------------------------------------------------------------
1286               0108 62B8 C1C6  18 fil16b  mov   tmp2,tmp3
1287               0109 62BA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1288                    62BC 0001
1289               0110 62BE 1301  14         jeq   dofill
1290               0111 62C0 0606  14         dec   tmp2                  ; Make TMP2 even
1291               0112 62C2 CD05  34 dofill  mov   tmp1,*tmp0+
1292               0113 62C4 0646  14         dect  tmp2
1293               0114 62C6 16FD  14         jne   dofill
1294               0115               *--------------------------------------------------------------
1295               0116               * Fill last byte if ODD
1296               0117               *--------------------------------------------------------------
1297               0118 62C8 C1C7  18         mov   tmp3,tmp3
1298               0119 62CA 1301  14         jeq   fil.$$
1299               0120 62CC DD05  32         movb  tmp1,*tmp0+
1300               0121 62CE 045B  20 fil.$$  b     *r11
1301               0122
1302               0123
1303               0124               ***************************************************************
1304               0125               * FILV - Fill VRAM with byte
1305               0126               ***************************************************************
1306               0127               *  BL   @FILV
1307               0128               *  DATA P0,P1,P2
1308               0129               *--------------------------------------------------------------
1309               0130               *  P0 = VDP start address
1310               0131               *  P1 = Byte to fill
1311               0132               *  P2 = Number of bytes to fill
1312               0133               *--------------------------------------------------------------
1313               0134               *  BL   @XFILV
1314               0135               *
1315               0136               *  TMP0 = VDP start address
1316               0137               *  TMP1 = Byte to fill
1317               0138               *  TMP2 = Number of bytes to fill
1318               0139               ********|*****|*********************|**************************
1319               0140 62D0 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
1320               0141 62D2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
1321               0142 62D4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1322               0143               *--------------------------------------------------------------
1323               0144               *    Setup VDP write address
1324               0145               *--------------------------------------------------------------
1325               0146 62D6 0264  22 xfilv   ori   tmp0,>4000
1326                    62D8 4000
1327               0147 62DA 06C4  14         swpb  tmp0
1328               0148 62DC D804  38         movb  tmp0,@vdpa
1329                    62DE 8C02
1330               0149 62E0 06C4  14         swpb  tmp0
1331               0150 62E2 D804  38         movb  tmp0,@vdpa
1332                    62E4 8C02
1333               0151               *--------------------------------------------------------------
1334               0152               *    Fill bytes in VDP memory
1335               0153               *--------------------------------------------------------------
1336               0154 62E6 020F  20         li    r15,vdpw              ; Set VDP write address
1337                    62E8 8C00
1338               0155 62EA 06C5  14         swpb  tmp1
1339               0156 62EC C820  54         mov   @filzz,@mcloop        ; Setup move command
1340                    62EE 2294
1341                    62F0 8320
1342               0157 62F2 0460  28         b     @mcloop               ; Write data to VDP
1343                    62F4 8320
1344               0158               *--------------------------------------------------------------
1345               0162 62F6 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
1346               0164
1347               0165
1348               0166
1349               0167               *//////////////////////////////////////////////////////////////
1350               0168               *                  VDP LOW LEVEL FUNCTIONS
1351               0169               *//////////////////////////////////////////////////////////////
1352               0170
1353               0171               ***************************************************************
1354               0172               * VDWA / VDRA - Setup VDP write or read address
1355               0173               ***************************************************************
1356               0174               *  BL   @VDWA
1357               0175               *
1358               0176               *  TMP0 = VDP destination address for write
1359               0177               *--------------------------------------------------------------
1360               0178               *  BL   @VDRA
1361               0179               *
1362               0180               *  TMP0 = VDP source address for read
1363               0181               ********|*****|*********************|**************************
1364               0182 62F8 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
1365                    62FA 4000
1366               0183 62FC 06C4  14 vdra    swpb  tmp0
1367               0184 62FE D804  38         movb  tmp0,@vdpa
1368                    6300 8C02
1369               0185 6302 06C4  14         swpb  tmp0
1370               0186 6304 D804  38         movb  tmp0,@vdpa            ; Set VDP address
1371                    6306 8C02
1372               0187 6308 045B  20         b     *r11                  ; Exit
1373               0188
1374               0189               ***************************************************************
1375               0190               * VPUTB - VDP put single byte
1376               0191               ***************************************************************
1377               0192               *  BL @VPUTB
1378               0193               *  DATA P0,P1
1379               0194               *--------------------------------------------------------------
1380               0195               *  P0 = VDP target address
1381               0196               *  P1 = Byte to write
1382               0197               ********|*****|*********************|**************************
1383               0198 630A C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
1384               0199 630C C17B  30         mov   *r11+,tmp1            ; Get byte to write
1385               0200               *--------------------------------------------------------------
1386               0201               * Set VDP write address
1387               0202               *--------------------------------------------------------------
1388               0203 630E 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
1389                    6310 4000
1390               0204 6312 06C4  14         swpb  tmp0                  ; \
1391               0205 6314 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
1392                    6316 8C02
1393               0206 6318 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
1394               0207 631A D804  38         movb  tmp0,@vdpa            ; /
1395                    631C 8C02
1396               0208               *--------------------------------------------------------------
1397               0209               * Write byte
1398               0210               *--------------------------------------------------------------
1399               0211 631E 06C5  14         swpb  tmp1                  ; LSB to MSB
1400               0212 6320 D7C5  30         movb  tmp1,*r15             ; Write byte
1401               0213 6322 045B  20         b     *r11                  ; Exit
1402               0214
1403               0215
1404               0216               ***************************************************************
1405               0217               * VGETB - VDP get single byte
1406               0218               ***************************************************************
1407               0219               *  bl   @vgetb
1408               0220               *  data p0
1409               0221               *--------------------------------------------------------------
1410               0222               *  P0 = VDP source address
1411               0223               *--------------------------------------------------------------
1412               0224               *  bl   @xvgetb
1413               0225               *
1414               0226               *  tmp0 = VDP source address
1415               0227               *--------------------------------------------------------------
1416               0228               *  Output:
1417               0229               *  tmp0 MSB = >00
1418               0230               *  tmp0 LSB = VDP byte read
1419               0231               ********|*****|*********************|**************************
1420               0232 6324 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
1421               0233               *--------------------------------------------------------------
1422               0234               * Set VDP read address
1423               0235               *--------------------------------------------------------------
1424               0236 6326 06C4  14 xvgetb  swpb  tmp0                  ; \
1425               0237 6328 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
1426                    632A 8C02
1427               0238 632C 06C4  14         swpb  tmp0                  ; | inlined @vdra call
1428               0239 632E D804  38         movb  tmp0,@vdpa            ; /
1429                    6330 8C02
1430               0240               *--------------------------------------------------------------
1431               0241               * Read byte
1432               0242               *--------------------------------------------------------------
1433               0243 6332 D120  34         movb  @vdpr,tmp0            ; Read byte
1434                    6334 8800
1435               0244 6336 0984  56         srl   tmp0,8                ; Right align
1436               0245 6338 045B  20         b     *r11                  ; Exit
1437               0246
1438               0247
1439               0248               ***************************************************************
1440               0249               * VIDTAB - Dump videomode table
1441               0250               ***************************************************************
1442               0251               *  BL   @VIDTAB
1443               0252               *  DATA P0
1444               0253               *--------------------------------------------------------------
1445               0254               *  P0 = Address of video mode table
1446               0255               *--------------------------------------------------------------
1447               0256               *  BL   @XIDTAB
1448               0257               *
1449               0258               *  TMP0 = Address of video mode table
1450               0259               *--------------------------------------------------------------
1451               0260               *  Remarks
1452               0261               *  TMP1 = MSB is the VDP target register
1453               0262               *         LSB is the value to write
1454               0263               ********|*****|*********************|**************************
1455               0264 633A C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
1456               0265 633C C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
1457               0266               *--------------------------------------------------------------
1458               0267               * Calculate PNT base address
1459               0268               *--------------------------------------------------------------
1460               0269 633E C144  18         mov   tmp0,tmp1
1461               0270 6340 05C5  14         inct  tmp1
1462               0271 6342 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
1463               0272 6344 0245  22         andi  tmp1,>ff00            ; Only keep MSB
1464                    6346 FF00
1465               0273 6348 0A25  56         sla   tmp1,2                ; TMP1 *= 400
1466               0274 634A C805  38         mov   tmp1,@wbase           ; Store calculated base
1467                    634C 8328
1468               0275               *--------------------------------------------------------------
1469               0276               * Dump VDP shadow registers
1470               0277               *--------------------------------------------------------------
1471               0278 634E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
1472                    6350 8000
1473               0279 6352 0206  20         li    tmp2,8
1474                    6354 0008
1475               0280 6356 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
1476                    6358 830B
1477               0281 635A 06C5  14         swpb  tmp1
1478               0282 635C D805  38         movb  tmp1,@vdpa
1479                    635E 8C02
1480               0283 6360 06C5  14         swpb  tmp1
1481               0284 6362 D805  38         movb  tmp1,@vdpa
1482                    6364 8C02
1483               0285 6366 0225  22         ai    tmp1,>0100
1484                    6368 0100
1485               0286 636A 0606  14         dec   tmp2
1486               0287 636C 16F4  14         jne   vidta1                ; Next register
1487               0288 636E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
1488                    6370 833A
1489               0289 6372 045B  20         b     *r11
1490               0290
1491               0291
1492               0292               ***************************************************************
1493               0293               * PUTVR  - Put single VDP register
1494               0294               ***************************************************************
1495               0295               *  BL   @PUTVR
1496               0296               *  DATA P0
1497               0297               *--------------------------------------------------------------
1498               0298               *  P0 = MSB is the VDP target register
1499               0299               *       LSB is the value to write
1500               0300               *--------------------------------------------------------------
1501               0301               *  BL   @PUTVRX
1502               0302               *
1503               0303               *  TMP0 = MSB is the VDP target register
1504               0304               *         LSB is the value to write
1505               0305               ********|*****|*********************|**************************
1506               0306 6374 C13B  30 putvr   mov   *r11+,tmp0
1507               0307 6376 0264  22 putvrx  ori   tmp0,>8000
1508                    6378 8000
1509               0308 637A 06C4  14         swpb  tmp0
1510               0309 637C D804  38         movb  tmp0,@vdpa
1511                    637E 8C02
1512               0310 6380 06C4  14         swpb  tmp0
1513               0311 6382 D804  38         movb  tmp0,@vdpa
1514                    6384 8C02
1515               0312 6386 045B  20         b     *r11
1516               0313
1517               0314
1518               0315               ***************************************************************
1519               0316               * PUTV01  - Put VDP registers #0 and #1
1520               0317               ***************************************************************
1521               0318               *  BL   @PUTV01
1522               0319               ********|*****|*********************|**************************
1523               0320 6388 C20B  18 putv01  mov   r11,tmp4              ; Save R11
1524               0321 638A C10E  18         mov   r14,tmp0
1525               0322 638C 0984  56         srl   tmp0,8
1526               0323 638E 06A0  32         bl    @putvrx               ; Write VR#0
1527                    6390 2314
1528               0324 6392 0204  20         li    tmp0,>0100
1529                    6394 0100
1530               0325 6396 D820  54         movb  @r14lb,@tmp0lb
1531                    6398 831D
1532                    639A 8309
1533               0326 639C 06A0  32         bl    @putvrx               ; Write VR#1
1534                    639E 2314
1535               0327 63A0 0458  20         b     *tmp4                 ; Exit
1536               0328
1537               0329
1538               0330               ***************************************************************
1539               0331               * LDFNT - Load TI-99/4A font from GROM into VDP
1540               0332               ***************************************************************
1541               0333               *  BL   @LDFNT
1542               0334               *  DATA P0,P1
1543               0335               *--------------------------------------------------------------
1544               0336               *  P0 = VDP Target address
1545               0337               *  P1 = Font options
1546               0338               *--------------------------------------------------------------
1547               0339               * Uses registers tmp0-tmp4
1548               0340               ********|*****|*********************|**************************
1549               0341 63A2 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
1550               0342 63A4 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
1551               0343 63A6 C11B  26         mov   *r11,tmp0             ; Get P0
1552               0344 63A8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1553                    63AA 7FFF
1554               0345 63AC 2120  38         coc   @wbit0,tmp0
1555                    63AE 202A
1556               0346 63B0 1604  14         jne   ldfnt1
1557               0347 63B2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
1558                    63B4 8000
1559               0348 63B6 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
1560                    63B8 7FFF
1561               0349               *--------------------------------------------------------------
1562               0350               * Read font table address from GROM into tmp1
1563               0351               *--------------------------------------------------------------
1564               0352 63BA C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
1565                    63BC 23C2
1566               0353 63BE D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
1567                    63C0 9C02
1568               0354 63C2 06C4  14         swpb  tmp0
1569               0355 63C4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
1570                    63C6 9C02
1571               0356 63C8 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
1572                    63CA 9800
1573               0357 63CC 06C5  14         swpb  tmp1
1574               0358 63CE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
1575                    63D0 9800
1576               0359 63D2 06C5  14         swpb  tmp1
1577               0360               *--------------------------------------------------------------
1578               0361               * Setup GROM source address from tmp1
1579               0362               *--------------------------------------------------------------
1580               0363 63D4 D805  38         movb  tmp1,@grmwa
1581                    63D6 9C02
1582               0364 63D8 06C5  14         swpb  tmp1
1583               0365 63DA D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
1584                    63DC 9C02
1585               0366               *--------------------------------------------------------------
1586               0367               * Setup VDP target address
1587               0368               *--------------------------------------------------------------
1588               0369 63DE C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
1589               0370 63E0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
1590                    63E2 2296
1591               0371 63E4 05C8  14         inct  tmp4                  ; R11=R11+2
1592               0372 63E6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
1593               0373 63E8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
1594                    63EA 7FFF
1595               0374 63EC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
1596                    63EE 23C4
1597               0375 63F0 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
1598                    63F2 23C6
1599               0376               *--------------------------------------------------------------
1600               0377               * Copy from GROM to VRAM
1601               0378               *--------------------------------------------------------------
1602               0379 63F4 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
1603               0380 63F6 1812  14         joc   ldfnt4                ; Yes, go insert a >00
1604               0381 63F8 D120  34         movb  @grmrd,tmp0
1605                    63FA 9800
1606               0382               *--------------------------------------------------------------
1607               0383               *   Make font fat
1608               0384               *--------------------------------------------------------------
1609               0385 63FC 20A0  38         coc   @wbit0,config         ; Fat flag set ?
1610                    63FE 202A
1611               0386 6400 1603  14         jne   ldfnt3                ; No, so skip
1612               0387 6402 D1C4  18         movb  tmp0,tmp3
1613               0388 6404 0917  56         srl   tmp3,1
1614               0389 6406 E107  18         soc   tmp3,tmp0
1615               0390               *--------------------------------------------------------------
1616               0391               *   Dump byte to VDP and do housekeeping
1617               0392               *--------------------------------------------------------------
1618               0393 6408 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
1619                    640A 8C00
1620               0394 640C 0606  14         dec   tmp2
1621               0395 640E 16F2  14         jne   ldfnt2
1622               0396 6410 05C8  14         inct  tmp4                  ; R11=R11+2
1623               0397 6412 020F  20         li    r15,vdpw              ; Set VDP write address
1624                    6414 8C00
1625               0398 6416 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1626                    6418 7FFF
1627               0399 641A 0458  20         b     *tmp4                 ; Exit
1628               0400 641C D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
1629                    641E 200A
1630                    6420 8C00
1631               0401 6422 10E8  14         jmp   ldfnt2
1632               0402               *--------------------------------------------------------------
1633               0403               * Fonts pointer table
1634               0404               *--------------------------------------------------------------
1635               0405 6424 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
1636                    6426 0200
1637                    6428 0000
1638               0406 642A 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
1639                    642C 01C0
1640                    642E 0101
1641               0407 6430 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
1642                    6432 02A0
1643                    6434 0101
1644               0408 6436 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
1645                    6438 00E0
1646                    643A 0101
1647               0409
1648               0410
1649               0411
1650               0412               ***************************************************************
1651               0413               * YX2PNT - Get VDP PNT address for current YX cursor position
1652               0414               ***************************************************************
1653               0415               *  BL   @YX2PNT
1654               0416               *--------------------------------------------------------------
1655               0417               *  INPUT
1656               0418               *  @WYX = Cursor YX position
1657               0419               *--------------------------------------------------------------
1658               0420               *  OUTPUT
1659               0421               *  TMP0 = VDP address for entry in Pattern Name Table
1660               0422               *--------------------------------------------------------------
1661               0423               *  Register usage
1662               0424               *  TMP0, R14, R15
1663               0425               ********|*****|*********************|**************************
1664               0426 643C C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
1665               0427 643E C3A0  34         mov   @wyx,r14              ; Get YX
1666                    6440 832A
1667               0428 6442 098E  56         srl   r14,8                 ; Right justify (remove X)
1668               0429 6444 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
1669                    6446 833A
1670               0430               *--------------------------------------------------------------
1671               0431               * Do rest of calculation with R15 (16 bit part is there)
1672               0432               * Re-use R14
1673               0433               *--------------------------------------------------------------
1674               0434 6448 C3A0  34         mov   @wyx,r14              ; Get YX
1675                    644A 832A
1676               0435 644C 024E  22         andi  r14,>00ff             ; Remove Y
1677                    644E 00FF
1678               0436 6450 A3CE  18         a     r14,r15               ; pos = pos + X
1679               0437 6452 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
1680                    6454 8328
1681               0438               *--------------------------------------------------------------
1682               0439               * Clean up before exit
1683               0440               *--------------------------------------------------------------
1684               0441 6456 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
1685               0442 6458 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
1686               0443 645A 020F  20         li    r15,vdpw              ; VDP write address
1687                    645C 8C00
1688               0444 645E 045B  20         b     *r11
1689               0445
1690               0446
1691               0447
1692               0448               ***************************************************************
1693               0449               * Put length-byte prefixed string at current YX
1694               0450               ***************************************************************
1695               0451               *  BL   @PUTSTR
1696               0452               *  DATA P0
1697               0453               *
1698               0454               *  P0 = Pointer to string
1699               0455               *--------------------------------------------------------------
1700               0456               *  REMARKS
1701               0457               *  First byte of string must contain length
1702               0458               ********|*****|*********************|**************************
1703               0459 6460 C17B  30 putstr  mov   *r11+,tmp1
1704               0460 6462 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
1705               0461 6464 C1CB  18 xutstr  mov   r11,tmp3
1706               0462 6466 06A0  32         bl    @yx2pnt               ; Get VDP destination address
1707                    6468 23DA
1708               0463 646A C2C7  18         mov   tmp3,r11
1709               0464 646C 0986  56         srl   tmp2,8                ; Right justify length byte
1710               0465 646E 0460  28         b     @xpym2v               ; Display string
1711                    6470 241E
1712               0466
1713               0467
1714               0468               ***************************************************************
1715               0469               * Put length-byte prefixed string at YX
1716               0470               ***************************************************************
1717               0471               *  BL   @PUTAT
1718               0472               *  DATA P0,P1
1719               0473               *
1720               0474               *  P0 = YX position
1721               0475               *  P1 = Pointer to string
1722               0476               *--------------------------------------------------------------
1723               0477               *  REMARKS
1724               0478               *  First byte of string must contain length
1725               0479               ********|*****|*********************|**************************
1726               0480 6472 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
1727                    6474 832A
1728               0481 6476 0460  28         b     @putstr
1729                    6478 23FE
1730               **** **** ****     > runlib.asm
1731               0090
1732               0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
1733               **** **** ****     > copy_cpu_vram.asm
1734               0001               * FILE......: copy_cpu_vram.asm
1735               0002               * Purpose...: CPU memory to VRAM copy support module
1736               0003
1737               0004               ***************************************************************
1738               0005               * CPYM2V - Copy CPU memory to VRAM
1739               0006               ***************************************************************
1740               0007               *  BL   @CPYM2V
1741               0008               *  DATA P0,P1,P2
1742               0009               *--------------------------------------------------------------
1743               0010               *  P0 = VDP start address
1744               0011               *  P1 = RAM/ROM start address
1745               0012               *  P2 = Number of bytes to copy
1746               0013               *--------------------------------------------------------------
1747               0014               *  BL @XPYM2V
1748               0015               *
1749               0016               *  TMP0 = VDP start address
1750               0017               *  TMP1 = RAM/ROM start address
1751               0018               *  TMP2 = Number of bytes to copy
1752               0019               ********|*****|*********************|**************************
1753               0020 647A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
1754               0021 647C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
1755               0022 647E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1756               0023               *--------------------------------------------------------------
1757               0024               *    Setup VDP write address
1758               0025               *--------------------------------------------------------------
1759               0026 6480 0264  22 xpym2v  ori   tmp0,>4000
1760                    6482 4000
1761               0027 6484 06C4  14         swpb  tmp0
1762               0028 6486 D804  38         movb  tmp0,@vdpa
1763                    6488 8C02
1764               0029 648A 06C4  14         swpb  tmp0
1765               0030 648C D804  38         movb  tmp0,@vdpa
1766                    648E 8C02
1767               0031               *--------------------------------------------------------------
1768               0032               *    Copy bytes from CPU memory to VRAM
1769               0033               *--------------------------------------------------------------
1770               0034 6490 020F  20         li    r15,vdpw              ; Set VDP write address
1771                    6492 8C00
1772               0035 6494 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
1773                    6496 243C
1774                    6498 8320
1775               0036 649A 0460  28         b     @mcloop               ; Write data to VDP
1776                    649C 8320
1777               0037 649E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
1778               **** **** ****     > runlib.asm
1779               0094
1780               0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
1781               **** **** ****     > copy_vram_cpu.asm
1782               0001               * FILE......: copy_vram_cpu.asm
1783               0002               * Purpose...: VRAM to CPU memory copy support module
1784               0003
1785               0004               ***************************************************************
1786               0005               * CPYV2M - Copy VRAM to CPU memory
1787               0006               ***************************************************************
1788               0007               *  BL   @CPYV2M
1789               0008               *  DATA P0,P1,P2
1790               0009               *--------------------------------------------------------------
1791               0010               *  P0 = VDP source address
1792               0011               *  P1 = RAM target address
1793               0012               *  P2 = Number of bytes to copy
1794               0013               *--------------------------------------------------------------
1795               0014               *  BL @XPYV2M
1796               0015               *
1797               0016               *  TMP0 = VDP source address
1798               0017               *  TMP1 = RAM target address
1799               0018               *  TMP2 = Number of bytes to copy
1800               0019               ********|*****|*********************|**************************
1801               0020 64A0 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
1802               0021 64A2 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
1803               0022 64A4 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1804               0023               *--------------------------------------------------------------
1805               0024               *    Setup VDP read address
1806               0025               *--------------------------------------------------------------
1807               0026 64A6 06C4  14 xpyv2m  swpb  tmp0
1808               0027 64A8 D804  38         movb  tmp0,@vdpa
1809                    64AA 8C02
1810               0028 64AC 06C4  14         swpb  tmp0
1811               0029 64AE D804  38         movb  tmp0,@vdpa
1812                    64B0 8C02
1813               0030               *--------------------------------------------------------------
1814               0031               *    Copy bytes from VDP memory to RAM
1815               0032               *--------------------------------------------------------------
1816               0033 64B2 020F  20         li    r15,vdpr              ; Set VDP read address
1817                    64B4 8800
1818               0034 64B6 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
1819                    64B8 245E
1820                    64BA 8320
1821               0035 64BC 0460  28         b     @mcloop               ; Read data from VDP
1822                    64BE 8320
1823               0036 64C0 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
1824               **** **** ****     > runlib.asm
1825               0098
1826               0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
1827               **** **** ****     > copy_cpu_cpu.asm
1828               0001               * FILE......: copy_cpu_cpu.asm
1829               0002               * Purpose...: CPU to CPU memory copy support module
1830               0003
1831               0004               *//////////////////////////////////////////////////////////////
1832               0005               *                       CPU COPY FUNCTIONS
1833               0006               *//////////////////////////////////////////////////////////////
1834               0007
1835               0008               ***************************************************************
1836               0009               * CPYM2M - Copy CPU memory to CPU memory
1837               0010               ***************************************************************
1838               0011               *  BL   @CPYM2M
1839               0012               *  DATA P0,P1,P2
1840               0013               *--------------------------------------------------------------
1841               0014               *  P0 = Memory source address
1842               0015               *  P1 = Memory target address
1843               0016               *  P2 = Number of bytes to copy
1844               0017               *--------------------------------------------------------------
1845               0018               *  BL @XPYM2M
1846               0019               *
1847               0020               *  TMP0 = Memory source address
1848               0021               *  TMP1 = Memory target address
1849               0022               *  TMP2 = Number of bytes to copy
1850               0023               ********|*****|*********************|**************************
1851               0024 64C2 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
1852               0025 64C4 C17B  30         mov   *r11+,tmp1            ; Memory target address
1853               0026 64C6 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
1854               0027               *--------------------------------------------------------------
1855               0028               * Do some checks first
1856               0029               *--------------------------------------------------------------
1857               0030 64C8 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
1858               0031 64CA 1604  14         jne   cpychk                ; No, continue checking
1859               0032
1860               0033 64CC C80B  38         mov   r11,@>ffce            ; \ Save caller address
1861                    64CE FFCE
1862               0034 64D0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1863                    64D2 2030
1864               0035               *--------------------------------------------------------------
1865               0036               *    Check: 1 byte copy
1866               0037               *--------------------------------------------------------------
1867               0038 64D4 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
1868                    64D6 0001
1869               0039 64D8 1603  14         jne   cpym0                 ; No, continue checking
1870               0040 64DA DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
1871               0041 64DC 04C6  14         clr   tmp2                  ; Reset counter
1872               0042 64DE 045B  20         b     *r11                  ; Return to caller
1873               0043               *--------------------------------------------------------------
1874               0044               *    Check: Uneven address handling
1875               0045               *--------------------------------------------------------------
1876               0046 64E0 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
1877                    64E2 7FFF
1878               0047 64E4 C1C4  18         mov   tmp0,tmp3
1879               0048 64E6 0247  22         andi  tmp3,1
1880                    64E8 0001
1881               0049 64EA 1618  14         jne   cpyodd                ; Odd source address handling
1882               0050 64EC C1C5  18 cpym1   mov   tmp1,tmp3
1883               0051 64EE 0247  22         andi  tmp3,1
1884                    64F0 0001
1885               0052 64F2 1614  14         jne   cpyodd                ; Odd target address handling
1886               0053               *--------------------------------------------------------------
1887               0054               * 8 bit copy
1888               0055               *--------------------------------------------------------------
1889               0056 64F4 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
1890                    64F6 202A
1891               0057 64F8 1605  14         jne   cpym3
1892               0058 64FA C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
1893                    64FC 24C0
1894                    64FE 8320
1895               0059 6500 0460  28         b     @mcloop               ; Copy memory and exit
1896                    6502 8320
1897               0060               *--------------------------------------------------------------
1898               0061               * 16 bit copy
1899               0062               *--------------------------------------------------------------
1900               0063 6504 C1C6  18 cpym3   mov   tmp2,tmp3
1901               0064 6506 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1902                    6508 0001
1903               0065 650A 1301  14         jeq   cpym4
1904               0066 650C 0606  14         dec   tmp2                  ; Make TMP2 even
1905               0067 650E CD74  46 cpym4   mov   *tmp0+,*tmp1+
1906               0068 6510 0646  14         dect  tmp2
1907               0069 6512 16FD  14         jne   cpym4
1908               0070               *--------------------------------------------------------------
1909               0071               * Copy last byte if ODD
1910               0072               *--------------------------------------------------------------
1911               0073 6514 C1C7  18         mov   tmp3,tmp3
1912               0074 6516 1301  14         jeq   cpymz
1913               0075 6518 D554  38         movb  *tmp0,*tmp1
1914               0076 651A 045B  20 cpymz   b     *r11                  ; Return to caller
1915               0077               *--------------------------------------------------------------
1916               0078               * Handle odd source/target address
1917               0079               *--------------------------------------------------------------
1918               0080 651C 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
1919                    651E 8000
1920               0081 6520 10E9  14         jmp   cpym2
1921               0082 6522 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
1922               **** **** ****     > runlib.asm
1923               0102
1924               0106
1925               0110
1926               0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
1927               **** **** ****     > cpu_sams_support.asm
1928               0001               * FILE......: cpu_sams_support.asm
1929               0002               * Purpose...: Low level support for SAMS memory expansion card
1930               0003
1931               0004               *//////////////////////////////////////////////////////////////
1932               0005               *                SAMS Memory Expansion support
1933               0006               *//////////////////////////////////////////////////////////////
1934               0007
1935               0008               *--------------------------------------------------------------
1936               0009               * ACCESS and MAPPING
1937               0010               * (by the late Bruce Harisson):
1938               0011               *
1939               0012               * To use other than the default setup, you have to do two
1940               0013               * things:
1941               0014               *
1942               0015               * 1. You have to "turn on" the card's memory in the
1943               0016               *    >4000 block and write to the mapping registers there.
1944               0017               *    (bl  @sams.page.set)
1945               0018               *
1946               0019               * 2. You have to "turn on" the mapper function to make what
1947               0020               *    you've written into the >4000 block take effect.
1948               0021               *    (bl  @sams.mapping.on)
1949               0022               *--------------------------------------------------------------
1950               0023               *  SAMS                          Default SAMS page
1951               0024               *  Register     Memory bank      (system startup)
1952               0025               *  =======      ===========      ================
1953               0026               *  >4004        >2000-2fff          >002
1954               0027               *  >4006        >3000-4fff          >003
1955               0028               *  >4014        >a000-afff          >00a
1956               0029               *  >4016        >b000-bfff          >00b
1957               0030               *  >4018        >c000-cfff          >00c
1958               0031               *  >401a        >d000-dfff          >00d
1959               0032               *  >401c        >e000-efff          >00e
1960               0033               *  >401e        >f000-ffff          >00f
1961               0034               *  Others       Inactive
1962               0035               *--------------------------------------------------------------
1963               0036
1964               0037
1965               0038
1966               0039
1967               0040               ***************************************************************
1968               0041               * sams.page.get - Get SAMS page number for memory address
1969               0042               ***************************************************************
1970               0043               * bl   @sams.page.get
1971               0044               *      data P0
1972               0045               *--------------------------------------------------------------
1973               0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
1974               0047               *      register >4014 (bank >a000 - >afff)
1975               0048               *--------------------------------------------------------------
1976               0049               * bl   @xsams.page.get
1977               0050               *
1978               0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
1979               0052               *        register >4014 (bank >a000 - >afff)
1980               0053               *--------------------------------------------------------------
1981               0054               * OUTPUT
1982               0055               * waux1 = SAMS page number
1983               0056               * waux2 = Address of affected SAMS register
1984               0057               *--------------------------------------------------------------
1985               0058               * Register usage
1986               0059               * r0, tmp0, r12
1987               0060               ********|*****|*********************|**************************
1988               0061               sams.page.get:
1989               0062 6524 C13B  30         mov   *r11+,tmp0            ; Memory address
1990               0063               xsams.page.get:
1991               0064 6526 0649  14         dect  stack
1992               0065 6528 C64B  30         mov   r11,*stack            ; Push return address
1993               0066 652A 0649  14         dect  stack
1994               0067 652C C640  30         mov   r0,*stack             ; Push r0
1995               0068 652E 0649  14         dect  stack
1996               0069 6530 C64C  30         mov   r12,*stack            ; Push r12
1997               0070               *--------------------------------------------------------------
1998               0071               * Determine memory bank
1999               0072               *--------------------------------------------------------------
2000               0073 6532 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
2001               0074 6534 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
2002               0075
2003               0076 6536 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
2004                    6538 4000
2005               0077 653A C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
2006                    653C 833E
2007               0078               *--------------------------------------------------------------
2008               0079               * Switch memory bank to specified SAMS page
2009               0080               *--------------------------------------------------------------
2010               0081 653E 020C  20         li    r12,>1e00             ; SAMS CRU address
2011                    6540 1E00
2012               0082 6542 04C0  14         clr   r0
2013               0083 6544 1D00  20         sbo   0                     ; Enable access to SAMS registers
2014               0084 6546 D014  26         movb  *tmp0,r0              ; Get SAMS page number
2015               0085 6548 D100  18         movb  r0,tmp0
2016               0086 654A 0984  56         srl   tmp0,8                ; Right align
2017               0087 654C C804  38         mov   tmp0,@waux1           ; Save SAMS page number
2018                    654E 833C
2019               0088 6550 1E00  20         sbz   0                     ; Disable access to SAMS registers
2020               0089               *--------------------------------------------------------------
2021               0090               * Exit
2022               0091               *--------------------------------------------------------------
2023               0092               sams.page.get.exit:
2024               0093 6552 C339  30         mov   *stack+,r12           ; Pop r12
2025               0094 6554 C039  30         mov   *stack+,r0            ; Pop r0
2026               0095 6556 C2F9  30         mov   *stack+,r11           ; Pop return address
2027               0096 6558 045B  20         b     *r11                  ; Return to caller
2028               0097
2029               0098
2030               0099
2031               0100
2032               0101               ***************************************************************
2033               0102               * sams.page.set - Set SAMS memory page
2034               0103               ***************************************************************
2035               0104               * bl   sams.page.set
2036               0105               *      data P0,P1
2037               0106               *--------------------------------------------------------------
2038               0107               * P0 = SAMS page number
2039               0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
2040               0109               *      register >4014 (bank >a000 - >afff)
2041               0110               *--------------------------------------------------------------
2042               0111               * bl   @xsams.page.set
2043               0112               *
2044               0113               * tmp0 = SAMS page number
2045               0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
2046               0115               *        register >4014 (bank >a000 - >afff)
2047               0116               *--------------------------------------------------------------
2048               0117               * Register usage
2049               0118               * r0, tmp0, tmp1, r12
2050               0119               *--------------------------------------------------------------
2051               0120               * SAMS page number should be in range 0-255 (>00 to >ff)
2052               0121               *
2053               0122               *  Page         Memory
2054               0123               *  ====         ======
2055               0124               *  >00             32K
2056               0125               *  >1f            128K
2057               0126               *  >3f            256K
2058               0127               *  >7f            512K
2059               0128               *  >ff           1024K
2060               0129               ********|*****|*********************|**************************
2061               0130               sams.page.set:
2062               0131 655A C13B  30         mov   *r11+,tmp0            ; Get SAMS page
2063               0132 655C C17B  30         mov   *r11+,tmp1            ; Get memory address
2064               0133               xsams.page.set:
2065               0134 655E 0649  14         dect  stack
2066               0135 6560 C64B  30         mov   r11,*stack            ; Push return address
2067               0136 6562 0649  14         dect  stack
2068               0137 6564 C640  30         mov   r0,*stack             ; Push r0
2069               0138 6566 0649  14         dect  stack
2070               0139 6568 C64C  30         mov   r12,*stack            ; Push r12
2071               0140 656A 0649  14         dect  stack
2072               0141 656C C644  30         mov   tmp0,*stack           ; Push tmp0
2073               0142 656E 0649  14         dect  stack
2074               0143 6570 C645  30         mov   tmp1,*stack           ; Push tmp1
2075               0144               *--------------------------------------------------------------
2076               0145               * Determine memory bank
2077               0146               *--------------------------------------------------------------
2078               0147 6572 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
2079               0148 6574 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
2080               0149               *--------------------------------------------------------------
2081               0150               * Sanity check on SAMS register
2082               0151               *--------------------------------------------------------------
2083               0152 6576 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
2084                    6578 001E
2085               0153 657A 150A  14         jgt   !
2086               0154 657C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
2087                    657E 0004
2088               0155 6580 1107  14         jlt   !
2089               0156 6582 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
2090                    6584 0012
2091               0157 6586 1508  14         jgt   sams.page.set.switch_page
2092               0158 6588 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
2093                    658A 0006
2094               0159 658C 1501  14         jgt   !
2095               0160 658E 1004  14         jmp   sams.page.set.switch_page
2096               0161                       ;------------------------------------------------------
2097               0162                       ; Crash the system
2098               0163                       ;------------------------------------------------------
2099               0164 6590 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
2100                    6592 FFCE
2101               0165 6594 06A0  32         bl    @cpu.crash            ; / Crash and halt system
2102                    6596 2030
2103               0166               *--------------------------------------------------------------
2104               0167               * Switch memory bank to specified SAMS page
2105               0168               *--------------------------------------------------------------
2106               0169               sams.page.set.switch_page
2107               0170 6598 020C  20         li    r12,>1e00             ; SAMS CRU address
2108                    659A 1E00
2109               0171 659C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
2110               0172 659E 06C0  14         swpb  r0                    ; LSB to MSB
2111               0173 65A0 1D00  20         sbo   0                     ; Enable access to SAMS registers
2112               0174 65A2 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
2113                    65A4 4000
2114               0175 65A6 1E00  20         sbz   0                     ; Disable access to SAMS registers
2115               0176               *--------------------------------------------------------------
2116               0177               * Exit
2117               0178               *--------------------------------------------------------------
2118               0179               sams.page.set.exit:
2119               0180 65A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2120               0181 65AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
2121               0182 65AC C339  30         mov   *stack+,r12           ; Pop r12
2122               0183 65AE C039  30         mov   *stack+,r0            ; Pop r0
2123               0184 65B0 C2F9  30         mov   *stack+,r11           ; Pop return address
2124               0185 65B2 045B  20         b     *r11                  ; Return to caller
2125               0186
2126               0187
2127               0188
2128               0189
2129               0190               ***************************************************************
2130               0191               * sams.mapping.on - Enable SAMS mapping mode
2131               0192               ***************************************************************
2132               0193               *  bl   @sams.mapping.on
2133               0194               *--------------------------------------------------------------
2134               0195               *  Register usage
2135               0196               *  r12
2136               0197               ********|*****|*********************|**************************
2137               0198               sams.mapping.on:
2138               0199 65B4 020C  20         li    r12,>1e00             ; SAMS CRU address
2139                    65B6 1E00
2140               0200 65B8 1D01  20         sbo   1                     ; Enable SAMS mapper
2141               0201               *--------------------------------------------------------------
2142               0202               * Exit
2143               0203               *--------------------------------------------------------------
2144               0204               sams.mapping.on.exit:
2145               0205 65BA 045B  20         b     *r11                  ; Return to caller
2146               0206
2147               0207
2148               0208
2149               0209
2150               0210               ***************************************************************
2151               0211               * sams.mapping.off - Disable SAMS mapping mode
2152               0212               ***************************************************************
2153               0213               * bl  @sams.mapping.off
2154               0214               *--------------------------------------------------------------
2155               0215               * OUTPUT
2156               0216               * none
2157               0217               *--------------------------------------------------------------
2158               0218               * Register usage
2159               0219               * r12
2160               0220               ********|*****|*********************|**************************
2161               0221               sams.mapping.off:
2162               0222 65BC 020C  20         li    r12,>1e00             ; SAMS CRU address
2163                    65BE 1E00
2164               0223 65C0 1E01  20         sbz   1                     ; Disable SAMS mapper
2165               0224               *--------------------------------------------------------------
2166               0225               * Exit
2167               0226               *--------------------------------------------------------------
2168               0227               sams.mapping.off.exit:
2169               0228 65C2 045B  20         b     *r11                  ; Return to caller
2170               0229
2171               0230
2172               0231
2173               0232
2174               0233
2175               0234               ***************************************************************
2176               0235               * sams.layout
2177               0236               * Setup SAMS memory banks
2178               0237               ***************************************************************
2179               0238               * bl  @sams.layout
2180               0239               *     data P0
2181               0240               *--------------------------------------------------------------
2182               0241               * INPUT
2183               0242               * P0 = Pointer to SAMS page layout table (16 words).
2184               0243               *--------------------------------------------------------------
2185               0244               * bl  @xsams.layout
2186               0245               *
2187               0246               * tmp0 = Pointer to SAMS page layout table (16 words).
2188               0247               *--------------------------------------------------------------
2189               0248               * OUTPUT
2190               0249               * none
2191               0250               *--------------------------------------------------------------
2192               0251               * Register usage
2193               0252               * tmp0, tmp1, tmp2, tmp3
2194               0253               ********|*****|*********************|**************************
2195               0254               sams.layout:
2196               0255 65C4 C1FB  30         mov   *r11+,tmp3            ; Get P0
2197               0256               xsams.layout:
2198               0257 65C6 0649  14         dect  stack
2199               0258 65C8 C64B  30         mov   r11,*stack            ; Save return address
2200               0259 65CA 0649  14         dect  stack
2201               0260 65CC C644  30         mov   tmp0,*stack           ; Save tmp0
2202               0261 65CE 0649  14         dect  stack
2203               0262 65D0 C645  30         mov   tmp1,*stack           ; Save tmp1
2204               0263 65D2 0649  14         dect  stack
2205               0264 65D4 C646  30         mov   tmp2,*stack           ; Save tmp2
2206               0265 65D6 0649  14         dect  stack
2207               0266 65D8 C647  30         mov   tmp3,*stack           ; Save tmp3
2208               0267                       ;------------------------------------------------------
2209               0268                       ; Initialize
2210               0269                       ;------------------------------------------------------
2211               0270 65DA 0206  20         li    tmp2,8                ; Set loop counter
2212                    65DC 0008
2213               0271                       ;------------------------------------------------------
2214               0272                       ; Set SAMS memory pages
2215               0273                       ;------------------------------------------------------
2216               0274               sams.layout.loop:
2217               0275 65DE C177  30         mov   *tmp3+,tmp1           ; Get memory address
2218               0276 65E0 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
2219               0277
2220               0278 65E2 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
2221                    65E4 24FC
2222               0279                                                   ; | i  tmp0 = SAMS page
2223               0280                                                   ; / i  tmp1 = Memory address
2224               0281
2225               0282 65E6 0606  14         dec   tmp2                  ; Next iteration
2226               0283 65E8 16FA  14         jne   sams.layout.loop      ; Loop until done
2227               0284                       ;------------------------------------------------------
2228               0285                       ; Exit
2229               0286                       ;------------------------------------------------------
2230               0287               sams.init.exit:
2231               0288 65EA 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
2232                    65EC 2552
2233               0289                                                   ; / activating changes.
2234               0290
2235               0291 65EE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2236               0292 65F0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2237               0293 65F2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2238               0294 65F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2239               0295 65F6 C2F9  30         mov   *stack+,r11           ; Pop r11
2240               0296 65F8 045B  20         b     *r11                  ; Return to caller
2241               0297
2242               0298
2243               0299
2244               0300               ***************************************************************
2245               0301               * sams.reset.layout
2246               0302               * Reset SAMS memory banks to standard layout
2247               0303               ***************************************************************
2248               0304               * bl  @sams.reset.layout
2249               0305               *--------------------------------------------------------------
2250               0306               * OUTPUT
2251               0307               * none
2252               0308               *--------------------------------------------------------------
2253               0309               * Register usage
2254               0310               * none
2255               0311               ********|*****|*********************|**************************
2256               0312               sams.reset.layout:
2257               0313 65FA 0649  14         dect  stack
2258               0314 65FC C64B  30         mov   r11,*stack            ; Save return address
2259               0315                       ;------------------------------------------------------
2260               0316                       ; Set SAMS standard layout
2261               0317                       ;------------------------------------------------------
2262               0318 65FE 06A0  32         bl    @sams.layout
2263                    6600 2562
2264               0319 6602 25A6                   data sams.reset.layout.data
2265               0320                       ;------------------------------------------------------
2266               0321                       ; Exit
2267               0322                       ;------------------------------------------------------
2268               0323               sams.reset.layout.exit:
2269               0324 6604 C2F9  30         mov   *stack+,r11           ; Pop r11
2270               0325 6606 045B  20         b     *r11                  ; Return to caller
2271               0326               ***************************************************************
2272               0327               * SAMS standard page layout table (16 words)
2273               0328               *--------------------------------------------------------------
2274               0329               sams.reset.layout.data:
2275               0330 6608 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
2276                    660A 0002
2277               0331 660C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
2278                    660E 0003
2279               0332 6610 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
2280                    6612 000A
2281               0333 6614 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
2282                    6616 000B
2283               0334 6618 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
2284                    661A 000C
2285               0335 661C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
2286                    661E 000D
2287               0336 6620 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
2288                    6622 000E
2289               0337 6624 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
2290                    6626 000F
2291               0338
2292               0339
2293               0340
2294               0341               ***************************************************************
2295               0342               * sams.copy.layout
2296               0343               * Copy SAMS memory layout
2297               0344               ***************************************************************
2298               0345               * bl  @sams.copy.layout
2299               0346               *     data P0
2300               0347               *--------------------------------------------------------------
2301               0348               * P0 = Pointer to 8 words RAM buffer for results
2302               0349               *--------------------------------------------------------------
2303               0350               * OUTPUT
2304               0351               * RAM buffer will have the SAMS page number for each range
2305               0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
2306               0353               *--------------------------------------------------------------
2307               0354               * Register usage
2308               0355               * tmp0, tmp1, tmp2, tmp3
2309               0356               ***************************************************************
2310               0357               sams.copy.layout:
2311               0358 6628 C1FB  30         mov   *r11+,tmp3            ; Get P0
2312               0359
2313               0360 662A 0649  14         dect  stack
2314               0361 662C C64B  30         mov   r11,*stack            ; Push return address
2315               0362 662E 0649  14         dect  stack
2316               0363 6630 C644  30         mov   tmp0,*stack           ; Push tmp0
2317               0364 6632 0649  14         dect  stack
2318               0365 6634 C645  30         mov   tmp1,*stack           ; Push tmp1
2319               0366 6636 0649  14         dect  stack
2320               0367 6638 C646  30         mov   tmp2,*stack           ; Push tmp2
2321               0368 663A 0649  14         dect  stack
2322               0369 663C C647  30         mov   tmp3,*stack           ; Push tmp3
2323               0370                       ;------------------------------------------------------
2324               0371                       ; Copy SAMS layout
2325               0372                       ;------------------------------------------------------
2326               0373 663E 0205  20         li    tmp1,sams.copy.layout.data
2327                    6640 25FE
2328               0374 6642 0206  20         li    tmp2,8                ; Set loop counter
2329                    6644 0008
2330               0375                       ;------------------------------------------------------
2331               0376                       ; Set SAMS memory pages
2332               0377                       ;------------------------------------------------------
2333               0378               sams.copy.layout.loop:
2334               0379 6646 C135  30         mov   *tmp1+,tmp0           ; Get memory address
2335               0380 6648 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
2336                    664A 24C4
2337               0381                                                   ; | i  tmp0   = Memory address
2338               0382                                                   ; / o  @waux1 = SAMS page
2339               0383
2340               0384 664C CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
2341                    664E 833C
2342               0385
2343               0386 6650 0606  14         dec   tmp2                  ; Next iteration
2344               0387 6652 16F9  14         jne   sams.copy.layout.loop ; Loop until done
2345               0388                       ;------------------------------------------------------
2346               0389                       ; Exit
2347               0390                       ;------------------------------------------------------
2348               0391               sams.copy.layout.exit:
2349               0392 6654 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2350               0393 6656 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2351               0394 6658 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2352               0395 665A C139  30         mov   *stack+,tmp0          ; Pop tmp0
2353               0396 665C C2F9  30         mov   *stack+,r11           ; Pop r11
2354               0397 665E 045B  20         b     *r11                  ; Return to caller
2355               0398               ***************************************************************
2356               0399               * SAMS memory range table (8 words)
2357               0400               *--------------------------------------------------------------
2358               0401               sams.copy.layout.data:
2359               0402 6660 2000             data  >2000                 ; >2000-2fff
2360               0403 6662 3000             data  >3000                 ; >3000-3fff
2361               0404 6664 A000             data  >a000                 ; >a000-afff
2362               0405 6666 B000             data  >b000                 ; >b000-bfff
2363               0406 6668 C000             data  >c000                 ; >c000-cfff
2364               0407 666A D000             data  >d000                 ; >d000-dfff
2365               0408 666C E000             data  >e000                 ; >e000-efff
2366               0409 666E F000             data  >f000                 ; >f000-ffff
2367               0410
2368               **** **** ****     > runlib.asm
2369               0114
2370               0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
2371               **** **** ****     > vdp_intscr.asm
2372               0001               * FILE......: vdp_intscr.asm
2373               0002               * Purpose...: VDP interrupt & screen on/off
2374               0003
2375               0004               ***************************************************************
2376               0005               * SCROFF - Disable screen display
2377               0006               ***************************************************************
2378               0007               *  BL @SCROFF
2379               0008               ********|*****|*********************|**************************
2380               0009 6670 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
2381                    6672 FFBF
2382               0010 6674 0460  28         b     @putv01
2383                    6676 2326
2384               0011
2385               0012               ***************************************************************
2386               0013               * SCRON - Disable screen display
2387               0014               ***************************************************************
2388               0015               *  BL @SCRON
2389               0016               ********|*****|*********************|**************************
2390               0017 6678 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
2391                    667A 0040
2392               0018 667C 0460  28         b     @putv01
2393                    667E 2326
2394               0019
2395               0020               ***************************************************************
2396               0021               * INTOFF - Disable VDP interrupt
2397               0022               ***************************************************************
2398               0023               *  BL @INTOFF
2399               0024               ********|*****|*********************|**************************
2400               0025 6680 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
2401                    6682 FFDF
2402               0026 6684 0460  28         b     @putv01
2403                    6686 2326
2404               0027
2405               0028               ***************************************************************
2406               0029               * INTON - Enable VDP interrupt
2407               0030               ***************************************************************
2408               0031               *  BL @INTON
2409               0032               ********|*****|*********************|**************************
2410               0033 6688 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
2411                    668A 0020
2412               0034 668C 0460  28         b     @putv01
2413                    668E 2326
2414               **** **** ****     > runlib.asm
2415               0118
2416               0120                       copy  "vdp_sprites.asm"          ; VDP sprites
2417               **** **** ****     > vdp_sprites.asm
2418               0001               ***************************************************************
2419               0002               * FILE......: vdp_sprites.asm
2420               0003               * Purpose...: Sprites support
2421               0004
2422               0005               ***************************************************************
2423               0006               * SMAG1X - Set sprite magnification 1x
2424               0007               ***************************************************************
2425               0008               *  BL @SMAG1X
2426               0009               ********|*****|*********************|**************************
2427               0010 6690 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
2428                    6692 FFFE
2429               0011 6694 0460  28         b     @putv01
2430                    6696 2326
2431               0012
2432               0013               ***************************************************************
2433               0014               * SMAG2X - Set sprite magnification 2x
2434               0015               ***************************************************************
2435               0016               *  BL @SMAG2X
2436               0017               ********|*****|*********************|**************************
2437               0018 6698 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
2438                    669A 0001
2439               0019 669C 0460  28         b     @putv01
2440                    669E 2326
2441               0020
2442               0021               ***************************************************************
2443               0022               * S8X8 - Set sprite size 8x8 bits
2444               0023               ***************************************************************
2445               0024               *  BL @S8X8
2446               0025               ********|*****|*********************|**************************
2447               0026 66A0 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
2448                    66A2 FFFD
2449               0027 66A4 0460  28         b     @putv01
2450                    66A6 2326
2451               0028
2452               0029               ***************************************************************
2453               0030               * S16X16 - Set sprite size 16x16 bits
2454               0031               ***************************************************************
2455               0032               *  BL @S16X16
2456               0033               ********|*****|*********************|**************************
2457               0034 66A8 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
2458                    66AA 0002
2459               0035 66AC 0460  28         b     @putv01
2460                    66AE 2326
2461               **** **** ****     > runlib.asm
2462               0122
2463               0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
2464               **** **** ****     > vdp_cursor.asm
2465               0001               * FILE......: vdp_cursor.asm
2466               0002               * Purpose...: VDP cursor handling
2467               0003
2468               0004               *//////////////////////////////////////////////////////////////
2469               0005               *               VDP cursor movement functions
2470               0006               *//////////////////////////////////////////////////////////////
2471               0007
2472               0008
2473               0009               ***************************************************************
2474               0010               * AT - Set cursor YX position
2475               0011               ***************************************************************
2476               0012               *  bl   @yx
2477               0013               *  data p0
2478               0014               *--------------------------------------------------------------
2479               0015               *  INPUT
2480               0016               *  P0 = New Cursor YX position
2481               0017               ********|*****|*********************|**************************
2482               0018 66B0 C83B  50 at      mov   *r11+,@wyx
2483                    66B2 832A
2484               0019 66B4 045B  20         b     *r11
2485               0020
2486               0021
2487               0022               ***************************************************************
2488               0023               * down - Increase cursor Y position
2489               0024               ***************************************************************
2490               0025               *  bl   @down
2491               0026               ********|*****|*********************|**************************
2492               0027 66B6 B820  54 down    ab    @hb$01,@wyx
2493                    66B8 201C
2494                    66BA 832A
2495               0028 66BC 045B  20         b     *r11
2496               0029
2497               0030
2498               0031               ***************************************************************
2499               0032               * up - Decrease cursor Y position
2500               0033               ***************************************************************
2501               0034               *  bl   @up
2502               0035               ********|*****|*********************|**************************
2503               0036 66BE 7820  54 up      sb    @hb$01,@wyx
2504                    66C0 201C
2505                    66C2 832A
2506               0037 66C4 045B  20         b     *r11
2507               0038
2508               0039
2509               0040               ***************************************************************
2510               0041               * setx - Set cursor X position
2511               0042               ***************************************************************
2512               0043               *  bl   @setx
2513               0044               *  data p0
2514               0045               *--------------------------------------------------------------
2515               0046               *  Register usage
2516               0047               *  TMP0
2517               0048               ********|*****|*********************|**************************
2518               0049 66C6 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
2519               0050 66C8 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
2520                    66CA 832A
2521               0051 66CC C804  38         mov   tmp0,@wyx             ; Save as new YX position
2522                    66CE 832A
2523               0052 66D0 045B  20         b     *r11
2524               **** **** ****     > runlib.asm
2525               0126
2526               0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
2527               **** **** ****     > vdp_yx2px_calc.asm
2528               0001               * FILE......: vdp_yx2px_calc.asm
2529               0002               * Purpose...: Calculate pixel position for YX coordinate
2530               0003
2531               0004               ***************************************************************
2532               0005               * YX2PX - Get pixel position for cursor YX position
2533               0006               ***************************************************************
2534               0007               *  BL   @YX2PX
2535               0008               *
2536               0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
2537               0010               *--------------------------------------------------------------
2538               0011               *  INPUT
2539               0012               *  @WYX   = Cursor YX position
2540               0013               *--------------------------------------------------------------
2541               0014               *  OUTPUT
2542               0015               *  TMP0HB = Y pixel position
2543               0016               *  TMP0LB = X pixel position
2544               0017               *--------------------------------------------------------------
2545               0018               *  Remarks
2546               0019               *  This subroutine does not support multicolor mode
2547               0020               ********|*****|*********************|**************************
2548               0021 66D2 C120  34 yx2px   mov   @wyx,tmp0
2549                    66D4 832A
2550               0022 66D6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
2551               0023 66D8 06C4  14         swpb  tmp0                  ; Y<->X
2552               0024 66DA 04C5  14         clr   tmp1                  ; Clear before copy
2553               0025 66DC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2554               0026               *--------------------------------------------------------------
2555               0027               * X pixel - Special F18a 80 colums treatment
2556               0028               *--------------------------------------------------------------
2557               0029 66DE 20A0  38         coc   @wbit1,config         ; f18a present ?
2558                    66E0 2028
2559               0030 66E2 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2560               0031 66E4 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
2561                    66E6 833A
2562                    66E8 26B0
2563               0032 66EA 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2564               0033
2565               0034 66EC 0A15  56         sla   tmp1,1                ; X = X * 2
2566               0035 66EE B144  18         ab    tmp0,tmp1             ; X = X + (original X)
2567               0036 66F0 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
2568                    66F2 0500
2569               0037 66F4 1002  14         jmp   yx2pxx_y_calc
2570               0038               *--------------------------------------------------------------
2571               0039               * X pixel - Normal VDP treatment
2572               0040               *--------------------------------------------------------------
2573               0041               yx2pxx_normal:
2574               0042 66F6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2575               0043               *--------------------------------------------------------------
2576               0044 66F8 0A35  56         sla   tmp1,3                ; X=X*8
2577               0045               *--------------------------------------------------------------
2578               0046               * Calculate Y pixel position
2579               0047               *--------------------------------------------------------------
2580               0048               yx2pxx_y_calc:
2581               0049 66FA 0A34  56         sla   tmp0,3                ; Y=Y*8
2582               0050 66FC D105  18         movb  tmp1,tmp0
2583               0051 66FE 06C4  14         swpb  tmp0                  ; X<->Y
2584               0052 6700 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
2585                    6702 202A
2586               0053 6704 1305  14         jeq   yx2pi3                ; Yes, exit
2587               0054               *--------------------------------------------------------------
2588               0055               * Adjust for Y sprite location
2589               0056               * See VDP Programmers Guide, Section 9.2.1
2590               0057               *--------------------------------------------------------------
2591               0058 6706 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
2592                    6708 201C
2593               0059 670A 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
2594                    670C 202E
2595               0060 670E 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
2596               0061 6710 0456  20 yx2pi3  b     *tmp2                 ; Exit
2597               0062               *--------------------------------------------------------------
2598               0063               * Local constants
2599               0064               *--------------------------------------------------------------
2600               0065               yx2pxx_c80:
2601               0066 6712 0050            data   80
2602               0067
2603               0068
2604               **** **** ****     > runlib.asm
2605               0130
2606               0134
2607               0138
2608               0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
2609               **** **** ****     > vdp_f18a_support.asm
2610               0001               * FILE......: vdp_f18a_support.asm
2611               0002               * Purpose...: VDP F18A Support module
2612               0003
2613               0004               *//////////////////////////////////////////////////////////////
2614               0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
2615               0006               *//////////////////////////////////////////////////////////////
2616               0007
2617               0008               ***************************************************************
2618               0009               * f18unl - Unlock F18A VDP
2619               0010               ***************************************************************
2620               0011               *  bl   @f18unl
2621               0012               ********|*****|*********************|**************************
2622               0013 6714 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
2623               0014 6716 06A0  32         bl    @putvr                ; Write once
2624                    6718 2312
2625               0015 671A 391C             data  >391c                 ; VR1/57, value 00011100
2626               0016 671C 06A0  32         bl    @putvr                ; Write twice
2627                    671E 2312
2628               0017 6720 391C             data  >391c                 ; VR1/57, value 00011100
2629               0018 6722 0458  20         b     *tmp4                 ; Exit
2630               0019
2631               0020
2632               0021               ***************************************************************
2633               0022               * f18lck - Lock F18A VDP
2634               0023               ***************************************************************
2635               0024               *  bl   @f18lck
2636               0025               ********|*****|*********************|**************************
2637               0026 6724 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
2638               0027 6726 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2639                    6728 2312
2640               0028 672A 391C             data  >391c
2641               0029 672C 0458  20         b     *tmp4                 ; Exit
2642               0030
2643               0031
2644               0032               ***************************************************************
2645               0033               * f18chk - Check if F18A VDP present
2646               0034               ***************************************************************
2647               0035               *  bl   @f18chk
2648               0036               *--------------------------------------------------------------
2649               0037               *  REMARKS
2650               0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
2651               0039               ********|*****|*********************|**************************
2652               0040 672E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
2653               0041 6730 06A0  32         bl    @cpym2v
2654                    6732 2418
2655               0042 6734 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
2656                    6736 2710
2657                    6738 0006
2658               0043 673A 06A0  32         bl    @putvr
2659                    673C 2312
2660               0044 673E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
2661               0045 6740 06A0  32         bl    @putvr
2662                    6742 2312
2663               0046 6744 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
2664               0047                                                   ; GPU code should run now
2665               0048               ***************************************************************
2666               0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
2667               0050               ***************************************************************
2668               0051 6746 0204  20         li    tmp0,>3f00
2669                    6748 3F00
2670               0052 674A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
2671                    674C 229A
2672               0053 674E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
2673                    6750 8800
2674               0054 6752 0984  56         srl   tmp0,8
2675               0055 6754 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
2676                    6756 8800
2677               0056 6758 C104  18         mov   tmp0,tmp0             ; For comparing with 0
2678               0057 675A 1303  14         jeq   f18chk_yes
2679               0058               f18chk_no:
2680               0059 675C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
2681                    675E BFFF
2682               0060 6760 1002  14         jmp   f18chk_exit
2683               0061               f18chk_yes:
2684               0062 6762 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
2685                    6764 4000
2686               0063               f18chk_exit:
2687               0064 6766 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
2688                    6768 226E
2689               0065 676A 3F00             data  >3f00,>00,6
2690                    676C 0000
2691                    676E 0006
2692               0066 6770 0458  20         b     *tmp4                 ; Exit
2693               0067               ***************************************************************
2694               0068               * GPU code
2695               0069               ********|*****|*********************|**************************
2696               0070               f18chk_gpu
2697               0071 6772 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
2698               0072 6774 3F00             data  >3f00                 ; 3f02 / 3f00
2699               0073 6776 0340             data  >0340                 ; 3f04   0340  idle
2700               0074
2701               0075
2702               0076               ***************************************************************
2703               0077               * f18rst - Reset f18a into standard settings
2704               0078               ***************************************************************
2705               0079               *  bl   @f18rst
2706               0080               *--------------------------------------------------------------
2707               0081               *  REMARKS
2708               0082               *  This is used to leave the F18A mode and revert all settings
2709               0083               *  that could lead to corruption when doing BLWP @0
2710               0084               *
2711               0085               *  There are some F18a settings that stay on when doing blwp @0
2712               0086               *  and the TI title screen cannot recover from that.
2713               0087               *
2714               0088               *  It is your responsibility to set video mode tables should
2715               0089               *  you want to continue instead of doing blwp @0 after your
2716               0090               *  program cleanup
2717               0091               ********|*****|*********************|**************************
2718               0092 6778 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
2719               0093                       ;------------------------------------------------------
2720               0094                       ; Reset all F18a VDP registers to power-on defaults
2721               0095                       ;------------------------------------------------------
2722               0096 677A 06A0  32         bl    @putvr
2723                    677C 2312
2724               0097 677E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
2725               0098
2726               0099 6780 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2727                    6782 2312
2728               0100 6784 391C             data  >391c                 ; Lock the F18a
2729               0101 6786 0458  20         b     *tmp4                 ; Exit
2730               0102
2731               0103
2732               0104
2733               0105               ***************************************************************
2734               0106               * f18fwv - Get F18A Firmware Version
2735               0107               ***************************************************************
2736               0108               *  bl   @f18fwv
2737               0109               *--------------------------------------------------------------
2738               0110               *  REMARKS
2739               0111               *  Successfully tested with F18A v1.8, note that this does not
2740               0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
2741               0113               *  firmware to begin with.
2742               0114               *--------------------------------------------------------------
2743               0115               *  TMP0 High nibble = major version
2744               0116               *  TMP0 Low nibble  = minor version
2745               0117               *
2746               0118               *  Example: >0018     F18a Firmware v1.8
2747               0119               ********|*****|*********************|**************************
2748               0120 6788 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
2749               0121 678A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
2750                    678C 2028
2751               0122 678E 1609  14         jne   f18fw1
2752               0123               ***************************************************************
2753               0124               * Read F18A major/minor version
2754               0125               ***************************************************************
2755               0126 6790 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
2756                    6792 8802
2757               0127 6794 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
2758                    6796 2312
2759               0128 6798 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
2760               0129 679A 04C4  14         clr   tmp0
2761               0130 679C D120  34         movb  @vdps,tmp0
2762                    679E 8802
2763               0131 67A0 0984  56         srl   tmp0,8
2764               0132 67A2 0458  20 f18fw1  b     *tmp4                 ; Exit
2765               **** **** ****     > runlib.asm
2766               0142
2767               0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
2768               **** **** ****     > vdp_hchar.asm
2769               0001               * FILE......: vdp_hchar.a99
2770               0002               * Purpose...: VDP hchar module
2771               0003
2772               0004               ***************************************************************
2773               0005               * Repeat characters horizontally at YX
2774               0006               ***************************************************************
2775               0007               *  BL    @HCHAR
2776               0008               *  DATA  P0,P1
2777               0009               *  ...
2778               0010               *  DATA  EOL                        ; End-of-list
2779               0011               *--------------------------------------------------------------
2780               0012               *  P0HB = Y position
2781               0013               *  P0LB = X position
2782               0014               *  P1HB = Byte to write
2783               0015               *  P1LB = Number of times to repeat
2784               0016               ********|*****|*********************|**************************
2785               0017 67A4 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
2786                    67A6 832A
2787               0018 67A8 D17B  28         movb  *r11+,tmp1
2788               0019 67AA 0985  56 hcharx  srl   tmp1,8                ; Byte to write
2789               0020 67AC D1BB  28         movb  *r11+,tmp2
2790               0021 67AE 0986  56         srl   tmp2,8                ; Repeat count
2791               0022 67B0 C1CB  18         mov   r11,tmp3
2792               0023 67B2 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2793                    67B4 23DA
2794               0024               *--------------------------------------------------------------
2795               0025               *    Draw line
2796               0026               *--------------------------------------------------------------
2797               0027 67B6 020B  20         li    r11,hchar1
2798                    67B8 275C
2799               0028 67BA 0460  28         b     @xfilv                ; Draw
2800                    67BC 2274
2801               0029               *--------------------------------------------------------------
2802               0030               *    Do housekeeping
2803               0031               *--------------------------------------------------------------
2804               0032 67BE 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
2805                    67C0 202C
2806               0033 67C2 1302  14         jeq   hchar2                ; Yes, exit
2807               0034 67C4 C2C7  18         mov   tmp3,r11
2808               0035 67C6 10EE  14         jmp   hchar                 ; Next one
2809               0036 67C8 05C7  14 hchar2  inct  tmp3
2810               0037 67CA 0457  20         b     *tmp3                 ; Exit
2811               **** **** ****     > runlib.asm
2812               0146
2813               0150
2814               0154
2815               0158
2816               0162
2817               0166
2818               0170
2819               0174
2820               0176                       copy  "keyb_real.asm"            ; Real Keyboard support
2821               **** **** ****     > keyb_real.asm
2822               0001               * FILE......: keyb_real.asm
2823               0002               * Purpose...: Full (real) keyboard support module
2824               0003
2825               0004               *//////////////////////////////////////////////////////////////
2826               0005               *                     KEYBOARD FUNCTIONS
2827               0006               *//////////////////////////////////////////////////////////////
2828               0007
2829               0008               ***************************************************************
2830               0009               * REALKB - Scan keyboard in real mode
2831               0010               ***************************************************************
2832               0011               *  BL @REALKB
2833               0012               *--------------------------------------------------------------
2834               0013               *  Based on work done by Simon Koppelmann
2835               0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
2836               0015               ********|*****|*********************|**************************
2837               0016 67CC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
2838                    67CE 202A
2839               0017 67D0 020C  20         li    r12,>0024
2840                    67D2 0024
2841               0018 67D4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
2842                    67D6 2802
2843               0019 67D8 04C6  14         clr   tmp2
2844               0020 67DA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
2845               0021               *--------------------------------------------------------------
2846               0022               * SHIFT key pressed ?
2847               0023               *--------------------------------------------------------------
2848               0024 67DC 04CC  14         clr   r12
2849               0025 67DE 1F08  20         tb    >0008                 ; Shift-key ?
2850               0026 67E0 1302  14         jeq   realk1                ; No
2851               0027 67E2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
2852                    67E4 2832
2853               0028               *--------------------------------------------------------------
2854               0029               * FCTN key pressed ?
2855               0030               *--------------------------------------------------------------
2856               0031 67E6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
2857               0032 67E8 1302  14         jeq   realk2                ; No
2858               0033 67EA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
2859                    67EC 2862
2860               0034               *--------------------------------------------------------------
2861               0035               * CTRL key pressed ?
2862               0036               *--------------------------------------------------------------
2863               0037 67EE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
2864               0038 67F0 1302  14         jeq   realk3                ; No
2865               0039 67F2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
2866                    67F4 2892
2867               0040               *--------------------------------------------------------------
2868               0041               * ALPHA LOCK key down ?
2869               0042               *--------------------------------------------------------------
2870               0043 67F6 1E15  20 realk3  sbz   >0015                 ; Set P5
2871               0044 67F8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
2872               0045 67FA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
2873               0046 67FC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
2874                    67FE 202A
2875               0047               *--------------------------------------------------------------
2876               0048               * Scan keyboard column
2877               0049               *--------------------------------------------------------------
2878               0050 6800 1D15  20 realk4  sbo   >0015                 ; Reset P5
2879               0051 6802 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
2880                    6804 0006
2881               0052 6806 0606  14 realk5  dec   tmp2
2882               0053 6808 020C  20         li    r12,>24               ; CRU address for P2-P4
2883                    680A 0024
2884               0054 680C 06C6  14         swpb  tmp2
2885               0055 680E 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
2886               0056 6810 06C6  14         swpb  tmp2
2887               0057 6812 020C  20         li    r12,6                 ; CRU read address
2888                    6814 0006
2889               0058 6816 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
2890               0059 6818 0547  14         inv   tmp3                  ;
2891               0060 681A 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
2892                    681C FF00
2893               0061               *--------------------------------------------------------------
2894               0062               * Scan keyboard row
2895               0063               *--------------------------------------------------------------
2896               0064 681E 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
2897               0065 6820 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
2898               0066 6822 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
2899               0067 6824 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
2900               0068 6826 0285  22         ci    tmp1,8
2901                    6828 0008
2902               0069 682A 1AFA  14         jl    realk6
2903               0070 682C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
2904               0071 682E 1BEB  14         jh    realk5                ; No, next column
2905               0072 6830 1016  14         jmp   realkz                ; Yes, exit
2906               0073               *--------------------------------------------------------------
2907               0074               * Check for match in data table
2908               0075               *--------------------------------------------------------------
2909               0076 6832 C206  18 realk8  mov   tmp2,tmp4
2910               0077 6834 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
2911               0078 6836 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
2912               0079 6838 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
2913               0080 683A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
2914               0081 683C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
2915               0082               *--------------------------------------------------------------
2916               0083               * Determine ASCII value of key
2917               0084               *--------------------------------------------------------------
2918               0085 683E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
2919               0086 6840 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
2920                    6842 202A
2921               0087 6844 1608  14         jne   realka                ; No, continue saving key
2922               0088 6846 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
2923                    6848 282C
2924               0089 684A 1A05  14         jl    realka
2925               0090 684C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
2926                    684E 282A
2927               0091 6850 1B02  14         jh    realka                ; No, continue
2928               0092 6852 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
2929                    6854 E000
2930               0093 6856 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
2931                    6858 833C
2932               0094 685A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
2933                    685C 2014
2934               0095 685E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
2935                    6860 8C00
2936               0096 6862 045B  20         b     *r11                  ; Exit
2937               0097               ********|*****|*********************|**************************
2938               0098 6864 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
2939                    6866 0000
2940                    6868 FF0D
2941                    686A 203D
2942               0099 686C ....             text  'xws29ol.'
2943               0100 6874 ....             text  'ced38ik,'
2944               0101 687C ....             text  'vrf47ujm'
2945               0102 6884 ....             text  'btg56yhn'
2946               0103 688C ....             text  'zqa10p;/'
2947               0104 6894 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
2948                    6896 0000
2949                    6898 FF0D
2950                    689A 202B
2951               0105 689C ....             text  'XWS@(OL>'
2952               0106 68A4 ....             text  'CED#*IK<'
2953               0107 68AC ....             text  'VRF$&UJM'
2954               0108 68B4 ....             text  'BTG%^YHN'
2955               0109 68BC ....             text  'ZQA!)P:-'
2956               0110 68C4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
2957                    68C6 0000
2958                    68C8 FF0D
2959                    68CA 2005
2960               0111 68CC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
2961                    68CE 0804
2962                    68D0 0F27
2963                    68D2 C2B9
2964               0112 68D4 600B             data  >600b,>0907,>063f,>c1B8
2965                    68D6 0907
2966                    68D8 063F
2967                    68DA C1B8
2968               0113 68DC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
2969                    68DE 7B02
2970                    68E0 015F
2971                    68E2 C0C3
2972               0114 68E4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
2973                    68E6 7D0E
2974                    68E8 0CC6
2975                    68EA BFC4
2976               0115 68EC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
2977                    68EE 7C03
2978                    68F0 BC22
2979                    68F2 BDBA
2980               0116 68F4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
2981                    68F6 0000
2982                    68F8 FF0D
2983                    68FA 209D
2984               0117 68FC 9897             data  >9897,>93b2,>9f8f,>8c9B
2985                    68FE 93B2
2986                    6900 9F8F
2987                    6902 8C9B
2988               0118 6904 8385             data  >8385,>84b3,>9e89,>8b80
2989                    6906 84B3
2990                    6908 9E89
2991                    690A 8B80
2992               0119 690C 9692             data  >9692,>86b4,>b795,>8a8D
2993                    690E 86B4
2994                    6910 B795
2995                    6912 8A8D
2996               0120 6914 8294             data  >8294,>87b5,>b698,>888E
2997                    6916 87B5
2998                    6918 B698
2999                    691A 888E
3000               0121 691C 9A91             data  >9a91,>81b1,>b090,>9cBB
3001                    691E 81B1
3002                    6920 B090
3003                    6922 9CBB
3004               **** **** ****     > runlib.asm
3005               0178
3006               0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
3007               **** **** ****     > cpu_hexsupport.asm
3008               0001               * FILE......: cpu_hexsupport.asm
3009               0002               * Purpose...: CPU create, display hex numbers module
3010               0003
3011               0004               ***************************************************************
3012               0005               * mkhex - Convert hex word to string
3013               0006               ***************************************************************
3014               0007               *  bl   @mkhex
3015               0008               *       data P0,P1,P2
3016               0009               *--------------------------------------------------------------
3017               0010               *  P0 = Pointer to 16 bit word
3018               0011               *  P1 = Pointer to string buffer
3019               0012               *  P2 = Offset for ASCII digit
3020               0013               *       MSB determines offset for chars A-F
3021               0014               *       LSB determines offset for chars 0-9
3022               0015               *  (CONFIG#0 = 1) = Display number at cursor YX
3023               0016               *--------------------------------------------------------------
3024               0017               *  Memory usage:
3025               0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
3026               0019               *  waux1, waux2, waux3
3027               0020               *--------------------------------------------------------------
3028               0021               *  Memory variables waux1-waux3 are used as temporary variables
3029               0022               ********|*****|*********************|**************************
3030               0023 6924 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
3031               0024 6926 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
3032                    6928 8340
3033               0025 692A 04E0  34         clr   @waux1
3034                    692C 833C
3035               0026 692E 04E0  34         clr   @waux2
3036                    6930 833E
3037               0027 6932 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
3038                    6934 833C
3039               0028 6936 C114  26         mov   *tmp0,tmp0            ; Get word
3040               0029               *--------------------------------------------------------------
3041               0030               *    Convert nibbles to bytes (is in wrong order)
3042               0031               *--------------------------------------------------------------
3043               0032 6938 0205  20         li    tmp1,4                ; 4 nibbles
3044                    693A 0004
3045               0033 693C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
3046               0034 693E 0246  22         andi  tmp2,>000f            ; Only keep LSN
3047                    6940 000F
3048               0035                       ;------------------------------------------------------
3049               0036                       ; Determine offset for ASCII char
3050               0037                       ;------------------------------------------------------
3051               0038 6942 0286  22         ci    tmp2,>000a
3052                    6944 000A
3053               0039 6946 1105  14         jlt   mkhex1.digit09
3054               0040                       ;------------------------------------------------------
3055               0041                       ; Add ASCII offset for digits A-F
3056               0042                       ;------------------------------------------------------
3057               0043               mkhex1.digitaf:
3058               0044 6948 C21B  26         mov   *r11,tmp4
3059               0045 694A 0988  56         srl   tmp4,8                ; Right justify
3060               0046 694C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
3061                    694E FFF6
3062               0047 6950 1003  14         jmp   mkhex2
3063               0048
3064               0049               mkhex1.digit09:
3065               0050                       ;------------------------------------------------------
3066               0051                       ; Add ASCII offset for digits 0-9
3067               0052                       ;------------------------------------------------------
3068               0053 6952 C21B  26         mov   *r11,tmp4
3069               0054 6954 0248  22         andi  tmp4,>00ff            ; Only keep LSB
3070                    6956 00FF
3071               0055
3072               0056 6958 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
3073               0057 695A 06C6  14         swpb  tmp2
3074               0058 695C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
3075               0059 695E 0944  56         srl   tmp0,4                ; Next nibble
3076               0060 6960 0605  14         dec   tmp1
3077               0061 6962 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
3078               0062 6964 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
3079                    6966 BFFF
3080               0063               *--------------------------------------------------------------
3081               0064               *    Build first 2 bytes in correct order
3082               0065               *--------------------------------------------------------------
3083               0066 6968 C160  34         mov   @waux3,tmp1           ; Get pointer
3084                    696A 8340
3085               0067 696C 04D5  26         clr   *tmp1                 ; Set length byte to 0
3086               0068 696E 0585  14         inc   tmp1                  ; Next byte, not word!
3087               0069 6970 C120  34         mov   @waux2,tmp0
3088                    6972 833E
3089               0070 6974 06C4  14         swpb  tmp0
3090               0071 6976 DD44  32         movb  tmp0,*tmp1+
3091               0072 6978 06C4  14         swpb  tmp0
3092               0073 697A DD44  32         movb  tmp0,*tmp1+
3093               0074               *--------------------------------------------------------------
3094               0075               *    Set length byte
3095               0076               *--------------------------------------------------------------
3096               0077 697C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
3097                    697E 8340
3098               0078 6980 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
3099                    6982 2020
3100               0079 6984 05CB  14         inct  r11                   ; Skip Parameter P2
3101               0080               *--------------------------------------------------------------
3102               0081               *    Build last 2 bytes in correct order
3103               0082               *--------------------------------------------------------------
3104               0083 6986 C120  34         mov   @waux1,tmp0
3105                    6988 833C
3106               0084 698A 06C4  14         swpb  tmp0
3107               0085 698C DD44  32         movb  tmp0,*tmp1+
3108               0086 698E 06C4  14         swpb  tmp0
3109               0087 6990 DD44  32         movb  tmp0,*tmp1+
3110               0088               *--------------------------------------------------------------
3111               0089               *    Display hex number ?
3112               0090               *--------------------------------------------------------------
3113               0091 6992 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3114                    6994 202A
3115               0092 6996 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
3116               0093 6998 045B  20         b     *r11                  ; Exit
3117               0094               *--------------------------------------------------------------
3118               0095               *  Display hex number on screen at current YX position
3119               0096               *--------------------------------------------------------------
3120               0097 699A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
3121                    699C 7FFF
3122               0098 699E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
3123                    69A0 8340
3124               0099 69A2 0460  28         b     @xutst0               ; Display string
3125                    69A4 2400
3126               0100 69A6 0610     prefix  data  >0610                 ; Length byte + blank
3127               0101
3128               0102
3129               0103
3130               0104               ***************************************************************
3131               0105               * puthex - Put 16 bit word on screen
3132               0106               ***************************************************************
3133               0107               *  bl   @mkhex
3134               0108               *       data P0,P1,P2,P3
3135               0109               *--------------------------------------------------------------
3136               0110               *  P0 = YX position
3137               0111               *  P1 = Pointer to 16 bit word
3138               0112               *  P2 = Pointer to string buffer
3139               0113               *  P3 = Offset for ASCII digit
3140               0114               *       MSB determines offset for chars A-F
3141               0115               *       LSB determines offset for chars 0-9
3142               0116               *--------------------------------------------------------------
3143               0117               *  Memory usage:
3144               0118               *  tmp0, tmp1, tmp2, tmp3
3145               0119               *  waux1, waux2, waux3
3146               0120               ********|*****|*********************|**************************
3147               0121 69A8 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
3148                    69AA 832A
3149               0122 69AC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3150                    69AE 8000
3151               0123 69B0 10B9  14         jmp   mkhex                 ; Convert number and display
3152               0124
3153               **** **** ****     > runlib.asm
3154               0182
3155               0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
3156               **** **** ****     > cpu_numsupport.asm
3157               0001               * FILE......: cpu_numsupport.asm
3158               0002               * Purpose...: CPU create, display numbers module
3159               0003
3160               0004               ***************************************************************
3161               0005               * MKNUM - Convert unsigned number to string
3162               0006               ***************************************************************
3163               0007               *  BL   @MKNUM
3164               0008               *  DATA P0,P1,P2
3165               0009               *
3166               0010               *  P0   = Pointer to 16 bit unsigned number
3167               0011               *  P1   = Pointer to 5 byte string buffer
3168               0012               *  P2HB = Offset for ASCII digit
3169               0013               *  P2LB = Character for replacing leading 0's
3170               0014               *
3171               0015               *  (CONFIG:0 = 1) = Display number at cursor YX
3172               0016               *-------------------------------------------------------------
3173               0017               *  Destroys registers tmp0-tmp4
3174               0018               ********|*****|*********************|**************************
3175               0019 69B2 0207  20 mknum   li    tmp3,5                ; Digit counter
3176                    69B4 0005
3177               0020 69B6 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
3178               0021 69B8 C155  26         mov   *tmp1,tmp1            ; /
3179               0022 69BA C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
3180               0023 69BC 0228  22         ai    tmp4,4                ; Get end of buffer
3181                    69BE 0004
3182               0024 69C0 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
3183                    69C2 000A
3184               0025               *--------------------------------------------------------------
3185               0026               *  Do string conversion
3186               0027               *--------------------------------------------------------------
3187               0028 69C4 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
3188               0029 69C6 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
3189               0030 69C8 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
3190               0031 69CA B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
3191               0032 69CC D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
3192               0033 69CE C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
3193               0034 69D0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
3194               0035 69D2 0607  14         dec   tmp3                  ; Decrease counter
3195               0036 69D4 16F7  14         jne   mknum1                ; Do next digit
3196               0037               *--------------------------------------------------------------
3197               0038               *  Replace leading 0's with fill character
3198               0039               *--------------------------------------------------------------
3199               0040 69D6 0207  20         li    tmp3,4                ; Check first 4 digits
3200                    69D8 0004
3201               0041 69DA 0588  14         inc   tmp4                  ; Too far, back to buffer start
3202               0042 69DC C11B  26         mov   *r11,tmp0
3203               0043 69DE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
3204               0044 69E0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
3205               0045 69E2 1305  14         jeq   mknum4                ; Yes, replace with fill character
3206               0046 69E4 05CB  14 mknum3  inct  r11
3207               0047 69E6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3208                    69E8 202A
3209               0048 69EA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
3210               0049 69EC 045B  20         b     *r11                  ; Exit
3211               0050 69EE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
3212               0051 69F0 0607  14         dec   tmp3                  ; 4th digit processed ?
3213               0052 69F2 13F8  14         jeq   mknum3                ; Yes, exit
3214               0053 69F4 10F5  14         jmp   mknum2                ; No, next one
3215               0054               *--------------------------------------------------------------
3216               0055               *  Display integer on screen at current YX position
3217               0056               *--------------------------------------------------------------
3218               0057 69F6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
3219                    69F8 7FFF
3220               0058 69FA C10B  18         mov   r11,tmp0
3221               0059 69FC 0224  22         ai    tmp0,-4
3222                    69FE FFFC
3223               0060 6A00 C154  26         mov   *tmp0,tmp1            ; Get buffer address
3224               0061 6A02 0206  20         li    tmp2,>0500            ; String length = 5
3225                    6A04 0500
3226               0062 6A06 0460  28         b     @xutstr               ; Display string
3227                    6A08 2402
3228               0063
3229               0064
3230               0065
3231               0066
3232               0067               ***************************************************************
3233               0068               * trimnum - Trim unsigned number string
3234               0069               ***************************************************************
3235               0070               *  bl   @trimnum
3236               0071               *  data p0,p1
3237               0072               *--------------------------------------------------------------
3238               0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
3239               0074               *  p1   = Pointer to output variable
3240               0075               *  p2   = Padding character to match against
3241               0076               *--------------------------------------------------------------
3242               0077               *  Copy unsigned number string into a length-padded, left
3243               0078               *  justified string for display with putstr, putat, ...
3244               0079               *
3245               0080               *  The new string starts at index 5 in buffer, overwriting
3246               0081               *  anything that is located there !
3247               0082               *
3248               0083               *  Before...:   XXXXX
3249               0084               *  After....:   XXXXX|zY       where length byte z=1
3250               0085               *               XXXXX|zYY      where length byte z=2
3251               0086               *                 ..
3252               0087               *               XXXXX|zYYYYY   where length byte z=5
3253               0088               *--------------------------------------------------------------
3254               0089               *  Destroys registers tmp0-tmp3
3255               0090               ********|*****|*********************|**************************
3256               0091               trimnum:
3257               0092 6A0A C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
3258               0093 6A0C C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
3259               0094 6A0E C1BB  30         mov   *r11+,tmp2            ; Get padding character
3260               0095 6A10 06C6  14         swpb  tmp2                  ; LO <-> HI
3261               0096 6A12 0207  20         li    tmp3,5                ; Set counter
3262                    6A14 0005
3263               0097                       ;------------------------------------------------------
3264               0098                       ; Scan for padding character from left to right
3265               0099                       ;------------------------------------------------------:
3266               0100               trimnum_scan:
3267               0101 6A16 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
3268               0102 6A18 1604  14         jne   trimnum_setlen        ; No, exit loop
3269               0103 6A1A 0584  14         inc   tmp0                  ; Next character
3270               0104 6A1C 0607  14         dec   tmp3                  ; Last digit reached ?
3271               0105 6A1E 1301  14         jeq   trimnum_setlen        ; yes, exit loop
3272               0106 6A20 10FA  14         jmp   trimnum_scan
3273               0107                       ;------------------------------------------------------
3274               0108                       ; Scan completed, set length byte new string
3275               0109                       ;------------------------------------------------------
3276               0110               trimnum_setlen:
3277               0111 6A22 06C7  14         swpb  tmp3                  ; LO <-> HI
3278               0112 6A24 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
3279               0113 6A26 06C7  14         swpb  tmp3                  ; LO <-> HI
3280               0114                       ;------------------------------------------------------
3281               0115                       ; Start filling new string
3282               0116                       ;------------------------------------------------------
3283               0117               trimnum_fill
3284               0118 6A28 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
3285               0119 6A2A 0607  14         dec   tmp3                  ; Last character ?
3286               0120 6A2C 16FD  14         jne   trimnum_fill          ; Not yet, repeat
3287               0121 6A2E 045B  20         b     *r11                  ; Return
3288               0122
3289               0123
3290               0124
3291               0125
3292               0126               ***************************************************************
3293               0127               * PUTNUM - Put unsigned number on screen
3294               0128               ***************************************************************
3295               0129               *  BL   @PUTNUM
3296               0130               *  DATA P0,P1,P2,P3
3297               0131               *--------------------------------------------------------------
3298               0132               *  P0   = YX position
3299               0133               *  P1   = Pointer to 16 bit unsigned number
3300               0134               *  P2   = Pointer to 5 byte string buffer
3301               0135               *  P3HB = Offset for ASCII digit
3302               0136               *  P3LB = Character for replacing leading 0's
3303               0137               ********|*****|*********************|**************************
3304               0138 6A30 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
3305                    6A32 832A
3306               0139 6A34 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3307                    6A36 8000
3308               0140 6A38 10BC  14         jmp   mknum                 ; Convert number and display
3309               **** **** ****     > runlib.asm
3310               0186
3311               0190
3312               0194
3313               0198
3314               0202
3315               0206
3316               0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
3317               **** **** ****     > cpu_scrpad_backrest.asm
3318               0001               * FILE......: cpu_scrpad_backrest.asm
3319               0002               * Purpose...: Scratchpad memory backup/restore functions
3320               0003
3321               0004               *//////////////////////////////////////////////////////////////
3322               0005               *                Scratchpad memory backup/restore
3323               0006               *//////////////////////////////////////////////////////////////
3324               0007
3325               0008               ***************************************************************
3326               0009               * cpu.scrpad.backup - Backup scratchpad memory to >2000
3327               0010               ***************************************************************
3328               0011               *  bl   @cpu.scrpad.backup
3329               0012               *--------------------------------------------------------------
3330               0013               *  Register usage
3331               0014               *  r0-r2, but values restored before exit
3332               0015               *--------------------------------------------------------------
3333               0016               *  Backup scratchpad memory to destination range
3334               0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3335               0018               *
3336               0019               *  Expects current workspace to be in scratchpad memory.
3337               0020               ********|*****|*********************|**************************
3338               0021               cpu.scrpad.backup:
3339               0022 6A3A C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
3340                    6A3C A000
3341               0023 6A3E C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
3342                    6A40 A002
3343               0024 6A42 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
3344                    6A44 A004
3345               0025                       ;------------------------------------------------------
3346               0026                       ; Prepare for copy loop
3347               0027                       ;------------------------------------------------------
3348               0028 6A46 0200  20         li    r0,>8306              ; Scratpad source address
3349                    6A48 8306
3350               0029 6A4A 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
3351                    6A4C A006
3352               0030 6A4E 0202  20         li    r2,62                 ; Loop counter
3353                    6A50 003E
3354               0031                       ;------------------------------------------------------
3355               0032                       ; Copy memory range >8306 - >83ff
3356               0033                       ;------------------------------------------------------
3357               0034               cpu.scrpad.backup.copy:
3358               0035 6A52 CC70  46         mov   *r0+,*r1+
3359               0036 6A54 CC70  46         mov   *r0+,*r1+
3360               0037 6A56 0642  14         dect  r2
3361               0038 6A58 16FC  14         jne   cpu.scrpad.backup.copy
3362               0039 6A5A C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
3363                    6A5C 83FE
3364                    6A5E A0FE
3365               0040                                                   ; Copy last word
3366               0041                       ;------------------------------------------------------
3367               0042                       ; Restore register r0 - r2
3368               0043                       ;------------------------------------------------------
3369               0044 6A60 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
3370                    6A62 A000
3371               0045 6A64 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
3372                    6A66 A002
3373               0046 6A68 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
3374                    6A6A A004
3375               0047                       ;------------------------------------------------------
3376               0048                       ; Exit
3377               0049                       ;------------------------------------------------------
3378               0050               cpu.scrpad.backup.exit:
3379               0051 6A6C 045B  20         b     *r11                  ; Return to caller
3380               0052
3381               0053
3382               0054               ***************************************************************
3383               0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
3384               0056               ***************************************************************
3385               0057               *  bl   @cpu.scrpad.restore
3386               0058               *--------------------------------------------------------------
3387               0059               *  Register usage
3388               0060               *  r0-r2, but values restored before exit
3389               0061               *--------------------------------------------------------------
3390               0062               *  Restore scratchpad from memory area
3391               0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3392               0064               *  Current workspace can be outside scratchpad when called.
3393               0065               ********|*****|*********************|**************************
3394               0066               cpu.scrpad.restore:
3395               0067                       ;------------------------------------------------------
3396               0068                       ; Restore scratchpad >8300 - >8304
3397               0069                       ;------------------------------------------------------
3398               0070 6A6E C820  54         mov   @cpu.scrpad.tgt,@>8300
3399                    6A70 A000
3400                    6A72 8300
3401               0071 6A74 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
3402                    6A76 A002
3403                    6A78 8302
3404               0072 6A7A C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
3405                    6A7C A004
3406                    6A7E 8304
3407               0073                       ;------------------------------------------------------
3408               0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
3409               0075                       ;------------------------------------------------------
3410               0076 6A80 C800  38         mov   r0,@cpu.scrpad.tgt
3411                    6A82 A000
3412               0077 6A84 C801  38         mov   r1,@cpu.scrpad.tgt + 2
3413                    6A86 A002
3414               0078 6A88 C802  38         mov   r2,@cpu.scrpad.tgt + 4
3415                    6A8A A004
3416               0079                       ;------------------------------------------------------
3417               0080                       ; Prepare for copy loop, WS
3418               0081                       ;------------------------------------------------------
3419               0082 6A8C 0200  20         li    r0,cpu.scrpad.tgt + 6
3420                    6A8E A006
3421               0083 6A90 0201  20         li    r1,>8306
3422                    6A92 8306
3423               0084 6A94 0202  20         li    r2,62
3424                    6A96 003E
3425               0085                       ;------------------------------------------------------
3426               0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
3427               0087                       ;------------------------------------------------------
3428               0088               cpu.scrpad.restore.copy:
3429               0089 6A98 CC70  46         mov   *r0+,*r1+
3430               0090 6A9A CC70  46         mov   *r0+,*r1+
3431               0091 6A9C 0642  14         dect  r2
3432               0092 6A9E 16FC  14         jne   cpu.scrpad.restore.copy
3433               0093 6AA0 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
3434                    6AA2 A0FE
3435                    6AA4 83FE
3436               0094                                                   ; Copy last word
3437               0095                       ;------------------------------------------------------
3438               0096                       ; Restore register r0 - r2
3439               0097                       ;------------------------------------------------------
3440               0098 6AA6 C020  34         mov   @cpu.scrpad.tgt,r0
3441                    6AA8 A000
3442               0099 6AAA C060  34         mov   @cpu.scrpad.tgt + 2,r1
3443                    6AAC A002
3444               0100 6AAE C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
3445                    6AB0 A004
3446               0101                       ;------------------------------------------------------
3447               0102                       ; Exit
3448               0103                       ;------------------------------------------------------
3449               0104               cpu.scrpad.restore.exit:
3450               0105 6AB2 045B  20         b     *r11                  ; Return to caller
3451               **** **** ****     > runlib.asm
3452               0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
3453               **** **** ****     > cpu_scrpad_paging.asm
3454               0001               * FILE......: cpu_scrpad_paging.asm
3455               0002               * Purpose...: CPU memory paging functions
3456               0003
3457               0004               *//////////////////////////////////////////////////////////////
3458               0005               *                     CPU memory paging
3459               0006               *//////////////////////////////////////////////////////////////
3460               0007
3461               0008
3462               0009               ***************************************************************
3463               0010               * cpu.scrpad.pgout - Page out scratchpad memory
3464               0011               ***************************************************************
3465               0012               *  bl   @cpu.scrpad.pgout
3466               0013               *       DATA p0
3467               0014               *
3468               0015               *  P0 = CPU memory destination
3469               0016               *--------------------------------------------------------------
3470               0017               *  bl   @xcpu.scrpad.pgout
3471               0018               *  TMP1 = CPU memory destination
3472               0019               *--------------------------------------------------------------
3473               0020               *  Register usage
3474               0021               *  tmp0-tmp2 = Used as temporary registers
3475               0022               *  tmp3      = Copy of CPU memory destination
3476               0023               ********|*****|*********************|**************************
3477               0024               cpu.scrpad.pgout:
3478               0025 6AB4 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
3479               0026                       ;------------------------------------------------------
3480               0027                       ; Copy scratchpad memory to destination
3481               0028                       ;------------------------------------------------------
3482               0029               xcpu.scrpad.pgout:
3483               0030 6AB6 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
3484                    6AB8 8300
3485               0031 6ABA C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
3486               0032 6ABC 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3487                    6ABE 0080
3488               0033                       ;------------------------------------------------------
3489               0034                       ; Copy memory
3490               0035                       ;------------------------------------------------------
3491               0036 6AC0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3492               0037 6AC2 0606  14         dec   tmp2
3493               0038 6AC4 16FD  14         jne   -!                    ; Loop until done
3494               0039                       ;------------------------------------------------------
3495               0040                       ; Switch to new workspace
3496               0041                       ;------------------------------------------------------
3497               0042 6AC6 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
3498               0043 6AC8 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
3499                    6ACA 2A6E
3500               0044                                                   ; R14=PC
3501               0045 6ACC 04CF  14         clr   r15                   ; R15=STATUS
3502               0046                       ;------------------------------------------------------
3503               0047                       ; If we get here, WS was copied to specified
3504               0048                       ; destination.  Also contents of r13,r14,r15
3505               0049                       ; are about to be overwritten by rtwp instruction.
3506               0050                       ;------------------------------------------------------
3507               0051 6ACE 0380  18         rtwp                        ; Activate copied workspace
3508               0052                                                   ; in non-scratchpad memory!
3509               0053
3510               0054               cpu.scrpad.pgout.after.rtwp:
3511               0055 6AD0 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
3512                    6AD2 2A0C
3513               0056
3514               0057                       ;------------------------------------------------------
3515               0058                       ; Exit
3516               0059                       ;------------------------------------------------------
3517               0060               cpu.scrpad.pgout.$$:
3518               0061 6AD4 045B  20         b     *r11                  ; Return to caller
3519               0062
3520               0063
3521               0064               ***************************************************************
3522               0065               * cpu.scrpad.pgin - Page in scratchpad memory
3523               0066               ***************************************************************
3524               0067               *  bl   @cpu.scrpad.pgin
3525               0068               *  DATA p0
3526               0069               *  P0 = CPU memory source
3527               0070               *--------------------------------------------------------------
3528               0071               *  bl   @memx.scrpad.pgin
3529               0072               *  TMP1 = CPU memory source
3530               0073               *--------------------------------------------------------------
3531               0074               *  Register usage
3532               0075               *  tmp0-tmp2 = Used as temporary registers
3533               0076               ********|*****|*********************|**************************
3534               0077               cpu.scrpad.pgin:
3535               0078 6AD6 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
3536               0079                       ;------------------------------------------------------
3537               0080                       ; Copy scratchpad memory to destination
3538               0081                       ;------------------------------------------------------
3539               0082               xcpu.scrpad.pgin:
3540               0083 6AD8 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
3541                    6ADA 8300
3542               0084 6ADC 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3543                    6ADE 0080
3544               0085                       ;------------------------------------------------------
3545               0086                       ; Copy memory
3546               0087                       ;------------------------------------------------------
3547               0088 6AE0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3548               0089 6AE2 0606  14         dec   tmp2
3549               0090 6AE4 16FD  14         jne   -!                    ; Loop until done
3550               0091                       ;------------------------------------------------------
3551               0092                       ; Switch workspace to scratchpad memory
3552               0093                       ;------------------------------------------------------
3553               0094 6AE6 02E0  18         lwpi  >8300                 ; Activate copied workspace
3554                    6AE8 8300
3555               0095                       ;------------------------------------------------------
3556               0096                       ; Exit
3557               0097                       ;------------------------------------------------------
3558               0098               cpu.scrpad.pgin.$$:
3559               0099 6AEA 045B  20         b     *r11                  ; Return to caller
3560               **** **** ****     > runlib.asm
3561               0211
3562               0213                       copy  "equ_fio.asm"              ; File I/O equates
3563               **** **** ****     > equ_fio.asm
3564               0001               * FILE......: equ_fio.asm
3565               0002               * Purpose...: Equates for file I/O operations
3566               0003
3567               0004               ***************************************************************
3568               0005               * File IO operations
3569               0006               ************************************@**************************
3570               0007      0000     io.op.open       equ >00            ; OPEN
3571               0008      0001     io.op.close      equ >01            ; CLOSE
3572               0009      0002     io.op.read       equ >02            ; READ
3573               0010      0003     io.op.write      equ >03            ; WRITE
3574               0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
3575               0012      0005     io.op.load       equ >05            ; LOAD
3576               0013      0006     io.op.save       equ >06            ; SAVE
3577               0014      0007     io.op.delfile    equ >07            ; DELETE FILE
3578               0015      0008     io.op.scratch    equ >08            ; SCRATCH
3579               0016      0009     io.op.status     equ >09            ; STATUS
3580               0017               ***************************************************************
3581               0018               * File types - All relative files are fixed length
3582               0019               ************************************@**************************
3583               0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
3584               0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
3585               0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
3586               0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
3587               0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
3588               0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
3589               0026               ***************************************************************
3590               0027               * File types - Sequential files
3591               0028               ************************************@**************************
3592               0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
3593               0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
3594               0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
3595               0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
3596               0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
3597               0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
3598               0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
3599               0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
3600               0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
3601               0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
3602               0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
3603               0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
3604               0041
3605               0042               ***************************************************************
3606               0043               * File error codes - Bits 13-15 in PAB byte 1
3607               0044               ************************************@**************************
3608               0045      0000     io.err.no_error_occured             equ 0
3609               0046                       ; Error code 0 with condition bit reset, indicates that
3610               0047                       ; no error has occured
3611               0048
3612               0049      0000     io.err.bad_device_name              equ 0
3613               0050                       ; Device indicated not in system
3614               0051                       ; Error code 0 with condition bit set, indicates a
3615               0052                       ; device not present in system
3616               0053
3617               0054      0001     io.err.device_write_prottected      equ 1
3618               0055                       ; Device is write protected
3619               0056
3620               0057      0002     io.err.bad_open_attribute           equ 2
3621               0058                       ; One or more of the OPEN attributes are illegal or do
3622               0059                       ; not match the file's actual characteristics.
3623               0060                       ; This could be:
3624               0061                       ;   * File type
3625               0062                       ;   * Record length
3626               0063                       ;   * I/O mode
3627               0064                       ;   * File organization
3628               0065
3629               0066      0003     io.err.illegal_operation            equ 3
3630               0067                       ; Either an issued I/O command was not supported, or a
3631               0068                       ; conflict with the OPEN mode has occured
3632               0069
3633               0070      0004     io.err.out_of_table_buffer_space    equ 4
3634               0071                       ; The amount of space left on the device is insufficient
3635               0072                       ; for the requested operation
3636               0073
3637               0074      0005     io.err.eof                          equ 5
3638               0075                       ; Attempt to read past end of file.
3639               0076                       ; This error may also be given for non-existing records
3640               0077                       ; in a relative record file
3641               0078
3642               0079      0006     io.err.device_error                 equ 6
3643               0080                       ; Covers all hard device errors, such as parity and
3644               0081                       ; bad medium errors
3645               0082
3646               0083      0007     io.err.file_error                   equ 7
3647               0084                       ; Covers all file-related error like: program/data
3648               0085                       ; file mismatch, non-existing file opened for input mode, etc.
3649               **** **** ****     > runlib.asm
3650               0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
3651               **** **** ****     > fio_dsrlnk.asm
3652               0001               * FILE......: fio_dsrlnk.asm
3653               0002               * Purpose...: Custom DSRLNK implementation
3654               0003
3655               0004               *//////////////////////////////////////////////////////////////
3656               0005               *                          DSRLNK
3657               0006               *//////////////////////////////////////////////////////////////
3658               0007
3659               0008
3660               0009               ***************************************************************
3661               0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
3662               0011               ***************************************************************
3663               0012               *  blwp @dsrlnk
3664               0013               *  data p0
3665               0014               *--------------------------------------------------------------
3666               0015               *  P0 = 8 or 10 (a)
3667               0016               *--------------------------------------------------------------
3668               0017               *  Output:
3669               0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
3670               0019               *--------------------------------------------------------------
3671               0020               ; Spectra2 scratchpad memory needs to be paged out before.
3672               0021               ; You need to specify following equates in main program
3673               0022               ;
3674               0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
3675               0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
3676               0025               ;
3677               0026               ; Scratchpad memory usage
3678               0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
3679               0028               ; >8356            Pointer to PAB
3680               0029               ; >83D0            CRU address of current device
3681               0030               ; >83D2            DSR entry address
3682               0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
3683               0032               ;
3684               0033               ; Credits
3685               0034               ; Originally appeared in Miller Graphics The Smart Programmer.
3686               0035               ; This version based on version of Paolo Bagnaresi.
3687               0036               *--------------------------------------------------------------
3688               0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
3689               0038                                                   ; dstype is address of R5 of DSRLNK ws
3690               0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
3691               0040               ********|*****|*********************|**************************
3692               0041 6AEC A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
3693               0042 6AEE 2A8E             data  dsrlnk.init           ; entry point
3694               0043                       ;------------------------------------------------------
3695               0044                       ; DSRLNK entry point
3696               0045                       ;------------------------------------------------------
3697               0046               dsrlnk.init:
3698               0047 6AF0 C17E  30         mov   *r14+,r5              ; get pgm type for link
3699               0048 6AF2 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
3700                    6AF4 8322
3701               0049 6AF6 53E0  34         szcb  @hb$20,r15            ; reset equal bit
3702                    6AF8 2026
3703               0050 6AFA C020  34         mov   @>8356,r0             ; get ptr to pab
3704                    6AFC 8356
3705               0051 6AFE C240  18         mov   r0,r9                 ; save ptr
3706               0052                       ;------------------------------------------------------
3707               0053                       ; Fetch file descriptor length from PAB
3708               0054                       ;------------------------------------------------------
3709               0055 6B00 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
3710                    6B02 FFF8
3711               0056
3712               0057                       ;---------------------------; Inline VSBR start
3713               0058 6B04 06C0  14         swpb  r0                    ;
3714               0059 6B06 D800  38         movb  r0,@vdpa              ; send low byte
3715                    6B08 8C02
3716               0060 6B0A 06C0  14         swpb  r0                    ;
3717               0061 6B0C D800  38         movb  r0,@vdpa              ; send high byte
3718                    6B0E 8C02
3719               0062 6B10 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
3720                    6B12 8800
3721               0063                       ;---------------------------; Inline VSBR end
3722               0064 6B14 0983  56         srl   r3,8                  ; Move to low byte
3723               0065
3724               0066                       ;------------------------------------------------------
3725               0067                       ; Fetch file descriptor device name from PAB
3726               0068                       ;------------------------------------------------------
3727               0069 6B16 0704  14         seto  r4                    ; init counter
3728               0070 6B18 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
3729                    6B1A A420
3730               0071 6B1C 0580  14 !       inc   r0                    ; point to next char of name
3731               0072 6B1E 0584  14         inc   r4                    ; incr char counter
3732               0073 6B20 0284  22         ci    r4,>0007              ; see if length more than 7 chars
3733                    6B22 0007
3734               0074 6B24 1565  14         jgt   dsrlnk.error.devicename_invalid
3735               0075                                                   ; yes, error
3736               0076 6B26 80C4  18         c     r4,r3                 ; end of name?
3737               0077 6B28 130C  14         jeq   dsrlnk.device_name.get_length
3738               0078                                                   ; yes
3739               0079
3740               0080                       ;---------------------------; Inline VSBR start
3741               0081 6B2A 06C0  14         swpb  r0                    ;
3742               0082 6B2C D800  38         movb  r0,@vdpa              ; send low byte
3743                    6B2E 8C02
3744               0083 6B30 06C0  14         swpb  r0                    ;
3745               0084 6B32 D800  38         movb  r0,@vdpa              ; send high byte
3746                    6B34 8C02
3747               0085 6B36 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
3748                    6B38 8800
3749               0086                       ;---------------------------; Inline VSBR end
3750               0087
3751               0088                       ;------------------------------------------------------
3752               0089                       ; Look for end of device name, for example "DSK1."
3753               0090                       ;------------------------------------------------------
3754               0091 6B3A DC81  32         movb  r1,*r2+               ; move into buffer
3755               0092 6B3C 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
3756                    6B3E 2B9E
3757               0093 6B40 16ED  14         jne   -!                    ; no, loop next char
3758               0094                       ;------------------------------------------------------
3759               0095                       ; Determine device name length
3760               0096                       ;------------------------------------------------------
3761               0097               dsrlnk.device_name.get_length:
3762               0098 6B42 C104  18         mov   r4,r4                 ; Check if length = 0
3763               0099 6B44 1355  14         jeq   dsrlnk.error.devicename_invalid
3764               0100                                                   ; yes, error
3765               0101 6B46 04E0  34         clr   @>83d0
3766                    6B48 83D0
3767               0102 6B4A C804  38         mov   r4,@>8354             ; save name length for search
3768                    6B4C 8354
3769               0103 6B4E 0584  14         inc   r4                    ; adjust for dot
3770               0104 6B50 A804  38         a     r4,@>8356             ; point to position after name
3771                    6B52 8356
3772               0105                       ;------------------------------------------------------
3773               0106                       ; Prepare for DSR scan >1000 - >1f00
3774               0107                       ;------------------------------------------------------
3775               0108               dsrlnk.dsrscan.start:
3776               0109 6B54 02E0  18         lwpi  >83e0                 ; Use GPL WS
3777                    6B56 83E0
3778               0110 6B58 04C1  14         clr   r1                    ; version found of dsr
3779               0111 6B5A 020C  20         li    r12,>0f00             ; init cru addr
3780                    6B5C 0F00
3781               0112                       ;------------------------------------------------------
3782               0113                       ; Turn off ROM on current card
3783               0114                       ;------------------------------------------------------
3784               0115               dsrlnk.dsrscan.cardoff:
3785               0116 6B5E C30C  18         mov   r12,r12               ; anything to turn off?
3786               0117 6B60 1301  14         jeq   dsrlnk.dsrscan.cardloop
3787               0118                                                   ; no, loop over cards
3788               0119 6B62 1E00  20         sbz   0                     ; yes, turn off
3789               0120                       ;------------------------------------------------------
3790               0121                       ; Loop over cards and look if DSR present
3791               0122                       ;------------------------------------------------------
3792               0123               dsrlnk.dsrscan.cardloop:
3793               0124 6B64 022C  22         ai    r12,>0100             ; next rom to turn on
3794                    6B66 0100
3795               0125 6B68 04E0  34         clr   @>83d0                ; clear in case we are done
3796                    6B6A 83D0
3797               0126 6B6C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
3798                    6B6E 2000
3799               0127 6B70 133D  14         jeq   dsrlnk.error.nodsr_found
3800               0128                                                   ; yes, no matching DSR found
3801               0129 6B72 C80C  38         mov   r12,@>83d0            ; save addr of next cru
3802                    6B74 83D0
3803               0130                       ;------------------------------------------------------
3804               0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
3805               0132                       ;------------------------------------------------------
3806               0133 6B76 1D00  20         sbo   0                     ; turn on rom
3807               0134 6B78 0202  20         li    r2,>4000              ; start at beginning of rom
3808                    6B7A 4000
3809               0135 6B7C 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
3810                    6B7E 2B9A
3811               0136 6B80 16EE  14         jne   dsrlnk.dsrscan.cardoff
3812               0137                                                   ; no rom found on card
3813               0138                       ;------------------------------------------------------
3814               0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
3815               0140                       ;------------------------------------------------------
3816               0141                       ; dstype is the address of R5 of the DSRLNK workspace,
3817               0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
3818               0143                       ; is stored before the DSR ROM is searched.
3819               0144                       ;------------------------------------------------------
3820               0145 6B82 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
3821                    6B84 A40A
3822               0146 6B86 1003  14         jmp   dsrlnk.dsrscan.getentry
3823               0147                       ;------------------------------------------------------
3824               0148                       ; Next DSR entry
3825               0149                       ;------------------------------------------------------
3826               0150               dsrlnk.dsrscan.nextentry:
3827               0151 6B88 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
3828                    6B8A 83D2
3829               0152                                                   ; subprogram
3830               0153
3831               0154 6B8C 1D00  20         sbo   0                     ; turn rom back on
3832               0155                       ;------------------------------------------------------
3833               0156                       ; Get DSR entry
3834               0157                       ;------------------------------------------------------
3835               0158               dsrlnk.dsrscan.getentry:
3836               0159 6B8E C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
3837               0160 6B90 13E6  14         jeq   dsrlnk.dsrscan.cardoff
3838               0161                                                   ; yes, no more DSRs or programs to check
3839               0162 6B92 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
3840                    6B94 83D2
3841               0163                                                   ; subprogram
3842               0164
3843               0165 6B96 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
3844               0166                                                   ; DSR/subprogram code
3845               0167
3846               0168 6B98 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
3847               0169                                                   ; offset 4 (DSR/subprogram name)
3848               0170                       ;------------------------------------------------------
3849               0171                       ; Check file descriptor in DSR
3850               0172                       ;------------------------------------------------------
3851               0173 6B9A 04C5  14         clr   r5                    ; Remove any old stuff
3852               0174 6B9C D160  34         movb  @>8355,r5             ; get length as counter
3853                    6B9E 8355
3854               0175 6BA0 130B  14         jeq   dsrlnk.dsrscan.call_dsr
3855               0176                                                   ; if zero, do not further check, call DSR
3856               0177                                                   ; program
3857               0178
3858               0179 6BA2 9C85  32         cb    r5,*r2+               ; see if length matches
3859               0180 6BA4 16F1  14         jne   dsrlnk.dsrscan.nextentry
3860               0181                                                   ; no, length does not match. Go process next
3861               0182                                                   ; DSR entry
3862               0183
3863               0184 6BA6 0985  56         srl   r5,8                  ; yes, move to low byte
3864               0185 6BA8 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
3865                    6BAA A420
3866               0186 6BAC 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
3867               0187                                                   ; DSR ROM
3868               0188 6BAE 16EC  14         jne   dsrlnk.dsrscan.nextentry
3869               0189                                                   ; try next DSR entry if no match
3870               0190 6BB0 0605  14         dec   r5                    ; loop until full length checked
3871               0191 6BB2 16FC  14         jne   -!
3872               0192                       ;------------------------------------------------------
3873               0193                       ; Device name/Subprogram match
3874               0194                       ;------------------------------------------------------
3875               0195               dsrlnk.dsrscan.match:
3876               0196 6BB4 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
3877                    6BB6 83D2
3878               0197
3879               0198                       ;------------------------------------------------------
3880               0199                       ; Call DSR program in device card
3881               0200                       ;------------------------------------------------------
3882               0201               dsrlnk.dsrscan.call_dsr:
3883               0202 6BB8 0581  14         inc   r1                    ; next version found
3884               0203 6BBA 0699  24         bl    *r9                   ; go run routine
3885               0204                       ;
3886               0205                       ; Depending on IO result the DSR in card ROM does RET
3887               0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
3888               0207                       ;
3889               0208 6BBC 10E5  14         jmp   dsrlnk.dsrscan.nextentry
3890               0209                                                   ; (1) error return
3891               0210 6BBE 1E00  20         sbz   0                     ; (2) turn off rom if good return
3892               0211 6BC0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
3893                    6BC2 A400
3894               0212 6BC4 C009  18         mov   r9,r0                 ; point to flag in pab
3895               0213 6BC6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
3896                    6BC8 8322
3897               0214                                                   ; (8 or >a)
3898               0215 6BCA 0281  22         ci    r1,8                  ; was it 8?
3899                    6BCC 0008
3900               0216 6BCE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
3901               0217 6BD0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
3902                    6BD2 8350
3903               0218                                                   ; Get error byte from @>8350
3904               0219 6BD4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
3905               0220
3906               0221                       ;------------------------------------------------------
3907               0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
3908               0223                       ;------------------------------------------------------
3909               0224               dsrlnk.dsrscan.dsr.8:
3910               0225                       ;---------------------------; Inline VSBR start
3911               0226 6BD6 06C0  14         swpb  r0                    ;
3912               0227 6BD8 D800  38         movb  r0,@vdpa              ; send low byte
3913                    6BDA 8C02
3914               0228 6BDC 06C0  14         swpb  r0                    ;
3915               0229 6BDE D800  38         movb  r0,@vdpa              ; send high byte
3916                    6BE0 8C02
3917               0230 6BE2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
3918                    6BE4 8800
3919               0231                       ;---------------------------; Inline VSBR end
3920               0232
3921               0233                       ;------------------------------------------------------
3922               0234                       ; Return DSR error to caller
3923               0235                       ;------------------------------------------------------
3924               0236               dsrlnk.dsrscan.dsr.a:
3925               0237 6BE6 09D1  56         srl   r1,13                 ; just keep error bits
3926               0238 6BE8 1604  14         jne   dsrlnk.error.io_error
3927               0239                                                   ; handle IO error
3928               0240 6BEA 0380  18         rtwp                        ; Return from DSR workspace to caller
3929               0241                                                   ; workspace
3930               0242
3931               0243                       ;------------------------------------------------------
3932               0244                       ; IO-error handler
3933               0245                       ;------------------------------------------------------
3934               0246               dsrlnk.error.nodsr_found:
3935               0247 6BEC 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
3936                    6BEE A400
3937               0248               dsrlnk.error.devicename_invalid:
3938               0249 6BF0 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
3939               0250               dsrlnk.error.io_error:
3940               0251 6BF2 06C1  14         swpb  r1                    ; put error in hi byte
3941               0252 6BF4 D741  30         movb  r1,*r13               ; store error flags in callers r0
3942               0253 6BF6 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
3943                    6BF8 2026
3944               0254 6BFA 0380  18         rtwp                        ; Return from DSR workspace to caller
3945               0255                                                   ; workspace
3946               0256
3947               0257               ********************************************************************************
3948               0258
3949               0259 6BFC AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
3950               0260 6BFE 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
3951               0261                                                   ; a @blwp @dsrlnk
3952               0262 6C00 ....     dsrlnk.period     text  '.'         ; For finding end of device name
3953               0263
3954               0264                       even
3955               **** **** ****     > runlib.asm
3956               0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
3957               **** **** ****     > fio_level2.asm
3958               0001               * FILE......: fio_level2.asm
3959               0002               * Purpose...: File I/O level 2 support
3960               0003
3961               0004
3962               0005               ***************************************************************
3963               0006               * PAB  - Peripheral Access Block
3964               0007               ********|*****|*********************|**************************
3965               0008               ; my_pab:
3966               0009               ;       byte  io.op.open            ;  0    - OPEN
3967               0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
3968               0011               ;                                   ;         Bit 13-15 used by DSR for returning
3969               0012               ;                                   ;         file error details to DSRLNK
3970               0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
3971               0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
3972               0015               ;       byte  0                     ;  5    - Character count (bytes read)
3973               0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
3974               0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
3975               0018               ; -------------------------------------------------------------
3976               0019               ;       byte  11                    ;  9    - File descriptor length
3977               0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
3978               0021               ;       even
3979               0022               ***************************************************************
3980               0023
3981               0024
3982               0025               ***************************************************************
3983               0026               * file.open - Open File for procesing
3984               0027               ***************************************************************
3985               0028               *  bl   @file.open
3986               0029               *  data P0
3987               0030               *--------------------------------------------------------------
3988               0031               *  P0 = Address of PAB in VDP RAM
3989               0032               *--------------------------------------------------------------
3990               0033               *  bl   @xfile.open
3991               0034               *
3992               0035               *  R0 = Address of PAB in VDP RAM
3993               0036               *--------------------------------------------------------------
3994               0037               *  Output:
3995               0038               *  tmp0 LSB = VDP PAB byte 1 (status)
3996               0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
3997               0040               *  tmp2     = Status register contents upon DSRLNK return
3998               0041               ********|*****|*********************|**************************
3999               0042               file.open:
4000               0043 6C02 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4001               0044               *--------------------------------------------------------------
4002               0045               * Initialisation
4003               0046               *--------------------------------------------------------------
4004               0047               xfile.open:
4005               0048 6C04 C04B  18         mov   r11,r1                ; Save return address
4006               0049 6C06 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4007                    6C08 A428
4008               0050 6C0A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4009               0051 6C0C 04C5  14         clr   tmp1                  ; io.op.open
4010               0052 6C0E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4011                    6C10 22AC
4012               0053               file.open_init:
4013               0054 6C12 0220  22         ai    r0,9                  ; Move to file descriptor length
4014                    6C14 0009
4015               0055 6C16 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4016                    6C18 8356
4017               0056               *--------------------------------------------------------------
4018               0057               * Main
4019               0058               *--------------------------------------------------------------
4020               0059               file.open_main:
4021               0060 6C1A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4022                    6C1C 2A8A
4023               0061 6C1E 0008             data  8                     ; Level 2 IO call
4024               0062               *--------------------------------------------------------------
4025               0063               * Exit
4026               0064               *--------------------------------------------------------------
4027               0065               file.open_exit:
4028               0066 6C20 1029  14         jmp   file.record.pab.details
4029               0067                                                   ; Get status and return to caller
4030               0068                                                   ; Status register bits are unaffected
4031               0069
4032               0070
4033               0071
4034               0072               ***************************************************************
4035               0073               * file.close - Close currently open file
4036               0074               ***************************************************************
4037               0075               *  bl   @file.close
4038               0076               *  data P0
4039               0077               *--------------------------------------------------------------
4040               0078               *  P0 = Address of PAB in VDP RAM
4041               0079               *--------------------------------------------------------------
4042               0080               *  bl   @xfile.close
4043               0081               *
4044               0082               *  R0 = Address of PAB in VDP RAM
4045               0083               *--------------------------------------------------------------
4046               0084               *  Output:
4047               0085               *  tmp0 LSB = VDP PAB byte 1 (status)
4048               0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4049               0087               *  tmp2     = Status register contents upon DSRLNK return
4050               0088               ********|*****|*********************|**************************
4051               0089               file.close:
4052               0090 6C22 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4053               0091               *--------------------------------------------------------------
4054               0092               * Initialisation
4055               0093               *--------------------------------------------------------------
4056               0094               xfile.close:
4057               0095 6C24 C04B  18         mov   r11,r1                ; Save return address
4058               0096 6C26 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4059                    6C28 A428
4060               0097 6C2A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4061               0098 6C2C 0205  20         li    tmp1,io.op.close      ; io.op.close
4062                    6C2E 0001
4063               0099 6C30 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4064                    6C32 22AC
4065               0100               file.close_init:
4066               0101 6C34 0220  22         ai    r0,9                  ; Move to file descriptor length
4067                    6C36 0009
4068               0102 6C38 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4069                    6C3A 8356
4070               0103               *--------------------------------------------------------------
4071               0104               * Main
4072               0105               *--------------------------------------------------------------
4073               0106               file.close_main:
4074               0107 6C3C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4075                    6C3E 2A8A
4076               0108 6C40 0008             data  8                     ;
4077               0109               *--------------------------------------------------------------
4078               0110               * Exit
4079               0111               *--------------------------------------------------------------
4080               0112               file.close_exit:
4081               0113 6C42 1018  14         jmp   file.record.pab.details
4082               0114                                                   ; Get status and return to caller
4083               0115                                                   ; Status register bits are unaffected
4084               0116
4085               0117
4086               0118
4087               0119
4088               0120
4089               0121               ***************************************************************
4090               0122               * file.record.read - Read record from file
4091               0123               ***************************************************************
4092               0124               *  bl   @file.record.read
4093               0125               *  data P0
4094               0126               *--------------------------------------------------------------
4095               0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4096               0128               *--------------------------------------------------------------
4097               0129               *  bl   @xfile.record.read
4098               0130               *
4099               0131               *  R0 = Address of PAB in VDP RAM
4100               0132               *--------------------------------------------------------------
4101               0133               *  Output:
4102               0134               *  tmp0 LSB = VDP PAB byte 1 (status)
4103               0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4104               0136               *  tmp2     = Status register contents upon DSRLNK return
4105               0137               ********|*****|*********************|**************************
4106               0138               file.record.read:
4107               0139 6C44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4108               0140               *--------------------------------------------------------------
4109               0141               * Initialisation
4110               0142               *--------------------------------------------------------------
4111               0143               xfile.record.read:
4112               0144 6C46 C04B  18         mov   r11,r1                ; Save return address
4113               0145 6C48 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4114                    6C4A A428
4115               0146 6C4C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4116               0147 6C4E 0205  20         li    tmp1,io.op.read       ; io.op.read
4117                    6C50 0002
4118               0148 6C52 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4119                    6C54 22AC
4120               0149               file.record.read_init:
4121               0150 6C56 0220  22         ai    r0,9                  ; Move to file descriptor length
4122                    6C58 0009
4123               0151 6C5A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4124                    6C5C 8356
4125               0152               *--------------------------------------------------------------
4126               0153               * Main
4127               0154               *--------------------------------------------------------------
4128               0155               file.record.read_main:
4129               0156 6C5E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4130                    6C60 2A8A
4131               0157 6C62 0008             data  8                     ;
4132               0158               *--------------------------------------------------------------
4133               0159               * Exit
4134               0160               *--------------------------------------------------------------
4135               0161               file.record.read_exit:
4136               0162 6C64 1007  14         jmp   file.record.pab.details
4137               0163                                                   ; Get status and return to caller
4138               0164                                                   ; Status register bits are unaffected
4139               0165
4140               0166
4141               0167
4142               0168
4143               0169               file.record.write:
4144               0170 6C66 1000  14         nop
4145               0171
4146               0172
4147               0173               file.record.seek:
4148               0174 6C68 1000  14         nop
4149               0175
4150               0176
4151               0177               file.image.load:
4152               0178 6C6A 1000  14         nop
4153               0179
4154               0180
4155               0181               file.image.save:
4156               0182 6C6C 1000  14         nop
4157               0183
4158               0184
4159               0185               file.delete:
4160               0186 6C6E 1000  14         nop
4161               0187
4162               0188
4163               0189               file.rename:
4164               0190 6C70 1000  14         nop
4165               0191
4166               0192
4167               0193               file.status:
4168               0194 6C72 1000  14         nop
4169               0195
4170               0196
4171               0197
4172               0198               ***************************************************************
4173               0199               * file.record.pab.details - Return PAB details to caller
4174               0200               ***************************************************************
4175               0201               * Called internally via JMP/B by file operations
4176               0202               *--------------------------------------------------------------
4177               0203               *  Output:
4178               0204               *  tmp0 LSB = VDP PAB byte 1 (status)
4179               0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4180               0206               *  tmp2     = Status register contents upon DSRLNK return
4181               0207               ********|*****|*********************|**************************
4182               0208
4183               0209               ********|*****|*********************|**************************
4184               0210               file.record.pab.details:
4185               0211 6C74 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
4186               0212                                                   ; Upon DSRLNK return status register EQ bit
4187               0213                                                   ; 1 = No file error
4188               0214                                                   ; 0 = File error occured
4189               0215               *--------------------------------------------------------------
4190               0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
4191               0217               *--------------------------------------------------------------
4192               0218 6C76 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
4193                    6C78 A428
4194               0219 6C7A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
4195                    6C7C 0005
4196               0220 6C7E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
4197                    6C80 22C4
4198               0221 6C82 C144  18         mov   tmp0,tmp1             ; Move to destination
4199               0222               *--------------------------------------------------------------
4200               0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
4201               0224               *--------------------------------------------------------------
4202               0225 6C84 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
4203               0226                                                   ; as returned by DSRLNK
4204               0227               *--------------------------------------------------------------
4205               0228               * Exit
4206               0229               *--------------------------------------------------------------
4207               0230               ; If an error occured during the IO operation, then the
4208               0231               ; equal bit in the saved status register (=tmp2) is set to 1.
4209               0232               ;
4210               0233               ; If no error occured during the IO operation, then the
4211               0234               ; equal bit in the saved status register (=tmp2) is set to 0.
4212               0235               ;
4213               0236               ; Upon return from this IO call you should basically test with:
4214               0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
4215               0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
4216               0239               ;
4217               0240               ; Then look for further details in the copy of VDP PAB byte 1
4218               0241               ; in register tmp0, bits 13-15
4219               0242               ;
4220               0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
4221               0244               ;                                   ; calls, skip for type >A subprograms!)
4222               0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
4223               0246               ;       jeq   my_error_handler
4224               0247               *--------------------------------------------------------------
4225               0248               file.record.pab.details.exit:
4226               0249 6C86 0451  20         b     *r1                   ; Return to caller
4227               **** **** ****     > runlib.asm
4228               0217
4229               0218               *//////////////////////////////////////////////////////////////
4230               0219               *                            TIMERS
4231               0220               *//////////////////////////////////////////////////////////////
4232               0221
4233               0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
4234               **** **** ****     > timers_tmgr.asm
4235               0001               * FILE......: timers_tmgr.asm
4236               0002               * Purpose...: Timers / Thread scheduler
4237               0003
4238               0004               ***************************************************************
4239               0005               * TMGR - X - Start Timers/Thread scheduler
4240               0006               ***************************************************************
4241               0007               *  B @TMGR
4242               0008               *--------------------------------------------------------------
4243               0009               *  REMARKS
4244               0010               *  Timer/Thread scheduler. Normally called from MAIN.
4245               0011               *  This is basically the kernel keeping everything togehter.
4246               0012               *  Do not forget to set BTIHI to highest slot in use.
4247               0013               *
4248               0014               *  Register usage in TMGR8 - TMGR11
4249               0015               *  TMP0  = Pointer to timer table
4250               0016               *  R10LB = Use as slot counter
4251               0017               *  TMP2  = 2nd word of slot data
4252               0018               *  TMP3  = Address of routine to call
4253               0019               ********|*****|*********************|**************************
4254               0020 6C88 0300  24 tmgr    limi  0                     ; No interrupt processing
4255                    6C8A 0000
4256               0021               *--------------------------------------------------------------
4257               0022               * Read VDP status register
4258               0023               *--------------------------------------------------------------
4259               0024 6C8C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
4260                    6C8E 8802
4261               0025               *--------------------------------------------------------------
4262               0026               * Latch sprite collision flag
4263               0027               *--------------------------------------------------------------
4264               0028 6C90 2360  38         coc   @wbit2,r13            ; C flag on ?
4265                    6C92 2026
4266               0029 6C94 1602  14         jne   tmgr1a                ; No, so move on
4267               0030 6C96 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
4268                    6C98 2012
4269               0031               *--------------------------------------------------------------
4270               0032               * Interrupt flag
4271               0033               *--------------------------------------------------------------
4272               0034 6C9A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
4273                    6C9C 202A
4274               0035 6C9E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
4275               0036               *--------------------------------------------------------------
4276               0037               * Run speech player
4277               0038               *--------------------------------------------------------------
4278               0044               *--------------------------------------------------------------
4279               0045               * Run kernel thread
4280               0046               *--------------------------------------------------------------
4281               0047 6CA0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
4282                    6CA2 201A
4283               0048 6CA4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
4284               0049 6CA6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
4285                    6CA8 2018
4286               0050 6CAA 1602  14         jne   tmgr3                 ; No, skip to user hook
4287               0051 6CAC 0460  28         b     @kthread              ; Run kernel thread
4288                    6CAE 2CC4
4289               0052               *--------------------------------------------------------------
4290               0053               * Run user hook
4291               0054               *--------------------------------------------------------------
4292               0055 6CB0 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
4293                    6CB2 201E
4294               0056 6CB4 13EB  14         jeq   tmgr1
4295               0057 6CB6 20A0  38         coc   @wbit7,config         ; User hook enabled ?
4296                    6CB8 201C
4297               0058 6CBA 16E8  14         jne   tmgr1
4298               0059 6CBC C120  34         mov   @wtiusr,tmp0
4299                    6CBE 832E
4300               0060 6CC0 0454  20         b     *tmp0                 ; Run user hook
4301               0061               *--------------------------------------------------------------
4302               0062               * Do internal housekeeping
4303               0063               *--------------------------------------------------------------
4304               0064 6CC2 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
4305                    6CC4 2CC2
4306               0065 6CC6 C10A  18         mov   r10,tmp0
4307               0066 6CC8 0244  22         andi  tmp0,>00ff            ; Clear HI byte
4308                    6CCA 00FF
4309               0067 6CCC 20A0  38         coc   @wbit2,config         ; PAL flag set ?
4310                    6CCE 2026
4311               0068 6CD0 1303  14         jeq   tmgr5
4312               0069 6CD2 0284  22         ci    tmp0,60               ; 1 second reached ?
4313                    6CD4 003C
4314               0070 6CD6 1002  14         jmp   tmgr6
4315               0071 6CD8 0284  22 tmgr5   ci    tmp0,50
4316                    6CDA 0032
4317               0072 6CDC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
4318               0073 6CDE 1001  14         jmp   tmgr8
4319               0074 6CE0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
4320               0075               *--------------------------------------------------------------
4321               0076               * Loop over slots
4322               0077               *--------------------------------------------------------------
4323               0078 6CE2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
4324                    6CE4 832C
4325               0079 6CE6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
4326                    6CE8 FF00
4327               0080 6CEA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
4328               0081 6CEC 1316  14         jeq   tmgr11                ; Yes, get next slot
4329               0082               *--------------------------------------------------------------
4330               0083               *  Check if slot should be executed
4331               0084               *--------------------------------------------------------------
4332               0085 6CEE 05C4  14         inct  tmp0                  ; Second word of slot data
4333               0086 6CF0 0594  26         inc   *tmp0                 ; Update tick count in slot
4334               0087 6CF2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
4335               0088 6CF4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
4336                    6CF6 830C
4337                    6CF8 830D
4338               0089 6CFA 1608  14         jne   tmgr10                ; No, get next slot
4339               0090 6CFC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
4340                    6CFE FF00
4341               0091 6D00 C506  30         mov   tmp2,*tmp0            ; Update timer table
4342               0092               *--------------------------------------------------------------
4343               0093               *  Run slot, we only need TMP0 to survive
4344               0094               *--------------------------------------------------------------
4345               0095 6D02 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
4346                    6D04 8330
4347               0096 6D06 0697  24         bl    *tmp3                 ; Call routine in slot
4348               0097 6D08 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
4349                    6D0A 8330
4350               0098               *--------------------------------------------------------------
4351               0099               *  Prepare for next slot
4352               0100               *--------------------------------------------------------------
4353               0101 6D0C 058A  14 tmgr10  inc   r10                   ; Next slot
4354               0102 6D0E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
4355                    6D10 8315
4356                    6D12 8314
4357               0103 6D14 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
4358               0104 6D16 05C4  14         inct  tmp0                  ; Offset for next slot
4359               0105 6D18 10E8  14         jmp   tmgr9                 ; Process next slot
4360               0106 6D1A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
4361               0107 6D1C 10F7  14         jmp   tmgr10                ; Process next slot
4362               0108 6D1E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
4363                    6D20 FF00
4364               0109 6D22 10B4  14         jmp   tmgr1
4365               0110 6D24 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
4366               0111
4367               **** **** ****     > runlib.asm
4368               0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
4369               **** **** ****     > timers_kthread.asm
4370               0001               * FILE......: timers_kthread.asm
4371               0002               * Purpose...: Timers / The kernel thread
4372               0003
4373               0004
4374               0005               ***************************************************************
4375               0006               * KTHREAD - The kernel thread
4376               0007               *--------------------------------------------------------------
4377               0008               *  REMARKS
4378               0009               *  You should not call the kernel thread manually.
4379               0010               *  Instead control it via the CONFIG register.
4380               0011               *
4381               0012               *  The kernel thread is responsible for running the sound
4382               0013               *  player and doing keyboard scan.
4383               0014               ********|*****|*********************|**************************
4384               0015 6D26 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
4385                    6D28 201A
4386               0016               *--------------------------------------------------------------
4387               0017               * Run sound player
4388               0018               *--------------------------------------------------------------
4389               0020               *       <<skipped>>
4390               0026               *--------------------------------------------------------------
4391               0027               * Scan virtual keyboard
4392               0028               *--------------------------------------------------------------
4393               0029               kthread_kb
4394               0031               *       <<skipped>>
4395               0035               *--------------------------------------------------------------
4396               0036               * Scan real keyboard
4397               0037               *--------------------------------------------------------------
4398               0041 6D2A 06A0  32         bl    @realkb               ; Scan full keyboard
4399                    6D2C 276A
4400               0043               *--------------------------------------------------------------
4401               0044               kthread_exit
4402               0045 6D2E 0460  28         b     @tmgr3                ; Exit
4403                    6D30 2C4E
4404               **** **** ****     > runlib.asm
4405               0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
4406               **** **** ****     > timers_hooks.asm
4407               0001               * FILE......: timers_kthread.asm
4408               0002               * Purpose...: Timers / User hooks
4409               0003
4410               0004
4411               0005               ***************************************************************
4412               0006               * MKHOOK - Allocate user hook
4413               0007               ***************************************************************
4414               0008               *  BL    @MKHOOK
4415               0009               *  DATA  P0
4416               0010               *--------------------------------------------------------------
4417               0011               *  P0 = Address of user hook
4418               0012               *--------------------------------------------------------------
4419               0013               *  REMARKS
4420               0014               *  The user hook gets executed after the kernel thread.
4421               0015               *  The user hook must always exit with "B @HOOKOK"
4422               0016               ********|*****|*********************|**************************
4423               0017 6D32 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
4424                    6D34 832E
4425               0018 6D36 E0A0  34         soc   @wbit7,config         ; Enable user hook
4426                    6D38 201C
4427               0019 6D3A 045B  20 mkhoo1  b     *r11                  ; Return
4428               0020      2C2A     hookok  equ   tmgr1                 ; Exit point for user hook
4429               0021
4430               0022
4431               0023               ***************************************************************
4432               0024               * CLHOOK - Clear user hook
4433               0025               ***************************************************************
4434               0026               *  BL    @CLHOOK
4435               0027               ********|*****|*********************|**************************
4436               0028 6D3C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
4437                    6D3E 832E
4438               0029 6D40 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
4439                    6D42 FEFF
4440               0030 6D44 045B  20         b     *r11                  ; Return
4441               **** **** ****     > runlib.asm
4442               0225
4443               0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
4444               **** **** ****     > timers_alloc.asm
4445               0001               * FILE......: timer_alloc.asm
4446               0002               * Purpose...: Timers / Timer allocation
4447               0003
4448               0004
4449               0005               ***************************************************************
4450               0006               * MKSLOT - Allocate timer slot(s)
4451               0007               ***************************************************************
4452               0008               *  BL    @MKSLOT
4453               0009               *  BYTE  P0HB,P0LB
4454               0010               *  DATA  P1
4455               0011               *  ....
4456               0012               *  DATA  EOL                        ; End-of-list
4457               0013               *--------------------------------------------------------------
4458               0014               *  P0 = Slot number, target count
4459               0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
4460               0016               ********|*****|*********************|**************************
4461               0017 6D46 C13B  30 mkslot  mov   *r11+,tmp0
4462               0018 6D48 C17B  30         mov   *r11+,tmp1
4463               0019               *--------------------------------------------------------------
4464               0020               *  Calculate address of slot
4465               0021               *--------------------------------------------------------------
4466               0022 6D4A C184  18         mov   tmp0,tmp2
4467               0023 6D4C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
4468               0024 6D4E A1A0  34         a     @wtitab,tmp2          ; Add table base
4469                    6D50 832C
4470               0025               *--------------------------------------------------------------
4471               0026               *  Add slot to table
4472               0027               *--------------------------------------------------------------
4473               0028 6D52 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
4474               0029 6D54 0A84  56         sla   tmp0,8                ; Get rid of slot number
4475               0030 6D56 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
4476               0031               *--------------------------------------------------------------
4477               0032               *  Check for end of list
4478               0033               *--------------------------------------------------------------
4479               0034 6D58 881B  46         c     *r11,@w$ffff          ; End of list ?
4480                    6D5A 202C
4481               0035 6D5C 1301  14         jeq   mkslo1                ; Yes, exit
4482               0036 6D5E 10F3  14         jmp   mkslot                ; Process next entry
4483               0037               *--------------------------------------------------------------
4484               0038               *  Exit
4485               0039               *--------------------------------------------------------------
4486               0040 6D60 05CB  14 mkslo1  inct  r11
4487               0041 6D62 045B  20         b     *r11                  ; Exit
4488               0042
4489               0043
4490               0044               ***************************************************************
4491               0045               * CLSLOT - Clear single timer slot
4492               0046               ***************************************************************
4493               0047               *  BL    @CLSLOT
4494               0048               *  DATA  P0
4495               0049               *--------------------------------------------------------------
4496               0050               *  P0 = Slot number
4497               0051               ********|*****|*********************|**************************
4498               0052 6D64 C13B  30 clslot  mov   *r11+,tmp0
4499               0053 6D66 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
4500               0054 6D68 A120  34         a     @wtitab,tmp0          ; Add table base
4501                    6D6A 832C
4502               0055 6D6C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
4503               0056 6D6E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
4504               0057 6D70 045B  20         b     *r11                  ; Exit
4505               **** **** ****     > runlib.asm
4506               0229
4507               0230
4508               0231
4509               0232               *//////////////////////////////////////////////////////////////
4510               0233               *                    RUNLIB INITIALISATION
4511               0234               *//////////////////////////////////////////////////////////////
4512               0235
4513               0236               ***************************************************************
4514               0237               *  RUNLIB - Runtime library initalisation
4515               0238               ***************************************************************
4516               0239               *  B  @RUNLIB
4517               0240               *--------------------------------------------------------------
4518               0241               *  REMARKS
4519               0242               *  if R0 in WS1 equals >4a4a we were called from the system
4520               0243               *  crash handler so we return there after initialisation.
4521               0244
4522               0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
4523               0246               *  after clearing scratchpad memory. This has higher priority
4524               0247               *  as crash handler flag R0.
4525               0248               ********|*****|*********************|**************************
4526               0250 6D72 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
4527                    6D74 29D8
4528               0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
4529               0252
4530               0253 6D76 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
4531                    6D78 8302
4532               0257               *--------------------------------------------------------------
4533               0258               * Alternative entry point
4534               0259               *--------------------------------------------------------------
4535               0260 6D7A 0300  24 runli1  limi  0                     ; Turn off interrupts
4536                    6D7C 0000
4537               0261 6D7E 02E0  18         lwpi  ws1                   ; Activate workspace 1
4538                    6D80 8300
4539               0262 6D82 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
4540                    6D84 83C0
4541               0263               *--------------------------------------------------------------
4542               0264               * Clear scratch-pad memory from R4 upwards
4543               0265               *--------------------------------------------------------------
4544               0266 6D86 0202  20 runli2  li    r2,>8308
4545                    6D88 8308
4546               0267 6D8A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
4547               0268 6D8C 0282  22         ci    r2,>8400
4548                    6D8E 8400
4549               0269 6D90 16FC  14         jne   runli3
4550               0270               *--------------------------------------------------------------
4551               0271               * Exit to TI-99/4A title screen ?
4552               0272               *--------------------------------------------------------------
4553               0273 6D92 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
4554                    6D94 FFFF
4555               0274 6D96 1602  14         jne   runli4                ; No, continue
4556               0275 6D98 0420  54         blwp  @0                    ; Yes, bye bye
4557                    6D9A 0000
4558               0276               *--------------------------------------------------------------
4559               0277               * Determine if VDP is PAL or NTSC
4560               0278               *--------------------------------------------------------------
4561               0279 6D9C C803  38 runli4  mov   r3,@waux1             ; Store random seed
4562                    6D9E 833C
4563               0280 6DA0 04C1  14         clr   r1                    ; Reset counter
4564               0281 6DA2 0202  20         li    r2,10                 ; We test 10 times
4565                    6DA4 000A
4566               0282 6DA6 C0E0  34 runli5  mov   @vdps,r3
4567                    6DA8 8802
4568               0283 6DAA 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
4569                    6DAC 202A
4570               0284 6DAE 1302  14         jeq   runli6
4571               0285 6DB0 0581  14         inc   r1                    ; Increase counter
4572               0286 6DB2 10F9  14         jmp   runli5
4573               0287 6DB4 0602  14 runli6  dec   r2                    ; Next test
4574               0288 6DB6 16F7  14         jne   runli5
4575               0289 6DB8 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
4576                    6DBA 1250
4577               0290 6DBC 1202  14         jle   runli7                ; No, so it must be NTSC
4578               0291 6DBE 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
4579                    6DC0 2026
4580               0292               *--------------------------------------------------------------
4581               0293               * Copy machine code to scratchpad (prepare tight loop)
4582               0294               *--------------------------------------------------------------
4583               0295 6DC2 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
4584                    6DC4 2200
4585               0296 6DC6 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
4586                    6DC8 8322
4587               0297 6DCA CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
4588               0298 6DCC CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
4589               0299 6DCE CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
4590               0300               *--------------------------------------------------------------
4591               0301               * Initialize registers, memory, ...
4592               0302               *--------------------------------------------------------------
4593               0303 6DD0 04C1  14 runli9  clr   r1
4594               0304 6DD2 04C2  14         clr   r2
4595               0305 6DD4 04C3  14         clr   r3
4596               0306 6DD6 0209  20         li    stack,>8400           ; Set stack
4597                    6DD8 8400
4598               0307 6DDA 020F  20         li    r15,vdpw              ; Set VDP write address
4599                    6DDC 8C00
4600               0311               *--------------------------------------------------------------
4601               0312               * Setup video memory
4602               0313               *--------------------------------------------------------------
4603               0315 6DDE 0280  22         ci    r0,>4a4a              ; Crash flag set?
4604                    6DE0 4A4A
4605               0316 6DE2 1605  14         jne   runlia
4606               0317 6DE4 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
4607                    6DE6 226E
4608               0318 6DE8 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
4609                    6DEA 0000
4610                    6DEC 3FFF
4611               0323 6DEE 06A0  32 runlia  bl    @filv
4612                    6DF0 226E
4613               0324 6DF2 0FC0             data  pctadr,spfclr,16      ; Load color table
4614                    6DF4 00F4
4615                    6DF6 0010
4616               0325               *--------------------------------------------------------------
4617               0326               * Check if there is a F18A present
4618               0327               *--------------------------------------------------------------
4619               0331 6DF8 06A0  32         bl    @f18unl               ; Unlock the F18A
4620                    6DFA 26B2
4621               0332 6DFC 06A0  32         bl    @f18chk               ; Check if F18A is there
4622                    6DFE 26CC
4623               0333 6E00 06A0  32         bl    @f18lck               ; Lock the F18A again
4624                    6E02 26C2
4625               0335               *--------------------------------------------------------------
4626               0336               * Check if there is a speech synthesizer attached
4627               0337               *--------------------------------------------------------------
4628               0339               *       <<skipped>>
4629               0343               *--------------------------------------------------------------
4630               0344               * Load video mode table & font
4631               0345               *--------------------------------------------------------------
4632               0346 6E04 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
4633                    6E06 22D8
4634               0347 6E08 21F6             data  spvmod                ; Equate selected video mode table
4635               0348 6E0A 0204  20         li    tmp0,spfont           ; Get font option
4636                    6E0C 000C
4637               0349 6E0E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
4638               0350 6E10 1304  14         jeq   runlid                ; Yes, skip it
4639               0351 6E12 06A0  32         bl    @ldfnt
4640                    6E14 2340
4641               0352 6E16 1100             data  fntadr,spfont         ; Load specified font
4642                    6E18 000C
4643               0353               *--------------------------------------------------------------
4644               0354               * Did a system crash occur before runlib was called?
4645               0355               *--------------------------------------------------------------
4646               0356 6E1A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
4647                    6E1C 4A4A
4648               0357 6E1E 1602  14         jne   runlie                ; No, continue
4649               0358 6E20 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
4650                    6E22 2090
4651               0359               *--------------------------------------------------------------
4652               0360               * Branch to main program
4653               0361               *--------------------------------------------------------------
4654               0362 6E24 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
4655                    6E26 0040
4656               0363 6E28 0460  28         b     @main                 ; Give control to main program
4657                    6E2A 6050
4658               **** **** ****     > tivi_b0.asm.13634
4659               0051
4660               0055 6E2C 2DCA                   data $                ; Bank 0 ROM size OK.
4661               0057
4662               0058
4663               0059               *--------------------------------------------------------------
4664               0060
4665               0061               * Video mode configuration
4666               0062               *--------------------------------------------------------------
4667               0063      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
4668               0064      0004     spfbck  equ   >04                   ; Screen background color.
4669               0065      21F6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
4670               0066      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
4671               0067      0050     colrow  equ   80                    ; Columns per row
4672               0068      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
4673               0069      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
4674               0070      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
4675               0071      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0020               **** **** ****     > equates.asm
0021               0001               ***************************************************************
0022               0002               *                          TiVi Editor
0023               0003               *
0024               0004               *       A 21th century Programming Editor for the 1981
0025               0005               *         Texas Instruments TI-99/4a Home Computer.
0026               0006               *
0027               0007               *              (c)2018-2020 // Filip van Vooren
0028               0008               ***************************************************************
0029               0009               * File: equates.asm                 ; Version 200322-13634
0030               0010               *--------------------------------------------------------------
0031               0011               * TiVi memory layout.
0032               0012               * See file "modules/memory.asm" for further details.
0033               0013               *
0034               0014               * Mem range   Bytes    Hex    Purpose
0035               0015               * =========   =====    ===    ==================================
0036               0016               * 2000-3fff   8192     no     TiVi program code
0037               0017               * 6000-7fff   8192     no     Spectra2 library program code (cartridge space)
0038               0018               * a000-afff   4096     no     Scratchpad/GPL backup, TiVi structures
0039               0019               * b000-bfff   4096     no     Command buffer
0040               0020               * c000-cfff   4096     yes    Main index
0041               0021               * d000-dfff   4096     yes    Shadow SAMS pages index
0042               0022               * e000-efff   4096     yes    Editor buffer 4k
0043               0023               * f000-ffff   4096     yes    Editor buffer 4k
0044               0024               *
0045               0025               * TiVi VDP layout
0046               0026               *
0047               0027               * Mem range   Bytes    Hex    Purpose
0048               0028               * =========   =====   ====    =================================
0049               0029               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0050               0030               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0051               0031               * 0fc0                        PCT - Pattern Color Table
0052               0032               * 1000                        PDT - Pattern Descriptor Table
0053               0033               * 1800                        SPT - Sprite Pattern Table
0054               0034               * 2000                        SAT - Sprite Attribute List
0055               0035               *--------------------------------------------------------------
0056               0036               * Skip unused spectra2 code modules for reduced code size
0057               0037               *--------------------------------------------------------------
0058               0038      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0059               0039      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0060               0040      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0061               0041      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0062               0042      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0063               0043      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0064               0044      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0065               0045      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0066               0046      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0067               0047      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0068               0048      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0069               0049      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0070               0050      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0071               0051      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0072               0052      0001     skip_random_generator     equ  1    ; Skip random functions
0073               0053      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0074               0054               *--------------------------------------------------------------
0075               0055               * SPECTRA2 / TiVi startup options
0076               0056               *--------------------------------------------------------------
0077               0057      0001     debug                     equ  1    ; Turn on spectra2 debugging
0078               0058      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0079               0059      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0080               0060      6030     kickstart.code1           equ  >6030; Uniform aorg entry address accross banks
0081               0061      6050     kickstart.code2           equ  >6050; Uniform aorg entry address start of code
0082               0062      A000     cpu.scrpad.tgt            equ  >a000; Destination cpu.scrpad.backup/restore
0083               0063
0084               0064               *--------------------------------------------------------------
0085               0065               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0086               0066               *--------------------------------------------------------------
0087               0067               ;               equ  >8342          ; >8342-834F **free***
0088               0068      8350     parm1           equ  >8350          ; Function parameter 1
0089               0069      8352     parm2           equ  >8352          ; Function parameter 2
0090               0070      8354     parm3           equ  >8354          ; Function parameter 3
0091               0071      8356     parm4           equ  >8356          ; Function parameter 4
0092               0072      8358     parm5           equ  >8358          ; Function parameter 5
0093               0073      835A     parm6           equ  >835a          ; Function parameter 6
0094               0074      835C     parm7           equ  >835c          ; Function parameter 7
0095               0075      835E     parm8           equ  >835e          ; Function parameter 8
0096               0076      8360     outparm1        equ  >8360          ; Function output parameter 1
0097               0077      8362     outparm2        equ  >8362          ; Function output parameter 2
0098               0078      8364     outparm3        equ  >8364          ; Function output parameter 3
0099               0079      8366     outparm4        equ  >8366          ; Function output parameter 4
0100               0080      8368     outparm5        equ  >8368          ; Function output parameter 5
0101               0081      836A     outparm6        equ  >836a          ; Function output parameter 6
0102               0082      836C     outparm7        equ  >836c          ; Function output parameter 7
0103               0083      836E     outparm8        equ  >836e          ; Function output parameter 8
0104               0084      8370     timers          equ  >8370          ; Timer table
0105               0085      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0106               0086      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0107               0087               *--------------------------------------------------------------
0108               0088               * Scratchpad backup 1               @>a000-a0ff     (256 bytes)
0109               0089               * Scratchpad backup 2               @>a100-a1ff     (256 bytes)
0110               0090               *--------------------------------------------------------------
0111               0091      A000     scrpad.backup1  equ  >a000          ; Backup GPL layout
0112               0092      A100     scrpad.backup2  equ  >a100          ; Backup spectra2 layout
0113               0093               *--------------------------------------------------------------
0114               0094               * TiVi Editor shared structures     @>a200-a27f     (128 bytes)
0115               0095               *--------------------------------------------------------------
0116               0096      A200     tv.top          equ  >a200          ; Structure begin
0117               0097      A200     tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
0118               0098      A202     tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
0119               0099      A204     tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
0120               0100      A206     tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
0121               0101      A208     tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
0122               0102      A20A     tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
0123               0103      A20C     tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
0124               0104      A20E     tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
0125               0105      A210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0126               0106      A212     tv.colorscheme  equ  tv.top + 18    ; Current color scheme (0-4)
0127               0107      A214     tv.curshape     equ  tv.top + 20    ; Cursor shape and color
0128               0108      A216     tv.end          equ  tv.top + 22    ; End of structure
0129               0109               *--------------------------------------------------------------
0130               0110               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0131               0111               *--------------------------------------------------------------
0132               0112      A280     fb.struct       equ  >a280          ; Structure begin
0133               0113      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0134               0114      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0135               0115      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0136               0116                                                   ; line X in editor buffer).
0137               0117      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0138               0118                                                   ; (offset 0 .. @fb.scrrows)
0139               0119      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0140               0120      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0141               0121      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0142               0122      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0143               0123      A290     fb.free1        equ  fb.struct + 16 ; **FREE FOR USE**
0144               0124      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0145               0125      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0146               0126      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0147               0127      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0148               0128      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0149               0129      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0150               0130               *--------------------------------------------------------------
0151               0131               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0152               0132               *--------------------------------------------------------------
0153               0133      A300     edb.struct        equ  >a300           ; Begin structure
0154               0134      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0155               0135      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0156               0136      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0157               0137      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0158               0138      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0159               0139      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0160               0140      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0161               0141      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0162               0142                                                      ; with current filename.
0163               0143      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0164               0144                                                      ; with current file type.
0165               0145      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0166               0146      A314     edb.end           equ  edb.struct + 20 ; End of structure
0167               0147               *--------------------------------------------------------------
0168               0148               * File handling structures          @>a400-a4ff     (256 bytes)
0169               0149               *--------------------------------------------------------------
0170               0150      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0171               0151      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0172               0152      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0173               0153      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0174               0154      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0175               0155      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0176               0156      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0177               0157      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0178               0158      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0179               0159      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0180               0160      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0181               0161      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0182               0162      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0183               0163      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0184               0164      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0185               0165      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0186               0166      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0187               0167      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0188               0168      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0189               0169      A496     fh.end            equ  fh.struct +150  ; End of structure
0190               0170      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0191               0171      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0192               0172               *--------------------------------------------------------------
0193               0173               * Command buffer structure          @>a500-a5ff     (256 bytes)
0194               0174               *--------------------------------------------------------------
0195               0175      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0196               0176      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0197               0177      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0198               0178      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0199               0179      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0200               0180      A508     cmdb.yxtop      equ  cmdb.struct + 8   ; Screen YX of 1st row in cmdb pane
0201               0181      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0202               0182      A50C     cmdb.lines      equ  cmdb.struct + 12  ; Total lines in editor buffer
0203               0183      A50E     cmdb.dirty      equ  cmdb.struct + 14  ; Editor buffer dirty (Text changed!)
0204               0184      A510     cmdb.end        equ  cmdb.struct + 16  ; End of structure
0205               0185               *--------------------------------------------------------------
0206               0186               * Free for future use               @>a600-a64f     (80 bytes)
0207               0187               *--------------------------------------------------------------
0208               0188      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0209               0189               *--------------------------------------------------------------
0210               0190               * Frame buffer                      @>a650-afff    (2480 bytes)
0211               0191               *--------------------------------------------------------------
0212               0192      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0213               0193      09B0     fb.size         equ  2480              ; Frame buffer size
0214               0194               *--------------------------------------------------------------
0215               0195               * Command buffer                    @>b000-bfff    (4096 bytes)
0216               0196               *--------------------------------------------------------------
0217               0197      B000     cmdb.top        equ  >b000             ; Top of command buffer
0218               0198      1000     cmdb.size       equ  4096              ; Command buffer size
0219               0199               *--------------------------------------------------------------
0220               0200               * Index                             @>c000-cfff    (4096 bytes)
0221               0201               *--------------------------------------------------------------
0222               0202      C000     idx.top         equ  >c000             ; Top of index
0223               0203      1000     idx.size        equ  4096              ; Index size
0224               0204               *--------------------------------------------------------------
0225               0205               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0226               0206               *--------------------------------------------------------------
0227               0207      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0228               0208      1000     idx.shadow.size equ  4096              ; Shadow index size
0229               0209               *--------------------------------------------------------------
0230               0210               * Editor buffer                     @>e000-efff    (4096 bytes)
0231               0211               *                                   @>f000-ffff    (4096 bytes)
0232               0212               *--------------------------------------------------------------
0233               0213      E000     edb.top         equ  >e000             ; Editor buffer high memory
0234               0214      2000     edb.size        equ  8192              ; Editor buffer size
0235               0215               *--------------------------------------------------------------
0236               **** **** ****     > tivi_b0.asm.13634
0237               0018                       copy  "kickstart.asm"       ; Cartridge header
0238               **** **** ****     > kickstart.asm
0239               0001               * FILE......: kickstart.asm
0240               0002               * Purpose...: Bankswitch routine for starting TiVi
0241               0003
0242               0004               ***************************************************************
0243               0005               * TiVi Cartridge Header & kickstart ROM bank 0
0244               0006               ***************************************************************
0245               0007               *
0246               0008               *--------------------------------------------------------------
0247               0009               * INPUT
0248               0010               * none
0249               0011               *--------------------------------------------------------------
0250               0012               * OUTPUT
0251               0013               * none
0252               0014               *--------------------------------------------------------------
0253               0015               * Register usage
0254               0016               * r0
0255               0017               ***************************************************************
0256               0018
0257               0019               *--------------------------------------------------------------
0258               0020               * Cartridge header
0259               0021               ********|*****|*********************|**************************
0260               0022 6000 AA01             byte  >aa,1,1,0,0,0
0261                    6002 0100
0262                    6004 0000
0263               0023 6006 6010             data  $+10
0264               0024 6008 0000             byte  0,0,0,0,0,0,0,0
0265                    600A 0000
0266                    600C 0000
0267                    600E 0000
0268               0025 6010 0000             data  0                     ; No more items following
0269               0026 6012 6030             data  kickstart.code1
0270               0027
0271               0029
0272               0030 6014 1154             byte  17
0273               0031 6015 ....             text  'TIVI 200322-13634'
0274               0032                       even
0275               0033
0276               0041
0277               0042               *--------------------------------------------------------------
0278               0043               * Kickstart bank 0
0279               0044               ********|*****|*********************|**************************
0280               0045                       aorg  kickstart.code1
0281               0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0282                    6032 6000
0283               **** **** ****     > tivi_b0.asm.13634
0284               0019               ***************************************************************
0285               0020               * Copy runtime library to destination >2000 - >3fff
0286               0021               ********|*****|*********************|**************************
0287               0022               kickstart.init:
0288               0023 6034 0200  20         li    r0,reloc+2            ; Start of code to relocate
0289                    6036 6062
0290               0024 6038 0201  20         li    r1,>2000
0291                    603A 2000
0292               0025 603C 0202  20         li    r2,512                ; Copy 8K (512 * 4 words)
0293                    603E 0200
0294               0026               kickstart.loop:
0295               0027 6040 CC70  46         mov   *r0+,*r1+
0296               0028 6042 CC70  46         mov   *r0+,*r1+
0297               0029 6044 CC70  46         mov   *r0+,*r1+
0298               0030 6046 CC70  46         mov   *r0+,*r1+
0299               0031 6048 0602  14         dec   r2
0300               0032 604A 16FA  14         jne   kickstart.loop
0301               0033 604C 0460  28         b     @runlib               ; Start spectra2 library
0302                    604E 2D10
0303               0034               ***************************************************************
0304               0035               * TiVi entry point after spectra2 initialisation
0305               0036               ********|*****|*********************|**************************
0306               0037                       aorg  kickstart.code2
0307               0038 6050 04E0  34 main    clr   @>6002                ; Jump to bank 1 (2nd bank)
0308                    6052 6002
0309               0039                                                   ;--------------------------
0310               0040                                                   ; Should not get here
0311               0041                                                   ;--------------------------
0312               0042 6054 0200  20         li    r0,main
0313                    6056 6050
0314               0043 6058 C800  38         mov   r0,@>ffce             ; \ Save caller address
0315                    605A FFCE
0316               0044 605C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
0317                    605E 2030
0318               0045               ***************************************************************
0319               0046               * Spectra2 library
0320               0047               ********|*****|*********************|**************************
0321               0048 6060 1000  14 reloc   nop                         ; Anchor for copy command
0322               0049                       xorg >2000                  ; Relocate all spectra2 code to >2000

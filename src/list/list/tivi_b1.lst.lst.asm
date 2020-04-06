XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.lst.asm.9915
0001               XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
0002               **** **** ****     > tivi_b1.asm.31428
0003               0001               ***************************************************************
0004               0002               *                          TiVi Editor
0005               0003               *
0006               0004               *       A 21th century Programming Editor for the 1981
0007               0005               *         Texas Instruments TI-99/4a Home Computer.
0008               0006               *
0009               0007               *              (c)2018-2020 // Filip van Vooren
0010               0008               ***************************************************************
0011               0009               * File: tivi_b1.asm                 ; Version 200331-31428
0012               0010
0013               0011
0014               0012               ***************************************************************
0015               0013               * BANK 1 - TiVi support modules
0016               0014               ********|*****|*********************|**************************
0017               0015                       aorg  >6000
0018               0016                       save  >6000,>7fff           ; Save bank 1
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
0029               0009               * File: equates.asm                 ; Version 200331-31428
0030               0010               *--------------------------------------------------------------
0031               0011               * TiVi memory layout.
0032               0012               * See file "modules/memory.asm" for further details.
0033               0013               *
0034               0014               * Mem range   Bytes    SAMS   Purpose
0035               0015               * =========   =====    ====   ==================================
0036               0016               * 2000-3fff   8192            Spectra2 library
0037               0017               * 6000-7fff   8192            bank 0: spectra2 library + copy code
0038               0018               *                             bank 1: TiVi program code
0039               0019               * a000-afff   4096            Scratchpad/GPL backup, TiVi structures
0040               0020               * b000-bfff   4096            Command buffer
0041               0021               * c000-cfff   4096     yes    Main index
0042               0022               * d000-dfff   4096     yes    Shadow SAMS pages index
0043               0023               * e000-efff   4096     yes    Editor buffer 4k
0044               0024               * f000-ffff   4096     yes    Editor buffer 4k
0045               0025               *
0046               0026               * TiVi VDP layout
0047               0027               *
0048               0028               * Mem range   Bytes    Hex    Purpose
0049               0029               * =========   =====   ====    =================================
0050               0030               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0051               0031               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0052               0032               * 0fc0                        PCT - Pattern Color Table
0053               0033               * 1000                        PDT - Pattern Descriptor Table
0054               0034               * 1800                        SPT - Sprite Pattern Table
0055               0035               * 2000                        SAT - Sprite Attribute List
0056               0036               *--------------------------------------------------------------
0057               0037               * Skip unused spectra2 code modules for reduced code size
0058               0038               *--------------------------------------------------------------
0059               0039      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0060               0040      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
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
0128               0108      A216     tv.pane.focus   equ  tv.top + 22    ; Identify pane that has focus
0129               0109      A216     tv.end          equ  tv.top + 22    ; End of structure
0130               0110      0000     pane.focus.fb   equ  0              ; Editor pane has focus
0131               0111      0001     pane.focus.cmdb equ  1              ; Command buffer pane has focus
0132               0112               *--------------------------------------------------------------
0133               0113               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0134               0114               *--------------------------------------------------------------
0135               0115      A280     fb.struct       equ  >a280          ; Structure begin
0136               0116      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0137               0117      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0138               0118      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0139               0119                                                   ; line X in editor buffer).
0140               0120      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0141               0121                                                   ; (offset 0 .. @fb.scrrows)
0142               0122      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0143               0123      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0144               0124      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0145               0125      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0146               0126      A290     fb.free         equ  fb.struct + 16 ; **** free ****
0147               0127      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0148               0128      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0149               0129      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0150               0130      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0151               0131      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0152               0132      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0153               0133               *--------------------------------------------------------------
0154               0134               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0155               0135               *--------------------------------------------------------------
0156               0136      A300     edb.struct        equ  >a300           ; Begin structure
0157               0137      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0158               0138      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0159               0139      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0160               0140      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0161               0141      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0162               0142      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0163               0143      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0164               0144      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0165               0145                                                      ; with current filename.
0166               0146      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0167               0147                                                      ; with current file type.
0168               0148      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0169               0149      A314     edb.end           equ  edb.struct + 20 ; End of structure
0170               0150               *--------------------------------------------------------------
0171               0151               * File handling structures          @>a400-a4ff     (256 bytes)
0172               0152               *--------------------------------------------------------------
0173               0153      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0174               0154      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0175               0155      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0176               0156      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0177               0157      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0178               0158      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0179               0159      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0180               0160      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0181               0161      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0182               0162      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0183               0163      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0184               0164      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0185               0165      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0186               0166      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0187               0167      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0188               0168      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0189               0169      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0190               0170      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0191               0171      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0192               0172      A496     fh.end            equ  fh.struct +150  ; End of structure
0193               0173      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0194               0174      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0195               0175               *--------------------------------------------------------------
0196               0176               * Command buffer structure          @>a500-a5ff     (256 bytes)
0197               0177               *--------------------------------------------------------------
0198               0178      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0199               0179      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0200               0180      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0201               0181      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0202               0182      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0203               0183      A508     cmdb.cursor     equ  cmdb.struct + 8   ; Screen YX of cursor in cmdb pane
0204               0184      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0205               0185      A50C     cmdb.yxtop      equ  cmdb.struct + 12  ; YX position of first row in cmdb pane
0206               0186      A50E     cmdb.lines      equ  cmdb.struct + 14  ; Total lines in editor buffer
0207               0187      A510     cmdb.dirty      equ  cmdb.struct + 16  ; Editor buffer dirty (Text changed!)
0208               0188      A512     cmdb.fb.yxsave  equ  cmdb.struct + 18  ; Copy of FB WYX when entering cmdb pane
0209               0189      A514     cmdb.end        equ  cmdb.struct + 20  ; End of structure
0210               0190               *--------------------------------------------------------------
0211               0191               * Free for future use               @>a600-a64f     (80 bytes)
0212               0192               *--------------------------------------------------------------
0213               0193      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0214               0194               *--------------------------------------------------------------
0215               0195               * Frame buffer                      @>a650-afff    (2480 bytes)
0216               0196               *--------------------------------------------------------------
0217               0197      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0218               0198      09B0     fb.size         equ  2480              ; Frame buffer size
0219               0199               *--------------------------------------------------------------
0220               0200               * Command buffer                    @>b000-bfff    (4096 bytes)
0221               0201               *--------------------------------------------------------------
0222               0202      B000     cmdb.top        equ  >b000             ; Top of command buffer
0223               0203      1000     cmdb.size       equ  4096              ; Command buffer size
0224               0204               *--------------------------------------------------------------
0225               0205               * Index                             @>c000-cfff    (4096 bytes)
0226               0206               *--------------------------------------------------------------
0227               0207      C000     idx.top         equ  >c000             ; Top of index
0228               0208      1000     idx.size        equ  4096              ; Index size
0229               0209               *--------------------------------------------------------------
0230               0210               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0231               0211               *--------------------------------------------------------------
0232               0212      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0233               0213      1000     idx.shadow.size equ  4096              ; Shadow index size
0234               0214               *--------------------------------------------------------------
0235               0215               * Editor buffer                     @>e000-efff    (4096 bytes)
0236               0216               *                                   @>f000-ffff    (4096 bytes)
0237               0217               *--------------------------------------------------------------
0238               0218      E000     edb.top         equ  >e000             ; Editor buffer high memory
0239               0219      2000     edb.size        equ  8192              ; Editor buffer size
0240               0220               *--------------------------------------------------------------
0241               0221
0242               0222
0243               **** **** ****     > tivi_b1.asm.31428
0244               0018                       copy  "kickstart.asm"       ; Cartridge header
0245               **** **** ****     > kickstart.asm
0246               0001               * FILE......: kickstart.asm
0247               0002               * Purpose...: Bankswitch routine for starting TiVi
0248               0003
0249               0004               ***************************************************************
0250               0005               * TiVi Cartridge Header & kickstart ROM bank 0
0251               0006               ***************************************************************
0252               0007               *
0253               0008               *--------------------------------------------------------------
0254               0009               * INPUT
0255               0010               * none
0256               0011               *--------------------------------------------------------------
0257               0012               * OUTPUT
0258               0013               * none
0259               0014               *--------------------------------------------------------------
0260               0015               * Register usage
0261               0016               * r0
0262               0017               ***************************************************************
0263               0018
0264               0019               *--------------------------------------------------------------
0265               0020               * Cartridge header
0266               0021               ********|*****|*********************|**************************
0267               0022 6000 AA01             byte  >aa,1,1,0,0,0
0268                    6002 0100
0269                    6004 0000
0270               0023 6006 6010             data  $+10
0271               0024 6008 0000             byte  0,0,0,0,0,0,0,0
0272                    600A 0000
0273                    600C 0000
0274                    600E 0000
0275               0025 6010 0000             data  0                     ; No more items following
0276               0026 6012 6030             data  kickstart.code1
0277               0027
0278               0029
0279               0030 6014 1154             byte  17
0280               0031 6015 ....             text  'TIVI 200331-31428'
0281               0032                       even
0282               0033
0283               0041
0284               0042               *--------------------------------------------------------------
0285               0043               * Kickstart bank 0
0286               0044               ********|*****|*********************|**************************
0287               0045                       aorg  kickstart.code1
0288               0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0289                    6032 6000
0290               **** **** ****     > tivi_b1.asm.31428
0291               0019
0292               0020                       aorg  >2000
0293               0021                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
0294               **** **** ****     > runlib.asm
0295               0001               *******************************************************************************
0296               0002               *              ___  ____  ____  ___  ____  ____    __    ___
0297               0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0298               0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0299               0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0300               0006               *
0301               0007               *                TMS9900 Monitor with Arcade Game support
0302               0008               *                                  for
0303               0009               *              the Texas Instruments TI-99/4A Home Computer
0304               0010               *
0305               0011               *                      2010-2020 by Filip Van Vooren
0306               0012               *
0307               0013               *              https://github.com/FilipVanVooren/spectra2.git
0308               0014               *******************************************************************************
0309               0015               * This file: runlib.a99
0310               0016               *******************************************************************************
0311               0017               * Use following equates to skip/exclude support modules and to control startup
0312               0018               * behaviour.
0313               0019               *
0314               0020               * == Memory
0315               0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0316               0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0317               0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0318               0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0319               0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0320               0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0321               0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0322               0028               *
0323               0029               * == VDP
0324               0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0325               0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0326               0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0327               0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0328               0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0329               0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0330               0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0331               0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0332               0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0333               0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0334               0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0335               0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0336               0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0337               0043               *
0338               0044               * == Sound & speech
0339               0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0340               0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0341               0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0342               0048               *
0343               0049               * ==  Keyboard
0344               0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0345               0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0346               0052               *
0347               0053               * == Utilities
0348               0054               * skip_random_generator     equ  1  ; Skip random generator functions
0349               0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0350               0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0351               0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0352               0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0353               0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0354               0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0355               0061               *
0356               0062               * == Kernel/Multitasking
0357               0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0358               0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0359               0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0360               0066               *
0361               0067               * == Startup behaviour
0362               0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0363               0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0364               0070               *******************************************************************************
0365               0071
0366               0072               *//////////////////////////////////////////////////////////////
0367               0073               *                       RUNLIB SETUP
0368               0074               *//////////////////////////////////////////////////////////////
0369               0075
0370               0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
0371               **** **** ****     > equ_memsetup.asm
0372               0001               * FILE......: memsetup.asm
0373               0002               * Purpose...: Equates for spectra2 memory layout
0374               0003
0375               0004               ***************************************************************
0376               0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0377               0006               ********|*****|*********************|**************************
0378               0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0379               0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0380               0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0381               0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0382               0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0383               0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0384               0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0385               0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0386               0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0387               0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0388               0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0389               0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0390               0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0391               0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0392               0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0393               0022               ***************************************************************
0394               0023      832A     by      equ   wyx                   ;      Cursor Y position
0395               0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0396               0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0397               0026               ***************************************************************
0398               **** **** ****     > runlib.asm
0399               0077                       copy  "equ_registers.asm"        ; Equates runlib registers
0400               **** **** ****     > equ_registers.asm
0401               0001               * FILE......: registers.asm
0402               0002               * Purpose...: Equates for registers
0403               0003
0404               0004               ***************************************************************
0405               0005               * Register usage
0406               0006               * R0      **free not used**
0407               0007               * R1      **free not used**
0408               0008               * R2      Config register
0409               0009               * R3      Extended config register
0410               0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0411               0011               * R9      Stack pointer
0412               0012               * R10     Highest slot in use + Timer counter
0413               0013               * R11     Subroutine return address
0414               0014               * R12     CRU
0415               0015               * R13     Copy of VDP status byte and counter for sound player
0416               0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0417               0017               * R15     VDP read/write address
0418               0018               *--------------------------------------------------------------
0419               0019               * Special purpose registers
0420               0020               * R0      shift count
0421               0021               * R12     CRU
0422               0022               * R13     WS     - when using LWPI, BLWP, RTWP
0423               0023               * R14     PC     - when using LWPI, BLWP, RTWP
0424               0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0425               0025               ***************************************************************
0426               0026               * Define registers
0427               0027               ********|*****|*********************|**************************
0428               0028      0000     r0      equ   0
0429               0029      0001     r1      equ   1
0430               0030      0002     r2      equ   2
0431               0031      0003     r3      equ   3
0432               0032      0004     r4      equ   4
0433               0033      0005     r5      equ   5
0434               0034      0006     r6      equ   6
0435               0035      0007     r7      equ   7
0436               0036      0008     r8      equ   8
0437               0037      0009     r9      equ   9
0438               0038      000A     r10     equ   10
0439               0039      000B     r11     equ   11
0440               0040      000C     r12     equ   12
0441               0041      000D     r13     equ   13
0442               0042      000E     r14     equ   14
0443               0043      000F     r15     equ   15
0444               0044               ***************************************************************
0445               0045               * Define register equates
0446               0046               ********|*****|*********************|**************************
0447               0047      0002     config  equ   r2                    ; Config register
0448               0048      0003     xconfig equ   r3                    ; Extended config register
0449               0049      0004     tmp0    equ   r4                    ; Temp register 0
0450               0050      0005     tmp1    equ   r5                    ; Temp register 1
0451               0051      0006     tmp2    equ   r6                    ; Temp register 2
0452               0052      0007     tmp3    equ   r7                    ; Temp register 3
0453               0053      0008     tmp4    equ   r8                    ; Temp register 4
0454               0054      0009     stack   equ   r9                    ; Stack pointer
0455               0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0456               0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0457               0057               ***************************************************************
0458               0058               * Define MSB/LSB equates for registers
0459               0059               ********|*****|*********************|**************************
0460               0060      8300     r0hb    equ   ws1                   ; HI byte R0
0461               0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0462               0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0463               0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0464               0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0465               0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0466               0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0467               0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0468               0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0469               0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0470               0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0471               0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0472               0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0473               0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0474               0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0475               0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0476               0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0477               0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0478               0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0479               0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0480               0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0481               0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0482               0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0483               0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0484               0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0485               0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0486               0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0487               0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0488               0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0489               0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0490               0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0491               0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0492               0092               ********|*****|*********************|**************************
0493               0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0494               0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0495               0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0496               0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0497               0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0498               0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0499               0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0500               0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0501               0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0502               0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0503               0103               ********|*****|*********************|**************************
0504               0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0505               0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0506               0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0507               0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0508               0108               ***************************************************************
0509               **** **** ****     > runlib.asm
0510               0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
0511               **** **** ****     > equ_portaddr.asm
0512               0001               * FILE......: portaddr.asm
0513               0002               * Purpose...: Equates for hardware port addresses
0514               0003
0515               0004               ***************************************************************
0516               0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0517               0006               ********|*****|*********************|**************************
0518               0007      8400     sound   equ   >8400                 ; Sound generator address
0519               0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0520               0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0521               0010      8802     vdps    equ   >8802                 ; VDP status register
0522               0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0523               0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0524               0013      9802     grmra   equ   >9802                 ; GROM set read address
0525               0014      9800     grmrd   equ   >9800                 ; GROM read byte
0526               0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0527               0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0528               0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
0529               **** **** ****     > runlib.asm
0530               0079                       copy  "equ_param.asm"            ; Equates runlib parameters
0531               **** **** ****     > equ_param.asm
0532               0001               * FILE......: param.asm
0533               0002               * Purpose...: Equates used for subroutine parameters
0534               0003
0535               0004               ***************************************************************
0536               0005               * Subroutine parameter equates
0537               0006               ***************************************************************
0538               0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0539               0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0540               0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0541               0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0542               0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0543               0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0544               0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0545               0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0546               0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0547               0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0548               0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0549               0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0550               0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0551               0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0552               0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0553               0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0554               0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0555               0024               *--------------------------------------------------------------
0556               0025               *   Speech player
0557               0026               *--------------------------------------------------------------
0558               0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0559               0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0560               0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0561               0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
0562               **** **** ****     > runlib.asm
0563               0080
0564               0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
0565               **** **** ****     > rom_bankswitch.asm
0566               0001               * FILE......: rom_bankswitch.asm
0567               0002               * Purpose...: ROM bankswitching Support module
0568               0003
0569               0004               *//////////////////////////////////////////////////////////////
0570               0005               *                   BANKSWITCHING FUNCTIONS
0571               0006               *//////////////////////////////////////////////////////////////
0572               0007
0573               0008               ***************************************************************
0574               0009               * SWBNK - Switch ROM bank
0575               0010               ***************************************************************
0576               0011               *  BL   @SWBNK
0577               0012               *  DATA P0,P1
0578               0013               *--------------------------------------------------------------
0579               0014               *  P0 = Bank selection address (>600X)
0580               0015               *  P1 = Vector address
0581               0016               *--------------------------------------------------------------
0582               0017               *  B    @SWBNKX
0583               0018               *
0584               0019               *  TMP0 = Bank selection address (>600X)
0585               0020               *  TMP1 = Vector address
0586               0021               *--------------------------------------------------------------
0587               0022               *  Important! The bank-switch routine must be at the exact
0588               0023               *  same location accross banks
0589               0024               ********|*****|*********************|**************************
0590               0025 2000 C13B  30 swbnk   mov   *r11+,tmp0
0591               0026 2002 C17B  30         mov   *r11+,tmp1
0592               0027 2004 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0593               0028 2006 C155  26         mov   *tmp1,tmp1
0594               0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
0595               **** **** ****     > runlib.asm
0596               0084
0597               0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
0598               **** **** ****     > cpu_constants.asm
0599               0001               * FILE......: cpu_constants.asm
0600               0002               * Purpose...: Constants used by Spectra2 and for own use
0601               0003
0602               0004               ***************************************************************
0603               0005               *                      Some constants
0604               0006               ********|*****|*********************|**************************
0605               0007
0606               0008               ---------------------------------------------------------------
0607               0009               * Word values
0608               0010               *--------------------------------------------------------------
0609               0011               ;                                   ;       0123456789ABCDEF
0610               0012 200A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0611               0013 200C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0612               0014 200E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0613               0015 2010 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0614               0016 2012 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0615               0017 2014 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0616               0018 2016 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0617               0019 2018 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0618               0020 201A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0619               0021 201C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0620               0022 201E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0621               0023 2020 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0622               0024 2022 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0623               0025 2024 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0624               0026 2026 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0625               0027 2028 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0626               0028 202A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0627               0029 202C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0628               0030 202E D000     w$d000  data  >d000                 ; >d000
0629               0031               *--------------------------------------------------------------
0630               0032               * Byte values - High byte (=MSB) for byte operations
0631               0033               *--------------------------------------------------------------
0632               0034      200A     hb$00   equ   w$0000                ; >0000
0633               0035      201C     hb$01   equ   w$0100                ; >0100
0634               0036      201E     hb$02   equ   w$0200                ; >0200
0635               0037      2020     hb$04   equ   w$0400                ; >0400
0636               0038      2022     hb$08   equ   w$0800                ; >0800
0637               0039      2024     hb$10   equ   w$1000                ; >1000
0638               0040      2026     hb$20   equ   w$2000                ; >2000
0639               0041      2028     hb$40   equ   w$4000                ; >4000
0640               0042      202A     hb$80   equ   w$8000                ; >8000
0641               0043      202E     hb$d0   equ   w$d000                ; >d000
0642               0044               *--------------------------------------------------------------
0643               0045               * Byte values - Low byte (=LSB) for byte operations
0644               0046               *--------------------------------------------------------------
0645               0047      200A     lb$00   equ   w$0000                ; >0000
0646               0048      200C     lb$01   equ   w$0001                ; >0001
0647               0049      200E     lb$02   equ   w$0002                ; >0002
0648               0050      2010     lb$04   equ   w$0004                ; >0004
0649               0051      2012     lb$08   equ   w$0008                ; >0008
0650               0052      2014     lb$10   equ   w$0010                ; >0010
0651               0053      2016     lb$20   equ   w$0020                ; >0020
0652               0054      2018     lb$40   equ   w$0040                ; >0040
0653               0055      201A     lb$80   equ   w$0080                ; >0080
0654               0056               *--------------------------------------------------------------
0655               0057               * Bit values
0656               0058               *--------------------------------------------------------------
0657               0059               ;                                   ;       0123456789ABCDEF
0658               0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0659               0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0660               0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0661               0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0662               0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0663               0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0664               0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0665               0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0666               0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0667               0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0668               0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0669               0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0670               0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0671               0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0672               0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0673               0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
0674               **** **** ****     > runlib.asm
0675               0086                       copy  "equ_config.asm"           ; Equates for bits in config register
0676               **** **** ****     > equ_config.asm
0677               0001               * FILE......: equ_config.asm
0678               0002               * Purpose...: Equates for bits in config register
0679               0003
0680               0004               ***************************************************************
0681               0005               * The config register equates
0682               0006               *--------------------------------------------------------------
0683               0007               * Configuration flags
0684               0008               * ===================
0685               0009               *
0686               0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0687               0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0688               0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0689               0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0690               0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0691               0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0692               0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0693               0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0694               0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0695               0019               * ; 06  Timer: Block user hook          1=yes          0=no
0696               0020               * ; 05  Speech synthesizer present      1=yes          0=no
0697               0021               * ; 04  Speech player: busy             1=yes          0=no
0698               0022               * ; 03  Speech player: enabled          1=yes          0=no
0699               0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0700               0024               * ; 01  F18A present                    1=on           0=off
0701               0025               * ; 00  Subroutine state flag           1=on           0=off
0702               0026               ********|*****|*********************|**************************
0703               0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0704               0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0705               0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0706               0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0707               0031               ***************************************************************
0708               0032
0709               **** **** ****     > runlib.asm
0710               0087                       copy  "cpu_crash.asm"            ; CPU crash handler
0711               **** **** ****     > cpu_crash.asm
0712               0001               * FILE......: cpu_crash.asm
0713               0002               * Purpose...: Custom crash handler module
0714               0003
0715               0004
0716               0005               ***************************************************************
0717               0006               * cpu.crash - CPU program crashed handler
0718               0007               ***************************************************************
0719               0008               *  bl   @cpu.crash
0720               0009               *--------------------------------------------------------------
0721               0010               * Crash and halt system. Upon crash entry register contents are
0722               0011               * copied to the memory region >ffe0 - >fffe and displayed after
0723               0012               * resetting the spectra2 runtime library, video modes, etc.
0724               0013               *
0725               0014               * Diagnostics
0726               0015               * >ffce  caller address
0727               0016               *
0728               0017               * Register contents
0729               0018               * >ffdc  wp
0730               0019               * >ffde  st
0731               0020               * >ffe0  r0
0732               0021               * >ffe2  r1
0733               0022               * >ffe4  r2  (config)
0734               0023               * >ffe6  r3
0735               0024               * >ffe8  r4  (tmp0)
0736               0025               * >ffea  r5  (tmp1)
0737               0026               * >ffec  r6  (tmp2)
0738               0027               * >ffee  r7  (tmp3)
0739               0028               * >fff0  r8  (tmp4)
0740               0029               * >fff2  r9  (stack)
0741               0030               * >fff4  r10
0742               0031               * >fff6  r11
0743               0032               * >fff8  r12
0744               0033               * >fffa  r13
0745               0034               * >fffc  r14
0746               0035               * >fffe  r15
0747               0036               ********|*****|*********************|**************************
0748               0037               cpu.crash:
0749               0038 2030 022B  22         ai    r11,-4                ; Remove opcode offset
0750                    2032 FFFC
0751               0039               *--------------------------------------------------------------
0752               0040               *    Save registers to high memory
0753               0041               *--------------------------------------------------------------
0754               0042 2034 C800  38         mov   r0,@>ffe0
0755                    2036 FFE0
0756               0043 2038 C801  38         mov   r1,@>ffe2
0757                    203A FFE2
0758               0044 203C C802  38         mov   r2,@>ffe4
0759                    203E FFE4
0760               0045 2040 C803  38         mov   r3,@>ffe6
0761                    2042 FFE6
0762               0046 2044 C804  38         mov   r4,@>ffe8
0763                    2046 FFE8
0764               0047 2048 C805  38         mov   r5,@>ffea
0765                    204A FFEA
0766               0048 204C C806  38         mov   r6,@>ffec
0767                    204E FFEC
0768               0049 2050 C807  38         mov   r7,@>ffee
0769                    2052 FFEE
0770               0050 2054 C808  38         mov   r8,@>fff0
0771                    2056 FFF0
0772               0051 2058 C809  38         mov   r9,@>fff2
0773                    205A FFF2
0774               0052 205C C80A  38         mov   r10,@>fff4
0775                    205E FFF4
0776               0053 2060 C80B  38         mov   r11,@>fff6
0777                    2062 FFF6
0778               0054 2064 C80C  38         mov   r12,@>fff8
0779                    2066 FFF8
0780               0055 2068 C80D  38         mov   r13,@>fffa
0781                    206A FFFA
0782               0056 206C C80E  38         mov   r14,@>fffc
0783                    206E FFFC
0784               0057 2070 C80F  38         mov   r15,@>ffff
0785                    2072 FFFF
0786               0058 2074 02A0  12         stwp  r0
0787               0059 2076 C800  38         mov   r0,@>ffdc
0788                    2078 FFDC
0789               0060 207A 02C0  12         stst  r0
0790               0061 207C C800  38         mov   r0,@>ffde
0791                    207E FFDE
0792               0062               *--------------------------------------------------------------
0793               0063               *    Reset system
0794               0064               *--------------------------------------------------------------
0795               0065               cpu.crash.reset:
0796               0066 2080 02E0  18         lwpi  ws1                   ; Activate workspace 1
0797                    2082 8300
0798               0067 2084 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
0799                    2086 8302
0800               0068 2088 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
0801                    208A 4A4A
0802               0069 208C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
0803                    208E 2D68
0804               0070               *--------------------------------------------------------------
0805               0071               *    Show diagnostics after system reset
0806               0072               *--------------------------------------------------------------
0807               0073               cpu.crash.main:
0808               0074                       ;------------------------------------------------------
0809               0075                       ; Show crash details
0810               0076                       ;------------------------------------------------------
0811               0077 2090 06A0  32         bl    @putat                ; Show crash message
0812                    2092 2410
0813               0078 2094 0000                   data >0000,cpu.crash.msg.crashed
0814                    2096 216A
0815               0079
0816               0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
0817                    209A 2996
0818               0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0819               0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0820               0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0821               0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0822               0085                                                   ; /         LSB offset for ASCII digit 0-9
0823               0086                       ;------------------------------------------------------
0824               0087                       ; Show caller details
0825               0088                       ;------------------------------------------------------
0826               0089 20A4 06A0  32         bl    @putat                ; Show caller message
0827                    20A6 2410
0828               0090 20A8 0100                   data >0100,cpu.crash.msg.caller
0829                    20AA 2180
0830               0091
0831               0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
0832                    20AE 2996
0833               0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0834               0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0835               0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0836               0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0837               0097                                                   ; /         LSB offset for ASCII digit 0-9
0838               0098                       ;------------------------------------------------------
0839               0099                       ; Display labels
0840               0100                       ;------------------------------------------------------
0841               0101 20B8 06A0  32         bl    @putat
0842                    20BA 2410
0843               0102 20BC 0300                   byte 3,0
0844               0103 20BE 219A                   data cpu.crash.msg.wp
0845               0104 20C0 06A0  32         bl    @putat
0846                    20C2 2410
0847               0105 20C4 0400                   byte 4,0
0848               0106 20C6 21A0                   data cpu.crash.msg.st
0849               0107 20C8 06A0  32         bl    @putat
0850                    20CA 2410
0851               0108 20CC 1600                   byte 22,0
0852               0109 20CE 21A6                   data cpu.crash.msg.source
0853               0110 20D0 06A0  32         bl    @putat
0854                    20D2 2410
0855               0111 20D4 1700                   byte 23,0
0856               0112 20D6 21C0                   data cpu.crash.msg.id
0857               0113                       ;------------------------------------------------------
0858               0114                       ; Show crash registers WP, ST, R0 - R15
0859               0115                       ;------------------------------------------------------
0860               0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
0861                    20DA 264E
0862               0117 20DC 0304                   byte 3,4              ; \ i p0 = YX position
0863               0118                                                   ; /
0864               0119
0865               0120 20DE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
0866                    20E0 FFDC
0867               0121 20E2 04C6  14         clr   tmp2                  ; Loop counter
0868               0122
0869               0123               cpu.crash.showreg:
0870               0124 20E4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0871               0125
0872               0126 20E6 0649  14         dect  stack
0873               0127 20E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0874               0128 20EA 0649  14         dect  stack
0875               0129 20EC C645  30         mov   tmp1,*stack           ; Push tmp1
0876               0130 20EE 0649  14         dect  stack
0877               0131 20F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0878               0132                       ;------------------------------------------------------
0879               0133                       ; Display crash register number
0880               0134                       ;------------------------------------------------------
0881               0135               cpu.crash.showreg.label:
0882               0136 20F2 C046  18         mov   tmp2,r1               ; Save register number
0883               0137 20F4 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
0884                    20F6 0001
0885               0138 20F8 121C  14         jle   cpu.crash.showreg.content
0886               0139                                                   ; Yes, skip
0887               0140
0888               0141 20FA 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0889               0142 20FC 06A0  32         bl    @mknum
0890                    20FE 29A0
0891               0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0892               0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0893               0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0894               0146                                                   ; /         LSB offset for ASCII digit 0-9
0895               0147
0896               0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
0897                    2108 2664
0898               0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0899               0150                                                   ; /
0900               0151
0901               0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
0902                    210E 23FE
0903               0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0904               0154                                                   ; /
0905               0155
0906               0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
0907                    2114 2664
0908               0157 2116 0002                   data 2                ; \ i  p0 =  Cursor Y position
0909               0158                                                   ; /
0910               0159
0911               0160 2118 0281  22         ci    r1,10
0912                    211A 000A
0913               0161 211C 1102  14         jlt   !
0914               0162 211E 0620  34         dec   @wyx                  ; x=x-1
0915                    2120 832A
0916               0163
0917               0164 2122 06A0  32 !       bl    @putstr
0918                    2124 23FE
0919               0165 2126 2196                   data cpu.crash.msg.r
0920               0166
0921               0167 2128 06A0  32         bl    @mknum
0922                    212A 29A0
0923               0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0924               0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0925               0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0926               0171                                                   ; /         LSB offset for ASCII digit 0-9
0927               0172                       ;------------------------------------------------------
0928               0173                       ; Display crash register content
0929               0174                       ;------------------------------------------------------
0930               0175               cpu.crash.showreg.content:
0931               0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
0932                    2134 2912
0933               0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0934               0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0935               0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0936               0180                                                   ; /         LSB offset for ASCII digit 0-9
0937               0181
0938               0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
0939                    213E 2664
0940               0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0941               0184                                                   ; /
0942               0185
0943               0186 2142 06A0  32         bl    @putstr
0944                    2144 23FE
0945               0187 2146 2198                   data cpu.crash.msg.marker
0946               0188
0947               0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
0948                    214A 2664
0949               0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0950               0191                                                   ; /
0951               0192
0952               0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
0953                    2150 23FE
0954               0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0955               0195                                                   ; /
0956               0196
0957               0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0958               0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0959               0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0960               0200
0961               0201 215A 06A0  32         bl    @down                 ; y=y+1
0962                    215C 2654
0963               0202
0964               0203 215E 0586  14         inc   tmp2
0965               0204 2160 0286  22         ci    tmp2,17
0966                    2162 0011
0967               0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0968               0206                       ;------------------------------------------------------
0969               0207                       ; Kernel takes over
0970               0208                       ;------------------------------------------------------
0971               0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
0972                    2168 2C76
0973               0210
0974               0211
0975               0212               cpu.crash.msg.crashed
0976               0213 216A 1553             byte  21
0977               0214 216B ....             text  'System crashed near >'
0978               0215                       even
0979               0216
0980               0217               cpu.crash.msg.caller
0981               0218 2180 1543             byte  21
0982               0219 2181 ....             text  'Caller address near >'
0983               0220                       even
0984               0221
0985               0222               cpu.crash.msg.r
0986               0223 2196 0152             byte  1
0987               0224 2197 ....             text  'R'
0988               0225                       even
0989               0226
0990               0227               cpu.crash.msg.marker
0991               0228 2198 013E             byte  1
0992               0229 2199 ....             text  '>'
0993               0230                       even
0994               0231
0995               0232               cpu.crash.msg.wp
0996               0233 219A 042A             byte  4
0997               0234 219B ....             text  '**WP'
0998               0235                       even
0999               0236
1000               0237               cpu.crash.msg.st
1001               0238 21A0 042A             byte  4
1002               0239 21A1 ....             text  '**ST'
1003               0240                       even
1004               0241
1005               0242               cpu.crash.msg.source
1006               0243 21A6 1953             byte  25
1007               0244 21A7 ....             text  'Source    tivi_b1.lst.asm'
1008               0245                       even
1009               0246
1010               0247               cpu.crash.msg.id
1011               0248 21C0 1642             byte  22
1012               0249 21C1 ....             text  'Build-ID  200331-31428'
1013               0250                       even
1014               0251
1015               **** **** ****     > runlib.asm
1016               0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
1017               **** **** ****     > vdp_tables.asm
1018               0001               * FILE......: vdp_tables.a99
1019               0002               * Purpose...: Video mode tables
1020               0003
1021               0004               ***************************************************************
1022               0005               * Graphics mode 1 (32 columns/24 rows)
1023               0006               *--------------------------------------------------------------
1024               0007 21D8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
1025                    21DA 000E
1026                    21DC 0106
1027                    21DE 0204
1028                    21E0 0020
1029               0008               *
1030               0009               * ; VDP#0 Control bits
1031               0010               * ;      bit 6=0: M3 | Graphics 1 mode
1032               0011               * ;      bit 7=0: Disable external VDP input
1033               0012               * ; VDP#1 Control bits
1034               0013               * ;      bit 0=1: 16K selection
1035               0014               * ;      bit 1=1: Enable display
1036               0015               * ;      bit 2=1: Enable VDP interrupt
1037               0016               * ;      bit 3=0: M1 \ Graphics 1 mode
1038               0017               * ;      bit 4=0: M2 /
1039               0018               * ;      bit 5=0: reserved
1040               0019               * ;      bit 6=1: 16x16 sprites
1041               0020               * ;      bit 7=0: Sprite magnification (1x)
1042               0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1043               0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1044               0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1045               0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1046               0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
1047               0026               * ; VDP#7 Set screen background color
1048               0027
1049               0028
1050               0029               ***************************************************************
1051               0030               * Textmode (40 columns/24 rows)
1052               0031               *--------------------------------------------------------------
1053               0032 21E2 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
1054                    21E4 000E
1055                    21E6 0106
1056                    21E8 00F4
1057                    21EA 0028
1058               0033               *
1059               0034               * ; VDP#0 Control bits
1060               0035               * ;      bit 6=0: M3 | Graphics 1 mode
1061               0036               * ;      bit 7=0: Disable external VDP input
1062               0037               * ; VDP#1 Control bits
1063               0038               * ;      bit 0=1: 16K selection
1064               0039               * ;      bit 1=1: Enable display
1065               0040               * ;      bit 2=1: Enable VDP interrupt
1066               0041               * ;      bit 3=1: M1 \ TEXT MODE
1067               0042               * ;      bit 4=0: M2 /
1068               0043               * ;      bit 5=0: reserved
1069               0044               * ;      bit 6=1: 16x16 sprites
1070               0045               * ;      bit 7=0: Sprite magnification (1x)
1071               0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1072               0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
1073               0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
1074               0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
1075               0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
1076               0051               * ; VDP#7 Set foreground/background color
1077               0052               ***************************************************************
1078               0053
1079               0054
1080               0055               ***************************************************************
1081               0056               * Textmode (80 columns, 24 rows) - F18A
1082               0057               *--------------------------------------------------------------
1083               0058 21EC 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1084                    21EE 003F
1085                    21F0 0240
1086                    21F2 03F4
1087                    21F4 0050
1088               0059               *
1089               0060               * ; VDP#0 Control bits
1090               0061               * ;      bit 6=0: M3 | Graphics 1 mode
1091               0062               * ;      bit 7=0: Disable external VDP input
1092               0063               * ; VDP#1 Control bits
1093               0064               * ;      bit 0=1: 16K selection
1094               0065               * ;      bit 1=1: Enable display
1095               0066               * ;      bit 2=1: Enable VDP interrupt
1096               0067               * ;      bit 3=1: M1 \ TEXT MODE
1097               0068               * ;      bit 4=0: M2 /
1098               0069               * ;      bit 5=0: reserved
1099               0070               * ;      bit 6=0: 8x8 sprites
1100               0071               * ;      bit 7=0: Sprite magnification (1x)
1101               0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
1102               0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1103               0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1104               0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1105               0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1106               0077               * ; VDP#7 Set foreground/background color
1107               0078               ***************************************************************
1108               0079
1109               0080
1110               0081               ***************************************************************
1111               0082               * Textmode (80 columns, 30 rows) - F18A
1112               0083               *--------------------------------------------------------------
1113               0084 21F6 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
1114                    21F8 003F
1115                    21FA 0240
1116                    21FC 03F4
1117                    21FE 0050
1118               0085               *
1119               0086               * ; VDP#0 Control bits
1120               0087               * ;      bit 6=0: M3 | Graphics 1 mode
1121               0088               * ;      bit 7=0: Disable external VDP input
1122               0089               * ; VDP#1 Control bits
1123               0090               * ;      bit 0=1: 16K selection
1124               0091               * ;      bit 1=1: Enable display
1125               0092               * ;      bit 2=1: Enable VDP interrupt
1126               0093               * ;      bit 3=1: M1 \ TEXT MODE
1127               0094               * ;      bit 4=0: M2 /
1128               0095               * ;      bit 5=0: reserved
1129               0096               * ;      bit 6=0: 8x8 sprites
1130               0097               * ;      bit 7=0: Sprite magnification (1x)
1131               0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
1132               0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
1133               0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
1134               0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
1135               0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
1136               0103               * ; VDP#7 Set foreground/background color
1137               0104               ***************************************************************
1138               **** **** ****     > runlib.asm
1139               0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
1140               **** **** ****     > basic_cpu_vdp.asm
1141               0001               * FILE......: basic_cpu_vdp.asm
1142               0002               * Purpose...: Basic CPU & VDP functions used by other modules
1143               0003
1144               0004               *//////////////////////////////////////////////////////////////
1145               0005               *       Support Machine Code for copy & fill functions
1146               0006               *//////////////////////////////////////////////////////////////
1147               0007
1148               0008               *--------------------------------------------------------------
1149               0009               * ; Machine code for tight loop.
1150               0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
1151               0011               *--------------------------------------------------------------
1152               0012               *       DATA  >????                 ; \ mcloop  mov   ...
1153               0013 2200 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
1154               0014 2202 16FD             data  >16fd                 ; |         jne   mcloop
1155               0015 2204 045B             data  >045b                 ; /         b     *r11
1156               0016               *--------------------------------------------------------------
1157               0017               * ; Machine code for reading from the speech synthesizer
1158               0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
1159               0019               * ; Is required for the 12 uS delay. It destroys R5.
1160               0020               *--------------------------------------------------------------
1161               0021 2206 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
1162               0022 2208 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
1163               0023                       even
1164               0024
1165               0025
1166               0026               *//////////////////////////////////////////////////////////////
1167               0027               *                    STACK SUPPORT FUNCTIONS
1168               0028               *//////////////////////////////////////////////////////////////
1169               0029
1170               0030               ***************************************************************
1171               0031               * POPR. - Pop registers & return to caller
1172               0032               ***************************************************************
1173               0033               *  B  @POPRG.
1174               0034               *--------------------------------------------------------------
1175               0035               *  REMARKS
1176               0036               *  R11 must be at stack bottom
1177               0037               ********|*****|*********************|**************************
1178               0038 220A C0F9  30 popr3   mov   *stack+,r3
1179               0039 220C C0B9  30 popr2   mov   *stack+,r2
1180               0040 220E C079  30 popr1   mov   *stack+,r1
1181               0041 2210 C039  30 popr0   mov   *stack+,r0
1182               0042 2212 C2F9  30 poprt   mov   *stack+,r11
1183               0043 2214 045B  20         b     *r11
1184               0044
1185               0045
1186               0046
1187               0047               *//////////////////////////////////////////////////////////////
1188               0048               *                   MEMORY FILL FUNCTIONS
1189               0049               *//////////////////////////////////////////////////////////////
1190               0050
1191               0051               ***************************************************************
1192               0052               * FILM - Fill CPU memory with byte
1193               0053               ***************************************************************
1194               0054               *  bl   @film
1195               0055               *  data P0,P1,P2
1196               0056               *--------------------------------------------------------------
1197               0057               *  P0 = Memory start address
1198               0058               *  P1 = Byte to fill
1199               0059               *  P2 = Number of bytes to fill
1200               0060               *--------------------------------------------------------------
1201               0061               *  bl   @xfilm
1202               0062               *
1203               0063               *  TMP0 = Memory start address
1204               0064               *  TMP1 = Byte to fill
1205               0065               *  TMP2 = Number of bytes to fill
1206               0066               ********|*****|*********************|**************************
1207               0067 2216 C13B  30 film    mov   *r11+,tmp0            ; Memory start
1208               0068 2218 C17B  30         mov   *r11+,tmp1            ; Byte to fill
1209               0069 221A C1BB  30         mov   *r11+,tmp2            ; Repeat count
1210               0070               *--------------------------------------------------------------
1211               0071               * Do some checks first
1212               0072               *--------------------------------------------------------------
1213               0073 221C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
1214               0074 221E 1604  14         jne   filchk                ; No, continue checking
1215               0075
1216               0076 2220 C80B  38         mov   r11,@>ffce            ; \ Save caller address
1217                    2222 FFCE
1218               0077 2224 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1219                    2226 2030
1220               0078               *--------------------------------------------------------------
1221               0079               *       Check: 1 byte fill
1222               0080               *--------------------------------------------------------------
1223               0081 2228 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
1224                    222A 830B
1225                    222C 830A
1226               0082
1227               0083 222E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
1228                    2230 0001
1229               0084 2232 1602  14         jne   filchk2
1230               0085 2234 DD05  32         movb  tmp1,*tmp0+
1231               0086 2236 045B  20         b     *r11                  ; Exit
1232               0087               *--------------------------------------------------------------
1233               0088               *       Check: 2 byte fill
1234               0089               *--------------------------------------------------------------
1235               0090 2238 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
1236                    223A 0002
1237               0091 223C 1603  14         jne   filchk3
1238               0092 223E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
1239               0093 2240 DD05  32         movb  tmp1,*tmp0+
1240               0094 2242 045B  20         b     *r11                  ; Exit
1241               0095               *--------------------------------------------------------------
1242               0096               *       Check: Handle uneven start address
1243               0097               *--------------------------------------------------------------
1244               0098 2244 C1C4  18 filchk3 mov   tmp0,tmp3
1245               0099 2246 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1246                    2248 0001
1247               0100 224A 1605  14         jne   fil16b
1248               0101 224C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
1249               0102 224E 0606  14         dec   tmp2
1250               0103 2250 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
1251                    2252 0002
1252               0104 2254 13F1  14         jeq   filchk2               ; Yes, copy word and exit
1253               0105               *--------------------------------------------------------------
1254               0106               *       Fill memory with 16 bit words
1255               0107               *--------------------------------------------------------------
1256               0108 2256 C1C6  18 fil16b  mov   tmp2,tmp3
1257               0109 2258 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1258                    225A 0001
1259               0110 225C 1301  14         jeq   dofill
1260               0111 225E 0606  14         dec   tmp2                  ; Make TMP2 even
1261               0112 2260 CD05  34 dofill  mov   tmp1,*tmp0+
1262               0113 2262 0646  14         dect  tmp2
1263               0114 2264 16FD  14         jne   dofill
1264               0115               *--------------------------------------------------------------
1265               0116               * Fill last byte if ODD
1266               0117               *--------------------------------------------------------------
1267               0118 2266 C1C7  18         mov   tmp3,tmp3
1268               0119 2268 1301  14         jeq   fil.$$
1269               0120 226A DD05  32         movb  tmp1,*tmp0+
1270               0121 226C 045B  20 fil.$$  b     *r11
1271               0122
1272               0123
1273               0124               ***************************************************************
1274               0125               * FILV - Fill VRAM with byte
1275               0126               ***************************************************************
1276               0127               *  BL   @FILV
1277               0128               *  DATA P0,P1,P2
1278               0129               *--------------------------------------------------------------
1279               0130               *  P0 = VDP start address
1280               0131               *  P1 = Byte to fill
1281               0132               *  P2 = Number of bytes to fill
1282               0133               *--------------------------------------------------------------
1283               0134               *  BL   @XFILV
1284               0135               *
1285               0136               *  TMP0 = VDP start address
1286               0137               *  TMP1 = Byte to fill
1287               0138               *  TMP2 = Number of bytes to fill
1288               0139               ********|*****|*********************|**************************
1289               0140 226E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
1290               0141 2270 C17B  30         mov   *r11+,tmp1            ; Byte to fill
1291               0142 2272 C1BB  30         mov   *r11+,tmp2            ; Repeat count
1292               0143               *--------------------------------------------------------------
1293               0144               *    Setup VDP write address
1294               0145               *--------------------------------------------------------------
1295               0146 2274 0264  22 xfilv   ori   tmp0,>4000
1296                    2276 4000
1297               0147 2278 06C4  14         swpb  tmp0
1298               0148 227A D804  38         movb  tmp0,@vdpa
1299                    227C 8C02
1300               0149 227E 06C4  14         swpb  tmp0
1301               0150 2280 D804  38         movb  tmp0,@vdpa
1302                    2282 8C02
1303               0151               *--------------------------------------------------------------
1304               0152               *    Fill bytes in VDP memory
1305               0153               *--------------------------------------------------------------
1306               0154 2284 020F  20         li    r15,vdpw              ; Set VDP write address
1307                    2286 8C00
1308               0155 2288 06C5  14         swpb  tmp1
1309               0156 228A C820  54         mov   @filzz,@mcloop        ; Setup move command
1310                    228C 2294
1311                    228E 8320
1312               0157 2290 0460  28         b     @mcloop               ; Write data to VDP
1313                    2292 8320
1314               0158               *--------------------------------------------------------------
1315               0162 2294 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
1316               0164
1317               0165
1318               0166
1319               0167               *//////////////////////////////////////////////////////////////
1320               0168               *                  VDP LOW LEVEL FUNCTIONS
1321               0169               *//////////////////////////////////////////////////////////////
1322               0170
1323               0171               ***************************************************************
1324               0172               * VDWA / VDRA - Setup VDP write or read address
1325               0173               ***************************************************************
1326               0174               *  BL   @VDWA
1327               0175               *
1328               0176               *  TMP0 = VDP destination address for write
1329               0177               *--------------------------------------------------------------
1330               0178               *  BL   @VDRA
1331               0179               *
1332               0180               *  TMP0 = VDP source address for read
1333               0181               ********|*****|*********************|**************************
1334               0182 2296 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
1335                    2298 4000
1336               0183 229A 06C4  14 vdra    swpb  tmp0
1337               0184 229C D804  38         movb  tmp0,@vdpa
1338                    229E 8C02
1339               0185 22A0 06C4  14         swpb  tmp0
1340               0186 22A2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
1341                    22A4 8C02
1342               0187 22A6 045B  20         b     *r11                  ; Exit
1343               0188
1344               0189               ***************************************************************
1345               0190               * VPUTB - VDP put single byte
1346               0191               ***************************************************************
1347               0192               *  BL @VPUTB
1348               0193               *  DATA P0,P1
1349               0194               *--------------------------------------------------------------
1350               0195               *  P0 = VDP target address
1351               0196               *  P1 = Byte to write
1352               0197               ********|*****|*********************|**************************
1353               0198 22A8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
1354               0199 22AA C17B  30         mov   *r11+,tmp1            ; Get byte to write
1355               0200               *--------------------------------------------------------------
1356               0201               * Set VDP write address
1357               0202               *--------------------------------------------------------------
1358               0203 22AC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
1359                    22AE 4000
1360               0204 22B0 06C4  14         swpb  tmp0                  ; \
1361               0205 22B2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
1362                    22B4 8C02
1363               0206 22B6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
1364               0207 22B8 D804  38         movb  tmp0,@vdpa            ; /
1365                    22BA 8C02
1366               0208               *--------------------------------------------------------------
1367               0209               * Write byte
1368               0210               *--------------------------------------------------------------
1369               0211 22BC 06C5  14         swpb  tmp1                  ; LSB to MSB
1370               0212 22BE D7C5  30         movb  tmp1,*r15             ; Write byte
1371               0213 22C0 045B  20         b     *r11                  ; Exit
1372               0214
1373               0215
1374               0216               ***************************************************************
1375               0217               * VGETB - VDP get single byte
1376               0218               ***************************************************************
1377               0219               *  bl   @vgetb
1378               0220               *  data p0
1379               0221               *--------------------------------------------------------------
1380               0222               *  P0 = VDP source address
1381               0223               *--------------------------------------------------------------
1382               0224               *  bl   @xvgetb
1383               0225               *
1384               0226               *  tmp0 = VDP source address
1385               0227               *--------------------------------------------------------------
1386               0228               *  Output:
1387               0229               *  tmp0 MSB = >00
1388               0230               *  tmp0 LSB = VDP byte read
1389               0231               ********|*****|*********************|**************************
1390               0232 22C2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
1391               0233               *--------------------------------------------------------------
1392               0234               * Set VDP read address
1393               0235               *--------------------------------------------------------------
1394               0236 22C4 06C4  14 xvgetb  swpb  tmp0                  ; \
1395               0237 22C6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
1396                    22C8 8C02
1397               0238 22CA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
1398               0239 22CC D804  38         movb  tmp0,@vdpa            ; /
1399                    22CE 8C02
1400               0240               *--------------------------------------------------------------
1401               0241               * Read byte
1402               0242               *--------------------------------------------------------------
1403               0243 22D0 D120  34         movb  @vdpr,tmp0            ; Read byte
1404                    22D2 8800
1405               0244 22D4 0984  56         srl   tmp0,8                ; Right align
1406               0245 22D6 045B  20         b     *r11                  ; Exit
1407               0246
1408               0247
1409               0248               ***************************************************************
1410               0249               * VIDTAB - Dump videomode table
1411               0250               ***************************************************************
1412               0251               *  BL   @VIDTAB
1413               0252               *  DATA P0
1414               0253               *--------------------------------------------------------------
1415               0254               *  P0 = Address of video mode table
1416               0255               *--------------------------------------------------------------
1417               0256               *  BL   @XIDTAB
1418               0257               *
1419               0258               *  TMP0 = Address of video mode table
1420               0259               *--------------------------------------------------------------
1421               0260               *  Remarks
1422               0261               *  TMP1 = MSB is the VDP target register
1423               0262               *         LSB is the value to write
1424               0263               ********|*****|*********************|**************************
1425               0264 22D8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
1426               0265 22DA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
1427               0266               *--------------------------------------------------------------
1428               0267               * Calculate PNT base address
1429               0268               *--------------------------------------------------------------
1430               0269 22DC C144  18         mov   tmp0,tmp1
1431               0270 22DE 05C5  14         inct  tmp1
1432               0271 22E0 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
1433               0272 22E2 0245  22         andi  tmp1,>ff00            ; Only keep MSB
1434                    22E4 FF00
1435               0273 22E6 0A25  56         sla   tmp1,2                ; TMP1 *= 400
1436               0274 22E8 C805  38         mov   tmp1,@wbase           ; Store calculated base
1437                    22EA 8328
1438               0275               *--------------------------------------------------------------
1439               0276               * Dump VDP shadow registers
1440               0277               *--------------------------------------------------------------
1441               0278 22EC 0205  20         li    tmp1,>8000            ; Start with VDP register 0
1442                    22EE 8000
1443               0279 22F0 0206  20         li    tmp2,8
1444                    22F2 0008
1445               0280 22F4 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
1446                    22F6 830B
1447               0281 22F8 06C5  14         swpb  tmp1
1448               0282 22FA D805  38         movb  tmp1,@vdpa
1449                    22FC 8C02
1450               0283 22FE 06C5  14         swpb  tmp1
1451               0284 2300 D805  38         movb  tmp1,@vdpa
1452                    2302 8C02
1453               0285 2304 0225  22         ai    tmp1,>0100
1454                    2306 0100
1455               0286 2308 0606  14         dec   tmp2
1456               0287 230A 16F4  14         jne   vidta1                ; Next register
1457               0288 230C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
1458                    230E 833A
1459               0289 2310 045B  20         b     *r11
1460               0290
1461               0291
1462               0292               ***************************************************************
1463               0293               * PUTVR  - Put single VDP register
1464               0294               ***************************************************************
1465               0295               *  BL   @PUTVR
1466               0296               *  DATA P0
1467               0297               *--------------------------------------------------------------
1468               0298               *  P0 = MSB is the VDP target register
1469               0299               *       LSB is the value to write
1470               0300               *--------------------------------------------------------------
1471               0301               *  BL   @PUTVRX
1472               0302               *
1473               0303               *  TMP0 = MSB is the VDP target register
1474               0304               *         LSB is the value to write
1475               0305               ********|*****|*********************|**************************
1476               0306 2312 C13B  30 putvr   mov   *r11+,tmp0
1477               0307 2314 0264  22 putvrx  ori   tmp0,>8000
1478                    2316 8000
1479               0308 2318 06C4  14         swpb  tmp0
1480               0309 231A D804  38         movb  tmp0,@vdpa
1481                    231C 8C02
1482               0310 231E 06C4  14         swpb  tmp0
1483               0311 2320 D804  38         movb  tmp0,@vdpa
1484                    2322 8C02
1485               0312 2324 045B  20         b     *r11
1486               0313
1487               0314
1488               0315               ***************************************************************
1489               0316               * PUTV01  - Put VDP registers #0 and #1
1490               0317               ***************************************************************
1491               0318               *  BL   @PUTV01
1492               0319               ********|*****|*********************|**************************
1493               0320 2326 C20B  18 putv01  mov   r11,tmp4              ; Save R11
1494               0321 2328 C10E  18         mov   r14,tmp0
1495               0322 232A 0984  56         srl   tmp0,8
1496               0323 232C 06A0  32         bl    @putvrx               ; Write VR#0
1497                    232E 2314
1498               0324 2330 0204  20         li    tmp0,>0100
1499                    2332 0100
1500               0325 2334 D820  54         movb  @r14lb,@tmp0lb
1501                    2336 831D
1502                    2338 8309
1503               0326 233A 06A0  32         bl    @putvrx               ; Write VR#1
1504                    233C 2314
1505               0327 233E 0458  20         b     *tmp4                 ; Exit
1506               0328
1507               0329
1508               0330               ***************************************************************
1509               0331               * LDFNT - Load TI-99/4A font from GROM into VDP
1510               0332               ***************************************************************
1511               0333               *  BL   @LDFNT
1512               0334               *  DATA P0,P1
1513               0335               *--------------------------------------------------------------
1514               0336               *  P0 = VDP Target address
1515               0337               *  P1 = Font options
1516               0338               *--------------------------------------------------------------
1517               0339               * Uses registers tmp0-tmp4
1518               0340               ********|*****|*********************|**************************
1519               0341 2340 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
1520               0342 2342 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
1521               0343 2344 C11B  26         mov   *r11,tmp0             ; Get P0
1522               0344 2346 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1523                    2348 7FFF
1524               0345 234A 2120  38         coc   @wbit0,tmp0
1525                    234C 202A
1526               0346 234E 1604  14         jne   ldfnt1
1527               0347 2350 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
1528                    2352 8000
1529               0348 2354 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
1530                    2356 7FFF
1531               0349               *--------------------------------------------------------------
1532               0350               * Read font table address from GROM into tmp1
1533               0351               *--------------------------------------------------------------
1534               0352 2358 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
1535                    235A 23C2
1536               0353 235C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
1537                    235E 9C02
1538               0354 2360 06C4  14         swpb  tmp0
1539               0355 2362 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
1540                    2364 9C02
1541               0356 2366 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
1542                    2368 9800
1543               0357 236A 06C5  14         swpb  tmp1
1544               0358 236C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
1545                    236E 9800
1546               0359 2370 06C5  14         swpb  tmp1
1547               0360               *--------------------------------------------------------------
1548               0361               * Setup GROM source address from tmp1
1549               0362               *--------------------------------------------------------------
1550               0363 2372 D805  38         movb  tmp1,@grmwa
1551                    2374 9C02
1552               0364 2376 06C5  14         swpb  tmp1
1553               0365 2378 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
1554                    237A 9C02
1555               0366               *--------------------------------------------------------------
1556               0367               * Setup VDP target address
1557               0368               *--------------------------------------------------------------
1558               0369 237C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
1559               0370 237E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
1560                    2380 2296
1561               0371 2382 05C8  14         inct  tmp4                  ; R11=R11+2
1562               0372 2384 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
1563               0373 2386 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
1564                    2388 7FFF
1565               0374 238A C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
1566                    238C 23C4
1567               0375 238E C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
1568                    2390 23C6
1569               0376               *--------------------------------------------------------------
1570               0377               * Copy from GROM to VRAM
1571               0378               *--------------------------------------------------------------
1572               0379 2392 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
1573               0380 2394 1812  14         joc   ldfnt4                ; Yes, go insert a >00
1574               0381 2396 D120  34         movb  @grmrd,tmp0
1575                    2398 9800
1576               0382               *--------------------------------------------------------------
1577               0383               *   Make font fat
1578               0384               *--------------------------------------------------------------
1579               0385 239A 20A0  38         coc   @wbit0,config         ; Fat flag set ?
1580                    239C 202A
1581               0386 239E 1603  14         jne   ldfnt3                ; No, so skip
1582               0387 23A0 D1C4  18         movb  tmp0,tmp3
1583               0388 23A2 0917  56         srl   tmp3,1
1584               0389 23A4 E107  18         soc   tmp3,tmp0
1585               0390               *--------------------------------------------------------------
1586               0391               *   Dump byte to VDP and do housekeeping
1587               0392               *--------------------------------------------------------------
1588               0393 23A6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
1589                    23A8 8C00
1590               0394 23AA 0606  14         dec   tmp2
1591               0395 23AC 16F2  14         jne   ldfnt2
1592               0396 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
1593               0397 23B0 020F  20         li    r15,vdpw              ; Set VDP write address
1594                    23B2 8C00
1595               0398 23B4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
1596                    23B6 7FFF
1597               0399 23B8 0458  20         b     *tmp4                 ; Exit
1598               0400 23BA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
1599                    23BC 200A
1600                    23BE 8C00
1601               0401 23C0 10E8  14         jmp   ldfnt2
1602               0402               *--------------------------------------------------------------
1603               0403               * Fonts pointer table
1604               0404               *--------------------------------------------------------------
1605               0405 23C2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
1606                    23C4 0200
1607                    23C6 0000
1608               0406 23C8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
1609                    23CA 01C0
1610                    23CC 0101
1611               0407 23CE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
1612                    23D0 02A0
1613                    23D2 0101
1614               0408 23D4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
1615                    23D6 00E0
1616                    23D8 0101
1617               0409
1618               0410
1619               0411
1620               0412               ***************************************************************
1621               0413               * YX2PNT - Get VDP PNT address for current YX cursor position
1622               0414               ***************************************************************
1623               0415               *  BL   @YX2PNT
1624               0416               *--------------------------------------------------------------
1625               0417               *  INPUT
1626               0418               *  @WYX = Cursor YX position
1627               0419               *--------------------------------------------------------------
1628               0420               *  OUTPUT
1629               0421               *  TMP0 = VDP address for entry in Pattern Name Table
1630               0422               *--------------------------------------------------------------
1631               0423               *  Register usage
1632               0424               *  TMP0, R14, R15
1633               0425               ********|*****|*********************|**************************
1634               0426 23DA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
1635               0427 23DC C3A0  34         mov   @wyx,r14              ; Get YX
1636                    23DE 832A
1637               0428 23E0 098E  56         srl   r14,8                 ; Right justify (remove X)
1638               0429 23E2 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
1639                    23E4 833A
1640               0430               *--------------------------------------------------------------
1641               0431               * Do rest of calculation with R15 (16 bit part is there)
1642               0432               * Re-use R14
1643               0433               *--------------------------------------------------------------
1644               0434 23E6 C3A0  34         mov   @wyx,r14              ; Get YX
1645                    23E8 832A
1646               0435 23EA 024E  22         andi  r14,>00ff             ; Remove Y
1647                    23EC 00FF
1648               0436 23EE A3CE  18         a     r14,r15               ; pos = pos + X
1649               0437 23F0 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
1650                    23F2 8328
1651               0438               *--------------------------------------------------------------
1652               0439               * Clean up before exit
1653               0440               *--------------------------------------------------------------
1654               0441 23F4 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
1655               0442 23F6 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
1656               0443 23F8 020F  20         li    r15,vdpw              ; VDP write address
1657                    23FA 8C00
1658               0444 23FC 045B  20         b     *r11
1659               0445
1660               0446
1661               0447
1662               0448               ***************************************************************
1663               0449               * Put length-byte prefixed string at current YX
1664               0450               ***************************************************************
1665               0451               *  BL   @PUTSTR
1666               0452               *  DATA P0
1667               0453               *
1668               0454               *  P0 = Pointer to string
1669               0455               *--------------------------------------------------------------
1670               0456               *  REMARKS
1671               0457               *  First byte of string must contain length
1672               0458               ********|*****|*********************|**************************
1673               0459 23FE C17B  30 putstr  mov   *r11+,tmp1
1674               0460 2400 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
1675               0461 2402 C1CB  18 xutstr  mov   r11,tmp3
1676               0462 2404 06A0  32         bl    @yx2pnt               ; Get VDP destination address
1677                    2406 23DA
1678               0463 2408 C2C7  18         mov   tmp3,r11
1679               0464 240A 0986  56         srl   tmp2,8                ; Right justify length byte
1680               0465 240C 0460  28         b     @xpym2v               ; Display string
1681                    240E 241E
1682               0466
1683               0467
1684               0468               ***************************************************************
1685               0469               * Put length-byte prefixed string at YX
1686               0470               ***************************************************************
1687               0471               *  BL   @PUTAT
1688               0472               *  DATA P0,P1
1689               0473               *
1690               0474               *  P0 = YX position
1691               0475               *  P1 = Pointer to string
1692               0476               *--------------------------------------------------------------
1693               0477               *  REMARKS
1694               0478               *  First byte of string must contain length
1695               0479               ********|*****|*********************|**************************
1696               0480 2410 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
1697                    2412 832A
1698               0481 2414 0460  28         b     @putstr
1699                    2416 23FE
1700               **** **** ****     > runlib.asm
1701               0090
1702               0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
1703               **** **** ****     > copy_cpu_vram.asm
1704               0001               * FILE......: copy_cpu_vram.asm
1705               0002               * Purpose...: CPU memory to VRAM copy support module
1706               0003
1707               0004               ***************************************************************
1708               0005               * CPYM2V - Copy CPU memory to VRAM
1709               0006               ***************************************************************
1710               0007               *  BL   @CPYM2V
1711               0008               *  DATA P0,P1,P2
1712               0009               *--------------------------------------------------------------
1713               0010               *  P0 = VDP start address
1714               0011               *  P1 = RAM/ROM start address
1715               0012               *  P2 = Number of bytes to copy
1716               0013               *--------------------------------------------------------------
1717               0014               *  BL @XPYM2V
1718               0015               *
1719               0016               *  TMP0 = VDP start address
1720               0017               *  TMP1 = RAM/ROM start address
1721               0018               *  TMP2 = Number of bytes to copy
1722               0019               ********|*****|*********************|**************************
1723               0020 2418 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
1724               0021 241A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
1725               0022 241C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1726               0023               *--------------------------------------------------------------
1727               0024               *    Setup VDP write address
1728               0025               *--------------------------------------------------------------
1729               0026 241E 0264  22 xpym2v  ori   tmp0,>4000
1730                    2420 4000
1731               0027 2422 06C4  14         swpb  tmp0
1732               0028 2424 D804  38         movb  tmp0,@vdpa
1733                    2426 8C02
1734               0029 2428 06C4  14         swpb  tmp0
1735               0030 242A D804  38         movb  tmp0,@vdpa
1736                    242C 8C02
1737               0031               *--------------------------------------------------------------
1738               0032               *    Copy bytes from CPU memory to VRAM
1739               0033               *--------------------------------------------------------------
1740               0034 242E 020F  20         li    r15,vdpw              ; Set VDP write address
1741                    2430 8C00
1742               0035 2432 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
1743                    2434 243C
1744                    2436 8320
1745               0036 2438 0460  28         b     @mcloop               ; Write data to VDP
1746                    243A 8320
1747               0037 243C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
1748               **** **** ****     > runlib.asm
1749               0094
1750               0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
1751               **** **** ****     > copy_vram_cpu.asm
1752               0001               * FILE......: copy_vram_cpu.asm
1753               0002               * Purpose...: VRAM to CPU memory copy support module
1754               0003
1755               0004               ***************************************************************
1756               0005               * CPYV2M - Copy VRAM to CPU memory
1757               0006               ***************************************************************
1758               0007               *  BL   @CPYV2M
1759               0008               *  DATA P0,P1,P2
1760               0009               *--------------------------------------------------------------
1761               0010               *  P0 = VDP source address
1762               0011               *  P1 = RAM target address
1763               0012               *  P2 = Number of bytes to copy
1764               0013               *--------------------------------------------------------------
1765               0014               *  BL @XPYV2M
1766               0015               *
1767               0016               *  TMP0 = VDP source address
1768               0017               *  TMP1 = RAM target address
1769               0018               *  TMP2 = Number of bytes to copy
1770               0019               ********|*****|*********************|**************************
1771               0020 243E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
1772               0021 2440 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
1773               0022 2442 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
1774               0023               *--------------------------------------------------------------
1775               0024               *    Setup VDP read address
1776               0025               *--------------------------------------------------------------
1777               0026 2444 06C4  14 xpyv2m  swpb  tmp0
1778               0027 2446 D804  38         movb  tmp0,@vdpa
1779                    2448 8C02
1780               0028 244A 06C4  14         swpb  tmp0
1781               0029 244C D804  38         movb  tmp0,@vdpa
1782                    244E 8C02
1783               0030               *--------------------------------------------------------------
1784               0031               *    Copy bytes from VDP memory to RAM
1785               0032               *--------------------------------------------------------------
1786               0033 2450 020F  20         li    r15,vdpr              ; Set VDP read address
1787                    2452 8800
1788               0034 2454 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
1789                    2456 245E
1790                    2458 8320
1791               0035 245A 0460  28         b     @mcloop               ; Read data from VDP
1792                    245C 8320
1793               0036 245E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
1794               **** **** ****     > runlib.asm
1795               0098
1796               0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
1797               **** **** ****     > copy_cpu_cpu.asm
1798               0001               * FILE......: copy_cpu_cpu.asm
1799               0002               * Purpose...: CPU to CPU memory copy support module
1800               0003
1801               0004               *//////////////////////////////////////////////////////////////
1802               0005               *                       CPU COPY FUNCTIONS
1803               0006               *//////////////////////////////////////////////////////////////
1804               0007
1805               0008               ***************************************************************
1806               0009               * CPYM2M - Copy CPU memory to CPU memory
1807               0010               ***************************************************************
1808               0011               *  BL   @CPYM2M
1809               0012               *  DATA P0,P1,P2
1810               0013               *--------------------------------------------------------------
1811               0014               *  P0 = Memory source address
1812               0015               *  P1 = Memory target address
1813               0016               *  P2 = Number of bytes to copy
1814               0017               *--------------------------------------------------------------
1815               0018               *  BL @XPYM2M
1816               0019               *
1817               0020               *  TMP0 = Memory source address
1818               0021               *  TMP1 = Memory target address
1819               0022               *  TMP2 = Number of bytes to copy
1820               0023               ********|*****|*********************|**************************
1821               0024 2460 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
1822               0025 2462 C17B  30         mov   *r11+,tmp1            ; Memory target address
1823               0026 2464 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
1824               0027               *--------------------------------------------------------------
1825               0028               * Do some checks first
1826               0029               *--------------------------------------------------------------
1827               0030 2466 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
1828               0031 2468 1604  14         jne   cpychk                ; No, continue checking
1829               0032
1830               0033 246A C80B  38         mov   r11,@>ffce            ; \ Save caller address
1831                    246C FFCE
1832               0034 246E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
1833                    2470 2030
1834               0035               *--------------------------------------------------------------
1835               0036               *    Check: 1 byte copy
1836               0037               *--------------------------------------------------------------
1837               0038 2472 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
1838                    2474 0001
1839               0039 2476 1603  14         jne   cpym0                 ; No, continue checking
1840               0040 2478 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
1841               0041 247A 04C6  14         clr   tmp2                  ; Reset counter
1842               0042 247C 045B  20         b     *r11                  ; Return to caller
1843               0043               *--------------------------------------------------------------
1844               0044               *    Check: Uneven address handling
1845               0045               *--------------------------------------------------------------
1846               0046 247E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
1847                    2480 7FFF
1848               0047 2482 C1C4  18         mov   tmp0,tmp3
1849               0048 2484 0247  22         andi  tmp3,1
1850                    2486 0001
1851               0049 2488 1618  14         jne   cpyodd                ; Odd source address handling
1852               0050 248A C1C5  18 cpym1   mov   tmp1,tmp3
1853               0051 248C 0247  22         andi  tmp3,1
1854                    248E 0001
1855               0052 2490 1614  14         jne   cpyodd                ; Odd target address handling
1856               0053               *--------------------------------------------------------------
1857               0054               * 8 bit copy
1858               0055               *--------------------------------------------------------------
1859               0056 2492 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
1860                    2494 202A
1861               0057 2496 1605  14         jne   cpym3
1862               0058 2498 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
1863                    249A 24C0
1864                    249C 8320
1865               0059 249E 0460  28         b     @mcloop               ; Copy memory and exit
1866                    24A0 8320
1867               0060               *--------------------------------------------------------------
1868               0061               * 16 bit copy
1869               0062               *--------------------------------------------------------------
1870               0063 24A2 C1C6  18 cpym3   mov   tmp2,tmp3
1871               0064 24A4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
1872                    24A6 0001
1873               0065 24A8 1301  14         jeq   cpym4
1874               0066 24AA 0606  14         dec   tmp2                  ; Make TMP2 even
1875               0067 24AC CD74  46 cpym4   mov   *tmp0+,*tmp1+
1876               0068 24AE 0646  14         dect  tmp2
1877               0069 24B0 16FD  14         jne   cpym4
1878               0070               *--------------------------------------------------------------
1879               0071               * Copy last byte if ODD
1880               0072               *--------------------------------------------------------------
1881               0073 24B2 C1C7  18         mov   tmp3,tmp3
1882               0074 24B4 1301  14         jeq   cpymz
1883               0075 24B6 D554  38         movb  *tmp0,*tmp1
1884               0076 24B8 045B  20 cpymz   b     *r11                  ; Return to caller
1885               0077               *--------------------------------------------------------------
1886               0078               * Handle odd source/target address
1887               0079               *--------------------------------------------------------------
1888               0080 24BA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
1889                    24BC 8000
1890               0081 24BE 10E9  14         jmp   cpym2
1891               0082 24C0 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
1892               **** **** ****     > runlib.asm
1893               0102
1894               0106
1895               0110
1896               0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
1897               **** **** ****     > cpu_sams_support.asm
1898               0001               * FILE......: cpu_sams_support.asm
1899               0002               * Purpose...: Low level support for SAMS memory expansion card
1900               0003
1901               0004               *//////////////////////////////////////////////////////////////
1902               0005               *                SAMS Memory Expansion support
1903               0006               *//////////////////////////////////////////////////////////////
1904               0007
1905               0008               *--------------------------------------------------------------
1906               0009               * ACCESS and MAPPING
1907               0010               * (by the late Bruce Harisson):
1908               0011               *
1909               0012               * To use other than the default setup, you have to do two
1910               0013               * things:
1911               0014               *
1912               0015               * 1. You have to "turn on" the card's memory in the
1913               0016               *    >4000 block and write to the mapping registers there.
1914               0017               *    (bl  @sams.page.set)
1915               0018               *
1916               0019               * 2. You have to "turn on" the mapper function to make what
1917               0020               *    you've written into the >4000 block take effect.
1918               0021               *    (bl  @sams.mapping.on)
1919               0022               *--------------------------------------------------------------
1920               0023               *  SAMS                          Default SAMS page
1921               0024               *  Register     Memory bank      (system startup)
1922               0025               *  =======      ===========      ================
1923               0026               *  >4004        >2000-2fff          >002
1924               0027               *  >4006        >3000-4fff          >003
1925               0028               *  >4014        >a000-afff          >00a
1926               0029               *  >4016        >b000-bfff          >00b
1927               0030               *  >4018        >c000-cfff          >00c
1928               0031               *  >401a        >d000-dfff          >00d
1929               0032               *  >401c        >e000-efff          >00e
1930               0033               *  >401e        >f000-ffff          >00f
1931               0034               *  Others       Inactive
1932               0035               *--------------------------------------------------------------
1933               0036
1934               0037
1935               0038
1936               0039
1937               0040               ***************************************************************
1938               0041               * sams.page.get - Get SAMS page number for memory address
1939               0042               ***************************************************************
1940               0043               * bl   @sams.page.get
1941               0044               *      data P0
1942               0045               *--------------------------------------------------------------
1943               0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
1944               0047               *      register >4014 (bank >a000 - >afff)
1945               0048               *--------------------------------------------------------------
1946               0049               * bl   @xsams.page.get
1947               0050               *
1948               0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
1949               0052               *        register >4014 (bank >a000 - >afff)
1950               0053               *--------------------------------------------------------------
1951               0054               * OUTPUT
1952               0055               * waux1 = SAMS page number
1953               0056               * waux2 = Address of affected SAMS register
1954               0057               *--------------------------------------------------------------
1955               0058               * Register usage
1956               0059               * r0, tmp0, r12
1957               0060               ********|*****|*********************|**************************
1958               0061               sams.page.get:
1959               0062 24C2 C13B  30         mov   *r11+,tmp0            ; Memory address
1960               0063               xsams.page.get:
1961               0064 24C4 0649  14         dect  stack
1962               0065 24C6 C64B  30         mov   r11,*stack            ; Push return address
1963               0066 24C8 0649  14         dect  stack
1964               0067 24CA C640  30         mov   r0,*stack             ; Push r0
1965               0068 24CC 0649  14         dect  stack
1966               0069 24CE C64C  30         mov   r12,*stack            ; Push r12
1967               0070               *--------------------------------------------------------------
1968               0071               * Determine memory bank
1969               0072               *--------------------------------------------------------------
1970               0073 24D0 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
1971               0074 24D2 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
1972               0075
1973               0076 24D4 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
1974                    24D6 4000
1975               0077 24D8 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
1976                    24DA 833E
1977               0078               *--------------------------------------------------------------
1978               0079               * Switch memory bank to specified SAMS page
1979               0080               *--------------------------------------------------------------
1980               0081 24DC 020C  20         li    r12,>1e00             ; SAMS CRU address
1981                    24DE 1E00
1982               0082 24E0 04C0  14         clr   r0
1983               0083 24E2 1D00  20         sbo   0                     ; Enable access to SAMS registers
1984               0084 24E4 D014  26         movb  *tmp0,r0              ; Get SAMS page number
1985               0085 24E6 D100  18         movb  r0,tmp0
1986               0086 24E8 0984  56         srl   tmp0,8                ; Right align
1987               0087 24EA C804  38         mov   tmp0,@waux1           ; Save SAMS page number
1988                    24EC 833C
1989               0088 24EE 1E00  20         sbz   0                     ; Disable access to SAMS registers
1990               0089               *--------------------------------------------------------------
1991               0090               * Exit
1992               0091               *--------------------------------------------------------------
1993               0092               sams.page.get.exit:
1994               0093 24F0 C339  30         mov   *stack+,r12           ; Pop r12
1995               0094 24F2 C039  30         mov   *stack+,r0            ; Pop r0
1996               0095 24F4 C2F9  30         mov   *stack+,r11           ; Pop return address
1997               0096 24F6 045B  20         b     *r11                  ; Return to caller
1998               0097
1999               0098
2000               0099
2001               0100
2002               0101               ***************************************************************
2003               0102               * sams.page.set - Set SAMS memory page
2004               0103               ***************************************************************
2005               0104               * bl   sams.page.set
2006               0105               *      data P0,P1
2007               0106               *--------------------------------------------------------------
2008               0107               * P0 = SAMS page number
2009               0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
2010               0109               *      register >4014 (bank >a000 - >afff)
2011               0110               *--------------------------------------------------------------
2012               0111               * bl   @xsams.page.set
2013               0112               *
2014               0113               * tmp0 = SAMS page number
2015               0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
2016               0115               *        register >4014 (bank >a000 - >afff)
2017               0116               *--------------------------------------------------------------
2018               0117               * Register usage
2019               0118               * r0, tmp0, tmp1, r12
2020               0119               *--------------------------------------------------------------
2021               0120               * SAMS page number should be in range 0-255 (>00 to >ff)
2022               0121               *
2023               0122               *  Page         Memory
2024               0123               *  ====         ======
2025               0124               *  >00             32K
2026               0125               *  >1f            128K
2027               0126               *  >3f            256K
2028               0127               *  >7f            512K
2029               0128               *  >ff           1024K
2030               0129               ********|*****|*********************|**************************
2031               0130               sams.page.set:
2032               0131 24F8 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
2033               0132 24FA C17B  30         mov   *r11+,tmp1            ; Get memory address
2034               0133               xsams.page.set:
2035               0134 24FC 0649  14         dect  stack
2036               0135 24FE C64B  30         mov   r11,*stack            ; Push return address
2037               0136 2500 0649  14         dect  stack
2038               0137 2502 C640  30         mov   r0,*stack             ; Push r0
2039               0138 2504 0649  14         dect  stack
2040               0139 2506 C64C  30         mov   r12,*stack            ; Push r12
2041               0140 2508 0649  14         dect  stack
2042               0141 250A C644  30         mov   tmp0,*stack           ; Push tmp0
2043               0142 250C 0649  14         dect  stack
2044               0143 250E C645  30         mov   tmp1,*stack           ; Push tmp1
2045               0144               *--------------------------------------------------------------
2046               0145               * Determine memory bank
2047               0146               *--------------------------------------------------------------
2048               0147 2510 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
2049               0148 2512 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
2050               0149               *--------------------------------------------------------------
2051               0150               * Sanity check on SAMS register
2052               0151               *--------------------------------------------------------------
2053               0152 2514 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
2054                    2516 001E
2055               0153 2518 150A  14         jgt   !
2056               0154 251A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
2057                    251C 0004
2058               0155 251E 1107  14         jlt   !
2059               0156 2520 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
2060                    2522 0012
2061               0157 2524 1508  14         jgt   sams.page.set.switch_page
2062               0158 2526 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
2063                    2528 0006
2064               0159 252A 1501  14         jgt   !
2065               0160 252C 1004  14         jmp   sams.page.set.switch_page
2066               0161                       ;------------------------------------------------------
2067               0162                       ; Crash the system
2068               0163                       ;------------------------------------------------------
2069               0164 252E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
2070                    2530 FFCE
2071               0165 2532 06A0  32         bl    @cpu.crash            ; / Crash and halt system
2072                    2534 2030
2073               0166               *--------------------------------------------------------------
2074               0167               * Switch memory bank to specified SAMS page
2075               0168               *--------------------------------------------------------------
2076               0169               sams.page.set.switch_page
2077               0170 2536 020C  20         li    r12,>1e00             ; SAMS CRU address
2078                    2538 1E00
2079               0171 253A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
2080               0172 253C 06C0  14         swpb  r0                    ; LSB to MSB
2081               0173 253E 1D00  20         sbo   0                     ; Enable access to SAMS registers
2082               0174 2540 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
2083                    2542 4000
2084               0175 2544 1E00  20         sbz   0                     ; Disable access to SAMS registers
2085               0176               *--------------------------------------------------------------
2086               0177               * Exit
2087               0178               *--------------------------------------------------------------
2088               0179               sams.page.set.exit:
2089               0180 2546 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2090               0181 2548 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2091               0182 254A C339  30         mov   *stack+,r12           ; Pop r12
2092               0183 254C C039  30         mov   *stack+,r0            ; Pop r0
2093               0184 254E C2F9  30         mov   *stack+,r11           ; Pop return address
2094               0185 2550 045B  20         b     *r11                  ; Return to caller
2095               0186
2096               0187
2097               0188
2098               0189
2099               0190               ***************************************************************
2100               0191               * sams.mapping.on - Enable SAMS mapping mode
2101               0192               ***************************************************************
2102               0193               *  bl   @sams.mapping.on
2103               0194               *--------------------------------------------------------------
2104               0195               *  Register usage
2105               0196               *  r12
2106               0197               ********|*****|*********************|**************************
2107               0198               sams.mapping.on:
2108               0199 2552 020C  20         li    r12,>1e00             ; SAMS CRU address
2109                    2554 1E00
2110               0200 2556 1D01  20         sbo   1                     ; Enable SAMS mapper
2111               0201               *--------------------------------------------------------------
2112               0202               * Exit
2113               0203               *--------------------------------------------------------------
2114               0204               sams.mapping.on.exit:
2115               0205 2558 045B  20         b     *r11                  ; Return to caller
2116               0206
2117               0207
2118               0208
2119               0209
2120               0210               ***************************************************************
2121               0211               * sams.mapping.off - Disable SAMS mapping mode
2122               0212               ***************************************************************
2123               0213               * bl  @sams.mapping.off
2124               0214               *--------------------------------------------------------------
2125               0215               * OUTPUT
2126               0216               * none
2127               0217               *--------------------------------------------------------------
2128               0218               * Register usage
2129               0219               * r12
2130               0220               ********|*****|*********************|**************************
2131               0221               sams.mapping.off:
2132               0222 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
2133                    255C 1E00
2134               0223 255E 1E01  20         sbz   1                     ; Disable SAMS mapper
2135               0224               *--------------------------------------------------------------
2136               0225               * Exit
2137               0226               *--------------------------------------------------------------
2138               0227               sams.mapping.off.exit:
2139               0228 2560 045B  20         b     *r11                  ; Return to caller
2140               0229
2141               0230
2142               0231
2143               0232
2144               0233
2145               0234               ***************************************************************
2146               0235               * sams.layout
2147               0236               * Setup SAMS memory banks
2148               0237               ***************************************************************
2149               0238               * bl  @sams.layout
2150               0239               *     data P0
2151               0240               *--------------------------------------------------------------
2152               0241               * INPUT
2153               0242               * P0 = Pointer to SAMS page layout table (16 words).
2154               0243               *--------------------------------------------------------------
2155               0244               * bl  @xsams.layout
2156               0245               *
2157               0246               * tmp0 = Pointer to SAMS page layout table (16 words).
2158               0247               *--------------------------------------------------------------
2159               0248               * OUTPUT
2160               0249               * none
2161               0250               *--------------------------------------------------------------
2162               0251               * Register usage
2163               0252               * tmp0, tmp1, tmp2, tmp3
2164               0253               ********|*****|*********************|**************************
2165               0254               sams.layout:
2166               0255 2562 C1FB  30         mov   *r11+,tmp3            ; Get P0
2167               0256               xsams.layout:
2168               0257 2564 0649  14         dect  stack
2169               0258 2566 C64B  30         mov   r11,*stack            ; Save return address
2170               0259 2568 0649  14         dect  stack
2171               0260 256A C644  30         mov   tmp0,*stack           ; Save tmp0
2172               0261 256C 0649  14         dect  stack
2173               0262 256E C645  30         mov   tmp1,*stack           ; Save tmp1
2174               0263 2570 0649  14         dect  stack
2175               0264 2572 C646  30         mov   tmp2,*stack           ; Save tmp2
2176               0265 2574 0649  14         dect  stack
2177               0266 2576 C647  30         mov   tmp3,*stack           ; Save tmp3
2178               0267                       ;------------------------------------------------------
2179               0268                       ; Initialize
2180               0269                       ;------------------------------------------------------
2181               0270 2578 0206  20         li    tmp2,8                ; Set loop counter
2182                    257A 0008
2183               0271                       ;------------------------------------------------------
2184               0272                       ; Set SAMS memory pages
2185               0273                       ;------------------------------------------------------
2186               0274               sams.layout.loop:
2187               0275 257C C177  30         mov   *tmp3+,tmp1           ; Get memory address
2188               0276 257E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
2189               0277
2190               0278 2580 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
2191                    2582 24FC
2192               0279                                                   ; | i  tmp0 = SAMS page
2193               0280                                                   ; / i  tmp1 = Memory address
2194               0281
2195               0282 2584 0606  14         dec   tmp2                  ; Next iteration
2196               0283 2586 16FA  14         jne   sams.layout.loop      ; Loop until done
2197               0284                       ;------------------------------------------------------
2198               0285                       ; Exit
2199               0286                       ;------------------------------------------------------
2200               0287               sams.init.exit:
2201               0288 2588 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
2202                    258A 2552
2203               0289                                                   ; / activating changes.
2204               0290
2205               0291 258C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2206               0292 258E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2207               0293 2590 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2208               0294 2592 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2209               0295 2594 C2F9  30         mov   *stack+,r11           ; Pop r11
2210               0296 2596 045B  20         b     *r11                  ; Return to caller
2211               0297
2212               0298
2213               0299
2214               0300               ***************************************************************
2215               0301               * sams.reset.layout
2216               0302               * Reset SAMS memory banks to standard layout
2217               0303               ***************************************************************
2218               0304               * bl  @sams.reset.layout
2219               0305               *--------------------------------------------------------------
2220               0306               * OUTPUT
2221               0307               * none
2222               0308               *--------------------------------------------------------------
2223               0309               * Register usage
2224               0310               * none
2225               0311               ********|*****|*********************|**************************
2226               0312               sams.reset.layout:
2227               0313 2598 0649  14         dect  stack
2228               0314 259A C64B  30         mov   r11,*stack            ; Save return address
2229               0315                       ;------------------------------------------------------
2230               0316                       ; Set SAMS standard layout
2231               0317                       ;------------------------------------------------------
2232               0318 259C 06A0  32         bl    @sams.layout
2233                    259E 2562
2234               0319 25A0 25A6                   data sams.reset.layout.data
2235               0320                       ;------------------------------------------------------
2236               0321                       ; Exit
2237               0322                       ;------------------------------------------------------
2238               0323               sams.reset.layout.exit:
2239               0324 25A2 C2F9  30         mov   *stack+,r11           ; Pop r11
2240               0325 25A4 045B  20         b     *r11                  ; Return to caller
2241               0326               ***************************************************************
2242               0327               * SAMS standard page layout table (16 words)
2243               0328               *--------------------------------------------------------------
2244               0329               sams.reset.layout.data:
2245               0330 25A6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
2246                    25A8 0002
2247               0331 25AA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
2248                    25AC 0003
2249               0332 25AE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
2250                    25B0 000A
2251               0333 25B2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
2252                    25B4 000B
2253               0334 25B6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
2254                    25B8 000C
2255               0335 25BA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
2256                    25BC 000D
2257               0336 25BE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
2258                    25C0 000E
2259               0337 25C2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
2260                    25C4 000F
2261               0338
2262               0339
2263               0340
2264               0341               ***************************************************************
2265               0342               * sams.copy.layout
2266               0343               * Copy SAMS memory layout
2267               0344               ***************************************************************
2268               0345               * bl  @sams.copy.layout
2269               0346               *     data P0
2270               0347               *--------------------------------------------------------------
2271               0348               * P0 = Pointer to 8 words RAM buffer for results
2272               0349               *--------------------------------------------------------------
2273               0350               * OUTPUT
2274               0351               * RAM buffer will have the SAMS page number for each range
2275               0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
2276               0353               *--------------------------------------------------------------
2277               0354               * Register usage
2278               0355               * tmp0, tmp1, tmp2, tmp3
2279               0356               ***************************************************************
2280               0357               sams.copy.layout:
2281               0358 25C6 C1FB  30         mov   *r11+,tmp3            ; Get P0
2282               0359
2283               0360 25C8 0649  14         dect  stack
2284               0361 25CA C64B  30         mov   r11,*stack            ; Push return address
2285               0362 25CC 0649  14         dect  stack
2286               0363 25CE C644  30         mov   tmp0,*stack           ; Push tmp0
2287               0364 25D0 0649  14         dect  stack
2288               0365 25D2 C645  30         mov   tmp1,*stack           ; Push tmp1
2289               0366 25D4 0649  14         dect  stack
2290               0367 25D6 C646  30         mov   tmp2,*stack           ; Push tmp2
2291               0368 25D8 0649  14         dect  stack
2292               0369 25DA C647  30         mov   tmp3,*stack           ; Push tmp3
2293               0370                       ;------------------------------------------------------
2294               0371                       ; Copy SAMS layout
2295               0372                       ;------------------------------------------------------
2296               0373 25DC 0205  20         li    tmp1,sams.copy.layout.data
2297                    25DE 25FE
2298               0374 25E0 0206  20         li    tmp2,8                ; Set loop counter
2299                    25E2 0008
2300               0375                       ;------------------------------------------------------
2301               0376                       ; Set SAMS memory pages
2302               0377                       ;------------------------------------------------------
2303               0378               sams.copy.layout.loop:
2304               0379 25E4 C135  30         mov   *tmp1+,tmp0           ; Get memory address
2305               0380 25E6 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
2306                    25E8 24C4
2307               0381                                                   ; | i  tmp0   = Memory address
2308               0382                                                   ; / o  @waux1 = SAMS page
2309               0383
2310               0384 25EA CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
2311                    25EC 833C
2312               0385
2313               0386 25EE 0606  14         dec   tmp2                  ; Next iteration
2314               0387 25F0 16F9  14         jne   sams.copy.layout.loop ; Loop until done
2315               0388                       ;------------------------------------------------------
2316               0389                       ; Exit
2317               0390                       ;------------------------------------------------------
2318               0391               sams.copy.layout.exit:
2319               0392 25F2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
2320               0393 25F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
2321               0394 25F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
2322               0395 25F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
2323               0396 25FA C2F9  30         mov   *stack+,r11           ; Pop r11
2324               0397 25FC 045B  20         b     *r11                  ; Return to caller
2325               0398               ***************************************************************
2326               0399               * SAMS memory range table (8 words)
2327               0400               *--------------------------------------------------------------
2328               0401               sams.copy.layout.data:
2329               0402 25FE 2000             data  >2000                 ; >2000-2fff
2330               0403 2600 3000             data  >3000                 ; >3000-3fff
2331               0404 2602 A000             data  >a000                 ; >a000-afff
2332               0405 2604 B000             data  >b000                 ; >b000-bfff
2333               0406 2606 C000             data  >c000                 ; >c000-cfff
2334               0407 2608 D000             data  >d000                 ; >d000-dfff
2335               0408 260A E000             data  >e000                 ; >e000-efff
2336               0409 260C F000             data  >f000                 ; >f000-ffff
2337               0410
2338               **** **** ****     > runlib.asm
2339               0114
2340               0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
2341               **** **** ****     > vdp_intscr.asm
2342               0001               * FILE......: vdp_intscr.asm
2343               0002               * Purpose...: VDP interrupt & screen on/off
2344               0003
2345               0004               ***************************************************************
2346               0005               * SCROFF - Disable screen display
2347               0006               ***************************************************************
2348               0007               *  BL @SCROFF
2349               0008               ********|*****|*********************|**************************
2350               0009 260E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
2351                    2610 FFBF
2352               0010 2612 0460  28         b     @putv01
2353                    2614 2326
2354               0011
2355               0012               ***************************************************************
2356               0013               * SCRON - Disable screen display
2357               0014               ***************************************************************
2358               0015               *  BL @SCRON
2359               0016               ********|*****|*********************|**************************
2360               0017 2616 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
2361                    2618 0040
2362               0018 261A 0460  28         b     @putv01
2363                    261C 2326
2364               0019
2365               0020               ***************************************************************
2366               0021               * INTOFF - Disable VDP interrupt
2367               0022               ***************************************************************
2368               0023               *  BL @INTOFF
2369               0024               ********|*****|*********************|**************************
2370               0025 261E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
2371                    2620 FFDF
2372               0026 2622 0460  28         b     @putv01
2373                    2624 2326
2374               0027
2375               0028               ***************************************************************
2376               0029               * INTON - Enable VDP interrupt
2377               0030               ***************************************************************
2378               0031               *  BL @INTON
2379               0032               ********|*****|*********************|**************************
2380               0033 2626 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
2381                    2628 0020
2382               0034 262A 0460  28         b     @putv01
2383                    262C 2326
2384               **** **** ****     > runlib.asm
2385               0118
2386               0120                       copy  "vdp_sprites.asm"          ; VDP sprites
2387               **** **** ****     > vdp_sprites.asm
2388               0001               ***************************************************************
2389               0002               * FILE......: vdp_sprites.asm
2390               0003               * Purpose...: Sprites support
2391               0004
2392               0005               ***************************************************************
2393               0006               * SMAG1X - Set sprite magnification 1x
2394               0007               ***************************************************************
2395               0008               *  BL @SMAG1X
2396               0009               ********|*****|*********************|**************************
2397               0010 262E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
2398                    2630 FFFE
2399               0011 2632 0460  28         b     @putv01
2400                    2634 2326
2401               0012
2402               0013               ***************************************************************
2403               0014               * SMAG2X - Set sprite magnification 2x
2404               0015               ***************************************************************
2405               0016               *  BL @SMAG2X
2406               0017               ********|*****|*********************|**************************
2407               0018 2636 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
2408                    2638 0001
2409               0019 263A 0460  28         b     @putv01
2410                    263C 2326
2411               0020
2412               0021               ***************************************************************
2413               0022               * S8X8 - Set sprite size 8x8 bits
2414               0023               ***************************************************************
2415               0024               *  BL @S8X8
2416               0025               ********|*****|*********************|**************************
2417               0026 263E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
2418                    2640 FFFD
2419               0027 2642 0460  28         b     @putv01
2420                    2644 2326
2421               0028
2422               0029               ***************************************************************
2423               0030               * S16X16 - Set sprite size 16x16 bits
2424               0031               ***************************************************************
2425               0032               *  BL @S16X16
2426               0033               ********|*****|*********************|**************************
2427               0034 2646 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
2428                    2648 0002
2429               0035 264A 0460  28         b     @putv01
2430                    264C 2326
2431               **** **** ****     > runlib.asm
2432               0122
2433               0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
2434               **** **** ****     > vdp_cursor.asm
2435               0001               * FILE......: vdp_cursor.asm
2436               0002               * Purpose...: VDP cursor handling
2437               0003
2438               0004               *//////////////////////////////////////////////////////////////
2439               0005               *               VDP cursor movement functions
2440               0006               *//////////////////////////////////////////////////////////////
2441               0007
2442               0008
2443               0009               ***************************************************************
2444               0010               * AT - Set cursor YX position
2445               0011               ***************************************************************
2446               0012               *  bl   @yx
2447               0013               *  data p0
2448               0014               *--------------------------------------------------------------
2449               0015               *  INPUT
2450               0016               *  P0 = New Cursor YX position
2451               0017               ********|*****|*********************|**************************
2452               0018 264E C83B  50 at      mov   *r11+,@wyx
2453                    2650 832A
2454               0019 2652 045B  20         b     *r11
2455               0020
2456               0021
2457               0022               ***************************************************************
2458               0023               * down - Increase cursor Y position
2459               0024               ***************************************************************
2460               0025               *  bl   @down
2461               0026               ********|*****|*********************|**************************
2462               0027 2654 B820  54 down    ab    @hb$01,@wyx
2463                    2656 201C
2464                    2658 832A
2465               0028 265A 045B  20         b     *r11
2466               0029
2467               0030
2468               0031               ***************************************************************
2469               0032               * up - Decrease cursor Y position
2470               0033               ***************************************************************
2471               0034               *  bl   @up
2472               0035               ********|*****|*********************|**************************
2473               0036 265C 7820  54 up      sb    @hb$01,@wyx
2474                    265E 201C
2475                    2660 832A
2476               0037 2662 045B  20         b     *r11
2477               0038
2478               0039
2479               0040               ***************************************************************
2480               0041               * setx - Set cursor X position
2481               0042               ***************************************************************
2482               0043               *  bl   @setx
2483               0044               *  data p0
2484               0045               *--------------------------------------------------------------
2485               0046               *  Register usage
2486               0047               *  TMP0
2487               0048               ********|*****|*********************|**************************
2488               0049 2664 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
2489               0050 2666 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
2490                    2668 832A
2491               0051 266A C804  38         mov   tmp0,@wyx             ; Save as new YX position
2492                    266C 832A
2493               0052 266E 045B  20         b     *r11
2494               **** **** ****     > runlib.asm
2495               0126
2496               0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
2497               **** **** ****     > vdp_yx2px_calc.asm
2498               0001               * FILE......: vdp_yx2px_calc.asm
2499               0002               * Purpose...: Calculate pixel position for YX coordinate
2500               0003
2501               0004               ***************************************************************
2502               0005               * YX2PX - Get pixel position for cursor YX position
2503               0006               ***************************************************************
2504               0007               *  BL   @YX2PX
2505               0008               *
2506               0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
2507               0010               *--------------------------------------------------------------
2508               0011               *  INPUT
2509               0012               *  @WYX   = Cursor YX position
2510               0013               *--------------------------------------------------------------
2511               0014               *  OUTPUT
2512               0015               *  TMP0HB = Y pixel position
2513               0016               *  TMP0LB = X pixel position
2514               0017               *--------------------------------------------------------------
2515               0018               *  Remarks
2516               0019               *  This subroutine does not support multicolor mode
2517               0020               ********|*****|*********************|**************************
2518               0021 2670 C120  34 yx2px   mov   @wyx,tmp0
2519                    2672 832A
2520               0022 2674 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
2521               0023 2676 06C4  14         swpb  tmp0                  ; Y<->X
2522               0024 2678 04C5  14         clr   tmp1                  ; Clear before copy
2523               0025 267A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2524               0026               *--------------------------------------------------------------
2525               0027               * X pixel - Special F18a 80 colums treatment
2526               0028               *--------------------------------------------------------------
2527               0029 267C 20A0  38         coc   @wbit1,config         ; f18a present ?
2528                    267E 2028
2529               0030 2680 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2530               0031 2682 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
2531                    2684 833A
2532                    2686 26B0
2533               0032 2688 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
2534               0033
2535               0034 268A 0A15  56         sla   tmp1,1                ; X = X * 2
2536               0035 268C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
2537               0036 268E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
2538                    2690 0500
2539               0037 2692 1002  14         jmp   yx2pxx_y_calc
2540               0038               *--------------------------------------------------------------
2541               0039               * X pixel - Normal VDP treatment
2542               0040               *--------------------------------------------------------------
2543               0041               yx2pxx_normal:
2544               0042 2694 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
2545               0043               *--------------------------------------------------------------
2546               0044 2696 0A35  56         sla   tmp1,3                ; X=X*8
2547               0045               *--------------------------------------------------------------
2548               0046               * Calculate Y pixel position
2549               0047               *--------------------------------------------------------------
2550               0048               yx2pxx_y_calc:
2551               0049 2698 0A34  56         sla   tmp0,3                ; Y=Y*8
2552               0050 269A D105  18         movb  tmp1,tmp0
2553               0051 269C 06C4  14         swpb  tmp0                  ; X<->Y
2554               0052 269E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
2555                    26A0 202A
2556               0053 26A2 1305  14         jeq   yx2pi3                ; Yes, exit
2557               0054               *--------------------------------------------------------------
2558               0055               * Adjust for Y sprite location
2559               0056               * See VDP Programmers Guide, Section 9.2.1
2560               0057               *--------------------------------------------------------------
2561               0058 26A4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
2562                    26A6 201C
2563               0059 26A8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
2564                    26AA 202E
2565               0060 26AC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
2566               0061 26AE 0456  20 yx2pi3  b     *tmp2                 ; Exit
2567               0062               *--------------------------------------------------------------
2568               0063               * Local constants
2569               0064               *--------------------------------------------------------------
2570               0065               yx2pxx_c80:
2571               0066 26B0 0050            data   80
2572               0067
2573               0068
2574               **** **** ****     > runlib.asm
2575               0130
2576               0134
2577               0138
2578               0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
2579               **** **** ****     > vdp_f18a_support.asm
2580               0001               * FILE......: vdp_f18a_support.asm
2581               0002               * Purpose...: VDP F18A Support module
2582               0003
2583               0004               *//////////////////////////////////////////////////////////////
2584               0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
2585               0006               *//////////////////////////////////////////////////////////////
2586               0007
2587               0008               ***************************************************************
2588               0009               * f18unl - Unlock F18A VDP
2589               0010               ***************************************************************
2590               0011               *  bl   @f18unl
2591               0012               ********|*****|*********************|**************************
2592               0013 26B2 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
2593               0014 26B4 06A0  32         bl    @putvr                ; Write once
2594                    26B6 2312
2595               0015 26B8 391C             data  >391c                 ; VR1/57, value 00011100
2596               0016 26BA 06A0  32         bl    @putvr                ; Write twice
2597                    26BC 2312
2598               0017 26BE 391C             data  >391c                 ; VR1/57, value 00011100
2599               0018 26C0 0458  20         b     *tmp4                 ; Exit
2600               0019
2601               0020
2602               0021               ***************************************************************
2603               0022               * f18lck - Lock F18A VDP
2604               0023               ***************************************************************
2605               0024               *  bl   @f18lck
2606               0025               ********|*****|*********************|**************************
2607               0026 26C2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
2608               0027 26C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2609                    26C6 2312
2610               0028 26C8 391C             data  >391c
2611               0029 26CA 0458  20         b     *tmp4                 ; Exit
2612               0030
2613               0031
2614               0032               ***************************************************************
2615               0033               * f18chk - Check if F18A VDP present
2616               0034               ***************************************************************
2617               0035               *  bl   @f18chk
2618               0036               *--------------------------------------------------------------
2619               0037               *  REMARKS
2620               0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
2621               0039               ********|*****|*********************|**************************
2622               0040 26CC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
2623               0041 26CE 06A0  32         bl    @cpym2v
2624                    26D0 2418
2625               0042 26D2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
2626                    26D4 2710
2627                    26D6 0006
2628               0043 26D8 06A0  32         bl    @putvr
2629                    26DA 2312
2630               0044 26DC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
2631               0045 26DE 06A0  32         bl    @putvr
2632                    26E0 2312
2633               0046 26E2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
2634               0047                                                   ; GPU code should run now
2635               0048               ***************************************************************
2636               0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
2637               0050               ***************************************************************
2638               0051 26E4 0204  20         li    tmp0,>3f00
2639                    26E6 3F00
2640               0052 26E8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
2641                    26EA 229A
2642               0053 26EC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
2643                    26EE 8800
2644               0054 26F0 0984  56         srl   tmp0,8
2645               0055 26F2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
2646                    26F4 8800
2647               0056 26F6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
2648               0057 26F8 1303  14         jeq   f18chk_yes
2649               0058               f18chk_no:
2650               0059 26FA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
2651                    26FC BFFF
2652               0060 26FE 1002  14         jmp   f18chk_exit
2653               0061               f18chk_yes:
2654               0062 2700 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
2655                    2702 4000
2656               0063               f18chk_exit:
2657               0064 2704 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
2658                    2706 226E
2659               0065 2708 3F00             data  >3f00,>00,6
2660                    270A 0000
2661                    270C 0006
2662               0066 270E 0458  20         b     *tmp4                 ; Exit
2663               0067               ***************************************************************
2664               0068               * GPU code
2665               0069               ********|*****|*********************|**************************
2666               0070               f18chk_gpu
2667               0071 2710 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
2668               0072 2712 3F00             data  >3f00                 ; 3f02 / 3f00
2669               0073 2714 0340             data  >0340                 ; 3f04   0340  idle
2670               0074
2671               0075
2672               0076               ***************************************************************
2673               0077               * f18rst - Reset f18a into standard settings
2674               0078               ***************************************************************
2675               0079               *  bl   @f18rst
2676               0080               *--------------------------------------------------------------
2677               0081               *  REMARKS
2678               0082               *  This is used to leave the F18A mode and revert all settings
2679               0083               *  that could lead to corruption when doing BLWP @0
2680               0084               *
2681               0085               *  There are some F18a settings that stay on when doing blwp @0
2682               0086               *  and the TI title screen cannot recover from that.
2683               0087               *
2684               0088               *  It is your responsibility to set video mode tables should
2685               0089               *  you want to continue instead of doing blwp @0 after your
2686               0090               *  program cleanup
2687               0091               ********|*****|*********************|**************************
2688               0092 2716 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
2689               0093                       ;------------------------------------------------------
2690               0094                       ; Reset all F18a VDP registers to power-on defaults
2691               0095                       ;------------------------------------------------------
2692               0096 2718 06A0  32         bl    @putvr
2693                    271A 2312
2694               0097 271C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
2695               0098
2696               0099 271E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
2697                    2720 2312
2698               0100 2722 391C             data  >391c                 ; Lock the F18a
2699               0101 2724 0458  20         b     *tmp4                 ; Exit
2700               0102
2701               0103
2702               0104
2703               0105               ***************************************************************
2704               0106               * f18fwv - Get F18A Firmware Version
2705               0107               ***************************************************************
2706               0108               *  bl   @f18fwv
2707               0109               *--------------------------------------------------------------
2708               0110               *  REMARKS
2709               0111               *  Successfully tested with F18A v1.8, note that this does not
2710               0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
2711               0113               *  firmware to begin with.
2712               0114               *--------------------------------------------------------------
2713               0115               *  TMP0 High nibble = major version
2714               0116               *  TMP0 Low nibble  = minor version
2715               0117               *
2716               0118               *  Example: >0018     F18a Firmware v1.8
2717               0119               ********|*****|*********************|**************************
2718               0120 2726 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
2719               0121 2728 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
2720                    272A 2028
2721               0122 272C 1609  14         jne   f18fw1
2722               0123               ***************************************************************
2723               0124               * Read F18A major/minor version
2724               0125               ***************************************************************
2725               0126 272E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
2726                    2730 8802
2727               0127 2732 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
2728                    2734 2312
2729               0128 2736 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
2730               0129 2738 04C4  14         clr   tmp0
2731               0130 273A D120  34         movb  @vdps,tmp0
2732                    273C 8802
2733               0131 273E 0984  56         srl   tmp0,8
2734               0132 2740 0458  20 f18fw1  b     *tmp4                 ; Exit
2735               **** **** ****     > runlib.asm
2736               0142
2737               0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
2738               **** **** ****     > vdp_hchar.asm
2739               0001               * FILE......: vdp_hchar.a99
2740               0002               * Purpose...: VDP hchar module
2741               0003
2742               0004               ***************************************************************
2743               0005               * Repeat characters horizontally at YX
2744               0006               ***************************************************************
2745               0007               *  BL    @HCHAR
2746               0008               *  DATA  P0,P1
2747               0009               *  ...
2748               0010               *  DATA  EOL                        ; End-of-list
2749               0011               *--------------------------------------------------------------
2750               0012               *  P0HB = Y position
2751               0013               *  P0LB = X position
2752               0014               *  P1HB = Byte to write
2753               0015               *  P1LB = Number of times to repeat
2754               0016               ********|*****|*********************|**************************
2755               0017 2742 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
2756                    2744 832A
2757               0018 2746 D17B  28         movb  *r11+,tmp1
2758               0019 2748 0985  56 hcharx  srl   tmp1,8                ; Byte to write
2759               0020 274A D1BB  28         movb  *r11+,tmp2
2760               0021 274C 0986  56         srl   tmp2,8                ; Repeat count
2761               0022 274E C1CB  18         mov   r11,tmp3
2762               0023 2750 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2763                    2752 23DA
2764               0024               *--------------------------------------------------------------
2765               0025               *    Draw line
2766               0026               *--------------------------------------------------------------
2767               0027 2754 020B  20         li    r11,hchar1
2768                    2756 275C
2769               0028 2758 0460  28         b     @xfilv                ; Draw
2770                    275A 2274
2771               0029               *--------------------------------------------------------------
2772               0030               *    Do housekeeping
2773               0031               *--------------------------------------------------------------
2774               0032 275C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
2775                    275E 202C
2776               0033 2760 1302  14         jeq   hchar2                ; Yes, exit
2777               0034 2762 C2C7  18         mov   tmp3,r11
2778               0035 2764 10EE  14         jmp   hchar                 ; Next one
2779               0036 2766 05C7  14 hchar2  inct  tmp3
2780               0037 2768 0457  20         b     *tmp3                 ; Exit
2781               **** **** ****     > runlib.asm
2782               0146
2783               0148                       copy  "vdp_vchar.asm"            ; VDP vchar functions
2784               **** **** ****     > vdp_vchar.asm
2785               0001               * FILE......: vdp_vchar.a99
2786               0002               * Purpose...: VDP vchar module
2787               0003
2788               0004               ***************************************************************
2789               0005               * Repeat characters vertically at YX
2790               0006               ***************************************************************
2791               0007               *  BL    @VCHAR
2792               0008               *  DATA  P0,P1
2793               0009               *  ...
2794               0010               *  DATA  EOL                        ; End-of-list
2795               0011               *--------------------------------------------------------------
2796               0012               *  P0HB = Y position
2797               0013               *  P0LB = X position
2798               0014               *  P1HB = Byte to write
2799               0015               *  P1LB = Number of times to repeat
2800               0016               ********|*****|*********************|**************************
2801               0017 276A C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
2802                    276C 832A
2803               0018 276E C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
2804               0019 2770 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
2805                    2772 833A
2806               0020 2774 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2807                    2776 23DA
2808               0021 2778 D177  28         movb  *tmp3+,tmp1           ; Byte to write
2809               0022 277A D1B7  28         movb  *tmp3+,tmp2
2810               0023 277C 0986  56         srl   tmp2,8                ; Repeat count
2811               0024               *--------------------------------------------------------------
2812               0025               *    Setup VDP write address
2813               0026               *--------------------------------------------------------------
2814               0027 277E 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
2815                    2780 2296
2816               0028               *--------------------------------------------------------------
2817               0029               *    Dump tile to VDP and do housekeeping
2818               0030               *--------------------------------------------------------------
2819               0031 2782 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
2820               0032 2784 A108  18         a     tmp4,tmp0             ; Next row
2821               0033 2786 0606  14         dec   tmp2
2822               0034 2788 16FA  14         jne   vchar2
2823               0035 278A 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
2824                    278C 202C
2825               0036 278E 1303  14         jeq   vchar3                ; Yes, exit
2826               0037 2790 C837  50         mov   *tmp3+,@wyx           ; Save YX position
2827                    2792 832A
2828               0038 2794 10ED  14         jmp   vchar1                ; Next one
2829               0039 2796 05C7  14 vchar3  inct  tmp3
2830               0040 2798 0457  20         b     *tmp3                 ; Exit
2831               0041
2832               0042               ***************************************************************
2833               0043               * Repeat characters vertically at YX
2834               0044               ***************************************************************
2835               0045               * TMP0 = YX position
2836               0046               * TMP1 = Byte to write
2837               0047               * TMP2 = Repeat count
2838               0048               ***************************************************************
2839               0049 279A C20B  18 xvchar  mov   r11,tmp4              ; Save return address
2840               0050 279C C804  38         mov   tmp0,@wyx             ; Set cursor position
2841                    279E 832A
2842               0051 27A0 06C5  14         swpb  tmp1                  ; Byte to write into MSB
2843               0052 27A2 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
2844                    27A4 833A
2845               0053 27A6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
2846                    27A8 23DA
2847               0054               *--------------------------------------------------------------
2848               0055               *    Setup VDP write address
2849               0056               *--------------------------------------------------------------
2850               0057 27AA 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
2851                    27AC 2296
2852               0058               *--------------------------------------------------------------
2853               0059               *    Dump tile to VDP and do housekeeping
2854               0060               *--------------------------------------------------------------
2855               0061 27AE D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
2856               0062 27B0 A120  34         a     @wcolmn,tmp0          ; Next row
2857                    27B2 833A
2858               0063 27B4 0606  14         dec   tmp2
2859               0064 27B6 16F9  14         jne   xvcha1
2860               0065 27B8 0458  20         b     *tmp4                 ; Exit
2861               **** **** ****     > runlib.asm
2862               0150
2863               0154
2864               0158
2865               0162
2866               0166
2867               0170
2868               0174
2869               0176                       copy  "keyb_real.asm"            ; Real Keyboard support
2870               **** **** ****     > keyb_real.asm
2871               0001               * FILE......: keyb_real.asm
2872               0002               * Purpose...: Full (real) keyboard support module
2873               0003
2874               0004               *//////////////////////////////////////////////////////////////
2875               0005               *                     KEYBOARD FUNCTIONS
2876               0006               *//////////////////////////////////////////////////////////////
2877               0007
2878               0008               ***************************************************************
2879               0009               * REALKB - Scan keyboard in real mode
2880               0010               ***************************************************************
2881               0011               *  BL @REALKB
2882               0012               *--------------------------------------------------------------
2883               0013               *  Based on work done by Simon Koppelmann
2884               0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
2885               0015               ********|*****|*********************|**************************
2886               0016 27BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
2887                    27BC 202A
2888               0017 27BE 020C  20         li    r12,>0024
2889                    27C0 0024
2890               0018 27C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
2891                    27C4 2852
2892               0019 27C6 04C6  14         clr   tmp2
2893               0020 27C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
2894               0021               *--------------------------------------------------------------
2895               0022               * SHIFT key pressed ?
2896               0023               *--------------------------------------------------------------
2897               0024 27CA 04CC  14         clr   r12
2898               0025 27CC 1F08  20         tb    >0008                 ; Shift-key ?
2899               0026 27CE 1302  14         jeq   realk1                ; No
2900               0027 27D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
2901                    27D2 2882
2902               0028               *--------------------------------------------------------------
2903               0029               * FCTN key pressed ?
2904               0030               *--------------------------------------------------------------
2905               0031 27D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
2906               0032 27D6 1302  14         jeq   realk2                ; No
2907               0033 27D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
2908                    27DA 28B2
2909               0034               *--------------------------------------------------------------
2910               0035               * CTRL key pressed ?
2911               0036               *--------------------------------------------------------------
2912               0037 27DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
2913               0038 27DE 1302  14         jeq   realk3                ; No
2914               0039 27E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
2915                    27E2 28E2
2916               0040               *--------------------------------------------------------------
2917               0041               * ALPHA LOCK key down ?
2918               0042               *--------------------------------------------------------------
2919               0043 27E4 1E15  20 realk3  sbz   >0015                 ; Set P5
2920               0044 27E6 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
2921               0045 27E8 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
2922               0046 27EA E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
2923                    27EC 202A
2924               0047               *--------------------------------------------------------------
2925               0048               * Scan keyboard column
2926               0049               *--------------------------------------------------------------
2927               0050 27EE 1D15  20 realk4  sbo   >0015                 ; Reset P5
2928               0051 27F0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
2929                    27F2 0006
2930               0052 27F4 0606  14 realk5  dec   tmp2
2931               0053 27F6 020C  20         li    r12,>24               ; CRU address for P2-P4
2932                    27F8 0024
2933               0054 27FA 06C6  14         swpb  tmp2
2934               0055 27FC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
2935               0056 27FE 06C6  14         swpb  tmp2
2936               0057 2800 020C  20         li    r12,6                 ; CRU read address
2937                    2802 0006
2938               0058 2804 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
2939               0059 2806 0547  14         inv   tmp3                  ;
2940               0060 2808 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
2941                    280A FF00
2942               0061               *--------------------------------------------------------------
2943               0062               * Scan keyboard row
2944               0063               *--------------------------------------------------------------
2945               0064 280C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
2946               0065 280E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
2947               0066 2810 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
2948               0067 2812 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
2949               0068 2814 0285  22         ci    tmp1,8
2950                    2816 0008
2951               0069 2818 1AFA  14         jl    realk6
2952               0070 281A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
2953               0071 281C 1BEB  14         jh    realk5                ; No, next column
2954               0072 281E 1016  14         jmp   realkz                ; Yes, exit
2955               0073               *--------------------------------------------------------------
2956               0074               * Check for match in data table
2957               0075               *--------------------------------------------------------------
2958               0076 2820 C206  18 realk8  mov   tmp2,tmp4
2959               0077 2822 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
2960               0078 2824 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
2961               0079 2826 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
2962               0080 2828 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
2963               0081 282A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
2964               0082               *--------------------------------------------------------------
2965               0083               * Determine ASCII value of key
2966               0084               *--------------------------------------------------------------
2967               0085 282C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
2968               0086 282E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
2969                    2830 202A
2970               0087 2832 1608  14         jne   realka                ; No, continue saving key
2971               0088 2834 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
2972                    2836 287C
2973               0089 2838 1A05  14         jl    realka
2974               0090 283A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
2975                    283C 287A
2976               0091 283E 1B02  14         jh    realka                ; No, continue
2977               0092 2840 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
2978                    2842 E000
2979               0093 2844 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
2980                    2846 833C
2981               0094 2848 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
2982                    284A 2014
2983               0095 284C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
2984                    284E 8C00
2985               0096 2850 045B  20         b     *r11                  ; Exit
2986               0097               ********|*****|*********************|**************************
2987               0098 2852 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
2988                    2854 0000
2989                    2856 FF0D
2990                    2858 203D
2991               0099 285A ....             text  'xws29ol.'
2992               0100 2862 ....             text  'ced38ik,'
2993               0101 286A ....             text  'vrf47ujm'
2994               0102 2872 ....             text  'btg56yhn'
2995               0103 287A ....             text  'zqa10p;/'
2996               0104 2882 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
2997                    2884 0000
2998                    2886 FF0D
2999                    2888 202B
3000               0105 288A ....             text  'XWS@(OL>'
3001               0106 2892 ....             text  'CED#*IK<'
3002               0107 289A ....             text  'VRF$&UJM'
3003               0108 28A2 ....             text  'BTG%^YHN'
3004               0109 28AA ....             text  'ZQA!)P:-'
3005               0110 28B2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
3006                    28B4 0000
3007                    28B6 FF0D
3008                    28B8 2005
3009               0111 28BA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
3010                    28BC 0804
3011                    28BE 0F27
3012                    28C0 C2B9
3013               0112 28C2 600B             data  >600b,>0907,>063f,>c1B8
3014                    28C4 0907
3015                    28C6 063F
3016                    28C8 C1B8
3017               0113 28CA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
3018                    28CC 7B02
3019                    28CE 015F
3020                    28D0 C0C3
3021               0114 28D2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
3022                    28D4 7D0E
3023                    28D6 0CC6
3024                    28D8 BFC4
3025               0115 28DA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
3026                    28DC 7C03
3027                    28DE BC22
3028                    28E0 BDBA
3029               0116 28E2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
3030                    28E4 0000
3031                    28E6 FF0D
3032                    28E8 209D
3033               0117 28EA 9897             data  >9897,>93b2,>9f8f,>8c9B
3034                    28EC 93B2
3035                    28EE 9F8F
3036                    28F0 8C9B
3037               0118 28F2 8385             data  >8385,>84b3,>9e89,>8b80
3038                    28F4 84B3
3039                    28F6 9E89
3040                    28F8 8B80
3041               0119 28FA 9692             data  >9692,>86b4,>b795,>8a8D
3042                    28FC 86B4
3043                    28FE B795
3044                    2900 8A8D
3045               0120 2902 8294             data  >8294,>87b5,>b698,>888E
3046                    2904 87B5
3047                    2906 B698
3048                    2908 888E
3049               0121 290A 9A91             data  >9a91,>81b1,>b090,>9cBB
3050                    290C 81B1
3051                    290E B090
3052                    2910 9CBB
3053               **** **** ****     > runlib.asm
3054               0178
3055               0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
3056               **** **** ****     > cpu_hexsupport.asm
3057               0001               * FILE......: cpu_hexsupport.asm
3058               0002               * Purpose...: CPU create, display hex numbers module
3059               0003
3060               0004               ***************************************************************
3061               0005               * mkhex - Convert hex word to string
3062               0006               ***************************************************************
3063               0007               *  bl   @mkhex
3064               0008               *       data P0,P1,P2
3065               0009               *--------------------------------------------------------------
3066               0010               *  P0 = Pointer to 16 bit word
3067               0011               *  P1 = Pointer to string buffer
3068               0012               *  P2 = Offset for ASCII digit
3069               0013               *       MSB determines offset for chars A-F
3070               0014               *       LSB determines offset for chars 0-9
3071               0015               *  (CONFIG#0 = 1) = Display number at cursor YX
3072               0016               *--------------------------------------------------------------
3073               0017               *  Memory usage:
3074               0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
3075               0019               *  waux1, waux2, waux3
3076               0020               *--------------------------------------------------------------
3077               0021               *  Memory variables waux1-waux3 are used as temporary variables
3078               0022               ********|*****|*********************|**************************
3079               0023 2912 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
3080               0024 2914 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
3081                    2916 8340
3082               0025 2918 04E0  34         clr   @waux1
3083                    291A 833C
3084               0026 291C 04E0  34         clr   @waux2
3085                    291E 833E
3086               0027 2920 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
3087                    2922 833C
3088               0028 2924 C114  26         mov   *tmp0,tmp0            ; Get word
3089               0029               *--------------------------------------------------------------
3090               0030               *    Convert nibbles to bytes (is in wrong order)
3091               0031               *--------------------------------------------------------------
3092               0032 2926 0205  20         li    tmp1,4                ; 4 nibbles
3093                    2928 0004
3094               0033 292A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
3095               0034 292C 0246  22         andi  tmp2,>000f            ; Only keep LSN
3096                    292E 000F
3097               0035                       ;------------------------------------------------------
3098               0036                       ; Determine offset for ASCII char
3099               0037                       ;------------------------------------------------------
3100               0038 2930 0286  22         ci    tmp2,>000a
3101                    2932 000A
3102               0039 2934 1105  14         jlt   mkhex1.digit09
3103               0040                       ;------------------------------------------------------
3104               0041                       ; Add ASCII offset for digits A-F
3105               0042                       ;------------------------------------------------------
3106               0043               mkhex1.digitaf:
3107               0044 2936 C21B  26         mov   *r11,tmp4
3108               0045 2938 0988  56         srl   tmp4,8                ; Right justify
3109               0046 293A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
3110                    293C FFF6
3111               0047 293E 1003  14         jmp   mkhex2
3112               0048
3113               0049               mkhex1.digit09:
3114               0050                       ;------------------------------------------------------
3115               0051                       ; Add ASCII offset for digits 0-9
3116               0052                       ;------------------------------------------------------
3117               0053 2940 C21B  26         mov   *r11,tmp4
3118               0054 2942 0248  22         andi  tmp4,>00ff            ; Only keep LSB
3119                    2944 00FF
3120               0055
3121               0056 2946 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
3122               0057 2948 06C6  14         swpb  tmp2
3123               0058 294A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
3124               0059 294C 0944  56         srl   tmp0,4                ; Next nibble
3125               0060 294E 0605  14         dec   tmp1
3126               0061 2950 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
3127               0062 2952 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
3128                    2954 BFFF
3129               0063               *--------------------------------------------------------------
3130               0064               *    Build first 2 bytes in correct order
3131               0065               *--------------------------------------------------------------
3132               0066 2956 C160  34         mov   @waux3,tmp1           ; Get pointer
3133                    2958 8340
3134               0067 295A 04D5  26         clr   *tmp1                 ; Set length byte to 0
3135               0068 295C 0585  14         inc   tmp1                  ; Next byte, not word!
3136               0069 295E C120  34         mov   @waux2,tmp0
3137                    2960 833E
3138               0070 2962 06C4  14         swpb  tmp0
3139               0071 2964 DD44  32         movb  tmp0,*tmp1+
3140               0072 2966 06C4  14         swpb  tmp0
3141               0073 2968 DD44  32         movb  tmp0,*tmp1+
3142               0074               *--------------------------------------------------------------
3143               0075               *    Set length byte
3144               0076               *--------------------------------------------------------------
3145               0077 296A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
3146                    296C 8340
3147               0078 296E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
3148                    2970 2020
3149               0079 2972 05CB  14         inct  r11                   ; Skip Parameter P2
3150               0080               *--------------------------------------------------------------
3151               0081               *    Build last 2 bytes in correct order
3152               0082               *--------------------------------------------------------------
3153               0083 2974 C120  34         mov   @waux1,tmp0
3154                    2976 833C
3155               0084 2978 06C4  14         swpb  tmp0
3156               0085 297A DD44  32         movb  tmp0,*tmp1+
3157               0086 297C 06C4  14         swpb  tmp0
3158               0087 297E DD44  32         movb  tmp0,*tmp1+
3159               0088               *--------------------------------------------------------------
3160               0089               *    Display hex number ?
3161               0090               *--------------------------------------------------------------
3162               0091 2980 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3163                    2982 202A
3164               0092 2984 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
3165               0093 2986 045B  20         b     *r11                  ; Exit
3166               0094               *--------------------------------------------------------------
3167               0095               *  Display hex number on screen at current YX position
3168               0096               *--------------------------------------------------------------
3169               0097 2988 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
3170                    298A 7FFF
3171               0098 298C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
3172                    298E 8340
3173               0099 2990 0460  28         b     @xutst0               ; Display string
3174                    2992 2400
3175               0100 2994 0610     prefix  data  >0610                 ; Length byte + blank
3176               0101
3177               0102
3178               0103
3179               0104               ***************************************************************
3180               0105               * puthex - Put 16 bit word on screen
3181               0106               ***************************************************************
3182               0107               *  bl   @mkhex
3183               0108               *       data P0,P1,P2,P3
3184               0109               *--------------------------------------------------------------
3185               0110               *  P0 = YX position
3186               0111               *  P1 = Pointer to 16 bit word
3187               0112               *  P2 = Pointer to string buffer
3188               0113               *  P3 = Offset for ASCII digit
3189               0114               *       MSB determines offset for chars A-F
3190               0115               *       LSB determines offset for chars 0-9
3191               0116               *--------------------------------------------------------------
3192               0117               *  Memory usage:
3193               0118               *  tmp0, tmp1, tmp2, tmp3
3194               0119               *  waux1, waux2, waux3
3195               0120               ********|*****|*********************|**************************
3196               0121 2996 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
3197                    2998 832A
3198               0122 299A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3199                    299C 8000
3200               0123 299E 10B9  14         jmp   mkhex                 ; Convert number and display
3201               0124
3202               **** **** ****     > runlib.asm
3203               0182
3204               0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
3205               **** **** ****     > cpu_numsupport.asm
3206               0001               * FILE......: cpu_numsupport.asm
3207               0002               * Purpose...: CPU create, display numbers module
3208               0003
3209               0004               ***************************************************************
3210               0005               * MKNUM - Convert unsigned number to string
3211               0006               ***************************************************************
3212               0007               *  BL   @MKNUM
3213               0008               *  DATA P0,P1,P2
3214               0009               *
3215               0010               *  P0   = Pointer to 16 bit unsigned number
3216               0011               *  P1   = Pointer to 5 byte string buffer
3217               0012               *  P2HB = Offset for ASCII digit
3218               0013               *  P2LB = Character for replacing leading 0's
3219               0014               *
3220               0015               *  (CONFIG:0 = 1) = Display number at cursor YX
3221               0016               *-------------------------------------------------------------
3222               0017               *  Destroys registers tmp0-tmp4
3223               0018               ********|*****|*********************|**************************
3224               0019 29A0 0207  20 mknum   li    tmp3,5                ; Digit counter
3225                    29A2 0005
3226               0020 29A4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
3227               0021 29A6 C155  26         mov   *tmp1,tmp1            ; /
3228               0022 29A8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
3229               0023 29AA 0228  22         ai    tmp4,4                ; Get end of buffer
3230                    29AC 0004
3231               0024 29AE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
3232                    29B0 000A
3233               0025               *--------------------------------------------------------------
3234               0026               *  Do string conversion
3235               0027               *--------------------------------------------------------------
3236               0028 29B2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
3237               0029 29B4 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
3238               0030 29B6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
3239               0031 29B8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
3240               0032 29BA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
3241               0033 29BC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
3242               0034 29BE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
3243               0035 29C0 0607  14         dec   tmp3                  ; Decrease counter
3244               0036 29C2 16F7  14         jne   mknum1                ; Do next digit
3245               0037               *--------------------------------------------------------------
3246               0038               *  Replace leading 0's with fill character
3247               0039               *--------------------------------------------------------------
3248               0040 29C4 0207  20         li    tmp3,4                ; Check first 4 digits
3249                    29C6 0004
3250               0041 29C8 0588  14         inc   tmp4                  ; Too far, back to buffer start
3251               0042 29CA C11B  26         mov   *r11,tmp0
3252               0043 29CC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
3253               0044 29CE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
3254               0045 29D0 1305  14         jeq   mknum4                ; Yes, replace with fill character
3255               0046 29D2 05CB  14 mknum3  inct  r11
3256               0047 29D4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
3257                    29D6 202A
3258               0048 29D8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
3259               0049 29DA 045B  20         b     *r11                  ; Exit
3260               0050 29DC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
3261               0051 29DE 0607  14         dec   tmp3                  ; 4th digit processed ?
3262               0052 29E0 13F8  14         jeq   mknum3                ; Yes, exit
3263               0053 29E2 10F5  14         jmp   mknum2                ; No, next one
3264               0054               *--------------------------------------------------------------
3265               0055               *  Display integer on screen at current YX position
3266               0056               *--------------------------------------------------------------
3267               0057 29E4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
3268                    29E6 7FFF
3269               0058 29E8 C10B  18         mov   r11,tmp0
3270               0059 29EA 0224  22         ai    tmp0,-4
3271                    29EC FFFC
3272               0060 29EE C154  26         mov   *tmp0,tmp1            ; Get buffer address
3273               0061 29F0 0206  20         li    tmp2,>0500            ; String length = 5
3274                    29F2 0500
3275               0062 29F4 0460  28         b     @xutstr               ; Display string
3276                    29F6 2402
3277               0063
3278               0064
3279               0065
3280               0066
3281               0067               ***************************************************************
3282               0068               * trimnum - Trim unsigned number string
3283               0069               ***************************************************************
3284               0070               *  bl   @trimnum
3285               0071               *  data p0,p1
3286               0072               *--------------------------------------------------------------
3287               0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
3288               0074               *  p1   = Pointer to output variable
3289               0075               *  p2   = Padding character to match against
3290               0076               *--------------------------------------------------------------
3291               0077               *  Copy unsigned number string into a length-padded, left
3292               0078               *  justified string for display with putstr, putat, ...
3293               0079               *
3294               0080               *  The new string starts at index 5 in buffer, overwriting
3295               0081               *  anything that is located there !
3296               0082               *
3297               0083               *  Before...:   XXXXX
3298               0084               *  After....:   XXXXX|zY       where length byte z=1
3299               0085               *               XXXXX|zYY      where length byte z=2
3300               0086               *                 ..
3301               0087               *               XXXXX|zYYYYY   where length byte z=5
3302               0088               *--------------------------------------------------------------
3303               0089               *  Destroys registers tmp0-tmp3
3304               0090               ********|*****|*********************|**************************
3305               0091               trimnum:
3306               0092 29F8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
3307               0093 29FA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
3308               0094 29FC C1BB  30         mov   *r11+,tmp2            ; Get padding character
3309               0095 29FE 06C6  14         swpb  tmp2                  ; LO <-> HI
3310               0096 2A00 0207  20         li    tmp3,5                ; Set counter
3311                    2A02 0005
3312               0097                       ;------------------------------------------------------
3313               0098                       ; Scan for padding character from left to right
3314               0099                       ;------------------------------------------------------:
3315               0100               trimnum_scan:
3316               0101 2A04 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
3317               0102 2A06 1604  14         jne   trimnum_setlen        ; No, exit loop
3318               0103 2A08 0584  14         inc   tmp0                  ; Next character
3319               0104 2A0A 0607  14         dec   tmp3                  ; Last digit reached ?
3320               0105 2A0C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
3321               0106 2A0E 10FA  14         jmp   trimnum_scan
3322               0107                       ;------------------------------------------------------
3323               0108                       ; Scan completed, set length byte new string
3324               0109                       ;------------------------------------------------------
3325               0110               trimnum_setlen:
3326               0111 2A10 06C7  14         swpb  tmp3                  ; LO <-> HI
3327               0112 2A12 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
3328               0113 2A14 06C7  14         swpb  tmp3                  ; LO <-> HI
3329               0114                       ;------------------------------------------------------
3330               0115                       ; Start filling new string
3331               0116                       ;------------------------------------------------------
3332               0117               trimnum_fill
3333               0118 2A16 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
3334               0119 2A18 0607  14         dec   tmp3                  ; Last character ?
3335               0120 2A1A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
3336               0121 2A1C 045B  20         b     *r11                  ; Return
3337               0122
3338               0123
3339               0124
3340               0125
3341               0126               ***************************************************************
3342               0127               * PUTNUM - Put unsigned number on screen
3343               0128               ***************************************************************
3344               0129               *  BL   @PUTNUM
3345               0130               *  DATA P0,P1,P2,P3
3346               0131               *--------------------------------------------------------------
3347               0132               *  P0   = YX position
3348               0133               *  P1   = Pointer to 16 bit unsigned number
3349               0134               *  P2   = Pointer to 5 byte string buffer
3350               0135               *  P3HB = Offset for ASCII digit
3351               0136               *  P3LB = Character for replacing leading 0's
3352               0137               ********|*****|*********************|**************************
3353               0138 2A1E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
3354                    2A20 832A
3355               0139 2A22 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
3356                    2A24 8000
3357               0140 2A26 10BC  14         jmp   mknum                 ; Convert number and display
3358               **** **** ****     > runlib.asm
3359               0186
3360               0190
3361               0194
3362               0198
3363               0202
3364               0206
3365               0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
3366               **** **** ****     > cpu_scrpad_backrest.asm
3367               0001               * FILE......: cpu_scrpad_backrest.asm
3368               0002               * Purpose...: Scratchpad memory backup/restore functions
3369               0003
3370               0004               *//////////////////////////////////////////////////////////////
3371               0005               *                Scratchpad memory backup/restore
3372               0006               *//////////////////////////////////////////////////////////////
3373               0007
3374               0008               ***************************************************************
3375               0009               * cpu.scrpad.backup - Backup scratchpad memory to >2000
3376               0010               ***************************************************************
3377               0011               *  bl   @cpu.scrpad.backup
3378               0012               *--------------------------------------------------------------
3379               0013               *  Register usage
3380               0014               *  r0-r2, but values restored before exit
3381               0015               *--------------------------------------------------------------
3382               0016               *  Backup scratchpad memory to destination range
3383               0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3384               0018               *
3385               0019               *  Expects current workspace to be in scratchpad memory.
3386               0020               ********|*****|*********************|**************************
3387               0021               cpu.scrpad.backup:
3388               0022 2A28 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
3389                    2A2A A000
3390               0023 2A2C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
3391                    2A2E A002
3392               0024 2A30 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
3393                    2A32 A004
3394               0025                       ;------------------------------------------------------
3395               0026                       ; Prepare for copy loop
3396               0027                       ;------------------------------------------------------
3397               0028 2A34 0200  20         li    r0,>8306              ; Scratpad source address
3398                    2A36 8306
3399               0029 2A38 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
3400                    2A3A A006
3401               0030 2A3C 0202  20         li    r2,62                 ; Loop counter
3402                    2A3E 003E
3403               0031                       ;------------------------------------------------------
3404               0032                       ; Copy memory range >8306 - >83ff
3405               0033                       ;------------------------------------------------------
3406               0034               cpu.scrpad.backup.copy:
3407               0035 2A40 CC70  46         mov   *r0+,*r1+
3408               0036 2A42 CC70  46         mov   *r0+,*r1+
3409               0037 2A44 0642  14         dect  r2
3410               0038 2A46 16FC  14         jne   cpu.scrpad.backup.copy
3411               0039 2A48 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
3412                    2A4A 83FE
3413                    2A4C A0FE
3414               0040                                                   ; Copy last word
3415               0041                       ;------------------------------------------------------
3416               0042                       ; Restore register r0 - r2
3417               0043                       ;------------------------------------------------------
3418               0044 2A4E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
3419                    2A50 A000
3420               0045 2A52 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
3421                    2A54 A002
3422               0046 2A56 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
3423                    2A58 A004
3424               0047                       ;------------------------------------------------------
3425               0048                       ; Exit
3426               0049                       ;------------------------------------------------------
3427               0050               cpu.scrpad.backup.exit:
3428               0051 2A5A 045B  20         b     *r11                  ; Return to caller
3429               0052
3430               0053
3431               0054               ***************************************************************
3432               0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
3433               0056               ***************************************************************
3434               0057               *  bl   @cpu.scrpad.restore
3435               0058               *--------------------------------------------------------------
3436               0059               *  Register usage
3437               0060               *  r0-r2, but values restored before exit
3438               0061               *--------------------------------------------------------------
3439               0062               *  Restore scratchpad from memory area
3440               0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
3441               0064               *  Current workspace can be outside scratchpad when called.
3442               0065               ********|*****|*********************|**************************
3443               0066               cpu.scrpad.restore:
3444               0067                       ;------------------------------------------------------
3445               0068                       ; Restore scratchpad >8300 - >8304
3446               0069                       ;------------------------------------------------------
3447               0070 2A5C C820  54         mov   @cpu.scrpad.tgt,@>8300
3448                    2A5E A000
3449                    2A60 8300
3450               0071 2A62 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
3451                    2A64 A002
3452                    2A66 8302
3453               0072 2A68 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
3454                    2A6A A004
3455                    2A6C 8304
3456               0073                       ;------------------------------------------------------
3457               0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
3458               0075                       ;------------------------------------------------------
3459               0076 2A6E C800  38         mov   r0,@cpu.scrpad.tgt
3460                    2A70 A000
3461               0077 2A72 C801  38         mov   r1,@cpu.scrpad.tgt + 2
3462                    2A74 A002
3463               0078 2A76 C802  38         mov   r2,@cpu.scrpad.tgt + 4
3464                    2A78 A004
3465               0079                       ;------------------------------------------------------
3466               0080                       ; Prepare for copy loop, WS
3467               0081                       ;------------------------------------------------------
3468               0082 2A7A 0200  20         li    r0,cpu.scrpad.tgt + 6
3469                    2A7C A006
3470               0083 2A7E 0201  20         li    r1,>8306
3471                    2A80 8306
3472               0084 2A82 0202  20         li    r2,62
3473                    2A84 003E
3474               0085                       ;------------------------------------------------------
3475               0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
3476               0087                       ;------------------------------------------------------
3477               0088               cpu.scrpad.restore.copy:
3478               0089 2A86 CC70  46         mov   *r0+,*r1+
3479               0090 2A88 CC70  46         mov   *r0+,*r1+
3480               0091 2A8A 0642  14         dect  r2
3481               0092 2A8C 16FC  14         jne   cpu.scrpad.restore.copy
3482               0093 2A8E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
3483                    2A90 A0FE
3484                    2A92 83FE
3485               0094                                                   ; Copy last word
3486               0095                       ;------------------------------------------------------
3487               0096                       ; Restore register r0 - r2
3488               0097                       ;------------------------------------------------------
3489               0098 2A94 C020  34         mov   @cpu.scrpad.tgt,r0
3490                    2A96 A000
3491               0099 2A98 C060  34         mov   @cpu.scrpad.tgt + 2,r1
3492                    2A9A A002
3493               0100 2A9C C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
3494                    2A9E A004
3495               0101                       ;------------------------------------------------------
3496               0102                       ; Exit
3497               0103                       ;------------------------------------------------------
3498               0104               cpu.scrpad.restore.exit:
3499               0105 2AA0 045B  20         b     *r11                  ; Return to caller
3500               **** **** ****     > runlib.asm
3501               0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
3502               **** **** ****     > cpu_scrpad_paging.asm
3503               0001               * FILE......: cpu_scrpad_paging.asm
3504               0002               * Purpose...: CPU memory paging functions
3505               0003
3506               0004               *//////////////////////////////////////////////////////////////
3507               0005               *                     CPU memory paging
3508               0006               *//////////////////////////////////////////////////////////////
3509               0007
3510               0008
3511               0009               ***************************************************************
3512               0010               * cpu.scrpad.pgout - Page out scratchpad memory
3513               0011               ***************************************************************
3514               0012               *  bl   @cpu.scrpad.pgout
3515               0013               *       DATA p0
3516               0014               *
3517               0015               *  P0 = CPU memory destination
3518               0016               *--------------------------------------------------------------
3519               0017               *  bl   @xcpu.scrpad.pgout
3520               0018               *  TMP1 = CPU memory destination
3521               0019               *--------------------------------------------------------------
3522               0020               *  Register usage
3523               0021               *  tmp0-tmp2 = Used as temporary registers
3524               0022               *  tmp3      = Copy of CPU memory destination
3525               0023               ********|*****|*********************|**************************
3526               0024               cpu.scrpad.pgout:
3527               0025 2AA2 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
3528               0026                       ;------------------------------------------------------
3529               0027                       ; Copy scratchpad memory to destination
3530               0028                       ;------------------------------------------------------
3531               0029               xcpu.scrpad.pgout:
3532               0030 2AA4 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
3533                    2AA6 8300
3534               0031 2AA8 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
3535               0032 2AAA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3536                    2AAC 0080
3537               0033                       ;------------------------------------------------------
3538               0034                       ; Copy memory
3539               0035                       ;------------------------------------------------------
3540               0036 2AAE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3541               0037 2AB0 0606  14         dec   tmp2
3542               0038 2AB2 16FD  14         jne   -!                    ; Loop until done
3543               0039                       ;------------------------------------------------------
3544               0040                       ; Switch to new workspace
3545               0041                       ;------------------------------------------------------
3546               0042 2AB4 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
3547               0043 2AB6 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
3548                    2AB8 2ABE
3549               0044                                                   ; R14=PC
3550               0045 2ABA 04CF  14         clr   r15                   ; R15=STATUS
3551               0046                       ;------------------------------------------------------
3552               0047                       ; If we get here, WS was copied to specified
3553               0048                       ; destination.  Also contents of r13,r14,r15
3554               0049                       ; are about to be overwritten by rtwp instruction.
3555               0050                       ;------------------------------------------------------
3556               0051 2ABC 0380  18         rtwp                        ; Activate copied workspace
3557               0052                                                   ; in non-scratchpad memory!
3558               0053
3559               0054               cpu.scrpad.pgout.after.rtwp:
3560               0055 2ABE 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
3561                    2AC0 2A5C
3562               0056
3563               0057                       ;------------------------------------------------------
3564               0058                       ; Exit
3565               0059                       ;------------------------------------------------------
3566               0060               cpu.scrpad.pgout.$$:
3567               0061 2AC2 045B  20         b     *r11                  ; Return to caller
3568               0062
3569               0063
3570               0064               ***************************************************************
3571               0065               * cpu.scrpad.pgin - Page in scratchpad memory
3572               0066               ***************************************************************
3573               0067               *  bl   @cpu.scrpad.pgin
3574               0068               *  DATA p0
3575               0069               *  P0 = CPU memory source
3576               0070               *--------------------------------------------------------------
3577               0071               *  bl   @memx.scrpad.pgin
3578               0072               *  TMP1 = CPU memory source
3579               0073               *--------------------------------------------------------------
3580               0074               *  Register usage
3581               0075               *  tmp0-tmp2 = Used as temporary registers
3582               0076               ********|*****|*********************|**************************
3583               0077               cpu.scrpad.pgin:
3584               0078 2AC4 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
3585               0079                       ;------------------------------------------------------
3586               0080                       ; Copy scratchpad memory to destination
3587               0081                       ;------------------------------------------------------
3588               0082               xcpu.scrpad.pgin:
3589               0083 2AC6 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
3590                    2AC8 8300
3591               0084 2ACA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
3592                    2ACC 0080
3593               0085                       ;------------------------------------------------------
3594               0086                       ; Copy memory
3595               0087                       ;------------------------------------------------------
3596               0088 2ACE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
3597               0089 2AD0 0606  14         dec   tmp2
3598               0090 2AD2 16FD  14         jne   -!                    ; Loop until done
3599               0091                       ;------------------------------------------------------
3600               0092                       ; Switch workspace to scratchpad memory
3601               0093                       ;------------------------------------------------------
3602               0094 2AD4 02E0  18         lwpi  >8300                 ; Activate copied workspace
3603                    2AD6 8300
3604               0095                       ;------------------------------------------------------
3605               0096                       ; Exit
3606               0097                       ;------------------------------------------------------
3607               0098               cpu.scrpad.pgin.$$:
3608               0099 2AD8 045B  20         b     *r11                  ; Return to caller
3609               **** **** ****     > runlib.asm
3610               0211
3611               0213                       copy  "equ_fio.asm"              ; File I/O equates
3612               **** **** ****     > equ_fio.asm
3613               0001               * FILE......: equ_fio.asm
3614               0002               * Purpose...: Equates for file I/O operations
3615               0003
3616               0004               ***************************************************************
3617               0005               * File IO operations
3618               0006               ************************************@**************************
3619               0007      0000     io.op.open       equ >00            ; OPEN
3620               0008      0001     io.op.close      equ >01            ; CLOSE
3621               0009      0002     io.op.read       equ >02            ; READ
3622               0010      0003     io.op.write      equ >03            ; WRITE
3623               0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
3624               0012      0005     io.op.load       equ >05            ; LOAD
3625               0013      0006     io.op.save       equ >06            ; SAVE
3626               0014      0007     io.op.delfile    equ >07            ; DELETE FILE
3627               0015      0008     io.op.scratch    equ >08            ; SCRATCH
3628               0016      0009     io.op.status     equ >09            ; STATUS
3629               0017               ***************************************************************
3630               0018               * File types - All relative files are fixed length
3631               0019               ************************************@**************************
3632               0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
3633               0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
3634               0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
3635               0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
3636               0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
3637               0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
3638               0026               ***************************************************************
3639               0027               * File types - Sequential files
3640               0028               ************************************@**************************
3641               0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
3642               0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
3643               0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
3644               0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
3645               0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
3646               0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
3647               0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
3648               0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
3649               0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
3650               0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
3651               0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
3652               0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
3653               0041
3654               0042               ***************************************************************
3655               0043               * File error codes - Bits 13-15 in PAB byte 1
3656               0044               ************************************@**************************
3657               0045      0000     io.err.no_error_occured             equ 0
3658               0046                       ; Error code 0 with condition bit reset, indicates that
3659               0047                       ; no error has occured
3660               0048
3661               0049      0000     io.err.bad_device_name              equ 0
3662               0050                       ; Device indicated not in system
3663               0051                       ; Error code 0 with condition bit set, indicates a
3664               0052                       ; device not present in system
3665               0053
3666               0054      0001     io.err.device_write_prottected      equ 1
3667               0055                       ; Device is write protected
3668               0056
3669               0057      0002     io.err.bad_open_attribute           equ 2
3670               0058                       ; One or more of the OPEN attributes are illegal or do
3671               0059                       ; not match the file's actual characteristics.
3672               0060                       ; This could be:
3673               0061                       ;   * File type
3674               0062                       ;   * Record length
3675               0063                       ;   * I/O mode
3676               0064                       ;   * File organization
3677               0065
3678               0066      0003     io.err.illegal_operation            equ 3
3679               0067                       ; Either an issued I/O command was not supported, or a
3680               0068                       ; conflict with the OPEN mode has occured
3681               0069
3682               0070      0004     io.err.out_of_table_buffer_space    equ 4
3683               0071                       ; The amount of space left on the device is insufficient
3684               0072                       ; for the requested operation
3685               0073
3686               0074      0005     io.err.eof                          equ 5
3687               0075                       ; Attempt to read past end of file.
3688               0076                       ; This error may also be given for non-existing records
3689               0077                       ; in a relative record file
3690               0078
3691               0079      0006     io.err.device_error                 equ 6
3692               0080                       ; Covers all hard device errors, such as parity and
3693               0081                       ; bad medium errors
3694               0082
3695               0083      0007     io.err.file_error                   equ 7
3696               0084                       ; Covers all file-related error like: program/data
3697               0085                       ; file mismatch, non-existing file opened for input mode, etc.
3698               **** **** ****     > runlib.asm
3699               0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
3700               **** **** ****     > fio_dsrlnk.asm
3701               0001               * FILE......: fio_dsrlnk.asm
3702               0002               * Purpose...: Custom DSRLNK implementation
3703               0003
3704               0004               *//////////////////////////////////////////////////////////////
3705               0005               *                          DSRLNK
3706               0006               *//////////////////////////////////////////////////////////////
3707               0007
3708               0008
3709               0009               ***************************************************************
3710               0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
3711               0011               ***************************************************************
3712               0012               *  blwp @dsrlnk
3713               0013               *  data p0
3714               0014               *--------------------------------------------------------------
3715               0015               *  P0 = 8 or 10 (a)
3716               0016               *--------------------------------------------------------------
3717               0017               *  Output:
3718               0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
3719               0019               *--------------------------------------------------------------
3720               0020               ; Spectra2 scratchpad memory needs to be paged out before.
3721               0021               ; You need to specify following equates in main program
3722               0022               ;
3723               0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
3724               0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
3725               0025               ;
3726               0026               ; Scratchpad memory usage
3727               0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
3728               0028               ; >8356            Pointer to PAB
3729               0029               ; >83D0            CRU address of current device
3730               0030               ; >83D2            DSR entry address
3731               0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
3732               0032               ;
3733               0033               ; Credits
3734               0034               ; Originally appeared in Miller Graphics The Smart Programmer.
3735               0035               ; This version based on version of Paolo Bagnaresi.
3736               0036               *--------------------------------------------------------------
3737               0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
3738               0038                                                   ; dstype is address of R5 of DSRLNK ws
3739               0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
3740               0040               ********|*****|*********************|**************************
3741               0041 2ADA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
3742               0042 2ADC 2ADE             data  dsrlnk.init           ; entry point
3743               0043                       ;------------------------------------------------------
3744               0044                       ; DSRLNK entry point
3745               0045                       ;------------------------------------------------------
3746               0046               dsrlnk.init:
3747               0047 2ADE C17E  30         mov   *r14+,r5              ; get pgm type for link
3748               0048 2AE0 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
3749                    2AE2 8322
3750               0049 2AE4 53E0  34         szcb  @hb$20,r15            ; reset equal bit
3751                    2AE6 2026
3752               0050 2AE8 C020  34         mov   @>8356,r0             ; get ptr to pab
3753                    2AEA 8356
3754               0051 2AEC C240  18         mov   r0,r9                 ; save ptr
3755               0052                       ;------------------------------------------------------
3756               0053                       ; Fetch file descriptor length from PAB
3757               0054                       ;------------------------------------------------------
3758               0055 2AEE 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
3759                    2AF0 FFF8
3760               0056
3761               0057                       ;---------------------------; Inline VSBR start
3762               0058 2AF2 06C0  14         swpb  r0                    ;
3763               0059 2AF4 D800  38         movb  r0,@vdpa              ; send low byte
3764                    2AF6 8C02
3765               0060 2AF8 06C0  14         swpb  r0                    ;
3766               0061 2AFA D800  38         movb  r0,@vdpa              ; send high byte
3767                    2AFC 8C02
3768               0062 2AFE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
3769                    2B00 8800
3770               0063                       ;---------------------------; Inline VSBR end
3771               0064 2B02 0983  56         srl   r3,8                  ; Move to low byte
3772               0065
3773               0066                       ;------------------------------------------------------
3774               0067                       ; Fetch file descriptor device name from PAB
3775               0068                       ;------------------------------------------------------
3776               0069 2B04 0704  14         seto  r4                    ; init counter
3777               0070 2B06 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
3778                    2B08 A420
3779               0071 2B0A 0580  14 !       inc   r0                    ; point to next char of name
3780               0072 2B0C 0584  14         inc   r4                    ; incr char counter
3781               0073 2B0E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
3782                    2B10 0007
3783               0074 2B12 1565  14         jgt   dsrlnk.error.devicename_invalid
3784               0075                                                   ; yes, error
3785               0076 2B14 80C4  18         c     r4,r3                 ; end of name?
3786               0077 2B16 130C  14         jeq   dsrlnk.device_name.get_length
3787               0078                                                   ; yes
3788               0079
3789               0080                       ;---------------------------; Inline VSBR start
3790               0081 2B18 06C0  14         swpb  r0                    ;
3791               0082 2B1A D800  38         movb  r0,@vdpa              ; send low byte
3792                    2B1C 8C02
3793               0083 2B1E 06C0  14         swpb  r0                    ;
3794               0084 2B20 D800  38         movb  r0,@vdpa              ; send high byte
3795                    2B22 8C02
3796               0085 2B24 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
3797                    2B26 8800
3798               0086                       ;---------------------------; Inline VSBR end
3799               0087
3800               0088                       ;------------------------------------------------------
3801               0089                       ; Look for end of device name, for example "DSK1."
3802               0090                       ;------------------------------------------------------
3803               0091 2B28 DC81  32         movb  r1,*r2+               ; move into buffer
3804               0092 2B2A 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
3805                    2B2C 2BEE
3806               0093 2B2E 16ED  14         jne   -!                    ; no, loop next char
3807               0094                       ;------------------------------------------------------
3808               0095                       ; Determine device name length
3809               0096                       ;------------------------------------------------------
3810               0097               dsrlnk.device_name.get_length:
3811               0098 2B30 C104  18         mov   r4,r4                 ; Check if length = 0
3812               0099 2B32 1355  14         jeq   dsrlnk.error.devicename_invalid
3813               0100                                                   ; yes, error
3814               0101 2B34 04E0  34         clr   @>83d0
3815                    2B36 83D0
3816               0102 2B38 C804  38         mov   r4,@>8354             ; save name length for search
3817                    2B3A 8354
3818               0103 2B3C 0584  14         inc   r4                    ; adjust for dot
3819               0104 2B3E A804  38         a     r4,@>8356             ; point to position after name
3820                    2B40 8356
3821               0105                       ;------------------------------------------------------
3822               0106                       ; Prepare for DSR scan >1000 - >1f00
3823               0107                       ;------------------------------------------------------
3824               0108               dsrlnk.dsrscan.start:
3825               0109 2B42 02E0  18         lwpi  >83e0                 ; Use GPL WS
3826                    2B44 83E0
3827               0110 2B46 04C1  14         clr   r1                    ; version found of dsr
3828               0111 2B48 020C  20         li    r12,>0f00             ; init cru addr
3829                    2B4A 0F00
3830               0112                       ;------------------------------------------------------
3831               0113                       ; Turn off ROM on current card
3832               0114                       ;------------------------------------------------------
3833               0115               dsrlnk.dsrscan.cardoff:
3834               0116 2B4C C30C  18         mov   r12,r12               ; anything to turn off?
3835               0117 2B4E 1301  14         jeq   dsrlnk.dsrscan.cardloop
3836               0118                                                   ; no, loop over cards
3837               0119 2B50 1E00  20         sbz   0                     ; yes, turn off
3838               0120                       ;------------------------------------------------------
3839               0121                       ; Loop over cards and look if DSR present
3840               0122                       ;------------------------------------------------------
3841               0123               dsrlnk.dsrscan.cardloop:
3842               0124 2B52 022C  22         ai    r12,>0100             ; next rom to turn on
3843                    2B54 0100
3844               0125 2B56 04E0  34         clr   @>83d0                ; clear in case we are done
3845                    2B58 83D0
3846               0126 2B5A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
3847                    2B5C 2000
3848               0127 2B5E 133D  14         jeq   dsrlnk.error.nodsr_found
3849               0128                                                   ; yes, no matching DSR found
3850               0129 2B60 C80C  38         mov   r12,@>83d0            ; save addr of next cru
3851                    2B62 83D0
3852               0130                       ;------------------------------------------------------
3853               0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
3854               0132                       ;------------------------------------------------------
3855               0133 2B64 1D00  20         sbo   0                     ; turn on rom
3856               0134 2B66 0202  20         li    r2,>4000              ; start at beginning of rom
3857                    2B68 4000
3858               0135 2B6A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
3859                    2B6C 2BEA
3860               0136 2B6E 16EE  14         jne   dsrlnk.dsrscan.cardoff
3861               0137                                                   ; no rom found on card
3862               0138                       ;------------------------------------------------------
3863               0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
3864               0140                       ;------------------------------------------------------
3865               0141                       ; dstype is the address of R5 of the DSRLNK workspace,
3866               0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
3867               0143                       ; is stored before the DSR ROM is searched.
3868               0144                       ;------------------------------------------------------
3869               0145 2B70 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
3870                    2B72 A40A
3871               0146 2B74 1003  14         jmp   dsrlnk.dsrscan.getentry
3872               0147                       ;------------------------------------------------------
3873               0148                       ; Next DSR entry
3874               0149                       ;------------------------------------------------------
3875               0150               dsrlnk.dsrscan.nextentry:
3876               0151 2B76 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
3877                    2B78 83D2
3878               0152                                                   ; subprogram
3879               0153
3880               0154 2B7A 1D00  20         sbo   0                     ; turn rom back on
3881               0155                       ;------------------------------------------------------
3882               0156                       ; Get DSR entry
3883               0157                       ;------------------------------------------------------
3884               0158               dsrlnk.dsrscan.getentry:
3885               0159 2B7C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
3886               0160 2B7E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
3887               0161                                                   ; yes, no more DSRs or programs to check
3888               0162 2B80 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
3889                    2B82 83D2
3890               0163                                                   ; subprogram
3891               0164
3892               0165 2B84 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
3893               0166                                                   ; DSR/subprogram code
3894               0167
3895               0168 2B86 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
3896               0169                                                   ; offset 4 (DSR/subprogram name)
3897               0170                       ;------------------------------------------------------
3898               0171                       ; Check file descriptor in DSR
3899               0172                       ;------------------------------------------------------
3900               0173 2B88 04C5  14         clr   r5                    ; Remove any old stuff
3901               0174 2B8A D160  34         movb  @>8355,r5             ; get length as counter
3902                    2B8C 8355
3903               0175 2B8E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
3904               0176                                                   ; if zero, do not further check, call DSR
3905               0177                                                   ; program
3906               0178
3907               0179 2B90 9C85  32         cb    r5,*r2+               ; see if length matches
3908               0180 2B92 16F1  14         jne   dsrlnk.dsrscan.nextentry
3909               0181                                                   ; no, length does not match. Go process next
3910               0182                                                   ; DSR entry
3911               0183
3912               0184 2B94 0985  56         srl   r5,8                  ; yes, move to low byte
3913               0185 2B96 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
3914                    2B98 A420
3915               0186 2B9A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
3916               0187                                                   ; DSR ROM
3917               0188 2B9C 16EC  14         jne   dsrlnk.dsrscan.nextentry
3918               0189                                                   ; try next DSR entry if no match
3919               0190 2B9E 0605  14         dec   r5                    ; loop until full length checked
3920               0191 2BA0 16FC  14         jne   -!
3921               0192                       ;------------------------------------------------------
3922               0193                       ; Device name/Subprogram match
3923               0194                       ;------------------------------------------------------
3924               0195               dsrlnk.dsrscan.match:
3925               0196 2BA2 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
3926                    2BA4 83D2
3927               0197
3928               0198                       ;------------------------------------------------------
3929               0199                       ; Call DSR program in device card
3930               0200                       ;------------------------------------------------------
3931               0201               dsrlnk.dsrscan.call_dsr:
3932               0202 2BA6 0581  14         inc   r1                    ; next version found
3933               0203 2BA8 0699  24         bl    *r9                   ; go run routine
3934               0204                       ;
3935               0205                       ; Depending on IO result the DSR in card ROM does RET
3936               0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
3937               0207                       ;
3938               0208 2BAA 10E5  14         jmp   dsrlnk.dsrscan.nextentry
3939               0209                                                   ; (1) error return
3940               0210 2BAC 1E00  20         sbz   0                     ; (2) turn off rom if good return
3941               0211 2BAE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
3942                    2BB0 A400
3943               0212 2BB2 C009  18         mov   r9,r0                 ; point to flag in pab
3944               0213 2BB4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
3945                    2BB6 8322
3946               0214                                                   ; (8 or >a)
3947               0215 2BB8 0281  22         ci    r1,8                  ; was it 8?
3948                    2BBA 0008
3949               0216 2BBC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
3950               0217 2BBE D060  34         movb  @>8350,r1             ; no, we have a data >a.
3951                    2BC0 8350
3952               0218                                                   ; Get error byte from @>8350
3953               0219 2BC2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
3954               0220
3955               0221                       ;------------------------------------------------------
3956               0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
3957               0223                       ;------------------------------------------------------
3958               0224               dsrlnk.dsrscan.dsr.8:
3959               0225                       ;---------------------------; Inline VSBR start
3960               0226 2BC4 06C0  14         swpb  r0                    ;
3961               0227 2BC6 D800  38         movb  r0,@vdpa              ; send low byte
3962                    2BC8 8C02
3963               0228 2BCA 06C0  14         swpb  r0                    ;
3964               0229 2BCC D800  38         movb  r0,@vdpa              ; send high byte
3965                    2BCE 8C02
3966               0230 2BD0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
3967                    2BD2 8800
3968               0231                       ;---------------------------; Inline VSBR end
3969               0232
3970               0233                       ;------------------------------------------------------
3971               0234                       ; Return DSR error to caller
3972               0235                       ;------------------------------------------------------
3973               0236               dsrlnk.dsrscan.dsr.a:
3974               0237 2BD4 09D1  56         srl   r1,13                 ; just keep error bits
3975               0238 2BD6 1604  14         jne   dsrlnk.error.io_error
3976               0239                                                   ; handle IO error
3977               0240 2BD8 0380  18         rtwp                        ; Return from DSR workspace to caller
3978               0241                                                   ; workspace
3979               0242
3980               0243                       ;------------------------------------------------------
3981               0244                       ; IO-error handler
3982               0245                       ;------------------------------------------------------
3983               0246               dsrlnk.error.nodsr_found:
3984               0247 2BDA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
3985                    2BDC A400
3986               0248               dsrlnk.error.devicename_invalid:
3987               0249 2BDE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
3988               0250               dsrlnk.error.io_error:
3989               0251 2BE0 06C1  14         swpb  r1                    ; put error in hi byte
3990               0252 2BE2 D741  30         movb  r1,*r13               ; store error flags in callers r0
3991               0253 2BE4 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
3992                    2BE6 2026
3993               0254 2BE8 0380  18         rtwp                        ; Return from DSR workspace to caller
3994               0255                                                   ; workspace
3995               0256
3996               0257               ********************************************************************************
3997               0258
3998               0259 2BEA AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
3999               0260 2BEC 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
4000               0261                                                   ; a @blwp @dsrlnk
4001               0262 2BEE ....     dsrlnk.period     text  '.'         ; For finding end of device name
4002               0263
4003               0264                       even
4004               **** **** ****     > runlib.asm
4005               0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
4006               **** **** ****     > fio_level2.asm
4007               0001               * FILE......: fio_level2.asm
4008               0002               * Purpose...: File I/O level 2 support
4009               0003
4010               0004
4011               0005               ***************************************************************
4012               0006               * PAB  - Peripheral Access Block
4013               0007               ********|*****|*********************|**************************
4014               0008               ; my_pab:
4015               0009               ;       byte  io.op.open            ;  0    - OPEN
4016               0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
4017               0011               ;                                   ;         Bit 13-15 used by DSR for returning
4018               0012               ;                                   ;         file error details to DSRLNK
4019               0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
4020               0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
4021               0015               ;       byte  0                     ;  5    - Character count (bytes read)
4022               0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
4023               0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
4024               0018               ; -------------------------------------------------------------
4025               0019               ;       byte  11                    ;  9    - File descriptor length
4026               0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
4027               0021               ;       even
4028               0022               ***************************************************************
4029               0023
4030               0024
4031               0025               ***************************************************************
4032               0026               * file.open - Open File for procesing
4033               0027               ***************************************************************
4034               0028               *  bl   @file.open
4035               0029               *  data P0
4036               0030               *--------------------------------------------------------------
4037               0031               *  P0 = Address of PAB in VDP RAM
4038               0032               *--------------------------------------------------------------
4039               0033               *  bl   @xfile.open
4040               0034               *
4041               0035               *  R0 = Address of PAB in VDP RAM
4042               0036               *--------------------------------------------------------------
4043               0037               *  Output:
4044               0038               *  tmp0 LSB = VDP PAB byte 1 (status)
4045               0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4046               0040               *  tmp2     = Status register contents upon DSRLNK return
4047               0041               ********|*****|*********************|**************************
4048               0042               file.open:
4049               0043 2BF0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4050               0044               *--------------------------------------------------------------
4051               0045               * Initialisation
4052               0046               *--------------------------------------------------------------
4053               0047               xfile.open:
4054               0048 2BF2 C04B  18         mov   r11,r1                ; Save return address
4055               0049 2BF4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4056                    2BF6 A428
4057               0050 2BF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4058               0051 2BFA 04C5  14         clr   tmp1                  ; io.op.open
4059               0052 2BFC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4060                    2BFE 22AC
4061               0053               file.open_init:
4062               0054 2C00 0220  22         ai    r0,9                  ; Move to file descriptor length
4063                    2C02 0009
4064               0055 2C04 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4065                    2C06 8356
4066               0056               *--------------------------------------------------------------
4067               0057               * Main
4068               0058               *--------------------------------------------------------------
4069               0059               file.open_main:
4070               0060 2C08 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4071                    2C0A 2ADA
4072               0061 2C0C 0008             data  8                     ; Level 2 IO call
4073               0062               *--------------------------------------------------------------
4074               0063               * Exit
4075               0064               *--------------------------------------------------------------
4076               0065               file.open_exit:
4077               0066 2C0E 1029  14         jmp   file.record.pab.details
4078               0067                                                   ; Get status and return to caller
4079               0068                                                   ; Status register bits are unaffected
4080               0069
4081               0070
4082               0071
4083               0072               ***************************************************************
4084               0073               * file.close - Close currently open file
4085               0074               ***************************************************************
4086               0075               *  bl   @file.close
4087               0076               *  data P0
4088               0077               *--------------------------------------------------------------
4089               0078               *  P0 = Address of PAB in VDP RAM
4090               0079               *--------------------------------------------------------------
4091               0080               *  bl   @xfile.close
4092               0081               *
4093               0082               *  R0 = Address of PAB in VDP RAM
4094               0083               *--------------------------------------------------------------
4095               0084               *  Output:
4096               0085               *  tmp0 LSB = VDP PAB byte 1 (status)
4097               0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4098               0087               *  tmp2     = Status register contents upon DSRLNK return
4099               0088               ********|*****|*********************|**************************
4100               0089               file.close:
4101               0090 2C10 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4102               0091               *--------------------------------------------------------------
4103               0092               * Initialisation
4104               0093               *--------------------------------------------------------------
4105               0094               xfile.close:
4106               0095 2C12 C04B  18         mov   r11,r1                ; Save return address
4107               0096 2C14 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4108                    2C16 A428
4109               0097 2C18 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4110               0098 2C1A 0205  20         li    tmp1,io.op.close      ; io.op.close
4111                    2C1C 0001
4112               0099 2C1E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4113                    2C20 22AC
4114               0100               file.close_init:
4115               0101 2C22 0220  22         ai    r0,9                  ; Move to file descriptor length
4116                    2C24 0009
4117               0102 2C26 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4118                    2C28 8356
4119               0103               *--------------------------------------------------------------
4120               0104               * Main
4121               0105               *--------------------------------------------------------------
4122               0106               file.close_main:
4123               0107 2C2A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4124                    2C2C 2ADA
4125               0108 2C2E 0008             data  8                     ;
4126               0109               *--------------------------------------------------------------
4127               0110               * Exit
4128               0111               *--------------------------------------------------------------
4129               0112               file.close_exit:
4130               0113 2C30 1018  14         jmp   file.record.pab.details
4131               0114                                                   ; Get status and return to caller
4132               0115                                                   ; Status register bits are unaffected
4133               0116
4134               0117
4135               0118
4136               0119
4137               0120
4138               0121               ***************************************************************
4139               0122               * file.record.read - Read record from file
4140               0123               ***************************************************************
4141               0124               *  bl   @file.record.read
4142               0125               *  data P0
4143               0126               *--------------------------------------------------------------
4144               0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
4145               0128               *--------------------------------------------------------------
4146               0129               *  bl   @xfile.record.read
4147               0130               *
4148               0131               *  R0 = Address of PAB in VDP RAM
4149               0132               *--------------------------------------------------------------
4150               0133               *  Output:
4151               0134               *  tmp0 LSB = VDP PAB byte 1 (status)
4152               0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4153               0136               *  tmp2     = Status register contents upon DSRLNK return
4154               0137               ********|*****|*********************|**************************
4155               0138               file.record.read:
4156               0139 2C32 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
4157               0140               *--------------------------------------------------------------
4158               0141               * Initialisation
4159               0142               *--------------------------------------------------------------
4160               0143               xfile.record.read:
4161               0144 2C34 C04B  18         mov   r11,r1                ; Save return address
4162               0145 2C36 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
4163                    2C38 A428
4164               0146 2C3A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
4165               0147 2C3C 0205  20         li    tmp1,io.op.read       ; io.op.read
4166                    2C3E 0002
4167               0148 2C40 06A0  32         bl    @xvputb               ; Write file opcode to VDP
4168                    2C42 22AC
4169               0149               file.record.read_init:
4170               0150 2C44 0220  22         ai    r0,9                  ; Move to file descriptor length
4171                    2C46 0009
4172               0151 2C48 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
4173                    2C4A 8356
4174               0152               *--------------------------------------------------------------
4175               0153               * Main
4176               0154               *--------------------------------------------------------------
4177               0155               file.record.read_main:
4178               0156 2C4C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
4179                    2C4E 2ADA
4180               0157 2C50 0008             data  8                     ;
4181               0158               *--------------------------------------------------------------
4182               0159               * Exit
4183               0160               *--------------------------------------------------------------
4184               0161               file.record.read_exit:
4185               0162 2C52 1007  14         jmp   file.record.pab.details
4186               0163                                                   ; Get status and return to caller
4187               0164                                                   ; Status register bits are unaffected
4188               0165
4189               0166
4190               0167
4191               0168
4192               0169               file.record.write:
4193               0170 2C54 1000  14         nop
4194               0171
4195               0172
4196               0173               file.record.seek:
4197               0174 2C56 1000  14         nop
4198               0175
4199               0176
4200               0177               file.image.load:
4201               0178 2C58 1000  14         nop
4202               0179
4203               0180
4204               0181               file.image.save:
4205               0182 2C5A 1000  14         nop
4206               0183
4207               0184
4208               0185               file.delete:
4209               0186 2C5C 1000  14         nop
4210               0187
4211               0188
4212               0189               file.rename:
4213               0190 2C5E 1000  14         nop
4214               0191
4215               0192
4216               0193               file.status:
4217               0194 2C60 1000  14         nop
4218               0195
4219               0196
4220               0197
4221               0198               ***************************************************************
4222               0199               * file.record.pab.details - Return PAB details to caller
4223               0200               ***************************************************************
4224               0201               * Called internally via JMP/B by file operations
4225               0202               *--------------------------------------------------------------
4226               0203               *  Output:
4227               0204               *  tmp0 LSB = VDP PAB byte 1 (status)
4228               0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
4229               0206               *  tmp2     = Status register contents upon DSRLNK return
4230               0207               ********|*****|*********************|**************************
4231               0208
4232               0209               ********|*****|*********************|**************************
4233               0210               file.record.pab.details:
4234               0211 2C62 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
4235               0212                                                   ; Upon DSRLNK return status register EQ bit
4236               0213                                                   ; 1 = No file error
4237               0214                                                   ; 0 = File error occured
4238               0215               *--------------------------------------------------------------
4239               0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
4240               0217               *--------------------------------------------------------------
4241               0218 2C64 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
4242                    2C66 A428
4243               0219 2C68 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
4244                    2C6A 0005
4245               0220 2C6C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
4246                    2C6E 22C4
4247               0221 2C70 C144  18         mov   tmp0,tmp1             ; Move to destination
4248               0222               *--------------------------------------------------------------
4249               0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
4250               0224               *--------------------------------------------------------------
4251               0225 2C72 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
4252               0226                                                   ; as returned by DSRLNK
4253               0227               *--------------------------------------------------------------
4254               0228               * Exit
4255               0229               *--------------------------------------------------------------
4256               0230               ; If an error occured during the IO operation, then the
4257               0231               ; equal bit in the saved status register (=tmp2) is set to 1.
4258               0232               ;
4259               0233               ; If no error occured during the IO operation, then the
4260               0234               ; equal bit in the saved status register (=tmp2) is set to 0.
4261               0235               ;
4262               0236               ; Upon return from this IO call you should basically test with:
4263               0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
4264               0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
4265               0239               ;
4266               0240               ; Then look for further details in the copy of VDP PAB byte 1
4267               0241               ; in register tmp0, bits 13-15
4268               0242               ;
4269               0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
4270               0244               ;                                   ; calls, skip for type >A subprograms!)
4271               0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
4272               0246               ;       jeq   my_error_handler
4273               0247               *--------------------------------------------------------------
4274               0248               file.record.pab.details.exit:
4275               0249 2C74 0451  20         b     *r1                   ; Return to caller
4276               **** **** ****     > runlib.asm
4277               0217
4278               0218               *//////////////////////////////////////////////////////////////
4279               0219               *                            TIMERS
4280               0220               *//////////////////////////////////////////////////////////////
4281               0221
4282               0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
4283               **** **** ****     > timers_tmgr.asm
4284               0001               * FILE......: timers_tmgr.asm
4285               0002               * Purpose...: Timers / Thread scheduler
4286               0003
4287               0004               ***************************************************************
4288               0005               * TMGR - X - Start Timers/Thread scheduler
4289               0006               ***************************************************************
4290               0007               *  B @TMGR
4291               0008               *--------------------------------------------------------------
4292               0009               *  REMARKS
4293               0010               *  Timer/Thread scheduler. Normally called from MAIN.
4294               0011               *  This is basically the kernel keeping everything togehter.
4295               0012               *  Do not forget to set BTIHI to highest slot in use.
4296               0013               *
4297               0014               *  Register usage in TMGR8 - TMGR11
4298               0015               *  TMP0  = Pointer to timer table
4299               0016               *  R10LB = Use as slot counter
4300               0017               *  TMP2  = 2nd word of slot data
4301               0018               *  TMP3  = Address of routine to call
4302               0019               ********|*****|*********************|**************************
4303               0020 2C76 0300  24 tmgr    limi  0                     ; No interrupt processing
4304                    2C78 0000
4305               0021               *--------------------------------------------------------------
4306               0022               * Read VDP status register
4307               0023               *--------------------------------------------------------------
4308               0024 2C7A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
4309                    2C7C 8802
4310               0025               *--------------------------------------------------------------
4311               0026               * Latch sprite collision flag
4312               0027               *--------------------------------------------------------------
4313               0028 2C7E 2360  38         coc   @wbit2,r13            ; C flag on ?
4314                    2C80 2026
4315               0029 2C82 1602  14         jne   tmgr1a                ; No, so move on
4316               0030 2C84 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
4317                    2C86 2012
4318               0031               *--------------------------------------------------------------
4319               0032               * Interrupt flag
4320               0033               *--------------------------------------------------------------
4321               0034 2C88 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
4322                    2C8A 202A
4323               0035 2C8C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
4324               0036               *--------------------------------------------------------------
4325               0037               * Run speech player
4326               0038               *--------------------------------------------------------------
4327               0044               *--------------------------------------------------------------
4328               0045               * Run kernel thread
4329               0046               *--------------------------------------------------------------
4330               0047 2C8E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
4331                    2C90 201A
4332               0048 2C92 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
4333               0049 2C94 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
4334                    2C96 2018
4335               0050 2C98 1602  14         jne   tmgr3                 ; No, skip to user hook
4336               0051 2C9A 0460  28         b     @kthread              ; Run kernel thread
4337                    2C9C 2D14
4338               0052               *--------------------------------------------------------------
4339               0053               * Run user hook
4340               0054               *--------------------------------------------------------------
4341               0055 2C9E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
4342                    2CA0 201E
4343               0056 2CA2 13EB  14         jeq   tmgr1
4344               0057 2CA4 20A0  38         coc   @wbit7,config         ; User hook enabled ?
4345                    2CA6 201C
4346               0058 2CA8 16E8  14         jne   tmgr1
4347               0059 2CAA C120  34         mov   @wtiusr,tmp0
4348                    2CAC 832E
4349               0060 2CAE 0454  20         b     *tmp0                 ; Run user hook
4350               0061               *--------------------------------------------------------------
4351               0062               * Do internal housekeeping
4352               0063               *--------------------------------------------------------------
4353               0064 2CB0 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
4354                    2CB2 2D12
4355               0065 2CB4 C10A  18         mov   r10,tmp0
4356               0066 2CB6 0244  22         andi  tmp0,>00ff            ; Clear HI byte
4357                    2CB8 00FF
4358               0067 2CBA 20A0  38         coc   @wbit2,config         ; PAL flag set ?
4359                    2CBC 2026
4360               0068 2CBE 1303  14         jeq   tmgr5
4361               0069 2CC0 0284  22         ci    tmp0,60               ; 1 second reached ?
4362                    2CC2 003C
4363               0070 2CC4 1002  14         jmp   tmgr6
4364               0071 2CC6 0284  22 tmgr5   ci    tmp0,50
4365                    2CC8 0032
4366               0072 2CCA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
4367               0073 2CCC 1001  14         jmp   tmgr8
4368               0074 2CCE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
4369               0075               *--------------------------------------------------------------
4370               0076               * Loop over slots
4371               0077               *--------------------------------------------------------------
4372               0078 2CD0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
4373                    2CD2 832C
4374               0079 2CD4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
4375                    2CD6 FF00
4376               0080 2CD8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
4377               0081 2CDA 1316  14         jeq   tmgr11                ; Yes, get next slot
4378               0082               *--------------------------------------------------------------
4379               0083               *  Check if slot should be executed
4380               0084               *--------------------------------------------------------------
4381               0085 2CDC 05C4  14         inct  tmp0                  ; Second word of slot data
4382               0086 2CDE 0594  26         inc   *tmp0                 ; Update tick count in slot
4383               0087 2CE0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
4384               0088 2CE2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
4385                    2CE4 830C
4386                    2CE6 830D
4387               0089 2CE8 1608  14         jne   tmgr10                ; No, get next slot
4388               0090 2CEA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
4389                    2CEC FF00
4390               0091 2CEE C506  30         mov   tmp2,*tmp0            ; Update timer table
4391               0092               *--------------------------------------------------------------
4392               0093               *  Run slot, we only need TMP0 to survive
4393               0094               *--------------------------------------------------------------
4394               0095 2CF0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
4395                    2CF2 8330
4396               0096 2CF4 0697  24         bl    *tmp3                 ; Call routine in slot
4397               0097 2CF6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
4398                    2CF8 8330
4399               0098               *--------------------------------------------------------------
4400               0099               *  Prepare for next slot
4401               0100               *--------------------------------------------------------------
4402               0101 2CFA 058A  14 tmgr10  inc   r10                   ; Next slot
4403               0102 2CFC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
4404                    2CFE 8315
4405                    2D00 8314
4406               0103 2D02 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
4407               0104 2D04 05C4  14         inct  tmp0                  ; Offset for next slot
4408               0105 2D06 10E8  14         jmp   tmgr9                 ; Process next slot
4409               0106 2D08 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
4410               0107 2D0A 10F7  14         jmp   tmgr10                ; Process next slot
4411               0108 2D0C 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
4412                    2D0E FF00
4413               0109 2D10 10B4  14         jmp   tmgr1
4414               0110 2D12 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
4415               0111
4416               **** **** ****     > runlib.asm
4417               0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
4418               **** **** ****     > timers_kthread.asm
4419               0001               * FILE......: timers_kthread.asm
4420               0002               * Purpose...: Timers / The kernel thread
4421               0003
4422               0004
4423               0005               ***************************************************************
4424               0006               * KTHREAD - The kernel thread
4425               0007               *--------------------------------------------------------------
4426               0008               *  REMARKS
4427               0009               *  You should not call the kernel thread manually.
4428               0010               *  Instead control it via the CONFIG register.
4429               0011               *
4430               0012               *  The kernel thread is responsible for running the sound
4431               0013               *  player and doing keyboard scan.
4432               0014               ********|*****|*********************|**************************
4433               0015 2D14 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
4434                    2D16 201A
4435               0016               *--------------------------------------------------------------
4436               0017               * Run sound player
4437               0018               *--------------------------------------------------------------
4438               0020               *       <<skipped>>
4439               0026               *--------------------------------------------------------------
4440               0027               * Scan virtual keyboard
4441               0028               *--------------------------------------------------------------
4442               0029               kthread_kb
4443               0031               *       <<skipped>>
4444               0035               *--------------------------------------------------------------
4445               0036               * Scan real keyboard
4446               0037               *--------------------------------------------------------------
4447               0041 2D18 06A0  32         bl    @realkb               ; Scan full keyboard
4448                    2D1A 27BA
4449               0043               *--------------------------------------------------------------
4450               0044               kthread_exit
4451               0045 2D1C 0460  28         b     @tmgr3                ; Exit
4452                    2D1E 2C9E
4453               **** **** ****     > runlib.asm
4454               0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
4455               **** **** ****     > timers_hooks.asm
4456               0001               * FILE......: timers_kthread.asm
4457               0002               * Purpose...: Timers / User hooks
4458               0003
4459               0004
4460               0005               ***************************************************************
4461               0006               * MKHOOK - Allocate user hook
4462               0007               ***************************************************************
4463               0008               *  BL    @MKHOOK
4464               0009               *  DATA  P0
4465               0010               *--------------------------------------------------------------
4466               0011               *  P0 = Address of user hook
4467               0012               *--------------------------------------------------------------
4468               0013               *  REMARKS
4469               0014               *  The user hook gets executed after the kernel thread.
4470               0015               *  The user hook must always exit with "B @HOOKOK"
4471               0016               ********|*****|*********************|**************************
4472               0017 2D20 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
4473                    2D22 832E
4474               0018 2D24 E0A0  34         soc   @wbit7,config         ; Enable user hook
4475                    2D26 201C
4476               0019 2D28 045B  20 mkhoo1  b     *r11                  ; Return
4477               0020      2C7A     hookok  equ   tmgr1                 ; Exit point for user hook
4478               0021
4479               0022
4480               0023               ***************************************************************
4481               0024               * CLHOOK - Clear user hook
4482               0025               ***************************************************************
4483               0026               *  BL    @CLHOOK
4484               0027               ********|*****|*********************|**************************
4485               0028 2D2A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
4486                    2D2C 832E
4487               0029 2D2E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
4488                    2D30 FEFF
4489               0030 2D32 045B  20         b     *r11                  ; Return
4490               **** **** ****     > runlib.asm
4491               0225
4492               0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
4493               **** **** ****     > timers_alloc.asm
4494               0001               * FILE......: timer_alloc.asm
4495               0002               * Purpose...: Timers / Timer allocation
4496               0003
4497               0004
4498               0005               ***************************************************************
4499               0006               * MKSLOT - Allocate timer slot(s)
4500               0007               ***************************************************************
4501               0008               *  BL    @MKSLOT
4502               0009               *  BYTE  P0HB,P0LB
4503               0010               *  DATA  P1
4504               0011               *  ....
4505               0012               *  DATA  EOL                        ; End-of-list
4506               0013               *--------------------------------------------------------------
4507               0014               *  P0 = Slot number, target count
4508               0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
4509               0016               ********|*****|*********************|**************************
4510               0017 2D34 C13B  30 mkslot  mov   *r11+,tmp0
4511               0018 2D36 C17B  30         mov   *r11+,tmp1
4512               0019               *--------------------------------------------------------------
4513               0020               *  Calculate address of slot
4514               0021               *--------------------------------------------------------------
4515               0022 2D38 C184  18         mov   tmp0,tmp2
4516               0023 2D3A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
4517               0024 2D3C A1A0  34         a     @wtitab,tmp2          ; Add table base
4518                    2D3E 832C
4519               0025               *--------------------------------------------------------------
4520               0026               *  Add slot to table
4521               0027               *--------------------------------------------------------------
4522               0028 2D40 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
4523               0029 2D42 0A84  56         sla   tmp0,8                ; Get rid of slot number
4524               0030 2D44 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
4525               0031               *--------------------------------------------------------------
4526               0032               *  Check for end of list
4527               0033               *--------------------------------------------------------------
4528               0034 2D46 881B  46         c     *r11,@w$ffff          ; End of list ?
4529                    2D48 202C
4530               0035 2D4A 1301  14         jeq   mkslo1                ; Yes, exit
4531               0036 2D4C 10F3  14         jmp   mkslot                ; Process next entry
4532               0037               *--------------------------------------------------------------
4533               0038               *  Exit
4534               0039               *--------------------------------------------------------------
4535               0040 2D4E 05CB  14 mkslo1  inct  r11
4536               0041 2D50 045B  20         b     *r11                  ; Exit
4537               0042
4538               0043
4539               0044               ***************************************************************
4540               0045               * CLSLOT - Clear single timer slot
4541               0046               ***************************************************************
4542               0047               *  BL    @CLSLOT
4543               0048               *  DATA  P0
4544               0049               *--------------------------------------------------------------
4545               0050               *  P0 = Slot number
4546               0051               ********|*****|*********************|**************************
4547               0052 2D52 C13B  30 clslot  mov   *r11+,tmp0
4548               0053 2D54 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
4549               0054 2D56 A120  34         a     @wtitab,tmp0          ; Add table base
4550                    2D58 832C
4551               0055 2D5A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
4552               0056 2D5C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
4553               0057 2D5E 045B  20         b     *r11                  ; Exit
4554               **** **** ****     > runlib.asm
4555               0229
4556               0230
4557               0231
4558               0232               *//////////////////////////////////////////////////////////////
4559               0233               *                    RUNLIB INITIALISATION
4560               0234               *//////////////////////////////////////////////////////////////
4561               0235
4562               0236               ***************************************************************
4563               0237               *  RUNLIB - Runtime library initalisation
4564               0238               ***************************************************************
4565               0239               *  B  @RUNLIB
4566               0240               *--------------------------------------------------------------
4567               0241               *  REMARKS
4568               0242               *  if R0 in WS1 equals >4a4a we were called from the system
4569               0243               *  crash handler so we return there after initialisation.
4570               0244
4571               0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
4572               0246               *  after clearing scratchpad memory. This has higher priority
4573               0247               *  as crash handler flag R0.
4574               0248               ********|*****|*********************|**************************
4575               0250 2D60 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
4576                    2D62 2A28
4577               0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
4578               0252
4579               0253 2D64 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
4580                    2D66 8302
4581               0257               *--------------------------------------------------------------
4582               0258               * Alternative entry point
4583               0259               *--------------------------------------------------------------
4584               0260 2D68 0300  24 runli1  limi  0                     ; Turn off interrupts
4585                    2D6A 0000
4586               0261 2D6C 02E0  18         lwpi  ws1                   ; Activate workspace 1
4587                    2D6E 8300
4588               0262 2D70 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
4589                    2D72 83C0
4590               0263               *--------------------------------------------------------------
4591               0264               * Clear scratch-pad memory from R4 upwards
4592               0265               *--------------------------------------------------------------
4593               0266 2D74 0202  20 runli2  li    r2,>8308
4594                    2D76 8308
4595               0267 2D78 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
4596               0268 2D7A 0282  22         ci    r2,>8400
4597                    2D7C 8400
4598               0269 2D7E 16FC  14         jne   runli3
4599               0270               *--------------------------------------------------------------
4600               0271               * Exit to TI-99/4A title screen ?
4601               0272               *--------------------------------------------------------------
4602               0273 2D80 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
4603                    2D82 FFFF
4604               0274 2D84 1602  14         jne   runli4                ; No, continue
4605               0275 2D86 0420  54         blwp  @0                    ; Yes, bye bye
4606                    2D88 0000
4607               0276               *--------------------------------------------------------------
4608               0277               * Determine if VDP is PAL or NTSC
4609               0278               *--------------------------------------------------------------
4610               0279 2D8A C803  38 runli4  mov   r3,@waux1             ; Store random seed
4611                    2D8C 833C
4612               0280 2D8E 04C1  14         clr   r1                    ; Reset counter
4613               0281 2D90 0202  20         li    r2,10                 ; We test 10 times
4614                    2D92 000A
4615               0282 2D94 C0E0  34 runli5  mov   @vdps,r3
4616                    2D96 8802
4617               0283 2D98 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
4618                    2D9A 202A
4619               0284 2D9C 1302  14         jeq   runli6
4620               0285 2D9E 0581  14         inc   r1                    ; Increase counter
4621               0286 2DA0 10F9  14         jmp   runli5
4622               0287 2DA2 0602  14 runli6  dec   r2                    ; Next test
4623               0288 2DA4 16F7  14         jne   runli5
4624               0289 2DA6 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
4625                    2DA8 1250
4626               0290 2DAA 1202  14         jle   runli7                ; No, so it must be NTSC
4627               0291 2DAC 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
4628                    2DAE 2026
4629               0292               *--------------------------------------------------------------
4630               0293               * Copy machine code to scratchpad (prepare tight loop)
4631               0294               *--------------------------------------------------------------
4632               0295 2DB0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
4633                    2DB2 2200
4634               0296 2DB4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
4635                    2DB6 8322
4636               0297 2DB8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
4637               0298 2DBA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
4638               0299 2DBC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
4639               0300               *--------------------------------------------------------------
4640               0301               * Initialize registers, memory, ...
4641               0302               *--------------------------------------------------------------
4642               0303 2DBE 04C1  14 runli9  clr   r1
4643               0304 2DC0 04C2  14         clr   r2
4644               0305 2DC2 04C3  14         clr   r3
4645               0306 2DC4 0209  20         li    stack,>8400           ; Set stack
4646                    2DC6 8400
4647               0307 2DC8 020F  20         li    r15,vdpw              ; Set VDP write address
4648                    2DCA 8C00
4649               0311               *--------------------------------------------------------------
4650               0312               * Setup video memory
4651               0313               *--------------------------------------------------------------
4652               0315 2DCC 0280  22         ci    r0,>4a4a              ; Crash flag set?
4653                    2DCE 4A4A
4654               0316 2DD0 1605  14         jne   runlia
4655               0317 2DD2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
4656                    2DD4 226E
4657               0318 2DD6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
4658                    2DD8 0000
4659                    2DDA 3FFF
4660               0323 2DDC 06A0  32 runlia  bl    @filv
4661                    2DDE 226E
4662               0324 2DE0 0FC0             data  pctadr,spfclr,16      ; Load color table
4663                    2DE2 00F4
4664                    2DE4 0010
4665               0325               *--------------------------------------------------------------
4666               0326               * Check if there is a F18A present
4667               0327               *--------------------------------------------------------------
4668               0331 2DE6 06A0  32         bl    @f18unl               ; Unlock the F18A
4669                    2DE8 26B2
4670               0332 2DEA 06A0  32         bl    @f18chk               ; Check if F18A is there
4671                    2DEC 26CC
4672               0333 2DEE 06A0  32         bl    @f18lck               ; Lock the F18A again
4673                    2DF0 26C2
4674               0335               *--------------------------------------------------------------
4675               0336               * Check if there is a speech synthesizer attached
4676               0337               *--------------------------------------------------------------
4677               0339               *       <<skipped>>
4678               0343               *--------------------------------------------------------------
4679               0344               * Load video mode table & font
4680               0345               *--------------------------------------------------------------
4681               0346 2DF2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
4682                    2DF4 22D8
4683               0347 2DF6 21F6             data  spvmod                ; Equate selected video mode table
4684               0348 2DF8 0204  20         li    tmp0,spfont           ; Get font option
4685                    2DFA 000C
4686               0349 2DFC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
4687               0350 2DFE 1304  14         jeq   runlid                ; Yes, skip it
4688               0351 2E00 06A0  32         bl    @ldfnt
4689                    2E02 2340
4690               0352 2E04 1100             data  fntadr,spfont         ; Load specified font
4691                    2E06 000C
4692               0353               *--------------------------------------------------------------
4693               0354               * Did a system crash occur before runlib was called?
4694               0355               *--------------------------------------------------------------
4695               0356 2E08 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
4696                    2E0A 4A4A
4697               0357 2E0C 1602  14         jne   runlie                ; No, continue
4698               0358 2E0E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
4699                    2E10 2090
4700               0359               *--------------------------------------------------------------
4701               0360               * Branch to main program
4702               0361               *--------------------------------------------------------------
4703               0362 2E12 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
4704                    2E14 0040
4705               0363 2E16 0460  28         b     @main                 ; Give control to main program
4706                    2E18 6050
4707               **** **** ****     > tivi_b1.asm.31428
4708               0022                                                   ; Relocated spectra2 in low memory expansion
4709               0023                                                   ; was loaded into RAM from bank 0.
4710               0024                                                   ;
4711               0025                                                   ; Only including it here, so that all
4712               0026                                                   ; references get satisfied during assembly.
4713               0027               ***************************************************************
4714               0028               * TiVi entry point after spectra2 initialisation
4715               0029               ********|*****|*********************|**************************
4716               0030                       aorg  kickstart.code2
4717               0031               main:
4718               0032 6050 04E0  34         clr   @>6002                ; Jump to bank 1
4719                    6052 6002
4720               0033 6054 0460  28         b     @main.tivi            ; Start editor
4721                    6056 6058
4722               0034                       ;-----------------------------------------------------------------------
4723               0035                       ; Include files
4724               0036                       ;-----------------------------------------------------------------------
4725               0037                       copy  "main.asm"            ; Main file (entrypoint)
4726               **** **** ****     > main.asm
4727               0001               * FILE......: main.asm
4728               0002               * Purpose...: TiVi Editor - Main editor module
4729               0003
4730               0004               *//////////////////////////////////////////////////////////////
4731               0005               *            TiVi Editor - Main editor module
4732               0006               *//////////////////////////////////////////////////////////////
4733               0007
4734               0008
4735               0009               ***************************************************************
4736               0010               * main
4737               0011               * Initialize editor
4738               0012               ***************************************************************
4739               0013               * b   @main.tivi
4740               0014               *--------------------------------------------------------------
4741               0015               * INPUT
4742               0016               * none
4743               0017               *--------------------------------------------------------------
4744               0018               * OUTPUT
4745               0019               * none
4746               0020               *--------------------------------------------------------------
4747               0021               * Register usage
4748               0022               * -
4749               0023               *--------------------------------------------------------------
4750               0024               * Notes
4751               0025               * Main entry point for TiVi editor
4752               0026               ***************************************************************
4753               0027
4754               0028
4755               0029               ***************************************************************
4756               0030               * Main
4757               0031               ********|*****|*********************|**************************
4758               0032               main.tivi:
4759               0033 6058 20A0  38         coc   @wbit1,config         ; F18a detected?
4760                    605A 2028
4761               0034 605C 1302  14         jeq   main.continue
4762               0035 605E 0420  54         blwp  @0                    ; Exit for now if no F18a detected
4763                    6060 0000
4764               0036
4765               0037               main.continue:
4766               0038 6062 06A0  32         bl    @scroff               ; Turn screen off
4767                    6064 260E
4768               0039 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
4769                    6068 26B2
4770               0040 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
4771                    606C 2312
4772               0041 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
4773               0042                       ;------------------------------------------------------
4774               0043                       ; Initialize VDP SIT
4775               0044                       ;------------------------------------------------------
4776               0045 6070 06A0  32         bl    @filv
4777                    6072 226E
4778               0046 6074 0000                   data >0000,32,31*80   ; Clear VDP SIT
4779                    6076 0020
4780                    6078 09B0
4781               0047 607A 06A0  32         bl    @scron                ; Turn screen on
4782                    607C 2616
4783               0048                       ;------------------------------------------------------
4784               0049                       ; Initialize high memory expansion
4785               0050                       ;------------------------------------------------------
4786               0051 607E 06A0  32         bl    @film
4787                    6080 2216
4788               0052 6082 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
4789                    6084 0000
4790                    6086 6000
4791               0053                       ;------------------------------------------------------
4792               0054                       ; Load SAMS default memory layout
4793               0055                       ;------------------------------------------------------
4794               0056 6088 06A0  32         bl    @mem.setup.sams.layout
4795                    608A 6732
4796               0057                                                   ; Initialize SAMS layout
4797               0058                       ;------------------------------------------------------
4798               0059                       ; Setup cursor, screen, etc.
4799               0060                       ;------------------------------------------------------
4800               0061 608C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
4801                    608E 262E
4802               0062 6090 06A0  32         bl    @s8x8                 ; Small sprite
4803                    6092 263E
4804               0063
4805               0064 6094 06A0  32         bl    @cpym2m
4806                    6096 2460
4807               0065 6098 72B8                   data romsat,ramsat,4  ; Load sprite SAT
4808                    609A 8380
4809                    609C 0004
4810               0066
4811               0067 609E C820  54         mov   @romsat+2,@tv.curshape
4812                    60A0 72BA
4813                    60A2 A214
4814               0068                                                   ; Save cursor shape & color
4815               0069
4816               0070 60A4 06A0  32         bl    @cpym2v
4817                    60A6 2418
4818               0071 60A8 1800                   data sprpdt,cursors,3*8
4819                    60AA 72BC
4820                    60AC 0018
4821               0072                                                   ; Load sprite cursor patterns
4822               0073
4823               0074 60AE 06A0  32         bl    @cpym2v
4824                    60B0 2418
4825               0075 60B2 1008                   data >1008,patterns,11*8
4826                    60B4 72D4
4827                    60B6 0058
4828               0076                                                   ; Load character patterns
4829               0077               *--------------------------------------------------------------
4830               0078               * Initialize
4831               0079               *--------------------------------------------------------------
4832               0080 60B8 06A0  32         bl    @tivi.init            ; Initialize TiVi editor config
4833                    60BA 6726
4834               0081 60BC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
4835                    60BE 6BB8
4836               0082 60C0 06A0  32         bl    @edb.init             ; Initialize editor buffer
4837                    60C2 69D2
4838               0083 60C4 06A0  32         bl    @idx.init             ; Initialize index
4839                    60C6 68FA
4840               0084 60C8 06A0  32         bl    @fb.init              ; Initialize framebuffer
4841                    60CA 67C8
4842               0085                       ;-------------------------------------------------------
4843               0086                       ; Setup editor tasks & hook
4844               0087                       ;-------------------------------------------------------
4845               0088 60CC 0204  20         li    tmp0,>0200
4846                    60CE 0200
4847               0089 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
4848                    60D2 8314
4849               0090
4850               0091 60D4 06A0  32         bl    @at
4851                    60D6 264E
4852               0092 60D8 0100                   data  >0100           ; Cursor YX position = >0000
4853               0093
4854               0094 60DA 0204  20         li    tmp0,timers
4855                    60DC 8370
4856               0095 60DE C804  38         mov   tmp0,@wtitab
4857                    60E0 832C
4858               0096
4859               0097 60E2 06A0  32         bl    @mkslot
4860                    60E4 2D34
4861               0098 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
4862                    60E8 7034
4863               0099 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
4864                    60EC 711E
4865               0100 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
4866                    60F0 7152
4867               0101 60F2 FFFF                   data eol
4868               0102
4869               0103 60F4 06A0  32         bl    @mkhook
4870                    60F6 2D20
4871               0104 60F8 7004                   data hook.keyscan     ; Setup user hook
4872               0105
4873               0106 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
4874                    60FC 2C76
4875               0107
4876               0108
4877               **** **** ****     > tivi_b1.asm.31428
4878               0038                       copy  "edkey.asm"           ; Keyboard actions
4879               **** **** ****     > edkey.asm
4880               0001               * FILE......: edkey.asm
4881               0002               * Purpose...: Process keyboard key press. Shared code for all panes
4882               0003
4883               0004
4884               0005               ****************************************************************
4885               0006               * Editor - Process action keys
4886               0007               ****************************************************************
4887               0008               edkey.key.process:
4888               0009 60FE C160  34         mov   @waux1,tmp1           ; Get key value
4889                    6100 833C
4890               0010 6102 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
4891                    6104 FF00
4892               0011 6106 0707  14         seto  tmp3                  ; EOL marker
4893               0012
4894               0013 6108 C1A0  34         mov   @tv.pane.focus,tmp2
4895                    610A A216
4896               0014 610C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
4897                    610E 0000
4898               0015 6110 1307  14         jeq   edkey.key.process.loadmap.editor
4899               0016                                                   ; Yes, so load editor keymap
4900               0017
4901               0018 6112 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
4902                    6114 0001
4903               0019 6116 1307  14         jeq   edkey.key.process.loadmap.cmdb
4904               0020                                                   ; Yes, so load CMDB keymap
4905               0021                       ;-------------------------------------------------------
4906               0022                       ; Pane without focus, crash
4907               0023                       ;-------------------------------------------------------
4908               0024 6118 C80B  38         mov   r11,@>ffce            ; \ Save caller address
4909                    611A FFCE
4910               0025 611C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
4911                    611E 2030
4912               0026                       ;-------------------------------------------------------
4913               0027                       ; Use editor keyboard map
4914               0028                       ;-------------------------------------------------------
4915               0029               edkey.key.process.loadmap.editor:
4916               0030 6120 0206  20         li    tmp2,keymap_actions.editor
4917                    6122 777E
4918               0031 6124 1003  14         jmp   edkey.key.check_next
4919               0032                       ;-------------------------------------------------------
4920               0033                       ; Use CMDB keyboard map
4921               0034                       ;-------------------------------------------------------
4922               0035               edkey.key.process.loadmap.cmdb:
4923               0036 6126 0206  20         li    tmp2,keymap_actions.cmdb
4924                    6128 7840
4925               0037 612A 1600  14         jne   edkey.key.check_next
4926               0038                       ;-------------------------------------------------------
4927               0039                       ; Iterate over keyboard map for matching action key
4928               0040                       ;-------------------------------------------------------
4929               0041               edkey.key.check_next:
4930               0042 612C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
4931               0043 612E 1309  14         jeq   edkey.key.process.addbuffer
4932               0044                                                   ; Yes, means no action key pressed, so
4933               0045                                                   ; add character to buffer
4934               0046                       ;-------------------------------------------------------
4935               0047                       ; Check for action key match
4936               0048                       ;-------------------------------------------------------
4937               0049 6130 8585  30         c     tmp1,*tmp2            ; Action key matched?
4938               0050 6132 1303  14         jeq   edkey.key.process.action
4939               0051                                                   ; Yes, do action
4940               0052 6134 0226  22         ai    tmp2,6                ; Skip current entry
4941                    6136 0006
4942               0053 6138 10F9  14         jmp   edkey.key.check_next  ; Check next entry
4943               0054                       ;-------------------------------------------------------
4944               0055                       ; Trigger keyboard action
4945               0056                       ;-------------------------------------------------------
4946               0057               edkey.key.process.action:
4947               0058 613A 0226  22         ai    tmp2,4                ; Move to action address
4948                    613C 0004
4949               0059 613E C196  26         mov   *tmp2,tmp2            ; Get action address
4950               0060 6140 0456  20         b     *tmp2                 ; Process key action
4951               0061                       ;-------------------------------------------------------
4952               0062                       ; Add character to buffer
4953               0063                       ;-------------------------------------------------------
4954               0064               edkey.key.process.addbuffer:
4955               0065 6142 C120  34         mov  @tv.pane.focus,tmp0    ; Framebuffer has focus?
4956                    6144 A216
4957               0066 6146 1602  14         jne  !
4958               0067                       ;-------------------------------------------------------
4959               0068                       ; Frame buffer
4960               0069                       ;-------------------------------------------------------
4961               0070 6148 0460  28         b    @edkey.action.char     ; Add character to buffer
4962                    614A 65E6
4963               0071                       ;-------------------------------------------------------
4964               0072                       ; CMDB buffer
4965               0073                       ;-------------------------------------------------------
4966               0074 614C 0285  22 !       ci   tmp1,pane.focus.cmdb   ; CMDB has focus ?
4967                    614E 0001
4968               0075 6150 1602  14         jne  edkey.key.process.crash
4969               0076 6152 0460  28         b    @edkey.cmdb.action.char
4970                    6154 6716
4971               0077                                                   ; Add character to buffer
4972               0078                       ;-------------------------------------------------------
4973               0079                       ; Crash
4974               0080                       ;-------------------------------------------------------
4975               0081               edkey.key.process.crash:
4976               0082 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
4977                    6158 FFCE
4978               0083 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
4979                    615C 2030
4980               **** **** ****     > tivi_b1.asm.31428
4981               0039                       copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys
4982               **** **** ****     > edkey.fb.mov.asm
4983               0001               * FILE......: edkey.fb.mov.asm
4984               0002               * Purpose...: Actions for movement keys in frame buffer pane.
4985               0003
4986               0004
4987               0005               *---------------------------------------------------------------
4988               0006               * Cursor left
4989               0007               *---------------------------------------------------------------
4990               0008               edkey.action.left:
4991               0009 615E C120  34         mov   @fb.column,tmp0
4992                    6160 A28C
4993               0010 6162 1306  14         jeq   !                     ; column=0 ? Skip further processing
4994               0011                       ;-------------------------------------------------------
4995               0012                       ; Update
4996               0013                       ;-------------------------------------------------------
4997               0014 6164 0620  34         dec   @fb.column            ; Column-- in screen buffer
4998                    6166 A28C
4999               0015 6168 0620  34         dec   @wyx                  ; Column-- VDP cursor
5000                    616A 832A
5001               0016 616C 0620  34         dec   @fb.current
5002                    616E A282
5003               0017                       ;-------------------------------------------------------
5004               0018                       ; Exit
5005               0019                       ;-------------------------------------------------------
5006               0020 6170 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5007                    6172 7028
5008               0021
5009               0022
5010               0023               *---------------------------------------------------------------
5011               0024               * Cursor right
5012               0025               *---------------------------------------------------------------
5013               0026               edkey.action.right:
5014               0027 6174 8820  54         c     @fb.column,@fb.row.length
5015                    6176 A28C
5016                    6178 A288
5017               0028 617A 1406  14         jhe   !                     ; column > length line ? Skip processing
5018               0029                       ;-------------------------------------------------------
5019               0030                       ; Update
5020               0031                       ;-------------------------------------------------------
5021               0032 617C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
5022                    617E A28C
5023               0033 6180 05A0  34         inc   @wyx                  ; Column++ VDP cursor
5024                    6182 832A
5025               0034 6184 05A0  34         inc   @fb.current
5026                    6186 A282
5027               0035                       ;-------------------------------------------------------
5028               0036                       ; Exit
5029               0037                       ;-------------------------------------------------------
5030               0038 6188 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5031                    618A 7028
5032               0039
5033               0040
5034               0041               *---------------------------------------------------------------
5035               0042               * Cursor up
5036               0043               *---------------------------------------------------------------
5037               0044               edkey.action.up:
5038               0045                       ;-------------------------------------------------------
5039               0046                       ; Crunch current line if dirty
5040               0047                       ;-------------------------------------------------------
5041               0048 618C 8820  54         c     @fb.row.dirty,@w$ffff
5042                    618E A28A
5043                    6190 202C
5044               0049 6192 1604  14         jne   edkey.action.up.cursor
5045               0050 6194 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5046                    6196 6A02
5047               0051 6198 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5048                    619A A28A
5049               0052                       ;-------------------------------------------------------
5050               0053                       ; Move cursor
5051               0054                       ;-------------------------------------------------------
5052               0055               edkey.action.up.cursor:
5053               0056 619C C120  34         mov   @fb.row,tmp0
5054                    619E A286
5055               0057 61A0 1509  14         jgt   edkey.action.up.cursor_up
5056               0058                                                   ; Move cursor up if fb.row > 0
5057               0059 61A2 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
5058                    61A4 A284
5059               0060 61A6 130A  14         jeq   edkey.action.up.set_cursorx
5060               0061                                                   ; At top, only position cursor X
5061               0062                       ;-------------------------------------------------------
5062               0063                       ; Scroll 1 line
5063               0064                       ;-------------------------------------------------------
5064               0065 61A8 0604  14         dec   tmp0                  ; fb.topline--
5065               0066 61AA C804  38         mov   tmp0,@parm1
5066                    61AC 8350
5067               0067 61AE 06A0  32         bl    @fb.refresh           ; Scroll one line up
5068                    61B0 683A
5069               0068 61B2 1004  14         jmp   edkey.action.up.set_cursorx
5070               0069                       ;-------------------------------------------------------
5071               0070                       ; Move cursor up
5072               0071                       ;-------------------------------------------------------
5073               0072               edkey.action.up.cursor_up:
5074               0073 61B4 0620  34         dec   @fb.row               ; Row-- in screen buffer
5075                    61B6 A286
5076               0074 61B8 06A0  32         bl    @up                   ; Row-- VDP cursor
5077                    61BA 265C
5078               0075                       ;-------------------------------------------------------
5079               0076                       ; Check line length and position cursor
5080               0077                       ;-------------------------------------------------------
5081               0078               edkey.action.up.set_cursorx:
5082               0079 61BC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
5083                    61BE 6B9A
5084               0080 61C0 8820  54         c     @fb.column,@fb.row.length
5085                    61C2 A28C
5086                    61C4 A288
5087               0081 61C6 1207  14         jle   edkey.action.up.exit
5088               0082                       ;-------------------------------------------------------
5089               0083                       ; Adjust cursor column position
5090               0084                       ;-------------------------------------------------------
5091               0085 61C8 C820  54         mov   @fb.row.length,@fb.column
5092                    61CA A288
5093                    61CC A28C
5094               0086 61CE C120  34         mov   @fb.column,tmp0
5095                    61D0 A28C
5096               0087 61D2 06A0  32         bl    @xsetx                ; Set VDP cursor X
5097                    61D4 2666
5098               0088                       ;-------------------------------------------------------
5099               0089                       ; Exit
5100               0090                       ;-------------------------------------------------------
5101               0091               edkey.action.up.exit:
5102               0092 61D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5103                    61D8 681E
5104               0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5105                    61DC 7028
5106               0094
5107               0095
5108               0096
5109               0097               *---------------------------------------------------------------
5110               0098               * Cursor down
5111               0099               *---------------------------------------------------------------
5112               0100               edkey.action.down:
5113               0101 61DE 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
5114                    61E0 A286
5115                    61E2 A304
5116               0102 61E4 1330  14         jeq   !                     ; Yes, skip further processing
5117               0103                       ;-------------------------------------------------------
5118               0104                       ; Crunch current row if dirty
5119               0105                       ;-------------------------------------------------------
5120               0106 61E6 8820  54         c     @fb.row.dirty,@w$ffff
5121                    61E8 A28A
5122                    61EA 202C
5123               0107 61EC 1604  14         jne   edkey.action.down.move
5124               0108 61EE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5125                    61F0 6A02
5126               0109 61F2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5127                    61F4 A28A
5128               0110                       ;-------------------------------------------------------
5129               0111                       ; Move cursor
5130               0112                       ;-------------------------------------------------------
5131               0113               edkey.action.down.move:
5132               0114                       ;-------------------------------------------------------
5133               0115                       ; EOF reached?
5134               0116                       ;-------------------------------------------------------
5135               0117 61F6 C120  34         mov   @fb.topline,tmp0
5136                    61F8 A284
5137               0118 61FA A120  34         a     @fb.row,tmp0
5138                    61FC A286
5139               0119 61FE 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
5140                    6200 A304
5141               0120 6202 1312  14         jeq   edkey.action.down.set_cursorx
5142               0121                                                   ; Yes, only position cursor X
5143               0122                       ;-------------------------------------------------------
5144               0123                       ; Check if scrolling required
5145               0124                       ;-------------------------------------------------------
5146               0125 6204 C120  34         mov   @fb.scrrows,tmp0
5147                    6206 A298
5148               0126 6208 0604  14         dec   tmp0
5149               0127 620A 8120  34         c     @fb.row,tmp0
5150                    620C A286
5151               0128 620E 1108  14         jlt   edkey.action.down.cursor
5152               0129                       ;-------------------------------------------------------
5153               0130                       ; Scroll 1 line
5154               0131                       ;-------------------------------------------------------
5155               0132 6210 C820  54         mov   @fb.topline,@parm1
5156                    6212 A284
5157                    6214 8350
5158               0133 6216 05A0  34         inc   @parm1
5159                    6218 8350
5160               0134 621A 06A0  32         bl    @fb.refresh
5161                    621C 683A
5162               0135 621E 1004  14         jmp   edkey.action.down.set_cursorx
5163               0136                       ;-------------------------------------------------------
5164               0137                       ; Move cursor down a row, there are still rows left
5165               0138                       ;-------------------------------------------------------
5166               0139               edkey.action.down.cursor:
5167               0140 6220 05A0  34         inc   @fb.row               ; Row++ in screen buffer
5168                    6222 A286
5169               0141 6224 06A0  32         bl    @down                 ; Row++ VDP cursor
5170                    6226 2654
5171               0142                       ;-------------------------------------------------------
5172               0143                       ; Check line length and position cursor
5173               0144                       ;-------------------------------------------------------
5174               0145               edkey.action.down.set_cursorx:
5175               0146 6228 06A0  32         bl    @edb.line.getlength2  ; Get length current line
5176                    622A 6B9A
5177               0147
5178               0148 622C 8820  54         c     @fb.column,@fb.row.length
5179                    622E A28C
5180                    6230 A288
5181               0149 6232 1207  14         jle   edkey.action.down.exit
5182               0150                                                   ; Exit
5183               0151                       ;-------------------------------------------------------
5184               0152                       ; Adjust cursor column position
5185               0153                       ;-------------------------------------------------------
5186               0154 6234 C820  54         mov   @fb.row.length,@fb.column
5187                    6236 A288
5188                    6238 A28C
5189               0155 623A C120  34         mov   @fb.column,tmp0
5190                    623C A28C
5191               0156 623E 06A0  32         bl    @xsetx                ; Set VDP cursor X
5192                    6240 2666
5193               0157                       ;-------------------------------------------------------
5194               0158                       ; Exit
5195               0159                       ;-------------------------------------------------------
5196               0160               edkey.action.down.exit:
5197               0161 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5198                    6244 681E
5199               0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5200                    6248 7028
5201               0163
5202               0164
5203               0165
5204               0166               *---------------------------------------------------------------
5205               0167               * Cursor beginning of line
5206               0168               *---------------------------------------------------------------
5207               0169               edkey.action.home:
5208               0170 624A C120  34         mov   @wyx,tmp0
5209                    624C 832A
5210               0171 624E 0244  22         andi  tmp0,>ff00
5211                    6250 FF00
5212               0172 6252 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
5213                    6254 832A
5214               0173 6256 04E0  34         clr   @fb.column
5215                    6258 A28C
5216               0174 625A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5217                    625C 681E
5218               0175 625E 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
5219                    6260 7028
5220               0176
5221               0177               *---------------------------------------------------------------
5222               0178               * Cursor end of line
5223               0179               *---------------------------------------------------------------
5224               0180               edkey.action.end:
5225               0181 6262 C120  34         mov   @fb.row.length,tmp0
5226                    6264 A288
5227               0182 6266 C804  38         mov   tmp0,@fb.column
5228                    6268 A28C
5229               0183 626A 06A0  32         bl    @xsetx                ; Set VDP cursor column position
5230                    626C 2666
5231               0184 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5232                    6270 681E
5233               0185 6272 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
5234                    6274 7028
5235               0186
5236               0187
5237               0188
5238               0189               *---------------------------------------------------------------
5239               0190               * Cursor beginning of word or previous word
5240               0191               *---------------------------------------------------------------
5241               0192               edkey.action.pword:
5242               0193 6276 C120  34         mov   @fb.column,tmp0
5243                    6278 A28C
5244               0194 627A 1324  14         jeq   !                     ; column=0 ? Skip further processing
5245               0195                       ;-------------------------------------------------------
5246               0196                       ; Prepare 2 char buffer
5247               0197                       ;-------------------------------------------------------
5248               0198 627C C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
5249                    627E A282
5250               0199 6280 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
5251               0200 6282 1003  14         jmp   edkey.action.pword_scan_char
5252               0201                       ;-------------------------------------------------------
5253               0202                       ; Scan backwards to first character following space
5254               0203                       ;-------------------------------------------------------
5255               0204               edkey.action.pword_scan
5256               0205 6284 0605  14         dec   tmp1
5257               0206 6286 0604  14         dec   tmp0                  ; Column-- in screen buffer
5258               0207 6288 1315  14         jeq   edkey.action.pword_done
5259               0208                                                   ; Column=0 ? Skip further processing
5260               0209                       ;-------------------------------------------------------
5261               0210                       ; Check character
5262               0211                       ;-------------------------------------------------------
5263               0212               edkey.action.pword_scan_char
5264               0213 628A D195  26         movb  *tmp1,tmp2            ; Get character
5265               0214 628C 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
5266               0215 628E D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
5267               0216 6290 0986  56         srl   tmp2,8                ; Right justify
5268               0217 6292 0286  22         ci    tmp2,32               ; Space character found?
5269                    6294 0020
5270               0218 6296 16F6  14         jne   edkey.action.pword_scan
5271               0219                                                   ; No space found, try again
5272               0220                       ;-------------------------------------------------------
5273               0221                       ; Space found, now look closer
5274               0222                       ;-------------------------------------------------------
5275               0223 6298 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
5276                    629A 2020
5277               0224 629C 13F3  14         jeq   edkey.action.pword_scan
5278               0225                                                   ; Yes, so continue scanning
5279               0226 629E 0287  22         ci    tmp3,>20ff            ; First character is space
5280                    62A0 20FF
5281               0227 62A2 13F0  14         jeq   edkey.action.pword_scan
5282               0228                       ;-------------------------------------------------------
5283               0229                       ; Check distance travelled
5284               0230                       ;-------------------------------------------------------
5285               0231 62A4 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
5286                    62A6 A28C
5287               0232 62A8 61C4  18         s     tmp0,tmp3
5288               0233 62AA 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
5289                    62AC 0002
5290               0234 62AE 11EA  14         jlt   edkey.action.pword_scan
5291               0235                                                   ; Didn't move enough so keep on scanning
5292               0236                       ;--------------------------------------------------------
5293               0237                       ; Set cursor following space
5294               0238                       ;--------------------------------------------------------
5295               0239 62B0 0585  14         inc   tmp1
5296               0240 62B2 0584  14         inc   tmp0                  ; Column++ in screen buffer
5297               0241                       ;-------------------------------------------------------
5298               0242                       ; Save position and position hardware cursor
5299               0243                       ;-------------------------------------------------------
5300               0244               edkey.action.pword_done:
5301               0245 62B4 C805  38         mov   tmp1,@fb.current
5302                    62B6 A282
5303               0246 62B8 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
5304                    62BA A28C
5305               0247 62BC 06A0  32         bl    @xsetx                ; Set VDP cursor X
5306                    62BE 2666
5307               0248                       ;-------------------------------------------------------
5308               0249                       ; Exit
5309               0250                       ;-------------------------------------------------------
5310               0251               edkey.action.pword.exit:
5311               0252 62C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5312                    62C2 681E
5313               0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5314                    62C6 7028
5315               0254
5316               0255
5317               0256
5318               0257               *---------------------------------------------------------------
5319               0258               * Cursor next word
5320               0259               *---------------------------------------------------------------
5321               0260               edkey.action.nword:
5322               0261 62C8 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
5323               0262 62CA C120  34         mov   @fb.column,tmp0
5324                    62CC A28C
5325               0263 62CE 8804  38         c     tmp0,@fb.row.length
5326                    62D0 A288
5327               0264 62D2 1428  14         jhe   !                     ; column=last char ? Skip further processing
5328               0265                       ;-------------------------------------------------------
5329               0266                       ; Prepare 2 char buffer
5330               0267                       ;-------------------------------------------------------
5331               0268 62D4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
5332                    62D6 A282
5333               0269 62D8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
5334               0270 62DA 1006  14         jmp   edkey.action.nword_scan_char
5335               0271                       ;-------------------------------------------------------
5336               0272                       ; Multiple spaces mode
5337               0273                       ;-------------------------------------------------------
5338               0274               edkey.action.nword_ms:
5339               0275 62DC 0708  14         seto  tmp4                  ; Set multiple spaces mode
5340               0276                       ;-------------------------------------------------------
5341               0277                       ; Scan forward to first character following space
5342               0278                       ;-------------------------------------------------------
5343               0279               edkey.action.nword_scan
5344               0280 62DE 0585  14         inc   tmp1
5345               0281 62E0 0584  14         inc   tmp0                  ; Column++ in screen buffer
5346               0282 62E2 8804  38         c     tmp0,@fb.row.length
5347                    62E4 A288
5348               0283 62E6 1316  14         jeq   edkey.action.nword_done
5349               0284                                                   ; Column=last char ? Skip further processing
5350               0285                       ;-------------------------------------------------------
5351               0286                       ; Check character
5352               0287                       ;-------------------------------------------------------
5353               0288               edkey.action.nword_scan_char
5354               0289 62E8 D195  26         movb  *tmp1,tmp2            ; Get character
5355               0290 62EA 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
5356               0291 62EC D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
5357               0292 62EE 0986  56         srl   tmp2,8                ; Right justify
5358               0293
5359               0294 62F0 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
5360                    62F2 FFFF
5361               0295 62F4 1604  14         jne   edkey.action.nword_scan_char_other
5362               0296                       ;-------------------------------------------------------
5363               0297                       ; Special handling if multiple spaces found
5364               0298                       ;-------------------------------------------------------
5365               0299               edkey.action.nword_scan_char_ms:
5366               0300 62F6 0286  22         ci    tmp2,32
5367                    62F8 0020
5368               0301 62FA 160C  14         jne   edkey.action.nword_done
5369               0302                                                   ; Exit if non-space found
5370               0303 62FC 10F0  14         jmp   edkey.action.nword_scan
5371               0304                       ;-------------------------------------------------------
5372               0305                       ; Normal handling
5373               0306                       ;-------------------------------------------------------
5374               0307               edkey.action.nword_scan_char_other:
5375               0308 62FE 0286  22         ci    tmp2,32               ; Space character found?
5376                    6300 0020
5377               0309 6302 16ED  14         jne   edkey.action.nword_scan
5378               0310                                                   ; No space found, try again
5379               0311                       ;-------------------------------------------------------
5380               0312                       ; Space found, now look closer
5381               0313                       ;-------------------------------------------------------
5382               0314 6304 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
5383                    6306 2020
5384               0315 6308 13E9  14         jeq   edkey.action.nword_ms
5385               0316                                                   ; Yes, so continue scanning
5386               0317 630A 0287  22         ci    tmp3,>20ff            ; First characer is space?
5387                    630C 20FF
5388               0318 630E 13E7  14         jeq   edkey.action.nword_scan
5389               0319                       ;--------------------------------------------------------
5390               0320                       ; Set cursor following space
5391               0321                       ;--------------------------------------------------------
5392               0322 6310 0585  14         inc   tmp1
5393               0323 6312 0584  14         inc   tmp0                  ; Column++ in screen buffer
5394               0324                       ;-------------------------------------------------------
5395               0325                       ; Save position and position hardware cursor
5396               0326                       ;-------------------------------------------------------
5397               0327               edkey.action.nword_done:
5398               0328 6314 C805  38         mov   tmp1,@fb.current
5399                    6316 A282
5400               0329 6318 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
5401                    631A A28C
5402               0330 631C 06A0  32         bl    @xsetx                ; Set VDP cursor X
5403                    631E 2666
5404               0331                       ;-------------------------------------------------------
5405               0332                       ; Exit
5406               0333                       ;-------------------------------------------------------
5407               0334               edkey.action.nword.exit:
5408               0335 6320 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5409                    6322 681E
5410               0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5411                    6326 7028
5412               0337
5413               0338
5414               0339
5415               0340
5416               0341               *---------------------------------------------------------------
5417               0342               * Previous page
5418               0343               *---------------------------------------------------------------
5419               0344               edkey.action.ppage:
5420               0345                       ;-------------------------------------------------------
5421               0346                       ; Sanity check
5422               0347                       ;-------------------------------------------------------
5423               0348 6328 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
5424                    632A A284
5425               0349 632C 1316  14         jeq   edkey.action.ppage.exit
5426               0350                       ;-------------------------------------------------------
5427               0351                       ; Special treatment top page
5428               0352                       ;-------------------------------------------------------
5429               0353 632E 8804  38         c     tmp0,@fb.scrrows   ; topline > rows on screen?
5430                    6330 A298
5431               0354 6332 1503  14         jgt   edkey.action.ppage.topline
5432               0355 6334 04E0  34         clr   @fb.topline           ; topline = 0
5433                    6336 A284
5434               0356 6338 1003  14         jmp   edkey.action.ppage.crunch
5435               0357                       ;-------------------------------------------------------
5436               0358                       ; Adjust topline
5437               0359                       ;-------------------------------------------------------
5438               0360               edkey.action.ppage.topline:
5439               0361 633A 6820  54         s     @fb.scrrows,@fb.topline
5440                    633C A298
5441                    633E A284
5442               0362                       ;-------------------------------------------------------
5443               0363                       ; Crunch current row if dirty
5444               0364                       ;-------------------------------------------------------
5445               0365               edkey.action.ppage.crunch:
5446               0366 6340 8820  54         c     @fb.row.dirty,@w$ffff
5447                    6342 A28A
5448                    6344 202C
5449               0367 6346 1604  14         jne   edkey.action.ppage.refresh
5450               0368 6348 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5451                    634A 6A02
5452               0369 634C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5453                    634E A28A
5454               0370                       ;-------------------------------------------------------
5455               0371                       ; Refresh page
5456               0372                       ;-------------------------------------------------------
5457               0373               edkey.action.ppage.refresh:
5458               0374 6350 C820  54         mov   @fb.topline,@parm1
5459                    6352 A284
5460                    6354 8350
5461               0375 6356 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
5462                    6358 683A
5463               0376                       ;-------------------------------------------------------
5464               0377                       ; Exit
5465               0378                       ;-------------------------------------------------------
5466               0379               edkey.action.ppage.exit:
5467               0380 635A 04E0  34         clr   @fb.row
5468                    635C A286
5469               0381 635E 04E0  34         clr   @fb.column
5470                    6360 A28C
5471               0382 6362 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
5472                    6364 0100
5473               0383 6366 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
5474                    6368 832A
5475               0384 636A 0460  28         b     @edkey.action.up      ; Do rest of logic
5476                    636C 618C
5477               0385
5478               0386
5479               0387
5480               0388               *---------------------------------------------------------------
5481               0389               * Next page
5482               0390               *---------------------------------------------------------------
5483               0391               edkey.action.npage:
5484               0392                       ;-------------------------------------------------------
5485               0393                       ; Sanity check
5486               0394                       ;-------------------------------------------------------
5487               0395 636E C120  34         mov   @fb.topline,tmp0
5488                    6370 A284
5489               0396 6372 A120  34         a     @fb.scrrows,tmp0
5490                    6374 A298
5491               0397 6376 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
5492                    6378 A304
5493               0398 637A 150D  14         jgt   edkey.action.npage.exit
5494               0399                       ;-------------------------------------------------------
5495               0400                       ; Adjust topline
5496               0401                       ;-------------------------------------------------------
5497               0402               edkey.action.npage.topline:
5498               0403 637C A820  54         a     @fb.scrrows,@fb.topline
5499                    637E A298
5500                    6380 A284
5501               0404                       ;-------------------------------------------------------
5502               0405                       ; Crunch current row if dirty
5503               0406                       ;-------------------------------------------------------
5504               0407               edkey.action.npage.crunch:
5505               0408 6382 8820  54         c     @fb.row.dirty,@w$ffff
5506                    6384 A28A
5507                    6386 202C
5508               0409 6388 1604  14         jne   edkey.action.npage.refresh
5509               0410 638A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5510                    638C 6A02
5511               0411 638E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5512                    6390 A28A
5513               0412                       ;-------------------------------------------------------
5514               0413                       ; Refresh page
5515               0414                       ;-------------------------------------------------------
5516               0415               edkey.action.npage.refresh:
5517               0416 6392 0460  28         b     @edkey.action.ppage.refresh
5518                    6394 6350
5519               0417                                                   ; Same logic as previous page
5520               0418                       ;-------------------------------------------------------
5521               0419                       ; Exit
5522               0420                       ;-------------------------------------------------------
5523               0421               edkey.action.npage.exit:
5524               0422 6396 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5525                    6398 7028
5526               0423
5527               0424
5528               0425
5529               0426
5530               0427               *---------------------------------------------------------------
5531               0428               * Goto top of file
5532               0429               *---------------------------------------------------------------
5533               0430               edkey.action.top:
5534               0431                       ;-------------------------------------------------------
5535               0432                       ; Crunch current row if dirty
5536               0433                       ;-------------------------------------------------------
5537               0434 639A 8820  54         c     @fb.row.dirty,@w$ffff
5538                    639C A28A
5539                    639E 202C
5540               0435 63A0 1604  14         jne   edkey.action.top.refresh
5541               0436 63A2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5542                    63A4 6A02
5543               0437 63A6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5544                    63A8 A28A
5545               0438                       ;-------------------------------------------------------
5546               0439                       ; Refresh page
5547               0440                       ;-------------------------------------------------------
5548               0441               edkey.action.top.refresh:
5549               0442 63AA 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
5550                    63AC A284
5551               0443 63AE 04E0  34         clr   @parm1
5552                    63B0 8350
5553               0444 63B2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
5554                    63B4 683A
5555               0445                       ;-------------------------------------------------------
5556               0446                       ; Exit
5557               0447                       ;-------------------------------------------------------
5558               0448               edkey.action.top.exit:
5559               0449 63B6 04E0  34         clr   @fb.row               ; Frame buffer line 0
5560                    63B8 A286
5561               0450 63BA 04E0  34         clr   @fb.column            ; Frame buffer column 0
5562                    63BC A28C
5563               0451 63BE 0204  20         li    tmp0,>0100
5564                    63C0 0100
5565               0452 63C2 C804  38         mov   tmp0,@wyx             ; Set VDP cursor on line 1, column 0
5566                    63C4 832A
5567               0453 63C6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5568                    63C8 7028
5569               0454
5570               0455
5571               0456
5572               0457               *---------------------------------------------------------------
5573               0458               * Goto bottom of file
5574               0459               *---------------------------------------------------------------
5575               0460               edkey.action.bot:
5576               0461                       ;-------------------------------------------------------
5577               0462                       ; Crunch current row if dirty
5578               0463                       ;-------------------------------------------------------
5579               0464 63CA 8820  54         c     @fb.row.dirty,@w$ffff
5580                    63CC A28A
5581                    63CE 202C
5582               0465 63D0 1604  14         jne   edkey.action.bot.refresh
5583               0466 63D2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5584                    63D4 6A02
5585               0467 63D6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5586                    63D8 A28A
5587               0468                       ;-------------------------------------------------------
5588               0469                       ; Refresh page
5589               0470                       ;-------------------------------------------------------
5590               0471               edkey.action.bot.refresh:
5591               0472 63DA 8820  54         c     @edb.lines,@fb.scrrows
5592                    63DC A304
5593                    63DE A298
5594               0473                                                   ; Skip if whole editor buffer on screen
5595               0474 63E0 1212  14         jle   !
5596               0475 63E2 C120  34         mov   @edb.lines,tmp0
5597                    63E4 A304
5598               0476 63E6 6120  34         s     @fb.scrrows,tmp0
5599                    63E8 A298
5600               0477 63EA C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
5601                    63EC A284
5602               0478 63EE C804  38         mov   tmp0,@parm1
5603                    63F0 8350
5604               0479 63F2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
5605                    63F4 683A
5606               0480                       ;-------------------------------------------------------
5607               0481                       ; Exit
5608               0482                       ;-------------------------------------------------------
5609               0483               edkey.action.bot.exit:
5610               0484 63F6 04E0  34         clr   @fb.row               ; Editor line 0
5611                    63F8 A286
5612               0485 63FA 04E0  34         clr   @fb.column            ; Editor column 0
5613                    63FC A28C
5614               0486 63FE 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
5615                    6400 0100
5616               0487 6402 C804  38         mov   tmp0,@wyx             ; Set cursor
5617                    6404 832A
5618               0488 6406 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
5619                    6408 7028
5620               **** **** ****     > tivi_b1.asm.31428
5621               0040                       copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
5622               **** **** ****     > edkey.fb.mod.asm
5623               0001               * FILE......: edkey.fb.mod.asm
5624               0002               * Purpose...: Actions for modifier keys in frame buffer pane.
5625               0003
5626               0004
5627               0005               *---------------------------------------------------------------
5628               0006               * Delete character
5629               0007               *---------------------------------------------------------------
5630               0008               edkey.action.del_char:
5631               0009 640A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5632                    640C A306
5633               0010 640E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5634                    6410 681E
5635               0011                       ;-------------------------------------------------------
5636               0012                       ; Sanity check 1
5637               0013                       ;-------------------------------------------------------
5638               0014 6412 C120  34         mov   @fb.current,tmp0      ; Get pointer
5639                    6414 A282
5640               0015 6416 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
5641                    6418 A288
5642               0016 641A 1311  14         jeq   edkey.action.del_char.exit
5643               0017                                                   ; Exit if empty line
5644               0018                       ;-------------------------------------------------------
5645               0019                       ; Sanity check 2
5646               0020                       ;-------------------------------------------------------
5647               0021 641C 8820  54         c     @fb.column,@fb.row.length
5648                    641E A28C
5649                    6420 A288
5650               0022 6422 130D  14         jeq   edkey.action.del_char.exit
5651               0023                                                   ; Exit if at EOL
5652               0024                       ;-------------------------------------------------------
5653               0025                       ; Prepare for delete operation
5654               0026                       ;-------------------------------------------------------
5655               0027 6424 C120  34         mov   @fb.current,tmp0      ; Get pointer
5656                    6426 A282
5657               0028 6428 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
5658               0029 642A 0585  14         inc   tmp1
5659               0030                       ;-------------------------------------------------------
5660               0031                       ; Loop until end of line
5661               0032                       ;-------------------------------------------------------
5662               0033               edkey.action.del_char_loop:
5663               0034 642C DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
5664               0035 642E 0606  14         dec   tmp2
5665               0036 6430 16FD  14         jne   edkey.action.del_char_loop
5666               0037                       ;-------------------------------------------------------
5667               0038                       ; Save variables
5668               0039                       ;-------------------------------------------------------
5669               0040 6432 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
5670                    6434 A28A
5671               0041 6436 0720  34         seto  @fb.dirty             ; Trigger screen refresh
5672                    6438 A296
5673               0042 643A 0620  34         dec   @fb.row.length        ; @fb.row.length--
5674                    643C A288
5675               0043                       ;-------------------------------------------------------
5676               0044                       ; Exit
5677               0045                       ;-------------------------------------------------------
5678               0046               edkey.action.del_char.exit:
5679               0047 643E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5680                    6440 7028
5681               0048
5682               0049
5683               0050               *---------------------------------------------------------------
5684               0051               * Delete until end of line
5685               0052               *---------------------------------------------------------------
5686               0053               edkey.action.del_eol:
5687               0054 6442 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5688                    6444 A306
5689               0055 6446 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5690                    6448 681E
5691               0056 644A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
5692                    644C A288
5693               0057 644E 1311  14         jeq   edkey.action.del_eol.exit
5694               0058                                                   ; Exit if empty line
5695               0059                       ;-------------------------------------------------------
5696               0060                       ; Prepare for erase operation
5697               0061                       ;-------------------------------------------------------
5698               0062 6450 C120  34         mov   @fb.current,tmp0      ; Get pointer
5699                    6452 A282
5700               0063 6454 C1A0  34         mov   @fb.colsline,tmp2
5701                    6456 A28E
5702               0064 6458 61A0  34         s     @fb.column,tmp2
5703                    645A A28C
5704               0065 645C 04C5  14         clr   tmp1
5705               0066                       ;-------------------------------------------------------
5706               0067                       ; Loop until last column in frame buffer
5707               0068                       ;-------------------------------------------------------
5708               0069               edkey.action.del_eol_loop:
5709               0070 645E DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
5710               0071 6460 0606  14         dec   tmp2
5711               0072 6462 16FD  14         jne   edkey.action.del_eol_loop
5712               0073                       ;-------------------------------------------------------
5713               0074                       ; Save variables
5714               0075                       ;-------------------------------------------------------
5715               0076 6464 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
5716                    6466 A28A
5717               0077 6468 0720  34         seto  @fb.dirty             ; Trigger screen refresh
5718                    646A A296
5719               0078
5720               0079 646C C820  54         mov   @fb.column,@fb.row.length
5721                    646E A28C
5722                    6470 A288
5723               0080                                                   ; Set new row length
5724               0081                       ;-------------------------------------------------------
5725               0082                       ; Exit
5726               0083                       ;-------------------------------------------------------
5727               0084               edkey.action.del_eol.exit:
5728               0085 6472 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5729                    6474 7028
5730               0086
5731               0087
5732               0088               *---------------------------------------------------------------
5733               0089               * Delete current line
5734               0090               *---------------------------------------------------------------
5735               0091               edkey.action.del_line:
5736               0092 6476 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5737                    6478 A306
5738               0093                       ;-------------------------------------------------------
5739               0094                       ; Special treatment if only 1 line in file
5740               0095                       ;-------------------------------------------------------
5741               0096 647A C120  34         mov   @edb.lines,tmp0
5742                    647C A304
5743               0097 647E 1604  14         jne   !
5744               0098 6480 04E0  34         clr   @fb.column            ; Column 0
5745                    6482 A28C
5746               0099 6484 0460  28         b     @edkey.action.del_eol ; Delete until end of line
5747                    6486 6442
5748               0100                       ;-------------------------------------------------------
5749               0101                       ; Delete entry in index
5750               0102                       ;-------------------------------------------------------
5751               0103 6488 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
5752                    648A 681E
5753               0104 648C 04E0  34         clr   @fb.row.dirty         ; Discard current line
5754                    648E A28A
5755               0105 6490 C820  54         mov   @fb.topline,@parm1
5756                    6492 A284
5757                    6494 8350
5758               0106 6496 A820  54         a     @fb.row,@parm1        ; Line number to remove
5759                    6498 A286
5760                    649A 8350
5761               0107 649C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
5762                    649E A304
5763                    64A0 8352
5764               0108 64A2 06A0  32         bl    @idx.entry.delete     ; Reorganize index
5765                    64A4 693C
5766               0109 64A6 0620  34         dec   @edb.lines            ; One line less in editor buffer
5767                    64A8 A304
5768               0110                       ;-------------------------------------------------------
5769               0111                       ; Refresh frame buffer and physical screen
5770               0112                       ;-------------------------------------------------------
5771               0113 64AA C820  54         mov   @fb.topline,@parm1
5772                    64AC A284
5773                    64AE 8350
5774               0114 64B0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
5775                    64B2 683A
5776               0115 64B4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
5777                    64B6 A296
5778               0116                       ;-------------------------------------------------------
5779               0117                       ; Special treatment if current line was last line
5780               0118                       ;-------------------------------------------------------
5781               0119 64B8 C120  34         mov   @fb.topline,tmp0
5782                    64BA A284
5783               0120 64BC A120  34         a     @fb.row,tmp0
5784                    64BE A286
5785               0121 64C0 8804  38         c     tmp0,@edb.lines       ; Was last line?
5786                    64C2 A304
5787               0122 64C4 1202  14         jle   edkey.action.del_line.exit
5788               0123 64C6 0460  28         b     @edkey.action.up      ; One line up
5789                    64C8 618C
5790               0124                       ;-------------------------------------------------------
5791               0125                       ; Exit
5792               0126                       ;-------------------------------------------------------
5793               0127               edkey.action.del_line.exit:
5794               0128 64CA 0460  28         b     @edkey.action.home    ; Move cursor to home and return
5795                    64CC 624A
5796               0129
5797               0130
5798               0131
5799               0132               *---------------------------------------------------------------
5800               0133               * Insert character
5801               0134               *
5802               0135               * @parm1 = high byte has character to insert
5803               0136               *---------------------------------------------------------------
5804               0137               edkey.action.ins_char.ws:
5805               0138 64CE 0204  20         li    tmp0,>2000            ; White space
5806                    64D0 2000
5807               0139 64D2 C804  38         mov   tmp0,@parm1
5808                    64D4 8350
5809               0140               edkey.action.ins_char:
5810               0141 64D6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5811                    64D8 A306
5812               0142 64DA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5813                    64DC 681E
5814               0143                       ;-------------------------------------------------------
5815               0144                       ; Sanity check 1 - Empty line
5816               0145                       ;-------------------------------------------------------
5817               0146 64DE C120  34         mov   @fb.current,tmp0      ; Get pointer
5818                    64E0 A282
5819               0147 64E2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
5820                    64E4 A288
5821               0148 64E6 131A  14         jeq   edkey.action.ins_char.sanity
5822               0149                                                   ; Add character in overwrite mode
5823               0150                       ;-------------------------------------------------------
5824               0151                       ; Sanity check 2 - EOL
5825               0152                       ;-------------------------------------------------------
5826               0153 64E8 8820  54         c     @fb.column,@fb.row.length
5827                    64EA A28C
5828                    64EC A288
5829               0154 64EE 1316  14         jeq   edkey.action.ins_char.sanity
5830               0155                                                   ; Add character in overwrite mode
5831               0156                       ;-------------------------------------------------------
5832               0157                       ; Prepare for insert operation
5833               0158                       ;-------------------------------------------------------
5834               0159               edkey.action.skipsanity:
5835               0160 64F0 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
5836               0161 64F2 61E0  34         s     @fb.column,tmp3
5837                    64F4 A28C
5838               0162 64F6 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
5839               0163 64F8 C144  18         mov   tmp0,tmp1
5840               0164 64FA 0585  14         inc   tmp1                  ; tmp1=tmp0+1
5841               0165 64FC 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
5842                    64FE A28C
5843               0166 6500 0586  14         inc   tmp2
5844               0167                       ;-------------------------------------------------------
5845               0168                       ; Loop from end of line until current character
5846               0169                       ;-------------------------------------------------------
5847               0170               edkey.action.ins_char_loop:
5848               0171 6502 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
5849               0172 6504 0604  14         dec   tmp0
5850               0173 6506 0605  14         dec   tmp1
5851               0174 6508 0606  14         dec   tmp2
5852               0175 650A 16FB  14         jne   edkey.action.ins_char_loop
5853               0176                       ;-------------------------------------------------------
5854               0177                       ; Set specified character on current position
5855               0178                       ;-------------------------------------------------------
5856               0179 650C D560  46         movb  @parm1,*tmp1
5857                    650E 8350
5858               0180                       ;-------------------------------------------------------
5859               0181                       ; Save variables
5860               0182                       ;-------------------------------------------------------
5861               0183 6510 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
5862                    6512 A28A
5863               0184 6514 0720  34         seto  @fb.dirty             ; Trigger screen refresh
5864                    6516 A296
5865               0185 6518 05A0  34         inc   @fb.row.length        ; @fb.row.length
5866                    651A A288
5867               0186                       ;-------------------------------------------------------
5868               0187                       ; Add character in overwrite mode
5869               0188                       ;-------------------------------------------------------
5870               0189               edkey.action.ins_char.sanity
5871               0190 651C 0460  28         b     @edkey.action.char.overwrite
5872                    651E 65F8
5873               0191                       ;-------------------------------------------------------
5874               0192                       ; Exit
5875               0193                       ;-------------------------------------------------------
5876               0194               edkey.action.ins_char.exit:
5877               0195 6520 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5878                    6522 7028
5879               0196
5880               0197
5881               0198
5882               0199
5883               0200
5884               0201
5885               0202               *---------------------------------------------------------------
5886               0203               * Insert new line
5887               0204               *---------------------------------------------------------------
5888               0205               edkey.action.ins_line:
5889               0206 6524 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5890                    6526 A306
5891               0207                       ;-------------------------------------------------------
5892               0208                       ; Crunch current line if dirty
5893               0209                       ;-------------------------------------------------------
5894               0210 6528 8820  54         c     @fb.row.dirty,@w$ffff
5895                    652A A28A
5896                    652C 202C
5897               0211 652E 1604  14         jne   edkey.action.ins_line.insert
5898               0212 6530 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5899                    6532 6A02
5900               0213 6534 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5901                    6536 A28A
5902               0214                       ;-------------------------------------------------------
5903               0215                       ; Insert entry in index
5904               0216                       ;-------------------------------------------------------
5905               0217               edkey.action.ins_line.insert:
5906               0218 6538 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
5907                    653A 681E
5908               0219 653C C820  54         mov   @fb.topline,@parm1
5909                    653E A284
5910                    6540 8350
5911               0220 6542 A820  54         a     @fb.row,@parm1        ; Line number to insert
5912                    6544 A286
5913                    6546 8350
5914               0221
5915               0222 6548 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
5916                    654A A304
5917                    654C 8352
5918               0223 654E 06A0  32         bl    @idx.entry.insert     ; Reorganize index
5919                    6550 6970
5920               0224 6552 05A0  34         inc   @edb.lines            ; One line more in editor buffer
5921                    6554 A304
5922               0225                       ;-------------------------------------------------------
5923               0226                       ; Refresh frame buffer and physical screen
5924               0227                       ;-------------------------------------------------------
5925               0228 6556 C820  54         mov   @fb.topline,@parm1
5926                    6558 A284
5927                    655A 8350
5928               0229 655C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
5929                    655E 683A
5930               0230 6560 0720  34         seto  @fb.dirty             ; Trigger screen refresh
5931                    6562 A296
5932               0231                       ;-------------------------------------------------------
5933               0232                       ; Exit
5934               0233                       ;-------------------------------------------------------
5935               0234               edkey.action.ins_line.exit:
5936               0235 6564 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
5937                    6566 7028
5938               0236
5939               0237
5940               0238
5941               0239
5942               0240
5943               0241
5944               0242               *---------------------------------------------------------------
5945               0243               * Enter
5946               0244               *---------------------------------------------------------------
5947               0245               edkey.action.enter:
5948               0246                       ;-------------------------------------------------------
5949               0247                       ; Crunch current line if dirty
5950               0248                       ;-------------------------------------------------------
5951               0249 6568 8820  54         c     @fb.row.dirty,@w$ffff
5952                    656A A28A
5953                    656C 202C
5954               0250 656E 1606  14         jne   edkey.action.enter.upd_counter
5955               0251 6570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
5956                    6572 A306
5957               0252 6574 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
5958                    6576 6A02
5959               0253 6578 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
5960                    657A A28A
5961               0254                       ;-------------------------------------------------------
5962               0255                       ; Update line counter
5963               0256                       ;-------------------------------------------------------
5964               0257               edkey.action.enter.upd_counter:
5965               0258 657C C120  34         mov   @fb.topline,tmp0
5966                    657E A284
5967               0259 6580 A120  34         a     @fb.row,tmp0
5968                    6582 A286
5969               0260 6584 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
5970                    6586 A304
5971               0261 6588 1602  14         jne   edkey.action.newline  ; No, continue newline
5972               0262 658A 05A0  34         inc   @edb.lines            ; Total lines++
5973                    658C A304
5974               0263                       ;-------------------------------------------------------
5975               0264                       ; Process newline
5976               0265                       ;-------------------------------------------------------
5977               0266               edkey.action.newline:
5978               0267                       ;-------------------------------------------------------
5979               0268                       ; Scroll 1 line if cursor at bottom row of screen
5980               0269                       ;-------------------------------------------------------
5981               0270 658E C120  34         mov   @fb.scrrows,tmp0
5982                    6590 A298
5983               0271 6592 0604  14         dec   tmp0
5984               0272 6594 8120  34         c     @fb.row,tmp0
5985                    6596 A286
5986               0273 6598 110A  14         jlt   edkey.action.newline.down
5987               0274                       ;-------------------------------------------------------
5988               0275                       ; Scroll
5989               0276                       ;-------------------------------------------------------
5990               0277 659A C120  34         mov   @fb.scrrows,tmp0
5991                    659C A298
5992               0278 659E C820  54         mov   @fb.topline,@parm1
5993                    65A0 A284
5994                    65A2 8350
5995               0279 65A4 05A0  34         inc   @parm1
5996                    65A6 8350
5997               0280 65A8 06A0  32         bl    @fb.refresh
5998                    65AA 683A
5999               0281 65AC 1004  14         jmp   edkey.action.newline.rest
6000               0282                       ;-------------------------------------------------------
6001               0283                       ; Move cursor down a row, there are still rows left
6002               0284                       ;-------------------------------------------------------
6003               0285               edkey.action.newline.down:
6004               0286 65AE 05A0  34         inc   @fb.row               ; Row++ in screen buffer
6005                    65B0 A286
6006               0287 65B2 06A0  32         bl    @down                 ; Row++ VDP cursor
6007                    65B4 2654
6008               0288                       ;-------------------------------------------------------
6009               0289                       ; Set VDP cursor and save variables
6010               0290                       ;-------------------------------------------------------
6011               0291               edkey.action.newline.rest:
6012               0292 65B6 06A0  32         bl    @fb.get.firstnonblank
6013                    65B8 68B2
6014               0293 65BA C120  34         mov   @outparm1,tmp0
6015                    65BC 8360
6016               0294 65BE C804  38         mov   tmp0,@fb.column
6017                    65C0 A28C
6018               0295 65C2 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
6019                    65C4 2666
6020               0296 65C6 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
6021                    65C8 6B9A
6022               0297 65CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
6023                    65CC 681E
6024               0298 65CE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
6025                    65D0 A296
6026               0299                       ;-------------------------------------------------------
6027               0300                       ; Exit
6028               0301                       ;-------------------------------------------------------
6029               0302               edkey.action.newline.exit:
6030               0303 65D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6031                    65D4 7028
6032               0304
6033               0305
6034               0306
6035               0307
6036               0308               *---------------------------------------------------------------
6037               0309               * Toggle insert/overwrite mode
6038               0310               *---------------------------------------------------------------
6039               0311               edkey.action.ins_onoff:
6040               0312 65D6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
6041                    65D8 A30A
6042               0313                       ;-------------------------------------------------------
6043               0314                       ; Delay
6044               0315                       ;-------------------------------------------------------
6045               0316 65DA 0204  20         li    tmp0,2000
6046                    65DC 07D0
6047               0317               edkey.action.ins_onoff.loop:
6048               0318 65DE 0604  14         dec   tmp0
6049               0319 65E0 16FE  14         jne   edkey.action.ins_onoff.loop
6050               0320                       ;-------------------------------------------------------
6051               0321                       ; Exit
6052               0322                       ;-------------------------------------------------------
6053               0323               edkey.action.ins_onoff.exit:
6054               0324 65E2 0460  28         b     @task.vdp.cursor      ; Update cursor shape
6055                    65E4 7152
6056               0325
6057               0326
6058               0327
6059               0328
6060               0329               *---------------------------------------------------------------
6061               0330               * Process character
6062               0331               *---------------------------------------------------------------
6063               0332               edkey.action.char:
6064               0333 65E6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
6065                    65E8 A306
6066               0334 65EA D805  38         movb  tmp1,@parm1           ; Store character for insert
6067                    65EC 8350
6068               0335 65EE C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
6069                    65F0 A30A
6070               0336 65F2 1302  14         jeq   edkey.action.char.overwrite
6071               0337                       ;-------------------------------------------------------
6072               0338                       ; Insert mode
6073               0339                       ;-------------------------------------------------------
6074               0340               edkey.action.char.insert:
6075               0341 65F4 0460  28         b     @edkey.action.ins_char
6076                    65F6 64D6
6077               0342                       ;-------------------------------------------------------
6078               0343                       ; Overwrite mode
6079               0344                       ;-------------------------------------------------------
6080               0345               edkey.action.char.overwrite:
6081               0346 65F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
6082                    65FA 681E
6083               0347 65FC C120  34         mov   @fb.current,tmp0      ; Get pointer
6084                    65FE A282
6085               0348
6086               0349 6600 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
6087                    6602 8350
6088               0350 6604 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
6089                    6606 A28A
6090               0351 6608 0720  34         seto  @fb.dirty             ; Trigger screen refresh
6091                    660A A296
6092               0352
6093               0353 660C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
6094                    660E A28C
6095               0354 6610 05A0  34         inc   @wyx                  ; Column++ VDP cursor
6096                    6612 832A
6097               0355                       ;-------------------------------------------------------
6098               0356                       ; Update line length in frame buffer
6099               0357                       ;-------------------------------------------------------
6100               0358 6614 8820  54         c     @fb.column,@fb.row.length
6101                    6616 A28C
6102                    6618 A288
6103               0359 661A 1103  14         jlt   edkey.action.char.exit
6104               0360                                                   ; column < length line ? Skip processing
6105               0361
6106               0362 661C C820  54         mov   @fb.column,@fb.row.length
6107                    661E A28C
6108                    6620 A288
6109               0363                       ;-------------------------------------------------------
6110               0364                       ; Exit
6111               0365                       ;-------------------------------------------------------
6112               0366               edkey.action.char.exit:
6113               0367 6622 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6114                    6624 7028
6115               **** **** ****     > tivi_b1.asm.31428
6116               0041                       copy  "edkey.fb.misc.asm"   ; fb pane   - Actions for miscelanneous keys
6117               **** **** ****     > edkey.fb.misc.asm
6118               0001               * FILE......: edkey.fb.misc.asm
6119               0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
6120               0003
6121               0004
6122               0005               *---------------------------------------------------------------
6123               0006               * Quit TiVi
6124               0007               *---------------------------------------------------------------
6125               0008               edkey.action.quit:
6126               0009 6626 06A0  32         bl    @f18rst               ; Reset and lock the F18A
6127                    6628 2716
6128               0010 662A 0420  54         blwp  @0                    ; Exit
6129                    662C 0000
6130               0011
6131               0012
6132               0013               *---------------------------------------------------------------
6133               0014               * No action at all
6134               0015               *---------------------------------------------------------------
6135               0016               edkey.action.noop:
6136               0017 662E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6137                    6630 7028
6138               0018
6139               0019
6140               0020               *---------------------------------------------------------------
6141               0021               * Show/Hide command buffer pane
6142               0022               ********|*****|*********************|**************************
6143               0023               edkey.action.cmdb.toggle:
6144               0024 6632 C120  34         mov   @cmdb.visible,tmp0
6145                    6634 A502
6146               0025 6636 1603  14         jne   edkey.action.cmdb.hide
6147               0026                       ;-------------------------------------------------------
6148               0027                       ; Show pane
6149               0028                       ;-------------------------------------------------------
6150               0029               edkey.action.cmdb.show:
6151               0030 6638 06A0  32         bl    @cmdb.show            ; Show command buffer pane
6152                    663A 6BF2
6153               0031 663C 1002  14         jmp   edkey.action.cmdb.toggle.exit
6154               0032                       ;-------------------------------------------------------
6155               0033                       ; Hide pane
6156               0034                       ;-------------------------------------------------------
6157               0035               edkey.action.cmdb.hide:
6158               0036 663E 06A0  32         bl    @cmdb.hide            ; Hide command buffer pane
6159                    6640 6C2C
6160               0037                       ;-------------------------------------------------------
6161               0038                       ; Exit
6162               0039                       ;-------------------------------------------------------
6163               0040               edkey.action.cmdb.toggle.exit:
6164               0041 6642 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6165                    6644 7028
6166               0042
6167               0043
6168               0044
6169               0045               *---------------------------------------------------------------
6170               0046               * Framebuffer down 1 row
6171               0047               *---------------------------------------------------------------
6172               0048               edkey.action.fbdown:
6173               0049 6646 05A0  34         inc   @fb.scrrows
6174                    6648 A298
6175               0050 664A 0720  34         seto  @fb.dirty
6176                    664C A296
6177               0051
6178               0052 664E 045B  20         b     *r11
6179               0053
6180               0054
6181               0055               *---------------------------------------------------------------
6182               0056               * Cycle colors
6183               0057               ********|*****|*********************|**************************
6184               0058               edkey.action.color.cycle:
6185               0059 6650 0649  14         dect  stack
6186               0060 6652 C64B  30         mov   r11,*stack            ; Push return address
6187               0061
6188               0062 6654 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
6189                    6656 A212
6190               0063 6658 0284  22         ci    tmp0,3                ; 4th entry reached?
6191                    665A 0003
6192               0064 665C 1102  14         jlt   !
6193               0065 665E 04C4  14         clr   tmp0
6194               0066 6660 1001  14         jmp   edkey.action.color.switch
6195               0067 6662 0584  14 !       inc   tmp0
6196               0068               *---------------------------------------------------------------
6197               0069               * Do actual color switch
6198               0070               ********|*****|*********************|**************************
6199               0071               edkey.action.color.switch:
6200               0072 6664 C804  38         mov   tmp0,@tv.colorscheme  ; Save color scheme index
6201                    6666 A212
6202               0073 6668 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
6203               0074 666A 0224  22         ai    tmp0,tv.data.colorscheme
6204                    666C 732C
6205               0075                                                   ; Add base for color scheme data table
6206               0076 666E D154  26         movb  *tmp0,tmp1            ; Get foreground / background color
6207               0077                       ;-------------------------------------------------------
6208               0078                       ; Dump cursor FG color to sprite table (SAT)
6209               0079                       ;-------------------------------------------------------
6210               0080 6670 C185  18         mov   tmp1,tmp2             ; Get work copy
6211               0081 6672 0946  56         srl   tmp2,4                ; Move nibble to right
6212               0082 6674 0246  22         andi  tmp2,>0f00
6213                    6676 0F00
6214               0083 6678 D806  38         movb  tmp2,@ramsat+3        ; Update FG color in sprite table (SAT)
6215                    667A 8383
6216               0084 667C D806  38         movb  tmp2,@tv.curshape+1   ; Save cursor color
6217                    667E A215
6218               0085                       ;-------------------------------------------------------
6219               0086                       ; Dump color combination to VDP color table
6220               0087                       ;-------------------------------------------------------
6221               0088 6680 0985  56         srl   tmp1,8                ; MSB to LSB
6222               0089 6682 0265  22         ori   tmp1,>0700
6223                    6684 0700
6224               0090 6686 C105  18         mov   tmp1,tmp0
6225               0091 6688 06A0  32         bl    @putvrx
6226                    668A 2314
6227               0092 668C C2F9  30         mov   *stack+,r11           ; Pop R11
6228               0093 668E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6229                    6690 7028
6230               **** **** ****     > tivi_b1.asm.31428
6231               0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
6232               **** **** ****     > edkey.fb.file.asm
6233               0001               * FILE......: edkey.fb.fíle.asm
6234               0002               * Purpose...: File related actions in frame buffer pane.
6235               0003
6236               0004
6237               0005               edkey.action.buffer0:
6238               0006 6692 0204  20         li   tmp0,fdname0
6239                    6694 73FA
6240               0007 6696 101B  14         jmp  edkey.action.rest
6241               0008               edkey.action.buffer1:
6242               0009 6698 0204  20         li   tmp0,fdname1
6243                    669A 740A
6244               0010 669C 1018  14         jmp  edkey.action.rest
6245               0011               edkey.action.buffer2:
6246               0012 669E 0204  20         li   tmp0,fdname2
6247                    66A0 741A
6248               0013 66A2 1015  14         jmp  edkey.action.rest
6249               0014               edkey.action.buffer3:
6250               0015 66A4 0204  20         li   tmp0,fdname3
6251                    66A6 7428
6252               0016 66A8 1012  14         jmp  edkey.action.rest
6253               0017               edkey.action.buffer4:
6254               0018 66AA 0204  20         li   tmp0,fdname4
6255                    66AC 7436
6256               0019 66AE 100F  14         jmp  edkey.action.rest
6257               0020               edkey.action.buffer5:
6258               0021 66B0 0204  20         li   tmp0,fdname5
6259                    66B2 7444
6260               0022 66B4 100C  14         jmp  edkey.action.rest
6261               0023               edkey.action.buffer6:
6262               0024 66B6 0204  20         li   tmp0,fdname6
6263                    66B8 7452
6264               0025 66BA 1009  14         jmp  edkey.action.rest
6265               0026               edkey.action.buffer7:
6266               0027 66BC 0204  20         li   tmp0,fdname7
6267                    66BE 7460
6268               0028 66C0 1006  14         jmp  edkey.action.rest
6269               0029               edkey.action.buffer8:
6270               0030 66C2 0204  20         li   tmp0,fdname8
6271                    66C4 746E
6272               0031 66C6 1003  14         jmp  edkey.action.rest
6273               0032               edkey.action.buffer9:
6274               0033 66C8 0204  20         li   tmp0,fdname9
6275                    66CA 747C
6276               0034 66CC 1000  14         jmp  edkey.action.rest
6277               0035
6278               0036               edkey.action.rest:
6279               0037 66CE 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
6280                    66D0 6EB0
6281               0038                                                   ; | i  tmp0 = Pointer to device and filename
6282               0039                                                   ; /
6283               0040
6284               0041 66D2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
6285                    66D4 639A
6286               **** **** ****     > tivi_b1.asm.31428
6287               0043                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
6288               **** **** ****     > edkey.cmdb.mod.asm
6289               0001               * FILE......: edkey.cmdb.mod.asm
6290               0002               * Purpose...: Actions for modifier keys in command buffer pane.
6291               0003
6292               0004
6293               0005               *---------------------------------------------------------------
6294               0006               * Insert character
6295               0007               *
6296               0008               * @parm1 = high byte has character to insert
6297               0009               *---------------------------------------------------------------
6298               0010               edkey.cmdb.action.ins_char.ws:
6299               0011 66D6 0204  20         li    tmp0,>2000            ; White space
6300                    66D8 2000
6301               0012 66DA C804  38         mov   tmp0,@parm1
6302                    66DC 8350
6303               0013               edkey.cmdb.action.ins_char:
6304               0014 66DE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
6305                    66E0 A510
6306               0015 66E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
6307                    66E4 681E
6308               0016                       ;-------------------------------------------------------
6309               0017                       ; Prepare for insert operation
6310               0018                       ;-------------------------------------------------------
6311               0019               edkey.cmdb.action.skipsanity:
6312               0020 66E6 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
6313               0021 66E8 61E0  34         s     @fb.column,tmp3
6314                    66EA A28C
6315               0022 66EC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
6316               0023 66EE C144  18         mov   tmp0,tmp1
6317               0024 66F0 0585  14         inc   tmp1                  ; tmp1=tmp0+1
6318               0025 66F2 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
6319                    66F4 A28C
6320               0026 66F6 0586  14         inc   tmp2
6321               0027                       ;-------------------------------------------------------
6322               0028                       ; Loop from end of line until current character
6323               0029                       ;-------------------------------------------------------
6324               0030               edkey.cmdb.action.ins_char_loop:
6325               0031 66F8 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
6326               0032 66FA 0604  14         dec   tmp0
6327               0033 66FC 0605  14         dec   tmp1
6328               0034 66FE 0606  14         dec   tmp2
6329               0035 6700 16FB  14         jne   edkey.cmdb.action.ins_char_loop
6330               0036                       ;-------------------------------------------------------
6331               0037                       ; Set specified character on current position
6332               0038                       ;-------------------------------------------------------
6333               0039 6702 D560  46         movb  @parm1,*tmp1
6334                    6704 8350
6335               0040                       ;-------------------------------------------------------
6336               0041                       ; Save variables
6337               0042                       ;-------------------------------------------------------
6338               0043 6706 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
6339                    6708 A28A
6340               0044 670A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
6341                    670C A296
6342               0045 670E 05A0  34         inc   @fb.row.length        ; @fb.row.length
6343                    6710 A288
6344               0046                       ;-------------------------------------------------------
6345               0047                       ; Exit
6346               0048                       ;-------------------------------------------------------
6347               0049               edkey.cmdb.action.ins_char.exit:
6348               0050 6712 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6349                    6714 7028
6350               0051
6351               0052
6352               0053
6353               0054               *---------------------------------------------------------------
6354               0055               * Process character
6355               0056               *---------------------------------------------------------------
6356               0057               edkey.cmdb.action.char:
6357               0058 6716 0720  34         seto  @cmdb.dirty           ; Editor buffer dirty (text changed!)
6358                    6718 A510
6359               0059 671A D805  38         movb  tmp1,@parm1           ; Store character for insert
6360                    671C 8350
6361               0060                       ;-------------------------------------------------------
6362               0061                       ; Only insert mode supported
6363               0062                       ;-------------------------------------------------------
6364               0063               edkey.cmdb.action.char.insert:
6365               0064 671E 0460  28         b     @edkey.action.ins_char
6366                    6720 64D6
6367               0065                       ;-------------------------------------------------------
6368               0066                       ; Exit
6369               0067                       ;-------------------------------------------------------
6370               0068               edkey.cmdb.action.char.exit:
6371               0069 6722 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
6372                    6724 7028
6373               **** **** ****     > tivi_b1.asm.31428
6374               0044                       copy  "tivi.asm"            ; Main editor configuration
6375               **** **** ****     > tivi.asm
6376               0001               * FILE......: tivi.asm
6377               0002               * Purpose...: TiVi Editor - Main editor configuration
6378               0003
6379               0004               *//////////////////////////////////////////////////////////////
6380               0005               *              TiVi Editor - Main editor configuration
6381               0006               *//////////////////////////////////////////////////////////////
6382               0007
6383               0008
6384               0009               ***************************************************************
6385               0010               * tv.init
6386               0011               * Initialize main editor
6387               0012               ***************************************************************
6388               0013               * bl @tivi.init
6389               0014               *--------------------------------------------------------------
6390               0015               * INPUT
6391               0016               * none
6392               0017               *--------------------------------------------------------------
6393               0018               * OUTPUT
6394               0019               * none
6395               0020               *--------------------------------------------------------------
6396               0021               * Register usage
6397               0022               * tmp0
6398               0023               *--------------------------------------------------------------
6399               0024               * Notes
6400               0025               ***************************************************************
6401               0026               tivi.init:
6402               0027 6726 0649  14         dect  stack
6403               0028 6728 C64B  30         mov   r11,*stack            ; Save return address
6404               0029                       ;------------------------------------------------------
6405               0030                       ; Initialize
6406               0031                       ;------------------------------------------------------
6407               0032 672A 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
6408                    672C A212
6409               0033
6410               0034                       ;------------------------------------------------------
6411               0035                       ; Exit
6412               0036                       ;------------------------------------------------------
6413               0037               tivi.init.exit:
6414               0038 672E 0460  28         b     @poprt                ; Return to caller
6415                    6730 2212
6416               **** **** ****     > tivi_b1.asm.31428
6417               0045                       copy  "mem.asm"             ; Memory Management
6418               **** **** ****     > mem.asm
6419               0001               * FILE......: mem.asm
6420               0002               * Purpose...: TiVi Editor - Memory management (SAMS)
6421               0003
6422               0004               *//////////////////////////////////////////////////////////////
6423               0005               *                  TiVi Editor - Memory Management
6424               0006               *//////////////////////////////////////////////////////////////
6425               0007
6426               0008               ***************************************************************
6427               0009               * mem.setup.sams.layout
6428               0010               * Setup SAMS memory pages for TiVi
6429               0011               ***************************************************************
6430               0012               * bl  @mem.setup.sams.layout
6431               0013               *--------------------------------------------------------------
6432               0014               * OUTPUT
6433               0015               * none
6434               0016               *--------------------------------------------------------------
6435               0017               * Register usage
6436               0018               * none
6437               0019               ***************************************************************
6438               0020               mem.setup.sams.layout:
6439               0021 6732 0649  14         dect  stack
6440               0022 6734 C64B  30         mov   r11,*stack            ; Save return address
6441               0023                       ;------------------------------------------------------
6442               0024                       ; Set SAMS standard layout
6443               0025                       ;------------------------------------------------------
6444               0026 6736 06A0  32         bl    @sams.layout
6445                    6738 2562
6446               0027 673A 6740                   data mem.sams.layout.data
6447               0028                       ;------------------------------------------------------
6448               0029                       ; Exit
6449               0030                       ;------------------------------------------------------
6450               0031               mem.setup.sams.layout.exit:
6451               0032 673C C2F9  30         mov   *stack+,r11           ; Pop r11
6452               0033 673E 045B  20         b     *r11                  ; Return to caller
6453               0034               ***************************************************************
6454               0035               * SAMS page layout table for TiVi (16 words)
6455               0036               *--------------------------------------------------------------
6456               0037               mem.sams.layout.data:
6457               0038 6740 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >00
6458                    6742 0002
6459               0039 6744 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >01
6460                    6746 0003
6461               0040 6748 A000             data  >a000,>000a           ; >a000-afff, SAMS page >02
6462                    674A 000A
6463               0041 674C B000             data  >b000,>000b           ; >b000-bfff, SAMS page >03
6464                    674E 000B
6465               0042 6750 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >04
6466                    6752 000C
6467               0043 6754 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >05
6468                    6756 000D
6469               0044 6758 E000             data  >e000,>0010           ; >e000-efff, SAMS page >10
6470                    675A 0010
6471               0045 675C F000             data  >f000,>0011           ; >f000-ffff, SAMS page >11
6472                    675E 0011
6473               0046
6474               0047
6475               0048
6476               0049
6477               0050               ***************************************************************
6478               0051               * mem.edb.sams.pagein
6479               0052               * Activate editor buffer SAMS page for line
6480               0053               ***************************************************************
6481               0054               * bl  @mem.edb.sams.pagein
6482               0055               *     data p0
6483               0056               *--------------------------------------------------------------
6484               0057               * p0 = Line number in editor buffer
6485               0058               *--------------------------------------------------------------
6486               0059               * bl  @xmem.edb.sams.pagein
6487               0060               *
6488               0061               * tmp0 = Line number in editor buffer
6489               0062               *--------------------------------------------------------------
6490               0063               * OUTPUT
6491               0064               * outparm1 = Pointer to line in editor buffer
6492               0065               * outparm2 = SAMS page
6493               0066               *--------------------------------------------------------------
6494               0067               * Register usage
6495               0068               * tmp0, tmp1, tmp2, tmp3
6496               0069               ***************************************************************
6497               0070               mem.edb.sams.pagein:
6498               0071 6760 C13B  30         mov   *r11+,tmp0            ; Get p0
6499               0072               xmem.edb.sams.pagein:
6500               0073 6762 0649  14         dect  stack
6501               0074 6764 C64B  30         mov   r11,*stack            ; Push return address
6502               0075 6766 0649  14         dect  stack
6503               0076 6768 C644  30         mov   tmp0,*stack           ; Push tmp0
6504               0077 676A 0649  14         dect  stack
6505               0078 676C C645  30         mov   tmp1,*stack           ; Push tmp1
6506               0079 676E 0649  14         dect  stack
6507               0080 6770 C646  30         mov   tmp2,*stack           ; Push tmp2
6508               0081 6772 0649  14         dect  stack
6509               0082 6774 C647  30         mov   tmp3,*stack           ; Push tmp3
6510               0083                       ;------------------------------------------------------
6511               0084                       ; Sanity check
6512               0085                       ;------------------------------------------------------
6513               0086 6776 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
6514                    6778 A304
6515               0087 677A 1104  14         jlt   mem.edb.sams.pagein.lookup
6516               0088                                                   ; All checks passed, continue
6517               0089                                                   ;--------------------------
6518               0090                                                   ; Sanity check failed
6519               0091                                                   ;--------------------------
6520               0092 677C C80B  38         mov   r11,@>ffce            ; \ Save caller address
6521                    677E FFCE
6522               0093 6780 06A0  32         bl    @cpu.crash            ; / Crash and halt system
6523                    6782 2030
6524               0094                       ;------------------------------------------------------
6525               0095                       ; Lookup SAMS page for line in parm1
6526               0096                       ;------------------------------------------------------
6527               0097               mem.edb.sams.pagein.lookup:
6528               0098 6784 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
6529                    6786 69B4
6530               0099                                                   ; \ i  parm1    = Line number
6531               0100                                                   ; | o  outparm1 = Pointer to line
6532               0101                                                   ; / o  outparm2 = SAMS page
6533               0102
6534               0103 6788 C120  34         mov   @outparm2,tmp0        ; SAMS page
6535                    678A 8362
6536               0104 678C C160  34         mov   @outparm1,tmp1        ; Memory address
6537                    678E 8360
6538               0105 6790 1315  14         jeq   mem.edb.sams.pagein.exit
6539               0106                                                   ; Nothing to page-in if empty line
6540               0107                       ;------------------------------------------------------
6541               0108                       ; 1. Determine if requested SAMS page is already active
6542               0109                       ;------------------------------------------------------
6543               0110 6792 0245  22         andi  tmp1,>f000            ; Reduce address to 4K chunks
6544                    6794 F000
6545               0111 6796 04C6  14         clr   tmp2                  ; Offset in SAMS shadow registers table
6546               0112 6798 0207  20         li    tmp3,sams.copy.layout.data + 6
6547                    679A 2604
6548               0113                                                   ; Entry >b000  in SAMS memory range table
6549               0114                       ;------------------------------------------------------
6550               0115                       ; Loop over memory ranges
6551               0116                       ;------------------------------------------------------
6552               0117               mem.edb.sams.pagein.compare.loop:
6553               0118 679C 8177  30         c     *tmp3+,tmp1           ; Does memory range match?
6554               0119 679E 1308  14         jeq   !                     ; Yes, now check SAMS page
6555               0120
6556               0121 67A0 05C6  14         inct  tmp2                  ; Next range
6557               0122 67A2 0286  22         ci    tmp2,12               ; All ranges checked?
6558                    67A4 000C
6559               0123 67A6 16FA  14         jne   mem.edb.sams.pagein.compare.loop
6560               0124                                                   ; Not yet, check next range
6561               0125                       ;------------------------------------------------------
6562               0126                       ; Invalid memory range. Should never get here
6563               0127                       ;------------------------------------------------------
6564               0128 67A8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
6565                    67AA FFCE
6566               0129 67AC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
6567                    67AE 2030
6568               0130                       ;------------------------------------------------------
6569               0131                       ; 2. Determine if requested SAMS page is already active
6570               0132                       ;------------------------------------------------------
6571               0133 67B0 0226  22 !       ai    tmp2,tv.sams.2000     ; Add offset for SAMS shadow register
6572                    67B2 A200
6573               0134 67B4 8116  26         c     *tmp2,tmp0            ; Requested SAMS page already active?
6574               0135 67B6 1302  14         jeq   mem.edb.sams.pagein.exit
6575               0136                                                   ; Yes, so exit
6576               0137                       ;------------------------------------------------------
6577               0138                       ; Activate requested SAMS page
6578               0139                       ;-----------------------------------------------------
6579               0140 67B8 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
6580                    67BA 24FC
6581               0141                                                   ; \ i  tmp0 = SAMS page
6582               0142                                                   ; / i  tmp1 = Memory address
6583               0143                       ;------------------------------------------------------
6584               0144                       ; Exit
6585               0145                       ;------------------------------------------------------
6586               0146               mem.edb.sams.pagein.exit:
6587               0147 67BC C1F9  30         mov   *stack+,tmp3          ; Pop tmp1
6588               0148 67BE C1B9  30         mov   *stack+,tmp2          ; Pop tmp1
6589               0149 67C0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
6590               0150 67C2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
6591               0151 67C4 C2F9  30         mov   *stack+,r11           ; Pop r11
6592               0152 67C6 045B  20         b     *r11                  ; Return to caller
6593               0153
6594               **** **** ****     > tivi_b1.asm.31428
6595               0046                       copy  "fb.asm"              ; Framebuffer
6596               **** **** ****     > fb.asm
6597               0001               * FILE......: fb.asm
6598               0002               * Purpose...: TiVi Editor - Framebuffer module
6599               0003
6600               0004               *//////////////////////////////////////////////////////////////
6601               0005               *          RAM Framebuffer for handling screen output
6602               0006               *//////////////////////////////////////////////////////////////
6603               0007
6604               0008               ***************************************************************
6605               0009               * fb.init
6606               0010               * Initialize framebuffer
6607               0011               ***************************************************************
6608               0012               *  bl   @fb.init
6609               0013               *--------------------------------------------------------------
6610               0014               *  INPUT
6611               0015               *  none
6612               0016               *--------------------------------------------------------------
6613               0017               *  OUTPUT
6614               0018               *  none
6615               0019               *--------------------------------------------------------------
6616               0020               * Register usage
6617               0021               * tmp0
6618               0022               ********|*****|*********************|**************************
6619               0023               fb.init
6620               0024 67C8 0649  14         dect  stack
6621               0025 67CA C64B  30         mov   r11,*stack            ; Save return address
6622               0026                       ;------------------------------------------------------
6623               0027                       ; Initialize
6624               0028                       ;------------------------------------------------------
6625               0029 67CC 0204  20         li    tmp0,fb.top
6626                    67CE A650
6627               0030 67D0 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
6628                    67D2 A280
6629               0031 67D4 04E0  34         clr   @fb.topline           ; Top line in framebuffer
6630                    67D6 A284
6631               0032 67D8 04E0  34         clr   @fb.row               ; Current row=0
6632                    67DA A286
6633               0033 67DC 04E0  34         clr   @fb.column            ; Current column=0
6634                    67DE A28C
6635               0034
6636               0035 67E0 0204  20         li    tmp0,80
6637                    67E2 0050
6638               0036 67E4 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
6639                    67E6 A28E
6640               0037
6641               0038 67E8 0204  20         li    tmp0,27
6642                    67EA 001B
6643               0039 67EC C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
6644                    67EE A298
6645               0040 67F0 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
6646                    67F2 A29A
6647               0041
6648               0042 67F4 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
6649                    67F6 A216
6650               0043 67F8 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
6651                    67FA A296
6652               0044                       ;------------------------------------------------------
6653               0045                       ; Clear frame buffer
6654               0046                       ;------------------------------------------------------
6655               0047 67FC 06A0  32         bl    @film
6656                    67FE 2216
6657               0048 6800 A650             data  fb.top,>00,fb.size    ; Clear it all the way
6658                    6802 0000
6659                    6804 09B0
6660               0049                       ;------------------------------------------------------
6661               0050                       ; Exit
6662               0051                       ;------------------------------------------------------
6663               0052               fb.init.exit
6664               0053 6806 0460  28         b     @poprt                ; Return to caller
6665                    6808 2212
6666               0054
6667               0055
6668               0056
6669               0057
6670               0058               ***************************************************************
6671               0059               * fb.row2line
6672               0060               * Calculate line in editor buffer
6673               0061               ***************************************************************
6674               0062               * bl @fb.row2line
6675               0063               *--------------------------------------------------------------
6676               0064               * INPUT
6677               0065               * @fb.topline = Top line in frame buffer
6678               0066               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
6679               0067               *--------------------------------------------------------------
6680               0068               * OUTPUT
6681               0069               * @outparm1 = Matching line in editor buffer
6682               0070               *--------------------------------------------------------------
6683               0071               * Register usage
6684               0072               * tmp2,tmp3
6685               0073               *--------------------------------------------------------------
6686               0074               * Formula
6687               0075               * outparm1 = @fb.topline + @parm1
6688               0076               ********|*****|*********************|**************************
6689               0077               fb.row2line:
6690               0078 680A 0649  14         dect  stack
6691               0079 680C C64B  30         mov   r11,*stack            ; Save return address
6692               0080                       ;------------------------------------------------------
6693               0081                       ; Calculate line in editor buffer
6694               0082                       ;------------------------------------------------------
6695               0083 680E C120  34         mov   @parm1,tmp0
6696                    6810 8350
6697               0084 6812 A120  34         a     @fb.topline,tmp0
6698                    6814 A284
6699               0085 6816 C804  38         mov   tmp0,@outparm1
6700                    6818 8360
6701               0086                       ;------------------------------------------------------
6702               0087                       ; Exit
6703               0088                       ;------------------------------------------------------
6704               0089               fb.row2line$$:
6705               0090 681A 0460  28         b    @poprt                 ; Return to caller
6706                    681C 2212
6707               0091
6708               0092
6709               0093
6710               0094
6711               0095               ***************************************************************
6712               0096               * fb.calc_pointer
6713               0097               * Calculate pointer address in frame buffer
6714               0098               ***************************************************************
6715               0099               * bl @fb.calc_pointer
6716               0100               *--------------------------------------------------------------
6717               0101               * INPUT
6718               0102               * @fb.top       = Address of top row in frame buffer
6719               0103               * @fb.topline   = Top line in frame buffer
6720               0104               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
6721               0105               * @fb.column    = Current column in frame buffer
6722               0106               * @fb.colsline  = Columns per line in frame buffer
6723               0107               *--------------------------------------------------------------
6724               0108               * OUTPUT
6725               0109               * @fb.current   = Updated pointer
6726               0110               *--------------------------------------------------------------
6727               0111               * Register usage
6728               0112               * tmp2,tmp3
6729               0113               *--------------------------------------------------------------
6730               0114               * Formula
6731               0115               * pointer = row * colsline + column + deref(@fb.top.ptr)
6732               0116               ********|*****|*********************|**************************
6733               0117               fb.calc_pointer:
6734               0118 681E 0649  14         dect  stack
6735               0119 6820 C64B  30         mov   r11,*stack            ; Save return address
6736               0120                       ;------------------------------------------------------
6737               0121                       ; Calculate pointer
6738               0122                       ;------------------------------------------------------
6739               0123 6822 C1A0  34         mov   @fb.row,tmp2
6740                    6824 A286
6741               0124 6826 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
6742                    6828 A28E
6743               0125 682A A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
6744                    682C A28C
6745               0126 682E A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
6746                    6830 A280
6747               0127 6832 C807  38         mov   tmp3,@fb.current
6748                    6834 A282
6749               0128                       ;------------------------------------------------------
6750               0129                       ; Exit
6751               0130                       ;------------------------------------------------------
6752               0131               fb.calc_pointer.$$
6753               0132 6836 0460  28         b    @poprt                 ; Return to caller
6754                    6838 2212
6755               0133
6756               0134
6757               0135
6758               0136
6759               0137               ***************************************************************
6760               0138               * fb.refresh
6761               0139               * Refresh frame buffer with editor buffer content
6762               0140               ***************************************************************
6763               0141               * bl @fb.refresh
6764               0142               *--------------------------------------------------------------
6765               0143               * INPUT
6766               0144               * @parm1 = Line to start with (becomes @fb.topline)
6767               0145               *--------------------------------------------------------------
6768               0146               * OUTPUT
6769               0147               * none
6770               0148               *--------------------------------------------------------------
6771               0149               * Register usage
6772               0150               * tmp0,tmp1,tmp2
6773               0151               ********|*****|*********************|**************************
6774               0152               fb.refresh:
6775               0153 683A 0649  14         dect  stack
6776               0154 683C C64B  30         mov   r11,*stack            ; Push return address
6777               0155 683E 0649  14         dect  stack
6778               0156 6840 C644  30         mov   tmp0,*stack           ; Push tmp0
6779               0157 6842 0649  14         dect  stack
6780               0158 6844 C645  30         mov   tmp1,*stack           ; Push tmp1
6781               0159 6846 0649  14         dect  stack
6782               0160 6848 C646  30         mov   tmp2,*stack           ; Push tmp2
6783               0161                       ;------------------------------------------------------
6784               0162                       ; Update SAMS shadow registers in RAM
6785               0163                       ;------------------------------------------------------
6786               0164 684A 06A0  32         bl    @sams.copy.layout     ; Copy SAMS memory layout
6787                    684C 25C6
6788               0165 684E A200                   data tv.sams.2000     ; \ i  p0 = Pointer to 8 words RAM buffer
6789               0166                                                   ; /
6790               0167                       ;------------------------------------------------------
6791               0168                       ; Setup starting position in index
6792               0169                       ;------------------------------------------------------
6793               0170 6850 C820  54         mov   @parm1,@fb.topline
6794                    6852 8350
6795                    6854 A284
6796               0171 6856 04E0  34         clr   @parm2                ; Target row in frame buffer
6797                    6858 8352
6798               0172                       ;------------------------------------------------------
6799               0173                       ; Check if already at EOF
6800               0174                       ;------------------------------------------------------
6801               0175 685A 8820  54         c     @parm1,@edb.lines    ; EOF reached?
6802                    685C 8350
6803                    685E A304
6804               0176 6860 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
6805               0177                       ;------------------------------------------------------
6806               0178                       ; Unpack line to frame buffer
6807               0179                       ;------------------------------------------------------
6808               0180               fb.refresh.unpack_line:
6809               0181 6862 06A0  32         bl    @edb.line.unpack      ; Unpack line
6810                    6864 6AAA
6811               0182                                                   ; \ i  parm1 = Line to unpack
6812               0183                                                   ; / i  parm2 = Target row in frame buffer
6813               0184
6814               0185 6866 05A0  34         inc   @parm1                ; Next line in editor buffer
6815                    6868 8350
6816               0186 686A 05A0  34         inc   @parm2                ; Next row in frame buffer
6817                    686C 8352
6818               0187                       ;------------------------------------------------------
6819               0188                       ; Last row in editor buffer reached ?
6820               0189                       ;------------------------------------------------------
6821               0190 686E 8820  54         c     @parm1,@edb.lines
6822                    6870 8350
6823                    6872 A304
6824               0191 6874 1113  14         jlt   !                     ; no, do next check
6825               0192                                                   ; yes, erase until end of frame buffer
6826               0193                       ;------------------------------------------------------
6827               0194                       ; Erase until end of frame buffer
6828               0195                       ;------------------------------------------------------
6829               0196               fb.refresh.erase_eob:
6830               0197 6876 C120  34         mov   @parm2,tmp0           ; Current row
6831                    6878 8352
6832               0198 687A C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
6833                    687C A298
6834               0199 687E 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
6835               0200 6880 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
6836                    6882 A28E
6837               0201
6838               0202 6884 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
6839               0203 6886 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
6840               0204
6841               0205 6888 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
6842                    688A A28E
6843               0206 688C A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
6844                    688E A280
6845               0207
6846               0208 6890 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
6847               0209 6892 0205  20         li    tmp1,32               ; Clear with space
6848                    6894 0020
6849               0210
6850               0211 6896 06A0  32         bl    @xfilm                ; \ Fill memory
6851                    6898 221C
6852               0212                                                   ; | i  tmp0 = Memory start address
6853               0213                                                   ; | i  tmp1 = Byte to fill
6854               0214                                                   ; / i  tmp2 = Number of bytes to fill
6855               0215 689A 1004  14         jmp   fb.refresh.exit
6856               0216                       ;------------------------------------------------------
6857               0217                       ; Bottom row in frame buffer reached ?
6858               0218                       ;------------------------------------------------------
6859               0219 689C 8820  54 !       c     @parm2,@fb.scrrows
6860                    689E 8352
6861                    68A0 A298
6862               0220 68A2 11DF  14         jlt   fb.refresh.unpack_line
6863               0221                                                   ; No, unpack next line
6864               0222                       ;------------------------------------------------------
6865               0223                       ; Exit
6866               0224                       ;------------------------------------------------------
6867               0225               fb.refresh.exit:
6868               0226 68A4 0720  34         seto  @fb.dirty             ; Refresh screen
6869                    68A6 A296
6870               0227 68A8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
6871               0228 68AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
6872               0229 68AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
6873               0230 68AE C2F9  30         mov   *stack+,r11           ; Pop r11
6874               0231 68B0 045B  20         b     *r11                  ; Return to caller
6875               0232
6876               0233
6877               0234               ***************************************************************
6878               0235               * fb.get.firstnonblank
6879               0236               * Get column of first non-blank character in specified line
6880               0237               ***************************************************************
6881               0238               * bl @fb.get.firstnonblank
6882               0239               *--------------------------------------------------------------
6883               0240               * OUTPUT
6884               0241               * @outparm1 = Column containing first non-blank character
6885               0242               * @outparm2 = Character
6886               0243               ********|*****|*********************|**************************
6887               0244               fb.get.firstnonblank:
6888               0245 68B2 0649  14         dect  stack
6889               0246 68B4 C64B  30         mov   r11,*stack            ; Save return address
6890               0247                       ;------------------------------------------------------
6891               0248                       ; Prepare for scanning
6892               0249                       ;------------------------------------------------------
6893               0250 68B6 04E0  34         clr   @fb.column
6894                    68B8 A28C
6895               0251 68BA 06A0  32         bl    @fb.calc_pointer
6896                    68BC 681E
6897               0252 68BE 06A0  32         bl    @edb.line.getlength2  ; Get length current line
6898                    68C0 6B9A
6899               0253 68C2 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
6900                    68C4 A288
6901               0254 68C6 1313  14         jeq   fb.get.firstnonblank.nomatch
6902               0255                                                   ; Exit if empty line
6903               0256 68C8 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
6904                    68CA A282
6905               0257 68CC 04C5  14         clr   tmp1
6906               0258                       ;------------------------------------------------------
6907               0259                       ; Scan line for non-blank character
6908               0260                       ;------------------------------------------------------
6909               0261               fb.get.firstnonblank.loop:
6910               0262 68CE D174  28         movb  *tmp0+,tmp1           ; Get character
6911               0263 68D0 130E  14         jeq   fb.get.firstnonblank.nomatch
6912               0264                                                   ; Exit if empty line
6913               0265 68D2 0285  22         ci    tmp1,>2000            ; Whitespace?
6914                    68D4 2000
6915               0266 68D6 1503  14         jgt   fb.get.firstnonblank.match
6916               0267 68D8 0606  14         dec   tmp2                  ; Counter--
6917               0268 68DA 16F9  14         jne   fb.get.firstnonblank.loop
6918               0269 68DC 1008  14         jmp   fb.get.firstnonblank.nomatch
6919               0270                       ;------------------------------------------------------
6920               0271                       ; Non-blank character found
6921               0272                       ;------------------------------------------------------
6922               0273               fb.get.firstnonblank.match:
6923               0274 68DE 6120  34         s     @fb.current,tmp0      ; Calculate column
6924                    68E0 A282
6925               0275 68E2 0604  14         dec   tmp0
6926               0276 68E4 C804  38         mov   tmp0,@outparm1        ; Save column
6927                    68E6 8360
6928               0277 68E8 D805  38         movb  tmp1,@outparm2        ; Save character
6929                    68EA 8362
6930               0278 68EC 1004  14         jmp   fb.get.firstnonblank.exit
6931               0279                       ;------------------------------------------------------
6932               0280                       ; No non-blank character found
6933               0281                       ;------------------------------------------------------
6934               0282               fb.get.firstnonblank.nomatch:
6935               0283 68EE 04E0  34         clr   @outparm1             ; X=0
6936                    68F0 8360
6937               0284 68F2 04E0  34         clr   @outparm2             ; Null
6938                    68F4 8362
6939               0285                       ;------------------------------------------------------
6940               0286                       ; Exit
6941               0287                       ;------------------------------------------------------
6942               0288               fb.get.firstnonblank.exit:
6943               0289 68F6 0460  28         b    @poprt                 ; Return to caller
6944                    68F8 2212
6945               **** **** ****     > tivi_b1.asm.31428
6946               0047                       copy  "idx.asm"             ; Index management
6947               **** **** ****     > idx.asm
6948               0001               * FILE......: idx.asm
6949               0002               * Purpose...: TiVi Editor - Index module
6950               0003
6951               0004               *//////////////////////////////////////////////////////////////
6952               0005               *                  TiVi Editor - Index Management
6953               0006               *//////////////////////////////////////////////////////////////
6954               0007
6955               0008               ***************************************************************
6956               0009               * The index contains 2 major parts:
6957               0010               *
6958               0011               * 1) Main index (c000 - cfff)
6959               0012               *
6960               0013               *    Size of index page is 4K and allows indexing of 2048 lines.
6961               0014               *    Each index slot (1 word) contains the pointer to the line
6962               0015               *    in the editor buffer.
6963               0016               *
6964               0017               * 2) Shadow SAMS pages index (d000 - dfff)
6965               0018               *
6966               0019               *    Size of index page is 4K and allows indexing of 2048 lines.
6967               0020               *    Each index slot (1 word) contains the SAMS page where the
6968               0021               *    line in the editor buffer resides
6969               0022               *
6970               0023               *
6971               0024               * The editor buffer itself always resides at (e000 -> ffff) for
6972               0025               * a total of 8kb.
6973               0026               * First line in editor buffer starts at offset 2 (c002), this
6974               0027               * allows the index to contain "null" pointers, aka empty lines
6975               0028               * without reference to editor buffer.
6976               0029               ***************************************************************
6977               0030
6978               0031
6979               0032               ***************************************************************
6980               0033               * idx.init
6981               0034               * Initialize index
6982               0035               ***************************************************************
6983               0036               * bl @idx.init
6984               0037               *--------------------------------------------------------------
6985               0038               * INPUT
6986               0039               * none
6987               0040               *--------------------------------------------------------------
6988               0041               * OUTPUT
6989               0042               * none
6990               0043               *--------------------------------------------------------------
6991               0044               * Register usage
6992               0045               * tmp0
6993               0046               ***************************************************************
6994               0047               idx.init:
6995               0048 68FA 0649  14         dect  stack
6996               0049 68FC C64B  30         mov   r11,*stack            ; Save return address
6997               0050                       ;------------------------------------------------------
6998               0051                       ; Initialize
6999               0052                       ;------------------------------------------------------
7000               0053 68FE 0204  20         li    tmp0,idx.top
7001                    6900 C000
7002               0054 6902 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
7003                    6904 A302
7004               0055                       ;------------------------------------------------------
7005               0056                       ; Clear index
7006               0057                       ;------------------------------------------------------
7007               0058 6906 06A0  32         bl    @film
7008                    6908 2216
7009               0059 690A C000             data  idx.top,>00,idx.size  ; Clear main index
7010                    690C 0000
7011                    690E 1000
7012               0060
7013               0061 6910 06A0  32         bl    @film
7014                    6912 2216
7015               0062 6914 D000             data  idx.shadow.top,>00,idx.shadow.size
7016                    6916 0000
7017                    6918 1000
7018               0063                                                   ; Clear shadow index
7019               0064                       ;------------------------------------------------------
7020               0065                       ; Exit
7021               0066                       ;------------------------------------------------------
7022               0067               idx.init.exit:
7023               0068 691A 0460  28         b     @poprt                ; Return to caller
7024                    691C 2212
7025               0069
7026               0070
7027               0071
7028               0072               ***************************************************************
7029               0073               * idx.entry.update
7030               0074               * Update index entry - Each entry corresponds to a line
7031               0075               ***************************************************************
7032               0076               * bl @idx.entry.update
7033               0077               *--------------------------------------------------------------
7034               0078               * INPUT
7035               0079               * @parm1    = Line number in editor buffer
7036               0080               * @parm2    = Pointer to line in editor buffer
7037               0081               * @parm3    = SAMS page
7038               0082               *--------------------------------------------------------------
7039               0083               * OUTPUT
7040               0084               * @outparm1 = Pointer to updated index entry
7041               0085               *--------------------------------------------------------------
7042               0086               * Register usage
7043               0087               * tmp0,tmp1,tmp2
7044               0088               *--------------------------------------------------------------
7045               0089               idx.entry.update:
7046               0090 691E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
7047                    6920 8350
7048               0091                       ;------------------------------------------------------
7049               0092                       ; Calculate offset
7050               0093                       ;------------------------------------------------------
7051               0094 6922 C160  34         mov   @parm2,tmp1
7052                    6924 8352
7053               0095 6926 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
7054               0096
7055               0097                       ;------------------------------------------------------
7056               0098                       ; SAMS bank
7057               0099                       ;------------------------------------------------------
7058               0100 6928 C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
7059                    692A 8354
7060               0101
7061               0102                       ;------------------------------------------------------
7062               0103                       ; Update index slot
7063               0104                       ;------------------------------------------------------
7064               0105               idx.entry.update.save:
7065               0106 692C 0A14  56         sla   tmp0,1                ; line number * 2
7066               0107 692E C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
7067                    6930 C000
7068               0108 6932 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
7069                    6934 D000
7070               0109                                                   ; Update SAMS page
7071               0110                       ;------------------------------------------------------
7072               0111                       ; Exit
7073               0112                       ;------------------------------------------------------
7074               0113               idx.entry.update.exit:
7075               0114 6936 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
7076                    6938 8360
7077               0115 693A 045B  20         b     *r11                  ; Return
7078               0116
7079               0117
7080               0118               ***************************************************************
7081               0119               * idx.entry.delete
7082               0120               * Delete index entry - Close gap created by delete
7083               0121               ***************************************************************
7084               0122               * bl @idx.entry.delete
7085               0123               *--------------------------------------------------------------
7086               0124               * INPUT
7087               0125               * @parm1    = Line number in editor buffer to delete
7088               0126               * @parm2    = Line number of last line to check for reorg
7089               0127               *--------------------------------------------------------------
7090               0128               * OUTPUT
7091               0129               * @outparm1 = Pointer to deleted line (for undo)
7092               0130               *--------------------------------------------------------------
7093               0131               * Register usage
7094               0132               * tmp0,tmp2
7095               0133               *--------------------------------------------------------------
7096               0134               idx.entry.delete:
7097               0135 693C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
7098                    693E 8350
7099               0136                       ;------------------------------------------------------
7100               0137                       ; Calculate address of index entry and save pointer
7101               0138                       ;------------------------------------------------------
7102               0139 6940 0A14  56         sla   tmp0,1                ; line number * 2
7103               0140 6942 C824  54         mov   @idx.top(tmp0),@outparm1
7104                    6944 C000
7105                    6946 8360
7106               0141                                                   ; Pointer to deleted line
7107               0142                       ;------------------------------------------------------
7108               0143                       ; Prepare for index reorg
7109               0144                       ;------------------------------------------------------
7110               0145 6948 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
7111                    694A 8352
7112               0146 694C 61A0  34         s     @parm1,tmp2           ; Calculate loop
7113                    694E 8350
7114               0147 6950 1601  14         jne   idx.entry.delete.reorg
7115               0148                       ;------------------------------------------------------
7116               0149                       ; Special treatment if last line
7117               0150                       ;------------------------------------------------------
7118               0151 6952 1009  14         jmp   idx.entry.delete.lastline
7119               0152                       ;------------------------------------------------------
7120               0153                       ; Reorganize index entries
7121               0154                       ;------------------------------------------------------
7122               0155               idx.entry.delete.reorg:
7123               0156 6954 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
7124                    6956 C002
7125                    6958 C000
7126               0157 695A C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
7127                    695C D002
7128                    695E D000
7129               0158 6960 05C4  14         inct  tmp0                  ; Next index entry
7130               0159 6962 0606  14         dec   tmp2                  ; tmp2--
7131               0160 6964 16F7  14         jne   idx.entry.delete.reorg
7132               0161                                                   ; Loop unless completed
7133               0162                       ;------------------------------------------------------
7134               0163                       ; Last line
7135               0164                       ;------------------------------------------------------
7136               0165               idx.entry.delete.lastline
7137               0166 6966 04E4  34         clr   @idx.top(tmp0)
7138                    6968 C000
7139               0167 696A 04E4  34         clr   @idx.shadow.top(tmp0)
7140                    696C D000
7141               0168                       ;------------------------------------------------------
7142               0169                       ; Exit
7143               0170                       ;------------------------------------------------------
7144               0171               idx.entry.delete.exit:
7145               0172 696E 045B  20         b     *r11                  ; Return
7146               0173
7147               0174
7148               0175               ***************************************************************
7149               0176               * idx.entry.insert
7150               0177               * Insert index entry
7151               0178               ***************************************************************
7152               0179               * bl @idx.entry.insert
7153               0180               *--------------------------------------------------------------
7154               0181               * INPUT
7155               0182               * @parm1    = Line number in editor buffer to insert
7156               0183               * @parm2    = Line number of last line to check for reorg
7157               0184               *--------------------------------------------------------------
7158               0185               * OUTPUT
7159               0186               * NONE
7160               0187               *--------------------------------------------------------------
7161               0188               * Register usage
7162               0189               * tmp0,tmp2
7163               0190               *--------------------------------------------------------------
7164               0191               idx.entry.insert:
7165               0192 6970 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
7166                    6972 8352
7167               0193                       ;------------------------------------------------------
7168               0194                       ; Calculate address of index entry and save pointer
7169               0195                       ;------------------------------------------------------
7170               0196 6974 0A14  56         sla   tmp0,1                ; line number * 2
7171               0197                       ;------------------------------------------------------
7172               0198                       ; Prepare for index reorg
7173               0199                       ;------------------------------------------------------
7174               0200 6976 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
7175                    6978 8352
7176               0201 697A 61A0  34         s     @parm1,tmp2           ; Calculate loop
7177                    697C 8350
7178               0202 697E 160B  14         jne   idx.entry.insert.reorg
7179               0203                       ;------------------------------------------------------
7180               0204                       ; Special treatment if last line
7181               0205                       ;------------------------------------------------------
7182               0206 6980 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
7183                    6982 C000
7184                    6984 C002
7185               0207                                                   ; Move pointer
7186               0208 6986 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
7187                    6988 C000
7188               0209
7189               0210 698A C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
7190                    698C D000
7191                    698E D002
7192               0211                                                   ; Move SAMS page
7193               0212 6990 04E4  34         clr   @idx.shadow.top+0(tmp0)
7194                    6992 D000
7195               0213                                                   ; Clear new index entry
7196               0214 6994 100E  14         jmp   idx.entry.insert.exit
7197               0215                       ;------------------------------------------------------
7198               0216                       ; Reorganize index entries
7199               0217                       ;------------------------------------------------------
7200               0218               idx.entry.insert.reorg:
7201               0219 6996 05C6  14         inct  tmp2                  ; Adjust one time
7202               0220
7203               0221 6998 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
7204                    699A C000
7205                    699C C002
7206               0222                                                   ; Move pointer
7207               0223
7208               0224 699E C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
7209                    69A0 D000
7210                    69A2 D002
7211               0225                                                   ; Move SAMS page
7212               0226
7213               0227 69A4 0644  14         dect  tmp0                  ; Previous index entry
7214               0228 69A6 0606  14         dec   tmp2                  ; tmp2--
7215               0229 69A8 16F7  14         jne   -!                    ; Loop unless completed
7216               0230
7217               0231 69AA 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
7218                    69AC C004
7219               0232 69AE 04E4  34         clr   @idx.shadow.top+4(tmp0)
7220                    69B0 D004
7221               0233                                                   ; Clear new index entry
7222               0234                       ;------------------------------------------------------
7223               0235                       ; Exit
7224               0236                       ;------------------------------------------------------
7225               0237               idx.entry.insert.exit:
7226               0238 69B2 045B  20         b     *r11                  ; Return
7227               0239
7228               0240
7229               0241
7230               0242               ***************************************************************
7231               0243               * idx.pointer.get
7232               0244               * Get pointer to editor buffer line content
7233               0245               ***************************************************************
7234               0246               * bl @idx.pointer.get
7235               0247               *--------------------------------------------------------------
7236               0248               * INPUT
7237               0249               * @parm1 = Line number in editor buffer
7238               0250               *--------------------------------------------------------------
7239               0251               * OUTPUT
7240               0252               * @outparm1 = Pointer to editor buffer line content
7241               0253               * @outparm2 = SAMS page
7242               0254               *--------------------------------------------------------------
7243               0255               * Register usage
7244               0256               * tmp0,tmp1,tmp2
7245               0257               *--------------------------------------------------------------
7246               0258               idx.pointer.get:
7247               0259 69B4 0649  14         dect  stack
7248               0260 69B6 C64B  30         mov   r11,*stack            ; Save return address
7249               0261                       ;------------------------------------------------------
7250               0262                       ; Get pointer
7251               0263                       ;------------------------------------------------------
7252               0264 69B8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
7253                    69BA 8350
7254               0265                       ;------------------------------------------------------
7255               0266                       ; Calculate index entry
7256               0267                       ;------------------------------------------------------
7257               0268 69BC 0A14  56         sla   tmp0,1                ; line number * 2
7258               0269 69BE C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
7259                    69C0 C000
7260               0270 69C2 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
7261                    69C4 D000
7262               0271                                                   ; Get SAMS page
7263               0272                       ;------------------------------------------------------
7264               0273                       ; Return parameter
7265               0274                       ;------------------------------------------------------
7266               0275               idx.pointer.get.parm:
7267               0276 69C6 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
7268                    69C8 8360
7269               0277 69CA C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
7270                    69CC 8362
7271               0278                       ;------------------------------------------------------
7272               0279                       ; Exit
7273               0280                       ;------------------------------------------------------
7274               0281               idx.pointer.get.exit:
7275               0282 69CE 0460  28         b     @poprt                ; Return to caller
7276                    69D0 2212
7277               **** **** ****     > tivi_b1.asm.31428
7278               0048                       copy  "edb.asm"             ; Editor Buffer
7279               **** **** ****     > edb.asm
7280               0001               * FILE......: edb.asm
7281               0002               * Purpose...: TiVi Editor - Editor Buffer module
7282               0003
7283               0004               *//////////////////////////////////////////////////////////////
7284               0005               *        TiVi Editor - Editor Buffer implementation
7285               0006               *//////////////////////////////////////////////////////////////
7286               0007
7287               0008               ***************************************************************
7288               0009               * edb.init
7289               0010               * Initialize Editor buffer
7290               0011               ***************************************************************
7291               0012               * bl @edb.init
7292               0013               *--------------------------------------------------------------
7293               0014               * INPUT
7294               0015               * none
7295               0016               *--------------------------------------------------------------
7296               0017               * OUTPUT
7297               0018               * none
7298               0019               *--------------------------------------------------------------
7299               0020               * Register usage
7300               0021               * tmp0
7301               0022               *--------------------------------------------------------------
7302               0023               * Notes
7303               0024               ***************************************************************
7304               0025               edb.init:
7305               0026 69D2 0649  14         dect  stack
7306               0027 69D4 C64B  30         mov   r11,*stack            ; Save return address
7307               0028                       ;------------------------------------------------------
7308               0029                       ; Initialize
7309               0030                       ;------------------------------------------------------
7310               0031 69D6 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
7311                    69D8 E002
7312               0032                                                   ; with null pointer (has offset 0)
7313               0033
7314               0034 69DA C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
7315                    69DC A300
7316               0035 69DE C804  38         mov   tmp0,@edb.next_free.ptr
7317                    69E0 A308
7318               0036                                                   ; Set pointer to next free line in
7319               0037                                                   ; editor buffer
7320               0038
7321               0039 69E2 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
7322                    69E4 A30A
7323               0040 69E6 04E0  34         clr   @edb.lines            ; Lines=0
7324                    69E8 A304
7325               0041 69EA 04E0  34         clr   @edb.rle              ; RLE compression off
7326                    69EC A30C
7327               0042
7328               0043 69EE 0204  20         li    tmp0,txt.newfile      ; "New file"
7329                    69F0 7394
7330               0044 69F2 C804  38         mov   tmp0,@edb.filename.ptr
7331                    69F4 A30E
7332               0045
7333               0046 69F6 0204  20         li    tmp0,txt.filetype.none
7334                    69F8 73E0
7335               0047 69FA C804  38         mov   tmp0,@edb.filetype.ptr
7336                    69FC A310
7337               0048
7338               0049               edb.init.exit:
7339               0050                       ;------------------------------------------------------
7340               0051                       ; Exit
7341               0052                       ;------------------------------------------------------
7342               0053 69FE 0460  28         b     @poprt                ; Return to caller
7343                    6A00 2212
7344               0054
7345               0055
7346               0056
7347               0057               ***************************************************************
7348               0058               * edb.line.pack
7349               0059               * Pack current line in framebuffer
7350               0060               ***************************************************************
7351               0061               *  bl   @edb.line.pack
7352               0062               *--------------------------------------------------------------
7353               0063               * INPUT
7354               0064               * @fb.top       = Address of top row in frame buffer
7355               0065               * @fb.row       = Current row in frame buffer
7356               0066               * @fb.column    = Current column in frame buffer
7357               0067               * @fb.colsline  = Columns per line in frame buffer
7358               0068               *--------------------------------------------------------------
7359               0069               * OUTPUT
7360               0070               *--------------------------------------------------------------
7361               0071               * Register usage
7362               0072               * tmp0,tmp1,tmp2
7363               0073               *--------------------------------------------------------------
7364               0074               * Memory usage
7365               0075               * rambuf   = Saved @fb.column
7366               0076               * rambuf+2 = Saved beginning of row
7367               0077               * rambuf+4 = Saved length of row
7368               0078               ********|*****|*********************|**************************
7369               0079               edb.line.pack:
7370               0080 6A02 0649  14         dect  stack
7371               0081 6A04 C64B  30         mov   r11,*stack            ; Save return address
7372               0082                       ;------------------------------------------------------
7373               0083                       ; Get values
7374               0084                       ;------------------------------------------------------
7375               0085 6A06 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
7376                    6A08 A28C
7377                    6A0A 8390
7378               0086 6A0C 04E0  34         clr   @fb.column
7379                    6A0E A28C
7380               0087 6A10 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
7381                    6A12 681E
7382               0088                       ;------------------------------------------------------
7383               0089                       ; Prepare scan
7384               0090                       ;------------------------------------------------------
7385               0091 6A14 04C4  14         clr   tmp0                  ; Counter
7386               0092 6A16 C160  34         mov   @fb.current,tmp1      ; Get position
7387                    6A18 A282
7388               0093 6A1A C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
7389                    6A1C 8392
7390               0094
7391               0095                       ;------------------------------------------------------
7392               0096                       ; Scan line for >00 byte termination
7393               0097                       ;------------------------------------------------------
7394               0098               edb.line.pack.scan:
7395               0099 6A1E D1B5  28         movb  *tmp1+,tmp2           ; Get char
7396               0100 6A20 0986  56         srl   tmp2,8                ; Right justify
7397               0101 6A22 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
7398               0102 6A24 0584  14         inc   tmp0                  ; Increase string length
7399               0103 6A26 10FB  14         jmp   edb.line.pack.scan    ; Next character
7400               0104
7401               0105                       ;------------------------------------------------------
7402               0106                       ; Prepare for storing line
7403               0107                       ;------------------------------------------------------
7404               0108               edb.line.pack.prepare:
7405               0109 6A28 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
7406                    6A2A A284
7407                    6A2C 8350
7408               0110 6A2E A820  54         a     @fb.row,@parm1        ; /
7409                    6A30 A286
7410                    6A32 8350
7411               0111
7412               0112 6A34 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
7413                    6A36 8394
7414               0113
7415               0114                       ;------------------------------------------------------
7416               0115                       ; 1. Update index
7417               0116                       ;------------------------------------------------------
7418               0117               edb.line.pack.update_index:
7419               0118 6A38 C120  34         mov   @edb.next_free.ptr,tmp0
7420                    6A3A A308
7421               0119 6A3C C804  38         mov   tmp0,@parm2           ; Block where line will reside
7422                    6A3E 8352
7423               0120
7424               0121 6A40 06A0  32         bl    @xsams.page.get       ; Get SAMS page
7425                    6A42 24C4
7426               0122                                                   ; \ i  tmp0  = Memory address
7427               0123                                                   ; | o  waux1 = SAMS page number
7428               0124                                                   ; / o  waux2 = Address of SAMS register
7429               0125
7430               0126 6A44 C820  54         mov   @waux1,@parm3
7431                    6A46 833C
7432                    6A48 8354
7433               0127 6A4A 06A0  32         bl    @idx.entry.update     ; Update index
7434                    6A4C 691E
7435               0128                                                   ; \ i  parm1 = Line number in editor buffer
7436               0129                                                   ; | i  parm2 = pointer to line in
7437               0130                                                   ; |            editor buffer
7438               0131                                                   ; / i  parm3 = SAMS page
7439               0132
7440               0133                       ;------------------------------------------------------
7441               0134                       ; 2. Switch to required SAMS page
7442               0135                       ;------------------------------------------------------
7443               0136 6A4E 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
7444                    6A50 A312
7445                    6A52 8354
7446               0137 6A54 1308  14         jeq   !                     ; Yes, skip setting page
7447               0138
7448               0139 6A56 C120  34         mov   @parm3,tmp0           ; get SAMS page
7449                    6A58 8354
7450               0140 6A5A C160  34         mov   @edb.next_free.ptr,tmp1
7451                    6A5C A308
7452               0141                                                   ; Pointer to line in editor buffer
7453               0142 6A5E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
7454                    6A60 24FC
7455               0143                                                   ; \ i  tmp0 = SAMS page
7456               0144                                                   ; / i  tmp1 = Memory address
7457               0145
7458               0146 6A62 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
7459                    6A64 A438
7460               0147
7461               0148                       ;------------------------------------------------------
7462               0149                       ; 3. Set line prefix in editor buffer
7463               0150                       ;------------------------------------------------------
7464               0151 6A66 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
7465                    6A68 8392
7466               0152 6A6A C160  34         mov   @edb.next_free.ptr,tmp1
7467                    6A6C A308
7468               0153                                                   ; Address of line in editor buffer
7469               0154
7470               0155 6A6E 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
7471                    6A70 A308
7472               0156
7473               0157 6A72 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
7474                    6A74 8394
7475               0158 6A76 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
7476               0159 6A78 06C6  14         swpb  tmp2
7477               0160 6A7A DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
7478               0161 6A7C 06C6  14         swpb  tmp2
7479               0162 6A7E 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
7480               0163
7481               0164                       ;------------------------------------------------------
7482               0165                       ; 4. Copy line from framebuffer to editor buffer
7483               0166                       ;------------------------------------------------------
7484               0167               edb.line.pack.copyline:
7485               0168 6A80 0286  22         ci    tmp2,2
7486                    6A82 0002
7487               0169 6A84 1603  14         jne   edb.line.pack.copyline.checkbyte
7488               0170 6A86 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
7489               0171 6A88 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
7490               0172 6A8A 1007  14         jmp   !
7491               0173               edb.line.pack.copyline.checkbyte:
7492               0174 6A8C 0286  22         ci    tmp2,1
7493                    6A8E 0001
7494               0175 6A90 1602  14         jne   edb.line.pack.copyline.block
7495               0176 6A92 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
7496               0177 6A94 1002  14         jmp   !
7497               0178               edb.line.pack.copyline.block:
7498               0179 6A96 06A0  32         bl    @xpym2m               ; Copy memory block
7499                    6A98 2466
7500               0180                                                   ; \ i  tmp0 = source
7501               0181                                                   ; | i  tmp1 = destination
7502               0182                                                   ; / i  tmp2 = bytes to copy
7503               0183
7504               0184 6A9A A820  54 !       a     @rambuf+4,@edb.next_free.ptr
7505                    6A9C 8394
7506                    6A9E A308
7507               0185                                                   ; Update pointer to next free line
7508               0186
7509               0187                       ;------------------------------------------------------
7510               0188                       ; Exit
7511               0189                       ;------------------------------------------------------
7512               0190               edb.line.pack.exit:
7513               0191 6AA0 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
7514                    6AA2 8390
7515                    6AA4 A28C
7516               0192 6AA6 0460  28         b     @poprt                ; Return to caller
7517                    6AA8 2212
7518               0193
7519               0194
7520               0195
7521               0196
7522               0197               ***************************************************************
7523               0198               * edb.line.unpack
7524               0199               * Unpack specified line to framebuffer
7525               0200               ***************************************************************
7526               0201               *  bl   @edb.line.unpack
7527               0202               *--------------------------------------------------------------
7528               0203               * INPUT
7529               0204               * @parm1 = Line to unpack in editor buffer
7530               0205               * @parm2 = Target row in frame buffer
7531               0206               *--------------------------------------------------------------
7532               0207               * OUTPUT
7533               0208               * none
7534               0209               *--------------------------------------------------------------
7535               0210               * Register usage
7536               0211               * tmp0,tmp1,tmp2,tmp3,tmp4
7537               0212               *--------------------------------------------------------------
7538               0213               * Memory usage
7539               0214               * rambuf    = Saved @parm1 of edb.line.unpack
7540               0215               * rambuf+2  = Saved @parm2 of edb.line.unpack
7541               0216               * rambuf+4  = Source memory address in editor buffer
7542               0217               * rambuf+6  = Destination memory address in frame buffer
7543               0218               * rambuf+8  = Length of RLE (decompressed) line
7544               0219               * rambuf+10 = Length of RLE compressed line
7545               0220               ********|*****|*********************|**************************
7546               0221               edb.line.unpack:
7547               0222 6AAA 0649  14         dect  stack
7548               0223 6AAC C64B  30         mov   r11,*stack            ; Save return address
7549               0224                       ;------------------------------------------------------
7550               0225                       ; Sanity check
7551               0226                       ;------------------------------------------------------
7552               0227 6AAE 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
7553                    6AB0 8350
7554                    6AB2 A304
7555               0228 6AB4 1104  14         jlt   !
7556               0229 6AB6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
7557                    6AB8 FFCE
7558               0230 6ABA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
7559                    6ABC 2030
7560               0231                       ;------------------------------------------------------
7561               0232                       ; Save parameters
7562               0233                       ;------------------------------------------------------
7563               0234 6ABE C820  54 !       mov   @parm1,@rambuf
7564                    6AC0 8350
7565                    6AC2 8390
7566               0235 6AC4 C820  54         mov   @parm2,@rambuf+2
7567                    6AC6 8352
7568                    6AC8 8392
7569               0236                       ;------------------------------------------------------
7570               0237                       ; Calculate offset in frame buffer
7571               0238                       ;------------------------------------------------------
7572               0239 6ACA C120  34         mov   @fb.colsline,tmp0
7573                    6ACC A28E
7574               0240 6ACE 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
7575                    6AD0 8352
7576               0241 6AD2 C1A0  34         mov   @fb.top.ptr,tmp2
7577                    6AD4 A280
7578               0242 6AD6 A146  18         a     tmp2,tmp1             ; Add base to offset
7579               0243 6AD8 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
7580                    6ADA 8396
7581               0244                       ;------------------------------------------------------
7582               0245                       ; Get pointer to line & page-in editor buffer page
7583               0246                       ;------------------------------------------------------
7584               0247 6ADC C120  34         mov   @parm1,tmp0
7585                    6ADE 8350
7586               0248 6AE0 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
7587                    6AE2 6762
7588               0249                                                   ; \ i  tmp0     = Line number
7589               0250                                                   ; | o  outparm1 = Pointer to line
7590               0251                                                   ; / o  outparm2 = SAMS page
7591               0252
7592               0253 6AE4 C820  54         mov   @outparm2,@edb.sams.page
7593                    6AE6 8362
7594                    6AE8 A312
7595               0254                                                   ; Save current SAMS page
7596               0255
7597               0256 6AEA 05E0  34         inct  @outparm1             ; Skip line prefix
7598                    6AEC 8360
7599               0257 6AEE C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
7600                    6AF0 8360
7601                    6AF2 8394
7602               0258                       ;------------------------------------------------------
7603               0259                       ; Get length of line to unpack
7604               0260                       ;------------------------------------------------------
7605               0261 6AF4 06A0  32         bl    @edb.line.getlength   ; Get length of line
7606                    6AF6 6B62
7607               0262                                                   ; \ i  parm1    = Line number
7608               0263                                                   ; | o  outparm1 = Line length (uncompressed)
7609               0264                                                   ; | o  outparm2 = Line length (compressed)
7610               0265                                                   ; / o  outparm3 = SAMS page
7611               0266
7612               0267 6AF8 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
7613                    6AFA 8362
7614                    6AFC 839A
7615               0268 6AFE C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
7616                    6B00 8360
7617                    6B02 8398
7618               0269 6B04 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line
7619               0270                       ;------------------------------------------------------
7620               0271                       ; Handle possible "line split" between 2 consecutive pages
7621               0272                       ;------------------------------------------------------
7622               0273 6B06 C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
7623                    6B08 8394
7624               0274 6B0A C144  18         mov     tmp0,tmp1           ; Pointer to line
7625               0275 6B0C A160  34         a       @rambuf+8,tmp1      ; Add length of line
7626                    6B0E 8398
7627               0276
7628               0277 6B10 0244  22         andi    tmp0,>f000          ; Only keep high nibble
7629                    6B12 F000
7630               0278 6B14 0245  22         andi    tmp1,>f000          ; Only keep high nibble
7631                    6B16 F000
7632               0279 6B18 8144  18         c       tmp0,tmp1           ; Same segment?
7633               0280 6B1A 1305  14         jeq     edb.line.unpack.clear
7634               0281                                                   ; Yes, so skip
7635               0282
7636               0283 6B1C C120  34         mov     @outparm3,tmp0      ; Get SAMS page
7637                    6B1E 8364
7638               0284 6B20 0584  14         inc     tmp0                ; Next sams page
7639               0285
7640               0286 6B22 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
7641                    6B24 24FC
7642               0287                                                   ; | i  tmp0 = SAMS page number
7643               0288                                                   ; / i  tmp1 = Memory Address
7644               0289
7645               0290                       ;------------------------------------------------------
7646               0291                       ; Erase chars from last column until column 80
7647               0292                       ;------------------------------------------------------
7648               0293               edb.line.unpack.clear:
7649               0294 6B26 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
7650                    6B28 8396
7651               0295 6B2A A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
7652                    6B2C 8398
7653               0296
7654               0297 6B2E 04C5  14         clr   tmp1                  ; Fill with >00
7655               0298 6B30 C1A0  34         mov   @fb.colsline,tmp2
7656                    6B32 A28E
7657               0299 6B34 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
7658                    6B36 8398
7659               0300 6B38 0586  14         inc   tmp2
7660               0301
7661               0302 6B3A 06A0  32         bl    @xfilm                ; Fill CPU memory
7662                    6B3C 221C
7663               0303                                                   ; \ i  tmp0 = Target address
7664               0304                                                   ; | i  tmp1 = Byte to fill
7665               0305                                                   ; / i  tmp2 = Repeat count
7666               0306                       ;------------------------------------------------------
7667               0307                       ; Prepare for unpacking data
7668               0308                       ;------------------------------------------------------
7669               0309               edb.line.unpack.prepare:
7670               0310 6B3E C1A0  34         mov   @rambuf+8,tmp2        ; Line length
7671                    6B40 8398
7672               0311 6B42 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
7673               0312 6B44 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
7674                    6B46 8394
7675               0313 6B48 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
7676                    6B4A 8396
7677               0314                       ;------------------------------------------------------
7678               0315                       ; Check before copy
7679               0316                       ;------------------------------------------------------
7680               0317               edb.line.unpack.copy.uncompressed:
7681               0318 6B4C 0286  22         ci    tmp2,80               ; Check line length
7682                    6B4E 0050
7683               0319 6B50 1204  14         jle   !
7684               0320 6B52 C80B  38         mov   r11,@>ffce            ; \ Save caller address
7685                    6B54 FFCE
7686               0321 6B56 06A0  32         bl    @cpu.crash            ; / Crash and halt system
7687                    6B58 2030
7688               0322                       ;------------------------------------------------------
7689               0323                       ; Copy memory block
7690               0324                       ;------------------------------------------------------
7691               0325 6B5A 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
7692                    6B5C 2466
7693               0326                                                   ; \ i  tmp0 = Source address
7694               0327                                                   ; | i  tmp1 = Target address
7695               0328                                                   ; / i  tmp2 = Bytes to copy
7696               0329                       ;------------------------------------------------------
7697               0330                       ; Exit
7698               0331                       ;------------------------------------------------------
7699               0332               edb.line.unpack.exit:
7700               0333 6B5E 0460  28         b     @poprt                ; Return to caller
7701                    6B60 2212
7702               0334
7703               0335
7704               0336
7705               0337
7706               0338               ***************************************************************
7707               0339               * edb.line.getlength
7708               0340               * Get length of specified line
7709               0341               ***************************************************************
7710               0342               *  bl   @edb.line.getlength
7711               0343               *--------------------------------------------------------------
7712               0344               * INPUT
7713               0345               * @parm1 = Line number
7714               0346               *--------------------------------------------------------------
7715               0347               * OUTPUT
7716               0348               * @outparm1 = Length of line (uncompressed)
7717               0349               * @outparm2 = Length of line (compressed)
7718               0350               * @outparm3 = SAMS page
7719               0351               *--------------------------------------------------------------
7720               0352               * Register usage
7721               0353               * tmp0,tmp1,tmp2
7722               0354               ********|*****|*********************|**************************
7723               0355               edb.line.getlength:
7724               0356 6B62 0649  14         dect  stack
7725               0357 6B64 C64B  30         mov   r11,*stack            ; Save return address
7726               0358                       ;------------------------------------------------------
7727               0359                       ; Initialisation
7728               0360                       ;------------------------------------------------------
7729               0361 6B66 04E0  34         clr   @outparm1             ; Reset uncompressed length
7730                    6B68 8360
7731               0362 6B6A 04E0  34         clr   @outparm2             ; Reset compressed length
7732                    6B6C 8362
7733               0363 6B6E 04E0  34         clr   @outparm3             ; Reset SAMS bank
7734                    6B70 8364
7735               0364                       ;------------------------------------------------------
7736               0365                       ; Get length
7737               0366                       ;------------------------------------------------------
7738               0367 6B72 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
7739                    6B74 69B4
7740               0368                                                   ; \ i  parm1    = Line number
7741               0369                                                   ; | o  outparm1 = Pointer to line
7742               0370                                                   ; / o  outparm2 = SAMS page
7743               0371
7744               0372 6B76 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
7745                    6B78 8360
7746               0373 6B7A 130D  14         jeq   edb.line.getlength.exit
7747               0374                                                   ; Exit early if NULL pointer
7748               0375 6B7C C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
7749                    6B7E 8362
7750                    6B80 8364
7751               0376                       ;------------------------------------------------------
7752               0377                       ; Process line prefix
7753               0378                       ;------------------------------------------------------
7754               0379 6B82 04C5  14         clr   tmp1
7755               0380 6B84 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
7756               0381 6B86 06C5  14         swpb  tmp1
7757               0382 6B88 C805  38         mov   tmp1,@outparm2        ; Save length
7758                    6B8A 8362
7759               0383
7760               0384 6B8C 04C5  14         clr   tmp1
7761               0385 6B8E D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
7762               0386 6B90 06C5  14         swpb  tmp1
7763               0387 6B92 C805  38         mov   tmp1,@outparm1        ; Save length
7764                    6B94 8360
7765               0388                       ;------------------------------------------------------
7766               0389                       ; Exit
7767               0390                       ;------------------------------------------------------
7768               0391               edb.line.getlength.exit:
7769               0392 6B96 0460  28         b     @poprt                ; Return to caller
7770                    6B98 2212
7771               0393
7772               0394
7773               0395
7774               0396
7775               0397               ***************************************************************
7776               0398               * edb.line.getlength2
7777               0399               * Get length of current row (as seen from editor buffer side)
7778               0400               ***************************************************************
7779               0401               *  bl   @edb.line.getlength2
7780               0402               *--------------------------------------------------------------
7781               0403               * INPUT
7782               0404               * @fb.row = Row in frame buffer
7783               0405               *--------------------------------------------------------------
7784               0406               * OUTPUT
7785               0407               * @fb.row.length = Length of row
7786               0408               *--------------------------------------------------------------
7787               0409               * Register usage
7788               0410               * tmp0
7789               0411               ********|*****|*********************|**************************
7790               0412               edb.line.getlength2:
7791               0413 6B9A 0649  14         dect  stack
7792               0414 6B9C C64B  30         mov   r11,*stack            ; Save return address
7793               0415                       ;------------------------------------------------------
7794               0416                       ; Calculate line in editor buffer
7795               0417                       ;------------------------------------------------------
7796               0418 6B9E C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
7797                    6BA0 A284
7798               0419 6BA2 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
7799                    6BA4 A286
7800               0420                       ;------------------------------------------------------
7801               0421                       ; Get length
7802               0422                       ;------------------------------------------------------
7803               0423 6BA6 C804  38         mov   tmp0,@parm1
7804                    6BA8 8350
7805               0424 6BAA 06A0  32         bl    @edb.line.getlength
7806                    6BAC 6B62
7807               0425 6BAE C820  54         mov   @outparm1,@fb.row.length
7808                    6BB0 8360
7809                    6BB2 A288
7810               0426                                                   ; Save row length
7811               0427                       ;------------------------------------------------------
7812               0428                       ; Exit
7813               0429                       ;------------------------------------------------------
7814               0430               edb.line.getlength2.exit:
7815               0431 6BB4 0460  28         b     @poprt                ; Return to caller
7816                    6BB6 2212
7817               0432
7818               **** **** ****     > tivi_b1.asm.31428
7819               0049                       copy  "cmdb.asm"            ; Command Buffer
7820               **** **** ****     > cmdb.asm
7821               0001               * FILE......: cmdb.asm
7822               0002               * Purpose...: TiVi Editor - Command Buffer module
7823               0003
7824               0004               *//////////////////////////////////////////////////////////////
7825               0005               *        TiVi Editor - Command Buffer implementation
7826               0006               *//////////////////////////////////////////////////////////////
7827               0007
7828               0008
7829               0009               ***************************************************************
7830               0010               * cmdb.init
7831               0011               * Initialize Command Buffer
7832               0012               ***************************************************************
7833               0013               * bl @cmdb.init
7834               0014               *--------------------------------------------------------------
7835               0015               * INPUT
7836               0016               * none
7837               0017               *--------------------------------------------------------------
7838               0018               * OUTPUT
7839               0019               * none
7840               0020               *--------------------------------------------------------------
7841               0021               * Register usage
7842               0022               * none
7843               0023               *--------------------------------------------------------------
7844               0024               * Notes
7845               0025               ********|*****|*********************|**************************
7846               0026               cmdb.init:
7847               0027 6BB8 0649  14         dect  stack
7848               0028 6BBA C64B  30         mov   r11,*stack            ; Save return address
7849               0029                       ;------------------------------------------------------
7850               0030                       ; Initialize
7851               0031                       ;------------------------------------------------------
7852               0032 6BBC 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
7853                    6BBE B000
7854               0033 6BC0 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
7855                    6BC2 A500
7856               0034
7857               0035 6BC4 04E0  34         clr   @cmdb.visible         ; Hide command buffer
7858                    6BC6 A502
7859               0036 6BC8 0204  20         li    tmp0,10
7860                    6BCA 000A
7861               0037 6BCC C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
7862                    6BCE A504
7863               0038 6BD0 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
7864                    6BD2 A506
7865               0039
7866               0040 6BD4 0204  20         li    tmp0,>1b02            ; Y=27, X=2
7867                    6BD6 1B02
7868               0041 6BD8 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
7869                    6BDA A508
7870               0042
7871               0043 6BDC 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
7872                    6BDE A50E
7873               0044 6BE0 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
7874                    6BE2 A510
7875               0045                       ;------------------------------------------------------
7876               0046                       ; Clear command buffer
7877               0047                       ;------------------------------------------------------
7878               0048 6BE4 06A0  32         bl    @film
7879                    6BE6 2216
7880               0049 6BE8 B000             data  cmdb.top,>00,cmdb.size
7881                    6BEA 0000
7882                    6BEC 1000
7883               0050                                                   ; Clear it all the way
7884               0051               cmdb.init.exit:
7885               0052                       ;------------------------------------------------------
7886               0053                       ; Exit
7887               0054                       ;------------------------------------------------------
7888               0055 6BEE C2F9  30         mov   *stack+,r11           ; Pop r11
7889               0056 6BF0 045B  20         b     *r11                  ; Return to caller
7890               0057
7891               0058
7892               0059
7893               0060
7894               0061               ***************************************************************
7895               0062               * cmdb.show
7896               0063               * Show command buffer pane
7897               0064               ***************************************************************
7898               0065               * bl @cmdb.show
7899               0066               *--------------------------------------------------------------
7900               0067               * INPUT
7901               0068               * none
7902               0069               *--------------------------------------------------------------
7903               0070               * OUTPUT
7904               0071               * none
7905               0072               *--------------------------------------------------------------
7906               0073               * Register usage
7907               0074               * none
7908               0075               *--------------------------------------------------------------
7909               0076               * Notes
7910               0077               ********|*****|*********************|**************************
7911               0078               cmdb.show:
7912               0079 6BF2 0649  14         dect  stack
7913               0080 6BF4 C64B  30         mov   r11,*stack            ; Save return address
7914               0081 6BF6 0649  14         dect  stack
7915               0082 6BF8 C644  30         mov   tmp0,*stack           ; Push tmp0
7916               0083                       ;------------------------------------------------------
7917               0084                       ; Show command buffer pane
7918               0085                       ;------------------------------------------------------
7919               0086 6BFA C820  54         mov   @wyx,@cmdb.fb.yxsave
7920                    6BFC 832A
7921                    6BFE A512
7922               0087                                                   ; Save YX position in frame buffer
7923               0088
7924               0089 6C00 C120  34         mov   @fb.scrrows.max,tmp0
7925                    6C02 A29A
7926               0090 6C04 6120  34         s     @cmdb.scrrows,tmp0
7927                    6C06 A504
7928               0091 6C08 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
7929                    6C0A A298
7930               0092
7931               0093 6C0C 05C4  14         inct  tmp0                  ; Line below cmdb top border line
7932               0094 6C0E 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
7933               0095 6C10 0584  14         inc   tmp0                  ; X=1
7934               0096 6C12 C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
7935                    6C14 A50C
7936               0097
7937               0098 6C16 0720  34         seto  @cmdb.visible         ; Show pane
7938                    6C18 A502
7939               0099
7940               0100 6C1A 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
7941                    6C1C 0001
7942               0101 6C1E C804  38         mov   tmp0,@tv.pane.focus   ; /
7943                    6C20 A216
7944               0102
7945               0103 6C22 0720  34         seto  @fb.dirty             ; Redraw framebuffer
7946                    6C24 A296
7947               0104
7948               0105               cmdb.show.exit:
7949               0106                       ;------------------------------------------------------
7950               0107                       ; Exit
7951               0108                       ;------------------------------------------------------
7952               0109 6C26 C139  30         mov   *stack+,tmp0          ; Pop tmp0
7953               0110 6C28 C2F9  30         mov   *stack+,r11           ; Pop r11
7954               0111 6C2A 045B  20         b     *r11                  ; Return to caller
7955               0112
7956               0113
7957               0114
7958               0115               ***************************************************************
7959               0116               * cmdb.hide
7960               0117               * Hide command buffer pane
7961               0118               ***************************************************************
7962               0119               * bl @cmdb.hide
7963               0120               *--------------------------------------------------------------
7964               0121               * INPUT
7965               0122               * none
7966               0123               *--------------------------------------------------------------
7967               0124               * OUTPUT
7968               0125               * none
7969               0126               *--------------------------------------------------------------
7970               0127               * Register usage
7971               0128               * none
7972               0129               *--------------------------------------------------------------
7973               0130               * Hiding the command buffer automatically passes pane focus
7974               0131               * to frame buffer.
7975               0132               ********|*****|*********************|**************************
7976               0133               cmdb.hide:
7977               0134 6C2C 0649  14         dect  stack
7978               0135 6C2E C64B  30         mov   r11,*stack            ; Save return address
7979               0136                       ;------------------------------------------------------
7980               0137                       ; Hide command buffer pane
7981               0138                       ;------------------------------------------------------
7982               0139 6C30 C820  54         mov   @fb.scrrows.max,@fb.scrrows
7983                    6C32 A29A
7984                    6C34 A298
7985               0140                                                   ; Resize framebuffer
7986               0141
7987               0142 6C36 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
7988                    6C38 A512
7989                    6C3A 832A
7990               0143
7991               0144 6C3C 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
7992                    6C3E A502
7993               0145 6C40 0720  34         seto  @fb.dirty             ; Redraw framebuffer
7994                    6C42 A296
7995               0146 6C44 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
7996                    6C46 A216
7997               0147
7998               0148               cmdb.hide.exit:
7999               0149                       ;------------------------------------------------------
8000               0150                       ; Exit
8001               0151                       ;------------------------------------------------------
8002               0152 6C48 C2F9  30         mov   *stack+,r11           ; Pop r11
8003               0153 6C4A 045B  20         b     *r11                  ; Return to caller
8004               0154
8005               0155
8006               0156
8007               0157               ***************************************************************
8008               0158               * cmdb.refresh
8009               0159               * Refresh command buffer content
8010               0160               ***************************************************************
8011               0161               * bl @cmdb.refresh
8012               0162               *--------------------------------------------------------------
8013               0163               * INPUT
8014               0164               * none
8015               0165               *--------------------------------------------------------------
8016               0166               * OUTPUT
8017               0167               * none
8018               0168               *--------------------------------------------------------------
8019               0169               * Register usage
8020               0170               * none
8021               0171               *--------------------------------------------------------------
8022               0172               * Notes
8023               0173               ********|*****|*********************|**************************
8024               0174               cmdb.refresh:
8025               0175 6C4C 0649  14         dect  stack
8026               0176 6C4E C64B  30         mov   r11,*stack            ; Save return address
8027               0177 6C50 0649  14         dect  stack
8028               0178 6C52 C644  30         mov   tmp0,*stack           ; Push tmp0
8029               0179 6C54 0649  14         dect  stack
8030               0180 6C56 C645  30         mov   tmp1,*stack           ; Push tmp1
8031               0181 6C58 0649  14         dect  stack
8032               0182 6C5A C646  30         mov   tmp2,*stack           ; Push tmp2
8033               0183                       ;------------------------------------------------------
8034               0184                       ; Dump Command buffer content
8035               0185                       ;------------------------------------------------------
8036               0186 6C5C C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
8037                    6C5E 832A
8038                    6C60 A50A
8039               0187
8040               0188 6C62 C820  54         mov   @cmdb.yxtop,@wyx
8041                    6C64 A50C
8042                    6C66 832A
8043               0189 6C68 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
8044                    6C6A 23DA
8045               0190
8046               0191 6C6C C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
8047                    6C6E A500
8048               0192 6C70 0206  20         li    tmp2,9*80
8049                    6C72 02D0
8050               0193
8051               0194 6C74 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
8052                    6C76 241E
8053               0195                                                   ; | i  tmp0 = VDP target address
8054               0196                                                   ; | i  tmp1 = RAM source address
8055               0197                                                   ; / i  tmp2 = Number of bytes to copy
8056               0198
8057               0199                       ;------------------------------------------------------
8058               0200                       ; Show command buffer prompt
8059               0201                       ;------------------------------------------------------
8060               0202 6C78 06A0  32         bl    @putat
8061                    6C7A 2410
8062               0203 6C7C 1B01                   byte 27,1
8063               0204 6C7E 73A0                   data txt.cmdb.prompt
8064               0205
8065               0206 6C80 C820  54         mov   @cmdb.yxsave,@fb.yxsave
8066                    6C82 A50A
8067                    6C84 A294
8068               0207 6C86 C820  54         mov   @cmdb.yxsave,@wyx
8069                    6C88 A50A
8070                    6C8A 832A
8071               0208                                                   ; Restore YX position
8072               0209               cmdb.refresh.exit:
8073               0210                       ;------------------------------------------------------
8074               0211                       ; Exit
8075               0212                       ;------------------------------------------------------
8076               0213 6C8C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
8077               0214 6C8E C179  30         mov   *stack+,tmp1          ; Pop tmp1
8078               0215 6C90 C139  30         mov   *stack+,tmp0          ; Pop tmp0
8079               0216 6C92 C2F9  30         mov   *stack+,r11           ; Pop r11
8080               0217 6C94 045B  20         b     *r11                  ; Return to caller
8081               0218
8082               **** **** ****     > tivi_b1.asm.31428
8083               0050                       copy  "fh.read.sams.asm"    ; File handler read file
8084               **** **** ****     > fh.read.sams.asm
8085               0001               * FILE......: fh.read.sams.asm
8086               0002               * Purpose...: File reader module (SAMS implementation)
8087               0003
8088               0004               *//////////////////////////////////////////////////////////////
8089               0005               *                  Read file into editor buffer
8090               0006               *//////////////////////////////////////////////////////////////
8091               0007
8092               0008
8093               0009               ***************************************************************
8094               0010               * fh.file.read.sams
8095               0011               * Read file into editor buffer with SAMS support
8096               0012               ***************************************************************
8097               0013               *  bl   @fh.file.read.sams
8098               0014               *--------------------------------------------------------------
8099               0015               * INPUT
8100               0016               * parm1 = Pointer to length-prefixed file descriptor
8101               0017               * parm2 = Pointer to callback function "loading indicator 1"
8102               0018               * parm3 = Pointer to callback function "loading indicator 2"
8103               0019               * parm4 = Pointer to callback function "loading indicator 3"
8104               0020               * parm5 = Pointer to callback function "File I/O error handler"
8105               0021               * parm6 = Not used yet (starting line in file)
8106               0022               * parm7 = Not used yet (starting line in editor buffer)
8107               0023               * parm8 = Not used yet (number of lines to read)
8108               0024               *--------------------------------------------------------------
8109               0025               * OUTPUT
8110               0026               *--------------------------------------------------------------
8111               0027               * Register usage
8112               0028               * tmp0, tmp1, tmp2, tmp3, tmp4
8113               0029               ********|*****|*********************|**************************
8114               0030               fh.file.read.sams:
8115               0031 6C96 0649  14         dect  stack
8116               0032 6C98 C64B  30         mov   r11,*stack            ; Save return address
8117               0033                       ;------------------------------------------------------
8118               0034                       ; Initialisation
8119               0035                       ;------------------------------------------------------
8120               0036 6C9A 04E0  34         clr   @fh.rleonload         ; No RLE compression!
8121                    6C9C A444
8122               0037 6C9E 04E0  34         clr   @fh.records           ; Reset records counter
8123                    6CA0 A42E
8124               0038 6CA2 04E0  34         clr   @fh.counter           ; Clear internal counter
8125                    6CA4 A434
8126               0039 6CA6 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
8127                    6CA8 A432
8128               0040 6CAA 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
8129               0041 6CAC 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
8130                    6CAE A42A
8131               0042 6CB0 04E0  34         clr   @fh.ioresult          ; Clear status register contents
8132                    6CB2 A42C
8133               0043
8134               0044 6CB4 0204  20         li    tmp0,3
8135                    6CB6 0003
8136               0045 6CB8 C804  38         mov   tmp0,@fh.sams.page    ; Set current SAMS page
8137                    6CBA A438
8138               0046 6CBC C804  38         mov   tmp0,@fh.sams.hpage   ; Set highest SAMS page in use
8139                    6CBE A43A
8140               0047                       ;------------------------------------------------------
8141               0048                       ; Save parameters / callback functions
8142               0049                       ;------------------------------------------------------
8143               0050 6CC0 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
8144                    6CC2 8350
8145                    6CC4 A436
8146               0051 6CC6 C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
8147                    6CC8 8352
8148                    6CCA A43C
8149               0052 6CCC C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
8150                    6CCE 8354
8151                    6CD0 A43E
8152               0053 6CD2 C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
8153                    6CD4 8356
8154                    6CD6 A440
8155               0054 6CD8 C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
8156                    6CDA 8358
8157                    6CDC A442
8158               0055                       ;------------------------------------------------------
8159               0056                       ; Sanity check
8160               0057                       ;------------------------------------------------------
8161               0058 6CDE C120  34         mov   @fh.callback1,tmp0
8162                    6CE0 A43C
8163               0059 6CE2 0284  22         ci    tmp0,>6000            ; Insane address ?
8164                    6CE4 6000
8165               0060 6CE6 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
8166               0061
8167               0062 6CE8 0284  22         ci    tmp0,>7fff            ; Insane address ?
8168                    6CEA 7FFF
8169               0063 6CEC 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
8170               0064
8171               0065 6CEE C120  34         mov   @fh.callback2,tmp0
8172                    6CF0 A43E
8173               0066 6CF2 0284  22         ci    tmp0,>6000            ; Insane address ?
8174                    6CF4 6000
8175               0067 6CF6 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
8176               0068
8177               0069 6CF8 0284  22         ci    tmp0,>7fff            ; Insane address ?
8178                    6CFA 7FFF
8179               0070 6CFC 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
8180               0071
8181               0072 6CFE C120  34         mov   @fh.callback3,tmp0
8182                    6D00 A440
8183               0073 6D02 0284  22         ci    tmp0,>6000            ; Insane address ?
8184                    6D04 6000
8185               0074 6D06 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
8186               0075
8187               0076 6D08 0284  22         ci    tmp0,>7fff            ; Insane address ?
8188                    6D0A 7FFF
8189               0077 6D0C 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
8190               0078
8191               0079 6D0E 1004  14         jmp   fh.file.read.sams.load1
8192               0080                                                   ; All checks passed, continue.
8193               0081                                                   ;--------------------------
8194               0082                                                   ; Check failed, crash CPU!
8195               0083                                                   ;--------------------------
8196               0084               fh.file.read.crash:
8197               0085 6D10 C80B  38         mov   r11,@>ffce            ; \ Save caller address
8198                    6D12 FFCE
8199               0086 6D14 06A0  32         bl    @cpu.crash            ; / Crash and halt system
8200                    6D16 2030
8201               0087                       ;------------------------------------------------------
8202               0088                       ; Show "loading indicator 1"
8203               0089                       ;------------------------------------------------------
8204               0090               fh.file.read.sams.load1:
8205               0091 6D18 C120  34         mov   @fh.callback1,tmp0
8206                    6D1A A43C
8207               0092 6D1C 0694  24         bl    *tmp0                 ; Run callback function
8208               0093                       ;------------------------------------------------------
8209               0094                       ; Copy PAB header to VDP
8210               0095                       ;------------------------------------------------------
8211               0096               fh.file.read.sams.pabheader:
8212               0097 6D1E 06A0  32         bl    @cpym2v
8213                    6D20 2418
8214               0098 6D22 0A60                   data fh.vpab,fh.file.pab.header,9
8215                    6D24 6EA6
8216                    6D26 0009
8217               0099                                                   ; Copy PAB header to VDP
8218               0100                       ;------------------------------------------------------
8219               0101                       ; Append file descriptor to PAB header in VDP
8220               0102                       ;------------------------------------------------------
8221               0103 6D28 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
8222                    6D2A 0A69
8223               0104 6D2C C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
8224                    6D2E A436
8225               0105 6D30 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
8226               0106 6D32 0986  56         srl   tmp2,8                ; Right justify
8227               0107 6D34 0586  14         inc   tmp2                  ; Include length byte as well
8228               0108 6D36 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
8229                    6D38 241E
8230               0109                       ;------------------------------------------------------
8231               0110                       ; Load GPL scratchpad layout
8232               0111                       ;------------------------------------------------------
8233               0112 6D3A 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
8234                    6D3C 2AA2
8235               0113 6D3E A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
8236               0114                       ;------------------------------------------------------
8237               0115                       ; Open file
8238               0116                       ;------------------------------------------------------
8239               0117 6D40 06A0  32         bl    @file.open
8240                    6D42 2BF0
8241               0118 6D44 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
8242               0119 6D46 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
8243                    6D48 2026
8244               0120 6D4A 1602  14         jne   fh.file.read.sams.record
8245               0121 6D4C 0460  28         b     @fh.file.read.sams.error
8246                    6D4E 6E70
8247               0122                                                   ; Yes, IO error occured
8248               0123                       ;------------------------------------------------------
8249               0124                       ; Step 1: Read file record
8250               0125                       ;------------------------------------------------------
8251               0126               fh.file.read.sams.record:
8252               0127 6D50 05A0  34         inc   @fh.records           ; Update counter
8253                    6D52 A42E
8254               0128 6D54 04E0  34         clr   @fh.reclen            ; Reset record length
8255                    6D56 A430
8256               0129
8257               0130 6D58 06A0  32         bl    @file.record.read     ; Read file record
8258                    6D5A 2C32
8259               0131 6D5C 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
8260               0132                                                   ; |           (without +9 offset!)
8261               0133                                                   ; | o  tmp0 = Status byte
8262               0134                                                   ; | o  tmp1 = Bytes read
8263               0135                                                   ; | o  tmp2 = Status register contents
8264               0136                                                   ; /           upon DSRLNK return
8265               0137
8266               0138 6D5E C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
8267                    6D60 A42A
8268               0139 6D62 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
8269                    6D64 A430
8270               0140 6D66 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
8271                    6D68 A42C
8272               0141                       ;------------------------------------------------------
8273               0142                       ; 1a: Calculate kilobytes processed
8274               0143                       ;------------------------------------------------------
8275               0144 6D6A A805  38         a     tmp1,@fh.counter
8276                    6D6C A434
8277               0145 6D6E A160  34         a     @fh.counter,tmp1
8278                    6D70 A434
8279               0146 6D72 0285  22         ci    tmp1,1024
8280                    6D74 0400
8281               0147 6D76 1106  14         jlt   !
8282               0148 6D78 05A0  34         inc   @fh.kilobytes
8283                    6D7A A432
8284               0149 6D7C 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
8285                    6D7E FC00
8286               0150 6D80 C805  38         mov   tmp1,@fh.counter
8287                    6D82 A434
8288               0151                       ;------------------------------------------------------
8289               0152                       ; 1b: Load spectra scratchpad layout
8290               0153                       ;------------------------------------------------------
8291               0154 6D84 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
8292                    6D86 2A28
8293               0155 6D88 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
8294                    6D8A 2AC4
8295               0156 6D8C A100                   data scrpad.backup2   ; / >2100->8300
8296               0157                       ;------------------------------------------------------
8297               0158                       ; 1c: Check if a file error occured
8298               0159                       ;------------------------------------------------------
8299               0160               fh.file.read.sams.check_fioerr:
8300               0161 6D8E C1A0  34         mov   @fh.ioresult,tmp2
8301                    6D90 A42C
8302               0162 6D92 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
8303                    6D94 2026
8304               0163 6D96 1602  14         jne   fh.file.read.sams.check_setpage
8305               0164                                                   ; No, goto (1d)
8306               0165 6D98 0460  28         b     @fh.file.read.sams.error
8307                    6D9A 6E70
8308               0166                                                   ; Yes, so handle file error
8309               0167                       ;------------------------------------------------------
8310               0168                       ; 1d: Check if SAMS page needs to be set
8311               0169                       ;------------------------------------------------------
8312               0170               fh.file.read.sams.check_setpage:
8313               0171 6D9C C120  34         mov   @edb.next_free.ptr,tmp0
8314                    6D9E A308
8315               0172 6DA0 06A0  32         bl    @xsams.page.get       ; Get SAMS page
8316                    6DA2 24C4
8317               0173                                                   ; \ i  tmp0  = Memory address
8318               0174                                                   ; | o  waux1 = SAMS page number
8319               0175                                                   ; / o  waux2 = Address of SAMS register
8320               0176
8321               0177 6DA4 C120  34         mov   @waux1,tmp0           ; Save SAMS page number
8322                    6DA6 833C
8323               0178 6DA8 8804  38         c     tmp0,@fh.sams.page   ; Compare page with current SAMS page
8324                    6DAA A438
8325               0179 6DAC 1310  14         jeq   fh.file.read.sams.nocompression
8326               0180                                                   ; Same, skip to (2)
8327               0181                       ;------------------------------------------------------
8328               0182                       ; 1e: Increase SAMS page if necessary
8329               0183                       ;------------------------------------------------------
8330               0184 6DAE 8804  38         c     tmp0,@fh.sams.hpage   ; Compare page with highest SAMS page
8331                    6DB0 A43A
8332               0185 6DB2 1502  14         jgt   fh.file.read.sams.switch
8333               0186                                                   ; Switch page
8334               0187 6DB4 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
8335                    6DB6 0005
8336               0188                       ;------------------------------------------------------
8337               0189                       ; 1f: Switch to SAMS page
8338               0190                       ;------------------------------------------------------
8339               0191               fh.file.read.sams.switch:
8340               0192 6DB8 C160  34         mov   @edb.next_free.ptr,tmp1
8341                    6DBA A308
8342               0193                                                   ; Beginning of line
8343               0194
8344               0195 6DBC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
8345                    6DBE 24FC
8346               0196                                                   ; \ i  tmp0 = SAMS page number
8347               0197                                                   ; / i  tmp1 = Memory address
8348               0198
8349               0199 6DC0 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
8350                    6DC2 A438
8351               0200
8352               0201 6DC4 8804  38         c     tmp0,@fh.sams.hpage   ; Current SAMS page > highest SAMS page?
8353                    6DC6 A43A
8354               0202 6DC8 1202  14         jle   fh.file.read.sams.nocompression
8355               0203                                                   ; No, skip to (2)
8356               0204 6DCA C804  38         mov   tmp0,@fh.sams.hpage   ; Update highest SAMS page
8357                    6DCC A43A
8358               0205                       ;------------------------------------------------------
8359               0206                       ; Step 2: Process line (without RLE compression)
8360               0207                       ;------------------------------------------------------
8361               0208               fh.file.read.sams.nocompression:
8362               0209 6DCE 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
8363                    6DD0 0960
8364               0210 6DD2 C160  34         mov   @edb.next_free.ptr,tmp1
8365                    6DD4 A308
8366               0211                                                   ; RAM target in editor buffer
8367               0212
8368               0213 6DD6 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
8369                    6DD8 8352
8370               0214
8371               0215 6DDA C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
8372                    6DDC A430
8373               0216 6DDE 1324  14         jeq   fh.file.read.sams.prepindex.emptyline
8374               0217                                                   ; Handle empty line
8375               0218                       ;------------------------------------------------------
8376               0219                       ; 2a: Copy line from VDP to CPU editor buffer
8377               0220                       ;------------------------------------------------------
8378               0221                                                   ; Save line prefix
8379               0222 6DE0 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
8380               0223 6DE2 06C6  14         swpb  tmp2                  ; |
8381               0224 6DE4 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
8382               0225 6DE6 06C6  14         swpb  tmp2                  ; /
8383               0226
8384               0227 6DE8 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
8385                    6DEA A308
8386               0228 6DEC A806  38         a     tmp2,@edb.next_free.ptr
8387                    6DEE A308
8388               0229                                                   ; Add line length
8389               0230                       ;------------------------------------------------------
8390               0231                       ; 2b: Handle line split accross 2 consecutive SAMS pages
8391               0232                       ;------------------------------------------------------
8392               0233 6DF0 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
8393               0234 6DF2 C205  18         mov   tmp1,tmp4             ; Backup tmp1
8394               0235
8395               0236 6DF4 C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
8396               0237 6DF6 09C4  56         srl   tmp0,12               ; Only keep high-nibble
8397               0238
8398               0239 6DF8 C160  34         mov   @edb.next_free.ptr,tmp1
8399                    6DFA A308
8400               0240                                                   ; Get pointer to next line (aka end of line)
8401               0241 6DFC 09C5  56         srl   tmp1,12               ; Only keep high-nibble
8402               0242
8403               0243 6DFE 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
8404               0244 6E00 1307  14         jeq   !                     ; Yes, skip setting SAMS page
8405               0245
8406               0246 6E02 C120  34         mov   @fh.sams.page,tmp0    ; Get current SAMS page
8407                    6E04 A438
8408               0247 6E06 0584  14         inc   tmp0                  ; Increase SAMS page
8409               0248 6E08 C160  34         mov   @edb.next_free.ptr,tmp1
8410                    6E0A A308
8411               0249                                                   ; Get pointer to next line (aka end of line)
8412               0250
8413               0251 6E0C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
8414                    6E0E 24FC
8415               0252                                                   ; \ i  tmp0 = SAMS page number
8416               0253                                                   ; / i  tmp1 = Memory address
8417               0254
8418               0255 6E10 C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
8419               0256 6E12 C107  18         mov   tmp3,tmp0             ; Restore tmp0
8420               0257                       ;------------------------------------------------------
8421               0258                       ; 2c: Do actual copy
8422               0259                       ;------------------------------------------------------
8423               0260 6E14 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
8424                    6E16 2444
8425               0261                                                   ; \ i  tmp0 = VDP source address
8426               0262                                                   ; | i  tmp1 = RAM target address
8427               0263                                                   ; / i  tmp2 = Bytes to copy
8428               0264
8429               0265 6E18 1000  14         jmp   fh.file.read.sams.prepindex
8430               0266                                                   ; Prepare for updating index
8431               0267                       ;------------------------------------------------------
8432               0268                       ; Step 4: Update index
8433               0269                       ;------------------------------------------------------
8434               0270               fh.file.read.sams.prepindex:
8435               0271 6E1A C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
8436                    6E1C A304
8437                    6E1E 8350
8438               0272                                                   ; parm2 = Must allready be set!
8439               0273 6E20 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
8440                    6E22 A438
8441                    6E24 8354
8442               0274
8443               0275 6E26 1009  14         jmp   fh.file.read.sams.updindex
8444               0276                                                   ; Update index
8445               0277                       ;------------------------------------------------------
8446               0278                       ; 4a: Special handling for empty line
8447               0279                       ;------------------------------------------------------
8448               0280               fh.file.read.sams.prepindex.emptyline:
8449               0281 6E28 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
8450                    6E2A A42E
8451                    6E2C 8350
8452               0282 6E2E 0620  34         dec   @parm1                ;         Adjust for base 0 index
8453                    6E30 8350
8454               0283 6E32 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
8455                    6E34 8352
8456               0284 6E36 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
8457                    6E38 8354
8458               0285                       ;------------------------------------------------------
8459               0286                       ; 4b: Do actual index update
8460               0287                       ;------------------------------------------------------
8461               0288               fh.file.read.sams.updindex:
8462               0289 6E3A 06A0  32         bl    @idx.entry.update     ; Update index
8463                    6E3C 691E
8464               0290                                                   ; \ i  parm1    = Line num in editor buffer
8465               0291                                                   ; | i  parm2    = Pointer to line in editor
8466               0292                                                   ; |               buffer
8467               0293                                                   ; | i  parm3    = SAMS page
8468               0294                                                   ; | o  outparm1 = Pointer to updated index
8469               0295                                                   ; /               entry
8470               0296
8471               0297 6E3E 05A0  34         inc   @edb.lines            ; lines=lines+1
8472                    6E40 A304
8473               0298                       ;------------------------------------------------------
8474               0299                       ; Step 5: Display results
8475               0300                       ;------------------------------------------------------
8476               0301               fh.file.read.sams.display:
8477               0302 6E42 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
8478                    6E44 A43E
8479               0303 6E46 0694  24         bl    *tmp0                 ; Run callback function
8480               0304                       ;------------------------------------------------------
8481               0305                       ; Step 6: Check if reaching memory high-limit >ffa0
8482               0306                       ;------------------------------------------------------
8483               0307               fh.file.read.sams.checkmem:
8484               0308 6E48 C120  34         mov   @edb.next_free.ptr,tmp0
8485                    6E4A A308
8486               0309 6E4C 0284  22         ci    tmp0,>ffa0
8487                    6E4E FFA0
8488               0310 6E50 1205  14         jle   fh.file.read.sams.next
8489               0311                       ;------------------------------------------------------
8490               0312                       ; 6a: Address range b000-ffff full, switch SAMS pages
8491               0313                       ;------------------------------------------------------
8492               0314 6E52 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
8493                    6E54 E002
8494               0315 6E56 C804  38         mov   tmp0,@edb.next_free.ptr
8495                    6E58 A308
8496               0316
8497               0317 6E5A 1000  14         jmp   fh.file.read.sams.next
8498               0318                       ;------------------------------------------------------
8499               0319                       ; 6b: Next record
8500               0320                       ;------------------------------------------------------
8501               0321               fh.file.read.sams.next:
8502               0322 6E5C 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
8503                    6E5E 2AA2
8504               0323 6E60 A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
8505               0324
8506               0325
8507               0326                       ;-------------------------------------------------------
8508               0327                       ; ** TEMPORARY FIX for 4KB INDEX LIMIT **
8509               0328                       ;-------------------------------------------------------
8510               0329 6E62 C120  34         mov   @edb.lines,tmp0
8511                    6E64 A304
8512               0330 6E66 0284  22         ci    tmp0,2047
8513                    6E68 07FF
8514               0331 6E6A 1311  14         jeq   fh.file.read.sams.eof
8515               0332
8516               0333 6E6C 0460  28         b     @fh.file.read.sams.record
8517                    6E6E 6D50
8518               0334                                                   ; Next record
8519               0335                       ;------------------------------------------------------
8520               0336                       ; Error handler
8521               0337                       ;------------------------------------------------------
8522               0338               fh.file.read.sams.error:
8523               0339 6E70 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
8524                    6E72 A42A
8525               0340 6E74 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
8526               0341 6E76 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
8527                    6E78 0005
8528               0342 6E7A 1309  14         jeq   fh.file.read.sams.eof
8529               0343                                                   ; All good. File closed by DSRLNK
8530               0344                       ;------------------------------------------------------
8531               0345                       ; File error occured
8532               0346                       ;------------------------------------------------------
8533               0347 6E7C 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
8534                    6E7E 2AC4
8535               0348 6E80 A100                   data scrpad.backup2   ; / >2100->8300
8536               0349
8537               0350 6E82 06A0  32         bl    @mem.setup.sams.layout
8538                    6E84 6732
8539               0351                                                   ; Restore SAMS default memory layout
8540               0352
8541               0353 6E86 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
8542                    6E88 A442
8543               0354 6E8A 0694  24         bl    *tmp0                 ; Run callback function
8544               0355 6E8C 100A  14         jmp   fh.file.read.sams.exit
8545               0356                       ;------------------------------------------------------
8546               0357                       ; End-Of-File reached
8547               0358                       ;------------------------------------------------------
8548               0359               fh.file.read.sams.eof:
8549               0360 6E8E 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
8550                    6E90 2AC4
8551               0361 6E92 A100                   data scrpad.backup2   ; / >2100->8300
8552               0362
8553               0363 6E94 06A0  32         bl    @mem.setup.sams.layout
8554                    6E96 6732
8555               0364                                                   ; Restore SAMS default memory layout
8556               0365                       ;------------------------------------------------------
8557               0366                       ; Show "loading indicator 3" (final)
8558               0367                       ;------------------------------------------------------
8559               0368 6E98 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
8560                    6E9A A306
8561               0369
8562               0370 6E9C C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
8563                    6E9E A440
8564               0371 6EA0 0694  24         bl    *tmp0                 ; Run callback function
8565               0372               *--------------------------------------------------------------
8566               0373               * Exit
8567               0374               *--------------------------------------------------------------
8568               0375               fh.file.read.sams.exit:
8569               0376 6EA2 0460  28         b     @poprt                ; Return to caller
8570                    6EA4 2212
8571               0377
8572               0378
8573               0379
8574               0380
8575               0381
8576               0382
8577               0383               ***************************************************************
8578               0384               * PAB for accessing DV/80 file
8579               0385               ********|*****|*********************|**************************
8580               0386               fh.file.pab.header:
8581               0387 6EA6 0014             byte  io.op.open            ;  0    - OPEN
8582               0388                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
8583               0389 6EA8 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
8584               0390 6EAA 5000             byte  80                    ;  4    - Record length (80 chars max)
8585 2000 0000     0391                       byte  00                    ;  5    - Character count
8586               0392 6EAC 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
8587               0393 6EAE 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
8588               0394                       ;------------------------------------------------------
8589               0395                       ; File descriptor part (variable length)
8590               0396                       ;------------------------------------------------------
8591               0397                       ; byte  12                  ;  9    - File descriptor length
8592               0398                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
8593               0399                                                   ;         (Device + '.' + File name)
8594               **** **** ****     > tivi_b1.asm.31428
8595               0051                       copy  "fm.load.asm"         ; File manager loadfile
8596               **** **** ****     > fm.load.asm
8597               0001               * FILE......: fm_load.asm
8598               0002               * Purpose...: High-level file manager module
8599               0003
8600               0004               *---------------------------------------------------------------
8601               0005               * Load file into editor
8602               0006               *---------------------------------------------------------------
8603               0007               * bl    @fm.loadfile
8604               0008               *---------------------------------------------------------------
8605               0009               * INPUT
8606               0010               * tmp0  = Pointer to length-prefixed string containing both
8607               0011               *         device and filename
8608               0012               ********|*****|*********************|**************************
8609               0013               fm.loadfile:
8610               0014 6EB0 0649  14         dect  stack
8611               0015 6EB2 C64B  30         mov   r11,*stack            ; Save return address
8612               0016
8613               0017 6EB4 C804  38         mov   tmp0,@parm1           ; Setup file to load
8614                    6EB6 8350
8615               0018 6EB8 06A0  32         bl    @edb.init             ; Initialize editor buffer
8616                    6EBA 69D2
8617               0019 6EBC 06A0  32         bl    @idx.init             ; Initialize index
8618                    6EBE 68FA
8619               0020 6EC0 06A0  32         bl    @fb.init              ; Initialize framebuffer
8620                    6EC2 67C8
8621               0021 6EC4 06A0  32         bl    @cmdb.hide            ; Hide command buffer
8622                    6EC6 6C2C
8623               0022 6EC8 C820  54         mov   @parm1,@edb.filename.ptr
8624                    6ECA 8350
8625                    6ECC A30E
8626               0023                                                   ; Set filename
8627               0024                       ;-------------------------------------------------------
8628               0025                       ; Clear VDP screen buffer
8629               0026                       ;-------------------------------------------------------
8630               0027 6ECE 06A0  32         bl    @filv
8631                    6ED0 226E
8632               0028 6ED2 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
8633                    6ED4 0000
8634                    6ED6 0004
8635               0029
8636               0030 6ED8 C160  34         mov   @fb.scrrows,tmp1
8637                    6EDA A298
8638               0031 6EDC 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
8639                    6EDE A28E
8640               0032                                                   ; 16 bit part is in tmp2!
8641               0033
8642               0034 6EE0 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
8643                    6EE2 0050
8644               0035 6EE4 0205  20         li    tmp1,32               ; Character to fill
8645                    6EE6 0020
8646               0036
8647               0037 6EE8 06A0  32         bl    @xfilv                ; Fill VDP memory
8648                    6EEA 2274
8649               0038                                                   ; \ i  tmp0 = VDP target address
8650               0039                                                   ; | i  tmp1 = Byte to fill
8651               0040                                                   ; / i  tmp2 = Bytes to copy
8652               0041                       ;-------------------------------------------------------
8653               0042                       ; Read DV80 file and display
8654               0043                       ;-------------------------------------------------------
8655               0044 6EEC 0204  20         li    tmp0,fm.loadfile.callback.indicator1
8656                    6EEE 6F20
8657               0045 6EF0 C804  38         mov   tmp0,@parm2           ; Register callback 1
8658                    6EF2 8352
8659               0046
8660               0047 6EF4 0204  20         li    tmp0,fm.loadfile.callback.indicator2
8661                    6EF6 6F58
8662               0048 6EF8 C804  38         mov   tmp0,@parm3           ; Register callback 2
8663                    6EFA 8354
8664               0049
8665               0050 6EFC 0204  20         li    tmp0,fm.loadfile.callback.indicator3
8666                    6EFE 6F8A
8667               0051 6F00 C804  38         mov   tmp0,@parm4           ; Register callback 3
8668                    6F02 8356
8669               0052
8670               0053 6F04 0204  20         li    tmp0,fm.loadfile.callback.fioerr
8671                    6F06 6FBC
8672               0054 6F08 C804  38         mov   tmp0,@parm5           ; Register callback 4
8673                    6F0A 8358
8674               0055
8675               0056 6F0C 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
8676                    6F0E 6C96
8677               0057                                                   ; \ i  parm1 = Pointer to length prefixed
8678               0058                                                   ; |            file descriptor
8679               0059                                                   ; | i  parm2 = Pointer to callback
8680               0060                                                   ; |            "loading indicator 1"
8681               0061                                                   ; | i  parm3 = Pointer to callback
8682               0062                                                   ; |            "loading indicator 2"
8683               0063                                                   ; | i  parm4 = Pointer to callback
8684               0064                                                   ; |            "loading indicator 3"
8685               0065                                                   ; | i  parm5 = Pointer to callback
8686               0066                                                   ; /            "File I/O error handler"
8687               0067
8688               0068 6F10 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
8689                    6F12 A306
8690               0069                                                   ; longer dirty.
8691               0070
8692               0071 6F14 0204  20         li    tmp0,txt.filetype.DV80
8693                    6F16 73D4
8694               0072 6F18 C804  38         mov   tmp0,@edb.filetype.ptr
8695                    6F1A A310
8696               0073                                                   ; Set filetype display string
8697               0074               *--------------------------------------------------------------
8698               0075               * Exit
8699               0076               *--------------------------------------------------------------
8700               0077               fm.loadfile.exit:
8701               0078 6F1C 0460  28         b     @poprt                ; Return to caller
8702                    6F1E 2212
8703               0079
8704               0080
8705               0081
8706               0082               *---------------------------------------------------------------
8707               0083               * Callback function "Show loading indicator 1"
8708               0084               *---------------------------------------------------------------
8709               0085               * Is expected to be passed as parm2 to @tfh.file.read
8710               0086               *---------------------------------------------------------------
8711               0087               fm.loadfile.callback.indicator1:
8712               0088 6F20 0649  14         dect  stack
8713               0089 6F22 C64B  30         mov   r11,*stack            ; Save return address
8714               0090                       ;------------------------------------------------------
8715               0091                       ; Show loading indicators and file descriptor
8716               0092                       ;------------------------------------------------------
8717               0093 6F24 06A0  32         bl    @hchar
8718                    6F26 2742
8719               0094 6F28 1D03                   byte 29,3,32,77
8720                    6F2A 204D
8721               0095 6F2C FFFF                   data EOL
8722               0096
8723               0097 6F2E 06A0  32         bl    @putat
8724                    6F30 2410
8725               0098 6F32 1D03                   byte 29,3
8726               0099 6F34 734C                   data txt.loading      ; Display "Loading...."
8727               0100
8728               0101 6F36 8820  54         c     @fh.rleonload,@w$ffff
8729                    6F38 A444
8730                    6F3A 202C
8731               0102 6F3C 1604  14         jne   !
8732               0103 6F3E 06A0  32         bl    @putat
8733                    6F40 2410
8734               0104 6F42 1D44                   byte 29,68
8735               0105 6F44 735C                   data txt.rle          ; Display "RLE"
8736               0106
8737               0107 6F46 06A0  32 !       bl    @at
8738                    6F48 264E
8739               0108 6F4A 1D0E                   byte 29,14            ; Cursor YX position
8740               0109 6F4C C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
8741                    6F4E 8350
8742               0110 6F50 06A0  32         bl    @xutst0               ; Display device/filename
8743                    6F52 2400
8744               0111                       ;------------------------------------------------------
8745               0112                       ; Exit
8746               0113                       ;------------------------------------------------------
8747               0114               fm.loadfile.callback.indicator1.exit:
8748               0115 6F54 0460  28         b     @poprt                ; Return to caller
8749                    6F56 2212
8750               0116
8751               0117
8752               0118
8753               0119
8754               0120               *---------------------------------------------------------------
8755               0121               * Callback function "Show loading indicator 2"
8756               0122               *---------------------------------------------------------------
8757               0123               * Is expected to be passed as parm3 to @tfh.file.read
8758               0124               *---------------------------------------------------------------
8759               0125               fm.loadfile.callback.indicator2:
8760               0126 6F58 0649  14         dect  stack
8761               0127 6F5A C64B  30         mov   r11,*stack            ; Save return address
8762               0128
8763               0129 6F5C 06A0  32         bl    @putnum
8764                    6F5E 2A1E
8765               0130 6F60 1D4B                   byte 29,75            ; Show lines read
8766               0131 6F62 A304                   data edb.lines,rambuf,>3020
8767                    6F64 8390
8768                    6F66 3020
8769               0132
8770               0133 6F68 8220  34         c     @fh.kilobytes,tmp4
8771                    6F6A A432
8772               0134 6F6C 130C  14         jeq   fm.loadfile.callback.indicator2.exit
8773               0135
8774               0136 6F6E C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
8775                    6F70 A432
8776               0137
8777               0138 6F72 06A0  32         bl    @putnum
8778                    6F74 2A1E
8779               0139 6F76 1D38                   byte 29,56            ; Show kilobytes read
8780               0140 6F78 A432                   data fh.kilobytes,rambuf,>3020
8781                    6F7A 8390
8782                    6F7C 3020
8783               0141
8784               0142 6F7E 06A0  32         bl    @putat
8785                    6F80 2410
8786               0143 6F82 1D3D                   byte 29,61
8787               0144 6F84 7358                   data txt.kb           ; Show "kb" string
8788               0145                       ;------------------------------------------------------
8789               0146                       ; Exit
8790               0147                       ;------------------------------------------------------
8791               0148               fm.loadfile.callback.indicator2.exit:
8792               0149 6F86 0460  28         b     @poprt                ; Return to caller
8793                    6F88 2212
8794               0150
8795               0151
8796               0152
8797               0153
8798               0154
8799               0155               *---------------------------------------------------------------
8800               0156               * Callback function "Show loading indicator 3"
8801               0157               *---------------------------------------------------------------
8802               0158               * Is expected to be passed as parm4 to @tfh.file.read
8803               0159               *---------------------------------------------------------------
8804               0160               fm.loadfile.callback.indicator3:
8805               0161 6F8A 0649  14         dect  stack
8806               0162 6F8C C64B  30         mov   r11,*stack            ; Save return address
8807               0163
8808               0164
8809               0165 6F8E 06A0  32         bl    @hchar
8810                    6F90 2742
8811               0166 6F92 1D03                   byte 29,3,32,50       ; Erase loading indicator
8812                    6F94 2032
8813               0167 6F96 FFFF                   data EOL
8814               0168
8815               0169 6F98 06A0  32         bl    @putnum
8816                    6F9A 2A1E
8817               0170 6F9C 1D38                   byte 29,56            ; Show kilobytes read
8818               0171 6F9E A432                   data fh.kilobytes,rambuf,>3020
8819                    6FA0 8390
8820                    6FA2 3020
8821               0172
8822               0173 6FA4 06A0  32         bl    @putat
8823                    6FA6 2410
8824               0174 6FA8 1D3D                   byte 29,61
8825               0175 6FAA 7358                   data txt.kb           ; Show "kb" string
8826               0176
8827               0177 6FAC 06A0  32         bl    @putnum
8828                    6FAE 2A1E
8829               0178 6FB0 1D4B                   byte 29,75            ; Show lines read
8830               0179 6FB2 A42E                   data fh.records,rambuf,>3020
8831                    6FB4 8390
8832                    6FB6 3020
8833               0180                       ;------------------------------------------------------
8834               0181                       ; Exit
8835               0182                       ;------------------------------------------------------
8836               0183               fm.loadfile.callback.indicator3.exit:
8837               0184 6FB8 0460  28         b     @poprt                ; Return to caller
8838                    6FBA 2212
8839               0185
8840               0186
8841               0187
8842               0188               *---------------------------------------------------------------
8843               0189               * Callback function "File I/O error handler"
8844               0190               *---------------------------------------------------------------
8845               0191               * Is expected to be passed as parm5 to @tfh.file.read
8846               0192               ********|*****|*********************|**************************
8847               0193               fm.loadfile.callback.fioerr:
8848               0194 6FBC 0649  14         dect  stack
8849               0195 6FBE C64B  30         mov   r11,*stack            ; Save return address
8850               0196
8851               0197 6FC0 06A0  32         bl    @hchar
8852                    6FC2 2742
8853               0198 6FC4 1D00                   byte 29,0,32,50       ; Erase loading indicator
8854                    6FC6 2032
8855               0199 6FC8 FFFF                   data EOL
8856               0200
8857               0201                       ;------------------------------------------------------
8858               0202                       ; Display I/O error message
8859               0203                       ;------------------------------------------------------
8860               0204 6FCA 06A0  32         bl    @cpym2m
8861                    6FCC 2460
8862               0205 6FCE 7367                   data txt.ioerr+1
8863               0206 6FD0 B000                   data cmdb.top
8864               0207 6FD2 0029                   data 41               ; Error message
8865               0208
8866               0209
8867               0210 6FD4 C120  34         mov   @edb.filename.ptr,tmp0
8868                    6FD6 A30E
8869               0211 6FD8 D194  26         movb  *tmp0,tmp2            ; Get length byte
8870               0212 6FDA 0986  56         srl   tmp2,8                ; Right align
8871               0213 6FDC 0584  14         inc   tmp0                  ; Skip length byte
8872               0214 6FDE 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
8873                    6FE0 B02A
8874               0215
8875               0216 6FE2 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
8876                    6FE4 2466
8877               0217                                                   ; | i  tmp0 = ROM/RAM source
8878               0218                                                   ; | i  tmp1 = RAM destination
8879               0219                                                   ; / i  tmp2 = Bytes top copy
8880               0220
8881               0221
8882               0222 6FE6 0204  20         li    tmp0,txt.newfile      ; New file
8883                    6FE8 7394
8884               0223 6FEA C804  38         mov   tmp0,@edb.filename.ptr
8885                    6FEC A30E
8886               0224
8887               0225 6FEE 0204  20         li    tmp0,txt.filetype.none
8888                    6FF0 73E0
8889               0226 6FF2 C804  38         mov   tmp0,@edb.filetype.ptr
8890                    6FF4 A310
8891               0227                                                   ; Empty filetype string
8892               0228
8893               0229 6FF6 C820  54         mov   @cmdb.scrrows,@parm1
8894                    6FF8 A504
8895                    6FFA 8350
8896               0230 6FFC 06A0  32         bl    @cmdb.show
8897                    6FFE 6BF2
8898               0231                       ;------------------------------------------------------
8899               0232                       ; Exit
8900               0233                       ;------------------------------------------------------
8901               0234               fm.loadfile.callback.fioerr.exit:
8902               0235 7000 0460  28         b     @poprt                ; Return to caller
8903                    7002 2212
8904               **** **** ****     > tivi_b1.asm.31428
8905               0052                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
8906               **** **** ****     > hook.keyscan.asm
8907               0001               * FILE......: hook.keyscan.asm
8908               0002               * Purpose...: TiVi Editor - Keyboard handling (spectra2 user hook)
8909               0003
8910               0004               *//////////////////////////////////////////////////////////////
8911               0005               *        TiVi Editor - Keyboard handling (spectra2 user hook)
8912               0006               *//////////////////////////////////////////////////////////////
8913               0007
8914               0008               ****************************************************************
8915               0009               * Editor - spectra2 user hook
8916               0010               ****************************************************************
8917               0011               hook.keyscan:
8918               0012 7004 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
8919                    7006 2014
8920               0013 7008 160B  14         jne   hook.keyscan.clear_kbbuffer
8921               0014                                                   ; No, clear buffer and exit
8922               0015               *---------------------------------------------------------------
8923               0016               * Identical key pressed ?
8924               0017               *---------------------------------------------------------------
8925               0018 700A 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
8926                    700C 2014
8927               0019 700E 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
8928                    7010 833C
8929                    7012 833E
8930               0020 7014 1309  14         jeq   hook.keyscan.bounce
8931               0021               *--------------------------------------------------------------
8932               0022               * New key pressed
8933               0023               *--------------------------------------------------------------
8934               0024               hook.keyscan.newkey:
8935               0025 7016 C820  54         mov   @waux1,@waux2         ; Save as previous key
8936                    7018 833C
8937                    701A 833E
8938               0026 701C 0460  28         b     @edkey.key.process    ; Process key
8939                    701E 60FE
8940               0027               *--------------------------------------------------------------
8941               0028               * Clear keyboard buffer if no key pressed
8942               0029               *--------------------------------------------------------------
8943               0030               hook.keyscan.clear_kbbuffer:
8944               0031 7020 04E0  34         clr   @waux1
8945                    7022 833C
8946               0032 7024 04E0  34         clr   @waux2
8947                    7026 833E
8948               0033               *--------------------------------------------------------------
8949               0034               * Delay to avoid key bouncing
8950               0035               *--------------------------------------------------------------
8951               0036               hook.keyscan.bounce:
8952               0037 7028 0204  20         li    tmp0,2000             ; Avoid key bouncing
8953                    702A 07D0
8954               0038                       ;------------------------------------------------------
8955               0039                       ; Delay loop
8956               0040                       ;------------------------------------------------------
8957               0041               hook.keyscan.bounce.loop:
8958               0042 702C 0604  14         dec   tmp0
8959               0043 702E 16FE  14         jne   hook.keyscan.bounce.loop
8960               0044               *--------------------------------------------------------------
8961               0045               * Exit
8962               0046               *--------------------------------------------------------------
8963               0047 7030 0460  28         b     @hookok               ; Return
8964                    7032 2C7A
8965               **** **** ****     > tivi_b1.asm.31428
8966               0053                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
8967               **** **** ****     > task.vdp.panes.asm
8968               0001               * FILE......: task.vdp.panes.asm
8969               0002               * Purpose...: TiVi Editor - VDP draw editor panes
8970               0003
8971               0004               *//////////////////////////////////////////////////////////////
8972               0005               *        TiVi Editor - Tasks implementation
8973               0006               *//////////////////////////////////////////////////////////////
8974               0007
8975               0008               ***************************************************************
8976               0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
8977               0010               ***************************************************************
8978               0011               task.vdp.panes:
8979               0012 7034 C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
8980                    7036 A296
8981               0013 7038 136E  14         jeq   task.vdp.panes.exit   ; No, skip update
8982               0014                       ;------------------------------------------------------
8983               0015                       ; Show banner line
8984               0016                       ;------------------------------------------------------
8985               0017 703A 06A0  32         bl    @pane.topline.draw
8986                    703C 719A
8987               0018 703E C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
8988                    7040 832A
8989                    7042 A294
8990               0019                       ;------------------------------------------------------
8991               0020                       ; Determine how many rows to copy
8992               0021                       ;------------------------------------------------------
8993               0022 7044 8820  54         c     @edb.lines,@fb.scrrows
8994                    7046 A304
8995                    7048 A298
8996               0023 704A 1103  14         jlt   task.vdp.panes.setrows.small
8997               0024 704C C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
8998                    704E A298
8999               0025 7050 1003  14         jmp   task.vdp.panes.copy.framebuffer
9000               0026                       ;------------------------------------------------------
9001               0027                       ; Less lines in editor buffer as rows in frame buffer
9002               0028                       ;------------------------------------------------------
9003               0029               task.vdp.panes.setrows.small:
9004               0030 7052 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
9005                    7054 A304
9006               0031 7056 0585  14         inc   tmp1
9007               0032                       ;------------------------------------------------------
9008               0033                       ; Determine area to copy
9009               0034                       ;------------------------------------------------------
9010               0035               task.vdp.panes.copy.framebuffer:
9011               0036 7058 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
9012                    705A A28E
9013               0037                                                   ; 16 bit part is in tmp2!
9014               0038 705C 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
9015                    705E 0050
9016               0039 7060 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
9017                    7062 A280
9018               0040                       ;------------------------------------------------------
9019               0041                       ; Copy memory block
9020               0042                       ;------------------------------------------------------
9021               0043 7064 06A0  32         bl    @xpym2v               ; Copy to VDP
9022                    7066 241E
9023               0044                                                   ; \ i  tmp0 = VDP target address
9024               0045                                                   ; | i  tmp1 = RAM source address
9025               0046                                                   ; / i  tmp2 = Bytes to copy
9026               0047 7068 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
9027                    706A A296
9028               0048                       ;-------------------------------------------------------
9029               0049                       ; Draw EOF marker at end-of-file
9030               0050                       ;-------------------------------------------------------
9031               0051 706C C120  34         mov   @edb.lines,tmp0
9032                    706E A304
9033               0052 7070 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
9034                    7072 A284
9035               0053 7074 05C4  14         inct  tmp0                  ; Y = Y + 2
9036               0054 7076 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
9037                    7078 A298
9038               0055 707A 121C  14         jle   task.vdp.panes.draw_double.line
9039               0056                       ;-------------------------------------------------------
9040               0057                       ; Do actual drawing of EOF marker
9041               0058                       ;-------------------------------------------------------
9042               0059               task.vdp.panes.draw_marker:
9043               0060 707C 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
9044               0061 707E C804  38         mov   tmp0,@wyx             ; Set VDP cursor
9045                    7080 832A
9046               0062
9047               0063 7082 06A0  32         bl    @putstr
9048                    7084 23FE
9049               0064 7086 7336                   data txt.marker       ; Display *EOF*
9050               0065                       ;-------------------------------------------------------
9051               0066                       ; Draw empty line after (and below) EOF marker
9052               0067                       ;-------------------------------------------------------
9053               0068 7088 06A0  32         bl    @setx
9054                    708A 2664
9055               0069 708C 0005                   data  5               ; Cursor after *EOF* string
9056               0070
9057               0071 708E C120  34         mov   @wyx,tmp0
9058                    7090 832A
9059               0072 7092 0984  56         srl   tmp0,8                ; Right justify
9060               0073 7094 0584  14         inc   tmp0                  ; One time adjust
9061               0074 7096 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
9062                    7098 A298
9063               0075 709A 1303  14         jeq   !
9064               0076 709C 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
9065                    709E 009B
9066               0077 70A0 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
9067               0078 70A2 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
9068                    70A4 004B
9069               0079                       ;-------------------------------------------------------
9070               0080                       ; Draw 1 or 2 empty lines
9071               0081                       ;-------------------------------------------------------
9072               0082               task.vdp.panes.draw_marker.empty.line:
9073               0083 70A6 0604  14         dec   tmp0                  ; One time adjust
9074               0084 70A8 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
9075                    70AA 23DA
9076               0085 70AC 0205  20         li    tmp1,32               ; Character to write (whitespace)
9077                    70AE 0020
9078               0086 70B0 06A0  32         bl    @xfilv                ; Fill VDP memory
9079                    70B2 2274
9080               0087                                                   ; i  tmp0 = VDP destination
9081               0088                                                   ; i  tmp1 = byte to write
9082               0089                                                   ; i  tmp2 = Number of bytes to write
9083               0090                       ;-------------------------------------------------------
9084               0091                       ; Draw "double" bottom line (above command buffer)
9085               0092                       ;-------------------------------------------------------
9086               0093               task.vdp.panes.draw_double.line:
9087               0094 70B4 C120  34         mov   @fb.scrrows,tmp0
9088                    70B6 A298
9089               0095 70B8 0584  14         inc   tmp0                  ; 1st Line after frame buffer boundary
9090               0096 70BA 06C4  14         swpb  tmp0                  ; LSB to MSB
9091               0097 70BC C804  38         mov   tmp0,@wyx             ; Save YX
9092                    70BE 832A
9093               0098
9094               0099 70C0 C120  34         mov   @cmdb.visible,tmp0    ; Command buffer hidden ?
9095                    70C2 A502
9096               0100 70C4 1306  14         jeq   !                     ; Yes, full double line
9097               0101                       ;-------------------------------------------------------
9098               0102                       ; Double line with corners
9099               0103                       ;-------------------------------------------------------
9100               0104 70C6 06A0  32         bl    @setx                 ; Set cursor to screen column 17
9101                    70C8 2664
9102               0105 70CA 0001                   data 1
9103               0106 70CC 0206  20         li    tmp2,78               ; Repeat 78x
9104                    70CE 004E
9105               0107 70D0 1005  14         jmp   task.vdp.panes.draw_double.draw
9106               0108                       ;-------------------------------------------------------
9107               0109                       ; Continuous double line (80 characters)
9108               0110                       ;-------------------------------------------------------
9109               0111 70D2 06A0  32 !       bl    @setx                 ; Set cursor to screen column 0
9110                    70D4 2664
9111               0112 70D6 0000                   data 0
9112               0113 70D8 0206  20         li    tmp2,80               ; Repeat 80x
9113                    70DA 0050
9114               0114                       ;-------------------------------------------------------
9115               0115                       ; Do actual drawing
9116               0116                       ;-------------------------------------------------------
9117               0117               task.vdp.panes.draw_double.draw:
9118               0118 70DC 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
9119                    70DE 23DA
9120               0119 70E0 0205  20         li    tmp1,3                ; Character to write (double line)
9121                    70E2 0003
9122               0120 70E4 06A0  32         bl    @xfilv                ; \ Fill VDP memory
9123                    70E6 2274
9124               0121                                                   ; | i  tmp0 = VDP destination
9125               0122                                                   ; | i  tmp1 = Byte to write
9126               0123                                                   ; / i  tmp2 = Number of bstes to write
9127               0124 70E8 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
9128                    70EA A294
9129                    70EC 832A
9130               0125                       ;-------------------------------------------------------
9131               0126                       ; Show command buffer
9132               0127                       ;-------------------------------------------------------
9133               0128 70EE C120  34         mov   @cmdb.visible,tmp0     ; Show command buffer?
9134                    70F0 A502
9135               0129 70F2 1311  14         jeq   task.vdp.panes.exit    ; No, skip
9136               0130
9137               0131 70F4 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
9138                    70F6 6C4C
9139               0132
9140               0133 70F8 06A0  32         bl    @vchar
9141                    70FA 276A
9142               0134 70FC 1200                   byte 18,0,4,1          ; Top left corner
9143                    70FE 0401
9144               0135 7100 124F                   byte 18,79,5,1         ; Top right corner
9145                    7102 0501
9146               0136 7104 1300                   byte 19,0,6,9          ; Left vertical double line
9147                    7106 0609
9148               0137 7108 134F                   byte 19,79,7,9         ; Right vertical double line
9149                    710A 0709
9150               0138 710C 1C00                   byte 28,0,8,1          ; Bottom left corner
9151                    710E 0801
9152               0139 7110 1C4F                   byte 28,79,9,1         ; Bottom right corner
9153                    7112 0901
9154               0140 7114 FFFF                   data EOL
9155               0141                       ;------------------------------------------------------
9156               0142                       ; Exit task
9157               0143                       ;------------------------------------------------------
9158               0144               task.vdp.panes.exit:
9159               0145 7116 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
9160                    7118 71C4
9161               0146 711A 0460  28         b     @slotok
9162                    711C 2CF6
9163               **** **** ****     > tivi_b1.asm.31428
9164               0054                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
9165               **** **** ****     > task.vdp.sat.asm
9166               0001               * FILE......: task.vdp.sat.asm
9167               0002               * Purpose...: TiVi Editor - VDP copy SAT
9168               0003
9169               0004               *//////////////////////////////////////////////////////////////
9170               0005               *        TiVi Editor - Tasks implementation
9171               0006               *//////////////////////////////////////////////////////////////
9172               0007
9173               0008               ***************************************************************
9174               0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
9175               0010               ********|*****|*********************|**************************
9176               0011               task.vdp.copy.sat:
9177               0012 711E C120  34         mov   @tv.pane.focus,tmp0
9178                    7120 A216
9179               0013 7122 130A  14         jeq   !                     ; Frame buffer has focus
9180               0014
9181               0015 7124 0284  22         ci    tmp0,pane.focus.cmdb
9182                    7126 0001
9183               0016 7128 1304  14         jeq   task.vdp.copy.sat.cmdb
9184               0017                                                   ; Command buffer has focus
9185               0018                       ;------------------------------------------------------
9186               0019                       ; Assert failed. Invalid value
9187               0020                       ;------------------------------------------------------
9188               0021 712A C80B  38         mov   r11,@>ffce            ; \ Save caller address
9189                    712C FFCE
9190               0022 712E 06A0  32         bl    @cpu.crash            ; / Halt system.
9191                    7130 2030
9192               0023                       ;------------------------------------------------------
9193               0024                       ; Command buffer has focus, position cursor
9194               0025                       ;------------------------------------------------------
9195               0026               task.vdp.copy.sat.cmdb:
9196               0027 7132 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
9197                    7134 A508
9198                    7136 832A
9199               0028                       ;------------------------------------------------------
9200               0029                       ; Position cursor
9201               0030                       ;------------------------------------------------------
9202               0031 7138 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
9203                    713A 202A
9204               0032 713C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
9205                    713E 2670
9206               0033                                                   ; | i  @WYX = Cursor YX
9207               0034                                                   ; / o  tmp0 = Pixel YX
9208               0035 7140 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
9209                    7142 8380
9210               0036
9211               0037 7144 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
9212                    7146 2418
9213               0038 7148 2000                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
9214                    714A 8380
9215                    714C 0004
9216               0039                                                   ; | i  tmp1 = ROM/RAM source
9217               0040                                                   ; / i  tmp2 = Number of bytes to write
9218               0041                       ;------------------------------------------------------
9219               0042                       ; Exit
9220               0043                       ;------------------------------------------------------
9221               0044               task.vdp.copy.sat.exit:
9222               0045 714E 0460  28         b     @slotok               ; Exit task
9223                    7150 2CF6
9224               **** **** ****     > tivi_b1.asm.31428
9225               0055                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
9226               **** **** ****     > task.vdp.cursor.asm
9227               0001               * FILE......: task.vdp.cursor.asm
9228               0002               * Purpose...: TiVi Editor - VDP sprite cursor
9229               0003
9230               0004               *//////////////////////////////////////////////////////////////
9231               0005               *        TiVi Editor - Tasks implementation
9232               0006               *//////////////////////////////////////////////////////////////
9233               0007
9234               0008               ***************************************************************
9235               0009               * Task - Update cursor shape (blink)
9236               0010               ***************************************************************
9237               0011               task.vdp.cursor:
9238               0012 7152 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
9239                    7154 A292
9240               0013 7156 1303  14         jeq   task.vdp.cursor.visible
9241               0014 7158 04E0  34         clr   @ramsat+2              ; Hide cursor
9242                    715A 8382
9243               0015 715C 1015  14         jmp   task.vdp.cursor.copy.sat
9244               0016                                                    ; Update VDP SAT and exit task
9245               0017               task.vdp.cursor.visible:
9246               0018 715E C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
9247                    7160 A30A
9248               0019 7162 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
9249               0020                       ;------------------------------------------------------
9250               0021                       ; Cursor in insert mode
9251               0022                       ;------------------------------------------------------
9252               0023               task.vdp.cursor.visible.insert_mode:
9253               0024 7164 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
9254                    7166 A216
9255               0025 7168 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
9256               0026                                                    ; Framebuffer has focus
9257               0027 716A 0284  22         ci    tmp0,pane.focus.cmdb
9258                    716C 0001
9259               0028 716E 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
9260               0029                       ;------------------------------------------------------
9261               0030                       ; Editor cursor (insert mode)
9262               0031                       ;------------------------------------------------------
9263               0032               task.vdp.cursor.visible.insert_mode.fb:
9264               0033 7170 04C4  14         clr   tmp0                   ; Cursor editor insert mode
9265               0034 7172 1005  14         jmp   task.vdp.cursor.visible.cursorshape
9266               0035                       ;------------------------------------------------------
9267               0036                       ; Command buffer cursor (insert mode)
9268               0037                       ;------------------------------------------------------
9269               0038               task.vdp.cursor.visible.insert_mode.cmdb:
9270               0039 7174 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
9271                    7176 0100
9272               0040 7178 1002  14         jmp   task.vdp.cursor.visible.cursorshape
9273               0041                       ;------------------------------------------------------
9274               0042                       ; Cursor in overwrite mode
9275               0043                       ;------------------------------------------------------
9276               0044               task.vdp.cursor.visible.overwrite_mode:
9277               0045 717A 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
9278                    717C 0200
9279               0046                       ;------------------------------------------------------
9280               0047                       ; Set cursor shape
9281               0048                       ;------------------------------------------------------
9282               0049               task.vdp.cursor.visible.cursorshape:
9283               0050 717E D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
9284                    7180 A214
9285               0051 7182 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
9286                    7184 A214
9287                    7186 8382
9288               0052                       ;------------------------------------------------------
9289               0053                       ; Copy SAT
9290               0054                       ;------------------------------------------------------
9291               0055               task.vdp.cursor.copy.sat:
9292               0056 7188 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
9293                    718A 2418
9294               0057 718C 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
9295                    718E 8380
9296                    7190 0004
9297               0058                                                    ; | i  tmp1 = ROM/RAM source
9298               0059                                                    ; / i  tmp2 = Number of bytes to write
9299               0060                       ;-------------------------------------------------------
9300               0061                       ; Show status bottom line
9301               0062                       ;-------------------------------------------------------
9302               0063 7192 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
9303                    7194 71C4
9304               0064                       ;------------------------------------------------------
9305               0065                       ; Exit
9306               0066                       ;------------------------------------------------------
9307               0067               task.vdp.cursor.exit:
9308               0068 7196 0460  28         b     @slotok                ; Exit task
9309                    7198 2CF6
9310               **** **** ****     > tivi_b1.asm.31428
9311               0056                       copy  "pane.topline.asm"    ; Pane banner top line
9312               **** **** ****     > pane.topline.asm
9313               0001               * FILE......: pane.topline.asm
9314               0002               * Purpose...: TiVi Editor - Pane top line
9315               0003
9316               0004               *//////////////////////////////////////////////////////////////
9317               0005               *              TiVi Editor - Pane top line
9318               0006               *//////////////////////////////////////////////////////////////
9319               0007
9320               0008               ***************************************************************
9321               0009               * pane.topline.draw
9322               0010               * Draw TiVi status top line
9323               0011               ***************************************************************
9324               0012               * bl  @pane.topline.draw
9325               0013               *--------------------------------------------------------------
9326               0014               * OUTPUT
9327               0015               * none
9328               0016               *--------------------------------------------------------------
9329               0017               * Register usage
9330               0018               * tmp0
9331               0019               ********|*****|*********************|**************************
9332               0020               pane.topline.draw:
9333               0021 719A 0649  14         dect  stack
9334               0022 719C C64B  30         mov   r11,*stack            ; Save return address
9335               0023 719E C820  54         mov   @wyx,@fb.yxsave
9336                    71A0 832A
9337                    71A2 A294
9338               0024                       ;------------------------------------------------------
9339               0025                       ; Show banner (line above frame buffer, not part of it)
9340               0026                       ;------------------------------------------------------
9341               0027 71A4 06A0  32         bl    @hchar
9342                    71A6 2742
9343               0028 71A8 0000                   byte 0,0,1,34         ; Double line at top (left)
9344                    71AA 0122
9345               0029 71AC 002E                   byte 0,46,1,34        ; Double line at top (right)
9346                    71AE 0122
9347               0030 71B0 FFFF                   data EOL
9348               0031
9349               0032 71B2 06A0  32         bl    @putat
9350                    71B4 2410
9351               0033 71B6 0022                   byte 0,34
9352               0034 71B8 73EC                   data txt.tivi         ; TiVi banner (middle)
9353               0035                       ;------------------------------------------------------
9354               0036                       ; Exit
9355               0037                       ;------------------------------------------------------
9356               0038               pane.topline.exit:
9357               0039 71BA C820  54         mov   @fb.yxsave,@wyx
9358                    71BC A294
9359                    71BE 832A
9360               0040 71C0 C2F9  30         mov   *stack+,r11           ; Pop r11
9361               0041 71C2 045B  20         b     *r11                  ; Return
9362               **** **** ****     > tivi_b1.asm.31428
9363               0057                       copy  "pane.botline.asm"    ; Pane status bottom line
9364               **** **** ****     > pane.botline.asm
9365               0001               * FILE......: pane.botline.asm
9366               0002               * Purpose...: TiVi Editor - Pane status bottom line
9367               0003
9368               0004               *//////////////////////////////////////////////////////////////
9369               0005               *              TiVi Editor - Pane status bottom line
9370               0006               *//////////////////////////////////////////////////////////////
9371               0007
9372               0008               ***************************************************************
9373               0009               * pane.botline.draw
9374               0010               * Draw TiVi status bottom line
9375               0011               ***************************************************************
9376               0012               * bl  @pane.botline.draw
9377               0013               *--------------------------------------------------------------
9378               0014               * OUTPUT
9379               0015               * none
9380               0016               *--------------------------------------------------------------
9381               0017               * Register usage
9382               0018               * tmp0
9383               0019               ********|*****|*********************|**************************
9384               0020               pane.botline.draw:
9385               0021 71C4 0649  14         dect  stack
9386               0022 71C6 C64B  30         mov   r11,*stack            ; Save return address
9387               0023 71C8 0649  14         dect  stack
9388               0024 71CA C644  30         mov   tmp0,*stack           ; Push tmp0
9389               0025
9390               0026 71CC C820  54         mov   @wyx,@fb.yxsave
9391                    71CE 832A
9392                    71D0 A294
9393               0027                       ;------------------------------------------------------
9394               0028                       ; Show buffer number
9395               0029                       ;------------------------------------------------------
9396               0030               pane.botline.bufnum:
9397               0031 71D2 06A0  32         bl    @putat
9398                    71D4 2410
9399               0032 71D6 1D00                   byte  29,0
9400               0033 71D8 7390                   data  txt.bufnum
9401               0034                       ;------------------------------------------------------
9402               0035                       ; Show current file
9403               0036                       ;------------------------------------------------------
9404               0037               pane.botline.show_file:
9405               0038 71DA 06A0  32         bl    @at
9406                    71DC 264E
9407               0039 71DE 1D03                   byte  29,3            ; Position cursor
9408               0040 71E0 C160  34         mov   @edb.filename.ptr,tmp1
9409                    71E2 A30E
9410               0041                                                   ; Get string to display
9411               0042 71E4 06A0  32         bl    @xutst0               ; Display string
9412                    71E6 2400
9413               0043
9414               0044 71E8 06A0  32         bl    @at
9415                    71EA 264E
9416               0045 71EC 1D23                   byte  29,35           ; Position cursor
9417               0046
9418               0047 71EE C160  34         mov   @edb.filetype.ptr,tmp1
9419                    71F0 A310
9420               0048                                                   ; Get string to display
9421               0049 71F2 06A0  32         bl    @xutst0               ; Display Filetype string
9422                    71F4 2400
9423               0050                       ;------------------------------------------------------
9424               0051                       ; Show text editing mode
9425               0052                       ;------------------------------------------------------
9426               0053               pane.botline.show_mode:
9427               0054 71F6 C120  34         mov   @edb.insmode,tmp0
9428                    71F8 A30A
9429               0055 71FA 1605  14         jne   pane.botline.show_mode.insert
9430               0056                       ;------------------------------------------------------
9431               0057                       ; Overwrite mode
9432               0058                       ;------------------------------------------------------
9433               0059               pane.botline.show_mode.overwrite:
9434               0060 71FC 06A0  32         bl    @putat
9435                    71FE 2410
9436               0061 7200 1D32                   byte  29,50
9437               0062 7202 7342                   data  txt.ovrwrite
9438               0063 7204 1004  14         jmp   pane.botline.show_changed
9439               0064                       ;------------------------------------------------------
9440               0065                       ; Insert  mode
9441               0066                       ;------------------------------------------------------
9442               0067               pane.botline.show_mode.insert:
9443               0068 7206 06A0  32         bl    @putat
9444                    7208 2410
9445               0069 720A 1D32                   byte  29,50
9446               0070 720C 7346                   data  txt.insert
9447               0071                       ;------------------------------------------------------
9448               0072                       ; Show if text was changed in editor buffer
9449               0073                       ;------------------------------------------------------
9450               0074               pane.botline.show_changed:
9451               0075 720E C120  34         mov   @edb.dirty,tmp0
9452                    7210 A306
9453               0076 7212 1305  14         jeq   pane.botline.show_changed.clear
9454               0077                       ;------------------------------------------------------
9455               0078                       ; Show "*"
9456               0079                       ;------------------------------------------------------
9457               0080 7214 06A0  32         bl    @putat
9458                    7216 2410
9459               0081 7218 1D36                   byte 29,54
9460               0082 721A 734A                   data txt.star
9461               0083 721C 1001  14         jmp   pane.botline.show_linecol
9462               0084                       ;------------------------------------------------------
9463               0085                       ; Show "line,column"
9464               0086                       ;------------------------------------------------------
9465               0087               pane.botline.show_changed.clear:
9466               0088 721E 1000  14         nop
9467               0089               pane.botline.show_linecol:
9468               0090 7220 C820  54         mov   @fb.row,@parm1
9469                    7222 A286
9470                    7224 8350
9471               0091 7226 06A0  32         bl    @fb.row2line
9472                    7228 680A
9473               0092 722A 05A0  34         inc   @outparm1
9474                    722C 8360
9475               0093                       ;------------------------------------------------------
9476               0094                       ; Show line
9477               0095                       ;------------------------------------------------------
9478               0096 722E 06A0  32         bl    @putnum
9479                    7230 2A1E
9480               0097 7232 1D40                   byte  29,64           ; YX
9481               0098 7234 8360                   data  outparm1,rambuf
9482                    7236 8390
9483               0099 7238 3020                   byte  48              ; ASCII offset
9484 2002 2000     0100                             byte  32              ; Padding character
9485               0101                       ;------------------------------------------------------
9486               0102                       ; Show comma
9487               0103                       ;------------------------------------------------------
9488               0104 723A 06A0  32         bl    @putat
9489                    723C 2410
9490               0105 723E 1D45                   byte  29,69
9491               0106 7240 7334                   data  txt.delim
9492               0107                       ;------------------------------------------------------
9493               0108                       ; Show column
9494               0109                       ;------------------------------------------------------
9495               0110 7242 06A0  32         bl    @film
9496                    7244 2216
9497               0111 7246 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
9498                    7248 0020
9499                    724A 000C
9500               0112
9501               0113 724C C820  54         mov   @fb.column,@waux1
9502                    724E A28C
9503                    7250 833C
9504               0114 7252 05A0  34         inc   @waux1                ; Offset 1
9505                    7254 833C
9506               0115
9507               0116 7256 06A0  32         bl    @mknum                ; Convert unsigned number to string
9508                    7258 29A0
9509               0117 725A 833C                   data  waux1,rambuf
9510                    725C 8390
9511               0118 725E 3020                   byte  48              ; ASCII offset
9512 2004 2000     0119                             byte  32              ; Fill character
9513               0120
9514               0121 7260 06A0  32         bl    @trimnum              ; Trim number to the left
9515                    7262 29F8
9516               0122 7264 8390                   data  rambuf,rambuf+6,32
9517                    7266 8396
9518                    7268 0020
9519               0123
9520               0124 726A 0204  20         li    tmp0,>0200
9521                    726C 0200
9522               0125 726E D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
9523                    7270 8396
9524               0126
9525               0127 7272 06A0  32         bl    @putat
9526                    7274 2410
9527               0128 7276 1D46                   byte 29,70
9528               0129 7278 8396                   data rambuf+6         ; Show column
9529               0130                       ;------------------------------------------------------
9530               0131                       ; Show lines in buffer unless on last line in file
9531               0132                       ;------------------------------------------------------
9532               0133 727A C820  54         mov   @fb.row,@parm1
9533                    727C A286
9534                    727E 8350
9535               0134 7280 06A0  32         bl    @fb.row2line
9536                    7282 680A
9537               0135 7284 8820  54         c     @edb.lines,@outparm1
9538                    7286 A304
9539                    7288 8360
9540               0136 728A 1605  14         jne   pane.botline.show_lines_in_buffer
9541               0137
9542               0138 728C 06A0  32         bl    @putat
9543                    728E 2410
9544               0139 7290 1D4B                   byte 29,75
9545               0140 7292 733C                   data txt.bottom
9546               0141
9547               0142 7294 100B  14         jmp   pane.botline.exit
9548               0143                       ;------------------------------------------------------
9549               0144                       ; Show lines in buffer
9550               0145                       ;------------------------------------------------------
9551               0146               pane.botline.show_lines_in_buffer:
9552               0147 7296 C820  54         mov   @edb.lines,@waux1
9553                    7298 A304
9554                    729A 833C
9555               0148 729C 05A0  34         inc   @waux1                ; Offset 1
9556                    729E 833C
9557               0149 72A0 06A0  32         bl    @putnum
9558                    72A2 2A1E
9559               0150 72A4 1D4B                   byte 29,75            ; YX
9560               0151 72A6 833C                   data waux1,rambuf
9561                    72A8 8390
9562               0152 72AA 3020                   byte 48
9563 2006 2000     0153                             byte 32
9564               0154                       ;------------------------------------------------------
9565               0155                       ; Exit
9566               0156                       ;------------------------------------------------------
9567               0157               pane.botline.exit:
9568               0158 72AC C820  54         mov   @fb.yxsave,@wyx
9569                    72AE A294
9570                    72B0 832A
9571               0159 72B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
9572               0160 72B4 C2F9  30         mov   *stack+,r11           ; Pop r11
9573               0161 72B6 045B  20         b     *r11                  ; Return
9574               **** **** ****     > tivi_b1.asm.31428
9575               0058                       copy  "data.constants.asm"  ; Data segment - Constants
9576               **** **** ****     > data.constants.asm
9577               0001               * FILE......: data.constants.asm
9578               0002               * Purpose...: TiVi Editor - data segment (constants)
9579               0003
9580               0004               ***************************************************************
9581               0005               *                      Constants
9582               0006               ********|*****|*********************|**************************
9583               0007               romsat:
9584               0008 72B8 0303             data  >0303,>000f           ; Cursor YX, initial shape and colour
9585                    72BA 000F
9586               0009
9587               0010               cursors:
9588               0011 72BC 0000             data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
9589                    72BE 0000
9590                    72C0 0000
9591                    72C2 001C
9592               0012 72C4 1010             data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
9593                    72C6 1010
9594                    72C8 1010
9595                    72CA 1000
9596               0013 72CC 1C1C             data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
9597                    72CE 1C1C
9598                    72D0 1C1C
9599                    72D2 1C00
9600               0014
9601               0015               patterns:
9602               0016 72D4 0000             data >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
9603                    72D6 FF00
9604                    72D8 00FF
9605                    72DA 0080
9606               0017 72DC 0080             data >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
9607                    72DE 0000
9608                    72E0 FF00
9609                    72E2 FF00
9610               0018               patterns.box:
9611               0019 72E4 0000             data >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
9612                    72E6 0000
9613                    72E8 FF00
9614                    72EA FF00
9615               0020 72EC 0000             data >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
9616                    72EE 0000
9617                    72F0 FF80
9618                    72F2 BFA0
9619               0021 72F4 0000             data >0000,>0000,>fc04,>f414 ; 05. Top right corner
9620                    72F6 0000
9621                    72F8 FC04
9622                    72FA F414
9623               0022 72FC A0A0             data >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
9624                    72FE A0A0
9625                    7300 A0A0
9626                    7302 A0A0
9627               0023 7304 1414             data >1414,>1414,>1414,>1414 ; 07. Right vertical double line
9628                    7306 1414
9629                    7308 1414
9630                    730A 1414
9631               0024 730C A0A0             data >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
9632                    730E A0A0
9633                    7310 BF80
9634                    7312 FF00
9635               0025 7314 1414             data >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
9636                    7316 1414
9637                    7318 F404
9638                    731A FC00
9639               0026 731C 0000             data >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
9640                    731E C0C0
9641                    7320 C0C0
9642                    7322 0080
9643               0027 7324 0000             data >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
9644                    7326 0F0F
9645                    7328 0F0F
9646                    732A 0000
9647               0028
9648               0029
9649               0030               tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
9650               0031 732C F404             data  >f404                 ; White      | Dark blue  | Dark blue
9651               0032 732E F101             data  >f101                 ; White      | Black      | Black
9652               0033 7330 1707             data  >1707                 ; Black      | Cyan       | Cyan
9653               0034 7332 1F0F             data  >1f0f                 ; Black      | White      | White
9654               **** **** ****     > tivi_b1.asm.31428
9655               0059                       copy  "data.strings.asm"    ; Data segment - Strings
9656               **** **** ****     > data.strings.asm
9657               0001               * FILE......: data.strings.asm
9658               0002               * Purpose...: TiVi Editor - data segment (strings)
9659               0003
9660               0004               ***************************************************************
9661               0005               *                       Strings
9662               0006               ***************************************************************
9663               0007               txt.delim
9664               0008 7334 012C             byte  1
9665               0009 7335 ....             text  ','
9666               0010                       even
9667               0011
9668               0012               txt.marker
9669               0013 7336 052A             byte  5
9670               0014 7337 ....             text  '*EOF*'
9671               0015                       even
9672               0016
9673               0017               txt.bottom
9674               0018 733C 0520             byte  5
9675               0019 733D ....             text  '  BOT'
9676               0020                       even
9677               0021
9678               0022               txt.ovrwrite
9679               0023 7342 034F             byte  3
9680               0024 7343 ....             text  'OVR'
9681               0025                       even
9682               0026
9683               0027               txt.insert
9684               0028 7346 0349             byte  3
9685               0029 7347 ....             text  'INS'
9686               0030                       even
9687               0031
9688               0032               txt.star
9689               0033 734A 012A             byte  1
9690               0034 734B ....             text  '*'
9691               0035                       even
9692               0036
9693               0037               txt.loading
9694               0038 734C 0A4C             byte  10
9695               0039 734D ....             text  'Loading...'
9696               0040                       even
9697               0041
9698               0042               txt.kb
9699               0043 7358 026B             byte  2
9700               0044 7359 ....             text  'kb'
9701               0045                       even
9702               0046
9703               0047               txt.rle
9704               0048 735C 0352             byte  3
9705               0049 735D ....             text  'RLE'
9706               0050                       even
9707               0051
9708               0052               txt.lines
9709               0053 7360 054C             byte  5
9710               0054 7361 ....             text  'Lines'
9711               0055                       even
9712               0056
9713               0057               txt.ioerr
9714               0058 7366 2921             byte  41
9715               0059 7367 ....             text  '! I/O error occured. Could not load file:'
9716               0060                       even
9717               0061
9718               0062               txt.bufnum
9719               0063 7390 0223             byte  2
9720               0064 7391 ....             text  '#1'
9721               0065                       even
9722               0066
9723               0067               txt.newfile
9724               0068 7394 0A5B             byte  10
9725               0069 7395 ....             text  '[New file]'
9726               0070                       even
9727               0071
9728               0072
9729               0073               txt.cmdb.prompt
9730               0074 73A0 013E             byte  1
9731               0075 73A1 ....             text  '>'
9732               0076                       even
9733               0077
9734               0078               txt.cmdb.hint
9735               0079 73A2 2348             byte  35
9736               0080 73A3 ....             text  'Hint: Type "help" for command list.'
9737               0081                       even
9738               0082
9739               0083               txt.cmdb.catalog
9740               0084 73C6 0C46             byte  12
9741               0085 73C7 ....             text  'File catalog'
9742               0086                       even
9743               0087
9744               0088
9745               0089
9746               0090               txt.filetype.dv80
9747               0091 73D4 0A44             byte  10
9748               0092 73D5 ....             text  'DIS/VAR80 '
9749               0093                       even
9750               0094
9751               0095               txt.filetype.none
9752               0096 73E0 0A20             byte  10
9753               0097 73E1 ....             text  '          '
9754               0098                       even
9755               0099
9756               0100
9757               0101 73EC 0C0A     txt.tivi     byte    12
9758 2008 0A00     0102                            byte    10
9759               0103 73EE ....                  text    'TiVi v1.00'
9760               0104 73F8 0B00                  byte    11
9761               0105                            even
9762               0106
9763               0107               fdname0
9764               0108 73FA 0F44             byte  15
9765               0109 73FB ....             text  'DSK1.FWDOC/PSRV'
9766               0110                       even
9767               0111
9768               0112               fdname1
9769               0113 740A 0F44             byte  15
9770               0114 740B ....             text  'DSK1.SPEECHDOCS'
9771               0115                       even
9772               0116
9773               0117               fdname2
9774               0118 741A 0C44             byte  12
9775               0119 741B ....             text  'DSK1.XBEADOC'
9776               0120                       even
9777               0121
9778               0122               fdname3
9779               0123 7428 0C44             byte  12
9780               0124 7429 ....             text  'DSK3.XBEADOC'
9781               0125                       even
9782               0126
9783               0127               fdname4
9784               0128 7436 0C44             byte  12
9785               0129 7437 ....             text  'DSK3.C99MAN1'
9786               0130                       even
9787               0131
9788               0132               fdname5
9789               0133 7444 0C44             byte  12
9790               0134 7445 ....             text  'DSK3.C99MAN2'
9791               0135                       even
9792               0136
9793               0137               fdname6
9794               0138 7452 0C44             byte  12
9795               0139 7453 ....             text  'DSK3.C99MAN3'
9796               0140                       even
9797               0141
9798               0142               fdname7
9799               0143 7460 0D44             byte  13
9800               0144 7461 ....             text  'DSK3.C99SPECS'
9801               0145                       even
9802               0146
9803               0147               fdname8
9804               0148 746E 0D44             byte  13
9805               0149 746F ....             text  'DSK3.RANDOM#C'
9806               0150                       even
9807               0151
9808               0152               fdname9
9809               0153 747C 0D44             byte  13
9810               0154 747D ....             text  'DSK1.INVADERS'
9811               0155                       even
9812               0156
9813               0157
9814               0158
9815               0159               *---------------------------------------------------------------
9816               0160               * Keyboard labels - Function keys
9817               0161               *---------------------------------------------------------------
9818               0162               txt.fctn.0
9819               0163 748A 0866             byte  8
9820               0164 748B ....             text  'fctn + 0'
9821               0165                       even
9822               0166
9823               0167               txt.fctn.1
9824               0168 7494 0866             byte  8
9825               0169 7495 ....             text  'fctn + 1'
9826               0170                       even
9827               0171
9828               0172               txt.fctn.2
9829               0173 749E 0866             byte  8
9830               0174 749F ....             text  'fctn + 2'
9831               0175                       even
9832               0176
9833               0177               txt.fctn.3
9834               0178 74A8 0866             byte  8
9835               0179 74A9 ....             text  'fctn + 3'
9836               0180                       even
9837               0181
9838               0182               txt.fctn.4
9839               0183 74B2 0866             byte  8
9840               0184 74B3 ....             text  'fctn + 4'
9841               0185                       even
9842               0186
9843               0187               txt.fctn.5
9844               0188 74BC 0866             byte  8
9845               0189 74BD ....             text  'fctn + 5'
9846               0190                       even
9847               0191
9848               0192               txt.fctn.6
9849               0193 74C6 0866             byte  8
9850               0194 74C7 ....             text  'fctn + 6'
9851               0195                       even
9852               0196
9853               0197               txt.fctn.7
9854               0198 74D0 0866             byte  8
9855               0199 74D1 ....             text  'fctn + 7'
9856               0200                       even
9857               0201
9858               0202               txt.fctn.8
9859               0203 74DA 0866             byte  8
9860               0204 74DB ....             text  'fctn + 8'
9861               0205                       even
9862               0206
9863               0207               txt.fctn.9
9864               0208 74E4 0866             byte  8
9865               0209 74E5 ....             text  'fctn + 9'
9866               0210                       even
9867               0211
9868               0212               txt.fctn.a
9869               0213 74EE 0866             byte  8
9870               0214 74EF ....             text  'fctn + a'
9871               0215                       even
9872               0216
9873               0217               txt.fctn.b
9874               0218 74F8 0866             byte  8
9875               0219 74F9 ....             text  'fctn + b'
9876               0220                       even
9877               0221
9878               0222               txt.fctn.c
9879               0223 7502 0866             byte  8
9880               0224 7503 ....             text  'fctn + c'
9881               0225                       even
9882               0226
9883               0227               txt.fctn.d
9884               0228 750C 0866             byte  8
9885               0229 750D ....             text  'fctn + d'
9886               0230                       even
9887               0231
9888               0232               txt.fctn.e
9889               0233 7516 0866             byte  8
9890               0234 7517 ....             text  'fctn + e'
9891               0235                       even
9892               0236
9893               0237               txt.fctn.f
9894               0238 7520 0866             byte  8
9895               0239 7521 ....             text  'fctn + f'
9896               0240                       even
9897               0241
9898               0242               txt.fctn.g
9899               0243 752A 0866             byte  8
9900               0244 752B ....             text  'fctn + g'
9901               0245                       even
9902               0246
9903               0247               txt.fctn.h
9904               0248 7534 0866             byte  8
9905               0249 7535 ....             text  'fctn + h'
9906               0250                       even
9907               0251
9908               0252               txt.fctn.i
9909               0253 753E 0866             byte  8
9910               0254 753F ....             text  'fctn + i'
9911               0255                       even
9912               0256
9913               0257               txt.fctn.j
9914               0258 7548 0866             byte  8
9915               0259 7549 ....             text  'fctn + j'
9916               0260                       even
9917               0261
9918               0262               txt.fctn.k
9919               0263 7552 0866             byte  8
9920               0264 7553 ....             text  'fctn + k'
9921               0265                       even
9922               0266
9923               0267               txt.fctn.l
9924               0268 755C 0866             byte  8
9925               0269 755D ....             text  'fctn + l'
9926               0270                       even
9927               0271
9928               0272               txt.fctn.m
9929               0273 7566 0866             byte  8
9930               0274 7567 ....             text  'fctn + m'
9931               0275                       even
9932               0276
9933               0277               txt.fctn.n
9934               0278 7570 0866             byte  8
9935               0279 7571 ....             text  'fctn + n'
9936               0280                       even
9937               0281
9938               0282               txt.fctn.o
9939               0283 757A 0866             byte  8
9940               0284 757B ....             text  'fctn + o'
9941               0285                       even
9942               0286
9943               0287               txt.fctn.p
9944               0288 7584 0866             byte  8
9945               0289 7585 ....             text  'fctn + p'
9946               0290                       even
9947               0291
9948               0292               txt.fctn.q
9949               0293 758E 0866             byte  8
9950               0294 758F ....             text  'fctn + q'
9951               0295                       even
9952               0296
9953               0297               txt.fctn.r
9954               0298 7598 0866             byte  8
9955               0299 7599 ....             text  'fctn + r'
9956               0300                       even
9957               0301
9958               0302               txt.fctn.s
9959               0303 75A2 0866             byte  8
9960               0304 75A3 ....             text  'fctn + s'
9961               0305                       even
9962               0306
9963               0307               txt.fctn.t
9964               0308 75AC 0866             byte  8
9965               0309 75AD ....             text  'fctn + t'
9966               0310                       even
9967               0311
9968               0312               txt.fctn.u
9969               0313 75B6 0866             byte  8
9970               0314 75B7 ....             text  'fctn + u'
9971               0315                       even
9972               0316
9973               0317               txt.fctn.v
9974               0318 75C0 0866             byte  8
9975               0319 75C1 ....             text  'fctn + v'
9976               0320                       even
9977               0321
9978               0322               txt.fctn.w
9979               0323 75CA 0866             byte  8
9980               0324 75CB ....             text  'fctn + w'
9981               0325                       even
9982               0326
9983               0327               txt.fctn.x
9984               0328 75D4 0866             byte  8
9985               0329 75D5 ....             text  'fctn + x'
9986               0330                       even
9987               0331
9988               0332               txt.fctn.y
9989               0333 75DE 0866             byte  8
9990               0334 75DF ....             text  'fctn + y'
9991               0335                       even
9992               0336
9993               0337               txt.fctn.z
9994               0338 75E8 0866             byte  8
9995               0339 75E9 ....             text  'fctn + z'
9996               0340                       even
9997               0341
9998               0342               *---------------------------------------------------------------
9999               0343               * Keyboard labels - Function keys extra
10000               0344               *---------------------------------------------------------------
10001               0345               txt.fctn.dot
10002               0346 75F2 0866             byte  8
10003               0347 75F3 ....             text  'fctn + .'
10004               0348                       even
10005               0349
10006               0350               txt.fctn.plus
10007               0351 75FC 0866             byte  8
10008               0352 75FD ....             text  'fctn + +'
10009               0353                       even
10010               0354
10011               0355               *---------------------------------------------------------------
10012               0356               * Keyboard labels - Control keys
10013               0357               *---------------------------------------------------------------
10014               0358               txt.ctrl.0
10015               0359 7606 0863             byte  8
10016               0360 7607 ....             text  'ctrl + 0'
10017               0361                       even
10018               0362
10019               0363               txt.ctrl.1
10020               0364 7610 0863             byte  8
10021               0365 7611 ....             text  'ctrl + 1'
10022               0366                       even
10023               0367
10024               0368               txt.ctrl.2
10025               0369 761A 0863             byte  8
10026               0370 761B ....             text  'ctrl + 2'
10027               0371                       even
10028               0372
10029               0373               txt.ctrl.3
10030               0374 7624 0863             byte  8
10031               0375 7625 ....             text  'ctrl + 3'
10032               0376                       even
10033               0377
10034               0378               txt.ctrl.4
10035               0379 762E 0863             byte  8
10036               0380 762F ....             text  'ctrl + 4'
10037               0381                       even
10038               0382
10039               0383               txt.ctrl.5
10040               0384 7638 0863             byte  8
10041               0385 7639 ....             text  'ctrl + 5'
10042               0386                       even
10043               0387
10044               0388               txt.ctrl.6
10045               0389 7642 0863             byte  8
10046               0390 7643 ....             text  'ctrl + 6'
10047               0391                       even
10048               0392
10049               0393               txt.ctrl.7
10050               0394 764C 0863             byte  8
10051               0395 764D ....             text  'ctrl + 7'
10052               0396                       even
10053               0397
10054               0398               txt.ctrl.8
10055               0399 7656 0863             byte  8
10056               0400 7657 ....             text  'ctrl + 8'
10057               0401                       even
10058               0402
10059               0403               txt.ctrl.9
10060               0404 7660 0863             byte  8
10061               0405 7661 ....             text  'ctrl + 9'
10062               0406                       even
10063               0407
10064               0408               txt.ctrl.a
10065               0409 766A 0863             byte  8
10066               0410 766B ....             text  'ctrl + a'
10067               0411                       even
10068               0412
10069               0413               txt.ctrl.b
10070               0414 7674 0863             byte  8
10071               0415 7675 ....             text  'ctrl + b'
10072               0416                       even
10073               0417
10074               0418               txt.ctrl.c
10075               0419 767E 0863             byte  8
10076               0420 767F ....             text  'ctrl + c'
10077               0421                       even
10078               0422
10079               0423               txt.ctrl.d
10080               0424 7688 0863             byte  8
10081               0425 7689 ....             text  'ctrl + d'
10082               0426                       even
10083               0427
10084               0428               txt.ctrl.e
10085               0429 7692 0863             byte  8
10086               0430 7693 ....             text  'ctrl + e'
10087               0431                       even
10088               0432
10089               0433               txt.ctrl.f
10090               0434 769C 0863             byte  8
10091               0435 769D ....             text  'ctrl + f'
10092               0436                       even
10093               0437
10094               0438               txt.ctrl.g
10095               0439 76A6 0863             byte  8
10096               0440 76A7 ....             text  'ctrl + g'
10097               0441                       even
10098               0442
10099               0443               txt.ctrl.h
10100               0444 76B0 0863             byte  8
10101               0445 76B1 ....             text  'ctrl + h'
10102               0446                       even
10103               0447
10104               0448               txt.ctrl.i
10105               0449 76BA 0863             byte  8
10106               0450 76BB ....             text  'ctrl + i'
10107               0451                       even
10108               0452
10109               0453               txt.ctrl.j
10110               0454 76C4 0863             byte  8
10111               0455 76C5 ....             text  'ctrl + j'
10112               0456                       even
10113               0457
10114               0458               txt.ctrl.k
10115               0459 76CE 0863             byte  8
10116               0460 76CF ....             text  'ctrl + k'
10117               0461                       even
10118               0462
10119               0463               txt.ctrl.l
10120               0464 76D8 0863             byte  8
10121               0465 76D9 ....             text  'ctrl + l'
10122               0466                       even
10123               0467
10124               0468               txt.ctrl.m
10125               0469 76E2 0863             byte  8
10126               0470 76E3 ....             text  'ctrl + m'
10127               0471                       even
10128               0472
10129               0473               txt.ctrl.n
10130               0474 76EC 0863             byte  8
10131               0475 76ED ....             text  'ctrl + n'
10132               0476                       even
10133               0477
10134               0478               txt.ctrl.o
10135               0479 76F6 0863             byte  8
10136               0480 76F7 ....             text  'ctrl + o'
10137               0481                       even
10138               0482
10139               0483               txt.ctrl.p
10140               0484 7700 0863             byte  8
10141               0485 7701 ....             text  'ctrl + p'
10142               0486                       even
10143               0487
10144               0488               txt.ctrl.q
10145               0489 770A 0863             byte  8
10146               0490 770B ....             text  'ctrl + q'
10147               0491                       even
10148               0492
10149               0493               txt.ctrl.r
10150               0494 7714 0863             byte  8
10151               0495 7715 ....             text  'ctrl + r'
10152               0496                       even
10153               0497
10154               0498               txt.ctrl.s
10155               0499 771E 0863             byte  8
10156               0500 771F ....             text  'ctrl + s'
10157               0501                       even
10158               0502
10159               0503               txt.ctrl.t
10160               0504 7728 0863             byte  8
10161               0505 7729 ....             text  'ctrl + t'
10162               0506                       even
10163               0507
10164               0508               txt.ctrl.u
10165               0509 7732 0863             byte  8
10166               0510 7733 ....             text  'ctrl + u'
10167               0511                       even
10168               0512
10169               0513               txt.ctrl.v
10170               0514 773C 0863             byte  8
10171               0515 773D ....             text  'ctrl + v'
10172               0516                       even
10173               0517
10174               0518               txt.ctrl.w
10175               0519 7746 0863             byte  8
10176               0520 7747 ....             text  'ctrl + w'
10177               0521                       even
10178               0522
10179               0523               txt.ctrl.x
10180               0524 7750 0863             byte  8
10181               0525 7751 ....             text  'ctrl + x'
10182               0526                       even
10183               0527
10184               0528               txt.ctrl.y
10185               0529 775A 0863             byte  8
10186               0530 775B ....             text  'ctrl + y'
10187               0531                       even
10188               0532
10189               0533               txt.ctrl.z
10190               0534 7764 0863             byte  8
10191               0535 7765 ....             text  'ctrl + z'
10192               0536                       even
10193               0537
10194               0538               *---------------------------------------------------------------
10195               0539               * Keyboard labels - control keys extra
10196               0540               *---------------------------------------------------------------
10197               0541               txt.ctrl.plus
10198               0542 776E 0863             byte  8
10199               0543 776F ....             text  'ctrl + +'
10200               0544                       even
10201               0545
10202               0546               *---------------------------------------------------------------
10203               0547               * Special keys
10204               0548               *---------------------------------------------------------------
10205               0549               txt.enter
10206               0550 7778 0565             byte  5
10207               0551 7779 ....             text  'enter'
10208               0552                       even
10209               0553
10210               **** **** ****     > tivi_b1.asm.31428
10211               0060                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
10212               **** **** ****     > data.keymap.asm
10213               0001               * FILE......: data.keymap.asm
10214               0002               * Purpose...: TiVi Editor - data segment (keyboard mapping)
10215               0003
10216               0004               *---------------------------------------------------------------
10217               0005               * Keyboard scancodes - Function keys
10218               0006               *-------------|---------------------|---------------------------
10219               0007      0000     key.fctn.0    equ >0000             ; fctn + 0
10220               0008      0300     key.fctn.1    equ >0300             ; fctn + 1
10221               0009      0400     key.fctn.2    equ >0400             ; fctn + 2
10222               0010      0700     key.fctn.3    equ >0700             ; fctn + 3
10223               0011      0000     key.fctn.4    equ >0000             ; fctn + 4
10224               0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
10225               0013      0000     key.fctn.6    equ >0000             ; fctn + 6
10226               0014      0000     key.fctn.7    equ >0000             ; fctn + 7
10227               0015      0000     key.fctn.8    equ >0000             ; fctn + 8
10228               0016      0F00     key.fctn.9    equ >0f00             ; fctn + 9
10229               0017      0000     key.fctn.a    equ >0000             ; fctn + a
10230               0018      0000     key.fctn.b    equ >0000             ; fctn + b
10231               0019      0000     key.fctn.c    equ >0000             ; fctn + c
10232               0020      0900     key.fctn.d    equ >0900             ; fctn + d
10233               0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
10234               0022      0000     key.fctn.f    equ >0000             ; fctn + f
10235               0023      0000     key.fctn.g    equ >0000             ; fctn + g
10236               0024      0000     key.fctn.h    equ >0000             ; fctn + h
10237               0025      0000     key.fctn.i    equ >0000             ; fctn + i
10238               0026      0000     key.fctn.j    equ >0000             ; fctn + j
10239               0027      0000     key.fctn.k    equ >0000             ; fctn + k
10240               0028      0000     key.fctn.l    equ >0000             ; fctn + l
10241               0029      0000     key.fctn.m    equ >0000             ; fctn + m
10242               0030      0000     key.fctn.n    equ >0000             ; fctn + n
10243               0031      0000     key.fctn.o    equ >0000             ; fctn + o
10244               0032      0000     key.fctn.p    equ >0000             ; fctn + p
10245               0033      0000     key.fctn.q    equ >0000             ; fctn + q
10246               0034      0000     key.fctn.r    equ >0000             ; fctn + r
10247               0035      0800     key.fctn.s    equ >0800             ; fctn + s
10248               0036      0000     key.fctn.t    equ >0000             ; fctn + t
10249               0037      0000     key.fctn.u    equ >0000             ; fctn + u
10250               0038      0000     key.fctn.v    equ >0000             ; fctn + v
10251               0039      0000     key.fctn.w    equ >0000             ; fctn + w
10252               0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
10253               0041      0000     key.fctn.y    equ >0000             ; fctn + y
10254               0042      0000     key.fctn.z    equ >0000             ; fctn + z
10255               0043               *---------------------------------------------------------------
10256               0044               * Keyboard scancodes - Function keys extra
10257               0045               *---------------------------------------------------------------
10258               0046      B900     key.fctn.dot  equ >b900             ; fctn + .
10259               0047      0500     key.fctn.plus equ >0500             ; fctn + +
10260               0048               *---------------------------------------------------------------
10261               0049               * Keyboard scancodes - control keys
10262               0050               *-------------|---------------------|---------------------------
10263               0051      B000     key.ctrl.0    equ >b000             ; ctrl + 0
10264               0052      B100     key.ctrl.1    equ >b100             ; ctrl + 1
10265               0053      B200     key.ctrl.2    equ >b200             ; ctrl + 2
10266               0054      B300     key.ctrl.3    equ >b300             ; ctrl + 3
10267               0055      B400     key.ctrl.4    equ >b400             ; ctrl + 4
10268               0056      B500     key.ctrl.5    equ >b500             ; ctrl + 5
10269               0057      B600     key.ctrl.6    equ >b600             ; ctrl + 6
10270               0058      B700     key.ctrl.7    equ >b700             ; ctrl + 7
10271               0059      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
10272               0060      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
10273               0061      8100     key.ctrl.a    equ >8100             ; ctrl + a
10274               0062      8200     key.ctrl.b    equ >8200             ; ctrl + b
10275               0063      0000     key.ctrl.c    equ >0000             ; ctrl + c
10276               0064      8400     key.ctrl.d    equ >8400             ; ctrl + d
10277               0065      8500     key.ctrl.e    equ >8500             ; ctrl + e
10278               0066      8600     key.ctrl.f    equ >8600             ; ctrl + f
10279               0067      0000     key.ctrl.g    equ >0000             ; ctrl + g
10280               0068      0000     key.ctrl.h    equ >0000             ; ctrl + h
10281               0069      0000     key.ctrl.i    equ >0000             ; ctrl + i
10282               0070      0000     key.ctrl.j    equ >0000             ; ctrl + j
10283               0071      0000     key.ctrl.k    equ >0000             ; ctrl + k
10284               0072      0000     key.ctrl.l    equ >0000             ; ctrl + l
10285               0073      0000     key.ctrl.m    equ >0000             ; ctrl + m
10286               0074      0000     key.ctrl.n    equ >0000             ; ctrl + n
10287               0075      0000     key.ctrl.o    equ >0000             ; ctrl + o
10288               0076      0000     key.ctrl.p    equ >0000             ; ctrl + p
10289               0077      0000     key.ctrl.q    equ >0000             ; ctrl + q
10290               0078      0000     key.ctrl.r    equ >0000             ; ctrl + r
10291               0079      9300     key.ctrl.s    equ >9300             ; ctrl + s
10292               0080      9400     key.ctrl.t    equ >9400             ; ctrl + t
10293               0081      0000     key.ctrl.u    equ >0000             ; ctrl + u
10294               0082      0000     key.ctrl.v    equ >0000             ; ctrl + v
10295               0083      0000     key.ctrl.w    equ >0000             ; ctrl + w
10296               0084      9800     key.ctrl.x    equ >9800             ; ctrl + x
10297               0085      0000     key.ctrl.y    equ >0000             ; ctrl + y
10298               0086      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
10299               0087               *---------------------------------------------------------------
10300               0088               * Keyboard scancodes - control keys extra
10301               0089               *---------------------------------------------------------------
10302               0090      9D00     key.ctrl.plus equ >9d00             ; ctrl + +
10303               0091               *---------------------------------------------------------------
10304               0092               * Special keys
10305               0093               *---------------------------------------------------------------
10306               0094      0D00     key.enter     equ >0d00             ; enter
10307               0095
10308               0096
10309               0097
10310               0098               *---------------------------------------------------------------
10311               0099               * Action keys mapping table: Editor
10312               0100               *---------------------------------------------------------------
10313               0101               keymap_actions.editor:
10314               0102                       ;-------------------------------------------------------
10315               0103                       ; Movement keys
10316               0104                       ;-------------------------------------------------------
10317               0105 777E 0D00             data  key.enter, txt.enter, edkey.action.enter
10318                    7780 7778
10319                    7782 6568
10320               0106 7784 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
10321                    7786 75A2
10322                    7788 615E
10323               0107 778A 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
10324                    778C 750C
10325                    778E 6174
10326               0108 7790 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
10327                    7792 7516
10328                    7794 618C
10329               0109 7796 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
10330                    7798 75D4
10331                    779A 61DE
10332               0110 779C 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
10333                    779E 766A
10334                    77A0 624A
10335               0111 77A2 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
10336                    77A4 769C
10337                    77A6 6262
10338               0112 77A8 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
10339                    77AA 771E
10340                    77AC 6276
10341               0113 77AE 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
10342                    77B0 7688
10343                    77B2 62C8
10344               0114 77B4 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
10345                    77B6 7692
10346                    77B8 6328
10347               0115 77BA 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
10348                    77BC 7750
10349                    77BE 636E
10350               0116 77C0 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
10351                    77C2 7728
10352                    77C4 639A
10353               0117 77C6 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
10354                    77C8 7674
10355                    77CA 63CA
10356               0118                       ;-------------------------------------------------------
10357               0119                       ; Modifier keys - Delete
10358               0120                       ;-------------------------------------------------------
10359               0121 77CC 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
10360                    77CE 7494
10361                    77D0 640A
10362               0122 77D2 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
10363                    77D4 76CE
10364                    77D6 6442
10365               0123 77D8 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
10366                    77DA 74A8
10367                    77DC 6476
10368               0124                       ;-------------------------------------------------------
10369               0125                       ; Modifier keys - Insert
10370               0126                       ;-------------------------------------------------------
10371               0127 77DE 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
10372                    77E0 749E
10373                    77E2 64CE
10374               0128 77E4 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
10375                    77E6 75F2
10376                    77E8 65D6
10377               0129 77EA 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
10378                    77EC 74BC
10379                    77EE 6524
10380               0130                       ;-------------------------------------------------------
10381               0131                       ; Other action keys
10382               0132                       ;-------------------------------------------------------
10383               0133 77F0 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
10384                    77F2 75FC
10385                    77F4 6626
10386               0134 77F6 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
10387                    77F8 74E4
10388                    77FA 6632
10389               0135 77FC 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
10390                    77FE 7764
10391                    7800 6650
10392               0136                       ;-------------------------------------------------------
10393               0137                       ; Editor/File buffer keys
10394               0138                       ;-------------------------------------------------------
10395               0139 7802 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
10396                    7804 7606
10397                    7806 6692
10398               0140 7808 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
10399                    780A 7610
10400                    780C 6698
10401               0141 780E B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
10402                    7810 761A
10403                    7812 669E
10404               0142 7814 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
10405                    7816 7624
10406                    7818 66A4
10407               0143 781A B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
10408                    781C 762E
10409                    781E 66AA
10410               0144 7820 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
10411                    7822 7638
10412                    7824 66B0
10413               0145 7826 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
10414                    7828 7642
10415                    782A 66B6
10416               0146 782C B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
10417                    782E 764C
10418                    7830 66BC
10419               0147 7832 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
10420                    7834 7656
10421                    7836 66C2
10422               0148 7838 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
10423                    783A 7660
10424                    783C 66C8
10425               0149                       ;-------------------------------------------------------
10426               0150                       ; End of list
10427               0151                       ;-------------------------------------------------------
10428               0152 783E FFFF             data  EOL                           ; EOL
10429               0153
10430               0154
10431               0155
10432               0156
10433               0157               *---------------------------------------------------------------
10434               0158               * Action keys mapping table: Command Buffer (CMDB)
10435               0159               *---------------------------------------------------------------
10436               0160               keymap_actions.cmdb:
10437               0161                       ;-------------------------------------------------------
10438               0162                       ; Movement keys
10439               0163                       ;-------------------------------------------------------
10440               0164 7840 0D00             data  key.enter, txt.enter, edkey.action.enter
10441                    7842 7778
10442                    7844 6568
10443               0165 7846 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
10444                    7848 75A2
10445                    784A 615E
10446               0166 784C 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
10447                    784E 750C
10448                    7850 6174
10449               0167 7852 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
10450                    7854 7516
10451                    7856 662E
10452               0168 7858 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
10453                    785A 75D4
10454                    785C 662E
10455               0169 785E 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
10456                    7860 766A
10457                    7862 662E
10458               0170 7864 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
10459                    7866 769C
10460                    7868 662E
10461               0171 786A 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
10462                    786C 771E
10463                    786E 662E
10464               0172 7870 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
10465                    7872 7688
10466                    7874 662E
10467               0173 7876 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
10468                    7878 7692
10469                    787A 662E
10470               0174 787C 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
10471                    787E 7750
10472                    7880 662E
10473               0175 7882 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
10474                    7884 7728
10475                    7886 662E
10476               0176 7888 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
10477                    788A 7674
10478                    788C 662E
10479               0177                       ;-------------------------------------------------------
10480               0178                       ; Modifier keys - Delete
10481               0179                       ;-------------------------------------------------------
10482               0180 788E 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
10483                    7890 7494
10484                    7892 640A
10485               0181 7894 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
10486                    7896 76CE
10487                    7898 6442
10488               0182 789A 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
10489                    789C 74A8
10490                    789E 662E
10491               0183                       ;-------------------------------------------------------
10492               0184                       ; Modifier keys - Insert
10493               0185                       ;-------------------------------------------------------
10494               0186 78A0 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
10495                    78A2 749E
10496                    78A4 64CE
10497               0187 78A6 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
10498                    78A8 75F2
10499                    78AA 65D6
10500               0188 78AC 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
10501                    78AE 74BC
10502                    78B0 662E
10503               0189                       ;-------------------------------------------------------
10504               0190                       ; Other action keys
10505               0191                       ;-------------------------------------------------------
10506               0192 78B2 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
10507                    78B4 75FC
10508                    78B6 6626
10509               0193 78B8 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
10510                    78BA 74E4
10511                    78BC 6632
10512               0194 78BE 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
10513                    78C0 7764
10514                    78C2 6650
10515               0195                       ;-------------------------------------------------------
10516               0196                       ; Editor/File buffer keys
10517               0197                       ;-------------------------------------------------------
10518               0198 78C4 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
10519                    78C6 7606
10520                    78C8 6692
10521               0199 78CA B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
10522                    78CC 7610
10523                    78CE 6698
10524               0200 78D0 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
10525                    78D2 761A
10526                    78D4 669E
10527               0201 78D6 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
10528                    78D8 7624
10529                    78DA 66A4
10530               0202 78DC B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
10531                    78DE 762E
10532                    78E0 66AA
10533               0203 78E2 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
10534                    78E4 7638
10535                    78E6 66B0
10536               0204 78E8 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
10537                    78EA 7642
10538                    78EC 66B6
10539               0205 78EE B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
10540                    78F0 764C
10541                    78F2 66BC
10542               0206 78F4 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
10543                    78F6 7656
10544                    78F8 66C2
10545               0207 78FA 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
10546                    78FC 7660
10547                    78FE 66C8
10548               0208                       ;-------------------------------------------------------
10549               0209                       ; End of list
10550               0210                       ;-------------------------------------------------------
10551               0211 7900 FFFF             data  EOL                           ; EOL
10552               **** **** ****     > tivi_b1.asm.31428
10553               0061
10554               0065 7902 7902                   data $                ; Bank 1 ROM size OK.
10555               0067
10556               0068               *--------------------------------------------------------------
10557               0069               * Video mode configuration
10558               0070               *--------------------------------------------------------------
10559               0071      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
10560               0072      0004     spfbck  equ   >04                   ; Screen background color.
10561               0073      21F6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
10562               0074      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
10563               0075      0050     colrow  equ   80                    ; Columns per row
10564               0076      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
10565               0077      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
10566               0078      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
10567               0079      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0020               **** **** ****     > equates.asm
0021               0001               ***************************************************************
0022               0002               *                          TiVi Editor
0023               0003               *
0024               0004               *       A 21th century Programming Editor for the 1981
0025               0005               *         Texas Instruments TI-99/4a Home Computer.
0026               0006               *
0027               0007               *              (c)2018-2020 // Filip van Vooren
0028               0008               ***************************************************************
0029               0009               * File: equates.asm                 ; Version 200331-31428
0030               0010               *--------------------------------------------------------------
0031               0011               * TiVi memory layout.
0032               0012               * See file "modules/memory.asm" for further details.
0033               0013               *
0034               0014               * Mem range   Bytes    SAMS   Purpose
0035               0015               * =========   =====    ====   ==================================
0036               0016               * 2000-3fff   8192            Spectra2 library
0037               0017               * 6000-7fff   8192            bank 0: spectra2 library + copy code
0038               0018               *                             bank 1: TiVi program code
0039               0019               * a000-afff   4096            Scratchpad/GPL backup, TiVi structures
0040               0020               * b000-bfff   4096            Command buffer
0041               0021               * c000-cfff   4096     yes    Main index
0042               0022               * d000-dfff   4096     yes    Shadow SAMS pages index
0043               0023               * e000-efff   4096     yes    Editor buffer 4k
0044               0024               * f000-ffff   4096     yes    Editor buffer 4k
0045               0025               *
0046               0026               * TiVi VDP layout
0047               0027               *
0048               0028               * Mem range   Bytes    Hex    Purpose
0049               0029               * =========   =====   ====    =================================
0050               0030               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0051               0031               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0052               0032               * 0fc0                        PCT - Pattern Color Table
0053               0033               * 1000                        PDT - Pattern Descriptor Table
0054               0034               * 1800                        SPT - Sprite Pattern Table
0055               0035               * 2000                        SAT - Sprite Attribute List
0056               0036               *--------------------------------------------------------------
0057               0037               * Skip unused spectra2 code modules for reduced code size
0058               0038               *--------------------------------------------------------------
0059               0039      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0060               0040      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
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
0128               0108      A216     tv.pane.focus   equ  tv.top + 22    ; Identify pane that has focus
0129               0109      A216     tv.end          equ  tv.top + 22    ; End of structure
0130               0110      0000     pane.focus.fb   equ  0              ; Editor pane has focus
0131               0111      0001     pane.focus.cmdb equ  1              ; Command buffer pane has focus
0132               0112               *--------------------------------------------------------------
0133               0113               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0134               0114               *--------------------------------------------------------------
0135               0115      A280     fb.struct       equ  >a280          ; Structure begin
0136               0116      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0137               0117      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0138               0118      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0139               0119                                                   ; line X in editor buffer).
0140               0120      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0141               0121                                                   ; (offset 0 .. @fb.scrrows)
0142               0122      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0143               0123      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0144               0124      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0145               0125      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0146               0126      A290     fb.free         equ  fb.struct + 16 ; **** free ****
0147               0127      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0148               0128      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0149               0129      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0150               0130      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0151               0131      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0152               0132      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0153               0133               *--------------------------------------------------------------
0154               0134               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0155               0135               *--------------------------------------------------------------
0156               0136      A300     edb.struct        equ  >a300           ; Begin structure
0157               0137      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0158               0138      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0159               0139      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0160               0140      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0161               0141      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0162               0142      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0163               0143      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0164               0144      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0165               0145                                                      ; with current filename.
0166               0146      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0167               0147                                                      ; with current file type.
0168               0148      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0169               0149      A314     edb.end           equ  edb.struct + 20 ; End of structure
0170               0150               *--------------------------------------------------------------
0171               0151               * File handling structures          @>a400-a4ff     (256 bytes)
0172               0152               *--------------------------------------------------------------
0173               0153      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0174               0154      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0175               0155      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0176               0156      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0177               0157      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0178               0158      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0179               0159      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0180               0160      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0181               0161      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0182               0162      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0183               0163      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0184               0164      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0185               0165      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0186               0166      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0187               0167      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0188               0168      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0189               0169      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0190               0170      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0191               0171      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0192               0172      A496     fh.end            equ  fh.struct +150  ; End of structure
0193               0173      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0194               0174      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0195               0175               *--------------------------------------------------------------
0196               0176               * Command buffer structure          @>a500-a5ff     (256 bytes)
0197               0177               *--------------------------------------------------------------
0198               0178      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0199               0179      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0200               0180      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0201               0181      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0202               0182      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0203               0183      A508     cmdb.cursor     equ  cmdb.struct + 8   ; Screen YX of cursor in cmdb pane
0204               0184      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0205               0185      A50C     cmdb.yxtop      equ  cmdb.struct + 12  ; YX position of first row in cmdb pane
0206               0186      A50E     cmdb.lines      equ  cmdb.struct + 14  ; Total lines in editor buffer
0207               0187      A510     cmdb.dirty      equ  cmdb.struct + 16  ; Editor buffer dirty (Text changed!)
0208               0188      A512     cmdb.fb.yxsave  equ  cmdb.struct + 18  ; Copy of FB WYX when entering cmdb pane
0209               0189      A514     cmdb.end        equ  cmdb.struct + 20  ; End of structure
0210               0190               *--------------------------------------------------------------
0211               0191               * Free for future use               @>a600-a64f     (80 bytes)
0212               0192               *--------------------------------------------------------------
0213               0193      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0214               0194               *--------------------------------------------------------------
0215               0195               * Frame buffer                      @>a650-afff    (2480 bytes)
0216               0196               *--------------------------------------------------------------
0217               0197      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0218               0198      09B0     fb.size         equ  2480              ; Frame buffer size
0219               0199               *--------------------------------------------------------------
0220               0200               * Command buffer                    @>b000-bfff    (4096 bytes)
0221               0201               *--------------------------------------------------------------
0222               0202      B000     cmdb.top        equ  >b000             ; Top of command buffer
0223               0203      1000     cmdb.size       equ  4096              ; Command buffer size
0224               0204               *--------------------------------------------------------------
0225               0205               * Index                             @>c000-cfff    (4096 bytes)
0226               0206               *--------------------------------------------------------------
0227               0207      C000     idx.top         equ  >c000             ; Top of index
0228               0208      1000     idx.size        equ  4096              ; Index size
0229               0209               *--------------------------------------------------------------
0230               0210               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0231               0211               *--------------------------------------------------------------
0232               0212      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0233               0213      1000     idx.shadow.size equ  4096              ; Shadow index size
0234               0214               *--------------------------------------------------------------
0235               0215               * Editor buffer                     @>e000-efff    (4096 bytes)
0236               0216               *                                   @>f000-ffff    (4096 bytes)
0237               0217               *--------------------------------------------------------------
0238               0218      E000     edb.top         equ  >e000             ; Editor buffer high memory
0239               0219      2000     edb.size        equ  8192              ; Editor buffer size
0240               0220               *--------------------------------------------------------------
0241               0221
0242               0222
0243               **** **** ****     > tivi_b1.asm.31428
0244               0018                       copy  "kickstart.asm"       ; Cartridge header
0245               **** **** ****     > kickstart.asm
0246               0001               * FILE......: kickstart.asm
0247               0002               * Purpose...: Bankswitch routine for starting TiVi
0248               0003
0249               0004               ***************************************************************
0250               0005               * TiVi Cartridge Header & kickstart ROM bank 0
0251               0006               ***************************************************************
0252               0007               *
0253               0008               *--------------------------------------------------------------
0254               0009               * INPUT
0255               0010               * none
0256               0011               *--------------------------------------------------------------
0257               0012               * OUTPUT
0258               0013               * none
0259               0014               *--------------------------------------------------------------
0260               0015               * Register usage
0261               0016               * r0
0262               0017               ***************************************************************
0263               0018
0264               0019               *--------------------------------------------------------------
0265               0020               * Cartridge header
0266               0021               ********|*****|*********************|**************************
0267               0022 6000 AA01             byte  >aa,1,1,0,0,0
0268                    6002 0100
0269                    6004 0000
0270               0023 6006 6010             data  $+10
0271               0024 6008 0000             byte  0,0,0,0,0,0,0,0
0272                    600A 0000
0273                    600C 0000
0274                    600E 0000
0275               0025 6010 0000             data  0                     ; No more items following
0276               0026 6012 6030             data  kickstart.code1
0277               0027
0278               0029
0279               0030 6014 1154             byte  17
0280               0031 6015 ....             text  'TIVI 200331-31428'
0281               0032                       even
0282               0033
0283               0041
0284               0042               *--------------------------------------------------------------
0285               0043               * Kickstart bank 0
0286               0044               ********|*****|*********************|**************************
0287               0045                       aorg  kickstart.code1
0288               0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
0289                    6032 6000
0290               **** **** ****     > tivi_b1.asm.31428
0291               0019
0292               0020                       aorg  >2000

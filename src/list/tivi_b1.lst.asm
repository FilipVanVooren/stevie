XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.asm.21084
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi_b1.asm                 ; Version 200325-21084
0010               
0011               
0012               ***************************************************************
0013               * BANK 1 - TiVi support modules
0014               ********|*****|*********************|**************************
0015                       aorg  >6000
0016                       save  >6000,>7fff           ; Save bank 1
0017                       copy  "equates.asm"         ; Equates TiVi configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.asm                 ; Version 200325-21084
0010               *--------------------------------------------------------------
0011               * TiVi memory layout.
0012               * See file "modules/memory.asm" for further details.
0013               *
0014               * Mem range   Bytes    SAMS   Purpose
0015               * =========   =====    ====   ==================================
0016               * 2000-3fff   8192            Spectra2 library
0017               * 6000-7fff   8192            bank 0: spectra2 library + copy code
0018               *                             bank 1: TiVi program code
0019               * a000-afff   4096            Scratchpad/GPL backup, TiVi structures
0020               * b000-bfff   4096            Command buffer
0021               * c000-cfff   4096     yes    Main index
0022               * d000-dfff   4096     yes    Shadow SAMS pages index
0023               * e000-efff   4096     yes    Editor buffer 4k
0024               * f000-ffff   4096     yes    Editor buffer 4k
0025               *
0026               * TiVi VDP layout
0027               *
0028               * Mem range   Bytes    Hex    Purpose
0029               * =========   =====   ====    =================================
0030               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0031               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0032               * 0fc0                        PCT - Pattern Color Table
0033               * 1000                        PDT - Pattern Descriptor Table
0034               * 1800                        SPT - Sprite Pattern Table
0035               * 2000                        SAT - Sprite Attribute List
0036               *--------------------------------------------------------------
0037               * Skip unused spectra2 code modules for reduced code size
0038               *--------------------------------------------------------------
0039      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0040      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0041      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0042      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0043      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0044      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0045      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0046      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0047      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0048      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0049      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0050      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0051      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0052      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0053      0001     skip_random_generator     equ  1    ; Skip random functions
0054      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0055               *--------------------------------------------------------------
0056               * SPECTRA2 / TiVi startup options
0057               *--------------------------------------------------------------
0058      0001     debug                     equ  1    ; Turn on spectra2 debugging
0059      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0060      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0061      6030     kickstart.code1           equ  >6030; Uniform aorg entry address accross banks
0062      6050     kickstart.code2           equ  >6050; Uniform aorg entry address start of code
0063      A000     cpu.scrpad.tgt            equ  >a000; Destination cpu.scrpad.backup/restore
0064               
0065               *--------------------------------------------------------------
0066               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0067               *--------------------------------------------------------------
0068               ;               equ  >8342          ; >8342-834F **free***
0069      8350     parm1           equ  >8350          ; Function parameter 1
0070      8352     parm2           equ  >8352          ; Function parameter 2
0071      8354     parm3           equ  >8354          ; Function parameter 3
0072      8356     parm4           equ  >8356          ; Function parameter 4
0073      8358     parm5           equ  >8358          ; Function parameter 5
0074      835A     parm6           equ  >835a          ; Function parameter 6
0075      835C     parm7           equ  >835c          ; Function parameter 7
0076      835E     parm8           equ  >835e          ; Function parameter 8
0077      8360     outparm1        equ  >8360          ; Function output parameter 1
0078      8362     outparm2        equ  >8362          ; Function output parameter 2
0079      8364     outparm3        equ  >8364          ; Function output parameter 3
0080      8366     outparm4        equ  >8366          ; Function output parameter 4
0081      8368     outparm5        equ  >8368          ; Function output parameter 5
0082      836A     outparm6        equ  >836a          ; Function output parameter 6
0083      836C     outparm7        equ  >836c          ; Function output parameter 7
0084      836E     outparm8        equ  >836e          ; Function output parameter 8
0085      8370     timers          equ  >8370          ; Timer table
0086      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0087      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0088               *--------------------------------------------------------------
0089               * Scratchpad backup 1               @>a000-a0ff     (256 bytes)
0090               * Scratchpad backup 2               @>a100-a1ff     (256 bytes)
0091               *--------------------------------------------------------------
0092      A000     scrpad.backup1  equ  >a000          ; Backup GPL layout
0093      A100     scrpad.backup2  equ  >a100          ; Backup spectra2 layout
0094               *--------------------------------------------------------------
0095               * TiVi Editor shared structures     @>a200-a27f     (128 bytes)
0096               *--------------------------------------------------------------
0097      A200     tv.top          equ  >a200          ; Structure begin
0098      A200     tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
0099      A202     tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
0100      A204     tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
0101      A206     tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
0102      A208     tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
0103      A20A     tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
0104      A20C     tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
0105      A20E     tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
0106      A210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0107      A212     tv.colorscheme  equ  tv.top + 18    ; Current color scheme (0-4)
0108      A214     tv.curshape     equ  tv.top + 20    ; Cursor shape and color
0109      A216     tv.end          equ  tv.top + 22    ; End of structure
0110               *--------------------------------------------------------------
0111               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0112               *--------------------------------------------------------------
0113      A280     fb.struct       equ  >a280          ; Structure begin
0114      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0115      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0116      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0117                                                   ; line X in editor buffer).
0118      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0119                                                   ; (offset 0 .. @fb.scrrows)
0120      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0121      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0122      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0123      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0124      A290     fb.hasfocus     equ  fb.struct + 16 ; Frame buffer pane has focus (>ffff = yes)
0125      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0126      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0127      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0128      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0129      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0130      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0131               *--------------------------------------------------------------
0132               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0133               *--------------------------------------------------------------
0134      A300     edb.struct        equ  >a300           ; Begin structure
0135      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0136      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0137      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0138      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0139      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0140      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0141      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0142      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0143                                                      ; with current filename.
0144      A310     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0145                                                      ; with current file type.
0146      A312     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0147      A314     edb.end           equ  edb.struct + 20 ; End of structure
0148               *--------------------------------------------------------------
0149               * File handling structures          @>a400-a4ff     (256 bytes)
0150               *--------------------------------------------------------------
0151      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0152      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0153      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0154      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0155      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0156      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0157      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0158      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0159      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0160      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0161      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0162      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0163      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0164      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0165      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0166      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0167      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0168      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0169      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0170      A496     fh.end            equ  fh.struct +150  ; End of structure
0171      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0172      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0173               *--------------------------------------------------------------
0174               * Command buffer structure          @>a500-a5ff     (256 bytes)
0175               *--------------------------------------------------------------
0176      A500     cmdb.struct     equ  >a500             ; Command Buffer structure
0177      A500     cmdb.top.ptr    equ  cmdb.struct       ; Pointer to command buffer
0178      A502     cmdb.visible    equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=visible)
0179      A504     cmdb.scrrows    equ  cmdb.struct + 4   ; Current size of cmdb pane (in rows)
0180      A506     cmdb.default    equ  cmdb.struct + 6   ; Default size of cmdb pane (in rows)
0181      A508     cmdb.yxtop      equ  cmdb.struct + 8   ; Screen YX of 1st row in cmdb pane
0182      A50A     cmdb.yxsave     equ  cmdb.struct + 10  ; Copy of WYX
0183      A50C     cmdb.lines      equ  cmdb.struct + 12  ; Total lines in editor buffer
0184      A50E     cmdb.dirty      equ  cmdb.struct + 14  ; Editor buffer dirty (Text changed!)
0185      A510     cmdb.hasfocus   equ  cmdb.struct + 16  ; CMDB pane has focus (>ffff=yes)
0186      A512     cmdb.end        equ  cmdb.struct + 18  ; End of structure
0187               *--------------------------------------------------------------
0188               * Free for future use               @>a600-a64f     (80 bytes)
0189               *--------------------------------------------------------------
0190      A600     free.mem2       equ  >a600             ; >b600-b64f    80 bytes
0191               *--------------------------------------------------------------
0192               * Frame buffer                      @>a650-afff    (2480 bytes)
0193               *--------------------------------------------------------------
0194      A650     fb.top          equ  >a650             ; Frame buffer low mem 2480 bytes (80x31)
0195      09B0     fb.size         equ  2480              ; Frame buffer size
0196               *--------------------------------------------------------------
0197               * Command buffer                    @>b000-bfff    (4096 bytes)
0198               *--------------------------------------------------------------
0199      B000     cmdb.top        equ  >b000             ; Top of command buffer
0200      1000     cmdb.size       equ  4096              ; Command buffer size
0201               *--------------------------------------------------------------
0202               * Index                             @>c000-cfff    (4096 bytes)
0203               *--------------------------------------------------------------
0204      C000     idx.top         equ  >c000             ; Top of index
0205      1000     idx.size        equ  4096              ; Index size
0206               *--------------------------------------------------------------
0207               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0208               *--------------------------------------------------------------
0209      D000     idx.shadow.top  equ  >d000             ; Top of shadow index
0210      1000     idx.shadow.size equ  4096              ; Shadow index size
0211               *--------------------------------------------------------------
0212               * Editor buffer                     @>e000-efff    (4096 bytes)
0213               *                                   @>f000-ffff    (4096 bytes)
0214               *--------------------------------------------------------------
0215      E000     edb.top         equ  >e000             ; Editor buffer high memory
0216      2000     edb.size        equ  8192              ; Editor buffer size
0217               *--------------------------------------------------------------
**** **** ****     > tivi_b1.asm.21084
0018                       copy  "kickstart.asm"       ; Cartridge header
**** **** ****     > kickstart.asm
0001               * FILE......: kickstart.asm
0002               * Purpose...: Bankswitch routine for starting TiVi
0003               
0004               ***************************************************************
0005               * TiVi Cartridge Header & kickstart ROM bank 0
0006               ***************************************************************
0007               *
0008               *--------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * OUTPUT
0013               * none
0014               *--------------------------------------------------------------
0015               * Register usage
0016               * r0
0017               ***************************************************************
0018               
0019               *--------------------------------------------------------------
0020               * Cartridge header
0021               ********|*****|*********************|**************************
0022 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0023 6006 6010             data  $+10
0024 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0025 6010 0000             data  0                     ; No more items following
0026 6012 6030             data  kickstart.code1
0027               
0029               
0030 6014 1154             byte  17
0031 6015 ....             text  'TIVI 200325-21084'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > tivi_b1.asm.21084
0019               
0020                       aorg  >2000
0021                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
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
0061               *
0062               * == Kernel/Multitasking
0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0066               *
0067               * == Startup behaviour
0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0070               *******************************************************************************
0071               
0072               *//////////////////////////////////////////////////////////////
0073               *                       RUNLIB SETUP
0074               *//////////////////////////////////////////////////////////////
0075               
0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
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
0077                       copy  "equ_registers.asm"        ; Equates runlib registers
**** **** ****     > equ_registers.asm
0001               * FILE......: registers.asm
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0011               * R9      Stack pointer
0012               * R10     Highest slot in use + Timer counter
0013               * R11     Subroutine return address
0014               * R12     CRU
0015               * R13     Copy of VDP status byte and counter for sound player
0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0017               * R15     VDP read/write address
0018               *--------------------------------------------------------------
0019               * Special purpose registers
0020               * R0      shift count
0021               * R12     CRU
0022               * R13     WS     - when using LWPI, BLWP, RTWP
0023               * R14     PC     - when using LWPI, BLWP, RTWP
0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0025               ***************************************************************
0026               * Define registers
0027               ********|*****|*********************|**************************
0028      0000     r0      equ   0
0029      0001     r1      equ   1
0030      0002     r2      equ   2
0031      0003     r3      equ   3
0032      0004     r4      equ   4
0033      0005     r5      equ   5
0034      0006     r6      equ   6
0035      0007     r7      equ   7
0036      0008     r8      equ   8
0037      0009     r9      equ   9
0038      000A     r10     equ   10
0039      000B     r11     equ   11
0040      000C     r12     equ   12
0041      000D     r13     equ   13
0042      000E     r14     equ   14
0043      000F     r15     equ   15
0044               ***************************************************************
0045               * Define register equates
0046               ********|*****|*********************|**************************
0047      0002     config  equ   r2                    ; Config register
0048      0003     xconfig equ   r3                    ; Extended config register
0049      0004     tmp0    equ   r4                    ; Temp register 0
0050      0005     tmp1    equ   r5                    ; Temp register 1
0051      0006     tmp2    equ   r6                    ; Temp register 2
0052      0007     tmp3    equ   r7                    ; Temp register 3
0053      0008     tmp4    equ   r8                    ; Temp register 4
0054      0009     stack   equ   r9                    ; Stack pointer
0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0057               ***************************************************************
0058               * Define MSB/LSB equates for registers
0059               ********|*****|*********************|**************************
0060      8300     r0hb    equ   ws1                   ; HI byte R0
0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0092               ********|*****|*********************|**************************
0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0103               ********|*****|*********************|**************************
0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0108               ***************************************************************
**** **** ****     > runlib.asm
0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
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
0079                       copy  "equ_param.asm"            ; Equates runlib parameters
**** **** ****     > equ_param.asm
0001               * FILE......: param.asm
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
0080               
0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
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
0027 2004 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 2006 C155  26         mov   *tmp1,tmp1
0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0012 200A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 200C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 200E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2010 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2012 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 2014 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 2016 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 2018 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 201A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 201C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 201E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2020 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2022 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 2024 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 2026 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 2028 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 202A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 202C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 202E D000     w$d000  data  >d000                 ; >d000
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
0086                       copy  "equ_config.asm"           ; Equates for bits in config register
**** **** ****     > equ_config.asm
0001               * FILE......: equ_config.asm
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
0032               
**** **** ****     > runlib.asm
0087                       copy  "cpu_crash.asm"            ; CPU crash handler
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
0038 2030 022B  22         ai    r11,-4                ; Remove opcode offset
     2032 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 2034 C800  38         mov   r0,@>ffe0
     2036 FFE0 
0043 2038 C801  38         mov   r1,@>ffe2
     203A FFE2 
0044 203C C802  38         mov   r2,@>ffe4
     203E FFE4 
0045 2040 C803  38         mov   r3,@>ffe6
     2042 FFE6 
0046 2044 C804  38         mov   r4,@>ffe8
     2046 FFE8 
0047 2048 C805  38         mov   r5,@>ffea
     204A FFEA 
0048 204C C806  38         mov   r6,@>ffec
     204E FFEC 
0049 2050 C807  38         mov   r7,@>ffee
     2052 FFEE 
0050 2054 C808  38         mov   r8,@>fff0
     2056 FFF0 
0051 2058 C809  38         mov   r9,@>fff2
     205A FFF2 
0052 205C C80A  38         mov   r10,@>fff4
     205E FFF4 
0053 2060 C80B  38         mov   r11,@>fff6
     2062 FFF6 
0054 2064 C80C  38         mov   r12,@>fff8
     2066 FFF8 
0055 2068 C80D  38         mov   r13,@>fffa
     206A FFFA 
0056 206C C80E  38         mov   r14,@>fffc
     206E FFFC 
0057 2070 C80F  38         mov   r15,@>ffff
     2072 FFFF 
0058 2074 02A0  12         stwp  r0
0059 2076 C800  38         mov   r0,@>ffdc
     2078 FFDC 
0060 207A 02C0  12         stst  r0
0061 207C C800  38         mov   r0,@>ffde
     207E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2080 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2082 8300 
0067 2084 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2086 8302 
0068 2088 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     208A 4A4A 
0069 208C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     208E 2D18 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @putat                ; Show crash message
     2092 2410 
0078 2094 0000                   data >0000,cpu.crash.msg.crashed
     2096 216A 
0079               
0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
     209A 2946 
0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 20A4 06A0  32         bl    @putat                ; Show caller message
     20A6 2410 
0090 20A8 0100                   data >0100,cpu.crash.msg.caller
     20AA 2180 
0091               
0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
     20AE 2946 
0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 20B8 06A0  32         bl    @putat
     20BA 2410 
0102 20BC 0300                   byte 3,0
0103 20BE 219A                   data cpu.crash.msg.wp
0104 20C0 06A0  32         bl    @putat
     20C2 2410 
0105 20C4 0400                   byte 4,0
0106 20C6 21A0                   data cpu.crash.msg.st
0107 20C8 06A0  32         bl    @putat
     20CA 2410 
0108 20CC 1600                   byte 22,0
0109 20CE 21A6                   data cpu.crash.msg.source
0110 20D0 06A0  32         bl    @putat
     20D2 2410 
0111 20D4 1700                   byte 23,0
0112 20D6 21C0                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
     20DA 264E 
0117 20DC 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 20DE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20E0 FFDC 
0121 20E2 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 20E4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 20E6 0649  14         dect  stack
0127 20E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 20EA 0649  14         dect  stack
0129 20EC C645  30         mov   tmp1,*stack           ; Push tmp1
0130 20EE 0649  14         dect  stack
0131 20F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 20F2 C046  18         mov   tmp2,r1               ; Save register number
0137 20F4 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     20F6 0001 
0138 20F8 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 20FA 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 20FC 06A0  32         bl    @mknum
     20FE 2950 
0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
     2108 2664 
0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     210E 23FE 
0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
     2114 2664 
0157 2116 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 2118 0281  22         ci    r1,10
     211A 000A 
0161 211C 1102  14         jlt   !
0162 211E 0620  34         dec   @wyx                  ; x=x-1
     2120 832A 
0163               
0164 2122 06A0  32 !       bl    @putstr
     2124 23FE 
0165 2126 2196                   data cpu.crash.msg.r
0166               
0167 2128 06A0  32         bl    @mknum
     212A 2950 
0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
     2134 28C2 
0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
     213E 2664 
0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 2142 06A0  32         bl    @putstr
     2144 23FE 
0187 2146 2198                   data cpu.crash.msg.marker
0188               
0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
     214A 2664 
0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2150 23FE 
0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 215A 06A0  32         bl    @down                 ; y=y+1
     215C 2654 
0202               
0203 215E 0586  14         inc   tmp2
0204 2160 0286  22         ci    tmp2,17
     2162 0011 
0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2168 2C26 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 216A 1553             byte  21
0214 216B ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 2180 1543             byte  21
0219 2181 ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 2196 0152             byte  1
0224 2197 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 2198 013E             byte  1
0229 2199 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 219A 042A             byte  4
0234 219B ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 21A0 042A             byte  4
0239 21A1 ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 21A6 1953             byte  25
0244 21A7 ....             text  'Source    tivi_b1.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 21C0 1642             byte  22
0249 21C1 ....             text  'Build-ID  200325-21084'
0250                       even
0251               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21D8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21DA 000E 
     21DC 0106 
     21DE 0204 
     21E0 0020 
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
0032 21E2 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21E4 000E 
     21E6 0106 
     21E8 00F4 
     21EA 0028 
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
0058 21EC 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21EE 003F 
     21F0 0240 
     21F2 03F4 
     21F4 0050 
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
0084 21F6 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21F8 003F 
     21FA 0240 
     21FC 03F4 
     21FE 0050 
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
0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 2200 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2202 16FD             data  >16fd                 ; |         jne   mcloop
0015 2204 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2206 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2208 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               *//////////////////////////////////////////////////////////////
0027               *                    STACK SUPPORT FUNCTIONS
0028               *//////////////////////////////////////////////////////////////
0029               
0030               ***************************************************************
0031               * POPR. - Pop registers & return to caller
0032               ***************************************************************
0033               *  B  @POPRG.
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  R11 must be at stack bottom
0037               ********|*****|*********************|**************************
0038 220A C0F9  30 popr3   mov   *stack+,r3
0039 220C C0B9  30 popr2   mov   *stack+,r2
0040 220E C079  30 popr1   mov   *stack+,r1
0041 2210 C039  30 popr0   mov   *stack+,r0
0042 2212 C2F9  30 poprt   mov   *stack+,r11
0043 2214 045B  20         b     *r11
0044               
0045               
0046               
0047               *//////////////////////////////////////////////////////////////
0048               *                   MEMORY FILL FUNCTIONS
0049               *//////////////////////////////////////////////////////////////
0050               
0051               ***************************************************************
0052               * FILM - Fill CPU memory with byte
0053               ***************************************************************
0054               *  bl   @film
0055               *  data P0,P1,P2
0056               *--------------------------------------------------------------
0057               *  P0 = Memory start address
0058               *  P1 = Byte to fill
0059               *  P2 = Number of bytes to fill
0060               *--------------------------------------------------------------
0061               *  bl   @xfilm
0062               *
0063               *  TMP0 = Memory start address
0064               *  TMP1 = Byte to fill
0065               *  TMP2 = Number of bytes to fill
0066               ********|*****|*********************|**************************
0067 2216 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 2218 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 221A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 221C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 221E 1604  14         jne   filchk                ; No, continue checking
0075               
0076 2220 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2222 FFCE 
0077 2224 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2226 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 2228 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     222A 830B 
     222C 830A 
0082               
0083 222E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2230 0001 
0084 2232 1602  14         jne   filchk2
0085 2234 DD05  32         movb  tmp1,*tmp0+
0086 2236 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 2238 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     223A 0002 
0091 223C 1603  14         jne   filchk3
0092 223E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 2240 DD05  32         movb  tmp1,*tmp0+
0094 2242 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 2244 C1C4  18 filchk3 mov   tmp0,tmp3
0099 2246 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2248 0001 
0100 224A 1605  14         jne   fil16b
0101 224C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 224E 0606  14         dec   tmp2
0103 2250 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2252 0002 
0104 2254 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2256 C1C6  18 fil16b  mov   tmp2,tmp3
0109 2258 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     225A 0001 
0110 225C 1301  14         jeq   dofill
0111 225E 0606  14         dec   tmp2                  ; Make TMP2 even
0112 2260 CD05  34 dofill  mov   tmp1,*tmp0+
0113 2262 0646  14         dect  tmp2
0114 2264 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2266 C1C7  18         mov   tmp3,tmp3
0119 2268 1301  14         jeq   fil.$$
0120 226A DD05  32         movb  tmp1,*tmp0+
0121 226C 045B  20 fil.$$  b     *r11
0122               
0123               
0124               ***************************************************************
0125               * FILV - Fill VRAM with byte
0126               ***************************************************************
0127               *  BL   @FILV
0128               *  DATA P0,P1,P2
0129               *--------------------------------------------------------------
0130               *  P0 = VDP start address
0131               *  P1 = Byte to fill
0132               *  P2 = Number of bytes to fill
0133               *--------------------------------------------------------------
0134               *  BL   @XFILV
0135               *
0136               *  TMP0 = VDP start address
0137               *  TMP1 = Byte to fill
0138               *  TMP2 = Number of bytes to fill
0139               ********|*****|*********************|**************************
0140 226E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 2270 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 2272 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 2274 0264  22 xfilv   ori   tmp0,>4000
     2276 4000 
0147 2278 06C4  14         swpb  tmp0
0148 227A D804  38         movb  tmp0,@vdpa
     227C 8C02 
0149 227E 06C4  14         swpb  tmp0
0150 2280 D804  38         movb  tmp0,@vdpa
     2282 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 2284 020F  20         li    r15,vdpw              ; Set VDP write address
     2286 8C00 
0155 2288 06C5  14         swpb  tmp1
0156 228A C820  54         mov   @filzz,@mcloop        ; Setup move command
     228C 2294 
     228E 8320 
0157 2290 0460  28         b     @mcloop               ; Write data to VDP
     2292 8320 
0158               *--------------------------------------------------------------
0162 2294 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0164               
0165               
0166               
0167               *//////////////////////////////////////////////////////////////
0168               *                  VDP LOW LEVEL FUNCTIONS
0169               *//////////////////////////////////////////////////////////////
0170               
0171               ***************************************************************
0172               * VDWA / VDRA - Setup VDP write or read address
0173               ***************************************************************
0174               *  BL   @VDWA
0175               *
0176               *  TMP0 = VDP destination address for write
0177               *--------------------------------------------------------------
0178               *  BL   @VDRA
0179               *
0180               *  TMP0 = VDP source address for read
0181               ********|*****|*********************|**************************
0182 2296 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     2298 4000 
0183 229A 06C4  14 vdra    swpb  tmp0
0184 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0185 22A0 06C4  14         swpb  tmp0
0186 22A2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22A4 8C02 
0187 22A6 045B  20         b     *r11                  ; Exit
0188               
0189               ***************************************************************
0190               * VPUTB - VDP put single byte
0191               ***************************************************************
0192               *  BL @VPUTB
0193               *  DATA P0,P1
0194               *--------------------------------------------------------------
0195               *  P0 = VDP target address
0196               *  P1 = Byte to write
0197               ********|*****|*********************|**************************
0198 22A8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22AA C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22AC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22AE 4000 
0204 22B0 06C4  14         swpb  tmp0                  ; \
0205 22B2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22B4 8C02 
0206 22B6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22B8 D804  38         movb  tmp0,@vdpa            ; /
     22BA 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22BC 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22BE D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22C0 045B  20         b     *r11                  ; Exit
0214               
0215               
0216               ***************************************************************
0217               * VGETB - VDP get single byte
0218               ***************************************************************
0219               *  bl   @vgetb
0220               *  data p0
0221               *--------------------------------------------------------------
0222               *  P0 = VDP source address
0223               *--------------------------------------------------------------
0224               *  bl   @xvgetb
0225               *
0226               *  tmp0 = VDP source address
0227               *--------------------------------------------------------------
0228               *  Output:
0229               *  tmp0 MSB = >00
0230               *  tmp0 LSB = VDP byte read
0231               ********|*****|*********************|**************************
0232 22C2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22C4 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22C6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22C8 8C02 
0238 22CA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22CC D804  38         movb  tmp0,@vdpa            ; /
     22CE 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22D0 D120  34         movb  @vdpr,tmp0            ; Read byte
     22D2 8800 
0244 22D4 0984  56         srl   tmp0,8                ; Right align
0245 22D6 045B  20         b     *r11                  ; Exit
0246               
0247               
0248               ***************************************************************
0249               * VIDTAB - Dump videomode table
0250               ***************************************************************
0251               *  BL   @VIDTAB
0252               *  DATA P0
0253               *--------------------------------------------------------------
0254               *  P0 = Address of video mode table
0255               *--------------------------------------------------------------
0256               *  BL   @XIDTAB
0257               *
0258               *  TMP0 = Address of video mode table
0259               *--------------------------------------------------------------
0260               *  Remarks
0261               *  TMP1 = MSB is the VDP target register
0262               *         LSB is the value to write
0263               ********|*****|*********************|**************************
0264 22D8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22DA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22DC C144  18         mov   tmp0,tmp1
0270 22DE 05C5  14         inct  tmp1
0271 22E0 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22E2 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22E4 FF00 
0273 22E6 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 22E8 C805  38         mov   tmp1,@wbase           ; Store calculated base
     22EA 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 22EC 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     22EE 8000 
0279 22F0 0206  20         li    tmp2,8
     22F2 0008 
0280 22F4 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     22F6 830B 
0281 22F8 06C5  14         swpb  tmp1
0282 22FA D805  38         movb  tmp1,@vdpa
     22FC 8C02 
0283 22FE 06C5  14         swpb  tmp1
0284 2300 D805  38         movb  tmp1,@vdpa
     2302 8C02 
0285 2304 0225  22         ai    tmp1,>0100
     2306 0100 
0286 2308 0606  14         dec   tmp2
0287 230A 16F4  14         jne   vidta1                ; Next register
0288 230C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     230E 833A 
0289 2310 045B  20         b     *r11
0290               
0291               
0292               ***************************************************************
0293               * PUTVR  - Put single VDP register
0294               ***************************************************************
0295               *  BL   @PUTVR
0296               *  DATA P0
0297               *--------------------------------------------------------------
0298               *  P0 = MSB is the VDP target register
0299               *       LSB is the value to write
0300               *--------------------------------------------------------------
0301               *  BL   @PUTVRX
0302               *
0303               *  TMP0 = MSB is the VDP target register
0304               *         LSB is the value to write
0305               ********|*****|*********************|**************************
0306 2312 C13B  30 putvr   mov   *r11+,tmp0
0307 2314 0264  22 putvrx  ori   tmp0,>8000
     2316 8000 
0308 2318 06C4  14         swpb  tmp0
0309 231A D804  38         movb  tmp0,@vdpa
     231C 8C02 
0310 231E 06C4  14         swpb  tmp0
0311 2320 D804  38         movb  tmp0,@vdpa
     2322 8C02 
0312 2324 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2326 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 2328 C10E  18         mov   r14,tmp0
0322 232A 0984  56         srl   tmp0,8
0323 232C 06A0  32         bl    @putvrx               ; Write VR#0
     232E 2314 
0324 2330 0204  20         li    tmp0,>0100
     2332 0100 
0325 2334 D820  54         movb  @r14lb,@tmp0lb
     2336 831D 
     2338 8309 
0326 233A 06A0  32         bl    @putvrx               ; Write VR#1
     233C 2314 
0327 233E 0458  20         b     *tmp4                 ; Exit
0328               
0329               
0330               ***************************************************************
0331               * LDFNT - Load TI-99/4A font from GROM into VDP
0332               ***************************************************************
0333               *  BL   @LDFNT
0334               *  DATA P0,P1
0335               *--------------------------------------------------------------
0336               *  P0 = VDP Target address
0337               *  P1 = Font options
0338               *--------------------------------------------------------------
0339               * Uses registers tmp0-tmp4
0340               ********|*****|*********************|**************************
0341 2340 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 2342 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 2344 C11B  26         mov   *r11,tmp0             ; Get P0
0344 2346 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2348 7FFF 
0345 234A 2120  38         coc   @wbit0,tmp0
     234C 202A 
0346 234E 1604  14         jne   ldfnt1
0347 2350 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2352 8000 
0348 2354 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2356 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 2358 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     235A 23C2 
0353 235C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     235E 9C02 
0354 2360 06C4  14         swpb  tmp0
0355 2362 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2364 9C02 
0356 2366 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2368 9800 
0357 236A 06C5  14         swpb  tmp1
0358 236C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     236E 9800 
0359 2370 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 2372 D805  38         movb  tmp1,@grmwa
     2374 9C02 
0364 2376 06C5  14         swpb  tmp1
0365 2378 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     237A 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 237C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 237E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     2380 2296 
0371 2382 05C8  14         inct  tmp4                  ; R11=R11+2
0372 2384 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 2386 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     2388 7FFF 
0374 238A C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     238C 23C4 
0375 238E C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     2390 23C6 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 2392 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 2394 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 2396 D120  34         movb  @grmrd,tmp0
     2398 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 239A 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     239C 202A 
0386 239E 1603  14         jne   ldfnt3                ; No, so skip
0387 23A0 D1C4  18         movb  tmp0,tmp3
0388 23A2 0917  56         srl   tmp3,1
0389 23A4 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23A6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23A8 8C00 
0394 23AA 0606  14         dec   tmp2
0395 23AC 16F2  14         jne   ldfnt2
0396 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23B0 020F  20         li    r15,vdpw              ; Set VDP write address
     23B2 8C00 
0398 23B4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23B6 7FFF 
0399 23B8 0458  20         b     *tmp4                 ; Exit
0400 23BA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23BC 200A 
     23BE 8C00 
0401 23C0 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23C2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23C4 0200 
     23C6 0000 
0406 23C8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23CA 01C0 
     23CC 0101 
0407 23CE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23D0 02A0 
     23D2 0101 
0408 23D4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23D6 00E0 
     23D8 0101 
0409               
0410               
0411               
0412               ***************************************************************
0413               * YX2PNT - Get VDP PNT address for current YX cursor position
0414               ***************************************************************
0415               *  BL   @YX2PNT
0416               *--------------------------------------------------------------
0417               *  INPUT
0418               *  @WYX = Cursor YX position
0419               *--------------------------------------------------------------
0420               *  OUTPUT
0421               *  TMP0 = VDP address for entry in Pattern Name Table
0422               *--------------------------------------------------------------
0423               *  Register usage
0424               *  TMP0, R14, R15
0425               ********|*****|*********************|**************************
0426 23DA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23DC C3A0  34         mov   @wyx,r14              ; Get YX
     23DE 832A 
0428 23E0 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23E2 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23E4 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 23E6 C3A0  34         mov   @wyx,r14              ; Get YX
     23E8 832A 
0435 23EA 024E  22         andi  r14,>00ff             ; Remove Y
     23EC 00FF 
0436 23EE A3CE  18         a     r14,r15               ; pos = pos + X
0437 23F0 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     23F2 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 23F4 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 23F6 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 23F8 020F  20         li    r15,vdpw              ; VDP write address
     23FA 8C00 
0444 23FC 045B  20         b     *r11
0445               
0446               
0447               
0448               ***************************************************************
0449               * Put length-byte prefixed string at current YX
0450               ***************************************************************
0451               *  BL   @PUTSTR
0452               *  DATA P0
0453               *
0454               *  P0 = Pointer to string
0455               *--------------------------------------------------------------
0456               *  REMARKS
0457               *  First byte of string must contain length
0458               ********|*****|*********************|**************************
0459 23FE C17B  30 putstr  mov   *r11+,tmp1
0460 2400 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 2402 C1CB  18 xutstr  mov   r11,tmp3
0462 2404 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2406 23DA 
0463 2408 C2C7  18         mov   tmp3,r11
0464 240A 0986  56         srl   tmp2,8                ; Right justify length byte
0465 240C 0460  28         b     @xpym2v               ; Display string
     240E 241E 
0466               
0467               
0468               ***************************************************************
0469               * Put length-byte prefixed string at YX
0470               ***************************************************************
0471               *  BL   @PUTAT
0472               *  DATA P0,P1
0473               *
0474               *  P0 = YX position
0475               *  P1 = Pointer to string
0476               *--------------------------------------------------------------
0477               *  REMARKS
0478               *  First byte of string must contain length
0479               ********|*****|*********************|**************************
0480 2410 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2412 832A 
0481 2414 0460  28         b     @putstr
     2416 23FE 
**** **** ****     > runlib.asm
0090               
0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 2418 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 241A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 241C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 241E 0264  22 xpym2v  ori   tmp0,>4000
     2420 4000 
0027 2422 06C4  14         swpb  tmp0
0028 2424 D804  38         movb  tmp0,@vdpa
     2426 8C02 
0029 2428 06C4  14         swpb  tmp0
0030 242A D804  38         movb  tmp0,@vdpa
     242C 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 242E 020F  20         li    r15,vdpw              ; Set VDP write address
     2430 8C00 
0035 2432 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2434 243C 
     2436 8320 
0036 2438 0460  28         b     @mcloop               ; Write data to VDP
     243A 8320 
0037 243C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0094               
0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 243E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2440 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2442 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2444 06C4  14 xpyv2m  swpb  tmp0
0027 2446 D804  38         movb  tmp0,@vdpa
     2448 8C02 
0028 244A 06C4  14         swpb  tmp0
0029 244C D804  38         movb  tmp0,@vdpa
     244E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2450 020F  20         li    r15,vdpr              ; Set VDP read address
     2452 8800 
0034 2454 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2456 245E 
     2458 8320 
0035 245A 0460  28         b     @mcloop               ; Read data from VDP
     245C 8320 
0036 245E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0098               
0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 2460 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 2462 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2464 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2466 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2468 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 246A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     246C FFCE 
0034 246E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2470 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2472 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2474 0001 
0039 2476 1603  14         jne   cpym0                 ; No, continue checking
0040 2478 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 247A 04C6  14         clr   tmp2                  ; Reset counter
0042 247C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 247E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2480 7FFF 
0047 2482 C1C4  18         mov   tmp0,tmp3
0048 2484 0247  22         andi  tmp3,1
     2486 0001 
0049 2488 1618  14         jne   cpyodd                ; Odd source address handling
0050 248A C1C5  18 cpym1   mov   tmp1,tmp3
0051 248C 0247  22         andi  tmp3,1
     248E 0001 
0052 2490 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2492 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2494 202A 
0057 2496 1605  14         jne   cpym3
0058 2498 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     249A 24C0 
     249C 8320 
0059 249E 0460  28         b     @mcloop               ; Copy memory and exit
     24A0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24A2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24A4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24A6 0001 
0065 24A8 1301  14         jeq   cpym4
0066 24AA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24AC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24AE 0646  14         dect  tmp2
0069 24B0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24B2 C1C7  18         mov   tmp3,tmp3
0074 24B4 1301  14         jeq   cpymz
0075 24B6 D554  38         movb  *tmp0,*tmp1
0076 24B8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24BA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24BC 8000 
0081 24BE 10E9  14         jmp   cpym2
0082 24C0 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0106               
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0062 24C2 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24C4 0649  14         dect  stack
0065 24C6 C64B  30         mov   r11,*stack            ; Push return address
0066 24C8 0649  14         dect  stack
0067 24CA C640  30         mov   r0,*stack             ; Push r0
0068 24CC 0649  14         dect  stack
0069 24CE C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24D0 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24D2 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24D4 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24D6 4000 
0077 24D8 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24DA 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 24DC 020C  20         li    r12,>1e00             ; SAMS CRU address
     24DE 1E00 
0082 24E0 04C0  14         clr   r0
0083 24E2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24E4 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 24E6 D100  18         movb  r0,tmp0
0086 24E8 0984  56         srl   tmp0,8                ; Right align
0087 24EA C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     24EC 833C 
0088 24EE 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 24F0 C339  30         mov   *stack+,r12           ; Pop r12
0094 24F2 C039  30         mov   *stack+,r0            ; Pop r0
0095 24F4 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 24F6 045B  20         b     *r11                  ; Return to caller
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
0131 24F8 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 24FA C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 24FC 0649  14         dect  stack
0135 24FE C64B  30         mov   r11,*stack            ; Push return address
0136 2500 0649  14         dect  stack
0137 2502 C640  30         mov   r0,*stack             ; Push r0
0138 2504 0649  14         dect  stack
0139 2506 C64C  30         mov   r12,*stack            ; Push r12
0140 2508 0649  14         dect  stack
0141 250A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 250C 0649  14         dect  stack
0143 250E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2510 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2512 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 2514 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2516 001E 
0153 2518 150A  14         jgt   !
0154 251A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     251C 0004 
0155 251E 1107  14         jlt   !
0156 2520 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2522 0012 
0157 2524 1508  14         jgt   sams.page.set.switch_page
0158 2526 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2528 0006 
0159 252A 1501  14         jgt   !
0160 252C 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 252E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2530 FFCE 
0165 2532 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2534 2030 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 2536 020C  20         li    r12,>1e00             ; SAMS CRU address
     2538 1E00 
0171 253A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 253C 06C0  14         swpb  r0                    ; LSB to MSB
0173 253E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 2540 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2542 4000 
0175 2544 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 2546 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 2548 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 254A C339  30         mov   *stack+,r12           ; Pop r12
0183 254C C039  30         mov   *stack+,r0            ; Pop r0
0184 254E C2F9  30         mov   *stack+,r11           ; Pop return address
0185 2550 045B  20         b     *r11                  ; Return to caller
0186               
0187               
0188               
0189               
0190               ***************************************************************
0191               * sams.mapping.on - Enable SAMS mapping mode
0192               ***************************************************************
0193               *  bl   @sams.mapping.on
0194               *--------------------------------------------------------------
0195               *  Register usage
0196               *  r12
0197               ********|*****|*********************|**************************
0198               sams.mapping.on:
0199 2552 020C  20         li    r12,>1e00             ; SAMS CRU address
     2554 1E00 
0200 2556 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 2558 045B  20         b     *r11                  ; Return to caller
0206               
0207               
0208               
0209               
0210               ***************************************************************
0211               * sams.mapping.off - Disable SAMS mapping mode
0212               ***************************************************************
0213               * bl  @sams.mapping.off
0214               *--------------------------------------------------------------
0215               * OUTPUT
0216               * none
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * r12
0220               ********|*****|*********************|**************************
0221               sams.mapping.off:
0222 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0223 255E 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 2560 045B  20         b     *r11                  ; Return to caller
0229               
0230               
0231               
0232               
0233               
0234               ***************************************************************
0235               * sams.layout
0236               * Setup SAMS memory banks
0237               ***************************************************************
0238               * bl  @sams.layout
0239               *     data P0
0240               *--------------------------------------------------------------
0241               * INPUT
0242               * P0 = Pointer to SAMS page layout table (16 words).
0243               *--------------------------------------------------------------
0244               * bl  @xsams.layout
0245               *
0246               * tmp0 = Pointer to SAMS page layout table (16 words).
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0, tmp1, tmp2, tmp3
0253               ********|*****|*********************|**************************
0254               sams.layout:
0255 2562 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 2564 0649  14         dect  stack
0258 2566 C64B  30         mov   r11,*stack            ; Save return address
0259 2568 0649  14         dect  stack
0260 256A C644  30         mov   tmp0,*stack           ; Save tmp0
0261 256C 0649  14         dect  stack
0262 256E C645  30         mov   tmp1,*stack           ; Save tmp1
0263 2570 0649  14         dect  stack
0264 2572 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 2574 0649  14         dect  stack
0266 2576 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 2578 0206  20         li    tmp2,8                ; Set loop counter
     257A 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 257C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 257E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 2580 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2582 24FC 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 2584 0606  14         dec   tmp2                  ; Next iteration
0283 2586 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 2588 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     258A 2552 
0289                                                   ; / activating changes.
0290               
0291 258C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 258E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 2590 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 2592 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 2594 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 2596 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.reset.layout
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.reset.layout
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.reset.layout:
0313 2598 0649  14         dect  stack
0314 259A C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 259C 06A0  32         bl    @sams.layout
     259E 2562 
0319 25A0 25A6                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.layout.exit:
0324 25A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 25A4 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 25A6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25A8 0002 
0331 25AA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25AC 0003 
0332 25AE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25B0 000A 
0333 25B2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25B4 000B 
0334 25B6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25B8 000C 
0335 25BA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25BC 000D 
0336 25BE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25C0 000E 
0337 25C2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25C4 000F 
0338               
0339               
0340               
0341               ***************************************************************
0342               * sams.copy.layout
0343               * Copy SAMS memory layout
0344               ***************************************************************
0345               * bl  @sams.copy.layout
0346               *     data P0
0347               *--------------------------------------------------------------
0348               * P0 = Pointer to 8 words RAM buffer for results
0349               *--------------------------------------------------------------
0350               * OUTPUT
0351               * RAM buffer will have the SAMS page number for each range
0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0353               *--------------------------------------------------------------
0354               * Register usage
0355               * tmp0, tmp1, tmp2, tmp3
0356               ***************************************************************
0357               sams.copy.layout:
0358 25C6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 25C8 0649  14         dect  stack
0361 25CA C64B  30         mov   r11,*stack            ; Push return address
0362 25CC 0649  14         dect  stack
0363 25CE C644  30         mov   tmp0,*stack           ; Push tmp0
0364 25D0 0649  14         dect  stack
0365 25D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 25D4 0649  14         dect  stack
0367 25D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 25D8 0649  14         dect  stack
0369 25DA C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 25DC 0205  20         li    tmp1,sams.copy.layout.data
     25DE 25FE 
0374 25E0 0206  20         li    tmp2,8                ; Set loop counter
     25E2 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.copy.layout.loop:
0379 25E4 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 25E6 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     25E8 24C4 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 25EA CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     25EC 833C 
0385               
0386 25EE 0606  14         dec   tmp2                  ; Next iteration
0387 25F0 16F9  14         jne   sams.copy.layout.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.copy.layout.exit:
0392 25F2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 25F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 25F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 25F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 25FA C2F9  30         mov   *stack+,r11           ; Pop r11
0397 25FC 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.copy.layout.data:
0402 25FE 2000             data  >2000                 ; >2000-2fff
0403 2600 3000             data  >3000                 ; >3000-3fff
0404 2602 A000             data  >a000                 ; >a000-afff
0405 2604 B000             data  >b000                 ; >b000-bfff
0406 2606 C000             data  >c000                 ; >c000-cfff
0407 2608 D000             data  >d000                 ; >d000-dfff
0408 260A E000             data  >e000                 ; >e000-efff
0409 260C F000             data  >f000                 ; >f000-ffff
0410               
**** **** ****     > runlib.asm
0114               
0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 260E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2610 FFBF 
0010 2612 0460  28         b     @putv01
     2614 2326 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2616 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2618 0040 
0018 261A 0460  28         b     @putv01
     261C 2326 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 261E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2620 FFDF 
0026 2622 0460  28         b     @putv01
     2624 2326 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2626 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2628 0020 
0034 262A 0460  28         b     @putv01
     262C 2326 
**** **** ****     > runlib.asm
0118               
0120                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 262E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2630 FFFE 
0011 2632 0460  28         b     @putv01
     2634 2326 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2636 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2638 0001 
0019 263A 0460  28         b     @putv01
     263C 2326 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 263E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2640 FFFD 
0027 2642 0460  28         b     @putv01
     2644 2326 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2646 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2648 0002 
0035 264A 0460  28         b     @putv01
     264C 2326 
**** **** ****     > runlib.asm
0122               
0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 264E C83B  50 at      mov   *r11+,@wyx
     2650 832A 
0019 2652 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2654 B820  54 down    ab    @hb$01,@wyx
     2656 201C 
     2658 832A 
0028 265A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 265C 7820  54 up      sb    @hb$01,@wyx
     265E 201C 
     2660 832A 
0037 2662 045B  20         b     *r11
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
0049 2664 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2666 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     2668 832A 
0051 266A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     266C 832A 
0052 266E 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 2670 C120  34 yx2px   mov   @wyx,tmp0
     2672 832A 
0022 2674 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2676 06C4  14         swpb  tmp0                  ; Y<->X
0024 2678 04C5  14         clr   tmp1                  ; Clear before copy
0025 267A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 267C 20A0  38         coc   @wbit1,config         ; f18a present ?
     267E 2028 
0030 2680 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2682 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2684 833A 
     2686 26B0 
0032 2688 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 268A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 268C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 268E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2690 0500 
0037 2692 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2694 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2696 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2698 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 269A D105  18         movb  tmp1,tmp0
0051 269C 06C4  14         swpb  tmp0                  ; X<->Y
0052 269E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26A0 202A 
0053 26A2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26A4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26A6 201C 
0059 26A8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26AA 202E 
0060 26AC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26AE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26B0 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0130               
0134               
0138               
0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
**** **** ****     > vdp_f18a_support.asm
0001               * FILE......: vdp_f18a_support.asm
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
0013 26B2 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26B4 06A0  32         bl    @putvr                ; Write once
     26B6 2312 
0015 26B8 391C             data  >391c                 ; VR1/57, value 00011100
0016 26BA 06A0  32         bl    @putvr                ; Write twice
     26BC 2312 
0017 26BE 391C             data  >391c                 ; VR1/57, value 00011100
0018 26C0 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26C2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26C6 2312 
0028 26C8 391C             data  >391c
0029 26CA 0458  20         b     *tmp4                 ; Exit
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
0040 26CC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26CE 06A0  32         bl    @cpym2v
     26D0 2418 
0042 26D2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26D4 2710 
     26D6 0006 
0043 26D8 06A0  32         bl    @putvr
     26DA 2312 
0044 26DC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26DE 06A0  32         bl    @putvr
     26E0 2312 
0046 26E2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 26E4 0204  20         li    tmp0,>3f00
     26E6 3F00 
0052 26E8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     26EA 229A 
0053 26EC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     26EE 8800 
0054 26F0 0984  56         srl   tmp0,8
0055 26F2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     26F4 8800 
0056 26F6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 26F8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 26FA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     26FC BFFF 
0060 26FE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2700 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2702 4000 
0063               f18chk_exit:
0064 2704 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2706 226E 
0065 2708 3F00             data  >3f00,>00,6
     270A 0000 
     270C 0006 
0066 270E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2710 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2712 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2714 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2716 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2718 06A0  32         bl    @putvr
     271A 2312 
0097 271C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 271E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2720 2312 
0100 2722 391C             data  >391c                 ; Lock the F18a
0101 2724 0458  20         b     *tmp4                 ; Exit
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
0120 2726 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2728 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     272A 2028 
0122 272C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 272E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2730 8802 
0127 2732 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2734 2312 
0128 2736 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2738 04C4  14         clr   tmp0
0130 273A D120  34         movb  @vdps,tmp0
     273C 8802 
0131 273E 0984  56         srl   tmp0,8
0132 2740 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0142               
0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 2742 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2744 832A 
0018 2746 D17B  28         movb  *r11+,tmp1
0019 2748 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 274A D1BB  28         movb  *r11+,tmp2
0021 274C 0986  56         srl   tmp2,8                ; Repeat count
0022 274E C1CB  18         mov   r11,tmp3
0023 2750 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2752 23DA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2754 020B  20         li    r11,hchar1
     2756 275C 
0028 2758 0460  28         b     @xfilv                ; Draw
     275A 2274 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 275C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     275E 202C 
0033 2760 1302  14         jeq   hchar2                ; Yes, exit
0034 2762 C2C7  18         mov   tmp3,r11
0035 2764 10EE  14         jmp   hchar                 ; Next one
0036 2766 05C7  14 hchar2  inct  tmp3
0037 2768 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0146               
0150               
0154               
0158               
0162               
0166               
0170               
0174               
0176                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 276A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     276C 202A 
0017 276E 020C  20         li    r12,>0024
     2770 0024 
0018 2772 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     2774 2802 
0019 2776 04C6  14         clr   tmp2
0020 2778 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 277A 04CC  14         clr   r12
0025 277C 1F08  20         tb    >0008                 ; Shift-key ?
0026 277E 1302  14         jeq   realk1                ; No
0027 2780 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     2782 2832 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 2784 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 2786 1302  14         jeq   realk2                ; No
0033 2788 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     278A 2862 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 278C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 278E 1302  14         jeq   realk3                ; No
0039 2790 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2792 2892 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2794 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 2796 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 2798 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 279A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     279C 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 279E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27A0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27A2 0006 
0052 27A4 0606  14 realk5  dec   tmp2
0053 27A6 020C  20         li    r12,>24               ; CRU address for P2-P4
     27A8 0024 
0054 27AA 06C6  14         swpb  tmp2
0055 27AC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27AE 06C6  14         swpb  tmp2
0057 27B0 020C  20         li    r12,6                 ; CRU read address
     27B2 0006 
0058 27B4 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 27B6 0547  14         inv   tmp3                  ;
0060 27B8 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     27BA FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 27BC 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 27BE 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 27C0 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 27C2 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 27C4 0285  22         ci    tmp1,8
     27C6 0008 
0069 27C8 1AFA  14         jl    realk6
0070 27CA C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 27CC 1BEB  14         jh    realk5                ; No, next column
0072 27CE 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 27D0 C206  18 realk8  mov   tmp2,tmp4
0077 27D2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 27D4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 27D6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 27D8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 27DA 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 27DC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 27DE 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     27E0 202A 
0087 27E2 1608  14         jne   realka                ; No, continue saving key
0088 27E4 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     27E6 282C 
0089 27E8 1A05  14         jl    realka
0090 27EA 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     27EC 282A 
0091 27EE 1B02  14         jh    realka                ; No, continue
0092 27F0 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     27F2 E000 
0093 27F4 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     27F6 833C 
0094 27F8 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     27FA 2014 
0095 27FC 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     27FE 8C00 
0096 2800 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2802 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2804 0000 
     2806 FF0D 
     2808 203D 
0099 280A ....             text  'xws29ol.'
0100 2812 ....             text  'ced38ik,'
0101 281A ....             text  'vrf47ujm'
0102 2822 ....             text  'btg56yhn'
0103 282A ....             text  'zqa10p;/'
0104 2832 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2834 0000 
     2836 FF0D 
     2838 202B 
0105 283A ....             text  'XWS@(OL>'
0106 2842 ....             text  'CED#*IK<'
0107 284A ....             text  'VRF$&UJM'
0108 2852 ....             text  'BTG%^YHN'
0109 285A ....             text  'ZQA!)P:-'
0110 2862 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     2864 0000 
     2866 FF0D 
     2868 2005 
0111 286A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     286C 0804 
     286E 0F27 
     2870 C2B9 
0112 2872 600B             data  >600b,>0907,>063f,>c1B8
     2874 0907 
     2876 063F 
     2878 C1B8 
0113 287A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     287C 7B02 
     287E 015F 
     2880 C0C3 
0114 2882 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     2884 7D0E 
     2886 0CC6 
     2888 BFC4 
0115 288A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     288C 7C03 
     288E BC22 
     2890 BDBA 
0116 2892 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     2894 0000 
     2896 FF0D 
     2898 209D 
0117 289A 9897             data  >9897,>93b2,>9f8f,>8c9B
     289C 93B2 
     289E 9F8F 
     28A0 8C9B 
0118 28A2 8385             data  >8385,>84b3,>9e89,>8b80
     28A4 84B3 
     28A6 9E89 
     28A8 8B80 
0119 28AA 9692             data  >9692,>86b4,>b795,>8a8D
     28AC 86B4 
     28AE B795 
     28B0 8A8D 
0120 28B2 8294             data  >8294,>87b5,>b698,>888E
     28B4 87B5 
     28B6 B698 
     28B8 888E 
0121 28BA 9A91             data  >9a91,>81b1,>b090,>9cBB
     28BC 81B1 
     28BE B090 
     28C0 9CBB 
**** **** ****     > runlib.asm
0178               
0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 28C2 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 28C4 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     28C6 8340 
0025 28C8 04E0  34         clr   @waux1
     28CA 833C 
0026 28CC 04E0  34         clr   @waux2
     28CE 833E 
0027 28D0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     28D2 833C 
0028 28D4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 28D6 0205  20         li    tmp1,4                ; 4 nibbles
     28D8 0004 
0033 28DA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 28DC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     28DE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 28E0 0286  22         ci    tmp2,>000a
     28E2 000A 
0039 28E4 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 28E6 C21B  26         mov   *r11,tmp4
0045 28E8 0988  56         srl   tmp4,8                ; Right justify
0046 28EA 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     28EC FFF6 
0047 28EE 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 28F0 C21B  26         mov   *r11,tmp4
0054 28F2 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     28F4 00FF 
0055               
0056 28F6 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 28F8 06C6  14         swpb  tmp2
0058 28FA DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 28FC 0944  56         srl   tmp0,4                ; Next nibble
0060 28FE 0605  14         dec   tmp1
0061 2900 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2902 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2904 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2906 C160  34         mov   @waux3,tmp1           ; Get pointer
     2908 8340 
0067 290A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 290C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 290E C120  34         mov   @waux2,tmp0
     2910 833E 
0070 2912 06C4  14         swpb  tmp0
0071 2914 DD44  32         movb  tmp0,*tmp1+
0072 2916 06C4  14         swpb  tmp0
0073 2918 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 291A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     291C 8340 
0078 291E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2920 2020 
0079 2922 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2924 C120  34         mov   @waux1,tmp0
     2926 833C 
0084 2928 06C4  14         swpb  tmp0
0085 292A DD44  32         movb  tmp0,*tmp1+
0086 292C 06C4  14         swpb  tmp0
0087 292E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2930 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2932 202A 
0092 2934 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2936 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2938 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     293A 7FFF 
0098 293C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     293E 8340 
0099 2940 0460  28         b     @xutst0               ; Display string
     2942 2400 
0100 2944 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2946 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2948 832A 
0122 294A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     294C 8000 
0123 294E 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0182               
0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 2950 0207  20 mknum   li    tmp3,5                ; Digit counter
     2952 0005 
0020 2954 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2956 C155  26         mov   *tmp1,tmp1            ; /
0022 2958 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 295A 0228  22         ai    tmp4,4                ; Get end of buffer
     295C 0004 
0024 295E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2960 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2962 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2964 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2966 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2968 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 296A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 296C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 296E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2970 0607  14         dec   tmp3                  ; Decrease counter
0036 2972 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2974 0207  20         li    tmp3,4                ; Check first 4 digits
     2976 0004 
0041 2978 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 297A C11B  26         mov   *r11,tmp0
0043 297C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 297E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 2980 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 2982 05CB  14 mknum3  inct  r11
0047 2984 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2986 202A 
0048 2988 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 298A 045B  20         b     *r11                  ; Exit
0050 298C DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 298E 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2990 13F8  14         jeq   mknum3                ; Yes, exit
0053 2992 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2994 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2996 7FFF 
0058 2998 C10B  18         mov   r11,tmp0
0059 299A 0224  22         ai    tmp0,-4
     299C FFFC 
0060 299E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29A0 0206  20         li    tmp2,>0500            ; String length = 5
     29A2 0500 
0062 29A4 0460  28         b     @xutstr               ; Display string
     29A6 2402 
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
0092 29A8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29AA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29AC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29AE 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 29B0 0207  20         li    tmp3,5                ; Set counter
     29B2 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 29B4 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 29B6 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 29B8 0584  14         inc   tmp0                  ; Next character
0104 29BA 0607  14         dec   tmp3                  ; Last digit reached ?
0105 29BC 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 29BE 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 29C0 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 29C2 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 29C4 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 29C6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 29C8 0607  14         dec   tmp3                  ; Last character ?
0120 29CA 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 29CC 045B  20         b     *r11                  ; Return
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
0138 29CE C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     29D0 832A 
0139 29D2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29D4 8000 
0140 29D6 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0190               
0194               
0198               
0202               
0206               
0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cpu.scrpad.backup - Backup scratchpad memory to >2000
0010               ***************************************************************
0011               *  bl   @cpu.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  r0-r2, but values restored before exit
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to destination range
0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0018               *
0019               *  Expects current workspace to be in scratchpad memory.
0020               ********|*****|*********************|**************************
0021               cpu.scrpad.backup:
0022 29D8 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     29DA A000 
0023 29DC C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     29DE A002 
0024 29E0 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     29E2 A004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 29E4 0200  20         li    r0,>8306              ; Scratpad source address
     29E6 8306 
0029 29E8 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     29EA A006 
0030 29EC 0202  20         li    r2,62                 ; Loop counter
     29EE 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 29F0 CC70  46         mov   *r0+,*r1+
0036 29F2 CC70  46         mov   *r0+,*r1+
0037 29F4 0642  14         dect  r2
0038 29F6 16FC  14         jne   cpu.scrpad.backup.copy
0039 29F8 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     29FA 83FE 
     29FC A0FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 29FE C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A00 A000 
0045 2A02 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A04 A002 
0046 2A06 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A08 A004 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A0A 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               ***************************************************************
0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0056               ***************************************************************
0057               *  bl   @cpu.scrpad.restore
0058               *--------------------------------------------------------------
0059               *  Register usage
0060               *  r0-r2, but values restored before exit
0061               *--------------------------------------------------------------
0062               *  Restore scratchpad from memory area
0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0064               *  Current workspace can be outside scratchpad when called.
0065               ********|*****|*********************|**************************
0066               cpu.scrpad.restore:
0067                       ;------------------------------------------------------
0068                       ; Restore scratchpad >8300 - >8304
0069                       ;------------------------------------------------------
0070 2A0C C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A0E A000 
     2A10 8300 
0071 2A12 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A14 A002 
     2A16 8302 
0072 2A18 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A1A A004 
     2A1C 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A1E C800  38         mov   r0,@cpu.scrpad.tgt
     2A20 A000 
0077 2A22 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A24 A002 
0078 2A26 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A28 A004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A2A 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A2C A006 
0083 2A2E 0201  20         li    r1,>8306
     2A30 8306 
0084 2A32 0202  20         li    r2,62
     2A34 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A36 CC70  46         mov   *r0+,*r1+
0090 2A38 CC70  46         mov   *r0+,*r1+
0091 2A3A 0642  14         dect  r2
0092 2A3C 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A3E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A40 A0FE 
     2A42 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A44 C020  34         mov   @cpu.scrpad.tgt,r0
     2A46 A000 
0099 2A48 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A4A A002 
0100 2A4C C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2A4E A004 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2A50 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > cpu_scrpad_paging.asm
0001               * FILE......: cpu_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cpu.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.pgout
0013               *       DATA p0
0014               *
0015               *  P0 = CPU memory destination
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu.scrpad.pgout
0018               *  TMP1 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  Register usage
0021               *  tmp0-tmp2 = Used as temporary registers
0022               *  tmp3      = Copy of CPU memory destination
0023               ********|*****|*********************|**************************
0024               cpu.scrpad.pgout:
0025 2A52 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2A54 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2A56 8300 
0031 2A58 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2A5A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2A5C 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2A5E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2A60 0606  14         dec   tmp2
0038 2A62 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2A64 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2A66 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2A68 2A6E 
0044                                                   ; R14=PC
0045 2A6A 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2A6C 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2A6E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2A70 2A0C 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2A72 045B  20         b     *r11                  ; Return to caller
0062               
0063               
0064               ***************************************************************
0065               * cpu.scrpad.pgin - Page in scratchpad memory
0066               ***************************************************************
0067               *  bl   @cpu.scrpad.pgin
0068               *  DATA p0
0069               *  P0 = CPU memory source
0070               *--------------------------------------------------------------
0071               *  bl   @memx.scrpad.pgin
0072               *  TMP1 = CPU memory source
0073               *--------------------------------------------------------------
0074               *  Register usage
0075               *  tmp0-tmp2 = Used as temporary registers
0076               ********|*****|*********************|**************************
0077               cpu.scrpad.pgin:
0078 2A74 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2A76 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2A78 8300 
0084 2A7A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2A7C 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2A7E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2A80 0606  14         dec   tmp2
0090 2A82 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2A84 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2A86 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2A88 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0211               
0213                       copy  "equ_fio.asm"              ; File I/O equates
**** **** ****     > equ_fio.asm
0001               * FILE......: equ_fio.asm
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations
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
0018               * File types - All relative files are fixed length
0019               ************************************@**************************
0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0026               ***************************************************************
0027               * File types - Sequential files
0028               ************************************@**************************
0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0041               
0042               ***************************************************************
0043               * File error codes - Bits 13-15 in PAB byte 1
0044               ************************************@**************************
0045      0000     io.err.no_error_occured             equ 0
0046                       ; Error code 0 with condition bit reset, indicates that
0047                       ; no error has occured
0048               
0049      0000     io.err.bad_device_name              equ 0
0050                       ; Device indicated not in system
0051                       ; Error code 0 with condition bit set, indicates a
0052                       ; device not present in system
0053               
0054      0001     io.err.device_write_prottected      equ 1
0055                       ; Device is write protected
0056               
0057      0002     io.err.bad_open_attribute           equ 2
0058                       ; One or more of the OPEN attributes are illegal or do
0059                       ; not match the file's actual characteristics.
0060                       ; This could be:
0061                       ;   * File type
0062                       ;   * Record length
0063                       ;   * I/O mode
0064                       ;   * File organization
0065               
0066      0003     io.err.illegal_operation            equ 3
0067                       ; Either an issued I/O command was not supported, or a
0068                       ; conflict with the OPEN mode has occured
0069               
0070      0004     io.err.out_of_table_buffer_space    equ 4
0071                       ; The amount of space left on the device is insufficient
0072                       ; for the requested operation
0073               
0074      0005     io.err.eof                          equ 5
0075                       ; Attempt to read past end of file.
0076                       ; This error may also be given for non-existing records
0077                       ; in a relative record file
0078               
0079      0006     io.err.device_error                 equ 6
0080                       ; Covers all hard device errors, such as parity and
0081                       ; bad medium errors
0082               
0083      0007     io.err.file_error                   equ 7
0084                       ; Covers all file-related error like: program/data
0085                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  P0 = 8 or 10 (a)
0016               *--------------------------------------------------------------
0017               *  Output:
0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0019               *--------------------------------------------------------------
0020               ; Spectra2 scratchpad memory needs to be paged out before.
0021               ; You need to specify following equates in main program
0022               ;
0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0025               ;
0026               ; Scratchpad memory usage
0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
0028               ; >8356            Pointer to PAB
0029               ; >83D0            CRU address of current device
0030               ; >83D2            DSR entry address
0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
0032               ;
0033               ; Credits
0034               ; Originally appeared in Miller Graphics The Smart Programmer.
0035               ; This version based on version of Paolo Bagnaresi.
0036               *--------------------------------------------------------------
0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********|*****|*********************|**************************
0041 2A8A A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2A8C 2A8E             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2A8E C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2A90 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2A92 8322 
0049 2A94 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2A96 2026 
0050 2A98 C020  34         mov   @>8356,r0             ; get ptr to pab
     2A9A 8356 
0051 2A9C C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2A9E 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AA0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AA2 06C0  14         swpb  r0                    ;
0059 2AA4 D800  38         movb  r0,@vdpa              ; send low byte
     2AA6 8C02 
0060 2AA8 06C0  14         swpb  r0                    ;
0061 2AAA D800  38         movb  r0,@vdpa              ; send high byte
     2AAC 8C02 
0062 2AAE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2AB0 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2AB2 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2AB4 0704  14         seto  r4                    ; init counter
0070 2AB6 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2AB8 A420 
0071 2ABA 0580  14 !       inc   r0                    ; point to next char of name
0072 2ABC 0584  14         inc   r4                    ; incr char counter
0073 2ABE 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2AC0 0007 
0074 2AC2 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2AC4 80C4  18         c     r4,r3                 ; end of name?
0077 2AC6 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2AC8 06C0  14         swpb  r0                    ;
0082 2ACA D800  38         movb  r0,@vdpa              ; send low byte
     2ACC 8C02 
0083 2ACE 06C0  14         swpb  r0                    ;
0084 2AD0 D800  38         movb  r0,@vdpa              ; send high byte
     2AD2 8C02 
0085 2AD4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2AD6 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2AD8 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2ADA 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2ADC 2B9E 
0093 2ADE 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2AE0 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2AE2 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2AE4 04E0  34         clr   @>83d0
     2AE6 83D0 
0102 2AE8 C804  38         mov   r4,@>8354             ; save name length for search
     2AEA 8354 
0103 2AEC 0584  14         inc   r4                    ; adjust for dot
0104 2AEE A804  38         a     r4,@>8356             ; point to position after name
     2AF0 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2AF2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2AF4 83E0 
0110 2AF6 04C1  14         clr   r1                    ; version found of dsr
0111 2AF8 020C  20         li    r12,>0f00             ; init cru addr
     2AFA 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2AFC C30C  18         mov   r12,r12               ; anything to turn off?
0117 2AFE 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B00 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B02 022C  22         ai    r12,>0100             ; next rom to turn on
     2B04 0100 
0125 2B06 04E0  34         clr   @>83d0                ; clear in case we are done
     2B08 83D0 
0126 2B0A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B0C 2000 
0127 2B0E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B10 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B12 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B14 1D00  20         sbo   0                     ; turn on rom
0134 2B16 0202  20         li    r2,>4000              ; start at beginning of rom
     2B18 4000 
0135 2B1A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B1C 2B9A 
0136 2B1E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B20 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B22 A40A 
0146 2B24 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B26 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B28 83D2 
0152                                                   ; subprogram
0153               
0154 2B2A 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B2C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B2E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B30 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B32 83D2 
0163                                                   ; subprogram
0164               
0165 2B34 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B36 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B38 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B3A D160  34         movb  @>8355,r5             ; get length as counter
     2B3C 8355 
0175 2B3E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B40 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B42 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B44 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B46 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B48 A420 
0186 2B4A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B4C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2B4E 0605  14         dec   r5                    ; loop until full length checked
0191 2B50 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2B52 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2B54 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2B56 0581  14         inc   r1                    ; next version found
0203 2B58 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2B5A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2B5C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2B5E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2B60 A400 
0212 2B62 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2B64 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2B66 8322 
0214                                                   ; (8 or >a)
0215 2B68 0281  22         ci    r1,8                  ; was it 8?
     2B6A 0008 
0216 2B6C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2B6E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2B70 8350 
0218                                                   ; Get error byte from @>8350
0219 2B72 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2B74 06C0  14         swpb  r0                    ;
0227 2B76 D800  38         movb  r0,@vdpa              ; send low byte
     2B78 8C02 
0228 2B7A 06C0  14         swpb  r0                    ;
0229 2B7C D800  38         movb  r0,@vdpa              ; send high byte
     2B7E 8C02 
0230 2B80 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B82 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2B84 09D1  56         srl   r1,13                 ; just keep error bits
0238 2B86 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2B88 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2B8A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2B8C A400 
0248               dsrlnk.error.devicename_invalid:
0249 2B8E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2B90 06C1  14         swpb  r1                    ; put error in hi byte
0252 2B92 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2B94 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2B96 2026 
0254 2B98 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2B9A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2B9C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2B9E ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
**** **** ****     > runlib.asm
0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
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
0029               *  data P0
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *--------------------------------------------------------------
0033               *  bl   @xfile.open
0034               *
0035               *  R0 = Address of PAB in VDP RAM
0036               *--------------------------------------------------------------
0037               *  Output:
0038               *  tmp0 LSB = VDP PAB byte 1 (status)
0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0040               *  tmp2     = Status register contents upon DSRLNK return
0041               ********|*****|*********************|**************************
0042               file.open:
0043 2BA0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BA2 C04B  18         mov   r11,r1                ; Save return address
0049 2BA4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BA6 A428 
0050 2BA8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BAA 04C5  14         clr   tmp1                  ; io.op.open
0052 2BAC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BAE 22AC 
0053               file.open_init:
0054 2BB0 0220  22         ai    r0,9                  ; Move to file descriptor length
     2BB2 0009 
0055 2BB4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2BB6 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2BB8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2BBA 2A8A 
0061 2BBC 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2BBE 1029  14         jmp   file.record.pab.details
0067                                                   ; Get status and return to caller
0068                                                   ; Status register bits are unaffected
0069               
0070               
0071               
0072               ***************************************************************
0073               * file.close - Close currently open file
0074               ***************************************************************
0075               *  bl   @file.close
0076               *  data P0
0077               *--------------------------------------------------------------
0078               *  P0 = Address of PAB in VDP RAM
0079               *--------------------------------------------------------------
0080               *  bl   @xfile.close
0081               *
0082               *  R0 = Address of PAB in VDP RAM
0083               *--------------------------------------------------------------
0084               *  Output:
0085               *  tmp0 LSB = VDP PAB byte 1 (status)
0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0087               *  tmp2     = Status register contents upon DSRLNK return
0088               ********|*****|*********************|**************************
0089               file.close:
0090 2BC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2BC2 C04B  18         mov   r11,r1                ; Save return address
0096 2BC4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BC6 A428 
0097 2BC8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2BCA 0205  20         li    tmp1,io.op.close      ; io.op.close
     2BCC 0001 
0099 2BCE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BD0 22AC 
0100               file.close_init:
0101 2BD2 0220  22         ai    r0,9                  ; Move to file descriptor length
     2BD4 0009 
0102 2BD6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2BD8 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2BDA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2BDC 2A8A 
0108 2BDE 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2BE0 1018  14         jmp   file.record.pab.details
0114                                                   ; Get status and return to caller
0115                                                   ; Status register bits are unaffected
0116               
0117               
0118               
0119               
0120               
0121               ***************************************************************
0122               * file.record.read - Read record from file
0123               ***************************************************************
0124               *  bl   @file.record.read
0125               *  data P0
0126               *--------------------------------------------------------------
0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0128               *--------------------------------------------------------------
0129               *  bl   @xfile.record.read
0130               *
0131               *  R0 = Address of PAB in VDP RAM
0132               *--------------------------------------------------------------
0133               *  Output:
0134               *  tmp0 LSB = VDP PAB byte 1 (status)
0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0136               *  tmp2     = Status register contents upon DSRLNK return
0137               ********|*****|*********************|**************************
0138               file.record.read:
0139 2BE2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2BE4 C04B  18         mov   r11,r1                ; Save return address
0145 2BE6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BE8 A428 
0146 2BEA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2BEC 0205  20         li    tmp1,io.op.read       ; io.op.read
     2BEE 0002 
0148 2BF0 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BF2 22AC 
0149               file.record.read_init:
0150 2BF4 0220  22         ai    r0,9                  ; Move to file descriptor length
     2BF6 0009 
0151 2BF8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2BFA 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2BFC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2BFE 2A8A 
0157 2C00 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C02 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C04 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C06 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C08 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C0A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C0C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C0E 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C10 1000  14         nop
0195               
0196               
0197               
0198               ***************************************************************
0199               * file.record.pab.details - Return PAB details to caller
0200               ***************************************************************
0201               * Called internally via JMP/B by file operations
0202               *--------------------------------------------------------------
0203               *  Output:
0204               *  tmp0 LSB = VDP PAB byte 1 (status)
0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0206               *  tmp2     = Status register contents upon DSRLNK return
0207               ********|*****|*********************|**************************
0208               
0209               ********|*****|*********************|**************************
0210               file.record.pab.details:
0211 2C12 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C14 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C16 A428 
0219 2C18 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C1A 0005 
0220 2C1C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C1E 22C4 
0221 2C20 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C22 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0226                                                   ; as returned by DSRLNK
0227               *--------------------------------------------------------------
0228               * Exit
0229               *--------------------------------------------------------------
0230               ; If an error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=tmp2) is set to 1.
0232               ;
0233               ; If no error occured during the IO operation, then the
0234               ; equal bit in the saved status register (=tmp2) is set to 0.
0235               ;
0236               ; Upon return from this IO call you should basically test with:
0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0239               ;
0240               ; Then look for further details in the copy of VDP PAB byte 1
0241               ; in register tmp0, bits 13-15
0242               ;
0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0244               ;                                   ; calls, skip for type >A subprograms!)
0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0246               ;       jeq   my_error_handler
0247               *--------------------------------------------------------------
0248               file.record.pab.details.exit:
0249 2C24 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                            TIMERS
0220               *//////////////////////////////////////////////////////////////
0221               
0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 2C26 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C28 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C2A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C2C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C2E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C30 2026 
0029 2C32 1602  14         jne   tmgr1a                ; No, so move on
0030 2C34 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C36 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C38 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C3A 202A 
0035 2C3C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C3E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C40 201A 
0048 2C42 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C44 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C46 2018 
0050 2C48 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C4A 0460  28         b     @kthread              ; Run kernel thread
     2C4C 2CC4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2C4E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2C50 201E 
0056 2C52 13EB  14         jeq   tmgr1
0057 2C54 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2C56 201C 
0058 2C58 16E8  14         jne   tmgr1
0059 2C5A C120  34         mov   @wtiusr,tmp0
     2C5C 832E 
0060 2C5E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2C60 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2C62 2CC2 
0065 2C64 C10A  18         mov   r10,tmp0
0066 2C66 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2C68 00FF 
0067 2C6A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2C6C 2026 
0068 2C6E 1303  14         jeq   tmgr5
0069 2C70 0284  22         ci    tmp0,60               ; 1 second reached ?
     2C72 003C 
0070 2C74 1002  14         jmp   tmgr6
0071 2C76 0284  22 tmgr5   ci    tmp0,50
     2C78 0032 
0072 2C7A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2C7C 1001  14         jmp   tmgr8
0074 2C7E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2C80 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2C82 832C 
0079 2C84 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2C86 FF00 
0080 2C88 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2C8A 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2C8C 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2C8E 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2C90 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2C92 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2C94 830C 
     2C96 830D 
0089 2C98 1608  14         jne   tmgr10                ; No, get next slot
0090 2C9A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2C9C FF00 
0091 2C9E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CA0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CA2 8330 
0096 2CA4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CA6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CA8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CAA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CAC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2CAE 8315 
     2CB0 8314 
0103 2CB2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2CB4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2CB6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2CB8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2CBA 10F7  14         jmp   tmgr10                ; Process next slot
0108 2CBC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2CBE FF00 
0109 2CC0 10B4  14         jmp   tmgr1
0110 2CC2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2CC4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2CC6 201A 
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
0041 2CC8 06A0  32         bl    @realkb               ; Scan full keyboard
     2CCA 276A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2CCC 0460  28         b     @tmgr3                ; Exit
     2CCE 2C4E 
**** **** ****     > runlib.asm
0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2CD0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2CD2 832E 
0018 2CD4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2CD6 201C 
0019 2CD8 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C2A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2CDA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2CDC 832E 
0029 2CDE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2CE0 FEFF 
0030 2CE2 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0225               
0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2CE4 C13B  30 mkslot  mov   *r11+,tmp0
0018 2CE6 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2CE8 C184  18         mov   tmp0,tmp2
0023 2CEA 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2CEC A1A0  34         a     @wtitab,tmp2          ; Add table base
     2CEE 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2CF0 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2CF2 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2CF4 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2CF6 881B  46         c     *r11,@w$ffff          ; End of list ?
     2CF8 202C 
0035 2CFA 1301  14         jeq   mkslo1                ; Yes, exit
0036 2CFC 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2CFE 05CB  14 mkslo1  inct  r11
0041 2D00 045B  20         b     *r11                  ; Exit
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
0052 2D02 C13B  30 clslot  mov   *r11+,tmp0
0053 2D04 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D06 A120  34         a     @wtitab,tmp0          ; Add table base
     2D08 832C 
0055 2D0A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D0C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D0E 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0229               
0230               
0231               
0232               *//////////////////////////////////////////////////////////////
0233               *                    RUNLIB INITIALISATION
0234               *//////////////////////////////////////////////////////////////
0235               
0236               ***************************************************************
0237               *  RUNLIB - Runtime library initalisation
0238               ***************************************************************
0239               *  B  @RUNLIB
0240               *--------------------------------------------------------------
0241               *  REMARKS
0242               *  if R0 in WS1 equals >4a4a we were called from the system
0243               *  crash handler so we return there after initialisation.
0244               
0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0246               *  after clearing scratchpad memory. This has higher priority
0247               *  as crash handler flag R0.
0248               ********|*****|*********************|**************************
0250 2D10 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D12 29D8 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D14 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D16 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D18 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D1A 0000 
0261 2D1C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D1E 8300 
0262 2D20 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D22 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D24 0202  20 runli2  li    r2,>8308
     2D26 8308 
0267 2D28 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D2A 0282  22         ci    r2,>8400
     2D2C 8400 
0269 2D2E 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D30 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D32 FFFF 
0274 2D34 1602  14         jne   runli4                ; No, continue
0275 2D36 0420  54         blwp  @0                    ; Yes, bye bye
     2D38 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D3A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D3C 833C 
0280 2D3E 04C1  14         clr   r1                    ; Reset counter
0281 2D40 0202  20         li    r2,10                 ; We test 10 times
     2D42 000A 
0282 2D44 C0E0  34 runli5  mov   @vdps,r3
     2D46 8802 
0283 2D48 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D4A 202A 
0284 2D4C 1302  14         jeq   runli6
0285 2D4E 0581  14         inc   r1                    ; Increase counter
0286 2D50 10F9  14         jmp   runli5
0287 2D52 0602  14 runli6  dec   r2                    ; Next test
0288 2D54 16F7  14         jne   runli5
0289 2D56 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2D58 1250 
0290 2D5A 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2D5C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2D5E 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2D60 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2D62 2200 
0296 2D64 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2D66 8322 
0297 2D68 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2D6A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2D6C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2D6E 04C1  14 runli9  clr   r1
0304 2D70 04C2  14         clr   r2
0305 2D72 04C3  14         clr   r3
0306 2D74 0209  20         li    stack,>8400           ; Set stack
     2D76 8400 
0307 2D78 020F  20         li    r15,vdpw              ; Set VDP write address
     2D7A 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2D7C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2D7E 4A4A 
0316 2D80 1605  14         jne   runlia
0317 2D82 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2D84 226E 
0318 2D86 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2D88 0000 
     2D8A 3FFF 
0323 2D8C 06A0  32 runlia  bl    @filv
     2D8E 226E 
0324 2D90 0FC0             data  pctadr,spfclr,16      ; Load color table
     2D92 00F4 
     2D94 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2D96 06A0  32         bl    @f18unl               ; Unlock the F18A
     2D98 26B2 
0332 2D9A 06A0  32         bl    @f18chk               ; Check if F18A is there
     2D9C 26CC 
0333 2D9E 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DA0 26C2 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0339               *       <<skipped>>
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 2DA2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DA4 22D8 
0347 2DA6 21F6             data  spvmod                ; Equate selected video mode table
0348 2DA8 0204  20         li    tmp0,spfont           ; Get font option
     2DAA 000C 
0349 2DAC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 2DAE 1304  14         jeq   runlid                ; Yes, skip it
0351 2DB0 06A0  32         bl    @ldfnt
     2DB2 2340 
0352 2DB4 1100             data  fntadr,spfont         ; Load specified font
     2DB6 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 2DB8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2DBA 4A4A 
0357 2DBC 1602  14         jne   runlie                ; No, continue
0358 2DBE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2DC0 2090 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 2DC2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2DC4 0040 
0363 2DC6 0460  28         b     @main                 ; Give control to main program
     2DC8 6050 
**** **** ****     > tivi_b1.asm.21084
0022                                                   ; Relocated spectra2 in low memory expansion
0023                                                   ; was loaded into RAM from bank 0.
0024                                                   ;
0025                                                   ; Only including it here, so that all
0026                                                   ; references get satisfied during assembly.
0027               ***************************************************************
0028               * TiVi entry point after spectra2 initialisation
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code2
0031               main:
0032 6050 04E0  34         clr   @>6002                ; Jump to bank 1
     6052 6002 
0033 6054 0460  28         b     @main.tivi            ; Start editor
     6056 6058 
0034                       ;-----------------------------------------------------------------------
0035                       ; Include files
0036                       ;-----------------------------------------------------------------------
0037                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: TiVi Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            TiVi Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * main
0011               * Initialize editor
0012               ***************************************************************
0013               * b   @main.tivi
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * -
0023               *--------------------------------------------------------------
0024               * Notes
0025               * Main entry point for TiVi editor
0026               ***************************************************************
0027               
0028               
0029               ***************************************************************
0030               * Main
0031               ********|*****|*********************|**************************
0032               main.tivi:
0033 6058 20A0  38         coc   @wbit1,config         ; F18a detected?
     605A 2028 
0034 605C 1302  14         jeq   main.continue
0035 605E 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6060 0000 
0036               
0037               main.continue:
0038 6062 06A0  32         bl    @scroff               ; Turn screen off
     6064 260E 
0039 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26B2 
0040 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 2312 
0041 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0042                       ;------------------------------------------------------
0043                       ; Initialize VDP SIT
0044                       ;------------------------------------------------------
0045 6070 06A0  32         bl    @filv
     6072 226E 
0046 6074 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6076 0020 
     6078 09B0 
0047 607A 06A0  32         bl    @scron                ; Turn screen on
     607C 2616 
0048                       ;------------------------------------------------------
0049                       ; Initialize low + high memory expansion
0050                       ;------------------------------------------------------
0051 607E 06A0  32         bl    @film
     6080 2216 
0052 6082 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6084 0000 
     6086 6000 
0053                       ;------------------------------------------------------
0054                       ; Load SAMS default memory layout
0055                       ;------------------------------------------------------
0056 6088 06A0  32         bl    @mem.setup.sams.layout
     608A 66C6 
0057                                                   ; Initialize SAMS layout
0058                       ;------------------------------------------------------
0059                       ; Setup cursor, screen, etc.
0060                       ;------------------------------------------------------
0061 608C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608E 262E 
0062 6090 06A0  32         bl    @s8x8                 ; Small sprite
     6092 263E 
0063               
0064 6094 06A0  32         bl    @cpym2m
     6096 2460 
0065 6098 71D0                   data romsat,ramsat,4  ; Load sprite SAT
     609A 8380 
     609C 0004 
0066               
0067 609E C820  54         mov   @romsat+2,@tv.curshape
     60A0 71D2 
     60A2 A214 
0068                                                   ; Save cursor shape & color
0069               
0070 60A4 06A0  32         bl    @cpym2v
     60A6 2418 
0071 60A8 1800                   data sprpdt,cursors,3*8
     60AA 71D4 
     60AC 0018 
0072                                                   ; Load sprite cursor patterns
0073               
0074 60AE 06A0  32         bl    @cpym2v
     60B0 2418 
0075 60B2 1008                   data >1008,lines,5*8  ; Load line patterns
     60B4 71EC 
     60B6 0028 
0076               *--------------------------------------------------------------
0077               * Initialize
0078               *--------------------------------------------------------------
0079 60B8 06A0  32         bl    @tivi.init            ; Initialize TiVi editor config
     60BA 66BA 
0080 60BC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60BE 6B5E 
0081 60C0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60C2 6978 
0082 60C4 06A0  32         bl    @idx.init             ; Initialize index
     60C6 68A0 
0083 60C8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60CA 675C 
0084                       ;-------------------------------------------------------
0085                       ; Setup editor tasks & hook
0086                       ;-------------------------------------------------------
0087 60CC 0204  20         li    tmp0,>0200
     60CE 0200 
0088 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60D2 8314 
0089               
0090 60D4 06A0  32         bl    @at
     60D6 264E 
0091 60D8 0100                   data  >0100           ; Cursor YX position = >0000
0092               
0093 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0094 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0095               
0096 60E2 06A0  32         bl    @mkslot
     60E4 2CE4 
0097 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 6FBE 
0098 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 708C 
0099 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 70A6 
0100 60F2 FFFF                   data eol
0101               
0102 60F4 06A0  32         bl    @mkhook
     60F6 2CD0 
0103 60F8 6F8E                   data hook.keyscan     ; Setup user hook
0104               
0105 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2C26 
0106               
0107               
**** **** ****     > tivi_b1.asm.21084
0038                       copy  "edkey.asm"           ; Actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Process keyboard key press
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 60FE C160  34         mov   @waux1,tmp1           ; Get key value
     6100 833C 
0010 6102 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6104 FF00 
0011 6106 0707  14         seto  tmp3                  ; EOL marker
0012               
0013 6108 C1A0  34         mov   @fb.hasfocus,tmp2     ; Framebuffer has focus ?
     610A A290 
0014 610C 1607  14         jne   edkey.key.process.loadmap.editor
0015                                                   ; Yes, so load editor keymap
0016               
0017 610E C1A0  34         mov   @cmdb.hasfocus,tmp2   ; Command buffer has focus ?
     6110 A510 
0018 6112 1607  14         jne   edkey.key.process.loadmap.cmdb
0019                                                   ; Yes, so load CMDB keymap
0020                       ;-------------------------------------------------------
0021                       ; Pane without focus, crash
0022                       ;-------------------------------------------------------
0023 6114 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6116 FFCE 
0024 6118 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     611A 2030 
0025                       ;-------------------------------------------------------
0026                       ; Use editor keyboard map
0027                       ;-------------------------------------------------------
0028               edkey.key.process.loadmap.editor:
0029 611C 0206  20         li    tmp2,keymap_actions.editor
     611E 765C 
0030 6120 1003  14         jmp   edkey.key.check_next
0031                       ;-------------------------------------------------------
0032                       ; Use CMDB keyboard map
0033                       ;-------------------------------------------------------
0034               edkey.key.process.loadmap.cmdb:
0035 6122 0206  20         li    tmp2,keymap_actions.cmdb
     6124 771E 
0036 6126 1600  14         jne   edkey.key.check_next
0037                       ;-------------------------------------------------------
0038                       ; Iterate over keyboard map for matching action key
0039                       ;-------------------------------------------------------
0040               edkey.key.check_next:
0041 6128 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0042 612A 1309  14         jeq   edkey.key.process.addbuffer
0043                                                   ; Yes, means no action key pressed, so
0044                                                   ; add character to buffer
0045                       ;-------------------------------------------------------
0046                       ; Check for action key match
0047                       ;-------------------------------------------------------
0048 612C 8585  30         c     tmp1,*tmp2            ; Action key matched?
0049 612E 1303  14         jeq   edkey.key.process.action
0050                                                   ; Yes, do action
0051 6130 0226  22         ai    tmp2,6                ; Skip current entry
     6132 0006 
0052 6134 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0053                       ;-------------------------------------------------------
0054                       ; Trigger keyboard action
0055                       ;-------------------------------------------------------
0056               edkey.key.process.action:
0057 6136 0226  22         ai    tmp2,4                ; Move to action address
     6138 0004 
0058 613A C196  26         mov   *tmp2,tmp2            ; Get action address
0059 613C 0456  20         b     *tmp2                 ; Process key action
0060                       ;-------------------------------------------------------
0061                       ; Add character to buffer
0062                       ;-------------------------------------------------------
0063               edkey.key.process.addbuffer:
0064 613E 0460  28         b    @edkey.action.char     ; Add character to buffer
     6140 65CA 
**** **** ****     > tivi_b1.asm.21084
0039                       copy  "edkey.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.mov.asm
0001               
0002               
0003               * FILE......: edkey.mov.asm
0004               * Purpose...: Actions for movement keys
0005               
0006               
0007               *---------------------------------------------------------------
0008               * Cursor left
0009               *---------------------------------------------------------------
0010               edkey.action.left:
0011 6142 C120  34         mov   @fb.column,tmp0
     6144 A28C 
0012 6146 1306  14         jeq   !                     ; column=0 ? Skip further processing
0013                       ;-------------------------------------------------------
0014                       ; Update
0015                       ;-------------------------------------------------------
0016 6148 0620  34         dec   @fb.column            ; Column-- in screen buffer
     614A A28C 
0017 614C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     614E 832A 
0018 6150 0620  34         dec   @fb.current
     6152 A282 
0019                       ;-------------------------------------------------------
0020                       ; Exit
0021                       ;-------------------------------------------------------
0022 6154 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6156 6FB2 
0023               
0024               
0025               *---------------------------------------------------------------
0026               * Cursor right
0027               *---------------------------------------------------------------
0028               edkey.action.right:
0029 6158 8820  54         c     @fb.column,@fb.row.length
     615A A28C 
     615C A288 
0030 615E 1406  14         jhe   !                     ; column > length line ? Skip processing
0031                       ;-------------------------------------------------------
0032                       ; Update
0033                       ;-------------------------------------------------------
0034 6160 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6162 A28C 
0035 6164 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6166 832A 
0036 6168 05A0  34         inc   @fb.current
     616A A282 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040 616C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     616E 6FB2 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Cursor up
0045               *---------------------------------------------------------------
0046               edkey.action.up:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current line if dirty
0049                       ;-------------------------------------------------------
0050 6170 8820  54         c     @fb.row.dirty,@w$ffff
     6172 A28A 
     6174 202C 
0051 6176 1604  14         jne   edkey.action.up.cursor
0052 6178 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     617A 69A8 
0053 617C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     617E A28A 
0054                       ;-------------------------------------------------------
0055                       ; Move cursor
0056                       ;-------------------------------------------------------
0057               edkey.action.up.cursor:
0058 6180 C120  34         mov   @fb.row,tmp0
     6182 A286 
0059 6184 1509  14         jgt   edkey.action.up.cursor_up
0060                                                   ; Move cursor up if fb.row > 0
0061 6186 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6188 A284 
0062 618A 130A  14         jeq   edkey.action.up.set_cursorx
0063                                                   ; At top, only position cursor X
0064                       ;-------------------------------------------------------
0065                       ; Scroll 1 line
0066                       ;-------------------------------------------------------
0067 618C 0604  14         dec   tmp0                  ; fb.topline--
0068 618E C804  38         mov   tmp0,@parm1
     6190 8350 
0069 6192 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6194 67E0 
0070 6196 1004  14         jmp   edkey.action.up.set_cursorx
0071                       ;-------------------------------------------------------
0072                       ; Move cursor up
0073                       ;-------------------------------------------------------
0074               edkey.action.up.cursor_up:
0075 6198 0620  34         dec   @fb.row               ; Row-- in screen buffer
     619A A286 
0076 619C 06A0  32         bl    @up                   ; Row-- VDP cursor
     619E 265C 
0077                       ;-------------------------------------------------------
0078                       ; Check line length and position cursor
0079                       ;-------------------------------------------------------
0080               edkey.action.up.set_cursorx:
0081 61A0 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61A2 6B40 
0082 61A4 8820  54         c     @fb.column,@fb.row.length
     61A6 A28C 
     61A8 A288 
0083 61AA 1207  14         jle   edkey.action.up.exit
0084                       ;-------------------------------------------------------
0085                       ; Adjust cursor column position
0086                       ;-------------------------------------------------------
0087 61AC C820  54         mov   @fb.row.length,@fb.column
     61AE A288 
     61B0 A28C 
0088 61B2 C120  34         mov   @fb.column,tmp0
     61B4 A28C 
0089 61B6 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61B8 2666 
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.up.exit:
0094 61BA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61BC 67C4 
0095 61BE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C0 6FB2 
0096               
0097               
0098               
0099               *---------------------------------------------------------------
0100               * Cursor down
0101               *---------------------------------------------------------------
0102               edkey.action.down:
0103 61C2 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     61C4 A286 
     61C6 A304 
0104 61C8 1330  14         jeq   !                     ; Yes, skip further processing
0105                       ;-------------------------------------------------------
0106                       ; Crunch current row if dirty
0107                       ;-------------------------------------------------------
0108 61CA 8820  54         c     @fb.row.dirty,@w$ffff
     61CC A28A 
     61CE 202C 
0109 61D0 1604  14         jne   edkey.action.down.move
0110 61D2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61D4 69A8 
0111 61D6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61D8 A28A 
0112                       ;-------------------------------------------------------
0113                       ; Move cursor
0114                       ;-------------------------------------------------------
0115               edkey.action.down.move:
0116                       ;-------------------------------------------------------
0117                       ; EOF reached?
0118                       ;-------------------------------------------------------
0119 61DA C120  34         mov   @fb.topline,tmp0
     61DC A284 
0120 61DE A120  34         a     @fb.row,tmp0
     61E0 A286 
0121 61E2 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     61E4 A304 
0122 61E6 1312  14         jeq   edkey.action.down.set_cursorx
0123                                                   ; Yes, only position cursor X
0124                       ;-------------------------------------------------------
0125                       ; Check if scrolling required
0126                       ;-------------------------------------------------------
0127 61E8 C120  34         mov   @fb.scrrows,tmp0
     61EA A298 
0128 61EC 0604  14         dec   tmp0
0129 61EE 8120  34         c     @fb.row,tmp0
     61F0 A286 
0130 61F2 1108  14         jlt   edkey.action.down.cursor
0131                       ;-------------------------------------------------------
0132                       ; Scroll 1 line
0133                       ;-------------------------------------------------------
0134 61F4 C820  54         mov   @fb.topline,@parm1
     61F6 A284 
     61F8 8350 
0135 61FA 05A0  34         inc   @parm1
     61FC 8350 
0136 61FE 06A0  32         bl    @fb.refresh
     6200 67E0 
0137 6202 1004  14         jmp   edkey.action.down.set_cursorx
0138                       ;-------------------------------------------------------
0139                       ; Move cursor down a row, there are still rows left
0140                       ;-------------------------------------------------------
0141               edkey.action.down.cursor:
0142 6204 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6206 A286 
0143 6208 06A0  32         bl    @down                 ; Row++ VDP cursor
     620A 2654 
0144                       ;-------------------------------------------------------
0145                       ; Check line length and position cursor
0146                       ;-------------------------------------------------------
0147               edkey.action.down.set_cursorx:
0148 620C 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     620E 6B40 
0149               
0150 6210 8820  54         c     @fb.column,@fb.row.length
     6212 A28C 
     6214 A288 
0151 6216 1207  14         jle   edkey.action.down.exit
0152                                                   ; Exit
0153                       ;-------------------------------------------------------
0154                       ; Adjust cursor column position
0155                       ;-------------------------------------------------------
0156 6218 C820  54         mov   @fb.row.length,@fb.column
     621A A288 
     621C A28C 
0157 621E C120  34         mov   @fb.column,tmp0
     6220 A28C 
0158 6222 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6224 2666 
0159                       ;-------------------------------------------------------
0160                       ; Exit
0161                       ;-------------------------------------------------------
0162               edkey.action.down.exit:
0163 6226 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6228 67C4 
0164 622A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     622C 6FB2 
0165               
0166               
0167               
0168               *---------------------------------------------------------------
0169               * Cursor beginning of line
0170               *---------------------------------------------------------------
0171               edkey.action.home:
0172 622E C120  34         mov   @wyx,tmp0
     6230 832A 
0173 6232 0244  22         andi  tmp0,>ff00
     6234 FF00 
0174 6236 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6238 832A 
0175 623A 04E0  34         clr   @fb.column
     623C A28C 
0176 623E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6240 67C4 
0177 6242 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6244 6FB2 
0178               
0179               *---------------------------------------------------------------
0180               * Cursor end of line
0181               *---------------------------------------------------------------
0182               edkey.action.end:
0183 6246 C120  34         mov   @fb.row.length,tmp0
     6248 A288 
0184 624A C804  38         mov   tmp0,@fb.column
     624C A28C 
0185 624E 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6250 2666 
0186 6252 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6254 67C4 
0187 6256 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6258 6FB2 
0188               
0189               
0190               
0191               *---------------------------------------------------------------
0192               * Cursor beginning of word or previous word
0193               *---------------------------------------------------------------
0194               edkey.action.pword:
0195 625A C120  34         mov   @fb.column,tmp0
     625C A28C 
0196 625E 1324  14         jeq   !                     ; column=0 ? Skip further processing
0197                       ;-------------------------------------------------------
0198                       ; Prepare 2 char buffer
0199                       ;-------------------------------------------------------
0200 6260 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6262 A282 
0201 6264 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0202 6266 1003  14         jmp   edkey.action.pword_scan_char
0203                       ;-------------------------------------------------------
0204                       ; Scan backwards to first character following space
0205                       ;-------------------------------------------------------
0206               edkey.action.pword_scan
0207 6268 0605  14         dec   tmp1
0208 626A 0604  14         dec   tmp0                  ; Column-- in screen buffer
0209 626C 1315  14         jeq   edkey.action.pword_done
0210                                                   ; Column=0 ? Skip further processing
0211                       ;-------------------------------------------------------
0212                       ; Check character
0213                       ;-------------------------------------------------------
0214               edkey.action.pword_scan_char
0215 626E D195  26         movb  *tmp1,tmp2            ; Get character
0216 6270 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0217 6272 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0218 6274 0986  56         srl   tmp2,8                ; Right justify
0219 6276 0286  22         ci    tmp2,32               ; Space character found?
     6278 0020 
0220 627A 16F6  14         jne   edkey.action.pword_scan
0221                                                   ; No space found, try again
0222                       ;-------------------------------------------------------
0223                       ; Space found, now look closer
0224                       ;-------------------------------------------------------
0225 627C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     627E 2020 
0226 6280 13F3  14         jeq   edkey.action.pword_scan
0227                                                   ; Yes, so continue scanning
0228 6282 0287  22         ci    tmp3,>20ff            ; First character is space
     6284 20FF 
0229 6286 13F0  14         jeq   edkey.action.pword_scan
0230                       ;-------------------------------------------------------
0231                       ; Check distance travelled
0232                       ;-------------------------------------------------------
0233 6288 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     628A A28C 
0234 628C 61C4  18         s     tmp0,tmp3
0235 628E 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6290 0002 
0236 6292 11EA  14         jlt   edkey.action.pword_scan
0237                                                   ; Didn't move enough so keep on scanning
0238                       ;--------------------------------------------------------
0239                       ; Set cursor following space
0240                       ;--------------------------------------------------------
0241 6294 0585  14         inc   tmp1
0242 6296 0584  14         inc   tmp0                  ; Column++ in screen buffer
0243                       ;-------------------------------------------------------
0244                       ; Save position and position hardware cursor
0245                       ;-------------------------------------------------------
0246               edkey.action.pword_done:
0247 6298 C805  38         mov   tmp1,@fb.current
     629A A282 
0248 629C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     629E A28C 
0249 62A0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62A2 2666 
0250                       ;-------------------------------------------------------
0251                       ; Exit
0252                       ;-------------------------------------------------------
0253               edkey.action.pword.exit:
0254 62A4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62A6 67C4 
0255 62A8 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62AA 6FB2 
0256               
0257               
0258               
0259               *---------------------------------------------------------------
0260               * Cursor next word
0261               *---------------------------------------------------------------
0262               edkey.action.nword:
0263 62AC 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0264 62AE C120  34         mov   @fb.column,tmp0
     62B0 A28C 
0265 62B2 8804  38         c     tmp0,@fb.row.length
     62B4 A288 
0266 62B6 1428  14         jhe   !                     ; column=last char ? Skip further processing
0267                       ;-------------------------------------------------------
0268                       ; Prepare 2 char buffer
0269                       ;-------------------------------------------------------
0270 62B8 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62BA A282 
0271 62BC 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0272 62BE 1006  14         jmp   edkey.action.nword_scan_char
0273                       ;-------------------------------------------------------
0274                       ; Multiple spaces mode
0275                       ;-------------------------------------------------------
0276               edkey.action.nword_ms:
0277 62C0 0708  14         seto  tmp4                  ; Set multiple spaces mode
0278                       ;-------------------------------------------------------
0279                       ; Scan forward to first character following space
0280                       ;-------------------------------------------------------
0281               edkey.action.nword_scan
0282 62C2 0585  14         inc   tmp1
0283 62C4 0584  14         inc   tmp0                  ; Column++ in screen buffer
0284 62C6 8804  38         c     tmp0,@fb.row.length
     62C8 A288 
0285 62CA 1316  14         jeq   edkey.action.nword_done
0286                                                   ; Column=last char ? Skip further processing
0287                       ;-------------------------------------------------------
0288                       ; Check character
0289                       ;-------------------------------------------------------
0290               edkey.action.nword_scan_char
0291 62CC D195  26         movb  *tmp1,tmp2            ; Get character
0292 62CE 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0293 62D0 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0294 62D2 0986  56         srl   tmp2,8                ; Right justify
0295               
0296 62D4 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     62D6 FFFF 
0297 62D8 1604  14         jne   edkey.action.nword_scan_char_other
0298                       ;-------------------------------------------------------
0299                       ; Special handling if multiple spaces found
0300                       ;-------------------------------------------------------
0301               edkey.action.nword_scan_char_ms:
0302 62DA 0286  22         ci    tmp2,32
     62DC 0020 
0303 62DE 160C  14         jne   edkey.action.nword_done
0304                                                   ; Exit if non-space found
0305 62E0 10F0  14         jmp   edkey.action.nword_scan
0306                       ;-------------------------------------------------------
0307                       ; Normal handling
0308                       ;-------------------------------------------------------
0309               edkey.action.nword_scan_char_other:
0310 62E2 0286  22         ci    tmp2,32               ; Space character found?
     62E4 0020 
0311 62E6 16ED  14         jne   edkey.action.nword_scan
0312                                                   ; No space found, try again
0313                       ;-------------------------------------------------------
0314                       ; Space found, now look closer
0315                       ;-------------------------------------------------------
0316 62E8 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62EA 2020 
0317 62EC 13E9  14         jeq   edkey.action.nword_ms
0318                                                   ; Yes, so continue scanning
0319 62EE 0287  22         ci    tmp3,>20ff            ; First characer is space?
     62F0 20FF 
0320 62F2 13E7  14         jeq   edkey.action.nword_scan
0321                       ;--------------------------------------------------------
0322                       ; Set cursor following space
0323                       ;--------------------------------------------------------
0324 62F4 0585  14         inc   tmp1
0325 62F6 0584  14         inc   tmp0                  ; Column++ in screen buffer
0326                       ;-------------------------------------------------------
0327                       ; Save position and position hardware cursor
0328                       ;-------------------------------------------------------
0329               edkey.action.nword_done:
0330 62F8 C805  38         mov   tmp1,@fb.current
     62FA A282 
0331 62FC C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62FE A28C 
0332 6300 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6302 2666 
0333                       ;-------------------------------------------------------
0334                       ; Exit
0335                       ;-------------------------------------------------------
0336               edkey.action.nword.exit:
0337 6304 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6306 67C4 
0338 6308 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     630A 6FB2 
0339               
0340               
0341               
0342               
0343               *---------------------------------------------------------------
0344               * Previous page
0345               *---------------------------------------------------------------
0346               edkey.action.ppage:
0347                       ;-------------------------------------------------------
0348                       ; Sanity check
0349                       ;-------------------------------------------------------
0350 630C C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     630E A284 
0351 6310 1316  14         jeq   edkey.action.ppage.exit
0352                       ;-------------------------------------------------------
0353                       ; Special treatment top page
0354                       ;-------------------------------------------------------
0355 6312 8804  38         c     tmp0,@fb.scrrows   ; topline > rows on screen?
     6314 A298 
0356 6316 1503  14         jgt   edkey.action.ppage.topline
0357 6318 04E0  34         clr   @fb.topline           ; topline = 0
     631A A284 
0358 631C 1003  14         jmp   edkey.action.ppage.crunch
0359                       ;-------------------------------------------------------
0360                       ; Adjust topline
0361                       ;-------------------------------------------------------
0362               edkey.action.ppage.topline:
0363 631E 6820  54         s     @fb.scrrows,@fb.topline
     6320 A298 
     6322 A284 
0364                       ;-------------------------------------------------------
0365                       ; Crunch current row if dirty
0366                       ;-------------------------------------------------------
0367               edkey.action.ppage.crunch:
0368 6324 8820  54         c     @fb.row.dirty,@w$ffff
     6326 A28A 
     6328 202C 
0369 632A 1604  14         jne   edkey.action.ppage.refresh
0370 632C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     632E 69A8 
0371 6330 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6332 A28A 
0372                       ;-------------------------------------------------------
0373                       ; Refresh page
0374                       ;-------------------------------------------------------
0375               edkey.action.ppage.refresh:
0376 6334 C820  54         mov   @fb.topline,@parm1
     6336 A284 
     6338 8350 
0377 633A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     633C 67E0 
0378                       ;-------------------------------------------------------
0379                       ; Exit
0380                       ;-------------------------------------------------------
0381               edkey.action.ppage.exit:
0382 633E 04E0  34         clr   @fb.row
     6340 A286 
0383 6342 04E0  34         clr   @fb.column
     6344 A28C 
0384 6346 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     6348 0100 
0385 634A C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     634C 832A 
0386 634E 0460  28         b     @edkey.action.up      ; Do rest of logic
     6350 6170 
0387               
0388               
0389               
0390               *---------------------------------------------------------------
0391               * Next page
0392               *---------------------------------------------------------------
0393               edkey.action.npage:
0394                       ;-------------------------------------------------------
0395                       ; Sanity check
0396                       ;-------------------------------------------------------
0397 6352 C120  34         mov   @fb.topline,tmp0
     6354 A284 
0398 6356 A120  34         a     @fb.scrrows,tmp0
     6358 A298 
0399 635A 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     635C A304 
0400 635E 150D  14         jgt   edkey.action.npage.exit
0401                       ;-------------------------------------------------------
0402                       ; Adjust topline
0403                       ;-------------------------------------------------------
0404               edkey.action.npage.topline:
0405 6360 A820  54         a     @fb.scrrows,@fb.topline
     6362 A298 
     6364 A284 
0406                       ;-------------------------------------------------------
0407                       ; Crunch current row if dirty
0408                       ;-------------------------------------------------------
0409               edkey.action.npage.crunch:
0410 6366 8820  54         c     @fb.row.dirty,@w$ffff
     6368 A28A 
     636A 202C 
0411 636C 1604  14         jne   edkey.action.npage.refresh
0412 636E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6370 69A8 
0413 6372 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6374 A28A 
0414                       ;-------------------------------------------------------
0415                       ; Refresh page
0416                       ;-------------------------------------------------------
0417               edkey.action.npage.refresh:
0418 6376 0460  28         b     @edkey.action.ppage.refresh
     6378 6334 
0419                                                   ; Same logic as previous page
0420                       ;-------------------------------------------------------
0421                       ; Exit
0422                       ;-------------------------------------------------------
0423               edkey.action.npage.exit:
0424 637A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     637C 6FB2 
0425               
0426               
0427               
0428               
0429               *---------------------------------------------------------------
0430               * Goto top of file
0431               *---------------------------------------------------------------
0432               edkey.action.top:
0433                       ;-------------------------------------------------------
0434                       ; Crunch current row if dirty
0435                       ;-------------------------------------------------------
0436 637E 8820  54         c     @fb.row.dirty,@w$ffff
     6380 A28A 
     6382 202C 
0437 6384 1604  14         jne   edkey.action.top.refresh
0438 6386 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6388 69A8 
0439 638A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     638C A28A 
0440                       ;-------------------------------------------------------
0441                       ; Refresh page
0442                       ;-------------------------------------------------------
0443               edkey.action.top.refresh:
0444 638E 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     6390 A284 
0445 6392 04E0  34         clr   @parm1
     6394 8350 
0446 6396 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6398 67E0 
0447                       ;-------------------------------------------------------
0448                       ; Exit
0449                       ;-------------------------------------------------------
0450               edkey.action.top.exit:
0451 639A 04E0  34         clr   @fb.row               ; Frame buffer line 0
     639C A286 
0452 639E 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63A0 A28C 
0453 63A2 0204  20         li    tmp0,>0100
     63A4 0100 
0454 63A6 C804  38         mov   tmp0,@wyx             ; Set VDP cursor on line 1, column 0
     63A8 832A 
0455 63AA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63AC 6FB2 
0456               
0457               
0458               
0459               *---------------------------------------------------------------
0460               * Goto bottom of file
0461               *---------------------------------------------------------------
0462               edkey.action.bot:
0463                       ;-------------------------------------------------------
0464                       ; Crunch current row if dirty
0465                       ;-------------------------------------------------------
0466 63AE 8820  54         c     @fb.row.dirty,@w$ffff
     63B0 A28A 
     63B2 202C 
0467 63B4 1604  14         jne   edkey.action.bot.refresh
0468 63B6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63B8 69A8 
0469 63BA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63BC A28A 
0470                       ;-------------------------------------------------------
0471                       ; Refresh page
0472                       ;-------------------------------------------------------
0473               edkey.action.bot.refresh:
0474 63BE 8820  54         c     @edb.lines,@fb.scrrows
     63C0 A304 
     63C2 A298 
0475                                                   ; Skip if whole editor buffer on screen
0476 63C4 1212  14         jle   !
0477 63C6 C120  34         mov   @edb.lines,tmp0
     63C8 A304 
0478 63CA 6120  34         s     @fb.scrrows,tmp0
     63CC A298 
0479 63CE C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     63D0 A284 
0480 63D2 C804  38         mov   tmp0,@parm1
     63D4 8350 
0481 63D6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63D8 67E0 
0482                       ;-------------------------------------------------------
0483                       ; Exit
0484                       ;-------------------------------------------------------
0485               edkey.action.bot.exit:
0486 63DA 04E0  34         clr   @fb.row               ; Editor line 0
     63DC A286 
0487 63DE 04E0  34         clr   @fb.column            ; Editor column 0
     63E0 A28C 
0488 63E2 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     63E4 0100 
0489 63E6 C804  38         mov   tmp0,@wyx             ; Set cursor
     63E8 832A 
0490 63EA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     63EC 6FB2 
**** **** ****     > tivi_b1.asm.21084
0040                       copy  "edkey.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.mod.asm
0001               * FILE......: edkey.mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 63EE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63F0 A306 
0010 63F2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63F4 67C4 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 63F6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     63F8 A282 
0015 63FA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     63FC A288 
0016 63FE 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 6400 8820  54         c     @fb.column,@fb.row.length
     6402 A28C 
     6404 A288 
0022 6406 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 6408 C120  34         mov   @fb.current,tmp0      ; Get pointer
     640A A282 
0028 640C C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 640E 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 6410 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 6412 0606  14         dec   tmp2
0036 6414 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 6416 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6418 A28A 
0041 641A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     641C A296 
0042 641E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6420 A288 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 6422 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6424 6FB2 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 6426 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6428 A306 
0055 642A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     642C 67C4 
0056 642E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6430 A288 
0057 6432 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 6434 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6436 A282 
0063 6438 C1A0  34         mov   @fb.colsline,tmp2
     643A A28E 
0064 643C 61A0  34         s     @fb.column,tmp2
     643E A28C 
0065 6440 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 6442 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 6444 0606  14         dec   tmp2
0072 6446 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 6448 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     644A A28A 
0077 644C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     644E A296 
0078               
0079 6450 C820  54         mov   @fb.column,@fb.row.length
     6452 A28C 
     6454 A288 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 6456 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6458 6FB2 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 645A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     645C A306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 645E C120  34         mov   @edb.lines,tmp0
     6460 A304 
0097 6462 1604  14         jne   !
0098 6464 04E0  34         clr   @fb.column            ; Column 0
     6466 A28C 
0099 6468 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     646A 6426 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 646C 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     646E 67C4 
0104 6470 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6472 A28A 
0105 6474 C820  54         mov   @fb.topline,@parm1
     6476 A284 
     6478 8350 
0106 647A A820  54         a     @fb.row,@parm1        ; Line number to remove
     647C A286 
     647E 8350 
0107 6480 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6482 A304 
     6484 8352 
0108 6486 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     6488 68E2 
0109 648A 0620  34         dec   @edb.lines            ; One line less in editor buffer
     648C A304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 648E C820  54         mov   @fb.topline,@parm1
     6490 A284 
     6492 8350 
0114 6494 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6496 67E0 
0115 6498 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     649A A296 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 649C C120  34         mov   @fb.topline,tmp0
     649E A284 
0120 64A0 A120  34         a     @fb.row,tmp0
     64A2 A286 
0121 64A4 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64A6 A304 
0122 64A8 1202  14         jle   edkey.action.del_line.exit
0123 64AA 0460  28         b     @edkey.action.up      ; One line up
     64AC 6170 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64AE 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64B0 622E 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 64B2 0204  20         li    tmp0,>2000            ; White space
     64B4 2000 
0139 64B6 C804  38         mov   tmp0,@parm1
     64B8 8350 
0140               edkey.action.ins_char:
0141 64BA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64BC A306 
0142 64BE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64C0 67C4 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64C2 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64C4 A282 
0147 64C6 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64C8 A288 
0148 64CA 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 64CC 8820  54         c     @fb.column,@fb.row.length
     64CE A28C 
     64D0 A288 
0154 64D2 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 64D4 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 64D6 61E0  34         s     @fb.column,tmp3
     64D8 A28C 
0162 64DA A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 64DC C144  18         mov   tmp0,tmp1
0164 64DE 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 64E0 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64E2 A28C 
0166 64E4 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 64E6 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 64E8 0604  14         dec   tmp0
0173 64EA 0605  14         dec   tmp1
0174 64EC 0606  14         dec   tmp2
0175 64EE 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 64F0 D560  46         movb  @parm1,*tmp1
     64F2 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 64F4 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64F6 A28A 
0184 64F8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FA A296 
0185 64FC 05A0  34         inc   @fb.row.length        ; @fb.row.length
     64FE A288 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 6500 0460  28         b     @edkey.action.char.overwrite
     6502 65DC 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 6504 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6506 6FB2 
0196               
0197               
0198               
0199               
0200               
0201               
0202               *---------------------------------------------------------------
0203               * Insert new line
0204               *---------------------------------------------------------------
0205               edkey.action.ins_line:
0206 6508 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     650A A306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 650C 8820  54         c     @fb.row.dirty,@w$ffff
     650E A28A 
     6510 202C 
0211 6512 1604  14         jne   edkey.action.ins_line.insert
0212 6514 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6516 69A8 
0213 6518 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     651A A28A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 651C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     651E 67C4 
0219 6520 C820  54         mov   @fb.topline,@parm1
     6522 A284 
     6524 8350 
0220 6526 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6528 A286 
     652A 8350 
0221               
0222 652C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     652E A304 
     6530 8352 
0223 6532 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6534 6916 
0224 6536 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     6538 A304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 653A C820  54         mov   @fb.topline,@parm1
     653C A284 
     653E 8350 
0229 6540 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6542 67E0 
0230 6544 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6546 A296 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 6548 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     654A 6FB2 
0236               
0237               
0238               
0239               
0240               
0241               
0242               *---------------------------------------------------------------
0243               * Enter
0244               *---------------------------------------------------------------
0245               edkey.action.enter:
0246                       ;-------------------------------------------------------
0247                       ; Crunch current line if dirty
0248                       ;-------------------------------------------------------
0249 654C 8820  54         c     @fb.row.dirty,@w$ffff
     654E A28A 
     6550 202C 
0250 6552 1606  14         jne   edkey.action.enter.upd_counter
0251 6554 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6556 A306 
0252 6558 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     655A 69A8 
0253 655C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     655E A28A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 6560 C120  34         mov   @fb.topline,tmp0
     6562 A284 
0259 6564 A120  34         a     @fb.row,tmp0
     6566 A286 
0260 6568 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     656A A304 
0261 656C 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 656E 05A0  34         inc   @edb.lines            ; Total lines++
     6570 A304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 6572 C120  34         mov   @fb.scrrows,tmp0
     6574 A298 
0271 6576 0604  14         dec   tmp0
0272 6578 8120  34         c     @fb.row,tmp0
     657A A286 
0273 657C 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 657E C120  34         mov   @fb.scrrows,tmp0
     6580 A298 
0278 6582 C820  54         mov   @fb.topline,@parm1
     6584 A284 
     6586 8350 
0279 6588 05A0  34         inc   @parm1
     658A 8350 
0280 658C 06A0  32         bl    @fb.refresh
     658E 67E0 
0281 6590 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 6592 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6594 A286 
0287 6596 06A0  32         bl    @down                 ; Row++ VDP cursor
     6598 2654 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 659A 06A0  32         bl    @fb.get.firstnonblank
     659C 6858 
0293 659E C120  34         mov   @outparm1,tmp0
     65A0 8360 
0294 65A2 C804  38         mov   tmp0,@fb.column
     65A4 A28C 
0295 65A6 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65A8 2666 
0296 65AA 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65AC 6B40 
0297 65AE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65B0 67C4 
0298 65B2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65B4 A296 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65B8 6FB2 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 65BA 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65BC A30A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 65BE 0204  20         li    tmp0,2000
     65C0 07D0 
0317               edkey.action.ins_onoff.loop:
0318 65C2 0604  14         dec   tmp0
0319 65C4 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 65C6 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65C8 70A6 
0325               
0326               
0327               
0328               
0329               *---------------------------------------------------------------
0330               * Process character
0331               *---------------------------------------------------------------
0332               edkey.action.char:
0333 65CA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65CC A306 
0334 65CE D805  38         movb  tmp1,@parm1           ; Store character for insert
     65D0 8350 
0335 65D2 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     65D4 A30A 
0336 65D6 1302  14         jeq   edkey.action.char.overwrite
0337                       ;-------------------------------------------------------
0338                       ; Insert mode
0339                       ;-------------------------------------------------------
0340               edkey.action.char.insert:
0341 65D8 0460  28         b     @edkey.action.ins_char
     65DA 64BA 
0342                       ;-------------------------------------------------------
0343                       ; Overwrite mode
0344                       ;-------------------------------------------------------
0345               edkey.action.char.overwrite:
0346 65DC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65DE 67C4 
0347 65E0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     65E2 A282 
0348               
0349 65E4 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     65E6 8350 
0350 65E8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65EA A28A 
0351 65EC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65EE A296 
0352               
0353 65F0 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     65F2 A28C 
0354 65F4 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     65F6 832A 
0355                       ;-------------------------------------------------------
0356                       ; Update line length in frame buffer
0357                       ;-------------------------------------------------------
0358 65F8 8820  54         c     @fb.column,@fb.row.length
     65FA A28C 
     65FC A288 
0359 65FE 1103  14         jlt   edkey.action.char.exit
0360                                                   ; column < length line ? Skip processing
0361               
0362 6600 C820  54         mov   @fb.column,@fb.row.length
     6602 A28C 
     6604 A288 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 6606 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6608 6FB2 
**** **** ****     > tivi_b1.asm.21084
0041                       copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
**** **** ****     > edkey.misc.asm
0001               * FILE......: edkey.misc.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 660A 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     660C 2716 
0010 660E 0420  54         blwp  @0                    ; Exit
     6610 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6612 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6614 6FB2 
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Show/Hide command buffer pane
0022               ********|*****|*********************|**************************
0023               edkey.action.cmdb.toggle:
0024 6616 C120  34         mov   @cmdb.visible,tmp0
     6618 A502 
0025 661A 1603  14         jne   edkey.action.cmdb.hide
0026                       ;-------------------------------------------------------
0027                       ; Show pane
0028                       ;-------------------------------------------------------
0029               edkey.action.cmdb.show:
0030 661C 06A0  32         bl    @cmdb.show            ; Show command buffer pane
     661E 6B94 
0031 6620 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 6622 06A0  32         bl    @cmdb.hide            ; Hide command buffer pane
     6624 6BC6 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 6626 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6628 6FB2 
0042               
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Framebuffer down 1 row
0047               *---------------------------------------------------------------
0048               edkey.action.fbdown:
0049 662A 05A0  34         inc   @fb.scrrows
     662C A298 
0050 662E 0720  34         seto  @fb.dirty
     6630 A296 
0051               
0052 6632 045B  20         b     *r11
0053               
0054               
0055               *---------------------------------------------------------------
0056               * Cycle colors
0057               ********|*****|*********************|**************************
0058               edkey.action.color.cycle:
0059 6634 0649  14         dect  stack
0060 6636 C64B  30         mov   r11,*stack            ; Push return address
0061               
0062 6638 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     663A A212 
0063 663C 0284  22         ci    tmp0,3                ; 4th entry reached?
     663E 0003 
0064 6640 1102  14         jlt   !
0065 6642 04C4  14         clr   tmp0
0066 6644 1001  14         jmp   edkey.action.color.switch
0067 6646 0584  14 !       inc   tmp0
0068               *---------------------------------------------------------------
0069               * Do actual color switch
0070               ********|*****|*********************|**************************
0071               edkey.action.color.switch:
0072 6648 C804  38         mov   tmp0,@tv.colorscheme  ; Save color scheme index
     664A A212 
0073 664C 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
0074 664E 0224  22         ai    tmp0,tv.data.colorscheme
     6650 7214 
0075                                                   ; Add base for color scheme data table
0076 6652 D154  26         movb  *tmp0,tmp1            ; Get foreground / background color
0077                       ;-------------------------------------------------------
0078                       ; Dump cursor FG color to sprite table (SAT)
0079                       ;-------------------------------------------------------
0080 6654 C185  18         mov   tmp1,tmp2             ; Get work copy
0081 6656 0946  56         srl   tmp2,4                ; Move nibble to right
0082 6658 0246  22         andi  tmp2,>0f00
     665A 0F00 
0083 665C D806  38         movb  tmp2,@ramsat+3        ; Update FG color in sprite table (SAT)
     665E 8383 
0084 6660 D806  38         movb  tmp2,@tv.curshape+1   ; Save cursor color
     6662 A215 
0085                       ;-------------------------------------------------------
0086                       ; Dump color combination to VDP color table
0087                       ;-------------------------------------------------------
0088 6664 0985  56         srl   tmp1,8                ; MSB to LSB
0089 6666 0265  22         ori   tmp1,>0700
     6668 0700 
0090 666A C105  18         mov   tmp1,tmp0
0091 666C 06A0  32         bl    @putvrx
     666E 2314 
0092 6670 C2F9  30         mov   *stack+,r11           ; Pop R11
0093 6672 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6674 6FB2 
**** **** ****     > tivi_b1.asm.21084
0042                       copy  "edkey.file.asm"      ; Actions for file related keys
**** **** ****     > edkey.file.asm
0001               * FILE......: edkey.fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               edkey.action.buffer0:
0006 6676 0204  20         li   tmp0,fdname0
     6678 72D8 
0007 667A 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 667C 0204  20         li   tmp0,fdname1
     667E 72E8 
0010 6680 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6682 0204  20         li   tmp0,fdname2
     6684 72F8 
0013 6686 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 6688 0204  20         li   tmp0,fdname3
     668A 7306 
0016 668C 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 668E 0204  20         li   tmp0,fdname4
     6690 7314 
0019 6692 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6694 0204  20         li   tmp0,fdname5
     6696 7322 
0022 6698 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 669A 0204  20         li   tmp0,fdname6
     669C 7330 
0025 669E 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 66A0 0204  20         li   tmp0,fdname7
     66A2 733E 
0028 66A4 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 66A6 0204  20         li   tmp0,fdname8
     66A8 734C 
0031 66AA 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 66AC 0204  20         li   tmp0,fdname9
     66AE 735A 
0034 66B0 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66B2 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66B4 6E3A 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66B6 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66B8 637E 
**** **** ****     > tivi_b1.asm.21084
0043                       copy  "tivi.asm"            ; Main editor configuration
**** **** ****     > tivi.asm
0001               * FILE......: tivi.asm
0002               * Purpose...: TiVi Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize main editor
0012               ***************************************************************
0013               * bl @tivi.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ***************************************************************
0026               tivi.init:
0027 66BA 0649  14         dect  stack
0028 66BC C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 66BE 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     66C0 A212 
0033               
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               tivi.init.exit:
0038 66C2 0460  28         b     @poprt                ; Return to caller
     66C4 2212 
**** **** ****     > tivi_b1.asm.21084
0044                       copy  "mem.asm"             ; Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: TiVi Editor - Memory management (SAMS)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Memory Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.setup.sams.layout
0010               * Setup SAMS memory pages for TiVi
0011               ***************************************************************
0012               * bl  @mem.setup.sams.layout
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ***************************************************************
0020               mem.setup.sams.layout:
0021 66C6 0649  14         dect  stack
0022 66C8 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 66CA 06A0  32         bl    @sams.layout
     66CC 2562 
0027 66CE 66D4                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 66D0 C2F9  30         mov   *stack+,r11           ; Pop r11
0033 66D2 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 66D4 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >00
     66D6 0002 
0039 66D8 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >01
     66DA 0003 
0040 66DC A000             data  >a000,>000a           ; >a000-afff, SAMS page >02
     66DE 000A 
0041 66E0 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >03
     66E2 000B 
0042 66E4 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >04
     66E6 000C 
0043 66E8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >05
     66EA 000D 
0044 66EC E000             data  >e000,>0010           ; >e000-efff, SAMS page >10
     66EE 0010 
0045 66F0 F000             data  >f000,>0011           ; >f000-ffff, SAMS page >11
     66F2 0011 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * mem.edb.sams.pagein
0052               * Activate editor buffer SAMS page for line
0053               ***************************************************************
0054               * bl  @mem.edb.sams.pagein
0055               *     data p0
0056               *--------------------------------------------------------------
0057               * p0 = Line number in editor buffer
0058               *--------------------------------------------------------------
0059               * bl  @xmem.edb.sams.pagein
0060               *
0061               * tmp0 = Line number in editor buffer
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * outparm1 = Pointer to line in editor buffer
0065               * outparm2 = SAMS page
0066               *--------------------------------------------------------------
0067               * Register usage
0068               * tmp0, tmp1, tmp2, tmp3
0069               ***************************************************************
0070               mem.edb.sams.pagein:
0071 66F4 C13B  30         mov   *r11+,tmp0            ; Get p0
0072               xmem.edb.sams.pagein:
0073 66F6 0649  14         dect  stack
0074 66F8 C64B  30         mov   r11,*stack            ; Push return address
0075 66FA 0649  14         dect  stack
0076 66FC C644  30         mov   tmp0,*stack           ; Push tmp0
0077 66FE 0649  14         dect  stack
0078 6700 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 6702 0649  14         dect  stack
0080 6704 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 6706 0649  14         dect  stack
0082 6708 C647  30         mov   tmp3,*stack           ; Push tmp3
0083                       ;------------------------------------------------------
0084                       ; Sanity check
0085                       ;------------------------------------------------------
0086 670A 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     670C A304 
0087 670E 1104  14         jlt   mem.edb.sams.pagein.lookup
0088                                                   ; All checks passed, continue
0089                                                   ;--------------------------
0090                                                   ; Sanity check failed
0091                                                   ;--------------------------
0092 6710 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6712 FFCE 
0093 6714 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6716 2030 
0094                       ;------------------------------------------------------
0095                       ; Lookup SAMS page for line in parm1
0096                       ;------------------------------------------------------
0097               mem.edb.sams.pagein.lookup:
0098 6718 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     671A 695A 
0099                                                   ; \ i  parm1    = Line number
0100                                                   ; | o  outparm1 = Pointer to line
0101                                                   ; / o  outparm2 = SAMS page
0102               
0103 671C C120  34         mov   @outparm2,tmp0        ; SAMS page
     671E 8362 
0104 6720 C160  34         mov   @outparm1,tmp1        ; Memory address
     6722 8360 
0105 6724 1315  14         jeq   mem.edb.sams.pagein.exit
0106                                                   ; Nothing to page-in if empty line
0107                       ;------------------------------------------------------
0108                       ; 1. Determine if requested SAMS page is already active
0109                       ;------------------------------------------------------
0110 6726 0245  22         andi  tmp1,>f000            ; Reduce address to 4K chunks
     6728 F000 
0111 672A 04C6  14         clr   tmp2                  ; Offset in SAMS shadow registers table
0112 672C 0207  20         li    tmp3,sams.copy.layout.data + 6
     672E 2604 
0113                                                   ; Entry >b000  in SAMS memory range table
0114                       ;------------------------------------------------------
0115                       ; Loop over memory ranges
0116                       ;------------------------------------------------------
0117               mem.edb.sams.pagein.compare.loop:
0118 6730 8177  30         c     *tmp3+,tmp1           ; Does memory range match?
0119 6732 1308  14         jeq   !                     ; Yes, now check SAMS page
0120               
0121 6734 05C6  14         inct  tmp2                  ; Next range
0122 6736 0286  22         ci    tmp2,12               ; All ranges checked?
     6738 000C 
0123 673A 16FA  14         jne   mem.edb.sams.pagein.compare.loop
0124                                                   ; Not yet, check next range
0125                       ;------------------------------------------------------
0126                       ; Invalid memory range. Should never get here
0127                       ;------------------------------------------------------
0128 673C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     673E FFCE 
0129 6740 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6742 2030 
0130                       ;------------------------------------------------------
0131                       ; 2. Determine if requested SAMS page is already active
0132                       ;------------------------------------------------------
0133 6744 0226  22 !       ai    tmp2,tv.sams.2000     ; Add offset for SAMS shadow register
     6746 A200 
0134 6748 8116  26         c     *tmp2,tmp0            ; Requested SAMS page already active?
0135 674A 1302  14         jeq   mem.edb.sams.pagein.exit
0136                                                   ; Yes, so exit
0137                       ;------------------------------------------------------
0138                       ; Activate requested SAMS page
0139                       ;-----------------------------------------------------
0140 674C 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     674E 24FC 
0141                                                   ; \ i  tmp0 = SAMS page
0142                                                   ; / i  tmp1 = Memory address
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               mem.edb.sams.pagein.exit:
0147 6750 C1F9  30         mov   *stack+,tmp3          ; Pop tmp1
0148 6752 C1B9  30         mov   *stack+,tmp2          ; Pop tmp1
0149 6754 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0150 6756 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 6758 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 675A 045B  20         b     *r11                  ; Return to caller
0153               
**** **** ****     > tivi_b1.asm.21084
0045                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: TiVi Editor - Framebuffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * fb.init
0010               * Initialize framebuffer
0011               ***************************************************************
0012               *  bl   @fb.init
0013               *--------------------------------------------------------------
0014               *  INPUT
0015               *  none
0016               *--------------------------------------------------------------
0017               *  OUTPUT
0018               *  none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               ********|*****|*********************|**************************
0023               fb.init
0024 675C 0649  14         dect  stack
0025 675E C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 6760 0204  20         li    tmp0,fb.top
     6762 A650 
0030 6764 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     6766 A280 
0031 6768 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     676A A284 
0032 676C 04E0  34         clr   @fb.row               ; Current row=0
     676E A286 
0033 6770 04E0  34         clr   @fb.column            ; Current column=0
     6772 A28C 
0034               
0035 6774 0204  20         li    tmp0,80
     6776 0050 
0036 6778 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     677A A28E 
0037               
0038 677C 0204  20         li    tmp0,27
     677E 001B 
0039 6780 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
     6782 A298 
0040 6784 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6786 A29A 
0041               
0042 6788 0720  34         seto  @fb.hasfocus          ; Frame buffer has focus!
     678A A290 
0043 678C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     678E A296 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 6790 06A0  32         bl    @film
     6792 2216 
0048 6794 A650             data  fb.top,>00,fb.size    ; Clear it all the way
     6796 0000 
     6798 09B0 
0049                       ;------------------------------------------------------
0050                       ; Show banner (line above frame buffer, not part of it)
0051                       ;------------------------------------------------------
0052 679A 06A0  32         bl    @hchar
     679C 2742 
0053 679E 0000                   byte 0,0,1,80         ; Double line at top
     67A0 0150 
0054 67A2 FFFF                   data EOL
0055               
0056 67A4 06A0  32         bl    @putat
     67A6 2410 
0057 67A8 001C                   byte 0,28
0058 67AA 72BE                   data txt.tivi         ; Banner
0059                       ;------------------------------------------------------
0060                       ; Exit
0061                       ;------------------------------------------------------
0062               fb.init.exit
0063 67AC 0460  28         b     @poprt                ; Return to caller
     67AE 2212 
0064               
0065               
0066               
0067               
0068               ***************************************************************
0069               * fb.row2line
0070               * Calculate line in editor buffer
0071               ***************************************************************
0072               * bl @fb.row2line
0073               *--------------------------------------------------------------
0074               * INPUT
0075               * @fb.topline = Top line in frame buffer
0076               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0077               *--------------------------------------------------------------
0078               * OUTPUT
0079               * @outparm1 = Matching line in editor buffer
0080               *--------------------------------------------------------------
0081               * Register usage
0082               * tmp2,tmp3
0083               *--------------------------------------------------------------
0084               * Formula
0085               * outparm1 = @fb.topline + @parm1
0086               ********|*****|*********************|**************************
0087               fb.row2line:
0088 67B0 0649  14         dect  stack
0089 67B2 C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Calculate line in editor buffer
0092                       ;------------------------------------------------------
0093 67B4 C120  34         mov   @parm1,tmp0
     67B6 8350 
0094 67B8 A120  34         a     @fb.topline,tmp0
     67BA A284 
0095 67BC C804  38         mov   tmp0,@outparm1
     67BE 8360 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               fb.row2line$$:
0100 67C0 0460  28         b    @poprt                 ; Return to caller
     67C2 2212 
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * fb.calc_pointer
0107               * Calculate pointer address in frame buffer
0108               ***************************************************************
0109               * bl @fb.calc_pointer
0110               *--------------------------------------------------------------
0111               * INPUT
0112               * @fb.top       = Address of top row in frame buffer
0113               * @fb.topline   = Top line in frame buffer
0114               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0115               * @fb.column    = Current column in frame buffer
0116               * @fb.colsline  = Columns per line in frame buffer
0117               *--------------------------------------------------------------
0118               * OUTPUT
0119               * @fb.current   = Updated pointer
0120               *--------------------------------------------------------------
0121               * Register usage
0122               * tmp2,tmp3
0123               *--------------------------------------------------------------
0124               * Formula
0125               * pointer = row * colsline + column + deref(@fb.top.ptr)
0126               ********|*****|*********************|**************************
0127               fb.calc_pointer:
0128 67C4 0649  14         dect  stack
0129 67C6 C64B  30         mov   r11,*stack            ; Save return address
0130                       ;------------------------------------------------------
0131                       ; Calculate pointer
0132                       ;------------------------------------------------------
0133 67C8 C1A0  34         mov   @fb.row,tmp2
     67CA A286 
0134 67CC 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     67CE A28E 
0135 67D0 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     67D2 A28C 
0136 67D4 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     67D6 A280 
0137 67D8 C807  38         mov   tmp3,@fb.current
     67DA A282 
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               fb.calc_pointer.$$
0142 67DC 0460  28         b    @poprt                 ; Return to caller
     67DE 2212 
0143               
0144               
0145               
0146               
0147               ***************************************************************
0148               * fb.refresh
0149               * Refresh frame buffer with editor buffer content
0150               ***************************************************************
0151               * bl @fb.refresh
0152               *--------------------------------------------------------------
0153               * INPUT
0154               * @parm1 = Line to start with (becomes @fb.topline)
0155               *--------------------------------------------------------------
0156               * OUTPUT
0157               * none
0158               *--------------------------------------------------------------
0159               * Register usage
0160               * tmp0,tmp1,tmp2
0161               ********|*****|*********************|**************************
0162               fb.refresh:
0163 67E0 0649  14         dect  stack
0164 67E2 C64B  30         mov   r11,*stack            ; Push return address
0165 67E4 0649  14         dect  stack
0166 67E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0167 67E8 0649  14         dect  stack
0168 67EA C645  30         mov   tmp1,*stack           ; Push tmp1
0169 67EC 0649  14         dect  stack
0170 67EE C646  30         mov   tmp2,*stack           ; Push tmp2
0171                       ;------------------------------------------------------
0172                       ; Update SAMS shadow registers in RAM
0173                       ;------------------------------------------------------
0174 67F0 06A0  32         bl    @sams.copy.layout     ; Copy SAMS memory layout
     67F2 25C6 
0175 67F4 A200                   data tv.sams.2000     ; \ i  p0 = Pointer to 8 words RAM buffer
0176                                                   ; /
0177                       ;------------------------------------------------------
0178                       ; Setup starting position in index
0179                       ;------------------------------------------------------
0180 67F6 C820  54         mov   @parm1,@fb.topline
     67F8 8350 
     67FA A284 
0181 67FC 04E0  34         clr   @parm2                ; Target row in frame buffer
     67FE 8352 
0182                       ;------------------------------------------------------
0183                       ; Check if already at EOF
0184                       ;------------------------------------------------------
0185 6800 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6802 8350 
     6804 A304 
0186 6806 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0187                       ;------------------------------------------------------
0188                       ; Unpack line to frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.unpack_line:
0191 6808 06A0  32         bl    @edb.line.unpack      ; Unpack line
     680A 6A50 
0192                                                   ; \ i  parm1 = Line to unpack
0193                                                   ; / i  parm2 = Target row in frame buffer
0194               
0195 680C 05A0  34         inc   @parm1                ; Next line in editor buffer
     680E 8350 
0196 6810 05A0  34         inc   @parm2                ; Next row in frame buffer
     6812 8352 
0197                       ;------------------------------------------------------
0198                       ; Last row in editor buffer reached ?
0199                       ;------------------------------------------------------
0200 6814 8820  54         c     @parm1,@edb.lines
     6816 8350 
     6818 A304 
0201 681A 1113  14         jlt   !                     ; no, do next check
0202                                                   ; yes, erase until end of frame buffer
0203                       ;------------------------------------------------------
0204                       ; Erase until end of frame buffer
0205                       ;------------------------------------------------------
0206               fb.refresh.erase_eob:
0207 681C C120  34         mov   @parm2,tmp0           ; Current row
     681E 8352 
0208 6820 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6822 A298 
0209 6824 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0210 6826 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6828 A28E 
0211               
0212 682A C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0213 682C 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0214               
0215 682E 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6830 A28E 
0216 6832 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6834 A280 
0217               
0218 6836 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0219 6838 0205  20         li    tmp1,32               ; Clear with space
     683A 0020 
0220               
0221 683C 06A0  32         bl    @xfilm                ; \ Fill memory
     683E 221C 
0222                                                   ; | i  tmp0 = Memory start address
0223                                                   ; | i  tmp1 = Byte to fill
0224                                                   ; / i  tmp2 = Number of bytes to fill
0225 6840 1004  14         jmp   fb.refresh.exit
0226                       ;------------------------------------------------------
0227                       ; Bottom row in frame buffer reached ?
0228                       ;------------------------------------------------------
0229 6842 8820  54 !       c     @parm2,@fb.scrrows
     6844 8352 
     6846 A298 
0230 6848 11DF  14         jlt   fb.refresh.unpack_line
0231                                                   ; No, unpack next line
0232                       ;------------------------------------------------------
0233                       ; Exit
0234                       ;------------------------------------------------------
0235               fb.refresh.exit:
0236 684A 0720  34         seto  @fb.dirty             ; Refresh screen
     684C A296 
0237 684E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0238 6850 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0239 6852 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0240 6854 C2F9  30         mov   *stack+,r11           ; Pop r11
0241 6856 045B  20         b     *r11                  ; Return to caller
0242               
0243               
0244               ***************************************************************
0245               * fb.get.firstnonblank
0246               * Get column of first non-blank character in specified line
0247               ***************************************************************
0248               * bl @fb.get.firstnonblank
0249               *--------------------------------------------------------------
0250               * OUTPUT
0251               * @outparm1 = Column containing first non-blank character
0252               * @outparm2 = Character
0253               ********|*****|*********************|**************************
0254               fb.get.firstnonblank:
0255 6858 0649  14         dect  stack
0256 685A C64B  30         mov   r11,*stack            ; Save return address
0257                       ;------------------------------------------------------
0258                       ; Prepare for scanning
0259                       ;------------------------------------------------------
0260 685C 04E0  34         clr   @fb.column
     685E A28C 
0261 6860 06A0  32         bl    @fb.calc_pointer
     6862 67C4 
0262 6864 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6866 6B40 
0263 6868 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     686A A288 
0264 686C 1313  14         jeq   fb.get.firstnonblank.nomatch
0265                                                   ; Exit if empty line
0266 686E C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6870 A282 
0267 6872 04C5  14         clr   tmp1
0268                       ;------------------------------------------------------
0269                       ; Scan line for non-blank character
0270                       ;------------------------------------------------------
0271               fb.get.firstnonblank.loop:
0272 6874 D174  28         movb  *tmp0+,tmp1           ; Get character
0273 6876 130E  14         jeq   fb.get.firstnonblank.nomatch
0274                                                   ; Exit if empty line
0275 6878 0285  22         ci    tmp1,>2000            ; Whitespace?
     687A 2000 
0276 687C 1503  14         jgt   fb.get.firstnonblank.match
0277 687E 0606  14         dec   tmp2                  ; Counter--
0278 6880 16F9  14         jne   fb.get.firstnonblank.loop
0279 6882 1008  14         jmp   fb.get.firstnonblank.nomatch
0280                       ;------------------------------------------------------
0281                       ; Non-blank character found
0282                       ;------------------------------------------------------
0283               fb.get.firstnonblank.match:
0284 6884 6120  34         s     @fb.current,tmp0      ; Calculate column
     6886 A282 
0285 6888 0604  14         dec   tmp0
0286 688A C804  38         mov   tmp0,@outparm1        ; Save column
     688C 8360 
0287 688E D805  38         movb  tmp1,@outparm2        ; Save character
     6890 8362 
0288 6892 1004  14         jmp   fb.get.firstnonblank.exit
0289                       ;------------------------------------------------------
0290                       ; No non-blank character found
0291                       ;------------------------------------------------------
0292               fb.get.firstnonblank.nomatch:
0293 6894 04E0  34         clr   @outparm1             ; X=0
     6896 8360 
0294 6898 04E0  34         clr   @outparm2             ; Null
     689A 8362 
0295                       ;------------------------------------------------------
0296                       ; Exit
0297                       ;------------------------------------------------------
0298               fb.get.firstnonblank.exit:
0299 689C 0460  28         b    @poprt                 ; Return to caller
     689E 2212 
**** **** ****     > tivi_b1.asm.21084
0046                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: TiVi Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * The index contains 2 major parts:
0010               *
0011               * 1) Main index (c000 - cfff)
0012               *
0013               *    Size of index page is 4K and allows indexing of 2048 lines.
0014               *    Each index slot (1 word) contains the pointer to the line
0015               *    in the editor buffer.
0016               *
0017               * 2) Shadow SAMS pages index (d000 - dfff)
0018               *
0019               *    Size of index page is 4K and allows indexing of 2048 lines.
0020               *    Each index slot (1 word) contains the SAMS page where the
0021               *    line in the editor buffer resides
0022               *
0023               *
0024               * The editor buffer itself always resides at (e000 -> ffff) for
0025               * a total of 8kb.
0026               * First line in editor buffer starts at offset 2 (c002), this
0027               * allows the index to contain "null" pointers, aka empty lines
0028               * without reference to editor buffer.
0029               ***************************************************************
0030               
0031               
0032               ***************************************************************
0033               * idx.init
0034               * Initialize index
0035               ***************************************************************
0036               * bl @idx.init
0037               *--------------------------------------------------------------
0038               * INPUT
0039               * none
0040               *--------------------------------------------------------------
0041               * OUTPUT
0042               * none
0043               *--------------------------------------------------------------
0044               * Register usage
0045               * tmp0
0046               ***************************************************************
0047               idx.init:
0048 68A0 0649  14         dect  stack
0049 68A2 C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 68A4 0204  20         li    tmp0,idx.top
     68A6 C000 
0054 68A8 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     68AA A302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 68AC 06A0  32         bl    @film
     68AE 2216 
0059 68B0 C000             data  idx.top,>00,idx.size  ; Clear main index
     68B2 0000 
     68B4 1000 
0060               
0061 68B6 06A0  32         bl    @film
     68B8 2216 
0062 68BA D000             data  idx.shadow.top,>00,idx.shadow.size
     68BC 0000 
     68BE 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 68C0 0460  28         b     @poprt                ; Return to caller
     68C2 2212 
0069               
0070               
0071               
0072               ***************************************************************
0073               * idx.entry.update
0074               * Update index entry - Each entry corresponds to a line
0075               ***************************************************************
0076               * bl @idx.entry.update
0077               *--------------------------------------------------------------
0078               * INPUT
0079               * @parm1    = Line number in editor buffer
0080               * @parm2    = Pointer to line in editor buffer
0081               * @parm3    = SAMS page
0082               *--------------------------------------------------------------
0083               * OUTPUT
0084               * @outparm1 = Pointer to updated index entry
0085               *--------------------------------------------------------------
0086               * Register usage
0087               * tmp0,tmp1,tmp2
0088               *--------------------------------------------------------------
0089               idx.entry.update:
0090 68C4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     68C6 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 68C8 C160  34         mov   @parm2,tmp1
     68CA 8352 
0095 68CC 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 68CE C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     68D0 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 68D2 0A14  56         sla   tmp0,1                ; line number * 2
0107 68D4 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     68D6 C000 
0108 68D8 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     68DA D000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 68DC C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     68DE 8360 
0115 68E0 045B  20         b     *r11                  ; Return
0116               
0117               
0118               ***************************************************************
0119               * idx.entry.delete
0120               * Delete index entry - Close gap created by delete
0121               ***************************************************************
0122               * bl @idx.entry.delete
0123               *--------------------------------------------------------------
0124               * INPUT
0125               * @parm1    = Line number in editor buffer to delete
0126               * @parm2    = Line number of last line to check for reorg
0127               *--------------------------------------------------------------
0128               * OUTPUT
0129               * @outparm1 = Pointer to deleted line (for undo)
0130               *--------------------------------------------------------------
0131               * Register usage
0132               * tmp0,tmp2
0133               *--------------------------------------------------------------
0134               idx.entry.delete:
0135 68E2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     68E4 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 68E6 0A14  56         sla   tmp0,1                ; line number * 2
0140 68E8 C824  54         mov   @idx.top(tmp0),@outparm1
     68EA C000 
     68EC 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 68EE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     68F0 8352 
0146 68F2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     68F4 8350 
0147 68F6 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 68F8 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 68FA C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     68FC C002 
     68FE C000 
0157 6900 C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     6902 D002 
     6904 D000 
0158 6906 05C4  14         inct  tmp0                  ; Next index entry
0159 6908 0606  14         dec   tmp2                  ; tmp2--
0160 690A 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 690C 04E4  34         clr   @idx.top(tmp0)
     690E C000 
0167 6910 04E4  34         clr   @idx.shadow.top(tmp0)
     6912 D000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 6914 045B  20         b     *r11                  ; Return
0173               
0174               
0175               ***************************************************************
0176               * idx.entry.insert
0177               * Insert index entry
0178               ***************************************************************
0179               * bl @idx.entry.insert
0180               *--------------------------------------------------------------
0181               * INPUT
0182               * @parm1    = Line number in editor buffer to insert
0183               * @parm2    = Line number of last line to check for reorg
0184               *--------------------------------------------------------------
0185               * OUTPUT
0186               * NONE
0187               *--------------------------------------------------------------
0188               * Register usage
0189               * tmp0,tmp2
0190               *--------------------------------------------------------------
0191               idx.entry.insert:
0192 6916 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6918 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 691A 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 691C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     691E 8352 
0201 6920 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6922 8350 
0202 6924 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 6926 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6928 C000 
     692A C002 
0207                                                   ; Move pointer
0208 692C 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     692E C000 
0209               
0210 6930 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     6932 D000 
     6934 D002 
0211                                                   ; Move SAMS page
0212 6936 04E4  34         clr   @idx.shadow.top+0(tmp0)
     6938 D000 
0213                                                   ; Clear new index entry
0214 693A 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 693C 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 693E C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6940 C000 
     6942 C002 
0222                                                   ; Move pointer
0223               
0224 6944 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     6946 D000 
     6948 D002 
0225                                                   ; Move SAMS page
0226               
0227 694A 0644  14         dect  tmp0                  ; Previous index entry
0228 694C 0606  14         dec   tmp2                  ; tmp2--
0229 694E 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 6950 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     6952 C004 
0232 6954 04E4  34         clr   @idx.shadow.top+4(tmp0)
     6956 D004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 6958 045B  20         b     *r11                  ; Return
0239               
0240               
0241               
0242               ***************************************************************
0243               * idx.pointer.get
0244               * Get pointer to editor buffer line content
0245               ***************************************************************
0246               * bl @idx.pointer.get
0247               *--------------------------------------------------------------
0248               * INPUT
0249               * @parm1 = Line number in editor buffer
0250               *--------------------------------------------------------------
0251               * OUTPUT
0252               * @outparm1 = Pointer to editor buffer line content
0253               * @outparm2 = SAMS page
0254               *--------------------------------------------------------------
0255               * Register usage
0256               * tmp0,tmp1,tmp2
0257               *--------------------------------------------------------------
0258               idx.pointer.get:
0259 695A 0649  14         dect  stack
0260 695C C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 695E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6960 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 6962 0A14  56         sla   tmp0,1                ; line number * 2
0269 6964 C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     6966 C000 
0270 6968 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     696A D000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 696C C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     696E 8360 
0277 6970 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6972 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 6974 0460  28         b     @poprt                ; Return to caller
     6976 2212 
**** **** ****     > tivi_b1.asm.21084
0047                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: TiVi Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Editor Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * edb.init
0010               * Initialize Editor buffer
0011               ***************************************************************
0012               * bl @edb.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               edb.init:
0026 6978 0649  14         dect  stack
0027 697A C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 697C 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     697E E002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 6980 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     6982 A300 
0035 6984 C804  38         mov   tmp0,@edb.next_free.ptr
     6986 A308 
0036                                                   ; Set pointer to next free line in
0037                                                   ; editor buffer
0038               
0039 6988 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     698A A30A 
0040 698C 04E0  34         clr   @edb.lines            ; Lines=0
     698E A304 
0041 6990 04E0  34         clr   @edb.rle              ; RLE compression off
     6992 A30C 
0042               
0043 6994 0204  20         li    tmp0,txt.newfile      ; "New file"
     6996 727C 
0044 6998 C804  38         mov   tmp0,@edb.filename.ptr
     699A A30E 
0045               
0046 699C 0204  20         li    tmp0,txt.filetype.none
     699E 72B2 
0047 69A0 C804  38         mov   tmp0,@edb.filetype.ptr
     69A2 A310 
0048               
0049               edb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 69A4 0460  28         b     @poprt                ; Return to caller
     69A6 2212 
0054               
0055               
0056               
0057               ***************************************************************
0058               * edb.line.pack
0059               * Pack current line in framebuffer
0060               ***************************************************************
0061               *  bl   @edb.line.pack
0062               *--------------------------------------------------------------
0063               * INPUT
0064               * @fb.top       = Address of top row in frame buffer
0065               * @fb.row       = Current row in frame buffer
0066               * @fb.column    = Current column in frame buffer
0067               * @fb.colsline  = Columns per line in frame buffer
0068               *--------------------------------------------------------------
0069               * OUTPUT
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * tmp0,tmp1,tmp2
0073               *--------------------------------------------------------------
0074               * Memory usage
0075               * rambuf   = Saved @fb.column
0076               * rambuf+2 = Saved beginning of row
0077               * rambuf+4 = Saved length of row
0078               ********|*****|*********************|**************************
0079               edb.line.pack:
0080 69A8 0649  14         dect  stack
0081 69AA C64B  30         mov   r11,*stack            ; Save return address
0082                       ;------------------------------------------------------
0083                       ; Get values
0084                       ;------------------------------------------------------
0085 69AC C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     69AE A28C 
     69B0 8390 
0086 69B2 04E0  34         clr   @fb.column
     69B4 A28C 
0087 69B6 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     69B8 67C4 
0088                       ;------------------------------------------------------
0089                       ; Prepare scan
0090                       ;------------------------------------------------------
0091 69BA 04C4  14         clr   tmp0                  ; Counter
0092 69BC C160  34         mov   @fb.current,tmp1      ; Get position
     69BE A282 
0093 69C0 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     69C2 8392 
0094               
0095                       ;------------------------------------------------------
0096                       ; Scan line for >00 byte termination
0097                       ;------------------------------------------------------
0098               edb.line.pack.scan:
0099 69C4 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0100 69C6 0986  56         srl   tmp2,8                ; Right justify
0101 69C8 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0102 69CA 0584  14         inc   tmp0                  ; Increase string length
0103 69CC 10FB  14         jmp   edb.line.pack.scan    ; Next character
0104               
0105                       ;------------------------------------------------------
0106                       ; Prepare for storing line
0107                       ;------------------------------------------------------
0108               edb.line.pack.prepare:
0109 69CE C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     69D0 A284 
     69D2 8350 
0110 69D4 A820  54         a     @fb.row,@parm1        ; /
     69D6 A286 
     69D8 8350 
0111               
0112 69DA C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     69DC 8394 
0113               
0114                       ;------------------------------------------------------
0115                       ; 1. Update index
0116                       ;------------------------------------------------------
0117               edb.line.pack.update_index:
0118 69DE C120  34         mov   @edb.next_free.ptr,tmp0
     69E0 A308 
0119 69E2 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     69E4 8352 
0120               
0121 69E6 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     69E8 24C4 
0122                                                   ; \ i  tmp0  = Memory address
0123                                                   ; | o  waux1 = SAMS page number
0124                                                   ; / o  waux2 = Address of SAMS register
0125               
0126 69EA C820  54         mov   @waux1,@parm3
     69EC 833C 
     69EE 8354 
0127 69F0 06A0  32         bl    @idx.entry.update     ; Update index
     69F2 68C4 
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132               
0133                       ;------------------------------------------------------
0134                       ; 2. Switch to required SAMS page
0135                       ;------------------------------------------------------
0136 69F4 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     69F6 A312 
     69F8 8354 
0137 69FA 1308  14         jeq   !                     ; Yes, skip setting page
0138               
0139 69FC C120  34         mov   @parm3,tmp0           ; get SAMS page
     69FE 8354 
0140 6A00 C160  34         mov   @edb.next_free.ptr,tmp1
     6A02 A308 
0141                                                   ; Pointer to line in editor buffer
0142 6A04 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6A06 24FC 
0143                                                   ; \ i  tmp0 = SAMS page
0144                                                   ; / i  tmp1 = Memory address
0145               
0146 6A08 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6A0A A438 
0147               
0148                       ;------------------------------------------------------
0149                       ; 3. Set line prefix in editor buffer
0150                       ;------------------------------------------------------
0151 6A0C C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6A0E 8392 
0152 6A10 C160  34         mov   @edb.next_free.ptr,tmp1
     6A12 A308 
0153                                                   ; Address of line in editor buffer
0154               
0155 6A14 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6A16 A308 
0156               
0157 6A18 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6A1A 8394 
0158 6A1C 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0159 6A1E 06C6  14         swpb  tmp2
0160 6A20 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0161 6A22 06C6  14         swpb  tmp2
0162 6A24 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0163               
0164                       ;------------------------------------------------------
0165                       ; 4. Copy line from framebuffer to editor buffer
0166                       ;------------------------------------------------------
0167               edb.line.pack.copyline:
0168 6A26 0286  22         ci    tmp2,2
     6A28 0002 
0169 6A2A 1603  14         jne   edb.line.pack.copyline.checkbyte
0170 6A2C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0171 6A2E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0172 6A30 1007  14         jmp   !
0173               edb.line.pack.copyline.checkbyte:
0174 6A32 0286  22         ci    tmp2,1
     6A34 0001 
0175 6A36 1602  14         jne   edb.line.pack.copyline.block
0176 6A38 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0177 6A3A 1002  14         jmp   !
0178               edb.line.pack.copyline.block:
0179 6A3C 06A0  32         bl    @xpym2m               ; Copy memory block
     6A3E 2466 
0180                                                   ; \ i  tmp0 = source
0181                                                   ; | i  tmp1 = destination
0182                                                   ; / i  tmp2 = bytes to copy
0183               
0184 6A40 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6A42 8394 
     6A44 A308 
0185                                                   ; Update pointer to next free line
0186               
0187                       ;------------------------------------------------------
0188                       ; Exit
0189                       ;------------------------------------------------------
0190               edb.line.pack.exit:
0191 6A46 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6A48 8390 
     6A4A A28C 
0192 6A4C 0460  28         b     @poprt                ; Return to caller
     6A4E 2212 
0193               
0194               
0195               
0196               
0197               ***************************************************************
0198               * edb.line.unpack
0199               * Unpack specified line to framebuffer
0200               ***************************************************************
0201               *  bl   @edb.line.unpack
0202               *--------------------------------------------------------------
0203               * INPUT
0204               * @parm1 = Line to unpack in editor buffer
0205               * @parm2 = Target row in frame buffer
0206               *--------------------------------------------------------------
0207               * OUTPUT
0208               * none
0209               *--------------------------------------------------------------
0210               * Register usage
0211               * tmp0,tmp1,tmp2,tmp3,tmp4
0212               *--------------------------------------------------------------
0213               * Memory usage
0214               * rambuf    = Saved @parm1 of edb.line.unpack
0215               * rambuf+2  = Saved @parm2 of edb.line.unpack
0216               * rambuf+4  = Source memory address in editor buffer
0217               * rambuf+6  = Destination memory address in frame buffer
0218               * rambuf+8  = Length of RLE (decompressed) line
0219               * rambuf+10 = Length of RLE compressed line
0220               ********|*****|*********************|**************************
0221               edb.line.unpack:
0222 6A50 0649  14         dect  stack
0223 6A52 C64B  30         mov   r11,*stack            ; Save return address
0224                       ;------------------------------------------------------
0225                       ; Sanity check
0226                       ;------------------------------------------------------
0227 6A54 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6A56 8350 
     6A58 A304 
0228 6A5A 1104  14         jlt   !
0229 6A5C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6A5E FFCE 
0230 6A60 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A62 2030 
0231                       ;------------------------------------------------------
0232                       ; Save parameters
0233                       ;------------------------------------------------------
0234 6A64 C820  54 !       mov   @parm1,@rambuf
     6A66 8350 
     6A68 8390 
0235 6A6A C820  54         mov   @parm2,@rambuf+2
     6A6C 8352 
     6A6E 8392 
0236                       ;------------------------------------------------------
0237                       ; Calculate offset in frame buffer
0238                       ;------------------------------------------------------
0239 6A70 C120  34         mov   @fb.colsline,tmp0
     6A72 A28E 
0240 6A74 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6A76 8352 
0241 6A78 C1A0  34         mov   @fb.top.ptr,tmp2
     6A7A A280 
0242 6A7C A146  18         a     tmp2,tmp1             ; Add base to offset
0243 6A7E C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6A80 8396 
0244                       ;------------------------------------------------------
0245                       ; Get pointer to line & page-in editor buffer page
0246                       ;------------------------------------------------------
0247 6A82 C120  34         mov   @parm1,tmp0
     6A84 8350 
0248 6A86 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     6A88 66F6 
0249                                                   ; \ i  tmp0     = Line number
0250                                                   ; | o  outparm1 = Pointer to line
0251                                                   ; / o  outparm2 = SAMS page
0252               
0253 6A8A C820  54         mov   @outparm2,@edb.sams.page
     6A8C 8362 
     6A8E A312 
0254                                                   ; Save current SAMS page
0255               
0256 6A90 05E0  34         inct  @outparm1             ; Skip line prefix
     6A92 8360 
0257 6A94 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6A96 8360 
     6A98 8394 
0258                       ;------------------------------------------------------
0259                       ; Get length of line to unpack
0260                       ;------------------------------------------------------
0261 6A9A 06A0  32         bl    @edb.line.getlength   ; Get length of line
     6A9C 6B08 
0262                                                   ; \ i  parm1    = Line number
0263                                                   ; | o  outparm1 = Line length (uncompressed)
0264                                                   ; | o  outparm2 = Line length (compressed)
0265                                                   ; / o  outparm3 = SAMS page
0266               
0267 6A9E C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     6AA0 8362 
     6AA2 839A 
0268 6AA4 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     6AA6 8360 
     6AA8 8398 
0269 6AAA 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line
0270                       ;------------------------------------------------------
0271                       ; Handle possible "line split" between 2 consecutive pages
0272                       ;------------------------------------------------------
0273 6AAC C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
     6AAE 8394 
0274 6AB0 C144  18         mov     tmp0,tmp1           ; Pointer to line
0275 6AB2 A160  34         a       @rambuf+8,tmp1      ; Add length of line
     6AB4 8398 
0276               
0277 6AB6 0244  22         andi    tmp0,>f000          ; Only keep high nibble
     6AB8 F000 
0278 6ABA 0245  22         andi    tmp1,>f000          ; Only keep high nibble
     6ABC F000 
0279 6ABE 8144  18         c       tmp0,tmp1           ; Same segment?
0280 6AC0 1305  14         jeq     edb.line.unpack.clear
0281                                                   ; Yes, so skip
0282               
0283 6AC2 C120  34         mov     @outparm3,tmp0      ; Get SAMS page
     6AC4 8364 
0284 6AC6 0584  14         inc     tmp0                ; Next sams page
0285               
0286 6AC8 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
     6ACA 24FC 
0287                                                   ; | i  tmp0 = SAMS page number
0288                                                   ; / i  tmp1 = Memory Address
0289               
0290                       ;------------------------------------------------------
0291                       ; Erase chars from last column until column 80
0292                       ;------------------------------------------------------
0293               edb.line.unpack.clear:
0294 6ACC C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6ACE 8396 
0295 6AD0 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6AD2 8398 
0296               
0297 6AD4 04C5  14         clr   tmp1                  ; Fill with >00
0298 6AD6 C1A0  34         mov   @fb.colsline,tmp2
     6AD8 A28E 
0299 6ADA 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6ADC 8398 
0300 6ADE 0586  14         inc   tmp2
0301               
0302 6AE0 06A0  32         bl    @xfilm                ; Fill CPU memory
     6AE2 221C 
0303                                                   ; \ i  tmp0 = Target address
0304                                                   ; | i  tmp1 = Byte to fill
0305                                                   ; / i  tmp2 = Repeat count
0306                       ;------------------------------------------------------
0307                       ; Prepare for unpacking data
0308                       ;------------------------------------------------------
0309               edb.line.unpack.prepare:
0310 6AE4 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6AE6 8398 
0311 6AE8 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0312 6AEA C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6AEC 8394 
0313 6AEE C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6AF0 8396 
0314                       ;------------------------------------------------------
0315                       ; Check before copy
0316                       ;------------------------------------------------------
0317               edb.line.unpack.copy.uncompressed:
0318 6AF2 0286  22         ci    tmp2,80               ; Check line length
     6AF4 0050 
0319 6AF6 1204  14         jle   !
0320 6AF8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AFA FFCE 
0321 6AFC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AFE 2030 
0322                       ;------------------------------------------------------
0323                       ; Copy memory block
0324                       ;------------------------------------------------------
0325 6B00 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6B02 2466 
0326                                                   ; \ i  tmp0 = Source address
0327                                                   ; | i  tmp1 = Target address
0328                                                   ; / i  tmp2 = Bytes to copy
0329                       ;------------------------------------------------------
0330                       ; Exit
0331                       ;------------------------------------------------------
0332               edb.line.unpack.exit:
0333 6B04 0460  28         b     @poprt                ; Return to caller
     6B06 2212 
0334               
0335               
0336               
0337               
0338               ***************************************************************
0339               * edb.line.getlength
0340               * Get length of specified line
0341               ***************************************************************
0342               *  bl   @edb.line.getlength
0343               *--------------------------------------------------------------
0344               * INPUT
0345               * @parm1 = Line number
0346               *--------------------------------------------------------------
0347               * OUTPUT
0348               * @outparm1 = Length of line (uncompressed)
0349               * @outparm2 = Length of line (compressed)
0350               * @outparm3 = SAMS page
0351               *--------------------------------------------------------------
0352               * Register usage
0353               * tmp0,tmp1,tmp2
0354               ********|*****|*********************|**************************
0355               edb.line.getlength:
0356 6B08 0649  14         dect  stack
0357 6B0A C64B  30         mov   r11,*stack            ; Save return address
0358                       ;------------------------------------------------------
0359                       ; Initialisation
0360                       ;------------------------------------------------------
0361 6B0C 04E0  34         clr   @outparm1             ; Reset uncompressed length
     6B0E 8360 
0362 6B10 04E0  34         clr   @outparm2             ; Reset compressed length
     6B12 8362 
0363 6B14 04E0  34         clr   @outparm3             ; Reset SAMS bank
     6B16 8364 
0364                       ;------------------------------------------------------
0365                       ; Get length
0366                       ;------------------------------------------------------
0367 6B18 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6B1A 695A 
0368                                                   ; \ i  parm1    = Line number
0369                                                   ; | o  outparm1 = Pointer to line
0370                                                   ; / o  outparm2 = SAMS page
0371               
0372 6B1C C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6B1E 8360 
0373 6B20 130D  14         jeq   edb.line.getlength.exit
0374                                                   ; Exit early if NULL pointer
0375 6B22 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     6B24 8362 
     6B26 8364 
0376                       ;------------------------------------------------------
0377                       ; Process line prefix
0378                       ;------------------------------------------------------
0379 6B28 04C5  14         clr   tmp1
0380 6B2A D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0381 6B2C 06C5  14         swpb  tmp1
0382 6B2E C805  38         mov   tmp1,@outparm2        ; Save length
     6B30 8362 
0383               
0384 6B32 04C5  14         clr   tmp1
0385 6B34 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0386 6B36 06C5  14         swpb  tmp1
0387 6B38 C805  38         mov   tmp1,@outparm1        ; Save length
     6B3A 8360 
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               edb.line.getlength.exit:
0392 6B3C 0460  28         b     @poprt                ; Return to caller
     6B3E 2212 
0393               
0394               
0395               
0396               
0397               ***************************************************************
0398               * edb.line.getlength2
0399               * Get length of current row (as seen from editor buffer side)
0400               ***************************************************************
0401               *  bl   @edb.line.getlength2
0402               *--------------------------------------------------------------
0403               * INPUT
0404               * @fb.row = Row in frame buffer
0405               *--------------------------------------------------------------
0406               * OUTPUT
0407               * @fb.row.length = Length of row
0408               *--------------------------------------------------------------
0409               * Register usage
0410               * tmp0
0411               ********|*****|*********************|**************************
0412               edb.line.getlength2:
0413 6B40 0649  14         dect  stack
0414 6B42 C64B  30         mov   r11,*stack            ; Save return address
0415                       ;------------------------------------------------------
0416                       ; Calculate line in editor buffer
0417                       ;------------------------------------------------------
0418 6B44 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6B46 A284 
0419 6B48 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6B4A A286 
0420                       ;------------------------------------------------------
0421                       ; Get length
0422                       ;------------------------------------------------------
0423 6B4C C804  38         mov   tmp0,@parm1
     6B4E 8350 
0424 6B50 06A0  32         bl    @edb.line.getlength
     6B52 6B08 
0425 6B54 C820  54         mov   @outparm1,@fb.row.length
     6B56 8360 
     6B58 A288 
0426                                                   ; Save row length
0427                       ;------------------------------------------------------
0428                       ; Exit
0429                       ;------------------------------------------------------
0430               edb.line.getlength2.exit:
0431 6B5A 0460  28         b     @poprt                ; Return to caller
     6B5C 2212 
0432               
**** **** ****     > tivi_b1.asm.21084
0048                       copy  "cmdb.asm"            ; Command Buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: TiVi Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Command Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cmdb.init
0011               * Initialize Command Buffer
0012               ***************************************************************
0013               * bl @cmdb.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * none
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               cmdb.init:
0027 6B5E 0649  14         dect  stack
0028 6B60 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6B62 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6B64 B000 
0033 6B66 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6B68 A500 
0034               
0035 6B6A 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6B6C A502 
0036 6B6E 0204  20         li    tmp0,8
     6B70 0008 
0037 6B72 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6B74 A504 
0038 6B76 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6B78 A506 
0039               
0040 6B7A 04E0  34         clr   @cmdb.yxtop           ; Screen Y of 1st row in cmdb pane
     6B7C A508 
0041 6B7E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6B80 A50C 
0042 6B82 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6B84 A50E 
0043                       ;------------------------------------------------------
0044                       ; Clear command buffer
0045                       ;------------------------------------------------------
0046 6B86 06A0  32         bl    @film
     6B88 2216 
0047 6B8A B000             data  cmdb.top,>00,cmdb.size
     6B8C 0000 
     6B8E 1000 
0048                                                   ; Clear it all the way
0049               cmdb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 6B90 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B92 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               ***************************************************************
0060               * cmdb.show
0061               * Show command buffer pane
0062               ***************************************************************
0063               * bl @cmdb.show
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
0074               * Notes
0075               ********|*****|*********************|**************************
0076               cmdb.show:
0077 6B94 0649  14         dect  stack
0078 6B96 C64B  30         mov   r11,*stack            ; Save return address
0079 6B98 0649  14         dect  stack
0080 6B9A C644  30         mov   tmp0,*stack           ; Push tmp0
0081                       ;------------------------------------------------------
0082                       ; Show command buffer pane
0083                       ;------------------------------------------------------
0084 6B9C C120  34         mov   @fb.scrrows.max,tmp0
     6B9E A29A 
0085 6BA0 6120  34         s     @cmdb.scrrows,tmp0
     6BA2 A504 
0086 6BA4 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6BA6 A298 
0087               
0088 6BA8 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0089 6BAA 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0090 6BAC C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer top row
     6BAE A508 
0091               
0092 6BB0 0720  34         seto  @cmdb.visible         ; Show pane
     6BB2 A502 
0093 6BB4 0720  34         seto  @cmdb.hasfocus        ; CMDB pane has focus
     6BB6 A510 
0094 6BB8 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BBA A296 
0095 6BBC 04E0  34         clr   @fb.hasfocus          ; Framebuffer has no focus
     6BBE A290 
0096               cmdb.show.exit:
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100 6BC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0101 6BC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0102 6BC4 045B  20         b     *r11                  ; Return to caller
0103               
0104               
0105               
0106               ***************************************************************
0107               * cmdb.hide
0108               * Hide command buffer pane
0109               ***************************************************************
0110               * bl @cmdb.show
0111               *--------------------------------------------------------------
0112               * INPUT
0113               * none
0114               *--------------------------------------------------------------
0115               * OUTPUT
0116               * none
0117               *--------------------------------------------------------------
0118               * Register usage
0119               * none
0120               *--------------------------------------------------------------
0121               * Hiding the command buffer automatically passes pane focus
0122               * to frame buffer.
0123               ********|*****|*********************|**************************
0124               cmdb.hide:
0125 6BC6 0649  14         dect  stack
0126 6BC8 C64B  30         mov   r11,*stack            ; Save return address
0127                       ;------------------------------------------------------
0128                       ; Hide command buffer pane
0129                       ;------------------------------------------------------
0130 6BCA C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6BCC A29A 
     6BCE A298 
0131                                                   ; Resize framebuffer
0132               
0133 6BD0 04E0  34         clr   @cmdb.visible         ; Hide pane
     6BD2 A502 
0134 6BD4 04E0  34         clr   @cmdb.hasfocus        ; Remove focus from CMDB
     6BD6 A510 
0135 6BD8 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BDA A296 
0136 6BDC 0720  34         seto  @fb.hasfocus          ; Framebuffer has focus!
     6BDE A290 
0137               cmdb.hide.exit:
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141 6BE0 C2F9  30         mov   *stack+,r11           ; Pop r11
0142 6BE2 045B  20         b     *r11                  ; Return to caller
0143               
0144               
0145               
0146               ***************************************************************
0147               * cmdb.refresh
0148               * Refresh command buffer content
0149               ***************************************************************
0150               * bl @cmdb.refresh
0151               *--------------------------------------------------------------
0152               * INPUT
0153               * none
0154               *--------------------------------------------------------------
0155               * OUTPUT
0156               * none
0157               *--------------------------------------------------------------
0158               * Register usage
0159               * none
0160               *--------------------------------------------------------------
0161               * Notes
0162               ********|*****|*********************|**************************
0163               cmdb.refresh:
0164 6BE4 0649  14         dect  stack
0165 6BE6 C64B  30         mov   r11,*stack            ; Save return address
0166 6BE8 0649  14         dect  stack
0167 6BEA C644  30         mov   tmp0,*stack           ; Push tmp0
0168 6BEC 0649  14         dect  stack
0169 6BEE C645  30         mov   tmp1,*stack           ; Push tmp1
0170 6BF0 0649  14         dect  stack
0171 6BF2 C646  30         mov   tmp2,*stack           ; Push tmp2
0172                       ;------------------------------------------------------
0173                       ; Show Command buffer content
0174                       ;------------------------------------------------------
0175 6BF4 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6BF6 832A 
     6BF8 A50A 
0176               
0177 6BFA C820  54         mov   @cmdb.yxtop,@wyx
     6BFC A508 
     6BFE 832A 
0178 6C00 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6C02 23DA 
0179               
0180 6C04 C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6C06 A500 
0181 6C08 0206  20         li    tmp2,7*80
     6C0A 0230 
0182               
0183 6C0C 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6C0E 241E 
0184                                                   ; | i  tmp0 = VDP target address
0185                                                   ; | i  tmp1 = RAM source address
0186                                                   ; / i  tmp2 = Number of bytes to copy
0187               
0188 6C10 C820  54         mov   @cmdb.yxsave,@wyx     ; Restore YX position
     6C12 A50A 
     6C14 832A 
0189               cmdb.refresh.exit:
0190                       ;------------------------------------------------------
0191                       ; Exit
0192                       ;------------------------------------------------------
0193 6C16 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0194 6C18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0195 6C1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0196 6C1C C2F9  30         mov   *stack+,r11           ; Pop r11
0197 6C1E 045B  20         b     *r11                  ; Return to caller
0198               
**** **** ****     > tivi_b1.asm.21084
0049                       copy  "fh.read.sams.asm"    ; File handler read file
**** **** ****     > fh.read.sams.asm
0001               * FILE......: fh.read.sams.asm
0002               * Purpose...: File reader module (SAMS implementation)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.read.sams
0011               * Read file into editor buffer with SAMS support
0012               ***************************************************************
0013               *  bl   @fh.file.read.sams
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "loading indicator 1"
0018               * parm3 = Pointer to callback function "loading indicator 2"
0019               * parm4 = Pointer to callback function "loading indicator 3"
0020               * parm5 = Pointer to callback function "File I/O error handler"
0021               * parm6 = Not used yet (starting line in file)
0022               * parm7 = Not used yet (starting line in editor buffer)
0023               * parm8 = Not used yet (number of lines to read)
0024               *--------------------------------------------------------------
0025               * OUTPUT
0026               *--------------------------------------------------------------
0027               * Register usage
0028               * tmp0, tmp1, tmp2, tmp3, tmp4
0029               ********|*****|*********************|**************************
0030               fh.file.read.sams:
0031 6C20 0649  14         dect  stack
0032 6C22 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6C24 04E0  34         clr   @fh.rleonload         ; No RLE compression!
     6C26 A444 
0037 6C28 04E0  34         clr   @fh.records           ; Reset records counter
     6C2A A42E 
0038 6C2C 04E0  34         clr   @fh.counter           ; Clear internal counter
     6C2E A434 
0039 6C30 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6C32 A432 
0040 6C34 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 6C36 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6C38 A42A 
0042 6C3A 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6C3C A42C 
0043               
0044 6C3E 0204  20         li    tmp0,3
     6C40 0003 
0045 6C42 C804  38         mov   tmp0,@fh.sams.page    ; Set current SAMS page
     6C44 A438 
0046 6C46 C804  38         mov   tmp0,@fh.sams.hpage   ; Set highest SAMS page in use
     6C48 A43A 
0047                       ;------------------------------------------------------
0048                       ; Save parameters / callback functions
0049                       ;------------------------------------------------------
0050 6C4A C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6C4C 8350 
     6C4E A436 
0051 6C50 C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
     6C52 8352 
     6C54 A43C 
0052 6C56 C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
     6C58 8354 
     6C5A A43E 
0053 6C5C C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
     6C5E 8356 
     6C60 A440 
0054 6C62 C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
     6C64 8358 
     6C66 A442 
0055                       ;------------------------------------------------------
0056                       ; Sanity check
0057                       ;------------------------------------------------------
0058 6C68 C120  34         mov   @fh.callback1,tmp0
     6C6A A43C 
0059 6C6C 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C6E 6000 
0060 6C70 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0061               
0062 6C72 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C74 7FFF 
0063 6C76 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0064               
0065 6C78 C120  34         mov   @fh.callback2,tmp0
     6C7A A43E 
0066 6C7C 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C7E 6000 
0067 6C80 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0068               
0069 6C82 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C84 7FFF 
0070 6C86 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0071               
0072 6C88 C120  34         mov   @fh.callback3,tmp0
     6C8A A440 
0073 6C8C 0284  22         ci    tmp0,>6000            ; Insane address ?
     6C8E 6000 
0074 6C90 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0075               
0076 6C92 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6C94 7FFF 
0077 6C96 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0078               
0079 6C98 1004  14         jmp   fh.file.read.sams.load1
0080                                                   ; All checks passed, continue.
0081                                                   ;--------------------------
0082                                                   ; Check failed, crash CPU!
0083                                                   ;--------------------------
0084               fh.file.read.crash:
0085 6C9A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C9C FFCE 
0086 6C9E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CA0 2030 
0087                       ;------------------------------------------------------
0088                       ; Show "loading indicator 1"
0089                       ;------------------------------------------------------
0090               fh.file.read.sams.load1:
0091 6CA2 C120  34         mov   @fh.callback1,tmp0
     6CA4 A43C 
0092 6CA6 0694  24         bl    *tmp0                 ; Run callback function
0093                       ;------------------------------------------------------
0094                       ; Copy PAB header to VDP
0095                       ;------------------------------------------------------
0096               fh.file.read.sams.pabheader:
0097 6CA8 06A0  32         bl    @cpym2v
     6CAA 2418 
0098 6CAC 0A60                   data fh.vpab,fh.file.pab.header,9
     6CAE 6E30 
     6CB0 0009 
0099                                                   ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101                       ; Append file descriptor to PAB header in VDP
0102                       ;------------------------------------------------------
0103 6CB2 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6CB4 0A69 
0104 6CB6 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6CB8 A436 
0105 6CBA D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0106 6CBC 0986  56         srl   tmp2,8                ; Right justify
0107 6CBE 0586  14         inc   tmp2                  ; Include length byte as well
0108 6CC0 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6CC2 241E 
0109                       ;------------------------------------------------------
0110                       ; Load GPL scratchpad layout
0111                       ;------------------------------------------------------
0112 6CC4 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6CC6 2A52 
0113 6CC8 A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0114                       ;------------------------------------------------------
0115                       ; Open file
0116                       ;------------------------------------------------------
0117 6CCA 06A0  32         bl    @file.open
     6CCC 2BA0 
0118 6CCE 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0119 6CD0 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6CD2 2026 
0120 6CD4 1602  14         jne   fh.file.read.sams.record
0121 6CD6 0460  28         b     @fh.file.read.sams.error
     6CD8 6DFA 
0122                                                   ; Yes, IO error occured
0123                       ;------------------------------------------------------
0124                       ; Step 1: Read file record
0125                       ;------------------------------------------------------
0126               fh.file.read.sams.record:
0127 6CDA 05A0  34         inc   @fh.records           ; Update counter
     6CDC A42E 
0128 6CDE 04E0  34         clr   @fh.reclen            ; Reset record length
     6CE0 A430 
0129               
0130 6CE2 06A0  32         bl    @file.record.read     ; Read file record
     6CE4 2BE2 
0131 6CE6 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0132                                                   ; |           (without +9 offset!)
0133                                                   ; | o  tmp0 = Status byte
0134                                                   ; | o  tmp1 = Bytes read
0135                                                   ; | o  tmp2 = Status register contents
0136                                                   ; /           upon DSRLNK return
0137               
0138 6CE8 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6CEA A42A 
0139 6CEC C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6CEE A430 
0140 6CF0 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6CF2 A42C 
0141                       ;------------------------------------------------------
0142                       ; 1a: Calculate kilobytes processed
0143                       ;------------------------------------------------------
0144 6CF4 A805  38         a     tmp1,@fh.counter
     6CF6 A434 
0145 6CF8 A160  34         a     @fh.counter,tmp1
     6CFA A434 
0146 6CFC 0285  22         ci    tmp1,1024
     6CFE 0400 
0147 6D00 1106  14         jlt   !
0148 6D02 05A0  34         inc   @fh.kilobytes
     6D04 A432 
0149 6D06 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6D08 FC00 
0150 6D0A C805  38         mov   tmp1,@fh.counter
     6D0C A434 
0151                       ;------------------------------------------------------
0152                       ; 1b: Load spectra scratchpad layout
0153                       ;------------------------------------------------------
0154 6D0E 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     6D10 29D8 
0155 6D12 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6D14 2A74 
0156 6D16 A100                   data scrpad.backup2   ; / >2100->8300
0157                       ;------------------------------------------------------
0158                       ; 1c: Check if a file error occured
0159                       ;------------------------------------------------------
0160               fh.file.read.sams.check_fioerr:
0161 6D18 C1A0  34         mov   @fh.ioresult,tmp2
     6D1A A42C 
0162 6D1C 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6D1E 2026 
0163 6D20 1602  14         jne   fh.file.read.sams.check_setpage
0164                                                   ; No, goto (1d)
0165 6D22 0460  28         b     @fh.file.read.sams.error
     6D24 6DFA 
0166                                                   ; Yes, so handle file error
0167                       ;------------------------------------------------------
0168                       ; 1d: Check if SAMS page needs to be set
0169                       ;------------------------------------------------------
0170               fh.file.read.sams.check_setpage:
0171 6D26 C120  34         mov   @edb.next_free.ptr,tmp0
     6D28 A308 
0172 6D2A 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6D2C 24C4 
0173                                                   ; \ i  tmp0  = Memory address
0174                                                   ; | o  waux1 = SAMS page number
0175                                                   ; / o  waux2 = Address of SAMS register
0176               
0177 6D2E C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     6D30 833C 
0178 6D32 8804  38         c     tmp0,@fh.sams.page   ; Compare page with current SAMS page
     6D34 A438 
0179 6D36 1310  14         jeq   fh.file.read.sams.nocompression
0180                                                   ; Same, skip to (2)
0181                       ;------------------------------------------------------
0182                       ; 1e: Increase SAMS page if necessary
0183                       ;------------------------------------------------------
0184 6D38 8804  38         c     tmp0,@fh.sams.hpage   ; Compare page with highest SAMS page
     6D3A A43A 
0185 6D3C 1502  14         jgt   fh.file.read.sams.switch
0186                                                   ; Switch page
0187 6D3E 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     6D40 0005 
0188                       ;------------------------------------------------------
0189                       ; 1f: Switch to SAMS page
0190                       ;------------------------------------------------------
0191               fh.file.read.sams.switch:
0192 6D42 C160  34         mov   @edb.next_free.ptr,tmp1
     6D44 A308 
0193                                                   ; Beginning of line
0194               
0195 6D46 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D48 24FC 
0196                                                   ; \ i  tmp0 = SAMS page number
0197                                                   ; / i  tmp1 = Memory address
0198               
0199 6D4A C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6D4C A438 
0200               
0201 6D4E 8804  38         c     tmp0,@fh.sams.hpage   ; Current SAMS page > highest SAMS page?
     6D50 A43A 
0202 6D52 1202  14         jle   fh.file.read.sams.nocompression
0203                                                   ; No, skip to (2)
0204 6D54 C804  38         mov   tmp0,@fh.sams.hpage   ; Update highest SAMS page
     6D56 A43A 
0205                       ;------------------------------------------------------
0206                       ; Step 2: Process line (without RLE compression)
0207                       ;------------------------------------------------------
0208               fh.file.read.sams.nocompression:
0209 6D58 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6D5A 0960 
0210 6D5C C160  34         mov   @edb.next_free.ptr,tmp1
     6D5E A308 
0211                                                   ; RAM target in editor buffer
0212               
0213 6D60 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6D62 8352 
0214               
0215 6D64 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6D66 A430 
0216 6D68 1324  14         jeq   fh.file.read.sams.prepindex.emptyline
0217                                                   ; Handle empty line
0218                       ;------------------------------------------------------
0219                       ; 2a: Copy line from VDP to CPU editor buffer
0220                       ;------------------------------------------------------
0221                                                   ; Save line prefix
0222 6D6A DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0223 6D6C 06C6  14         swpb  tmp2                  ; |
0224 6D6E DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0225 6D70 06C6  14         swpb  tmp2                  ; /
0226               
0227 6D72 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6D74 A308 
0228 6D76 A806  38         a     tmp2,@edb.next_free.ptr
     6D78 A308 
0229                                                   ; Add line length
0230                       ;------------------------------------------------------
0231                       ; 2b: Handle line split accross 2 consecutive SAMS pages
0232                       ;------------------------------------------------------
0233 6D7A C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0234 6D7C C205  18         mov   tmp1,tmp4             ; Backup tmp1
0235               
0236 6D7E C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
0237 6D80 09C4  56         srl   tmp0,12               ; Only keep high-nibble
0238               
0239 6D82 C160  34         mov   @edb.next_free.ptr,tmp1
     6D84 A308 
0240                                                   ; Get pointer to next line (aka end of line)
0241 6D86 09C5  56         srl   tmp1,12               ; Only keep high-nibble
0242               
0243 6D88 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
0244 6D8A 1307  14         jeq   !                     ; Yes, skip setting SAMS page
0245               
0246 6D8C C120  34         mov   @fh.sams.page,tmp0    ; Get current SAMS page
     6D8E A438 
0247 6D90 0584  14         inc   tmp0                  ; Increase SAMS page
0248 6D92 C160  34         mov   @edb.next_free.ptr,tmp1
     6D94 A308 
0249                                                   ; Get pointer to next line (aka end of line)
0250               
0251 6D96 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D98 24FC 
0252                                                   ; \ i  tmp0 = SAMS page number
0253                                                   ; / i  tmp1 = Memory address
0254               
0255 6D9A C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
0256 6D9C C107  18         mov   tmp3,tmp0             ; Restore tmp0
0257                       ;------------------------------------------------------
0258                       ; 2c: Do actual copy
0259                       ;------------------------------------------------------
0260 6D9E 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6DA0 2444 
0261                                                   ; \ i  tmp0 = VDP source address
0262                                                   ; | i  tmp1 = RAM target address
0263                                                   ; / i  tmp2 = Bytes to copy
0264               
0265 6DA2 1000  14         jmp   fh.file.read.sams.prepindex
0266                                                   ; Prepare for updating index
0267                       ;------------------------------------------------------
0268                       ; Step 4: Update index
0269                       ;------------------------------------------------------
0270               fh.file.read.sams.prepindex:
0271 6DA4 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6DA6 A304 
     6DA8 8350 
0272                                                   ; parm2 = Must allready be set!
0273 6DAA C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6DAC A438 
     6DAE 8354 
0274               
0275 6DB0 1009  14         jmp   fh.file.read.sams.updindex
0276                                                   ; Update index
0277                       ;------------------------------------------------------
0278                       ; 4a: Special handling for empty line
0279                       ;------------------------------------------------------
0280               fh.file.read.sams.prepindex.emptyline:
0281 6DB2 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6DB4 A42E 
     6DB6 8350 
0282 6DB8 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6DBA 8350 
0283 6DBC 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6DBE 8352 
0284 6DC0 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6DC2 8354 
0285                       ;------------------------------------------------------
0286                       ; 4b: Do actual index update
0287                       ;------------------------------------------------------
0288               fh.file.read.sams.updindex:
0289 6DC4 06A0  32         bl    @idx.entry.update     ; Update index
     6DC6 68C4 
0290                                                   ; \ i  parm1    = Line num in editor buffer
0291                                                   ; | i  parm2    = Pointer to line in editor
0292                                                   ; |               buffer
0293                                                   ; | i  parm3    = SAMS page
0294                                                   ; | o  outparm1 = Pointer to updated index
0295                                                   ; /               entry
0296               
0297 6DC8 05A0  34         inc   @edb.lines            ; lines=lines+1
     6DCA A304 
0298                       ;------------------------------------------------------
0299                       ; Step 5: Display results
0300                       ;------------------------------------------------------
0301               fh.file.read.sams.display:
0302 6DCC C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6DCE A43E 
0303 6DD0 0694  24         bl    *tmp0                 ; Run callback function
0304                       ;------------------------------------------------------
0305                       ; Step 6: Check if reaching memory high-limit >ffa0
0306                       ;------------------------------------------------------
0307               fh.file.read.sams.checkmem:
0308 6DD2 C120  34         mov   @edb.next_free.ptr,tmp0
     6DD4 A308 
0309 6DD6 0284  22         ci    tmp0,>ffa0
     6DD8 FFA0 
0310 6DDA 1205  14         jle   fh.file.read.sams.next
0311                       ;------------------------------------------------------
0312                       ; 6a: Address range b000-ffff full, switch SAMS pages
0313                       ;------------------------------------------------------
0314 6DDC 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     6DDE E002 
0315 6DE0 C804  38         mov   tmp0,@edb.next_free.ptr
     6DE2 A308 
0316               
0317 6DE4 1000  14         jmp   fh.file.read.sams.next
0318                       ;------------------------------------------------------
0319                       ; 6b: Next record
0320                       ;------------------------------------------------------
0321               fh.file.read.sams.next:
0322 6DE6 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6DE8 2A52 
0323 6DEA A100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0324               
0325               
0326                       ;-------------------------------------------------------
0327                       ; ** TEMPORARY FIX for 4KB INDEX LIMIT **
0328                       ;-------------------------------------------------------
0329 6DEC C120  34         mov   @edb.lines,tmp0
     6DEE A304 
0330 6DF0 0284  22         ci    tmp0,2047
     6DF2 07FF 
0331 6DF4 1311  14         jeq   fh.file.read.sams.eof
0332               
0333 6DF6 0460  28         b     @fh.file.read.sams.record
     6DF8 6CDA 
0334                                                   ; Next record
0335                       ;------------------------------------------------------
0336                       ; Error handler
0337                       ;------------------------------------------------------
0338               fh.file.read.sams.error:
0339 6DFA C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6DFC A42A 
0340 6DFE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0341 6E00 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6E02 0005 
0342 6E04 1309  14         jeq   fh.file.read.sams.eof
0343                                                   ; All good. File closed by DSRLNK
0344                       ;------------------------------------------------------
0345                       ; File error occured
0346                       ;------------------------------------------------------
0347 6E06 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E08 2A74 
0348 6E0A A100                   data scrpad.backup2   ; / >2100->8300
0349               
0350 6E0C 06A0  32         bl    @mem.setup.sams.layout
     6E0E 66C6 
0351                                                   ; Restore SAMS default memory layout
0352               
0353 6E10 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
     6E12 A442 
0354 6E14 0694  24         bl    *tmp0                 ; Run callback function
0355 6E16 100A  14         jmp   fh.file.read.sams.exit
0356                       ;------------------------------------------------------
0357                       ; End-Of-File reached
0358                       ;------------------------------------------------------
0359               fh.file.read.sams.eof:
0360 6E18 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E1A 2A74 
0361 6E1C A100                   data scrpad.backup2   ; / >2100->8300
0362               
0363 6E1E 06A0  32         bl    @mem.setup.sams.layout
     6E20 66C6 
0364                                                   ; Restore SAMS default memory layout
0365                       ;------------------------------------------------------
0366                       ; Show "loading indicator 3" (final)
0367                       ;------------------------------------------------------
0368 6E22 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     6E24 A306 
0369               
0370 6E26 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
     6E28 A440 
0371 6E2A 0694  24         bl    *tmp0                 ; Run callback function
0372               *--------------------------------------------------------------
0373               * Exit
0374               *--------------------------------------------------------------
0375               fh.file.read.sams.exit:
0376 6E2C 0460  28         b     @poprt                ; Return to caller
     6E2E 2212 
0377               
0378               
0379               
0380               
0381               
0382               
0383               ***************************************************************
0384               * PAB for accessing DV/80 file
0385               ********|*****|*********************|**************************
0386               fh.file.pab.header:
0387 6E30 0014             byte  io.op.open            ;  0    - OPEN
0388                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0389 6E32 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0390 6E34 5000             byte  80                    ;  4    - Record length (80 chars max)
0391                       byte  00                    ;  5    - Character count
0392 6E36 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0393 6E38 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0394                       ;------------------------------------------------------
0395                       ; File descriptor part (variable length)
0396                       ;------------------------------------------------------
0397                       ; byte  12                  ;  9    - File descriptor length
0398                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0399                                                   ;         (Device + '.' + File name)
**** **** ****     > tivi_b1.asm.21084
0050                       copy  "fm.load.asm"         ; File manager loadfile
**** **** ****     > fm.load.asm
0001               * FILE......: fm_load.asm
0002               * Purpose...: High-level file manager module
0003               
0004               *---------------------------------------------------------------
0005               * Load file into editor
0006               *---------------------------------------------------------------
0007               * bl    @fm.loadfile
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * tmp0  = Pointer to length-prefixed string containing both
0011               *         device and filename
0012               ********|*****|*********************|**************************
0013               fm.loadfile:
0014 6E3A 0649  14         dect  stack
0015 6E3C C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6E3E C804  38         mov   tmp0,@parm1           ; Setup file to load
     6E40 8350 
0018 6E42 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E44 6978 
0019 6E46 06A0  32         bl    @idx.init             ; Initialize index
     6E48 68A0 
0020 6E4A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E4C 675C 
0021 6E4E 06A0  32         bl    @cmdb.hide            ; Hide command buffer
     6E50 6BC6 
0022 6E52 C820  54         mov   @parm1,@edb.filename.ptr
     6E54 8350 
     6E56 A30E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6E58 06A0  32         bl    @filv
     6E5A 226E 
0028 6E5C 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6E5E 0000 
     6E60 0004 
0029               
0030 6E62 C160  34         mov   @fb.scrrows,tmp1
     6E64 A298 
0031 6E66 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6E68 A28E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6E6A 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6E6C 0050 
0035 6E6E 0205  20         li    tmp1,32               ; Character to fill
     6E70 0020 
0036               
0037 6E72 06A0  32         bl    @xfilv                ; Fill VDP memory
     6E74 2274 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6E76 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     6E78 6EAA 
0045 6E7A C804  38         mov   tmp0,@parm2           ; Register callback 1
     6E7C 8352 
0046               
0047 6E7E 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     6E80 6EE2 
0048 6E82 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6E84 8354 
0049               
0050 6E86 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     6E88 6F14 
0051 6E8A C804  38         mov   tmp0,@parm4           ; Register callback 3
     6E8C 8356 
0052               
0053 6E8E 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     6E90 6F46 
0054 6E92 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6E94 8358 
0055               
0056 6E96 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6E98 6C20 
0057                                                   ; \ i  parm1 = Pointer to length prefixed
0058                                                   ; |            file descriptor
0059                                                   ; | i  parm2 = Pointer to callback
0060                                                   ; |            "loading indicator 1"
0061                                                   ; | i  parm3 = Pointer to callback
0062                                                   ; |            "loading indicator 2"
0063                                                   ; | i  parm4 = Pointer to callback
0064                                                   ; |            "loading indicator 3"
0065                                                   ; | i  parm5 = Pointer to callback
0066                                                   ; /            "File I/O error handler"
0067               
0068 6E9A 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6E9C A306 
0069                                                   ; longer dirty.
0070               
0071 6E9E 0204  20         li    tmp0,txt.filetype.DV80
     6EA0 72A6 
0072 6EA2 C804  38         mov   tmp0,@edb.filetype.ptr
     6EA4 A310 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6EA6 0460  28         b     @poprt                ; Return to caller
     6EA8 2212 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               *---------------------------------------------------------------
0085               * Is expected to be passed as parm2 to @tfh.file.read
0086               *---------------------------------------------------------------
0087               fm.loadfile.callback.indicator1:
0088 6EAA 0649  14         dect  stack
0089 6EAC C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Show loading indicators and file descriptor
0092                       ;------------------------------------------------------
0093 6EAE 06A0  32         bl    @hchar
     6EB0 2742 
0094 6EB2 1D03                   byte 29,3,32,77
     6EB4 204D 
0095 6EB6 FFFF                   data EOL
0096               
0097 6EB8 06A0  32         bl    @putat
     6EBA 2410 
0098 6EBC 1D03                   byte 29,3
0099 6EBE 7234                   data txt.loading      ; Display "Loading...."
0100               
0101 6EC0 8820  54         c     @fh.rleonload,@w$ffff
     6EC2 A444 
     6EC4 202C 
0102 6EC6 1604  14         jne   !
0103 6EC8 06A0  32         bl    @putat
     6ECA 2410 
0104 6ECC 1D44                   byte 29,68
0105 6ECE 7244                   data txt.rle          ; Display "RLE"
0106               
0107 6ED0 06A0  32 !       bl    @at
     6ED2 264E 
0108 6ED4 1D0E                   byte 29,14            ; Cursor YX position
0109 6ED6 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     6ED8 8350 
0110 6EDA 06A0  32         bl    @xutst0               ; Display device/filename
     6EDC 2400 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.callback.indicator1.exit:
0115 6EDE 0460  28         b     @poprt                ; Return to caller
     6EE0 2212 
0116               
0117               
0118               
0119               
0120               *---------------------------------------------------------------
0121               * Callback function "Show loading indicator 2"
0122               *---------------------------------------------------------------
0123               * Is expected to be passed as parm3 to @tfh.file.read
0124               *---------------------------------------------------------------
0125               fm.loadfile.callback.indicator2:
0126 6EE2 0649  14         dect  stack
0127 6EE4 C64B  30         mov   r11,*stack            ; Save return address
0128               
0129 6EE6 06A0  32         bl    @putnum
     6EE8 29CE 
0130 6EEA 1D4B                   byte 29,75            ; Show lines read
0131 6EEC A304                   data edb.lines,rambuf,>3020
     6EEE 8390 
     6EF0 3020 
0132               
0133 6EF2 8220  34         c     @fh.kilobytes,tmp4
     6EF4 A432 
0134 6EF6 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0135               
0136 6EF8 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     6EFA A432 
0137               
0138 6EFC 06A0  32         bl    @putnum
     6EFE 29CE 
0139 6F00 1D38                   byte 29,56            ; Show kilobytes read
0140 6F02 A432                   data fh.kilobytes,rambuf,>3020
     6F04 8390 
     6F06 3020 
0141               
0142 6F08 06A0  32         bl    @putat
     6F0A 2410 
0143 6F0C 1D3D                   byte 29,61
0144 6F0E 7240                   data txt.kb           ; Show "kb" string
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fm.loadfile.callback.indicator2.exit:
0149 6F10 0460  28         b     @poprt                ; Return to caller
     6F12 2212 
0150               
0151               
0152               
0153               
0154               
0155               *---------------------------------------------------------------
0156               * Callback function "Show loading indicator 3"
0157               *---------------------------------------------------------------
0158               * Is expected to be passed as parm4 to @tfh.file.read
0159               *---------------------------------------------------------------
0160               fm.loadfile.callback.indicator3:
0161 6F14 0649  14         dect  stack
0162 6F16 C64B  30         mov   r11,*stack            ; Save return address
0163               
0164               
0165 6F18 06A0  32         bl    @hchar
     6F1A 2742 
0166 6F1C 1D03                   byte 29,3,32,50       ; Erase loading indicator
     6F1E 2032 
0167 6F20 FFFF                   data EOL
0168               
0169 6F22 06A0  32         bl    @putnum
     6F24 29CE 
0170 6F26 1D38                   byte 29,56            ; Show kilobytes read
0171 6F28 A432                   data fh.kilobytes,rambuf,>3020
     6F2A 8390 
     6F2C 3020 
0172               
0173 6F2E 06A0  32         bl    @putat
     6F30 2410 
0174 6F32 1D3D                   byte 29,61
0175 6F34 7240                   data txt.kb           ; Show "kb" string
0176               
0177 6F36 06A0  32         bl    @putnum
     6F38 29CE 
0178 6F3A 1D4B                   byte 29,75            ; Show lines read
0179 6F3C A42E                   data fh.records,rambuf,>3020
     6F3E 8390 
     6F40 3020 
0180                       ;------------------------------------------------------
0181                       ; Exit
0182                       ;------------------------------------------------------
0183               fm.loadfile.callback.indicator3.exit:
0184 6F42 0460  28         b     @poprt                ; Return to caller
     6F44 2212 
0185               
0186               
0187               
0188               *---------------------------------------------------------------
0189               * Callback function "File I/O error handler"
0190               *---------------------------------------------------------------
0191               * Is expected to be passed as parm5 to @tfh.file.read
0192               ********|*****|*********************|**************************
0193               fm.loadfile.callback.fioerr:
0194 6F46 0649  14         dect  stack
0195 6F48 C64B  30         mov   r11,*stack            ; Save return address
0196               
0197 6F4A 06A0  32         bl    @hchar
     6F4C 2742 
0198 6F4E 1D00                   byte 29,0,32,50       ; Erase loading indicator
     6F50 2032 
0199 6F52 FFFF                   data EOL
0200               
0201                       ;------------------------------------------------------
0202                       ; Display I/O error message
0203                       ;------------------------------------------------------
0204 6F54 06A0  32         bl    @cpym2m
     6F56 2460 
0205 6F58 724F                   data txt.ioerr+1
0206 6F5A B000                   data cmdb.top
0207 6F5C 0029                   data 41               ; Error message
0208               
0209               
0210 6F5E C120  34         mov   @edb.filename.ptr,tmp0
     6F60 A30E 
0211 6F62 D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 6F64 0986  56         srl   tmp2,8                ; Right align
0213 6F66 0584  14         inc   tmp0                  ; Skip length byte
0214 6F68 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     6F6A B02A 
0215               
0216 6F6C 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     6F6E 2466 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220               
0221               
0222 6F70 0204  20         li    tmp0,txt.newfile      ; New file
     6F72 727C 
0223 6F74 C804  38         mov   tmp0,@edb.filename.ptr
     6F76 A30E 
0224               
0225 6F78 0204  20         li    tmp0,txt.filetype.none
     6F7A 72B2 
0226 6F7C C804  38         mov   tmp0,@edb.filetype.ptr
     6F7E A310 
0227                                                   ; Empty filetype string
0228               
0229 6F80 C820  54         mov   @cmdb.scrrows,@parm1
     6F82 A504 
     6F84 8350 
0230 6F86 06A0  32         bl    @cmdb.show
     6F88 6B94 
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               fm.loadfile.callback.fioerr.exit:
0235 6F8A 0460  28         b     @poprt                ; Return to caller
     6F8C 2212 
**** **** ****     > tivi_b1.asm.21084
0051                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: TiVi Editor - Keyboard handling (spectra2 user hook)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Keyboard handling (spectra2 user hook)
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011               hook.keyscan:
0012 6F8E 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     6F90 2014 
0013 6F92 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 6F94 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6F96 2014 
0019 6F98 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6F9A 833C 
     6F9C 833E 
0020 6F9E 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 6FA0 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6FA2 833C 
     6FA4 833E 
0026 6FA6 0460  28         b     @edkey.key.process    ; Process key
     6FA8 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 6FAA 04E0  34         clr   @waux1
     6FAC 833C 
0032 6FAE 04E0  34         clr   @waux2
     6FB0 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 6FB2 0204  20         li    tmp0,2000             ; Avoid key bouncing
     6FB4 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 6FB6 0604  14         dec   tmp0
0043 6FB8 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 6FBA 0460  28         b     @hookok               ; Return
     6FBC 2C2A 
**** **** ****     > tivi_b1.asm.21084
0052                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: TiVi Editor - VDP draw editor panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0010               ***************************************************************
0011               task.vdp.panes:
0012 6FBE C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     6FC0 A296 
0013 6FC2 1360  14         jeq   task.vdp.panes.exit   ; No, skip update
0014 6FC4 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     6FC6 832A 
     6FC8 A294 
0015                       ;------------------------------------------------------
0016                       ; Determine how many rows to copy
0017                       ;------------------------------------------------------
0018 6FCA 8820  54         c     @edb.lines,@fb.scrrows
     6FCC A304 
     6FCE A298 
0019 6FD0 1103  14         jlt   task.vdp.panes.setrows.small
0020 6FD2 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     6FD4 A298 
0021 6FD6 1003  14         jmp   task.vdp.panes.copy.framebuffer
0022                       ;------------------------------------------------------
0023                       ; Less lines in editor buffer as rows in frame buffer
0024                       ;------------------------------------------------------
0025               task.vdp.panes.setrows.small:
0026 6FD8 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     6FDA A304 
0027 6FDC 0585  14         inc   tmp1
0028                       ;------------------------------------------------------
0029                       ; Determine area to copy
0030                       ;------------------------------------------------------
0031               task.vdp.panes.copy.framebuffer:
0032 6FDE 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6FE0 A28E 
0033                                                   ; 16 bit part is in tmp2!
0034 6FE2 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6FE4 0050 
0035 6FE6 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     6FE8 A280 
0036                       ;------------------------------------------------------
0037                       ; Copy memory block
0038                       ;------------------------------------------------------
0039 6FEA 06A0  32         bl    @xpym2v               ; Copy to VDP
     6FEC 241E 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = RAM source address
0042                                                   ; / i  tmp2 = Bytes to copy
0043 6FEE 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     6FF0 A296 
0044                       ;-------------------------------------------------------
0045                       ; Draw EOF marker at end-of-file
0046                       ;-------------------------------------------------------
0047 6FF2 C120  34         mov   @edb.lines,tmp0
     6FF4 A304 
0048 6FF6 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     6FF8 A284 
0049 6FFA 05C4  14         inct  tmp0                  ; Y = Y + 2
0050 6FFC 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     6FFE A298 
0051 7000 121C  14         jle   task.vdp.panes.draw_double.line
0052                       ;-------------------------------------------------------
0053                       ; Do actual drawing of EOF marker
0054                       ;-------------------------------------------------------
0055               task.vdp.panes.draw_marker:
0056 7002 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0057 7004 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7006 832A 
0058               
0059 7008 06A0  32         bl    @putstr
     700A 23FE 
0060 700C 721E                   data txt.marker       ; Display *EOF*
0061                       ;-------------------------------------------------------
0062                       ; Draw empty line after (and below) EOF marker
0063                       ;-------------------------------------------------------
0064 700E 06A0  32         bl    @setx
     7010 2664 
0065 7012 0005                   data  5               ; Cursor after *EOF* string
0066               
0067 7014 C120  34         mov   @wyx,tmp0
     7016 832A 
0068 7018 0984  56         srl   tmp0,8                ; Right justify
0069 701A 0584  14         inc   tmp0                  ; One time adjust
0070 701C 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     701E A298 
0071 7020 1303  14         jeq   !
0072 7022 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7024 009B 
0073 7026 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0074 7028 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     702A 004B 
0075                       ;-------------------------------------------------------
0076                       ; Draw 1 or 2 empty lines
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.draw_marker.empty.line:
0079 702C 0604  14         dec   tmp0                  ; One time adjust
0080 702E 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7030 23DA 
0081 7032 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7034 0020 
0082 7036 06A0  32         bl    @xfilv                ; Fill VDP memory
     7038 2274 
0083                                                   ; i  tmp0 = VDP destination
0084                                                   ; i  tmp1 = byte to write
0085                                                   ; i  tmp2 = Number of bytes to write
0086                       ;-------------------------------------------------------
0087                       ; Draw "double" bottom line (above command buffer)
0088                       ;-------------------------------------------------------
0089               task.vdp.panes.draw_double.line:
0090 703A C120  34         mov   @fb.scrrows,tmp0
     703C A298 
0091 703E 0584  14         inc   tmp0                  ; 1st Line after frame buffer boundary
0092 7040 06C4  14         swpb  tmp0                  ; LSB to MSB
0093 7042 C804  38         mov   tmp0,@wyx             ; Save YX
     7044 832A 
0094               
0095 7046 C120  34         mov   @cmdb.visible,tmp0    ; Command buffer hidden ?
     7048 A502 
0096 704A 1309  14         jeq   !                     ; Yes, full double line
0097                       ;-------------------------------------------------------
0098                       ; Double line with "header" label
0099                       ;-------------------------------------------------------
0100 704C 06A0  32         bl    @putstr
     704E 23FE 
0101 7050 7288                   data txt.cmdb.cmdb    ; Show text "Command Buffer"
0102               
0103 7052 06A0  32         bl    @setx                 ; Set cursor to screen column 15
     7054 2664 
0104 7056 000F                   data 15
0105 7058 0206  20         li    tmp2,65               ; Repeat 65x
     705A 0041 
0106 705C 1005  14         jmp   task.vdp.panes.draw_double.draw
0107                       ;-------------------------------------------------------
0108                       ; Continious double line (80 characters)
0109                       ;-------------------------------------------------------
0110 705E 06A0  32 !       bl    @setx                 ; Set cursor to screen column 0
     7060 2664 
0111 7062 0000                   data 0
0112 7064 0206  20         li    tmp2,80               ; Repeat 80x
     7066 0050 
0113                       ;-------------------------------------------------------
0114                       ; Do actual drawing
0115                       ;-------------------------------------------------------
0116               task.vdp.panes.draw_double.draw:
0117 7068 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     706A 23DA 
0118 706C 0205  20         li    tmp1,3                ; Character to write (double line)
     706E 0003 
0119 7070 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     7072 2274 
0120                                                   ; | i  tmp0 = VDP destination
0121                                                   ; | i  tmp1 = Byte to write
0122                                                   ; / i  tmp2 = Number of bstes to write
0123 7074 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7076 A294 
     7078 832A 
0124                       ;-------------------------------------------------------
0125                       ; Show command buffer
0126                       ;-------------------------------------------------------
0127 707A C120  34         mov   @cmdb.visible,tmp0     ; Show command buffer?
     707C A502 
0128 707E 1302  14         jeq   task.vdp.panes.exit    ; No, skip
0129 7080 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     7082 6BE4 
0130                       ;------------------------------------------------------
0131                       ; Exit task
0132                       ;------------------------------------------------------
0133               task.vdp.panes.exit:
0134 7084 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     7086 70DC 
0135 7088 0460  28         b     @slotok
     708A 2CA6 
**** **** ****     > tivi_b1.asm.21084
0053                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: TiVi Editor - VDP copy SAT
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
0010               ***************************************************************
0011               task.vdp.copy.sat:
0012 708C E0A0  34         soc   @wbit0,config          ; Sprite adjustment on
     708E 202A 
0013 7090 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     7092 2670 
0014 7094 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7096 8380 
0015               
0016 7098 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     709A 2418 
0017 709C 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     709E 8380 
     70A0 0004 
0018                                                    ; | i  tmp1 = ROM/RAM source
0019                                                    ; / i  tmp2 = Number of bytes to write
0020                       ;------------------------------------------------------
0021                       ; Exit
0022                       ;------------------------------------------------------
0023               task.vdp.copy.sat.exit:
0024 70A2 0460  28         b     @slotok                ; Exit task
     70A4 2CA6 
**** **** ****     > tivi_b1.asm.21084
0054                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: TiVi Editor - VDP sprite cursor
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Update cursor shape (blink)
0010               ***************************************************************
0011               task.vdp.cursor:
0012 70A6 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     70A8 A292 
0013 70AA 1303  14         jeq   task.vdp.cursor.visible
0014 70AC 04E0  34         clr   @ramsat+2              ; Hide cursor
     70AE 8382 
0015 70B0 100C  14         jmp  task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 70B2 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     70B4 A30A 
0019 70B6 1302  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 70B8 04C4  14         clr   tmp0
0025 70BA 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0026                       ;------------------------------------------------------
0027                       ; Cursor in overwrite mode
0028                       ;------------------------------------------------------
0029               task.vdp.cursor.visible.overwrite_mode:
0030 70BC 0204  20         li    tmp0,>0200
     70BE 0200 
0031                       ;------------------------------------------------------
0032                       ; Set cursor shape
0033                       ;------------------------------------------------------
0034               task.vdp.cursor.visible.cursorshape:
0035 70C0 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     70C2 A214 
0036 70C4 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     70C6 A214 
     70C8 8382 
0037                       ;------------------------------------------------------
0038                       ; Copy SAT
0039                       ;------------------------------------------------------
0040               task.vdp.cursor.copy.sat:
0041 70CA 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     70CC 2418 
0042 70CE 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     70D0 8380 
     70D2 0004 
0043                                                    ; | i  tmp1 = ROM/RAM source
0044                                                    ; / i  tmp2 = Number of bytes to write
0045                       ;-------------------------------------------------------
0046                       ; Show status bottom line
0047                       ;-------------------------------------------------------
0048 70D4 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     70D6 70DC 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               task.vdp.cursor.exit:
0053 70D8 0460  28         b     @slotok                ; Exit task
     70DA 2CA6 
**** **** ****     > tivi_b1.asm.21084
0055                       copy  "pane.botline.asm"    ; Pane status bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: TiVi Editor - Pane status bottom line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Pane status bottom line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.botline.draw
0010               * Draw TiVi status bottom line
0011               ***************************************************************
0012               * bl  @pane.botline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.botline.draw:
0021 70DC 0649  14         dect  stack
0022 70DE C64B  30         mov   r11,*stack            ; Save return address
0023 70E0 0649  14         dect  stack
0024 70E2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 70E4 C820  54         mov   @wyx,@fb.yxsave
     70E6 832A 
     70E8 A294 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 70EA 06A0  32         bl    @putat
     70EC 2410 
0032 70EE 1D00                   byte  29,0
0033 70F0 7278                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 70F2 06A0  32         bl    @at
     70F4 264E 
0039 70F6 1D03                   byte  29,3            ; Position cursor
0040 70F8 C160  34         mov   @edb.filename.ptr,tmp1
     70FA A30E 
0041                                                   ; Get string to display
0042 70FC 06A0  32         bl    @xutst0               ; Display string
     70FE 2400 
0043               
0044 7100 06A0  32         bl    @at
     7102 264E 
0045 7104 1D23                   byte  29,35           ; Position cursor
0046               
0047 7106 C160  34         mov   @edb.filetype.ptr,tmp1
     7108 A310 
0048                                                   ; Get string to display
0049 710A 06A0  32         bl    @xutst0               ; Display Filetype string
     710C 2400 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 710E C120  34         mov   @edb.insmode,tmp0
     7110 A30A 
0055 7112 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 7114 06A0  32         bl    @putat
     7116 2410 
0061 7118 1D32                   byte  29,50
0062 711A 722A                   data  txt.ovrwrite
0063 711C 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 711E 06A0  32         bl    @putat
     7120 2410 
0069 7122 1D32                   byte  29,50
0070 7124 722E                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7126 C120  34         mov   @edb.dirty,tmp0
     7128 A306 
0076 712A 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 712C 06A0  32         bl    @putat
     712E 2410 
0081 7130 1D36                   byte 29,54
0082 7132 7232                   data txt.star
0083 7134 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7136 1000  14         nop
0089               pane.botline.show_linecol:
0090 7138 C820  54         mov   @fb.row,@parm1
     713A A286 
     713C 8350 
0091 713E 06A0  32         bl    @fb.row2line
     7140 67B0 
0092 7142 05A0  34         inc   @outparm1
     7144 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7146 06A0  32         bl    @putnum
     7148 29CE 
0097 714A 1D40                   byte  29,64            ; YX
0098 714C 8360                   data  outparm1,rambuf
     714E 8390 
0099 7150 3020                   byte  48               ; ASCII offset
0100                             byte  32               ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7152 06A0  32         bl    @putat
     7154 2410 
0105 7156 1D45                   byte  29,69
0106 7158 721C                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 715A 06A0  32         bl    @film
     715C 2216 
0111 715E 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7160 0020 
     7162 000C 
0112               
0113 7164 C820  54         mov   @fb.column,@waux1
     7166 A28C 
     7168 833C 
0114 716A 05A0  34         inc   @waux1                 ; Offset 1
     716C 833C 
0115               
0116 716E 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7170 2950 
0117 7172 833C                   data  waux1,rambuf
     7174 8390 
0118 7176 3020                   byte  48               ; ASCII offset
0119                             byte  32               ; Fill character
0120               
0121 7178 06A0  32         bl    @trimnum               ; Trim number to the left
     717A 29A8 
0122 717C 8390                   data  rambuf,rambuf+6,32
     717E 8396 
     7180 0020 
0123               
0124 7182 0204  20         li    tmp0,>0200
     7184 0200 
0125 7186 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7188 8396 
0126               
0127 718A 06A0  32         bl    @putat
     718C 2410 
0128 718E 1D46                   byte 29,70
0129 7190 8396                   data rambuf+6          ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7192 C820  54         mov   @fb.row,@parm1
     7194 A286 
     7196 8350 
0134 7198 06A0  32         bl    @fb.row2line
     719A 67B0 
0135 719C 8820  54         c     @edb.lines,@outparm1
     719E A304 
     71A0 8360 
0136 71A2 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 71A4 06A0  32         bl    @putat
     71A6 2410 
0139 71A8 1D4B                   byte 29,75
0140 71AA 7224                   data txt.bottom
0141               
0142 71AC 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 71AE C820  54         mov   @edb.lines,@waux1
     71B0 A304 
     71B2 833C 
0148 71B4 05A0  34         inc   @waux1                 ; Offset 1
     71B6 833C 
0149 71B8 06A0  32         bl    @putnum
     71BA 29CE 
0150 71BC 1D4B                   byte 29,75             ; YX
0151 71BE 833C                   data waux1,rambuf
     71C0 8390 
0152 71C2 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 71C4 C820  54         mov   @fb.yxsave,@wyx
     71C6 A294 
     71C8 832A 
0159 71CA C139  30         mov   *stack+,tmp0           ; Pop tmp0
0160 71CC C2F9  30         mov   *stack+,r11            ; Pop r11
0161 71CE 045B  20         b     *r11                   ; Return
**** **** ****     > tivi_b1.asm.21084
0056                       copy  "data.constants.asm"  ; Data segment - Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: TiVi Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               romsat:
0008 71D0 0303             data  >0303,>000f           ; Cursor YX, initial shape and colour
     71D2 000F 
0009               
0010               cursors:
0011 71D4 0000             data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     71D6 0000 
     71D8 0000 
     71DA 001C 
0012 71DC 1010             data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     71DE 1010 
     71E0 1010 
     71E2 1000 
0013 71E4 1C1C             data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     71E6 1C1C 
     71E8 1C1C 
     71EA 1C00 
0014               
0015               lines:
0016 71EC 0000             data >0000,>ff00,>00ff,>0080 ; Double line top + ruler
     71EE FF00 
     71F0 00FF 
     71F2 0080 
0017 71F4 0080             data >0080,>0000,>ff00,>ff00 ; Ruler + double line bottom
     71F6 0000 
     71F8 FF00 
     71FA FF00 
0018 71FC 0000             data >0000,>0000,>ff00,>ff00 ; Double line bottom, without ruler
     71FE 0000 
     7200 FF00 
     7202 FF00 
0019 7204 0000             data >0000,>c0c0,>c0c0,>0080 ; Double line top left corner
     7206 C0C0 
     7208 C0C0 
     720A 0080 
0020 720C 0000             data >0000,>0f0f,>0f0f,>0000 ; Double line top right corner
     720E 0F0F 
     7210 0F0F 
     7212 0000 
0021               
0022               
0023               tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
0024 7214 F404             data  >f404                 ; White      | Dark blue  | Dark blue
0025 7216 F101             data  >f101                 ; White      | Black      | Black
0026 7218 1707             data  >1707                 ; Black      | Cyan       | Cyan
0027 721A 1F0F             data  >1f0f                 ; Black      | White      | White
**** **** ****     > tivi_b1.asm.21084
0057                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: TiVi Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 721C 012C             byte  1
0009 721D ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 721E 052A             byte  5
0014 721F ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 7224 0520             byte  5
0019 7225 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 722A 034F             byte  3
0024 722B ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 722E 0349             byte  3
0029 722F ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 7232 012A             byte  1
0034 7233 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 7234 0A4C             byte  10
0039 7235 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 7240 026B             byte  2
0044 7241 ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 7244 0352             byte  3
0049 7245 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 7248 054C             byte  5
0054 7249 ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 724E 293E             byte  41
0059 724F ....             text  '> I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 7278 0223             byte  2
0064 7279 ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 727C 0A5B             byte  10
0069 727D ....             text  '[New file]'
0070                       even
0071               
0072               
0073               
0074               txt.cmdb.cmdb
0075 7288 0F43             byte  15
0076 7289 ....             text  'Command Buffer '
0077                       even
0078               
0079               txt.cmdb.catalog
0080 7298 0D46             byte  13
0081 7299 ....             text  'File catalog '
0082                       even
0083               
0084               
0085               
0086               txt.filetype.dv80
0087 72A6 0A44             byte  10
0088 72A7 ....             text  'DIS/VAR80 '
0089                       even
0090               
0091               txt.filetype.none
0092 72B2 0A20             byte  10
0093 72B3 ....             text  '          '
0094                       even
0095               
0096               
0097 72BE 1804     txt.tivi     byte    24
0098                            byte    4
0099 72C0 ....                  text    'TiVi beta 200325-21084'
0100 72D6 0500                  byte    5
0101                            even
0102               
0103               fdname0
0104 72D8 0F44             byte  15
0105 72D9 ....             text  'DSK1.FWDOC/PSRV'
0106                       even
0107               
0108               fdname1
0109 72E8 0F44             byte  15
0110 72E9 ....             text  'DSK1.SPEECHDOCS'
0111                       even
0112               
0113               fdname2
0114 72F8 0C44             byte  12
0115 72F9 ....             text  'DSK1.XBEADOC'
0116                       even
0117               
0118               fdname3
0119 7306 0C44             byte  12
0120 7307 ....             text  'DSK3.XBEADOC'
0121                       even
0122               
0123               fdname4
0124 7314 0C44             byte  12
0125 7315 ....             text  'DSK3.C99MAN1'
0126                       even
0127               
0128               fdname5
0129 7322 0C44             byte  12
0130 7323 ....             text  'DSK3.C99MAN2'
0131                       even
0132               
0133               fdname6
0134 7330 0C44             byte  12
0135 7331 ....             text  'DSK3.C99MAN3'
0136                       even
0137               
0138               fdname7
0139 733E 0D44             byte  13
0140 733F ....             text  'DSK3.C99SPECS'
0141                       even
0142               
0143               fdname8
0144 734C 0D44             byte  13
0145 734D ....             text  'DSK3.RANDOM#C'
0146                       even
0147               
0148               fdname9
0149 735A 0D44             byte  13
0150 735B ....             text  'DSK1.INVADERS'
0151                       even
0152               
0153               
0154               
0155               *---------------------------------------------------------------
0156               * Keyboard labels - Function keys
0157               *---------------------------------------------------------------
0158               txt.fctn.0
0159 7368 0866             byte  8
0160 7369 ....             text  'fctn + 0'
0161                       even
0162               
0163               txt.fctn.1
0164 7372 0866             byte  8
0165 7373 ....             text  'fctn + 1'
0166                       even
0167               
0168               txt.fctn.2
0169 737C 0866             byte  8
0170 737D ....             text  'fctn + 2'
0171                       even
0172               
0173               txt.fctn.3
0174 7386 0866             byte  8
0175 7387 ....             text  'fctn + 3'
0176                       even
0177               
0178               txt.fctn.4
0179 7390 0866             byte  8
0180 7391 ....             text  'fctn + 4'
0181                       even
0182               
0183               txt.fctn.5
0184 739A 0866             byte  8
0185 739B ....             text  'fctn + 5'
0186                       even
0187               
0188               txt.fctn.6
0189 73A4 0866             byte  8
0190 73A5 ....             text  'fctn + 6'
0191                       even
0192               
0193               txt.fctn.7
0194 73AE 0866             byte  8
0195 73AF ....             text  'fctn + 7'
0196                       even
0197               
0198               txt.fctn.8
0199 73B8 0866             byte  8
0200 73B9 ....             text  'fctn + 8'
0201                       even
0202               
0203               txt.fctn.9
0204 73C2 0866             byte  8
0205 73C3 ....             text  'fctn + 9'
0206                       even
0207               
0208               txt.fctn.a
0209 73CC 0866             byte  8
0210 73CD ....             text  'fctn + a'
0211                       even
0212               
0213               txt.fctn.b
0214 73D6 0866             byte  8
0215 73D7 ....             text  'fctn + b'
0216                       even
0217               
0218               txt.fctn.c
0219 73E0 0866             byte  8
0220 73E1 ....             text  'fctn + c'
0221                       even
0222               
0223               txt.fctn.d
0224 73EA 0866             byte  8
0225 73EB ....             text  'fctn + d'
0226                       even
0227               
0228               txt.fctn.e
0229 73F4 0866             byte  8
0230 73F5 ....             text  'fctn + e'
0231                       even
0232               
0233               txt.fctn.f
0234 73FE 0866             byte  8
0235 73FF ....             text  'fctn + f'
0236                       even
0237               
0238               txt.fctn.g
0239 7408 0866             byte  8
0240 7409 ....             text  'fctn + g'
0241                       even
0242               
0243               txt.fctn.h
0244 7412 0866             byte  8
0245 7413 ....             text  'fctn + h'
0246                       even
0247               
0248               txt.fctn.i
0249 741C 0866             byte  8
0250 741D ....             text  'fctn + i'
0251                       even
0252               
0253               txt.fctn.j
0254 7426 0866             byte  8
0255 7427 ....             text  'fctn + j'
0256                       even
0257               
0258               txt.fctn.k
0259 7430 0866             byte  8
0260 7431 ....             text  'fctn + k'
0261                       even
0262               
0263               txt.fctn.l
0264 743A 0866             byte  8
0265 743B ....             text  'fctn + l'
0266                       even
0267               
0268               txt.fctn.m
0269 7444 0866             byte  8
0270 7445 ....             text  'fctn + m'
0271                       even
0272               
0273               txt.fctn.n
0274 744E 0866             byte  8
0275 744F ....             text  'fctn + n'
0276                       even
0277               
0278               txt.fctn.o
0279 7458 0866             byte  8
0280 7459 ....             text  'fctn + o'
0281                       even
0282               
0283               txt.fctn.p
0284 7462 0866             byte  8
0285 7463 ....             text  'fctn + p'
0286                       even
0287               
0288               txt.fctn.q
0289 746C 0866             byte  8
0290 746D ....             text  'fctn + q'
0291                       even
0292               
0293               txt.fctn.r
0294 7476 0866             byte  8
0295 7477 ....             text  'fctn + r'
0296                       even
0297               
0298               txt.fctn.s
0299 7480 0866             byte  8
0300 7481 ....             text  'fctn + s'
0301                       even
0302               
0303               txt.fctn.t
0304 748A 0866             byte  8
0305 748B ....             text  'fctn + t'
0306                       even
0307               
0308               txt.fctn.u
0309 7494 0866             byte  8
0310 7495 ....             text  'fctn + u'
0311                       even
0312               
0313               txt.fctn.v
0314 749E 0866             byte  8
0315 749F ....             text  'fctn + v'
0316                       even
0317               
0318               txt.fctn.w
0319 74A8 0866             byte  8
0320 74A9 ....             text  'fctn + w'
0321                       even
0322               
0323               txt.fctn.x
0324 74B2 0866             byte  8
0325 74B3 ....             text  'fctn + x'
0326                       even
0327               
0328               txt.fctn.y
0329 74BC 0866             byte  8
0330 74BD ....             text  'fctn + y'
0331                       even
0332               
0333               txt.fctn.z
0334 74C6 0866             byte  8
0335 74C7 ....             text  'fctn + z'
0336                       even
0337               
0338               *---------------------------------------------------------------
0339               * Keyboard labels - Function keys extra
0340               *---------------------------------------------------------------
0341               txt.fctn.dot
0342 74D0 0866             byte  8
0343 74D1 ....             text  'fctn + .'
0344                       even
0345               
0346               txt.fctn.plus
0347 74DA 0866             byte  8
0348 74DB ....             text  'fctn + +'
0349                       even
0350               
0351               *---------------------------------------------------------------
0352               * Keyboard labels - Control keys
0353               *---------------------------------------------------------------
0354               txt.ctrl.0
0355 74E4 0863             byte  8
0356 74E5 ....             text  'ctrl + 0'
0357                       even
0358               
0359               txt.ctrl.1
0360 74EE 0863             byte  8
0361 74EF ....             text  'ctrl + 1'
0362                       even
0363               
0364               txt.ctrl.2
0365 74F8 0863             byte  8
0366 74F9 ....             text  'ctrl + 2'
0367                       even
0368               
0369               txt.ctrl.3
0370 7502 0863             byte  8
0371 7503 ....             text  'ctrl + 3'
0372                       even
0373               
0374               txt.ctrl.4
0375 750C 0863             byte  8
0376 750D ....             text  'ctrl + 4'
0377                       even
0378               
0379               txt.ctrl.5
0380 7516 0863             byte  8
0381 7517 ....             text  'ctrl + 5'
0382                       even
0383               
0384               txt.ctrl.6
0385 7520 0863             byte  8
0386 7521 ....             text  'ctrl + 6'
0387                       even
0388               
0389               txt.ctrl.7
0390 752A 0863             byte  8
0391 752B ....             text  'ctrl + 7'
0392                       even
0393               
0394               txt.ctrl.8
0395 7534 0863             byte  8
0396 7535 ....             text  'ctrl + 8'
0397                       even
0398               
0399               txt.ctrl.9
0400 753E 0863             byte  8
0401 753F ....             text  'ctrl + 9'
0402                       even
0403               
0404               txt.ctrl.a
0405 7548 0863             byte  8
0406 7549 ....             text  'ctrl + a'
0407                       even
0408               
0409               txt.ctrl.b
0410 7552 0863             byte  8
0411 7553 ....             text  'ctrl + b'
0412                       even
0413               
0414               txt.ctrl.c
0415 755C 0863             byte  8
0416 755D ....             text  'ctrl + c'
0417                       even
0418               
0419               txt.ctrl.d
0420 7566 0863             byte  8
0421 7567 ....             text  'ctrl + d'
0422                       even
0423               
0424               txt.ctrl.e
0425 7570 0863             byte  8
0426 7571 ....             text  'ctrl + e'
0427                       even
0428               
0429               txt.ctrl.f
0430 757A 0863             byte  8
0431 757B ....             text  'ctrl + f'
0432                       even
0433               
0434               txt.ctrl.g
0435 7584 0863             byte  8
0436 7585 ....             text  'ctrl + g'
0437                       even
0438               
0439               txt.ctrl.h
0440 758E 0863             byte  8
0441 758F ....             text  'ctrl + h'
0442                       even
0443               
0444               txt.ctrl.i
0445 7598 0863             byte  8
0446 7599 ....             text  'ctrl + i'
0447                       even
0448               
0449               txt.ctrl.j
0450 75A2 0863             byte  8
0451 75A3 ....             text  'ctrl + j'
0452                       even
0453               
0454               txt.ctrl.k
0455 75AC 0863             byte  8
0456 75AD ....             text  'ctrl + k'
0457                       even
0458               
0459               txt.ctrl.l
0460 75B6 0863             byte  8
0461 75B7 ....             text  'ctrl + l'
0462                       even
0463               
0464               txt.ctrl.m
0465 75C0 0863             byte  8
0466 75C1 ....             text  'ctrl + m'
0467                       even
0468               
0469               txt.ctrl.n
0470 75CA 0863             byte  8
0471 75CB ....             text  'ctrl + n'
0472                       even
0473               
0474               txt.ctrl.o
0475 75D4 0863             byte  8
0476 75D5 ....             text  'ctrl + o'
0477                       even
0478               
0479               txt.ctrl.p
0480 75DE 0863             byte  8
0481 75DF ....             text  'ctrl + p'
0482                       even
0483               
0484               txt.ctrl.q
0485 75E8 0863             byte  8
0486 75E9 ....             text  'ctrl + q'
0487                       even
0488               
0489               txt.ctrl.r
0490 75F2 0863             byte  8
0491 75F3 ....             text  'ctrl + r'
0492                       even
0493               
0494               txt.ctrl.s
0495 75FC 0863             byte  8
0496 75FD ....             text  'ctrl + s'
0497                       even
0498               
0499               txt.ctrl.t
0500 7606 0863             byte  8
0501 7607 ....             text  'ctrl + t'
0502                       even
0503               
0504               txt.ctrl.u
0505 7610 0863             byte  8
0506 7611 ....             text  'ctrl + u'
0507                       even
0508               
0509               txt.ctrl.v
0510 761A 0863             byte  8
0511 761B ....             text  'ctrl + v'
0512                       even
0513               
0514               txt.ctrl.w
0515 7624 0863             byte  8
0516 7625 ....             text  'ctrl + w'
0517                       even
0518               
0519               txt.ctrl.x
0520 762E 0863             byte  8
0521 762F ....             text  'ctrl + x'
0522                       even
0523               
0524               txt.ctrl.y
0525 7638 0863             byte  8
0526 7639 ....             text  'ctrl + y'
0527                       even
0528               
0529               txt.ctrl.z
0530 7642 0863             byte  8
0531 7643 ....             text  'ctrl + z'
0532                       even
0533               
0534               *---------------------------------------------------------------
0535               * Keyboard labels - control keys extra
0536               *---------------------------------------------------------------
0537               txt.ctrl.plus
0538 764C 0863             byte  8
0539 764D ....             text  'ctrl + +'
0540                       even
0541               
0542               *---------------------------------------------------------------
0543               * Special keys
0544               *---------------------------------------------------------------
0545               txt.enter
0546 7656 0565             byte  5
0547 7657 ....             text  'enter'
0548                       even
0549               
**** **** ****     > tivi_b1.asm.21084
0058                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: TiVi Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      0000     key.fctn.0    equ >0000             ; fctn + 0
0008      0300     key.fctn.1    equ >0300             ; fctn + 1
0009      0400     key.fctn.2    equ >0400             ; fctn + 2
0010      0700     key.fctn.3    equ >0700             ; fctn + 3
0011      0000     key.fctn.4    equ >0000             ; fctn + 4
0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0013      0000     key.fctn.6    equ >0000             ; fctn + 6
0014      0000     key.fctn.7    equ >0000             ; fctn + 7
0015      0000     key.fctn.8    equ >0000             ; fctn + 8
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
0046      B900     key.fctn.dot  equ >b900             ; fctn + .
0047      0500     key.fctn.plus equ >0500             ; fctn + +
0048               *---------------------------------------------------------------
0049               * Keyboard scancodes - control keys
0050               *-------------|---------------------|---------------------------
0051      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0052      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0053      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0054      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0055      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0056      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0057      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0058      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0059      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0060      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0061      8100     key.ctrl.a    equ >8100             ; ctrl + a
0062      8200     key.ctrl.b    equ >8200             ; ctrl + b
0063      0000     key.ctrl.c    equ >0000             ; ctrl + c
0064      8400     key.ctrl.d    equ >8400             ; ctrl + d
0065      8500     key.ctrl.e    equ >8500             ; ctrl + e
0066      8600     key.ctrl.f    equ >8600             ; ctrl + f
0067      0000     key.ctrl.g    equ >0000             ; ctrl + g
0068      0000     key.ctrl.h    equ >0000             ; ctrl + h
0069      0000     key.ctrl.i    equ >0000             ; ctrl + i
0070      0000     key.ctrl.j    equ >0000             ; ctrl + j
0071      0000     key.ctrl.k    equ >0000             ; ctrl + k
0072      0000     key.ctrl.l    equ >0000             ; ctrl + l
0073      0000     key.ctrl.m    equ >0000             ; ctrl + m
0074      0000     key.ctrl.n    equ >0000             ; ctrl + n
0075      0000     key.ctrl.o    equ >0000             ; ctrl + o
0076      0000     key.ctrl.p    equ >0000             ; ctrl + p
0077      0000     key.ctrl.q    equ >0000             ; ctrl + q
0078      0000     key.ctrl.r    equ >0000             ; ctrl + r
0079      9300     key.ctrl.s    equ >9300             ; ctrl + s
0080      9400     key.ctrl.t    equ >9400             ; ctrl + t
0081      0000     key.ctrl.u    equ >0000             ; ctrl + u
0082      0000     key.ctrl.v    equ >0000             ; ctrl + v
0083      0000     key.ctrl.w    equ >0000             ; ctrl + w
0084      9800     key.ctrl.x    equ >9800             ; ctrl + x
0085      0000     key.ctrl.y    equ >0000             ; ctrl + y
0086      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0087               *---------------------------------------------------------------
0088               * Keyboard scancodes - control keys extra
0089               *---------------------------------------------------------------
0090      9D00     key.ctrl.plus equ >9d00             ; ctrl + +
0091               *---------------------------------------------------------------
0092               * Special keys
0093               *---------------------------------------------------------------
0094      0D00     key.enter     equ >0d00             ; enter
0095               
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Action keys mapping table: Editor
0100               *---------------------------------------------------------------
0101               keymap_actions.editor:
0102                       ;-------------------------------------------------------
0103                       ; Movement keys
0104                       ;-------------------------------------------------------
0105 765C 0D00             data  key.enter, txt.enter, edkey.action.enter
     765E 7656 
     7660 654C 
0106 7662 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7664 7480 
     7666 6142 
0107 7668 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     766A 73EA 
     766C 6158 
0108 766E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7670 73F4 
     7672 6170 
0109 7674 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7676 74B2 
     7678 61C2 
0110 767A 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     767C 7548 
     767E 622E 
0111 7680 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7682 757A 
     7684 6246 
0112 7686 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7688 75FC 
     768A 625A 
0113 768C 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     768E 7566 
     7690 62AC 
0114 7692 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7694 7570 
     7696 630C 
0115 7698 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     769A 762E 
     769C 6352 
0116 769E 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     76A0 7606 
     76A2 637E 
0117 76A4 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     76A6 7552 
     76A8 63AE 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 76AA 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     76AC 7372 
     76AE 63EE 
0122 76B0 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     76B2 75AC 
     76B4 6426 
0123 76B6 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     76B8 7386 
     76BA 645A 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 76BC 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     76BE 737C 
     76C0 64B2 
0128 76C2 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     76C4 74D0 
     76C6 65BA 
0129 76C8 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     76CA 739A 
     76CC 6508 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 76CE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     76D0 74DA 
     76D2 660A 
0134 76D4 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     76D6 73C2 
     76D8 6616 
0135 76DA 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     76DC 7642 
     76DE 6634 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 76E0 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     76E2 74E4 
     76E4 6676 
0140 76E6 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     76E8 74EE 
     76EA 667C 
0141 76EC B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     76EE 74F8 
     76F0 6682 
0142 76F2 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     76F4 7502 
     76F6 6688 
0143 76F8 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     76FA 750C 
     76FC 668E 
0144 76FE B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7700 7516 
     7702 6694 
0145 7704 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7706 7520 
     7708 669A 
0146 770A B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     770C 752A 
     770E 66A0 
0147 7710 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7712 7534 
     7714 66A6 
0148 7716 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7718 753E 
     771A 66AC 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 771C FFFF             data  EOL                           ; EOL
0153               
0154               
0155               
0156               
0157               *---------------------------------------------------------------
0158               * Action keys mapping table: Command Buffer (CMDB)
0159               *---------------------------------------------------------------
0160               keymap_actions.cmdb:
0161                       ;-------------------------------------------------------
0162                       ; Movement keys
0163                       ;-------------------------------------------------------
0164 771E 0D00             data  key.enter, txt.enter, edkey.action.enter
     7720 7656 
     7722 654C 
0165 7724 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7726 7480 
     7728 6142 
0166 772A 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     772C 73EA 
     772E 6158 
0167 7730 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     7732 73F4 
     7734 6612 
0168 7736 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     7738 74B2 
     773A 6612 
0169 773C 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     773E 7548 
     7740 622E 
0170 7742 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7744 757A 
     7746 6246 
0171 7748 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     774A 75FC 
     774C 6612 
0172 774E 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     7750 7566 
     7752 6612 
0173 7754 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     7756 7570 
     7758 6612 
0174 775A 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     775C 762E 
     775E 6612 
0175 7760 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     7762 7606 
     7764 6612 
0176 7766 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     7768 7552 
     776A 6612 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 776C 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     776E 7372 
     7770 63EE 
0181 7772 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7774 75AC 
     7776 6426 
0182 7778 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     777A 7386 
     777C 6612 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 777E 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7780 737C 
     7782 64B2 
0187 7784 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7786 74D0 
     7788 65BA 
0188 778A 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     778C 739A 
     778E 6612 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 7790 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7792 74DA 
     7794 660A 
0193 7796 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7798 73C2 
     779A 6616 
0194 779C 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     779E 7642 
     77A0 6634 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 77A2 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     77A4 74E4 
     77A6 6676 
0199 77A8 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     77AA 74EE 
     77AC 667C 
0200 77AE B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     77B0 74F8 
     77B2 6682 
0201 77B4 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     77B6 7502 
     77B8 6688 
0202 77BA B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     77BC 750C 
     77BE 668E 
0203 77C0 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     77C2 7516 
     77C4 6694 
0204 77C6 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     77C8 7520 
     77CA 669A 
0205 77CC B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     77CE 752A 
     77D0 66A0 
0206 77D2 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     77D4 7534 
     77D6 66A6 
0207 77D8 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     77DA 753E 
     77DC 66AC 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 77DE FFFF             data  EOL                           ; EOL
**** **** ****     > tivi_b1.asm.21084
0059               
0063 77E0 77E0                   data $                ; Bank 1 ROM size OK.
0065               
0066               *--------------------------------------------------------------
0067               * Video mode configuration
0068               *--------------------------------------------------------------
0069      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0070      0004     spfbck  equ   >04                   ; Screen background color.
0071      21F6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0072      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0073      0050     colrow  equ   80                    ; Columns per row
0074      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0075      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0076      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0077      2000     sprsat  equ   >2000                 ; VDP sprite attribute table

XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.22880
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2020 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200221-22880
0009               *--------------------------------------------------------------
0010               * A 21th century Programming Editor for the 20th century
0011               * Texas Instruments TI-99/4a Home Computer.
0012               *--------------------------------------------------------------
0013               * TiVi memory layout.
0014               * See file "modules/memory.asm" for further details.
0015               *
0016               * Mem range   Bytes    Hex    Purpose
0017               * =========   =====    ===    ==================================
0018               * 8300-83ff     256   >0100   scrpad spectra2 layout
0019               * 2000-20ff     256   >0100   scrpad backup 1: GPL layout
0020               * 2100-21ff     256   >0100   scrpad backup 2: paged out spectra2
0021               * 2200-227f     128   >0080   TiVi editor structure
0022               * 2280-22ff     128   >0080   TiVi frame buffer structure
0023               * 2300-23ff     256   >0100   TiVi editor buffer structure
0024               * 2400-24ff     256   >0100   TiVi file handling structure
0025               * 2500-25ff     256   >0100   Free for future use
0026               * 2600-264f      80   >0050   Free for future use
0027               * 2650-2faf    2400   >0960   Frame buffer 80x30
0028               * 2fb0-2fff     160   >00a0   Free for future use
0029               * 3000-3fff    4096   >1000   Index 2048 lines
0030               * a000-afff    4096   >1000   Shadow Index 2048 lines
0031               * b000-ffff   20480   >5000   Editor buffer
0032               *--------------------------------------------------------------
0033               * Mem range  Bytes     SAMS   Purpose
0034               * =========  =====     ====   =======
0035               * 2000-2fff   4096     no     Scratchpad/GPL backup, TiVi structures
0036               * 3000-3fff   4096     yes    Main index
0037               * a000-afff   4096     yes    Shadow index
0038               * b000-bfff   4096     yes    Editor buffer \
0039               * c000-cfff   4096     yes    Editor buffer |  20kb continious
0040               * d000-dfff   4096     yes    Editor buffer |  address space.
0041               * e000-efff   4096     yes    Editor buffer |
0042               * f000-ffff   4096     yes    Editor buffer /
0043               *--------------------------------------------------------------
0044               * TiVi VDP layout
0045               *
0046               * Mem range   Bytes    Hex    Purpose
0047               * =========   =====   ====    =================================
0048               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0049               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0050               * 0fc0                        PCT - Pattern Color Table
0051               * 1000                        PDT - Pattern Descriptor Table
0052               * 1800                        SPT - Sprite Pattern Table
0053               * 2000                        SAT - Sprite Attribute List
0054               *--------------------------------------------------------------
0055               * EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
0056               *--------------------------------------------------------------
0057      0001     debug                     equ  1    ; Turn on spectra2 debugging
0058               *--------------------------------------------------------------
0059               * Skip unused spectra2 code modules for reduced code size
0060               *--------------------------------------------------------------
0061      0001     skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
0062      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0063      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0064      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0065      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0066      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0067      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0068      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0069      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0070      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0071      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0072      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0073      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0074      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0075      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0076      0001     skip_random_generator     equ  1    ; Skip random functions
0077      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0078               *--------------------------------------------------------------
0079               * SPECTRA2 startup options
0080               *--------------------------------------------------------------
0081      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0082      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0083      00F4     spfclr                    equ  >f4  ; Foreground/Background color for font.
0084      0004     spfbck                    equ  >04  ; Screen background color.
0085               *--------------------------------------------------------------
0086               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0087               *--------------------------------------------------------------
0088               ;               equ  >8342          ; >8342-834F **free***
0089      8350     parm1           equ  >8350          ; Function parameter 1
0090      8352     parm2           equ  >8352          ; Function parameter 2
0091      8354     parm3           equ  >8354          ; Function parameter 3
0092      8356     parm4           equ  >8356          ; Function parameter 4
0093      8358     parm5           equ  >8358          ; Function parameter 5
0094      835A     parm6           equ  >835a          ; Function parameter 6
0095      835C     parm7           equ  >835c          ; Function parameter 7
0096      835E     parm8           equ  >835e          ; Function parameter 8
0097      8360     outparm1        equ  >8360          ; Function output parameter 1
0098      8362     outparm2        equ  >8362          ; Function output parameter 2
0099      8364     outparm3        equ  >8364          ; Function output parameter 3
0100      8366     outparm4        equ  >8366          ; Function output parameter 4
0101      8368     outparm5        equ  >8368          ; Function output parameter 5
0102      836A     outparm6        equ  >836a          ; Function output parameter 6
0103      836C     outparm7        equ  >836c          ; Function output parameter 7
0104      836E     outparm8        equ  >836e          ; Function output parameter 8
0105      8370     timers          equ  >8370          ; Timer table
0106      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0107      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0108               *--------------------------------------------------------------
0109               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0110               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0111               *--------------------------------------------------------------
0112      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0113      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0114               *--------------------------------------------------------------
0115               * TiVi Editor shared structures     @>2200-227f     (128 bytes)
0116               *--------------------------------------------------------------
0117      2200     tv.top          equ  >2200          ; Structure begin
0118      2200     tv.sams.2000    equ  tv.top + 0     ; SAMS page for memory range >2000-2fff
0119      2202     tv.sams.3000    equ  tv.top + 2     ; SAMS page for memory range >3000-3fff
0120      2204     tv.sams.a000    equ  tv.top + 4     ; SAMS page for memory range >a000-afff
0121      2206     tv.sams.b000    equ  tv.top + 6     ; SAMS page for memory range >b000-bfff
0122      2208     tv.sams.c000    equ  tv.top + 8     ; SAMS page for memory range >c000-cfff
0123      220A     tv.sams.d000    equ  tv.top + 10    ; SAMS page for memory range >d000-dfff
0124      220C     tv.sams.e000    equ  tv.top + 12    ; SAMS page for memory range >e000-efff
0125      220E     tv.sams.f000    equ  tv.top + 14    ; SAMS page for memory range >f000-ffff
0126      2210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0127      2212     tv.end          equ  tv.top + 18    ; End of structure
0128               *--------------------------------------------------------------
0129               * Frame buffer structure            @>2280-22ff     (128 bytes)
0130               *--------------------------------------------------------------
0131      2280     fb.struct       equ  >2280          ; Structure begin
0132      2280     fb.top.ptr      equ  >2280          ; Pointer to frame buffer
0133      2282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0134      2284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0135                                                   ; line X in editor buffer).
0136      2286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0137                                                   ; (offset 0 .. @fb.scrrows)
0138      2288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0139      228A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0140      228C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0141      228E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0142      2290     fb.curshape     equ  fb.struct + 16 ; Cursor shape & colour
0143      2292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0144      2294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0145      2296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0146      2298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0147      229A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0148      229C     fb.end          equ  fb.struct + 28 ; End of structure
0149               *--------------------------------------------------------------
0150               * Editor buffer structure           @>2300-23ff     (256 bytes)
0151               *--------------------------------------------------------------
0152      2300     edb.struct        equ  >2300           ; Begin structure
0153      2300     edb.top.ptr       equ  >2300           ; Pointer to editor buffer
0154      2302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0155      2304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0156      2306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0157      2308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0158      230A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0159      230C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0160      230E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0161                                                      ; with current filename.
0162      2310     edb.sams.page     equ  edb.struct + 16 ; Current SAMS page
0163      2312     edb.end           equ  edb.struct + 18 ; End of structure
0164               *--------------------------------------------------------------
0165               * File handling structures          @>2400-24ff     (256 bytes)
0166               *--------------------------------------------------------------
0167      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0168      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0169      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0170      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB,required by level 2 FIO
0171      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0172      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0173      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0174      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0175      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0176      2434     tfh.counter     equ  tfh.top + 52   ; Counter used in TiVi file operations
0177      2436     tfh.fname.ptr   equ  tfh.top + 54   ; Pointer to device and filename
0178      2438     tfh.sams.page   equ  tfh.top + 56   ; Current SAMS page during file operation
0179      243A     tfh.sams.hpage  equ  tfh.top + 58   ; Highest SAMS page used for file operation
0180      243C     tfh.callback1   equ  tfh.top + 60   ; Pointer to callback function 1
0181      243E     tfh.callback2   equ  tfh.top + 62   ; Pointer to callback function 2
0182      2440     tfh.callback3   equ  tfh.top + 64   ; Pointer to callback function 3
0183      2442     tfh.callback4   equ  tfh.top + 66   ; Pointer to callback function 4
0184      2444     tfh.rleonload   equ  tfh.top + 68   ; RLE compression needed during file load
0185      2446     tfh.membuffer   equ  tfh.top + 70   ; 80 bytes file memory buffer
0186      2496     tfh.end         equ  tfh.top + 150  ; End of structure
0187               
0188      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory
0189      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0190               *--------------------------------------------------------------
0191               * Command buffer structure          @>2500-25ff     (256 bytes)
0192               *--------------------------------------------------------------
0193      2500     cmdb.top        equ  >2500          ; TiVi command buffer structures
0194      2502     cmdb.visible    equ  cmdb.top + 2   ; Command buffer visible? (>ffff = visible)
0195      2504     cmdb.scrrows    equ  cmdb.top + 4   ; Current size of cmdb pane (in rows)
0196      2506     cmdb.default    equ  cmdb.top + 6   ; Default size of cmdb pane (in rows)
0197      2508     cmdb.end        equ  cmdb.top + 8   ; End of structure
0198               *--------------------------------------------------------------
0199               * Free for future use               @>2500-264f     (80 bytes)
0200               *--------------------------------------------------------------
0201      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0202               *--------------------------------------------------------------
0203               * Frame buffer                      @>2650-2fff    (2480 bytes)
0204               *--------------------------------------------------------------
0205      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0206      09B0     fb.size         equ  2480           ; Frame buffer size
0207               *--------------------------------------------------------------
0208               * Index                             @>3000-3fff    (4096 bytes)
0209               *--------------------------------------------------------------
0210      3000     idx.top         equ  >3000          ; Top of index
0211      1000     idx.size        equ  4096           ; Index size
0212               *--------------------------------------------------------------
0213               * SAMS shadow index                 @>a000-afff    (4096 bytes)
0214               *--------------------------------------------------------------
0215      A000     idx.shadow.top  equ  >a000          ; Top of shadow index
0216      1000     idx.shadow.size equ  4096           ; Shadow index size
0217               *--------------------------------------------------------------
0218               * Editor buffer                     @>b000-bfff    (4096 bytes)
0219               *                                   @>c000-cfff    (4096 bytes)
0220               *                                   @>d000-dfff    (4096 bytes)
0221               *                                   @>e000-efff    (4096 bytes)
0222               *                                   @>f000-ffff    (4096 bytes)
0223               *--------------------------------------------------------------
0224      B000     edb.top         equ  >b000          ; Editor buffer high memory
0225      4F9C     edb.size        equ  20380          ; Editor buffer size
0226               *--------------------------------------------------------------
0227               
0228               
0229               *--------------------------------------------------------------
0230               * Cartridge header
0231               *--------------------------------------------------------------
0232                       save  >6000,>7fff
0233                       aorg  >6000
0234               
0235 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0236 6006 6010             data  prog0
0237 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0238 6010 0000     prog0   data  0                     ; No more items following
0239 6012 6D2A             data  runlib
0240               
0242               
0243 6014 1154             byte  17
0244 6015 ....             text  'TIVI 200221-22880'
0245                       even
0246               
0254               
0255               *--------------------------------------------------------------
0256               * Include required files
0257               *--------------------------------------------------------------
0258                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0076                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
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
0077                       copy  "equ_registers.asm"        ; Equates for runlib registers
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
0078                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
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
0079                       copy  "equ_param.asm"            ; Equates for runlib parameters
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
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants & equates for word/MSB/LSB
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
0012 6026 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 6028 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 602A 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 602C 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 602E 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6030 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6032 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6034 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 6036 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 6038 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 603A 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 603C 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 603E 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6040 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6042 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6044 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 6046 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 6048 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 604A D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      6026     hb$00   equ   w$0000                ; >0000
0035      6038     hb$01   equ   w$0100                ; >0100
0036      603A     hb$02   equ   w$0200                ; >0200
0037      603C     hb$04   equ   w$0400                ; >0400
0038      603E     hb$08   equ   w$0800                ; >0800
0039      6040     hb$10   equ   w$1000                ; >1000
0040      6042     hb$20   equ   w$2000                ; >2000
0041      6044     hb$40   equ   w$4000                ; >4000
0042      6046     hb$80   equ   w$8000                ; >8000
0043      604A     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      6026     lb$00   equ   w$0000                ; >0000
0048      6028     lb$01   equ   w$0001                ; >0001
0049      602A     lb$02   equ   w$0002                ; >0002
0050      602C     lb$04   equ   w$0004                ; >0004
0051      602E     lb$08   equ   w$0008                ; >0008
0052      6030     lb$10   equ   w$0010                ; >0010
0053      6032     lb$20   equ   w$0020                ; >0020
0054      6034     lb$40   equ   w$0040                ; >0040
0055      6036     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      6028     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      602A     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      602C     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      602E     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      6030     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      6032     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      6034     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      6036     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      6038     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      603A     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      603C     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      603E     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      6040     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      6042     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      6044     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      6046     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      6042     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6038     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6034     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6030     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0038 604C 022B  22         ai    r11,-4                ; Remove opcode offset
     604E FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 6050 C800  38         mov   r0,@>ffe0
     6052 FFE0 
0043 6054 C801  38         mov   r1,@>ffe2
     6056 FFE2 
0044 6058 C802  38         mov   r2,@>ffe4
     605A FFE4 
0045 605C C803  38         mov   r3,@>ffe6
     605E FFE6 
0046 6060 C804  38         mov   r4,@>ffe8
     6062 FFE8 
0047 6064 C805  38         mov   r5,@>ffea
     6066 FFEA 
0048 6068 C806  38         mov   r6,@>ffec
     606A FFEC 
0049 606C C807  38         mov   r7,@>ffee
     606E FFEE 
0050 6070 C808  38         mov   r8,@>fff0
     6072 FFF0 
0051 6074 C809  38         mov   r9,@>fff2
     6076 FFF2 
0052 6078 C80A  38         mov   r10,@>fff4
     607A FFF4 
0053 607C C80B  38         mov   r11,@>fff6
     607E FFF6 
0054 6080 C80C  38         mov   r12,@>fff8
     6082 FFF8 
0055 6084 C80D  38         mov   r13,@>fffa
     6086 FFFA 
0056 6088 C80E  38         mov   r14,@>fffc
     608A FFFC 
0057 608C C80F  38         mov   r15,@>ffff
     608E FFFF 
0058 6090 02A0  12         stwp  r0
0059 6092 C800  38         mov   r0,@>ffdc
     6094 FFDC 
0060 6096 02C0  12         stst  r0
0061 6098 C800  38         mov   r0,@>ffde
     609A FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 609C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     609E 8300 
0067 60A0 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60A2 8302 
0068 60A4 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60A6 4A4A 
0069 60A8 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60AA 6D32 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 60AC 06A0  32         bl    @putat                ; Show crash message
     60AE 642A 
0078 60B0 0000                   data >0000,cpu.crash.msg.crashed
     60B2 6186 
0079               
0080 60B4 06A0  32         bl    @puthex               ; Put hex value on screen
     60B6 6960 
0081 60B8 0015                   byte 0,21             ; \ i  p0 = YX position
0082 60BA FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 60BC 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 60BE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 60C0 06A0  32         bl    @putat                ; Show caller message
     60C2 642A 
0090 60C4 0100                   data >0100,cpu.crash.msg.caller
     60C6 619C 
0091               
0092 60C8 06A0  32         bl    @puthex               ; Put hex value on screen
     60CA 6960 
0093 60CC 0115                   byte 1,21             ; \ i  p0 = YX position
0094 60CE FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 60D0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 60D2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 60D4 06A0  32         bl    @putat
     60D6 642A 
0102 60D8 0300                   byte 3,0
0103 60DA 61B6                   data cpu.crash.msg.wp
0104 60DC 06A0  32         bl    @putat
     60DE 642A 
0105 60E0 0400                   byte 4,0
0106 60E2 61BC                   data cpu.crash.msg.st
0107 60E4 06A0  32         bl    @putat
     60E6 642A 
0108 60E8 1600                   byte 22,0
0109 60EA 61C2                   data cpu.crash.msg.source
0110 60EC 06A0  32         bl    @putat
     60EE 642A 
0111 60F0 1700                   byte 23,0
0112 60F2 61DA                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 60F4 06A0  32         bl    @at                   ; Put cursor at YX
     60F6 6668 
0117 60F8 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 60FA 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     60FC FFDC 
0121 60FE 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 6100 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 6102 0649  14         dect  stack
0127 6104 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 6106 0649  14         dect  stack
0129 6108 C645  30         mov   tmp1,*stack           ; Push tmp1
0130 610A 0649  14         dect  stack
0131 610C C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 610E C046  18         mov   tmp2,r1               ; Save register number
0137 6110 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6112 0001 
0138 6114 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 6116 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 6118 06A0  32         bl    @mknum
     611A 696A 
0143 611C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 611E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 6120 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 6122 06A0  32         bl    @setx                 ; Set cursor X position
     6124 667E 
0149 6126 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 6128 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     612A 6418 
0153 612C 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 612E 06A0  32         bl    @setx                 ; Set cursor X position
     6130 667E 
0157 6132 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 6134 0281  22         ci    r1,10
     6136 000A 
0161 6138 1102  14         jlt   !
0162 613A 0620  34         dec   @wyx                  ; x=x-1
     613C 832A 
0163               
0164 613E 06A0  32 !       bl    @putstr
     6140 6418 
0165 6142 61B2                   data cpu.crash.msg.r
0166               
0167 6144 06A0  32         bl    @mknum
     6146 696A 
0168 6148 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 614A 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 614C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 614E 06A0  32         bl    @mkhex                ; Convert hex word to string
     6150 68DC 
0177 6152 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 6154 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 6156 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 667E 
0183 615C 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 615E 06A0  32         bl    @putstr
     6160 6418 
0187 6162 61B4                   data cpu.crash.msg.marker
0188               
0189 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 667E 
0190 6168 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 616A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     616C 6418 
0194 616E 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 6170 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 6172 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 6174 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 6176 06A0  32         bl    @down                 ; y=y+1
     6178 666E 
0202               
0203 617A 0586  14         inc   tmp2
0204 617C 0286  22         ci    tmp2,17
     617E 0011 
0205 6180 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 6182 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6184 6C40 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 6186 1553             byte  21
0214 6187 ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 619C 1543             byte  21
0219 619D ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 61B2 0152             byte  1
0224 61B3 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 61B4 013E             byte  1
0229 61B5 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 61B6 042A             byte  4
0234 61B7 ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 61BC 042A             byte  4
0239 61BD ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 61C2 1653             byte  22
0244 61C3 ....             text  'Source    tivi.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 61DA 1642             byte  22
0249 61DB ....             text  'Build-ID  200221-22880'
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
0007 61F2 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     61F4 000E 
     61F6 0106 
     61F8 0204 
     61FA 0020 
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
0032 61FC 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     61FE 000E 
     6200 0106 
     6202 00F4 
     6204 0028 
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
0058 6206 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6208 003F 
     620A 0240 
     620C 03F4 
     620E 0050 
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
0084 6210 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6212 003F 
     6214 0240 
     6216 03F4 
     6218 0050 
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
0013 621A 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 621C 16FD             data  >16fd                 ; |         jne   mcloop
0015 621E 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6220 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6222 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6224 C0F9  30 popr3   mov   *stack+,r3
0039 6226 C0B9  30 popr2   mov   *stack+,r2
0040 6228 C079  30 popr1   mov   *stack+,r1
0041 622A C039  30 popr0   mov   *stack+,r0
0042 622C C2F9  30 poprt   mov   *stack+,r11
0043 622E 045B  20         b     *r11
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
0067 6230 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6232 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6234 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 6236 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 6238 1604  14         jne   filchk                ; No, continue checking
0075               
0076 623A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     623C FFCE 
0077 623E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6240 604C 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 6242 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6244 830B 
     6246 830A 
0082               
0083 6248 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     624A 0001 
0084 624C 1602  14         jne   filchk2
0085 624E DD05  32         movb  tmp1,*tmp0+
0086 6250 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 6252 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6254 0002 
0091 6256 1603  14         jne   filchk3
0092 6258 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 625A DD05  32         movb  tmp1,*tmp0+
0094 625C 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 625E C1C4  18 filchk3 mov   tmp0,tmp3
0099 6260 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6262 0001 
0100 6264 1605  14         jne   fil16b
0101 6266 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 6268 0606  14         dec   tmp2
0103 626A 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     626C 0002 
0104 626E 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 6270 C1C6  18 fil16b  mov   tmp2,tmp3
0109 6272 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6274 0001 
0110 6276 1301  14         jeq   dofill
0111 6278 0606  14         dec   tmp2                  ; Make TMP2 even
0112 627A CD05  34 dofill  mov   tmp1,*tmp0+
0113 627C 0646  14         dect  tmp2
0114 627E 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 6280 C1C7  18         mov   tmp3,tmp3
0119 6282 1301  14         jeq   fil.$$
0120 6284 DD05  32         movb  tmp1,*tmp0+
0121 6286 045B  20 fil.$$  b     *r11
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
0140 6288 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 628A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 628C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 628E 0264  22 xfilv   ori   tmp0,>4000
     6290 4000 
0147 6292 06C4  14         swpb  tmp0
0148 6294 D804  38         movb  tmp0,@vdpa
     6296 8C02 
0149 6298 06C4  14         swpb  tmp0
0150 629A D804  38         movb  tmp0,@vdpa
     629C 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 629E 020F  20         li    r15,vdpw              ; Set VDP write address
     62A0 8C00 
0155 62A2 06C5  14         swpb  tmp1
0156 62A4 C820  54         mov   @filzz,@mcloop        ; Setup move command
     62A6 62AE 
     62A8 8320 
0157 62AA 0460  28         b     @mcloop               ; Write data to VDP
     62AC 8320 
0158               *--------------------------------------------------------------
0162 62AE D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 62B0 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62B2 4000 
0183 62B4 06C4  14 vdra    swpb  tmp0
0184 62B6 D804  38         movb  tmp0,@vdpa
     62B8 8C02 
0185 62BA 06C4  14         swpb  tmp0
0186 62BC D804  38         movb  tmp0,@vdpa            ; Set VDP address
     62BE 8C02 
0187 62C0 045B  20         b     *r11                  ; Exit
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
0198 62C2 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 62C4 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 62C6 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     62C8 4000 
0204 62CA 06C4  14         swpb  tmp0                  ; \
0205 62CC D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     62CE 8C02 
0206 62D0 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 62D2 D804  38         movb  tmp0,@vdpa            ; /
     62D4 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 62D6 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 62D8 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 62DA 045B  20         b     *r11                  ; Exit
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
0232 62DC C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 62DE 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 62E0 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     62E2 8C02 
0238 62E4 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 62E6 D804  38         movb  tmp0,@vdpa            ; /
     62E8 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 62EA D120  34         movb  @vdpr,tmp0            ; Read byte
     62EC 8800 
0244 62EE 0984  56         srl   tmp0,8                ; Right align
0245 62F0 045B  20         b     *r11                  ; Exit
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
0264 62F2 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 62F4 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 62F6 C144  18         mov   tmp0,tmp1
0270 62F8 05C5  14         inct  tmp1
0271 62FA D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 62FC 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     62FE FF00 
0273 6300 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 6302 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6304 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 6306 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6308 8000 
0279 630A 0206  20         li    tmp2,8
     630C 0008 
0280 630E D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6310 830B 
0281 6312 06C5  14         swpb  tmp1
0282 6314 D805  38         movb  tmp1,@vdpa
     6316 8C02 
0283 6318 06C5  14         swpb  tmp1
0284 631A D805  38         movb  tmp1,@vdpa
     631C 8C02 
0285 631E 0225  22         ai    tmp1,>0100
     6320 0100 
0286 6322 0606  14         dec   tmp2
0287 6324 16F4  14         jne   vidta1                ; Next register
0288 6326 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6328 833A 
0289 632A 045B  20         b     *r11
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
0306 632C C13B  30 putvr   mov   *r11+,tmp0
0307 632E 0264  22 putvrx  ori   tmp0,>8000
     6330 8000 
0308 6332 06C4  14         swpb  tmp0
0309 6334 D804  38         movb  tmp0,@vdpa
     6336 8C02 
0310 6338 06C4  14         swpb  tmp0
0311 633A D804  38         movb  tmp0,@vdpa
     633C 8C02 
0312 633E 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 6340 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 6342 C10E  18         mov   r14,tmp0
0322 6344 0984  56         srl   tmp0,8
0323 6346 06A0  32         bl    @putvrx               ; Write VR#0
     6348 632E 
0324 634A 0204  20         li    tmp0,>0100
     634C 0100 
0325 634E D820  54         movb  @r14lb,@tmp0lb
     6350 831D 
     6352 8309 
0326 6354 06A0  32         bl    @putvrx               ; Write VR#1
     6356 632E 
0327 6358 0458  20         b     *tmp4                 ; Exit
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
0341 635A C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 635C 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 635E C11B  26         mov   *r11,tmp0             ; Get P0
0344 6360 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6362 7FFF 
0345 6364 2120  38         coc   @wbit0,tmp0
     6366 6046 
0346 6368 1604  14         jne   ldfnt1
0347 636A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     636C 8000 
0348 636E 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6370 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 6372 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6374 63DC 
0353 6376 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6378 9C02 
0354 637A 06C4  14         swpb  tmp0
0355 637C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     637E 9C02 
0356 6380 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6382 9800 
0357 6384 06C5  14         swpb  tmp1
0358 6386 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6388 9800 
0359 638A 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 638C D805  38         movb  tmp1,@grmwa
     638E 9C02 
0364 6390 06C5  14         swpb  tmp1
0365 6392 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6394 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 6396 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 6398 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     639A 62B0 
0371 639C 05C8  14         inct  tmp4                  ; R11=R11+2
0372 639E C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 63A0 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63A2 7FFF 
0374 63A4 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63A6 63DE 
0375 63A8 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     63AA 63E0 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 63AC 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 63AE 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 63B0 D120  34         movb  @grmrd,tmp0
     63B2 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 63B4 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63B6 6046 
0386 63B8 1603  14         jne   ldfnt3                ; No, so skip
0387 63BA D1C4  18         movb  tmp0,tmp3
0388 63BC 0917  56         srl   tmp3,1
0389 63BE E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 63C0 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     63C2 8C00 
0394 63C4 0606  14         dec   tmp2
0395 63C6 16F2  14         jne   ldfnt2
0396 63C8 05C8  14         inct  tmp4                  ; R11=R11+2
0397 63CA 020F  20         li    r15,vdpw              ; Set VDP write address
     63CC 8C00 
0398 63CE 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63D0 7FFF 
0399 63D2 0458  20         b     *tmp4                 ; Exit
0400 63D4 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     63D6 6026 
     63D8 8C00 
0401 63DA 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 63DC 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     63DE 0200 
     63E0 0000 
0406 63E2 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     63E4 01C0 
     63E6 0101 
0407 63E8 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     63EA 02A0 
     63EC 0101 
0408 63EE 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     63F0 00E0 
     63F2 0101 
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
0426 63F4 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 63F6 C3A0  34         mov   @wyx,r14              ; Get YX
     63F8 832A 
0428 63FA 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 63FC 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     63FE 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 6400 C3A0  34         mov   @wyx,r14              ; Get YX
     6402 832A 
0435 6404 024E  22         andi  r14,>00ff             ; Remove Y
     6406 00FF 
0436 6408 A3CE  18         a     r14,r15               ; pos = pos + X
0437 640A A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     640C 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 640E C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 6410 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6412 020F  20         li    r15,vdpw              ; VDP write address
     6414 8C00 
0444 6416 045B  20         b     *r11
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
0459 6418 C17B  30 putstr  mov   *r11+,tmp1
0460 641A D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 641C C1CB  18 xutstr  mov   r11,tmp3
0462 641E 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6420 63F4 
0463 6422 C2C7  18         mov   tmp3,r11
0464 6424 0986  56         srl   tmp2,8                ; Right justify length byte
0465 6426 0460  28         b     @xpym2v               ; Display string
     6428 6438 
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
0480 642A C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     642C 832A 
0481 642E 0460  28         b     @putstr
     6430 6418 
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
0020 6432 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6434 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6436 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6438 0264  22 xpym2v  ori   tmp0,>4000
     643A 4000 
0027 643C 06C4  14         swpb  tmp0
0028 643E D804  38         movb  tmp0,@vdpa
     6440 8C02 
0029 6442 06C4  14         swpb  tmp0
0030 6444 D804  38         movb  tmp0,@vdpa
     6446 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6448 020F  20         li    r15,vdpw              ; Set VDP write address
     644A 8C00 
0035 644C C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     644E 6456 
     6450 8320 
0036 6452 0460  28         b     @mcloop               ; Write data to VDP
     6454 8320 
0037 6456 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6458 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 645A C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 645C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 645E 06C4  14 xpyv2m  swpb  tmp0
0027 6460 D804  38         movb  tmp0,@vdpa
     6462 8C02 
0028 6464 06C4  14         swpb  tmp0
0029 6466 D804  38         movb  tmp0,@vdpa
     6468 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 646A 020F  20         li    r15,vdpr              ; Set VDP read address
     646C 8800 
0034 646E C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6470 6478 
     6472 8320 
0035 6474 0460  28         b     @mcloop               ; Read data from VDP
     6476 8320 
0036 6478 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 647A C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 647C C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 647E C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6480 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6482 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6484 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6486 FFCE 
0034 6488 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     648A 604C 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 648C 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     648E 0001 
0039 6490 1603  14         jne   cpym0                 ; No, continue checking
0040 6492 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6494 04C6  14         clr   tmp2                  ; Reset counter
0042 6496 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6498 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     649A 7FFF 
0047 649C C1C4  18         mov   tmp0,tmp3
0048 649E 0247  22         andi  tmp3,1
     64A0 0001 
0049 64A2 1618  14         jne   cpyodd                ; Odd source address handling
0050 64A4 C1C5  18 cpym1   mov   tmp1,tmp3
0051 64A6 0247  22         andi  tmp3,1
     64A8 0001 
0052 64AA 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 64AC 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     64AE 6046 
0057 64B0 1605  14         jne   cpym3
0058 64B2 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     64B4 64DA 
     64B6 8320 
0059 64B8 0460  28         b     @mcloop               ; Copy memory and exit
     64BA 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 64BC C1C6  18 cpym3   mov   tmp2,tmp3
0064 64BE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     64C0 0001 
0065 64C2 1301  14         jeq   cpym4
0066 64C4 0606  14         dec   tmp2                  ; Make TMP2 even
0067 64C6 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 64C8 0646  14         dect  tmp2
0069 64CA 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 64CC C1C7  18         mov   tmp3,tmp3
0074 64CE 1301  14         jeq   cpymz
0075 64D0 D554  38         movb  *tmp0,*tmp1
0076 64D2 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 64D4 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     64D6 8000 
0081 64D8 10E9  14         jmp   cpym2
0082 64DA DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0106               
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory expansion card
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
0062 64DC C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 64DE 0649  14         dect  stack
0065 64E0 C64B  30         mov   r11,*stack            ; Push return address
0066 64E2 0649  14         dect  stack
0067 64E4 C640  30         mov   r0,*stack             ; Push r0
0068 64E6 0649  14         dect  stack
0069 64E8 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 64EA 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 64EC 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 64EE 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     64F0 4000 
0077 64F2 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     64F4 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 64F6 020C  20         li    r12,>1e00             ; SAMS CRU address
     64F8 1E00 
0082 64FA 04C0  14         clr   r0
0083 64FC 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 64FE D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 6500 D100  18         movb  r0,tmp0
0086 6502 0984  56         srl   tmp0,8                ; Right align
0087 6504 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     6506 833C 
0088 6508 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 650A C339  30         mov   *stack+,r12           ; Pop r12
0094 650C C039  30         mov   *stack+,r0            ; Pop r0
0095 650E C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6510 045B  20         b     *r11                  ; Return to caller
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
0131 6512 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6514 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6516 0649  14         dect  stack
0135 6518 C64B  30         mov   r11,*stack            ; Push return address
0136 651A 0649  14         dect  stack
0137 651C C640  30         mov   r0,*stack             ; Push r0
0138 651E 0649  14         dect  stack
0139 6520 C64C  30         mov   r12,*stack            ; Push r12
0140 6522 0649  14         dect  stack
0141 6524 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6526 0649  14         dect  stack
0143 6528 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 652A 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 652C 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 652E 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6530 001E 
0153 6532 150A  14         jgt   !
0154 6534 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     6536 0004 
0155 6538 1107  14         jlt   !
0156 653A 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     653C 0012 
0157 653E 1508  14         jgt   sams.page.set.switch_page
0158 6540 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6542 0006 
0159 6544 1501  14         jgt   !
0160 6546 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 6548 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     654A FFCE 
0165 654C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     654E 604C 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 6550 020C  20         li    r12,>1e00             ; SAMS CRU address
     6552 1E00 
0171 6554 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 6556 06C0  14         swpb  r0                    ; LSB to MSB
0173 6558 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 655A D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     655C 4000 
0175 655E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 6560 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 6562 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 6564 C339  30         mov   *stack+,r12           ; Pop r12
0183 6566 C039  30         mov   *stack+,r0            ; Pop r0
0184 6568 C2F9  30         mov   *stack+,r11           ; Pop return address
0185 656A 045B  20         b     *r11                  ; Return to caller
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
0199 656C 020C  20         li    r12,>1e00             ; SAMS CRU address
     656E 1E00 
0200 6570 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 6572 045B  20         b     *r11                  ; Return to caller
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
0222 6574 020C  20         li    r12,>1e00             ; SAMS CRU address
     6576 1E00 
0223 6578 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 657A 045B  20         b     *r11                  ; Return to caller
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
0255 657C C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 657E 0649  14         dect  stack
0258 6580 C64B  30         mov   r11,*stack            ; Save return address
0259 6582 0649  14         dect  stack
0260 6584 C644  30         mov   tmp0,*stack           ; Save tmp0
0261 6586 0649  14         dect  stack
0262 6588 C645  30         mov   tmp1,*stack           ; Save tmp1
0263 658A 0649  14         dect  stack
0264 658C C646  30         mov   tmp2,*stack           ; Save tmp2
0265 658E 0649  14         dect  stack
0266 6590 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 6592 0206  20         li    tmp2,8                ; Set loop counter
     6594 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 6596 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 6598 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 659A 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     659C 6516 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 659E 0606  14         dec   tmp2                  ; Next iteration
0283 65A0 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 65A2 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     65A4 656C 
0289                                                   ; / activating changes.
0290               
0291 65A6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 65A8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 65AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 65AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 65AE C2F9  30         mov   *stack+,r11           ; Pop r11
0296 65B0 045B  20         b     *r11                  ; Return to caller
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
0313 65B2 0649  14         dect  stack
0314 65B4 C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 65B6 06A0  32         bl    @sams.layout
     65B8 657C 
0319 65BA 65C0                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.layout.exit:
0324 65BC C2F9  30         mov   *stack+,r11           ; Pop r11
0325 65BE 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 65C0 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     65C2 0002 
0331 65C4 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     65C6 0003 
0332 65C8 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     65CA 000A 
0333 65CC B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     65CE 000B 
0334 65D0 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     65D2 000C 
0335 65D4 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     65D6 000D 
0336 65D8 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     65DA 000E 
0337 65DC F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     65DE 000F 
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
0358 65E0 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 65E2 0649  14         dect  stack
0361 65E4 C64B  30         mov   r11,*stack            ; Push return address
0362 65E6 0649  14         dect  stack
0363 65E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0364 65EA 0649  14         dect  stack
0365 65EC C645  30         mov   tmp1,*stack           ; Push tmp1
0366 65EE 0649  14         dect  stack
0367 65F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 65F2 0649  14         dect  stack
0369 65F4 C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 65F6 0205  20         li    tmp1,sams.copy.layout.data
     65F8 6618 
0374 65FA 0206  20         li    tmp2,8                ; Set loop counter
     65FC 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.copy.layout.loop:
0379 65FE C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 6600 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     6602 64DE 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 6604 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6606 833C 
0385               
0386 6608 0606  14         dec   tmp2                  ; Next iteration
0387 660A 16F9  14         jne   sams.copy.layout.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.copy.layout.exit:
0392 660C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 660E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 6610 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 6612 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 6614 C2F9  30         mov   *stack+,r11           ; Pop r11
0397 6616 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS standard page layout table (8 words)
0400               *--------------------------------------------------------------
0401               sams.copy.layout.data:
0402 6618 2000             data  >2000                 ; >2000-2fff
0403 661A 3000             data  >3000                 ; >3000-3fff
0404 661C A000             data  >a000                 ; >a000-afff
0405 661E B000             data  >b000                 ; >b000-bfff
0406 6620 C000             data  >c000                 ; >c000-cfff
0407 6622 D000             data  >d000                 ; >d000-dfff
0408 6624 E000             data  >e000                 ; >e000-efff
0409 6626 F000             data  >f000                 ; >f000-ffff
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
0009 6628 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     662A FFBF 
0010 662C 0460  28         b     @putv01
     662E 6340 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6630 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6632 0040 
0018 6634 0460  28         b     @putv01
     6636 6340 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6638 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     663A FFDF 
0026 663C 0460  28         b     @putv01
     663E 6340 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6640 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6642 0020 
0034 6644 0460  28         b     @putv01
     6646 6340 
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
0010 6648 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     664A FFFE 
0011 664C 0460  28         b     @putv01
     664E 6340 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6650 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6652 0001 
0019 6654 0460  28         b     @putv01
     6656 6340 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6658 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     665A FFFD 
0027 665C 0460  28         b     @putv01
     665E 6340 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6660 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6662 0002 
0035 6664 0460  28         b     @putv01
     6666 6340 
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
0018 6668 C83B  50 at      mov   *r11+,@wyx
     666A 832A 
0019 666C 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 666E B820  54 down    ab    @hb$01,@wyx
     6670 6038 
     6672 832A 
0028 6674 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6676 7820  54 up      sb    @hb$01,@wyx
     6678 6038 
     667A 832A 
0037 667C 045B  20         b     *r11
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
0049 667E C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6680 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6682 832A 
0051 6684 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6686 832A 
0052 6688 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0021 668A C120  34 yx2px   mov   @wyx,tmp0
     668C 832A 
0022 668E C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6690 06C4  14         swpb  tmp0                  ; Y<->X
0024 6692 04C5  14         clr   tmp1                  ; Clear before copy
0025 6694 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6696 20A0  38         coc   @wbit1,config         ; f18a present ?
     6698 6044 
0030 669A 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 669C 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     669E 833A 
     66A0 66CA 
0032 66A2 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 66A4 0A15  56         sla   tmp1,1                ; X = X * 2
0035 66A6 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 66A8 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     66AA 0500 
0037 66AC 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 66AE D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 66B0 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 66B2 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 66B4 D105  18         movb  tmp1,tmp0
0051 66B6 06C4  14         swpb  tmp0                  ; X<->Y
0052 66B8 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     66BA 6046 
0053 66BC 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 66BE 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     66C0 6038 
0059 66C2 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     66C4 604A 
0060 66C6 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 66C8 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 66CA 0050            data   80
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
0013 66CC C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 66CE 06A0  32         bl    @putvr                ; Write once
     66D0 632C 
0015 66D2 391C             data  >391c                 ; VR1/57, value 00011100
0016 66D4 06A0  32         bl    @putvr                ; Write twice
     66D6 632C 
0017 66D8 391C             data  >391c                 ; VR1/57, value 00011100
0018 66DA 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 66DC C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 66DE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     66E0 632C 
0028 66E2 391C             data  >391c
0029 66E4 0458  20         b     *tmp4                 ; Exit
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
0040 66E6 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 66E8 06A0  32         bl    @cpym2v
     66EA 6432 
0042 66EC 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     66EE 672A 
     66F0 0006 
0043 66F2 06A0  32         bl    @putvr
     66F4 632C 
0044 66F6 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 66F8 06A0  32         bl    @putvr
     66FA 632C 
0046 66FC 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 66FE 0204  20         li    tmp0,>3f00
     6700 3F00 
0052 6702 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6704 62B4 
0053 6706 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6708 8800 
0054 670A 0984  56         srl   tmp0,8
0055 670C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     670E 8800 
0056 6710 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6712 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6714 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6716 BFFF 
0060 6718 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 671A 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     671C 4000 
0063               f18chk_exit:
0064 671E 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6720 6288 
0065 6722 3F00             data  >3f00,>00,6
     6724 0000 
     6726 0006 
0066 6728 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 672A 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 672C 3F00             data  >3f00                 ; 3f02 / 3f00
0073 672E 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6730 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6732 06A0  32         bl    @putvr
     6734 632C 
0097 6736 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6738 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     673A 632C 
0100 673C 391C             data  >391c                 ; Lock the F18a
0101 673E 0458  20         b     *tmp4                 ; Exit
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
0120 6740 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 6742 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6744 6044 
0122 6746 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6748 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     674A 8802 
0127 674C 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     674E 632C 
0128 6750 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6752 04C4  14         clr   tmp0
0130 6754 D120  34         movb  @vdps,tmp0
     6756 8802 
0131 6758 0984  56         srl   tmp0,8
0132 675A 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 675C C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     675E 832A 
0018 6760 D17B  28         movb  *r11+,tmp1
0019 6762 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6764 D1BB  28         movb  *r11+,tmp2
0021 6766 0986  56         srl   tmp2,8                ; Repeat count
0022 6768 C1CB  18         mov   r11,tmp3
0023 676A 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     676C 63F4 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 676E 020B  20         li    r11,hchar1
     6770 6776 
0028 6772 0460  28         b     @xfilv                ; Draw
     6774 628E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6776 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6778 6048 
0033 677A 1302  14         jeq   hchar2                ; Yes, exit
0034 677C C2C7  18         mov   tmp3,r11
0035 677E 10EE  14         jmp   hchar                 ; Next one
0036 6780 05C7  14 hchar2  inct  tmp3
0037 6782 0457  20         b     *tmp3                 ; Exit
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
0016 6784 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6786 6046 
0017 6788 020C  20         li    r12,>0024
     678A 0024 
0018 678C 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     678E 681C 
0019 6790 04C6  14         clr   tmp2
0020 6792 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6794 04CC  14         clr   r12
0025 6796 1F08  20         tb    >0008                 ; Shift-key ?
0026 6798 1302  14         jeq   realk1                ; No
0027 679A 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     679C 684C 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 679E 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 67A0 1302  14         jeq   realk2                ; No
0033 67A2 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     67A4 687C 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 67A6 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 67A8 1302  14         jeq   realk3                ; No
0039 67AA 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     67AC 68AC 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 67AE 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 67B0 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 67B2 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 67B4 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     67B6 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 67B8 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 67BA 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     67BC 0006 
0052 67BE 0606  14 realk5  dec   tmp2
0053 67C0 020C  20         li    r12,>24               ; CRU address for P2-P4
     67C2 0024 
0054 67C4 06C6  14         swpb  tmp2
0055 67C6 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 67C8 06C6  14         swpb  tmp2
0057 67CA 020C  20         li    r12,6                 ; CRU read address
     67CC 0006 
0058 67CE 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 67D0 0547  14         inv   tmp3                  ;
0060 67D2 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     67D4 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 67D6 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 67D8 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 67DA 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 67DC 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 67DE 0285  22         ci    tmp1,8
     67E0 0008 
0069 67E2 1AFA  14         jl    realk6
0070 67E4 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 67E6 1BEB  14         jh    realk5                ; No, next column
0072 67E8 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 67EA C206  18 realk8  mov   tmp2,tmp4
0077 67EC 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 67EE A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 67F0 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 67F2 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 67F4 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 67F6 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 67F8 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     67FA 6046 
0087 67FC 1608  14         jne   realka                ; No, continue saving key
0088 67FE 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6800 6846 
0089 6802 1A05  14         jl    realka
0090 6804 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6806 6844 
0091 6808 1B02  14         jh    realka                ; No, continue
0092 680A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     680C E000 
0093 680E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6810 833C 
0094 6812 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6814 6030 
0095 6816 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6818 8C00 
0096 681A 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 681C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     681E 0000 
     6820 FF0D 
     6822 203D 
0099 6824 ....             text  'xws29ol.'
0100 682C ....             text  'ced38ik,'
0101 6834 ....             text  'vrf47ujm'
0102 683C ....             text  'btg56yhn'
0103 6844 ....             text  'zqa10p;/'
0104 684C FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     684E 0000 
     6850 FF0D 
     6852 202B 
0105 6854 ....             text  'XWS@(OL>'
0106 685C ....             text  'CED#*IK<'
0107 6864 ....             text  'VRF$&UJM'
0108 686C ....             text  'BTG%^YHN'
0109 6874 ....             text  'ZQA!)P:-'
0110 687C FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     687E 0000 
     6880 FF0D 
     6882 2005 
0111 6884 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6886 0804 
     6888 0F27 
     688A C2B9 
0112 688C 600B             data  >600b,>0907,>063f,>c1B8
     688E 0907 
     6890 063F 
     6892 C1B8 
0113 6894 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6896 7B02 
     6898 015F 
     689A C0C3 
0114 689C BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     689E 7D0E 
     68A0 0CC6 
     68A2 BFC4 
0115 68A4 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     68A6 7C03 
     68A8 BC22 
     68AA BDBA 
0116 68AC FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     68AE 0000 
     68B0 FF0D 
     68B2 209D 
0117 68B4 9897             data  >9897,>93b2,>9f8f,>8c9B
     68B6 93B2 
     68B8 9F8F 
     68BA 8C9B 
0118 68BC 8385             data  >8385,>84b3,>9e89,>8b80
     68BE 84B3 
     68C0 9E89 
     68C2 8B80 
0119 68C4 9692             data  >9692,>86b4,>b795,>8a8D
     68C6 86B4 
     68C8 B795 
     68CA 8A8D 
0120 68CC 8294             data  >8294,>87b5,>b698,>888E
     68CE 87B5 
     68D0 B698 
     68D2 888E 
0121 68D4 9A91             data  >9a91,>81b1,>b090,>9cBB
     68D6 81B1 
     68D8 B090 
     68DA 9CBB 
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
0023 68DC C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 68DE C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     68E0 8340 
0025 68E2 04E0  34         clr   @waux1
     68E4 833C 
0026 68E6 04E0  34         clr   @waux2
     68E8 833E 
0027 68EA 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     68EC 833C 
0028 68EE C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 68F0 0205  20         li    tmp1,4                ; 4 nibbles
     68F2 0004 
0033 68F4 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 68F6 0246  22         andi  tmp2,>000f            ; Only keep LSN
     68F8 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 68FA 0286  22         ci    tmp2,>000a
     68FC 000A 
0039 68FE 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6900 C21B  26         mov   *r11,tmp4
0045 6902 0988  56         srl   tmp4,8                ; Right justify
0046 6904 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6906 FFF6 
0047 6908 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 690A C21B  26         mov   *r11,tmp4
0054 690C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     690E 00FF 
0055               
0056 6910 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6912 06C6  14         swpb  tmp2
0058 6914 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6916 0944  56         srl   tmp0,4                ; Next nibble
0060 6918 0605  14         dec   tmp1
0061 691A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 691C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     691E BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6920 C160  34         mov   @waux3,tmp1           ; Get pointer
     6922 8340 
0067 6924 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6926 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6928 C120  34         mov   @waux2,tmp0
     692A 833E 
0070 692C 06C4  14         swpb  tmp0
0071 692E DD44  32         movb  tmp0,*tmp1+
0072 6930 06C4  14         swpb  tmp0
0073 6932 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6934 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6936 8340 
0078 6938 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     693A 603C 
0079 693C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 693E C120  34         mov   @waux1,tmp0
     6940 833C 
0084 6942 06C4  14         swpb  tmp0
0085 6944 DD44  32         movb  tmp0,*tmp1+
0086 6946 06C4  14         swpb  tmp0
0087 6948 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 694A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     694C 6046 
0092 694E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6950 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6952 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6954 7FFF 
0098 6956 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6958 8340 
0099 695A 0460  28         b     @xutst0               ; Display string
     695C 641A 
0100 695E 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6960 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6962 832A 
0122 6964 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6966 8000 
0123 6968 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 696A 0207  20 mknum   li    tmp3,5                ; Digit counter
     696C 0005 
0020 696E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6970 C155  26         mov   *tmp1,tmp1            ; /
0022 6972 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6974 0228  22         ai    tmp4,4                ; Get end of buffer
     6976 0004 
0024 6978 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     697A 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 697C 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 697E 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6980 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6982 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6984 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6986 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6988 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 698A 0607  14         dec   tmp3                  ; Decrease counter
0036 698C 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 698E 0207  20         li    tmp3,4                ; Check first 4 digits
     6990 0004 
0041 6992 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6994 C11B  26         mov   *r11,tmp0
0043 6996 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6998 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 699A 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 699C 05CB  14 mknum3  inct  r11
0047 699E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     69A0 6046 
0048 69A2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 69A4 045B  20         b     *r11                  ; Exit
0050 69A6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 69A8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 69AA 13F8  14         jeq   mknum3                ; Yes, exit
0053 69AC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 69AE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     69B0 7FFF 
0058 69B2 C10B  18         mov   r11,tmp0
0059 69B4 0224  22         ai    tmp0,-4
     69B6 FFFC 
0060 69B8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 69BA 0206  20         li    tmp2,>0500            ; String length = 5
     69BC 0500 
0062 69BE 0460  28         b     @xutstr               ; Display string
     69C0 641C 
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
0092 69C2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 69C4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 69C6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 69C8 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 69CA 0207  20         li    tmp3,5                ; Set counter
     69CC 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 69CE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 69D0 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 69D2 0584  14         inc   tmp0                  ; Next character
0104 69D4 0607  14         dec   tmp3                  ; Last digit reached ?
0105 69D6 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 69D8 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 69DA 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 69DC DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 69DE 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 69E0 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 69E2 0607  14         dec   tmp3                  ; Last character ?
0120 69E4 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 69E6 045B  20         b     *r11                  ; Return
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
0138 69E8 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     69EA 832A 
0139 69EC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     69EE 8000 
0140 69F0 10BC  14         jmp   mknum                 ; Convert number and display
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
0016               *  Backup scratchpad memory to the memory area >2000 - >20FF.
0017               *  Expects current workspace to be in scratchpad memory.
0018               ********|*****|*********************|**************************
0019               cpu.scrpad.backup:
0020 69F2 C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     69F4 2000 
0021 69F6 C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     69F8 2002 
0022 69FA C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     69FC 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 69FE 0200  20         li    r0,>8306              ; Scratpad source address
     6A00 8306 
0027 6A02 0201  20         li    r1,>2006              ; RAM target address
     6A04 2006 
0028 6A06 0202  20         li    r2,62                 ; Loop counter
     6A08 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 6A0A CC70  46         mov   *r0+,*r1+
0034 6A0C CC70  46         mov   *r0+,*r1+
0035 6A0E 0642  14         dect  r2
0036 6A10 16FC  14         jne   cpu.scrpad.backup.copy
0037 6A12 C820  54         mov   @>83fe,@>20fe         ; Copy last word
     6A14 83FE 
     6A16 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 6A18 C020  34         mov   @>2000,r0             ; Restore r0
     6A1A 2000 
0042 6A1C C060  34         mov   @>2002,r1             ; Restore r1
     6A1E 2002 
0043 6A20 C0A0  34         mov   @>2004,r2             ; Restore r2
     6A22 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 6A24 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0051               ***************************************************************
0052               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0053               ***************************************************************
0054               *  bl   @cpu.scrpad.restore
0055               *--------------------------------------------------------------
0056               *  Register usage
0057               *  r0-r2, but values restored before exit
0058               *--------------------------------------------------------------
0059               *  Restore scratchpad from memory area >2000 - >20FF
0060               *  Current workspace can be outside scratchpad when called.
0061               ********|*****|*********************|**************************
0062               cpu.scrpad.restore:
0063                       ;------------------------------------------------------
0064                       ; Restore scratchpad >8300 - >8304
0065                       ;------------------------------------------------------
0066 6A26 C820  54         mov   @>2000,@>8300
     6A28 2000 
     6A2A 8300 
0067 6A2C C820  54         mov   @>2002,@>8302
     6A2E 2002 
     6A30 8302 
0068 6A32 C820  54         mov   @>2004,@>8304
     6A34 2004 
     6A36 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 6A38 C800  38         mov   r0,@>2000
     6A3A 2000 
0073 6A3C C801  38         mov   r1,@>2002
     6A3E 2002 
0074 6A40 C802  38         mov   r2,@>2004
     6A42 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 6A44 0200  20         li    r0,>2006
     6A46 2006 
0079 6A48 0201  20         li    r1,>8306
     6A4A 8306 
0080 6A4C 0202  20         li    r2,62
     6A4E 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 6A50 CC70  46         mov   *r0+,*r1+
0086 6A52 CC70  46         mov   *r0+,*r1+
0087 6A54 0642  14         dect  r2
0088 6A56 16FC  14         jne   cpu.scrpad.restore.copy
0089 6A58 C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6A5A 20FE 
     6A5C 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 6A5E C020  34         mov   @>2000,r0             ; Restore r0
     6A60 2000 
0094 6A62 C060  34         mov   @>2002,r1             ; Restore r1
     6A64 2002 
0095 6A66 C0A0  34         mov   @>2004,r2             ; Restore r2
     6A68 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6A6A 045B  20         b     *r11                  ; Return to caller
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
0025 6A6C C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 6A6E 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6A70 8300 
0031 6A72 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 6A74 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A76 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6A78 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6A7A 0606  14         dec   tmp2
0038 6A7C 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6A7E C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6A80 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6A82 6A88 
0044                                                   ; R14=PC
0045 6A84 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 6A86 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 6A88 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6A8A 6A26 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 6A8C 045B  20         b     *r11                  ; Return to caller
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
0078 6A8E C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 6A90 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6A92 8300 
0084 6A94 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A96 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6A98 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6A9A 0606  14         dec   tmp2
0090 6A9C 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6A9E 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6AA0 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6AA2 045B  20         b     *r11                  ; Return to caller
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
0037      240A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********|*****|*********************|**************************
0041 6AA4 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6AA6 6AA8             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6AA8 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6AAA C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6AAC 8322 
0049 6AAE 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6AB0 6042 
0050 6AB2 C020  34         mov   @>8356,r0             ; get ptr to pab
     6AB4 8356 
0051 6AB6 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6AB8 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     6ABA FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6ABC 06C0  14         swpb  r0                    ;
0059 6ABE D800  38         movb  r0,@vdpa              ; send low byte
     6AC0 8C02 
0060 6AC2 06C0  14         swpb  r0                    ;
0061 6AC4 D800  38         movb  r0,@vdpa              ; send high byte
     6AC6 8C02 
0062 6AC8 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6ACA 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6ACC 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6ACE 0704  14         seto  r4                    ; init counter
0070 6AD0 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6AD2 2420 
0071 6AD4 0580  14 !       inc   r0                    ; point to next char of name
0072 6AD6 0584  14         inc   r4                    ; incr char counter
0073 6AD8 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6ADA 0007 
0074 6ADC 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6ADE 80C4  18         c     r4,r3                 ; end of name?
0077 6AE0 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6AE2 06C0  14         swpb  r0                    ;
0082 6AE4 D800  38         movb  r0,@vdpa              ; send low byte
     6AE6 8C02 
0083 6AE8 06C0  14         swpb  r0                    ;
0084 6AEA D800  38         movb  r0,@vdpa              ; send high byte
     6AEC 8C02 
0085 6AEE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6AF0 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6AF2 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6AF4 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6AF6 6BB8 
0093 6AF8 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6AFA C104  18         mov   r4,r4                 ; Check if length = 0
0099 6AFC 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6AFE 04E0  34         clr   @>83d0
     6B00 83D0 
0102 6B02 C804  38         mov   r4,@>8354             ; save name length for search
     6B04 8354 
0103 6B06 0584  14         inc   r4                    ; adjust for dot
0104 6B08 A804  38         a     r4,@>8356             ; point to position after name
     6B0A 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6B0C 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6B0E 83E0 
0110 6B10 04C1  14         clr   r1                    ; version found of dsr
0111 6B12 020C  20         li    r12,>0f00             ; init cru addr
     6B14 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6B16 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6B18 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6B1A 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6B1C 022C  22         ai    r12,>0100             ; next rom to turn on
     6B1E 0100 
0125 6B20 04E0  34         clr   @>83d0                ; clear in case we are done
     6B22 83D0 
0126 6B24 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6B26 2000 
0127 6B28 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6B2A C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6B2C 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6B2E 1D00  20         sbo   0                     ; turn on rom
0134 6B30 0202  20         li    r2,>4000              ; start at beginning of rom
     6B32 4000 
0135 6B34 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6B36 6BB4 
0136 6B38 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6B3A A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6B3C 240A 
0146 6B3E 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6B40 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     6B42 83D2 
0152                                                   ; subprogram
0153               
0154 6B44 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 6B46 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 6B48 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 6B4A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     6B4C 83D2 
0163                                                   ; subprogram
0164               
0165 6B4E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 6B50 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 6B52 04C5  14         clr   r5                    ; Remove any old stuff
0174 6B54 D160  34         movb  @>8355,r5             ; get length as counter
     6B56 8355 
0175 6B58 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 6B5A 9C85  32         cb    r5,*r2+               ; see if length matches
0180 6B5C 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 6B5E 0985  56         srl   r5,8                  ; yes, move to low byte
0185 6B60 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B62 2420 
0186 6B64 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 6B66 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 6B68 0605  14         dec   r5                    ; loop until full length checked
0191 6B6A 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 6B6C C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6B6E 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 6B70 0581  14         inc   r1                    ; next version found
0203 6B72 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 6B74 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 6B76 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 6B78 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6B7A 2400 
0212 6B7C C009  18         mov   r9,r0                 ; point to flag in pab
0213 6B7E C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6B80 8322 
0214                                                   ; (8 or >a)
0215 6B82 0281  22         ci    r1,8                  ; was it 8?
     6B84 0008 
0216 6B86 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 6B88 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6B8A 8350 
0218                                                   ; Get error byte from @>8350
0219 6B8C 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 6B8E 06C0  14         swpb  r0                    ;
0227 6B90 D800  38         movb  r0,@vdpa              ; send low byte
     6B92 8C02 
0228 6B94 06C0  14         swpb  r0                    ;
0229 6B96 D800  38         movb  r0,@vdpa              ; send high byte
     6B98 8C02 
0230 6B9A D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6B9C 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 6B9E 09D1  56         srl   r1,13                 ; just keep error bits
0238 6BA0 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 6BA2 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 6BA4 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6BA6 2400 
0248               dsrlnk.error.devicename_invalid:
0249 6BA8 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 6BAA 06C1  14         swpb  r1                    ; put error in hi byte
0252 6BAC D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 6BAE F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6BB0 6042 
0254 6BB2 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 6BB4 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 6BB6 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 6BB8 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6BBA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6BBC C04B  18         mov   r11,r1                ; Save return address
0049 6BBE C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BC0 2428 
0050 6BC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6BC4 04C5  14         clr   tmp1                  ; io.op.open
0052 6BC6 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BC8 62C6 
0053               file.open_init:
0054 6BCA 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BCC 0009 
0055 6BCE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BD0 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6BD2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BD4 6AA4 
0061 6BD6 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6BD8 1029  14         jmp   file.record.pab.details
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
0090 6BDA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6BDC C04B  18         mov   r11,r1                ; Save return address
0096 6BDE C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BE0 2428 
0097 6BE2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6BE4 0205  20         li    tmp1,io.op.close      ; io.op.close
     6BE6 0001 
0099 6BE8 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BEA 62C6 
0100               file.close_init:
0101 6BEC 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BEE 0009 
0102 6BF0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BF2 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6BF4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BF6 6AA4 
0108 6BF8 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6BFA 1018  14         jmp   file.record.pab.details
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
0139 6BFC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6BFE C04B  18         mov   r11,r1                ; Save return address
0145 6C00 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6C02 2428 
0146 6C04 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6C06 0205  20         li    tmp1,io.op.read       ; io.op.read
     6C08 0002 
0148 6C0A 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6C0C 62C6 
0149               file.record.read_init:
0150 6C0E 0220  22         ai    r0,9                  ; Move to file descriptor length
     6C10 0009 
0151 6C12 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6C14 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6C16 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6C18 6AA4 
0157 6C1A 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6C1C 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6C1E 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6C20 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6C22 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6C24 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6C26 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6C28 1000  14         nop
0191               
0192               
0193               file.status:
0194 6C2A 1000  14         nop
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
0211 6C2C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6C2E C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6C30 2428 
0219 6C32 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6C34 0005 
0220 6C36 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6C38 62DE 
0221 6C3A C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6C3C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6C3E 0451  20         b     *r1                   ; Return to caller
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
0020 6C40 0300  24 tmgr    limi  0                     ; No interrupt processing
     6C42 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6C44 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6C46 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6C48 2360  38         coc   @wbit2,r13            ; C flag on ?
     6C4A 6042 
0029 6C4C 1602  14         jne   tmgr1a                ; No, so move on
0030 6C4E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6C50 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6C52 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6C54 6046 
0035 6C56 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6C58 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6C5A 6036 
0048 6C5C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6C5E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6C60 6034 
0050 6C62 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6C64 0460  28         b     @kthread              ; Run kernel thread
     6C66 6CDE 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6C68 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6C6A 603A 
0056 6C6C 13EB  14         jeq   tmgr1
0057 6C6E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6C70 6038 
0058 6C72 16E8  14         jne   tmgr1
0059 6C74 C120  34         mov   @wtiusr,tmp0
     6C76 832E 
0060 6C78 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6C7A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6C7C 6CDC 
0065 6C7E C10A  18         mov   r10,tmp0
0066 6C80 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6C82 00FF 
0067 6C84 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6C86 6042 
0068 6C88 1303  14         jeq   tmgr5
0069 6C8A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6C8C 003C 
0070 6C8E 1002  14         jmp   tmgr6
0071 6C90 0284  22 tmgr5   ci    tmp0,50
     6C92 0032 
0072 6C94 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C96 1001  14         jmp   tmgr8
0074 6C98 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C9A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C9C 832C 
0079 6C9E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6CA0 FF00 
0080 6CA2 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6CA4 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6CA6 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6CA8 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6CAA C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6CAC 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6CAE 830C 
     6CB0 830D 
0089 6CB2 1608  14         jne   tmgr10                ; No, get next slot
0090 6CB4 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6CB6 FF00 
0091 6CB8 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6CBA C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6CBC 8330 
0096 6CBE 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6CC0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6CC2 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6CC4 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6CC6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6CC8 8315 
     6CCA 8314 
0103 6CCC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6CCE 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6CD0 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6CD2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6CD4 10F7  14         jmp   tmgr10                ; Process next slot
0108 6CD6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6CD8 FF00 
0109 6CDA 10B4  14         jmp   tmgr1
0110 6CDC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6CDE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6CE0 6036 
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
0041 6CE2 06A0  32         bl    @realkb               ; Scan full keyboard
     6CE4 6784 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6CE6 0460  28         b     @tmgr3                ; Exit
     6CE8 6C68 
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
0017 6CEA C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6CEC 832E 
0018 6CEE E0A0  34         soc   @wbit7,config         ; Enable user hook
     6CF0 6038 
0019 6CF2 045B  20 mkhoo1  b     *r11                  ; Return
0020      6C44     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6CF4 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6CF6 832E 
0029 6CF8 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6CFA FEFF 
0030 6CFC 045B  20         b     *r11                  ; Return
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
0017 6CFE C13B  30 mkslot  mov   *r11+,tmp0
0018 6D00 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6D02 C184  18         mov   tmp0,tmp2
0023 6D04 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6D06 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6D08 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6D0A CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6D0C 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6D0E C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6D10 881B  46         c     *r11,@w$ffff          ; End of list ?
     6D12 6048 
0035 6D14 1301  14         jeq   mkslo1                ; Yes, exit
0036 6D16 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6D18 05CB  14 mkslo1  inct  r11
0041 6D1A 045B  20         b     *r11                  ; Exit
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
0052 6D1C C13B  30 clslot  mov   *r11+,tmp0
0053 6D1E 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6D20 A120  34         a     @wtitab,tmp0          ; Add table base
     6D22 832C 
0055 6D24 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6D26 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6D28 045B  20         b     *r11                  ; Exit
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
0250 6D2A 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6D2C 69F2 
0251 6D2E 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6D30 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6D32 0300  24 runli1  limi  0                     ; Turn off interrupts
     6D34 0000 
0259 6D36 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6D38 8300 
0260 6D3A C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6D3C 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6D3E 0202  20 runli2  li    r2,>8308
     6D40 8308 
0265 6D42 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6D44 0282  22         ci    r2,>8400
     6D46 8400 
0267 6D48 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6D4A 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6D4C FFFF 
0273 6D4E 1602  14         jne   runli4                ; No, continue
0274 6D50 0420  54         blwp  @0                    ; Yes, bye bye
     6D52 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6D54 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6D56 833C 
0279 6D58 04C1  14         clr   r1                    ; Reset counter
0280 6D5A 0202  20         li    r2,10                 ; We test 10 times
     6D5C 000A 
0281 6D5E C0E0  34 runli5  mov   @vdps,r3
     6D60 8802 
0282 6D62 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6D64 6046 
0283 6D66 1302  14         jeq   runli6
0284 6D68 0581  14         inc   r1                    ; Increase counter
0285 6D6A 10F9  14         jmp   runli5
0286 6D6C 0602  14 runli6  dec   r2                    ; Next test
0287 6D6E 16F7  14         jne   runli5
0288 6D70 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6D72 1250 
0289 6D74 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6D76 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6D78 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6D7A 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6D7C 621A 
0295 6D7E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6D80 8322 
0296 6D82 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6D84 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6D86 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6D88 04C1  14 runli9  clr   r1
0303 6D8A 04C2  14         clr   r2
0304 6D8C 04C3  14         clr   r3
0305 6D8E 0209  20         li    stack,>8400           ; Set stack
     6D90 8400 
0306 6D92 020F  20         li    r15,vdpw              ; Set VDP write address
     6D94 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6D96 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6D98 4A4A 
0315 6D9A 1605  14         jne   runlia
0316 6D9C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6D9E 6288 
0317 6DA0 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6DA2 0000 
     6DA4 3FFF 
0322 6DA6 06A0  32 runlia  bl    @filv
     6DA8 6288 
0323 6DAA 0FC0             data  pctadr,spfclr,16      ; Load color table
     6DAC 00F4 
     6DAE 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6DB0 06A0  32         bl    @f18unl               ; Unlock the F18A
     6DB2 66CC 
0331 6DB4 06A0  32         bl    @f18chk               ; Check if F18A is there
     6DB6 66E6 
0332 6DB8 06A0  32         bl    @f18lck               ; Lock the F18A again
     6DBA 66DC 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6DBC 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6DBE 62F2 
0346 6DC0 6210             data  spvmod                ; Equate selected video mode table
0347 6DC2 0204  20         li    tmp0,spfont           ; Get font option
     6DC4 000C 
0348 6DC6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6DC8 1304  14         jeq   runlid                ; Yes, skip it
0350 6DCA 06A0  32         bl    @ldfnt
     6DCC 635A 
0351 6DCE 1100             data  fntadr,spfont         ; Load specified font
     6DD0 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6DD2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6DD4 4A4A 
0356 6DD6 1602  14         jne   runlie                ; No, continue
0357 6DD8 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6DDA 60AC 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6DDC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6DDE 0040 
0362 6DE0 0460  28         b     @main                 ; Give control to main program
     6DE2 6DE4 
**** **** ****     > tivi.asm.22880
0259               
0260               *--------------------------------------------------------------
0261               * Video mode configuration
0262               *--------------------------------------------------------------
0263      6210     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0264      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0265      0050     colrow  equ   80                    ; Columns per row
0266      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0267      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0268      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0269      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0270               
0271               
0272               
0273               
0274               
0275               ***************************************************************
0276               *                     TiVi support modules
0277               ***************************************************************
0278                       copy  "editor.asm"          ; Main editor
**** **** ****     > editor.asm
0001               * FILE......: editor.asm
0002               * Purpose...: TiVi Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            TiVi Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * main
0010               * Initialize editor
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
0021               * -
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               
0026               
0027               ***************************************************************
0028               * Main
0029               ********|*****|*********************|**************************
0030               main:
0031 6DE4 20A0  38         coc   @wbit1,config         ; F18a detected?
     6DE6 6044 
0032 6DE8 1302  14         jeq   main.continue
0033 6DEA 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6DEC 0000 
0034               
0035               main.continue:
0036 6DEE 06A0  32         bl    @scroff               ; Turn screen off
     6DF0 6628 
0037 6DF2 06A0  32         bl    @f18unl               ; Unlock the F18a
     6DF4 66CC 
0038 6DF6 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6DF8 632C 
0039 6DFA 3140                   data >3140            ; F18a VR49 (>31), bit 40
0040                       ;------------------------------------------------------
0041                       ; Initialize VDP SIT
0042                       ;------------------------------------------------------
0043 6DFC 06A0  32         bl    @filv
     6DFE 6288 
0044 6E00 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6E02 0020 
     6E04 09B0 
0045 6E06 06A0  32         bl    @scron                ; Turn screen on
     6E08 6630 
0046                       ;------------------------------------------------------
0047                       ; Initialize low + high memory expansion
0048                       ;------------------------------------------------------
0049 6E0A 06A0  32         bl    @film
     6E0C 6230 
0050 6E0E 2200                   data >2200,00,8*1024-256*2
     6E10 0000 
     6E12 3E00 
0051                                                   ; Clear part of 8k low-memory
0052               
0053 6E14 06A0  32         bl    @film
     6E16 6230 
0054 6E18 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6E1A 0000 
     6E1C 6000 
0055                       ;------------------------------------------------------
0056                       ; Load SAMS default memory layout
0057                       ;------------------------------------------------------
0058 6E1E 06A0  32         bl    @mem.setup.sams.layout
     6E20 7468 
0059                                                   ; Initialize SAMS layout
0060                       ;------------------------------------------------------
0061                       ; Setup cursor, screen, etc.
0062                       ;------------------------------------------------------
0063 6E22 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6E24 6648 
0064 6E26 06A0  32         bl    @s8x8                 ; Small sprite
     6E28 6658 
0065               
0066 6E2A 06A0  32         bl    @cpym2m
     6E2C 647A 
0067 6E2E 7E54                   data romsat,ramsat,4  ; Load sprite SAT
     6E30 8380 
     6E32 0004 
0068               
0069 6E34 C820  54         mov   @romsat+2,@fb.curshape
     6E36 7E56 
     6E38 2290 
0070                                                   ; Save cursor shape & color
0071               
0072 6E3A 06A0  32         bl    @cpym2v
     6E3C 6432 
0073 6E3E 1800                   data sprpdt,cursors,3*8
     6E40 7E58 
     6E42 0018 
0074                                                   ; Load sprite cursor patterns
0075               
0076 6E44 06A0  32         bl    @cpym2v
     6E46 6432 
0077 6E48 1008                   data >1008,lines,16   ; Load line patterns
     6E4A 7E70 
     6E4C 0010 
0078               *--------------------------------------------------------------
0079               * Initialize
0080               *--------------------------------------------------------------
0081 6E4E 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6E50 78C2 
0082 6E52 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E54 76E4 
0083 6E56 06A0  32         bl    @idx.init             ; Initialize index
     6E58 760C 
0084 6E5A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E5C 74CC 
0085                       ;-------------------------------------------------------
0086                       ; Setup editor tasks & hook
0087                       ;-------------------------------------------------------
0088 6E5E 0204  20         li    tmp0,>0200
     6E60 0200 
0089 6E62 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6E64 8314 
0090               
0091 6E66 06A0  32         bl    @at
     6E68 6668 
0092 6E6A 0100             data  >0100                 ; Cursor YX position = >0000
0093               
0094 6E6C 0204  20         li    tmp0,timers
     6E6E 8370 
0095 6E70 C804  38         mov   tmp0,@wtitab
     6E72 832C 
0096               
0097 6E74 06A0  32         bl    @mkslot
     6E76 6CFE 
0098 6E78 0001                   data >0001,task0      ; Task 0 - Update screen
     6E7A 7C8A 
0099 6E7C 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6E7E 7D16 
0100 6E80 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6E82 7D24 
     6E84 FFFF 
0101               
0102 6E86 06A0  32         bl    @mkhook
     6E88 6CEA 
0103 6E8A 7C5A                   data editor           ; Setup user hook
0104               
0105 6E8C 0460  28         b     @tmgr                 ; Start timers and kthread
     6E8E 6C40 
0106               
0107               
**** **** ****     > tivi.asm.22880
0279                       copy  "edkey.asm"           ; Actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Initialisation & setup key actions
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Movement keys
0007               *---------------------------------------------------------------
0008      0800     key_left      equ >0800                      ; fctn + s
0009      0900     key_right     equ >0900                      ; fctn + d
0010      0B00     key_up        equ >0b00                      ; fctn + e
0011      0A00     key_down      equ >0a00                      ; fctn + x
0012      8100     key_home      equ >8100                      ; ctrl + a
0013      8600     key_end       equ >8600                      ; ctrl + f
0014      9300     key_pword     equ >9300                      ; ctrl + s
0015      8400     key_nword     equ >8400                      ; ctrl + d
0016      8500     key_ppage     equ >8500                      ; ctrl + e
0017      9800     key_npage     equ >9800                      ; ctrl + x
0018      9400     key_tpage     equ >9400                      ; ctrl + t
0019      8200     key_bpage     equ >8200                      ; ctrl + b
0020               *---------------------------------------------------------------
0021               * Modifier keys
0022               *---------------------------------------------------------------
0023      0D00     key_enter       equ >0d00                    ; enter
0024      0300     key_del_char    equ >0300                    ; fctn + 1
0025      0700     key_del_line    equ >0700                    ; fctn + 3
0026      8B00     key_del_eol     equ >8b00                    ; ctrl + k
0027      0400     key_ins_char    equ >0400                    ; fctn + 2
0028      B900     key_ins_onoff   equ >b900                    ; fctn + .
0029      0E00     key_ins_line    equ >0e00                    ; fctn + 5
0030      0500     key_quit1       equ >0500                    ; fctn + +
0031      9D00     key_quit2       equ >9d00                    ; ctrl + +
0032               *---------------------------------------------------------------
0033               * File buffer keys
0034               *---------------------------------------------------------------
0035      B000     key_buf0        equ >b000                    ; ctrl + 0
0036      B100     key_buf1        equ >b100                    ; ctrl + 1
0037      B200     key_buf2        equ >b200                    ; ctrl + 2
0038      B300     key_buf3        equ >b300                    ; ctrl + 3
0039      B400     key_buf4        equ >b400                    ; ctrl + 4
0040      B500     key_buf5        equ >b500                    ; ctrl + 5
0041      B600     key_buf6        equ >b600                    ; ctrl + 6
0042      B700     key_buf7        equ >b700                    ; ctrl + 7
0043      9E00     key_buf8        equ >9e00                    ; ctrl + 8
0044      9F00     key_buf9        equ >9f00                    ; ctrl + 9
0045               *---------------------------------------------------------------
0046               * Misc keys
0047               *---------------------------------------------------------------
0048      C400     key_cmdb_tog    equ >c400                    ; fctn + n
0049               
0050               
0051               *---------------------------------------------------------------
0052               * Action keys mapping <-> actions table
0053               *---------------------------------------------------------------
0054               keymap_actions
0055                       ;-------------------------------------------------------
0056                       ; Movement keys
0057                       ;-------------------------------------------------------
0058 6E90 0D00             data  key_enter,edkey.action.enter          ; New line
     6E92 733A 
0059 6E94 0800             data  key_left,edkey.action.left            ; Move cursor left
     6E96 6F30 
0060 6E98 0900             data  key_right,edkey.action.right          ; Move cursor right
     6E9A 6F46 
0061 6E9C 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6E9E 6F5E 
0062 6EA0 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6EA2 6FB0 
0063 6EA4 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6EA6 701C 
0064 6EA8 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6EAA 7034 
0065 6EAC 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6EAE 7048 
0066 6EB0 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6EB2 709A 
0067 6EB4 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6EB6 70FA 
0068 6EB8 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6EBA 7140 
0069 6EBC 9400             data  key_tpage,edkey.action.top            ; Move cursor to file top
     6EBE 716C 
0070 6EC0 8200             data  key_bpage,edkey.action.bot            ; Move cursor to file bottom
     6EC2 719C 
0071                       ;-------------------------------------------------------
0072                       ; Modifier keys - Delete
0073                       ;-------------------------------------------------------
0074 6EC4 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6EC6 71DC 
0075 6EC8 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6ECA 7214 
0076 6ECC 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6ECE 7248 
0077                       ;-------------------------------------------------------
0078                       ; Modifier keys - Insert
0079                       ;-------------------------------------------------------
0080 6ED0 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6ED2 72A0 
0081 6ED4 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6ED6 73A8 
0082 6ED8 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6EDA 72F6 
0083                       ;-------------------------------------------------------
0084                       ; Other action keys
0085                       ;-------------------------------------------------------
0086 6EDC 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6EDE 73F8 
0087 6EE0 C400             data  key_cmdb_tog,edkey.action.cmdb.toggle ; Toggle command buffer pane
     6EE2 7400 
0088                       ;-------------------------------------------------------
0089                       ; Editor/File buffer keys
0090                       ;-------------------------------------------------------
0091 6EE4 B000             data  key_buf0,edkey.action.buffer0
     6EE6 7424 
0092 6EE8 B100             data  key_buf1,edkey.action.buffer1
     6EEA 742A 
0093 6EEC B200             data  key_buf2,edkey.action.buffer2
     6EEE 7430 
0094 6EF0 B300             data  key_buf3,edkey.action.buffer3
     6EF2 7436 
0095 6EF4 B400             data  key_buf4,edkey.action.buffer4
     6EF6 743C 
0096 6EF8 B500             data  key_buf5,edkey.action.buffer5
     6EFA 7442 
0097 6EFC B600             data  key_buf6,edkey.action.buffer6
     6EFE 7448 
0098 6F00 B700             data  key_buf7,edkey.action.buffer7
     6F02 744E 
0099 6F04 9E00             data  key_buf8,edkey.action.buffer8
     6F06 7454 
0100 6F08 9F00             data  key_buf9,edkey.action.buffer9
     6F0A 745A 
0101 6F0C FFFF             data  >ffff                                 ; EOL
0102               
0103               
0104               
0105               ****************************************************************
0106               * Editor - Process key
0107               ****************************************************************
0108 6F0E C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6F10 833C 
0109 6F12 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6F14 FF00 
0110               
0111 6F16 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6F18 6E90 
0112 6F1A 0707  14         seto  tmp3                  ; EOL marker
0113                       ;-------------------------------------------------------
0114                       ; Iterate over keyboard map for matching key
0115                       ;-------------------------------------------------------
0116               edkey.check_next_key:
0117 6F1C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0118 6F1E 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0119               
0120 6F20 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0121 6F22 1302  14         jeq   edkey.do_action       ; Yes, do action
0122 6F24 05C6  14         inct  tmp2                  ; No, skip action
0123 6F26 10FA  14         jmp   edkey.check_next_key  ; Next key
0124               
0125               edkey.do_action:
0126 6F28 C196  26         mov  *tmp2,tmp2             ; Get action address
0127 6F2A 0456  20         b    *tmp2                  ; Process key action
0128               edkey.do_action.set:
0129 6F2C 0460  28         b    @edkey.action.char     ; Add character to buffer
     6F2E 73B8 
**** **** ****     > tivi.asm.22880
0280                       copy  "edkey.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.mov.asm
0001               * FILE......: edkey.mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6F30 C120  34         mov   @fb.column,tmp0
     6F32 228C 
0010 6F34 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6F36 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6F38 228C 
0015 6F3A 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6F3C 832A 
0016 6F3E 0620  34         dec   @fb.current
     6F40 2282 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6F42 0460  28 !       b     @ed_wait              ; Back to editor main
     6F44 7C7E 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6F46 8820  54         c     @fb.column,@fb.row.length
     6F48 228C 
     6F4A 2288 
0028 6F4C 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6F4E 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6F50 228C 
0033 6F52 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6F54 832A 
0034 6F56 05A0  34         inc   @fb.current
     6F58 2282 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6F5A 0460  28 !       b     @ed_wait              ; Back to editor main
     6F5C 7C7E 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6F5E 8820  54         c     @fb.row.dirty,@w$ffff
     6F60 228A 
     6F62 6048 
0049 6F64 1604  14         jne   edkey.action.up.cursor
0050 6F66 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F68 770C 
0051 6F6A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F6C 228A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6F6E C120  34         mov   @fb.row,tmp0
     6F70 2286 
0057 6F72 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row > 0
0059 6F74 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6F76 2284 
0060 6F78 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6F7A 0604  14         dec   tmp0                  ; fb.topline--
0066 6F7C C804  38         mov   tmp0,@parm1
     6F7E 8350 
0067 6F80 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F82 754C 
0068 6F84 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6F86 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F88 2286 
0074 6F8A 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F8C 6676 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6F8E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F90 78A4 
0080 6F92 8820  54         c     @fb.column,@fb.row.length
     6F94 228C 
     6F96 2288 
0081 6F98 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6F9A C820  54         mov   @fb.row.length,@fb.column
     6F9C 2288 
     6F9E 228C 
0086 6FA0 C120  34         mov   @fb.column,tmp0
     6FA2 228C 
0087 6FA4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FA6 6680 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6FA8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FAA 7530 
0093 6FAC 0460  28         b     @ed_wait              ; Back to editor main
     6FAE 7C7E 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6FB0 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6FB2 2286 
     6FB4 2304 
0102 6FB6 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6FB8 8820  54         c     @fb.row.dirty,@w$ffff
     6FBA 228A 
     6FBC 6048 
0107 6FBE 1604  14         jne   edkey.action.down.move
0108 6FC0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6FC2 770C 
0109 6FC4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6FC6 228A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6FC8 C120  34         mov   @fb.topline,tmp0
     6FCA 2284 
0118 6FCC A120  34         a     @fb.row,tmp0
     6FCE 2286 
0119 6FD0 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6FD2 2304 
0120 6FD4 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6FD6 C120  34         mov   @fb.scrrows,tmp0
     6FD8 2298 
0126 6FDA 0604  14         dec   tmp0
0127 6FDC 8120  34         c     @fb.row,tmp0
     6FDE 2286 
0128 6FE0 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6FE2 C820  54         mov   @fb.topline,@parm1
     6FE4 2284 
     6FE6 8350 
0133 6FE8 05A0  34         inc   @parm1
     6FEA 8350 
0134 6FEC 06A0  32         bl    @fb.refresh
     6FEE 754C 
0135 6FF0 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6FF2 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6FF4 2286 
0141 6FF6 06A0  32         bl    @down                 ; Row++ VDP cursor
     6FF8 666E 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6FFA 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6FFC 78A4 
0147               
0148 6FFE 8820  54         c     @fb.column,@fb.row.length
     7000 228C 
     7002 2288 
0149 7004 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 7006 C820  54         mov   @fb.row.length,@fb.column
     7008 2288 
     700A 228C 
0155 700C C120  34         mov   @fb.column,tmp0
     700E 228C 
0156 7010 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7012 6680 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 7014 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7016 7530 
0162 7018 0460  28 !       b     @ed_wait              ; Back to editor main
     701A 7C7E 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 701C C120  34         mov   @wyx,tmp0
     701E 832A 
0171 7020 0244  22         andi  tmp0,>ff00
     7022 FF00 
0172 7024 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     7026 832A 
0173 7028 04E0  34         clr   @fb.column
     702A 228C 
0174 702C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     702E 7530 
0175 7030 0460  28         b     @ed_wait              ; Back to editor main
     7032 7C7E 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 7034 C120  34         mov   @fb.row.length,tmp0
     7036 2288 
0182 7038 C804  38         mov   tmp0,@fb.column
     703A 228C 
0183 703C 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     703E 6680 
0184 7040 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7042 7530 
0185 7044 0460  28         b     @ed_wait              ; Back to editor main
     7046 7C7E 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 7048 C120  34         mov   @fb.column,tmp0
     704A 228C 
0194 704C 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 704E C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7050 2282 
0199 7052 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 7054 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 7056 0605  14         dec   tmp1
0206 7058 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 705A 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 705C D195  26         movb  *tmp1,tmp2            ; Get character
0214 705E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 7060 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 7062 0986  56         srl   tmp2,8                ; Right justify
0217 7064 0286  22         ci    tmp2,32               ; Space character found?
     7066 0020 
0218 7068 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 706A 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     706C 2020 
0224 706E 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 7070 0287  22         ci    tmp3,>20ff            ; First character is space
     7072 20FF 
0227 7074 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 7076 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     7078 228C 
0232 707A 61C4  18         s     tmp0,tmp3
0233 707C 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     707E 0002 
0234 7080 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 7082 0585  14         inc   tmp1
0240 7084 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 7086 C805  38         mov   tmp1,@fb.current
     7088 2282 
0246 708A C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     708C 228C 
0247 708E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7090 6680 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 7092 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7094 7530 
0253 7096 0460  28 !       b     @ed_wait              ; Back to editor main
     7098 7C7E 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 709A 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 709C C120  34         mov   @fb.column,tmp0
     709E 228C 
0263 70A0 8804  38         c     tmp0,@fb.row.length
     70A2 2288 
0264 70A4 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 70A6 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     70A8 2282 
0269 70AA 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 70AC 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 70AE 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 70B0 0585  14         inc   tmp1
0281 70B2 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 70B4 8804  38         c     tmp0,@fb.row.length
     70B6 2288 
0283 70B8 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 70BA D195  26         movb  *tmp1,tmp2            ; Get character
0290 70BC 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 70BE D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 70C0 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 70C2 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     70C4 FFFF 
0295 70C6 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 70C8 0286  22         ci    tmp2,32
     70CA 0020 
0301 70CC 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 70CE 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 70D0 0286  22         ci    tmp2,32               ; Space character found?
     70D2 0020 
0309 70D4 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 70D6 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     70D8 2020 
0315 70DA 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 70DC 0287  22         ci    tmp3,>20ff            ; First characer is space?
     70DE 20FF 
0318 70E0 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 70E2 0585  14         inc   tmp1
0323 70E4 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 70E6 C805  38         mov   tmp1,@fb.current
     70E8 2282 
0329 70EA C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     70EC 228C 
0330 70EE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70F0 6680 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 70F2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70F4 7530 
0336 70F6 0460  28 !       b     @ed_wait              ; Back to editor main
     70F8 7C7E 
0337               
0338               
0339               
0340               
0341               *---------------------------------------------------------------
0342               * Previous page
0343               *---------------------------------------------------------------
0344               edkey.action.ppage:
0345                       ;-------------------------------------------------------
0346                       ; Sanity check
0347                       ;-------------------------------------------------------
0348 70FA C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     70FC 2284 
0349 70FE 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 7100 8804  38         c     tmp0,@fb.scrrows   ; topline > rows on screen?
     7102 2298 
0354 7104 1503  14         jgt   edkey.action.ppage.topline
0355 7106 04E0  34         clr   @fb.topline           ; topline = 0
     7108 2284 
0356 710A 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 710C 6820  54         s     @fb.scrrows,@fb.topline
     710E 2298 
     7110 2284 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 7112 8820  54         c     @fb.row.dirty,@w$ffff
     7114 228A 
     7116 6048 
0367 7118 1604  14         jne   edkey.action.ppage.refresh
0368 711A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     711C 770C 
0369 711E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7120 228A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 7122 C820  54         mov   @fb.topline,@parm1
     7124 2284 
     7126 8350 
0375 7128 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     712A 754C 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 712C 04E0  34         clr   @fb.row
     712E 2286 
0381 7130 04E0  34         clr   @fb.column
     7132 228C 
0382 7134 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7136 0100 
0383 7138 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     713A 832A 
0384 713C 0460  28         b     @edkey.action.up      ; Do rest of logic
     713E 6F5E 
0385               
0386               
0387               
0388               *---------------------------------------------------------------
0389               * Next page
0390               *---------------------------------------------------------------
0391               edkey.action.npage:
0392                       ;-------------------------------------------------------
0393                       ; Sanity check
0394                       ;-------------------------------------------------------
0395 7140 C120  34         mov   @fb.topline,tmp0
     7142 2284 
0396 7144 A120  34         a     @fb.scrrows,tmp0
     7146 2298 
0397 7148 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     714A 2304 
0398 714C 150D  14         jgt   edkey.action.npage.exit
0399                       ;-------------------------------------------------------
0400                       ; Adjust topline
0401                       ;-------------------------------------------------------
0402               edkey.action.npage.topline:
0403 714E A820  54         a     @fb.scrrows,@fb.topline
     7150 2298 
     7152 2284 
0404                       ;-------------------------------------------------------
0405                       ; Crunch current row if dirty
0406                       ;-------------------------------------------------------
0407               edkey.action.npage.crunch:
0408 7154 8820  54         c     @fb.row.dirty,@w$ffff
     7156 228A 
     7158 6048 
0409 715A 1604  14         jne   edkey.action.npage.refresh
0410 715C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     715E 770C 
0411 7160 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7162 228A 
0412                       ;-------------------------------------------------------
0413                       ; Refresh page
0414                       ;-------------------------------------------------------
0415               edkey.action.npage.refresh:
0416 7164 0460  28         b     @edkey.action.ppage.refresh
     7166 7122 
0417                                                   ; Same logic as previous page
0418                       ;-------------------------------------------------------
0419                       ; Exit
0420                       ;-------------------------------------------------------
0421               edkey.action.npage.exit:
0422 7168 0460  28         b     @ed_wait              ; Back to editor main
     716A 7C7E 
0423               
0424               
0425               
0426               
0427               *---------------------------------------------------------------
0428               * Goto top of file
0429               *---------------------------------------------------------------
0430               edkey.action.top:
0431                       ;-------------------------------------------------------
0432                       ; Crunch current row if dirty
0433                       ;-------------------------------------------------------
0434 716C 8820  54         c     @fb.row.dirty,@w$ffff
     716E 228A 
     7170 6048 
0435 7172 1604  14         jne   edkey.action.top.refresh
0436 7174 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7176 770C 
0437 7178 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     717A 228A 
0438                       ;-------------------------------------------------------
0439                       ; Refresh page
0440                       ;-------------------------------------------------------
0441               edkey.action.top.refresh:
0442 717C 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     717E 2284 
0443 7180 04E0  34         clr   @parm1
     7182 8350 
0444 7184 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7186 754C 
0445                       ;-------------------------------------------------------
0446                       ; Exit
0447                       ;-------------------------------------------------------
0448               edkey.action.top.exit:
0449 7188 04E0  34         clr   @fb.row               ; Frame buffer line 0
     718A 2286 
0450 718C 04E0  34         clr   @fb.column            ; Frame buffer column 0
     718E 228C 
0451 7190 0204  20         li    tmp0,>0100
     7192 0100 
0452 7194 C804  38         mov   tmp0,@wyx             ; Set VDP cursor on line 1, column 0
     7196 832A 
0453 7198 0460  28         b     @ed_wait              ; Back to editor main
     719A 7C7E 
0454               
0455               
0456               
0457               *---------------------------------------------------------------
0458               * Goto bottom of file
0459               *---------------------------------------------------------------
0460               edkey.action.bot:
0461                       ;-------------------------------------------------------
0462                       ; Crunch current row if dirty
0463                       ;-------------------------------------------------------
0464 719C 8820  54         c     @fb.row.dirty,@w$ffff
     719E 228A 
     71A0 6048 
0465 71A2 1604  14         jne   edkey.action.bot.refresh
0466 71A4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     71A6 770C 
0467 71A8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     71AA 228A 
0468                       ;-------------------------------------------------------
0469                       ; Refresh page
0470                       ;-------------------------------------------------------
0471               edkey.action.bot.refresh:
0472 71AC 8820  54         c     @edb.lines,@fb.scrrows
     71AE 2304 
     71B0 2298 
0473                                                   ; Skip if whole editor buffer on screen
0474 71B2 1212  14         jle   !
0475 71B4 C120  34         mov   @edb.lines,tmp0
     71B6 2304 
0476 71B8 6120  34         s     @fb.scrrows,tmp0
     71BA 2298 
0477 71BC C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     71BE 2284 
0478 71C0 C804  38         mov   tmp0,@parm1
     71C2 8350 
0479 71C4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71C6 754C 
0480                       ;-------------------------------------------------------
0481                       ; Exit
0482                       ;-------------------------------------------------------
0483               edkey.action.bot.exit:
0484 71C8 04E0  34         clr   @fb.row               ; Editor line 0
     71CA 2286 
0485 71CC 04E0  34         clr   @fb.column            ; Editor column 0
     71CE 228C 
0486 71D0 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     71D2 0100 
0487 71D4 C804  38         mov   tmp0,@wyx             ; Set cursor
     71D6 832A 
0488 71D8 0460  28 !       b     @ed_wait              ; Back to editor main
     71DA 7C7E 
**** **** ****     > tivi.asm.22880
0281                       copy  "edkey.mod.asm"       ; Actions for modifier keys
**** **** ****     > edkey.mod.asm
0001               * FILE......: edkey.mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 71DC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71DE 2306 
0010 71E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71E2 7530 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 71E4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     71E6 2282 
0015 71E8 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     71EA 2288 
0016 71EC 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 71EE 8820  54         c     @fb.column,@fb.row.length
     71F0 228C 
     71F2 2288 
0022 71F4 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 71F6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     71F8 2282 
0028 71FA C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 71FC 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 71FE DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7200 0606  14         dec   tmp2
0036 7202 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 7204 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7206 228A 
0041 7208 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     720A 2296 
0042 720C 0620  34         dec   @fb.row.length        ; @fb.row.length--
     720E 2288 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7210 0460  28         b     @ed_wait              ; Back to editor main
     7212 7C7E 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 7214 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7216 2306 
0055 7218 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     721A 7530 
0056 721C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     721E 2288 
0057 7220 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 7222 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7224 2282 
0063 7226 C1A0  34         mov   @fb.colsline,tmp2
     7228 228E 
0064 722A 61A0  34         s     @fb.column,tmp2
     722C 228C 
0065 722E 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 7230 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 7232 0606  14         dec   tmp2
0072 7234 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 7236 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7238 228A 
0077 723A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     723C 2296 
0078               
0079 723E C820  54         mov   @fb.column,@fb.row.length
     7240 228C 
     7242 2288 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 7244 0460  28         b     @ed_wait              ; Back to editor main
     7246 7C7E 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7248 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     724A 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 724C C120  34         mov   @edb.lines,tmp0
     724E 2304 
0097 7250 1604  14         jne   !
0098 7252 04E0  34         clr   @fb.column            ; Column 0
     7254 228C 
0099 7256 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7258 7214 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 725A 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     725C 7530 
0104 725E 04E0  34         clr   @fb.row.dirty         ; Discard current line
     7260 228A 
0105 7262 C820  54         mov   @fb.topline,@parm1
     7264 2284 
     7266 8350 
0106 7268 A820  54         a     @fb.row,@parm1        ; Line number to remove
     726A 2286 
     726C 8350 
0107 726E C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7270 2304 
     7272 8352 
0108 7274 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7276 764E 
0109 7278 0620  34         dec   @edb.lines            ; One line less in editor buffer
     727A 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 727C C820  54         mov   @fb.topline,@parm1
     727E 2284 
     7280 8350 
0114 7282 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7284 754C 
0115 7286 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7288 2296 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 728A C120  34         mov   @fb.topline,tmp0
     728C 2284 
0120 728E A120  34         a     @fb.row,tmp0
     7290 2286 
0121 7292 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7294 2304 
0122 7296 1202  14         jle   edkey.action.del_line.exit
0123 7298 0460  28         b     @edkey.action.up      ; One line up
     729A 6F5E 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 729C 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     729E 701C 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 72A0 0204  20         li    tmp0,>2000            ; White space
     72A2 2000 
0139 72A4 C804  38         mov   tmp0,@parm1
     72A6 8350 
0140               edkey.action.ins_char:
0141 72A8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72AA 2306 
0142 72AC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72AE 7530 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 72B0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     72B2 2282 
0147 72B4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     72B6 2288 
0148 72B8 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 72BA 8820  54         c     @fb.column,@fb.row.length
     72BC 228C 
     72BE 2288 
0154 72C0 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 72C2 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 72C4 61E0  34         s     @fb.column,tmp3
     72C6 228C 
0162 72C8 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 72CA C144  18         mov   tmp0,tmp1
0164 72CC 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 72CE 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     72D0 228C 
0166 72D2 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 72D4 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 72D6 0604  14         dec   tmp0
0173 72D8 0605  14         dec   tmp1
0174 72DA 0606  14         dec   tmp2
0175 72DC 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 72DE D560  46         movb  @parm1,*tmp1
     72E0 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 72E2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     72E4 228A 
0184 72E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72E8 2296 
0185 72EA 05A0  34         inc   @fb.row.length        ; @fb.row.length
     72EC 2288 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 72EE 0460  28         b     @edkey.action.char.overwrite
     72F0 73CA 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 72F2 0460  28         b     @ed_wait              ; Back to editor main
     72F4 7C7E 
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
0206 72F6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72F8 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 72FA 8820  54         c     @fb.row.dirty,@w$ffff
     72FC 228A 
     72FE 6048 
0211 7300 1604  14         jne   edkey.action.ins_line.insert
0212 7302 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7304 770C 
0213 7306 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7308 228A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 730A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     730C 7530 
0219 730E C820  54         mov   @fb.topline,@parm1
     7310 2284 
     7312 8350 
0220 7314 A820  54         a     @fb.row,@parm1        ; Line number to insert
     7316 2286 
     7318 8350 
0221               
0222 731A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     731C 2304 
     731E 8352 
0223 7320 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7322 7682 
0224 7324 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     7326 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 7328 C820  54         mov   @fb.topline,@parm1
     732A 2284 
     732C 8350 
0229 732E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7330 754C 
0230 7332 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7334 2296 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 7336 0460  28         b     @ed_wait              ; Back to editor main
     7338 7C7E 
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
0249 733A 8820  54         c     @fb.row.dirty,@w$ffff
     733C 228A 
     733E 6048 
0250 7340 1606  14         jne   edkey.action.enter.upd_counter
0251 7342 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7344 2306 
0252 7346 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7348 770C 
0253 734A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     734C 228A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 734E C120  34         mov   @fb.topline,tmp0
     7350 2284 
0259 7352 A120  34         a     @fb.row,tmp0
     7354 2286 
0260 7356 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7358 2304 
0261 735A 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 735C 05A0  34         inc   @edb.lines            ; Total lines++
     735E 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 7360 C120  34         mov   @fb.scrrows,tmp0
     7362 2298 
0271 7364 0604  14         dec   tmp0
0272 7366 8120  34         c     @fb.row,tmp0
     7368 2286 
0273 736A 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 736C C120  34         mov   @fb.scrrows,tmp0
     736E 2298 
0278 7370 C820  54         mov   @fb.topline,@parm1
     7372 2284 
     7374 8350 
0279 7376 05A0  34         inc   @parm1
     7378 8350 
0280 737A 06A0  32         bl    @fb.refresh
     737C 754C 
0281 737E 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 7380 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7382 2286 
0287 7384 06A0  32         bl    @down                 ; Row++ VDP cursor
     7386 666E 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 7388 06A0  32         bl    @fb.get.firstnonblank
     738A 75C4 
0293 738C C120  34         mov   @outparm1,tmp0
     738E 8360 
0294 7390 C804  38         mov   tmp0,@fb.column
     7392 228C 
0295 7394 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     7396 6680 
0296 7398 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     739A 78A4 
0297 739C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     739E 7530 
0298 73A0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     73A2 2296 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 73A4 0460  28         b     @ed_wait              ; Back to editor main
     73A6 7C7E 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 73A8 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     73AA 230A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 73AC 0204  20         li    tmp0,2000
     73AE 07D0 
0317               edkey.action.ins_onoff.loop:
0318 73B0 0604  14         dec   tmp0
0319 73B2 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 73B4 0460  28         b     @task2.cur_visible    ; Update cursor shape
     73B6 7D30 
0325               
0326               
0327               
0328               
0329               
0330               
0331               *---------------------------------------------------------------
0332               * Process character
0333               *---------------------------------------------------------------
0334               edkey.action.char:
0335 73B8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     73BA 2306 
0336 73BC D805  38         movb  tmp1,@parm1           ; Store character for insert
     73BE 8350 
0337 73C0 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     73C2 230A 
0338 73C4 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 73C6 0460  28         b     @edkey.action.ins_char
     73C8 72A8 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 73CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73CC 7530 
0349 73CE C120  34         mov   @fb.current,tmp0      ; Get pointer
     73D0 2282 
0350               
0351 73D2 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     73D4 8350 
0352 73D6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     73D8 228A 
0353 73DA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     73DC 2296 
0354               
0355 73DE 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     73E0 228C 
0356 73E2 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     73E4 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 73E6 8820  54         c     @fb.column,@fb.row.length
     73E8 228C 
     73EA 2288 
0361 73EC 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 73EE C820  54         mov   @fb.column,@fb.row.length
     73F0 228C 
     73F2 2288 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 73F4 0460  28         b     @ed_wait              ; Back to editor main
     73F6 7C7E 
**** **** ****     > tivi.asm.22880
0282                       copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
**** **** ****     > edkey.misc.asm
0001               * FILE......: edkey.misc.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 73F8 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     73FA 6730 
0010 73FC 0420  54         blwp  @0                    ; Exit
     73FE 0000 
0011               
0012               
0013               
0014               *---------------------------------------------------------------
0015               * Show/Hide command buffer pane
0016               ********|*****|*********************|**************************
0017               edkey.action.cmdb.toggle:
0018 7400 0560  34         inv   @cmdb.visible
     7402 2502 
0019               *       jeq   edkey.action.cmdb.hide
0020                       ;-------------------------------------------------------
0021                       ; Show pane
0022                       ;-------------------------------------------------------
0023               edkey.action.cmdb.show:
0024 7404 0204  20         li    tmp0,5
     7406 0005 
0025 7408 C804  38         mov   tmp0,@parm1           ; Set pane size
     740A 8350 
0026               
0027 740C 06A0  32         bl    @cmdb.show            ; \ Show command buffer pane
     740E 78DA 
0028                                                   ; | i  parm1 = Size in rows
0029                                                   ; /
0030 7410 1002  14         jmp   edkey.action.cmdb.toggle.exit
0031                       ;-------------------------------------------------------
0032                       ; Hide pane
0033                       ;-------------------------------------------------------
0034               edkey.action.cmdb.hide:
0035 7412 06A0  32         bl    @cmdb.hide             ; Hide command buffer pane
     7414 7902 
0036               
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 7416 0460  28         b     @ed_wait              ; Back to editor main
     7418 7C7E 
0042               
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Framebuffer down 1 row
0047               *---------------------------------------------------------------
0048               edkey.action.fbdown:
0049 741A 05A0  34         inc   @fb.scrrows
     741C 2298 
0050 741E 0720  34         seto  @fb.dirty
     7420 2296 
0051               
0052 7422 069B  24         bl    *r11
**** **** ****     > tivi.asm.22880
0283                       copy  "edkey.file.asm"      ; Actions for file related keys
**** **** ****     > edkey.file.asm
0001               * FILE......: edkey.fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               edkey.action.buffer0:
0006 7424 0204  20         li   tmp0,fdname0
     7426 7F06 
0007 7428 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 742A 0204  20         li   tmp0,fdname1
     742C 7F14 
0010 742E 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 7430 0204  20         li   tmp0,fdname2
     7432 7F24 
0013 7434 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 7436 0204  20         li   tmp0,fdname3
     7438 7F32 
0016 743A 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 743C 0204  20         li   tmp0,fdname4
     743E 7F40 
0019 7440 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 7442 0204  20         li   tmp0,fdname5
     7444 7F4E 
0022 7446 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 7448 0204  20         li   tmp0,fdname6
     744A 7F5C 
0025 744C 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 744E 0204  20         li   tmp0,fdname7
     7450 7F6A 
0028 7452 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 7454 0204  20         li   tmp0,fdname8
     7456 7F78 
0031 7458 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 745A 0204  20         li   tmp0,fdname9
     745C 7F86 
0034 745E 1000  14         jmp  edkey.action.rest
0035               edkey.action.rest:
0036 7460 06A0  32         bl   @fm.loadfile           ; Load DIS/VAR 80 file into editor buffer
     7462 7B2E 
0037 7464 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     7466 716C 
**** **** ****     > tivi.asm.22880
0284                       copy  "mem.asm"             ; mem      - Memory Management
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
0021 7468 0649  14         dect  stack
0022 746A C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 746C 06A0  32         bl    @sams.layout
     746E 657C 
0027 7470 7476                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 7472 C2F9  30         mov   *stack+,r11           ; Pop r11
0033 7474 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 7476 2000             data  >2000,>0000           ; >2000-2fff, SAMS page >00
     7478 0000 
0039 747A 3000             data  >3000,>0001           ; >3000-3fff, SAMS page >01
     747C 0001 
0040 747E A000             data  >a000,>0002           ; >a000-afff, SAMS page >02
     7480 0002 
0041 7482 B000             data  >b000,>0003           ; >b000-bfff, SAMS page >03
     7484 0003 
0042 7486 C000             data  >c000,>0004           ; >c000-cfff, SAMS page >04
     7488 0004 
0043 748A D000             data  >d000,>0005           ; >d000-dfff, SAMS page >05
     748C 0005 
0044 748E E000             data  >e000,>0006           ; >e000-efff, SAMS page >06
     7490 0006 
0045 7492 F000             data  >f000,>0007           ; >f000-ffff, SAMS page >07
     7494 0007 
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
0068               * tmp0, tmp1
0069               ***************************************************************
0070               mem.edb.sams.pagein:
0071 7496 C13B  30         mov   *r11+,tmp0            ; Get p0
0072               xmem.edb.sams.pagein:
0073 7498 0649  14         dect  stack
0074 749A C64B  30         mov   r11,*stack            ; Save return address
0075 749C 0649  14         dect  stack
0076 749E C644  30         mov   tmp0,*stack           ; Save tmp0
0077 74A0 0649  14         dect  stack
0078 74A2 C645  30         mov   tmp1,*stack           ; Save tmp1
0079                       ;------------------------------------------------------
0080                       ; Sanity check
0081                       ;------------------------------------------------------
0082 74A4 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     74A6 2304 
0083 74A8 1104  14         jlt   mem.edb.sams.pagein.lookup
0084                                                   ; All checks passed, continue
0085                                                   ;--------------------------
0086                                                   ; Sanity check failed
0087                                                   ;--------------------------
0088 74AA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     74AC FFCE 
0089 74AE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     74B0 604C 
0090                       ;------------------------------------------------------
0091                       ; Lookup SAMS page for line in parm1
0092                       ;------------------------------------------------------
0093               mem.edb.sams.pagein.lookup:
0094 74B2 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     74B4 76C6 
0095                                                   ; \ i  parm1    = Line number
0096                                                   ; | o  outparm1 = Pointer to line
0097                                                   ; / o  outparm2 = SAMS page
0098               
0099 74B6 C160  34         mov   @outparm1,tmp1        ; Memory address
     74B8 8360 
0100 74BA 1304  14         jeq   mem.edb.sams.pagein.exit
0101                                                   ; Nothing to page-in if empty line
0102               
0103 74BC C120  34         mov   @outparm2,tmp0        ; SAMS page
     74BE 8362 
0104               
0105                       ;------------------------------------------------------
0106                       ; Activate SAMS page where specified line is stored
0107                       ;------------------------------------------------------
0108 74C0 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     74C2 6516 
0109                                                   ; \ i  tmp0 = SAMS page
0110                                                   ; / i  tmp1 = Memory address
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               mem.edb.sams.pagein.exit
0115 74C4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0116 74C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0117 74C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0118 74CA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi.asm.22880
0285                       copy  "fb.asm"              ; fb       - Framebuffer
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
0024 74CC 0649  14         dect  stack
0025 74CE C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 74D0 0204  20         li    tmp0,fb.top
     74D2 2650 
0030 74D4 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     74D6 2280 
0031 74D8 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     74DA 2284 
0032 74DC 04E0  34         clr   @fb.row               ; Current row=0
     74DE 2286 
0033 74E0 04E0  34         clr   @fb.column            ; Current column=0
     74E2 228C 
0034               
0035 74E4 0204  20         li    tmp0,80
     74E6 0050 
0036 74E8 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     74EA 228E 
0037               
0038 74EC 0204  20         li    tmp0,27
     74EE 001B 
0039 74F0 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
     74F2 2298 
0040 74F4 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     74F6 229A 
0041               
0042 74F8 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     74FA 2296 
0043                       ;------------------------------------------------------
0044                       ; Clear frame buffer
0045                       ;------------------------------------------------------
0046 74FC 06A0  32         bl    @film
     74FE 6230 
0047 7500 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7502 0000 
     7504 09B0 
0048                       ;------------------------------------------------------
0049                       ; Show banner (line above frame buffer, not part of it)
0050                       ;------------------------------------------------------
0051 7506 06A0  32         bl    @hchar
     7508 675C 
0052 750A 0000                   byte 0,0,2,80         ; Double line
     750C 0250 
0053 750E FFFF                   data EOL
0054               
0055 7510 06A0  32         bl    @putat
     7512 642A 
0056 7514 001E                   byte 0,30
0057 7516 7EEC                   data txt_tivi         ; Banner
0058                       ;------------------------------------------------------
0059                       ; Exit
0060                       ;------------------------------------------------------
0061               fb.init.exit
0062 7518 0460  28         b     @poprt                ; Return to caller
     751A 622C 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * fb.row2line
0069               * Calculate line in editor buffer
0070               ***************************************************************
0071               * bl @fb.row2line
0072               *--------------------------------------------------------------
0073               * INPUT
0074               * @fb.topline = Top line in frame buffer
0075               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0076               *--------------------------------------------------------------
0077               * OUTPUT
0078               * @outparm1 = Matching line in editor buffer
0079               *--------------------------------------------------------------
0080               * Register usage
0081               * tmp2,tmp3
0082               *--------------------------------------------------------------
0083               * Formula
0084               * outparm1 = @fb.topline + @parm1
0085               ********|*****|*********************|**************************
0086               fb.row2line:
0087 751C 0649  14         dect  stack
0088 751E C64B  30         mov   r11,*stack            ; Save return address
0089                       ;------------------------------------------------------
0090                       ; Calculate line in editor buffer
0091                       ;------------------------------------------------------
0092 7520 C120  34         mov   @parm1,tmp0
     7522 8350 
0093 7524 A120  34         a     @fb.topline,tmp0
     7526 2284 
0094 7528 C804  38         mov   tmp0,@outparm1
     752A 8360 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               fb.row2line$$:
0099 752C 0460  28         b    @poprt                 ; Return to caller
     752E 622C 
0100               
0101               
0102               
0103               
0104               ***************************************************************
0105               * fb.calc_pointer
0106               * Calculate pointer address in frame buffer
0107               ***************************************************************
0108               * bl @fb.calc_pointer
0109               *--------------------------------------------------------------
0110               * INPUT
0111               * @fb.top       = Address of top row in frame buffer
0112               * @fb.topline   = Top line in frame buffer
0113               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0114               * @fb.column    = Current column in frame buffer
0115               * @fb.colsline  = Columns per line in frame buffer
0116               *--------------------------------------------------------------
0117               * OUTPUT
0118               * @fb.current   = Updated pointer
0119               *--------------------------------------------------------------
0120               * Register usage
0121               * tmp2,tmp3
0122               *--------------------------------------------------------------
0123               * Formula
0124               * pointer = row * colsline + column + deref(@fb.top.ptr)
0125               ********|*****|*********************|**************************
0126               fb.calc_pointer:
0127 7530 0649  14         dect  stack
0128 7532 C64B  30         mov   r11,*stack            ; Save return address
0129                       ;------------------------------------------------------
0130                       ; Calculate pointer
0131                       ;------------------------------------------------------
0132 7534 C1A0  34         mov   @fb.row,tmp2
     7536 2286 
0133 7538 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     753A 228E 
0134 753C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     753E 228C 
0135 7540 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7542 2280 
0136 7544 C807  38         mov   tmp3,@fb.current
     7546 2282 
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140               fb.calc_pointer.$$
0141 7548 0460  28         b    @poprt                 ; Return to caller
     754A 622C 
0142               
0143               
0144               
0145               
0146               ***************************************************************
0147               * fb.refresh
0148               * Refresh frame buffer with editor buffer content
0149               ***************************************************************
0150               * bl @fb.refresh
0151               *--------------------------------------------------------------
0152               * INPUT
0153               * @parm1 = Line to start with (becomes @fb.topline)
0154               *--------------------------------------------------------------
0155               * OUTPUT
0156               * none
0157               *--------------------------------------------------------------
0158               * Register usage
0159               * tmp0,tmp1,tmp2
0160               ********|*****|*********************|**************************
0161               fb.refresh:
0162 754C 0649  14         dect  stack
0163 754E C64B  30         mov   r11,*stack            ; Push return address
0164 7550 0649  14         dect  stack
0165 7552 C644  30         mov   tmp0,*stack           ; Push tmp0
0166 7554 0649  14         dect  stack
0167 7556 C645  30         mov   tmp1,*stack           ; Push tmp1
0168 7558 0649  14         dect  stack
0169 755A C646  30         mov   tmp2,*stack           ; Push tmp2
0170               
0171                       ;------------------------------------------------------
0172                       ; Update SAMS shadow registers in RAM
0173                       ;------------------------------------------------------
0174 755C 06A0  32         bl    @sams.copy.layout     ; Copy SAMS memory layout
     755E 65E0 
0175 7560 2200                   data tv.sams.2000     ; \ i  p0 = Pointer to 8 words RAM buffer
0176                                                   ; /
0177                       ;------------------------------------------------------
0178                       ; Setup starting position in index
0179                       ;------------------------------------------------------
0180 7562 C820  54         mov   @parm1,@fb.topline
     7564 8350 
     7566 2284 
0181 7568 04E0  34         clr   @parm2                ; Target row in frame buffer
     756A 8352 
0182                       ;------------------------------------------------------
0183                       ; Check if already at EOF
0184                       ;------------------------------------------------------
0185 756C 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     756E 8350 
     7570 2304 
0186 7572 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0187                       ;------------------------------------------------------
0188                       ; Unpack line to frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.unpack_line:
0191 7574 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7576 77B4 
0192                                                   ; \ i  parm1 = Line to unpack
0193                                                   ; / i  parm2 = Target row in frame buffer
0194               
0195 7578 05A0  34         inc   @parm1                ; Next line in editor buffer
     757A 8350 
0196 757C 05A0  34         inc   @parm2                ; Next row in frame buffer
     757E 8352 
0197                       ;------------------------------------------------------
0198                       ; Last row in editor buffer reached ?
0199                       ;------------------------------------------------------
0200 7580 8820  54         c     @parm1,@edb.lines
     7582 8350 
     7584 2304 
0201 7586 1113  14         jlt   !                     ; no, do next check
0202                                                   ; yes, erase until end of frame buffer
0203                       ;------------------------------------------------------
0204                       ; Erase until end of frame buffer
0205                       ;------------------------------------------------------
0206               fb.refresh.erase_eob:
0207 7588 C120  34         mov   @parm2,tmp0           ; Current row
     758A 8352 
0208 758C C160  34         mov   @fb.scrrows,tmp1   ; Rows framebuffer
     758E 2298 
0209 7590 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0210 7592 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     7594 228E 
0211               
0212 7596 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0213 7598 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0214               
0215 759A 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     759C 228E 
0216 759E A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     75A0 2280 
0217               
0218 75A2 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0219 75A4 0205  20         li    tmp1,32               ; Clear with space
     75A6 0020 
0220               
0221 75A8 06A0  32         bl    @xfilm                ; \ Fill memory
     75AA 6236 
0222                                                   ; | i  tmp0 = Memory start address
0223                                                   ; | i  tmp1 = Byte to fill
0224                                                   ; / i  tmp2 = Number of bytes to fill
0225 75AC 1004  14         jmp   fb.refresh.exit
0226                       ;------------------------------------------------------
0227                       ; Bottom row in frame buffer reached ?
0228                       ;------------------------------------------------------
0229 75AE 8820  54 !       c     @parm2,@fb.scrrows
     75B0 8352 
     75B2 2298 
0230 75B4 11DF  14         jlt   fb.refresh.unpack_line
0231                                                   ; No, unpack next line
0232                       ;------------------------------------------------------
0233                       ; Exit
0234                       ;------------------------------------------------------
0235               fb.refresh.exit:
0236 75B6 0720  34         seto  @fb.dirty             ; Refresh screen
     75B8 2296 
0237 75BA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0238 75BC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0239 75BE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0240 75C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0241 75C2 045B  20         b     *r11                  ; Return to caller
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
0255 75C4 0649  14         dect  stack
0256 75C6 C64B  30         mov   r11,*stack            ; Save return address
0257                       ;------------------------------------------------------
0258                       ; Prepare for scanning
0259                       ;------------------------------------------------------
0260 75C8 04E0  34         clr   @fb.column
     75CA 228C 
0261 75CC 06A0  32         bl    @fb.calc_pointer
     75CE 7530 
0262 75D0 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     75D2 78A4 
0263 75D4 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     75D6 2288 
0264 75D8 1313  14         jeq   fb.get.firstnonblank.nomatch
0265                                                   ; Exit if empty line
0266 75DA C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     75DC 2282 
0267 75DE 04C5  14         clr   tmp1
0268                       ;------------------------------------------------------
0269                       ; Scan line for non-blank character
0270                       ;------------------------------------------------------
0271               fb.get.firstnonblank.loop:
0272 75E0 D174  28         movb  *tmp0+,tmp1           ; Get character
0273 75E2 130E  14         jeq   fb.get.firstnonblank.nomatch
0274                                                   ; Exit if empty line
0275 75E4 0285  22         ci    tmp1,>2000            ; Whitespace?
     75E6 2000 
0276 75E8 1503  14         jgt   fb.get.firstnonblank.match
0277 75EA 0606  14         dec   tmp2                  ; Counter--
0278 75EC 16F9  14         jne   fb.get.firstnonblank.loop
0279 75EE 1008  14         jmp   fb.get.firstnonblank.nomatch
0280                       ;------------------------------------------------------
0281                       ; Non-blank character found
0282                       ;------------------------------------------------------
0283               fb.get.firstnonblank.match:
0284 75F0 6120  34         s     @fb.current,tmp0      ; Calculate column
     75F2 2282 
0285 75F4 0604  14         dec   tmp0
0286 75F6 C804  38         mov   tmp0,@outparm1        ; Save column
     75F8 8360 
0287 75FA D805  38         movb  tmp1,@outparm2        ; Save character
     75FC 8362 
0288 75FE 1004  14         jmp   fb.get.firstnonblank.exit
0289                       ;------------------------------------------------------
0290                       ; No non-blank character found
0291                       ;------------------------------------------------------
0292               fb.get.firstnonblank.nomatch:
0293 7600 04E0  34         clr   @outparm1             ; X=0
     7602 8360 
0294 7604 04E0  34         clr   @outparm2             ; Null
     7606 8362 
0295                       ;------------------------------------------------------
0296                       ; Exit
0297                       ;------------------------------------------------------
0298               fb.get.firstnonblank.exit:
0299 7608 0460  28         b    @poprt                 ; Return to caller
     760A 622C 
**** **** ****     > tivi.asm.22880
0286                       copy  "idx.asm"             ; idx      - Index management
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
0011               * 1) Main index (3000 - 3fff)
0012               *
0013               *    Size of index page is 4K and allows indexing of 2048 lines.
0014               *    Each index slot (1 word) contains the pointer to the line
0015               *    in the editor buffer.
0016               *
0017               * 2) Shadow index (a000 - afff)
0018               *
0019               *    Size of index page is 4K and allows indexing of 2048 lines.
0020               *    Each index slot (1 word) contains the SAMS page where the
0021               *    line in the editor buffer resides
0022               *
0023               *
0024               * The editor buffer itself always resides at (b000 -> ffff) for
0025               * a total of 20kb.
0026               * First line in editor buffer starts at offset 2 (b002), this
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
0048 760C 0649  14         dect  stack
0049 760E C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 7610 0204  20         li    tmp0,idx.top
     7612 3000 
0054 7614 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7616 2302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 7618 06A0  32         bl    @film
     761A 6230 
0059 761C 3000             data  idx.top,>00,idx.size  ; Clear main index
     761E 0000 
     7620 1000 
0060               
0061 7622 06A0  32         bl    @film
     7624 6230 
0062 7626 A000             data  idx.shadow.top,>00,idx.shadow.size
     7628 0000 
     762A 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 762C 0460  28         b     @poprt                ; Return to caller
     762E 622C 
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
0090 7630 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7632 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 7634 C160  34         mov   @parm2,tmp1
     7636 8352 
0095 7638 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 763A C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     763C 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 763E 0A14  56         sla   tmp0,1                ; line number * 2
0107 7640 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     7642 3000 
0108 7644 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     7646 A000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 7648 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     764A 8360 
0115 764C 045B  20         b     *r11                  ; Return
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
0135 764E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7650 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 7652 0A14  56         sla   tmp0,1                ; line number * 2
0140 7654 C824  54         mov   @idx.top(tmp0),@outparm1
     7656 3000 
     7658 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 765A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     765C 8352 
0146 765E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7660 8350 
0147 7662 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 7664 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 7666 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7668 3002 
     766A 3000 
0157 766C C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     766E A002 
     7670 A000 
0158 7672 05C4  14         inct  tmp0                  ; Next index entry
0159 7674 0606  14         dec   tmp2                  ; tmp2--
0160 7676 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 7678 04E4  34         clr   @idx.top(tmp0)
     767A 3000 
0167 767C 04E4  34         clr   @idx.shadow.top(tmp0)
     767E A000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 7680 045B  20         b     *r11                  ; Return
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
0192 7682 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7684 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 7686 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 7688 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     768A 8352 
0201 768C 61A0  34         s     @parm1,tmp2           ; Calculate loop
     768E 8350 
0202 7690 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 7692 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7694 3000 
     7696 3002 
0207                                                   ; Move pointer
0208 7698 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     769A 3000 
0209               
0210 769C C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     769E A000 
     76A0 A002 
0211                                                   ; Move SAMS page
0212 76A2 04E4  34         clr   @idx.shadow.top+0(tmp0)
     76A4 A000 
0213                                                   ; Clear new index entry
0214 76A6 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 76A8 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 76AA C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     76AC 3000 
     76AE 3002 
0222                                                   ; Move pointer
0223               
0224 76B0 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     76B2 A000 
     76B4 A002 
0225                                                   ; Move SAMS page
0226               
0227 76B6 0644  14         dect  tmp0                  ; Previous index entry
0228 76B8 0606  14         dec   tmp2                  ; tmp2--
0229 76BA 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 76BC 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     76BE 3004 
0232 76C0 04E4  34         clr   @idx.shadow.top+4(tmp0)
     76C2 A004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 76C4 045B  20         b     *r11                  ; Return
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
0259 76C6 0649  14         dect  stack
0260 76C8 C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 76CA C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76CC 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 76CE 0A14  56         sla   tmp0,1                ; line number * 2
0269 76D0 C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     76D2 3000 
0270 76D4 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     76D6 A000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 76D8 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     76DA 8360 
0277 76DC C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     76DE 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 76E0 0460  28         b     @poprt                ; Return to caller
     76E2 622C 
**** **** ****     > tivi.asm.22880
0287                       copy  "edb.asm"             ; edb      - Editor Buffer
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
0026 76E4 0649  14         dect  stack
0027 76E6 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 76E8 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     76EA B002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 76EC C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     76EE 2300 
0035 76F0 C804  38         mov   tmp0,@edb.next_free.ptr
     76F2 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037               
0038 76F4 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     76F6 230A 
0039 76F8 04E0  34         clr   @edb.lines            ; Lines=0
     76FA 2304 
0040 76FC 04E0  34         clr   @edb.rle              ; RLE compression off
     76FE 230C 
0041               
0042 7700 0204  20         li    tmp0,txt_newfile
     7702 7EE0 
0043 7704 C804  38         mov   tmp0,@edb.filename.ptr
     7706 230E 
0044               
0045               
0046               edb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7708 0460  28         b     @poprt                ; Return to caller
     770A 622C 
0051               
0052               
0053               
0054               ***************************************************************
0055               * edb.line.pack
0056               * Pack current line in framebuffer
0057               ***************************************************************
0058               *  bl   @edb.line.pack
0059               *--------------------------------------------------------------
0060               * INPUT
0061               * @fb.top       = Address of top row in frame buffer
0062               * @fb.row       = Current row in frame buffer
0063               * @fb.column    = Current column in frame buffer
0064               * @fb.colsline  = Columns per line in frame buffer
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               *--------------------------------------------------------------
0068               * Register usage
0069               * tmp0,tmp1,tmp2
0070               *--------------------------------------------------------------
0071               * Memory usage
0072               * rambuf   = Saved @fb.column
0073               * rambuf+2 = Saved beginning of row
0074               * rambuf+4 = Saved length of row
0075               ********|*****|*********************|**************************
0076               edb.line.pack:
0077 770C 0649  14         dect  stack
0078 770E C64B  30         mov   r11,*stack            ; Save return address
0079                       ;------------------------------------------------------
0080                       ; Get values
0081                       ;------------------------------------------------------
0082 7710 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7712 228C 
     7714 8390 
0083 7716 04E0  34         clr   @fb.column
     7718 228C 
0084 771A 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     771C 7530 
0085                       ;------------------------------------------------------
0086                       ; Prepare scan
0087                       ;------------------------------------------------------
0088 771E 04C4  14         clr   tmp0                  ; Counter
0089 7720 C160  34         mov   @fb.current,tmp1      ; Get position
     7722 2282 
0090 7724 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7726 8392 
0091               
0092                       ;------------------------------------------------------
0093                       ; Scan line for >00 byte termination
0094                       ;------------------------------------------------------
0095               edb.line.pack.scan:
0096 7728 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0097 772A 0986  56         srl   tmp2,8                ; Right justify
0098 772C 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0099 772E 0584  14         inc   tmp0                  ; Increase string length
0100 7730 10FB  14         jmp   edb.line.pack.scan    ; Next character
0101               
0102                       ;------------------------------------------------------
0103                       ; Prepare for storing line
0104                       ;------------------------------------------------------
0105               edb.line.pack.prepare:
0106 7732 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7734 2284 
     7736 8350 
0107 7738 A820  54         a     @fb.row,@parm1        ; /
     773A 2286 
     773C 8350 
0108               
0109 773E C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7740 8394 
0110               
0111                       ;------------------------------------------------------
0112                       ; 1. Update index
0113                       ;------------------------------------------------------
0114               edb.line.pack.update_index:
0115 7742 C120  34         mov   @edb.next_free.ptr,tmp0
     7744 2308 
0116 7746 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     7748 8352 
0117               
0118 774A 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     774C 64DE 
0119                                                   ; \ i  tmp0  = Memory address
0120                                                   ; | o  waux1 = SAMS page number
0121                                                   ; / o  waux2 = Address of SAMS register
0122               
0123 774E C820  54         mov   @waux1,@parm3
     7750 833C 
     7752 8354 
0124 7754 06A0  32         bl    @idx.entry.update     ; Update index
     7756 7630 
0125                                                   ; \ i  parm1 = Line number in editor buffer
0126                                                   ; | i  parm2 = pointer to line in editor buffer
0127                                                   ; / i  parm3 = SAMS page
0128               
0129                       ;------------------------------------------------------
0130                       ; 2. Switch to required SAMS page
0131                       ;------------------------------------------------------
0132 7758 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     775A 2310 
     775C 8354 
0133 775E 1308  14         jeq   !                     ; Yes, skip setting page
0134               
0135 7760 C120  34         mov   @parm3,tmp0           ; get SAMS page
     7762 8354 
0136 7764 C160  34         mov   @edb.next_free.ptr,tmp1
     7766 2308 
0137                                                   ; Pointer to line in editor buffer
0138 7768 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     776A 6516 
0139                                                   ; \ i  tmp0 = SAMS page
0140                                                   ; / i  tmp1 = Memory address
0141               
0142 776C C804  38         mov   tmp0,@tfh.sams.page   ; Save current SAMS page
     776E 2438 
0143               
0144                       ;------------------------------------------------------
0145                       ; 3. Set line prefix in editor buffer
0146                       ;------------------------------------------------------
0147 7770 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     7772 8392 
0148 7774 C160  34         mov   @edb.next_free.ptr,tmp1
     7776 2308 
0149                                                   ; Address of line in editor buffer
0150               
0151 7778 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     777A 2308 
0152               
0153 777C C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     777E 8394 
0154 7780 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0155 7782 06C6  14         swpb  tmp2
0156 7784 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0157 7786 06C6  14         swpb  tmp2
0158 7788 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0159               
0160                       ;------------------------------------------------------
0161                       ; 4. Copy line from framebuffer to editor buffer
0162                       ;------------------------------------------------------
0163               edb.line.pack.copyline:
0164 778A 0286  22         ci    tmp2,2
     778C 0002 
0165 778E 1603  14         jne   edb.line.pack.copyline.checkbyte
0166 7790 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0167 7792 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0168 7794 1007  14         jmp   !
0169               edb.line.pack.copyline.checkbyte:
0170 7796 0286  22         ci    tmp2,1
     7798 0001 
0171 779A 1602  14         jne   edb.line.pack.copyline.block
0172 779C D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0173 779E 1002  14         jmp   !
0174               edb.line.pack.copyline.block:
0175 77A0 06A0  32         bl    @xpym2m               ; Copy memory block
     77A2 6480 
0176                                                   ; \ i  tmp0 = source
0177                                                   ; | i  tmp1 = destination
0178                                                   ; / i  tmp2 = bytes to copy
0179               
0180 77A4 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     77A6 8394 
     77A8 2308 
0181                                                   ; Update pointer to next free line
0182               
0183                       ;------------------------------------------------------
0184                       ; Exit
0185                       ;------------------------------------------------------
0186               edb.line.pack.exit:
0187 77AA C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     77AC 8390 
     77AE 228C 
0188 77B0 0460  28         b     @poprt                ; Return to caller
     77B2 622C 
0189               
0190               
0191               
0192               
0193               ***************************************************************
0194               * edb.line.unpack
0195               * Unpack specified line to framebuffer
0196               ***************************************************************
0197               *  bl   @edb.line.unpack
0198               *--------------------------------------------------------------
0199               * INPUT
0200               * @parm1 = Line to unpack in editor buffer
0201               * @parm2 = Target row in frame buffer
0202               *--------------------------------------------------------------
0203               * OUTPUT
0204               * none
0205               *--------------------------------------------------------------
0206               * Register usage
0207               * tmp0,tmp1,tmp2,tmp3,tmp4
0208               *--------------------------------------------------------------
0209               * Memory usage
0210               * rambuf    = Saved @parm1 of edb.line.unpack
0211               * rambuf+2  = Saved @parm2 of edb.line.unpack
0212               * rambuf+4  = Source memory address in editor buffer
0213               * rambuf+6  = Destination memory address in frame buffer
0214               * rambuf+8  = Length of RLE (decompressed) line
0215               * rambuf+10 = Length of RLE compressed line
0216               ********|*****|*********************|**************************
0217               edb.line.unpack:
0218 77B4 0649  14         dect  stack
0219 77B6 C64B  30         mov   r11,*stack            ; Save return address
0220                       ;------------------------------------------------------
0221                       ; Sanity check
0222                       ;------------------------------------------------------
0223 77B8 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     77BA 8350 
     77BC 2304 
0224 77BE 1104  14         jlt   !
0225 77C0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     77C2 FFCE 
0226 77C4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     77C6 604C 
0227                       ;------------------------------------------------------
0228                       ; Save parameters
0229                       ;------------------------------------------------------
0230 77C8 C820  54 !       mov   @parm1,@rambuf
     77CA 8350 
     77CC 8390 
0231 77CE C820  54         mov   @parm2,@rambuf+2
     77D0 8352 
     77D2 8392 
0232                       ;------------------------------------------------------
0233                       ; Calculate offset in frame buffer
0234                       ;------------------------------------------------------
0235 77D4 C120  34         mov   @fb.colsline,tmp0
     77D6 228E 
0236 77D8 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     77DA 8352 
0237 77DC C1A0  34         mov   @fb.top.ptr,tmp2
     77DE 2280 
0238 77E0 A146  18         a     tmp2,tmp1             ; Add base to offset
0239 77E2 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     77E4 8396 
0240                       ;------------------------------------------------------
0241                       ; Get pointer to line & page-in editor buffer page
0242                       ;------------------------------------------------------
0243 77E6 C120  34         mov   @parm1,tmp0
     77E8 8350 
0244 77EA 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     77EC 7498 
0245                                                   ; \ i  tmp0     = Line number
0246                                                   ; | o  outparm1 = Pointer to line
0247                                                   ; / o  outparm2 = SAMS page
0248               
0249 77EE C820  54         mov   @outparm2,@edb.sams.page
     77F0 8362 
     77F2 2310 
0250                                                   ; Save current SAMS page
0251               
0252 77F4 05E0  34         inct  @outparm1             ; Skip line prefix
     77F6 8360 
0253 77F8 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     77FA 8360 
     77FC 8394 
0254                       ;------------------------------------------------------
0255                       ; Get length of line to unpack
0256                       ;------------------------------------------------------
0257 77FE 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7800 786C 
0258                                                   ; \ i  parm1    = Line number
0259                                                   ; | o  outparm1 = Line length (uncompressed)
0260                                                   ; | o  outparm2 = Line length (compressed)
0261                                                   ; / o  outparm3 = SAMS page
0262               
0263 7802 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7804 8362 
     7806 839A 
0264 7808 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     780A 8360 
     780C 8398 
0265 780E 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line anyway
0266                       ;------------------------------------------------------
0267                       ; Handle possible "line split" between 2 consecutive pages
0268                       ;------------------------------------------------------
0269 7810 C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
     7812 8394 
0270 7814 C144  18         mov     tmp0,tmp1           ; Pointer to line
0271 7816 A160  34         a       @rambuf+8,tmp1      ; Add length of line
     7818 8398 
0272               
0273 781A 0244  22         andi    tmp0,>f000          ; Only keep high nibble
     781C F000 
0274 781E 0245  22         andi    tmp1,>f000          ; Only keep high nibble
     7820 F000 
0275 7822 8144  18         c       tmp0,tmp1           ; Same segment?
0276 7824 1305  14         jeq     edb.line.unpack.clear
0277                                                   ; Yes, so skip
0278               
0279 7826 C120  34         mov     @outparm3,tmp0      ; Get SAMS page
     7828 8364 
0280 782A 0584  14         inc     tmp0                ; Next sams page
0281               
0282 782C 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
     782E 6516 
0283                                                   ; | i  tmp0 = SAMS page number
0284                                                   ; / i  tmp1 = Memory Address
0285               
0286                       ;------------------------------------------------------
0287                       ; Erase chars from last column until column 80
0288                       ;------------------------------------------------------
0289               edb.line.unpack.clear:
0290 7830 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7832 8396 
0291 7834 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7836 8398 
0292               
0293 7838 04C5  14         clr   tmp1                  ; Fill with >00
0294 783A C1A0  34         mov   @fb.colsline,tmp2
     783C 228E 
0295 783E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7840 8398 
0296 7842 0586  14         inc   tmp2
0297               
0298 7844 06A0  32         bl    @xfilm                ; Fill CPU memory
     7846 6236 
0299                                                   ; \ i  tmp0 = Target address
0300                                                   ; | i  tmp1 = Byte to fill
0301                                                   ; / i  tmp2 = Repeat count
0302                       ;------------------------------------------------------
0303                       ; Prepare for unpacking data
0304                       ;------------------------------------------------------
0305               edb.line.unpack.prepare:
0306 7848 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     784A 8398 
0307 784C 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0308 784E C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7850 8394 
0309 7852 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7854 8396 
0310                       ;------------------------------------------------------
0311                       ; Check before copy
0312                       ;------------------------------------------------------
0313               edb.line.unpack.copy.uncompressed:
0314 7856 0286  22         ci    tmp2,80               ; Check line length
     7858 0050 
0315 785A 1204  14         jle   !
0316 785C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     785E FFCE 
0317 7860 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7862 604C 
0318                       ;------------------------------------------------------
0319                       ; Copy memory block
0320                       ;------------------------------------------------------
0321 7864 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     7866 6480 
0322                                                   ; \ i  tmp0 = Source address
0323                                                   ; | i  tmp1 = Target address
0324                                                   ; / i  tmp2 = Bytes to copy
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               edb.line.unpack.exit:
0329 7868 0460  28         b     @poprt                ; Return to caller
     786A 622C 
0330               
0331               
0332               
0333               
0334               ***************************************************************
0335               * edb.line.getlength
0336               * Get length of specified line
0337               ***************************************************************
0338               *  bl   @edb.line.getlength
0339               *--------------------------------------------------------------
0340               * INPUT
0341               * @parm1 = Line number
0342               *--------------------------------------------------------------
0343               * OUTPUT
0344               * @outparm1 = Length of line (uncompressed)
0345               * @outparm2 = Length of line (compressed)
0346               * @outparm3 = SAMS page
0347               *--------------------------------------------------------------
0348               * Register usage
0349               * tmp0,tmp1,tmp2
0350               ********|*****|*********************|**************************
0351               edb.line.getlength:
0352 786C 0649  14         dect  stack
0353 786E C64B  30         mov   r11,*stack            ; Save return address
0354                       ;------------------------------------------------------
0355                       ; Initialisation
0356                       ;------------------------------------------------------
0357 7870 04E0  34         clr   @outparm1             ; Reset uncompressed length
     7872 8360 
0358 7874 04E0  34         clr   @outparm2             ; Reset compressed length
     7876 8362 
0359 7878 04E0  34         clr   @outparm3             ; Reset SAMS bank
     787A 8364 
0360                       ;------------------------------------------------------
0361                       ; Get length
0362                       ;------------------------------------------------------
0363 787C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     787E 76C6 
0364                                                   ; \ i  parm1    = Line number
0365                                                   ; | o  outparm1 = Pointer to line
0366                                                   ; / o  outparm2 = SAMS page
0367               
0368 7880 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     7882 8360 
0369 7884 130D  14         jeq   edb.line.getlength.exit
0370                                                   ; Exit early if NULL pointer
0371 7886 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     7888 8362 
     788A 8364 
0372                       ;------------------------------------------------------
0373                       ; Process line prefix
0374                       ;------------------------------------------------------
0375 788C 04C5  14         clr   tmp1
0376 788E D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0377 7890 06C5  14         swpb  tmp1
0378 7892 C805  38         mov   tmp1,@outparm2        ; Save length
     7894 8362 
0379               
0380 7896 04C5  14         clr   tmp1
0381 7898 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0382 789A 06C5  14         swpb  tmp1
0383 789C C805  38         mov   tmp1,@outparm1        ; Save length
     789E 8360 
0384                       ;------------------------------------------------------
0385                       ; Exit
0386                       ;------------------------------------------------------
0387               edb.line.getlength.exit:
0388 78A0 0460  28         b     @poprt                ; Return to caller
     78A2 622C 
0389               
0390               
0391               
0392               
0393               ***************************************************************
0394               * edb.line.getlength2
0395               * Get length of current row (as seen from editor buffer side)
0396               ***************************************************************
0397               *  bl   @edb.line.getlength2
0398               *--------------------------------------------------------------
0399               * INPUT
0400               * @fb.row = Row in frame buffer
0401               *--------------------------------------------------------------
0402               * OUTPUT
0403               * @fb.row.length = Length of row
0404               *--------------------------------------------------------------
0405               * Register usage
0406               * tmp0
0407               ********|*****|*********************|**************************
0408               edb.line.getlength2:
0409 78A4 0649  14         dect  stack
0410 78A6 C64B  30         mov   r11,*stack            ; Save return address
0411                       ;------------------------------------------------------
0412                       ; Calculate line in editor buffer
0413                       ;------------------------------------------------------
0414 78A8 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     78AA 2284 
0415 78AC A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     78AE 2286 
0416                       ;------------------------------------------------------
0417                       ; Get length
0418                       ;------------------------------------------------------
0419 78B0 C804  38         mov   tmp0,@parm1
     78B2 8350 
0420 78B4 06A0  32         bl    @edb.line.getlength
     78B6 786C 
0421 78B8 C820  54         mov   @outparm1,@fb.row.length
     78BA 8360 
     78BC 2288 
0422                                                   ; Save row length
0423                       ;------------------------------------------------------
0424                       ; Exit
0425                       ;------------------------------------------------------
0426               edb.line.getlength2.exit:
0427 78BE 0460  28         b     @poprt                ; Return to caller
     78C0 622C 
0428               
**** **** ****     > tivi.asm.22880
0288                       copy  "cmdb.asm"            ; cmdb     - Command Buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: TiVi Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Command Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               ***************************************************************
0012               * cmdb.init
0013               * Initialize Command Buffer
0014               ***************************************************************
0015               * bl @cmdb.init
0016               *--------------------------------------------------------------
0017               * INPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * OUTPUT
0021               * none
0022               *--------------------------------------------------------------
0023               * Register usage
0024               * none
0025               *--------------------------------------------------------------
0026               * Notes
0027               ***************************************************************
0028               cmdb.init:
0029 78C2 0649  14         dect  stack
0030 78C4 C64B  30         mov   r11,*stack            ; Save return address
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 78C6 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     78C8 2502 
0035               
0036 78CA 0204  20         li    tmp0,5
     78CC 0005 
0037 78CE C804  38         mov   tmp0,@cmdb.default    ; Set default size
     78D0 2506 
0038 78D2 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current size
     78D4 2504 
0039               cmdb.init.exit:
0040                       ;------------------------------------------------------
0041                       ; Exit
0042                       ;------------------------------------------------------
0043 78D6 0460  28         b     @poprt                ; Return to caller
     78D8 622C 
0044               
0045               
0046               
0047               
0048               
0049               ***************************************************************
0050               * cmdb.show
0051               * Show command buffer pane
0052               ***************************************************************
0053               * bl @cmdb.show
0054               *--------------------------------------------------------------
0055               * INPUT
0056               * @parm1 = Size (in row)
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * none
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * none
0063               *--------------------------------------------------------------
0064               * Notes
0065               ***************************************************************
0066               cmdb.show:
0067 78DA 0649  14         dect  stack
0068 78DC C64B  30         mov   r11,*stack            ; Save return address
0069 78DE 0649  14         dect  stack
0070 78E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0071                       ;------------------------------------------------------
0072                       ; Show command buffer pane
0073                       ;------------------------------------------------------
0074 78E2 C820  54         mov   @parm1,@cmdb.scrrows  ; Set pane size
     78E4 8350 
     78E6 2504 
0075               
0076 78E8 C120  34         mov   @fb.scrrows.max,tmp0
     78EA 229A 
0077 78EC 6120  34         s     @cmdb.scrrows,tmp0
     78EE 2504 
0078 78F0 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     78F2 2298 
0079               
0080 78F4 0720  34         seto  @cmdb.visible         ; Show pane
     78F6 2502 
0081 78F8 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     78FA 2296 
0082               cmdb.show.exit:
0083                       ;------------------------------------------------------
0084                       ; Exit
0085                       ;------------------------------------------------------
0086 78FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 78FE 0460  28         b     @poprt                ; Return to caller
     7900 622C 
0088               
0089               
0090               
0091               ***************************************************************
0092               * cmdb.hide
0093               * Hide command buffer pane
0094               ***************************************************************
0095               * bl @cmdb.show
0096               *--------------------------------------------------------------
0097               * INPUT
0098               * none
0099               *--------------------------------------------------------------
0100               * OUTPUT
0101               * none
0102               *--------------------------------------------------------------
0103               * Register usage
0104               * none
0105               *--------------------------------------------------------------
0106               * Notes
0107               ***************************************************************
0108               cmdb.hide:
0109 7902 0649  14         dect  stack
0110 7904 C64B  30         mov   r11,*stack            ; Save return address
0111                       ;------------------------------------------------------
0112                       ; Hide command buffer pane
0113                       ;------------------------------------------------------
0114 7906 04E0  34         clr   @cmdb.visible         ; Hide pane
     7908 2502 
0115 790A C120  34         mov   @fb.scrrows.max,tmp0
     790C 229A 
0116 790E C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7910 2298 
0117               
0118 7912 0720  34         seto  @cmdb.visible         ; Show pane
     7914 2502 
0119 7916 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7918 2296 
0120               cmdb.hide.exit:
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124 791A 0460  28         b     @poprt                ; Return to caller
     791C 622C 
**** **** ****     > tivi.asm.22880
0289                       copy  "tfh.read.sams.asm"   ; tfh.sams - File handler read file (SAMS)
**** **** ****     > tfh.read.sams.asm
0001               * FILE......: tfh.read.sams.asm
0002               * Purpose...: File reader module (SAMS implementation)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tfh.file.read.sams
0011               * Read file into editor buffer with SAMS support
0012               ***************************************************************
0013               *  bl   @tfh.file.read.sams
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
0030               tfh.file.read.sams:
0031 791E 0649  14         dect  stack
0032 7920 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 7922 04E0  34         clr   @tfh.rleonload        ; No RLE compression!
     7924 2444 
0037 7926 04E0  34         clr   @tfh.records          ; Reset records counter
     7928 242E 
0038 792A 04E0  34         clr   @tfh.counter          ; Clear internal counter
     792C 2434 
0039 792E 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7930 2432 
0040 7932 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 7934 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7936 242A 
0042 7938 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     793A 242C 
0043               
0044 793C 0204  20         li    tmp0,3
     793E 0003 
0045 7940 C804  38         mov   tmp0,@tfh.sams.page   ; Set current SAMS page
     7942 2438 
0046 7944 C804  38         mov   tmp0,@tfh.sams.hpage  ; Set highest SAMS page in use
     7946 243A 
0047                       ;------------------------------------------------------
0048                       ; Save parameters / callback functions
0049                       ;------------------------------------------------------
0050 7948 C820  54         mov   @parm1,@tfh.fname.ptr ; Pointer to file descriptor
     794A 8350 
     794C 2436 
0051 794E C820  54         mov   @parm2,@tfh.callback1 ; Loading indicator 1
     7950 8352 
     7952 243C 
0052 7954 C820  54         mov   @parm3,@tfh.callback2 ; Loading indicator 2
     7956 8354 
     7958 243E 
0053 795A C820  54         mov   @parm4,@tfh.callback3 ; Loading indicator 3
     795C 8356 
     795E 2440 
0054 7960 C820  54         mov   @parm5,@tfh.callback4 ; File I/O error handler
     7962 8358 
     7964 2442 
0055                       ;------------------------------------------------------
0056                       ; Sanity check
0057                       ;------------------------------------------------------
0058 7966 C120  34         mov   @tfh.callback1,tmp0
     7968 243C 
0059 796A 0284  22         ci    tmp0,>6000            ; Insane address ?
     796C 6000 
0060 796E 1114  14         jlt   !                     ; Yes, crash!
0061               
0062 7970 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7972 7FFF 
0063 7974 1511  14         jgt   !                     ; Yes, crash!
0064               
0065 7976 C120  34         mov   @tfh.callback2,tmp0
     7978 243E 
0066 797A 0284  22         ci    tmp0,>6000            ; Insane address ?
     797C 6000 
0067 797E 110C  14         jlt   !                     ; Yes, crash!
0068               
0069 7980 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7982 7FFF 
0070 7984 1509  14         jgt   !                     ; Yes, crash!
0071               
0072 7986 C120  34         mov   @tfh.callback3,tmp0
     7988 2440 
0073 798A 0284  22         ci    tmp0,>6000            ; Insane address ?
     798C 6000 
0074 798E 1104  14         jlt   !                     ; Yes, crash!
0075               
0076 7990 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7992 7FFF 
0077 7994 1501  14         jgt   !                     ; Yes, crash!
0078               
0079 7996 1004  14         jmp   tfh.file.read.sams.load1
0080                                                   ; All checks passed, continue.
0081               
0082                                                   ;--------------------------
0083                                                   ; Sanity check failed
0084                                                   ;--------------------------
0085 7998 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     799A FFCE 
0086 799C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     799E 604C 
0087                       ;------------------------------------------------------
0088                       ; Show "loading indicator 1"
0089                       ;------------------------------------------------------
0090               tfh.file.read.sams.load1:
0091 79A0 C120  34         mov   @tfh.callback1,tmp0
     79A2 243C 
0092 79A4 0694  24         bl    *tmp0                 ; Run callback function
0093                       ;------------------------------------------------------
0094                       ; Copy PAB header to VDP
0095                       ;------------------------------------------------------
0096               tfh.file.read.sams.pabheader:
0097 79A6 06A0  32         bl    @cpym2v
     79A8 6432 
0098 79AA 0A60                   data tfh.vpab,tfh.file.pab.header,9
     79AC 7B24 
     79AE 0009 
0099                                                   ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101                       ; Append file descriptor to PAB header in VDP
0102                       ;------------------------------------------------------
0103 79B0 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     79B2 0A69 
0104 79B4 C160  34         mov   @tfh.fname.ptr,tmp1   ; Get pointer to file descriptor
     79B6 2436 
0105 79B8 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0106 79BA 0986  56         srl   tmp2,8                ; Right justify
0107 79BC 0586  14         inc   tmp2                  ; Include length byte as well
0108 79BE 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     79C0 6438 
0109                       ;------------------------------------------------------
0110                       ; Load GPL scratchpad layout
0111                       ;------------------------------------------------------
0112 79C2 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     79C4 6A6C 
0113 79C6 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0114                       ;------------------------------------------------------
0115                       ; Open file
0116                       ;------------------------------------------------------
0117 79C8 06A0  32         bl    @file.open
     79CA 6BBA 
0118 79CC 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0119 79CE 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     79D0 6042 
0120 79D2 1602  14         jne   tfh.file.read.sams.record
0121 79D4 0460  28         b     @tfh.file.read.sams.error
     79D6 7AEE 
0122                                                   ; Yes, IO error occured
0123                       ;------------------------------------------------------
0124                       ; Step 1: Read file record
0125                       ;------------------------------------------------------
0126               tfh.file.read.sams.record:
0127 79D8 05A0  34         inc   @tfh.records          ; Update counter
     79DA 242E 
0128 79DC 04E0  34         clr   @tfh.reclen           ; Reset record length
     79DE 2430 
0129               
0130 79E0 06A0  32         bl    @file.record.read     ; Read file record
     79E2 6BFC 
0131 79E4 0A60                   data tfh.vpab         ; \ i  p0   = Address of PAB in VDP RAM (without +9 offset!)
0132                                                   ; | o  tmp0 = Status byte
0133                                                   ; | o  tmp1 = Bytes read
0134                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0135               
0136 79E6 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     79E8 242A 
0137 79EA C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     79EC 2430 
0138 79EE C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     79F0 242C 
0139                       ;------------------------------------------------------
0140                       ; 1a: Calculate kilobytes processed
0141                       ;------------------------------------------------------
0142 79F2 A805  38         a     tmp1,@tfh.counter
     79F4 2434 
0143 79F6 A160  34         a     @tfh.counter,tmp1
     79F8 2434 
0144 79FA 0285  22         ci    tmp1,1024
     79FC 0400 
0145 79FE 1106  14         jlt   !
0146 7A00 05A0  34         inc   @tfh.kilobytes
     7A02 2432 
0147 7A04 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7A06 FC00 
0148 7A08 C805  38         mov   tmp1,@tfh.counter
     7A0A 2434 
0149                       ;------------------------------------------------------
0150                       ; 1b: Load spectra scratchpad layout
0151                       ;------------------------------------------------------
0152 7A0C 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     7A0E 69F2 
0153 7A10 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7A12 6A8E 
0154 7A14 2100                   data scrpad.backup2   ; / >2100->8300
0155                       ;------------------------------------------------------
0156                       ; 1c: Check if a file error occured
0157                       ;------------------------------------------------------
0158               tfh.file.read.sams.check_fioerr:
0159 7A16 C1A0  34         mov   @tfh.ioresult,tmp2
     7A18 242C 
0160 7A1A 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7A1C 6042 
0161 7A1E 1602  14         jne   tfh.file.read.sams.check_setpage
0162                                                   ; No, goto (1d)
0163 7A20 0460  28         b     @tfh.file.read.sams.error
     7A22 7AEE 
0164                                                   ; Yes, so handle file error
0165                       ;------------------------------------------------------
0166                       ; 1d: Check if SAMS page needs to be set
0167                       ;------------------------------------------------------
0168               tfh.file.read.sams.check_setpage:
0169 7A24 C120  34         mov   @edb.next_free.ptr,tmp0
     7A26 2308 
0170 7A28 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     7A2A 64DE 
0171                                                   ; \ i  tmp0  = Memory address
0172                                                   ; | o  waux1 = SAMS page number
0173                                                   ; / o  waux2 = Address of SAMS register
0174               
0175 7A2C C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     7A2E 833C 
0176 7A30 8804  38         c     tmp0,@tfh.sams.page   ; Compare page with current SAMS page
     7A32 2438 
0177 7A34 1310  14         jeq   tfh.file.read.sams.nocompression
0178                                                   ; Same, skip to (2)
0179                       ;------------------------------------------------------
0180                       ; 1e: Increase SAMS page if necessary
0181                       ;------------------------------------------------------
0182 7A36 8804  38         c     tmp0,@tfh.sams.hpage  ; Compare page with highest SAMS page
     7A38 243A 
0183 7A3A 1502  14         jgt   tfh.file.read.sams.switch
0184                                                   ; Switch page
0185 7A3C 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     7A3E 0005 
0186                       ;------------------------------------------------------
0187                       ; 1f: Switch to SAMS page
0188                       ;------------------------------------------------------
0189               tfh.file.read.sams.switch:
0190 7A40 C160  34         mov   @edb.next_free.ptr,tmp1
     7A42 2308 
0191                                                   ; Beginning of line
0192               
0193 7A44 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7A46 6516 
0194                                                   ; \ i  tmp0 = SAMS page number
0195                                                   ; / i  tmp1 = Memory address
0196               
0197 7A48 C804  38         mov   tmp0,@tfh.sams.page   ; Save current SAMS page
     7A4A 2438 
0198               
0199 7A4C 8804  38         c     tmp0,@tfh.sams.hpage  ; Current SAMS page > highest SAMS page?
     7A4E 243A 
0200 7A50 1202  14         jle   tfh.file.read.sams.nocompression
0201                                                   ; No, skip to (2)
0202 7A52 C804  38         mov   tmp0,@tfh.sams.hpage  ; Update highest SAMS page
     7A54 243A 
0203                       ;------------------------------------------------------
0204                       ; Step 2: Process line (without RLE compression)
0205                       ;------------------------------------------------------
0206               tfh.file.read.sams.nocompression:
0207 7A56 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7A58 0960 
0208 7A5A C160  34         mov   @edb.next_free.ptr,tmp1
     7A5C 2308 
0209                                                   ; RAM target in editor buffer
0210               
0211 7A5E C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7A60 8352 
0212               
0213 7A62 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7A64 2430 
0214 7A66 1324  14         jeq   tfh.file.read.sams.prepindex.emptyline
0215                                                   ; Handle empty line
0216                       ;------------------------------------------------------
0217                       ; 2a: Copy line from VDP to CPU editor buffer
0218                       ;------------------------------------------------------
0219                                                   ; Save line prefix
0220 7A68 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0221 7A6A 06C6  14         swpb  tmp2                  ; |
0222 7A6C DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0223 7A6E 06C6  14         swpb  tmp2                  ; /
0224               
0225 7A70 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7A72 2308 
0226 7A74 A806  38         a     tmp2,@edb.next_free.ptr
     7A76 2308 
0227                                                   ; Add line length
0228                       ;------------------------------------------------------
0229                       ; 2b: Handle line split accross 2 consecutive SAMS pages
0230                       ;------------------------------------------------------
0231 7A78 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0232 7A7A C205  18         mov   tmp1,tmp4             ; Backup tmp1
0233               
0234 7A7C C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
0235 7A7E 09C4  56         srl   tmp0,12               ; Only keep high-nibble
0236               
0237 7A80 C160  34         mov   @edb.next_free.ptr,tmp1
     7A82 2308 
0238                                                   ; Get pointer to next line (aka end of line)
0239 7A84 09C5  56         srl   tmp1,12               ; Only keep high-nibble
0240               
0241 7A86 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
0242 7A88 1307  14         jeq   !                     ; Yes, skip setting SAMS page
0243               
0244 7A8A C120  34         mov   @tfh.sams.page,tmp0   ; Get current SAMS page
     7A8C 2438 
0245 7A8E 0584  14         inc   tmp0                  ; Increase SAMS page
0246 7A90 C160  34         mov   @edb.next_free.ptr,tmp1
     7A92 2308 
0247                                                   ; Get pointer to next line (aka end of line)
0248               
0249 7A94 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7A96 6516 
0250                                                   ; \ i  tmp0 = SAMS page number
0251                                                   ; / i  tmp1 = Memory address
0252               
0253 7A98 C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
0254 7A9A C107  18         mov   tmp3,tmp0             ; Restore tmp0
0255                       ;------------------------------------------------------
0256                       ; 2c: Do actual copy
0257                       ;------------------------------------------------------
0258 7A9C 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7A9E 645E 
0259                                                   ; \ i  tmp0 = VDP source address
0260                                                   ; | i  tmp1 = RAM target address
0261                                                   ; / i  tmp2 = Bytes to copy
0262               
0263 7AA0 1000  14         jmp   tfh.file.read.sams.prepindex
0264                                                   ; Prepare for updating index
0265                       ;------------------------------------------------------
0266                       ; Step 4: Update index
0267                       ;------------------------------------------------------
0268               tfh.file.read.sams.prepindex:
0269 7AA2 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7AA4 2304 
     7AA6 8350 
0270                                                   ; parm2 = Must allready be set!
0271 7AA8 C820  54         mov   @tfh.sams.page,@parm3 ; parm3 = SAMS page number
     7AAA 2438 
     7AAC 8354 
0272               
0273 7AAE 1009  14         jmp   tfh.file.read.sams.updindex
0274                                                   ; Update index
0275                       ;------------------------------------------------------
0276                       ; 4a: Special handling for empty line
0277                       ;------------------------------------------------------
0278               tfh.file.read.sams.prepindex.emptyline:
0279 7AB0 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7AB2 242E 
     7AB4 8350 
0280 7AB6 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7AB8 8350 
0281 7ABA 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7ABC 8352 
0282 7ABE 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7AC0 8354 
0283                       ;------------------------------------------------------
0284                       ; 4b: Do actual index update
0285                       ;------------------------------------------------------
0286               tfh.file.read.sams.updindex:
0287 7AC2 06A0  32         bl    @idx.entry.update     ; Update index
     7AC4 7630 
0288                                                   ; \ i  parm1    = Line number in editor buffer
0289                                                   ; | i  parm2    = Pointer to line in editor buffer
0290                                                   ; | i  parm3    = SAMS page
0291                                                   ; / o  outparm1 = Pointer to updated index entry
0292               
0293 7AC6 05A0  34         inc   @edb.lines            ; lines=lines+1
     7AC8 2304 
0294                       ;------------------------------------------------------
0295                       ; Step 5: Display results
0296                       ;------------------------------------------------------
0297               tfh.file.read.sams.display:
0298 7ACA C120  34         mov   @tfh.callback2,tmp0   ; Get pointer to "Loading indicator 2"
     7ACC 243E 
0299 7ACE 0694  24         bl    *tmp0                 ; Run callback function
0300                       ;------------------------------------------------------
0301                       ; Step 6: Check if reaching memory high-limit >ffa0
0302                       ;------------------------------------------------------
0303               tfh.file.read.sams.checkmem:
0304 7AD0 C120  34         mov   @edb.next_free.ptr,tmp0
     7AD2 2308 
0305 7AD4 0284  22         ci    tmp0,>ffa0
     7AD6 FFA0 
0306 7AD8 1205  14         jle   tfh.file.read.sams.next
0307                       ;------------------------------------------------------
0308                       ; 6a: Address range b000-ffff full, switch SAMS pages
0309                       ;------------------------------------------------------
0310 7ADA 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     7ADC B002 
0311 7ADE C804  38         mov   tmp0,@edb.next_free.ptr
     7AE0 2308 
0312               
0313 7AE2 1000  14         jmp   tfh.file.read.sams.next
0314                       ;------------------------------------------------------
0315                       ; 6b: Next record
0316                       ;------------------------------------------------------
0317               tfh.file.read.sams.next:
0318 7AE4 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7AE6 6A6C 
0319 7AE8 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0320               
0321 7AEA 0460  28         b     @tfh.file.read.sams.record
     7AEC 79D8 
0322                                                   ; Next record
0323                       ;------------------------------------------------------
0324                       ; Error handler
0325                       ;------------------------------------------------------
0326               tfh.file.read.sams.error:
0327 7AEE C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7AF0 242A 
0328 7AF2 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0329 7AF4 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7AF6 0005 
0330 7AF8 1309  14         jeq   tfh.file.read.sams.eof
0331                                                   ; All good. File closed by DSRLNK
0332                       ;------------------------------------------------------
0333                       ; File error occured
0334                       ;------------------------------------------------------
0335 7AFA 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7AFC 6A8E 
0336 7AFE 2100                   data scrpad.backup2   ; / >2100->8300
0337               
0338 7B00 06A0  32         bl    @mem.setup.sams.layout
     7B02 7468 
0339                                                   ; Restore SAMS default memory layout
0340               
0341 7B04 C120  34         mov   @tfh.callback4,tmp0   ; Get pointer to "File I/O error handler"
     7B06 2442 
0342 7B08 0694  24         bl    *tmp0                 ; Run callback function
0343 7B0A 100A  14         jmp   tfh.file.read.sams.exit
0344                       ;------------------------------------------------------
0345                       ; End-Of-File reached
0346                       ;------------------------------------------------------
0347               tfh.file.read.sams.eof:
0348 7B0C 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7B0E 6A8E 
0349 7B10 2100                   data scrpad.backup2   ; / >2100->8300
0350               
0351 7B12 06A0  32         bl    @mem.setup.sams.layout
     7B14 7468 
0352                                                   ; Restore SAMS default memory layout
0353                       ;------------------------------------------------------
0354                       ; Show "loading indicator 3" (final)
0355                       ;------------------------------------------------------
0356 7B16 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7B18 2306 
0357               
0358 7B1A C120  34         mov   @tfh.callback3,tmp0   ; Get pointer to "Loading indicator 3"
     7B1C 2440 
0359 7B1E 0694  24         bl    *tmp0                 ; Run callback function
0360               *--------------------------------------------------------------
0361               * Exit
0362               *--------------------------------------------------------------
0363               tfh.file.read.sams.exit:
0364 7B20 0460  28         b     @poprt                ; Return to caller
     7B22 622C 
0365               
0366               
0367               
0368               
0369               
0370               
0371               ***************************************************************
0372               * PAB for accessing DV/80 file
0373               ********|*****|*********************|**************************
0374               tfh.file.pab.header:
0375 7B24 0014             byte  io.op.open            ;  0    - OPEN
0376                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0377 7B26 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0378 7B28 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0379                       byte  00                    ;  5    - Character count
0380 7B2A 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0381 7B2C 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0382                       ;------------------------------------------------------
0383                       ; File descriptor part (variable length)
0384                       ;------------------------------------------------------
0385                       ; byte  12                  ;  9    - File descriptor length
0386                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.22880
0290                       copy  "fm.load.asm"         ; fm.load  - File manager loadfile
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
0014 7B2E 0649  14         dect  stack
0015 7B30 C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 7B32 C804  38         mov   tmp0,@parm1           ; Setup file to load
     7B34 8350 
0018 7B36 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7B38 76E4 
0019 7B3A 06A0  32         bl    @idx.init             ; Initialize index
     7B3C 760C 
0020 7B3E 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7B40 74CC 
0021 7B42 C820  54         mov   @parm1,@edb.filename.ptr
     7B44 8350 
     7B46 230E 
0022                                                   ; Set filename
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7B48 06A0  32         bl    @filv
     7B4A 6288 
0027 7B4C 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7B4E 0000 
     7B50 0004 
0028               
0029 7B52 C160  34         mov   @fb.scrrows,tmp1
     7B54 2298 
0030 7B56 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7B58 228E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 7B5A 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     7B5C 0050 
0034 7B5E 0205  20         li    tmp1,32               ; Character to fill
     7B60 0020 
0035               
0036 7B62 06A0  32         bl    @xfilv                ; Fill VDP memory
     7B64 628E 
0037                                                   ; \ i  tmp0 = VDP target address
0038                                                   ; | i  tmp1 = Byte to fill
0039                                                   ; / i  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 7B66 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     7B68 7B92 
0044 7B6A C804  38         mov   tmp0,@parm2           ; Register callback 1
     7B6C 8352 
0045               
0046 7B6E 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     7B70 7BCA 
0047 7B72 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7B74 8354 
0048               
0049 7B76 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     7B78 7BFC 
0050 7B7A C804  38         mov   tmp0,@parm4           ; Register callback 3
     7B7C 8356 
0051               
0052 7B7E 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     7B80 7C2E 
0053 7B82 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7B84 8358 
0054               
0055 7B86 06A0  32         bl    @tfh.file.read.sams   ; Read specified file with SAMS support
     7B88 791E 
0056                                                   ; \ i  parm1 = Pointer to length prefixed file descriptor
0057                                                   ; | i  parm2 = Pointer to callback function "loading indicator 1"
0058                                                   ; | i  parm3 = Pointer to callback function "loading indicator 2"
0059                                                   ; | i  parm4 = Pointer to callback function "loading indicator 3"
0060                                                   ; / i  parm5 = Pointer to callback function "File I/O error handler"
0061               
0062 7B8A 04E0  34         clr   @edb.dirty            ; Editor buffer fully replaced, no longer dirty
     7B8C 2306 
0063               *--------------------------------------------------------------
0064               * Exit
0065               *--------------------------------------------------------------
0066               fm.loadfile.exit:
0067 7B8E 0460  28         b     @poprt                ; Return to caller
     7B90 622C 
0068               
0069               
0070               
0071               *---------------------------------------------------------------
0072               * Callback function "Show loading indicator 1"
0073               *---------------------------------------------------------------
0074               * Is expected to be passed as parm2 to @tfh.file.read
0075               *---------------------------------------------------------------
0076               fm.loadfile.callback.indicator1:
0077 7B92 0649  14         dect  stack
0078 7B94 C64B  30         mov   r11,*stack            ; Save return address
0079                       ;------------------------------------------------------
0080                       ; Show loading indicators and file descriptor
0081                       ;------------------------------------------------------
0082 7B96 06A0  32         bl    @hchar
     7B98 675C 
0083 7B9A 1D03                   byte 29,3,32,77
     7B9C 204D 
0084 7B9E FFFF                   data EOL
0085               
0086 7BA0 06A0  32         bl    @putat
     7BA2 642A 
0087 7BA4 1D03                   byte 29,3
0088 7BA6 7E98                   data txt_loading      ; Display "Loading...."
0089               
0090 7BA8 8820  54         c     @tfh.rleonload,@w$ffff
     7BAA 2444 
     7BAC 6048 
0091 7BAE 1604  14         jne   !
0092 7BB0 06A0  32         bl    @putat
     7BB2 642A 
0093 7BB4 1D44                   byte 29,68
0094 7BB6 7EA8                   data txt_rle          ; Display "RLE"
0095               
0096 7BB8 06A0  32 !       bl    @at
     7BBA 6668 
0097 7BBC 1D0E                   byte 29,14            ; Cursor YX position
0098 7BBE C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7BC0 8350 
0099 7BC2 06A0  32         bl    @xutst0               ; Display device/filename
     7BC4 641A 
0100                       ;------------------------------------------------------
0101                       ; Exit
0102                       ;------------------------------------------------------
0103               fm.loadfile.callback.indicator1.exit:
0104 7BC6 0460  28         b     @poprt                ; Return to caller
     7BC8 622C 
0105               
0106               
0107               
0108               
0109               *---------------------------------------------------------------
0110               * Callback function "Show loading indicator 2"
0111               *---------------------------------------------------------------
0112               * Is expected to be passed as parm3 to @tfh.file.read
0113               *---------------------------------------------------------------
0114               fm.loadfile.callback.indicator2:
0115 7BCA 0649  14         dect  stack
0116 7BCC C64B  30         mov   r11,*stack            ; Save return address
0117               
0118 7BCE 06A0  32         bl    @putnum
     7BD0 69E8 
0119 7BD2 1D4B                   byte 29,75            ; Show lines read
0120 7BD4 2304                   data edb.lines,rambuf,>3020
     7BD6 8390 
     7BD8 3020 
0121               
0122 7BDA 8220  34         c     @tfh.kilobytes,tmp4
     7BDC 2432 
0123 7BDE 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0124               
0125 7BE0 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7BE2 2432 
0126               
0127 7BE4 06A0  32         bl    @putnum
     7BE6 69E8 
0128 7BE8 1D38                   byte 29,56            ; Show kilobytes read
0129 7BEA 2432                   data tfh.kilobytes,rambuf,>3020
     7BEC 8390 
     7BEE 3020 
0130               
0131 7BF0 06A0  32         bl    @putat
     7BF2 642A 
0132 7BF4 1D3D                   byte 29,61
0133 7BF6 7EA4                   data txt_kb           ; Show "kb" string
0134                       ;------------------------------------------------------
0135                       ; Exit
0136                       ;------------------------------------------------------
0137               fm.loadfile.callback.indicator2.exit:
0138 7BF8 0460  28         b     @poprt                ; Return to caller
     7BFA 622C 
0139               
0140               
0141               
0142               
0143               
0144               *---------------------------------------------------------------
0145               * Callback function "Show loading indicator 3"
0146               *---------------------------------------------------------------
0147               * Is expected to be passed as parm4 to @tfh.file.read
0148               *---------------------------------------------------------------
0149               fm.loadfile.callback.indicator3:
0150 7BFC 0649  14         dect  stack
0151 7BFE C64B  30         mov   r11,*stack            ; Save return address
0152               
0153               
0154 7C00 06A0  32         bl    @hchar
     7C02 675C 
0155 7C04 1D03                   byte 29,3,32,50       ; Erase loading indicator
     7C06 2032 
0156 7C08 FFFF                   data EOL
0157               
0158 7C0A 06A0  32         bl    @putnum
     7C0C 69E8 
0159 7C0E 1D38                   byte 29,56            ; Show kilobytes read
0160 7C10 2432                   data tfh.kilobytes,rambuf,>3020
     7C12 8390 
     7C14 3020 
0161               
0162 7C16 06A0  32         bl    @putat
     7C18 642A 
0163 7C1A 1D3D                   byte 29,61
0164 7C1C 7EA4                   data txt_kb           ; Show "kb" string
0165               
0166 7C1E 06A0  32         bl    @putnum
     7C20 69E8 
0167 7C22 1D4B                   byte 29,75            ; Show lines read
0168 7C24 242E                   data tfh.records,rambuf,>3020
     7C26 8390 
     7C28 3020 
0169                       ;------------------------------------------------------
0170                       ; Exit
0171                       ;------------------------------------------------------
0172               fm.loadfile.callback.indicator3.exit:
0173 7C2A 0460  28         b     @poprt                ; Return to caller
     7C2C 622C 
0174               
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Callback function "File I/O error handler"
0179               *---------------------------------------------------------------
0180               * Is expected to be passed as parm5 to @tfh.file.read
0181               *---------------------------------------------------------------
0182               fm.loadfile.callback.fioerr:
0183 7C2E 0649  14         dect  stack
0184 7C30 C64B  30         mov   r11,*stack            ; Save return address
0185               
0186 7C32 06A0  32         bl    @hchar
     7C34 675C 
0187 7C36 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7C38 2032 
0188 7C3A FFFF                   data EOL
0189               
0190 7C3C 06A0  32         bl    @putat
     7C3E 642A 
0191 7C40 1B00                   byte 27,0             ; Display message
0192 7C42 7EB2                   data txt_ioerr
0193               
0194 7C44 0204  20         li    tmp0,txt_newfile
     7C46 7EE0 
0195 7C48 C804  38         mov   tmp0,@edb.filename.ptr
     7C4A 230E 
0196               
0197 7C4C C820  54         mov   @cmdb.scrrows,@parm1
     7C4E 2504 
     7C50 8350 
0198 7C52 06A0  32         bl    @cmdb.show
     7C54 78DA 
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202               fm.loadfile.callback.fioerr.exit:
0203 7C56 0460  28         b     @poprt                ; Return to caller
     7C58 622C 
**** **** ****     > tivi.asm.22880
0291                       copy  "tasks.asm"           ; tsk      - Tasks
**** **** ****     > tasks.asm
0001               * FILE......: tasks.asm
0002               * Purpose...: TiVi Editor - Tasks module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011 7C5A 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7C5C 6030 
0012 7C5E 160B  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0013               *---------------------------------------------------------------
0014               * Identical key pressed ?
0015               *---------------------------------------------------------------
0016 7C60 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7C62 6030 
0017 7C64 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7C66 833C 
     7C68 833E 
0018 7C6A 1309  14         jeq   ed_wait
0019               *--------------------------------------------------------------
0020               * New key pressed
0021               *--------------------------------------------------------------
0022               ed_new_key
0023 7C6C C820  54         mov   @waux1,@waux2         ; Save as previous key
     7C6E 833C 
     7C70 833E 
0024 7C72 0460  28         b     @edkey                ; Process key
     7C74 6F0E 
0025               *--------------------------------------------------------------
0026               * Clear keyboard buffer if no key pressed
0027               *--------------------------------------------------------------
0028               ed_clear_kbbuffer
0029 7C76 04E0  34         clr   @waux1
     7C78 833C 
0030 7C7A 04E0  34         clr   @waux2
     7C7C 833E 
0031               *--------------------------------------------------------------
0032               * Delay to avoid key bouncing
0033               *--------------------------------------------------------------
0034               ed_wait
0035 7C7E 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     7C80 0708 
0036                       ;------------------------------------------------------
0037                       ; Delay loop
0038                       ;------------------------------------------------------
0039               ed_wait_loop
0040 7C82 0604  14         dec   tmp0
0041 7C84 16FE  14         jne   ed_wait_loop
0042               *--------------------------------------------------------------
0043               * Exit
0044               *--------------------------------------------------------------
0045 7C86 0460  28 ed_exit b     @hookok               ; Return
     7C88 6C44 
0046               
0047               
0048               
0049               
0050               
0051               
0052               ***************************************************************
0053               * Task 0 - Copy frame buffer to VDP
0054               ***************************************************************
0055 7C8A C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7C8C 2296 
0056 7C8E 1341  14         jeq   task0.exit            ; No, skip update
0057                       ;------------------------------------------------------
0058                       ; Determine how many rows to copy
0059                       ;------------------------------------------------------
0060 7C90 8820  54         c     @edb.lines,@fb.scrrows
     7C92 2304 
     7C94 2298 
0061 7C96 1103  14         jlt   task0.setrows.small
0062 7C98 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7C9A 2298 
0063 7C9C 1003  14         jmp   task0.copy.framebuffer
0064                       ;------------------------------------------------------
0065                       ; Less lines in editor buffer as rows in frame buffer
0066                       ;------------------------------------------------------
0067               task0.setrows.small:
0068 7C9E C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7CA0 2304 
0069 7CA2 0585  14         inc   tmp1
0070                       ;------------------------------------------------------
0071                       ; Determine area to copy
0072                       ;------------------------------------------------------
0073               task0.copy.framebuffer:
0074 7CA4 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7CA6 228E 
0075                                                   ; 16 bit part is in tmp2!
0076 7CA8 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     7CAA 0050 
0077 7CAC C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7CAE 2280 
0078                       ;------------------------------------------------------
0079                       ; Copy memory block
0080                       ;------------------------------------------------------
0081 7CB0 06A0  32         bl    @xpym2v               ; Copy to VDP
     7CB2 6438 
0082                                                   ; tmp0 = VDP target address
0083                                                   ; tmp1 = RAM source address
0084                                                   ; tmp2 = Bytes to copy
0085 7CB4 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7CB6 2296 
0086                       ;-------------------------------------------------------
0087                       ; Draw EOF marker at end-of-file
0088                       ;-------------------------------------------------------
0089 7CB8 C120  34         mov   @edb.lines,tmp0
     7CBA 2304 
0090 7CBC 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7CBE 2284 
0091 7CC0 05C4  14         inct  tmp0                  ; Y = Y + 2
0092 7CC2 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     7CC4 2298 
0093 7CC6 1225  14         jle   task0.exit
0094                       ;-------------------------------------------------------
0095                       ; Draw EOF marker
0096                       ;-------------------------------------------------------
0097               task0.draw_marker:
0098 7CC8 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7CCA 832A 
     7CCC 2294 
0099 7CCE 0A84  56         sla   tmp0,8                ; X=0
0100 7CD0 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7CD2 832A 
0101 7CD4 06A0  32         bl    @putstr
     7CD6 6418 
0102 7CD8 7E82                   data txt_marker       ; Display *EOF*
0103                       ;-------------------------------------------------------
0104                       ; Draw empty line after (and below) EOF marker
0105                       ;-------------------------------------------------------
0106 7CDA 06A0  32         bl    @setx
     7CDC 667E 
0107 7CDE 0005                   data  5               ; Cursor after *EOF* string
0108               
0109 7CE0 C120  34         mov   @wyx,tmp0
     7CE2 832A 
0110 7CE4 0984  56         srl   tmp0,8                ; Right justify
0111 7CE6 0584  14         inc   tmp0                  ; One time adjust
0112 7CE8 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     7CEA 2298 
0113 7CEC 1303  14         jeq   !
0114 7CEE 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7CF0 009B 
0115 7CF2 1002  14         jmp   task0.draw_marker.empty.line
0116 7CF4 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     7CF6 004B 
0117                       ;-------------------------------------------------------
0118                       ; Draw empty line
0119                       ;-------------------------------------------------------
0120               task0.draw_marker.empty.line
0121 7CF8 0604  14         dec   tmp0                  ; One time adjust
0122 7CFA 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7CFC 63F4 
0123 7CFE 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7D00 0020 
0124 7D02 06A0  32         bl    @xfilv                ; Write characters
     7D04 628E 
0125 7D06 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7D08 2294 
     7D0A 832A 
0126                       ;-------------------------------------------------------
0127                       ; Draw "double" bottom line
0128                       ;-------------------------------------------------------
0129               ;        mov   @fb.scrrows,tmp0
0130               ;        swpb  tmp0
0131               ;        mov   tmp0,@wyx
0132               ;        bl    @yx2pnt               ; Set VDP address in tmp0
0133               ;        li    tmp1,2                ; Character to write (double line)
0134               ;        li    tmp2,80
0135               ;        bl    @xfilv                ; Write characters
0136               
0137               
0138 7D0C C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7D0E 2294 
     7D10 832A 
0139               
0140               *--------------------------------------------------------------
0141               * Task 0 - Exit
0142               *--------------------------------------------------------------
0143               task0.exit:
0144 7D12 0460  28         b     @slotok
     7D14 6CC0 
0145               
0146               
0147               
0148               ***************************************************************
0149               * Task 1 - Copy SAT to VDP
0150               ***************************************************************
0151 7D16 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     7D18 6046 
0152 7D1A 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     7D1C 668A 
0153 7D1E C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7D20 8380 
0154 7D22 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0155               
0156               
0157               
0158               ***************************************************************
0159               * Task 2 - Update cursor shape (blink)
0160               ***************************************************************
0161 7D24 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     7D26 2292 
0162 7D28 1303  14         jeq   task2.cur_visible
0163 7D2A 04E0  34         clr   @ramsat+2              ; Hide cursor
     7D2C 8382 
0164 7D2E 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0165               
0166               task2.cur_visible:
0167 7D30 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7D32 230A 
0168 7D34 1303  14         jeq   task2.cur_visible.overwrite_mode
0169                       ;------------------------------------------------------
0170                       ; Cursor in insert mode
0171                       ;------------------------------------------------------
0172               task2.cur_visible.insert_mode:
0173 7D36 0204  20         li    tmp0,>0008
     7D38 0008 
0174 7D3A 1002  14         jmp   task2.cur_visible.cursorshape
0175                       ;------------------------------------------------------
0176                       ; Cursor in overwrite mode
0177                       ;------------------------------------------------------
0178               task2.cur_visible.overwrite_mode:
0179 7D3C 0204  20         li    tmp0,>0208
     7D3E 0208 
0180                       ;------------------------------------------------------
0181                       ; Set cursor shape
0182                       ;------------------------------------------------------
0183               task2.cur_visible.cursorshape:
0184 7D40 C804  38         mov   tmp0,@fb.curshape
     7D42 2290 
0185 7D44 C804  38         mov   tmp0,@ramsat+2
     7D46 8382 
0186               
0187               
0188               
0189               
0190               *--------------------------------------------------------------
0191               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0192               *--------------------------------------------------------------
0193               task.sub_copy_ramsat:
0194 7D48 0649  14         dect  stack
0195 7D4A C644  30         mov   tmp0,*stack            ; Push tmp0
0196               
0197 7D4C 06A0  32         bl    @cpym2v
     7D4E 6432 
0198 7D50 2000                   data sprsat,ramsat,4   ; Copy sprite SAT to VDP
     7D52 8380 
     7D54 0004 
0199               
0200 7D56 C820  54         mov   @wyx,@fb.yxsave
     7D58 832A 
     7D5A 2294 
0201                       ;-------------------------------------------------------
0202                       ; Draw border line
0203                       ;-------------------------------------------------------
0204 7D5C C120  34         mov   @fb.scrrows,tmp0
     7D5E 2298 
0205 7D60 0284  22         ci    tmp0,27
     7D62 001B 
0206 7D64 1306  14         jeq   !
0207 7D66 06A0  32         bl    @hchar
     7D68 675C 
0208 7D6A 1C00                   byte 28,0,2,80
     7D6C 0250 
0209 7D6E FFFF                   data EOL
0210 7D70 1005  14         jmp   task.botline.bufnum
0211 7D72 06A0  32 !       bl    @hchar
     7D74 675C 
0212 7D76 1C00                   byte 28,0,1,80
     7D78 0150 
0213 7D7A FFFF                   data EOL
0214                       ;------------------------------------------------------
0215                       ; Show buffer number
0216                       ;------------------------------------------------------
0217               task.botline.bufnum
0218 7D7C 06A0  32         bl    @putat
     7D7E 642A 
0219 7D80 1D00                   byte  29,0
0220 7D82 7EDC                   data  txt_bufnum
0221                       ;------------------------------------------------------
0222                       ; Show current file
0223                       ;------------------------------------------------------
0224 7D84 06A0  32         bl    @at
     7D86 6668 
0225 7D88 1D03                   byte  29,3             ; Position cursor
0226               
0227 7D8A C160  34         mov   @edb.filename.ptr,tmp1 ; Get string to display
     7D8C 230E 
0228 7D8E 06A0  32         bl    @xutst0                ; Display string
     7D90 641A 
0229                       ;------------------------------------------------------
0230                       ; Show text editing mode
0231                       ;------------------------------------------------------
0232               task.botline.show_mode:
0233 7D92 C120  34         mov   @edb.insmode,tmp0
     7D94 230A 
0234 7D96 1605  14         jne   task.botline.show_mode.insert
0235                       ;------------------------------------------------------
0236                       ; Overwrite mode
0237                       ;------------------------------------------------------
0238               task.botline.show_mode.overwrite:
0239 7D98 06A0  32         bl    @putat
     7D9A 642A 
0240 7D9C 1D32                   byte  29,50
0241 7D9E 7E8E                   data  txt_ovrwrite
0242 7DA0 1004  14         jmp   task.botline.show_changed
0243                       ;------------------------------------------------------
0244                       ; Insert  mode
0245                       ;------------------------------------------------------
0246               task.botline.show_mode.insert:
0247 7DA2 06A0  32         bl    @putat
     7DA4 642A 
0248 7DA6 1D32                   byte  29,50
0249 7DA8 7E92                   data  txt_insert
0250                       ;------------------------------------------------------
0251                       ; Show if text was changed in editor buffer
0252                       ;------------------------------------------------------
0253               task.botline.show_changed:
0254 7DAA C120  34         mov   @edb.dirty,tmp0
     7DAC 2306 
0255 7DAE 1305  14         jeq   task.botline.show_changed.clear
0256                       ;------------------------------------------------------
0257                       ; Show "*"
0258                       ;------------------------------------------------------
0259 7DB0 06A0  32         bl    @putat
     7DB2 642A 
0260 7DB4 1D36                   byte 29,54
0261 7DB6 7E96                   data txt_star
0262 7DB8 1001  14         jmp   task.botline.show_linecol
0263                       ;------------------------------------------------------
0264                       ; Show "line,column"
0265                       ;------------------------------------------------------
0266               task.botline.show_changed.clear:
0267 7DBA 1000  14         nop
0268               task.botline.show_linecol:
0269 7DBC C820  54         mov   @fb.row,@parm1
     7DBE 2286 
     7DC0 8350 
0270 7DC2 06A0  32         bl    @fb.row2line
     7DC4 751C 
0271 7DC6 05A0  34         inc   @outparm1
     7DC8 8360 
0272                       ;------------------------------------------------------
0273                       ; Show line
0274                       ;------------------------------------------------------
0275 7DCA 06A0  32         bl    @putnum
     7DCC 69E8 
0276 7DCE 1D40                   byte  29,64            ; YX
0277 7DD0 8360                   data  outparm1,rambuf
     7DD2 8390 
0278 7DD4 3020                   byte  48               ; ASCII offset
0279                             byte  32               ; Padding character
0280                       ;------------------------------------------------------
0281                       ; Show comma
0282                       ;------------------------------------------------------
0283 7DD6 06A0  32         bl    @putat
     7DD8 642A 
0284 7DDA 1D45                   byte  29,69
0285 7DDC 7E80                   data  txt_delim
0286                       ;------------------------------------------------------
0287                       ; Show column
0288                       ;------------------------------------------------------
0289 7DDE 06A0  32         bl    @film
     7DE0 6230 
0290 7DE2 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7DE4 0020 
     7DE6 000C 
0291               
0292 7DE8 C820  54         mov   @fb.column,@waux1
     7DEA 228C 
     7DEC 833C 
0293 7DEE 05A0  34         inc   @waux1                 ; Offset 1
     7DF0 833C 
0294               
0295 7DF2 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7DF4 696A 
0296 7DF6 833C                   data  waux1,rambuf
     7DF8 8390 
0297 7DFA 3020                   byte  48               ; ASCII offset
0298                             byte  32               ; Fill character
0299               
0300 7DFC 06A0  32         bl    @trimnum               ; Trim number to the left
     7DFE 69C2 
0301 7E00 8390                   data  rambuf,rambuf+6,32
     7E02 8396 
     7E04 0020 
0302               
0303 7E06 0204  20         li    tmp0,>0200
     7E08 0200 
0304 7E0A D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7E0C 8396 
0305               
0306 7E0E 06A0  32         bl    @putat
     7E10 642A 
0307 7E12 1D46                   byte 29,70
0308 7E14 8396                   data rambuf+6          ; Show column
0309                       ;------------------------------------------------------
0310                       ; Show lines in buffer unless on last line in file
0311                       ;------------------------------------------------------
0312 7E16 C820  54         mov   @fb.row,@parm1
     7E18 2286 
     7E1A 8350 
0313 7E1C 06A0  32         bl    @fb.row2line
     7E1E 751C 
0314 7E20 8820  54         c     @edb.lines,@outparm1
     7E22 2304 
     7E24 8360 
0315 7E26 1605  14         jne   task.botline.show_lines_in_buffer
0316               
0317 7E28 06A0  32         bl    @putat
     7E2A 642A 
0318 7E2C 1D4B                   byte 29,75
0319 7E2E 7E88                   data txt_bottom
0320               
0321 7E30 100B  14         jmp   task.botline.exit
0322                       ;------------------------------------------------------
0323                       ; Show lines in buffer
0324                       ;------------------------------------------------------
0325               task.botline.show_lines_in_buffer:
0326 7E32 C820  54         mov   @edb.lines,@waux1
     7E34 2304 
     7E36 833C 
0327 7E38 05A0  34         inc   @waux1                 ; Offset 1
     7E3A 833C 
0328 7E3C 06A0  32         bl    @putnum
     7E3E 69E8 
0329 7E40 1D4B                   byte 29,75             ; YX
0330 7E42 833C                   data waux1,rambuf
     7E44 8390 
0331 7E46 3020                   byte 48
0332                             byte 32
0333                       ;------------------------------------------------------
0334                       ; Exit
0335                       ;------------------------------------------------------
0336               task.botline.exit
0337 7E48 C820  54         mov   @fb.yxsave,@wyx
     7E4A 2294 
     7E4C 832A 
0338 7E4E C139  30         mov   *stack+,tmp0           ; Pop tmp0
0339 7E50 0460  28         b     @slotok                ; Exit running task
     7E52 6CC0 
**** **** ****     > tivi.asm.22880
0292               
0293               
0294               ***************************************************************
0295               *                      Constants
0296               ***************************************************************
0297               romsat:
0298 7E54 0303             data >0303,>0008              ; Cursor YX, initial shape and colour
     7E56 0008 
0299               
0300               cursors:
0301 7E58 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7E5A 0000 
     7E5C 0000 
     7E5E 001C 
0302 7E60 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7E62 1010 
     7E64 1010 
     7E66 1000 
0303 7E68 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7E6A 1C1C 
     7E6C 1C1C 
     7E6E 1C00 
0304               
0305               lines:
0306 7E70 0080             data >0080,>0000,>ff00,>ff00  ; Ruler and double line
     7E72 0000 
     7E74 FF00 
     7E76 FF00 
0307 7E78 0000             data >0000,>0000,>ff00,>ff00  ; Double line
     7E7A 0000 
     7E7C FF00 
     7E7E FF00 
0308               
0309               ***************************************************************
0310               *                       Strings
0311               ***************************************************************
0312               txt_delim
0313 7E80 012C             byte  1
0314 7E81 ....             text  ','
0315                       even
0316               
0317               txt_marker
0318 7E82 052A             byte  5
0319 7E83 ....             text  '*EOF*'
0320                       even
0321               
0322               txt_bottom
0323 7E88 0520             byte  5
0324 7E89 ....             text  '  BOT'
0325                       even
0326               
0327               txt_ovrwrite
0328 7E8E 034F             byte  3
0329 7E8F ....             text  'OVR'
0330                       even
0331               
0332               txt_insert
0333 7E92 0349             byte  3
0334 7E93 ....             text  'INS'
0335                       even
0336               
0337               txt_star
0338 7E96 012A             byte  1
0339 7E97 ....             text  '*'
0340                       even
0341               
0342               txt_loading
0343 7E98 0A4C             byte  10
0344 7E99 ....             text  'Loading...'
0345                       even
0346               
0347               txt_kb
0348 7EA4 026B             byte  2
0349 7EA5 ....             text  'kb'
0350                       even
0351               
0352               txt_rle
0353 7EA8 0352             byte  3
0354 7EA9 ....             text  'RLE'
0355                       even
0356               
0357               txt_lines
0358 7EAC 054C             byte  5
0359 7EAD ....             text  'Lines'
0360                       even
0361               
0362               txt_ioerr
0363 7EB2 292A             byte  41
0364 7EB3 ....             text  '* I/O error occured. Could not load file.'
0365                       even
0366               
0367               txt_bufnum
0368 7EDC 0223             byte  2
0369 7EDD ....             text  '#1'
0370                       even
0371               
0372               txt_newfile
0373 7EE0 0A5B             byte  10
0374 7EE1 ....             text  '[New file]'
0375                       even
0376               
0377               txt_tivi
0378 7EEC 1654             byte  22
0379 7EED ....             text  'TiVi beta 200221-22880'
0380                       even
0381               
0382 7F04 7F04     end          data    $
0383               
0384               
0385               fdname0
0386 7F06 0D44             byte  13
0387 7F07 ....             text  'DSK1.INVADERS'
0388                       even
0389               
0390               fdname1
0391 7F14 0F44             byte  15
0392 7F15 ....             text  'DSK1.SPEECHDOCS'
0393                       even
0394               
0395               fdname2
0396 7F24 0C44             byte  12
0397 7F25 ....             text  'DSK1.XBEADOC'
0398                       even
0399               
0400               fdname3
0401 7F32 0C44             byte  12
0402 7F33 ....             text  'DSK3.XBEADOC'
0403                       even
0404               
0405               fdname4
0406 7F40 0C44             byte  12
0407 7F41 ....             text  'DSK3.C99MAN1'
0408                       even
0409               
0410               fdname5
0411 7F4E 0C44             byte  12
0412 7F4F ....             text  'DSK3.C99MAN2'
0413                       even
0414               
0415               fdname6
0416 7F5C 0C44             byte  12
0417 7F5D ....             text  'DSK3.C99MAN3'
0418                       even
0419               
0420               fdname7
0421 7F6A 0D44             byte  13
0422 7F6B ....             text  'DSK3.C99SPECS'
0423                       even
0424               
0425               fdname8
0426 7F78 0D44             byte  13
0427 7F79 ....             text  'DSK3.RANDOM#C'
0428                       even
0429               
0430               fdname9
0431 7F86 0D44             byte  13
0432 7F87 ....             text  'DSK1.INVADERS'
0433                       even
0434               
0435               
0436               
0437               ***************************************************************
0438               *                  Sanity check on ROM size
0439               ***************************************************************
0443 7F94 7F94              data $   ; ROM size OK.

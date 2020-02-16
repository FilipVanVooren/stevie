XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.3217
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2020 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200216-3217
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
0021               * 2200-22ff     256   >0100   TiVi frame buffer structure
0022               * 2300-23ff     256   >0100   TiVi editor buffer structure
0023               * 2400-24ff     256   >0100   TiVi file handling structure
0024               * 2500-25ff     256   >0100   Free for future use
0025               * 2600-264f      80   >0050   Free for future use
0026               * 2650-2faf    2400   >0960   Frame buffer 80x30
0027               * 2fb0-2fff     160   >00a0   Free for future use
0028               * 3000-3fff    4096   >1000   Index 2048 lines
0029               * a000-afff    4096   >1000   Shadow Index 2048 lines
0030               * b000-ffff   20480   >5000   Editor buffer
0031               *--------------------------------------------------------------
0032               * Mem range  Bytes     SAMS   Purpose
0033               * =========  =====     ====   =======
0034               * 2000-2fff   4096     no     Scratchpad/GPL backup, TiVi structures
0035               * 3000-3fff   4096     yes    Main index
0036               * a000-afff   4096     yes    Shadow index
0037               * b000-bfff   4096     yes    Editor buffer \
0038               * c000-cfff   4096     yes    Editor buffer |  20kb continious
0039               * d000-dfff   4096     yes    Editor buffer |  address space.
0040               * e000-efff   4096     yes    Editor buffer |
0041               * f000-ffff   4096     yes    Editor buffer /
0042               *--------------------------------------------------------------
0043               * TiVi VDP layout
0044               *
0045               * Mem range   Bytes    Hex    Purpose
0046               * =========   =====   ====    =================================
0047               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0048               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0049               * 0fc0                        PCT - Pattern Color Table
0050               * 1000                        PDT - Pattern Descriptor Table
0051               * 1800                        SPT - Sprite Pattern Table
0052               * 2000                        SAT - Sprite Attribute List
0053               *--------------------------------------------------------------
0054               * EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
0055               *--------------------------------------------------------------
0056      0001     debug                     equ  1    ; Turn on spectra2 debugging
0057               *--------------------------------------------------------------
0058               * Skip unused spectra2 code modules for reduced code size
0059               *--------------------------------------------------------------
0060      0001     skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
0061      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0062      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0063      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0064      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0065      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0066      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0067      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0068      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0069      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0070      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0071      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0072      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0073      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0074      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0075      0001     skip_random_generator     equ  1    ; Skip random functions
0076      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0077               *--------------------------------------------------------------
0078               * SPECTRA2 startup options
0079               *--------------------------------------------------------------
0080      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0081      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0082      00F4     spfclr                    equ  >f4  ; Foreground/Background color for font.
0083      0004     spfbck                    equ  >04  ; Screen background color.
0084               *--------------------------------------------------------------
0085               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0086               *--------------------------------------------------------------
0087               ;               equ  >8342          ; >8342-834F **free***
0088      8350     parm1           equ  >8350          ; Function parameter 1
0089      8352     parm2           equ  >8352          ; Function parameter 2
0090      8354     parm3           equ  >8354          ; Function parameter 3
0091      8356     parm4           equ  >8356          ; Function parameter 4
0092      8358     parm5           equ  >8358          ; Function parameter 5
0093      835A     parm6           equ  >835a          ; Function parameter 6
0094      835C     parm7           equ  >835c          ; Function parameter 7
0095      835E     parm8           equ  >835e          ; Function parameter 8
0096      8360     outparm1        equ  >8360          ; Function output parameter 1
0097      8362     outparm2        equ  >8362          ; Function output parameter 2
0098      8364     outparm3        equ  >8364          ; Function output parameter 3
0099      8366     outparm4        equ  >8366          ; Function output parameter 4
0100      8368     outparm5        equ  >8368          ; Function output parameter 5
0101      836A     outparm6        equ  >836a          ; Function output parameter 6
0102      836C     outparm7        equ  >836c          ; Function output parameter 7
0103      836E     outparm8        equ  >836e          ; Function output parameter 8
0104      8370     timers          equ  >8370          ; Timer table
0105      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0106      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0107               *--------------------------------------------------------------
0108               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0109               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0110               *--------------------------------------------------------------
0111      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0112      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0113               *--------------------------------------------------------------
0114               * Frame buffer structure            @>2200-22ff     (256 bytes)
0115               *--------------------------------------------------------------
0116      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0117      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0118      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0119      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0120      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0121      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0122      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0123      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0124      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0125      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0126      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0127      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0128      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0129      221A     fb.end          equ  fb.top.ptr+26  ; Free from here on
0130               *--------------------------------------------------------------
0131               * Editor buffer structure           @>2300-23ff     (256 bytes)
0132               *--------------------------------------------------------------
0133      2300     edb.top.ptr         equ  >2300          ; Pointer to editor buffer
0134      2302     edb.index.ptr       equ  edb.top.ptr+2  ; Pointer to index
0135      2304     edb.lines           equ  edb.top.ptr+4  ; Total lines in editor buffer
0136      2306     edb.dirty           equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0137      2308     edb.next_free.ptr   equ  edb.top.ptr+8  ; Pointer to next free line
0138      230A     edb.insmode         equ  edb.top.ptr+10 ; Editor insert mode (>0000 overwrite / >ffff insert)
0139      230C     edb.rle             equ  edb.top.ptr+12 ; RLE compression activated
0140      230E     edb.filename.ptr    equ  edb.top.ptr+14 ; Pointer to length-prefixed string with current filename
0141      230E     edb.end             equ  edb.top.ptr+14 ; Free from here on
0142               *--------------------------------------------------------------
0143               * File handling structures          @>2400-24ff     (256 bytes)
0144               *--------------------------------------------------------------
0145      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0146      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0147      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0148      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB, required by level 2 FIO
0149      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0150      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0151      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0152      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0153      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0154      2434     tfh.counter     equ  tfh.top + 52   ; Internal counter used in TiVi file operations
0155      2436     tfh.fname.ptr   equ  tfh.top + 54   ; Pointer to device and filename
0156      2438     tfh.sams.page   equ  tfh.top + 56   ; Current SAMS page during file operation
0157      243A     tfh.sams.hpage  equ  tfh.top + 58   ; Highest SAMS page in use so far for file operation
0158      243C     tfh.callback1   equ  tfh.top + 60   ; Pointer to callback function 1
0159      243E     tfh.callback2   equ  tfh.top + 62   ; Pointer to callback function 2
0160      2440     tfh.callback3   equ  tfh.top + 64   ; Pointer to callback function 3
0161      2442     tfh.callback4   equ  tfh.top + 66   ; Pointer to callback function 4
0162      2444     tfh.rleonload   equ  tfh.top + 68   ; RLE compression needed during file load
0163      2446     tfh.membuffer   equ  tfh.top + 70   ; 80 bytes file memory buffer
0164      2496     tfh.end         equ  tfh.top + 150  ; Free from here on
0165      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0166      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0167               *--------------------------------------------------------------
0168               * Free for future use               @>2500-264f     (336 bytes)
0169               *--------------------------------------------------------------
0170      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0171      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0172               *--------------------------------------------------------------
0173               * Frame buffer                      @>2650-2fff    (2480 bytes)
0174               *--------------------------------------------------------------
0175      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0176      09B0     fb.size         equ  2480           ; Frame buffer size
0177               *--------------------------------------------------------------
0178               * Index                             @>3000-3fff    (4096 bytes)
0179               *--------------------------------------------------------------
0180      3000     idx.top         equ  >3000          ; Top of index
0181      1000     idx.size        equ  4096           ; Index size
0182               *--------------------------------------------------------------
0183               * SAMS shadow index                 @>a000-afff    (4096 bytes)
0184               *--------------------------------------------------------------
0185      A000     idx.shadow.top  equ  >a000          ; Top of shadow index
0186      1000     idx.shadow.size equ  4096           ; Shadow index size
0187               *--------------------------------------------------------------
0188               * Editor buffer                     @>b000-bfff    (4096 bytes)
0189               *                                   @>c000-cfff    (4096 bytes)
0190               *                                   @>d000-dfff    (4096 bytes)
0191               *                                   @>e000-efff    (4096 bytes)
0192               *                                   @>f000-ffff    (4096 bytes)
0193               *--------------------------------------------------------------
0194      B000     edb.top         equ  >b000          ; Editor buffer high memory
0195      4F9C     edb.size        equ  20380          ; Editor buffer size
0196               *--------------------------------------------------------------
0197               
0198               
0199               *--------------------------------------------------------------
0200               * Cartridge header
0201               *--------------------------------------------------------------
0202                       save  >6000,>7fff
0203                       aorg  >6000
0204               
0205 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0206 6006 6010             data  prog0
0207 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0208 6010 0000     prog0   data  0                     ; No more items following
0209 6012 6CE0             data  runlib
0210               
0212               
0213 6014 1054             byte  16
0214 6015 ....             text  'TIVI 200216-3217'
0215                       even
0216               
0224               *--------------------------------------------------------------
0225               * Include required files
0226               *--------------------------------------------------------------
0227                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     60AA 6CE8 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 60AC 06A0  32         bl    @putat                ; Show crash message
     60AE 6428 
0078 60B0 0000                   data >0000,cpu.crash.msg.crashed
     60B2 6186 
0079               
0080 60B4 06A0  32         bl    @puthex               ; Put hex value on screen
     60B6 6916 
0081 60B8 0015                   byte 0,21             ; \ i  p0 = YX position
0082 60BA FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 60BC 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 60BE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 60C0 06A0  32         bl    @putat                ; Show caller message
     60C2 6428 
0090 60C4 0100                   data >0100,cpu.crash.msg.caller
     60C6 619C 
0091               
0092 60C8 06A0  32         bl    @puthex               ; Put hex value on screen
     60CA 6916 
0093 60CC 0115                   byte 1,21             ; \ i  p0 = YX position
0094 60CE FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 60D0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 60D2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 60D4 06A0  32         bl    @putat
     60D6 6428 
0102 60D8 0300                   byte 3,0
0103 60DA 61B6                   data cpu.crash.msg.wp
0104 60DC 06A0  32         bl    @putat
     60DE 6428 
0105 60E0 0400                   byte 4,0
0106 60E2 61BC                   data cpu.crash.msg.st
0107 60E4 06A0  32         bl    @putat
     60E6 6428 
0108 60E8 1600                   byte 22,0
0109 60EA 61C2                   data cpu.crash.msg.source
0110 60EC 06A0  32         bl    @putat
     60EE 6428 
0111 60F0 1700                   byte 23,0
0112 60F2 61DA                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 60F4 06A0  32         bl    @at                   ; Put cursor at YX
     60F6 661E 
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
     611A 6920 
0143 611C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 611E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 6120 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 6122 06A0  32         bl    @setx                 ; Set cursor X position
     6124 6634 
0149 6126 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 6128 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     612A 6416 
0153 612C 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 612E 06A0  32         bl    @setx                 ; Set cursor X position
     6130 6634 
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
     6140 6416 
0165 6142 61B2                   data cpu.crash.msg.r
0166               
0167 6144 06A0  32         bl    @mknum
     6146 6920 
0168 6148 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 614A 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 614C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 614E 06A0  32         bl    @mkhex                ; Convert hex word to string
     6150 6892 
0177 6152 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 6154 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 6156 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 6158 06A0  32         bl    @setx                 ; Set cursor X position
     615A 6634 
0183 615C 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 615E 06A0  32         bl    @putstr
     6160 6416 
0187 6162 61B4                   data cpu.crash.msg.marker
0188               
0189 6164 06A0  32         bl    @setx                 ; Set cursor X position
     6166 6634 
0190 6168 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 616A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     616C 6416 
0194 616E 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 6170 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 6172 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 6174 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 6176 06A0  32         bl    @down                 ; y=y+1
     6178 6624 
0202               
0203 617A 0586  14         inc   tmp2
0204 617C 0286  22         ci    tmp2,17
     617E 0011 
0205 6180 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 6182 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6184 6BF6 
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
0248 61DA 1542             byte  21
0249 61DB ....             text  'Build-ID  200216-3217'
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
0007 61F0 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     61F2 000E 
     61F4 0106 
     61F6 0204 
     61F8 0020 
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
0032 61FA 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     61FC 000E 
     61FE 0106 
     6200 00F4 
     6202 0028 
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
0058 6204 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6206 003F 
     6208 0240 
     620A 03F4 
     620C 0050 
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
0084 620E 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6210 003F 
     6212 0240 
     6214 03F4 
     6216 0050 
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
0013 6218 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 621A 16FD             data  >16fd                 ; |         jne   mcloop
0015 621C 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 621E D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6220 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6222 C0F9  30 popr3   mov   *stack+,r3
0039 6224 C0B9  30 popr2   mov   *stack+,r2
0040 6226 C079  30 popr1   mov   *stack+,r1
0041 6228 C039  30 popr0   mov   *stack+,r0
0042 622A C2F9  30 poprt   mov   *stack+,r11
0043 622C 045B  20         b     *r11
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
0067 622E C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6230 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6232 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 6234 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 6236 1604  14         jne   filchk                ; No, continue checking
0075               
0076 6238 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     623A FFCE 
0077 623C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     623E 604C 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 6240 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6242 830B 
     6244 830A 
0082               
0083 6246 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     6248 0001 
0084 624A 1602  14         jne   filchk2
0085 624C DD05  32         movb  tmp1,*tmp0+
0086 624E 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 6250 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6252 0002 
0091 6254 1603  14         jne   filchk3
0092 6256 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 6258 DD05  32         movb  tmp1,*tmp0+
0094 625A 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 625C C1C4  18 filchk3 mov   tmp0,tmp3
0099 625E 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6260 0001 
0100 6262 1605  14         jne   fil16b
0101 6264 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 6266 0606  14         dec   tmp2
0103 6268 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     626A 0002 
0104 626C 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 626E C1C6  18 fil16b  mov   tmp2,tmp3
0109 6270 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6272 0001 
0110 6274 1301  14         jeq   dofill
0111 6276 0606  14         dec   tmp2                  ; Make TMP2 even
0112 6278 CD05  34 dofill  mov   tmp1,*tmp0+
0113 627A 0646  14         dect  tmp2
0114 627C 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 627E C1C7  18         mov   tmp3,tmp3
0119 6280 1301  14         jeq   fil.$$
0120 6282 DD05  32         movb  tmp1,*tmp0+
0121 6284 045B  20 fil.$$  b     *r11
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
0140 6286 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 6288 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 628A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 628C 0264  22 xfilv   ori   tmp0,>4000
     628E 4000 
0147 6290 06C4  14         swpb  tmp0
0148 6292 D804  38         movb  tmp0,@vdpa
     6294 8C02 
0149 6296 06C4  14         swpb  tmp0
0150 6298 D804  38         movb  tmp0,@vdpa
     629A 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 629C 020F  20         li    r15,vdpw              ; Set VDP write address
     629E 8C00 
0155 62A0 06C5  14         swpb  tmp1
0156 62A2 C820  54         mov   @filzz,@mcloop        ; Setup move command
     62A4 62AC 
     62A6 8320 
0157 62A8 0460  28         b     @mcloop               ; Write data to VDP
     62AA 8320 
0158               *--------------------------------------------------------------
0162 62AC D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 62AE 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62B0 4000 
0183 62B2 06C4  14 vdra    swpb  tmp0
0184 62B4 D804  38         movb  tmp0,@vdpa
     62B6 8C02 
0185 62B8 06C4  14         swpb  tmp0
0186 62BA D804  38         movb  tmp0,@vdpa            ; Set VDP address
     62BC 8C02 
0187 62BE 045B  20         b     *r11                  ; Exit
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
0198 62C0 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 62C2 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 62C4 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     62C6 4000 
0204 62C8 06C4  14         swpb  tmp0                  ; \
0205 62CA D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     62CC 8C02 
0206 62CE 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 62D0 D804  38         movb  tmp0,@vdpa            ; /
     62D2 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 62D4 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 62D6 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 62D8 045B  20         b     *r11                  ; Exit
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
0232 62DA C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 62DC 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 62DE D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     62E0 8C02 
0238 62E2 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 62E4 D804  38         movb  tmp0,@vdpa            ; /
     62E6 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 62E8 D120  34         movb  @vdpr,tmp0            ; Read byte
     62EA 8800 
0244 62EC 0984  56         srl   tmp0,8                ; Right align
0245 62EE 045B  20         b     *r11                  ; Exit
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
0264 62F0 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 62F2 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 62F4 C144  18         mov   tmp0,tmp1
0270 62F6 05C5  14         inct  tmp1
0271 62F8 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 62FA 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     62FC FF00 
0273 62FE 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 6300 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6302 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 6304 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6306 8000 
0279 6308 0206  20         li    tmp2,8
     630A 0008 
0280 630C D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     630E 830B 
0281 6310 06C5  14         swpb  tmp1
0282 6312 D805  38         movb  tmp1,@vdpa
     6314 8C02 
0283 6316 06C5  14         swpb  tmp1
0284 6318 D805  38         movb  tmp1,@vdpa
     631A 8C02 
0285 631C 0225  22         ai    tmp1,>0100
     631E 0100 
0286 6320 0606  14         dec   tmp2
0287 6322 16F4  14         jne   vidta1                ; Next register
0288 6324 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6326 833A 
0289 6328 045B  20         b     *r11
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
0306 632A C13B  30 putvr   mov   *r11+,tmp0
0307 632C 0264  22 putvrx  ori   tmp0,>8000
     632E 8000 
0308 6330 06C4  14         swpb  tmp0
0309 6332 D804  38         movb  tmp0,@vdpa
     6334 8C02 
0310 6336 06C4  14         swpb  tmp0
0311 6338 D804  38         movb  tmp0,@vdpa
     633A 8C02 
0312 633C 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 633E C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 6340 C10E  18         mov   r14,tmp0
0322 6342 0984  56         srl   tmp0,8
0323 6344 06A0  32         bl    @putvrx               ; Write VR#0
     6346 632C 
0324 6348 0204  20         li    tmp0,>0100
     634A 0100 
0325 634C D820  54         movb  @r14lb,@tmp0lb
     634E 831D 
     6350 8309 
0326 6352 06A0  32         bl    @putvrx               ; Write VR#1
     6354 632C 
0327 6356 0458  20         b     *tmp4                 ; Exit
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
0341 6358 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 635A 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 635C C11B  26         mov   *r11,tmp0             ; Get P0
0344 635E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6360 7FFF 
0345 6362 2120  38         coc   @wbit0,tmp0
     6364 6046 
0346 6366 1604  14         jne   ldfnt1
0347 6368 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     636A 8000 
0348 636C 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     636E 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 6370 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6372 63DA 
0353 6374 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6376 9C02 
0354 6378 06C4  14         swpb  tmp0
0355 637A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     637C 9C02 
0356 637E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6380 9800 
0357 6382 06C5  14         swpb  tmp1
0358 6384 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6386 9800 
0359 6388 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 638A D805  38         movb  tmp1,@grmwa
     638C 9C02 
0364 638E 06C5  14         swpb  tmp1
0365 6390 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6392 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 6394 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 6396 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6398 62AE 
0371 639A 05C8  14         inct  tmp4                  ; R11=R11+2
0372 639C C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 639E 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63A0 7FFF 
0374 63A2 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63A4 63DC 
0375 63A6 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     63A8 63DE 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 63AA 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 63AC 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 63AE D120  34         movb  @grmrd,tmp0
     63B0 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 63B2 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63B4 6046 
0386 63B6 1603  14         jne   ldfnt3                ; No, so skip
0387 63B8 D1C4  18         movb  tmp0,tmp3
0388 63BA 0917  56         srl   tmp3,1
0389 63BC E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 63BE D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     63C0 8C00 
0394 63C2 0606  14         dec   tmp2
0395 63C4 16F2  14         jne   ldfnt2
0396 63C6 05C8  14         inct  tmp4                  ; R11=R11+2
0397 63C8 020F  20         li    r15,vdpw              ; Set VDP write address
     63CA 8C00 
0398 63CC 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63CE 7FFF 
0399 63D0 0458  20         b     *tmp4                 ; Exit
0400 63D2 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     63D4 6026 
     63D6 8C00 
0401 63D8 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 63DA 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     63DC 0200 
     63DE 0000 
0406 63E0 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     63E2 01C0 
     63E4 0101 
0407 63E6 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     63E8 02A0 
     63EA 0101 
0408 63EC 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     63EE 00E0 
     63F0 0101 
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
0426 63F2 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 63F4 C3A0  34         mov   @wyx,r14              ; Get YX
     63F6 832A 
0428 63F8 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 63FA 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     63FC 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 63FE C3A0  34         mov   @wyx,r14              ; Get YX
     6400 832A 
0435 6402 024E  22         andi  r14,>00ff             ; Remove Y
     6404 00FF 
0436 6406 A3CE  18         a     r14,r15               ; pos = pos + X
0437 6408 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     640A 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 640C C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 640E C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6410 020F  20         li    r15,vdpw              ; VDP write address
     6412 8C00 
0444 6414 045B  20         b     *r11
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
0459 6416 C17B  30 putstr  mov   *r11+,tmp1
0460 6418 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 641A C1CB  18 xutstr  mov   r11,tmp3
0462 641C 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     641E 63F2 
0463 6420 C2C7  18         mov   tmp3,r11
0464 6422 0986  56         srl   tmp2,8                ; Right justify length byte
0465 6424 0460  28         b     @xpym2v               ; Display string
     6426 6436 
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
0480 6428 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     642A 832A 
0481 642C 0460  28         b     @putstr
     642E 6416 
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
0020 6430 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6432 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6434 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6436 0264  22 xpym2v  ori   tmp0,>4000
     6438 4000 
0027 643A 06C4  14         swpb  tmp0
0028 643C D804  38         movb  tmp0,@vdpa
     643E 8C02 
0029 6440 06C4  14         swpb  tmp0
0030 6442 D804  38         movb  tmp0,@vdpa
     6444 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6446 020F  20         li    r15,vdpw              ; Set VDP write address
     6448 8C00 
0035 644A C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     644C 6454 
     644E 8320 
0036 6450 0460  28         b     @mcloop               ; Write data to VDP
     6452 8320 
0037 6454 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6456 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6458 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 645A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 645C 06C4  14 xpyv2m  swpb  tmp0
0027 645E D804  38         movb  tmp0,@vdpa
     6460 8C02 
0028 6462 06C4  14         swpb  tmp0
0029 6464 D804  38         movb  tmp0,@vdpa
     6466 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6468 020F  20         li    r15,vdpr              ; Set VDP read address
     646A 8800 
0034 646C C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     646E 6476 
     6470 8320 
0035 6472 0460  28         b     @mcloop               ; Read data from VDP
     6474 8320 
0036 6476 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6478 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 647A C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 647C C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 647E C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6480 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6482 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6484 FFCE 
0034 6486 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6488 604C 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 648A 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     648C 0001 
0039 648E 1603  14         jne   cpym0                 ; No, continue checking
0040 6490 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6492 04C6  14         clr   tmp2                  ; Reset counter
0042 6494 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 6496 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6498 7FFF 
0047 649A C1C4  18         mov   tmp0,tmp3
0048 649C 0247  22         andi  tmp3,1
     649E 0001 
0049 64A0 1618  14         jne   cpyodd                ; Odd source address handling
0050 64A2 C1C5  18 cpym1   mov   tmp1,tmp3
0051 64A4 0247  22         andi  tmp3,1
     64A6 0001 
0052 64A8 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 64AA 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     64AC 6046 
0057 64AE 1605  14         jne   cpym3
0058 64B0 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     64B2 64D8 
     64B4 8320 
0059 64B6 0460  28         b     @mcloop               ; Copy memory and exit
     64B8 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 64BA C1C6  18 cpym3   mov   tmp2,tmp3
0064 64BC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     64BE 0001 
0065 64C0 1301  14         jeq   cpym4
0066 64C2 0606  14         dec   tmp2                  ; Make TMP2 even
0067 64C4 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 64C6 0646  14         dect  tmp2
0069 64C8 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 64CA C1C7  18         mov   tmp3,tmp3
0074 64CC 1301  14         jeq   cpymz
0075 64CE D554  38         movb  *tmp0,*tmp1
0076 64D0 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 64D2 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     64D4 8000 
0081 64D6 10E9  14         jmp   cpym2
0082 64D8 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0017               *    (bl  @sams.page)
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
0062 64DA C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 64DC 0649  14         dect  stack
0065 64DE C64B  30         mov   r11,*stack            ; Push return address
0066 64E0 0649  14         dect  stack
0067 64E2 C640  30         mov   r0,*stack             ; Push r0
0068 64E4 0649  14         dect  stack
0069 64E6 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 64E8 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 64EA 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 64EC 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     64EE 4000 
0077 64F0 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     64F2 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 64F4 020C  20         li    r12,>1e00             ; SAMS CRU address
     64F6 1E00 
0082 64F8 04C0  14         clr   r0
0083 64FA 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 64FC D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 64FE D100  18         movb  r0,tmp0
0086 6500 0984  56         srl   tmp0,8                ; Right align
0087 6502 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     6504 833C 
0088 6506 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6508 C339  30         mov   *stack+,r12           ; Pop r12
0094 650A C039  30         mov   *stack+,r0            ; Pop r0
0095 650C C2F9  30         mov   *stack+,r11           ; Pop return address
0096 650E 045B  20         b     *r11                  ; Return to caller
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
0131 6510 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6512 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6514 0649  14         dect  stack
0135 6516 C64B  30         mov   r11,*stack            ; Push return address
0136 6518 0649  14         dect  stack
0137 651A C640  30         mov   r0,*stack             ; Push r0
0138 651C 0649  14         dect  stack
0139 651E C64C  30         mov   r12,*stack            ; Push r12
0140 6520 0649  14         dect  stack
0141 6522 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6524 0649  14         dect  stack
0143 6526 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6528 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 652A 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 652C 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     652E 001E 
0153 6530 150A  14         jgt   !
0154 6532 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     6534 0004 
0155 6536 1107  14         jlt   !
0156 6538 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     653A 0012 
0157 653C 1508  14         jgt   sams.page.set.switch_page
0158 653E 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6540 0006 
0159 6542 1501  14         jgt   !
0160 6544 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 6546 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6548 FFCE 
0165 654A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     654C 604C 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 654E 020C  20         li    r12,>1e00             ; SAMS CRU address
     6550 1E00 
0171 6552 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 6554 06C0  14         swpb  r0                    ; LSB to MSB
0173 6556 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 6558 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     655A 4000 
0175 655C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 655E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 6560 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 6562 C339  30         mov   *stack+,r12           ; Pop r12
0183 6564 C039  30         mov   *stack+,r0            ; Pop r0
0184 6566 C2F9  30         mov   *stack+,r11           ; Pop return address
0185 6568 045B  20         b     *r11                  ; Return to caller
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
0199 656A 020C  20         li    r12,>1e00             ; SAMS CRU address
     656C 1E00 
0200 656E 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 6570 045B  20         b     *r11                  ; Return to caller
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
0222 6572 020C  20         li    r12,>1e00             ; SAMS CRU address
     6574 1E00 
0223 6576 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 6578 045B  20         b     *r11                  ; Return to caller
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
0255 657A C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 657C 0649  14         dect  stack
0258 657E C64B  30         mov   r11,*stack            ; Save return address
0259 6580 0649  14         dect  stack
0260 6582 C644  30         mov   tmp0,*stack           ; Save tmp0
0261 6584 0649  14         dect  stack
0262 6586 C645  30         mov   tmp1,*stack           ; Save tmp1
0263 6588 0649  14         dect  stack
0264 658A C646  30         mov   tmp2,*stack           ; Save tmp2
0265 658C 0649  14         dect  stack
0266 658E C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 6590 0206  20         li    tmp2,8                ; Set loop counter
     6592 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 6594 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 6596 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 6598 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     659A 6514 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 659C 0606  14         dec   tmp2                  ; Next iteration
0283 659E 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 65A0 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     65A2 656A 
0289                                                   ; / activating changes.
0290               
0291 65A4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 65A6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 65A8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 65AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 65AC C2F9  30         mov   *stack+,r11           ; Pop r11
0296 65AE 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.reset
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.reset
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.reset:
0313 65B0 0649  14         dect  stack
0314 65B2 C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 65B4 06A0  32         bl    @sams.layout
     65B6 657A 
0319 65B8 65BE                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.exit:
0324 65BA C2F9  30         mov   *stack+,r11           ; Pop r11
0325 65BC 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 65BE 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     65C0 0002 
0331 65C2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     65C4 0003 
0332 65C6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     65C8 000A 
0333 65CA B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     65CC 000B 
0334 65CE C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     65D0 000C 
0335 65D2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     65D4 000D 
0336 65D6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     65D8 000E 
0337 65DA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     65DC 000F 
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
0009 65DE 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     65E0 FFBF 
0010 65E2 0460  28         b     @putv01
     65E4 633E 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 65E6 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     65E8 0040 
0018 65EA 0460  28         b     @putv01
     65EC 633E 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 65EE 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     65F0 FFDF 
0026 65F2 0460  28         b     @putv01
     65F4 633E 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 65F6 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     65F8 0020 
0034 65FA 0460  28         b     @putv01
     65FC 633E 
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
0010 65FE 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6600 FFFE 
0011 6602 0460  28         b     @putv01
     6604 633E 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6606 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6608 0001 
0019 660A 0460  28         b     @putv01
     660C 633E 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 660E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6610 FFFD 
0027 6612 0460  28         b     @putv01
     6614 633E 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6616 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6618 0002 
0035 661A 0460  28         b     @putv01
     661C 633E 
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
0018 661E C83B  50 at      mov   *r11+,@wyx
     6620 832A 
0019 6622 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6624 B820  54 down    ab    @hb$01,@wyx
     6626 6038 
     6628 832A 
0028 662A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 662C 7820  54 up      sb    @hb$01,@wyx
     662E 6038 
     6630 832A 
0037 6632 045B  20         b     *r11
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
0049 6634 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6636 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6638 832A 
0051 663A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     663C 832A 
0052 663E 045B  20         b     *r11
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
0021 6640 C120  34 yx2px   mov   @wyx,tmp0
     6642 832A 
0022 6644 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6646 06C4  14         swpb  tmp0                  ; Y<->X
0024 6648 04C5  14         clr   tmp1                  ; Clear before copy
0025 664A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 664C 20A0  38         coc   @wbit1,config         ; f18a present ?
     664E 6044 
0030 6650 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6652 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6654 833A 
     6656 6680 
0032 6658 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 665A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 665C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 665E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6660 0500 
0037 6662 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6664 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6666 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6668 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 666A D105  18         movb  tmp1,tmp0
0051 666C 06C4  14         swpb  tmp0                  ; X<->Y
0052 666E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6670 6046 
0053 6672 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6674 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6676 6038 
0059 6678 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     667A 604A 
0060 667C 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 667E 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6680 0050            data   80
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
0013 6682 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6684 06A0  32         bl    @putvr                ; Write once
     6686 632A 
0015 6688 391C             data  >391c                 ; VR1/57, value 00011100
0016 668A 06A0  32         bl    @putvr                ; Write twice
     668C 632A 
0017 668E 391C             data  >391c                 ; VR1/57, value 00011100
0018 6690 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6692 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6694 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6696 632A 
0028 6698 391C             data  >391c
0029 669A 0458  20         b     *tmp4                 ; Exit
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
0040 669C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 669E 06A0  32         bl    @cpym2v
     66A0 6430 
0042 66A2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     66A4 66E0 
     66A6 0006 
0043 66A8 06A0  32         bl    @putvr
     66AA 632A 
0044 66AC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 66AE 06A0  32         bl    @putvr
     66B0 632A 
0046 66B2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 66B4 0204  20         li    tmp0,>3f00
     66B6 3F00 
0052 66B8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     66BA 62B2 
0053 66BC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     66BE 8800 
0054 66C0 0984  56         srl   tmp0,8
0055 66C2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     66C4 8800 
0056 66C6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 66C8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 66CA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     66CC BFFF 
0060 66CE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 66D0 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     66D2 4000 
0063               f18chk_exit:
0064 66D4 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     66D6 6286 
0065 66D8 3F00             data  >3f00,>00,6
     66DA 0000 
     66DC 0006 
0066 66DE 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 66E0 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 66E2 3F00             data  >3f00                 ; 3f02 / 3f00
0073 66E4 0340             data  >0340                 ; 3f04   0340  idle
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
0092 66E6 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 66E8 06A0  32         bl    @putvr
     66EA 632A 
0097 66EC 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 66EE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     66F0 632A 
0100 66F2 391C             data  >391c                 ; Lock the F18a
0101 66F4 0458  20         b     *tmp4                 ; Exit
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
0120 66F6 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 66F8 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     66FA 6044 
0122 66FC 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 66FE C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6700 8802 
0127 6702 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6704 632A 
0128 6706 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6708 04C4  14         clr   tmp0
0130 670A D120  34         movb  @vdps,tmp0
     670C 8802 
0131 670E 0984  56         srl   tmp0,8
0132 6710 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6712 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6714 832A 
0018 6716 D17B  28         movb  *r11+,tmp1
0019 6718 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 671A D1BB  28         movb  *r11+,tmp2
0021 671C 0986  56         srl   tmp2,8                ; Repeat count
0022 671E C1CB  18         mov   r11,tmp3
0023 6720 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6722 63F2 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6724 020B  20         li    r11,hchar1
     6726 672C 
0028 6728 0460  28         b     @xfilv                ; Draw
     672A 628C 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 672C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     672E 6048 
0033 6730 1302  14         jeq   hchar2                ; Yes, exit
0034 6732 C2C7  18         mov   tmp3,r11
0035 6734 10EE  14         jmp   hchar                 ; Next one
0036 6736 05C7  14 hchar2  inct  tmp3
0037 6738 0457  20         b     *tmp3                 ; Exit
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
0016 673A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     673C 6046 
0017 673E 020C  20         li    r12,>0024
     6740 0024 
0018 6742 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6744 67D2 
0019 6746 04C6  14         clr   tmp2
0020 6748 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 674A 04CC  14         clr   r12
0025 674C 1F08  20         tb    >0008                 ; Shift-key ?
0026 674E 1302  14         jeq   realk1                ; No
0027 6750 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6752 6802 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6754 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6756 1302  14         jeq   realk2                ; No
0033 6758 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     675A 6832 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 675C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 675E 1302  14         jeq   realk3                ; No
0039 6760 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6762 6862 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6764 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6766 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6768 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 676A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     676C 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 676E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6770 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6772 0006 
0052 6774 0606  14 realk5  dec   tmp2
0053 6776 020C  20         li    r12,>24               ; CRU address for P2-P4
     6778 0024 
0054 677A 06C6  14         swpb  tmp2
0055 677C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 677E 06C6  14         swpb  tmp2
0057 6780 020C  20         li    r12,6                 ; CRU read address
     6782 0006 
0058 6784 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6786 0547  14         inv   tmp3                  ;
0060 6788 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     678A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 678C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 678E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6790 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6792 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6794 0285  22         ci    tmp1,8
     6796 0008 
0069 6798 1AFA  14         jl    realk6
0070 679A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 679C 1BEB  14         jh    realk5                ; No, next column
0072 679E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 67A0 C206  18 realk8  mov   tmp2,tmp4
0077 67A2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 67A4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 67A6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 67A8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 67AA 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 67AC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 67AE 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     67B0 6046 
0087 67B2 1608  14         jne   realka                ; No, continue saving key
0088 67B4 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     67B6 67FC 
0089 67B8 1A05  14         jl    realka
0090 67BA 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     67BC 67FA 
0091 67BE 1B02  14         jh    realka                ; No, continue
0092 67C0 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     67C2 E000 
0093 67C4 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     67C6 833C 
0094 67C8 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     67CA 6030 
0095 67CC 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     67CE 8C00 
0096 67D0 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 67D2 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     67D4 0000 
     67D6 FF0D 
     67D8 203D 
0099 67DA ....             text  'xws29ol.'
0100 67E2 ....             text  'ced38ik,'
0101 67EA ....             text  'vrf47ujm'
0102 67F2 ....             text  'btg56yhn'
0103 67FA ....             text  'zqa10p;/'
0104 6802 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6804 0000 
     6806 FF0D 
     6808 202B 
0105 680A ....             text  'XWS@(OL>'
0106 6812 ....             text  'CED#*IK<'
0107 681A ....             text  'VRF$&UJM'
0108 6822 ....             text  'BTG%^YHN'
0109 682A ....             text  'ZQA!)P:-'
0110 6832 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6834 0000 
     6836 FF0D 
     6838 2005 
0111 683A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     683C 0804 
     683E 0F27 
     6840 C2B9 
0112 6842 600B             data  >600b,>0907,>063f,>c1B8
     6844 0907 
     6846 063F 
     6848 C1B8 
0113 684A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     684C 7B02 
     684E 015F 
     6850 C0C3 
0114 6852 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6854 7D0E 
     6856 0CC6 
     6858 BFC4 
0115 685A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     685C 7C03 
     685E BC22 
     6860 BDBA 
0116 6862 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6864 0000 
     6866 FF0D 
     6868 209D 
0117 686A 9897             data  >9897,>93b2,>9f8f,>8c9B
     686C 93B2 
     686E 9F8F 
     6870 8C9B 
0118 6872 8385             data  >8385,>84b3,>9e89,>8b80
     6874 84B3 
     6876 9E89 
     6878 8B80 
0119 687A 9692             data  >9692,>86b4,>b795,>8a8D
     687C 86B4 
     687E B795 
     6880 8A8D 
0120 6882 8294             data  >8294,>87b5,>b698,>888E
     6884 87B5 
     6886 B698 
     6888 888E 
0121 688A 9A91             data  >9a91,>81b1,>b090,>9cBB
     688C 81B1 
     688E B090 
     6890 9CBB 
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
0023 6892 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6894 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6896 8340 
0025 6898 04E0  34         clr   @waux1
     689A 833C 
0026 689C 04E0  34         clr   @waux2
     689E 833E 
0027 68A0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     68A2 833C 
0028 68A4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 68A6 0205  20         li    tmp1,4                ; 4 nibbles
     68A8 0004 
0033 68AA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 68AC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     68AE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 68B0 0286  22         ci    tmp2,>000a
     68B2 000A 
0039 68B4 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 68B6 C21B  26         mov   *r11,tmp4
0045 68B8 0988  56         srl   tmp4,8                ; Right justify
0046 68BA 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     68BC FFF6 
0047 68BE 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 68C0 C21B  26         mov   *r11,tmp4
0054 68C2 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     68C4 00FF 
0055               
0056 68C6 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 68C8 06C6  14         swpb  tmp2
0058 68CA DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 68CC 0944  56         srl   tmp0,4                ; Next nibble
0060 68CE 0605  14         dec   tmp1
0061 68D0 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 68D2 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     68D4 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 68D6 C160  34         mov   @waux3,tmp1           ; Get pointer
     68D8 8340 
0067 68DA 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 68DC 0585  14         inc   tmp1                  ; Next byte, not word!
0069 68DE C120  34         mov   @waux2,tmp0
     68E0 833E 
0070 68E2 06C4  14         swpb  tmp0
0071 68E4 DD44  32         movb  tmp0,*tmp1+
0072 68E6 06C4  14         swpb  tmp0
0073 68E8 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 68EA C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     68EC 8340 
0078 68EE D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     68F0 603C 
0079 68F2 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 68F4 C120  34         mov   @waux1,tmp0
     68F6 833C 
0084 68F8 06C4  14         swpb  tmp0
0085 68FA DD44  32         movb  tmp0,*tmp1+
0086 68FC 06C4  14         swpb  tmp0
0087 68FE DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6900 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6902 6046 
0092 6904 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6906 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6908 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     690A 7FFF 
0098 690C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     690E 8340 
0099 6910 0460  28         b     @xutst0               ; Display string
     6912 6418 
0100 6914 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6916 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6918 832A 
0122 691A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     691C 8000 
0123 691E 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6920 0207  20 mknum   li    tmp3,5                ; Digit counter
     6922 0005 
0020 6924 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6926 C155  26         mov   *tmp1,tmp1            ; /
0022 6928 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 692A 0228  22         ai    tmp4,4                ; Get end of buffer
     692C 0004 
0024 692E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6930 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6932 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6934 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6936 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6938 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 693A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 693C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 693E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6940 0607  14         dec   tmp3                  ; Decrease counter
0036 6942 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6944 0207  20         li    tmp3,4                ; Check first 4 digits
     6946 0004 
0041 6948 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 694A C11B  26         mov   *r11,tmp0
0043 694C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 694E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6950 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6952 05CB  14 mknum3  inct  r11
0047 6954 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6956 6046 
0048 6958 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 695A 045B  20         b     *r11                  ; Exit
0050 695C DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 695E 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6960 13F8  14         jeq   mknum3                ; Yes, exit
0053 6962 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6964 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6966 7FFF 
0058 6968 C10B  18         mov   r11,tmp0
0059 696A 0224  22         ai    tmp0,-4
     696C FFFC 
0060 696E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6970 0206  20         li    tmp2,>0500            ; String length = 5
     6972 0500 
0062 6974 0460  28         b     @xutstr               ; Display string
     6976 641A 
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
0092 6978 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 697A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 697C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 697E 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6980 0207  20         li    tmp3,5                ; Set counter
     6982 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6984 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6986 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6988 0584  14         inc   tmp0                  ; Next character
0104 698A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 698C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 698E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6990 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6992 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6994 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6996 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6998 0607  14         dec   tmp3                  ; Last character ?
0120 699A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 699C 045B  20         b     *r11                  ; Return
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
0138 699E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     69A0 832A 
0139 69A2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     69A4 8000 
0140 69A6 10BC  14         jmp   mknum                 ; Convert number and display
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
0020 69A8 C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     69AA 2000 
0021 69AC C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     69AE 2002 
0022 69B0 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     69B2 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 69B4 0200  20         li    r0,>8306              ; Scratpad source address
     69B6 8306 
0027 69B8 0201  20         li    r1,>2006              ; RAM target address
     69BA 2006 
0028 69BC 0202  20         li    r2,62                 ; Loop counter
     69BE 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 69C0 CC70  46         mov   *r0+,*r1+
0034 69C2 CC70  46         mov   *r0+,*r1+
0035 69C4 0642  14         dect  r2
0036 69C6 16FC  14         jne   cpu.scrpad.backup.copy
0037 69C8 C820  54         mov   @>83fe,@>20fe         ; Copy last word
     69CA 83FE 
     69CC 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 69CE C020  34         mov   @>2000,r0             ; Restore r0
     69D0 2000 
0042 69D2 C060  34         mov   @>2002,r1             ; Restore r1
     69D4 2002 
0043 69D6 C0A0  34         mov   @>2004,r2             ; Restore r2
     69D8 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 69DA 045B  20         b     *r11                  ; Return to caller
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
0066 69DC C820  54         mov   @>2000,@>8300
     69DE 2000 
     69E0 8300 
0067 69E2 C820  54         mov   @>2002,@>8302
     69E4 2002 
     69E6 8302 
0068 69E8 C820  54         mov   @>2004,@>8304
     69EA 2004 
     69EC 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 69EE C800  38         mov   r0,@>2000
     69F0 2000 
0073 69F2 C801  38         mov   r1,@>2002
     69F4 2002 
0074 69F6 C802  38         mov   r2,@>2004
     69F8 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 69FA 0200  20         li    r0,>2006
     69FC 2006 
0079 69FE 0201  20         li    r1,>8306
     6A00 8306 
0080 6A02 0202  20         li    r2,62
     6A04 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 6A06 CC70  46         mov   *r0+,*r1+
0086 6A08 CC70  46         mov   *r0+,*r1+
0087 6A0A 0642  14         dect  r2
0088 6A0C 16FC  14         jne   cpu.scrpad.restore.copy
0089 6A0E C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6A10 20FE 
     6A12 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 6A14 C020  34         mov   @>2000,r0             ; Restore r0
     6A16 2000 
0094 6A18 C060  34         mov   @>2002,r1             ; Restore r1
     6A1A 2002 
0095 6A1C C0A0  34         mov   @>2004,r2             ; Restore r2
     6A1E 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6A20 045B  20         b     *r11                  ; Return to caller
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
0025 6A22 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 6A24 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6A26 8300 
0031 6A28 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 6A2A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A2C 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6A2E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6A30 0606  14         dec   tmp2
0038 6A32 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6A34 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6A36 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6A38 6A3E 
0044                                                   ; R14=PC
0045 6A3A 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 6A3C 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 6A3E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6A40 69DC 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 6A42 045B  20         b     *r11                  ; Return to caller
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
0078 6A44 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 6A46 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6A48 8300 
0084 6A4A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A4C 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6A4E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6A50 0606  14         dec   tmp2
0090 6A52 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6A54 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6A56 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6A58 045B  20         b     *r11                  ; Return to caller
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
0041 6A5A 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6A5C 6A5E             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6A5E C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6A60 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6A62 8322 
0049 6A64 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6A66 6042 
0050 6A68 C020  34         mov   @>8356,r0             ; get ptr to pab
     6A6A 8356 
0051 6A6C C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6A6E 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6A70 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6A72 06C0  14         swpb  r0                    ;
0059 6A74 D800  38         movb  r0,@vdpa              ; send low byte
     6A76 8C02 
0060 6A78 06C0  14         swpb  r0                    ;
0061 6A7A D800  38         movb  r0,@vdpa              ; send high byte
     6A7C 8C02 
0062 6A7E D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6A80 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6A82 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6A84 0704  14         seto  r4                    ; init counter
0070 6A86 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6A88 2420 
0071 6A8A 0580  14 !       inc   r0                    ; point to next char of name
0072 6A8C 0584  14         inc   r4                    ; incr char counter
0073 6A8E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6A90 0007 
0074 6A92 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6A94 80C4  18         c     r4,r3                 ; end of name?
0077 6A96 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6A98 06C0  14         swpb  r0                    ;
0082 6A9A D800  38         movb  r0,@vdpa              ; send low byte
     6A9C 8C02 
0083 6A9E 06C0  14         swpb  r0                    ;
0084 6AA0 D800  38         movb  r0,@vdpa              ; send high byte
     6AA2 8C02 
0085 6AA4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6AA6 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6AA8 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6AAA 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6AAC 6B6E 
0093 6AAE 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6AB0 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6AB2 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6AB4 04E0  34         clr   @>83d0
     6AB6 83D0 
0102 6AB8 C804  38         mov   r4,@>8354             ; save name length for search
     6ABA 8354 
0103 6ABC 0584  14         inc   r4                    ; adjust for dot
0104 6ABE A804  38         a     r4,@>8356             ; point to position after name
     6AC0 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6AC2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6AC4 83E0 
0110 6AC6 04C1  14         clr   r1                    ; version found of dsr
0111 6AC8 020C  20         li    r12,>0f00             ; init cru addr
     6ACA 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6ACC C30C  18         mov   r12,r12               ; anything to turn off?
0117 6ACE 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6AD0 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6AD2 022C  22         ai    r12,>0100             ; next rom to turn on
     6AD4 0100 
0125 6AD6 04E0  34         clr   @>83d0                ; clear in case we are done
     6AD8 83D0 
0126 6ADA 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6ADC 2000 
0127 6ADE 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6AE0 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6AE2 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6AE4 1D00  20         sbo   0                     ; turn on rom
0134 6AE6 0202  20         li    r2,>4000              ; start at beginning of rom
     6AE8 4000 
0135 6AEA 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6AEC 6B6A 
0136 6AEE 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6AF0 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6AF2 240A 
0146 6AF4 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6AF6 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6AF8 83D2 
0152 6AFA 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6AFC C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6AFE 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6B00 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6B02 83D2 
0161 6B04 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6B06 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6B08 04C5  14         clr   r5                    ; Remove any old stuff
0167 6B0A D160  34         movb  @>8355,r5             ; get length as counter
     6B0C 8355 
0168 6B0E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6B10 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6B12 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6B14 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6B16 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B18 2420 
0175 6B1A 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6B1C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6B1E 0605  14         dec   r5                    ; loop until full length checked
0179 6B20 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6B22 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6B24 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6B26 0581  14         inc   r1                    ; next version found
0191 6B28 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6B2A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6B2C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6B2E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6B30 2400 
0200 6B32 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6B34 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6B36 8322 
0202                                                   ; (8 or >a)
0203 6B38 0281  22         ci    r1,8                  ; was it 8?
     6B3A 0008 
0204 6B3C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6B3E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6B40 8350 
0206                                                   ; Get error byte from @>8350
0207 6B42 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6B44 06C0  14         swpb  r0                    ;
0215 6B46 D800  38         movb  r0,@vdpa              ; send low byte
     6B48 8C02 
0216 6B4A 06C0  14         swpb  r0                    ;
0217 6B4C D800  38         movb  r0,@vdpa              ; send high byte
     6B4E 8C02 
0218 6B50 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6B52 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6B54 09D1  56         srl   r1,13                 ; just keep error bits
0226 6B56 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6B58 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6B5A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6B5C 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6B5E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6B60 06C1  14         swpb  r1                    ; put error in hi byte
0239 6B62 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6B64 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6B66 6042 
0241 6B68 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6B6A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6B6C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6B6E ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
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
0043 6B70 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6B72 C04B  18         mov   r11,r1                ; Save return address
0049 6B74 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B76 2428 
0050 6B78 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6B7A 04C5  14         clr   tmp1                  ; io.op.open
0052 6B7C 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B7E 62C4 
0053               file.open_init:
0054 6B80 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B82 0009 
0055 6B84 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B86 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6B88 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B8A 6A5A 
0061 6B8C 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6B8E 1029  14         jmp   file.record.pab.details
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
0090 6B90 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6B92 C04B  18         mov   r11,r1                ; Save return address
0096 6B94 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B96 2428 
0097 6B98 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6B9A 0205  20         li    tmp1,io.op.close      ; io.op.close
     6B9C 0001 
0099 6B9E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BA0 62C4 
0100               file.close_init:
0101 6BA2 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BA4 0009 
0102 6BA6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BA8 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6BAA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BAC 6A5A 
0108 6BAE 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6BB0 1018  14         jmp   file.record.pab.details
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
0139 6BB2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6BB4 C04B  18         mov   r11,r1                ; Save return address
0145 6BB6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BB8 2428 
0146 6BBA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6BBC 0205  20         li    tmp1,io.op.read       ; io.op.read
     6BBE 0002 
0148 6BC0 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BC2 62C4 
0149               file.record.read_init:
0150 6BC4 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BC6 0009 
0151 6BC8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BCA 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6BCC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BCE 6A5A 
0157 6BD0 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6BD2 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6BD4 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6BD6 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6BD8 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6BDA 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6BDC 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6BDE 1000  14         nop
0191               
0192               
0193               file.status:
0194 6BE0 1000  14         nop
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
0211 6BE2 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6BE4 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6BE6 2428 
0219 6BE8 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6BEA 0005 
0220 6BEC 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6BEE 62DC 
0221 6BF0 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6BF2 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6BF4 0451  20         b     *r1                   ; Return to caller
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
0020 6BF6 0300  24 tmgr    limi  0                     ; No interrupt processing
     6BF8 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6BFA D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6BFC 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6BFE 2360  38         coc   @wbit2,r13            ; C flag on ?
     6C00 6042 
0029 6C02 1602  14         jne   tmgr1a                ; No, so move on
0030 6C04 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6C06 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6C08 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6C0A 6046 
0035 6C0C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6C0E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6C10 6036 
0048 6C12 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6C14 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6C16 6034 
0050 6C18 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6C1A 0460  28         b     @kthread              ; Run kernel thread
     6C1C 6C94 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6C1E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6C20 603A 
0056 6C22 13EB  14         jeq   tmgr1
0057 6C24 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6C26 6038 
0058 6C28 16E8  14         jne   tmgr1
0059 6C2A C120  34         mov   @wtiusr,tmp0
     6C2C 832E 
0060 6C2E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6C30 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6C32 6C92 
0065 6C34 C10A  18         mov   r10,tmp0
0066 6C36 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6C38 00FF 
0067 6C3A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6C3C 6042 
0068 6C3E 1303  14         jeq   tmgr5
0069 6C40 0284  22         ci    tmp0,60               ; 1 second reached ?
     6C42 003C 
0070 6C44 1002  14         jmp   tmgr6
0071 6C46 0284  22 tmgr5   ci    tmp0,50
     6C48 0032 
0072 6C4A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C4C 1001  14         jmp   tmgr8
0074 6C4E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C50 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C52 832C 
0079 6C54 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6C56 FF00 
0080 6C58 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6C5A 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6C5C 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6C5E 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6C60 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6C62 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6C64 830C 
     6C66 830D 
0089 6C68 1608  14         jne   tmgr10                ; No, get next slot
0090 6C6A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6C6C FF00 
0091 6C6E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6C70 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6C72 8330 
0096 6C74 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6C76 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6C78 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6C7A 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6C7C 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6C7E 8315 
     6C80 8314 
0103 6C82 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6C84 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6C86 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6C88 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6C8A 10F7  14         jmp   tmgr10                ; Process next slot
0108 6C8C 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6C8E FF00 
0109 6C90 10B4  14         jmp   tmgr1
0110 6C92 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6C94 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6C96 6036 
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
0041 6C98 06A0  32         bl    @realkb               ; Scan full keyboard
     6C9A 673A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6C9C 0460  28         b     @tmgr3                ; Exit
     6C9E 6C1E 
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
0017 6CA0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6CA2 832E 
0018 6CA4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6CA6 6038 
0019 6CA8 045B  20 mkhoo1  b     *r11                  ; Return
0020      6BFA     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6CAA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6CAC 832E 
0029 6CAE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6CB0 FEFF 
0030 6CB2 045B  20         b     *r11                  ; Return
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
0017 6CB4 C13B  30 mkslot  mov   *r11+,tmp0
0018 6CB6 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6CB8 C184  18         mov   tmp0,tmp2
0023 6CBA 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6CBC A1A0  34         a     @wtitab,tmp2          ; Add table base
     6CBE 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6CC0 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6CC2 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6CC4 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6CC6 881B  46         c     *r11,@w$ffff          ; End of list ?
     6CC8 6048 
0035 6CCA 1301  14         jeq   mkslo1                ; Yes, exit
0036 6CCC 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6CCE 05CB  14 mkslo1  inct  r11
0041 6CD0 045B  20         b     *r11                  ; Exit
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
0052 6CD2 C13B  30 clslot  mov   *r11+,tmp0
0053 6CD4 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6CD6 A120  34         a     @wtitab,tmp0          ; Add table base
     6CD8 832C 
0055 6CDA 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6CDC 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6CDE 045B  20         b     *r11                  ; Exit
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
0250 6CE0 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6CE2 69A8 
0251 6CE4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6CE6 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6CE8 0300  24 runli1  limi  0                     ; Turn off interrupts
     6CEA 0000 
0259 6CEC 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6CEE 8300 
0260 6CF0 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6CF2 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6CF4 0202  20 runli2  li    r2,>8308
     6CF6 8308 
0265 6CF8 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6CFA 0282  22         ci    r2,>8400
     6CFC 8400 
0267 6CFE 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6D00 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6D02 FFFF 
0273 6D04 1602  14         jne   runli4                ; No, continue
0274 6D06 0420  54         blwp  @0                    ; Yes, bye bye
     6D08 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6D0A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6D0C 833C 
0279 6D0E 04C1  14         clr   r1                    ; Reset counter
0280 6D10 0202  20         li    r2,10                 ; We test 10 times
     6D12 000A 
0281 6D14 C0E0  34 runli5  mov   @vdps,r3
     6D16 8802 
0282 6D18 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6D1A 6046 
0283 6D1C 1302  14         jeq   runli6
0284 6D1E 0581  14         inc   r1                    ; Increase counter
0285 6D20 10F9  14         jmp   runli5
0286 6D22 0602  14 runli6  dec   r2                    ; Next test
0287 6D24 16F7  14         jne   runli5
0288 6D26 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6D28 1250 
0289 6D2A 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6D2C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6D2E 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6D30 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6D32 6218 
0295 6D34 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6D36 8322 
0296 6D38 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6D3A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6D3C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6D3E 04C1  14 runli9  clr   r1
0303 6D40 04C2  14         clr   r2
0304 6D42 04C3  14         clr   r3
0305 6D44 0209  20         li    stack,>8400           ; Set stack
     6D46 8400 
0306 6D48 020F  20         li    r15,vdpw              ; Set VDP write address
     6D4A 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6D4C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6D4E 4A4A 
0315 6D50 1605  14         jne   runlia
0316 6D52 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6D54 6286 
0317 6D56 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6D58 0000 
     6D5A 3FFF 
0322 6D5C 06A0  32 runlia  bl    @filv
     6D5E 6286 
0323 6D60 0FC0             data  pctadr,spfclr,16      ; Load color table
     6D62 00F4 
     6D64 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6D66 06A0  32         bl    @f18unl               ; Unlock the F18A
     6D68 6682 
0331 6D6A 06A0  32         bl    @f18chk               ; Check if F18A is there
     6D6C 669C 
0332 6D6E 06A0  32         bl    @f18lck               ; Lock the F18A again
     6D70 6692 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6D72 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6D74 62F0 
0346 6D76 620E             data  spvmod                ; Equate selected video mode table
0347 6D78 0204  20         li    tmp0,spfont           ; Get font option
     6D7A 000C 
0348 6D7C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6D7E 1304  14         jeq   runlid                ; Yes, skip it
0350 6D80 06A0  32         bl    @ldfnt
     6D82 6358 
0351 6D84 1100             data  fntadr,spfont         ; Load specified font
     6D86 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6D88 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6D8A 4A4A 
0356 6D8C 1602  14         jne   runlie                ; No, continue
0357 6D8E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6D90 60AC 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6D92 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6D94 0040 
0362 6D96 0460  28         b     @main                 ; Give control to main program
     6D98 6D9A 
**** **** ****     > tivi.asm.3217
0228               
0229               *--------------------------------------------------------------
0230               * Video mode configuration
0231               *--------------------------------------------------------------
0232      620E     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0233      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0234      0050     colrow  equ   80                    ; Columns per row
0235      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0236      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0237      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0238      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0239               
0240               
0241               
0242               
0243               
0244               ***************************************************************
0245               *                     TiVi support modules
0246               ***************************************************************
0247                       copy  "editor.asm"          ; Main editor
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
0031 6D9A 20A0  38         coc   @wbit1,config         ; F18a detected?
     6D9C 6044 
0032 6D9E 1302  14         jeq   main.continue
0033 6DA0 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6DA2 0000 
0034               
0035               main.continue:
0036 6DA4 06A0  32         bl    @scroff               ; Turn screen off
     6DA6 65DE 
0037 6DA8 06A0  32         bl    @f18unl               ; Unlock the F18a
     6DAA 6682 
0038 6DAC 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6DAE 632A 
0039 6DB0 3140                   data >3140            ; F18a VR49 (>31), bit 40
0040                       ;------------------------------------------------------
0041                       ; Initialize VDP SIT
0042                       ;------------------------------------------------------
0043 6DB2 06A0  32         bl    @filv
     6DB4 6286 
0044 6DB6 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6DB8 0020 
     6DBA 09B0 
0045 6DBC 06A0  32         bl    @scron                ; Turn screen on
     6DBE 65E6 
0046                       ;------------------------------------------------------
0047                       ; Initialize low + high memory expansion
0048                       ;------------------------------------------------------
0049 6DC0 06A0  32         bl    @film
     6DC2 622E 
0050 6DC4 2200                   data >2200,00,8*1024-256*2
     6DC6 0000 
     6DC8 3E00 
0051                                                   ; Clear part of 8k low-memory
0052               
0053 6DCA 06A0  32         bl    @film
     6DCC 622E 
0054 6DCE A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6DD0 0000 
     6DD2 6000 
0055                       ;------------------------------------------------------
0056                       ; Load SAMS default memory layout
0057                       ;------------------------------------------------------
0058 6DD4 06A0  32         bl    @mem.setup.sams.layout
     6DD6 73CC 
0059                                                   ; Initialize SAMS layout
0060                       ;------------------------------------------------------
0061                       ; Setup cursor, screen, etc.
0062                       ;------------------------------------------------------
0063 6DD8 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6DDA 65FE 
0064 6DDC 06A0  32         bl    @s8x8                 ; Small sprite
     6DDE 660E 
0065               
0066 6DE0 06A0  32         bl    @cpym2m
     6DE2 6478 
0067 6DE4 7CEA                   data romsat,ramsat,4  ; Load sprite SAT
     6DE6 8380 
     6DE8 0004 
0068               
0069 6DEA C820  54         mov   @romsat+2,@fb.curshape
     6DEC 7CEC 
     6DEE 2210 
0070                                                   ; Save cursor shape & color
0071               
0072 6DF0 06A0  32         bl    @cpym2v
     6DF2 6430 
0073 6DF4 1800                   data sprpdt,cursors,3*8
     6DF6 7CEE 
     6DF8 0018 
0074                                                   ; Load sprite cursor patterns
0075               
0076               
0077 6DFA 06A0  32         bl    @cpym2v
     6DFC 6430 
0078 6DFE 1008                   data >1008,line,8     ; Load line pattern
     6E00 7D06 
     6E02 0008 
0079               
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 6E04 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E06 761E 
0084 6E08 06A0  32         bl    @idx.init             ; Initialize index
     6E0A 7546 
0085 6E0C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E0E 742E 
0086                       ;-------------------------------------------------------
0087                       ; Setup editor tasks & hook
0088                       ;-------------------------------------------------------
0089 6E10 0204  20         li    tmp0,>0200
     6E12 0200 
0090 6E14 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6E16 8314 
0091               
0092 6E18 06A0  32         bl    @at
     6E1A 661E 
0093 6E1C 0000             data  >0000                 ; Cursor YX position = >0000
0094               
0095 6E1E 0204  20         li    tmp0,timers
     6E20 8370 
0096 6E22 C804  38         mov   tmp0,@wtitab
     6E24 832C 
0097               
0098 6E26 06A0  32         bl    @mkslot
     6E28 6CB4 
0099 6E2A 0001                   data >0001,task0      ; Task 0 - Update screen
     6E2C 7B44 
0100 6E2E 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6E30 7BC8 
0101 6E32 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6E34 7BD6 
     6E36 FFFF 
0102               
0103 6E38 06A0  32         bl    @mkhook
     6E3A 6CA0 
0104 6E3C 7B14                   data editor           ; Setup user hook
0105               
0106 6E3E 0460  28         b     @tmgr                 ; Start timers and kthread
     6E40 6BF6 
0107               
0108               
**** **** ****     > tivi.asm.3217
0248                       copy  "editorkeys.asm"      ; Actions initalisation
**** **** ****     > editorkeys.asm
0001               * FILE......: editorkeys.asm
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
0048      C400     key_fbup        equ >c400                    ; fctn + n
0049      C600     key_fbdown      equ >c600                    ; fctn + b
0050               
0051               
0052               *---------------------------------------------------------------
0053               * Action keys mapping <-> actions table
0054               *---------------------------------------------------------------
0055               keymap_actions
0056                       ;-------------------------------------------------------
0057                       ; Movement keys
0058                       ;-------------------------------------------------------
0059 6E42 0D00             data  key_enter,edkey.action.enter          ; New line
     6E44 72AE 
0060 6E46 0800             data  key_left,edkey.action.left            ; Move cursor left
     6E48 6EE2 
0061 6E4A 0900             data  key_right,edkey.action.right          ; Move cursor right
     6E4C 6EF8 
0062 6E4E 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6E50 6F10 
0063 6E52 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6E54 6F62 
0064 6E56 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6E58 6FCE 
0065 6E5A 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6E5C 6FE6 
0066 6E5E 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6E60 6FFA 
0067 6E62 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6E64 704C 
0068 6E66 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6E68 70AC 
0069 6E6A 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6E6C 70F6 
0070 6E6E 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6E70 7122 
0071                       ;-------------------------------------------------------
0072                       ; Modifier keys - Delete
0073                       ;-------------------------------------------------------
0074 6E72 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6E74 7150 
0075 6E76 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6E78 7188 
0076 6E7A 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6E7C 71BC 
0077                       ;-------------------------------------------------------
0078                       ; Modifier keys - Insert
0079                       ;-------------------------------------------------------
0080 6E7E 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6E80 7214 
0081 6E82 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6E84 731C 
0082 6E86 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6E88 726A 
0083                       ;-------------------------------------------------------
0084                       ; Other action keys
0085                       ;-------------------------------------------------------
0086 6E8A 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6E8C 736C 
0087 6E8E C400             data  key_fbup,edkey.action.fbup            ; Framebuffer 1 row up
     6E90 7374 
0088 6E92 C400             data  key_fbup,edkey.action.fbdown          ; Framebuffer 1 row down
     6E94 737E 
0089                       ;-------------------------------------------------------
0090                       ; Editor/File buffer keys
0091                       ;-------------------------------------------------------
0092 6E96 B000             data  key_buf0,edkey.action.buffer0
     6E98 7388 
0093 6E9A B100             data  key_buf1,edkey.action.buffer1
     6E9C 738E 
0094 6E9E B200             data  key_buf2,edkey.action.buffer2
     6EA0 7394 
0095 6EA2 B300             data  key_buf3,edkey.action.buffer3
     6EA4 739A 
0096 6EA6 B400             data  key_buf4,edkey.action.buffer4
     6EA8 73A0 
0097 6EAA B500             data  key_buf5,edkey.action.buffer5
     6EAC 73A6 
0098 6EAE B600             data  key_buf6,edkey.action.buffer6
     6EB0 73AC 
0099 6EB2 B700             data  key_buf7,edkey.action.buffer7
     6EB4 73B2 
0100 6EB6 9E00             data  key_buf8,edkey.action.buffer8
     6EB8 73B8 
0101 6EBA 9F00             data  key_buf9,edkey.action.buffer9
     6EBC 73BE 
0102 6EBE FFFF             data  >ffff                                 ; EOL
0103               
0104               
0105               
0106               ****************************************************************
0107               * Editor - Process key
0108               ****************************************************************
0109 6EC0 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6EC2 833C 
0110 6EC4 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6EC6 FF00 
0111               
0112 6EC8 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6ECA 6E42 
0113 6ECC 0707  14         seto  tmp3                  ; EOL marker
0114                       ;-------------------------------------------------------
0115                       ; Iterate over keyboard map for matching key
0116                       ;-------------------------------------------------------
0117               edkey.check_next_key:
0118 6ECE 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0119 6ED0 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0120               
0121 6ED2 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0122 6ED4 1302  14         jeq   edkey.do_action       ; Yes, do action
0123 6ED6 05C6  14         inct  tmp2                  ; No, skip action
0124 6ED8 10FA  14         jmp   edkey.check_next_key  ; Next key
0125               
0126               edkey.do_action:
0127 6EDA C196  26         mov  *tmp2,tmp2             ; Get action address
0128 6EDC 0456  20         b    *tmp2                  ; Process key action
0129               edkey.do_action.set:
0130 6EDE 0460  28         b    @edkey.action.char     ; Add character to buffer
     6EE0 732C 
**** **** ****     > tivi.asm.3217
0249                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6EE2 C120  34         mov   @fb.column,tmp0
     6EE4 220C 
0010 6EE6 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6EE8 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6EEA 220C 
0015 6EEC 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6EEE 832A 
0016 6EF0 0620  34         dec   @fb.current
     6EF2 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6EF4 0460  28 !       b     @ed_wait              ; Back to editor main
     6EF6 7B38 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6EF8 8820  54         c     @fb.column,@fb.row.length
     6EFA 220C 
     6EFC 2208 
0028 6EFE 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6F00 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6F02 220C 
0033 6F04 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6F06 832A 
0034 6F08 05A0  34         inc   @fb.current
     6F0A 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6F0C 0460  28 !       b     @ed_wait              ; Back to editor main
     6F0E 7B38 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6F10 8820  54         c     @fb.row.dirty,@w$ffff
     6F12 220A 
     6F14 6048 
0049 6F16 1604  14         jne   edkey.action.up.cursor
0050 6F18 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F1A 7646 
0051 6F1C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F1E 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6F20 C120  34         mov   @fb.row,tmp0
     6F22 2206 
0057 6F24 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6F26 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6F28 2204 
0060 6F2A 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6F2C 0604  14         dec   tmp0                  ; fb.topline--
0066 6F2E C804  38         mov   tmp0,@parm1
     6F30 8350 
0067 6F32 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F34 7498 
0068 6F36 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6F38 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F3A 2206 
0074 6F3C 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F3E 662C 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6F40 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F42 77C0 
0080 6F44 8820  54         c     @fb.column,@fb.row.length
     6F46 220C 
     6F48 2208 
0081 6F4A 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6F4C C820  54         mov   @fb.row.length,@fb.column
     6F4E 2208 
     6F50 220C 
0086 6F52 C120  34         mov   @fb.column,tmp0
     6F54 220C 
0087 6F56 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F58 6636 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6F5A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F5C 747C 
0093 6F5E 0460  28         b     @ed_wait              ; Back to editor main
     6F60 7B38 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6F62 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6F64 2206 
     6F66 2304 
0102 6F68 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6F6A 8820  54         c     @fb.row.dirty,@w$ffff
     6F6C 220A 
     6F6E 6048 
0107 6F70 1604  14         jne   edkey.action.down.move
0108 6F72 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F74 7646 
0109 6F76 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F78 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6F7A C120  34         mov   @fb.topline,tmp0
     6F7C 2204 
0118 6F7E A120  34         a     @fb.row,tmp0
     6F80 2206 
0119 6F82 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6F84 2304 
0120 6F86 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6F88 C120  34         mov   @fb.screenrows,tmp0
     6F8A 2218 
0126 6F8C 0604  14         dec   tmp0
0127 6F8E 8120  34         c     @fb.row,tmp0
     6F90 2206 
0128 6F92 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6F94 C820  54         mov   @fb.topline,@parm1
     6F96 2204 
     6F98 8350 
0133 6F9A 05A0  34         inc   @parm1
     6F9C 8350 
0134 6F9E 06A0  32         bl    @fb.refresh
     6FA0 7498 
0135 6FA2 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6FA4 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6FA6 2206 
0141 6FA8 06A0  32         bl    @down                 ; Row++ VDP cursor
     6FAA 6624 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6FAC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6FAE 77C0 
0147               
0148 6FB0 8820  54         c     @fb.column,@fb.row.length
     6FB2 220C 
     6FB4 2208 
0149 6FB6 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 6FB8 C820  54         mov   @fb.row.length,@fb.column
     6FBA 2208 
     6FBC 220C 
0155 6FBE C120  34         mov   @fb.column,tmp0
     6FC0 220C 
0156 6FC2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FC4 6636 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6FC6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FC8 747C 
0162 6FCA 0460  28 !       b     @ed_wait              ; Back to editor main
     6FCC 7B38 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 6FCE C120  34         mov   @wyx,tmp0
     6FD0 832A 
0171 6FD2 0244  22         andi  tmp0,>ff00
     6FD4 FF00 
0172 6FD6 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6FD8 832A 
0173 6FDA 04E0  34         clr   @fb.column
     6FDC 220C 
0174 6FDE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FE0 747C 
0175 6FE2 0460  28         b     @ed_wait              ; Back to editor main
     6FE4 7B38 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 6FE6 C120  34         mov   @fb.row.length,tmp0
     6FE8 2208 
0182 6FEA C804  38         mov   tmp0,@fb.column
     6FEC 220C 
0183 6FEE 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6FF0 6636 
0184 6FF2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FF4 747C 
0185 6FF6 0460  28         b     @ed_wait              ; Back to editor main
     6FF8 7B38 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 6FFA C120  34         mov   @fb.column,tmp0
     6FFC 220C 
0194 6FFE 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 7000 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7002 2202 
0199 7004 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 7006 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 7008 0605  14         dec   tmp1
0206 700A 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 700C 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 700E D195  26         movb  *tmp1,tmp2            ; Get character
0214 7010 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 7012 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 7014 0986  56         srl   tmp2,8                ; Right justify
0217 7016 0286  22         ci    tmp2,32               ; Space character found?
     7018 0020 
0218 701A 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 701C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     701E 2020 
0224 7020 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 7022 0287  22         ci    tmp3,>20ff            ; First character is space
     7024 20FF 
0227 7026 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 7028 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     702A 220C 
0232 702C 61C4  18         s     tmp0,tmp3
0233 702E 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7030 0002 
0234 7032 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 7034 0585  14         inc   tmp1
0240 7036 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 7038 C805  38         mov   tmp1,@fb.current
     703A 2202 
0246 703C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     703E 220C 
0247 7040 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7042 6636 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 7044 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7046 747C 
0253 7048 0460  28 !       b     @ed_wait              ; Back to editor main
     704A 7B38 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 704C 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 704E C120  34         mov   @fb.column,tmp0
     7050 220C 
0263 7052 8804  38         c     tmp0,@fb.row.length
     7054 2208 
0264 7056 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 7058 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     705A 2202 
0269 705C 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 705E 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 7060 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 7062 0585  14         inc   tmp1
0281 7064 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 7066 8804  38         c     tmp0,@fb.row.length
     7068 2208 
0283 706A 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 706C D195  26         movb  *tmp1,tmp2            ; Get character
0290 706E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 7070 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 7072 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 7074 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7076 FFFF 
0295 7078 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 707A 0286  22         ci    tmp2,32
     707C 0020 
0301 707E 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 7080 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 7082 0286  22         ci    tmp2,32               ; Space character found?
     7084 0020 
0309 7086 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 7088 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     708A 2020 
0315 708C 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 708E 0287  22         ci    tmp3,>20ff            ; First characer is space?
     7090 20FF 
0318 7092 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 7094 0585  14         inc   tmp1
0323 7096 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 7098 C805  38         mov   tmp1,@fb.current
     709A 2202 
0329 709C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     709E 220C 
0330 70A0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70A2 6636 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 70A4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70A6 747C 
0336 70A8 0460  28 !       b     @ed_wait              ; Back to editor main
     70AA 7B38 
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
0348 70AC C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     70AE 2204 
0349 70B0 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 70B2 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     70B4 2218 
0354 70B6 1503  14         jgt   edkey.action.ppage.topline
0355 70B8 04E0  34         clr   @fb.topline           ; topline = 0
     70BA 2204 
0356 70BC 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 70BE 6820  54         s     @fb.screenrows,@fb.topline
     70C0 2218 
     70C2 2204 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 70C4 8820  54         c     @fb.row.dirty,@w$ffff
     70C6 220A 
     70C8 6048 
0367 70CA 1604  14         jne   edkey.action.ppage.refresh
0368 70CC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70CE 7646 
0369 70D0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70D2 220A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 70D4 C820  54         mov   @fb.topline,@parm1
     70D6 2204 
     70D8 8350 
0375 70DA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     70DC 7498 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 70DE 04E0  34         clr   @fb.row
     70E0 2206 
0381 70E2 05A0  34         inc   @fb.row               ; Set fb.row=1
     70E4 2206 
0382 70E6 04E0  34         clr   @fb.column
     70E8 220C 
0383 70EA 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     70EC 0100 
0384 70EE C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     70F0 832A 
0385 70F2 0460  28         b     @edkey.action.up      ; Do rest of logic
     70F4 6F10 
0386               
0387               
0388               
0389               *---------------------------------------------------------------
0390               * Next page
0391               *---------------------------------------------------------------
0392               edkey.action.npage:
0393                       ;-------------------------------------------------------
0394                       ; Sanity check
0395                       ;-------------------------------------------------------
0396 70F6 C120  34         mov   @fb.topline,tmp0
     70F8 2204 
0397 70FA A120  34         a     @fb.screenrows,tmp0
     70FC 2218 
0398 70FE 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7100 2304 
0399 7102 150D  14         jgt   edkey.action.npage.exit
0400                       ;-------------------------------------------------------
0401                       ; Adjust topline
0402                       ;-------------------------------------------------------
0403               edkey.action.npage.topline:
0404 7104 A820  54         a     @fb.screenrows,@fb.topline
     7106 2218 
     7108 2204 
0405                       ;-------------------------------------------------------
0406                       ; Crunch current row if dirty
0407                       ;-------------------------------------------------------
0408               edkey.action.npage.crunch:
0409 710A 8820  54         c     @fb.row.dirty,@w$ffff
     710C 220A 
     710E 6048 
0410 7110 1604  14         jne   edkey.action.npage.refresh
0411 7112 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7114 7646 
0412 7116 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7118 220A 
0413                       ;-------------------------------------------------------
0414                       ; Refresh page
0415                       ;-------------------------------------------------------
0416               edkey.action.npage.refresh:
0417 711A 0460  28         b     @edkey.action.ppage.refresh
     711C 70D4 
0418                                                   ; Same logic as previous page
0419                       ;-------------------------------------------------------
0420                       ; Exit
0421                       ;-------------------------------------------------------
0422               edkey.action.npage.exit:
0423 711E 0460  28         b     @ed_wait              ; Back to editor main
     7120 7B38 
0424               
0425               
0426               
0427               
0428               *---------------------------------------------------------------
0429               * Goto top of file
0430               *---------------------------------------------------------------
0431               edkey.action.top:
0432                       ;-------------------------------------------------------
0433                       ; Crunch current row if dirty
0434                       ;-------------------------------------------------------
0435 7122 8820  54         c     @fb.row.dirty,@w$ffff
     7124 220A 
     7126 6048 
0436 7128 1604  14         jne   edkey.action.top.refresh
0437 712A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     712C 7646 
0438 712E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7130 220A 
0439                       ;-------------------------------------------------------
0440                       ; Refresh page
0441                       ;-------------------------------------------------------
0442               edkey.action.top.refresh:
0443 7132 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     7134 2204 
0444 7136 04E0  34         clr   @parm1
     7138 8350 
0445 713A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     713C 7498 
0446                       ;-------------------------------------------------------
0447                       ; Exit
0448                       ;-------------------------------------------------------
0449               edkey.action.top.exit:
0450 713E 04E0  34         clr   @fb.row               ; Editor line 0
     7140 2206 
0451 7142 04E0  34         clr   @fb.column            ; Editor column 0
     7144 220C 
0452 7146 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0453 7148 C804  38         mov   tmp0,@wyx             ;
     714A 832A 
0454 714C 0460  28         b     @ed_wait              ; Back to editor main
     714E 7B38 
**** **** ****     > tivi.asm.3217
0250                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 7150 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7152 2306 
0010 7154 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7156 747C 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 7158 C120  34         mov   @fb.current,tmp0      ; Get pointer
     715A 2202 
0015 715C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     715E 2208 
0016 7160 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7162 8820  54         c     @fb.column,@fb.row.length
     7164 220C 
     7166 2208 
0022 7168 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 716A C120  34         mov   @fb.current,tmp0      ; Get pointer
     716C 2202 
0028 716E C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 7170 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7172 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7174 0606  14         dec   tmp2
0036 7176 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 7178 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     717A 220A 
0041 717C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     717E 2216 
0042 7180 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7182 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7184 0460  28         b     @ed_wait              ; Back to editor main
     7186 7B38 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 7188 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     718A 2306 
0055 718C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     718E 747C 
0056 7190 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7192 2208 
0057 7194 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 7196 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7198 2202 
0063 719A C1A0  34         mov   @fb.colsline,tmp2
     719C 220E 
0064 719E 61A0  34         s     @fb.column,tmp2
     71A0 220C 
0065 71A2 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 71A4 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 71A6 0606  14         dec   tmp2
0072 71A8 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 71AA 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     71AC 220A 
0077 71AE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71B0 2216 
0078               
0079 71B2 C820  54         mov   @fb.column,@fb.row.length
     71B4 220C 
     71B6 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 71B8 0460  28         b     @ed_wait              ; Back to editor main
     71BA 7B38 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 71BC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71BE 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 71C0 C120  34         mov   @edb.lines,tmp0
     71C2 2304 
0097 71C4 1604  14         jne   !
0098 71C6 04E0  34         clr   @fb.column            ; Column 0
     71C8 220C 
0099 71CA 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     71CC 7188 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 71CE 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71D0 747C 
0104 71D2 04E0  34         clr   @fb.row.dirty         ; Discard current line
     71D4 220A 
0105 71D6 C820  54         mov   @fb.topline,@parm1
     71D8 2204 
     71DA 8350 
0106 71DC A820  54         a     @fb.row,@parm1        ; Line number to remove
     71DE 2206 
     71E0 8350 
0107 71E2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71E4 2304 
     71E6 8352 
0108 71E8 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     71EA 7588 
0109 71EC 0620  34         dec   @edb.lines            ; One line less in editor buffer
     71EE 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 71F0 C820  54         mov   @fb.topline,@parm1
     71F2 2204 
     71F4 8350 
0114 71F6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71F8 7498 
0115 71FA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71FC 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 71FE C120  34         mov   @fb.topline,tmp0
     7200 2204 
0120 7202 A120  34         a     @fb.row,tmp0
     7204 2206 
0121 7206 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7208 2304 
0122 720A 1202  14         jle   edkey.action.del_line.exit
0123 720C 0460  28         b     @edkey.action.up      ; One line up
     720E 6F10 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 7210 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7212 6FCE 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 7214 0204  20         li    tmp0,>2000            ; White space
     7216 2000 
0139 7218 C804  38         mov   tmp0,@parm1
     721A 8350 
0140               edkey.action.ins_char:
0141 721C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     721E 2306 
0142 7220 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7222 747C 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 7224 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7226 2202 
0147 7228 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     722A 2208 
0148 722C 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 722E 8820  54         c     @fb.column,@fb.row.length
     7230 220C 
     7232 2208 
0154 7234 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 7236 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 7238 61E0  34         s     @fb.column,tmp3
     723A 220C 
0162 723C A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 723E C144  18         mov   tmp0,tmp1
0164 7240 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7242 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7244 220C 
0166 7246 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 7248 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 724A 0604  14         dec   tmp0
0173 724C 0605  14         dec   tmp1
0174 724E 0606  14         dec   tmp2
0175 7250 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 7252 D560  46         movb  @parm1,*tmp1
     7254 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 7256 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7258 220A 
0184 725A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     725C 2216 
0185 725E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7260 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7262 0460  28         b     @edkey.action.char.overwrite
     7264 733E 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 7266 0460  28         b     @ed_wait              ; Back to editor main
     7268 7B38 
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
0206 726A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     726C 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 726E 8820  54         c     @fb.row.dirty,@w$ffff
     7270 220A 
     7272 6048 
0211 7274 1604  14         jne   edkey.action.ins_line.insert
0212 7276 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7278 7646 
0213 727A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     727C 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 727E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7280 747C 
0219 7282 C820  54         mov   @fb.topline,@parm1
     7284 2204 
     7286 8350 
0220 7288 A820  54         a     @fb.row,@parm1        ; Line number to insert
     728A 2206 
     728C 8350 
0221               
0222 728E C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7290 2304 
     7292 8352 
0223 7294 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7296 75BC 
0224 7298 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     729A 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 729C C820  54         mov   @fb.topline,@parm1
     729E 2204 
     72A0 8350 
0229 72A2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     72A4 7498 
0230 72A6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72A8 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 72AA 0460  28         b     @ed_wait              ; Back to editor main
     72AC 7B38 
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
0249 72AE 8820  54         c     @fb.row.dirty,@w$ffff
     72B0 220A 
     72B2 6048 
0250 72B4 1606  14         jne   edkey.action.enter.upd_counter
0251 72B6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72B8 2306 
0252 72BA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72BC 7646 
0253 72BE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72C0 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 72C2 C120  34         mov   @fb.topline,tmp0
     72C4 2204 
0259 72C6 A120  34         a     @fb.row,tmp0
     72C8 2206 
0260 72CA 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     72CC 2304 
0261 72CE 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 72D0 05A0  34         inc   @edb.lines            ; Total lines++
     72D2 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 72D4 C120  34         mov   @fb.screenrows,tmp0
     72D6 2218 
0271 72D8 0604  14         dec   tmp0
0272 72DA 8120  34         c     @fb.row,tmp0
     72DC 2206 
0273 72DE 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 72E0 C120  34         mov   @fb.screenrows,tmp0
     72E2 2218 
0278 72E4 C820  54         mov   @fb.topline,@parm1
     72E6 2204 
     72E8 8350 
0279 72EA 05A0  34         inc   @parm1
     72EC 8350 
0280 72EE 06A0  32         bl    @fb.refresh
     72F0 7498 
0281 72F2 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 72F4 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     72F6 2206 
0287 72F8 06A0  32         bl    @down                 ; Row++ VDP cursor
     72FA 6624 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 72FC 06A0  32         bl    @fb.get.firstnonblank
     72FE 74FE 
0293 7300 C120  34         mov   @outparm1,tmp0
     7302 8360 
0294 7304 C804  38         mov   tmp0,@fb.column
     7306 220C 
0295 7308 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     730A 6636 
0296 730C 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     730E 77C0 
0297 7310 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7312 747C 
0298 7314 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7316 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 7318 0460  28         b     @ed_wait              ; Back to editor main
     731A 7B38 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 731C 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     731E 230A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7320 0204  20         li    tmp0,2000
     7322 07D0 
0317               edkey.action.ins_onoff.loop:
0318 7324 0604  14         dec   tmp0
0319 7326 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 7328 0460  28         b     @task2.cur_visible    ; Update cursor shape
     732A 7BE2 
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
0335 732C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     732E 2306 
0336 7330 D805  38         movb  tmp1,@parm1           ; Store character for insert
     7332 8350 
0337 7334 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7336 230A 
0338 7338 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 733A 0460  28         b     @edkey.action.ins_char
     733C 721C 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 733E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7340 747C 
0349 7342 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7344 2202 
0350               
0351 7346 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7348 8350 
0352 734A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     734C 220A 
0353 734E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7350 2216 
0354               
0355 7352 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7354 220C 
0356 7356 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7358 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 735A 8820  54         c     @fb.column,@fb.row.length
     735C 220C 
     735E 2208 
0361 7360 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7362 C820  54         mov   @fb.column,@fb.row.length
     7364 220C 
     7366 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 7368 0460  28         b     @ed_wait              ; Back to editor main
     736A 7B38 
**** **** ****     > tivi.asm.3217
0251                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 736C 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     736E 66E6 
0010 7370 0420  54         blwp  @0                    ; Exit
     7372 0000 
0011               
0012               
0013               
0014               *---------------------------------------------------------------
0015               * Framebuffer up 1 row
0016               *---------------------------------------------------------------
0017               edkey.action.fbup:
0018 7374 0620  34         dec   @fb.screenrows
     7376 2218 
0019 7378 0720  34         seto  @fb.dirty
     737A 2216 
0020 737C 069B  24         bl    *r11
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Framebuffer down 1 row
0025               *---------------------------------------------------------------
0026               edkey.action.fbdown:
0027 737E 05A0  34         inc   @fb.screenrows
     7380 2218 
0028 7382 0720  34         seto  @fb.dirty
     7384 2216 
0029 7386 069B  24         bl    *r11
**** **** ****     > tivi.asm.3217
0252                       copy  "editorkeys_file.asm" ; Actions for file related keys
**** **** ****     > editorkeys_file.asm
0001               * FILE......: editorkeys_fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               edkey.action.buffer0:
0006 7388 0204  20         li   tmp0,fdname0
     738A 7D60 
0007 738C 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 738E 0204  20         li   tmp0,fdname1
     7390 7D6E 
0010 7392 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 7394 0204  20         li   tmp0,fdname2
     7396 7D7E 
0013 7398 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 739A 0204  20         li   tmp0,fdname3
     739C 7D8C 
0016 739E 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 73A0 0204  20         li   tmp0,fdname4
     73A2 7D9A 
0019 73A4 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 73A6 0204  20         li   tmp0,fdname5
     73A8 7DA8 
0022 73AA 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 73AC 0204  20         li   tmp0,fdname6
     73AE 7DB6 
0025 73B0 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 73B2 0204  20         li   tmp0,fdname7
     73B4 7DC4 
0028 73B6 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 73B8 0204  20         li   tmp0,fdname8
     73BA 7DD2 
0031 73BC 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 73BE 0204  20         li   tmp0,fdname9
     73C0 7DE0 
0034 73C2 1000  14         jmp  edkey.action.rest
0035               edkey.action.rest:
0036 73C4 06A0  32         bl   @fm.loadfile           ; Load DIS/VAR 80 file into editor buffer
     73C6 79EE 
0037 73C8 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     73CA 7122 
**** **** ****     > tivi.asm.3217
0253                       copy  "memory.asm"          ; mem - Memory Management module
**** **** ****     > memory.asm
0001               * FILE......: memory.asm
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
0021 73CC 0649  14         dect  stack
0022 73CE C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 73D0 06A0  32         bl    @sams.layout
     73D2 657A 
0027 73D4 73DA                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 73D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0033 73D8 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 73DA 2000             data  >2000,>0000           ; >2000-2fff, SAMS page >00
     73DC 0000 
0039 73DE 3000             data  >3000,>0001           ; >3000-3fff, SAMS page >01
     73E0 0001 
0040 73E2 A000             data  >a000,>0002           ; >a000-afff, SAMS page >02
     73E4 0002 
0041 73E6 B000             data  >b000,>0003           ; >b000-bfff, SAMS page >03
     73E8 0003 
0042 73EA C000             data  >c000,>0004           ; >c000-cfff, SAMS page >04
     73EC 0004 
0043 73EE D000             data  >d000,>0005           ; >d000-dfff, SAMS page >05
     73F0 0005 
0044 73F2 E000             data  >e000,>0006           ; >e000-efff, SAMS page >06
     73F4 0006 
0045 73F6 F000             data  >f000,>0007           ; >f000-ffff, SAMS page >07
     73F8 0007 
0046               
0047               
0048               
0049               ***************************************************************
0050               * mem.edb.sams.pagein
0051               * Activate editor buffer SAMS page for line
0052               ***************************************************************
0053               * bl  @mem.edb.sams.pagein
0054               *     data p0
0055               *--------------------------------------------------------------
0056               * p0 = Line number in editor buffer
0057               *--------------------------------------------------------------
0058               * bl  @xmem.edb.sams.pagein
0059               *
0060               * tmp0 = Line number in editor buffer
0061               *--------------------------------------------------------------
0062               * OUTPUT
0063               * outparm1 = Pointer to line in editor buffer
0064               * outparm2 = SAMS page
0065               *--------------------------------------------------------------
0066               * Register usage
0067               * tmp0, tmp1
0068               ***************************************************************
0069               mem.edb.sams.pagein:
0070 73FA C13B  30         mov   *r11+,tmp0            ; Get p0
0071               xmem.edb.sams.pagein:
0072 73FC 0649  14         dect  stack
0073 73FE C64B  30         mov   r11,*stack            ; Save return address
0074 7400 0649  14         dect  stack
0075 7402 C644  30         mov   tmp0,*stack           ; Save tmp0
0076 7404 0649  14         dect  stack
0077 7406 C645  30         mov   tmp1,*stack           ; Save tmp1
0078                       ;------------------------------------------------------
0079                       ; Sanity check
0080                       ;------------------------------------------------------
0081 7408 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     740A 2304 
0082 740C 1104  14         jlt   mem.edb.sams.pagein.lookup
0083                                                   ; All checks passed, continue
0084                                                   ;--------------------------
0085                                                   ; Sanity check failed
0086                                                   ;--------------------------
0087 740E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7410 FFCE 
0088 7412 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7414 604C 
0089                       ;------------------------------------------------------
0090                       ; Lookup SAMS page for line in parm1
0091                       ;------------------------------------------------------
0092               mem.edb.sams.pagein.lookup:
0093 7416 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7418 7600 
0094                                                   ; \ i  parm1    = Line number
0095                                                   ; | o  outparm1 = Pointer to line
0096                                                   ; / o  outparm2 = SAMS page
0097               
0098 741A C120  34         mov   @outparm2,tmp0        ; SAMS page
     741C 8362 
0099 741E C160  34         mov   @outparm1,tmp1        ; Memory address
     7420 8360 
0100                       ;------------------------------------------------------
0101                       ; Activate SAMS page where specified line is stored
0102                       ;------------------------------------------------------
0103 7422 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     7424 6514 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               mem.edb.sams.pagein.exit
0110 7426 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 7428 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 742A C2F9  30         mov   *stack+,r11           ; Pop r11
0113 742C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi.asm.3217
0254                       copy  "framebuffer.asm"     ; fb  - Framebuffer module
**** **** ****     > framebuffer.asm
0001               * FILE......: framebuffer.asm
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
0024 742E 0649  14         dect  stack
0025 7430 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7432 0204  20         li    tmp0,fb.top
     7434 2650 
0030 7436 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7438 2200 
0031 743A 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     743C 2204 
0032 743E 04E0  34         clr   @fb.row               ; Current row=0
     7440 2206 
0033 7442 04E0  34         clr   @fb.column            ; Current column=0
     7444 220C 
0034 7446 0204  20         li    tmp0,80
     7448 0050 
0035 744A C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     744C 220E 
0036 744E 0204  20         li    tmp0,28
     7450 001C 
0037 7452 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     7454 2218 
0038 7456 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7458 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 745A 06A0  32         bl    @film
     745C 622E 
0043 745E 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7460 0000 
     7462 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7464 0460  28         b     @poprt                ; Return to caller
     7466 622A 
0049               
0050               
0051               
0052               
0053               ***************************************************************
0054               * fb.row2line
0055               * Calculate line in editor buffer
0056               ***************************************************************
0057               * bl @fb.row2line
0058               *--------------------------------------------------------------
0059               * INPUT
0060               * @fb.topline = Top line in frame buffer
0061               * @parm1      = Row in frame buffer (offset 0..@fb.screenrows)
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * @outparm1 = Matching line in editor buffer
0065               *--------------------------------------------------------------
0066               * Register usage
0067               * tmp2,tmp3
0068               *--------------------------------------------------------------
0069               * Formula
0070               * outparm1 = @fb.topline + @parm1
0071               ********|*****|*********************|**************************
0072               fb.row2line:
0073 7468 0649  14         dect  stack
0074 746A C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 746C C120  34         mov   @parm1,tmp0
     746E 8350 
0079 7470 A120  34         a     @fb.topline,tmp0
     7472 2204 
0080 7474 C804  38         mov   tmp0,@outparm1
     7476 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 7478 0460  28         b    @poprt                 ; Return to caller
     747A 622A 
0086               
0087               
0088               
0089               
0090               ***************************************************************
0091               * fb.calc_pointer
0092               * Calculate pointer address in frame buffer
0093               ***************************************************************
0094               * bl @fb.calc_pointer
0095               *--------------------------------------------------------------
0096               * INPUT
0097               * @fb.top       = Address of top row in frame buffer
0098               * @fb.topline   = Top line in frame buffer
0099               * @fb.row       = Current row in frame buffer (offset 0..@fb.screenrows)
0100               * @fb.column    = Current column in frame buffer
0101               * @fb.colsline  = Columns per line in frame buffer
0102               *--------------------------------------------------------------
0103               * OUTPUT
0104               * @fb.current   = Updated pointer
0105               *--------------------------------------------------------------
0106               * Register usage
0107               * tmp2,tmp3
0108               *--------------------------------------------------------------
0109               * Formula
0110               * pointer = row * colsline + column + deref(@fb.top.ptr)
0111               ********|*****|*********************|**************************
0112               fb.calc_pointer:
0113 747C 0649  14         dect  stack
0114 747E C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7480 C1A0  34         mov   @fb.row,tmp2
     7482 2206 
0119 7484 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7486 220E 
0120 7488 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     748A 220C 
0121 748C A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     748E 2200 
0122 7490 C807  38         mov   tmp3,@fb.current
     7492 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7494 0460  28         b    @poprt                 ; Return to caller
     7496 622A 
0128               
0129               
0130               
0131               
0132               ***************************************************************
0133               * fb.refresh
0134               * Refresh frame buffer with editor buffer content
0135               ***************************************************************
0136               * bl @fb.refresh
0137               *--------------------------------------------------------------
0138               * INPUT
0139               * @parm1 = Line to start with (becomes @fb.topline)
0140               *--------------------------------------------------------------
0141               * OUTPUT
0142               * none
0143               *--------------------------------------------------------------
0144               * Register usage
0145               * tmp0,tmp1,tmp2
0146               ********|*****|*********************|**************************
0147               fb.refresh:
0148 7498 0649  14         dect  stack
0149 749A C64B  30         mov   r11,*stack            ; Push return address
0150 749C 0649  14         dect  stack
0151 749E C644  30         mov   tmp0,*stack           ; Push tmp0
0152 74A0 0649  14         dect  stack
0153 74A2 C645  30         mov   tmp1,*stack           ; Push tmp1
0154 74A4 0649  14         dect  stack
0155 74A6 C646  30         mov   tmp2,*stack           ; Push tmp2
0156                       ;------------------------------------------------------
0157                       ; Setup starting position in index
0158                       ;------------------------------------------------------
0159 74A8 C820  54         mov   @parm1,@fb.topline
     74AA 8350 
     74AC 2204 
0160 74AE 04E0  34         clr   @parm2                ; Target row in frame buffer
     74B0 8352 
0161                       ;------------------------------------------------------
0162                       ; Unpack line to frame buffer
0163                       ;------------------------------------------------------
0164               fb.refresh.unpack_line:
0165 74B2 06A0  32         bl    @edb.line.unpack      ; Unpack line
     74B4 76D6 
0166                                                   ; \ i  parm1 = Line to unpack
0167                                                   ; / i  parm2 = Target row in frame buffer
0168               
0169 74B6 05A0  34         inc   @parm1                ; Next line in editor buffer
     74B8 8350 
0170 74BA 05A0  34         inc   @parm2                ; Next row in frame buffer
     74BC 8352 
0171                       ;------------------------------------------------------
0172                       ; Last row in editor buffer reached ?
0173                       ;------------------------------------------------------
0174 74BE 8820  54         c     @parm1,@edb.lines
     74C0 8350 
     74C2 2304 
0175 74C4 1111  14         jlt   !                     ; no, do next check
0176               
0177                       ;------------------------------------------------------
0178                       ; Erase until end of frame buffer
0179                       ;------------------------------------------------------
0180 74C6 C120  34         mov   @parm2,tmp0           ; Current row
     74C8 8352 
0181 74CA C160  34         mov   @fb.screenrows,tmp1   ; Rows framebuffer
     74CC 2218 
0182 74CE 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0183 74D0 3960  72         mpy   @fb.colsline,tmp1     ; columns per row * tmp1 (Result in tmp2!)
     74D2 220E 
0184               
0185 74D4 3920  72         mpy   @fb.colsline,tmp0     ; Offset = columns per row * tmp0 (Result in tmp1!)
     74D6 220E 
0186 74D8 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     74DA 2200 
0187               
0188 74DC C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0189 74DE 0205  20         li    tmp1,32               ; Clear with space
     74E0 0020 
0190               
0191 74E2 06A0  32         bl    @xfilm                ; \ Fill memory
     74E4 6234 
0192                                                   ; | i  tmp0 = Memory start address
0193                                                   ; | i  tmp1 = Byte to fill
0194                                                   ; / i  tmp2 = Number of bytes to fill
0195 74E6 1004  14         jmp   fb.refresh.exit
0196                       ;------------------------------------------------------
0197                       ; Bottom row in frame buffer reached ?
0198                       ;------------------------------------------------------
0199 74E8 8820  54 !       c     @parm2,@fb.screenrows
     74EA 8352 
     74EC 2218 
0200 74EE 11E1  14         jlt   fb.refresh.unpack_line
0201                                                   ; No, unpack next line
0202                       ;------------------------------------------------------
0203                       ; Exit
0204                       ;------------------------------------------------------
0205               fb.refresh.exit:
0206 74F0 0720  34         seto  @fb.dirty             ; Refresh screen
     74F2 2216 
0207 74F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0208 74F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0209 74F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0210 74FA C2F9  30         mov   *stack+,r11           ; Pop r11
0211 74FC 045B  20         b     *r11                  ; Return to caller
0212               
0213               
0214               ***************************************************************
0215               * fb.get.firstnonblank
0216               * Get column of first non-blank character in specified line
0217               ***************************************************************
0218               * bl @fb.get.firstnonblank
0219               *--------------------------------------------------------------
0220               * OUTPUT
0221               * @outparm1 = Column containing first non-blank character
0222               * @outparm2 = Character
0223               ********|*****|*********************|**************************
0224               fb.get.firstnonblank:
0225 74FE 0649  14         dect  stack
0226 7500 C64B  30         mov   r11,*stack            ; Save return address
0227                       ;------------------------------------------------------
0228                       ; Prepare for scanning
0229                       ;------------------------------------------------------
0230 7502 04E0  34         clr   @fb.column
     7504 220C 
0231 7506 06A0  32         bl    @fb.calc_pointer
     7508 747C 
0232 750A 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     750C 77C0 
0233 750E C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7510 2208 
0234 7512 1313  14         jeq   fb.get.firstnonblank.nomatch
0235                                                   ; Exit if empty line
0236 7514 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7516 2202 
0237 7518 04C5  14         clr   tmp1
0238                       ;------------------------------------------------------
0239                       ; Scan line for non-blank character
0240                       ;------------------------------------------------------
0241               fb.get.firstnonblank.loop:
0242 751A D174  28         movb  *tmp0+,tmp1           ; Get character
0243 751C 130E  14         jeq   fb.get.firstnonblank.nomatch
0244                                                   ; Exit if empty line
0245 751E 0285  22         ci    tmp1,>2000            ; Whitespace?
     7520 2000 
0246 7522 1503  14         jgt   fb.get.firstnonblank.match
0247 7524 0606  14         dec   tmp2                  ; Counter--
0248 7526 16F9  14         jne   fb.get.firstnonblank.loop
0249 7528 1008  14         jmp   fb.get.firstnonblank.nomatch
0250                       ;------------------------------------------------------
0251                       ; Non-blank character found
0252                       ;------------------------------------------------------
0253               fb.get.firstnonblank.match:
0254 752A 6120  34         s     @fb.current,tmp0      ; Calculate column
     752C 2202 
0255 752E 0604  14         dec   tmp0
0256 7530 C804  38         mov   tmp0,@outparm1        ; Save column
     7532 8360 
0257 7534 D805  38         movb  tmp1,@outparm2        ; Save character
     7536 8362 
0258 7538 1004  14         jmp   fb.get.firstnonblank.exit
0259                       ;------------------------------------------------------
0260                       ; No non-blank character found
0261                       ;------------------------------------------------------
0262               fb.get.firstnonblank.nomatch:
0263 753A 04E0  34         clr   @outparm1             ; X=0
     753C 8360 
0264 753E 04E0  34         clr   @outparm2             ; Null
     7540 8362 
0265                       ;------------------------------------------------------
0266                       ; Exit
0267                       ;------------------------------------------------------
0268               fb.get.firstnonblank.exit:
0269 7542 0460  28         b    @poprt                 ; Return to caller
     7544 622A 
**** **** ****     > tivi.asm.3217
0255                       copy  "index.asm"           ; idx - Index management module
**** **** ****     > index.asm
0001               * FILE......: index.asm
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
0048 7546 0649  14         dect  stack
0049 7548 C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 754A 0204  20         li    tmp0,idx.top
     754C 3000 
0054 754E C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7550 2302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 7552 06A0  32         bl    @film
     7554 622E 
0059 7556 3000             data  idx.top,>00,idx.size  ; Clear main index
     7558 0000 
     755A 1000 
0060               
0061 755C 06A0  32         bl    @film
     755E 622E 
0062 7560 A000             data  idx.shadow.top,>00,idx.shadow.size
     7562 0000 
     7564 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 7566 0460  28         b     @poprt                ; Return to caller
     7568 622A 
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
0090 756A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     756C 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 756E C160  34         mov   @parm2,tmp1
     7570 8352 
0095 7572 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 7574 C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     7576 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 7578 0A14  56         sla   tmp0,1                ; line number * 2
0107 757A C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     757C 3000 
0108 757E C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     7580 A000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 7582 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7584 8360 
0115 7586 045B  20         b     *r11                  ; Return
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
0135 7588 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     758A 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 758C 0A14  56         sla   tmp0,1                ; line number * 2
0140 758E C824  54         mov   @idx.top(tmp0),@outparm1
     7590 3000 
     7592 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 7594 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7596 8352 
0146 7598 61A0  34         s     @parm1,tmp2           ; Calculate loop
     759A 8350 
0147 759C 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 759E 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 75A0 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     75A2 3002 
     75A4 3000 
0157 75A6 C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     75A8 A002 
     75AA A000 
0158 75AC 05C4  14         inct  tmp0                  ; Next index entry
0159 75AE 0606  14         dec   tmp2                  ; tmp2--
0160 75B0 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 75B2 04E4  34         clr   @idx.top(tmp0)
     75B4 3000 
0167 75B6 04E4  34         clr   @idx.shadow.top(tmp0)
     75B8 A000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 75BA 045B  20         b     *r11                  ; Return
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
0192 75BC C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     75BE 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 75C0 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 75C2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75C4 8352 
0201 75C6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75C8 8350 
0202 75CA 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 75CC C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     75CE 3000 
     75D0 3002 
0207                                                   ; Move pointer
0208 75D2 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     75D4 3000 
0209               
0210 75D6 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     75D8 A000 
     75DA A002 
0211                                                   ; Move SAMS page
0212 75DC 04E4  34         clr   @idx.shadow.top+0(tmp0)
     75DE A000 
0213                                                   ; Clear new index entry
0214 75E0 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 75E2 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 75E4 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     75E6 3000 
     75E8 3002 
0222                                                   ; Move pointer
0223               
0224 75EA C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     75EC A000 
     75EE A002 
0225                                                   ; Move SAMS page
0226               
0227 75F0 0644  14         dect  tmp0                  ; Previous index entry
0228 75F2 0606  14         dec   tmp2                  ; tmp2--
0229 75F4 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 75F6 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     75F8 3004 
0232 75FA 04E4  34         clr   @idx.shadow.top+4(tmp0)
     75FC A004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 75FE 045B  20         b     *r11                  ; Return
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
0259 7600 0649  14         dect  stack
0260 7602 C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 7604 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7606 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 7608 0A14  56         sla   tmp0,1                ; line number * 2
0269 760A C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     760C 3000 
0270 760E C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     7610 A000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 7612 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7614 8360 
0277 7616 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     7618 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 761A 0460  28         b     @poprt                ; Return to caller
     761C 622A 
**** **** ****     > tivi.asm.3217
0256                       copy  "editorbuffer.asm"    ; edb - Editor Buffer module
**** **** ****     > editorbuffer.asm
0001               * FILE......: editorbuffer.asm
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
0026 761E 0649  14         dect  stack
0027 7620 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7622 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7624 B002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 7626 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7628 2300 
0035 762A C804  38         mov   tmp0,@edb.next_free.ptr
     762C 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037               
0038 762E 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7630 230A 
0039 7632 04E0  34         clr   @edb.lines            ; Lines=0
     7634 2304 
0040 7636 04E0  34         clr   @edb.rle              ; RLE compression off
     7638 230C 
0041               
0042 763A 0204  20         li    tmp0,txt_newfile
     763C 7D52 
0043 763E C804  38         mov   tmp0,@edb.filename.ptr
     7640 230E 
0044               
0045               
0046               edb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 7642 0460  28         b     @poprt                ; Return to caller
     7644 622A 
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
0077 7646 0649  14         dect  stack
0078 7648 C64B  30         mov   r11,*stack            ; Save return address
0079                       ;------------------------------------------------------
0080                       ; Get values
0081                       ;------------------------------------------------------
0082 764A C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     764C 220C 
     764E 8390 
0083 7650 04E0  34         clr   @fb.column
     7652 220C 
0084 7654 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7656 747C 
0085                       ;------------------------------------------------------
0086                       ; Prepare scan
0087                       ;------------------------------------------------------
0088 7658 04C4  14         clr   tmp0                  ; Counter
0089 765A C160  34         mov   @fb.current,tmp1      ; Get position
     765C 2202 
0090 765E C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7660 8392 
0091               
0092                       ;------------------------------------------------------
0093                       ; Scan line for >00 byte termination
0094                       ;------------------------------------------------------
0095               edb.line.pack.scan:
0096 7662 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0097 7664 0986  56         srl   tmp2,8                ; Right justify
0098 7666 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0099 7668 0584  14         inc   tmp0                  ; Increase string length
0100 766A 10FB  14         jmp   edb.line.pack.scan    ; Next character
0101               
0102                       ;------------------------------------------------------
0103                       ; Prepare for storing line
0104                       ;------------------------------------------------------
0105               edb.line.pack.prepare:
0106 766C C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     766E 2204 
     7670 8350 
0107 7672 A820  54         a     @fb.row,@parm1        ; /
     7674 2206 
     7676 8350 
0108               
0109 7678 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     767A 8394 
0110               
0111                       ;------------------------------------------------------
0112                       ; 1. Update index
0113                       ;------------------------------------------------------
0114               edb.line.pack.update_index:
0115 767C C120  34         mov   @edb.next_free.ptr,tmp0
     767E 2308 
0116 7680 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     7682 8352 
0117               
0118 7684 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     7686 64DC 
0119                                                   ; \ i  tmp0  = Memory address
0120                                                   ; | o  waux1 = SAMS page number
0121                                                   ; / o  waux2 = Address of SAMS register
0122               
0123 7688 C820  54         mov   @waux1,@parm3         ; Save SAMS page number
     768A 833C 
     768C 8354 
0124               
0125 768E 06A0  32         bl    @idx.entry.update     ; Update index
     7690 756A 
0126                                                   ; \ i  parm1 = Line number in editor buffer
0127                                                   ; | i  parm2 = pointer to line in editor buffer
0128                                                   ; / i  parm3 = SAMS page
0129               
0130                       ;------------------------------------------------------
0131                       ; 2. Switch to required SAMS page
0132                       ;------------------------------------------------------
0133                       ;mov   @edb.sams.page,tmp0   ; Current SAMS page
0134                       ;mov   @edb.next_free.ptr,tmp1
0135                                                   ; Pointer to line in editor buffer
0136                 ;     bl    @xsams.page           ; Switch to SAMS page
0137                                                   ; \ i  tmp0 = SAMS page
0138                                                   ; / i  tmp1 = Memory address
0139               
0140                       ;------------------------------------------------------
0141                       ; 3. Set line prefix in editor buffer
0142                       ;------------------------------------------------------
0143 7692 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7694 8392 
0144 7696 C160  34         mov   @edb.next_free.ptr,tmp1
     7698 2308 
0145                                                   ; Address of line in editor buffer
0146               
0147 769A 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     769C 2308 
0148               
0149 769E C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     76A0 8394 
0150 76A2 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0151 76A4 06C6  14         swpb  tmp2
0152 76A6 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0153 76A8 06C6  14         swpb  tmp2
0154 76AA 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0155               
0156                       ;------------------------------------------------------
0157                       ; 4. Copy line from framebuffer to editor buffer
0158                       ;------------------------------------------------------
0159               edb.line.pack.copyline:
0160 76AC 0286  22         ci    tmp2,2
     76AE 0002 
0161 76B0 1603  14         jne   edb.line.pack.copyline.checkbyte
0162 76B2 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0163 76B4 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0164 76B6 1007  14         jmp   !
0165               edb.line.pack.copyline.checkbyte:
0166 76B8 0286  22         ci    tmp2,1
     76BA 0001 
0167 76BC 1602  14         jne   edb.line.pack.copyline.block
0168 76BE D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0169 76C0 1002  14         jmp   !
0170               edb.line.pack.copyline.block:
0171 76C2 06A0  32         bl    @xpym2m               ; Copy memory block
     76C4 647E 
0172                                                   ; \ i  tmp0 = source
0173                                                   ; | i  tmp1 = destination
0174                                                   ; / i  tmp2 = bytes to copy
0175               
0176 76C6 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     76C8 8394 
     76CA 2308 
0177                                                   ; Update pointer to next free line
0178               
0179                       ;------------------------------------------------------
0180                       ; Exit
0181                       ;------------------------------------------------------
0182               edb.line.pack.exit:
0183 76CC C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     76CE 8390 
     76D0 220C 
0184 76D2 0460  28         b     @poprt                ; Return to caller
     76D4 622A 
0185               
0186               
0187               
0188               
0189               ***************************************************************
0190               * edb.line.unpack
0191               * Unpack specified line to framebuffer
0192               ***************************************************************
0193               *  bl   @edb.line.unpack
0194               *--------------------------------------------------------------
0195               * INPUT
0196               * @parm1 = Line to unpack in editor buffer
0197               * @parm2 = Target row in frame buffer
0198               *--------------------------------------------------------------
0199               * OUTPUT
0200               * none
0201               *--------------------------------------------------------------
0202               * Register usage
0203               * tmp0,tmp1,tmp2,tmp3,tmp4
0204               *--------------------------------------------------------------
0205               * Memory usage
0206               * rambuf    = Saved @parm1 of edb.line.unpack
0207               * rambuf+2  = Saved @parm2 of edb.line.unpack
0208               * rambuf+4  = Source memory address in editor buffer
0209               * rambuf+6  = Destination memory address in frame buffer
0210               * rambuf+8  = Length of RLE (decompressed) line
0211               * rambuf+10 = Length of RLE compressed line
0212               ********|*****|*********************|**************************
0213               edb.line.unpack:
0214 76D6 0649  14         dect  stack
0215 76D8 C64B  30         mov   r11,*stack            ; Save return address
0216                       ;------------------------------------------------------
0217                       ; Sanity check
0218                       ;------------------------------------------------------
0219 76DA 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     76DC 8350 
     76DE 2304 
0220 76E0 1104  14         jlt   !
0221 76E2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     76E4 FFCE 
0222 76E6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     76E8 604C 
0223                       ;------------------------------------------------------
0224                       ; Save parameters
0225                       ;------------------------------------------------------
0226 76EA C820  54 !       mov   @parm1,@rambuf
     76EC 8350 
     76EE 8390 
0227 76F0 C820  54         mov   @parm2,@rambuf+2
     76F2 8352 
     76F4 8392 
0228                       ;------------------------------------------------------
0229                       ; Calculate offset in frame buffer
0230                       ;------------------------------------------------------
0231 76F6 C120  34         mov   @fb.colsline,tmp0
     76F8 220E 
0232 76FA 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     76FC 8352 
0233 76FE C1A0  34         mov   @fb.top.ptr,tmp2
     7700 2200 
0234 7702 A146  18         a     tmp2,tmp1             ; Add base to offset
0235 7704 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7706 8396 
0236                       ;------------------------------------------------------
0237                       ; Get pointer to line & page-in editor buffer page
0238                       ;------------------------------------------------------
0239 7708 C120  34         mov   @parm1,tmp0
     770A 8350 
0240 770C 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     770E 73FC 
0241                                                   ; \ i  tmp0     = Line number
0242                                                   ; | o  outparm1 = Pointer to line
0243                                                   ; / o  outparm2 = SAMS page
0244               
0245 7710 05E0  34         inct  @outparm1             ; Skip line prefix
     7712 8360 
0246 7714 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7716 8360 
     7718 8394 
0247                       ;------------------------------------------------------
0248                       ; Get length of line to unpack
0249                       ;------------------------------------------------------
0250 771A 06A0  32         bl    @edb.line.getlength   ; Get length of line
     771C 7788 
0251                                                   ; \ i  parm1    = Line number
0252                                                   ; | o  outparm1 = Line length (uncompressed)
0253                                                   ; | o  outparm2 = Line length (compressed)
0254                                                   ; / o  outparm3 = SAMS page
0255               
0256 771E C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7720 8362 
     7722 839A 
0257 7724 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7726 8360 
     7728 8398 
0258 772A 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line anyway
0259                       ;------------------------------------------------------
0260                       ; Handle possible "line split" between 2 consecutive pages
0261                       ;------------------------------------------------------
0262 772C C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
     772E 8394 
0263 7730 C144  18         mov     tmp0,tmp1           ; Pointer to line
0264 7732 A160  34         a       @rambuf+8,tmp1      ; Add length of line
     7734 8398 
0265               
0266 7736 0244  22         andi    tmp0,>f000          ; Only keep high nibble
     7738 F000 
0267 773A 0245  22         andi    tmp1,>f000          ; Only keep high nibble
     773C F000 
0268 773E 8144  18         c       tmp0,tmp1           ; Same segment?
0269 7740 1305  14         jeq     edb.line.unpack.clear
0270                                                   ; Yes, so skip
0271               
0272 7742 C120  34         mov     @outparm3,tmp0      ; Get SAMS page
     7744 8364 
0273 7746 0584  14         inc     tmp0                ; Next sams page
0274               
0275 7748 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
     774A 6514 
0276                                                   ; | i  tmp0 = SAMS page number
0277                                                   ; / i  tmp1 = Memory Address
0278               
0279                       ;------------------------------------------------------
0280                       ; Erase chars from last column until column 80
0281                       ;------------------------------------------------------
0282               edb.line.unpack.clear:
0283 774C C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     774E 8396 
0284 7750 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7752 8398 
0285               
0286 7754 04C5  14         clr   tmp1                  ; Fill with >00
0287 7756 C1A0  34         mov   @fb.colsline,tmp2
     7758 220E 
0288 775A 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     775C 8398 
0289 775E 0586  14         inc   tmp2
0290               
0291 7760 06A0  32         bl    @xfilm                ; Fill CPU memory
     7762 6234 
0292                                                   ; \ i  tmp0 = Target address
0293                                                   ; | i  tmp1 = Byte to fill
0294                                                   ; / i  tmp2 = Repeat count
0295                       ;------------------------------------------------------
0296                       ; Prepare for unpacking data
0297                       ;------------------------------------------------------
0298               edb.line.unpack.prepare:
0299 7764 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     7766 8398 
0300 7768 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0301 776A C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     776C 8394 
0302 776E C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7770 8396 
0303                       ;------------------------------------------------------
0304                       ; Check before copy
0305                       ;------------------------------------------------------
0306               edb.line.unpack.copy.uncompressed:
0307 7772 0286  22         ci    tmp2,80               ; Check line length;
     7774 0050 
0308 7776 1204  14         jle   !
0309 7778 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     777A FFCE 
0310 777C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     777E 604C 
0311                       ;------------------------------------------------------
0312                       ; Copy memory block
0313                       ;------------------------------------------------------
0314 7780 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     7782 647E 
0315                                                   ; \ i  tmp0 = Source address
0316                                                   ; | i  tmp1 = Target address
0317                                                   ; / i  tmp2 = Bytes to copy
0318                       ;------------------------------------------------------
0319                       ; Exit
0320                       ;------------------------------------------------------
0321               edb.line.unpack.exit:
0322 7784 0460  28         b     @poprt                ; Return to caller
     7786 622A 
0323               
0324               
0325               
0326               
0327               ***************************************************************
0328               * edb.line.getlength
0329               * Get length of specified line
0330               ***************************************************************
0331               *  bl   @edb.line.getlength
0332               *--------------------------------------------------------------
0333               * INPUT
0334               * @parm1 = Line number
0335               *--------------------------------------------------------------
0336               * OUTPUT
0337               * @outparm1 = Length of line (uncompressed)
0338               * @outparm2 = Length of line (compressed)
0339               * @outparm3 = SAMS page
0340               *--------------------------------------------------------------
0341               * Register usage
0342               * tmp0,tmp1,tmp2
0343               ********|*****|*********************|**************************
0344               edb.line.getlength:
0345 7788 0649  14         dect  stack
0346 778A C64B  30         mov   r11,*stack            ; Save return address
0347                       ;------------------------------------------------------
0348                       ; Initialisation
0349                       ;------------------------------------------------------
0350 778C 04E0  34         clr   @outparm1             ; Reset uncompressed length
     778E 8360 
0351 7790 04E0  34         clr   @outparm2             ; Reset compressed length
     7792 8362 
0352 7794 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7796 8364 
0353                       ;------------------------------------------------------
0354                       ; Get length
0355                       ;------------------------------------------------------
0356 7798 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     779A 7600 
0357                                                   ; \ i  parm1    = Line number
0358                                                   ; | o  outparm1 = Pointer to line
0359                                                   ; / o  outparm2 = SAMS page
0360               
0361 779C C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     779E 8360 
0362 77A0 130D  14         jeq   edb.line.getlength.exit
0363                                                   ; Exit early if NULL pointer
0364 77A2 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     77A4 8362 
     77A6 8364 
0365                       ;------------------------------------------------------
0366                       ; Process line prefix
0367                       ;------------------------------------------------------
0368 77A8 04C5  14         clr   tmp1
0369 77AA D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0370 77AC 06C5  14         swpb  tmp1
0371 77AE C805  38         mov   tmp1,@outparm2        ; Save length
     77B0 8362 
0372               
0373 77B2 04C5  14         clr   tmp1
0374 77B4 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0375 77B6 06C5  14         swpb  tmp1
0376 77B8 C805  38         mov   tmp1,@outparm1        ; Save length
     77BA 8360 
0377                       ;------------------------------------------------------
0378                       ; Exit
0379                       ;------------------------------------------------------
0380               edb.line.getlength.exit:
0381 77BC 0460  28         b     @poprt                ; Return to caller
     77BE 622A 
0382               
0383               
0384               
0385               
0386               ***************************************************************
0387               * edb.line.getlength2
0388               * Get length of current row (as seen from editor buffer side)
0389               ***************************************************************
0390               *  bl   @edb.line.getlength2
0391               *--------------------------------------------------------------
0392               * INPUT
0393               * @fb.row = Row in frame buffer
0394               *--------------------------------------------------------------
0395               * OUTPUT
0396               * @fb.row.length = Length of row
0397               *--------------------------------------------------------------
0398               * Register usage
0399               * tmp0
0400               ********|*****|*********************|**************************
0401               edb.line.getlength2:
0402 77C0 0649  14         dect  stack
0403 77C2 C64B  30         mov   r11,*stack            ; Save return address
0404                       ;------------------------------------------------------
0405                       ; Calculate line in editor buffer
0406                       ;------------------------------------------------------
0407 77C4 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     77C6 2204 
0408 77C8 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     77CA 2206 
0409                       ;------------------------------------------------------
0410                       ; Get length
0411                       ;------------------------------------------------------
0412 77CC C804  38         mov   tmp0,@parm1
     77CE 8350 
0413 77D0 06A0  32         bl    @edb.line.getlength
     77D2 7788 
0414 77D4 C820  54         mov   @outparm1,@fb.row.length
     77D6 8360 
     77D8 2208 
0415                                                   ; Save row length
0416                       ;------------------------------------------------------
0417                       ; Exit
0418                       ;------------------------------------------------------
0419               edb.line.getlength2.exit:
0420 77DA 0460  28         b     @poprt                ; Return to caller
     77DC 622A 
0421               
**** **** ****     > tivi.asm.3217
0257                       copy  "fh_sams.asm"         ; fh  - File handling module
**** **** ****     > fh_sams.asm
0001               * FILE......: fh_sams.asm
0002               * Purpose...: File read module: SAMS implementation
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
0031 77DE 0649  14         dect  stack
0032 77E0 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 77E2 04E0  34         clr   @tfh.rleonload        ; No RLE compression!
     77E4 2444 
0037 77E6 04E0  34         clr   @tfh.records          ; Reset records counter
     77E8 242E 
0038 77EA 04E0  34         clr   @tfh.counter          ; Clear internal counter
     77EC 2434 
0039 77EE 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     77F0 2432 
0040 77F2 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 77F4 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     77F6 242A 
0042 77F8 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     77FA 242C 
0043               
0044 77FC 0204  20         li    tmp0,3
     77FE 0003 
0045 7800 C804  38         mov   tmp0,@tfh.sams.page   ; Set current SAMS page
     7802 2438 
0046 7804 C804  38         mov   tmp0,@tfh.sams.hpage  ; Set highest SAMS page in use
     7806 243A 
0047                       ;------------------------------------------------------
0048                       ; Save parameters / callback functions
0049                       ;------------------------------------------------------
0050 7808 C820  54         mov   @parm1,@tfh.fname.ptr ; Pointer to file descriptor
     780A 8350 
     780C 2436 
0051 780E C820  54         mov   @parm2,@tfh.callback1 ; Loading indicator 1
     7810 8352 
     7812 243C 
0052 7814 C820  54         mov   @parm3,@tfh.callback2 ; Loading indicator 2
     7816 8354 
     7818 243E 
0053 781A C820  54         mov   @parm4,@tfh.callback3 ; Loading indicator 3
     781C 8356 
     781E 2440 
0054 7820 C820  54         mov   @parm5,@tfh.callback4 ; File I/O error handler
     7822 8358 
     7824 2442 
0055                       ;------------------------------------------------------
0056                       ; Sanity check
0057                       ;------------------------------------------------------
0058 7826 C120  34         mov   @tfh.callback1,tmp0
     7828 243C 
0059 782A 0284  22         ci    tmp0,>6000            ; Insane address ?
     782C 6000 
0060 782E 1114  14         jlt   !                     ; Yes, crash!
0061               
0062 7830 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7832 7FFF 
0063 7834 1511  14         jgt   !                     ; Yes, crash!
0064               
0065 7836 C120  34         mov   @tfh.callback2,tmp0
     7838 243E 
0066 783A 0284  22         ci    tmp0,>6000            ; Insane address ?
     783C 6000 
0067 783E 110C  14         jlt   !                     ; Yes, crash!
0068               
0069 7840 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7842 7FFF 
0070 7844 1509  14         jgt   !                     ; Yes, crash!
0071               
0072 7846 C120  34         mov   @tfh.callback3,tmp0
     7848 2440 
0073 784A 0284  22         ci    tmp0,>6000            ; Insane address ?
     784C 6000 
0074 784E 1104  14         jlt   !                     ; Yes, crash!
0075               
0076 7850 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7852 7FFF 
0077 7854 1501  14         jgt   !                     ; Yes, crash!
0078               
0079 7856 1004  14         jmp   tfh.file.read.sams.load1
0080                                                   ; All checks passed, continue.
0081               
0082                                                   ;--------------------------
0083                                                   ; Sanity check failed
0084                                                   ;--------------------------
0085 7858 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     785A FFCE 
0086 785C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     785E 604C 
0087                       ;------------------------------------------------------
0088                       ; Show "loading indicator 1"
0089                       ;------------------------------------------------------
0090               tfh.file.read.sams.load1:
0091 7860 C120  34         mov   @tfh.callback1,tmp0
     7862 243C 
0092 7864 0694  24         bl    *tmp0                 ; Run callback function
0093                       ;------------------------------------------------------
0094                       ; Copy PAB header to VDP
0095                       ;------------------------------------------------------
0096               tfh.file.read.sams.pabheader:
0097 7866 06A0  32         bl    @cpym2v
     7868 6430 
0098 786A 0A60                   data tfh.vpab,tfh.file.pab.header,9
     786C 79E4 
     786E 0009 
0099                                                   ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101                       ; Append file descriptor to PAB header in VDP
0102                       ;------------------------------------------------------
0103 7870 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7872 0A69 
0104 7874 C160  34         mov   @tfh.fname.ptr,tmp1   ; Get pointer to file descriptor
     7876 2436 
0105 7878 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0106 787A 0986  56         srl   tmp2,8                ; Right justify
0107 787C 0586  14         inc   tmp2                  ; Include length byte as well
0108 787E 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7880 6436 
0109                       ;------------------------------------------------------
0110                       ; Load GPL scratchpad layout
0111                       ;------------------------------------------------------
0112 7882 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7884 6A22 
0113 7886 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0114                       ;------------------------------------------------------
0115                       ; Open file
0116                       ;------------------------------------------------------
0117 7888 06A0  32         bl    @file.open
     788A 6B70 
0118 788C 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0119 788E 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7890 6042 
0120 7892 1602  14         jne   tfh.file.read.sams.record
0121 7894 0460  28         b     @tfh.file.read.sams.error
     7896 79AE 
0122                                                   ; Yes, IO error occured
0123                       ;------------------------------------------------------
0124                       ; Step 1: Read file record
0125                       ;------------------------------------------------------
0126               tfh.file.read.sams.record:
0127 7898 05A0  34         inc   @tfh.records          ; Update counter
     789A 242E 
0128 789C 04E0  34         clr   @tfh.reclen           ; Reset record length
     789E 2430 
0129               
0130 78A0 06A0  32         bl    @file.record.read     ; Read file record
     78A2 6BB2 
0131 78A4 0A60                   data tfh.vpab         ; \ i  p0   = Address of PAB in VDP RAM (without +9 offset!)
0132                                                   ; | o  tmp0 = Status byte
0133                                                   ; | o  tmp1 = Bytes read
0134                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0135               
0136 78A6 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     78A8 242A 
0137 78AA C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     78AC 2430 
0138 78AE C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     78B0 242C 
0139                       ;------------------------------------------------------
0140                       ; 1a: Calculate kilobytes processed
0141                       ;------------------------------------------------------
0142 78B2 A805  38         a     tmp1,@tfh.counter
     78B4 2434 
0143 78B6 A160  34         a     @tfh.counter,tmp1
     78B8 2434 
0144 78BA 0285  22         ci    tmp1,1024
     78BC 0400 
0145 78BE 1106  14         jlt   !
0146 78C0 05A0  34         inc   @tfh.kilobytes
     78C2 2432 
0147 78C4 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     78C6 FC00 
0148 78C8 C805  38         mov   tmp1,@tfh.counter
     78CA 2434 
0149                       ;------------------------------------------------------
0150                       ; 1b: Load spectra scratchpad layout
0151                       ;------------------------------------------------------
0152 78CC 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     78CE 69A8 
0153 78D0 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     78D2 6A44 
0154 78D4 2100                   data scrpad.backup2   ; / >2100->8300
0155                       ;------------------------------------------------------
0156                       ; 1c: Check if a file error occured
0157                       ;------------------------------------------------------
0158               tfh.file.read.sams.check_fioerr:
0159 78D6 C1A0  34         mov   @tfh.ioresult,tmp2
     78D8 242C 
0160 78DA 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     78DC 6042 
0161 78DE 1602  14         jne   tfh.file.read.sams.check_setpage
0162                                                   ; No, goto (1d)
0163 78E0 0460  28         b     @tfh.file.read.sams.error
     78E2 79AE 
0164                                                   ; Yes, so handle file error
0165                       ;------------------------------------------------------
0166                       ; 1d: Check if SAMS page needs to be set
0167                       ;------------------------------------------------------
0168               tfh.file.read.sams.check_setpage:
0169 78E4 C120  34         mov   @edb.next_free.ptr,tmp0
     78E6 2308 
0170 78E8 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     78EA 64DC 
0171                                                   ; \ i  tmp0  = Memory address
0172                                                   ; | o  waux1 = SAMS page number
0173                                                   ; / o  waux2 = Address of SAMS register
0174               
0175 78EC C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     78EE 833C 
0176 78F0 8804  38         c     tmp0,@tfh.sams.page   ; Compare page with current SAMS page
     78F2 2438 
0177 78F4 1310  14         jeq   tfh.file.read.sams.nocompression
0178                                                   ; Same, skip to (2)
0179                       ;------------------------------------------------------
0180                       ; 1e: Increase SAMS page if necessary
0181                       ;------------------------------------------------------
0182 78F6 8804  38         c     tmp0,@tfh.sams.hpage  ; Compare page with highest SAMS page
     78F8 243A 
0183 78FA 1502  14         jgt   tfh.file.read.sams.switch
0184                                                   ; Switch page
0185 78FC 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     78FE 0005 
0186                       ;------------------------------------------------------
0187                       ; 1f: Switch to SAMS page
0188                       ;------------------------------------------------------
0189               tfh.file.read.sams.switch:
0190 7900 C160  34         mov   @edb.next_free.ptr,tmp1
     7902 2308 
0191                                                   ; Beginning of line
0192               
0193 7904 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7906 6514 
0194                                                   ; \ i  tmp0 = SAMS page number
0195                                                   ; / i  tmp1 = Memory address
0196               
0197 7908 C804  38         mov   tmp0,@tfh.sams.page   ; Save current SAMS page
     790A 2438 
0198               
0199 790C 8804  38         c     tmp0,@tfh.sams.hpage  ; Current SAMS page > highest SAMS page?
     790E 243A 
0200 7910 1202  14         jle   tfh.file.read.sams.nocompression
0201                                                   ; No, skip to (2)
0202 7912 C804  38         mov   tmp0,@tfh.sams.hpage  ; Update highest SAMS page
     7914 243A 
0203                       ;------------------------------------------------------
0204                       ; Step 2: Process line (without RLE compression)
0205                       ;------------------------------------------------------
0206               tfh.file.read.sams.nocompression:
0207 7916 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7918 0960 
0208 791A C160  34         mov   @edb.next_free.ptr,tmp1
     791C 2308 
0209                                                   ; RAM target in editor buffer
0210               
0211 791E C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7920 8352 
0212               
0213 7922 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7924 2430 
0214 7926 1324  14         jeq   tfh.file.read.sams.prepindex.emptyline
0215                                                   ; Handle empty line
0216                       ;------------------------------------------------------
0217                       ; 2a: Copy line from VDP to CPU editor buffer
0218                       ;------------------------------------------------------
0219                                                   ; Save line prefix
0220 7928 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0221 792A 06C6  14         swpb  tmp2                  ; |
0222 792C DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0223 792E 06C6  14         swpb  tmp2                  ; /
0224               
0225 7930 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7932 2308 
0226 7934 A806  38         a     tmp2,@edb.next_free.ptr
     7936 2308 
0227                                                   ; Add line length
0228                       ;------------------------------------------------------
0229                       ; 2b: Handle line split accross 2 consecutive SAMS pages
0230                       ;------------------------------------------------------
0231 7938 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0232 793A C205  18         mov   tmp1,tmp4             ; Backup tmp1
0233               
0234 793C C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
0235 793E 09C4  56         srl   tmp0,12               ; Only keep high-nibble
0236               
0237 7940 C160  34         mov   @edb.next_free.ptr,tmp1
     7942 2308 
0238                                                   ; Get pointer to next line (aka end of line)
0239 7944 09C5  56         srl   tmp1,12               ; Only keep high-nibble
0240               
0241 7946 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
0242 7948 1307  14         jeq   !                     ; Yes, skip setting SAMS page
0243               
0244 794A C120  34         mov   @tfh.sams.page,tmp0   ; Get current SAMS page
     794C 2438 
0245 794E 0584  14         inc   tmp0                  ; Increase SAMS page
0246 7950 C160  34         mov   @edb.next_free.ptr,tmp1
     7952 2308 
0247                                                   ; Get pointer to next line (aka end of line)
0248               
0249 7954 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7956 6514 
0250                                                   ; \ i  tmp0 = SAMS page number
0251                                                   ; / i  tmp1 = Memory address
0252               
0253 7958 C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
0254 795A C107  18         mov   tmp3,tmp0             ; Restore tmp0
0255                       ;------------------------------------------------------
0256                       ; 2c: Do actual copy
0257                       ;------------------------------------------------------
0258 795C 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     795E 645C 
0259                                                   ; \ i  tmp0 = VDP source address
0260                                                   ; | i  tmp1 = RAM target address
0261                                                   ; / i  tmp2 = Bytes to copy
0262               
0263 7960 1000  14         jmp   tfh.file.read.sams.prepindex
0264                                                   ; Prepare for updating index
0265                       ;------------------------------------------------------
0266                       ; Step 4: Update index
0267                       ;------------------------------------------------------
0268               tfh.file.read.sams.prepindex:
0269 7962 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7964 2304 
     7966 8350 
0270                                                   ; parm2 = Must allready be set!
0271 7968 C820  54         mov   @tfh.sams.page,@parm3 ; parm3 = SAMS page number
     796A 2438 
     796C 8354 
0272               
0273 796E 1009  14         jmp   tfh.file.read.sams.updindex
0274                                                   ; Update index
0275                       ;------------------------------------------------------
0276                       ; 4a: Special handling for empty line
0277                       ;------------------------------------------------------
0278               tfh.file.read.sams.prepindex.emptyline:
0279 7970 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7972 242E 
     7974 8350 
0280 7976 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7978 8350 
0281 797A 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     797C 8352 
0282 797E 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7980 8354 
0283                       ;------------------------------------------------------
0284                       ; 4b: Do actual index update
0285                       ;------------------------------------------------------
0286               tfh.file.read.sams.updindex:
0287 7982 06A0  32         bl    @idx.entry.update     ; Update index
     7984 756A 
0288                                                   ; \ i  parm1    = Line number in editor buffer
0289                                                   ; | i  parm2    = Pointer to line in editor buffer
0290                                                   ; | i  parm3    = SAMS page
0291                                                   ; / o  outparm1 = Pointer to updated index entry
0292               
0293 7986 05A0  34         inc   @edb.lines            ; lines=lines+1
     7988 2304 
0294                       ;------------------------------------------------------
0295                       ; Step 5: Display results
0296                       ;------------------------------------------------------
0297               tfh.file.read.sams.display:
0298 798A C120  34         mov   @tfh.callback2,tmp0   ; Get pointer to "Loading indicator 2"
     798C 243E 
0299 798E 0694  24         bl    *tmp0                 ; Run callback function
0300                       ;------------------------------------------------------
0301                       ; Step 6: Check if reaching memory high-limit >ffa0
0302                       ;------------------------------------------------------
0303               tfh.file.read.sams.checkmem:
0304 7990 C120  34         mov   @edb.next_free.ptr,tmp0
     7992 2308 
0305 7994 0284  22         ci    tmp0,>ffa0
     7996 FFA0 
0306 7998 1205  14         jle   tfh.file.read.sams.next
0307                       ;------------------------------------------------------
0308                       ; 6a: Address range b000-ffff full, switch SAMS pages
0309                       ;------------------------------------------------------
0310 799A 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     799C B002 
0311 799E C804  38         mov   tmp0,@edb.next_free.ptr
     79A0 2308 
0312               
0313 79A2 1000  14         jmp   tfh.file.read.sams.next
0314                       ;------------------------------------------------------
0315                       ; 6b: Next record
0316                       ;------------------------------------------------------
0317               tfh.file.read.sams.next:
0318 79A4 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     79A6 6A22 
0319 79A8 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0320               
0321 79AA 0460  28         b     @tfh.file.read.sams.record
     79AC 7898 
0322                                                   ; Next record
0323                       ;------------------------------------------------------
0324                       ; Error handler
0325                       ;------------------------------------------------------
0326               tfh.file.read.sams.error:
0327 79AE C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     79B0 242A 
0328 79B2 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0329 79B4 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     79B6 0005 
0330 79B8 1309  14         jeq   tfh.file.read.sams.eof
0331                                                   ; All good. File closed by DSRLNK
0332                       ;------------------------------------------------------
0333                       ; File error occured
0334                       ;------------------------------------------------------
0335 79BA 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     79BC 6A44 
0336 79BE 2100                   data scrpad.backup2   ; / >2100->8300
0337               
0338 79C0 06A0  32         bl    @mem.setup.sams.layout
     79C2 73CC 
0339                                                   ; Restore SAMS default memory layout
0340               
0341 79C4 C120  34         mov   @tfh.callback4,tmp0   ; Get pointer to "File I/O error handler"
     79C6 2442 
0342 79C8 0694  24         bl    *tmp0                 ; Run callback function
0343 79CA 100A  14         jmp   tfh.file.read.sams.exit
0344                       ;------------------------------------------------------
0345                       ; End-Of-File reached
0346                       ;------------------------------------------------------
0347               tfh.file.read.sams.eof:
0348 79CC 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     79CE 6A44 
0349 79D0 2100                   data scrpad.backup2   ; / >2100->8300
0350               
0351 79D2 06A0  32         bl    @mem.setup.sams.layout
     79D4 73CC 
0352                                                   ; Restore SAMS default memory layout
0353                       ;------------------------------------------------------
0354                       ; Show "loading indicator 3" (final)
0355                       ;------------------------------------------------------
0356 79D6 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     79D8 2306 
0357               
0358 79DA C120  34         mov   @tfh.callback3,tmp0   ; Get pointer to "Loading indicator 3"
     79DC 2440 
0359 79DE 0694  24         bl    *tmp0                 ; Run callback function
0360               *--------------------------------------------------------------
0361               * Exit
0362               *--------------------------------------------------------------
0363               tfh.file.read.sams.exit:
0364 79E0 0460  28         b     @poprt                ; Return to caller
     79E2 622A 
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
0375 79E4 0014             byte  io.op.open            ;  0    - OPEN
0376                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0377 79E6 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0378 79E8 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0379                       byte  00                    ;  5    - Character count
0380 79EA 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0381 79EC 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0382                       ;------------------------------------------------------
0383                       ; File descriptor part (variable length)
0384                       ;------------------------------------------------------
0385                       ; byte  12                  ;  9    - File descriptor length
0386                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.3217
0258                       copy  "fm_load.asm"         ; fm  - File manager module
**** **** ****     > fm_load.asm
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
0014 79EE 0649  14         dect  stack
0015 79F0 C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 79F2 C804  38         mov   tmp0,@parm1           ; Setup file to load
     79F4 8350 
0018 79F6 06A0  32         bl    @edb.init             ; Initialize editor buffer
     79F8 761E 
0019 79FA 06A0  32         bl    @idx.init             ; Initialize index
     79FC 7546 
0020 79FE 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7A00 742E 
0021 7A02 C820  54         mov   @parm1,@edb.filename.ptr
     7A04 8350 
     7A06 230E 
0022                                                   ; Set filename
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7A08 06A0  32         bl    @filv
     7A0A 6286 
0027 7A0C 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7A0E 0000 
     7A10 0004 
0028               
0029 7A12 C160  34         mov   @fb.screenrows,tmp1
     7A14 2218 
0030 7A16 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7A18 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 7A1A 04C4  14         clr   tmp0                  ; VDP target address
0034 7A1C 0205  20         li    tmp1,32               ; Character to fill
     7A1E 0020 
0035               
0036 7A20 06A0  32         bl    @xfilv                ; Fill VDP memory
     7A22 628C 
0037                                                   ; \ i  tmp0 = VDP target address
0038                                                   ; | i  tmp1 = Byte to fill
0039                                                   ; / i  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 7A24 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     7A26 7A50 
0044 7A28 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7A2A 8352 
0045               
0046 7A2C 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     7A2E 7A88 
0047 7A30 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7A32 8354 
0048               
0049 7A34 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     7A36 7ABA 
0050 7A38 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7A3A 8356 
0051               
0052 7A3C 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     7A3E 7AEC 
0053 7A40 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7A42 8358 
0054               
0055 7A44 06A0  32         bl    @tfh.file.read.sams   ; Read specified file with SAMS support
     7A46 77DE 
0056                                                   ; \ i  parm1 = Pointer to length prefixed file descriptor
0057                                                   ; | i  parm2 = Pointer to callback function "loading indicator 1"
0058                                                   ; | i  parm3 = Pointer to callback function "loading indicator 2"
0059                                                   ; | i  parm4 = Pointer to callback function "loading indicator 3"
0060                                                   ; / i  parm5 = Pointer to callback function "File I/O error handler"
0061               
0062 7A48 04E0  34         clr   @edb.dirty            ; Editor buffer fully replaced, no longer dirty
     7A4A 2306 
0063               *--------------------------------------------------------------
0064               * Exit
0065               *--------------------------------------------------------------
0066               fm.loadfile.exit:
0067 7A4C 0460  28         b     @poprt                ; Return to caller
     7A4E 622A 
0068               
0069               
0070               
0071               *---------------------------------------------------------------
0072               * Callback function "Show loading indicator 1"
0073               *---------------------------------------------------------------
0074               * Is expected to be passed as parm2 to @tfh.file.read
0075               *---------------------------------------------------------------
0076               fm.loadfile.callback.indicator1:
0077 7A50 0649  14         dect  stack
0078 7A52 C64B  30         mov   r11,*stack            ; Save return address
0079                       ;------------------------------------------------------
0080                       ; Show loading indicators and file descriptor
0081                       ;------------------------------------------------------
0082 7A54 06A0  32         bl    @hchar
     7A56 6712 
0083 7A58 1D03                   byte 29,3,32,77
     7A5A 204D 
0084 7A5C FFFF                   data EOL
0085               
0086 7A5E 06A0  32         bl    @putat
     7A60 6428 
0087 7A62 1D03                   byte 29,3
0088 7A64 7D26                   data txt_loading      ; Display "Loading...."
0089               
0090 7A66 8820  54         c     @tfh.rleonload,@w$ffff
     7A68 2444 
     7A6A 6048 
0091 7A6C 1604  14         jne   !
0092 7A6E 06A0  32         bl    @putat
     7A70 6428 
0093 7A72 1D44                   byte 29,68
0094 7A74 7D36                   data txt_rle          ; Display "RLE"
0095               
0096 7A76 06A0  32 !       bl    @at
     7A78 661E 
0097 7A7A 1D0E                   byte 29,14            ; Cursor YX position
0098 7A7C C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7A7E 8350 
0099 7A80 06A0  32         bl    @xutst0               ; Display device/filename
     7A82 6418 
0100                       ;------------------------------------------------------
0101                       ; Exit
0102                       ;------------------------------------------------------
0103               fm.loadfile.callback.indicator1.exit:
0104 7A84 0460  28         b     @poprt                ; Return to caller
     7A86 622A 
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
0115 7A88 0649  14         dect  stack
0116 7A8A C64B  30         mov   r11,*stack            ; Save return address
0117               
0118 7A8C 06A0  32         bl    @putnum
     7A8E 699E 
0119 7A90 1D4B                   byte 29,75            ; Show lines read
0120 7A92 2304                   data edb.lines,rambuf,>3020
     7A94 8390 
     7A96 3020 
0121               
0122 7A98 8220  34         c     @tfh.kilobytes,tmp4
     7A9A 2432 
0123 7A9C 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0124               
0125 7A9E C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7AA0 2432 
0126               
0127 7AA2 06A0  32         bl    @putnum
     7AA4 699E 
0128 7AA6 1D38                   byte 29,56            ; Show kilobytes read
0129 7AA8 2432                   data tfh.kilobytes,rambuf,>3020
     7AAA 8390 
     7AAC 3020 
0130               
0131 7AAE 06A0  32         bl    @putat
     7AB0 6428 
0132 7AB2 1D3D                   byte 29,61
0133 7AB4 7D32                   data txt_kb           ; Show "kb" string
0134                       ;------------------------------------------------------
0135                       ; Exit
0136                       ;------------------------------------------------------
0137               fm.loadfile.callback.indicator2.exit:
0138 7AB6 0460  28         b     @poprt                ; Return to caller
     7AB8 622A 
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
0150 7ABA 0649  14         dect  stack
0151 7ABC C64B  30         mov   r11,*stack            ; Save return address
0152               
0153               
0154 7ABE 06A0  32         bl    @hchar
     7AC0 6712 
0155 7AC2 1D03                   byte 29,3,32,50       ; Erase loading indicator
     7AC4 2032 
0156 7AC6 FFFF                   data EOL
0157               
0158 7AC8 06A0  32         bl    @putnum
     7ACA 699E 
0159 7ACC 1D38                   byte 29,56            ; Show kilobytes read
0160 7ACE 2432                   data tfh.kilobytes,rambuf,>3020
     7AD0 8390 
     7AD2 3020 
0161               
0162 7AD4 06A0  32         bl    @putat
     7AD6 6428 
0163 7AD8 1D3D                   byte 29,61
0164 7ADA 7D32                   data txt_kb           ; Show "kb" string
0165               
0166 7ADC 06A0  32         bl    @putnum
     7ADE 699E 
0167 7AE0 1D4B                   byte 29,75            ; Show lines read
0168 7AE2 242E                   data tfh.records,rambuf,>3020
     7AE4 8390 
     7AE6 3020 
0169                       ;------------------------------------------------------
0170                       ; Exit
0171                       ;------------------------------------------------------
0172               fm.loadfile.callback.indicator3.exit:
0173 7AE8 0460  28         b     @poprt                ; Return to caller
     7AEA 622A 
0174               
0175               
0176               
0177               *---------------------------------------------------------------
0178               * Callback function "File I/O error handler"
0179               *---------------------------------------------------------------
0180               * Is expected to be passed as parm5 to @tfh.file.read
0181               *---------------------------------------------------------------
0182               fm.loadfile.callback.fioerr:
0183 7AEC 0649  14         dect  stack
0184 7AEE C64B  30         mov   r11,*stack            ; Save return address
0185               
0186               
0187 7AF0 06A0  32         bl    @hchar
     7AF2 6712 
0188 7AF4 1D00                   byte 29,0,32,30       ; Erase loading indicator
     7AF6 201E 
0189 7AF8 FFFF                   data EOL
0190               
0191 7AFA 06A0  32         bl    @putat
     7AFC 6428 
0192 7AFE 1D00                   byte 29,0             ; Display message
0193 7B00 7D40                   data txt_ioerr
0194               
0195 7B02 06A0  32         bl    @at                   ; Position cursor
     7B04 661E 
0196 7B06 1D0D                   byte 29,13
0197               
0198 7B08 C160  34         mov   @tfh.fname.ptr,tmp1   ; Get file descriptor
     7B0A 2436 
0199 7B0C 06A0  32         bl    @xutst0               ; Show file descriptor
     7B0E 6418 
0200                       ;------------------------------------------------------
0201                       ; Exit
0202                       ;------------------------------------------------------
0203               fm.loadfile.callback.fioerr.exit:
0204 7B10 0460  28         b     @poprt                ; Return to caller
     7B12 622A 
**** **** ****     > tivi.asm.3217
0259                       copy  "tasks.asm"           ; tsk - Tasks module
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
0011 7B14 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7B16 6030 
0012 7B18 160B  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0013               *---------------------------------------------------------------
0014               * Identical key pressed ?
0015               *---------------------------------------------------------------
0016 7B1A 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7B1C 6030 
0017 7B1E 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7B20 833C 
     7B22 833E 
0018 7B24 1309  14         jeq   ed_wait
0019               *--------------------------------------------------------------
0020               * New key pressed
0021               *--------------------------------------------------------------
0022               ed_new_key
0023 7B26 C820  54         mov   @waux1,@waux2         ; Save as previous key
     7B28 833C 
     7B2A 833E 
0024 7B2C 0460  28         b     @edkey                ; Process key
     7B2E 6EC0 
0025               *--------------------------------------------------------------
0026               * Clear keyboard buffer if no key pressed
0027               *--------------------------------------------------------------
0028               ed_clear_kbbuffer
0029 7B30 04E0  34         clr   @waux1
     7B32 833C 
0030 7B34 04E0  34         clr   @waux2
     7B36 833E 
0031               *--------------------------------------------------------------
0032               * Delay to avoid key bouncing
0033               *--------------------------------------------------------------
0034               ed_wait
0035 7B38 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     7B3A 0708 
0036                       ;------------------------------------------------------
0037                       ; Delay loop
0038                       ;------------------------------------------------------
0039               ed_wait_loop
0040 7B3C 0604  14         dec   tmp0
0041 7B3E 16FE  14         jne   ed_wait_loop
0042               *--------------------------------------------------------------
0043               * Exit
0044               *--------------------------------------------------------------
0045 7B40 0460  28 ed_exit b     @hookok               ; Return
     7B42 6BFA 
0046               
0047               
0048               
0049               
0050               
0051               
0052               ***************************************************************
0053               * Task 0 - Copy frame buffer to VDP
0054               ***************************************************************
0055 7B44 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7B46 2216 
0056 7B48 133D  14         jeq   task0.exit            ; No, skip update
0057                       ;------------------------------------------------------
0058                       ; Determine how many rows to copy
0059                       ;------------------------------------------------------
0060 7B4A 8820  54         c     @edb.lines,@fb.screenrows
     7B4C 2304 
     7B4E 2218 
0061 7B50 1103  14         jlt   task0.setrows.small
0062 7B52 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7B54 2218 
0063 7B56 1003  14         jmp   task0.copy.framebuffer
0064                       ;------------------------------------------------------
0065                       ; Less lines in editor buffer as rows in frame buffer
0066                       ;------------------------------------------------------
0067               task0.setrows.small:
0068 7B58 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7B5A 2304 
0069 7B5C 0585  14         inc   tmp1
0070                       ;------------------------------------------------------
0071                       ; Determine area to copy
0072                       ;------------------------------------------------------
0073               task0.copy.framebuffer:
0074 7B5E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7B60 220E 
0075                                                   ; 16 bit part is in tmp2!
0076 7B62 04C4  14         clr   tmp0                  ; VDP target address
0077 7B64 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7B66 2200 
0078                       ;------------------------------------------------------
0079                       ; Copy memory block
0080                       ;------------------------------------------------------
0081 7B68 06A0  32         bl    @xpym2v               ; Copy to VDP
     7B6A 6436 
0082                                                   ; tmp0 = VDP target address
0083                                                   ; tmp1 = RAM source address
0084                                                   ; tmp2 = Bytes to copy
0085 7B6C 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7B6E 2216 
0086                       ;-------------------------------------------------------
0087                       ; Draw EOF marker at end-of-file
0088                       ;-------------------------------------------------------
0089 7B70 C120  34         mov   @edb.lines,tmp0
     7B72 2304 
0090 7B74 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7B76 2204 
0091 7B78 0584  14         inc   tmp0                  ; Y++
0092 7B7A 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7B7C 2218 
0093 7B7E 1222  14         jle   task0.exit
0094                       ;-------------------------------------------------------
0095                       ; Draw EOF marker
0096                       ;-------------------------------------------------------
0097               task0.draw_marker:
0098 7B80 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7B82 832A 
     7B84 2214 
0099 7B86 0A84  56         sla   tmp0,8                ; X=0
0100 7B88 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7B8A 832A 
0101 7B8C 06A0  32         bl    @putstr
     7B8E 6416 
0102 7B90 7D10                   data txt_marker       ; Display *EOF*
0103                       ;-------------------------------------------------------
0104                       ; Draw empty line after (and below) EOF marker
0105                       ;-------------------------------------------------------
0106 7B92 06A0  32         bl    @setx
     7B94 6634 
0107 7B96 0005                   data  5               ; Cursor after *EOF* string
0108               
0109 7B98 C120  34         mov   @wyx,tmp0
     7B9A 832A 
0110 7B9C 0984  56         srl   tmp0,8                ; Right justify
0111 7B9E 0584  14         inc   tmp0                  ; One time adjust
0112 7BA0 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7BA2 2218 
0113 7BA4 1303  14         jeq   !
0114 7BA6 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7BA8 009B 
0115 7BAA 1002  14         jmp   task0.draw_marker.line
0116 7BAC 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     7BAE 004B 
0117                       ;-------------------------------------------------------
0118                       ; Draw empty line
0119                       ;-------------------------------------------------------
0120               task0.draw_marker.line:
0121 7BB0 0604  14         dec   tmp0                  ; One time adjust
0122 7BB2 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7BB4 63F2 
0123 7BB6 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7BB8 0020 
0124 7BBA 06A0  32         bl    @xfilv                ; Write characters
     7BBC 628C 
0125 7BBE C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7BC0 2214 
     7BC2 832A 
0126               *--------------------------------------------------------------
0127               * Task 0 - Exit
0128               *--------------------------------------------------------------
0129               task0.exit:
0130 7BC4 0460  28         b     @slotok
     7BC6 6C76 
0131               
0132               
0133               
0134               ***************************************************************
0135               * Task 1 - Copy SAT to VDP
0136               ***************************************************************
0137 7BC8 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     7BCA 6046 
0138 7BCC 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     7BCE 6640 
0139 7BD0 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7BD2 8380 
0140 7BD4 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0141               
0142               
0143               
0144               ***************************************************************
0145               * Task 2 - Update cursor shape (blink)
0146               ***************************************************************
0147 7BD6 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     7BD8 2212 
0148 7BDA 1303  14         jeq   task2.cur_visible
0149 7BDC 04E0  34         clr   @ramsat+2              ; Hide cursor
     7BDE 8382 
0150 7BE0 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0151               
0152               task2.cur_visible:
0153 7BE2 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7BE4 230A 
0154 7BE6 1303  14         jeq   task2.cur_visible.overwrite_mode
0155                       ;------------------------------------------------------
0156                       ; Cursor in insert mode
0157                       ;------------------------------------------------------
0158               task2.cur_visible.insert_mode:
0159 7BE8 0204  20         li    tmp0,>0008
     7BEA 0008 
0160 7BEC 1002  14         jmp   task2.cur_visible.cursorshape
0161                       ;------------------------------------------------------
0162                       ; Cursor in overwrite mode
0163                       ;------------------------------------------------------
0164               task2.cur_visible.overwrite_mode:
0165 7BEE 0204  20         li    tmp0,>0208
     7BF0 0208 
0166                       ;------------------------------------------------------
0167                       ; Set cursor shape
0168                       ;------------------------------------------------------
0169               task2.cur_visible.cursorshape:
0170 7BF2 C804  38         mov   tmp0,@fb.curshape
     7BF4 2210 
0171 7BF6 C804  38         mov   tmp0,@ramsat+2
     7BF8 8382 
0172               
0173               
0174               
0175               
0176               *--------------------------------------------------------------
0177               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0178               *--------------------------------------------------------------
0179               task.sub_copy_ramsat:
0180 7BFA 06A0  32         bl    @cpym2v
     7BFC 6430 
0181 7BFE 2000                   data sprsat,ramsat,4   ; Update sprite
     7C00 8380 
     7C02 0004 
0182               
0183 7C04 C820  54         mov   @wyx,@fb.yxsave
     7C06 832A 
     7C08 2214 
0184               
0185                       ;-------------------------------------------------------
0186                       ; Draw border line
0187                       ;-------------------------------------------------------
0188 7C0A 06A0  32         bl    @hchar
     7C0C 6712 
0189 7C0E 1C00                   byte 28,0,1,80
     7C10 0150 
0190 7C12 FFFF                   data EOL
0191                       ;------------------------------------------------------
0192                       ; Show buffer number
0193                       ;------------------------------------------------------
0194 7C14 06A0  32         bl    @putat
     7C16 6428 
0195 7C18 1D00                   byte  29,0
0196 7C1A 7D4E                   data  txt_bufnum
0197                       ;------------------------------------------------------
0198                       ; Show current file
0199                       ;------------------------------------------------------
0200 7C1C 06A0  32         bl    @at
     7C1E 661E 
0201 7C20 1D03                   byte  29,3             ; Position cursor
0202               
0203 7C22 C160  34         mov   @edb.filename.ptr,tmp1 ; Get string to display
     7C24 230E 
0204 7C26 06A0  32         bl    @xutst0                ; Display string
     7C28 6418 
0205                       ;------------------------------------------------------
0206                       ; Show text editing mode
0207                       ;------------------------------------------------------
0208               task.botline.show_mode:
0209 7C2A C120  34         mov   @edb.insmode,tmp0
     7C2C 230A 
0210 7C2E 1605  14         jne   task.botline.show_mode.insert
0211                       ;------------------------------------------------------
0212                       ; Overwrite mode
0213                       ;------------------------------------------------------
0214               task.botline.show_mode.overwrite:
0215 7C30 06A0  32         bl    @putat
     7C32 6428 
0216 7C34 1D32                   byte  29,50
0217 7C36 7D1C                   data  txt_ovrwrite
0218 7C38 1004  14         jmp   task.botline.show_changed
0219                       ;------------------------------------------------------
0220                       ; Insert  mode
0221                       ;------------------------------------------------------
0222               task.botline.show_mode.insert:
0223 7C3A 06A0  32         bl    @putat
     7C3C 6428 
0224 7C3E 1D32                   byte  29,50
0225 7C40 7D20                   data  txt_insert
0226                       ;------------------------------------------------------
0227                       ; Show if text was changed in editor buffer
0228                       ;------------------------------------------------------
0229               task.botline.show_changed:
0230 7C42 C120  34         mov   @edb.dirty,tmp0
     7C44 2306 
0231 7C46 1305  14         jeq   task.botline.show_changed.clear
0232                       ;------------------------------------------------------
0233                       ; Show "*"
0234                       ;------------------------------------------------------
0235 7C48 06A0  32         bl    @putat
     7C4A 6428 
0236 7C4C 1D36                   byte 29,54
0237 7C4E 7D24                   data txt_star
0238 7C50 1001  14         jmp   task.botline.show_linecol
0239                       ;------------------------------------------------------
0240                       ; Show "line,column"
0241                       ;------------------------------------------------------
0242               task.botline.show_changed.clear:
0243 7C52 1000  14         nop
0244               task.botline.show_linecol:
0245 7C54 C820  54         mov   @fb.row,@parm1
     7C56 2206 
     7C58 8350 
0246 7C5A 06A0  32         bl    @fb.row2line
     7C5C 7468 
0247 7C5E 05A0  34         inc   @outparm1
     7C60 8360 
0248                       ;------------------------------------------------------
0249                       ; Show line
0250                       ;------------------------------------------------------
0251 7C62 06A0  32         bl    @putnum
     7C64 699E 
0252 7C66 1D40                   byte  29,64            ; YX
0253 7C68 8360                   data  outparm1,rambuf
     7C6A 8390 
0254 7C6C 3020                   byte  48               ; ASCII offset
0255                             byte  32               ; Padding character
0256                       ;------------------------------------------------------
0257                       ; Show comma
0258                       ;------------------------------------------------------
0259 7C6E 06A0  32         bl    @putat
     7C70 6428 
0260 7C72 1D45                   byte  29,69
0261 7C74 7D0E                   data  txt_delim
0262                       ;------------------------------------------------------
0263                       ; Show column
0264                       ;------------------------------------------------------
0265 7C76 06A0  32         bl    @film
     7C78 622E 
0266 7C7A 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7C7C 0020 
     7C7E 000C 
0267               
0268 7C80 C820  54         mov   @fb.column,@waux1
     7C82 220C 
     7C84 833C 
0269 7C86 05A0  34         inc   @waux1                 ; Offset 1
     7C88 833C 
0270               
0271 7C8A 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7C8C 6920 
0272 7C8E 833C                   data  waux1,rambuf
     7C90 8390 
0273 7C92 3020                   byte  48               ; ASCII offset
0274                             byte  32               ; Fill character
0275               
0276 7C94 06A0  32         bl    @trimnum               ; Trim number to the left
     7C96 6978 
0277 7C98 8390                   data  rambuf,rambuf+6,32
     7C9A 8396 
     7C9C 0020 
0278               
0279 7C9E 0204  20         li    tmp0,>0200
     7CA0 0200 
0280 7CA2 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7CA4 8396 
0281               
0282 7CA6 06A0  32         bl    @putat
     7CA8 6428 
0283 7CAA 1D46                   byte 29,70
0284 7CAC 8396                   data rambuf+6          ; Show column
0285                       ;------------------------------------------------------
0286                       ; Show lines in buffer unless on last line in file
0287                       ;------------------------------------------------------
0288 7CAE C820  54         mov   @fb.row,@parm1
     7CB0 2206 
     7CB2 8350 
0289 7CB4 06A0  32         bl    @fb.row2line
     7CB6 7468 
0290 7CB8 8820  54         c     @edb.lines,@outparm1
     7CBA 2304 
     7CBC 8360 
0291 7CBE 1605  14         jne   task.botline.show_lines_in_buffer
0292               
0293 7CC0 06A0  32         bl    @putat
     7CC2 6428 
0294 7CC4 1D4B                   byte 29,75
0295 7CC6 7D16                   data txt_bottom
0296               
0297 7CC8 100B  14         jmp   task.botline.exit
0298                       ;------------------------------------------------------
0299                       ; Show lines in buffer
0300                       ;------------------------------------------------------
0301               task.botline.show_lines_in_buffer:
0302 7CCA C820  54         mov   @edb.lines,@waux1
     7CCC 2304 
     7CCE 833C 
0303 7CD0 05A0  34         inc   @waux1                 ; Offset 1
     7CD2 833C 
0304 7CD4 06A0  32         bl    @putnum
     7CD6 699E 
0305 7CD8 1D4B                   byte 29,75             ; YX
0306 7CDA 833C                   data waux1,rambuf
     7CDC 8390 
0307 7CDE 3020                   byte 48
0308                             byte 32
0309                       ;------------------------------------------------------
0310                       ; Exit
0311                       ;------------------------------------------------------
0312               task.botline.exit
0313 7CE0 C820  54         mov   @fb.yxsave,@wyx
     7CE2 2214 
     7CE4 832A 
0314 7CE6 0460  28         b     @slotok                ; Exit running task
     7CE8 6C76 
**** **** ****     > tivi.asm.3217
0260               
0261               
0262               ***************************************************************
0263               *                      Constants
0264               ***************************************************************
0265               romsat:
0266 7CEA 0303             data >0303,>0008              ; Cursor YX, initial shape and colour
     7CEC 0008 
0267               
0268               cursors:
0269 7CEE 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7CF0 0000 
     7CF2 0000 
     7CF4 001C 
0270 7CF6 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7CF8 1010 
     7CFA 1010 
     7CFC 1000 
0271 7CFE 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7D00 1C1C 
     7D02 1C1C 
     7D04 1C00 
0272               
0273               line:
0274 7D06 0080             data >0080,>0000,>ff00,>ff00  ; A double line
     7D08 0000 
     7D0A FF00 
     7D0C FF00 
0275               
0276               ***************************************************************
0277               *                       Strings
0278               ***************************************************************
0279               txt_delim
0280 7D0E 012C             byte  1
0281 7D0F ....             text  ','
0282                       even
0283               
0284               txt_marker
0285 7D10 052A             byte  5
0286 7D11 ....             text  '*EOF*'
0287                       even
0288               
0289               txt_bottom
0290 7D16 0520             byte  5
0291 7D17 ....             text  '  BOT'
0292                       even
0293               
0294               txt_ovrwrite
0295 7D1C 034F             byte  3
0296 7D1D ....             text  'OVR'
0297                       even
0298               
0299               txt_insert
0300 7D20 0349             byte  3
0301 7D21 ....             text  'INS'
0302                       even
0303               
0304               txt_star
0305 7D24 012A             byte  1
0306 7D25 ....             text  '*'
0307                       even
0308               
0309               txt_loading
0310 7D26 0A4C             byte  10
0311 7D27 ....             text  'Loading...'
0312                       even
0313               
0314               txt_kb
0315 7D32 026B             byte  2
0316 7D33 ....             text  'kb'
0317                       even
0318               
0319               txt_rle
0320 7D36 0352             byte  3
0321 7D37 ....             text  'RLE'
0322                       even
0323               
0324               txt_lines
0325 7D3A 054C             byte  5
0326 7D3B ....             text  'Lines'
0327                       even
0328               
0329               txt_ioerr
0330 7D40 0C4C             byte  12
0331 7D41 ....             text  'Load failed:'
0332                       even
0333               
0334               txt_bufnum
0335 7D4E 0223             byte  2
0336 7D4F ....             text  '#1'
0337                       even
0338               
0339               txt_newfile
0340 7D52 0A5B             byte  10
0341 7D53 ....             text  '[New file]'
0342                       even
0343               
0344 7D5E 7D5E     end          data    $
0345               
0346               
0347               fdname0
0348 7D60 0D44             byte  13
0349 7D61 ....             text  'DSK1.INVADERS'
0350                       even
0351               
0352               fdname1
0353 7D6E 0F44             byte  15
0354 7D6F ....             text  'DSK1.SPEECHDOCS'
0355                       even
0356               
0357               fdname2
0358 7D7E 0C44             byte  12
0359 7D7F ....             text  'DSK1.XBEADOC'
0360                       even
0361               
0362               fdname3
0363 7D8C 0C44             byte  12
0364 7D8D ....             text  'DSK3.XBEADOC'
0365                       even
0366               
0367               fdname4
0368 7D9A 0C44             byte  12
0369 7D9B ....             text  'DSK3.C99MAN1'
0370                       even
0371               
0372               fdname5
0373 7DA8 0C44             byte  12
0374 7DA9 ....             text  'DSK3.C99MAN2'
0375                       even
0376               
0377               fdname6
0378 7DB6 0C44             byte  12
0379 7DB7 ....             text  'DSK3.C99MAN3'
0380                       even
0381               
0382               fdname7
0383 7DC4 0D44             byte  13
0384 7DC5 ....             text  'DSK3.C99SPECS'
0385                       even
0386               
0387               fdname8
0388 7DD2 0D44             byte  13
0389 7DD3 ....             text  'DSK3.RANDOM#C'
0390                       even
0391               
0392               fdname9
0393 7DE0 0D44             byte  13
0394 7DE1 ....             text  'DSK1.INVADERS'
0395                       even
0396               
0397               
0398               
0399               ***************************************************************
0400               *                  Sanity check on ROM size
0401               ***************************************************************
0405 7DEE 7DEE              data $   ; ROM size OK.

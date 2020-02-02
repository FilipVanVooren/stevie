XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.11019
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2020 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200202-11019
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
0056      0001     debug                   equ  1      ; Turn on spectra2 debugging
0057               *--------------------------------------------------------------
0058               * Skip unused spectra2 code modules for reduced code size
0059               *--------------------------------------------------------------
0060      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0061      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0062      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0063      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0064      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0065      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0066      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0067      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0068      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0069      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0070      0001     skip_speech_detection   equ  1      ; Skip speech synthesizer detection
0071      0001     skip_speech_player      equ  1      ; Skip inclusion of speech player code
0072      0001     skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
0073      0001     skip_random_generator   equ  1      ; Skip random functions
0074      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0075               *--------------------------------------------------------------
0076               * SPECTRA2 startup options
0077               *--------------------------------------------------------------
0078      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0079      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0080      00F4     spfclr                  equ  >f4    ; Foreground/Background color for font.
0081      0004     spfbck                  equ  >04    ; Screen background color.
0082               *--------------------------------------------------------------
0083               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0084               *--------------------------------------------------------------
0085               ;               equ  >8342          ; >8342-834F **free***
0086      8350     parm1           equ  >8350          ; Function parameter 1
0087      8352     parm2           equ  >8352          ; Function parameter 2
0088      8354     parm3           equ  >8354          ; Function parameter 3
0089      8356     parm4           equ  >8356          ; Function parameter 4
0090      8358     parm5           equ  >8358          ; Function parameter 5
0091      835A     parm6           equ  >835a          ; Function parameter 6
0092      835C     parm7           equ  >835c          ; Function parameter 7
0093      835E     parm8           equ  >835e          ; Function parameter 8
0094      8360     outparm1        equ  >8360          ; Function output parameter 1
0095      8362     outparm2        equ  >8362          ; Function output parameter 2
0096      8364     outparm3        equ  >8364          ; Function output parameter 3
0097      8366     outparm4        equ  >8366          ; Function output parameter 4
0098      8368     outparm5        equ  >8368          ; Function output parameter 5
0099      836A     outparm6        equ  >836a          ; Function output parameter 6
0100      836C     outparm7        equ  >836c          ; Function output parameter 7
0101      836E     outparm8        equ  >836e          ; Function output parameter 8
0102      8370     timers          equ  >8370          ; Timer table
0103      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0104      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0105               *--------------------------------------------------------------
0106               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0107               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0108               *--------------------------------------------------------------
0109      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0110      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0111               *--------------------------------------------------------------
0112               * Frame buffer structure            @>2200-22ff     (256 bytes)
0113               *--------------------------------------------------------------
0114      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0115      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0116      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0117      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0118      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0119      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0120      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0121      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0122      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0123      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0124      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0125      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0126      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0127      221A     fb.end          equ  fb.top.ptr+26  ; Free from here on
0128               *--------------------------------------------------------------
0129               * Editor buffer structure           @>2300-23ff     (256 bytes)
0130               *--------------------------------------------------------------
0131      2300     edb.top.ptr         equ  >2300          ; Pointer to editor buffer
0132      2302     edb.index.ptr       equ  edb.top.ptr+2  ; Pointer to index
0133      2304     edb.lines           equ  edb.top.ptr+4  ; Total lines in editor buffer
0134      2306     edb.dirty           equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0135      2308     edb.next_free.ptr   equ  edb.top.ptr+8  ; Pointer to next free line
0136      230A     edb.insmode         equ  edb.top.ptr+10 ; Editor insert mode (>0000 overwrite / >ffff insert)
0137      230C     edb.rle             equ  edb.top.ptr+12 ; RLE compression activated
0138      230E     edb.end             equ  edb.top.ptr+14 ; Free from here on
0139               *--------------------------------------------------------------
0140               * File handling structures          @>2400-24ff     (256 bytes)
0141               *--------------------------------------------------------------
0142      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0143      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0144      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0145      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB, required by level 2 FIO
0146      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0147      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0148      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0149      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0150      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0151      2434     tfh.counter     equ  tfh.top + 52   ; Internal counter used in TiVi file operations
0152      2436     tfh.rleonload   equ  tfh.top + 54   ; RLE compression needed during file load
0153      2438     tfh.sams.page   equ  tfh.top + 56   ; Current SAMS page during file operation
0154      243A     tfh.sams.hpage  equ  tfh.top + 58   ; Highest SAMS page in use so far for file operation
0155      243C     tfh.membuffer   equ  tfh.top + 60   ; 80 bytes file memory buffer
0156      248C     tfh.end         equ  tfh.top + 140  ; Free from here on
0157      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0158      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0159               *--------------------------------------------------------------
0160               * Free for future use               @>2500-264f     (336 bytes)
0161               *--------------------------------------------------------------
0162      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0163      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0164               *--------------------------------------------------------------
0165               * Frame buffer                      @>2650-2fff    (2480 bytes)
0166               *--------------------------------------------------------------
0167      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0168      09B0     fb.size         equ  2480           ; Frame buffer size
0169               *--------------------------------------------------------------
0170               * Index                             @>3000-3fff    (4096 bytes)
0171               *--------------------------------------------------------------
0172      3000     idx.top         equ  >3000          ; Top of index
0173      1000     idx.size        equ  4096           ; Index size
0174               *--------------------------------------------------------------
0175               * SAMS shadow index                 @>a000-afff    (4096 bytes)
0176               *--------------------------------------------------------------
0177      A000     idx.shadow.top  equ  >a000          ; Top of shadow index
0178      1000     idx.shadow.size equ  4096           ; Shadow index size
0179               *--------------------------------------------------------------
0180               * Editor buffer                     @>b000-bfff    (4096 bytes)
0181               *                                   @>c000-cfff    (4096 bytes)
0182               *                                   @>d000-dfff    (4096 bytes)
0183               *                                   @>e000-efff    (4096 bytes)
0184               *                                   @>f000-ffff    (4096 bytes)
0185               *--------------------------------------------------------------
0186      B000     edb.top         equ  >b000          ; Editor buffer high memory
0187      4F9C     edb.size        equ  20380          ; Editor buffer size
0188               *--------------------------------------------------------------
0189               
0190               
0191               *--------------------------------------------------------------
0192               * Cartridge header
0193               *--------------------------------------------------------------
0194                       save  >6000,>7fff
0195                       aorg  >6000
0196               
0197 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0198 6006 6010             data  prog0
0199 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0200 6010 0000     prog0   data  0                     ; No more items following
0201 6012 6CEA             data  runlib
0202               
0204               
0205 6014 1154             byte  17
0206 6015 ....             text  'TIVI 200202-11019'
0207                       even
0208               
0216               *--------------------------------------------------------------
0217               * Include required files
0218               *--------------------------------------------------------------
0219                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *    v2.0
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
0018               * >ffe0  r0               >fff0  r8  (tmp4)
0019               * >ffe2  r1               >fff2  r9  (stack)
0020               * >ffe4  r2 (config)      >fff4  r10
0021               * >ffe6  r3               >fff6  r11
0022               * >ffe8  r4 (tmp0)        >fff8  r12
0023               * >ffea  r5 (tmp1)        >fffa  r13
0024               * >ffec  r6 (tmp2)        >fffc  r14
0025               * >ffee  r7 (tmp3)        >fffe  r15
0026               ********|*****|*********************|**************************
0027               cpu.crash:
0028 604C 022B  22         ai    r11,-4                ; Remove opcode offset
     604E FFFC 
0029               *--------------------------------------------------------------
0030               *    Save registers to high memory
0031               *--------------------------------------------------------------
0032 6050 C800  38         mov   r0,@>ffe0
     6052 FFE0 
0033 6054 C801  38         mov   r1,@>ffe2
     6056 FFE2 
0034 6058 C802  38         mov   r2,@>ffe4
     605A FFE4 
0035 605C C803  38         mov   r3,@>ffe6
     605E FFE6 
0036 6060 C804  38         mov   r4,@>ffe8
     6062 FFE8 
0037 6064 C805  38         mov   r5,@>ffea
     6066 FFEA 
0038 6068 C806  38         mov   r6,@>ffec
     606A FFEC 
0039 606C C807  38         mov   r7,@>ffee
     606E FFEE 
0040 6070 C808  38         mov   r8,@>fff0
     6072 FFF0 
0041 6074 C809  38         mov   r9,@>fff2
     6076 FFF2 
0042 6078 C80A  38         mov   r10,@>fff4
     607A FFF4 
0043 607C C80B  38         mov   r11,@>fff6
     607E FFF6 
0044 6080 C80C  38         mov   r12,@>fff8
     6082 FFF8 
0045 6084 C80D  38         mov   r13,@>fffa
     6086 FFFA 
0046 6088 C80E  38         mov   r14,@>fffc
     608A FFFC 
0047 608C C80F  38         mov   r15,@>ffff
     608E FFFF 
0048               *--------------------------------------------------------------
0049               *    Reset system
0050               *--------------------------------------------------------------
0051               cpu.crash.reset:
0052 6090 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6092 8300 
0053 6094 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6096 8302 
0054 6098 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     609A 4A4A 
0055 609C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     609E 6CF2 
0056               *--------------------------------------------------------------
0057               *    Show diagnostics after system reset
0058               *--------------------------------------------------------------
0059               cpu.crash.main:
0060                       ;------------------------------------------------------
0061                       ; Show crashed message
0062                       ;------------------------------------------------------
0063 60A0 06A0  32         bl    @putat                ; Show crash message
     60A2 6330 
0064 60A4 0000                   data >0000,cpu.crash.msg.crashed
     60A6 60CC 
0065               
0066 60A8 06A0  32         bl    @puthex               ; Put hex value on screen
     60AA 681E 
0067 60AC 0015                   byte 0,21             ; \ .  p0 = YX position
0068 60AE FFF6                   data >fff6            ; | .  p1 = Pointer to 16 bit word
0069 60B0 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0070 60B2 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0071                                                   ; /         LSB offset for ASCII digit 0-9
0072                       ;------------------------------------------------------
0073                       ; Show caller details
0074                       ;------------------------------------------------------
0075 60B4 06A0  32         bl    @putat                ; Show caller message
     60B6 6330 
0076 60B8 0100                   data >0100,cpu.crash.msg.caller
     60BA 60E2 
0077               
0078 60BC 06A0  32         bl    @puthex               ; Put hex value on screen
     60BE 681E 
0079 60C0 0115                   byte 1,21             ; \ .  p0 = YX position
0080 60C2 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0081 60C4 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0082 60C6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0083                                                   ; /         LSB offset for ASCII digit 0-9
0084                       ;------------------------------------------------------
0085                       ; Kernel takes over
0086                       ;------------------------------------------------------
0087 60C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CA 6C00 
0088               
0089               
0090               
0091 60CC 1553     cpu.crash.msg.crashed      byte 21
0092 60CD ....                                text 'System crashed near >'
0093               
0094 60E2 1543     cpu.crash.msg.caller       byte 21
0095 60E3 ....                                text 'Caller address near >'
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 60F8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     60FA 000E 
     60FC 0106 
     60FE 0204 
     6100 0020 
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
0032 6102 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6104 000E 
     6106 0106 
     6108 00F4 
     610A 0028 
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
0058 610C 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     610E 003F 
     6110 0240 
     6112 03F4 
     6114 0050 
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
0084 6116 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6118 003F 
     611A 0240 
     611C 03F4 
     611E 0050 
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
0013 6120 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6122 16FD             data  >16fd                 ; |         jne   mcloop
0015 6124 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6126 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6128 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 612A C0F9  30 popr3   mov   *stack+,r3
0039 612C C0B9  30 popr2   mov   *stack+,r2
0040 612E C079  30 popr1   mov   *stack+,r1
0041 6130 C039  30 popr0   mov   *stack+,r0
0042 6132 C2F9  30 poprt   mov   *stack+,r11
0043 6134 045B  20         b     *r11
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
0067 6136 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6138 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 613A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 613C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 613E 1604  14         jne   filchk                ; No, continue checking
0075               
0076 6140 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6142 FFCE 
0077 6144 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6146 604C 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 6148 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     614A 830B 
     614C 830A 
0082               
0083 614E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     6150 0001 
0084 6152 1602  14         jne   filchk2
0085 6154 DD05  32         movb  tmp1,*tmp0+
0086 6156 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 6158 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     615A 0002 
0091 615C 1603  14         jne   filchk3
0092 615E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 6160 DD05  32         movb  tmp1,*tmp0+
0094 6162 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 6164 C1C4  18 filchk3 mov   tmp0,tmp3
0099 6166 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6168 0001 
0100 616A 1605  14         jne   fil16b
0101 616C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 616E 0606  14         dec   tmp2
0103 6170 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6172 0002 
0104 6174 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 6176 C1C6  18 fil16b  mov   tmp2,tmp3
0109 6178 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     617A 0001 
0110 617C 1301  14         jeq   dofill
0111 617E 0606  14         dec   tmp2                  ; Make TMP2 even
0112 6180 CD05  34 dofill  mov   tmp1,*tmp0+
0113 6182 0646  14         dect  tmp2
0114 6184 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 6186 C1C7  18         mov   tmp3,tmp3
0119 6188 1301  14         jeq   fil.$$
0120 618A DD05  32         movb  tmp1,*tmp0+
0121 618C 045B  20 fil.$$  b     *r11
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
0140 618E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 6190 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 6192 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6194 0264  22 xfilv   ori   tmp0,>4000
     6196 4000 
0147 6198 06C4  14         swpb  tmp0
0148 619A D804  38         movb  tmp0,@vdpa
     619C 8C02 
0149 619E 06C4  14         swpb  tmp0
0150 61A0 D804  38         movb  tmp0,@vdpa
     61A2 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 61A4 020F  20         li    r15,vdpw              ; Set VDP write address
     61A6 8C00 
0155 61A8 06C5  14         swpb  tmp1
0156 61AA C820  54         mov   @filzz,@mcloop        ; Setup move command
     61AC 61B4 
     61AE 8320 
0157 61B0 0460  28         b     @mcloop               ; Write data to VDP
     61B2 8320 
0158               *--------------------------------------------------------------
0162 61B4 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 61B6 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     61B8 4000 
0183 61BA 06C4  14 vdra    swpb  tmp0
0184 61BC D804  38         movb  tmp0,@vdpa
     61BE 8C02 
0185 61C0 06C4  14         swpb  tmp0
0186 61C2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     61C4 8C02 
0187 61C6 045B  20         b     *r11                  ; Exit
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
0198 61C8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 61CA C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 61CC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     61CE 4000 
0204 61D0 06C4  14         swpb  tmp0                  ; \
0205 61D2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     61D4 8C02 
0206 61D6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 61D8 D804  38         movb  tmp0,@vdpa            ; /
     61DA 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 61DC 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 61DE D7C5  30         movb  tmp1,*r15             ; Write byte
0213 61E0 045B  20         b     *r11                  ; Exit
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
0232 61E2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 61E4 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 61E6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     61E8 8C02 
0238 61EA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 61EC D804  38         movb  tmp0,@vdpa            ; /
     61EE 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 61F0 D120  34         movb  @vdpr,tmp0            ; Read byte
     61F2 8800 
0244 61F4 0984  56         srl   tmp0,8                ; Right align
0245 61F6 045B  20         b     *r11                  ; Exit
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
0264 61F8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 61FA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 61FC C144  18         mov   tmp0,tmp1
0270 61FE 05C5  14         inct  tmp1
0271 6200 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 6202 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6204 FF00 
0273 6206 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 6208 C805  38         mov   tmp1,@wbase           ; Store calculated base
     620A 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 620C 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     620E 8000 
0279 6210 0206  20         li    tmp2,8
     6212 0008 
0280 6214 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6216 830B 
0281 6218 06C5  14         swpb  tmp1
0282 621A D805  38         movb  tmp1,@vdpa
     621C 8C02 
0283 621E 06C5  14         swpb  tmp1
0284 6220 D805  38         movb  tmp1,@vdpa
     6222 8C02 
0285 6224 0225  22         ai    tmp1,>0100
     6226 0100 
0286 6228 0606  14         dec   tmp2
0287 622A 16F4  14         jne   vidta1                ; Next register
0288 622C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     622E 833A 
0289 6230 045B  20         b     *r11
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
0306 6232 C13B  30 putvr   mov   *r11+,tmp0
0307 6234 0264  22 putvrx  ori   tmp0,>8000
     6236 8000 
0308 6238 06C4  14         swpb  tmp0
0309 623A D804  38         movb  tmp0,@vdpa
     623C 8C02 
0310 623E 06C4  14         swpb  tmp0
0311 6240 D804  38         movb  tmp0,@vdpa
     6242 8C02 
0312 6244 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 6246 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 6248 C10E  18         mov   r14,tmp0
0322 624A 0984  56         srl   tmp0,8
0323 624C 06A0  32         bl    @putvrx               ; Write VR#0
     624E 6234 
0324 6250 0204  20         li    tmp0,>0100
     6252 0100 
0325 6254 D820  54         movb  @r14lb,@tmp0lb
     6256 831D 
     6258 8309 
0326 625A 06A0  32         bl    @putvrx               ; Write VR#1
     625C 6234 
0327 625E 0458  20         b     *tmp4                 ; Exit
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
0341 6260 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 6262 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 6264 C11B  26         mov   *r11,tmp0             ; Get P0
0344 6266 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6268 7FFF 
0345 626A 2120  38         coc   @wbit0,tmp0
     626C 6046 
0346 626E 1604  14         jne   ldfnt1
0347 6270 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6272 8000 
0348 6274 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6276 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 6278 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     627A 62E2 
0353 627C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     627E 9C02 
0354 6280 06C4  14         swpb  tmp0
0355 6282 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6284 9C02 
0356 6286 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6288 9800 
0357 628A 06C5  14         swpb  tmp1
0358 628C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     628E 9800 
0359 6290 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 6292 D805  38         movb  tmp1,@grmwa
     6294 9C02 
0364 6296 06C5  14         swpb  tmp1
0365 6298 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     629A 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 629C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 629E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     62A0 61B6 
0371 62A2 05C8  14         inct  tmp4                  ; R11=R11+2
0372 62A4 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 62A6 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     62A8 7FFF 
0374 62AA C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     62AC 62E4 
0375 62AE C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     62B0 62E6 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 62B2 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 62B4 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 62B6 D120  34         movb  @grmrd,tmp0
     62B8 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 62BA 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     62BC 6046 
0386 62BE 1603  14         jne   ldfnt3                ; No, so skip
0387 62C0 D1C4  18         movb  tmp0,tmp3
0388 62C2 0917  56         srl   tmp3,1
0389 62C4 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 62C6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     62C8 8C00 
0394 62CA 0606  14         dec   tmp2
0395 62CC 16F2  14         jne   ldfnt2
0396 62CE 05C8  14         inct  tmp4                  ; R11=R11+2
0397 62D0 020F  20         li    r15,vdpw              ; Set VDP write address
     62D2 8C00 
0398 62D4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     62D6 7FFF 
0399 62D8 0458  20         b     *tmp4                 ; Exit
0400 62DA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     62DC 6026 
     62DE 8C00 
0401 62E0 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 62E2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     62E4 0200 
     62E6 0000 
0406 62E8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     62EA 01C0 
     62EC 0101 
0407 62EE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     62F0 02A0 
     62F2 0101 
0408 62F4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     62F6 00E0 
     62F8 0101 
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
0426 62FA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 62FC C3A0  34         mov   @wyx,r14              ; Get YX
     62FE 832A 
0428 6300 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 6302 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6304 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 6306 C3A0  34         mov   @wyx,r14              ; Get YX
     6308 832A 
0435 630A 024E  22         andi  r14,>00ff             ; Remove Y
     630C 00FF 
0436 630E A3CE  18         a     r14,r15               ; pos = pos + X
0437 6310 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6312 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6314 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 6316 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6318 020F  20         li    r15,vdpw              ; VDP write address
     631A 8C00 
0444 631C 045B  20         b     *r11
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
0459 631E C17B  30 putstr  mov   *r11+,tmp1
0460 6320 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 6322 C1CB  18 xutstr  mov   r11,tmp3
0462 6324 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6326 62FA 
0463 6328 C2C7  18         mov   tmp3,r11
0464 632A 0986  56         srl   tmp2,8                ; Right justify length byte
0465 632C 0460  28         b     @xpym2v               ; Display string
     632E 633E 
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
0480 6330 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6332 832A 
0481 6334 0460  28         b     @putstr
     6336 631E 
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
0020 6338 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 633A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 633C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 633E 0264  22 xpym2v  ori   tmp0,>4000
     6340 4000 
0027 6342 06C4  14         swpb  tmp0
0028 6344 D804  38         movb  tmp0,@vdpa
     6346 8C02 
0029 6348 06C4  14         swpb  tmp0
0030 634A D804  38         movb  tmp0,@vdpa
     634C 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 634E 020F  20         li    r15,vdpw              ; Set VDP write address
     6350 8C00 
0035 6352 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6354 635C 
     6356 8320 
0036 6358 0460  28         b     @mcloop               ; Write data to VDP
     635A 8320 
0037 635C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 635E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6360 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6362 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6364 06C4  14 xpyv2m  swpb  tmp0
0027 6366 D804  38         movb  tmp0,@vdpa
     6368 8C02 
0028 636A 06C4  14         swpb  tmp0
0029 636C D804  38         movb  tmp0,@vdpa
     636E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6370 020F  20         li    r15,vdpr              ; Set VDP read address
     6372 8800 
0034 6374 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6376 637E 
     6378 8320 
0035 637A 0460  28         b     @mcloop               ; Read data from VDP
     637C 8320 
0036 637E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6380 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6382 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6384 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6386 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6388 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 638A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     638C FFCE 
0034 638E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6390 604C 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6392 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6394 0001 
0039 6396 1603  14         jne   cpym0                 ; No, continue checking
0040 6398 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 639A 04C6  14         clr   tmp2                  ; Reset counter
0042 639C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 639E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     63A0 7FFF 
0047 63A2 C1C4  18         mov   tmp0,tmp3
0048 63A4 0247  22         andi  tmp3,1
     63A6 0001 
0049 63A8 1618  14         jne   cpyodd                ; Odd source address handling
0050 63AA C1C5  18 cpym1   mov   tmp1,tmp3
0051 63AC 0247  22         andi  tmp3,1
     63AE 0001 
0052 63B0 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 63B2 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     63B4 6046 
0057 63B6 1605  14         jne   cpym3
0058 63B8 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     63BA 63E0 
     63BC 8320 
0059 63BE 0460  28         b     @mcloop               ; Copy memory and exit
     63C0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 63C2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 63C4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     63C6 0001 
0065 63C8 1301  14         jeq   cpym4
0066 63CA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 63CC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 63CE 0646  14         dect  tmp2
0069 63D0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 63D2 C1C7  18         mov   tmp3,tmp3
0074 63D4 1301  14         jeq   cpymz
0075 63D6 D554  38         movb  *tmp0,*tmp1
0076 63D8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 63DA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     63DC 8000 
0081 63DE 10E9  14         jmp   cpym2
0082 63E0 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 63E2 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 63E4 0649  14         dect  stack
0065 63E6 C64B  30         mov   r11,*stack            ; Push return address
0066 63E8 0649  14         dect  stack
0067 63EA C640  30         mov   r0,*stack             ; Push r0
0068 63EC 0649  14         dect  stack
0069 63EE C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 63F0 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 63F2 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 63F4 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     63F6 4000 
0077 63F8 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     63FA 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 63FC 020C  20         li    r12,>1e00             ; SAMS CRU address
     63FE 1E00 
0082 6400 04C0  14         clr   r0
0083 6402 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 6404 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 6406 D100  18         movb  r0,tmp0
0086 6408 0984  56         srl   tmp0,8                ; Right align
0087 640A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     640C 833C 
0088 640E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6410 C339  30         mov   *stack+,r12           ; Pop r12
0094 6412 C039  30         mov   *stack+,r0            ; Pop r0
0095 6414 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6416 045B  20         b     *r11                  ; Return to caller
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
0131 6418 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 641A C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 641C 0649  14         dect  stack
0135 641E C64B  30         mov   r11,*stack            ; Push return address
0136 6420 0649  14         dect  stack
0137 6422 C640  30         mov   r0,*stack             ; Push r0
0138 6424 0649  14         dect  stack
0139 6426 C64C  30         mov   r12,*stack            ; Push r12
0140 6428 0649  14         dect  stack
0141 642A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 642C 0649  14         dect  stack
0143 642E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6430 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 6432 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 6434 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6436 001E 
0153 6438 150A  14         jgt   !
0154 643A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     643C 0004 
0155 643E 1107  14         jlt   !
0156 6440 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     6442 0012 
0157 6444 1508  14         jgt   sams.page.set.switch_page
0158 6446 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6448 0006 
0159 644A 1501  14         jgt   !
0160 644C 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 644E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6450 FFCE 
0165 6452 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6454 604C 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 6456 020C  20         li    r12,>1e00             ; SAMS CRU address
     6458 1E00 
0171 645A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 645C 06C0  14         swpb  r0                    ; LSB to MSB
0173 645E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 6460 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6462 4000 
0175 6464 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 6466 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 6468 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 646A C339  30         mov   *stack+,r12           ; Pop r12
0183 646C C039  30         mov   *stack+,r0            ; Pop r0
0184 646E C2F9  30         mov   *stack+,r11           ; Pop return address
0185 6470 045B  20         b     *r11                  ; Return to caller
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
0199 6472 020C  20         li    r12,>1e00             ; SAMS CRU address
     6474 1E00 
0200 6476 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 6478 045B  20         b     *r11                  ; Return to caller
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
0222 647A 020C  20         li    r12,>1e00             ; SAMS CRU address
     647C 1E00 
0223 647E 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 6480 045B  20         b     *r11                  ; Return to caller
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
0255 6482 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 6484 0649  14         dect  stack
0258 6486 C64B  30         mov   r11,*stack            ; Save return address
0259 6488 0649  14         dect  stack
0260 648A C644  30         mov   tmp0,*stack           ; Save tmp0
0261 648C 0649  14         dect  stack
0262 648E C645  30         mov   tmp1,*stack           ; Save tmp1
0263 6490 0649  14         dect  stack
0264 6492 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 6494 0649  14         dect  stack
0266 6496 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 6498 0206  20         li    tmp2,8                ; Set loop counter
     649A 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 649C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 649E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 64A0 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     64A2 641C 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 64A4 0606  14         dec   tmp2                  ; Next iteration
0283 64A6 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 64A8 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     64AA 6472 
0289                                                   ; / activating changes.
0290               
0291 64AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 64AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 64B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 64B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 64B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 64B6 045B  20         b     *r11                  ; Return to caller
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
0313 64B8 0649  14         dect  stack
0314 64BA C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 64BC 06A0  32         bl    @sams.layout
     64BE 6482 
0319 64C0 64C6                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.exit:
0324 64C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 64C4 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 64C6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     64C8 0002 
0331 64CA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     64CC 0003 
0332 64CE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     64D0 000A 
0333 64D2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     64D4 000B 
0334 64D6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     64D8 000C 
0335 64DA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     64DC 000D 
0336 64DE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     64E0 000E 
0337 64E2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     64E4 000F 
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
0009 64E6 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     64E8 FFBF 
0010 64EA 0460  28         b     @putv01
     64EC 6246 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 64EE 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     64F0 0040 
0018 64F2 0460  28         b     @putv01
     64F4 6246 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 64F6 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     64F8 FFDF 
0026 64FA 0460  28         b     @putv01
     64FC 6246 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 64FE 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6500 0020 
0034 6502 0460  28         b     @putv01
     6504 6246 
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
0010 6506 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6508 FFFE 
0011 650A 0460  28         b     @putv01
     650C 6246 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 650E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6510 0001 
0019 6512 0460  28         b     @putv01
     6514 6246 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6516 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6518 FFFD 
0027 651A 0460  28         b     @putv01
     651C 6246 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 651E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6520 0002 
0035 6522 0460  28         b     @putv01
     6524 6246 
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
0018 6526 C83B  50 at      mov   *r11+,@wyx
     6528 832A 
0019 652A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 652C B820  54 down    ab    @hb$01,@wyx
     652E 6038 
     6530 832A 
0028 6532 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6534 7820  54 up      sb    @hb$01,@wyx
     6536 6038 
     6538 832A 
0037 653A 045B  20         b     *r11
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
0049 653C C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 653E D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6540 832A 
0051 6542 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6544 832A 
0052 6546 045B  20         b     *r11
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
0021 6548 C120  34 yx2px   mov   @wyx,tmp0
     654A 832A 
0022 654C C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 654E 06C4  14         swpb  tmp0                  ; Y<->X
0024 6550 04C5  14         clr   tmp1                  ; Clear before copy
0025 6552 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6554 20A0  38         coc   @wbit1,config         ; f18a present ?
     6556 6044 
0030 6558 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 655A 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     655C 833A 
     655E 6588 
0032 6560 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6562 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6564 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6566 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6568 0500 
0037 656A 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 656C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 656E 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6570 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6572 D105  18         movb  tmp1,tmp0
0051 6574 06C4  14         swpb  tmp0                  ; X<->Y
0052 6576 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6578 6046 
0053 657A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 657C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     657E 6038 
0059 6580 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6582 604A 
0060 6584 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6586 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6588 0050            data   80
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
0013 658A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 658C 06A0  32         bl    @putvr                ; Write once
     658E 6232 
0015 6590 391C             data  >391c                 ; VR1/57, value 00011100
0016 6592 06A0  32         bl    @putvr                ; Write twice
     6594 6232 
0017 6596 391C             data  >391c                 ; VR1/57, value 00011100
0018 6598 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 659A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 659C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     659E 6232 
0028 65A0 391C             data  >391c
0029 65A2 0458  20         b     *tmp4                 ; Exit
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
0040 65A4 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 65A6 06A0  32         bl    @cpym2v
     65A8 6338 
0042 65AA 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     65AC 65E8 
     65AE 0006 
0043 65B0 06A0  32         bl    @putvr
     65B2 6232 
0044 65B4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 65B6 06A0  32         bl    @putvr
     65B8 6232 
0046 65BA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 65BC 0204  20         li    tmp0,>3f00
     65BE 3F00 
0052 65C0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     65C2 61BA 
0053 65C4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     65C6 8800 
0054 65C8 0984  56         srl   tmp0,8
0055 65CA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     65CC 8800 
0056 65CE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 65D0 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 65D2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     65D4 BFFF 
0060 65D6 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 65D8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     65DA 4000 
0063               f18chk_exit:
0064 65DC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     65DE 618E 
0065 65E0 3F00             data  >3f00,>00,6
     65E2 0000 
     65E4 0006 
0066 65E6 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 65E8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 65EA 3F00             data  >3f00                 ; 3f02 / 3f00
0073 65EC 0340             data  >0340                 ; 3f04   0340  idle
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
0092 65EE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 65F0 06A0  32         bl    @putvr
     65F2 6232 
0097 65F4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 65F6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     65F8 6232 
0100 65FA 391C             data  >391c                 ; Lock the F18a
0101 65FC 0458  20         b     *tmp4                 ; Exit
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
0120 65FE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 6600 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6602 6044 
0122 6604 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6606 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6608 8802 
0127 660A 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     660C 6232 
0128 660E 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6610 04C4  14         clr   tmp0
0130 6612 D120  34         movb  @vdps,tmp0
     6614 8802 
0131 6616 0984  56         srl   tmp0,8
0132 6618 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 661A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     661C 832A 
0018 661E D17B  28         movb  *r11+,tmp1
0019 6620 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6622 D1BB  28         movb  *r11+,tmp2
0021 6624 0986  56         srl   tmp2,8                ; Repeat count
0022 6626 C1CB  18         mov   r11,tmp3
0023 6628 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     662A 62FA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 662C 020B  20         li    r11,hchar1
     662E 6634 
0028 6630 0460  28         b     @xfilv                ; Draw
     6632 6194 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6634 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6636 6048 
0033 6638 1302  14         jeq   hchar2                ; Yes, exit
0034 663A C2C7  18         mov   tmp3,r11
0035 663C 10EE  14         jmp   hchar                 ; Next one
0036 663E 05C7  14 hchar2  inct  tmp3
0037 6640 0457  20         b     *tmp3                 ; Exit
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
0016 6642 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6644 6046 
0017 6646 020C  20         li    r12,>0024
     6648 0024 
0018 664A 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     664C 66DA 
0019 664E 04C6  14         clr   tmp2
0020 6650 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6652 04CC  14         clr   r12
0025 6654 1F08  20         tb    >0008                 ; Shift-key ?
0026 6656 1302  14         jeq   realk1                ; No
0027 6658 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     665A 670A 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 665C 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 665E 1302  14         jeq   realk2                ; No
0033 6660 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6662 673A 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6664 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6666 1302  14         jeq   realk3                ; No
0039 6668 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     666A 676A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 666C 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 666E 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6670 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6672 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6674 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6676 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6678 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     667A 0006 
0052 667C 0606  14 realk5  dec   tmp2
0053 667E 020C  20         li    r12,>24               ; CRU address for P2-P4
     6680 0024 
0054 6682 06C6  14         swpb  tmp2
0055 6684 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6686 06C6  14         swpb  tmp2
0057 6688 020C  20         li    r12,6                 ; CRU read address
     668A 0006 
0058 668C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 668E 0547  14         inv   tmp3                  ;
0060 6690 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6692 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6694 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6696 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6698 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 669A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 669C 0285  22         ci    tmp1,8
     669E 0008 
0069 66A0 1AFA  14         jl    realk6
0070 66A2 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 66A4 1BEB  14         jh    realk5                ; No, next column
0072 66A6 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 66A8 C206  18 realk8  mov   tmp2,tmp4
0077 66AA 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 66AC A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 66AE A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 66B0 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 66B2 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 66B4 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 66B6 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     66B8 6046 
0087 66BA 1608  14         jne   realka                ; No, continue saving key
0088 66BC 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     66BE 6704 
0089 66C0 1A05  14         jl    realka
0090 66C2 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     66C4 6702 
0091 66C6 1B02  14         jh    realka                ; No, continue
0092 66C8 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     66CA E000 
0093 66CC C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     66CE 833C 
0094 66D0 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     66D2 6030 
0095 66D4 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     66D6 8C00 
0096 66D8 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 66DA FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     66DC 0000 
     66DE FF0D 
     66E0 203D 
0099 66E2 ....             text  'xws29ol.'
0100 66EA ....             text  'ced38ik,'
0101 66F2 ....             text  'vrf47ujm'
0102 66FA ....             text  'btg56yhn'
0103 6702 ....             text  'zqa10p;/'
0104 670A FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     670C 0000 
     670E FF0D 
     6710 202B 
0105 6712 ....             text  'XWS@(OL>'
0106 671A ....             text  'CED#*IK<'
0107 6722 ....             text  'VRF$&UJM'
0108 672A ....             text  'BTG%^YHN'
0109 6732 ....             text  'ZQA!)P:-'
0110 673A FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     673C 0000 
     673E FF0D 
     6740 2005 
0111 6742 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6744 0804 
     6746 0F27 
     6748 C2B9 
0112 674A 600B             data  >600b,>0907,>063f,>c1B8
     674C 0907 
     674E 063F 
     6750 C1B8 
0113 6752 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6754 7B02 
     6756 015F 
     6758 C0C3 
0114 675A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     675C 7D0E 
     675E 0CC6 
     6760 BFC4 
0115 6762 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6764 7C03 
     6766 BC22 
     6768 BDBA 
0116 676A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     676C 0000 
     676E FF0D 
     6770 209D 
0117 6772 9897             data  >9897,>93b2,>9f8f,>8c9B
     6774 93B2 
     6776 9F8F 
     6778 8C9B 
0118 677A 8385             data  >8385,>84b3,>9e89,>8b80
     677C 84B3 
     677E 9E89 
     6780 8B80 
0119 6782 9692             data  >9692,>86b4,>b795,>8a8D
     6784 86B4 
     6786 B795 
     6788 8A8D 
0120 678A 8294             data  >8294,>87b5,>b698,>888E
     678C 87B5 
     678E B698 
     6790 888E 
0121 6792 9A91             data  >9a91,>81b1,>b090,>9cBB
     6794 81B1 
     6796 B090 
     6798 9CBB 
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
0023 679A C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 679C C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     679E 8340 
0025 67A0 04E0  34         clr   @waux1
     67A2 833C 
0026 67A4 04E0  34         clr   @waux2
     67A6 833E 
0027 67A8 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     67AA 833C 
0028 67AC C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 67AE 0205  20         li    tmp1,4                ; 4 nibbles
     67B0 0004 
0033 67B2 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 67B4 0246  22         andi  tmp2,>000f            ; Only keep LSN
     67B6 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 67B8 0286  22         ci    tmp2,>000a
     67BA 000A 
0039 67BC 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 67BE C21B  26         mov   *r11,tmp4
0045 67C0 0988  56         srl   tmp4,8                ; Right justify
0046 67C2 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     67C4 FFF6 
0047 67C6 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 67C8 C21B  26         mov   *r11,tmp4
0054 67CA 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     67CC 00FF 
0055               
0056 67CE A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 67D0 06C6  14         swpb  tmp2
0058 67D2 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 67D4 0944  56         srl   tmp0,4                ; Next nibble
0060 67D6 0605  14         dec   tmp1
0061 67D8 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 67DA 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     67DC BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 67DE C160  34         mov   @waux3,tmp1           ; Get pointer
     67E0 8340 
0067 67E2 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 67E4 0585  14         inc   tmp1                  ; Next byte, not word!
0069 67E6 C120  34         mov   @waux2,tmp0
     67E8 833E 
0070 67EA 06C4  14         swpb  tmp0
0071 67EC DD44  32         movb  tmp0,*tmp1+
0072 67EE 06C4  14         swpb  tmp0
0073 67F0 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 67F2 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     67F4 8340 
0078 67F6 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     67F8 603C 
0079 67FA 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 67FC C120  34         mov   @waux1,tmp0
     67FE 833C 
0084 6800 06C4  14         swpb  tmp0
0085 6802 DD44  32         movb  tmp0,*tmp1+
0086 6804 06C4  14         swpb  tmp0
0087 6806 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6808 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     680A 6046 
0092 680C 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 680E 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6810 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6812 7FFF 
0098 6814 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6816 8340 
0099 6818 0460  28         b     @xutst0               ; Display string
     681A 6320 
0100 681C 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 681E C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6820 832A 
0122 6822 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6824 8000 
0123 6826 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6828 0207  20 mknum   li    tmp3,5                ; Digit counter
     682A 0005 
0020 682C C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 682E C155  26         mov   *tmp1,tmp1            ; /
0022 6830 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6832 0228  22         ai    tmp4,4                ; Get end of buffer
     6834 0004 
0024 6836 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6838 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 683A 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 683C 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 683E 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6840 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6842 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6844 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6846 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6848 0607  14         dec   tmp3                  ; Decrease counter
0036 684A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 684C 0207  20         li    tmp3,4                ; Check first 4 digits
     684E 0004 
0041 6850 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6852 C11B  26         mov   *r11,tmp0
0043 6854 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6856 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6858 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 685A 05CB  14 mknum3  inct  r11
0047 685C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     685E 6046 
0048 6860 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6862 045B  20         b     *r11                  ; Exit
0050 6864 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6866 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6868 13F8  14         jeq   mknum3                ; Yes, exit
0053 686A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 686C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     686E 7FFF 
0058 6870 C10B  18         mov   r11,tmp0
0059 6872 0224  22         ai    tmp0,-4
     6874 FFFC 
0060 6876 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6878 0206  20         li    tmp2,>0500            ; String length = 5
     687A 0500 
0062 687C 0460  28         b     @xutstr               ; Display string
     687E 6322 
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
0092 6880 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6882 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6884 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6886 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6888 0207  20         li    tmp3,5                ; Set counter
     688A 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 688C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 688E 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6890 0584  14         inc   tmp0                  ; Next character
0104 6892 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6894 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6896 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6898 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 689A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 689C 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 689E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 68A0 0607  14         dec   tmp3                  ; Last character ?
0120 68A2 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 68A4 045B  20         b     *r11                  ; Return
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
0138 68A6 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     68A8 832A 
0139 68AA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     68AC 8000 
0140 68AE 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0190               
0192                       copy  "cpu_rle_compress.asm"     ; CPU RLE compression support
**** **** ****     > cpu_rle_compress.asm
0001               * FILE......: cpu_rle_compress.asm
0002               * Purpose...: RLE compression support
0003               
0004               ***************************************************************
0005               * cpu2rle - RLE compress CPU memory
0006               ***************************************************************
0007               *  bl   @cpu2rle
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = ROM/RAM source address
0011               *  P1 = RAM target address
0012               *  P2 = Length uncompressed data
0013               *
0014               *  Output:
0015               *  waux1 = Length of RLE encoded string
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu2rle
0018               *
0019               *  TMP0  = ROM/RAM source address
0020               *  TMP1  = RAM target address
0021               *  TMP2  = Length uncompressed data
0022               *
0023               *  Output:
0024               *  waux1 = Length of RLE encoded string
0025               *--------------------------------------------------------------
0026               *  Memory usage:
0027               *  tmp0, tmp1, tmp2, tmp3, tmp4
0028               *  waux1, waux2, waux3
0029               *--------------------------------------------------------------
0030               *  Detail on RLE compression format:
0031               *  - If high bit is set, remaining 7 bits indicate to copy
0032               *    the next byte that many times.
0033               *  - If high bit is clear, remaining 7 bits indicate how many
0034               *    data bytes (non-repeated) follow.
0035               *
0036               *  Part of string is considered for RLE compression as soon as
0037               *  the same char is repeated 3 times.
0038               *
0039               *  Implementation workflow:
0040               *  (1) Scan string from left to right:
0041               *      (1.1) Compare lookahead char with current char.
0042               *            - Jump to (1.2) if it's not a repeated character.
0043               *            - If repeated char count = 0 then check 2nd lookahead
0044               *              char. If it's a repeated char again then jump to (1.3)
0045               *              else handle as non-repeated char (1.2)
0046               *            - If repeated char count > 0 then handle as repeated char (1.3)
0047               *
0048               *      (1.2) It's not a repeated character:
0049               *            (1.2.1) Check if any pending repeated character
0050               *            (1.2.2) If yes, flush pending to output buffer (=RLE encode)
0051               *            (1.2.3) Track address of future encoding byte
0052               *            (1.2.4) Append data byte to output buffer and jump to (2)
0053               *
0054               *      (1.3) It's a repeated character:
0055               *            (1.3.1) Check if any pending non-repeated character
0056               *            (1.3.2) If yes, set encoding byte before first data byte
0057               *            (1.3.3) Increase repetition counter and jump to (2)
0058               *
0059               *  (2) Process next character
0060               *      (2.1) Jump back to (1.1) unless end of string reached
0061               *
0062               *  (3) End of string reached:
0063               *      (3.1) Check if pending repeated character
0064               *      (3.2) If yes, flush pending to output buffer (=RLE encode)
0065               *      (3.3) Check if pending non-repeated character
0066               *      (3.4) If yes, set encoding byte before first data byte
0067               *
0068               *  (4) Exit
0069               *--------------------------------------------------------------
0070               
0071               
0072               ********|*****|*********************|**************************
0073               cpu2rle:
0074 68B0 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 68B2 C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 68B4 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 68B6 0649  14         dect  stack
0079 68B8 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 68BA 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 68BC 04C8  14         clr   tmp4                  ; Repeat counter
0086 68BE 04E0  34         clr   @waux1                ; Length of RLE string
     68C0 833C 
0087 68C2 04E0  34         clr   @waux2                ; Address of encoding byte
     68C4 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 68C6 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 68C8 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 68CA 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 68CC 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 68CE C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 68D0 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 68D2 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     68D4 0001 
0105 68D6 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 68D8 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 68DA C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 68DC 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 68DE 06A0  32         bl    @cpu2rle.flush.duplicates
     68E0 692A 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 68E2 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     68E4 833E 
     68E6 833E 
0126 68E8 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 68EA C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     68EC 833E 
0129 68EE 0585  14         inc   tmp1                  ; Skip encoding byte
0130 68F0 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     68F2 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 68F4 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 68F6 05A0  34         inc   @waux1                ; RLE string length += 1
     68F8 833C 
0136 68FA 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 68FC C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     68FE 833E 
     6900 833E 
0145 6902 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 6904 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6906 6944 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 6908 0588  14         inc   tmp4                  ; Increase repeat counter
0155 690A 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 690C 0606  14         dec   tmp2
0162 690E 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 6910 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 6912 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 6914 06A0  32         bl    @cpu2rle.flush.duplicates
     6916 692A 
0175                                                   ; (3.2) Flush pending ...
0176 6918 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 691A C820  54         mov   @waux2,@waux2
     691C 833E 
     691E 833E 
0182 6920 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 6922 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6924 6944 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 6926 0460  28         b     @poprt                ; Return
     6928 6132 
0192               
0193               
0194               
0195               
0196               *****************************************************************
0197               * Helper routines called internally
0198               *****************************************************************
0199               
0200               *--------------------------------------------------------------
0201               * Flush duplicate to output buffer (=RLE encode)
0202               *--------------------------------------------------------------
0203               cpu2rle.flush.duplicates:
0204 692A 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 692C D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 692E 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 6930 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     6932 8000 
0210 6934 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 6936 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6938 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 693A 05E0  34         inct  @waux1                ; RLE string length += 2
     693C 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 693E 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 6940 04C8  14         clr   tmp4                  ; Clear repeat count
0220 6942 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 6944 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 6946 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6948 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 694A 61E0  34         s     @waux2,tmp3           ; | characters
     694C 833E 
0232 694E 0607  14         dec   tmp3                  ; /
0233               
0234 6950 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 6952 C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     6954 833E 
0236 6956 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6958 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 695A 04E0  34         clr   @waux2                ; Reset address of encoding byte
     695C 833E 
0240 695E 04C8  14         clr   tmp4                  ; Clear before exit
0241 6960 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0194               
0196                       copy  "cpu_rle_decompress.asm"   ; CPU RLE decompression support
**** **** ****     > cpu_rle_decompress.asm
0001               * FILE......: cpu_rle_decompress.asm
0002               * Purpose...: RLE decompression support
0003               
0004               
0005               ***************************************************************
0006               * rl2cpu - RLE decompress to CPU memory
0007               ***************************************************************
0008               *  bl   @rle2cpu
0009               *       data P0,P1,P2
0010               *--------------------------------------------------------------
0011               *  P0 = ROM/RAM source address
0012               *  P1 = RAM target address
0013               *  P2 = Length of RLE encoded data
0014               *--------------------------------------------------------------
0015               *  bl   @xrle2cpu
0016               
0017               *  TMP0 = ROM/RAM source address
0018               *  TMP1 = RAM target address
0019               *  TMP2 = Length of RLE encoded data
0020               *--------------------------------------------------------------
0021               *  Detail on RLE compression format:
0022               *  - If high bit is set, remaining 7 bits indicate to copy
0023               *    the next byte that many times.
0024               *  - If high bit is clear, remaining 7 bits indicate how many
0025               *    data bytes (non-repeated) follow.
0026               *--------------------------------------------------------------
0027               
0028               
0029               ********|*****|*********************|**************************
0030               rle2cpu:
0031 6962 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 6964 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6966 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6968 0649  14         dect  stack
0036 696A C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 696C D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 696E 0606  14         dec   tmp2                  ; Update length
0043 6970 131E  14         jeq   rle2cpu.exit          ; End of list
0044 6972 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 6974 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6976 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6978 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 697A 0649  14         dect  stack
0055 697C C646  30         mov   tmp2,*stack           ; Push tmp2
0056 697E C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 6980 06A0  32         bl    @xpym2m               ; Block copy to destination
     6982 6386 
0059                                                   ; \ i  tmp0 = Source address
0060                                                   ; | i  tmp1 = Target address
0061                                                   ; / i  tmp2 = Bytes to copy
0062               
0063 6984 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6986 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6988 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 698A 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 698C 0649  14         dect  stack
0073 698E C645  30         mov   tmp1,*stack           ; Push tmp1
0074 6990 0649  14         dect  stack
0075 6992 C646  30         mov   tmp2,*stack           ; Push tmp2
0076 6994 0649  14         dect  stack
0077 6996 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6998 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 699A D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 699C 0985  56         srl   tmp1,8                ; Right align
0082               
0083 699E 06A0  32         bl    @xfilm                ; Block fill to destination
     69A0 613C 
0084                                                   ; \ i  tmp0 = Target address
0085                                                   ; | i  tmp1 = Byte to fill
0086                                                   ; / i  tmp2 = Repeat count
0087               
0088 69A2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 69A4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 69A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 69A8 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 69AA C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 69AC 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 69AE 0460  28         b     @poprt                ; Return
     69B0 6132 
**** **** ****     > runlib.asm
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
0020 69B2 C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     69B4 2000 
0021 69B6 C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     69B8 2002 
0022 69BA C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     69BC 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 69BE 0200  20         li    r0,>8306              ; Scratpad source address
     69C0 8306 
0027 69C2 0201  20         li    r1,>2006              ; RAM target address
     69C4 2006 
0028 69C6 0202  20         li    r2,62                 ; Loop counter
     69C8 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 69CA CC70  46         mov   *r0+,*r1+
0034 69CC CC70  46         mov   *r0+,*r1+
0035 69CE 0642  14         dect  r2
0036 69D0 16FC  14         jne   cpu.scrpad.backup.copy
0037 69D2 C820  54         mov   @>83fe,@>20fe         ; Copy last word
     69D4 83FE 
     69D6 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 69D8 C020  34         mov   @>2000,r0             ; Restore r0
     69DA 2000 
0042 69DC C060  34         mov   @>2002,r1             ; Restore r1
     69DE 2002 
0043 69E0 C0A0  34         mov   @>2004,r2             ; Restore r2
     69E2 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 69E4 045B  20         b     *r11                  ; Return to caller
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
0066 69E6 C820  54         mov   @>2000,@>8300
     69E8 2000 
     69EA 8300 
0067 69EC C820  54         mov   @>2002,@>8302
     69EE 2002 
     69F0 8302 
0068 69F2 C820  54         mov   @>2004,@>8304
     69F4 2004 
     69F6 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 69F8 C800  38         mov   r0,@>2000
     69FA 2000 
0073 69FC C801  38         mov   r1,@>2002
     69FE 2002 
0074 6A00 C802  38         mov   r2,@>2004
     6A02 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 6A04 0200  20         li    r0,>2006
     6A06 2006 
0079 6A08 0201  20         li    r1,>8306
     6A0A 8306 
0080 6A0C 0202  20         li    r2,62
     6A0E 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 6A10 CC70  46         mov   *r0+,*r1+
0086 6A12 CC70  46         mov   *r0+,*r1+
0087 6A14 0642  14         dect  r2
0088 6A16 16FC  14         jne   cpu.scrpad.restore.copy
0089 6A18 C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6A1A 20FE 
     6A1C 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 6A1E C020  34         mov   @>2000,r0             ; Restore r0
     6A20 2000 
0094 6A22 C060  34         mov   @>2002,r1             ; Restore r1
     6A24 2002 
0095 6A26 C0A0  34         mov   @>2004,r2             ; Restore r2
     6A28 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6A2A 045B  20         b     *r11                  ; Return to caller
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
0025 6A2C C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 6A2E 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6A30 8300 
0031 6A32 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 6A34 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A36 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6A38 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6A3A 0606  14         dec   tmp2
0038 6A3C 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6A3E C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6A40 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6A42 6A48 
0044                                                   ; R14=PC
0045 6A44 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 6A46 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 6A48 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6A4A 69E6 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 6A4C 045B  20         b     *r11                  ; Return to caller
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
0078 6A4E C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 6A50 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6A52 8300 
0084 6A54 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A56 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6A58 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6A5A 0606  14         dec   tmp2
0090 6A5C 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6A5E 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6A60 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6A62 045B  20         b     *r11                  ; Return to caller
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
0041 6A64 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6A66 6A68             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6A68 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6A6A C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6A6C 8322 
0049 6A6E 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6A70 6042 
0050 6A72 C020  34         mov   @>8356,r0             ; get ptr to pab
     6A74 8356 
0051 6A76 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6A78 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6A7A FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6A7C 06C0  14         swpb  r0                    ;
0059 6A7E D800  38         movb  r0,@vdpa              ; send low byte
     6A80 8C02 
0060 6A82 06C0  14         swpb  r0                    ;
0061 6A84 D800  38         movb  r0,@vdpa              ; send high byte
     6A86 8C02 
0062 6A88 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6A8A 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6A8C 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6A8E 0704  14         seto  r4                    ; init counter
0070 6A90 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6A92 2420 
0071 6A94 0580  14 !       inc   r0                    ; point to next char of name
0072 6A96 0584  14         inc   r4                    ; incr char counter
0073 6A98 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6A9A 0007 
0074 6A9C 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6A9E 80C4  18         c     r4,r3                 ; end of name?
0077 6AA0 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6AA2 06C0  14         swpb  r0                    ;
0082 6AA4 D800  38         movb  r0,@vdpa              ; send low byte
     6AA6 8C02 
0083 6AA8 06C0  14         swpb  r0                    ;
0084 6AAA D800  38         movb  r0,@vdpa              ; send high byte
     6AAC 8C02 
0085 6AAE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6AB0 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6AB2 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6AB4 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6AB6 6B78 
0093 6AB8 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6ABA C104  18         mov   r4,r4                 ; Check if length = 0
0099 6ABC 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6ABE 04E0  34         clr   @>83d0
     6AC0 83D0 
0102 6AC2 C804  38         mov   r4,@>8354             ; save name length for search
     6AC4 8354 
0103 6AC6 0584  14         inc   r4                    ; adjust for dot
0104 6AC8 A804  38         a     r4,@>8356             ; point to position after name
     6ACA 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6ACC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6ACE 83E0 
0110 6AD0 04C1  14         clr   r1                    ; version found of dsr
0111 6AD2 020C  20         li    r12,>0f00             ; init cru addr
     6AD4 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6AD6 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6AD8 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6ADA 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6ADC 022C  22         ai    r12,>0100             ; next rom to turn on
     6ADE 0100 
0125 6AE0 04E0  34         clr   @>83d0                ; clear in case we are done
     6AE2 83D0 
0126 6AE4 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6AE6 2000 
0127 6AE8 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6AEA C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6AEC 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6AEE 1D00  20         sbo   0                     ; turn on rom
0134 6AF0 0202  20         li    r2,>4000              ; start at beginning of rom
     6AF2 4000 
0135 6AF4 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6AF6 6B74 
0136 6AF8 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6AFA A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6AFC 240A 
0146 6AFE 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6B00 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6B02 83D2 
0152 6B04 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6B06 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6B08 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6B0A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6B0C 83D2 
0161 6B0E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6B10 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6B12 04C5  14         clr   r5                    ; Remove any old stuff
0167 6B14 D160  34         movb  @>8355,r5             ; get length as counter
     6B16 8355 
0168 6B18 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6B1A 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6B1C 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6B1E 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6B20 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B22 2420 
0175 6B24 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6B26 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6B28 0605  14         dec   r5                    ; loop until full length checked
0179 6B2A 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6B2C C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6B2E 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6B30 0581  14         inc   r1                    ; next version found
0191 6B32 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6B34 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6B36 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6B38 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6B3A 2400 
0200 6B3C C009  18         mov   r9,r0                 ; point to flag in pab
0201 6B3E C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6B40 8322 
0202                                                   ; (8 or >a)
0203 6B42 0281  22         ci    r1,8                  ; was it 8?
     6B44 0008 
0204 6B46 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6B48 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6B4A 8350 
0206                                                   ; Get error byte from @>8350
0207 6B4C 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6B4E 06C0  14         swpb  r0                    ;
0215 6B50 D800  38         movb  r0,@vdpa              ; send low byte
     6B52 8C02 
0216 6B54 06C0  14         swpb  r0                    ;
0217 6B56 D800  38         movb  r0,@vdpa              ; send high byte
     6B58 8C02 
0218 6B5A D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6B5C 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6B5E 09D1  56         srl   r1,13                 ; just keep error bits
0226 6B60 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6B62 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6B64 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6B66 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6B68 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6B6A 06C1  14         swpb  r1                    ; put error in hi byte
0239 6B6C D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6B6E F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6B70 6042 
0241 6B72 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6B74 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6B76 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6B78 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6B7A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6B7C C04B  18         mov   r11,r1                ; Save return address
0049 6B7E C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B80 2428 
0050 6B82 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6B84 04C5  14         clr   tmp1                  ; io.op.open
0052 6B86 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B88 61CC 
0053               file.open_init:
0054 6B8A 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B8C 0009 
0055 6B8E C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B90 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6B92 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B94 6A64 
0061 6B96 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6B98 1029  14         jmp   file.record.pab.details
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
0090 6B9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6B9C C04B  18         mov   r11,r1                ; Save return address
0096 6B9E C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BA0 2428 
0097 6BA2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6BA4 0205  20         li    tmp1,io.op.close      ; io.op.close
     6BA6 0001 
0099 6BA8 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BAA 61CC 
0100               file.close_init:
0101 6BAC 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BAE 0009 
0102 6BB0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BB2 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6BB4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BB6 6A64 
0108 6BB8 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6BBA 1018  14         jmp   file.record.pab.details
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
0139 6BBC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6BBE C04B  18         mov   r11,r1                ; Save return address
0145 6BC0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BC2 2428 
0146 6BC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6BC6 0205  20         li    tmp1,io.op.read       ; io.op.read
     6BC8 0002 
0148 6BCA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BCC 61CC 
0149               file.record.read_init:
0150 6BCE 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BD0 0009 
0151 6BD2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BD4 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6BD6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BD8 6A64 
0157 6BDA 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6BDC 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6BDE 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6BE0 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6BE2 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6BE4 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6BE6 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6BE8 1000  14         nop
0191               
0192               
0193               file.status:
0194 6BEA 1000  14         nop
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
0211 6BEC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6BEE C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6BF0 2428 
0219 6BF2 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6BF4 0005 
0220 6BF6 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6BF8 61E4 
0221 6BFA C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6BFC C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6BFE 0451  20         b     *r1                   ; Return to caller
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
0020 6C00 0300  24 tmgr    limi  0                     ; No interrupt processing
     6C02 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6C04 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6C06 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6C08 2360  38         coc   @wbit2,r13            ; C flag on ?
     6C0A 6042 
0029 6C0C 1602  14         jne   tmgr1a                ; No, so move on
0030 6C0E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6C10 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6C12 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6C14 6046 
0035 6C16 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6C18 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6C1A 6036 
0048 6C1C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6C1E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6C20 6034 
0050 6C22 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6C24 0460  28         b     @kthread              ; Run kernel thread
     6C26 6C9E 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6C28 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6C2A 603A 
0056 6C2C 13EB  14         jeq   tmgr1
0057 6C2E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6C30 6038 
0058 6C32 16E8  14         jne   tmgr1
0059 6C34 C120  34         mov   @wtiusr,tmp0
     6C36 832E 
0060 6C38 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6C3A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6C3C 6C9C 
0065 6C3E C10A  18         mov   r10,tmp0
0066 6C40 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6C42 00FF 
0067 6C44 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6C46 6042 
0068 6C48 1303  14         jeq   tmgr5
0069 6C4A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6C4C 003C 
0070 6C4E 1002  14         jmp   tmgr6
0071 6C50 0284  22 tmgr5   ci    tmp0,50
     6C52 0032 
0072 6C54 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C56 1001  14         jmp   tmgr8
0074 6C58 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C5A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C5C 832C 
0079 6C5E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6C60 FF00 
0080 6C62 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6C64 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6C66 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6C68 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6C6A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6C6C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6C6E 830C 
     6C70 830D 
0089 6C72 1608  14         jne   tmgr10                ; No, get next slot
0090 6C74 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6C76 FF00 
0091 6C78 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6C7A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6C7C 8330 
0096 6C7E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6C80 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6C82 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6C84 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6C86 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6C88 8315 
     6C8A 8314 
0103 6C8C 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6C8E 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6C90 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6C92 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6C94 10F7  14         jmp   tmgr10                ; Process next slot
0108 6C96 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6C98 FF00 
0109 6C9A 10B4  14         jmp   tmgr1
0110 6C9C 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6C9E E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6CA0 6036 
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
0041 6CA2 06A0  32         bl    @realkb               ; Scan full keyboard
     6CA4 6642 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6CA6 0460  28         b     @tmgr3                ; Exit
     6CA8 6C28 
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
0017 6CAA C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6CAC 832E 
0018 6CAE E0A0  34         soc   @wbit7,config         ; Enable user hook
     6CB0 6038 
0019 6CB2 045B  20 mkhoo1  b     *r11                  ; Return
0020      6C04     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6CB4 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6CB6 832E 
0029 6CB8 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6CBA FEFF 
0030 6CBC 045B  20         b     *r11                  ; Return
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
0017 6CBE C13B  30 mkslot  mov   *r11+,tmp0
0018 6CC0 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6CC2 C184  18         mov   tmp0,tmp2
0023 6CC4 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6CC6 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6CC8 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6CCA CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6CCC 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6CCE C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6CD0 881B  46         c     *r11,@w$ffff          ; End of list ?
     6CD2 6048 
0035 6CD4 1301  14         jeq   mkslo1                ; Yes, exit
0036 6CD6 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6CD8 05CB  14 mkslo1  inct  r11
0041 6CDA 045B  20         b     *r11                  ; Exit
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
0052 6CDC C13B  30 clslot  mov   *r11+,tmp0
0053 6CDE 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6CE0 A120  34         a     @wtitab,tmp0          ; Add table base
     6CE2 832C 
0055 6CE4 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6CE6 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6CE8 045B  20         b     *r11                  ; Exit
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
0250 6CEA 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6CEC 69B2 
0251 6CEE 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6CF0 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6CF2 0300  24 runli1  limi  0                     ; Turn off interrupts
     6CF4 0000 
0259 6CF6 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6CF8 8300 
0260 6CFA C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6CFC 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6CFE 0202  20 runli2  li    r2,>8308
     6D00 8308 
0265 6D02 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6D04 0282  22         ci    r2,>8400
     6D06 8400 
0267 6D08 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6D0A 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6D0C FFFF 
0273 6D0E 1602  14         jne   runli4                ; No, continue
0274 6D10 0420  54         blwp  @0                    ; Yes, bye bye
     6D12 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6D14 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6D16 833C 
0279 6D18 04C1  14         clr   r1                    ; Reset counter
0280 6D1A 0202  20         li    r2,10                 ; We test 10 times
     6D1C 000A 
0281 6D1E C0E0  34 runli5  mov   @vdps,r3
     6D20 8802 
0282 6D22 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6D24 6046 
0283 6D26 1302  14         jeq   runli6
0284 6D28 0581  14         inc   r1                    ; Increase counter
0285 6D2A 10F9  14         jmp   runli5
0286 6D2C 0602  14 runli6  dec   r2                    ; Next test
0287 6D2E 16F7  14         jne   runli5
0288 6D30 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6D32 1250 
0289 6D34 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6D36 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6D38 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6D3A 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6D3C 6120 
0295 6D3E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6D40 8322 
0296 6D42 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6D44 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6D46 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6D48 04C1  14 runli9  clr   r1
0303 6D4A 04C2  14         clr   r2
0304 6D4C 04C3  14         clr   r3
0305 6D4E 0209  20         li    stack,>8400           ; Set stack
     6D50 8400 
0306 6D52 020F  20         li    r15,vdpw              ; Set VDP write address
     6D54 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6D56 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6D58 4A4A 
0315 6D5A 1605  14         jne   runlia
0316 6D5C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6D5E 618E 
0317 6D60 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6D62 0000 
     6D64 3FFF 
0322 6D66 06A0  32 runlia  bl    @filv
     6D68 618E 
0323 6D6A 0FC0             data  pctadr,spfclr,16      ; Load color table
     6D6C 00F4 
     6D6E 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6D70 06A0  32         bl    @f18unl               ; Unlock the F18A
     6D72 658A 
0331 6D74 06A0  32         bl    @f18chk               ; Check if F18A is there
     6D76 65A4 
0332 6D78 06A0  32         bl    @f18lck               ; Lock the F18A again
     6D7A 659A 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6D7C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6D7E 61F8 
0346 6D80 6116             data  spvmod                ; Equate selected video mode table
0347 6D82 0204  20         li    tmp0,spfont           ; Get font option
     6D84 000C 
0348 6D86 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6D88 1304  14         jeq   runlid                ; Yes, skip it
0350 6D8A 06A0  32         bl    @ldfnt
     6D8C 6260 
0351 6D8E 1100             data  fntadr,spfont         ; Load specified font
     6D90 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6D92 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6D94 4A4A 
0356 6D96 1602  14         jne   runlie                ; No, continue
0357 6D98 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6D9A 60A0 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6D9C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6D9E 0040 
0362 6DA0 0460  28         b     @main                 ; Give control to main program
     6DA2 6DA4 
**** **** ****     > tivi.asm.11019
0220               
0221               *--------------------------------------------------------------
0222               * Video mode configuration
0223               *--------------------------------------------------------------
0224      6116     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0225      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0226      0050     colrow  equ   80                    ; Columns per row
0227      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0228      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0229      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0230      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0231               
0232               
0233               ***************************************************************
0234               * Main
0235               ********|*****|*********************|**************************
0236 6DA4 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6DA6 6044 
0237 6DA8 1302  14         jeq   main.continue
0238 6DAA 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6DAC 0000 
0239               
0240               main.continue:
0241 6DAE 06A0  32         bl    @scroff               ; Turn screen off
     6DB0 64E6 
0242 6DB2 06A0  32         bl    @f18unl               ; Unlock the F18a
     6DB4 658A 
0243 6DB6 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6DB8 6232 
0244 6DBA 3140                   data >3140            ; F18a VR49 (>31), bit 40
0245                       ;------------------------------------------------------
0246                       ; Initialize VDP SIT
0247                       ;------------------------------------------------------
0248 6DBC 06A0  32         bl    @filv
     6DBE 618E 
0249 6DC0 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6DC2 0020 
     6DC4 09B0 
0250 6DC6 06A0  32         bl    @scron                ; Turn screen on
     6DC8 64EE 
0251                       ;------------------------------------------------------
0252                       ; Initialize low + high memory expansion
0253                       ;------------------------------------------------------
0254 6DCA 06A0  32         bl    @film
     6DCC 6136 
0255 6DCE 2200                   data >2200,00,8*1024-256*2
     6DD0 0000 
     6DD2 3E00 
0256                                                   ; Clear part of 8k low-memory
0257               
0258 6DD4 06A0  32         bl    @film
     6DD6 6136 
0259 6DD8 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6DDA 0000 
     6DDC 6000 
0260                       ;------------------------------------------------------
0261                       ; Load SAMS default memory layout
0262                       ;------------------------------------------------------
0263 6DDE 06A0  32         bl    @mem.setup.sams.layout
     6DE0 75A0 
0264                                                   ; Initialize SAMS layout
0265                       ;------------------------------------------------------
0266                       ; Setup cursor, screen, etc.
0267                       ;------------------------------------------------------
0268 6DE2 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6DE4 6506 
0269 6DE6 06A0  32         bl    @s8x8                 ; Small sprite
     6DE8 6516 
0270               
0271 6DEA 06A0  32         bl    @cpym2m
     6DEC 6380 
0272 6DEE 7B66                   data romsat,ramsat,4  ; Load sprite SAT
     6DF0 8380 
     6DF2 0004 
0273               
0274 6DF4 C820  54         mov   @romsat+2,@fb.curshape
     6DF6 7B68 
     6DF8 2210 
0275                                                   ; Save cursor shape & color
0276               
0277 6DFA 06A0  32         bl    @cpym2v
     6DFC 6338 
0278 6DFE 1800                   data sprpdt,cursors,3*8
     6E00 7B6A 
     6E02 0018 
0279                                                   ; Load sprite cursor patterns
0280               *--------------------------------------------------------------
0281               * Initialize
0282               *--------------------------------------------------------------
0283 6E04 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E06 7782 
0284 6E08 06A0  32         bl    @idx.init             ; Initialize index
     6E0A 76AA 
0285 6E0C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E0E 75CE 
0286                       ;-------------------------------------------------------
0287                       ; Setup editor tasks & hook
0288                       ;-------------------------------------------------------
0289 6E10 0204  20         li    tmp0,>0200
     6E12 0200 
0290 6E14 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6E16 8314 
0291               
0292 6E18 06A0  32         bl    @at
     6E1A 6526 
0293 6E1C 0000             data  >0000                 ; Cursor YX position = >0000
0294               
0295 6E1E 0204  20         li    tmp0,timers
     6E20 8370 
0296 6E22 C804  38         mov   tmp0,@wtitab
     6E24 832C 
0297               
0298 6E26 06A0  32         bl    @mkslot
     6E28 6CBE 
0299 6E2A 0001                   data >0001,task0      ; Task 0 - Update screen
     6E2C 741A 
0300 6E2E 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6E30 749E 
0301 6E32 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6E34 74AC 
     6E36 FFFF 
0302               
0303 6E38 06A0  32         bl    @mkhook
     6E3A 6CAA 
0304 6E3C 6E42                   data editor           ; Setup user hook
0305               
0306 6E3E 0460  28         b     @tmgr                 ; Start timers and kthread
     6E40 6C00 
0307               
0308               
0309               ****************************************************************
0310               * Editor - Main loop
0311               ****************************************************************
0312 6E42 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6E44 6030 
0313 6E46 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0314               *---------------------------------------------------------------
0315               * Identical key pressed ?
0316               *---------------------------------------------------------------
0317 6E48 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6E4A 6030 
0318 6E4C 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6E4E 833C 
     6E50 833E 
0319 6E52 1308  14         jeq   ed_wait
0320               *--------------------------------------------------------------
0321               * New key pressed
0322               *--------------------------------------------------------------
0323               ed_new_key
0324 6E54 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6E56 833C 
     6E58 833E 
0325 6E5A 1045  14         jmp   edkey                 ; Process key
0326               *--------------------------------------------------------------
0327               * Clear keyboard buffer if no key pressed
0328               *--------------------------------------------------------------
0329               ed_clear_kbbuffer
0330 6E5C 04E0  34         clr   @waux1
     6E5E 833C 
0331 6E60 04E0  34         clr   @waux2
     6E62 833E 
0332               *--------------------------------------------------------------
0333               * Delay to avoid key bouncing
0334               *--------------------------------------------------------------
0335               ed_wait
0336 6E64 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6E66 0708 
0337                       ;------------------------------------------------------
0338                       ; Delay loop
0339                       ;------------------------------------------------------
0340               ed_wait_loop
0341 6E68 0604  14         dec   tmp0
0342 6E6A 16FE  14         jne   ed_wait_loop
0343               *--------------------------------------------------------------
0344               * Exit
0345               *--------------------------------------------------------------
0346 6E6C 0460  28 ed_exit b     @hookok               ; Return
     6E6E 6C04 
0347               
0348               
0349               
0350               
0351               
0352               
0353               ***************************************************************
0354               *                Tivi - Editor keyboard actions
0355               ***************************************************************
0356                       copy  "editorkeys_init.asm" ; Initialisation & setup
**** **** ****     > editorkeys_init.asm
0001               * FILE......: editorkeys_init.asm
0002               * Purpose...: Initialisation & setup key press actions
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Movement keys
0007               *---------------------------------------------------------------
0008      0800     key_left      equ >0800                      ; fctn  + s
0009      0900     key_right     equ >0900                      ; fctn  + d
0010      0B00     key_up        equ >0b00                      ; fctn  + e
0011      0A00     key_down      equ >0a00                      ; fctn  + x
0012      8100     key_home      equ >8100                      ; ctrl  + a
0013      8600     key_end       equ >8600                      ; ctrl  + f
0014      9300     key_pword     equ >9300                      ; ctrl  + s
0015      8400     key_nword     equ >8400                      ; ctrl  + d
0016      8500     key_ppage     equ >8500                      ; ctrl  + e
0017      9800     key_npage     equ >9800                      ; ctrl  + x
0018      9400     key_tpage     equ >9400                      ; ctrl  + t
0019      8200     key_bpage     equ >8200                      ; ctrl  + b
0020               *---------------------------------------------------------------
0021               * Modifier keys
0022               *---------------------------------------------------------------
0023      0D00     key_enter       equ >0d00                    ; enter
0024      0300     key_del_char    equ >0300                    ; fctn  + 1
0025      0700     key_del_line    equ >0700                    ; fctn  + 3
0026      8B00     key_del_eol     equ >8b00                    ; ctrl  + k
0027      0400     key_ins_char    equ >0400                    ; fctn  + 2
0028      B900     key_ins_onoff   equ >b900                    ; fctn  + .
0029      0E00     key_ins_line    equ >0e00                    ; fctn  + 5
0030      0500     key_quit1       equ >0500                    ; fctn  + +
0031      9D00     key_quit2       equ >9d00                    ; ctrl  + +
0032               *---------------------------------------------------------------
0033               * File buffer keys
0034               *---------------------------------------------------------------
0035      B000     key_buf0        equ >b000                    ; ctrl  + 0
0036      B100     key_buf1        equ >b100                    ; ctrl  + 1
0037      B200     key_buf2        equ >b200                    ; ctrl  + 2
0038      B300     key_buf3        equ >b300                    ; ctrl  + 3
0039      B400     key_buf4        equ >b400                    ; ctrl  + 4
0040      B500     key_buf5        equ >b500                    ; ctrl  + 5
0041      B600     key_buf6        equ >b600                    ; ctrl  + 6
0042      B700     key_buf7        equ >b700                    ; ctrl  + 7
0043      9E00     key_buf8        equ >9e00                    ; ctrl  + 8
0044      9F00     key_buf9        equ >9f00                    ; ctrl  + 9
0045               
0046               
0047               
0048               *---------------------------------------------------------------
0049               * Action keys mapping <-> actions table
0050               *---------------------------------------------------------------
0051               keymap_actions
0052                       ;-------------------------------------------------------
0053                       ; Movement keys
0054                       ;-------------------------------------------------------
0055 6E70 0D00             data  key_enter,edkey.action.enter          ; New line
     6E72 72D4 
0056 6E74 0800             data  key_left,edkey.action.left            ; Move cursor left
     6E76 6F08 
0057 6E78 0900             data  key_right,edkey.action.right          ; Move cursor right
     6E7A 6F1E 
0058 6E7C 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6E7E 6F36 
0059 6E80 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6E82 6F88 
0060 6E84 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6E86 6FF4 
0061 6E88 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6E8A 700C 
0062 6E8C 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6E8E 7020 
0063 6E90 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6E92 7072 
0064 6E94 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6E96 70D2 
0065 6E98 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6E9A 711C 
0066 6E9C 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6E9E 7148 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 6EA0 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6EA2 7176 
0071 6EA4 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6EA6 71AE 
0072 6EA8 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6EAA 71E2 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 6EAC 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6EAE 723A 
0077 6EB0 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6EB2 7342 
0078 6EB4 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6EB6 7290 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 6EB8 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6EBA 7392 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 6EBC B000             data  key_buf0,edkey.action.buffer0
     6EBE 73DE 
0087 6EC0 B100             data  key_buf1,edkey.action.buffer1
     6EC2 73E4 
0088 6EC4 B200             data  key_buf2,edkey.action.buffer2
     6EC6 73EA 
0089 6EC8 B300             data  key_buf3,edkey.action.buffer3
     6ECA 73F0 
0090 6ECC B400             data  key_buf4,edkey.action.buffer4
     6ECE 73F6 
0091 6ED0 B500             data  key_buf5,edkey.action.buffer5
     6ED2 73FC 
0092 6ED4 B600             data  key_buf6,edkey.action.buffer6
     6ED6 7402 
0093 6ED8 B700             data  key_buf7,edkey.action.buffer7
     6EDA 7408 
0094 6EDC 9E00             data  key_buf8,edkey.action.buffer8
     6EDE 740E 
0095 6EE0 9F00             data  key_buf9,edkey.action.buffer9
     6EE2 7414 
0096 6EE4 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 6EE6 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6EE8 833C 
0104 6EEA 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6EEC FF00 
0105               
0106 6EEE 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6EF0 6E70 
0107 6EF2 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 6EF4 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 6EF6 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 6EF8 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 6EFA 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 6EFC 05C6  14         inct  tmp2                  ; No, skip action
0118 6EFE 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 6F00 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 6F02 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 6F04 0460  28         b    @edkey.action.char     ; Add character to buffer
     6F06 7352 
**** **** ****     > tivi.asm.11019
0357                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6F08 C120  34         mov   @fb.column,tmp0
     6F0A 220C 
0010 6F0C 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6F0E 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6F10 220C 
0015 6F12 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6F14 832A 
0016 6F16 0620  34         dec   @fb.current
     6F18 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6F1A 0460  28 !       b     @ed_wait              ; Back to editor main
     6F1C 6E64 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6F1E 8820  54         c     @fb.column,@fb.row.length
     6F20 220C 
     6F22 2208 
0028 6F24 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6F26 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6F28 220C 
0033 6F2A 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6F2C 832A 
0034 6F2E 05A0  34         inc   @fb.current
     6F30 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6F32 0460  28 !       b     @ed_wait              ; Back to editor main
     6F34 6E64 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6F36 8820  54         c     @fb.row.dirty,@w$ffff
     6F38 220A 
     6F3A 6048 
0049 6F3C 1604  14         jne   edkey.action.up.cursor
0050 6F3E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F40 77A2 
0051 6F42 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F44 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6F46 C120  34         mov   @fb.row,tmp0
     6F48 2206 
0057 6F4A 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6F4C C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6F4E 2204 
0060 6F50 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6F52 0604  14         dec   tmp0                  ; fb.topline--
0066 6F54 C804  38         mov   tmp0,@parm1
     6F56 8350 
0067 6F58 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F5A 7638 
0068 6F5C 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6F5E 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F60 2206 
0074 6F62 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F64 6534 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6F66 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F68 78F6 
0080 6F6A 8820  54         c     @fb.column,@fb.row.length
     6F6C 220C 
     6F6E 2208 
0081 6F70 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6F72 C820  54         mov   @fb.row.length,@fb.column
     6F74 2208 
     6F76 220C 
0086 6F78 C120  34         mov   @fb.column,tmp0
     6F7A 220C 
0087 6F7C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F7E 653E 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6F80 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F82 761C 
0093 6F84 0460  28         b     @ed_wait              ; Back to editor main
     6F86 6E64 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6F88 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6F8A 2206 
     6F8C 2304 
0102 6F8E 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6F90 8820  54         c     @fb.row.dirty,@w$ffff
     6F92 220A 
     6F94 6048 
0107 6F96 1604  14         jne   edkey.action.down.move
0108 6F98 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F9A 77A2 
0109 6F9C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F9E 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6FA0 C120  34         mov   @fb.topline,tmp0
     6FA2 2204 
0118 6FA4 A120  34         a     @fb.row,tmp0
     6FA6 2206 
0119 6FA8 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6FAA 2304 
0120 6FAC 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6FAE C120  34         mov   @fb.screenrows,tmp0
     6FB0 2218 
0126 6FB2 0604  14         dec   tmp0
0127 6FB4 8120  34         c     @fb.row,tmp0
     6FB6 2206 
0128 6FB8 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6FBA C820  54         mov   @fb.topline,@parm1
     6FBC 2204 
     6FBE 8350 
0133 6FC0 05A0  34         inc   @parm1
     6FC2 8350 
0134 6FC4 06A0  32         bl    @fb.refresh
     6FC6 7638 
0135 6FC8 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6FCA 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6FCC 2206 
0141 6FCE 06A0  32         bl    @down                 ; Row++ VDP cursor
     6FD0 652C 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6FD2 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6FD4 78F6 
0147 6FD6 8820  54         c     @fb.column,@fb.row.length
     6FD8 220C 
     6FDA 2208 
0148 6FDC 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 6FDE C820  54         mov   @fb.row.length,@fb.column
     6FE0 2208 
     6FE2 220C 
0153 6FE4 C120  34         mov   @fb.column,tmp0
     6FE6 220C 
0154 6FE8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FEA 653E 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 6FEC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FEE 761C 
0160 6FF0 0460  28 !       b     @ed_wait              ; Back to editor main
     6FF2 6E64 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 6FF4 C120  34         mov   @wyx,tmp0
     6FF6 832A 
0169 6FF8 0244  22         andi  tmp0,>ff00
     6FFA FF00 
0170 6FFC C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6FFE 832A 
0171 7000 04E0  34         clr   @fb.column
     7002 220C 
0172 7004 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7006 761C 
0173 7008 0460  28         b     @ed_wait              ; Back to editor main
     700A 6E64 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 700C C120  34         mov   @fb.row.length,tmp0
     700E 2208 
0180 7010 C804  38         mov   tmp0,@fb.column
     7012 220C 
0181 7014 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7016 653E 
0182 7018 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     701A 761C 
0183 701C 0460  28         b     @ed_wait              ; Back to editor main
     701E 6E64 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 7020 C120  34         mov   @fb.column,tmp0
     7022 220C 
0192 7024 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 7026 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7028 2202 
0197 702A 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 702C 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 702E 0605  14         dec   tmp1
0204 7030 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 7032 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 7034 D195  26         movb  *tmp1,tmp2            ; Get character
0212 7036 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 7038 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 703A 0986  56         srl   tmp2,8                ; Right justify
0215 703C 0286  22         ci    tmp2,32               ; Space character found?
     703E 0020 
0216 7040 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 7042 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7044 2020 
0222 7046 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 7048 0287  22         ci    tmp3,>20ff            ; First character is space
     704A 20FF 
0225 704C 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 704E C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     7050 220C 
0230 7052 61C4  18         s     tmp0,tmp3
0231 7054 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7056 0002 
0232 7058 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 705A 0585  14         inc   tmp1
0238 705C 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 705E C805  38         mov   tmp1,@fb.current
     7060 2202 
0244 7062 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7064 220C 
0245 7066 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7068 653E 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 706A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     706C 761C 
0251 706E 0460  28 !       b     @ed_wait              ; Back to editor main
     7070 6E64 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 7072 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 7074 C120  34         mov   @fb.column,tmp0
     7076 220C 
0261 7078 8804  38         c     tmp0,@fb.row.length
     707A 2208 
0262 707C 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 707E C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7080 2202 
0267 7082 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 7084 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 7086 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 7088 0585  14         inc   tmp1
0279 708A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 708C 8804  38         c     tmp0,@fb.row.length
     708E 2208 
0281 7090 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 7092 D195  26         movb  *tmp1,tmp2            ; Get character
0288 7094 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 7096 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 7098 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 709A 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     709C FFFF 
0293 709E 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 70A0 0286  22         ci    tmp2,32
     70A2 0020 
0299 70A4 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 70A6 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 70A8 0286  22         ci    tmp2,32               ; Space character found?
     70AA 0020 
0307 70AC 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 70AE 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     70B0 2020 
0313 70B2 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 70B4 0287  22         ci    tmp3,>20ff            ; First characer is space?
     70B6 20FF 
0316 70B8 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 70BA 0585  14         inc   tmp1
0321 70BC 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 70BE C805  38         mov   tmp1,@fb.current
     70C0 2202 
0327 70C2 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     70C4 220C 
0328 70C6 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70C8 653E 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 70CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70CC 761C 
0334 70CE 0460  28 !       b     @ed_wait              ; Back to editor main
     70D0 6E64 
0335               
0336               
0337               
0338               
0339               *---------------------------------------------------------------
0340               * Previous page
0341               *---------------------------------------------------------------
0342               edkey.action.ppage:
0343                       ;-------------------------------------------------------
0344                       ; Sanity check
0345                       ;-------------------------------------------------------
0346 70D2 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     70D4 2204 
0347 70D6 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 70D8 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     70DA 2218 
0352 70DC 1503  14         jgt   edkey.action.ppage.topline
0353 70DE 04E0  34         clr   @fb.topline           ; topline = 0
     70E0 2204 
0354 70E2 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 70E4 6820  54         s     @fb.screenrows,@fb.topline
     70E6 2218 
     70E8 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 70EA 8820  54         c     @fb.row.dirty,@w$ffff
     70EC 220A 
     70EE 6048 
0365 70F0 1604  14         jne   edkey.action.ppage.refresh
0366 70F2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70F4 77A2 
0367 70F6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70F8 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 70FA C820  54         mov   @fb.topline,@parm1
     70FC 2204 
     70FE 8350 
0373 7100 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7102 7638 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 7104 04E0  34         clr   @fb.row
     7106 2206 
0379 7108 05A0  34         inc   @fb.row               ; Set fb.row=1
     710A 2206 
0380 710C 04E0  34         clr   @fb.column
     710E 220C 
0381 7110 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7112 0100 
0382 7114 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7116 832A 
0383 7118 0460  28         b     @edkey.action.up      ; Do rest of logic
     711A 6F36 
0384               
0385               
0386               
0387               *---------------------------------------------------------------
0388               * Next page
0389               *---------------------------------------------------------------
0390               edkey.action.npage:
0391                       ;-------------------------------------------------------
0392                       ; Sanity check
0393                       ;-------------------------------------------------------
0394 711C C120  34         mov   @fb.topline,tmp0
     711E 2204 
0395 7120 A120  34         a     @fb.screenrows,tmp0
     7122 2218 
0396 7124 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7126 2304 
0397 7128 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 712A A820  54         a     @fb.screenrows,@fb.topline
     712C 2218 
     712E 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 7130 8820  54         c     @fb.row.dirty,@w$ffff
     7132 220A 
     7134 6048 
0408 7136 1604  14         jne   edkey.action.npage.refresh
0409 7138 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     713A 77A2 
0410 713C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     713E 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 7140 0460  28         b     @edkey.action.ppage.refresh
     7142 70FA 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 7144 0460  28         b     @ed_wait              ; Back to editor main
     7146 6E64 
0422               
0423               
0424               
0425               
0426               *---------------------------------------------------------------
0427               * Goto top of file
0428               *---------------------------------------------------------------
0429               edkey.action.top:
0430                       ;-------------------------------------------------------
0431                       ; Crunch current row if dirty
0432                       ;-------------------------------------------------------
0433 7148 8820  54         c     @fb.row.dirty,@w$ffff
     714A 220A 
     714C 6048 
0434 714E 1604  14         jne   edkey.action.top.refresh
0435 7150 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7152 77A2 
0436 7154 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7156 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 7158 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     715A 2204 
0442 715C 04E0  34         clr   @parm1
     715E 8350 
0443 7160 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7162 7638 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 7164 04E0  34         clr   @fb.row               ; Editor line 0
     7166 2206 
0449 7168 04E0  34         clr   @fb.column            ; Editor column 0
     716A 220C 
0450 716C 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 716E C804  38         mov   tmp0,@wyx             ;
     7170 832A 
0452 7172 0460  28         b     @ed_wait              ; Back to editor main
     7174 6E64 
**** **** ****     > tivi.asm.11019
0358                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 7176 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7178 2306 
0010 717A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     717C 761C 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 717E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7180 2202 
0015 7182 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7184 2208 
0016 7186 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7188 8820  54         c     @fb.column,@fb.row.length
     718A 220C 
     718C 2208 
0022 718E 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 7190 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7192 2202 
0028 7194 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 7196 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7198 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 719A 0606  14         dec   tmp2
0036 719C 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 719E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     71A0 220A 
0041 71A2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71A4 2216 
0042 71A6 0620  34         dec   @fb.row.length        ; @fb.row.length--
     71A8 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 71AA 0460  28         b     @ed_wait              ; Back to editor main
     71AC 6E64 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 71AE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71B0 2306 
0055 71B2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71B4 761C 
0056 71B6 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     71B8 2208 
0057 71BA 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 71BC C120  34         mov   @fb.current,tmp0      ; Get pointer
     71BE 2202 
0063 71C0 C1A0  34         mov   @fb.colsline,tmp2
     71C2 220E 
0064 71C4 61A0  34         s     @fb.column,tmp2
     71C6 220C 
0065 71C8 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 71CA DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 71CC 0606  14         dec   tmp2
0072 71CE 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 71D0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     71D2 220A 
0077 71D4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71D6 2216 
0078               
0079 71D8 C820  54         mov   @fb.column,@fb.row.length
     71DA 220C 
     71DC 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 71DE 0460  28         b     @ed_wait              ; Back to editor main
     71E0 6E64 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 71E2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71E4 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 71E6 C120  34         mov   @edb.lines,tmp0
     71E8 2304 
0097 71EA 1604  14         jne   !
0098 71EC 04E0  34         clr   @fb.column            ; Column 0
     71EE 220C 
0099 71F0 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     71F2 71AE 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 71F4 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71F6 761C 
0104 71F8 04E0  34         clr   @fb.row.dirty         ; Discard current line
     71FA 220A 
0105 71FC C820  54         mov   @fb.topline,@parm1
     71FE 2204 
     7200 8350 
0106 7202 A820  54         a     @fb.row,@parm1        ; Line number to remove
     7204 2206 
     7206 8350 
0107 7208 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     720A 2304 
     720C 8352 
0108 720E 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7210 76EC 
0109 7212 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7214 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7216 C820  54         mov   @fb.topline,@parm1
     7218 2204 
     721A 8350 
0114 721C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     721E 7638 
0115 7220 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7222 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 7224 C120  34         mov   @fb.topline,tmp0
     7226 2204 
0120 7228 A120  34         a     @fb.row,tmp0
     722A 2206 
0121 722C 8804  38         c     tmp0,@edb.lines       ; Was last line?
     722E 2304 
0122 7230 1202  14         jle   edkey.action.del_line.exit
0123 7232 0460  28         b     @edkey.action.up      ; One line up
     7234 6F36 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 7236 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7238 6FF4 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 723A 0204  20         li    tmp0,>2000            ; White space
     723C 2000 
0139 723E C804  38         mov   tmp0,@parm1
     7240 8350 
0140               edkey.action.ins_char:
0141 7242 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7244 2306 
0142 7246 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7248 761C 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 724A C120  34         mov   @fb.current,tmp0      ; Get pointer
     724C 2202 
0147 724E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7250 2208 
0148 7252 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 7254 8820  54         c     @fb.column,@fb.row.length
     7256 220C 
     7258 2208 
0154 725A 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 725C C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 725E 61E0  34         s     @fb.column,tmp3
     7260 220C 
0162 7262 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 7264 C144  18         mov   tmp0,tmp1
0164 7266 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7268 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     726A 220C 
0166 726C 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 726E D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 7270 0604  14         dec   tmp0
0173 7272 0605  14         dec   tmp1
0174 7274 0606  14         dec   tmp2
0175 7276 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 7278 D560  46         movb  @parm1,*tmp1
     727A 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 727C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     727E 220A 
0184 7280 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7282 2216 
0185 7284 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7286 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7288 0460  28         b     @edkey.action.char.overwrite
     728A 7364 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 728C 0460  28         b     @ed_wait              ; Back to editor main
     728E 6E64 
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
0206 7290 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7292 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 7294 8820  54         c     @fb.row.dirty,@w$ffff
     7296 220A 
     7298 6048 
0211 729A 1604  14         jne   edkey.action.ins_line.insert
0212 729C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     729E 77A2 
0213 72A0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72A2 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 72A4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72A6 761C 
0219 72A8 C820  54         mov   @fb.topline,@parm1
     72AA 2204 
     72AC 8350 
0220 72AE A820  54         a     @fb.row,@parm1        ; Line number to insert
     72B0 2206 
     72B2 8350 
0221               
0222 72B4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72B6 2304 
     72B8 8352 
0223 72BA 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     72BC 7720 
0224 72BE 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     72C0 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 72C2 C820  54         mov   @fb.topline,@parm1
     72C4 2204 
     72C6 8350 
0229 72C8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     72CA 7638 
0230 72CC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72CE 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 72D0 0460  28         b     @ed_wait              ; Back to editor main
     72D2 6E64 
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
0249 72D4 8820  54         c     @fb.row.dirty,@w$ffff
     72D6 220A 
     72D8 6048 
0250 72DA 1606  14         jne   edkey.action.enter.upd_counter
0251 72DC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72DE 2306 
0252 72E0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72E2 77A2 
0253 72E4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72E6 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 72E8 C120  34         mov   @fb.topline,tmp0
     72EA 2204 
0259 72EC A120  34         a     @fb.row,tmp0
     72EE 2206 
0260 72F0 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     72F2 2304 
0261 72F4 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 72F6 05A0  34         inc   @edb.lines            ; Total lines++
     72F8 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 72FA C120  34         mov   @fb.screenrows,tmp0
     72FC 2218 
0271 72FE 0604  14         dec   tmp0
0272 7300 8120  34         c     @fb.row,tmp0
     7302 2206 
0273 7304 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 7306 C120  34         mov   @fb.screenrows,tmp0
     7308 2218 
0278 730A C820  54         mov   @fb.topline,@parm1
     730C 2204 
     730E 8350 
0279 7310 05A0  34         inc   @parm1
     7312 8350 
0280 7314 06A0  32         bl    @fb.refresh
     7316 7638 
0281 7318 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 731A 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     731C 2206 
0287 731E 06A0  32         bl    @down                 ; Row++ VDP cursor
     7320 652C 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 7322 06A0  32         bl    @fb.get.firstnonblank
     7324 7662 
0293 7326 C120  34         mov   @outparm1,tmp0
     7328 8360 
0294 732A C804  38         mov   tmp0,@fb.column
     732C 220C 
0295 732E 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     7330 653E 
0296 7332 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7334 78F6 
0297 7336 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7338 761C 
0298 733A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     733C 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 733E 0460  28         b     @ed_wait              ; Back to editor main
     7340 6E64 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 7342 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7344 230A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7346 0204  20         li    tmp0,2000
     7348 07D0 
0317               edkey.action.ins_onoff.loop:
0318 734A 0604  14         dec   tmp0
0319 734C 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 734E 0460  28         b     @task2.cur_visible    ; Update cursor shape
     7350 74B8 
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
0335 7352 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7354 2306 
0336 7356 D805  38         movb  tmp1,@parm1           ; Store character for insert
     7358 8350 
0337 735A C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     735C 230A 
0338 735E 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 7360 0460  28         b     @edkey.action.ins_char
     7362 7242 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 7364 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7366 761C 
0349 7368 C120  34         mov   @fb.current,tmp0      ; Get pointer
     736A 2202 
0350               
0351 736C D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     736E 8350 
0352 7370 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7372 220A 
0353 7374 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7376 2216 
0354               
0355 7378 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     737A 220C 
0356 737C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     737E 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 7380 8820  54         c     @fb.column,@fb.row.length
     7382 220C 
     7384 2208 
0361 7386 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7388 C820  54         mov   @fb.column,@fb.row.length
     738A 220C 
     738C 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 738E 0460  28         b     @ed_wait              ; Back to editor main
     7390 6E64 
**** **** ****     > tivi.asm.11019
0359                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 7392 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7394 65EE 
0010 7396 0420  54         blwp  @0                    ; Exit
     7398 0000 
0011               
**** **** ****     > tivi.asm.11019
0360                       copy  "editorkeys_file.asm" ; Actions for file related keys
**** **** ****     > editorkeys_file.asm
0001               * FILE......: editorkeys_fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load DV/80 text file into editor
0007               *---------------------------------------------------------------
0008               * b     @edkey.action.loadfile
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * tmp0  = Pointer to length-prefixed string containing device
0012               *         and filename
0013               * parm1 = >FFFF for RLE compression on load, otherwise >0000
0014               *---------------------------------------------------------------
0015               edkey.action.loadfile:
0016 739A C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     739C 8350 
     739E 8352 
0017 73A0 C804  38         mov   tmp0,@parm1           ; Setup file to load
     73A2 8350 
0018               
0019 73A4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     73A6 7782 
0020 73A8 06A0  32         bl    @idx.init             ; Initialize index
     73AA 76AA 
0021 73AC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     73AE 75CE 
0022 73B0 C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     73B2 8352 
     73B4 230C 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 73B6 06A0  32         bl    @filv
     73B8 618E 
0027 73BA 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     73BC 0000 
     73BE 0004 
0028               
0029 73C0 C160  34         mov   @fb.screenrows,tmp1
     73C2 2218 
0030 73C4 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     73C6 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 73C8 04C4  14         clr   tmp0                  ; VDP target address
0034 73CA 0205  20         li    tmp1,32               ; Character to fill
     73CC 0020 
0035               
0036 73CE 06A0  32         bl    @xfilv                ; Fill VDP memory
     73D0 6194 
0037                                                   ; \ i  tmp0 = VDP target address
0038                                                   ; | i  tmp1 = Byte to fill
0039                                                   ; / i  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 73D2 06A0  32         bl    @tfh.file.read        ; Read specified file
     73D4 7914 
0044                                                   ; \ i  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / i  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 73D6 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     73D8 2306 
0048 73DA 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     73DC 7148 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 73DE 0204  20         li   tmp0,fdname0
     73E0 7BB6 
0054 73E2 10DB  14         jmp  edkey.action.loadfile
0055                                                   ; Load DIS/VAR 80 file into editor buffer
0056               edkey.action.buffer1:
0057 73E4 0204  20         li   tmp0,fdname1
     73E6 7BC4 
0058 73E8 10D8  14         jmp  edkey.action.loadfile
0059                                                   ; Load DIS/VAR 80 file into editor buffer
0060               
0061               edkey.action.buffer2:
0062 73EA 0204  20         li   tmp0,fdname2
     73EC 7BD4 
0063 73EE 10D5  14         jmp  edkey.action.loadfile
0064                                                   ; Load DIS/VAR 80 file into editor buffer
0065               
0066               edkey.action.buffer3:
0067 73F0 0204  20         li   tmp0,fdname3
     73F2 7BE2 
0068 73F4 10D2  14         jmp  edkey.action.loadfile
0069                                                   ; Load DIS/VAR 80 file into editor buffer
0070               
0071               edkey.action.buffer4:
0072 73F6 0204  20         li   tmp0,fdname4
     73F8 7BF0 
0073 73FA 10CF  14         jmp  edkey.action.loadfile
0074                                                   ; Load DIS/VAR 80 file into editor buffer
0075               
0076               edkey.action.buffer5:
0077 73FC 0204  20         li   tmp0,fdname5
     73FE 7BFE 
0078 7400 10CC  14         jmp  edkey.action.loadfile
0079                                                   ; Load DIS/VAR 80 file into editor buffer
0080               
0081               edkey.action.buffer6:
0082 7402 0204  20         li   tmp0,fdname6
     7404 7C0C 
0083 7406 10C9  14         jmp  edkey.action.loadfile
0084                                                   ; Load DIS/VAR 80 file into editor buffer
0085               
0086               edkey.action.buffer7:
0087 7408 0204  20         li   tmp0,fdname7
     740A 7C1A 
0088 740C 10C6  14         jmp  edkey.action.loadfile
0089                                                   ; Load DIS/VAR 80 file into editor buffer
0090               
0091               edkey.action.buffer8:
0092 740E 0204  20         li   tmp0,fdname8
     7410 7C28 
0093 7412 10C3  14         jmp  edkey.action.loadfile
0094                                                   ; Load DIS/VAR 80 file into editor buffer
0095               
0096               edkey.action.buffer9:
0097 7414 0204  20         li   tmp0,fdname9
     7416 7C36 
0098 7418 10C0  14         jmp  edkey.action.loadfile
0099                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.11019
0361               
0362               
0363               
0364               ***************************************************************
0365               * Task 0 - Copy frame buffer to VDP
0366               ***************************************************************
0367 741A C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     741C 2216 
0368 741E 133D  14         jeq   task0.$$              ; No, skip update
0369                       ;------------------------------------------------------
0370                       ; Determine how many rows to copy
0371                       ;------------------------------------------------------
0372 7420 8820  54         c     @edb.lines,@fb.screenrows
     7422 2304 
     7424 2218 
0373 7426 1103  14         jlt   task0.setrows.small
0374 7428 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     742A 2218 
0375 742C 1003  14         jmp   task0.copy.framebuffer
0376                       ;------------------------------------------------------
0377                       ; Less lines in editor buffer as rows in frame buffer
0378                       ;------------------------------------------------------
0379               task0.setrows.small:
0380 742E C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7430 2304 
0381 7432 0585  14         inc   tmp1
0382                       ;------------------------------------------------------
0383                       ; Determine area to copy
0384                       ;------------------------------------------------------
0385               task0.copy.framebuffer:
0386 7434 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7436 220E 
0387                                                   ; 16 bit part is in tmp2!
0388 7438 04C4  14         clr   tmp0                  ; VDP target address
0389 743A C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     743C 2200 
0390                       ;------------------------------------------------------
0391                       ; Copy memory block
0392                       ;------------------------------------------------------
0393 743E 06A0  32         bl    @xpym2v               ; Copy to VDP
     7440 633E 
0394                                                   ; tmp0 = VDP target address
0395                                                   ; tmp1 = RAM source address
0396                                                   ; tmp2 = Bytes to copy
0397 7442 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7444 2216 
0398                       ;-------------------------------------------------------
0399                       ; Draw EOF marker at end-of-file
0400                       ;-------------------------------------------------------
0401 7446 C120  34         mov   @edb.lines,tmp0
     7448 2304 
0402 744A 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     744C 2204 
0403 744E 0584  14         inc   tmp0                  ; Y++
0404 7450 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7452 2218 
0405 7454 1222  14         jle   task0.$$
0406                       ;-------------------------------------------------------
0407                       ; Draw EOF marker
0408                       ;-------------------------------------------------------
0409               task0.draw_marker:
0410 7456 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7458 832A 
     745A 2214 
0411 745C 0A84  56         sla   tmp0,8                ; X=0
0412 745E C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7460 832A 
0413 7462 06A0  32         bl    @putstr
     7464 631E 
0414 7466 7B84                   data txt_marker       ; Display *EOF*
0415                       ;-------------------------------------------------------
0416                       ; Draw empty line after (and below) EOF marker
0417                       ;-------------------------------------------------------
0418 7468 06A0  32         bl    @setx
     746A 653C 
0419 746C 0005                   data  5               ; Cursor after *EOF* string
0420               
0421 746E C120  34         mov   @wyx,tmp0
     7470 832A 
0422 7472 0984  56         srl   tmp0,8                ; Right justify
0423 7474 0584  14         inc   tmp0                  ; One time adjust
0424 7476 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7478 2218 
0425 747A 1303  14         jeq   !
0426 747C 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     747E 009B 
0427 7480 1002  14         jmp   task0.draw_marker.line
0428 7482 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     7484 004B 
0429                       ;-------------------------------------------------------
0430                       ; Draw empty line
0431                       ;-------------------------------------------------------
0432               task0.draw_marker.line:
0433 7486 0604  14         dec   tmp0                  ; One time adjust
0434 7488 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     748A 62FA 
0435 748C 0205  20         li    tmp1,32               ; Character to write (whitespace)
     748E 0020 
0436 7490 06A0  32         bl    @xfilv                ; Write characters
     7492 6194 
0437 7494 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7496 2214 
     7498 832A 
0438               *--------------------------------------------------------------
0439               * Task 0 - Exit
0440               *--------------------------------------------------------------
0441               task0.$$:
0442 749A 0460  28         b     @slotok
     749C 6C80 
0443               
0444               
0445               
0446               ***************************************************************
0447               * Task 1 - Copy SAT to VDP
0448               ***************************************************************
0449 749E E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     74A0 6046 
0450 74A2 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     74A4 6548 
0451 74A6 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     74A8 8380 
0452 74AA 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0453               
0454               
0455               ***************************************************************
0456               * Task 2 - Update cursor shape (blink)
0457               ***************************************************************
0458 74AC 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     74AE 2212 
0459 74B0 1303  14         jeq   task2.cur_visible
0460 74B2 04E0  34         clr   @ramsat+2              ; Hide cursor
     74B4 8382 
0461 74B6 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0462               
0463               task2.cur_visible:
0464 74B8 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     74BA 230A 
0465 74BC 1303  14         jeq   task2.cur_visible.overwrite_mode
0466                       ;------------------------------------------------------
0467                       ; Cursor in insert mode
0468                       ;------------------------------------------------------
0469               task2.cur_visible.insert_mode:
0470 74BE 0204  20         li    tmp0,>000f
     74C0 000F 
0471 74C2 1002  14         jmp   task2.cur_visible.cursorshape
0472                       ;------------------------------------------------------
0473                       ; Cursor in overwrite mode
0474                       ;------------------------------------------------------
0475               task2.cur_visible.overwrite_mode:
0476 74C4 0204  20         li    tmp0,>020f
     74C6 020F 
0477                       ;------------------------------------------------------
0478                       ; Set cursor shape
0479                       ;------------------------------------------------------
0480               task2.cur_visible.cursorshape:
0481 74C8 C804  38         mov   tmp0,@fb.curshape
     74CA 2210 
0482 74CC C804  38         mov   tmp0,@ramsat+2
     74CE 8382 
0483               
0484               
0485               
0486               
0487               
0488               
0489               
0490               *--------------------------------------------------------------
0491               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0492               *--------------------------------------------------------------
0493               task.sub_copy_ramsat:
0494 74D0 06A0  32         bl    @cpym2v
     74D2 6338 
0495 74D4 2000                   data sprsat,ramsat,4   ; Update sprite
     74D6 8380 
     74D8 0004 
0496               
0497 74DA C820  54         mov   @wyx,@fb.yxsave
     74DC 832A 
     74DE 2214 
0498                       ;------------------------------------------------------
0499                       ; Show text editing mode
0500                       ;------------------------------------------------------
0501               task.botline.show_mode:
0502 74E0 C120  34         mov   @edb.insmode,tmp0
     74E2 230A 
0503 74E4 1605  14         jne   task.botline.show_mode.insert
0504                       ;------------------------------------------------------
0505                       ; Overwrite mode
0506                       ;------------------------------------------------------
0507               task.botline.show_mode.overwrite:
0508 74E6 06A0  32         bl    @putat
     74E8 6330 
0509 74EA 1D32                   byte  29,50
0510 74EC 7B90                   data  txt_ovrwrite
0511 74EE 1004  14         jmp   task.botline.show_changed
0512                       ;------------------------------------------------------
0513                       ; Insert  mode
0514                       ;------------------------------------------------------
0515               task.botline.show_mode.insert:
0516 74F0 06A0  32         bl    @putat
     74F2 6330 
0517 74F4 1D32                   byte  29,50
0518 74F6 7B94                   data  txt_insert
0519                       ;------------------------------------------------------
0520                       ; Show if text was changed in editor buffer
0521                       ;------------------------------------------------------
0522               task.botline.show_changed:
0523 74F8 C120  34         mov   @edb.dirty,tmp0
     74FA 2306 
0524 74FC 1305  14         jeq   task.botline.show_changed.clear
0525                       ;------------------------------------------------------
0526                       ; Show "*"
0527                       ;------------------------------------------------------
0528 74FE 06A0  32         bl    @putat
     7500 6330 
0529 7502 1D36                   byte 29,54
0530 7504 7B98                   data txt_star
0531 7506 1001  14         jmp   task.botline.show_linecol
0532                       ;------------------------------------------------------
0533                       ; Show "line,column"
0534                       ;------------------------------------------------------
0535               task.botline.show_changed.clear:
0536 7508 1000  14         nop
0537               task.botline.show_linecol:
0538 750A C820  54         mov   @fb.row,@parm1
     750C 2206 
     750E 8350 
0539 7510 06A0  32         bl    @fb.row2line
     7512 7608 
0540 7514 05A0  34         inc   @outparm1
     7516 8360 
0541                       ;------------------------------------------------------
0542                       ; Show line
0543                       ;------------------------------------------------------
0544 7518 06A0  32         bl    @putnum
     751A 68A6 
0545 751C 1D40                   byte  29,64            ; YX
0546 751E 8360                   data  outparm1,rambuf
     7520 8390 
0547 7522 3020                   byte  48               ; ASCII offset
0548                             byte  32               ; Padding character
0549                       ;------------------------------------------------------
0550                       ; Show comma
0551                       ;------------------------------------------------------
0552 7524 06A0  32         bl    @putat
     7526 6330 
0553 7528 1D45                   byte  29,69
0554 752A 7B82                   data  txt_delim
0555                       ;------------------------------------------------------
0556                       ; Show column
0557                       ;------------------------------------------------------
0558 752C 06A0  32         bl    @film
     752E 6136 
0559 7530 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7532 0020 
     7534 000C 
0560               
0561 7536 C820  54         mov   @fb.column,@waux1
     7538 220C 
     753A 833C 
0562 753C 05A0  34         inc   @waux1                 ; Offset 1
     753E 833C 
0563               
0564 7540 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7542 6828 
0565 7544 833C                   data  waux1,rambuf
     7546 8390 
0566 7548 3020                   byte  48               ; ASCII offset
0567                             byte  32               ; Fill character
0568               
0569 754A 06A0  32         bl    @trimnum               ; Trim number to the left
     754C 6880 
0570 754E 8390                   data  rambuf,rambuf+6,32
     7550 8396 
     7552 0020 
0571               
0572 7554 0204  20         li    tmp0,>0200
     7556 0200 
0573 7558 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     755A 8396 
0574               
0575 755C 06A0  32         bl    @putat
     755E 6330 
0576 7560 1D46                   byte 29,70
0577 7562 8396                   data rambuf+6          ; Show column
0578                       ;------------------------------------------------------
0579                       ; Show lines in buffer unless on last line in file
0580                       ;------------------------------------------------------
0581 7564 C820  54         mov   @fb.row,@parm1
     7566 2206 
     7568 8350 
0582 756A 06A0  32         bl    @fb.row2line
     756C 7608 
0583 756E 8820  54         c     @edb.lines,@outparm1
     7570 2304 
     7572 8360 
0584 7574 1605  14         jne   task.botline.show_lines_in_buffer
0585               
0586 7576 06A0  32         bl    @putat
     7578 6330 
0587 757A 1D49                   byte 29,73
0588 757C 7B8A                   data txt_bottom
0589               
0590 757E 100B  14         jmp   task.botline.$$
0591                       ;------------------------------------------------------
0592                       ; Show lines in buffer
0593                       ;------------------------------------------------------
0594               task.botline.show_lines_in_buffer:
0595 7580 C820  54         mov   @edb.lines,@waux1
     7582 2304 
     7584 833C 
0596 7586 05A0  34         inc   @waux1                 ; Offset 1
     7588 833C 
0597 758A 06A0  32         bl    @putnum
     758C 68A6 
0598 758E 1D49                   byte 29,73             ; YX
0599 7590 833C                   data waux1,rambuf
     7592 8390 
0600 7594 3020                   byte 48
0601                             byte 32
0602                       ;------------------------------------------------------
0603                       ; Exit
0604                       ;------------------------------------------------------
0605               task.botline.$$
0606 7596 C820  54         mov   @fb.yxsave,@wyx
     7598 2214 
     759A 832A 
0607 759C 0460  28         b     @slotok                ; Exit running task
     759E 6C80 
0608               
0609               
0610               
0611               ***************************************************************
0612               *              mem - Memory Management module
0613               ***************************************************************
0614                       copy  "memory.asm"
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
0021 75A0 0649  14         dect  stack
0022 75A2 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 75A4 06A0  32         bl    @sams.layout
     75A6 6482 
0027 75A8 75AE                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 75AA C2F9  30         mov   *stack+,r11           ; Pop r11
0033 75AC 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 75AE 2000             data  >2000,>0000           ; >2000-2fff, SAMS page >00
     75B0 0000 
0039 75B2 3000             data  >3000,>0001           ; >3000-3fff, SAMS page >01
     75B4 0001 
0040 75B6 A000             data  >a000,>0002           ; >a000-afff, SAMS page >02
     75B8 0002 
0041 75BA B000             data  >b000,>0003           ; >b000-bfff, SAMS page >03
     75BC 0003 
0042 75BE C000             data  >c000,>0004           ; >c000-cfff, SAMS page >04
     75C0 0004 
0043 75C2 D000             data  >d000,>0005           ; >d000-dfff, SAMS page >05
     75C4 0005 
0044 75C6 E000             data  >e000,>0006           ; >e000-efff, SAMS page >06
     75C8 0006 
0045 75CA F000             data  >f000,>0007           ; >f000-ffff, SAMS page >07
     75CC 0007 
**** **** ****     > tivi.asm.11019
0615               
0616               ***************************************************************
0617               *                 fb - Framebuffer module
0618               ***************************************************************
0619                       copy  "framebuffer.asm"
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
0024 75CE 0649  14         dect  stack
0025 75D0 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 75D2 0204  20         li    tmp0,fb.top
     75D4 2650 
0030 75D6 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     75D8 2200 
0031 75DA 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     75DC 2204 
0032 75DE 04E0  34         clr   @fb.row               ; Current row=0
     75E0 2206 
0033 75E2 04E0  34         clr   @fb.column            ; Current column=0
     75E4 220C 
0034 75E6 0204  20         li    tmp0,80
     75E8 0050 
0035 75EA C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     75EC 220E 
0036 75EE 0204  20         li    tmp0,29
     75F0 001D 
0037 75F2 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     75F4 2218 
0038 75F6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     75F8 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 75FA 06A0  32         bl    @film
     75FC 6136 
0043 75FE 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7600 0000 
     7602 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7604 0460  28         b     @poprt                ; Return to caller
     7606 6132 
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
0073 7608 0649  14         dect  stack
0074 760A C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 760C C120  34         mov   @parm1,tmp0
     760E 8350 
0079 7610 A120  34         a     @fb.topline,tmp0
     7612 2204 
0080 7614 C804  38         mov   tmp0,@outparm1
     7616 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 7618 0460  28         b    @poprt                 ; Return to caller
     761A 6132 
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
0113 761C 0649  14         dect  stack
0114 761E C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7620 C1A0  34         mov   @fb.row,tmp2
     7622 2206 
0119 7624 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7626 220E 
0120 7628 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     762A 220C 
0121 762C A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     762E 2200 
0122 7630 C807  38         mov   tmp3,@fb.current
     7632 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7634 0460  28         b    @poprt                 ; Return to caller
     7636 6132 
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
0143               ********|*****|*********************|**************************
0144               fb.refresh:
0145 7638 0649  14         dect  stack
0146 763A C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 763C C820  54         mov   @parm1,@fb.topline
     763E 8350 
     7640 2204 
0151 7642 04E0  34         clr   @parm2                ; Target row in frame buffer
     7644 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 7646 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7648 7832 
0157                                                   ; \ i  parm1 = Line to unpack
0158                                                   ; / i  parm2 = Target row in frame buffer
0159               
0160 764A 05A0  34         inc   @parm1                ; Next line in editor buffer
     764C 8350 
0161 764E 05A0  34         inc   @parm2                ; Next row in frame buffer
     7650 8352 
0162 7652 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7654 8352 
     7656 2218 
0163 7658 11F6  14         jlt   fb.refresh.unpack_line
0164 765A 0720  34         seto  @fb.dirty             ; Refresh screen
     765C 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit:
0169 765E 0460  28         b     @poprt                ; Return to caller
     7660 6132 
0170               
0171               
0172               
0173               
0174               ***************************************************************
0175               * fb.get.firstnonblank
0176               * Get column of first non-blank character in specified line
0177               ***************************************************************
0178               * bl @fb.get.firstnonblank
0179               *--------------------------------------------------------------
0180               * OUTPUT
0181               * @outparm1 = Column containing first non-blank character
0182               * @outparm2 = Character
0183               ********|*****|*********************|**************************
0184               fb.get.firstnonblank:
0185 7662 0649  14         dect  stack
0186 7664 C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 7666 04E0  34         clr   @fb.column
     7668 220C 
0191 766A 06A0  32         bl    @fb.calc_pointer
     766C 761C 
0192 766E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7670 78F6 
0193 7672 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7674 2208 
0194 7676 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 7678 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     767A 2202 
0197 767C 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 767E D174  28         movb  *tmp0+,tmp1           ; Get character
0203 7680 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 7682 0285  22         ci    tmp1,>2000            ; Whitespace?
     7684 2000 
0206 7686 1503  14         jgt   fb.get.firstnonblank.match
0207 7688 0606  14         dec   tmp2                  ; Counter--
0208 768A 16F9  14         jne   fb.get.firstnonblank.loop
0209 768C 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match:
0214 768E 6120  34         s     @fb.current,tmp0      ; Calculate column
     7690 2202 
0215 7692 0604  14         dec   tmp0
0216 7694 C804  38         mov   tmp0,@outparm1        ; Save column
     7696 8360 
0217 7698 D805  38         movb  tmp1,@outparm2        ; Save character
     769A 8362 
0218 769C 1004  14         jmp   fb.get.firstnonblank.exit
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch:
0223 769E 04E0  34         clr   @outparm1             ; X=0
     76A0 8360 
0224 76A2 04E0  34         clr   @outparm2             ; Null
     76A4 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.exit:
0229 76A6 0460  28         b    @poprt                 ; Return to caller
     76A8 6132 
**** **** ****     > tivi.asm.11019
0620               
0621               ***************************************************************
0622               *              idx - Index management module
0623               ***************************************************************
0624                       copy  "index.asm"
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
0048 76AA 0649  14         dect  stack
0049 76AC C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 76AE 0204  20         li    tmp0,idx.top
     76B0 3000 
0054 76B2 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     76B4 2302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 76B6 06A0  32         bl    @film
     76B8 6136 
0059 76BA 3000             data  idx.top,>00,idx.size  ; Clear main index
     76BC 0000 
     76BE 1000 
0060               
0061 76C0 06A0  32         bl    @film
     76C2 6136 
0062 76C4 A000             data  idx.shadow.top,>00,idx.shadow.size
     76C6 0000 
     76C8 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 76CA 0460  28         b     @poprt                ; Return to caller
     76CC 6132 
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
0090 76CE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76D0 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 76D2 C160  34         mov   @parm2,tmp1
     76D4 8352 
0095 76D6 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 76D8 C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     76DA 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 76DC 0A14  56         sla   tmp0,1                ; line number * 2
0107 76DE C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     76E0 3000 
0108 76E2 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     76E4 A000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 76E6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     76E8 8360 
0115 76EA 045B  20         b     *r11                  ; Return
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
0135 76EC C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76EE 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 76F0 0A14  56         sla   tmp0,1                ; line number * 2
0140 76F2 C824  54         mov   @idx.top(tmp0),@outparm1
     76F4 3000 
     76F6 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 76F8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     76FA 8352 
0146 76FC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     76FE 8350 
0147 7700 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 7702 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 7704 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7706 3002 
     7708 3000 
0157 770A C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     770C A002 
     770E A000 
0158 7710 05C4  14         inct  tmp0                  ; Next index entry
0159 7712 0606  14         dec   tmp2                  ; tmp2--
0160 7714 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 7716 04E4  34         clr   @idx.top(tmp0)
     7718 3000 
0167 771A 04E4  34         clr   @idx.shadow.top(tmp0)
     771C A000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 771E 045B  20         b     *r11                  ; Return
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
0192 7720 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7722 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 7724 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 7726 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7728 8352 
0201 772A 61A0  34         s     @parm1,tmp2           ; Calculate loop
     772C 8350 
0202 772E 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 7730 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7732 3000 
     7734 3002 
0207                                                   ; Move pointer
0208 7736 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     7738 3000 
0209               
0210 773A C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     773C A000 
     773E A002 
0211                                                   ; Move SAMS page
0212 7740 04E4  34         clr   @idx.shadow.top+0(tmp0)
     7742 A000 
0213                                                   ; Clear new index entry
0214 7744 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 7746 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 7748 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     774A 3000 
     774C 3002 
0222                                                   ; Move pointer
0223               
0224 774E C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     7750 A000 
     7752 A002 
0225                                                   ; Move SAMS page
0226               
0227 7754 0644  14         dect  tmp0                  ; Previous index entry
0228 7756 0606  14         dec   tmp2                  ; tmp2--
0229 7758 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 775A 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     775C 3004 
0232 775E 04E4  34         clr   @idx.shadow.top+4(tmp0)
     7760 A004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 7762 045B  20         b     *r11                  ; Return
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
0259 7764 0649  14         dect  stack
0260 7766 C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 7768 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     776A 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 776C 0A14  56         sla   tmp0,1                ; line number * 2
0269 776E C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     7770 3000 
0270 7772 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     7774 A000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 7776 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7778 8360 
0277 777A C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     777C 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 777E 0460  28         b     @poprt                ; Return to caller
     7780 6132 
**** **** ****     > tivi.asm.11019
0625               
0626               ***************************************************************
0627               *               edb - Editor Buffer module
0628               ***************************************************************
0629                       copy  "editorbuffer.asm"
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
0026 7782 0649  14         dect  stack
0027 7784 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7786 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7788 B002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 778A C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     778C 2300 
0035 778E C804  38         mov   tmp0,@edb.next_free.ptr
     7790 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037               
0038 7792 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7794 230A 
0039 7796 04E0  34         clr   @edb.lines            ; Lines=0
     7798 2304 
0040 779A 04E0  34         clr   @edb.rle              ; RLE compression off
     779C 230C 
0041               
0042               
0043               edb.init.exit:
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047 779E 0460  28         b     @poprt                ; Return to caller
     77A0 6132 
0048               
0049               
0050               
0051               ***************************************************************
0052               * edb.line.pack
0053               * Pack current line in framebuffer
0054               ***************************************************************
0055               *  bl   @edb.line.pack
0056               *--------------------------------------------------------------
0057               * INPUT
0058               * @fb.top       = Address of top row in frame buffer
0059               * @fb.row       = Current row in frame buffer
0060               * @fb.column    = Current column in frame buffer
0061               * @fb.colsline  = Columns per line in frame buffer
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               *--------------------------------------------------------------
0065               * Register usage
0066               * tmp0,tmp1,tmp2
0067               *--------------------------------------------------------------
0068               * Memory usage
0069               * rambuf   = Saved @fb.column
0070               * rambuf+2 = Saved beginning of row
0071               * rambuf+4 = Saved length of row
0072               ********|*****|*********************|**************************
0073               edb.line.pack:
0074 77A2 0649  14         dect  stack
0075 77A4 C64B  30         mov   r11,*stack            ; Save return address
0076                       ;------------------------------------------------------
0077                       ; Get values
0078                       ;------------------------------------------------------
0079 77A6 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     77A8 220C 
     77AA 8390 
0080 77AC 04E0  34         clr   @fb.column
     77AE 220C 
0081 77B0 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     77B2 761C 
0082                       ;------------------------------------------------------
0083                       ; Prepare scan
0084                       ;------------------------------------------------------
0085 77B4 04C4  14         clr   tmp0                  ; Counter
0086 77B6 C160  34         mov   @fb.current,tmp1      ; Get position
     77B8 2202 
0087 77BA C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     77BC 8392 
0088               
0089                       ;------------------------------------------------------
0090                       ; Scan line for >00 byte termination
0091                       ;------------------------------------------------------
0092               edb.line.pack.scan:
0093 77BE D1B5  28         movb  *tmp1+,tmp2           ; Get char
0094 77C0 0986  56         srl   tmp2,8                ; Right justify
0095 77C2 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0096 77C4 0584  14         inc   tmp0                  ; Increase string length
0097 77C6 10FB  14         jmp   edb.line.pack.scan    ; Next character
0098               
0099                       ;------------------------------------------------------
0100                       ; Prepare for storing line
0101                       ;------------------------------------------------------
0102               edb.line.pack.prepare:
0103 77C8 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     77CA 2204 
     77CC 8350 
0104 77CE A820  54         a     @fb.row,@parm1        ; /
     77D0 2206 
     77D2 8350 
0105               
0106 77D4 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     77D6 8394 
0107               
0108                       ;------------------------------------------------------
0109                       ; 1. Update index
0110                       ;------------------------------------------------------
0111               edb.line.pack.update_index:
0112 77D8 C120  34         mov   @edb.next_free.ptr,tmp0
     77DA 2308 
0113 77DC C804  38         mov   tmp0,@parm2           ; Block where line will reside
     77DE 8352 
0114               
0115 77E0 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     77E2 63E4 
0116                                                   ; \ i  tmp0  = Memory address
0117                                                   ; | o  waux1 = SAMS page number
0118                                                   ; / o  waux2 = Address of SAMS register
0119               
0120 77E4 C820  54         mov   @waux1,@parm3         ; Save SAMS page number
     77E6 833C 
     77E8 8354 
0121               
0122 77EA 06A0  32         bl    @idx.entry.update     ; Update index
     77EC 76CE 
0123                                                   ; \ i  parm1 = Line number in editor buffer
0124                                                   ; | i  parm2 = pointer to line in editor buffer
0125                                                   ; / i  parm3 = SAMS page
0126               
0127                       ;------------------------------------------------------
0128                       ; 2. Switch to required SAMS page
0129                       ;------------------------------------------------------
0130                       ;mov   @edb.sams.page,tmp0   ; Current SAMS page
0131                       ;mov   @edb.next_free.ptr,tmp1
0132                                                   ; Pointer to line in editor buffer
0133                 ;     bl    @xsams.page           ; Switch to SAMS page
0134                                                   ; \ i  tmp0 = SAMS page
0135                                                   ; / i  tmp1 = Memory address
0136               
0137                       ;------------------------------------------------------
0138                       ; 3. Set line prefix in editor buffer
0139                       ;------------------------------------------------------
0140 77EE C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     77F0 8392 
0141 77F2 C160  34         mov   @edb.next_free.ptr,tmp1
     77F4 2308 
0142                                                   ; Address of line in editor buffer
0143               
0144 77F6 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     77F8 2308 
0145               
0146 77FA C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     77FC 8394 
0147 77FE 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0148 7800 06C6  14         swpb  tmp2
0149 7802 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0150 7804 06C6  14         swpb  tmp2
0151 7806 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0152               
0153                       ;------------------------------------------------------
0154                       ; 4. Copy line from framebuffer to editor buffer
0155                       ;------------------------------------------------------
0156               edb.line.pack.copyline:
0157 7808 0286  22         ci    tmp2,2
     780A 0002 
0158 780C 1603  14         jne   edb.line.pack.copyline.checkbyte
0159 780E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0160 7810 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0161 7812 1007  14         jmp   !
0162               edb.line.pack.copyline.checkbyte:
0163 7814 0286  22         ci    tmp2,1
     7816 0001 
0164 7818 1602  14         jne   edb.line.pack.copyline.block
0165 781A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0166 781C 1002  14         jmp   !
0167               edb.line.pack.copyline.block:
0168 781E 06A0  32         bl    @xpym2m               ; Copy memory block
     7820 6386 
0169                                                   ; \ i  tmp0 = source
0170                                                   ; | i  tmp1 = destination
0171                                                   ; / i  tmp2 = bytes to copy
0172               
0173 7822 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     7824 8394 
     7826 2308 
0174                                                   ; Update pointer to next free line
0175               
0176                       ;------------------------------------------------------
0177                       ; Exit
0178                       ;------------------------------------------------------
0179               edb.line.pack.exit:
0180 7828 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     782A 8390 
     782C 220C 
0181 782E 0460  28         b     @poprt                ; Return to caller
     7830 6132 
0182               
0183               
0184               
0185               
0186               ***************************************************************
0187               * edb.line.unpack
0188               * Unpack specified line to framebuffer
0189               ***************************************************************
0190               *  bl   @edb.line.unpack
0191               *--------------------------------------------------------------
0192               * INPUT
0193               * @parm1 = Line to unpack from editor buffer
0194               * @parm2 = Target row in frame buffer
0195               *--------------------------------------------------------------
0196               * OUTPUT
0197               * none
0198               *--------------------------------------------------------------
0199               * Register usage
0200               * tmp0,tmp1,tmp2,tmp3
0201               *--------------------------------------------------------------
0202               * Memory usage
0203               * rambuf    = Saved @parm1 of edb.line.unpack
0204               * rambuf+2  = Saved @parm2 of edb.line.unpack
0205               * rambuf+4  = Source memory address in editor buffer
0206               * rambuf+6  = Destination memory address in frame buffer
0207               * rambuf+8  = Length of RLE (decompressed) line
0208               * rambuf+10 = Length of RLE compressed line
0209               ********|*****|*********************|**************************
0210               edb.line.unpack:
0211 7832 0649  14         dect  stack
0212 7834 C64B  30         mov   r11,*stack            ; Save return address
0213                       ;------------------------------------------------------
0214                       ; Save parameters
0215                       ;------------------------------------------------------
0216 7836 C820  54         mov   @parm1,@rambuf
     7838 8350 
     783A 8390 
0217 783C C820  54         mov   @parm2,@rambuf+2
     783E 8352 
     7840 8392 
0218                       ;------------------------------------------------------
0219                       ; Calculate offset in frame buffer
0220                       ;------------------------------------------------------
0221 7842 C120  34         mov   @fb.colsline,tmp0
     7844 220E 
0222 7846 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7848 8352 
0223 784A C1A0  34         mov   @fb.top.ptr,tmp2
     784C 2200 
0224 784E A146  18         a     tmp2,tmp1             ; Add base to offset
0225 7850 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7852 8396 
0226                       ;------------------------------------------------------
0227                       ; Get length of line to unpack
0228                       ;------------------------------------------------------
0229 7854 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7856 78BE 
0230                                                   ; \ i  parm1    = Line number
0231                                                   ; | o  outparm1 = Line length (uncompressed)
0232                                                   ; | o  outparm2 = Line length (compressed)
0233                                                   ; / o  outparm3 = SAMS page
0234               
0235 7858 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     785A 8362 
     785C 839A 
0236 785E C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7860 8360 
     7862 8398 
0237 7864 130D  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0238               
0239                       ;------------------------------------------------------
0240                       ; Index. Calculate address of entry and get pointer
0241                       ;------------------------------------------------------
0242 7866 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7868 7764 
0243                                                   ; \ i  parm1    = Line number
0244                                                   ; | o  outparm1 = Pointer to line
0245                                                   ; / o  outparm2 = SAMS page
0246               
0247 786A C120  34         mov   @outparm2,tmp0        ; SAMS page
     786C 8362 
0248 786E C160  34         mov   @outparm1,tmp1        ; Memory address
     7870 8360 
0249 7872 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     7874 641C 
0250                                                   ; \ i  tmp0 = SAMS page
0251                                                   ; / i  tmp1 = Memory address
0252               
0253 7876 05E0  34         inct  @outparm1             ; Skip line prefix
     7878 8360 
0254 787A C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     787C 8360 
     787E 8394 
0255               
0256                       ;------------------------------------------------------
0257                       ; Erase chars from last column until column 80
0258                       ;------------------------------------------------------
0259               edb.line.unpack.clear:
0260 7880 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7882 8396 
0261 7884 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7886 8398 
0262               
0263 7888 04C5  14         clr   tmp1                  ; Fill with >00
0264 788A C1A0  34         mov   @fb.colsline,tmp2
     788C 220E 
0265 788E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7890 8398 
0266 7892 0586  14         inc   tmp2
0267               
0268 7894 06A0  32         bl    @xfilm                ; Fill CPU memory
     7896 613C 
0269                                                   ; \ i  tmp0 = Target address
0270                                                   ; | i  tmp1 = Byte to fill
0271                                                   ; / i  tmp2 = Repeat count
0272                       ;------------------------------------------------------
0273                       ; Prepare for unpacking data
0274                       ;------------------------------------------------------
0275               edb.line.unpack.prepare:
0276 7898 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     789A 8398 
0277 789C 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0278 789E C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     78A0 8394 
0279 78A2 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     78A4 8396 
0280                       ;------------------------------------------------------
0281                       ; Either RLE decompress or do normal memory copy
0282                       ;------------------------------------------------------
0283 78A6 C1E0  34         mov   @edb.rle,tmp3
     78A8 230C 
0284 78AA 1305  14         jeq   edb.line.unpack.copy.uncompressed
0285                       ;------------------------------------------------------
0286                       ; Uncompress RLE line to frame buffer
0287                       ;------------------------------------------------------
0288 78AC C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     78AE 839A 
0289               
0290 78B0 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     78B2 6968 
0291                                                   ; \ i  tmp0 = ROM/RAM source address
0292                                                   ; | i  tmp1 = RAM target address
0293                                                   ; / i  tmp2 = Length of RLE encoded data
0294 78B4 1002  14         jmp   edb.line.unpack.exit
0295                       ;------------------------------------------------------
0296                       ; Copy memory block
0297                       ;------------------------------------------------------
0298               edb.line.unpack.copy.uncompressed:
0299 78B6 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     78B8 6386 
0300                                                   ; \ i  tmp0 = Source address
0301                                                   ; | i  tmp1 = Target address
0302                                                   ; / i  tmp2 = Bytes to copy
0303                       ;------------------------------------------------------
0304                       ; Exit
0305                       ;------------------------------------------------------
0306               edb.line.unpack.exit:
0307 78BA 0460  28         b     @poprt                ; Return to caller
     78BC 6132 
0308               
0309               
0310               
0311               
0312               ***************************************************************
0313               * edb.line.getlength
0314               * Get length of specified line
0315               ***************************************************************
0316               *  bl   @edb.line.getlength
0317               *--------------------------------------------------------------
0318               * INPUT
0319               * @parm1 = Line number
0320               *--------------------------------------------------------------
0321               * OUTPUT
0322               * @outparm1 = Length of line (uncompressed)
0323               * @outparm2 = Length of line (compressed)
0324               * @outparm3 = SAMS page
0325               *--------------------------------------------------------------
0326               * Register usage
0327               * tmp0,tmp1,tmp2
0328               ********|*****|*********************|**************************
0329               edb.line.getlength:
0330 78BE 0649  14         dect  stack
0331 78C0 C64B  30         mov   r11,*stack            ; Save return address
0332                       ;------------------------------------------------------
0333                       ; Initialisation
0334                       ;------------------------------------------------------
0335 78C2 04E0  34         clr   @outparm1             ; Reset uncompressed length
     78C4 8360 
0336 78C6 04E0  34         clr   @outparm2             ; Reset compressed length
     78C8 8362 
0337 78CA 04E0  34         clr   @outparm3             ; Reset SAMS bank
     78CC 8364 
0338                       ;------------------------------------------------------
0339                       ; Get length
0340                       ;------------------------------------------------------
0341 78CE 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     78D0 7764 
0342                                                   ; \ i  parm1    = Line number
0343                                                   ; | o  outparm1 = Pointer to line
0344                                                   ; / o  outparm2 = SAMS page
0345               
0346 78D2 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     78D4 8360 
0347 78D6 130D  14         jeq   edb.line.getlength.exit
0348                                                   ; Exit early if NULL pointer
0349 78D8 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     78DA 8362 
     78DC 8364 
0350                       ;------------------------------------------------------
0351                       ; Process line prefix
0352                       ;------------------------------------------------------
0353 78DE 04C5  14         clr   tmp1
0354 78E0 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0355 78E2 06C5  14         swpb  tmp1
0356 78E4 C805  38         mov   tmp1,@outparm2        ; Save length
     78E6 8362 
0357               
0358 78E8 04C5  14         clr   tmp1
0359 78EA D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0360 78EC 06C5  14         swpb  tmp1
0361 78EE C805  38         mov   tmp1,@outparm1        ; Save length
     78F0 8360 
0362                       ;------------------------------------------------------
0363                       ; Exit
0364                       ;------------------------------------------------------
0365               edb.line.getlength.exit:
0366 78F2 0460  28         b     @poprt                ; Return to caller
     78F4 6132 
0367               
0368               
0369               
0370               
0371               ***************************************************************
0372               * edb.line.getlength2
0373               * Get length of current row (as seen from editor buffer side)
0374               ***************************************************************
0375               *  bl   @edb.line.getlength2
0376               *--------------------------------------------------------------
0377               * INPUT
0378               * @fb.row = Row in frame buffer
0379               *--------------------------------------------------------------
0380               * OUTPUT
0381               * @fb.row.length = Length of row
0382               *--------------------------------------------------------------
0383               * Register usage
0384               * tmp0
0385               ********|*****|*********************|**************************
0386               edb.line.getlength2:
0387 78F6 0649  14         dect  stack
0388 78F8 C64B  30         mov   r11,*stack            ; Save return address
0389                       ;------------------------------------------------------
0390                       ; Calculate line in editor buffer
0391                       ;------------------------------------------------------
0392 78FA C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     78FC 2204 
0393 78FE A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7900 2206 
0394                       ;------------------------------------------------------
0395                       ; Get length
0396                       ;------------------------------------------------------
0397 7902 C804  38         mov   tmp0,@parm1
     7904 8350 
0398 7906 06A0  32         bl    @edb.line.getlength
     7908 78BE 
0399 790A C820  54         mov   @outparm1,@fb.row.length
     790C 8360 
     790E 2208 
0400                                                   ; Save row length
0401                       ;------------------------------------------------------
0402                       ; Exit
0403                       ;------------------------------------------------------
0404               edb.line.getlength2.exit:
0405 7910 0460  28         b     @poprt                ; Return to caller
     7912 6132 
0406               
**** **** ****     > tivi.asm.11019
0630               
0631               ***************************************************************
0632               *               fh - File handling module
0633               ***************************************************************
0634                       copy  "filehandler.asm"
**** **** ****     > filehandler.asm
0001               * FILE......: filehandler.asm
0002               * Purpose...: File handling module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tfh.file.read
0011               * Read file into editor buffer
0012               ***************************************************************
0013               *  bl   @tfh.file.read
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = pointer to length-prefixed file descriptor
0017               * parm2 = RLE compression on (>FFFF) or off (>0000)
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0, tmp1, tmp2, tmp3, tmp4
0023               *--------------------------------------------------------------
0024               * The frame buffer is temporarily used for compressing the line
0025               * before it is moved to the editor buffer
0026               ********|*****|*********************|**************************
0027               tfh.file.read:
0028 7914 0649  14         dect  stack
0029 7916 C64B  30         mov   r11,*stack            ; Save return address
0030 7918 C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     791A 8352 
     791C 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 791E 04E0  34         clr   @tfh.records          ; Reset records counter
     7920 242E 
0035 7922 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7924 2434 
0036 7926 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7928 2432 
0037 792A 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 792C 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     792E 242A 
0039 7930 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7932 242C 
0040               
0041 7934 0204  20         li    tmp0,3
     7936 0003 
0042 7938 C804  38         mov   tmp0,@tfh.sams.page   ; Set current SAMS page
     793A 2438 
0043 793C C804  38         mov   tmp0,@tfh.sams.hpage  ; Set highest SAMS page in use
     793E 243A 
0044               
0045                       ;------------------------------------------------------
0046                       ; Show loading indicators and file descriptor
0047                       ;------------------------------------------------------
0048 7940 06A0  32         bl    @hchar
     7942 661A 
0049 7944 1D00                   byte 29,0,32,80
     7946 2050 
0050 7948 FFFF                   data EOL
0051               
0052 794A 06A0  32         bl    @putat
     794C 6330 
0053 794E 1D00                   byte 29,0
0054 7950 7B9A                   data txt_loading      ; Display "Loading...."
0055               
0056 7952 8820  54         c     @tfh.rleonload,@w$ffff
     7954 2436 
     7956 6048 
0057 7958 1604  14         jne   !
0058 795A 06A0  32         bl    @putat
     795C 6330 
0059 795E 1D44                   byte 29,68
0060 7960 7BAA                   data txt_rle          ; Display "RLE"
0061               
0062 7962 06A0  32 !       bl    @at
     7964 6526 
0063 7966 1D0B                   byte 29,11            ; Cursor YX position
0064 7968 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     796A 8350 
0065 796C 06A0  32         bl    @xutst0               ; Display device/filename
     796E 6320 
0066                       ;------------------------------------------------------
0067                       ; Copy PAB header to VDP
0068                       ;------------------------------------------------------
0069 7970 06A0  32         bl    @cpym2v
     7972 6338 
0070 7974 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7976 7B5C 
     7978 0009 
0071                                                   ; Copy PAB header to VDP
0072                       ;------------------------------------------------------
0073                       ; Append file descriptor to PAB header in VDP
0074                       ;------------------------------------------------------
0075 797A 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     797C 0A69 
0076 797E C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7980 8350 
0077 7982 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0078 7984 0986  56         srl   tmp2,8                ; Right justify
0079 7986 0586  14         inc   tmp2                  ; Include length byte as well
0080 7988 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     798A 633E 
0081                       ;------------------------------------------------------
0082                       ; Load GPL scratchpad layout
0083                       ;------------------------------------------------------
0084 798C 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     798E 6A2C 
0085 7990 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0086                       ;------------------------------------------------------
0087                       ; Open file
0088                       ;------------------------------------------------------
0089 7992 06A0  32         bl    @file.open
     7994 6B7A 
0090 7996 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0091 7998 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     799A 6042 
0092 799C 1602  14         jne   tfh.file.read.record
0093 799E 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     79A0 7B10 
0094                       ;------------------------------------------------------
0095                       ; Step 1: Read file record
0096                       ;------------------------------------------------------
0097               tfh.file.read.record:
0098 79A2 05A0  34         inc   @tfh.records          ; Update counter
     79A4 242E 
0099 79A6 04E0  34         clr   @tfh.reclen           ; Reset record length
     79A8 2430 
0100               
0101 79AA 06A0  32         bl    @file.record.read     ; Read file record
     79AC 6BBC 
0102 79AE 0A60                   data tfh.vpab         ; \ i  p0   = Address of PAB in VDP RAM (without +9 offset!)
0103                                                   ; | o  tmp0 = Status byte
0104                                                   ; | o  tmp1 = Bytes read
0105                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0106               
0107 79B0 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     79B2 242A 
0108 79B4 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     79B6 2430 
0109 79B8 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     79BA 242C 
0110                       ;------------------------------------------------------
0111                       ; 1a: Calculate kilobytes processed
0112                       ;------------------------------------------------------
0113 79BC A805  38         a     tmp1,@tfh.counter
     79BE 2434 
0114 79C0 A160  34         a     @tfh.counter,tmp1
     79C2 2434 
0115 79C4 0285  22         ci    tmp1,1024
     79C6 0400 
0116 79C8 1106  14         jlt   !
0117 79CA 05A0  34         inc   @tfh.kilobytes
     79CC 2432 
0118 79CE 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     79D0 FC00 
0119 79D2 C805  38         mov   tmp1,@tfh.counter
     79D4 2434 
0120                       ;------------------------------------------------------
0121                       ; 1b: Load spectra scratchpad layout
0122                       ;------------------------------------------------------
0123 79D6 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     79D8 69B2 
0124 79DA 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     79DC 6A4E 
0125 79DE 2100                   data scrpad.backup2   ; / >2100->8300
0126                       ;------------------------------------------------------
0127                       ; 1c: Check if a file error occured
0128                       ;------------------------------------------------------
0129               tfh.file.read.check:
0130 79E0 C1A0  34         mov   @tfh.ioresult,tmp2
     79E2 242C 
0131 79E4 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     79E6 6042 
0132 79E8 1602  14         jne   tfh.file.read.sams    ; No, goto (1d)
0133 79EA 0460  28         b     @tfh.file.read.error  ; Yes, so handle file error
     79EC 7B10 
0134                       ;------------------------------------------------------
0135                       ; 1d: Check if SAMS page needs to be set
0136                       ;------------------------------------------------------
0137               tfh.file.read.sams:
0138 79EE C120  34         mov   @edb.next_free.ptr,tmp0
     79F0 2308 
0139 79F2 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     79F4 63E4 
0140                                                   ; \ i  tmp0  = Memory address
0141                                                   ; | o  waux1 = SAMS page number
0142                                                   ; / o  waux2 = Address of SAMS register
0143               
0144 79F6 C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     79F8 833C 
0145 79FA 8804  38         c     tmp0,@tfh.sams.page   ; Compare page with current SAMS page
     79FC 2438 
0146 79FE 1310  14         jeq   tfh.file.read.rlecheck
0147                                                   ; Same, skip to (1g)
0148                       ;------------------------------------------------------
0149                       ; 1e: Increase SAMS page if necessary
0150                       ;------------------------------------------------------
0151 7A00 8804  38         c     tmp0,@tfh.sams.hpage  ; Compare page with highest SAMS page
     7A02 243A 
0152 7A04 1502  14         jgt   tfh.file.read.sams.switch
0153                                                   ; Switch page
0154 7A06 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     7A08 0005 
0155                       ;------------------------------------------------------
0156                       ; 1f: Switch to SAMS page
0157                       ;------------------------------------------------------
0158               tfh.file.read.sams.switch:
0159 7A0A C160  34         mov   @edb.next_free.ptr,tmp1
     7A0C 2308 
0160 7A0E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7A10 641C 
0161                                                   ; \ i  tmp0 = SAMS page number
0162                                                   ; / i  tmp1 = Memory address
0163               
0164 7A12 C804  38         mov   tmp0,@tfh.sams.page   ; Save current SAMS page
     7A14 2438 
0165               
0166 7A16 8804  38         c     tmp0,@tfh.sams.hpage  ; Current SAMS page > highest SAMS page?
     7A18 243A 
0167 7A1A 1202  14         jle   tfh.file.read.rlecheck
0168                                                   ; No, skip to (1g)
0169 7A1C C804  38         mov   tmp0,@tfh.sams.hpage  ; Update highest SAMS page
     7A1E 243A 
0170                       ;------------------------------------------------------
0171                       ; 1g: Decide on copy line from VDP buffer to editor
0172                       ;     buffer (RLE off) or RAM buffer (RLE on)
0173                       ;------------------------------------------------------
0174               tfh.file.read.rlecheck:
0175 7A20 8820  54         c     @tfh.rleonload,@w$ffff
     7A22 2436 
     7A24 6048 
0176                                                   ; RLE compression on?
0177 7A26 1314  14         jeq   tfh.file.read.compression
0178                                                   ; Yes, do RLE compression
0179                       ;------------------------------------------------------
0180                       ; Step 2: Process line without doing RLE compression
0181                       ;------------------------------------------------------
0182               tfh.file.read.nocompression:
0183 7A28 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7A2A 0960 
0184 7A2C C160  34         mov   @edb.next_free.ptr,tmp1
     7A2E 2308 
0185                                                   ; RAM target in editor buffer
0186               
0187 7A30 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7A32 8352 
0188               
0189 7A34 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7A36 2430 
0190 7A38 133A  14         jeq   tfh.file.read.prepindex.emptyline
0191                                                   ; Handle empty line
0192                       ;------------------------------------------------------
0193                       ; 2a: Copy line from VDP to CPU editor buffer
0194                       ;------------------------------------------------------
0195                                                   ; Save line prefix
0196 7A3A DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0197 7A3C 06C6  14         swpb  tmp2                  ; |
0198 7A3E DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0199 7A40 06C6  14         swpb  tmp2                  ; /
0200               
0201 7A42 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7A44 2308 
0202 7A46 A806  38         a     tmp2,@edb.next_free.ptr
     7A48 2308 
0203                                                   ; Add line length
0204               
0205 7A4A 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7A4C 6364 
0206                                                   ; \ i  tmp0 = VDP source address
0207                                                   ; | i  tmp1 = RAM target address
0208                                                   ; / i  tmp2 = Bytes to copy
0209               
0210 7A4E 1028  14         jmp   tfh.file.read.prepindex
0211                                                   ; Prepare for updating index
0212                       ;------------------------------------------------------
0213                       ; Step 3: Process line and do RLE compression
0214                       ;------------------------------------------------------
0215               tfh.file.read.compression:
0216 7A50 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7A52 0960 
0217 7A54 0205  20         li    tmp1,fb.top           ; RAM target address
     7A56 2650 
0218 7A58 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7A5A 2430 
0219 7A5C 1328  14         jeq   tfh.file.read.prepindex.emptyline
0220                                                   ; Handle empty line
0221               
0222 7A5E 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7A60 6364 
0223                                                   ; \ i  tmp0 = VDP source address
0224                                                   ; | i  tmp1 = RAM target address
0225                                                   ; / i  tmp2 = Bytes to copy
0226                       ;------------------------------------------------------
0227                       ; 3a: RLE compression on line
0228                       ;------------------------------------------------------
0229 7A62 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     7A64 2650 
0230 7A66 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     7A68 26F0 
0231 7A6A C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     7A6C 2430 
0232               
0233 7A6E 06A0  32         bl    @xcpu2rle             ; RLE compression
     7A70 68B6 
0234                                                   ; \ i  tmp0  = ROM/RAM source address
0235                                                   ; | i  tmp1  = RAM target address
0236                                                   ; | i  tmp2  = Length uncompressed data
0237                                                   ; / o  waux1 = Length RLE encoded string
0238                       ;------------------------------------------------------
0239                       ; 3b: Set line prefix
0240                       ;------------------------------------------------------
0241 7A72 C160  34         mov   @edb.next_free.ptr,tmp1
     7A74 2308 
0242                                                   ; RAM target address
0243 7A76 C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     7A78 8352 
0244 7A7A C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7A7C 833C 
0245 7A7E 06C6  14         swpb  tmp2                  ;
0246 7A80 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0247               
0248 7A82 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     7A84 2430 
0249 7A86 06C6  14         swpb  tmp2
0250 7A88 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0251 7A8A 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     7A8C 2308 
0252                       ;------------------------------------------------------
0253                       ; 3c: Copy compressed line to editor buffer
0254                       ;------------------------------------------------------
0255 7A8E 0204  20         li    tmp0,fb.top+160       ; RAM source address
     7A90 26F0 
0256 7A92 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7A94 833C 
0257               
0258 7A96 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7A98 6386 
0259                                                   ; \ i  tmp0 = RAM source address
0260                                                   ; | i  tmp1 = RAM target address
0261                                                   ; / i  tmp2 = Bytes to copy
0262               
0263 7A9A A820  54         a     @waux1,@edb.next_free.ptr
     7A9C 833C 
     7A9E 2308 
0264                                                   ; Update pointer to next free line
0265                       ;------------------------------------------------------
0266                       ; Step 4: Update index
0267                       ;------------------------------------------------------
0268               tfh.file.read.prepindex:
0269 7AA0 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7AA2 2304 
     7AA4 8350 
0270                                                   ; parm2 = Must allready be set!
0271 7AA6 C820  54         mov   @tfh.sams.page,@parm3 ; parm3 = SAMS page number
     7AA8 2438 
     7AAA 8354 
0272               
0273 7AAC 1009  14         jmp   tfh.file.read.updindex
0274                                                   ; Update index
0275                       ;------------------------------------------------------
0276                       ; 4a: Special handling for empty line
0277                       ;------------------------------------------------------
0278               tfh.file.read.prepindex.emptyline:
0279 7AAE C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7AB0 242E 
     7AB2 8350 
0280 7AB4 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7AB6 8350 
0281 7AB8 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7ABA 8352 
0282 7ABC 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7ABE 8354 
0283                       ;------------------------------------------------------
0284                       ; 4b: Do actual index update
0285                       ;------------------------------------------------------
0286               tfh.file.read.updindex:
0287 7AC0 06A0  32         bl    @idx.entry.update     ; Update index
     7AC2 76CE 
0288                                                   ; \ i  parm1    = Line number in editor buffer
0289                                                   ; | i  parm2    = Pointer to line in editor buffer
0290                                                   ; | i  parm3    = SAMS page
0291                                                   ; / o  outparm1 = Pointer to updated index entry
0292               
0293 7AC4 05A0  34         inc   @edb.lines            ; lines=lines+1
     7AC6 2304 
0294                       ;------------------------------------------------------
0295                       ; Step 5: Display results
0296                       ;------------------------------------------------------
0297               tfh.file.read.display:
0298 7AC8 06A0  32         bl    @putnum
     7ACA 68A6 
0299 7ACC 1D49                   byte 29,73            ; Show lines read
0300 7ACE 2304                   data edb.lines,rambuf,>3020
     7AD0 8390 
     7AD2 3020 
0301               
0302 7AD4 8220  34         c     @tfh.kilobytes,tmp4
     7AD6 2432 
0303 7AD8 130C  14         jeq   tfh.file.read.checkmem
0304               
0305 7ADA C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7ADC 2432 
0306               
0307 7ADE 06A0  32         bl    @putnum
     7AE0 68A6 
0308 7AE2 1D38                   byte 29,56            ; Show kilobytes read
0309 7AE4 2432                   data tfh.kilobytes,rambuf,>3020
     7AE6 8390 
     7AE8 3020 
0310               
0311 7AEA 06A0  32         bl    @putat
     7AEC 6330 
0312 7AEE 1D3D                   byte 29,61
0313 7AF0 7BA6                   data txt_kb           ; Show "kb" string
0314               
0315               ******************************************************
0316               * Stop reading file if high memory expansion gets full
0317               ******************************************************
0318               tfh.file.read.checkmem:
0319 7AF2 C120  34         mov   @edb.next_free.ptr,tmp0
     7AF4 2308 
0320 7AF6 0284  22         ci    tmp0,>ffa0
     7AF8 FFA0 
0321 7AFA 1205  14         jle   tfh.file.read.next
0322                       ;------------------------------------------------------
0323                       ; Address range b000-ffff full, switch SAMS pages
0324                       ;------------------------------------------------------
0325 7AFC 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     7AFE B002 
0326 7B00 C804  38         mov   tmp0,@edb.next_free.ptr
     7B02 2308 
0327               
0328 7B04 1000  14         jmp   tfh.file.read.next
0329                       ;------------------------------------------------------
0330                       ; Next record
0331                       ;------------------------------------------------------
0332               tfh.file.read.next:
0333 7B06 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7B08 6A2C 
0334 7B0A 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0335               
0336 7B0C 0460  28         b     @tfh.file.read.record
     7B0E 79A2 
0337                                                   ; Next record
0338                       ;------------------------------------------------------
0339                       ; Error handler
0340                       ;------------------------------------------------------
0341               tfh.file.read.error:
0342 7B10 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7B12 242A 
0343 7B14 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0344 7B16 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7B18 0005 
0345 7B1A 1304  14         jeq   tfh.file.read.eof     ; All good. File closed by DSRLNK
0346                       ;------------------------------------------------------
0347                       ; File error occured
0348                       ;------------------------------------------------------
0349 7B1C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7B1E FFCE 
0350 7B20 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7B22 604C 
0351                       ;------------------------------------------------------
0352                       ; End-Of-File reached
0353                       ;------------------------------------------------------
0354               tfh.file.read.eof:
0355 7B24 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7B26 6A4E 
0356 7B28 2100                   data scrpad.backup2   ; / >2100->8300
0357                       ;------------------------------------------------------
0358                       ; Display final results
0359                       ;------------------------------------------------------
0360 7B2A 06A0  32         bl    @hchar
     7B2C 661A 
0361 7B2E 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7B30 200A 
0362 7B32 FFFF                   data EOL
0363               
0364 7B34 06A0  32         bl    @putnum
     7B36 68A6 
0365 7B38 1D38                   byte 29,56            ; Show kilobytes read
0366 7B3A 2432                   data tfh.kilobytes,rambuf,>3020
     7B3C 8390 
     7B3E 3020 
0367               
0368 7B40 06A0  32         bl    @putat
     7B42 6330 
0369 7B44 1D3D                   byte 29,61
0370 7B46 7BA6                   data txt_kb           ; Show "kb" string
0371               
0372 7B48 06A0  32         bl    @putnum
     7B4A 68A6 
0373 7B4C 1D49                   byte 29,73            ; Show lines read
0374 7B4E 242E                   data tfh.records,rambuf,>3020
     7B50 8390 
     7B52 3020 
0375               
0376 7B54 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7B56 2306 
0377               *--------------------------------------------------------------
0378               * Exit
0379               *--------------------------------------------------------------
0380               tfh.file.read_exit:
0381 7B58 0460  28         b     @poprt                ; Return to caller
     7B5A 6132 
0382               
0383               
0384               ***************************************************************
0385               * PAB for accessing DV/80 file
0386               ********|*****|*********************|**************************
0387               tfh.file.pab.header:
0388 7B5C 0014             byte  io.op.open            ;  0    - OPEN
0389                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0390 7B5E 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0391 7B60 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0392                       byte  00                    ;  5    - Character count
0393 7B62 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0394 7B64 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0395                       ;------------------------------------------------------
0396                       ; File descriptor part (variable length)
0397                       ;------------------------------------------------------
0398                       ; byte  12                  ;  9    - File descriptor length
0399                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.11019
0635               
0636               
0637               ***************************************************************
0638               *                      Constants
0639               ***************************************************************
0640               romsat:
0641 7B66 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7B68 000F 
0642               
0643               cursors:
0644 7B6A 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7B6C 0000 
     7B6E 0000 
     7B70 001C 
0645 7B72 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7B74 1010 
     7B76 1010 
     7B78 1000 
0646 7B7A 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7B7C 1C1C 
     7B7E 1C1C 
     7B80 1C00 
0647               
0648               ***************************************************************
0649               *                       Strings
0650               ***************************************************************
0651               txt_delim
0652 7B82 012C             byte  1
0653 7B83 ....             text  ','
0654                       even
0655               
0656               txt_marker
0657 7B84 052A             byte  5
0658 7B85 ....             text  '*EOF*'
0659                       even
0660               
0661               txt_bottom
0662 7B8A 0520             byte  5
0663 7B8B ....             text  '  BOT'
0664                       even
0665               
0666               txt_ovrwrite
0667 7B90 034F             byte  3
0668 7B91 ....             text  'OVR'
0669                       even
0670               
0671               txt_insert
0672 7B94 0349             byte  3
0673 7B95 ....             text  'INS'
0674                       even
0675               
0676               txt_star
0677 7B98 012A             byte  1
0678 7B99 ....             text  '*'
0679                       even
0680               
0681               txt_loading
0682 7B9A 0A4C             byte  10
0683 7B9B ....             text  'Loading...'
0684                       even
0685               
0686               txt_kb
0687 7BA6 026B             byte  2
0688 7BA7 ....             text  'kb'
0689                       even
0690               
0691               txt_rle
0692 7BAA 0352             byte  3
0693 7BAB ....             text  'RLE'
0694                       even
0695               
0696               txt_lines
0697 7BAE 054C             byte  5
0698 7BAF ....             text  'Lines'
0699                       even
0700               
0701 7BB4 7BB4     end          data    $
0702               
0703               
0704               fdname0
0705 7BB6 0D44             byte  13
0706 7BB7 ....             text  'DSK1.INVADERS'
0707                       even
0708               
0709               fdname1
0710 7BC4 0F44             byte  15
0711 7BC5 ....             text  'DSK1.SPEECHDOCS'
0712                       even
0713               
0714               fdname2
0715 7BD4 0C44             byte  12
0716 7BD5 ....             text  'DSK1.XBEADOC'
0717                       even
0718               
0719               fdname3
0720 7BE2 0C44             byte  12
0721 7BE3 ....             text  'DSK3.XBEADOC'
0722                       even
0723               
0724               fdname4
0725 7BF0 0C44             byte  12
0726 7BF1 ....             text  'DSK3.C99MAN1'
0727                       even
0728               
0729               fdname5
0730 7BFE 0C44             byte  12
0731 7BFF ....             text  'DSK3.C99MAN2'
0732                       even
0733               
0734               fdname6
0735 7C0C 0C44             byte  12
0736 7C0D ....             text  'DSK3.C99MAN3'
0737                       even
0738               
0739               fdname7
0740 7C1A 0D44             byte  13
0741 7C1B ....             text  'DSK3.C99SPECS'
0742                       even
0743               
0744               fdname8
0745 7C28 0D44             byte  13
0746 7C29 ....             text  'DSK3.RANDOM#C'
0747                       even
0748               
0749               fdname9
0750 7C36 0D44             byte  13
0751 7C37 ....             text  'DSK1.INVADERS'
0752                       even
0753               
0754               
0755               
0756               ***************************************************************
0757               *                  Sanity check on ROM size
0758               ***************************************************************
0762 7C44 7C44              data $   ; ROM size OK.

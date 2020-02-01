XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.23569
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200201-23569
0009               *--------------------------------------------------------------
0010               * TI-99/4a Advanced Editor & IDE
0011               *--------------------------------------------------------------
0012               * TiVi memory layout.
0013               * See file "modules/memory.asm" for further details.
0014               *
0015               * Mem range   Bytes    Hex    Purpose
0016               * =========   =====    ===    ==================================
0017               * 8300-83ff     256   >0100   scrpad spectra2 layout
0018               * 2000-20ff     256   >0100   scrpad backup 1: GPL layout
0019               * 2100-21ff     256   >0100   scrpad backup 2: paged out spectra2
0020               * 2200-22ff     256   >0100   TiVi frame buffer structure
0021               * 2300-23ff     256   >0100   TiVi editor buffer structure
0022               * 2400-24ff     256   >0100   TiVi file handling structure
0023               * 2500-25ff     256   >0100   Free for future use
0024               * 2600-264f      80   >0050   Free for future use
0025               * 2650-2faf    2400   >0960   Frame buffer 80x30
0026               * 2fb0-2fff     160   >00a0   Free for future use
0027               * 3000-3fff    4096   >1000   Index for 2048 lines
0028               * a000-ffff   24576   >6000   Editor buffer
0029               *--------------------------------------------------------------
0030               * Mem range  Bytes     SAMS   Purpose
0031               * =========  =====     ====   =======
0032               * 2000-2fff   4096     no     Scratchpad/GPL backup, TiVi structures
0033               * 3000-3fff   4096     yes    Index, Shadow index
0034               * a000-afff   4096     yes    Editor buffer
0035               * b000-bfff   4096     yes    Editor buffer
0036               * c000-cfff   4096     yes    Editor buffer
0037               * d000-dfff   4096     yes    Editor buffer
0038               * e000-efff   4096     yes    Editor buffer
0039               * f000-ffff   4096     yes    Editor buffer
0040               *--------------------------------------------------------------
0041               * TiVi VDP layout
0042               *
0043               * Mem range   Bytes    Hex    Purpose
0044               * =========   =====   ====    =================================
0045               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0046               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0047               * 0fc0                        PCT - Pattern Color Table
0048               * 1000                        PDT - Pattern Descriptor Table
0049               * 1800                        SPT - Sprite Pattern Table
0050               * 2000                        SAT - Sprite Attribute List
0051               *--------------------------------------------------------------
0052               * EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
0053               *--------------------------------------------------------------
0054      0001     debug                   equ  1      ; Turn on spectra2 debugging
0055               *--------------------------------------------------------------
0056               * Skip unused spectra2 code modules for reduced code size
0057               *--------------------------------------------------------------
0058      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0059      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0060      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0061      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0062      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0063      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0064      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0065      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0066      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0067      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0068      0001     skip_speech_detection   equ  1      ; Skip speech synthesizer detection
0069      0001     skip_speech_player      equ  1      ; Skip inclusion of speech player code
0070      0001     skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
0071      0001     skip_random_generator   equ  1      ; Skip random functions
0072      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0073               *--------------------------------------------------------------
0074               * SPECTRA2 startup options
0075               *--------------------------------------------------------------
0076      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0077      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0078      00F4     spfclr                  equ  >f4    ; Foreground/Background color for font.
0079      0004     spfbck                  equ  >04    ; Screen background color.
0080               *--------------------------------------------------------------
0081               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0082               *--------------------------------------------------------------
0083               ;               equ  >8342          ; >8342-834F **free***
0084      8350     parm1           equ  >8350          ; Function parameter 1
0085      8352     parm2           equ  >8352          ; Function parameter 2
0086      8354     parm3           equ  >8354          ; Function parameter 3
0087      8356     parm4           equ  >8356          ; Function parameter 4
0088      8358     parm5           equ  >8358          ; Function parameter 5
0089      835A     parm6           equ  >835a          ; Function parameter 6
0090      835C     parm7           equ  >835c          ; Function parameter 7
0091      835E     parm8           equ  >835e          ; Function parameter 8
0092      8360     outparm1        equ  >8360          ; Function output parameter 1
0093      8362     outparm2        equ  >8362          ; Function output parameter 2
0094      8364     outparm3        equ  >8364          ; Function output parameter 3
0095      8366     outparm4        equ  >8366          ; Function output parameter 4
0096      8368     outparm5        equ  >8368          ; Function output parameter 5
0097      836A     outparm6        equ  >836a          ; Function output parameter 6
0098      836C     outparm7        equ  >836c          ; Function output parameter 7
0099      836E     outparm8        equ  >836e          ; Function output parameter 8
0100      8370     timers          equ  >8370          ; Timer table
0101      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0102      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0103               *--------------------------------------------------------------
0104               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0105               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0106               *--------------------------------------------------------------
0107      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0108      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0109               *--------------------------------------------------------------
0110               * Frame buffer structure            @>2200-22ff     (256 bytes)
0111               *--------------------------------------------------------------
0112      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0113      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0114      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0115      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0116      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0117      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0118      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0119      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0120      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0121      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0122      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0123      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0124      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0125      221A     fb.end          equ  fb.top.ptr+26  ; Free from here on
0126               *--------------------------------------------------------------
0127               * Editor buffer structure           @>2300-23ff     (256 bytes)
0128               *--------------------------------------------------------------
0129      2300     edb.top.ptr         equ  >2300          ; Pointer to editor buffer
0130      2302     edb.index.ptr       equ  edb.top.ptr+2  ; Pointer to index
0131      2304     edb.lines           equ  edb.top.ptr+4  ; Total lines in editor buffer
0132      2306     edb.dirty           equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0133      2308     edb.next_free.ptr   equ  edb.top.ptr+8  ; Pointer to next free line
0134      230A     edb.next_free.page  equ  edb.top.ptr+10 ; SAMS page of next free line
0135      230C     edb.insmode         equ  edb.top.ptr+12 ; Editor insert mode (>0000 overwrite / >ffff insert)
0136      230E     edb.rle             equ  edb.top.ptr+14 ; RLE compression activated
0137      2310     edb.samspage        equ  edb.top.ptr+16 ; Current SAMS page
0138      2310     edb.end             equ  edb.top.ptr+16 ; Free from here on
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
0153      2438     tfh.membuffer   equ  tfh.top + 56   ; 80 bytes file memory buffer
0154      2488     tfh.end         equ  tfh.top + 136  ; Free from here on
0155      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0156      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0157               *--------------------------------------------------------------
0158               * Free for future use               @>2500-264f     (336 bytes)
0159               *--------------------------------------------------------------
0160      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0161      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0162               *--------------------------------------------------------------
0163               * Frame buffer                      @>2650-2fff    (2480 bytes)
0164               *--------------------------------------------------------------
0165      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0166      09B0     fb.size         equ  2480           ; Frame buffer size
0167               *--------------------------------------------------------------
0168               * Index                             @>3000-3fff    (4096 bytes)
0169               *--------------------------------------------------------------
0170      3000     idx.top         equ  >3000          ; Top of index
0171      1000     idx.size        equ  4096           ; Index size
0172               *--------------------------------------------------------------
0173               * SAMS shadow index                 @>a000-Afff    (4096 bytes)
0174               *--------------------------------------------------------------
0175      A000     idx.shadow.top  equ  >a000          ; Top of shadow index
0176      1000     idx.shadow.size equ  4096           ; Shadow index size
0177               *--------------------------------------------------------------
0178               * Editor buffer                     @>b000-ffff   (20380 bytes)
0179               *--------------------------------------------------------------
0180      B000     edb.top         equ  >b000          ; Editor buffer high memory
0181      4F9C     edb.size        equ  20380          ; Editor buffer size
0182               *--------------------------------------------------------------
0183               
0184               
0185               *--------------------------------------------------------------
0186               * Cartridge header
0187               *--------------------------------------------------------------
0188                       save  >6000,>7fff
0189                       aorg  >6000
0190               
0191 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0192 6006 6010             data  prog0
0193 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0194 6010 0000     prog0   data  0                     ; No more items following
0195 6012 6C94             data  runlib
0196               
0198               
0199 6014 1154             byte  17
0200 6015 ....             text  'TIVI 200201-23569'
0201                       even
0202               
0210               *--------------------------------------------------------------
0211               * Include required files
0212               *--------------------------------------------------------------
0213                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0085                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Constants and equates used by runlib modules
0003               
0004               
0005               ***************************************************************
0006               *                      Some constants
0007               ********|*****|*********************|**************************
0008               
0009               ---------------------------------------------------------------
0010               * Word values
0011               *--------------------------------------------------------------
0012               ;                                   ;       0123456789ABCDEF
0013 6026 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0014 6028 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0015 602A 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0016 602C 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0017 602E 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0018 6030 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0019 6032 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0020 6034 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0021 6036 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0022 6038 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0023 603A 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0024 603C 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0025 603E 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0026 6040 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0027 6042 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0028 6044 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0029 6046 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0030 6048 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0031 604A D000     w$d000  data  >d000                 ; >d000
0032               *--------------------------------------------------------------
0033               * Byte values - High byte (=MSB) for byte operations
0034               *--------------------------------------------------------------
0035      6026     hb$00   equ   w$0000                ; >0000
0036      6038     hb$01   equ   w$0100                ; >0100
0037      603A     hb$02   equ   w$0200                ; >0200
0038      603C     hb$04   equ   w$0400                ; >0400
0039      603E     hb$08   equ   w$0800                ; >0800
0040      6040     hb$10   equ   w$1000                ; >1000
0041      6042     hb$20   equ   w$2000                ; >2000
0042      6044     hb$40   equ   w$4000                ; >4000
0043      6046     hb$80   equ   w$8000                ; >8000
0044      604A     hb$d0   equ   w$d000                ; >d000
0045               *--------------------------------------------------------------
0046               * Byte values - Low byte (=LSB) for byte operations
0047               *--------------------------------------------------------------
0048      6026     lb$00   equ   w$0000                ; >0000
0049      6028     lb$01   equ   w$0001                ; >0001
0050      602A     lb$02   equ   w$0002                ; >0002
0051      602C     lb$04   equ   w$0004                ; >0004
0052      602E     lb$08   equ   w$0008                ; >0008
0053      6030     lb$10   equ   w$0010                ; >0010
0054      6032     lb$20   equ   w$0020                ; >0020
0055      6034     lb$40   equ   w$0040                ; >0040
0056      6036     lb$80   equ   w$0080                ; >0080
0057               *--------------------------------------------------------------
0058               * Bit values
0059               *--------------------------------------------------------------
0060               ;                                   ;       0123456789ABCDEF
0061      6028     wbit15  equ   w$0001                ; >0001 0000000000000001
0062      602A     wbit14  equ   w$0002                ; >0002 0000000000000010
0063      602C     wbit13  equ   w$0004                ; >0004 0000000000000100
0064      602E     wbit12  equ   w$0008                ; >0008 0000000000001000
0065      6030     wbit11  equ   w$0010                ; >0010 0000000000010000
0066      6032     wbit10  equ   w$0020                ; >0020 0000000000100000
0067      6034     wbit9   equ   w$0040                ; >0040 0000000001000000
0068      6036     wbit8   equ   w$0080                ; >0080 0000000010000000
0069      6038     wbit7   equ   w$0100                ; >0100 0000000100000000
0070      603A     wbit6   equ   w$0200                ; >0200 0000001000000000
0071      603C     wbit5   equ   w$0400                ; >0400 0000010000000000
0072      603E     wbit4   equ   w$0800                ; >0800 0000100000000000
0073      6040     wbit3   equ   w$1000                ; >1000 0001000000000000
0074      6042     wbit2   equ   w$2000                ; >2000 0010000000000000
0075      6044     wbit1   equ   w$4000                ; >4000 0100000000000000
0076      6046     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0006               * crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @crash
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
0027 604C 022B  22 crash:  ai    r11,-4                ; Remove opcode offset
     604E FFFC 
0028               *--------------------------------------------------------------
0029               *    Save registers to high memory
0030               *--------------------------------------------------------------
0031 6050 C800  38         mov   r0,@>ffe0
     6052 FFE0 
0032 6054 C801  38         mov   r1,@>ffe2
     6056 FFE2 
0033 6058 C802  38         mov   r2,@>ffe4
     605A FFE4 
0034 605C C803  38         mov   r3,@>ffe6
     605E FFE6 
0035 6060 C804  38         mov   r4,@>ffe8
     6062 FFE8 
0036 6064 C805  38         mov   r5,@>ffea
     6066 FFEA 
0037 6068 C806  38         mov   r6,@>ffec
     606A FFEC 
0038 606C C807  38         mov   r7,@>ffee
     606E FFEE 
0039 6070 C808  38         mov   r8,@>fff0
     6072 FFF0 
0040 6074 C809  38         mov   r9,@>fff2
     6076 FFF2 
0041 6078 C80A  38         mov   r10,@>fff4
     607A FFF4 
0042 607C C80B  38         mov   r11,@>fff6
     607E FFF6 
0043 6080 C80C  38         mov   r12,@>fff8
     6082 FFF8 
0044 6084 C80D  38         mov   r13,@>fffa
     6086 FFFA 
0045 6088 C80E  38         mov   r14,@>fffc
     608A FFFC 
0046 608C C80F  38         mov   r15,@>ffff
     608E FFFF 
0047               *--------------------------------------------------------------
0048               *    Reset system
0049               *--------------------------------------------------------------
0050               crash.reset:
0051 6090 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6092 8300 
0052 6094 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6096 8302 
0053 6098 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     609A 4A4A 
0054 609C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     609E 6C9C 
0055               *--------------------------------------------------------------
0056               *    Show diagnostics after system reset
0057               *--------------------------------------------------------------
0058               crash.main:
0059                       ;------------------------------------------------------
0060                       ; Show crashed message
0061                       ;------------------------------------------------------
0062 60A0 06A0  32         bl    @putat                ; Show crash message
     60A2 6330 
0063 60A4 0000                   data >0000,crash.msg.crashed
     60A6 60CC 
0064               
0065 60A8 06A0  32         bl    @puthex               ; Put hex value on screen
     60AA 67C8 
0066 60AC 0015                   byte 0,21             ; \ .  p0 = YX position
0067 60AE FFF6                   data >fff6            ; | .  p1 = Pointer to 16 bit word
0068 60B0 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0069 60B2 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0070                                                   ; /         LSB offset for ASCII digit 0-9
0071                       ;------------------------------------------------------
0072                       ; Show caller details
0073                       ;------------------------------------------------------
0074 60B4 06A0  32         bl    @putat                ; Show caller message
     60B6 6330 
0075 60B8 0100                   data >0100,crash.msg.caller
     60BA 60E2 
0076               
0077 60BC 06A0  32         bl    @puthex               ; Put hex value on screen
     60BE 67C8 
0078 60C0 0115                   byte 1,21             ; \ .  p0 = YX position
0079 60C2 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0080 60C4 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0081 60C6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0082                                                   ; /         LSB offset for ASCII digit 0-9
0083                       ;------------------------------------------------------
0084                       ; Kernel takes over
0085                       ;------------------------------------------------------
0086 60C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CA 6BAA 
0087               
0088 60CC 1553     crash.msg.crashed      byte 21
0089 60CD ....                            text 'System crashed near >'
0090               
0091 60E2 1543     crash.msg.caller       byte 21
0092 60E3 ....                            text 'Caller address near >'
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
0077 6144 06A0  32         bl    @crash                ; / Crash and halt system
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
0034 638E 06A0  32         bl    @crash                ; / Crash and halt system
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
0039               ***************************************************************
0040               * sams.page - Page SAMS memory to memory bank
0041               ***************************************************************
0042               *  bl   @xsams.page
0043               *
0044               *  tmp0 = SAMS page number
0045               *  tmp1 = Memory address (e.g. address >a100 will map to SAMS
0046               *         register >4014 (bank >a000 - >afff)
0047               *--------------------------------------------------------------
0048               *  Register usage
0049               *  r0, tmp0, tmp1, r12
0050               *--------------------------------------------------------------
0051               *  SAMS page number should be in range 0-255 (>00 to >ff)
0052               *
0053               *  Page         Memory
0054               *  ====         ======
0055               *  >00             32K
0056               *  >1f            128K
0057               *  >3f            256K
0058               *  >7f            512K
0059               *  >ff           1024K
0060               ********|*****|*********************|**************************
0061               xsams.page:
0062 63E2 0649  14         dect  stack
0063 63E4 C64B  30         mov   r11,*stack            ; Push return address
0064 63E6 0649  14         dect  stack
0065 63E8 C640  30         mov   r0,*stack             ; Push r0
0066 63EA 0649  14         dect  stack
0067 63EC C64C  30         mov   r12,*stack            ; Push r12
0068 63EE 0649  14         dect  stack
0069 63F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0070 63F2 0649  14         dect  stack
0071 63F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0072 63F6 0649  14         dect  stack
0073 63F8 C646  30         mov   tmp2,*stack           ; Push tmp2
0074               *--------------------------------------------------------------
0075               * Determine memory bank
0076               *--------------------------------------------------------------
0077 63FA 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0078 63FC 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0079               *--------------------------------------------------------------
0080               * Switch memory bank to specified SAMS page
0081               *--------------------------------------------------------------
0082               sams.page.switch:
0083 63FE 020C  20         li    r12,>1e00             ; SAMS CRU address
     6400 1E00 
0084 6402 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0085 6404 06C0  14         swpb  r0                    ; LSB to MSB
0086 6406 1D00  20         sbo   0                     ; Enable access to SAMS registers
0087 6408 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     640A 4000 
0088 640C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.exit:
0093 640E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0094 6410 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0095 6412 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0096 6414 C339  30         mov   *stack+,r12           ; Pop r12
0097 6416 C039  30         mov   *stack+,r0            ; Pop r0
0098 6418 C2F9  30         mov   *stack+,r11           ; Pop return address
0099 641A 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               
0103               
0104               ***************************************************************
0105               * sams.mapping.on - Enable SAMS mapping mode
0106               ***************************************************************
0107               *  bl   @sams.mapping.on
0108               *--------------------------------------------------------------
0109               *  Register usage
0110               *  r12
0111               ********|*****|*********************|**************************
0112               sams.mapping.on:
0113 641C 020C  20         li    r12,>1e00             ; SAMS CRU address
     641E 1E00 
0114 6420 1D01  20         sbo   1                     ; Enable SAMS mapper
0115               *--------------------------------------------------------------
0116               * Exit
0117               *--------------------------------------------------------------
0118               sams.mapping.on.exit:
0119 6422 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
0123               
0124               ***************************************************************
0125               * sams.mapping.off - Disable SAMS mapping mode
0126               ***************************************************************
0127               *  bl   @sams.mapping.off
0128               *--------------------------------------------------------------
0129               *  Register usage
0130               *  r12
0131               ********|*****|*********************|**************************
0132               sams.mapping.off:
0133 6424 020C  20         li    r12,>1e00             ; SAMS CRU address
     6426 1E00 
0134 6428 1E01  20         sbz   1                     ; Disable SAMS mapper
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               sams.mapping.off.exit:
0139 642A 045B  20         b     *r11                  ; Return to caller
0140               
0141               
0142               
0143               
0144               
0145               ***************************************************************
0146               * sams.layout
0147               * Setup SAMS memory banks
0148               ***************************************************************
0149               * bl  @sams.layout
0150               *     data P0
0151               *--------------------------------------------------------------
0152               * INPUT
0153               * P0 = Pointer to SAMS page layout table (16 words).
0154               *--------------------------------------------------------------
0155               * bl  @xsams.layout
0156               *
0157               * TMP0 = Pointer to SAMS page layout table (16 words).
0158               *--------------------------------------------------------------
0159               * OUTPUT
0160               * none
0161               *--------------------------------------------------------------
0162               * Register usage
0163               * tmp0, tmp1, tmp2, tmp3
0164               ***************************************************************
0165               sams.layout:
0166 642C C1FB  30         mov   *r11+,tmp3            ; Get P0
0167               xsams.layout
0168 642E 0649  14         dect  stack
0169 6430 C64B  30         mov   r11,*stack            ; Save return address
0170 6432 0649  14         dect  stack
0171 6434 C644  30         mov   tmp0,*stack           ; Save tmp0
0172 6436 0649  14         dect  stack
0173 6438 C645  30         mov   tmp1,*stack           ; Save tmp1
0174 643A 0649  14         dect  stack
0175 643C C646  30         mov   tmp2,*stack           ; Save tmp2
0176 643E 0649  14         dect  stack
0177 6440 C647  30         mov   tmp3,*stack           ; Save tmp3
0178                       ;------------------------------------------------------
0179                       ; Initialize
0180                       ;------------------------------------------------------
0181 6442 0206  20         li    tmp2,8                ; Set loop counter
     6444 0008 
0182                       ;------------------------------------------------------
0183                       ; Set SAMS banks
0184                       ;------------------------------------------------------
0185               sams.layout.loop:
0186 6446 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0187 6448 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0188               
0189 644A 06A0  32         bl    @xsams.page           ; \ SAMS page to memory bank
     644C 63E2 
0190                                                   ; | .  tmp0 = SAMS bank number
0191                                                   ; / .  tmp1 = Memory address
0192               
0193 644E 0606  14         dec   tmp2                  ; Next iteration
0194 6450 16FA  14         jne   sams.layout.loop      ; Loop until done
0195                       ;------------------------------------------------------
0196                       ; Exit
0197                       ;------------------------------------------------------
0198               sams.init.exit:
0199 6452 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6454 641C 
0200                                                   ; / activating changes.
0201               
0202 6456 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0203 6458 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0204 645A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0205 645C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0206 645E C2F9  30         mov   *stack+,r11           ; Pop r11
0207 6460 045B  20         b     *r11                  ; Return to caller
0208               
0209               
0210               
0211               ***************************************************************
0212               * sams.reset
0213               * Reset SAMS memory banks to standard layout
0214               ***************************************************************
0215               * bl  @sams.reset
0216               *--------------------------------------------------------------
0217               * OUTPUT
0218               * none
0219               *--------------------------------------------------------------
0220               * Register usage
0221               * none
0222               ***************************************************************
0223               sams.reset:
0224 6462 0649  14         dect  stack
0225 6464 C64B  30         mov   r11,*stack            ; Save return address
0226                       ;------------------------------------------------------
0227                       ; Set SAMS standard layout
0228                       ;------------------------------------------------------
0229 6466 06A0  32         bl    @sams.layout
     6468 642C 
0230 646A 6470                   data data.sams.reset.layout
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               sams.reset.exit:
0235 646C C2F9  30         mov   *stack+,r11           ; Pop r11
0236 646E 045B  20         b     *r11                  ; Return to caller
0237               ***************************************************************
0238               * SAMS standard page layout table (16 words)
0239               *--------------------------------------------------------------
0240               data.sams.reset.layout:
0241 6470 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6472 0002 
0242 6474 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6476 0003 
0243 6478 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     647A 000A 
0244 647C B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     647E 000B 
0245 6480 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6482 000C 
0246 6484 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6486 000D 
0247 6488 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     648A 000E 
0248 648C F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     648E 000F 
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
0009 6490 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6492 FFBF 
0010 6494 0460  28         b     @putv01
     6496 6246 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6498 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     649A 0040 
0018 649C 0460  28         b     @putv01
     649E 6246 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 64A0 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     64A2 FFDF 
0026 64A4 0460  28         b     @putv01
     64A6 6246 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 64A8 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     64AA 0020 
0034 64AC 0460  28         b     @putv01
     64AE 6246 
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
0010 64B0 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     64B2 FFFE 
0011 64B4 0460  28         b     @putv01
     64B6 6246 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 64B8 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     64BA 0001 
0019 64BC 0460  28         b     @putv01
     64BE 6246 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 64C0 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     64C2 FFFD 
0027 64C4 0460  28         b     @putv01
     64C6 6246 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 64C8 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     64CA 0002 
0035 64CC 0460  28         b     @putv01
     64CE 6246 
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
0018 64D0 C83B  50 at      mov   *r11+,@wyx
     64D2 832A 
0019 64D4 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 64D6 B820  54 down    ab    @hb$01,@wyx
     64D8 6038 
     64DA 832A 
0028 64DC 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 64DE 7820  54 up      sb    @hb$01,@wyx
     64E0 6038 
     64E2 832A 
0037 64E4 045B  20         b     *r11
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
0049 64E6 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 64E8 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     64EA 832A 
0051 64EC C804  38         mov   tmp0,@wyx             ; Save as new YX position
     64EE 832A 
0052 64F0 045B  20         b     *r11
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
0021 64F2 C120  34 yx2px   mov   @wyx,tmp0
     64F4 832A 
0022 64F6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 64F8 06C4  14         swpb  tmp0                  ; Y<->X
0024 64FA 04C5  14         clr   tmp1                  ; Clear before copy
0025 64FC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 64FE 20A0  38         coc   @wbit1,config         ; f18a present ?
     6500 6044 
0030 6502 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6504 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6506 833A 
     6508 6532 
0032 650A 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 650C 0A15  56         sla   tmp1,1                ; X = X * 2
0035 650E B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6510 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6512 0500 
0037 6514 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6516 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6518 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 651A 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 651C D105  18         movb  tmp1,tmp0
0051 651E 06C4  14         swpb  tmp0                  ; X<->Y
0052 6520 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6522 6046 
0053 6524 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6526 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6528 6038 
0059 652A 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     652C 604A 
0060 652E 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6530 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6532 0050            data   80
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
0013 6534 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6536 06A0  32         bl    @putvr                ; Write once
     6538 6232 
0015 653A 391C             data  >391c                 ; VR1/57, value 00011100
0016 653C 06A0  32         bl    @putvr                ; Write twice
     653E 6232 
0017 6540 391C             data  >391c                 ; VR1/57, value 00011100
0018 6542 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6544 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6546 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6548 6232 
0028 654A 391C             data  >391c
0029 654C 0458  20         b     *tmp4                 ; Exit
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
0040 654E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6550 06A0  32         bl    @cpym2v
     6552 6338 
0042 6554 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6556 6592 
     6558 0006 
0043 655A 06A0  32         bl    @putvr
     655C 6232 
0044 655E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6560 06A0  32         bl    @putvr
     6562 6232 
0046 6564 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6566 0204  20         li    tmp0,>3f00
     6568 3F00 
0052 656A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     656C 61BA 
0053 656E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6570 8800 
0054 6572 0984  56         srl   tmp0,8
0055 6574 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6576 8800 
0056 6578 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 657A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 657C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     657E BFFF 
0060 6580 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6582 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6584 4000 
0063               f18chk_exit:
0064 6586 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6588 618E 
0065 658A 3F00             data  >3f00,>00,6
     658C 0000 
     658E 0006 
0066 6590 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 6592 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6594 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6596 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6598 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 659A 06A0  32         bl    @putvr
     659C 6232 
0097 659E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 65A0 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     65A2 6232 
0100 65A4 391C             data  >391c                 ; Lock the F18a
0101 65A6 0458  20         b     *tmp4                 ; Exit
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
0120 65A8 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 65AA 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     65AC 6044 
0122 65AE 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 65B0 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     65B2 8802 
0127 65B4 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     65B6 6232 
0128 65B8 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 65BA 04C4  14         clr   tmp0
0130 65BC D120  34         movb  @vdps,tmp0
     65BE 8802 
0131 65C0 0984  56         srl   tmp0,8
0132 65C2 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 65C4 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     65C6 832A 
0018 65C8 D17B  28         movb  *r11+,tmp1
0019 65CA 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 65CC D1BB  28         movb  *r11+,tmp2
0021 65CE 0986  56         srl   tmp2,8                ; Repeat count
0022 65D0 C1CB  18         mov   r11,tmp3
0023 65D2 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     65D4 62FA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 65D6 020B  20         li    r11,hchar1
     65D8 65DE 
0028 65DA 0460  28         b     @xfilv                ; Draw
     65DC 6194 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 65DE 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     65E0 6048 
0033 65E2 1302  14         jeq   hchar2                ; Yes, exit
0034 65E4 C2C7  18         mov   tmp3,r11
0035 65E6 10EE  14         jmp   hchar                 ; Next one
0036 65E8 05C7  14 hchar2  inct  tmp3
0037 65EA 0457  20         b     *tmp3                 ; Exit
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
0016 65EC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     65EE 6046 
0017 65F0 020C  20         li    r12,>0024
     65F2 0024 
0018 65F4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     65F6 6684 
0019 65F8 04C6  14         clr   tmp2
0020 65FA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 65FC 04CC  14         clr   r12
0025 65FE 1F08  20         tb    >0008                 ; Shift-key ?
0026 6600 1302  14         jeq   realk1                ; No
0027 6602 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6604 66B4 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6606 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6608 1302  14         jeq   realk2                ; No
0033 660A 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     660C 66E4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 660E 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6610 1302  14         jeq   realk3                ; No
0039 6612 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6614 6714 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6616 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6618 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 661A 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 661C E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     661E 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6620 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6622 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6624 0006 
0052 6626 0606  14 realk5  dec   tmp2
0053 6628 020C  20         li    r12,>24               ; CRU address for P2-P4
     662A 0024 
0054 662C 06C6  14         swpb  tmp2
0055 662E 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6630 06C6  14         swpb  tmp2
0057 6632 020C  20         li    r12,6                 ; CRU read address
     6634 0006 
0058 6636 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6638 0547  14         inv   tmp3                  ;
0060 663A 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     663C FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 663E 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6640 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6642 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6644 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6646 0285  22         ci    tmp1,8
     6648 0008 
0069 664A 1AFA  14         jl    realk6
0070 664C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 664E 1BEB  14         jh    realk5                ; No, next column
0072 6650 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6652 C206  18 realk8  mov   tmp2,tmp4
0077 6654 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6656 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6658 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 665A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 665C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 665E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6660 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6662 6046 
0087 6664 1608  14         jne   realka                ; No, continue saving key
0088 6666 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6668 66AE 
0089 666A 1A05  14         jl    realka
0090 666C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     666E 66AC 
0091 6670 1B02  14         jh    realka                ; No, continue
0092 6672 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6674 E000 
0093 6676 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6678 833C 
0094 667A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     667C 6030 
0095 667E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6680 8C00 
0096 6682 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 6684 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6686 0000 
     6688 FF0D 
     668A 203D 
0099 668C ....             text  'xws29ol.'
0100 6694 ....             text  'ced38ik,'
0101 669C ....             text  'vrf47ujm'
0102 66A4 ....             text  'btg56yhn'
0103 66AC ....             text  'zqa10p;/'
0104 66B4 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     66B6 0000 
     66B8 FF0D 
     66BA 202B 
0105 66BC ....             text  'XWS@(OL>'
0106 66C4 ....             text  'CED#*IK<'
0107 66CC ....             text  'VRF$&UJM'
0108 66D4 ....             text  'BTG%^YHN'
0109 66DC ....             text  'ZQA!)P:-'
0110 66E4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     66E6 0000 
     66E8 FF0D 
     66EA 2005 
0111 66EC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     66EE 0804 
     66F0 0F27 
     66F2 C2B9 
0112 66F4 600B             data  >600b,>0907,>063f,>c1B8
     66F6 0907 
     66F8 063F 
     66FA C1B8 
0113 66FC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     66FE 7B02 
     6700 015F 
     6702 C0C3 
0114 6704 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6706 7D0E 
     6708 0CC6 
     670A BFC4 
0115 670C 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     670E 7C03 
     6710 BC22 
     6712 BDBA 
0116 6714 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6716 0000 
     6718 FF0D 
     671A 209D 
0117 671C 9897             data  >9897,>93b2,>9f8f,>8c9B
     671E 93B2 
     6720 9F8F 
     6722 8C9B 
0118 6724 8385             data  >8385,>84b3,>9e89,>8b80
     6726 84B3 
     6728 9E89 
     672A 8B80 
0119 672C 9692             data  >9692,>86b4,>b795,>8a8D
     672E 86B4 
     6730 B795 
     6732 8A8D 
0120 6734 8294             data  >8294,>87b5,>b698,>888E
     6736 87B5 
     6738 B698 
     673A 888E 
0121 673C 9A91             data  >9a91,>81b1,>b090,>9cBB
     673E 81B1 
     6740 B090 
     6742 9CBB 
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
0023 6744 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6746 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6748 8340 
0025 674A 04E0  34         clr   @waux1
     674C 833C 
0026 674E 04E0  34         clr   @waux2
     6750 833E 
0027 6752 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6754 833C 
0028 6756 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6758 0205  20         li    tmp1,4                ; 4 nibbles
     675A 0004 
0033 675C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 675E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6760 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6762 0286  22         ci    tmp2,>000a
     6764 000A 
0039 6766 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6768 C21B  26         mov   *r11,tmp4
0045 676A 0988  56         srl   tmp4,8                ; Right justify
0046 676C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     676E FFF6 
0047 6770 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6772 C21B  26         mov   *r11,tmp4
0054 6774 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6776 00FF 
0055               
0056 6778 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 677A 06C6  14         swpb  tmp2
0058 677C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 677E 0944  56         srl   tmp0,4                ; Next nibble
0060 6780 0605  14         dec   tmp1
0061 6782 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6784 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6786 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6788 C160  34         mov   @waux3,tmp1           ; Get pointer
     678A 8340 
0067 678C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 678E 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6790 C120  34         mov   @waux2,tmp0
     6792 833E 
0070 6794 06C4  14         swpb  tmp0
0071 6796 DD44  32         movb  tmp0,*tmp1+
0072 6798 06C4  14         swpb  tmp0
0073 679A DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 679C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     679E 8340 
0078 67A0 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     67A2 603C 
0079 67A4 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 67A6 C120  34         mov   @waux1,tmp0
     67A8 833C 
0084 67AA 06C4  14         swpb  tmp0
0085 67AC DD44  32         movb  tmp0,*tmp1+
0086 67AE 06C4  14         swpb  tmp0
0087 67B0 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 67B2 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     67B4 6046 
0092 67B6 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 67B8 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 67BA 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     67BC 7FFF 
0098 67BE C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     67C0 8340 
0099 67C2 0460  28         b     @xutst0               ; Display string
     67C4 6320 
0100 67C6 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 67C8 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     67CA 832A 
0122 67CC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     67CE 8000 
0123 67D0 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 67D2 0207  20 mknum   li    tmp3,5                ; Digit counter
     67D4 0005 
0020 67D6 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 67D8 C155  26         mov   *tmp1,tmp1            ; /
0022 67DA C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 67DC 0228  22         ai    tmp4,4                ; Get end of buffer
     67DE 0004 
0024 67E0 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     67E2 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 67E4 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 67E6 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 67E8 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 67EA B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 67EC D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 67EE C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 67F0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 67F2 0607  14         dec   tmp3                  ; Decrease counter
0036 67F4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 67F6 0207  20         li    tmp3,4                ; Check first 4 digits
     67F8 0004 
0041 67FA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 67FC C11B  26         mov   *r11,tmp0
0043 67FE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6800 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6802 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6804 05CB  14 mknum3  inct  r11
0047 6806 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6808 6046 
0048 680A 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 680C 045B  20         b     *r11                  ; Exit
0050 680E DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6810 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6812 13F8  14         jeq   mknum3                ; Yes, exit
0053 6814 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6816 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6818 7FFF 
0058 681A C10B  18         mov   r11,tmp0
0059 681C 0224  22         ai    tmp0,-4
     681E FFFC 
0060 6820 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6822 0206  20         li    tmp2,>0500            ; String length = 5
     6824 0500 
0062 6826 0460  28         b     @xutstr               ; Display string
     6828 6322 
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
0092 682A C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 682C C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 682E C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6830 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6832 0207  20         li    tmp3,5                ; Set counter
     6834 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6836 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6838 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 683A 0584  14         inc   tmp0                  ; Next character
0104 683C 0607  14         dec   tmp3                  ; Last digit reached ?
0105 683E 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6840 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6842 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6844 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6846 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6848 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 684A 0607  14         dec   tmp3                  ; Last character ?
0120 684C 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 684E 045B  20         b     *r11                  ; Return
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
0138 6850 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6852 832A 
0139 6854 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6856 8000 
0140 6858 10BC  14         jmp   mknum                 ; Convert number and display
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
0074 685A C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 685C C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 685E C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 6860 0649  14         dect  stack
0079 6862 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 6864 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 6866 04C8  14         clr   tmp4                  ; Repeat counter
0086 6868 04E0  34         clr   @waux1                ; Length of RLE string
     686A 833C 
0087 686C 04E0  34         clr   @waux2                ; Address of encoding byte
     686E 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 6870 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 6872 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 6874 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 6876 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 6878 C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 687A 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 687C 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     687E 0001 
0105 6880 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 6882 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 6884 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 6886 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 6888 06A0  32         bl    @cpu2rle.flush.duplicates
     688A 68D4 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 688C C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     688E 833E 
     6890 833E 
0126 6892 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 6894 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     6896 833E 
0129 6898 0585  14         inc   tmp1                  ; Skip encoding byte
0130 689A 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     689C 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 689E DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 68A0 05A0  34         inc   @waux1                ; RLE string length += 1
     68A2 833C 
0136 68A4 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 68A6 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     68A8 833E 
     68AA 833E 
0145 68AC 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 68AE 06A0  32         bl    @cpu2rle.flush.encoding_byte
     68B0 68EE 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 68B2 0588  14         inc   tmp4                  ; Increase repeat counter
0155 68B4 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 68B6 0606  14         dec   tmp2
0162 68B8 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 68BA C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 68BC 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 68BE 06A0  32         bl    @cpu2rle.flush.duplicates
     68C0 68D4 
0175                                                   ; (3.2) Flush pending ...
0176 68C2 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 68C4 C820  54         mov   @waux2,@waux2
     68C6 833E 
     68C8 833E 
0182 68CA 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 68CC 06A0  32         bl    @cpu2rle.flush.encoding_byte
     68CE 68EE 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 68D0 0460  28         b     @poprt                ; Return
     68D2 6132 
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
0204 68D4 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 68D6 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 68D8 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 68DA 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     68DC 8000 
0210 68DE DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 68E0 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 68E2 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 68E4 05E0  34         inct  @waux1                ; RLE string length += 2
     68E6 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 68E8 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 68EA 04C8  14         clr   tmp4                  ; Clear repeat count
0220 68EC 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 68EE 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 68F0 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 68F2 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 68F4 61E0  34         s     @waux2,tmp3           ; | characters
     68F6 833E 
0232 68F8 0607  14         dec   tmp3                  ; /
0233               
0234 68FA 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 68FC C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     68FE 833E 
0236 6900 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6902 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6904 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6906 833E 
0240 6908 04C8  14         clr   tmp4                  ; Clear before exit
0241 690A 045B  20         b     *r11                  ; Return
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
0031 690C C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 690E C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6910 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6912 0649  14         dect  stack
0036 6914 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6916 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 6918 0606  14         dec   tmp2                  ; Update length
0043 691A 131E  14         jeq   rle2cpu.exit          ; End of list
0044 691C 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 691E 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6920 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6922 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 6924 0649  14         dect  stack
0055 6926 C646  30         mov   tmp2,*stack           ; Push tmp2
0056 6928 C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 692A 06A0  32         bl    @xpym2m               ; Block copy to destination
     692C 6386 
0059                                                   ; \ .  tmp0 = Source address
0060                                                   ; | .  tmp1 = Target address
0061                                                   ; / .  tmp2 = Bytes to copy
0062               
0063 692E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6930 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6932 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 6934 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 6936 0649  14         dect  stack
0073 6938 C645  30         mov   tmp1,*stack           ; Push tmp1
0074 693A 0649  14         dect  stack
0075 693C C646  30         mov   tmp2,*stack           ; Push tmp2
0076 693E 0649  14         dect  stack
0077 6940 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6942 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 6944 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 6946 0985  56         srl   tmp1,8                ; Right align
0082               
0083 6948 06A0  32         bl    @xfilm                ; Block fill to destination
     694A 613C 
0084                                                   ; \ .  tmp0 = Target address
0085                                                   ; | .  tmp1 = Byte to fill
0086                                                   ; / .  tmp2 = Repeat count
0087               
0088 694C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 694E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 6950 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 6952 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 6954 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 6956 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 6958 0460  28         b     @poprt                ; Return
     695A 6132 
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
0020 695C C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     695E 2000 
0021 6960 C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     6962 2002 
0022 6964 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     6966 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 6968 0200  20         li    r0,>8306              ; Scratpad source address
     696A 8306 
0027 696C 0201  20         li    r1,>2006              ; RAM target address
     696E 2006 
0028 6970 0202  20         li    r2,62                 ; Loop counter
     6972 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 6974 CC70  46         mov   *r0+,*r1+
0034 6976 CC70  46         mov   *r0+,*r1+
0035 6978 0642  14         dect  r2
0036 697A 16FC  14         jne   cpu.scrpad.backup.copy
0037 697C C820  54         mov   @>83fe,@>20fe         ; Copy last word
     697E 83FE 
     6980 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 6982 C020  34         mov   @>2000,r0             ; Restore r0
     6984 2000 
0042 6986 C060  34         mov   @>2002,r1             ; Restore r1
     6988 2002 
0043 698A C0A0  34         mov   @>2004,r2             ; Restore r2
     698C 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 698E 045B  20         b     *r11                  ; Return to caller
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
0066 6990 C820  54         mov   @>2000,@>8300
     6992 2000 
     6994 8300 
0067 6996 C820  54         mov   @>2002,@>8302
     6998 2002 
     699A 8302 
0068 699C C820  54         mov   @>2004,@>8304
     699E 2004 
     69A0 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 69A2 C800  38         mov   r0,@>2000
     69A4 2000 
0073 69A6 C801  38         mov   r1,@>2002
     69A8 2002 
0074 69AA C802  38         mov   r2,@>2004
     69AC 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 69AE 0200  20         li    r0,>2006
     69B0 2006 
0079 69B2 0201  20         li    r1,>8306
     69B4 8306 
0080 69B6 0202  20         li    r2,62
     69B8 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 69BA CC70  46         mov   *r0+,*r1+
0086 69BC CC70  46         mov   *r0+,*r1+
0087 69BE 0642  14         dect  r2
0088 69C0 16FC  14         jne   cpu.scrpad.restore.copy
0089 69C2 C820  54         mov   @>20fe,@>83fe         ; Copy last word
     69C4 20FE 
     69C6 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 69C8 C020  34         mov   @>2000,r0             ; Restore r0
     69CA 2000 
0094 69CC C060  34         mov   @>2002,r1             ; Restore r1
     69CE 2002 
0095 69D0 C0A0  34         mov   @>2004,r2             ; Restore r2
     69D2 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 69D4 045B  20         b     *r11                  ; Return to caller
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
0025 69D6 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 69D8 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     69DA 8300 
0031 69DC C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 69DE 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     69E0 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 69E2 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 69E4 0606  14         dec   tmp2
0038 69E6 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 69E8 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 69EA 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     69EC 69F2 
0044                                                   ; R14=PC
0045 69EE 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 69F0 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 69F2 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     69F4 6990 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 69F6 045B  20         b     *r11                  ; Return to caller
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
0078 69F8 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 69FA 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     69FC 8300 
0084 69FE 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A00 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6A02 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6A04 0606  14         dec   tmp2
0090 6A06 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6A08 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6A0A 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6A0C 045B  20         b     *r11                  ; Return to caller
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
0041 6A0E 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6A10 6A12             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6A12 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6A14 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6A16 8322 
0049 6A18 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6A1A 6042 
0050 6A1C C020  34         mov   @>8356,r0             ; get ptr to pab
     6A1E 8356 
0051 6A20 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6A22 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6A24 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6A26 06C0  14         swpb  r0                    ;
0059 6A28 D800  38         movb  r0,@vdpa              ; send low byte
     6A2A 8C02 
0060 6A2C 06C0  14         swpb  r0                    ;
0061 6A2E D800  38         movb  r0,@vdpa              ; send high byte
     6A30 8C02 
0062 6A32 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6A34 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6A36 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6A38 0704  14         seto  r4                    ; init counter
0070 6A3A 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6A3C 2420 
0071 6A3E 0580  14 !       inc   r0                    ; point to next char of name
0072 6A40 0584  14         inc   r4                    ; incr char counter
0073 6A42 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6A44 0007 
0074 6A46 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6A48 80C4  18         c     r4,r3                 ; end of name?
0077 6A4A 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6A4C 06C0  14         swpb  r0                    ;
0082 6A4E D800  38         movb  r0,@vdpa              ; send low byte
     6A50 8C02 
0083 6A52 06C0  14         swpb  r0                    ;
0084 6A54 D800  38         movb  r0,@vdpa              ; send high byte
     6A56 8C02 
0085 6A58 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6A5A 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6A5C DC81  32         movb  r1,*r2+               ; move into buffer
0092 6A5E 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6A60 6B22 
0093 6A62 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6A64 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6A66 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6A68 04E0  34         clr   @>83d0
     6A6A 83D0 
0102 6A6C C804  38         mov   r4,@>8354             ; save name length for search
     6A6E 8354 
0103 6A70 0584  14         inc   r4                    ; adjust for dot
0104 6A72 A804  38         a     r4,@>8356             ; point to position after name
     6A74 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6A76 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6A78 83E0 
0110 6A7A 04C1  14         clr   r1                    ; version found of dsr
0111 6A7C 020C  20         li    r12,>0f00             ; init cru addr
     6A7E 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6A80 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6A82 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6A84 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6A86 022C  22         ai    r12,>0100             ; next rom to turn on
     6A88 0100 
0125 6A8A 04E0  34         clr   @>83d0                ; clear in case we are done
     6A8C 83D0 
0126 6A8E 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6A90 2000 
0127 6A92 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6A94 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6A96 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6A98 1D00  20         sbo   0                     ; turn on rom
0134 6A9A 0202  20         li    r2,>4000              ; start at beginning of rom
     6A9C 4000 
0135 6A9E 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6AA0 6B1E 
0136 6AA2 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6AA4 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6AA6 240A 
0146 6AA8 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6AAA C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6AAC 83D2 
0152 6AAE 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6AB0 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6AB2 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6AB4 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6AB6 83D2 
0161 6AB8 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6ABA C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6ABC 04C5  14         clr   r5                    ; Remove any old stuff
0167 6ABE D160  34         movb  @>8355,r5             ; get length as counter
     6AC0 8355 
0168 6AC2 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6AC4 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6AC6 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6AC8 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6ACA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6ACC 2420 
0175 6ACE 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6AD0 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6AD2 0605  14         dec   r5                    ; loop until full length checked
0179 6AD4 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6AD6 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6AD8 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6ADA 0581  14         inc   r1                    ; next version found
0191 6ADC 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6ADE 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6AE0 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6AE2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6AE4 2400 
0200 6AE6 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6AE8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6AEA 8322 
0202                                                   ; (8 or >a)
0203 6AEC 0281  22         ci    r1,8                  ; was it 8?
     6AEE 0008 
0204 6AF0 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6AF2 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6AF4 8350 
0206                                                   ; Get error byte from @>8350
0207 6AF6 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6AF8 06C0  14         swpb  r0                    ;
0215 6AFA D800  38         movb  r0,@vdpa              ; send low byte
     6AFC 8C02 
0216 6AFE 06C0  14         swpb  r0                    ;
0217 6B00 D800  38         movb  r0,@vdpa              ; send high byte
     6B02 8C02 
0218 6B04 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6B06 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6B08 09D1  56         srl   r1,13                 ; just keep error bits
0226 6B0A 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6B0C 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6B0E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6B10 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6B12 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6B14 06C1  14         swpb  r1                    ; put error in hi byte
0239 6B16 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6B18 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6B1A 6042 
0241 6B1C 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6B1E AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6B20 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6B22 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6B24 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6B26 C04B  18         mov   r11,r1                ; Save return address
0049 6B28 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B2A 2428 
0050 6B2C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6B2E 04C5  14         clr   tmp1                  ; io.op.open
0052 6B30 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B32 61CC 
0053               file.open_init:
0054 6B34 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B36 0009 
0055 6B38 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B3A 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6B3C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B3E 6A0E 
0061 6B40 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6B42 1029  14         jmp   file.record.pab.details
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
0090 6B44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6B46 C04B  18         mov   r11,r1                ; Save return address
0096 6B48 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B4A 2428 
0097 6B4C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6B4E 0205  20         li    tmp1,io.op.close      ; io.op.close
     6B50 0001 
0099 6B52 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B54 61CC 
0100               file.close_init:
0101 6B56 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B58 0009 
0102 6B5A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B5C 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6B5E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B60 6A0E 
0108 6B62 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6B64 1018  14         jmp   file.record.pab.details
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
0139 6B66 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6B68 C04B  18         mov   r11,r1                ; Save return address
0145 6B6A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B6C 2428 
0146 6B6E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6B70 0205  20         li    tmp1,io.op.read       ; io.op.read
     6B72 0002 
0148 6B74 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B76 61CC 
0149               file.record.read_init:
0150 6B78 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B7A 0009 
0151 6B7C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B7E 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6B80 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B82 6A0E 
0157 6B84 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6B86 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6B88 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6B8A 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6B8C 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6B8E 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6B90 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6B92 1000  14         nop
0191               
0192               
0193               file.status:
0194 6B94 1000  14         nop
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
0211 6B96 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6B98 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6B9A 2428 
0219 6B9C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6B9E 0005 
0220 6BA0 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6BA2 61E4 
0221 6BA4 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6BA6 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6BA8 0451  20         b     *r1                   ; Return to caller
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
0020 6BAA 0300  24 tmgr    limi  0                     ; No interrupt processing
     6BAC 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6BAE D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6BB0 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6BB2 2360  38         coc   @wbit2,r13            ; C flag on ?
     6BB4 6042 
0029 6BB6 1602  14         jne   tmgr1a                ; No, so move on
0030 6BB8 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6BBA 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6BBC 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6BBE 6046 
0035 6BC0 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6BC2 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6BC4 6036 
0048 6BC6 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6BC8 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6BCA 6034 
0050 6BCC 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6BCE 0460  28         b     @kthread              ; Run kernel thread
     6BD0 6C48 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6BD2 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6BD4 603A 
0056 6BD6 13EB  14         jeq   tmgr1
0057 6BD8 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6BDA 6038 
0058 6BDC 16E8  14         jne   tmgr1
0059 6BDE C120  34         mov   @wtiusr,tmp0
     6BE0 832E 
0060 6BE2 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6BE4 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6BE6 6C46 
0065 6BE8 C10A  18         mov   r10,tmp0
0066 6BEA 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6BEC 00FF 
0067 6BEE 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6BF0 6042 
0068 6BF2 1303  14         jeq   tmgr5
0069 6BF4 0284  22         ci    tmp0,60               ; 1 second reached ?
     6BF6 003C 
0070 6BF8 1002  14         jmp   tmgr6
0071 6BFA 0284  22 tmgr5   ci    tmp0,50
     6BFC 0032 
0072 6BFE 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C00 1001  14         jmp   tmgr8
0074 6C02 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C04 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C06 832C 
0079 6C08 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6C0A FF00 
0080 6C0C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6C0E 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6C10 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6C12 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6C14 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6C16 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6C18 830C 
     6C1A 830D 
0089 6C1C 1608  14         jne   tmgr10                ; No, get next slot
0090 6C1E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6C20 FF00 
0091 6C22 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6C24 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6C26 8330 
0096 6C28 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6C2A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6C2C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6C2E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6C30 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6C32 8315 
     6C34 8314 
0103 6C36 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6C38 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6C3A 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6C3C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6C3E 10F7  14         jmp   tmgr10                ; Process next slot
0108 6C40 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6C42 FF00 
0109 6C44 10B4  14         jmp   tmgr1
0110 6C46 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6C48 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6C4A 6036 
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
0041 6C4C 06A0  32         bl    @realkb               ; Scan full keyboard
     6C4E 65EC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6C50 0460  28         b     @tmgr3                ; Exit
     6C52 6BD2 
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
0017 6C54 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6C56 832E 
0018 6C58 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6C5A 6038 
0019 6C5C 045B  20 mkhoo1  b     *r11                  ; Return
0020      6BAE     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6C5E 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6C60 832E 
0029 6C62 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6C64 FEFF 
0030 6C66 045B  20         b     *r11                  ; Return
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
0017 6C68 C13B  30 mkslot  mov   *r11+,tmp0
0018 6C6A C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6C6C C184  18         mov   tmp0,tmp2
0023 6C6E 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6C70 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6C72 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6C74 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6C76 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6C78 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6C7A 881B  46         c     *r11,@w$ffff          ; End of list ?
     6C7C 6048 
0035 6C7E 1301  14         jeq   mkslo1                ; Yes, exit
0036 6C80 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6C82 05CB  14 mkslo1  inct  r11
0041 6C84 045B  20         b     *r11                  ; Exit
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
0052 6C86 C13B  30 clslot  mov   *r11+,tmp0
0053 6C88 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6C8A A120  34         a     @wtitab,tmp0          ; Add table base
     6C8C 832C 
0055 6C8E 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6C90 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6C92 045B  20         b     *r11                  ; Exit
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
0250 6C94 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6C96 695C 
0251 6C98 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6C9A 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6C9C 0300  24 runli1  limi  0                     ; Turn off interrupts
     6C9E 0000 
0259 6CA0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6CA2 8300 
0260 6CA4 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6CA6 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6CA8 0202  20 runli2  li    r2,>8308
     6CAA 8308 
0265 6CAC 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6CAE 0282  22         ci    r2,>8400
     6CB0 8400 
0267 6CB2 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6CB4 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6CB6 FFFF 
0273 6CB8 1602  14         jne   runli4                ; No, continue
0274 6CBA 0420  54         blwp  @0                    ; Yes, bye bye
     6CBC 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6CBE C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6CC0 833C 
0279 6CC2 04C1  14         clr   r1                    ; Reset counter
0280 6CC4 0202  20         li    r2,10                 ; We test 10 times
     6CC6 000A 
0281 6CC8 C0E0  34 runli5  mov   @vdps,r3
     6CCA 8802 
0282 6CCC 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6CCE 6046 
0283 6CD0 1302  14         jeq   runli6
0284 6CD2 0581  14         inc   r1                    ; Increase counter
0285 6CD4 10F9  14         jmp   runli5
0286 6CD6 0602  14 runli6  dec   r2                    ; Next test
0287 6CD8 16F7  14         jne   runli5
0288 6CDA 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6CDC 1250 
0289 6CDE 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6CE0 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6CE2 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6CE4 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6CE6 6120 
0295 6CE8 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6CEA 8322 
0296 6CEC CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6CEE CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6CF0 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6CF2 04C1  14 runli9  clr   r1
0303 6CF4 04C2  14         clr   r2
0304 6CF6 04C3  14         clr   r3
0305 6CF8 0209  20         li    stack,>8400           ; Set stack
     6CFA 8400 
0306 6CFC 020F  20         li    r15,vdpw              ; Set VDP write address
     6CFE 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6D00 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6D02 4A4A 
0315 6D04 1605  14         jne   runlia
0316 6D06 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6D08 618E 
0317 6D0A 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6D0C 0000 
     6D0E 3FFF 
0322 6D10 06A0  32 runlia  bl    @filv
     6D12 618E 
0323 6D14 0FC0             data  pctadr,spfclr,16      ; Load color table
     6D16 00F4 
     6D18 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6D1A 06A0  32         bl    @f18unl               ; Unlock the F18A
     6D1C 6534 
0331 6D1E 06A0  32         bl    @f18chk               ; Check if F18A is there
     6D20 654E 
0332 6D22 06A0  32         bl    @f18lck               ; Lock the F18A again
     6D24 6544 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6D26 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6D28 61F8 
0346 6D2A 6116             data  spvmod                ; Equate selected video mode table
0347 6D2C 0204  20         li    tmp0,spfont           ; Get font option
     6D2E 000C 
0348 6D30 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6D32 1304  14         jeq   runlid                ; Yes, skip it
0350 6D34 06A0  32         bl    @ldfnt
     6D36 6260 
0351 6D38 1100             data  fntadr,spfont         ; Load specified font
     6D3A 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6D3C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6D3E 4A4A 
0356 6D40 1602  14         jne   runlie                ; No, continue
0357 6D42 0460  28         b     @crash.main           ; Yes, back to crash handler
     6D44 60A0 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6D46 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6D48 0040 
0362 6D4A 0460  28         b     @main                 ; Give control to main program
     6D4C 6D4E 
**** **** ****     > tivi.asm.23569
0214               
0215               *--------------------------------------------------------------
0216               * Video mode configuration
0217               *--------------------------------------------------------------
0218      6116     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0219      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0220      0050     colrow  equ   80                    ; Columns per row
0221      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0222      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0223      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0224      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0225               
0226               
0227               ***************************************************************
0228               * Main
0229               ********|*****|*********************|**************************
0230 6D4E 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6D50 6044 
0231 6D52 1302  14         jeq   main.continue
0232 6D54 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6D56 0000 
0233               
0234               main.continue:
0235 6D58 06A0  32         bl    @scroff               ; Turn screen off
     6D5A 6490 
0236 6D5C 06A0  32         bl    @f18unl               ; Unlock the F18a
     6D5E 6534 
0237 6D60 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6D62 6232 
0238 6D64 3140                   data >3140            ; F18a VR49 (>31), bit 40
0239                       ;------------------------------------------------------
0240                       ; Initialize VDP SIT
0241                       ;------------------------------------------------------
0242 6D66 06A0  32         bl    @filv
     6D68 618E 
0243 6D6A 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6D6C 0020 
     6D6E 09B0 
0244 6D70 06A0  32         bl    @scron                ; Turn screen on
     6D72 6498 
0245                       ;------------------------------------------------------
0246                       ; Initialize low + high memory expansion
0247                       ;------------------------------------------------------
0248 6D74 06A0  32         bl    @film
     6D76 6136 
0249 6D78 2200                   data >2200,00,8*1024-256*2
     6D7A 0000 
     6D7C 3E00 
0250                                                   ; Clear part of 8k low-memory
0251               
0252 6D7E 06A0  32         bl    @film
     6D80 6136 
0253 6D82 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6D84 0000 
     6D86 6000 
0254                       ;------------------------------------------------------
0255                       ; Load SAMS default memory layout
0256                       ;------------------------------------------------------
0257 6D88 06A0  32         bl    @mem.setup.sams.layout
     6D8A 754A 
0258                                                   ; Initialize SAMS layout
0259                       ;------------------------------------------------------
0260                       ; Setup cursor, screen, etc.
0261                       ;------------------------------------------------------
0262 6D8C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6D8E 64B0 
0263 6D90 06A0  32         bl    @s8x8                 ; Small sprite
     6D92 64C0 
0264               
0265 6D94 06A0  32         bl    @cpym2m
     6D96 6380 
0266 6D98 7B00                   data romsat,ramsat,4  ; Load sprite SAT
     6D9A 8380 
     6D9C 0004 
0267               
0268 6D9E C820  54         mov   @romsat+2,@fb.curshape
     6DA0 7B02 
     6DA2 2210 
0269                                                   ; Save cursor shape & color
0270               
0271 6DA4 06A0  32         bl    @cpym2v
     6DA6 6338 
0272 6DA8 1800                   data sprpdt,cursors,3*8
     6DAA 7B04 
     6DAC 0018 
0273                                                   ; Load sprite cursor patterns
0274               *--------------------------------------------------------------
0275               * Initialize
0276               *--------------------------------------------------------------
0277 6DAE 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6DB0 7734 
0278 6DB2 06A0  32         bl    @idx.init             ; Initialize index
     6DB4 765C 
0279 6DB6 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6DB8 7580 
0280                       ;-------------------------------------------------------
0281                       ; Setup editor tasks & hook
0282                       ;-------------------------------------------------------
0283 6DBA 0204  20         li    tmp0,>0200
     6DBC 0200 
0284 6DBE C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6DC0 8314 
0285               
0286 6DC2 06A0  32         bl    @at
     6DC4 64D0 
0287 6DC6 0000             data  >0000                 ; Cursor YX position = >0000
0288               
0289 6DC8 0204  20         li    tmp0,timers
     6DCA 8370 
0290 6DCC C804  38         mov   tmp0,@wtitab
     6DCE 832C 
0291               
0292 6DD0 06A0  32         bl    @mkslot
     6DD2 6C68 
0293 6DD4 0001                   data >0001,task0      ; Task 0 - Update screen
     6DD6 73C4 
0294 6DD8 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6DDA 7448 
0295 6DDC 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6DDE 7456 
     6DE0 FFFF 
0296               
0297 6DE2 06A0  32         bl    @mkhook
     6DE4 6C54 
0298 6DE6 6DEC                   data editor           ; Setup user hook
0299               
0300 6DE8 0460  28         b     @tmgr                 ; Start timers and kthread
     6DEA 6BAA 
0301               
0302               
0303               ****************************************************************
0304               * Editor - Main loop
0305               ****************************************************************
0306 6DEC 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6DEE 6030 
0307 6DF0 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0308               *---------------------------------------------------------------
0309               * Identical key pressed ?
0310               *---------------------------------------------------------------
0311 6DF2 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6DF4 6030 
0312 6DF6 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6DF8 833C 
     6DFA 833E 
0313 6DFC 1308  14         jeq   ed_wait
0314               *--------------------------------------------------------------
0315               * New key pressed
0316               *--------------------------------------------------------------
0317               ed_new_key
0318 6DFE C820  54         mov   @waux1,@waux2         ; Save as previous key
     6E00 833C 
     6E02 833E 
0319 6E04 1045  14         jmp   edkey                 ; Process key
0320               *--------------------------------------------------------------
0321               * Clear keyboard buffer if no key pressed
0322               *--------------------------------------------------------------
0323               ed_clear_kbbuffer
0324 6E06 04E0  34         clr   @waux1
     6E08 833C 
0325 6E0A 04E0  34         clr   @waux2
     6E0C 833E 
0326               *--------------------------------------------------------------
0327               * Delay to avoid key bouncing
0328               *--------------------------------------------------------------
0329               ed_wait
0330 6E0E 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6E10 0708 
0331                       ;------------------------------------------------------
0332                       ; Delay loop
0333                       ;------------------------------------------------------
0334               ed_wait_loop
0335 6E12 0604  14         dec   tmp0
0336 6E14 16FE  14         jne   ed_wait_loop
0337               *--------------------------------------------------------------
0338               * Exit
0339               *--------------------------------------------------------------
0340 6E16 0460  28 ed_exit b     @hookok               ; Return
     6E18 6BAE 
0341               
0342               
0343               
0344               
0345               
0346               
0347               ***************************************************************
0348               *                Tivi - Editor keyboard actions
0349               ***************************************************************
0350                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 6E1A 0D00             data  key_enter,edkey.action.enter          ; New line
     6E1C 727E 
0056 6E1E 0800             data  key_left,edkey.action.left            ; Move cursor left
     6E20 6EB2 
0057 6E22 0900             data  key_right,edkey.action.right          ; Move cursor right
     6E24 6EC8 
0058 6E26 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6E28 6EE0 
0059 6E2A 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6E2C 6F32 
0060 6E2E 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6E30 6F9E 
0061 6E32 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6E34 6FB6 
0062 6E36 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6E38 6FCA 
0063 6E3A 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6E3C 701C 
0064 6E3E 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6E40 707C 
0065 6E42 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6E44 70C6 
0066 6E46 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6E48 70F2 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 6E4A 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6E4C 7120 
0071 6E4E 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6E50 7158 
0072 6E52 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6E54 718C 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 6E56 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6E58 71E4 
0077 6E5A B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6E5C 72EC 
0078 6E5E 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6E60 723A 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 6E62 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6E64 733C 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 6E66 B000             data  key_buf0,edkey.action.buffer0
     6E68 7388 
0087 6E6A B100             data  key_buf1,edkey.action.buffer1
     6E6C 738E 
0088 6E6E B200             data  key_buf2,edkey.action.buffer2
     6E70 7394 
0089 6E72 B300             data  key_buf3,edkey.action.buffer3
     6E74 739A 
0090 6E76 B400             data  key_buf4,edkey.action.buffer4
     6E78 73A0 
0091 6E7A B500             data  key_buf5,edkey.action.buffer5
     6E7C 73A6 
0092 6E7E B600             data  key_buf6,edkey.action.buffer6
     6E80 73AC 
0093 6E82 B700             data  key_buf7,edkey.action.buffer7
     6E84 73B2 
0094 6E86 9E00             data  key_buf8,edkey.action.buffer8
     6E88 73B8 
0095 6E8A 9F00             data  key_buf9,edkey.action.buffer9
     6E8C 73BE 
0096 6E8E FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 6E90 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6E92 833C 
0104 6E94 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6E96 FF00 
0105               
0106 6E98 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6E9A 6E1A 
0107 6E9C 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 6E9E 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 6EA0 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 6EA2 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 6EA4 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 6EA6 05C6  14         inct  tmp2                  ; No, skip action
0118 6EA8 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 6EAA C196  26         mov  *tmp2,tmp2             ; Get action address
0122 6EAC 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 6EAE 0460  28         b    @edkey.action.char     ; Add character to buffer
     6EB0 72FC 
**** **** ****     > tivi.asm.23569
0351                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6EB2 C120  34         mov   @fb.column,tmp0
     6EB4 220C 
0010 6EB6 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6EB8 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6EBA 220C 
0015 6EBC 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6EBE 832A 
0016 6EC0 0620  34         dec   @fb.current
     6EC2 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6EC4 0460  28 !       b     @ed_wait              ; Back to editor main
     6EC6 6E0E 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6EC8 8820  54         c     @fb.column,@fb.row.length
     6ECA 220C 
     6ECC 2208 
0028 6ECE 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6ED0 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6ED2 220C 
0033 6ED4 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6ED6 832A 
0034 6ED8 05A0  34         inc   @fb.current
     6EDA 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6EDC 0460  28 !       b     @ed_wait              ; Back to editor main
     6EDE 6E0E 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6EE0 8820  54         c     @fb.row.dirty,@w$ffff
     6EE2 220A 
     6EE4 6048 
0049 6EE6 1604  14         jne   edkey.action.up.cursor
0050 6EE8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6EEA 7754 
0051 6EEC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6EEE 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6EF0 C120  34         mov   @fb.row,tmp0
     6EF2 2206 
0057 6EF4 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6EF6 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6EF8 2204 
0060 6EFA 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6EFC 0604  14         dec   tmp0                  ; fb.topline--
0066 6EFE C804  38         mov   tmp0,@parm1
     6F00 8350 
0067 6F02 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F04 75EA 
0068 6F06 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6F08 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F0A 2206 
0074 6F0C 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F0E 64DE 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6F10 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F12 78AE 
0080 6F14 8820  54         c     @fb.column,@fb.row.length
     6F16 220C 
     6F18 2208 
0081 6F1A 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6F1C C820  54         mov   @fb.row.length,@fb.column
     6F1E 2208 
     6F20 220C 
0086 6F22 C120  34         mov   @fb.column,tmp0
     6F24 220C 
0087 6F26 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F28 64E8 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6F2A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F2C 75CE 
0093 6F2E 0460  28         b     @ed_wait              ; Back to editor main
     6F30 6E0E 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6F32 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6F34 2206 
     6F36 2304 
0102 6F38 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6F3A 8820  54         c     @fb.row.dirty,@w$ffff
     6F3C 220A 
     6F3E 6048 
0107 6F40 1604  14         jne   edkey.action.down.move
0108 6F42 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F44 7754 
0109 6F46 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F48 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6F4A C120  34         mov   @fb.topline,tmp0
     6F4C 2204 
0118 6F4E A120  34         a     @fb.row,tmp0
     6F50 2206 
0119 6F52 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6F54 2304 
0120 6F56 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6F58 C120  34         mov   @fb.screenrows,tmp0
     6F5A 2218 
0126 6F5C 0604  14         dec   tmp0
0127 6F5E 8120  34         c     @fb.row,tmp0
     6F60 2206 
0128 6F62 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6F64 C820  54         mov   @fb.topline,@parm1
     6F66 2204 
     6F68 8350 
0133 6F6A 05A0  34         inc   @parm1
     6F6C 8350 
0134 6F6E 06A0  32         bl    @fb.refresh
     6F70 75EA 
0135 6F72 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6F74 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6F76 2206 
0141 6F78 06A0  32         bl    @down                 ; Row++ VDP cursor
     6F7A 64D6 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6F7C 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F7E 78AE 
0147 6F80 8820  54         c     @fb.column,@fb.row.length
     6F82 220C 
     6F84 2208 
0148 6F86 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 6F88 C820  54         mov   @fb.row.length,@fb.column
     6F8A 2208 
     6F8C 220C 
0153 6F8E C120  34         mov   @fb.column,tmp0
     6F90 220C 
0154 6F92 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F94 64E8 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 6F96 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F98 75CE 
0160 6F9A 0460  28 !       b     @ed_wait              ; Back to editor main
     6F9C 6E0E 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 6F9E C120  34         mov   @wyx,tmp0
     6FA0 832A 
0169 6FA2 0244  22         andi  tmp0,>ff00
     6FA4 FF00 
0170 6FA6 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6FA8 832A 
0171 6FAA 04E0  34         clr   @fb.column
     6FAC 220C 
0172 6FAE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FB0 75CE 
0173 6FB2 0460  28         b     @ed_wait              ; Back to editor main
     6FB4 6E0E 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 6FB6 C120  34         mov   @fb.row.length,tmp0
     6FB8 2208 
0180 6FBA C804  38         mov   tmp0,@fb.column
     6FBC 220C 
0181 6FBE 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6FC0 64E8 
0182 6FC2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FC4 75CE 
0183 6FC6 0460  28         b     @ed_wait              ; Back to editor main
     6FC8 6E0E 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 6FCA C120  34         mov   @fb.column,tmp0
     6FCC 220C 
0192 6FCE 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 6FD0 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6FD2 2202 
0197 6FD4 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 6FD6 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 6FD8 0605  14         dec   tmp1
0204 6FDA 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 6FDC 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 6FDE D195  26         movb  *tmp1,tmp2            ; Get character
0212 6FE0 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 6FE2 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 6FE4 0986  56         srl   tmp2,8                ; Right justify
0215 6FE6 0286  22         ci    tmp2,32               ; Space character found?
     6FE8 0020 
0216 6FEA 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 6FEC 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6FEE 2020 
0222 6FF0 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 6FF2 0287  22         ci    tmp3,>20ff            ; First character is space
     6FF4 20FF 
0225 6FF6 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 6FF8 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6FFA 220C 
0230 6FFC 61C4  18         s     tmp0,tmp3
0231 6FFE 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7000 0002 
0232 7002 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 7004 0585  14         inc   tmp1
0238 7006 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 7008 C805  38         mov   tmp1,@fb.current
     700A 2202 
0244 700C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     700E 220C 
0245 7010 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7012 64E8 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 7014 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7016 75CE 
0251 7018 0460  28 !       b     @ed_wait              ; Back to editor main
     701A 6E0E 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 701C 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 701E C120  34         mov   @fb.column,tmp0
     7020 220C 
0261 7022 8804  38         c     tmp0,@fb.row.length
     7024 2208 
0262 7026 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 7028 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     702A 2202 
0267 702C 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 702E 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 7030 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 7032 0585  14         inc   tmp1
0279 7034 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 7036 8804  38         c     tmp0,@fb.row.length
     7038 2208 
0281 703A 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 703C D195  26         movb  *tmp1,tmp2            ; Get character
0288 703E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 7040 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 7042 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 7044 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7046 FFFF 
0293 7048 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 704A 0286  22         ci    tmp2,32
     704C 0020 
0299 704E 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 7050 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 7052 0286  22         ci    tmp2,32               ; Space character found?
     7054 0020 
0307 7056 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 7058 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     705A 2020 
0313 705C 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 705E 0287  22         ci    tmp3,>20ff            ; First characer is space?
     7060 20FF 
0316 7062 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 7064 0585  14         inc   tmp1
0321 7066 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 7068 C805  38         mov   tmp1,@fb.current
     706A 2202 
0327 706C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     706E 220C 
0328 7070 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7072 64E8 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 7074 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7076 75CE 
0334 7078 0460  28 !       b     @ed_wait              ; Back to editor main
     707A 6E0E 
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
0346 707C C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     707E 2204 
0347 7080 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 7082 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     7084 2218 
0352 7086 1503  14         jgt   edkey.action.ppage.topline
0353 7088 04E0  34         clr   @fb.topline           ; topline = 0
     708A 2204 
0354 708C 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 708E 6820  54         s     @fb.screenrows,@fb.topline
     7090 2218 
     7092 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 7094 8820  54         c     @fb.row.dirty,@w$ffff
     7096 220A 
     7098 6048 
0365 709A 1604  14         jne   edkey.action.ppage.refresh
0366 709C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     709E 7754 
0367 70A0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70A2 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 70A4 C820  54         mov   @fb.topline,@parm1
     70A6 2204 
     70A8 8350 
0373 70AA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     70AC 75EA 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 70AE 04E0  34         clr   @fb.row
     70B0 2206 
0379 70B2 05A0  34         inc   @fb.row               ; Set fb.row=1
     70B4 2206 
0380 70B6 04E0  34         clr   @fb.column
     70B8 220C 
0381 70BA 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     70BC 0100 
0382 70BE C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     70C0 832A 
0383 70C2 0460  28         b     @edkey.action.up      ; Do rest of logic
     70C4 6EE0 
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
0394 70C6 C120  34         mov   @fb.topline,tmp0
     70C8 2204 
0395 70CA A120  34         a     @fb.screenrows,tmp0
     70CC 2218 
0396 70CE 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     70D0 2304 
0397 70D2 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 70D4 A820  54         a     @fb.screenrows,@fb.topline
     70D6 2218 
     70D8 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 70DA 8820  54         c     @fb.row.dirty,@w$ffff
     70DC 220A 
     70DE 6048 
0408 70E0 1604  14         jne   edkey.action.npage.refresh
0409 70E2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70E4 7754 
0410 70E6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70E8 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 70EA 0460  28         b     @edkey.action.ppage.refresh
     70EC 70A4 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 70EE 0460  28         b     @ed_wait              ; Back to editor main
     70F0 6E0E 
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
0433 70F2 8820  54         c     @fb.row.dirty,@w$ffff
     70F4 220A 
     70F6 6048 
0434 70F8 1604  14         jne   edkey.action.top.refresh
0435 70FA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70FC 7754 
0436 70FE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7100 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 7102 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     7104 2204 
0442 7106 04E0  34         clr   @parm1
     7108 8350 
0443 710A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     710C 75EA 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 710E 04E0  34         clr   @fb.row               ; Editor line 0
     7110 2206 
0449 7112 04E0  34         clr   @fb.column            ; Editor column 0
     7114 220C 
0450 7116 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 7118 C804  38         mov   tmp0,@wyx             ;
     711A 832A 
0452 711C 0460  28         b     @ed_wait              ; Back to editor main
     711E 6E0E 
**** **** ****     > tivi.asm.23569
0352                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 7120 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7122 2306 
0010 7124 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7126 75CE 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 7128 C120  34         mov   @fb.current,tmp0      ; Get pointer
     712A 2202 
0015 712C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     712E 2208 
0016 7130 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7132 8820  54         c     @fb.column,@fb.row.length
     7134 220C 
     7136 2208 
0022 7138 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 713A C120  34         mov   @fb.current,tmp0      ; Get pointer
     713C 2202 
0028 713E C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 7140 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7142 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7144 0606  14         dec   tmp2
0036 7146 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 7148 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     714A 220A 
0041 714C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     714E 2216 
0042 7150 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7152 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7154 0460  28         b     @ed_wait              ; Back to editor main
     7156 6E0E 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 7158 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     715A 2306 
0055 715C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     715E 75CE 
0056 7160 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7162 2208 
0057 7164 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 7166 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7168 2202 
0063 716A C1A0  34         mov   @fb.colsline,tmp2
     716C 220E 
0064 716E 61A0  34         s     @fb.column,tmp2
     7170 220C 
0065 7172 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 7174 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 7176 0606  14         dec   tmp2
0072 7178 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 717A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     717C 220A 
0077 717E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7180 2216 
0078               
0079 7182 C820  54         mov   @fb.column,@fb.row.length
     7184 220C 
     7186 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 7188 0460  28         b     @ed_wait              ; Back to editor main
     718A 6E0E 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 718C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     718E 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 7190 C120  34         mov   @edb.lines,tmp0
     7192 2304 
0097 7194 1604  14         jne   !
0098 7196 04E0  34         clr   @fb.column            ; Column 0
     7198 220C 
0099 719A 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     719C 7158 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 719E 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71A0 75CE 
0104 71A2 04E0  34         clr   @fb.row.dirty         ; Discard current line
     71A4 220A 
0105 71A6 C820  54         mov   @fb.topline,@parm1
     71A8 2204 
     71AA 8350 
0106 71AC A820  54         a     @fb.row,@parm1        ; Line number to remove
     71AE 2206 
     71B0 8350 
0107 71B2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71B4 2304 
     71B6 8352 
0108 71B8 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     71BA 769E 
0109 71BC 0620  34         dec   @edb.lines            ; One line less in editor buffer
     71BE 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 71C0 C820  54         mov   @fb.topline,@parm1
     71C2 2204 
     71C4 8350 
0114 71C6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71C8 75EA 
0115 71CA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71CC 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 71CE C120  34         mov   @fb.topline,tmp0
     71D0 2204 
0120 71D2 A120  34         a     @fb.row,tmp0
     71D4 2206 
0121 71D6 8804  38         c     tmp0,@edb.lines       ; Was last line?
     71D8 2304 
0122 71DA 1202  14         jle   edkey.action.del_line.exit
0123 71DC 0460  28         b     @edkey.action.up      ; One line up
     71DE 6EE0 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 71E0 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     71E2 6F9E 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 71E4 0204  20         li    tmp0,>2000            ; White space
     71E6 2000 
0139 71E8 C804  38         mov   tmp0,@parm1
     71EA 8350 
0140               edkey.action.ins_char:
0141 71EC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71EE 2306 
0142 71F0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71F2 75CE 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 71F4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     71F6 2202 
0147 71F8 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     71FA 2208 
0148 71FC 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 71FE 8820  54         c     @fb.column,@fb.row.length
     7200 220C 
     7202 2208 
0154 7204 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 7206 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 7208 61E0  34         s     @fb.column,tmp3
     720A 220C 
0162 720C A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 720E C144  18         mov   tmp0,tmp1
0164 7210 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7212 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7214 220C 
0166 7216 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 7218 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 721A 0604  14         dec   tmp0
0173 721C 0605  14         dec   tmp1
0174 721E 0606  14         dec   tmp2
0175 7220 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 7222 D560  46         movb  @parm1,*tmp1
     7224 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 7226 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7228 220A 
0184 722A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     722C 2216 
0185 722E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7230 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7232 0460  28         b     @edkey.action.char.overwrite
     7234 730E 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 7236 0460  28         b     @ed_wait              ; Back to editor main
     7238 6E0E 
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
0206 723A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     723C 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 723E 8820  54         c     @fb.row.dirty,@w$ffff
     7240 220A 
     7242 6048 
0211 7244 1604  14         jne   edkey.action.ins_line.insert
0212 7246 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7248 7754 
0213 724A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     724C 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 724E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7250 75CE 
0219 7252 C820  54         mov   @fb.topline,@parm1
     7254 2204 
     7256 8350 
0220 7258 A820  54         a     @fb.row,@parm1        ; Line number to insert
     725A 2206 
     725C 8350 
0221               
0222 725E C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7260 2304 
     7262 8352 
0223 7264 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7266 76D2 
0224 7268 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     726A 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 726C C820  54         mov   @fb.topline,@parm1
     726E 2204 
     7270 8350 
0229 7272 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7274 75EA 
0230 7276 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7278 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 727A 0460  28         b     @ed_wait              ; Back to editor main
     727C 6E0E 
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
0249 727E 8820  54         c     @fb.row.dirty,@w$ffff
     7280 220A 
     7282 6048 
0250 7284 1606  14         jne   edkey.action.enter.upd_counter
0251 7286 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7288 2306 
0252 728A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     728C 7754 
0253 728E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7290 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 7292 C120  34         mov   @fb.topline,tmp0
     7294 2204 
0259 7296 A120  34         a     @fb.row,tmp0
     7298 2206 
0260 729A 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     729C 2304 
0261 729E 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 72A0 05A0  34         inc   @edb.lines            ; Total lines++
     72A2 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 72A4 C120  34         mov   @fb.screenrows,tmp0
     72A6 2218 
0271 72A8 0604  14         dec   tmp0
0272 72AA 8120  34         c     @fb.row,tmp0
     72AC 2206 
0273 72AE 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 72B0 C120  34         mov   @fb.screenrows,tmp0
     72B2 2218 
0278 72B4 C820  54         mov   @fb.topline,@parm1
     72B6 2204 
     72B8 8350 
0279 72BA 05A0  34         inc   @parm1
     72BC 8350 
0280 72BE 06A0  32         bl    @fb.refresh
     72C0 75EA 
0281 72C2 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 72C4 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     72C6 2206 
0287 72C8 06A0  32         bl    @down                 ; Row++ VDP cursor
     72CA 64D6 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 72CC 06A0  32         bl    @fb.get.firstnonblank
     72CE 7614 
0293 72D0 C120  34         mov   @outparm1,tmp0
     72D2 8360 
0294 72D4 C804  38         mov   tmp0,@fb.column
     72D6 220C 
0295 72D8 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     72DA 64E8 
0296 72DC 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     72DE 78AE 
0297 72E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72E2 75CE 
0298 72E4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72E6 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 72E8 0460  28         b     @ed_wait              ; Back to editor main
     72EA 6E0E 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 72EC 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     72EE 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 72F0 0204  20         li    tmp0,2000
     72F2 07D0 
0317               edkey.action.ins_onoff.loop:
0318 72F4 0604  14         dec   tmp0
0319 72F6 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 72F8 0460  28         b     @task2.cur_visible    ; Update cursor shape
     72FA 7462 
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
0335 72FC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72FE 2306 
0336 7300 D805  38         movb  tmp1,@parm1           ; Store character for insert
     7302 8350 
0337 7304 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7306 230C 
0338 7308 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 730A 0460  28         b     @edkey.action.ins_char
     730C 71EC 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 730E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7310 75CE 
0349 7312 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7314 2202 
0350               
0351 7316 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7318 8350 
0352 731A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     731C 220A 
0353 731E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7320 2216 
0354               
0355 7322 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7324 220C 
0356 7326 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7328 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 732A 8820  54         c     @fb.column,@fb.row.length
     732C 220C 
     732E 2208 
0361 7330 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7332 C820  54         mov   @fb.column,@fb.row.length
     7334 220C 
     7336 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 7338 0460  28         b     @ed_wait              ; Back to editor main
     733A 6E0E 
**** **** ****     > tivi.asm.23569
0353                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 733C 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     733E 6598 
0010 7340 0420  54         blwp  @0                    ; Exit
     7342 0000 
0011               
**** **** ****     > tivi.asm.23569
0354                       copy  "editorkeys_file.asm" ; Actions for file related keys
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
0016 7344 C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     7346 8350 
     7348 8352 
0017 734A C804  38         mov   tmp0,@parm1           ; Setup file to load
     734C 8350 
0018               
0019 734E 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7350 7734 
0020 7352 06A0  32         bl    @idx.init             ; Initialize index
     7354 765C 
0021 7356 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7358 7580 
0022 735A C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     735C 8352 
     735E 230E 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7360 06A0  32         bl    @filv
     7362 618E 
0027 7364 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7366 0000 
     7368 0004 
0028               
0029 736A C160  34         mov   @fb.screenrows,tmp1
     736C 2218 
0030 736E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7370 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 7372 04C4  14         clr   tmp0                  ; VDP target address
0034 7374 0205  20         li    tmp1,32               ; Character to fill
     7376 0020 
0035               
0036 7378 06A0  32         bl    @xfilv                ; Fill VDP memory
     737A 6194 
0037                                                   ; \ .  tmp0 = VDP target address
0038                                                   ; | .  tmp1 = Byte to fill
0039                                                   ; / .  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 737C 06A0  32         bl    @tfh.file.read        ; Read specified file
     737E 78CC 
0044                                                   ; \ .  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / .  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 7380 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     7382 2306 
0048 7384 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     7386 70F2 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 7388 0204  20         li   tmp0,fdname0
     738A 7B50 
0054 738C 10DB  14         jmp  edkey.action.loadfile
0055                                                   ; Load DIS/VAR 80 file into editor buffer
0056               edkey.action.buffer1:
0057 738E 0204  20         li   tmp0,fdname1
     7390 7B5E 
0058 7392 10D8  14         jmp  edkey.action.loadfile
0059                                                   ; Load DIS/VAR 80 file into editor buffer
0060               
0061               edkey.action.buffer2:
0062 7394 0204  20         li   tmp0,fdname2
     7396 7B6E 
0063 7398 10D5  14         jmp  edkey.action.loadfile
0064                                                   ; Load DIS/VAR 80 file into editor buffer
0065               
0066               edkey.action.buffer3:
0067 739A 0204  20         li   tmp0,fdname3
     739C 7B7C 
0068 739E 10D2  14         jmp  edkey.action.loadfile
0069                                                   ; Load DIS/VAR 80 file into editor buffer
0070               
0071               edkey.action.buffer4:
0072 73A0 0204  20         li   tmp0,fdname4
     73A2 7B8A 
0073 73A4 10CF  14         jmp  edkey.action.loadfile
0074                                                   ; Load DIS/VAR 80 file into editor buffer
0075               
0076               edkey.action.buffer5:
0077 73A6 0204  20         li   tmp0,fdname5
     73A8 7B98 
0078 73AA 10CC  14         jmp  edkey.action.loadfile
0079                                                   ; Load DIS/VAR 80 file into editor buffer
0080               
0081               edkey.action.buffer6:
0082 73AC 0204  20         li   tmp0,fdname6
     73AE 7BA6 
0083 73B0 10C9  14         jmp  edkey.action.loadfile
0084                                                   ; Load DIS/VAR 80 file into editor buffer
0085               
0086               edkey.action.buffer7:
0087 73B2 0204  20         li   tmp0,fdname7
     73B4 7BB4 
0088 73B6 10C6  14         jmp  edkey.action.loadfile
0089                                                   ; Load DIS/VAR 80 file into editor buffer
0090               
0091               edkey.action.buffer8:
0092 73B8 0204  20         li   tmp0,fdname8
     73BA 7BC2 
0093 73BC 10C3  14         jmp  edkey.action.loadfile
0094                                                   ; Load DIS/VAR 80 file into editor buffer
0095               
0096               edkey.action.buffer9:
0097 73BE 0204  20         li   tmp0,fdname9
     73C0 7BD0 
0098 73C2 10C0  14         jmp  edkey.action.loadfile
0099                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.23569
0355               
0356               
0357               
0358               ***************************************************************
0359               * Task 0 - Copy frame buffer to VDP
0360               ***************************************************************
0361 73C4 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     73C6 2216 
0362 73C8 133D  14         jeq   task0.$$              ; No, skip update
0363                       ;------------------------------------------------------
0364                       ; Determine how many rows to copy
0365                       ;------------------------------------------------------
0366 73CA 8820  54         c     @edb.lines,@fb.screenrows
     73CC 2304 
     73CE 2218 
0367 73D0 1103  14         jlt   task0.setrows.small
0368 73D2 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     73D4 2218 
0369 73D6 1003  14         jmp   task0.copy.framebuffer
0370                       ;------------------------------------------------------
0371                       ; Less lines in editor buffer as rows in frame buffer
0372                       ;------------------------------------------------------
0373               task0.setrows.small:
0374 73D8 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     73DA 2304 
0375 73DC 0585  14         inc   tmp1
0376                       ;------------------------------------------------------
0377                       ; Determine area to copy
0378                       ;------------------------------------------------------
0379               task0.copy.framebuffer:
0380 73DE 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     73E0 220E 
0381                                                   ; 16 bit part is in tmp2!
0382 73E2 04C4  14         clr   tmp0                  ; VDP target address
0383 73E4 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     73E6 2200 
0384                       ;------------------------------------------------------
0385                       ; Copy memory block
0386                       ;------------------------------------------------------
0387 73E8 06A0  32         bl    @xpym2v               ; Copy to VDP
     73EA 633E 
0388                                                   ; tmp0 = VDP target address
0389                                                   ; tmp1 = RAM source address
0390                                                   ; tmp2 = Bytes to copy
0391 73EC 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     73EE 2216 
0392                       ;-------------------------------------------------------
0393                       ; Draw EOF marker at end-of-file
0394                       ;-------------------------------------------------------
0395 73F0 C120  34         mov   @edb.lines,tmp0
     73F2 2304 
0396 73F4 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     73F6 2204 
0397 73F8 0584  14         inc   tmp0                  ; Y++
0398 73FA 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     73FC 2218 
0399 73FE 1222  14         jle   task0.$$
0400                       ;-------------------------------------------------------
0401                       ; Draw EOF marker
0402                       ;-------------------------------------------------------
0403               task0.draw_marker:
0404 7400 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7402 832A 
     7404 2214 
0405 7406 0A84  56         sla   tmp0,8                ; X=0
0406 7408 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     740A 832A 
0407 740C 06A0  32         bl    @putstr
     740E 631E 
0408 7410 7B1E                   data txt_marker       ; Display *EOF*
0409                       ;-------------------------------------------------------
0410                       ; Draw empty line after (and below) EOF marker
0411                       ;-------------------------------------------------------
0412 7412 06A0  32         bl    @setx
     7414 64E6 
0413 7416 0005                   data  5               ; Cursor after *EOF* string
0414               
0415 7418 C120  34         mov   @wyx,tmp0
     741A 832A 
0416 741C 0984  56         srl   tmp0,8                ; Right justify
0417 741E 0584  14         inc   tmp0                  ; One time adjust
0418 7420 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7422 2218 
0419 7424 1303  14         jeq   !
0420 7426 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7428 009B 
0421 742A 1002  14         jmp   task0.draw_marker.line
0422 742C 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     742E 004B 
0423                       ;-------------------------------------------------------
0424                       ; Draw empty line
0425                       ;-------------------------------------------------------
0426               task0.draw_marker.line:
0427 7430 0604  14         dec   tmp0                  ; One time adjust
0428 7432 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7434 62FA 
0429 7436 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7438 0020 
0430 743A 06A0  32         bl    @xfilv                ; Write characters
     743C 6194 
0431 743E C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7440 2214 
     7442 832A 
0432               *--------------------------------------------------------------
0433               * Task 0 - Exit
0434               *--------------------------------------------------------------
0435               task0.$$:
0436 7444 0460  28         b     @slotok
     7446 6C2A 
0437               
0438               
0439               
0440               ***************************************************************
0441               * Task 1 - Copy SAT to VDP
0442               ***************************************************************
0443 7448 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     744A 6046 
0444 744C 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     744E 64F2 
0445 7450 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7452 8380 
0446 7454 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0447               
0448               
0449               ***************************************************************
0450               * Task 2 - Update cursor shape (blink)
0451               ***************************************************************
0452 7456 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     7458 2212 
0453 745A 1303  14         jeq   task2.cur_visible
0454 745C 04E0  34         clr   @ramsat+2              ; Hide cursor
     745E 8382 
0455 7460 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0456               
0457               task2.cur_visible:
0458 7462 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7464 230C 
0459 7466 1303  14         jeq   task2.cur_visible.overwrite_mode
0460                       ;------------------------------------------------------
0461                       ; Cursor in insert mode
0462                       ;------------------------------------------------------
0463               task2.cur_visible.insert_mode:
0464 7468 0204  20         li    tmp0,>000f
     746A 000F 
0465 746C 1002  14         jmp   task2.cur_visible.cursorshape
0466                       ;------------------------------------------------------
0467                       ; Cursor in overwrite mode
0468                       ;------------------------------------------------------
0469               task2.cur_visible.overwrite_mode:
0470 746E 0204  20         li    tmp0,>020f
     7470 020F 
0471                       ;------------------------------------------------------
0472                       ; Set cursor shape
0473                       ;------------------------------------------------------
0474               task2.cur_visible.cursorshape:
0475 7472 C804  38         mov   tmp0,@fb.curshape
     7474 2210 
0476 7476 C804  38         mov   tmp0,@ramsat+2
     7478 8382 
0477               
0478               
0479               
0480               
0481               
0482               
0483               
0484               *--------------------------------------------------------------
0485               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0486               *--------------------------------------------------------------
0487               task.sub_copy_ramsat
0488 747A 06A0  32         bl    @cpym2v
     747C 6338 
0489 747E 2000                   data sprsat,ramsat,4   ; Update sprite
     7480 8380 
     7482 0004 
0490               
0491 7484 C820  54         mov   @wyx,@fb.yxsave
     7486 832A 
     7488 2214 
0492                       ;------------------------------------------------------
0493                       ; Show text editing mode
0494                       ;------------------------------------------------------
0495               task.botline.show_mode
0496 748A C120  34         mov   @edb.insmode,tmp0
     748C 230C 
0497 748E 1605  14         jne   task.botline.show_mode.insert
0498                       ;------------------------------------------------------
0499                       ; Overwrite mode
0500                       ;------------------------------------------------------
0501               task.botline.show_mode.overwrite:
0502 7490 06A0  32         bl    @putat
     7492 6330 
0503 7494 1D32                   byte  29,50
0504 7496 7B2A                   data  txt_ovrwrite
0505 7498 1004  14         jmp   task.botline.show_changed
0506                       ;------------------------------------------------------
0507                       ; Insert  mode
0508                       ;------------------------------------------------------
0509               task.botline.show_mode.insert:
0510 749A 06A0  32         bl    @putat
     749C 6330 
0511 749E 1D32                   byte  29,50
0512 74A0 7B2E                   data  txt_insert
0513                       ;------------------------------------------------------
0514                       ; Show if text was changed in editor buffer
0515                       ;------------------------------------------------------
0516               task.botline.show_changed:
0517 74A2 C120  34         mov   @edb.dirty,tmp0
     74A4 2306 
0518 74A6 1305  14         jeq   task.botline.show_changed.clear
0519                       ;------------------------------------------------------
0520                       ; Show "*"
0521                       ;------------------------------------------------------
0522 74A8 06A0  32         bl    @putat
     74AA 6330 
0523 74AC 1D36                   byte 29,54
0524 74AE 7B32                   data txt_star
0525 74B0 1001  14         jmp   task.botline.show_linecol
0526                       ;------------------------------------------------------
0527                       ; Show "line,column"
0528                       ;------------------------------------------------------
0529               task.botline.show_changed.clear:
0530 74B2 1000  14         nop
0531               task.botline.show_linecol:
0532 74B4 C820  54         mov   @fb.row,@parm1
     74B6 2206 
     74B8 8350 
0533 74BA 06A0  32         bl    @fb.row2line
     74BC 75BA 
0534 74BE 05A0  34         inc   @outparm1
     74C0 8360 
0535                       ;------------------------------------------------------
0536                       ; Show line
0537                       ;------------------------------------------------------
0538 74C2 06A0  32         bl    @putnum
     74C4 6850 
0539 74C6 1D40                   byte  29,64            ; YX
0540 74C8 8360                   data  outparm1,rambuf
     74CA 8390 
0541 74CC 3020                   byte  48               ; ASCII offset
0542                             byte  32               ; Padding character
0543                       ;------------------------------------------------------
0544                       ; Show comma
0545                       ;------------------------------------------------------
0546 74CE 06A0  32         bl    @putat
     74D0 6330 
0547 74D2 1D45                   byte  29,69
0548 74D4 7B1C                   data  txt_delim
0549                       ;------------------------------------------------------
0550                       ; Show column
0551                       ;------------------------------------------------------
0552 74D6 06A0  32         bl    @film
     74D8 6136 
0553 74DA 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     74DC 0020 
     74DE 000C 
0554               
0555 74E0 C820  54         mov   @fb.column,@waux1
     74E2 220C 
     74E4 833C 
0556 74E6 05A0  34         inc   @waux1                 ; Offset 1
     74E8 833C 
0557               
0558 74EA 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     74EC 67D2 
0559 74EE 833C                   data  waux1,rambuf
     74F0 8390 
0560 74F2 3020                   byte  48               ; ASCII offset
0561                             byte  32               ; Fill character
0562               
0563 74F4 06A0  32         bl    @trimnum               ; Trim number to the left
     74F6 682A 
0564 74F8 8390                   data  rambuf,rambuf+6,32
     74FA 8396 
     74FC 0020 
0565               
0566 74FE 0204  20         li    tmp0,>0200
     7500 0200 
0567 7502 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7504 8396 
0568               
0569 7506 06A0  32         bl    @putat
     7508 6330 
0570 750A 1D46                   byte 29,70
0571 750C 8396                   data rambuf+6          ; Show column
0572                       ;------------------------------------------------------
0573                       ; Show lines in buffer unless on last line in file
0574                       ;------------------------------------------------------
0575 750E C820  54         mov   @fb.row,@parm1
     7510 2206 
     7512 8350 
0576 7514 06A0  32         bl    @fb.row2line
     7516 75BA 
0577 7518 8820  54         c     @edb.lines,@outparm1
     751A 2304 
     751C 8360 
0578 751E 1605  14         jne   task.botline.show_lines_in_buffer
0579               
0580 7520 06A0  32         bl    @putat
     7522 6330 
0581 7524 1D49                   byte 29,73
0582 7526 7B24                   data txt_bottom
0583               
0584 7528 100B  14         jmp   task.botline.$$
0585                       ;------------------------------------------------------
0586                       ; Show lines in buffer
0587                       ;------------------------------------------------------
0588               task.botline.show_lines_in_buffer:
0589 752A C820  54         mov   @edb.lines,@waux1
     752C 2304 
     752E 833C 
0590 7530 05A0  34         inc   @waux1                 ; Offset 1
     7532 833C 
0591 7534 06A0  32         bl    @putnum
     7536 6850 
0592 7538 1D49                   byte 29,73             ; YX
0593 753A 833C                   data waux1,rambuf
     753C 8390 
0594 753E 3020                   byte 48
0595                             byte 32
0596                       ;------------------------------------------------------
0597                       ; Exit
0598                       ;------------------------------------------------------
0599               task.botline.$$
0600 7540 C820  54         mov   @fb.yxsave,@wyx
     7542 2214 
     7544 832A 
0601 7546 0460  28         b     @slotok                ; Exit running task
     7548 6C2A 
0602               
0603               
0604               
0605               ***************************************************************
0606               *              mem - Memory Management module
0607               ***************************************************************
0608                       copy  "memory.asm"
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
0021 754A 0649  14         dect  stack
0022 754C C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 754E 06A0  32         bl    @sams.layout
     7550 642C 
0027 7552 7560                   data data.tivi.sams.layout
0028               
0029 7554 0204  20         li    tmp0,3                ; Start with page 3
     7556 0003 
0030 7558 C804  38         mov   tmp0,@edb.samspage    ; Set current SAMS page
     755A 2310 
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.setup.sams.layout.exit:
0035 755C C2F9  30         mov   *stack+,r11           ; Pop r11
0036 755E 045B  20         b     *r11                  ; Return to caller
0037               ***************************************************************
0038               * SAMS page layout table for TiVi (16 words)
0039               *--------------------------------------------------------------
0040               data.tivi.sams.layout:
0041 7560 2000             data  >2000,>0000           ; >2000-2fff, SAMS page >00
     7562 0000 
0042 7564 3000             data  >3000,>0001           ; >3000-3fff, SAMS page >01
     7566 0001 
0043 7568 A000             data  >a000,>0002           ; >a000-afff, SAMS page >02
     756A 0002 
0044 756C B000             data  >b000,>0003           ; >b000-bfff, SAMS page >03
     756E 0003 
0045 7570 C000             data  >c000,>0004           ; >c000-cfff, SAMS page >04
     7572 0004 
0046 7574 D000             data  >d000,>0005           ; >d000-dfff, SAMS page >05
     7576 0005 
0047 7578 E000             data  >e000,>0006           ; >e000-efff, SAMS page >06
     757A 0006 
0048 757C F000             data  >f000,>0007           ; >f000-ffff, SAMS page >07
     757E 0007 
**** **** ****     > tivi.asm.23569
0609               
0610               ***************************************************************
0611               *                 fb - Framebuffer module
0612               ***************************************************************
0613                       copy  "framebuffer.asm"
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
0024 7580 0649  14         dect  stack
0025 7582 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7584 0204  20         li    tmp0,fb.top
     7586 2650 
0030 7588 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     758A 2200 
0031 758C 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     758E 2204 
0032 7590 04E0  34         clr   @fb.row               ; Current row=0
     7592 2206 
0033 7594 04E0  34         clr   @fb.column            ; Current column=0
     7596 220C 
0034 7598 0204  20         li    tmp0,80
     759A 0050 
0035 759C C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     759E 220E 
0036 75A0 0204  20         li    tmp0,29
     75A2 001D 
0037 75A4 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     75A6 2218 
0038 75A8 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     75AA 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 75AC 06A0  32         bl    @film
     75AE 6136 
0043 75B0 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     75B2 0000 
     75B4 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 75B6 0460  28         b     @poprt                ; Return to caller
     75B8 6132 
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
0073 75BA 0649  14         dect  stack
0074 75BC C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 75BE C120  34         mov   @parm1,tmp0
     75C0 8350 
0079 75C2 A120  34         a     @fb.topline,tmp0
     75C4 2204 
0080 75C6 C804  38         mov   tmp0,@outparm1
     75C8 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 75CA 0460  28         b    @poprt                 ; Return to caller
     75CC 6132 
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
0113 75CE 0649  14         dect  stack
0114 75D0 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 75D2 C1A0  34         mov   @fb.row,tmp2
     75D4 2206 
0119 75D6 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     75D8 220E 
0120 75DA A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     75DC 220C 
0121 75DE A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     75E0 2200 
0122 75E2 C807  38         mov   tmp3,@fb.current
     75E4 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 75E6 0460  28         b    @poprt                 ; Return to caller
     75E8 6132 
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
0145 75EA 0649  14         dect  stack
0146 75EC C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 75EE C820  54         mov   @parm1,@fb.topline
     75F0 8350 
     75F2 2204 
0151 75F4 04E0  34         clr   @parm2                ; Target row in frame buffer
     75F6 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 75F8 06A0  32         bl    @edb.line.unpack      ; Unpack line
     75FA 77EA 
0157                                                   ; \ .  parm1 = Line to unpack
0158                                                   ; / .  parm2 = Target row in frame buffer
0159               
0160 75FC 05A0  34         inc   @parm1                ; Next line in editor buffer
     75FE 8350 
0161 7600 05A0  34         inc   @parm2                ; Next row in frame buffer
     7602 8352 
0162 7604 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7606 8352 
     7608 2218 
0163 760A 11F6  14         jlt   fb.refresh.unpack_line
0164 760C 0720  34         seto  @fb.dirty             ; Refresh screen
     760E 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit
0169 7610 0460  28         b    @poprt                 ; Return to caller
     7612 6132 
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
0184               fb.get.firstnonblank
0185 7614 0649  14         dect  stack
0186 7616 C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 7618 04E0  34         clr   @fb.column
     761A 220C 
0191 761C 06A0  32         bl    @fb.calc_pointer
     761E 75CE 
0192 7620 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7622 78AE 
0193 7624 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7626 2208 
0194 7628 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 762A C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     762C 2202 
0197 762E 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 7630 D174  28         movb  *tmp0+,tmp1           ; Get character
0203 7632 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 7634 0285  22         ci    tmp1,>2000            ; Whitespace?
     7636 2000 
0206 7638 1503  14         jgt   fb.get.firstnonblank.match
0207 763A 0606  14         dec   tmp2                  ; Counter--
0208 763C 16F9  14         jne   fb.get.firstnonblank.loop
0209 763E 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match
0214 7640 6120  34         s     @fb.current,tmp0      ; Calculate column
     7642 2202 
0215 7644 0604  14         dec   tmp0
0216 7646 C804  38         mov   tmp0,@outparm1        ; Save column
     7648 8360 
0217 764A D805  38         movb  tmp1,@outparm2        ; Save character
     764C 8362 
0218 764E 1004  14         jmp   fb.get.firstnonblank.$$
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch
0223 7650 04E0  34         clr   @outparm1             ; X=0
     7652 8360 
0224 7654 04E0  34         clr   @outparm2             ; Null
     7656 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.$$
0229 7658 0460  28         b    @poprt                 ; Return to caller
     765A 6132 
0230               
0231               
0232               
0233               
0234               
0235               
**** **** ****     > tivi.asm.23569
0614               
0615               ***************************************************************
0616               *              idx - Index management module
0617               ***************************************************************
0618                       copy  "index.asm"
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
0048 765C 0649  14         dect  stack
0049 765E C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 7660 0204  20         li    tmp0,idx.top
     7662 3000 
0054 7664 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7666 2302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 7668 06A0  32         bl    @film
     766A 6136 
0059 766C 3000             data  idx.top,>00,idx.size  ; Clear main index
     766E 0000 
     7670 1000 
0060               
0061 7672 06A0  32         bl    @film
     7674 6136 
0062 7676 A000             data  idx.shadow.top,>00,idx.shadow.size
     7678 0000 
     767A 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 767C 0460  28         b     @poprt                ; Return to caller
     767E 6132 
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
0090 7680 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7682 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 7684 C160  34         mov   @parm2,tmp1
     7686 8352 
0095 7688 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 768A C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     768C 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 768E 0A14  56         sla   tmp0,1                ; line number * 2
0107 7690 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     7692 3000 
0108 7694 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     7696 A000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 7698 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     769A 8360 
0115 769C 045B  20         b     *r11                  ; Return
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
0135 769E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76A0 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 76A2 0A14  56         sla   tmp0,1                ; line number * 2
0140 76A4 C824  54         mov   @idx.top(tmp0),@outparm1
     76A6 3000 
     76A8 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 76AA C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     76AC 8352 
0146 76AE 61A0  34         s     @parm1,tmp2           ; Calculate loop
     76B0 8350 
0147 76B2 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 76B4 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 76B6 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     76B8 3002 
     76BA 3000 
0157 76BC C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     76BE A002 
     76C0 A000 
0158 76C2 05C4  14         inct  tmp0                  ; Next index entry
0159 76C4 0606  14         dec   tmp2                  ; tmp2--
0160 76C6 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 76C8 04E4  34         clr   @idx.top(tmp0)
     76CA 3000 
0167 76CC 04E4  34         clr   @idx.shadow.top(tmp0)
     76CE A000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 76D0 045B  20         b     *r11                  ; Return
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
0192 76D2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     76D4 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 76D6 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 76D8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     76DA 8352 
0201 76DC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     76DE 8350 
0202 76E0 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 76E2 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     76E4 3000 
     76E6 3002 
0207                                                   ; Move pointer
0208 76E8 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     76EA 3000 
0209               
0210 76EC C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     76EE A000 
     76F0 A002 
0211                                                   ; Move SAMS page
0212 76F2 04E4  34         clr   @idx.shadow.top+0(tmp0)
     76F4 A000 
0213                                                   ; Clear new index entry
0214 76F6 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 76F8 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 76FA C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     76FC 3000 
     76FE 3002 
0222                                                   ; Move pointer
0223               
0224 7700 C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     7702 A000 
     7704 A002 
0225                                                   ; Move SAMS page
0226               
0227 7706 0644  14         dect  tmp0                  ; Previous index entry
0228 7708 0606  14         dec   tmp2                  ; tmp2--
0229 770A 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 770C 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     770E 3004 
0232 7710 04E4  34         clr   @idx.shadow.top+4(tmp0)
     7712 A004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 7714 045B  20         b     *r11                  ; Return
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
0259 7716 0649  14         dect  stack
0260 7718 C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 771A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     771C 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 771E 0A14  56         sla   tmp0,1                ; line number * 2
0269 7720 C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     7722 3000 
0270 7724 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     7726 A000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 7728 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     772A 8360 
0277 772C C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     772E 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 7730 0460  28         b     @poprt                ; Return to caller
     7732 6132 
**** **** ****     > tivi.asm.23569
0619               
0620               ***************************************************************
0621               *               edb - Editor Buffer module
0622               ***************************************************************
0623                       copy  "editorbuffer.asm"
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
0026 7734 0649  14         dect  stack
0027 7736 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7738 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     773A B002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 773C C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     773E 2300 
0035 7740 C804  38         mov   tmp0,@edb.next_free.ptr
     7742 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 7744 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7746 230C 
0038 7748 04E0  34         clr   @edb.lines            ; Lines=0
     774A 2304 
0039 774C 04E0  34         clr   @edb.rle              ; RLE compression off
     774E 230E 
0040               
0041               edb.init.exit:
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045 7750 0460  28         b     @poprt                ; Return to caller
     7752 6132 
0046               
0047               
0048               
0049               ***************************************************************
0050               * edb.line.pack
0051               * Pack current line in framebuffer
0052               ***************************************************************
0053               *  bl   @edb.line.pack
0054               *--------------------------------------------------------------
0055               * INPUT
0056               * @fb.top       = Address of top row in frame buffer
0057               * @fb.row       = Current row in frame buffer
0058               * @fb.column    = Current column in frame buffer
0059               * @fb.colsline  = Columns per line in frame buffer
0060               *--------------------------------------------------------------
0061               * OUTPUT
0062               *--------------------------------------------------------------
0063               * Register usage
0064               * tmp0,tmp1,tmp2
0065               *--------------------------------------------------------------
0066               * Memory usage
0067               * rambuf   = Saved @fb.column
0068               * rambuf+2 = Saved beginning of row
0069               * rambuf+4 = Saved length of row
0070               ********|*****|*********************|**************************
0071               edb.line.pack:
0072 7754 0649  14         dect  stack
0073 7756 C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Get values
0076                       ;------------------------------------------------------
0077 7758 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     775A 220C 
     775C 8390 
0078 775E 04E0  34         clr   @fb.column
     7760 220C 
0079 7762 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7764 75CE 
0080                       ;------------------------------------------------------
0081                       ; Prepare scan
0082                       ;------------------------------------------------------
0083 7766 04C4  14         clr   tmp0                  ; Counter
0084 7768 C160  34         mov   @fb.current,tmp1      ; Get position
     776A 2202 
0085 776C C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     776E 8392 
0086               
0087                       ;------------------------------------------------------
0088                       ; Scan line for >00 byte termination
0089                       ;------------------------------------------------------
0090               edb.line.pack.scan:
0091 7770 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0092 7772 0986  56         srl   tmp2,8                ; Right justify
0093 7774 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0094 7776 0584  14         inc   tmp0                  ; Increase string length
0095 7778 10FB  14         jmp   edb.line.pack.scan    ; Next character
0096               
0097                       ;------------------------------------------------------
0098                       ; Prepare for storing line
0099                       ;------------------------------------------------------
0100               edb.line.pack.prepare:
0101 777A C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     777C 2204 
     777E 8350 
0102 7780 A820  54         a     @fb.row,@parm1        ; /
     7782 2206 
     7784 8350 
0103               
0104 7786 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7788 8394 
0105               
0106                       ;------------------------------------------------------
0107                       ; 1. Update index
0108                       ;------------------------------------------------------
0109               edb.line.pack.update_index:
0110 778A C820  54         mov   @edb.next_free.ptr,@parm2
     778C 2308 
     778E 8352 
0111                                                   ; Block where line will reside
0112               
0113 7790 C820  54         mov   @edb.samspage,@parm3  ; Get SAMS page
     7792 2310 
     7794 8354 
0114 7796 06A0  32         bl    @idx.entry.update     ; Update index
     7798 7680 
0115                                                   ; \ .  parm1 = Line number in editor buffer
0116                                                   ; | .  parm2 = pointer to line in editor buffer
0117                                                   ; / .  parm3 = SAMS page
0118               
0119                       ;------------------------------------------------------
0120                       ; 2. Switch to required SAMS page
0121                       ;------------------------------------------------------
0122 779A C120  34         mov   @edb.samspage,tmp0    ; Current SAMS page
     779C 2310 
0123 779E C160  34         mov   @edb.next_free.ptr,tmp1
     77A0 2308 
0124                                                   ; Pointer to line in editor buffer
0125 77A2 06A0  32         bl    @xsams.page           ; Switch to SAMS page
     77A4 63E2 
0126                                                   ; \ . tmp0 = SAMS page
0127                                                   ; / . tmp1 = Memory address
0128               
0129                       ;------------------------------------------------------
0130                       ; 3. Set line prefix in editor buffer
0131                       ;------------------------------------------------------
0132 77A6 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     77A8 8392 
0133 77AA C160  34         mov   @edb.next_free.ptr,tmp1
     77AC 2308 
0134                                                   ; Address of line in editor buffer
0135               
0136 77AE 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     77B0 2308 
0137               
0138 77B2 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     77B4 8394 
0139 77B6 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0140 77B8 06C6  14         swpb  tmp2
0141 77BA DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0142 77BC 06C6  14         swpb  tmp2
0143 77BE 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0144               
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.copyline:
0149 77C0 0286  22         ci    tmp2,2
     77C2 0002 
0150 77C4 1603  14         jne   edb.line.pack.copyline.checkbyte
0151 77C6 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 77C8 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 77CA 1007  14         jmp   !
0154               edb.line.pack.copyline.checkbyte:
0155 77CC 0286  22         ci    tmp2,1
     77CE 0001 
0156 77D0 1602  14         jne   edb.line.pack.copyline.block
0157 77D2 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0158 77D4 1002  14         jmp   !
0159               edb.line.pack.copyline.block:
0160 77D6 06A0  32         bl    @xpym2m               ; Copy memory block
     77D8 6386 
0161                                                   ;   tmp0 = source
0162                                                   ;   tmp1 = destination
0163                                                   ;   tmp2 = bytes to copy
0164               
0165 77DA A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     77DC 8394 
     77DE 2308 
0166                                                   ; Update pointer to next free line
0167               
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               edb.line.pack.exit:
0172 77E0 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     77E2 8390 
     77E4 220C 
0173 77E6 0460  28         b     @poprt                ; Return to caller
     77E8 6132 
0174               
0175               
0176               
0177               
0178               ***************************************************************
0179               * edb.line.unpack
0180               * Unpack specified line to framebuffer
0181               ***************************************************************
0182               *  bl   @edb.line.unpack
0183               *--------------------------------------------------------------
0184               * INPUT
0185               * @parm1 = Line to unpack from editor buffer
0186               * @parm2 = Target row in frame buffer
0187               *--------------------------------------------------------------
0188               * OUTPUT
0189               * none
0190               *--------------------------------------------------------------
0191               * Register usage
0192               * tmp0,tmp1,tmp2,tmp3
0193               *--------------------------------------------------------------
0194               * Memory usage
0195               * rambuf    = Saved @parm1 of edb.line.unpack
0196               * rambuf+2  = Saved @parm2 of edb.line.unpack
0197               * rambuf+4  = Source memory address in editor buffer
0198               * rambuf+6  = Destination memory address in frame buffer
0199               * rambuf+8  = Length of RLE (decompressed) line
0200               * rambuf+10 = Length of RLE compressed line
0201               ********|*****|*********************|**************************
0202               edb.line.unpack:
0203 77EA 0649  14         dect  stack
0204 77EC C64B  30         mov   r11,*stack            ; Save return address
0205                       ;------------------------------------------------------
0206                       ; Save parameters
0207                       ;------------------------------------------------------
0208 77EE C820  54         mov   @parm1,@rambuf
     77F0 8350 
     77F2 8390 
0209 77F4 C820  54         mov   @parm2,@rambuf+2
     77F6 8352 
     77F8 8392 
0210                       ;------------------------------------------------------
0211                       ; Calculate offset in frame buffer
0212                       ;------------------------------------------------------
0213 77FA C120  34         mov   @fb.colsline,tmp0
     77FC 220E 
0214 77FE 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7800 8352 
0215 7802 C1A0  34         mov   @fb.top.ptr,tmp2
     7804 2200 
0216 7806 A146  18         a     tmp2,tmp1             ; Add base to offset
0217 7808 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     780A 8396 
0218                       ;------------------------------------------------------
0219                       ; Get length of line to unpack
0220                       ;------------------------------------------------------
0221 780C 06A0  32         bl    @edb.line.getlength   ; Get length of line
     780E 7876 
0222                                                   ; \ .  parm1    = Line number
0223                                                   ; | o  outparm1 = Line length (uncompressed)
0224                                                   ; | o  outparm2 = Line length (compressed)
0225                                                   ; / o  outparm3 = SAMS bank (>0 - >a)
0226               
0227 7810 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7812 8362 
     7814 839A 
0228 7816 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7818 8360 
     781A 8398 
0229 781C 130D  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0230               
0231                       ;------------------------------------------------------
0232                       ; Index. Calculate address of entry and get pointer
0233                       ;------------------------------------------------------
0234 781E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7820 7716 
0235                                                   ; \ .  parm1    = Line number
0236                                                   ; | o  outparm1 = Pointer to line
0237                                                   ; / o  outparm2 = SAMS page
0238               
0239 7822 C120  34         mov   @outparm2,tmp0        ; SAMS page
     7824 8362 
0240 7826 C160  34         mov   @outparm1,tmp1        ; Memory address
     7828 8360 
0241 782A 06A0  32         bl    @xsams.page           ; Activate SAMS page
     782C 63E2 
0242                                                   ; \ .  tmp0 = SAMS page
0243                                                   ; / .  tmp1 = Memory address
0244               
0245 782E 05E0  34         inct  @outparm1             ; Skip line prefix
     7830 8360 
0246 7832 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7834 8360 
     7836 8394 
0247               
0248                       ;------------------------------------------------------
0249                       ; Erase chars from last column until column 80
0250                       ;------------------------------------------------------
0251               edb.line.unpack.clear:
0252 7838 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     783A 8396 
0253 783C A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     783E 8398 
0254               
0255 7840 04C5  14         clr   tmp1                  ; Fill with >00
0256 7842 C1A0  34         mov   @fb.colsline,tmp2
     7844 220E 
0257 7846 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7848 8398 
0258 784A 0586  14         inc   tmp2
0259               
0260 784C 06A0  32         bl    @xfilm                ; Fill CPU memory
     784E 613C 
0261                                                   ; \ .  tmp0 = Target address
0262                                                   ; | .  tmp1 = Byte to fill
0263                                                   ; / .  tmp2 = Repeat count
0264               
0265                       ;------------------------------------------------------
0266                       ; Prepare for unpacking data
0267                       ;------------------------------------------------------
0268               edb.line.unpack.prepare:
0269 7850 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     7852 8398 
0270 7854 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0271 7856 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7858 8394 
0272 785A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     785C 8396 
0273                       ;------------------------------------------------------
0274                       ; Either RLE decompress or do normal memory copy
0275                       ;------------------------------------------------------
0276 785E C1E0  34         mov   @edb.rle,tmp3
     7860 230E 
0277 7862 1305  14         jeq   edb.line.unpack.copy.uncompressed
0278                       ;------------------------------------------------------
0279                       ; Uncompress RLE line to frame buffer
0280                       ;------------------------------------------------------
0281 7864 C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     7866 839A 
0282               
0283 7868 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     786A 6912 
0284                                                   ; \ .  tmp0 = ROM/RAM source address
0285                                                   ; | .  tmp1 = RAM target address
0286                                                   ; / .  tmp2 = Length of RLE encoded data
0287 786C 1002  14         jmp   edb.line.unpack.exit
0288               
0289               edb.line.unpack.copy.uncompressed:
0290                       ;------------------------------------------------------
0291                       ; Copy memory block
0292                       ;------------------------------------------------------
0293 786E 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7870 6386 
0294                                                   ; \ .  tmp0 = Source address
0295                                                   ; | .  tmp1 = Target address
0296                                                   ; / .  tmp2 = Bytes to copy
0297                       ;------------------------------------------------------
0298                       ; Exit
0299                       ;------------------------------------------------------
0300               edb.line.unpack.exit:
0301 7872 0460  28         b     @poprt                ; Return to caller
     7874 6132 
0302               
0303               
0304               
0305               
0306               ***************************************************************
0307               * edb.line.getlength
0308               * Get length of specified line
0309               ***************************************************************
0310               *  bl   @edb.line.getlength
0311               *--------------------------------------------------------------
0312               * INPUT
0313               * @parm1 = Line number
0314               *--------------------------------------------------------------
0315               * OUTPUT
0316               * @outparm1 = Length of line (uncompressed)
0317               * @outparm2 = Length of line (compressed)
0318               * @outparm3 = SAMS page
0319               *--------------------------------------------------------------
0320               * Register usage
0321               * tmp0,tmp1,tmp2
0322               ********|*****|*********************|**************************
0323               edb.line.getlength:
0324 7876 0649  14         dect  stack
0325 7878 C64B  30         mov   r11,*stack            ; Save return address
0326                       ;------------------------------------------------------
0327                       ; Initialisation
0328                       ;------------------------------------------------------
0329 787A 04E0  34         clr   @outparm1             ; Reset uncompressed length
     787C 8360 
0330 787E 04E0  34         clr   @outparm2             ; Reset compressed length
     7880 8362 
0331 7882 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7884 8364 
0332                       ;------------------------------------------------------
0333                       ; Get length
0334                       ;------------------------------------------------------
0335 7886 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7888 7716 
0336                                                   ; \  parm1    = Line number
0337                                                   ; |  outparm1 = Pointer to line
0338                                                   ; /  outparm2 = SAMS page
0339               
0340 788A C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     788C 8360 
0341 788E 130D  14         jeq   edb.line.getlength.exit
0342                                                   ; Exit early if NULL pointer
0343 7890 C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     7892 8362 
     7894 8364 
0344                       ;------------------------------------------------------
0345                       ; Process line prefix
0346                       ;------------------------------------------------------
0347 7896 04C5  14         clr   tmp1
0348 7898 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0349 789A 06C5  14         swpb  tmp1
0350 789C C805  38         mov   tmp1,@outparm2        ; Save length
     789E 8362 
0351               
0352 78A0 04C5  14         clr   tmp1
0353 78A2 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0354 78A4 06C5  14         swpb  tmp1
0355 78A6 C805  38         mov   tmp1,@outparm1        ; Save length
     78A8 8360 
0356                       ;------------------------------------------------------
0357                       ; Exit
0358                       ;------------------------------------------------------
0359               edb.line.getlength.exit:
0360 78AA 0460  28         b     @poprt                ; Return to caller
     78AC 6132 
0361               
0362               
0363               
0364               
0365               ***************************************************************
0366               * edb.line.getlength2
0367               * Get length of current row (as seen from editor buffer side)
0368               ***************************************************************
0369               *  bl   @edb.line.getlength2
0370               *--------------------------------------------------------------
0371               * INPUT
0372               * @fb.row = Row in frame buffer
0373               *--------------------------------------------------------------
0374               * OUTPUT
0375               * @fb.row.length = Length of row
0376               *--------------------------------------------------------------
0377               * Register usage
0378               * tmp0
0379               ********|*****|*********************|**************************
0380               edb.line.getlength2:
0381 78AE 0649  14         dect  stack
0382 78B0 C64B  30         mov   r11,*stack            ; Save return address
0383                       ;------------------------------------------------------
0384                       ; Calculate line in editor buffer
0385                       ;------------------------------------------------------
0386 78B2 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     78B4 2204 
0387 78B6 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     78B8 2206 
0388                       ;------------------------------------------------------
0389                       ; Get length
0390                       ;------------------------------------------------------
0391 78BA C804  38         mov   tmp0,@parm1
     78BC 8350 
0392 78BE 06A0  32         bl    @edb.line.getlength
     78C0 7876 
0393 78C2 C820  54         mov   @outparm1,@fb.row.length
     78C4 8360 
     78C6 2208 
0394                                                   ; Save row length
0395                       ;------------------------------------------------------
0396                       ; Exit
0397                       ;------------------------------------------------------
0398               edb.line.getlength2.exit:
0399 78C8 0460  28         b     @poprt                ; Return to caller
     78CA 6132 
0400               
**** **** ****     > tivi.asm.23569
0624               
0625               ***************************************************************
0626               *               fh - File handling module
0627               ***************************************************************
0628                       copy  "filehandler.asm"
**** **** ****     > filehandler.asm
0001               * FILE......: filehandler.asm
0002               * Purpose...: File handling module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     Load and save files
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
0028 78CC 0649  14         dect  stack
0029 78CE C64B  30         mov   r11,*stack            ; Save return address
0030 78D0 C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     78D2 8352 
     78D4 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 78D6 04E0  34         clr   @tfh.records          ; Reset records counter
     78D8 242E 
0035 78DA 04E0  34         clr   @tfh.counter          ; Clear internal counter
     78DC 2434 
0036 78DE 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     78E0 2432 
0037 78E2 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 78E4 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     78E6 242A 
0039 78E8 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     78EA 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 78EC 06A0  32         bl    @hchar
     78EE 65C4 
0044 78F0 1D00                   byte 29,0,32,80
     78F2 2050 
0045 78F4 FFFF                   data EOL
0046               
0047 78F6 06A0  32         bl    @putat
     78F8 6330 
0048 78FA 1D00                   byte 29,0
0049 78FC 7B34                   data txt_loading      ; Display "Loading...."
0050               
0051 78FE 8820  54         c     @tfh.rleonload,@w$ffff
     7900 2436 
     7902 6048 
0052 7904 1604  14         jne   !
0053 7906 06A0  32         bl    @putat
     7908 6330 
0054 790A 1D44                   byte 29,68
0055 790C 7B44                   data txt_rle          ; Display "RLE"
0056               
0057 790E 06A0  32 !       bl    @at
     7910 64D0 
0058 7912 1D0B                   byte 29,11            ; Cursor YX position
0059 7914 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7916 8350 
0060 7918 06A0  32         bl    @xutst0               ; Display device/filename
     791A 6320 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 791C 06A0  32         bl    @cpym2v
     791E 6338 
0065 7920 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7922 7AF6 
     7924 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 7926 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7928 0A69 
0071 792A C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     792C 8350 
0072 792E D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 7930 0986  56         srl   tmp2,8                ; Right justify
0074 7932 0586  14         inc   tmp2                  ; Include length byte as well
0075 7934 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7936 633E 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 7938 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     793A 69D6 
0080 793C 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 793E 06A0  32         bl    @file.open
     7940 6B24 
0085 7942 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 7944 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7946 6042 
0087 7948 1602  14         jne   tfh.file.read.record
0088 794A 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     794C 7AAA 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 794E 05A0  34         inc   @tfh.records          ; Update counter
     7950 242E 
0094 7952 04E0  34         clr   @tfh.reclen           ; Reset record length
     7954 2430 
0095               
0096 7956 06A0  32         bl    @file.record.read     ; Read file record
     7958 6B66 
0097 795A 0A60                   data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
0098                                                   ; | o  tmp0 = Status byte
0099                                                   ; | o  tmp1 = Bytes read
0100                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0101               
0102 795C C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     795E 242A 
0103 7960 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7962 2430 
0104 7964 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7966 242C 
0105                       ;------------------------------------------------------
0106                       ; 1a: Calculate kilobytes processed
0107                       ;------------------------------------------------------
0108 7968 A805  38         a     tmp1,@tfh.counter
     796A 2434 
0109 796C A160  34         a     @tfh.counter,tmp1
     796E 2434 
0110 7970 0285  22         ci    tmp1,1024
     7972 0400 
0111 7974 1106  14         jlt   !
0112 7976 05A0  34         inc   @tfh.kilobytes
     7978 2432 
0113 797A 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     797C FC00 
0114 797E C805  38         mov   tmp1,@tfh.counter
     7980 2434 
0115                       ;------------------------------------------------------
0116                       ; 1b: Load spectra scratchpad layout
0117                       ;------------------------------------------------------
0118 7982 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     7984 695C 
0119 7986 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7988 69F8 
0120 798A 2100                   data scrpad.backup2   ; / >2100->8300
0121                       ;------------------------------------------------------
0122                       ; 1c: Check if a file error occured
0123                       ;------------------------------------------------------
0124               tfh.file.read.check:
0125 798C C1A0  34         mov   @tfh.ioresult,tmp2
     798E 242C 
0126 7990 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7992 6042 
0127 7994 1602  14         jne   !                     ; No, goto (1d)
0128 7996 0460  28         b     @tfh.file.read.error  ; Yes, so handle file error
     7998 7AAA 
0129                       ;------------------------------------------------------
0130                       ; 1d: Decide on copy line from VDP buffer to editor
0131                       ;     buffer (RLE off) or RAM buffer (RLE on)
0132                       ;------------------------------------------------------
0133 799A 8820  54 !       c     @tfh.rleonload,@w$ffff
     799C 2436 
     799E 6048 
0134                                                   ; RLE compression on?
0135 79A0 131C  14         jeq   tfh.file.read.compression
0136                                                   ; Yes, do RLE compression
0137                       ;------------------------------------------------------
0138                       ; Step 2: Process line without doing RLE compression
0139                       ;------------------------------------------------------
0140               tfh.file.read.nocompression:
0141 79A2 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     79A4 0960 
0142 79A6 C160  34         mov   @edb.next_free.ptr,tmp1
     79A8 2308 
0143                                                   ; RAM target in editor buffer
0144               
0145 79AA C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     79AC 8352 
0146               
0147 79AE C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     79B0 2430 
0148 79B2 133F  14         jeq   tfh.file.read.prepindex.emptyline
0149                                                   ; Handle empty line
0150                       ;------------------------------------------------------
0151                       ; 2a: Copy line from VDP to CPU editor buffer
0152                       ;------------------------------------------------------
0153 79B4 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0154 79B6 C205  18         mov   tmp1,tmp4             ; Backup tmp1
0155 79B8 C120  34         mov   @edb.samspage,tmp0    ; Current SAMS page
     79BA 2310 
0156 79BC 06A0  32         bl    @xsams.page           ; Switch to SAMS page
     79BE 63E2 
0157                                                   ; \ . tmp0 = SAMS page
0158                                                   ; / . tmp1 = Memory address
0159 79C0 C148  18         mov   tmp4,tmp1             ; Restore tmp1
0160 79C2 C107  18         mov   tmp3,tmp0             ; Restore tmp0
0161               
0162                                                   ; Save line prefix
0163 79C4 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0164 79C6 06C6  14         swpb  tmp2                  ; |
0165 79C8 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0166 79CA 06C6  14         swpb  tmp2                  ; /
0167               
0168 79CC 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     79CE 2308 
0169 79D0 A806  38         a     tmp2,@edb.next_free.ptr
     79D2 2308 
0170                                                   ; Add line length
0171               
0172 79D4 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     79D6 6364 
0173                                                   ; \ .  tmp0 = VDP source address
0174                                                   ; | .  tmp1 = RAM target address
0175                                                   ; / .  tmp2 = Bytes to copy
0176               
0177 79D8 1028  14         jmp   tfh.file.read.prepindex
0178                                                   ; Prepare for updating index
0179                       ;------------------------------------------------------
0180                       ; Step 3: Process line and do RLE compression
0181                       ;------------------------------------------------------
0182               tfh.file.read.compression:
0183 79DA 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     79DC 0960 
0184 79DE 0205  20         li    tmp1,fb.top           ; RAM target address
     79E0 2650 
0185 79E2 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     79E4 2430 
0186 79E6 1325  14         jeq   tfh.file.read.prepindex.emptyline
0187                                                   ; Handle empty line
0188               
0189 79E8 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     79EA 6364 
0190                                                   ; \ .  tmp0 = VDP source address
0191                                                   ; | .  tmp1 = RAM target address
0192                                                   ; / .  tmp2 = Bytes to copy
0193               
0194                       ;------------------------------------------------------
0195                       ; 3a: RLE compression on line
0196                       ;------------------------------------------------------
0197 79EC 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     79EE 2650 
0198 79F0 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     79F2 26F0 
0199 79F4 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     79F6 2430 
0200               
0201 79F8 06A0  32         bl    @xcpu2rle             ; RLE compression
     79FA 6860 
0202                                                   ; \ .  tmp0  = ROM/RAM source address
0203                                                   ; | .  tmp1  = RAM target address
0204                                                   ; | .  tmp2  = Length uncompressed data
0205                                                   ; / o  waux1 = Length RLE encoded string
0206                       ;------------------------------------------------------
0207                       ; 3b: Set line prefix
0208                       ;------------------------------------------------------
0209 79FC C160  34         mov   @edb.next_free.ptr,tmp1
     79FE 2308 
0210                                                   ; RAM target address
0211 7A00 C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     7A02 8352 
0212 7A04 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7A06 833C 
0213 7A08 06C6  14         swpb  tmp2                  ;
0214 7A0A DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0215               
0216 7A0C C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     7A0E 2430 
0217 7A10 06C6  14         swpb  tmp2
0218 7A12 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0219 7A14 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     7A16 2308 
0220                       ;------------------------------------------------------
0221                       ; 3c: Copy compressed line to editor buffer
0222                       ;------------------------------------------------------
0223 7A18 0204  20         li    tmp0,fb.top+160       ; RAM source address
     7A1A 26F0 
0224 7A1C C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7A1E 833C 
0225               
0226 7A20 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7A22 6386 
0227                                                   ; \ .  tmp0 = RAM source address
0228                                                   ; | .  tmp1 = RAM target address
0229                                                   ; / .  tmp2 = Bytes to copy
0230               
0231 7A24 A820  54         a     @waux1,@edb.next_free.ptr
     7A26 833C 
     7A28 2308 
0232                                                   ; Update pointer to next free line
0233                       ;------------------------------------------------------
0234                       ; Step 4: Update index
0235                       ;------------------------------------------------------
0236               tfh.file.read.prepindex:
0237 7A2A C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7A2C 2304 
     7A2E 8350 
0238                                                   ; parm2 = Must allready be set!
0239 7A30 1007  14         jmp   tfh.file.read.updindex
0240                                                   ; Update index
0241                       ;------------------------------------------------------
0242                       ; 4a: Special handling for empty line
0243                       ;------------------------------------------------------
0244               tfh.file.read.prepindex.emptyline:
0245 7A32 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7A34 242E 
     7A36 8350 
0246 7A38 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7A3A 8350 
0247 7A3C 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7A3E 8352 
0248                       ;------------------------------------------------------
0249                       ; 4b: Do actual index update
0250                       ;------------------------------------------------------
0251               tfh.file.read.updindex:
0252 7A40 04E0  34         clr   @parm3
     7A42 8354 
0253 7A44 06A0  32         bl    @idx.entry.update     ; Update index
     7A46 7680 
0254                                                   ; \ .  parm1    = Line number in editor buffer
0255                                                   ; | .  parm2    = Pointer to line in editor buffer
0256                                                   ; | .  parm3    = SAMS page
0257                                                   ; / o  outparm1 = Pointer to updated index entry
0258               
0259 7A48 05A0  34         inc   @edb.lines            ; lines=lines+1
     7A4A 2304 
0260                       ;------------------------------------------------------
0261                       ; Step 5: Display results
0262                       ;------------------------------------------------------
0263               tfh.file.read.display:
0264 7A4C 06A0  32         bl    @putnum
     7A4E 6850 
0265 7A50 1D49                   byte 29,73            ; Show lines read
0266 7A52 2304                   data edb.lines,rambuf,>3020
     7A54 8390 
     7A56 3020 
0267               
0268 7A58 8220  34         c     @tfh.kilobytes,tmp4
     7A5A 2432 
0269 7A5C 130C  14         jeq   tfh.file.read.checkmem
0270               
0271 7A5E C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7A60 2432 
0272               
0273 7A62 06A0  32         bl    @putnum
     7A64 6850 
0274 7A66 1D38                   byte 29,56            ; Show kilobytes read
0275 7A68 2432                   data tfh.kilobytes,rambuf,>3020
     7A6A 8390 
     7A6C 3020 
0276               
0277 7A6E 06A0  32         bl    @putat
     7A70 6330 
0278 7A72 1D3D                   byte 29,61
0279 7A74 7B40                   data txt_kb           ; Show "kb" string
0280               
0281               ******************************************************
0282               * Stop reading file if high memory expansion gets full
0283               ******************************************************
0284               tfh.file.read.checkmem:
0285 7A76 C120  34         mov   @edb.next_free.ptr,tmp0
     7A78 2308 
0286 7A7A 0284  22         ci    tmp0,>ffa0
     7A7C FFA0 
0287 7A7E 1210  14         jle   tfh.file.read.next
0288               
0289 7A80 0204  20         li    tmp0,8
     7A82 0008 
0290 7A84 C804  38         mov   tmp0,@edb.samspage    ; Next SAMS page
     7A86 2310 
0291 7A88 0204  20         li    tmp0,edb.top
     7A8A B000 
0292 7A8C C804  38         mov   tmp0,@edb.next_free.ptr
     7A8E 2308 
0293 7A90 1007  14         jmp   tfh.file.read.next
0294               
0295 7A92 1015  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0296                       ;------------------------------------------------------
0297                       ; Next SAMS page
0298                       ;------------------------------------------------------
0299 7A94 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7A96 230A 
0300 7A98 0204  20         li    tmp0,edb.top
     7A9A B000 
0301 7A9C C804  38         mov   tmp0,@edb.next_free.ptr
     7A9E 2308 
0302                                                   ; Reset to top of editor buffer
0303                       ;------------------------------------------------------
0304                       ; Next record
0305                       ;------------------------------------------------------
0306               tfh.file.read.next:
0307 7AA0 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7AA2 69D6 
0308 7AA4 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0309               
0310 7AA6 0460  28         b     @tfh.file.read.record
     7AA8 794E 
0311                                                   ; Next record
0312                       ;------------------------------------------------------
0313                       ; Error handler
0314                       ;------------------------------------------------------
0315               tfh.file.read.error:
0316 7AAA C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7AAC 242A 
0317 7AAE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0318 7AB0 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7AB2 0005 
0319 7AB4 1304  14         jeq   tfh.file.read.eof
0320                                                   ; All good. File closed by DSRLNK
0321                       ;------------------------------------------------------
0322                       ; File error occured
0323                       ;------------------------------------------------------
0324 7AB6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7AB8 FFCE 
0325 7ABA 06A0  32         bl    @crash                ; / Crash and halt system
     7ABC 604C 
0326                       ;------------------------------------------------------
0327                       ; End-Of-File reached
0328                       ;------------------------------------------------------
0329               tfh.file.read.eof:
0330 7ABE 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7AC0 69F8 
0331 7AC2 2100                   data scrpad.backup2   ; / >2100->8300
0332                       ;------------------------------------------------------
0333                       ; Display final results
0334                       ;------------------------------------------------------
0335 7AC4 06A0  32         bl    @hchar
     7AC6 65C4 
0336 7AC8 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7ACA 200A 
0337 7ACC FFFF                   data EOL
0338               
0339 7ACE 06A0  32         bl    @putnum
     7AD0 6850 
0340 7AD2 1D38                   byte 29,56            ; Show kilobytes read
0341 7AD4 2432                   data tfh.kilobytes,rambuf,>3020
     7AD6 8390 
     7AD8 3020 
0342               
0343 7ADA 06A0  32         bl    @putat
     7ADC 6330 
0344 7ADE 1D3D                   byte 29,61
0345 7AE0 7B40                   data txt_kb           ; Show "kb" string
0346               
0347 7AE2 06A0  32         bl    @putnum
     7AE4 6850 
0348 7AE6 1D49                   byte 29,73            ; Show lines read
0349 7AE8 242E                   data tfh.records,rambuf,>3020
     7AEA 8390 
     7AEC 3020 
0350               
0351 7AEE 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7AF0 2306 
0352               *--------------------------------------------------------------
0353               * Exit
0354               *--------------------------------------------------------------
0355               tfh.file.read_exit:
0356 7AF2 0460  28         b     @poprt                ; Return to caller
     7AF4 6132 
0357               
0358               
0359               ***************************************************************
0360               * PAB for accessing DV/80 file
0361               ********|*****|*********************|**************************
0362               tfh.file.pab.header:
0363 7AF6 0014             byte  io.op.open            ;  0    - OPEN
0364                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0365 7AF8 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0366 7AFA 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0367                       byte  00                    ;  5    - Character count
0368 7AFC 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0369 7AFE 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0370                       ;------------------------------------------------------
0371                       ; File descriptor part (variable length)
0372                       ;------------------------------------------------------
0373                       ; byte  12                  ;  9    - File descriptor length
0374                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.23569
0629               
0630               
0631               ***************************************************************
0632               *                      Constants
0633               ***************************************************************
0634               romsat:
0635 7B00 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7B02 000F 
0636               
0637               cursors:
0638 7B04 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7B06 0000 
     7B08 0000 
     7B0A 001C 
0639 7B0C 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7B0E 1010 
     7B10 1010 
     7B12 1000 
0640 7B14 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7B16 1C1C 
     7B18 1C1C 
     7B1A 1C00 
0641               
0642               ***************************************************************
0643               *                       Strings
0644               ***************************************************************
0645               txt_delim
0646 7B1C 012C             byte  1
0647 7B1D ....             text  ','
0648                       even
0649               
0650               txt_marker
0651 7B1E 052A             byte  5
0652 7B1F ....             text  '*EOF*'
0653                       even
0654               
0655               txt_bottom
0656 7B24 0520             byte  5
0657 7B25 ....             text  '  BOT'
0658                       even
0659               
0660               txt_ovrwrite
0661 7B2A 034F             byte  3
0662 7B2B ....             text  'OVR'
0663                       even
0664               
0665               txt_insert
0666 7B2E 0349             byte  3
0667 7B2F ....             text  'INS'
0668                       even
0669               
0670               txt_star
0671 7B32 012A             byte  1
0672 7B33 ....             text  '*'
0673                       even
0674               
0675               txt_loading
0676 7B34 0A4C             byte  10
0677 7B35 ....             text  'Loading...'
0678                       even
0679               
0680               txt_kb
0681 7B40 026B             byte  2
0682 7B41 ....             text  'kb'
0683                       even
0684               
0685               txt_rle
0686 7B44 0352             byte  3
0687 7B45 ....             text  'RLE'
0688                       even
0689               
0690               txt_lines
0691 7B48 054C             byte  5
0692 7B49 ....             text  'Lines'
0693                       even
0694               
0695 7B4E 7B4E     end          data    $
0696               
0697               
0698               fdname0
0699 7B50 0D44             byte  13
0700 7B51 ....             text  'DSK1.INVADERS'
0701                       even
0702               
0703               fdname1
0704 7B5E 0F44             byte  15
0705 7B5F ....             text  'DSK1.SPEECHDOCS'
0706                       even
0707               
0708               fdname2
0709 7B6E 0C44             byte  12
0710 7B6F ....             text  'DSK1.XBEADOC'
0711                       even
0712               
0713               fdname3
0714 7B7C 0C44             byte  12
0715 7B7D ....             text  'DSK3.XBEADOC'
0716                       even
0717               
0718               fdname4
0719 7B8A 0C44             byte  12
0720 7B8B ....             text  'DSK3.C99MAN1'
0721                       even
0722               
0723               fdname5
0724 7B98 0C44             byte  12
0725 7B99 ....             text  'DSK3.C99MAN2'
0726                       even
0727               
0728               fdname6
0729 7BA6 0C44             byte  12
0730 7BA7 ....             text  'DSK3.C99MAN3'
0731                       even
0732               
0733               fdname7
0734 7BB4 0D44             byte  13
0735 7BB5 ....             text  'DSK3.C99SPECS'
0736                       even
0737               
0738               fdname8
0739 7BC2 0D44             byte  13
0740 7BC3 ....             text  'DSK3.RANDOM#C'
0741                       even
0742               
0743               fdname9
0744 7BD0 0D44             byte  13
0745 7BD1 ....             text  'DSK1.INVADERS'
0746                       even
0747               
0748               
0749               
0750               ***************************************************************
0751               *                  Sanity check on ROM size
0752               ***************************************************************
0756 7BDE 7BDE              data $   ; ROM size OK.

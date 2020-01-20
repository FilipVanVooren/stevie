XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.2048
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200120-2048
0009               *--------------------------------------------------------------
0010               * TI-99/4a Advanced Editor & IDE
0011               *--------------------------------------------------------------
0012               * TiVi memory layout
0013               *
0014               * Mem range   Bytes    Hex    Purpose
0015               * =========   =====   ====    ==================================
0016               * 2000-20ff     256   >0100   scrpad backup 1: GPL layout
0017               * 2100-21ff     256   >0100   scrpad backup 2: paged out spectra2
0018               * 2200-22ff     256   >0100   TiVi frame buffer structure
0019               * 2300-23ff     256   >0100   TiVi editor buffer structure
0020               * 2400-24ff     256   >0100   TiVi file handling structure
0021               * 2500-25ff     256   >0100   Free for future use
0022               * 2600-264f      80   >0050   Free for future use
0023               * 2650-2faf    2400   >0960   Frame buffer 80x30
0024               * 2fb0-2fff     160   >00a0   Free for future use
0025               * 3000-3fff    4096   >1000   Index for 2048 lines
0026               * 8300-83ff     256   >0100   scrpad spectra2 layout
0027               * a000-fffb   24574   >5ffe   Editor buffer
0028               *--------------------------------------------------------------
0029               * SAMS 4k pages in transparent mode
0030               *
0031               * Low memory expansion
0032               * 2000-2fff 4k  Scratchpad backup / TiVi structures
0033               * 3000-3fff 4k  Index
0034               *
0035               * High memory expansion
0036               * a000-afff 4k  Editor buffer
0037               * b000-bfff 4k  Editor buffer
0038               * c000-cfff 4k  Editor buffer
0039               * d000-dfff 4k  Editor buffer
0040               * e000-efff 4k  Editor buffer
0041               * f000-ffff 4k  Editor buffer
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
0136      230A     edb.next_free.page  equ  edb.top.ptr+10 ; SAMS page of next free line
0137      230C     edb.insmode         equ  edb.top.ptr+12 ; Editor insert mode (>0000 overwrite / >ffff insert)
0138      230E     edb.rle             equ  edb.top.ptr+14 ; RLE compression activated
0139      2310     edb.end             equ  edb.top.ptr+16 ; Free from here on
0140               *--------------------------------------------------------------
0141               * File handling structures          @>2400-24ff     (256 bytes)
0142               *--------------------------------------------------------------
0143      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0144      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0145      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0146      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB, required by level 2 FIO
0147      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0148      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0149      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0150      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0151      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0152      2434     tfh.counter     equ  tfh.top + 52   ; Internal counter used in TiVi file operations
0153      2436     tfh.rleonload   equ  tfh.top + 54   ; RLE compression needed during file load
0154      2438     tfh.membuffer   equ  tfh.top + 56   ; 80 bytes file memory buffer
0155      2488     tfh.end         equ  tfh.top + 136  ; Free from here on
0156      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0157      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0158               *--------------------------------------------------------------
0159               * Free for future use               @>2500-264f     (336 bytes)
0160               *--------------------------------------------------------------
0161      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0162      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0163               *--------------------------------------------------------------
0164               * Frame buffer                      @>2650-2fff    (2480 bytes)
0165               *--------------------------------------------------------------
0166      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0167      09B0     fb.size         equ  2480           ; Frame buffer size
0168               *--------------------------------------------------------------
0169               * Index                             @>3000-3fff    (4096 bytes)
0170               *--------------------------------------------------------------
0171      3000     idx.top         equ  >3000          ; Top of index
0172      1000     idx.size        equ  4096           ; Index size
0173               *--------------------------------------------------------------
0174               * Editor buffer                     @>a000-ffff   (24576 bytes)
0175               *--------------------------------------------------------------
0176      A000     edb.top         equ  >a000          ; Editor buffer high memory
0177      6000     edb.size        equ  24576          ; Editor buffer size
0178               *--------------------------------------------------------------
0179               
0180               
0181               
0182               *--------------------------------------------------------------
0183               * Cartridge header
0184               *--------------------------------------------------------------
0185                       save  >6000,>7fff
0186                       aorg  >6000
0187               
0188 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0189 6006 6010             data  prog0
0190 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0191 6010 0000     prog0   data  0                     ; No more items following
0192 6012 716C             data  runlib
0193               
0195               
0196 6014 1054             byte  16
0197 6015 ....             text  'TIVI 200120-2048'
0198                       even
0199               
0207               *--------------------------------------------------------------
0208               * Include required files
0209               *--------------------------------------------------------------
0210                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0027               *
0028               * == VDP
0029               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0030               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0031               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0032               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0033               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0034               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0035               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0036               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0037               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0038               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0039               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0040               * skip_vdp_sprites          equ  1  ; Skip sprites support
0041               * skip_vdp_cursor           equ  1  ; Skip cursor support
0042               *
0043               * == Sound & speech
0044               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0045               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0046               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0047               *
0048               * ==  Keyboard
0049               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0050               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0051               *
0052               * == Utilities
0053               * skip_random_generator     equ  1  ; Skip random generator functions
0054               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0055               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0056               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0057               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0058               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0059               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0060               *
0061               * == Kernel/Multitasking
0062               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0063               * skip_mem_paging           equ  1  ; Skip support for memory paging
0064               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0065               *
0066               * == Startup behaviour
0067               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0068               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0069               *******************************************************************************
0070               
0071               *//////////////////////////////////////////////////////////////
0072               *                       RUNLIB SETUP
0073               *//////////////////////////////////////////////////////////////
0074               
0075                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
0002               * Purpose...: Equates for spectra2 memory layout
0003               
0004               ***************************************************************
0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0006               ********@*****@*********************@**************************
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
0076                       copy  "equ_registers.asm"        ; Equates for runlib registers
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
0027               ********@*****@*********************@**************************
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
0046               ********@*****@*********************@**************************
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
0059               ********@*****@*********************@**************************
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
0092               ********@*****@*********************@**************************
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
0103               ********@*****@*********************@**************************
0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0108               ***************************************************************
**** **** ****     > runlib.asm
0077                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
0002               * Purpose...: Equates for hardware port addresses
0003               
0004               ***************************************************************
0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0006               ********@*****@*********************@**************************
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
0078                       copy  "equ_param.asm"            ; Equates for runlib parameters
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
0079               
0083               
0084                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Constants and equates used by runlib modules
0003               
0004               
0005               ***************************************************************
0006               *                      Some constants
0007               ********@*****@*********************@**************************
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
0085                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0026               ********@*****@*********************@**************************
0027      6042     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6038     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6034     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6030     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
0032               
**** **** ****     > runlib.asm
0086                       copy  "cpu_crash.asm"            ; CPU crash handler
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
0026               ********@*****@*********************@**************************
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
     609E 7174 
0055               *--------------------------------------------------------------
0056               *    Show diagnostics after system reset
0057               *--------------------------------------------------------------
0058               crash.main:
0059                       ;------------------------------------------------------
0060                       ; Show crashed message
0061                       ;------------------------------------------------------
0062 60A0 06A0  32         bl    @putat                ; Show crash message
     60A2 632C 
0063 60A4 0000                   data >0000,crash.msg.crashed
     60A6 60CC 
0064               
0065 60A8 06A0  32         bl    @puthex               ; Put hex value on screen
     60AA 6716 
0066 60AC 0013                   byte 0,19             ; \ .  p0 = YX position
0067 60AE FFF6                   data >fff6            ; | .  p1 = Pointer to 16 bit word
0068 60B0 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0069 60B2 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0070                                                   ; /         LSB offset for ASCII digit 0-9
0071                       ;------------------------------------------------------
0072                       ; Show caller details
0073                       ;------------------------------------------------------
0074 60B4 06A0  32         bl    @putat                ; Show caller message
     60B6 632C 
0075 60B8 0100                   data >0100,crash.msg.caller
     60BA 60E0 
0076               
0077 60BC 06A0  32         bl    @puthex               ; Put hex value on screen
     60BE 6716 
0078 60C0 0113                   byte 1,19             ; \ .  p0 = YX position
0079 60C2 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0080 60C4 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0081 60C6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0082                                                   ; /         LSB offset for ASCII digit 0-9
0083                       ;------------------------------------------------------
0084                       ; Kernel takes over
0085                       ;------------------------------------------------------
0086 60C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CA 7082 
0087               
0088 60CC 1353     crash.msg.crashed      byte 19
0089 60CD ....                            text 'System crashed at >'
0090               
0091 60E0 1343     crash.msg.caller       byte 19
0092 60E1 ....                            text 'Caller address is >'
**** **** ****     > runlib.asm
0087                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 60F4 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     60F6 000E 
     60F8 0106 
     60FA 0204 
     60FC 0020 
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
0032 60FE 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6100 000E 
     6102 0106 
     6104 00F4 
     6106 0028 
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
0058 6108 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     610A 003F 
     610C 0240 
     610E 03F4 
     6110 0050 
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
0084 6112 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6114 003F 
     6116 0240 
     6118 03F4 
     611A 0050 
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
0088                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 611C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 611E 16FD             data  >16fd                 ; |         jne   mcloop
0015 6120 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6122 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6124 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0037               ********@*****@*********************@**************************
0038 6126 C0F9  30 popr3   mov   *stack+,r3
0039 6128 C0B9  30 popr2   mov   *stack+,r2
0040 612A C079  30 popr1   mov   *stack+,r1
0041 612C C039  30 popr0   mov   *stack+,r0
0042 612E C2F9  30 poprt   mov   *stack+,r11
0043 6130 045B  20         b     *r11
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
0066               ********@*****@*********************@**************************
0067 6132 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6134 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6136 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 6138 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 613A 1604  14         jne   filchk                ; No, continue checking
0075               
0076 613C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     613E FFCE 
0077 6140 06A0  32         bl    @crash                ; / Crash and halt system
     6142 604C 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 6144 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6146 830B 
     6148 830A 
0082               
0083 614A 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     614C 0001 
0084 614E 1602  14         jne   filchk2
0085 6150 DD05  32         movb  tmp1,*tmp0+
0086 6152 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 6154 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6156 0002 
0091 6158 1603  14         jne   filchk3
0092 615A DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 615C DD05  32         movb  tmp1,*tmp0+
0094 615E 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 6160 C1C4  18 filchk3 mov   tmp0,tmp3
0099 6162 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6164 0001 
0100 6166 1605  14         jne   fil16b
0101 6168 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 616A 0606  14         dec   tmp2
0103 616C 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     616E 0002 
0104 6170 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 6172 C1C6  18 fil16b  mov   tmp2,tmp3
0109 6174 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6176 0001 
0110 6178 1301  14         jeq   dofill
0111 617A 0606  14         dec   tmp2                  ; Make TMP2 even
0112 617C CD05  34 dofill  mov   tmp1,*tmp0+
0113 617E 0646  14         dect  tmp2
0114 6180 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 6182 C1C7  18         mov   tmp3,tmp3
0119 6184 1301  14         jeq   fil.$$
0120 6186 DD05  32         movb  tmp1,*tmp0+
0121 6188 045B  20 fil.$$  b     *r11
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
0139               ********@*****@*********************@**************************
0140 618A C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 618C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 618E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6190 0264  22 xfilv   ori   tmp0,>4000
     6192 4000 
0147 6194 06C4  14         swpb  tmp0
0148 6196 D804  38         movb  tmp0,@vdpa
     6198 8C02 
0149 619A 06C4  14         swpb  tmp0
0150 619C D804  38         movb  tmp0,@vdpa
     619E 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 61A0 020F  20         li    r15,vdpw              ; Set VDP write address
     61A2 8C00 
0155 61A4 06C5  14         swpb  tmp1
0156 61A6 C820  54         mov   @filzz,@mcloop        ; Setup move command
     61A8 61B0 
     61AA 8320 
0157 61AC 0460  28         b     @mcloop               ; Write data to VDP
     61AE 8320 
0158               *--------------------------------------------------------------
0162 61B0 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0181               ********@*****@*********************@**************************
0182 61B2 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     61B4 4000 
0183 61B6 06C4  14 vdra    swpb  tmp0
0184 61B8 D804  38         movb  tmp0,@vdpa
     61BA 8C02 
0185 61BC 06C4  14         swpb  tmp0
0186 61BE D804  38         movb  tmp0,@vdpa            ; Set VDP address
     61C0 8C02 
0187 61C2 045B  20         b     *r11                  ; Exit
0188               
0189               ***************************************************************
0190               * VPUTB - VDP put single byte
0191               ***************************************************************
0192               *  BL @VPUTB
0193               *  DATA P0,P1
0194               *--------------------------------------------------------------
0195               *  P0 = VDP target address
0196               *  P1 = Byte to write
0197               ********@*****@*********************@**************************
0198 61C4 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 61C6 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 61C8 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     61CA 4000 
0204 61CC 06C4  14         swpb  tmp0                  ; \
0205 61CE D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     61D0 8C02 
0206 61D2 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 61D4 D804  38         movb  tmp0,@vdpa            ; /
     61D6 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 61D8 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 61DA D7C5  30         movb  tmp1,*r15             ; Write byte
0213 61DC 045B  20         b     *r11                  ; Exit
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
0231               ********@*****@*********************@**************************
0232 61DE C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 61E0 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 61E2 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     61E4 8C02 
0238 61E6 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 61E8 D804  38         movb  tmp0,@vdpa            ; /
     61EA 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 61EC D120  34         movb  @vdpr,tmp0            ; Read byte
     61EE 8800 
0244 61F0 0984  56         srl   tmp0,8                ; Right align
0245 61F2 045B  20         b     *r11                  ; Exit
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
0263               ********@*****@*********************@**************************
0264 61F4 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 61F6 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 61F8 C144  18         mov   tmp0,tmp1
0270 61FA 05C5  14         inct  tmp1
0271 61FC D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 61FE 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6200 FF00 
0273 6202 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 6204 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6206 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 6208 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     620A 8000 
0279 620C 0206  20         li    tmp2,8
     620E 0008 
0280 6210 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6212 830B 
0281 6214 06C5  14         swpb  tmp1
0282 6216 D805  38         movb  tmp1,@vdpa
     6218 8C02 
0283 621A 06C5  14         swpb  tmp1
0284 621C D805  38         movb  tmp1,@vdpa
     621E 8C02 
0285 6220 0225  22         ai    tmp1,>0100
     6222 0100 
0286 6224 0606  14         dec   tmp2
0287 6226 16F4  14         jne   vidta1                ; Next register
0288 6228 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     622A 833A 
0289 622C 045B  20         b     *r11
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
0305               ********@*****@*********************@**************************
0306 622E C13B  30 putvr   mov   *r11+,tmp0
0307 6230 0264  22 putvrx  ori   tmp0,>8000
     6232 8000 
0308 6234 06C4  14         swpb  tmp0
0309 6236 D804  38         movb  tmp0,@vdpa
     6238 8C02 
0310 623A 06C4  14         swpb  tmp0
0311 623C D804  38         movb  tmp0,@vdpa
     623E 8C02 
0312 6240 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********@*****@*********************@**************************
0320 6242 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 6244 C10E  18         mov   r14,tmp0
0322 6246 0984  56         srl   tmp0,8
0323 6248 06A0  32         bl    @putvrx               ; Write VR#0
     624A 6230 
0324 624C 0204  20         li    tmp0,>0100
     624E 0100 
0325 6250 D820  54         movb  @r14lb,@tmp0lb
     6252 831D 
     6254 8309 
0326 6256 06A0  32         bl    @putvrx               ; Write VR#1
     6258 6230 
0327 625A 0458  20         b     *tmp4                 ; Exit
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
0340               ********@*****@*********************@**************************
0341 625C C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 625E 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 6260 C11B  26         mov   *r11,tmp0             ; Get P0
0344 6262 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6264 7FFF 
0345 6266 2120  38         coc   @wbit0,tmp0
     6268 6046 
0346 626A 1604  14         jne   ldfnt1
0347 626C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     626E 8000 
0348 6270 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6272 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 6274 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6276 62DE 
0353 6278 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     627A 9C02 
0354 627C 06C4  14         swpb  tmp0
0355 627E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6280 9C02 
0356 6282 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6284 9800 
0357 6286 06C5  14         swpb  tmp1
0358 6288 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     628A 9800 
0359 628C 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 628E D805  38         movb  tmp1,@grmwa
     6290 9C02 
0364 6292 06C5  14         swpb  tmp1
0365 6294 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6296 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 6298 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 629A 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     629C 61B2 
0371 629E 05C8  14         inct  tmp4                  ; R11=R11+2
0372 62A0 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 62A2 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     62A4 7FFF 
0374 62A6 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     62A8 62E0 
0375 62AA C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     62AC 62E2 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 62AE 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 62B0 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 62B2 D120  34         movb  @grmrd,tmp0
     62B4 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 62B6 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     62B8 6046 
0386 62BA 1603  14         jne   ldfnt3                ; No, so skip
0387 62BC D1C4  18         movb  tmp0,tmp3
0388 62BE 0917  56         srl   tmp3,1
0389 62C0 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 62C2 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     62C4 8C00 
0394 62C6 0606  14         dec   tmp2
0395 62C8 16F2  14         jne   ldfnt2
0396 62CA 05C8  14         inct  tmp4                  ; R11=R11+2
0397 62CC 020F  20         li    r15,vdpw              ; Set VDP write address
     62CE 8C00 
0398 62D0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     62D2 7FFF 
0399 62D4 0458  20         b     *tmp4                 ; Exit
0400 62D6 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     62D8 6026 
     62DA 8C00 
0401 62DC 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 62DE 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     62E0 0200 
     62E2 0000 
0406 62E4 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     62E6 01C0 
     62E8 0101 
0407 62EA 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     62EC 02A0 
     62EE 0101 
0408 62F0 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     62F2 00E0 
     62F4 0101 
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
0425               ********@*****@*********************@**************************
0426 62F6 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 62F8 C3A0  34         mov   @wyx,r14              ; Get YX
     62FA 832A 
0428 62FC 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 62FE 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6300 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 6302 C3A0  34         mov   @wyx,r14              ; Get YX
     6304 832A 
0435 6306 024E  22         andi  r14,>00ff             ; Remove Y
     6308 00FF 
0436 630A A3CE  18         a     r14,r15               ; pos = pos + X
0437 630C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     630E 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6310 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 6312 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6314 020F  20         li    r15,vdpw              ; VDP write address
     6316 8C00 
0444 6318 045B  20         b     *r11
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
0458               ********@*****@*********************@**************************
0459 631A C17B  30 putstr  mov   *r11+,tmp1
0460 631C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 631E C1CB  18 xutstr  mov   r11,tmp3
0462 6320 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6322 62F6 
0463 6324 C2C7  18         mov   tmp3,r11
0464 6326 0986  56         srl   tmp2,8                ; Right justify length byte
0465 6328 0460  28         b     @xpym2v               ; Display string
     632A 633A 
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
0479               ********@*****@*********************@**************************
0480 632C C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     632E 832A 
0481 6330 0460  28         b     @putstr
     6332 631A 
**** **** ****     > runlib.asm
0089               
0091                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0019               ********@*****@*********************@**************************
0020 6334 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6336 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6338 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 633A 0264  22 xpym2v  ori   tmp0,>4000
     633C 4000 
0027 633E 06C4  14         swpb  tmp0
0028 6340 D804  38         movb  tmp0,@vdpa
     6342 8C02 
0029 6344 06C4  14         swpb  tmp0
0030 6346 D804  38         movb  tmp0,@vdpa
     6348 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 634A 020F  20         li    r15,vdpw              ; Set VDP write address
     634C 8C00 
0035 634E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6350 6358 
     6352 8320 
0036 6354 0460  28         b     @mcloop               ; Write data to VDP
     6356 8320 
0037 6358 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0093               
0095                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0019               ********@*****@*********************@**************************
0020 635A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 635C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 635E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6360 06C4  14 xpyv2m  swpb  tmp0
0027 6362 D804  38         movb  tmp0,@vdpa
     6364 8C02 
0028 6366 06C4  14         swpb  tmp0
0029 6368 D804  38         movb  tmp0,@vdpa
     636A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 636C 020F  20         li    r15,vdpr              ; Set VDP read address
     636E 8800 
0034 6370 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6372 637A 
     6374 8320 
0035 6376 0460  28         b     @mcloop               ; Read data from VDP
     6378 8320 
0036 637A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0097               
0099                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0023               ********@*****@*********************@**************************
0024 637C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 637E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6380 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6382 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6384 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6386 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6388 FFCE 
0034 638A 06A0  32         bl    @crash                ; / Crash and halt system
     638C 604C 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 638E 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6390 0001 
0039 6392 1603  14         jne   cpym0                 ; No, continue checking
0040 6394 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6396 04C6  14         clr   tmp2                  ; Reset counter
0042 6398 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 639A 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     639C 7FFF 
0047 639E C1C4  18         mov   tmp0,tmp3
0048 63A0 0247  22         andi  tmp3,1
     63A2 0001 
0049 63A4 1618  14         jne   cpyodd                ; Odd source address handling
0050 63A6 C1C5  18 cpym1   mov   tmp1,tmp3
0051 63A8 0247  22         andi  tmp3,1
     63AA 0001 
0052 63AC 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 63AE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     63B0 6046 
0057 63B2 1605  14         jne   cpym3
0058 63B4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     63B6 63DC 
     63B8 8320 
0059 63BA 0460  28         b     @mcloop               ; Copy memory and exit
     63BC 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 63BE C1C6  18 cpym3   mov   tmp2,tmp3
0064 63C0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     63C2 0001 
0065 63C4 1301  14         jeq   cpym4
0066 63C6 0606  14         dec   tmp2                  ; Make TMP2 even
0067 63C8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 63CA 0646  14         dect  tmp2
0069 63CC 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 63CE C1C7  18         mov   tmp3,tmp3
0074 63D0 1301  14         jeq   cpymz
0075 63D2 D554  38         movb  *tmp0,*tmp1
0076 63D4 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 63D6 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     63D8 8000 
0081 63DA 10E9  14         jmp   cpym2
0082 63DC DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0101               
0105               
0109               
0111                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 63DE 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     63E0 FFBF 
0010 63E2 0460  28         b     @putv01
     63E4 6242 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 63E6 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     63E8 0040 
0018 63EA 0460  28         b     @putv01
     63EC 6242 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 63EE 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     63F0 FFDF 
0026 63F2 0460  28         b     @putv01
     63F4 6242 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 63F6 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     63F8 0020 
0034 63FA 0460  28         b     @putv01
     63FC 6242 
**** **** ****     > runlib.asm
0113               
0115                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********@*****@*********************@**************************
0010 63FE 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6400 FFFE 
0011 6402 0460  28         b     @putv01
     6404 6242 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 6406 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6408 0001 
0019 640A 0460  28         b     @putv01
     640C 6242 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 640E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6410 FFFD 
0027 6412 0460  28         b     @putv01
     6414 6242 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 6416 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6418 0002 
0035 641A 0460  28         b     @putv01
     641C 6242 
**** **** ****     > runlib.asm
0117               
0119                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0017               ********@*****@*********************@**************************
0018 641E C83B  50 at      mov   *r11+,@wyx
     6420 832A 
0019 6422 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6424 B820  54 down    ab    @hb$01,@wyx
     6426 6038 
     6428 832A 
0028 642A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 642C 7820  54 up      sb    @hb$01,@wyx
     642E 6038 
     6430 832A 
0037 6432 045B  20         b     *r11
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
0048               ********@*****@*********************@**************************
0049 6434 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6436 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6438 832A 
0051 643A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     643C 832A 
0052 643E 045B  20         b     *r11
**** **** ****     > runlib.asm
0121               
0123                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0020               ********@*****@*********************@**************************
0021 6440 C120  34 yx2px   mov   @wyx,tmp0
     6442 832A 
0022 6444 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6446 06C4  14         swpb  tmp0                  ; Y<->X
0024 6448 04C5  14         clr   tmp1                  ; Clear before copy
0025 644A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 644C 20A0  38         coc   @wbit1,config         ; f18a present ?
     644E 6044 
0030 6450 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6452 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6454 833A 
     6456 6480 
0032 6458 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 645A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 645C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 645E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6460 0500 
0037 6462 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6464 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6466 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6468 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 646A D105  18         movb  tmp1,tmp0
0051 646C 06C4  14         swpb  tmp0                  ; X<->Y
0052 646E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6470 6046 
0053 6472 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6474 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     6476 6038 
0059 6478 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     647A 604A 
0060 647C 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 647E 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6480 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0125               
0129               
0133               
0135                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0012               ********@*****@*********************@**************************
0013 6482 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6484 06A0  32         bl    @putvr                ; Write once
     6486 622E 
0015 6488 391C             data  >391c                 ; VR1/57, value 00011100
0016 648A 06A0  32         bl    @putvr                ; Write twice
     648C 622E 
0017 648E 391C             data  >391c                 ; VR1/57, value 00011100
0018 6490 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 6492 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6494 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6496 622E 
0028 6498 391C             data  >391c
0029 649A 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********@*****@*********************@**************************
0040 649C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 649E 06A0  32         bl    @cpym2v
     64A0 6334 
0042 64A2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     64A4 64E0 
     64A6 0006 
0043 64A8 06A0  32         bl    @putvr
     64AA 622E 
0044 64AC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 64AE 06A0  32         bl    @putvr
     64B0 622E 
0046 64B2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 64B4 0204  20         li    tmp0,>3f00
     64B6 3F00 
0052 64B8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     64BA 61B6 
0053 64BC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     64BE 8800 
0054 64C0 0984  56         srl   tmp0,8
0055 64C2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     64C4 8800 
0056 64C6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 64C8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 64CA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     64CC BFFF 
0060 64CE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 64D0 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     64D2 4000 
0063               f18chk_exit:
0064 64D4 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     64D6 618A 
0065 64D8 3F00             data  >3f00,>00,6
     64DA 0000 
     64DC 0006 
0066 64DE 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 64E0 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 64E2 3F00             data  >3f00                 ; 3f02 / 3f00
0073 64E4 0340             data  >0340                 ; 3f04   0340  idle
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
0091               ********@*****@*********************@**************************
0092 64E6 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 64E8 06A0  32         bl    @putvr
     64EA 622E 
0097 64EC 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 64EE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     64F0 622E 
0100 64F2 391C             data  >391c                 ; Lock the F18a
0101 64F4 0458  20         b     *tmp4                 ; Exit
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
0119               ********@*****@*********************@**************************
0120 64F6 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 64F8 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     64FA 6044 
0122 64FC 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 64FE C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6500 8802 
0127 6502 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6504 622E 
0128 6506 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6508 04C4  14         clr   tmp0
0130 650A D120  34         movb  @vdps,tmp0
     650C 8802 
0131 650E 0984  56         srl   tmp0,8
0132 6510 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0137               
0139                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0016               ********@*****@*********************@**************************
0017 6512 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6514 832A 
0018 6516 D17B  28         movb  *r11+,tmp1
0019 6518 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 651A D1BB  28         movb  *r11+,tmp2
0021 651C 0986  56         srl   tmp2,8                ; Repeat count
0022 651E C1CB  18         mov   r11,tmp3
0023 6520 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6522 62F6 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6524 020B  20         li    r11,hchar1
     6526 652C 
0028 6528 0460  28         b     @xfilv                ; Draw
     652A 6190 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 652C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     652E 6048 
0033 6530 1302  14         jeq   hchar2                ; Yes, exit
0034 6532 C2C7  18         mov   tmp3,r11
0035 6534 10EE  14         jmp   hchar                 ; Next one
0036 6536 05C7  14 hchar2  inct  tmp3
0037 6538 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0141               
0145               
0149               
0153               
0157               
0161               
0165               
0169               
0171                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0015               ********@*****@*********************@**************************
0016 653A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     653C 6046 
0017 653E 020C  20         li    r12,>0024
     6540 0024 
0018 6542 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6544 65D2 
0019 6546 04C6  14         clr   tmp2
0020 6548 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 654A 04CC  14         clr   r12
0025 654C 1F08  20         tb    >0008                 ; Shift-key ?
0026 654E 1302  14         jeq   realk1                ; No
0027 6550 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6552 6602 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6554 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6556 1302  14         jeq   realk2                ; No
0033 6558 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     655A 6632 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 655C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 655E 1302  14         jeq   realk3                ; No
0039 6560 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6562 6662 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6564 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6566 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6568 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 656A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     656C 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 656E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6570 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6572 0006 
0052 6574 0606  14 realk5  dec   tmp2
0053 6576 020C  20         li    r12,>24               ; CRU address for P2-P4
     6578 0024 
0054 657A 06C6  14         swpb  tmp2
0055 657C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 657E 06C6  14         swpb  tmp2
0057 6580 020C  20         li    r12,6                 ; CRU read address
     6582 0006 
0058 6584 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6586 0547  14         inv   tmp3                  ;
0060 6588 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     658A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 658C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 658E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6590 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6592 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6594 0285  22         ci    tmp1,8
     6596 0008 
0069 6598 1AFA  14         jl    realk6
0070 659A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 659C 1BEB  14         jh    realk5                ; No, next column
0072 659E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 65A0 C206  18 realk8  mov   tmp2,tmp4
0077 65A2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 65A4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 65A6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 65A8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 65AA 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 65AC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 65AE 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     65B0 6046 
0087 65B2 1608  14         jne   realka                ; No, continue saving key
0088 65B4 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     65B6 65FC 
0089 65B8 1A05  14         jl    realka
0090 65BA 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     65BC 65FA 
0091 65BE 1B02  14         jh    realka                ; No, continue
0092 65C0 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     65C2 E000 
0093 65C4 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     65C6 833C 
0094 65C8 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     65CA 6030 
0095 65CC 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     65CE 8C00 
0096 65D0 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 65D2 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     65D4 0000 
     65D6 FF0D 
     65D8 203D 
0099 65DA ....             text  'xws29ol.'
0100 65E2 ....             text  'ced38ik,'
0101 65EA ....             text  'vrf47ujm'
0102 65F2 ....             text  'btg56yhn'
0103 65FA ....             text  'zqa10p;/'
0104 6602 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6604 0000 
     6606 FF0D 
     6608 202B 
0105 660A ....             text  'XWS@(OL>'
0106 6612 ....             text  'CED#*IK<'
0107 661A ....             text  'VRF$&UJM'
0108 6622 ....             text  'BTG%^YHN'
0109 662A ....             text  'ZQA!)P:-'
0110 6632 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6634 0000 
     6636 FF0D 
     6638 2005 
0111 663A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     663C 0804 
     663E 0F27 
     6640 C2B9 
0112 6642 600B             data  >600b,>0907,>063f,>c1B8
     6644 0907 
     6646 063F 
     6648 C1B8 
0113 664A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     664C 7B02 
     664E 015F 
     6650 C0C3 
0114 6652 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6654 7D0E 
     6656 0CC6 
     6658 BFC4 
0115 665A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     665C 7C03 
     665E BC22 
     6660 BDBA 
0116 6662 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6664 0000 
     6666 FF0D 
     6668 209D 
0117 666A 9897             data  >9897,>93b2,>9f8f,>8c9B
     666C 93B2 
     666E 9F8F 
     6670 8C9B 
0118 6672 8385             data  >8385,>84b3,>9e89,>8b80
     6674 84B3 
     6676 9E89 
     6678 8B80 
0119 667A 9692             data  >9692,>86b4,>b795,>8a8D
     667C 86B4 
     667E B795 
     6680 8A8D 
0120 6682 8294             data  >8294,>87b5,>b698,>888E
     6684 87B5 
     6686 B698 
     6688 888E 
0121 668A 9A91             data  >9a91,>81b1,>b090,>9cBB
     668C 81B1 
     668E B090 
     6690 9CBB 
**** **** ****     > runlib.asm
0173               
0175                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0022               ********@*****@*********************@**************************
0023 6692 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6694 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6696 8340 
0025 6698 04E0  34         clr   @waux1
     669A 833C 
0026 669C 04E0  34         clr   @waux2
     669E 833E 
0027 66A0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     66A2 833C 
0028 66A4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 66A6 0205  20         li    tmp1,4                ; 4 nibbles
     66A8 0004 
0033 66AA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 66AC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     66AE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 66B0 0286  22         ci    tmp2,>000a
     66B2 000A 
0039 66B4 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 66B6 C21B  26         mov   *r11,tmp4
0045 66B8 0988  56         srl   tmp4,8                ; Right justify
0046 66BA 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     66BC FFF6 
0047 66BE 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 66C0 C21B  26         mov   *r11,tmp4
0054 66C2 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     66C4 00FF 
0055               
0056 66C6 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 66C8 06C6  14         swpb  tmp2
0058 66CA DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 66CC 0944  56         srl   tmp0,4                ; Next nibble
0060 66CE 0605  14         dec   tmp1
0061 66D0 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 66D2 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     66D4 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 66D6 C160  34         mov   @waux3,tmp1           ; Get pointer
     66D8 8340 
0067 66DA 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 66DC 0585  14         inc   tmp1                  ; Next byte, not word!
0069 66DE C120  34         mov   @waux2,tmp0
     66E0 833E 
0070 66E2 06C4  14         swpb  tmp0
0071 66E4 DD44  32         movb  tmp0,*tmp1+
0072 66E6 06C4  14         swpb  tmp0
0073 66E8 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 66EA C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     66EC 8340 
0078 66EE D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     66F0 603C 
0079 66F2 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 66F4 C120  34         mov   @waux1,tmp0
     66F6 833C 
0084 66F8 06C4  14         swpb  tmp0
0085 66FA DD44  32         movb  tmp0,*tmp1+
0086 66FC 06C4  14         swpb  tmp0
0087 66FE DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6700 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6702 6046 
0092 6704 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6706 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6708 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     670A 7FFF 
0098 670C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     670E 8340 
0099 6710 0460  28         b     @xutst0               ; Display string
     6712 631C 
0100 6714 0610     prefix  data  >0610                 ; Length byte + blank
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
0120               ********@*****@*********************@**************************
0121 6716 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6718 832A 
0122 671A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     671C 8000 
0123 671E 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0177               
0179                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0018               ********@*****@*********************@**************************
0019 6720 0207  20 mknum   li    tmp3,5                ; Digit counter
     6722 0005 
0020 6724 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6726 C155  26         mov   *tmp1,tmp1            ; /
0022 6728 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 672A 0228  22         ai    tmp4,4                ; Get end of buffer
     672C 0004 
0024 672E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6730 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6732 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6734 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6736 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6738 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 673A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 673C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 673E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6740 0607  14         dec   tmp3                  ; Decrease counter
0036 6742 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6744 0207  20         li    tmp3,4                ; Check first 4 digits
     6746 0004 
0041 6748 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 674A C11B  26         mov   *r11,tmp0
0043 674C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 674E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6750 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6752 05CB  14 mknum3  inct  r11
0047 6754 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6756 6046 
0048 6758 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 675A 045B  20         b     *r11                  ; Exit
0050 675C DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 675E 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6760 13F8  14         jeq   mknum3                ; Yes, exit
0053 6762 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6764 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6766 7FFF 
0058 6768 C10B  18         mov   r11,tmp0
0059 676A 0224  22         ai    tmp0,-4
     676C FFFC 
0060 676E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6770 0206  20         li    tmp2,>0500            ; String length = 5
     6772 0500 
0062 6774 0460  28         b     @xutstr               ; Display string
     6776 631E 
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
0090               ********@*****@*********************@**************************
0091               trimnum:
0092 6778 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 677A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 677C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 677E 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6780 0207  20         li    tmp3,5                ; Set counter
     6782 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6784 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6786 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6788 0584  14         inc   tmp0                  ; Next character
0104 678A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 678C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 678E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6790 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6792 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6794 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6796 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6798 0607  14         dec   tmp3                  ; Last character ?
0120 679A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 679C 045B  20         b     *r11                  ; Return
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
0137               ********@*****@*********************@**************************
0138 679E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     67A0 832A 
0139 67A2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     67A4 8000 
0140 67A6 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0181               
0185               
0187                       copy  "cpu_rle_compress.asm"     ; CPU RLE compression support
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
0072               ********@*****@*********************@**************************
0073               cpu2rle:
0074 67A8 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 67AA C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 67AC C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 67AE 0649  14         dect  stack
0079 67B0 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 67B2 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 67B4 04C8  14         clr   tmp4                  ; Repeat counter
0086 67B6 04E0  34         clr   @waux1                ; Length of RLE string
     67B8 833C 
0087 67BA 04E0  34         clr   @waux2                ; Address of encoding byte
     67BC 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 67BE 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 67C0 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 67C2 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 67C4 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 67C6 C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 67C8 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 67CA 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     67CC 0001 
0105 67CE 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 67D0 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 67D2 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 67D4 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 67D6 06A0  32         bl    @cpu2rle.flush.duplicates
     67D8 6822 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 67DA C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     67DC 833E 
     67DE 833E 
0126 67E0 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 67E2 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     67E4 833E 
0129 67E6 0585  14         inc   tmp1                  ; Skip encoding byte
0130 67E8 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     67EA 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 67EC DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 67EE 05A0  34         inc   @waux1                ; RLE string length += 1
     67F0 833C 
0136 67F2 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 67F4 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     67F6 833E 
     67F8 833E 
0145 67FA 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 67FC 06A0  32         bl    @cpu2rle.flush.encoding_byte
     67FE 683C 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 6800 0588  14         inc   tmp4                  ; Increase repeat counter
0155 6802 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 6804 0606  14         dec   tmp2
0162 6806 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 6808 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 680A 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 680C 06A0  32         bl    @cpu2rle.flush.duplicates
     680E 6822 
0175                                                   ; (3.2) Flush pending ...
0176 6810 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 6812 C820  54         mov   @waux2,@waux2
     6814 833E 
     6816 833E 
0182 6818 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 681A 06A0  32         bl    @cpu2rle.flush.encoding_byte
     681C 683C 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 681E 0460  28         b     @poprt                ; Return
     6820 612E 
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
0204 6822 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 6824 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 6826 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 6828 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     682A 8000 
0210 682C DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 682E 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6830 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 6832 05E0  34         inct  @waux1                ; RLE string length += 2
     6834 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 6836 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 6838 04C8  14         clr   tmp4                  ; Clear repeat count
0220 683A 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 683C 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 683E C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6840 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 6842 61E0  34         s     @waux2,tmp3           ; | characters
     6844 833E 
0232 6846 0607  14         dec   tmp3                  ; /
0233               
0234 6848 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 684A C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     684C 833E 
0236 684E D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6850 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6852 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6854 833E 
0240 6856 04C8  14         clr   tmp4                  ; Clear before exit
0241 6858 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0189               
0191                       copy  "cpu_rle_decompress.asm"   ; CPU RLE decompression support
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
0029               ********@*****@*********************@**************************
0030               rle2cpu:
0031 685A C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 685C C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 685E C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6860 0649  14         dect  stack
0036 6862 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6864 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 6866 0606  14         dec   tmp2                  ; Update length
0043 6868 131E  14         jeq   rle2cpu.exit          ; End of list
0044 686A 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 686C 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 686E 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6870 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 6872 0649  14         dect  stack
0055 6874 C646  30         mov   tmp2,*stack           ; Push tmp2
0056 6876 C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 6878 06A0  32         bl    @xpym2m               ; Block copy to destination
     687A 6382 
0059                                                   ; \ .  tmp0 = Source address
0060                                                   ; | .  tmp1 = Target address
0061                                                   ; / .  tmp2 = Bytes to copy
0062               
0063 687C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 687E 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6880 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 6882 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 6884 0649  14         dect  stack
0073 6886 C645  30         mov   tmp1,*stack           ; Push tmp1
0074 6888 0649  14         dect  stack
0075 688A C646  30         mov   tmp2,*stack           ; Push tmp2
0076 688C 0649  14         dect  stack
0077 688E C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6890 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 6892 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 6894 0985  56         srl   tmp1,8                ; Right align
0082               
0083 6896 06A0  32         bl    @xfilm                ; Block fill to destination
     6898 6138 
0084                                                   ; \ .  tmp0 = Target address
0085                                                   ; | .  tmp1 = Byte to fill
0086                                                   ; / .  tmp2 = Repeat count
0087               
0088 689A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 689C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 689E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 68A0 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 68A2 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 68A4 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 68A6 0460  28         b     @poprt                ; Return
     68A8 612E 
**** **** ****     > runlib.asm
0193               
0197               
0201               
0203                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > mem_scrpad_backrest.asm
0001               * FILE......: mem_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.scrpad.backup - Backup scratchpad memory to >2000
0010               ***************************************************************
0011               *  bl   @mem.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  None
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to the memory area >2000 - >20FF
0017               *  without using any registers.
0018               ********@*****@*********************@**************************
0019               mem.scrpad.backup:
0020               ********@*****@*********************@**************************
0021 68AA C820  54         mov   @>8300,@>2000
     68AC 8300 
     68AE 2000 
0022 68B0 C820  54         mov   @>8302,@>2002
     68B2 8302 
     68B4 2002 
0023 68B6 C820  54         mov   @>8304,@>2004
     68B8 8304 
     68BA 2004 
0024 68BC C820  54         mov   @>8306,@>2006
     68BE 8306 
     68C0 2006 
0025 68C2 C820  54         mov   @>8308,@>2008
     68C4 8308 
     68C6 2008 
0026 68C8 C820  54         mov   @>830A,@>200A
     68CA 830A 
     68CC 200A 
0027 68CE C820  54         mov   @>830C,@>200C
     68D0 830C 
     68D2 200C 
0028 68D4 C820  54         mov   @>830E,@>200E
     68D6 830E 
     68D8 200E 
0029 68DA C820  54         mov   @>8310,@>2010
     68DC 8310 
     68DE 2010 
0030 68E0 C820  54         mov   @>8312,@>2012
     68E2 8312 
     68E4 2012 
0031 68E6 C820  54         mov   @>8314,@>2014
     68E8 8314 
     68EA 2014 
0032 68EC C820  54         mov   @>8316,@>2016
     68EE 8316 
     68F0 2016 
0033 68F2 C820  54         mov   @>8318,@>2018
     68F4 8318 
     68F6 2018 
0034 68F8 C820  54         mov   @>831A,@>201A
     68FA 831A 
     68FC 201A 
0035 68FE C820  54         mov   @>831C,@>201C
     6900 831C 
     6902 201C 
0036 6904 C820  54         mov   @>831E,@>201E
     6906 831E 
     6908 201E 
0037 690A C820  54         mov   @>8320,@>2020
     690C 8320 
     690E 2020 
0038 6910 C820  54         mov   @>8322,@>2022
     6912 8322 
     6914 2022 
0039 6916 C820  54         mov   @>8324,@>2024
     6918 8324 
     691A 2024 
0040 691C C820  54         mov   @>8326,@>2026
     691E 8326 
     6920 2026 
0041 6922 C820  54         mov   @>8328,@>2028
     6924 8328 
     6926 2028 
0042 6928 C820  54         mov   @>832A,@>202A
     692A 832A 
     692C 202A 
0043 692E C820  54         mov   @>832C,@>202C
     6930 832C 
     6932 202C 
0044 6934 C820  54         mov   @>832E,@>202E
     6936 832E 
     6938 202E 
0045 693A C820  54         mov   @>8330,@>2030
     693C 8330 
     693E 2030 
0046 6940 C820  54         mov   @>8332,@>2032
     6942 8332 
     6944 2032 
0047 6946 C820  54         mov   @>8334,@>2034
     6948 8334 
     694A 2034 
0048 694C C820  54         mov   @>8336,@>2036
     694E 8336 
     6950 2036 
0049 6952 C820  54         mov   @>8338,@>2038
     6954 8338 
     6956 2038 
0050 6958 C820  54         mov   @>833A,@>203A
     695A 833A 
     695C 203A 
0051 695E C820  54         mov   @>833C,@>203C
     6960 833C 
     6962 203C 
0052 6964 C820  54         mov   @>833E,@>203E
     6966 833E 
     6968 203E 
0053 696A C820  54         mov   @>8340,@>2040
     696C 8340 
     696E 2040 
0054 6970 C820  54         mov   @>8342,@>2042
     6972 8342 
     6974 2042 
0055 6976 C820  54         mov   @>8344,@>2044
     6978 8344 
     697A 2044 
0056 697C C820  54         mov   @>8346,@>2046
     697E 8346 
     6980 2046 
0057 6982 C820  54         mov   @>8348,@>2048
     6984 8348 
     6986 2048 
0058 6988 C820  54         mov   @>834A,@>204A
     698A 834A 
     698C 204A 
0059 698E C820  54         mov   @>834C,@>204C
     6990 834C 
     6992 204C 
0060 6994 C820  54         mov   @>834E,@>204E
     6996 834E 
     6998 204E 
0061 699A C820  54         mov   @>8350,@>2050
     699C 8350 
     699E 2050 
0062 69A0 C820  54         mov   @>8352,@>2052
     69A2 8352 
     69A4 2052 
0063 69A6 C820  54         mov   @>8354,@>2054
     69A8 8354 
     69AA 2054 
0064 69AC C820  54         mov   @>8356,@>2056
     69AE 8356 
     69B0 2056 
0065 69B2 C820  54         mov   @>8358,@>2058
     69B4 8358 
     69B6 2058 
0066 69B8 C820  54         mov   @>835A,@>205A
     69BA 835A 
     69BC 205A 
0067 69BE C820  54         mov   @>835C,@>205C
     69C0 835C 
     69C2 205C 
0068 69C4 C820  54         mov   @>835E,@>205E
     69C6 835E 
     69C8 205E 
0069 69CA C820  54         mov   @>8360,@>2060
     69CC 8360 
     69CE 2060 
0070 69D0 C820  54         mov   @>8362,@>2062
     69D2 8362 
     69D4 2062 
0071 69D6 C820  54         mov   @>8364,@>2064
     69D8 8364 
     69DA 2064 
0072 69DC C820  54         mov   @>8366,@>2066
     69DE 8366 
     69E0 2066 
0073 69E2 C820  54         mov   @>8368,@>2068
     69E4 8368 
     69E6 2068 
0074 69E8 C820  54         mov   @>836A,@>206A
     69EA 836A 
     69EC 206A 
0075 69EE C820  54         mov   @>836C,@>206C
     69F0 836C 
     69F2 206C 
0076 69F4 C820  54         mov   @>836E,@>206E
     69F6 836E 
     69F8 206E 
0077 69FA C820  54         mov   @>8370,@>2070
     69FC 8370 
     69FE 2070 
0078 6A00 C820  54         mov   @>8372,@>2072
     6A02 8372 
     6A04 2072 
0079 6A06 C820  54         mov   @>8374,@>2074
     6A08 8374 
     6A0A 2074 
0080 6A0C C820  54         mov   @>8376,@>2076
     6A0E 8376 
     6A10 2076 
0081 6A12 C820  54         mov   @>8378,@>2078
     6A14 8378 
     6A16 2078 
0082 6A18 C820  54         mov   @>837A,@>207A
     6A1A 837A 
     6A1C 207A 
0083 6A1E C820  54         mov   @>837C,@>207C
     6A20 837C 
     6A22 207C 
0084 6A24 C820  54         mov   @>837E,@>207E
     6A26 837E 
     6A28 207E 
0085 6A2A C820  54         mov   @>8380,@>2080
     6A2C 8380 
     6A2E 2080 
0086 6A30 C820  54         mov   @>8382,@>2082
     6A32 8382 
     6A34 2082 
0087 6A36 C820  54         mov   @>8384,@>2084
     6A38 8384 
     6A3A 2084 
0088 6A3C C820  54         mov   @>8386,@>2086
     6A3E 8386 
     6A40 2086 
0089 6A42 C820  54         mov   @>8388,@>2088
     6A44 8388 
     6A46 2088 
0090 6A48 C820  54         mov   @>838A,@>208A
     6A4A 838A 
     6A4C 208A 
0091 6A4E C820  54         mov   @>838C,@>208C
     6A50 838C 
     6A52 208C 
0092 6A54 C820  54         mov   @>838E,@>208E
     6A56 838E 
     6A58 208E 
0093 6A5A C820  54         mov   @>8390,@>2090
     6A5C 8390 
     6A5E 2090 
0094 6A60 C820  54         mov   @>8392,@>2092
     6A62 8392 
     6A64 2092 
0095 6A66 C820  54         mov   @>8394,@>2094
     6A68 8394 
     6A6A 2094 
0096 6A6C C820  54         mov   @>8396,@>2096
     6A6E 8396 
     6A70 2096 
0097 6A72 C820  54         mov   @>8398,@>2098
     6A74 8398 
     6A76 2098 
0098 6A78 C820  54         mov   @>839A,@>209A
     6A7A 839A 
     6A7C 209A 
0099 6A7E C820  54         mov   @>839C,@>209C
     6A80 839C 
     6A82 209C 
0100 6A84 C820  54         mov   @>839E,@>209E
     6A86 839E 
     6A88 209E 
0101 6A8A C820  54         mov   @>83A0,@>20A0
     6A8C 83A0 
     6A8E 20A0 
0102 6A90 C820  54         mov   @>83A2,@>20A2
     6A92 83A2 
     6A94 20A2 
0103 6A96 C820  54         mov   @>83A4,@>20A4
     6A98 83A4 
     6A9A 20A4 
0104 6A9C C820  54         mov   @>83A6,@>20A6
     6A9E 83A6 
     6AA0 20A6 
0105 6AA2 C820  54         mov   @>83A8,@>20A8
     6AA4 83A8 
     6AA6 20A8 
0106 6AA8 C820  54         mov   @>83AA,@>20AA
     6AAA 83AA 
     6AAC 20AA 
0107 6AAE C820  54         mov   @>83AC,@>20AC
     6AB0 83AC 
     6AB2 20AC 
0108 6AB4 C820  54         mov   @>83AE,@>20AE
     6AB6 83AE 
     6AB8 20AE 
0109 6ABA C820  54         mov   @>83B0,@>20B0
     6ABC 83B0 
     6ABE 20B0 
0110 6AC0 C820  54         mov   @>83B2,@>20B2
     6AC2 83B2 
     6AC4 20B2 
0111 6AC6 C820  54         mov   @>83B4,@>20B4
     6AC8 83B4 
     6ACA 20B4 
0112 6ACC C820  54         mov   @>83B6,@>20B6
     6ACE 83B6 
     6AD0 20B6 
0113 6AD2 C820  54         mov   @>83B8,@>20B8
     6AD4 83B8 
     6AD6 20B8 
0114 6AD8 C820  54         mov   @>83BA,@>20BA
     6ADA 83BA 
     6ADC 20BA 
0115 6ADE C820  54         mov   @>83BC,@>20BC
     6AE0 83BC 
     6AE2 20BC 
0116 6AE4 C820  54         mov   @>83BE,@>20BE
     6AE6 83BE 
     6AE8 20BE 
0117 6AEA C820  54         mov   @>83C0,@>20C0
     6AEC 83C0 
     6AEE 20C0 
0118 6AF0 C820  54         mov   @>83C2,@>20C2
     6AF2 83C2 
     6AF4 20C2 
0119 6AF6 C820  54         mov   @>83C4,@>20C4
     6AF8 83C4 
     6AFA 20C4 
0120 6AFC C820  54         mov   @>83C6,@>20C6
     6AFE 83C6 
     6B00 20C6 
0121 6B02 C820  54         mov   @>83C8,@>20C8
     6B04 83C8 
     6B06 20C8 
0122 6B08 C820  54         mov   @>83CA,@>20CA
     6B0A 83CA 
     6B0C 20CA 
0123 6B0E C820  54         mov   @>83CC,@>20CC
     6B10 83CC 
     6B12 20CC 
0124 6B14 C820  54         mov   @>83CE,@>20CE
     6B16 83CE 
     6B18 20CE 
0125 6B1A C820  54         mov   @>83D0,@>20D0
     6B1C 83D0 
     6B1E 20D0 
0126 6B20 C820  54         mov   @>83D2,@>20D2
     6B22 83D2 
     6B24 20D2 
0127 6B26 C820  54         mov   @>83D4,@>20D4
     6B28 83D4 
     6B2A 20D4 
0128 6B2C C820  54         mov   @>83D6,@>20D6
     6B2E 83D6 
     6B30 20D6 
0129 6B32 C820  54         mov   @>83D8,@>20D8
     6B34 83D8 
     6B36 20D8 
0130 6B38 C820  54         mov   @>83DA,@>20DA
     6B3A 83DA 
     6B3C 20DA 
0131 6B3E C820  54         mov   @>83DC,@>20DC
     6B40 83DC 
     6B42 20DC 
0132 6B44 C820  54         mov   @>83DE,@>20DE
     6B46 83DE 
     6B48 20DE 
0133 6B4A C820  54         mov   @>83E0,@>20E0
     6B4C 83E0 
     6B4E 20E0 
0134 6B50 C820  54         mov   @>83E2,@>20E2
     6B52 83E2 
     6B54 20E2 
0135 6B56 C820  54         mov   @>83E4,@>20E4
     6B58 83E4 
     6B5A 20E4 
0136 6B5C C820  54         mov   @>83E6,@>20E6
     6B5E 83E6 
     6B60 20E6 
0137 6B62 C820  54         mov   @>83E8,@>20E8
     6B64 83E8 
     6B66 20E8 
0138 6B68 C820  54         mov   @>83EA,@>20EA
     6B6A 83EA 
     6B6C 20EA 
0139 6B6E C820  54         mov   @>83EC,@>20EC
     6B70 83EC 
     6B72 20EC 
0140 6B74 C820  54         mov   @>83EE,@>20EE
     6B76 83EE 
     6B78 20EE 
0141 6B7A C820  54         mov   @>83F0,@>20F0
     6B7C 83F0 
     6B7E 20F0 
0142 6B80 C820  54         mov   @>83F2,@>20F2
     6B82 83F2 
     6B84 20F2 
0143 6B86 C820  54         mov   @>83F4,@>20F4
     6B88 83F4 
     6B8A 20F4 
0144 6B8C C820  54         mov   @>83F6,@>20F6
     6B8E 83F6 
     6B90 20F6 
0145 6B92 C820  54         mov   @>83F8,@>20F8
     6B94 83F8 
     6B96 20F8 
0146 6B98 C820  54         mov   @>83FA,@>20FA
     6B9A 83FA 
     6B9C 20FA 
0147 6B9E C820  54         mov   @>83FC,@>20FC
     6BA0 83FC 
     6BA2 20FC 
0148 6BA4 C820  54         mov   @>83FE,@>20FE
     6BA6 83FE 
     6BA8 20FE 
0149 6BAA 045B  20         b     *r11                  ; Return to caller
0150               
0151               
0152               ***************************************************************
0153               * mem.scrpad.restore - Restore scratchpad memory from >2000
0154               ***************************************************************
0155               *  bl   @mem.scrpad.restore
0156               *--------------------------------------------------------------
0157               *  Register usage
0158               *  None
0159               *--------------------------------------------------------------
0160               *  Restore scratchpad from memory area >2000 - >20FF
0161               *  without using any registers.
0162               ********@*****@*********************@**************************
0163               mem.scrpad.restore:
0164 6BAC C820  54         mov   @>2000,@>8300
     6BAE 2000 
     6BB0 8300 
0165 6BB2 C820  54         mov   @>2002,@>8302
     6BB4 2002 
     6BB6 8302 
0166 6BB8 C820  54         mov   @>2004,@>8304
     6BBA 2004 
     6BBC 8304 
0167 6BBE C820  54         mov   @>2006,@>8306
     6BC0 2006 
     6BC2 8306 
0168 6BC4 C820  54         mov   @>2008,@>8308
     6BC6 2008 
     6BC8 8308 
0169 6BCA C820  54         mov   @>200A,@>830A
     6BCC 200A 
     6BCE 830A 
0170 6BD0 C820  54         mov   @>200C,@>830C
     6BD2 200C 
     6BD4 830C 
0171 6BD6 C820  54         mov   @>200E,@>830E
     6BD8 200E 
     6BDA 830E 
0172 6BDC C820  54         mov   @>2010,@>8310
     6BDE 2010 
     6BE0 8310 
0173 6BE2 C820  54         mov   @>2012,@>8312
     6BE4 2012 
     6BE6 8312 
0174 6BE8 C820  54         mov   @>2014,@>8314
     6BEA 2014 
     6BEC 8314 
0175 6BEE C820  54         mov   @>2016,@>8316
     6BF0 2016 
     6BF2 8316 
0176 6BF4 C820  54         mov   @>2018,@>8318
     6BF6 2018 
     6BF8 8318 
0177 6BFA C820  54         mov   @>201A,@>831A
     6BFC 201A 
     6BFE 831A 
0178 6C00 C820  54         mov   @>201C,@>831C
     6C02 201C 
     6C04 831C 
0179 6C06 C820  54         mov   @>201E,@>831E
     6C08 201E 
     6C0A 831E 
0180 6C0C C820  54         mov   @>2020,@>8320
     6C0E 2020 
     6C10 8320 
0181 6C12 C820  54         mov   @>2022,@>8322
     6C14 2022 
     6C16 8322 
0182 6C18 C820  54         mov   @>2024,@>8324
     6C1A 2024 
     6C1C 8324 
0183 6C1E C820  54         mov   @>2026,@>8326
     6C20 2026 
     6C22 8326 
0184 6C24 C820  54         mov   @>2028,@>8328
     6C26 2028 
     6C28 8328 
0185 6C2A C820  54         mov   @>202A,@>832A
     6C2C 202A 
     6C2E 832A 
0186 6C30 C820  54         mov   @>202C,@>832C
     6C32 202C 
     6C34 832C 
0187 6C36 C820  54         mov   @>202E,@>832E
     6C38 202E 
     6C3A 832E 
0188 6C3C C820  54         mov   @>2030,@>8330
     6C3E 2030 
     6C40 8330 
0189 6C42 C820  54         mov   @>2032,@>8332
     6C44 2032 
     6C46 8332 
0190 6C48 C820  54         mov   @>2034,@>8334
     6C4A 2034 
     6C4C 8334 
0191 6C4E C820  54         mov   @>2036,@>8336
     6C50 2036 
     6C52 8336 
0192 6C54 C820  54         mov   @>2038,@>8338
     6C56 2038 
     6C58 8338 
0193 6C5A C820  54         mov   @>203A,@>833A
     6C5C 203A 
     6C5E 833A 
0194 6C60 C820  54         mov   @>203C,@>833C
     6C62 203C 
     6C64 833C 
0195 6C66 C820  54         mov   @>203E,@>833E
     6C68 203E 
     6C6A 833E 
0196 6C6C C820  54         mov   @>2040,@>8340
     6C6E 2040 
     6C70 8340 
0197 6C72 C820  54         mov   @>2042,@>8342
     6C74 2042 
     6C76 8342 
0198 6C78 C820  54         mov   @>2044,@>8344
     6C7A 2044 
     6C7C 8344 
0199 6C7E C820  54         mov   @>2046,@>8346
     6C80 2046 
     6C82 8346 
0200 6C84 C820  54         mov   @>2048,@>8348
     6C86 2048 
     6C88 8348 
0201 6C8A C820  54         mov   @>204A,@>834A
     6C8C 204A 
     6C8E 834A 
0202 6C90 C820  54         mov   @>204C,@>834C
     6C92 204C 
     6C94 834C 
0203 6C96 C820  54         mov   @>204E,@>834E
     6C98 204E 
     6C9A 834E 
0204 6C9C C820  54         mov   @>2050,@>8350
     6C9E 2050 
     6CA0 8350 
0205 6CA2 C820  54         mov   @>2052,@>8352
     6CA4 2052 
     6CA6 8352 
0206 6CA8 C820  54         mov   @>2054,@>8354
     6CAA 2054 
     6CAC 8354 
0207 6CAE C820  54         mov   @>2056,@>8356
     6CB0 2056 
     6CB2 8356 
0208 6CB4 C820  54         mov   @>2058,@>8358
     6CB6 2058 
     6CB8 8358 
0209 6CBA C820  54         mov   @>205A,@>835A
     6CBC 205A 
     6CBE 835A 
0210 6CC0 C820  54         mov   @>205C,@>835C
     6CC2 205C 
     6CC4 835C 
0211 6CC6 C820  54         mov   @>205E,@>835E
     6CC8 205E 
     6CCA 835E 
0212 6CCC C820  54         mov   @>2060,@>8360
     6CCE 2060 
     6CD0 8360 
0213 6CD2 C820  54         mov   @>2062,@>8362
     6CD4 2062 
     6CD6 8362 
0214 6CD8 C820  54         mov   @>2064,@>8364
     6CDA 2064 
     6CDC 8364 
0215 6CDE C820  54         mov   @>2066,@>8366
     6CE0 2066 
     6CE2 8366 
0216 6CE4 C820  54         mov   @>2068,@>8368
     6CE6 2068 
     6CE8 8368 
0217 6CEA C820  54         mov   @>206A,@>836A
     6CEC 206A 
     6CEE 836A 
0218 6CF0 C820  54         mov   @>206C,@>836C
     6CF2 206C 
     6CF4 836C 
0219 6CF6 C820  54         mov   @>206E,@>836E
     6CF8 206E 
     6CFA 836E 
0220 6CFC C820  54         mov   @>2070,@>8370
     6CFE 2070 
     6D00 8370 
0221 6D02 C820  54         mov   @>2072,@>8372
     6D04 2072 
     6D06 8372 
0222 6D08 C820  54         mov   @>2074,@>8374
     6D0A 2074 
     6D0C 8374 
0223 6D0E C820  54         mov   @>2076,@>8376
     6D10 2076 
     6D12 8376 
0224 6D14 C820  54         mov   @>2078,@>8378
     6D16 2078 
     6D18 8378 
0225 6D1A C820  54         mov   @>207A,@>837A
     6D1C 207A 
     6D1E 837A 
0226 6D20 C820  54         mov   @>207C,@>837C
     6D22 207C 
     6D24 837C 
0227 6D26 C820  54         mov   @>207E,@>837E
     6D28 207E 
     6D2A 837E 
0228 6D2C C820  54         mov   @>2080,@>8380
     6D2E 2080 
     6D30 8380 
0229 6D32 C820  54         mov   @>2082,@>8382
     6D34 2082 
     6D36 8382 
0230 6D38 C820  54         mov   @>2084,@>8384
     6D3A 2084 
     6D3C 8384 
0231 6D3E C820  54         mov   @>2086,@>8386
     6D40 2086 
     6D42 8386 
0232 6D44 C820  54         mov   @>2088,@>8388
     6D46 2088 
     6D48 8388 
0233 6D4A C820  54         mov   @>208A,@>838A
     6D4C 208A 
     6D4E 838A 
0234 6D50 C820  54         mov   @>208C,@>838C
     6D52 208C 
     6D54 838C 
0235 6D56 C820  54         mov   @>208E,@>838E
     6D58 208E 
     6D5A 838E 
0236 6D5C C820  54         mov   @>2090,@>8390
     6D5E 2090 
     6D60 8390 
0237 6D62 C820  54         mov   @>2092,@>8392
     6D64 2092 
     6D66 8392 
0238 6D68 C820  54         mov   @>2094,@>8394
     6D6A 2094 
     6D6C 8394 
0239 6D6E C820  54         mov   @>2096,@>8396
     6D70 2096 
     6D72 8396 
0240 6D74 C820  54         mov   @>2098,@>8398
     6D76 2098 
     6D78 8398 
0241 6D7A C820  54         mov   @>209A,@>839A
     6D7C 209A 
     6D7E 839A 
0242 6D80 C820  54         mov   @>209C,@>839C
     6D82 209C 
     6D84 839C 
0243 6D86 C820  54         mov   @>209E,@>839E
     6D88 209E 
     6D8A 839E 
0244 6D8C C820  54         mov   @>20A0,@>83A0
     6D8E 20A0 
     6D90 83A0 
0245 6D92 C820  54         mov   @>20A2,@>83A2
     6D94 20A2 
     6D96 83A2 
0246 6D98 C820  54         mov   @>20A4,@>83A4
     6D9A 20A4 
     6D9C 83A4 
0247 6D9E C820  54         mov   @>20A6,@>83A6
     6DA0 20A6 
     6DA2 83A6 
0248 6DA4 C820  54         mov   @>20A8,@>83A8
     6DA6 20A8 
     6DA8 83A8 
0249 6DAA C820  54         mov   @>20AA,@>83AA
     6DAC 20AA 
     6DAE 83AA 
0250 6DB0 C820  54         mov   @>20AC,@>83AC
     6DB2 20AC 
     6DB4 83AC 
0251 6DB6 C820  54         mov   @>20AE,@>83AE
     6DB8 20AE 
     6DBA 83AE 
0252 6DBC C820  54         mov   @>20B0,@>83B0
     6DBE 20B0 
     6DC0 83B0 
0253 6DC2 C820  54         mov   @>20B2,@>83B2
     6DC4 20B2 
     6DC6 83B2 
0254 6DC8 C820  54         mov   @>20B4,@>83B4
     6DCA 20B4 
     6DCC 83B4 
0255 6DCE C820  54         mov   @>20B6,@>83B6
     6DD0 20B6 
     6DD2 83B6 
0256 6DD4 C820  54         mov   @>20B8,@>83B8
     6DD6 20B8 
     6DD8 83B8 
0257 6DDA C820  54         mov   @>20BA,@>83BA
     6DDC 20BA 
     6DDE 83BA 
0258 6DE0 C820  54         mov   @>20BC,@>83BC
     6DE2 20BC 
     6DE4 83BC 
0259 6DE6 C820  54         mov   @>20BE,@>83BE
     6DE8 20BE 
     6DEA 83BE 
0260 6DEC C820  54         mov   @>20C0,@>83C0
     6DEE 20C0 
     6DF0 83C0 
0261 6DF2 C820  54         mov   @>20C2,@>83C2
     6DF4 20C2 
     6DF6 83C2 
0262 6DF8 C820  54         mov   @>20C4,@>83C4
     6DFA 20C4 
     6DFC 83C4 
0263 6DFE C820  54         mov   @>20C6,@>83C6
     6E00 20C6 
     6E02 83C6 
0264 6E04 C820  54         mov   @>20C8,@>83C8
     6E06 20C8 
     6E08 83C8 
0265 6E0A C820  54         mov   @>20CA,@>83CA
     6E0C 20CA 
     6E0E 83CA 
0266 6E10 C820  54         mov   @>20CC,@>83CC
     6E12 20CC 
     6E14 83CC 
0267 6E16 C820  54         mov   @>20CE,@>83CE
     6E18 20CE 
     6E1A 83CE 
0268 6E1C C820  54         mov   @>20D0,@>83D0
     6E1E 20D0 
     6E20 83D0 
0269 6E22 C820  54         mov   @>20D2,@>83D2
     6E24 20D2 
     6E26 83D2 
0270 6E28 C820  54         mov   @>20D4,@>83D4
     6E2A 20D4 
     6E2C 83D4 
0271 6E2E C820  54         mov   @>20D6,@>83D6
     6E30 20D6 
     6E32 83D6 
0272 6E34 C820  54         mov   @>20D8,@>83D8
     6E36 20D8 
     6E38 83D8 
0273 6E3A C820  54         mov   @>20DA,@>83DA
     6E3C 20DA 
     6E3E 83DA 
0274 6E40 C820  54         mov   @>20DC,@>83DC
     6E42 20DC 
     6E44 83DC 
0275 6E46 C820  54         mov   @>20DE,@>83DE
     6E48 20DE 
     6E4A 83DE 
0276 6E4C C820  54         mov   @>20E0,@>83E0
     6E4E 20E0 
     6E50 83E0 
0277 6E52 C820  54         mov   @>20E2,@>83E2
     6E54 20E2 
     6E56 83E2 
0278 6E58 C820  54         mov   @>20E4,@>83E4
     6E5A 20E4 
     6E5C 83E4 
0279 6E5E C820  54         mov   @>20E6,@>83E6
     6E60 20E6 
     6E62 83E6 
0280 6E64 C820  54         mov   @>20E8,@>83E8
     6E66 20E8 
     6E68 83E8 
0281 6E6A C820  54         mov   @>20EA,@>83EA
     6E6C 20EA 
     6E6E 83EA 
0282 6E70 C820  54         mov   @>20EC,@>83EC
     6E72 20EC 
     6E74 83EC 
0283 6E76 C820  54         mov   @>20EE,@>83EE
     6E78 20EE 
     6E7A 83EE 
0284 6E7C C820  54         mov   @>20F0,@>83F0
     6E7E 20F0 
     6E80 83F0 
0285 6E82 C820  54         mov   @>20F2,@>83F2
     6E84 20F2 
     6E86 83F2 
0286 6E88 C820  54         mov   @>20F4,@>83F4
     6E8A 20F4 
     6E8C 83F4 
0287 6E8E C820  54         mov   @>20F6,@>83F6
     6E90 20F6 
     6E92 83F6 
0288 6E94 C820  54         mov   @>20F8,@>83F8
     6E96 20F8 
     6E98 83F8 
0289 6E9A C820  54         mov   @>20FA,@>83FA
     6E9C 20FA 
     6E9E 83FA 
0290 6EA0 C820  54         mov   @>20FC,@>83FC
     6EA2 20FC 
     6EA4 83FC 
0291 6EA6 C820  54         mov   @>20FE,@>83FE
     6EA8 20FE 
     6EAA 83FE 
0292 6EAC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0204                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > mem_scrpad_paging.asm
0001               * FILE......: mem_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * mem.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @mem.scrpad.pgout
0013               *  DATA p0
0014               *  P0 = CPU memory destination
0015               *--------------------------------------------------------------
0016               *  bl   @memx.scrpad.pgout
0017               *  TMP1 = CPU memory destination
0018               *--------------------------------------------------------------
0019               *  Register usage
0020               *  tmp0-tmp2 = Used as temporary registers
0021               *  tmp3      = Copy of CPU memory destination
0022               ********@*****@*********************@**************************
0023               mem.scrpad.pgout:
0024 6EAE C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6EB0 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6EB2 8300 
0030 6EB4 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6EB6 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6EB8 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6EBA CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6EBC 0606  14         dec   tmp2
0037 6EBE 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6EC0 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6EC2 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6EC4 6ECA 
0043                                                   ; R14=PC
0044 6EC6 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6EC8 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6ECA 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6ECC 6BAC 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6ECE 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               ***************************************************************
0064               * mem.scrpad.pgin - Page in scratchpad memory
0065               ***************************************************************
0066               *  bl   @mem.scrpad.pgin
0067               *  DATA p0
0068               *  P0 = CPU memory source
0069               *--------------------------------------------------------------
0070               *  bl   @memx.scrpad.pgin
0071               *  TMP1 = CPU memory source
0072               *--------------------------------------------------------------
0073               *  Register usage
0074               *  tmp0-tmp2 = Used as temporary registers
0075               ********@*****@*********************@**************************
0076               mem.scrpad.pgin:
0077 6ED0 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6ED2 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6ED4 8300 
0083 6ED6 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6ED8 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6EDA CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6EDC 0606  14         dec   tmp2
0089 6EDE 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6EE0 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6EE2 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6EE4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0206               
0208                       copy  "equ_fio.asm"              ; File I/O equates
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
0209                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
**** **** ****     > dsrlnk.asm
0001               * FILE......: dsrlnk.asm
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
0040               ********@*****@*********************@**************************
0041 6EE6 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6EE8 6EEA             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6EEA C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6EEC C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6EEE 8322 
0049 6EF0 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6EF2 6042 
0050 6EF4 C020  34         mov   @>8356,r0             ; get ptr to pab
     6EF6 8356 
0051 6EF8 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6EFA 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6EFC FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6EFE 06C0  14         swpb  r0                    ;
0059 6F00 D800  38         movb  r0,@vdpa              ; send low byte
     6F02 8C02 
0060 6F04 06C0  14         swpb  r0                    ;
0061 6F06 D800  38         movb  r0,@vdpa              ; send high byte
     6F08 8C02 
0062 6F0A D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6F0C 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6F0E 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6F10 0704  14         seto  r4                    ; init counter
0070 6F12 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6F14 2420 
0071 6F16 0580  14 !       inc   r0                    ; point to next char of name
0072 6F18 0584  14         inc   r4                    ; incr char counter
0073 6F1A 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6F1C 0007 
0074 6F1E 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6F20 80C4  18         c     r4,r3                 ; end of name?
0077 6F22 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6F24 06C0  14         swpb  r0                    ;
0082 6F26 D800  38         movb  r0,@vdpa              ; send low byte
     6F28 8C02 
0083 6F2A 06C0  14         swpb  r0                    ;
0084 6F2C D800  38         movb  r0,@vdpa              ; send high byte
     6F2E 8C02 
0085 6F30 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6F32 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6F34 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6F36 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6F38 6FFA 
0093 6F3A 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6F3C C104  18         mov   r4,r4                 ; Check if length = 0
0099 6F3E 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6F40 04E0  34         clr   @>83d0
     6F42 83D0 
0102 6F44 C804  38         mov   r4,@>8354             ; save name length for search
     6F46 8354 
0103 6F48 0584  14         inc   r4                    ; adjust for dot
0104 6F4A A804  38         a     r4,@>8356             ; point to position after name
     6F4C 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6F4E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6F50 83E0 
0110 6F52 04C1  14         clr   r1                    ; version found of dsr
0111 6F54 020C  20         li    r12,>0f00             ; init cru addr
     6F56 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6F58 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6F5A 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6F5C 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6F5E 022C  22         ai    r12,>0100             ; next rom to turn on
     6F60 0100 
0125 6F62 04E0  34         clr   @>83d0                ; clear in case we are done
     6F64 83D0 
0126 6F66 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6F68 2000 
0127 6F6A 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6F6C C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6F6E 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6F70 1D00  20         sbo   0                     ; turn on rom
0134 6F72 0202  20         li    r2,>4000              ; start at beginning of rom
     6F74 4000 
0135 6F76 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6F78 6FF6 
0136 6F7A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6F7C A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6F7E 240A 
0146 6F80 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6F82 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6F84 83D2 
0152 6F86 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6F88 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6F8A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6F8C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6F8E 83D2 
0161 6F90 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6F92 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6F94 04C5  14         clr   r5                    ; Remove any old stuff
0167 6F96 D160  34         movb  @>8355,r5             ; get length as counter
     6F98 8355 
0168 6F9A 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6F9C 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6F9E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6FA0 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6FA2 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6FA4 2420 
0175 6FA6 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6FA8 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6FAA 0605  14         dec   r5                    ; loop until full length checked
0179 6FAC 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6FAE C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6FB0 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6FB2 0581  14         inc   r1                    ; next version found
0191 6FB4 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6FB6 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6FB8 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6FBA 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6FBC 2400 
0200 6FBE C009  18         mov   r9,r0                 ; point to flag in pab
0201 6FC0 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6FC2 8322 
0202                                                   ; (8 or >a)
0203 6FC4 0281  22         ci    r1,8                  ; was it 8?
     6FC6 0008 
0204 6FC8 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6FCA D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6FCC 8350 
0206                                                   ; Get error byte from @>8350
0207 6FCE 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6FD0 06C0  14         swpb  r0                    ;
0215 6FD2 D800  38         movb  r0,@vdpa              ; send low byte
     6FD4 8C02 
0216 6FD6 06C0  14         swpb  r0                    ;
0217 6FD8 D800  38         movb  r0,@vdpa              ; send high byte
     6FDA 8C02 
0218 6FDC D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6FDE 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6FE0 09D1  56         srl   r1,13                 ; just keep error bits
0226 6FE2 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6FE4 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6FE6 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6FE8 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6FEA 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6FEC 06C1  14         swpb  r1                    ; put error in hi byte
0239 6FEE D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6FF0 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6FF2 6042 
0241 6FF4 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6FF6 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6FF8 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6FFA ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
**** **** ****     > runlib.asm
0210                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********@*****@*********************@**************************
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
0041               ********@*****@*********************@**************************
0042               file.open:
0043 6FFC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6FFE C04B  18         mov   r11,r1                ; Save return address
0049 7000 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     7002 2428 
0050 7004 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 7006 04C5  14         clr   tmp1                  ; io.op.open
0052 7008 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     700A 61C8 
0053               file.open_init:
0054 700C 0220  22         ai    r0,9                  ; Move to file descriptor length
     700E 0009 
0055 7010 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7012 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 7014 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     7016 6EE6 
0061 7018 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 701A 1029  14         jmp   file.record.pab.details
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
0088               ********@*****@*********************@**************************
0089               file.close:
0090 701C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 701E C04B  18         mov   r11,r1                ; Save return address
0096 7020 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     7022 2428 
0097 7024 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 7026 0205  20         li    tmp1,io.op.close      ; io.op.close
     7028 0001 
0099 702A 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     702C 61C8 
0100               file.close_init:
0101 702E 0220  22         ai    r0,9                  ; Move to file descriptor length
     7030 0009 
0102 7032 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7034 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 7036 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     7038 6EE6 
0108 703A 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 703C 1018  14         jmp   file.record.pab.details
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
0137               ********@*****@*********************@**************************
0138               file.record.read:
0139 703E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 7040 C04B  18         mov   r11,r1                ; Save return address
0145 7042 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     7044 2428 
0146 7046 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 7048 0205  20         li    tmp1,io.op.read       ; io.op.read
     704A 0002 
0148 704C 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     704E 61C8 
0149               file.record.read_init:
0150 7050 0220  22         ai    r0,9                  ; Move to file descriptor length
     7052 0009 
0151 7054 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7056 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 7058 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     705A 6EE6 
0157 705C 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 705E 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 7060 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 7062 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 7064 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 7066 1000  14         nop
0183               
0184               
0185               file.delete:
0186 7068 1000  14         nop
0187               
0188               
0189               file.rename:
0190 706A 1000  14         nop
0191               
0192               
0193               file.status:
0194 706C 1000  14         nop
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
0207               ********@*****@*********************@**************************
0208               
0209               ********@*****@*********************@**************************
0210               file.record.pab.details:
0211 706E 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 7070 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     7072 2428 
0219 7074 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     7076 0005 
0220 7078 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     707A 61E0 
0221 707C C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 707E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 7080 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0212               
0213               
0214               
0215               *//////////////////////////////////////////////////////////////
0216               *                            TIMERS
0217               *//////////////////////////////////////////////////////////////
0218               
0219                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0019               ********@*****@*********************@**************************
0020 7082 0300  24 tmgr    limi  0                     ; No interrupt processing
     7084 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 7086 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     7088 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 708A 2360  38         coc   @wbit2,r13            ; C flag on ?
     708C 6042 
0029 708E 1602  14         jne   tmgr1a                ; No, so move on
0030 7090 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     7092 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 7094 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     7096 6046 
0035 7098 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 709A 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     709C 6036 
0048 709E 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 70A0 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     70A2 6034 
0050 70A4 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 70A6 0460  28         b     @kthread              ; Run kernel thread
     70A8 7120 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 70AA 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     70AC 603A 
0056 70AE 13EB  14         jeq   tmgr1
0057 70B0 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     70B2 6038 
0058 70B4 16E8  14         jne   tmgr1
0059 70B6 C120  34         mov   @wtiusr,tmp0
     70B8 832E 
0060 70BA 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 70BC 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     70BE 711E 
0065 70C0 C10A  18         mov   r10,tmp0
0066 70C2 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     70C4 00FF 
0067 70C6 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     70C8 6042 
0068 70CA 1303  14         jeq   tmgr5
0069 70CC 0284  22         ci    tmp0,60               ; 1 second reached ?
     70CE 003C 
0070 70D0 1002  14         jmp   tmgr6
0071 70D2 0284  22 tmgr5   ci    tmp0,50
     70D4 0032 
0072 70D6 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 70D8 1001  14         jmp   tmgr8
0074 70DA 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 70DC C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     70DE 832C 
0079 70E0 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     70E2 FF00 
0080 70E4 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 70E6 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 70E8 05C4  14         inct  tmp0                  ; Second word of slot data
0086 70EA 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 70EC C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 70EE 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     70F0 830C 
     70F2 830D 
0089 70F4 1608  14         jne   tmgr10                ; No, get next slot
0090 70F6 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     70F8 FF00 
0091 70FA C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 70FC C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     70FE 8330 
0096 7100 0697  24         bl    *tmp3                 ; Call routine in slot
0097 7102 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     7104 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 7106 058A  14 tmgr10  inc   r10                   ; Next slot
0102 7108 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     710A 8315 
     710C 8314 
0103 710E 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 7110 05C4  14         inct  tmp0                  ; Offset for next slot
0105 7112 10E8  14         jmp   tmgr9                 ; Process next slot
0106 7114 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 7116 10F7  14         jmp   tmgr10                ; Process next slot
0108 7118 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     711A FF00 
0109 711C 10B4  14         jmp   tmgr1
0110 711E 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0220                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0014               ********@*****@*********************@**************************
0015 7120 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     7122 6036 
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
0041 7124 06A0  32         bl    @realkb               ; Scan full keyboard
     7126 653A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7128 0460  28         b     @tmgr3                ; Exit
     712A 70AA 
**** **** ****     > runlib.asm
0221                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0016               ********@*****@*********************@**************************
0017 712C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     712E 832E 
0018 7130 E0A0  34         soc   @wbit7,config         ; Enable user hook
     7132 6038 
0019 7134 045B  20 mkhoo1  b     *r11                  ; Return
0020      7086     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 7136 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7138 832E 
0029 713A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     713C FEFF 
0030 713E 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0222               
0224                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0016               ********@*****@*********************@**************************
0017 7140 C13B  30 mkslot  mov   *r11+,tmp0
0018 7142 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 7144 C184  18         mov   tmp0,tmp2
0023 7146 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 7148 A1A0  34         a     @wtitab,tmp2          ; Add table base
     714A 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 714C CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 714E 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7150 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7152 881B  46         c     *r11,@w$ffff          ; End of list ?
     7154 6048 
0035 7156 1301  14         jeq   mkslo1                ; Yes, exit
0036 7158 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 715A 05CB  14 mkslo1  inct  r11
0041 715C 045B  20         b     *r11                  ; Exit
0042               
0043               
0044               ***************************************************************
0045               * CLSLOT - Clear single timer slot
0046               ***************************************************************
0047               *  BL    @CLSLOT
0048               *  DATA  P0
0049               *--------------------------------------------------------------
0050               *  P0 = Slot number
0051               ********@*****@*********************@**************************
0052 715E C13B  30 clslot  mov   *r11+,tmp0
0053 7160 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7162 A120  34         a     @wtitab,tmp0          ; Add table base
     7164 832C 
0055 7166 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7168 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 716A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0226               
0227               
0228               
0229               *//////////////////////////////////////////////////////////////
0230               *                    RUNLIB INITIALISATION
0231               *//////////////////////////////////////////////////////////////
0232               
0233               ***************************************************************
0234               *  RUNLIB - Runtime library initalisation
0235               ***************************************************************
0236               *  B  @RUNLIB
0237               *--------------------------------------------------------------
0238               *  REMARKS
0239               *  if R0 in WS1 equals >4a4a we were called from the system
0240               *  crash handler so we return there after initialisation.
0241               
0242               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0243               *  after clearing scratchpad memory. This has higher priority
0244               *  as crash handler flag R0.
0245               ********@*****@*********************@**************************
0247 716C 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     716E 68AA 
0248 7170 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7172 8302 
0252               *--------------------------------------------------------------
0253               * Alternative entry point
0254               *--------------------------------------------------------------
0255 7174 0300  24 runli1  limi  0                     ; Turn off interrupts
     7176 0000 
0256 7178 02E0  18         lwpi  ws1                   ; Activate workspace 1
     717A 8300 
0257 717C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     717E 83C0 
0258               *--------------------------------------------------------------
0259               * Clear scratch-pad memory from R4 upwards
0260               *--------------------------------------------------------------
0261 7180 0202  20 runli2  li    r2,>8308
     7182 8308 
0262 7184 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0263 7186 0282  22         ci    r2,>8400
     7188 8400 
0264 718A 16FC  14         jne   runli3
0265               *--------------------------------------------------------------
0266               * Exit to TI-99/4A title screen ?
0267               *--------------------------------------------------------------
0268               runli3a
0269 718C 0281  22         ci    r1,>ffff              ; Exit flag set ?
     718E FFFF 
0270 7190 1602  14         jne   runli4                ; No, continue
0271 7192 0420  54         blwp  @0                    ; Yes, bye bye
     7194 0000 
0272               *--------------------------------------------------------------
0273               * Determine if VDP is PAL or NTSC
0274               *--------------------------------------------------------------
0275 7196 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7198 833C 
0276 719A 04C1  14         clr   r1                    ; Reset counter
0277 719C 0202  20         li    r2,10                 ; We test 10 times
     719E 000A 
0278 71A0 C0E0  34 runli5  mov   @vdps,r3
     71A2 8802 
0279 71A4 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     71A6 6046 
0280 71A8 1302  14         jeq   runli6
0281 71AA 0581  14         inc   r1                    ; Increase counter
0282 71AC 10F9  14         jmp   runli5
0283 71AE 0602  14 runli6  dec   r2                    ; Next test
0284 71B0 16F7  14         jne   runli5
0285 71B2 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     71B4 1250 
0286 71B6 1202  14         jle   runli7                ; No, so it must be NTSC
0287 71B8 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     71BA 6042 
0288               *--------------------------------------------------------------
0289               * Copy machine code to scratchpad (prepare tight loop)
0290               *--------------------------------------------------------------
0291 71BC 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     71BE 611C 
0292 71C0 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     71C2 8322 
0293 71C4 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0294 71C6 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0295 71C8 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0296               *--------------------------------------------------------------
0297               * Initialize registers, memory, ...
0298               *--------------------------------------------------------------
0299 71CA 04C1  14 runli9  clr   r1
0300 71CC 04C2  14         clr   r2
0301 71CE 04C3  14         clr   r3
0302 71D0 0209  20         li    stack,>8400           ; Set stack
     71D2 8400 
0303 71D4 020F  20         li    r15,vdpw              ; Set VDP write address
     71D6 8C00 
0307               *--------------------------------------------------------------
0308               * Setup video memory
0309               *--------------------------------------------------------------
0311 71D8 0280  22         ci    r0,>4a4a              ; Crash flag set?
     71DA 4A4A 
0312 71DC 1605  14         jne   runlia
0313 71DE 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     71E0 618A 
0314 71E2 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     71E4 0000 
     71E6 3FFF 
0319 71E8 06A0  32 runlia  bl    @filv
     71EA 618A 
0320 71EC 0FC0             data  pctadr,spfclr,16      ; Load color table
     71EE 00F4 
     71F0 0010 
0321               *--------------------------------------------------------------
0322               * Check if there is a F18A present
0323               *--------------------------------------------------------------
0327 71F2 06A0  32         bl    @f18unl               ; Unlock the F18A
     71F4 6482 
0328 71F6 06A0  32         bl    @f18chk               ; Check if F18A is there
     71F8 649C 
0329 71FA 06A0  32         bl    @f18lck               ; Lock the F18A again
     71FC 6492 
0331               *--------------------------------------------------------------
0332               * Check if there is a speech synthesizer attached
0333               *--------------------------------------------------------------
0335               *       <<skipped>>
0339               *--------------------------------------------------------------
0340               * Load video mode table & font
0341               *--------------------------------------------------------------
0342 71FE 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7200 61F4 
0343 7202 6112             data  spvmod                ; Equate selected video mode table
0344 7204 0204  20         li    tmp0,spfont           ; Get font option
     7206 000C 
0345 7208 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0346 720A 1304  14         jeq   runlid                ; Yes, skip it
0347 720C 06A0  32         bl    @ldfnt
     720E 625C 
0348 7210 1100             data  fntadr,spfont         ; Load specified font
     7212 000C 
0349               *--------------------------------------------------------------
0350               * Did a system crash occur before runlib was called?
0351               *--------------------------------------------------------------
0352 7214 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     7216 4A4A 
0353 7218 1602  14         jne   runlie                ; No, continue
0354 721A 0460  28         b     @crash.main           ; Yes, back to crash handler
     721C 60A0 
0355               *--------------------------------------------------------------
0356               * Branch to main program
0357               *--------------------------------------------------------------
0358 721E 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7220 0040 
0359 7222 0460  28         b     @main                 ; Give control to main program
     7224 7226 
**** **** ****     > tivi.asm.2048
0211               
0212               *--------------------------------------------------------------
0213               * Video mode configuration
0214               *--------------------------------------------------------------
0215      6112     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0216      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0217      0050     colrow  equ   80                    ; Columns per row
0218      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0219      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0220      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0221      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0222               
0223               
0224               ***************************************************************
0225               * Main
0226               ********@*****@*********************@**************************
0227 7226 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     7228 6044 
0228 722A 1302  14         jeq   main.continue
0229 722C 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     722E 0000 
0230               
0231               main.continue:
0232 7230 06A0  32         bl    @scroff               ; Turn screen off
     7232 63DE 
0233 7234 06A0  32         bl    @f18unl               ; Unlock the F18a
     7236 6482 
0234 7238 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     723A 622E 
0235 723C 3140                   data >3140            ; F18a VR49 (>31), bit 40
0236                       ;------------------------------------------------------
0237                       ; Initialize VDP SIT
0238                       ;------------------------------------------------------
0239 723E 06A0  32         bl    @filv
     7240 618A 
0240 7242 0000                   data >0000,32,31*80   ; Clear VDP SIT
     7244 0020 
     7246 09B0 
0241 7248 06A0  32         bl    @scron                ; Turn screen on
     724A 63E6 
0242                       ;------------------------------------------------------
0243                       ; Initialize low + high memory expansion
0244                       ;------------------------------------------------------
0245 724C 06A0  32         bl    @film
     724E 6132 
0246 7250 2200                   data >2200,00,8*1024-256*2
     7252 0000 
     7254 3E00 
0247                                                   ; Clear part of 8k low-memory
0248               
0249 7256 06A0  32         bl    @film
     7258 6132 
0250 725A A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     725C 0000 
     725E 6000 
0251                       ;------------------------------------------------------
0252                       ; Setup cursor, screen, etc.
0253                       ;------------------------------------------------------
0254 7260 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     7262 63FE 
0255 7264 06A0  32         bl    @s8x8                 ; Small sprite
     7266 640E 
0256               
0257 7268 06A0  32         bl    @cpym2m
     726A 637C 
0258 726C 7F60                   data romsat,ramsat,4  ; Load sprite SAT
     726E 8380 
     7270 0004 
0259               
0260 7272 C820  54         mov   @romsat+2,@fb.curshape
     7274 7F62 
     7276 2210 
0261                                                   ; Save cursor shape & color
0262               
0263 7278 06A0  32         bl    @cpym2v
     727A 6334 
0264 727C 1800                   data sprpdt,cursors,3*8
     727E 7F64 
     7280 0018 
0265                                                   ; Load sprite cursor patterns
0266               *--------------------------------------------------------------
0267               * Initialize
0268               *--------------------------------------------------------------
0269 7282 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7284 7BC8 
0270 7286 06A0  32         bl    @idx.init             ; Initialize index
     7288 7B02 
0271 728A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     728C 7A26 
0272               
0273                       ;-------------------------------------------------------
0274                       ; Setup editor tasks & hook
0275                       ;-------------------------------------------------------
0276 728E 0204  20         li    tmp0,>0200
     7290 0200 
0277 7292 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     7294 8314 
0278               
0279 7296 06A0  32         bl    @at
     7298 641E 
0280 729A 0000             data  >0000                 ; Cursor YX position = >0000
0281               
0282 729C 0204  20         li    tmp0,timers
     729E 8370 
0283 72A0 C804  38         mov   tmp0,@wtitab
     72A2 832C 
0284               
0285 72A4 06A0  32         bl    @mkslot
     72A6 7140 
0286 72A8 0001                   data >0001,task0      ; Task 0 - Update screen
     72AA 78A0 
0287 72AC 0101                   data >0101,task1      ; Task 1 - Update cursor position
     72AE 7924 
0288 72B0 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     72B2 7932 
     72B4 FFFF 
0289               
0290 72B6 06A0  32         bl    @mkhook
     72B8 712C 
0291 72BA 72C0                   data editor           ; Setup user hook
0292               
0293 72BC 0460  28         b     @tmgr                 ; Start timers and kthread
     72BE 7082 
0294               
0295               
0296               ****************************************************************
0297               * Editor - Main loop
0298               ****************************************************************
0299 72C0 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     72C2 6030 
0300 72C4 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0301               *---------------------------------------------------------------
0302               * Identical key pressed ?
0303               *---------------------------------------------------------------
0304 72C6 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     72C8 6030 
0305 72CA 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     72CC 833C 
     72CE 833E 
0306 72D0 1308  14         jeq   ed_wait
0307               *--------------------------------------------------------------
0308               * New key pressed
0309               *--------------------------------------------------------------
0310               ed_new_key
0311 72D2 C820  54         mov   @waux1,@waux2         ; Save as previous key
     72D4 833C 
     72D6 833E 
0312 72D8 1045  14         jmp   edkey                 ; Process key
0313               *--------------------------------------------------------------
0314               * Clear keyboard buffer if no key pressed
0315               *--------------------------------------------------------------
0316               ed_clear_kbbuffer
0317 72DA 04E0  34         clr   @waux1
     72DC 833C 
0318 72DE 04E0  34         clr   @waux2
     72E0 833E 
0319               *--------------------------------------------------------------
0320               * Delay to avoid key bouncing
0321               *--------------------------------------------------------------
0322               ed_wait
0323 72E2 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     72E4 0708 
0324                       ;------------------------------------------------------
0325                       ; Delay loop
0326                       ;------------------------------------------------------
0327               ed_wait_loop
0328 72E6 0604  14         dec   tmp0
0329 72E8 16FE  14         jne   ed_wait_loop
0330               *--------------------------------------------------------------
0331               * Exit
0332               *--------------------------------------------------------------
0333 72EA 0460  28 ed_exit b     @hookok               ; Return
     72EC 7086 
0334               
0335               
0336               
0337               
0338               
0339               
0340               ***************************************************************
0341               *                Tivi - Editor keyboard actions
0342               ***************************************************************
0343                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 72EE 0D00             data  key_enter,edkey.action.enter          ; New line
     72F0 7752 
0056 72F2 0800             data  key_left,edkey.action.left            ; Move cursor left
     72F4 7386 
0057 72F6 0900             data  key_right,edkey.action.right          ; Move cursor right
     72F8 739C 
0058 72FA 0B00             data  key_up,edkey.action.up                ; Move cursor up
     72FC 73B4 
0059 72FE 0A00             data  key_down,edkey.action.down            ; Move cursor down
     7300 7406 
0060 7302 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     7304 7472 
0061 7306 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     7308 748A 
0062 730A 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     730C 749E 
0063 730E 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     7310 74F0 
0064 7312 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     7314 7550 
0065 7316 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     7318 759A 
0066 731A 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     731C 75C6 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 731E 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     7320 75F4 
0071 7322 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     7324 762C 
0072 7326 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     7328 7660 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 732A 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     732C 76B8 
0077 732E B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     7330 77C0 
0078 7332 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     7334 770E 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 7336 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     7338 7810 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 733A B000             data  key_buf0,edkey.action.buffer0
     733C 785C 
0087 733E B100             data  key_buf1,edkey.action.buffer1
     7340 7866 
0088 7342 B200             data  key_buf2,edkey.action.buffer2
     7344 786C 
0089 7346 B300             data  key_buf3,edkey.action.buffer3
     7348 7876 
0090 734A B400             data  key_buf4,edkey.action.buffer4
     734C 787C 
0091 734E B500             data  key_buf5,edkey.action.buffer5
     7350 7882 
0092 7352 B600             data  key_buf6,edkey.action.buffer6
     7354 7888 
0093 7356 B700             data  key_buf7,edkey.action.buffer7
     7358 788E 
0094 735A 9E00             data  key_buf8,edkey.action.buffer8
     735C 7894 
0095 735E 9F00             data  key_buf9,edkey.action.buffer9
     7360 789A 
0096 7362 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 7364 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     7366 833C 
0104 7368 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     736A FF00 
0105               
0106 736C 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     736E 72EE 
0107 7370 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 7372 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 7374 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 7376 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 7378 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 737A 05C6  14         inct  tmp2                  ; No, skip action
0118 737C 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 737E C196  26         mov  *tmp2,tmp2             ; Get action address
0122 7380 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 7382 0460  28         b    @edkey.action.char     ; Add character to buffer
     7384 77D0 
**** **** ****     > tivi.asm.2048
0344                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 7386 C120  34         mov   @fb.column,tmp0
     7388 220C 
0010 738A 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 738C 0620  34         dec   @fb.column            ; Column-- in screen buffer
     738E 220C 
0015 7390 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7392 832A 
0016 7394 0620  34         dec   @fb.current
     7396 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 7398 0460  28 !       b     @ed_wait              ; Back to editor main
     739A 72E2 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 739C 8820  54         c     @fb.column,@fb.row.length
     739E 220C 
     73A0 2208 
0028 73A2 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 73A4 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     73A6 220C 
0033 73A8 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     73AA 832A 
0034 73AC 05A0  34         inc   @fb.current
     73AE 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 73B0 0460  28 !       b     @ed_wait              ; Back to editor main
     73B2 72E2 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 73B4 8820  54         c     @fb.row.dirty,@w$ffff
     73B6 220A 
     73B8 6048 
0049 73BA 1604  14         jne   edkey.action.up.cursor
0050 73BC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     73BE 7BE8 
0051 73C0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     73C2 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 73C4 C120  34         mov   @fb.row,tmp0
     73C6 2206 
0057 73C8 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 73CA C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     73CC 2204 
0060 73CE 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 73D0 0604  14         dec   tmp0                  ; fb.topline--
0066 73D2 C804  38         mov   tmp0,@parm1
     73D4 8350 
0067 73D6 06A0  32         bl    @fb.refresh           ; Scroll one line up
     73D8 7A90 
0068 73DA 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 73DC 0620  34         dec   @fb.row               ; Row-- in screen buffer
     73DE 2206 
0074 73E0 06A0  32         bl    @up                   ; Row-- VDP cursor
     73E2 642C 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 73E4 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     73E6 7D2E 
0080 73E8 8820  54         c     @fb.column,@fb.row.length
     73EA 220C 
     73EC 2208 
0081 73EE 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 73F0 C820  54         mov   @fb.row.length,@fb.column
     73F2 2208 
     73F4 220C 
0086 73F6 C120  34         mov   @fb.column,tmp0
     73F8 220C 
0087 73FA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     73FC 6436 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 73FE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7400 7A74 
0093 7402 0460  28         b     @ed_wait              ; Back to editor main
     7404 72E2 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 7406 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     7408 2206 
     740A 2304 
0102 740C 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 740E 8820  54         c     @fb.row.dirty,@w$ffff
     7410 220A 
     7412 6048 
0107 7414 1604  14         jne   edkey.action.down.move
0108 7416 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7418 7BE8 
0109 741A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     741C 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 741E C120  34         mov   @fb.topline,tmp0
     7420 2204 
0118 7422 A120  34         a     @fb.row,tmp0
     7424 2206 
0119 7426 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     7428 2304 
0120 742A 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 742C C120  34         mov   @fb.screenrows,tmp0
     742E 2218 
0126 7430 0604  14         dec   tmp0
0127 7432 8120  34         c     @fb.row,tmp0
     7434 2206 
0128 7436 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 7438 C820  54         mov   @fb.topline,@parm1
     743A 2204 
     743C 8350 
0133 743E 05A0  34         inc   @parm1
     7440 8350 
0134 7442 06A0  32         bl    @fb.refresh
     7444 7A90 
0135 7446 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 7448 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     744A 2206 
0141 744C 06A0  32         bl    @down                 ; Row++ VDP cursor
     744E 6424 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 7450 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7452 7D2E 
0147 7454 8820  54         c     @fb.column,@fb.row.length
     7456 220C 
     7458 2208 
0148 745A 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 745C C820  54         mov   @fb.row.length,@fb.column
     745E 2208 
     7460 220C 
0153 7462 C120  34         mov   @fb.column,tmp0
     7464 220C 
0154 7466 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7468 6436 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 746A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     746C 7A74 
0160 746E 0460  28 !       b     @ed_wait              ; Back to editor main
     7470 72E2 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 7472 C120  34         mov   @wyx,tmp0
     7474 832A 
0169 7476 0244  22         andi  tmp0,>ff00
     7478 FF00 
0170 747A C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     747C 832A 
0171 747E 04E0  34         clr   @fb.column
     7480 220C 
0172 7482 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7484 7A74 
0173 7486 0460  28         b     @ed_wait              ; Back to editor main
     7488 72E2 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 748A C120  34         mov   @fb.row.length,tmp0
     748C 2208 
0180 748E C804  38         mov   tmp0,@fb.column
     7490 220C 
0181 7492 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7494 6436 
0182 7496 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7498 7A74 
0183 749A 0460  28         b     @ed_wait              ; Back to editor main
     749C 72E2 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 749E C120  34         mov   @fb.column,tmp0
     74A0 220C 
0192 74A2 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 74A4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     74A6 2202 
0197 74A8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 74AA 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 74AC 0605  14         dec   tmp1
0204 74AE 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 74B0 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 74B2 D195  26         movb  *tmp1,tmp2            ; Get character
0212 74B4 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 74B6 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 74B8 0986  56         srl   tmp2,8                ; Right justify
0215 74BA 0286  22         ci    tmp2,32               ; Space character found?
     74BC 0020 
0216 74BE 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 74C0 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     74C2 2020 
0222 74C4 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 74C6 0287  22         ci    tmp3,>20ff            ; First character is space
     74C8 20FF 
0225 74CA 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 74CC C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     74CE 220C 
0230 74D0 61C4  18         s     tmp0,tmp3
0231 74D2 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     74D4 0002 
0232 74D6 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 74D8 0585  14         inc   tmp1
0238 74DA 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 74DC C805  38         mov   tmp1,@fb.current
     74DE 2202 
0244 74E0 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     74E2 220C 
0245 74E4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     74E6 6436 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 74E8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74EA 7A74 
0251 74EC 0460  28 !       b     @ed_wait              ; Back to editor main
     74EE 72E2 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 74F0 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 74F2 C120  34         mov   @fb.column,tmp0
     74F4 220C 
0261 74F6 8804  38         c     tmp0,@fb.row.length
     74F8 2208 
0262 74FA 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 74FC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     74FE 2202 
0267 7500 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 7502 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 7504 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 7506 0585  14         inc   tmp1
0279 7508 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 750A 8804  38         c     tmp0,@fb.row.length
     750C 2208 
0281 750E 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 7510 D195  26         movb  *tmp1,tmp2            ; Get character
0288 7512 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 7514 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 7516 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 7518 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     751A FFFF 
0293 751C 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 751E 0286  22         ci    tmp2,32
     7520 0020 
0299 7522 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 7524 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 7526 0286  22         ci    tmp2,32               ; Space character found?
     7528 0020 
0307 752A 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 752C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     752E 2020 
0313 7530 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 7532 0287  22         ci    tmp3,>20ff            ; First characer is space?
     7534 20FF 
0316 7536 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 7538 0585  14         inc   tmp1
0321 753A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 753C C805  38         mov   tmp1,@fb.current
     753E 2202 
0327 7540 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7542 220C 
0328 7544 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7546 6436 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 7548 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     754A 7A74 
0334 754C 0460  28 !       b     @ed_wait              ; Back to editor main
     754E 72E2 
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
0346 7550 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     7552 2204 
0347 7554 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 7556 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     7558 2218 
0352 755A 1503  14         jgt   edkey.action.ppage.topline
0353 755C 04E0  34         clr   @fb.topline           ; topline = 0
     755E 2204 
0354 7560 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 7562 6820  54         s     @fb.screenrows,@fb.topline
     7564 2218 
     7566 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 7568 8820  54         c     @fb.row.dirty,@w$ffff
     756A 220A 
     756C 6048 
0365 756E 1604  14         jne   edkey.action.ppage.refresh
0366 7570 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7572 7BE8 
0367 7574 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7576 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 7578 C820  54         mov   @fb.topline,@parm1
     757A 2204 
     757C 8350 
0373 757E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7580 7A90 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 7582 04E0  34         clr   @fb.row
     7584 2206 
0379 7586 05A0  34         inc   @fb.row               ; Set fb.row=1
     7588 2206 
0380 758A 04E0  34         clr   @fb.column
     758C 220C 
0381 758E 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7590 0100 
0382 7592 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7594 832A 
0383 7596 0460  28         b     @edkey.action.up      ; Do rest of logic
     7598 73B4 
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
0394 759A C120  34         mov   @fb.topline,tmp0
     759C 2204 
0395 759E A120  34         a     @fb.screenrows,tmp0
     75A0 2218 
0396 75A2 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     75A4 2304 
0397 75A6 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 75A8 A820  54         a     @fb.screenrows,@fb.topline
     75AA 2218 
     75AC 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 75AE 8820  54         c     @fb.row.dirty,@w$ffff
     75B0 220A 
     75B2 6048 
0408 75B4 1604  14         jne   edkey.action.npage.refresh
0409 75B6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     75B8 7BE8 
0410 75BA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     75BC 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 75BE 0460  28         b     @edkey.action.ppage.refresh
     75C0 7578 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 75C2 0460  28         b     @ed_wait              ; Back to editor main
     75C4 72E2 
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
0433 75C6 8820  54         c     @fb.row.dirty,@w$ffff
     75C8 220A 
     75CA 6048 
0434 75CC 1604  14         jne   edkey.action.top.refresh
0435 75CE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     75D0 7BE8 
0436 75D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     75D4 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 75D6 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     75D8 2204 
0442 75DA 04E0  34         clr   @parm1
     75DC 8350 
0443 75DE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     75E0 7A90 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 75E2 04E0  34         clr   @fb.row               ; Editor line 0
     75E4 2206 
0449 75E6 04E0  34         clr   @fb.column            ; Editor column 0
     75E8 220C 
0450 75EA 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 75EC C804  38         mov   tmp0,@wyx             ;
     75EE 832A 
0452 75F0 0460  28         b     @ed_wait              ; Back to editor main
     75F2 72E2 
**** **** ****     > tivi.asm.2048
0345                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 75F4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     75F6 2306 
0010 75F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     75FA 7A74 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 75FC C120  34         mov   @fb.current,tmp0      ; Get pointer
     75FE 2202 
0015 7600 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7602 2208 
0016 7604 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7606 8820  54         c     @fb.column,@fb.row.length
     7608 220C 
     760A 2208 
0022 760C 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 760E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7610 2202 
0028 7612 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 7614 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7616 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7618 0606  14         dec   tmp2
0036 761A 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 761C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     761E 220A 
0041 7620 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7622 2216 
0042 7624 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7626 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7628 0460  28         b     @ed_wait              ; Back to editor main
     762A 72E2 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 762C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     762E 2306 
0055 7630 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7632 7A74 
0056 7634 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7636 2208 
0057 7638 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 763A C120  34         mov   @fb.current,tmp0      ; Get pointer
     763C 2202 
0063 763E C1A0  34         mov   @fb.colsline,tmp2
     7640 220E 
0064 7642 61A0  34         s     @fb.column,tmp2
     7644 220C 
0065 7646 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 7648 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 764A 0606  14         dec   tmp2
0072 764C 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 764E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7650 220A 
0077 7652 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7654 2216 
0078               
0079 7656 C820  54         mov   @fb.column,@fb.row.length
     7658 220C 
     765A 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 765C 0460  28         b     @ed_wait              ; Back to editor main
     765E 72E2 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7660 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7662 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 7664 C120  34         mov   @edb.lines,tmp0
     7666 2304 
0097 7668 1604  14         jne   !
0098 766A 04E0  34         clr   @fb.column            ; Column 0
     766C 220C 
0099 766E 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7670 762C 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 7672 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7674 7A74 
0104 7676 04E0  34         clr   @fb.row.dirty         ; Discard current line
     7678 220A 
0105 767A C820  54         mov   @fb.topline,@parm1
     767C 2204 
     767E 8350 
0106 7680 A820  54         a     @fb.row,@parm1        ; Line number to remove
     7682 2206 
     7684 8350 
0107 7686 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7688 2304 
     768A 8352 
0108 768C 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     768E 7B3C 
0109 7690 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7692 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7694 C820  54         mov   @fb.topline,@parm1
     7696 2204 
     7698 8350 
0114 769A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     769C 7A90 
0115 769E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     76A0 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 76A2 C120  34         mov   @fb.topline,tmp0
     76A4 2204 
0120 76A6 A120  34         a     @fb.row,tmp0
     76A8 2206 
0121 76AA 8804  38         c     tmp0,@edb.lines       ; Was last line?
     76AC 2304 
0122 76AE 1202  14         jle   edkey.action.del_line.exit
0123 76B0 0460  28         b     @edkey.action.up      ; One line up
     76B2 73B4 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 76B4 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     76B6 7472 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 76B8 0204  20         li    tmp0,>2000            ; White space
     76BA 2000 
0139 76BC C804  38         mov   tmp0,@parm1
     76BE 8350 
0140               edkey.action.ins_char:
0141 76C0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     76C2 2306 
0142 76C4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     76C6 7A74 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 76C8 C120  34         mov   @fb.current,tmp0      ; Get pointer
     76CA 2202 
0147 76CC C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     76CE 2208 
0148 76D0 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 76D2 8820  54         c     @fb.column,@fb.row.length
     76D4 220C 
     76D6 2208 
0154 76D8 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 76DA C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 76DC 61E0  34         s     @fb.column,tmp3
     76DE 220C 
0162 76E0 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 76E2 C144  18         mov   tmp0,tmp1
0164 76E4 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 76E6 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     76E8 220C 
0166 76EA 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 76EC D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 76EE 0604  14         dec   tmp0
0173 76F0 0605  14         dec   tmp1
0174 76F2 0606  14         dec   tmp2
0175 76F4 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 76F6 D560  46         movb  @parm1,*tmp1
     76F8 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 76FA 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     76FC 220A 
0184 76FE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7700 2216 
0185 7702 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7704 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7706 0460  28         b     @edkey.action.char.overwrite
     7708 77E2 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 770A 0460  28         b     @ed_wait              ; Back to editor main
     770C 72E2 
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
0206 770E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7710 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 7712 8820  54         c     @fb.row.dirty,@w$ffff
     7714 220A 
     7716 6048 
0211 7718 1604  14         jne   edkey.action.ins_line.insert
0212 771A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     771C 7BE8 
0213 771E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7720 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 7722 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7724 7A74 
0219 7726 C820  54         mov   @fb.topline,@parm1
     7728 2204 
     772A 8350 
0220 772C A820  54         a     @fb.row,@parm1        ; Line number to insert
     772E 2206 
     7730 8350 
0221               
0222 7732 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7734 2304 
     7736 8352 
0223 7738 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     773A 7B66 
0224 773C 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     773E 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 7740 C820  54         mov   @fb.topline,@parm1
     7742 2204 
     7744 8350 
0229 7746 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7748 7A90 
0230 774A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     774C 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 774E 0460  28         b     @ed_wait              ; Back to editor main
     7750 72E2 
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
0249 7752 8820  54         c     @fb.row.dirty,@w$ffff
     7754 220A 
     7756 6048 
0250 7758 1606  14         jne   edkey.action.enter.upd_counter
0251 775A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     775C 2306 
0252 775E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7760 7BE8 
0253 7762 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7764 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 7766 C120  34         mov   @fb.topline,tmp0
     7768 2204 
0259 776A A120  34         a     @fb.row,tmp0
     776C 2206 
0260 776E 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7770 2304 
0261 7772 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 7774 05A0  34         inc   @edb.lines            ; Total lines++
     7776 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 7778 C120  34         mov   @fb.screenrows,tmp0
     777A 2218 
0271 777C 0604  14         dec   tmp0
0272 777E 8120  34         c     @fb.row,tmp0
     7780 2206 
0273 7782 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 7784 C120  34         mov   @fb.screenrows,tmp0
     7786 2218 
0278 7788 C820  54         mov   @fb.topline,@parm1
     778A 2204 
     778C 8350 
0279 778E 05A0  34         inc   @parm1
     7790 8350 
0280 7792 06A0  32         bl    @fb.refresh
     7794 7A90 
0281 7796 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 7798 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     779A 2206 
0287 779C 06A0  32         bl    @down                 ; Row++ VDP cursor
     779E 6424 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 77A0 06A0  32         bl    @fb.get.firstnonblank
     77A2 7ABA 
0293 77A4 C120  34         mov   @outparm1,tmp0
     77A6 8360 
0294 77A8 C804  38         mov   tmp0,@fb.column
     77AA 220C 
0295 77AC 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     77AE 6436 
0296 77B0 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     77B2 7D2E 
0297 77B4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     77B6 7A74 
0298 77B8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     77BA 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 77BC 0460  28         b     @ed_wait              ; Back to editor main
     77BE 72E2 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 77C0 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     77C2 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 77C4 0204  20         li    tmp0,2000
     77C6 07D0 
0317               edkey.action.ins_onoff.loop:
0318 77C8 0604  14         dec   tmp0
0319 77CA 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 77CC 0460  28         b     @task2.cur_visible    ; Update cursor shape
     77CE 793E 
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
0335 77D0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     77D2 2306 
0336 77D4 D805  38         movb  tmp1,@parm1           ; Store character for insert
     77D6 8350 
0337 77D8 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     77DA 230C 
0338 77DC 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 77DE 0460  28         b     @edkey.action.ins_char
     77E0 76C0 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 77E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     77E4 7A74 
0349 77E6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     77E8 2202 
0350               
0351 77EA D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     77EC 8350 
0352 77EE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     77F0 220A 
0353 77F2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     77F4 2216 
0354               
0355 77F6 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     77F8 220C 
0356 77FA 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     77FC 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 77FE 8820  54         c     @fb.column,@fb.row.length
     7800 220C 
     7802 2208 
0361 7804 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7806 C820  54         mov   @fb.column,@fb.row.length
     7808 220C 
     780A 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 780C 0460  28         b     @ed_wait              ; Back to editor main
     780E 72E2 
**** **** ****     > tivi.asm.2048
0346                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 7810 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7812 64E6 
0010 7814 0420  54         blwp  @0                    ; Exit
     7816 0000 
0011               
**** **** ****     > tivi.asm.2048
0347                       copy  "editorkeys_file.asm" ; Actions for file related keys
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
0016 7818 C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     781A 8350 
     781C 8352 
0017 781E C804  38         mov   tmp0,@parm1           ; Setup file to load
     7820 8350 
0018               
0019 7822 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7824 7BC8 
0020 7826 06A0  32         bl    @idx.init             ; Initialize index
     7828 7B02 
0021 782A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     782C 7A26 
0022 782E C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     7830 8352 
     7832 230E 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7834 06A0  32         bl    @filv
     7836 618A 
0027 7838 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     783A 0000 
     783C 0004 
0028               
0029 783E C160  34         mov   @fb.screenrows,tmp1
     7840 2218 
0030 7842 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7844 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 7846 04C4  14         clr   tmp0                  ; VDP target address
0034 7848 0205  20         li    tmp1,32               ; Character to fill
     784A 0020 
0035               
0036 784C 06A0  32         bl    @xfilv                ; Fill VDP memory
     784E 6190 
0037                                                   ; \ .  tmp0 = VDP target address
0038                                                   ; | .  tmp1 = Byte to fill
0039                                                   ; / .  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 7850 06A0  32         bl    @tfh.file.read        ; Read specified file
     7852 7D52 
0044                                                   ; \ .  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / .  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 7854 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     7856 2306 
0048 7858 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     785A 75C6 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 785C 0204  20         li   tmp0,fdname0
     785E 7FB0 
0054 7860 0720  34         seto @parm1                 ; RLE encoding on
     7862 8350 
0055 7864 10D9  14         jmp  edkey.action.loadfile
0056                                                   ; Load DIS/VAR 80 file into editor buffer
0057               edkey.action.buffer1:
0058 7866 0204  20         li   tmp0,fdname1
     7868 7FBE 
0059 786A 10D6  14         jmp  edkey.action.loadfile
0060                                                   ; Load DIS/VAR 80 file into editor buffer
0061               
0062               edkey.action.buffer2:
0063 786C 0204  20         li   tmp0,fdname2
     786E 7FCE 
0064 7870 0720  34         seto @parm1                 ; RLE encoding on
     7872 8350 
0065 7874 10D1  14         jmp  edkey.action.loadfile
0066                                                   ; Load DIS/VAR 80 file into editor buffer
0067               
0068               edkey.action.buffer3:
0069 7876 0204  20         li   tmp0,fdname3
     7878 7FDC 
0070 787A 10CE  14         jmp  edkey.action.loadfile
0071                                                   ; Load DIS/VAR 80 file into editor buffer
0072               
0073               edkey.action.buffer4:
0074 787C 0204  20         li   tmp0,fdname4
     787E 7FEA 
0075 7880 10CB  14         jmp  edkey.action.loadfile
0076                                                   ; Load DIS/VAR 80 file into editor buffer
0077               
0078               edkey.action.buffer5:
0079 7882 0204  20         li   tmp0,fdname5
     7884 7FF8 
0080 7886 10C8  14         jmp  edkey.action.loadfile
0081                                                   ; Load DIS/VAR 80 file into editor buffer
0082               
0083               edkey.action.buffer6:
0084 7888 0204  20         li   tmp0,fdname6
     788A 8006 
0085 788C 10C5  14         jmp  edkey.action.loadfile
0086                                                   ; Load DIS/VAR 80 file into editor buffer
0087               
0088               edkey.action.buffer7:
0089 788E 0204  20         li   tmp0,fdname7
     7890 8014 
0090 7892 10C2  14         jmp  edkey.action.loadfile
0091                                                   ; Load DIS/VAR 80 file into editor buffer
0092               
0093               edkey.action.buffer8:
0094 7894 0204  20         li   tmp0,fdname8
     7896 8022 
0095 7898 10BF  14         jmp  edkey.action.loadfile
0096                                                   ; Load DIS/VAR 80 file into editor buffer
0097               
0098               edkey.action.buffer9:
0099 789A 0204  20         li   tmp0,fdname9
     789C 8030 
0100 789E 10BC  14         jmp  edkey.action.loadfile
0101                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.2048
0348               
0349               
0350               
0351               ***************************************************************
0352               * Task 0 - Copy frame buffer to VDP
0353               ***************************************************************
0354 78A0 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     78A2 2216 
0355 78A4 133D  14         jeq   task0.$$              ; No, skip update
0356                       ;------------------------------------------------------
0357                       ; Determine how many rows to copy
0358                       ;------------------------------------------------------
0359 78A6 8820  54         c     @edb.lines,@fb.screenrows
     78A8 2304 
     78AA 2218 
0360 78AC 1103  14         jlt   task0.setrows.small
0361 78AE C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     78B0 2218 
0362 78B2 1003  14         jmp   task0.copy.framebuffer
0363                       ;------------------------------------------------------
0364                       ; Less lines in editor buffer as rows in frame buffer
0365                       ;------------------------------------------------------
0366               task0.setrows.small:
0367 78B4 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     78B6 2304 
0368 78B8 0585  14         inc   tmp1
0369                       ;------------------------------------------------------
0370                       ; Determine area to copy
0371                       ;------------------------------------------------------
0372               task0.copy.framebuffer:
0373 78BA 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     78BC 220E 
0374                                                   ; 16 bit part is in tmp2!
0375 78BE 04C4  14         clr   tmp0                  ; VDP target address
0376 78C0 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     78C2 2200 
0377                       ;------------------------------------------------------
0378                       ; Copy memory block
0379                       ;------------------------------------------------------
0380 78C4 06A0  32         bl    @xpym2v               ; Copy to VDP
     78C6 633A 
0381                                                   ; tmp0 = VDP target address
0382                                                   ; tmp1 = RAM source address
0383                                                   ; tmp2 = Bytes to copy
0384 78C8 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     78CA 2216 
0385                       ;-------------------------------------------------------
0386                       ; Draw EOF marker at end-of-file
0387                       ;-------------------------------------------------------
0388 78CC C120  34         mov   @edb.lines,tmp0
     78CE 2304 
0389 78D0 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     78D2 2204 
0390 78D4 0584  14         inc   tmp0                  ; Y++
0391 78D6 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     78D8 2218 
0392 78DA 1222  14         jle   task0.$$
0393                       ;-------------------------------------------------------
0394                       ; Draw EOF marker
0395                       ;-------------------------------------------------------
0396               task0.draw_marker:
0397 78DC C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     78DE 832A 
     78E0 2214 
0398 78E2 0A84  56         sla   tmp0,8                ; X=0
0399 78E4 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     78E6 832A 
0400 78E8 06A0  32         bl    @putstr
     78EA 631A 
0401 78EC 7F7E                   data txt_marker       ; Display *EOF*
0402                       ;-------------------------------------------------------
0403                       ; Draw empty line after (and below) EOF marker
0404                       ;-------------------------------------------------------
0405 78EE 06A0  32         bl    @setx
     78F0 6434 
0406 78F2 0005                   data  5               ; Cursor after *EOF* string
0407               
0408 78F4 C120  34         mov   @wyx,tmp0
     78F6 832A 
0409 78F8 0984  56         srl   tmp0,8                ; Right justify
0410 78FA 0584  14         inc   tmp0                  ; One time adjust
0411 78FC 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     78FE 2218 
0412 7900 1303  14         jeq   !
0413 7902 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7904 009B 
0414 7906 1002  14         jmp   task0.draw_marker.line
0415 7908 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     790A 004B 
0416                       ;-------------------------------------------------------
0417                       ; Draw empty line
0418                       ;-------------------------------------------------------
0419               task0.draw_marker.line:
0420 790C 0604  14         dec   tmp0                  ; One time adjust
0421 790E 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7910 62F6 
0422 7912 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7914 0020 
0423 7916 06A0  32         bl    @xfilv                ; Write characters
     7918 6190 
0424 791A C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     791C 2214 
     791E 832A 
0425               *--------------------------------------------------------------
0426               * Task 0 - Exit
0427               *--------------------------------------------------------------
0428               task0.$$:
0429 7920 0460  28         b     @slotok
     7922 7102 
0430               
0431               
0432               
0433               ***************************************************************
0434               * Task 1 - Copy SAT to VDP
0435               ***************************************************************
0436 7924 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     7926 6046 
0437 7928 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     792A 6440 
0438 792C C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     792E 8380 
0439 7930 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0440               
0441               
0442               ***************************************************************
0443               * Task 2 - Update cursor shape (blink)
0444               ***************************************************************
0445 7932 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     7934 2212 
0446 7936 1303  14         jeq   task2.cur_visible
0447 7938 04E0  34         clr   @ramsat+2              ; Hide cursor
     793A 8382 
0448 793C 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0449               
0450               task2.cur_visible:
0451 793E C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7940 230C 
0452 7942 1303  14         jeq   task2.cur_visible.overwrite_mode
0453                       ;------------------------------------------------------
0454                       ; Cursor in insert mode
0455                       ;------------------------------------------------------
0456               task2.cur_visible.insert_mode:
0457 7944 0204  20         li    tmp0,>000f
     7946 000F 
0458 7948 1002  14         jmp   task2.cur_visible.cursorshape
0459                       ;------------------------------------------------------
0460                       ; Cursor in overwrite mode
0461                       ;------------------------------------------------------
0462               task2.cur_visible.overwrite_mode:
0463 794A 0204  20         li    tmp0,>020f
     794C 020F 
0464                       ;------------------------------------------------------
0465                       ; Set cursor shape
0466                       ;------------------------------------------------------
0467               task2.cur_visible.cursorshape:
0468 794E C804  38         mov   tmp0,@fb.curshape
     7950 2210 
0469 7952 C804  38         mov   tmp0,@ramsat+2
     7954 8382 
0470               
0471               
0472               
0473               
0474               
0475               
0476               
0477               *--------------------------------------------------------------
0478               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0479               *--------------------------------------------------------------
0480               task.sub_copy_ramsat
0481 7956 06A0  32         bl    @cpym2v
     7958 6334 
0482 795A 2000                   data sprsat,ramsat,4   ; Update sprite
     795C 8380 
     795E 0004 
0483               
0484 7960 C820  54         mov   @wyx,@fb.yxsave
     7962 832A 
     7964 2214 
0485                       ;------------------------------------------------------
0486                       ; Show text editing mode
0487                       ;------------------------------------------------------
0488               task.botline.show_mode
0489 7966 C120  34         mov   @edb.insmode,tmp0
     7968 230C 
0490 796A 1605  14         jne   task.botline.show_mode.insert
0491                       ;------------------------------------------------------
0492                       ; Overwrite mode
0493                       ;------------------------------------------------------
0494               task.botline.show_mode.overwrite:
0495 796C 06A0  32         bl    @putat
     796E 632C 
0496 7970 1D32                   byte  29,50
0497 7972 7F8A                   data  txt_ovrwrite
0498 7974 1004  14         jmp   task.botline.show_changed
0499                       ;------------------------------------------------------
0500                       ; Insert  mode
0501                       ;------------------------------------------------------
0502               task.botline.show_mode.insert:
0503 7976 06A0  32         bl    @putat
     7978 632C 
0504 797A 1D32                   byte  29,50
0505 797C 7F8E                   data  txt_insert
0506                       ;------------------------------------------------------
0507                       ; Show if text was changed in editor buffer
0508                       ;------------------------------------------------------
0509               task.botline.show_changed:
0510 797E C120  34         mov   @edb.dirty,tmp0
     7980 2306 
0511 7982 1305  14         jeq   task.botline.show_changed.clear
0512                       ;------------------------------------------------------
0513                       ; Show "*"
0514                       ;------------------------------------------------------
0515 7984 06A0  32         bl    @putat
     7986 632C 
0516 7988 1D36                   byte 29,54
0517 798A 7F92                   data txt_star
0518 798C 1001  14         jmp   task.botline.show_linecol
0519                       ;------------------------------------------------------
0520                       ; Show "line,column"
0521                       ;------------------------------------------------------
0522               task.botline.show_changed.clear:
0523 798E 1000  14         nop
0524               task.botline.show_linecol:
0525 7990 C820  54         mov   @fb.row,@parm1
     7992 2206 
     7994 8350 
0526 7996 06A0  32         bl    @fb.row2line
     7998 7A60 
0527 799A 05A0  34         inc   @outparm1
     799C 8360 
0528                       ;------------------------------------------------------
0529                       ; Show line
0530                       ;------------------------------------------------------
0531 799E 06A0  32         bl    @putnum
     79A0 679E 
0532 79A2 1D40                   byte  29,64            ; YX
0533 79A4 8360                   data  outparm1,rambuf
     79A6 8390 
0534 79A8 3020                   byte  48               ; ASCII offset
0535                             byte  32               ; Padding character
0536                       ;------------------------------------------------------
0537                       ; Show comma
0538                       ;------------------------------------------------------
0539 79AA 06A0  32         bl    @putat
     79AC 632C 
0540 79AE 1D45                   byte  29,69
0541 79B0 7F7C                   data  txt_delim
0542                       ;------------------------------------------------------
0543                       ; Show column
0544                       ;------------------------------------------------------
0545 79B2 06A0  32         bl    @film
     79B4 6132 
0546 79B6 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     79B8 0020 
     79BA 000C 
0547               
0548 79BC C820  54         mov   @fb.column,@waux1
     79BE 220C 
     79C0 833C 
0549 79C2 05A0  34         inc   @waux1                 ; Offset 1
     79C4 833C 
0550               
0551 79C6 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     79C8 6720 
0552 79CA 833C                   data  waux1,rambuf
     79CC 8390 
0553 79CE 3020                   byte  48               ; ASCII offset
0554                             byte  32               ; Fill character
0555               
0556 79D0 06A0  32         bl    @trimnum               ; Trim number to the left
     79D2 6778 
0557 79D4 8390                   data  rambuf,rambuf+6,32
     79D6 8396 
     79D8 0020 
0558               
0559 79DA 0204  20         li    tmp0,>0200
     79DC 0200 
0560 79DE D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     79E0 8396 
0561               
0562 79E2 06A0  32         bl    @putat
     79E4 632C 
0563 79E6 1D46                   byte 29,70
0564 79E8 8396                   data rambuf+6          ; Show column
0565                       ;------------------------------------------------------
0566                       ; Show lines in buffer unless on last line in file
0567                       ;------------------------------------------------------
0568 79EA C820  54         mov   @fb.row,@parm1
     79EC 2206 
     79EE 8350 
0569 79F0 06A0  32         bl    @fb.row2line
     79F2 7A60 
0570 79F4 8820  54         c     @edb.lines,@outparm1
     79F6 2304 
     79F8 8360 
0571 79FA 1605  14         jne   task.botline.show_lines_in_buffer
0572               
0573 79FC 06A0  32         bl    @putat
     79FE 632C 
0574 7A00 1D49                   byte 29,73
0575 7A02 7F84                   data txt_bottom
0576               
0577 7A04 100B  14         jmp   task.botline.$$
0578                       ;------------------------------------------------------
0579                       ; Show lines in buffer
0580                       ;------------------------------------------------------
0581               task.botline.show_lines_in_buffer:
0582 7A06 C820  54         mov   @edb.lines,@waux1
     7A08 2304 
     7A0A 833C 
0583 7A0C 05A0  34         inc   @waux1                 ; Offset 1
     7A0E 833C 
0584 7A10 06A0  32         bl    @putnum
     7A12 679E 
0585 7A14 1D49                   byte 29,73             ; YX
0586 7A16 833C                   data waux1,rambuf
     7A18 8390 
0587 7A1A 3020                   byte 48
0588                             byte 32
0589                       ;------------------------------------------------------
0590                       ; Exit
0591                       ;------------------------------------------------------
0592               task.botline.$$
0593 7A1C C820  54         mov   @fb.yxsave,@wyx
     7A1E 2214 
     7A20 832A 
0594 7A22 0460  28         b     @slotok                ; Exit running task
     7A24 7102 
0595               
0596               
0597               
0598               ***************************************************************
0599               *                  fb - Framebuffer module
0600               ***************************************************************
0601                       copy  "framebuffer.asm"
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
0022               ********@*****@*********************@**************************
0023               fb.init
0024 7A26 0649  14         dect  stack
0025 7A28 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7A2A 0204  20         li    tmp0,fb.top
     7A2C 2650 
0030 7A2E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7A30 2200 
0031 7A32 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     7A34 2204 
0032 7A36 04E0  34         clr   @fb.row               ; Current row=0
     7A38 2206 
0033 7A3A 04E0  34         clr   @fb.column            ; Current column=0
     7A3C 220C 
0034 7A3E 0204  20         li    tmp0,80
     7A40 0050 
0035 7A42 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7A44 220E 
0036 7A46 0204  20         li    tmp0,29
     7A48 001D 
0037 7A4A C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     7A4C 2218 
0038 7A4E 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7A50 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 7A52 06A0  32         bl    @film
     7A54 6132 
0043 7A56 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7A58 0000 
     7A5A 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7A5C 0460  28         b     @poprt                ; Return to caller
     7A5E 612E 
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
0071               ********@*****@*********************@**************************
0072               fb.row2line:
0073 7A60 0649  14         dect  stack
0074 7A62 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 7A64 C120  34         mov   @parm1,tmp0
     7A66 8350 
0079 7A68 A120  34         a     @fb.topline,tmp0
     7A6A 2204 
0080 7A6C C804  38         mov   tmp0,@outparm1
     7A6E 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 7A70 0460  28         b    @poprt                 ; Return to caller
     7A72 612E 
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
0111               ********@*****@*********************@**************************
0112               fb.calc_pointer:
0113 7A74 0649  14         dect  stack
0114 7A76 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7A78 C1A0  34         mov   @fb.row,tmp2
     7A7A 2206 
0119 7A7C 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7A7E 220E 
0120 7A80 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     7A82 220C 
0121 7A84 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7A86 2200 
0122 7A88 C807  38         mov   tmp3,@fb.current
     7A8A 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7A8C 0460  28         b    @poprt                 ; Return to caller
     7A8E 612E 
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
0143               ********@*****@*********************@**************************
0144               fb.refresh:
0145 7A90 0649  14         dect  stack
0146 7A92 C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7A94 C820  54         mov   @parm1,@fb.topline
     7A96 8350 
     7A98 2204 
0151 7A9A 04E0  34         clr   @parm2                ; Target row in frame buffer
     7A9C 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 7A9E 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7AA0 7C76 
0157                                                   ; \ .  parm1 = Line to unpack
0158                                                   ; / .  parm2 = Target row in frame buffer
0159               
0160 7AA2 05A0  34         inc   @parm1                ; Next line in editor buffer
     7AA4 8350 
0161 7AA6 05A0  34         inc   @parm2                ; Next row in frame buffer
     7AA8 8352 
0162 7AAA 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7AAC 8352 
     7AAE 2218 
0163 7AB0 11F6  14         jlt   fb.refresh.unpack_line
0164 7AB2 0720  34         seto  @fb.dirty             ; Refresh screen
     7AB4 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit
0169 7AB6 0460  28         b    @poprt                 ; Return to caller
     7AB8 612E 
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
0183               ********@*****@*********************@**************************
0184               fb.get.firstnonblank
0185 7ABA 0649  14         dect  stack
0186 7ABC C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 7ABE 04E0  34         clr   @fb.column
     7AC0 220C 
0191 7AC2 06A0  32         bl    @fb.calc_pointer
     7AC4 7A74 
0192 7AC6 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7AC8 7D2E 
0193 7ACA C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7ACC 2208 
0194 7ACE 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 7AD0 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7AD2 2202 
0197 7AD4 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 7AD6 D174  28         movb  *tmp0+,tmp1           ; Get character
0203 7AD8 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 7ADA 0285  22         ci    tmp1,>2000            ; Whitespace?
     7ADC 2000 
0206 7ADE 1503  14         jgt   fb.get.firstnonblank.match
0207 7AE0 0606  14         dec   tmp2                  ; Counter--
0208 7AE2 16F9  14         jne   fb.get.firstnonblank.loop
0209 7AE4 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match
0214 7AE6 6120  34         s     @fb.current,tmp0      ; Calculate column
     7AE8 2202 
0215 7AEA 0604  14         dec   tmp0
0216 7AEC C804  38         mov   tmp0,@outparm1        ; Save column
     7AEE 8360 
0217 7AF0 D805  38         movb  tmp1,@outparm2        ; Save character
     7AF2 8362 
0218 7AF4 1004  14         jmp   fb.get.firstnonblank.$$
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch
0223 7AF6 04E0  34         clr   @outparm1             ; X=0
     7AF8 8360 
0224 7AFA 04E0  34         clr   @outparm2             ; Null
     7AFC 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.$$
0229 7AFE 0460  28         b    @poprt                 ; Return to caller
     7B00 612E 
0230               
0231               
0232               
0233               
0234               
0235               
**** **** ****     > tivi.asm.2048
0602               
0603               
0604               ***************************************************************
0605               *              idx - Index management module
0606               ***************************************************************
0607                       copy  "index.asm"
**** **** ****     > index.asm
0001               * FILE......: index.asm
0002               * Purpose...: TiVi Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Size of index page is 4K and allows indexing of 2048 lines.
0010               * Each index slot (1 word) contains the pointer to the line in
0011               * the editor buffer.
0012               *
0013               * The editor buffer always resides at (a000 -> ffff) for a total
0014               * of 24K. Therefor when dereferencing, the base >a000 is to be
0015               * added and only the offset (0000 -> 5fff) is stored in the index
0016               * itself.
0017               *
0018               * The pointers' MSB high-nibble determines the SAMS bank to use:
0019               *
0020               *   0 > SAMS bank 0
0021               *   1 > SAMS bank 0
0022               *   2 > SAMS bank 0
0023               *   3 > SAMS bank 0
0024               *   4 > SAMS bank 0
0025               *   5 > SAMS bank 0
0026               *   6 > SAMS bank 1
0027               *   7 > SAMS bank 2
0028               *   8 > SAMS bank 3
0029               *   9 > SAMS bank 4
0030               *   a > SAMS bank 5
0031               *   b > SAMS bank 6
0032               *   c > SAMS bank 7
0033               *   d > SAMS bank 8
0034               *   e > SAMS bank 9
0035               *   f > SAMS bank A
0036               *
0037               * First line in editor buffer starts at offset 2 (a002), this
0038               * allows index to contain "null" pointers which mean empty line
0039               * without reference to editor buffer.
0040               ***************************************************************
0041               
0042               
0043               ***************************************************************
0044               * idx.init
0045               * Initialize index
0046               ***************************************************************
0047               * bl @idx.init
0048               *--------------------------------------------------------------
0049               * INPUT
0050               * none
0051               *--------------------------------------------------------------
0052               * OUTPUT
0053               * none
0054               *--------------------------------------------------------------
0055               * Register usage
0056               * tmp0
0057               ***************************************************************
0058               idx.init:
0059 7B02 0649  14         dect  stack
0060 7B04 C64B  30         mov   r11,*stack            ; Save return address
0061                       ;------------------------------------------------------
0062                       ; Initialize
0063                       ;------------------------------------------------------
0064 7B06 0204  20         li    tmp0,idx.top
     7B08 3000 
0065 7B0A C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7B0C 2302 
0066                       ;------------------------------------------------------
0067                       ; Create index slot 0
0068                       ;------------------------------------------------------
0069 7B0E 06A0  32         bl    @film
     7B10 6132 
0070 7B12 3000             data  idx.top,>00,idx.size  ; Clear index
     7B14 0000 
     7B16 1000 
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               idx.init.exit:
0075 7B18 0460  28         b     @poprt                ; Return to caller
     7B1A 612E 
0076               
0077               
0078               
0079               ***************************************************************
0080               * idx.entry.update
0081               * Update index entry - Each entry corresponds to a line
0082               ***************************************************************
0083               * bl @idx.entry.update
0084               *--------------------------------------------------------------
0085               * INPUT
0086               * @parm1    = Line number in editor buffer
0087               * @parm2    = Pointer to line in editor buffer
0088               * @parm3    = SAMS bank (0-A)
0089               *--------------------------------------------------------------
0090               * OUTPUT
0091               * @outparm1 = Pointer to updated index entry
0092               *--------------------------------------------------------------
0093               * Register usage
0094               * tmp0,tmp1,tmp2
0095               *--------------------------------------------------------------
0096               idx.entry.update:
0097 7B1C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7B1E 8350 
0098                       ;------------------------------------------------------
0099                       ; Calculate offset
0100                       ;------------------------------------------------------
0101 7B20 C160  34         mov   @parm2,tmp1
     7B22 8352 
0102 7B24 1305  14         jeq   idx.entry.update.save ; Special handling for empty line
0103 7B26 0225  22         ai    tmp1,-edb.top         ; Substract editor buffer base,
     7B28 6000 
0104                                                   ; we only store the offset
0105               
0106                       ;------------------------------------------------------
0107                       ; Inject SAMS bank into high-nibble MSB of pointer
0108                       ;------------------------------------------------------
0109 7B2A C1A0  34         mov   @parm3,tmp2
     7B2C 8354 
0110 7B2E 1300  14         jeq   idx.entry.update.save ; Skip for SAMS bank 0
0111               
0112                       ; <still to do>
0113               
0114                       ;------------------------------------------------------
0115                       ; Update index slot
0116                       ;------------------------------------------------------
0117               idx.entry.update.save:
0118 7B30 0A14  56         sla   tmp0,1                ; line number * 2
0119 7B32 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     7B34 3000 
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               idx.entry.update.exit:
0124 7B36 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7B38 8360 
0125 7B3A 045B  20         b     *r11                  ; Return
0126               
0127               
0128               ***************************************************************
0129               * idx.entry.delete
0130               * Delete index entry - Close gap created by delete
0131               ***************************************************************
0132               * bl @idx.entry.delete
0133               *--------------------------------------------------------------
0134               * INPUT
0135               * @parm1    = Line number in editor buffer to delete
0136               * @parm2    = Line number of last line to check for reorg
0137               *--------------------------------------------------------------
0138               * OUTPUT
0139               * @outparm1 = Pointer to deleted line (for undo)
0140               *--------------------------------------------------------------
0141               * Register usage
0142               * tmp0,tmp2
0143               *--------------------------------------------------------------
0144               idx.entry.delete:
0145 7B3C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7B3E 8350 
0146                       ;------------------------------------------------------
0147                       ; Calculate address of index entry and save pointer
0148                       ;------------------------------------------------------
0149 7B40 0A14  56         sla   tmp0,1                ; line number * 2
0150 7B42 C824  54         mov   @idx.top(tmp0),@outparm1
     7B44 3000 
     7B46 8360 
0151                                                   ; Pointer to deleted line
0152                       ;------------------------------------------------------
0153                       ; Prepare for index reorg
0154                       ;------------------------------------------------------
0155 7B48 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7B4A 8352 
0156 7B4C 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7B4E 8350 
0157 7B50 1603  14         jne   idx.entry.delete.reorg
0158                       ;------------------------------------------------------
0159                       ; Special treatment if last line
0160                       ;------------------------------------------------------
0161 7B52 04E4  34         clr   @idx.top(tmp0)
     7B54 3000 
0162 7B56 1006  14         jmp   idx.entry.delete.exit
0163                       ;------------------------------------------------------
0164                       ; Reorganize index entries
0165                       ;------------------------------------------------------
0166               idx.entry.delete.reorg:
0167 7B58 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7B5A 3002 
     7B5C 3000 
0168 7B5E 05C4  14         inct  tmp0                  ; Next index entry
0169 7B60 0606  14         dec   tmp2                  ; tmp2--
0170 7B62 16FA  14         jne   idx.entry.delete.reorg
0171                                                   ; Loop unless completed
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               idx.entry.delete.exit:
0176 7B64 045B  20         b     *r11                  ; Return
0177               
0178               
0179               ***************************************************************
0180               * idx.entry.insert
0181               * Insert index entry
0182               ***************************************************************
0183               * bl @idx.entry.insert
0184               *--------------------------------------------------------------
0185               * INPUT
0186               * @parm1    = Line number in editor buffer to insert
0187               * @parm2    = Line number of last line to check for reorg
0188               *--------------------------------------------------------------
0189               * OUTPUT
0190               * NONE
0191               *--------------------------------------------------------------
0192               * Register usage
0193               * tmp0,tmp2
0194               *--------------------------------------------------------------
0195               idx.entry.insert:
0196 7B66 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7B68 8352 
0197                       ;------------------------------------------------------
0198                       ; Calculate address of index entry and save pointer
0199                       ;------------------------------------------------------
0200 7B6A 0A14  56         sla   tmp0,1                ; line number * 2
0201                       ;------------------------------------------------------
0202                       ; Prepare for index reorg
0203                       ;------------------------------------------------------
0204 7B6C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7B6E 8352 
0205 7B70 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7B72 8350 
0206 7B74 1606  14         jne   idx.entry.insert.reorg
0207                       ;------------------------------------------------------
0208                       ; Special treatment if last line
0209                       ;------------------------------------------------------
0210 7B76 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7B78 3000 
     7B7A 3002 
0211 7B7C 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     7B7E 3000 
0212 7B80 1009  14         jmp   idx.entry.insert.$$
0213                       ;------------------------------------------------------
0214                       ; Reorganize index entries
0215                       ;------------------------------------------------------
0216               idx.entry.insert.reorg:
0217 7B82 05C6  14         inct  tmp2                  ; Adjust one time
0218 7B84 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7B86 3000 
     7B88 3002 
0219 7B8A 0644  14         dect  tmp0                  ; Previous index entry
0220 7B8C 0606  14         dec   tmp2                  ; tmp2--
0221 7B8E 16FA  14         jne   -!                    ; Loop unless completed
0222               
0223 7B90 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     7B92 3004 
0224                       ;------------------------------------------------------
0225                       ; Exit
0226                       ;------------------------------------------------------
0227               idx.entry.insert.$$:
0228 7B94 045B  20         b     *r11                  ; Return
0229               
0230               
0231               
0232               ***************************************************************
0233               * idx.pointer.get
0234               * Get pointer to editor buffer line content
0235               ***************************************************************
0236               * bl @idx.pointer.get
0237               *--------------------------------------------------------------
0238               * INPUT
0239               * @parm1 = Line number in editor buffer
0240               *--------------------------------------------------------------
0241               * OUTPUT
0242               * @outparm1 = Pointer to editor buffer line content
0243               * @outparm2 = SAMS bank (>0 - >a)
0244               *--------------------------------------------------------------
0245               * Register usage
0246               * tmp0,tmp1,tmp2
0247               *--------------------------------------------------------------
0248               idx.pointer.get:
0249 7B96 0649  14         dect  stack
0250 7B98 C64B  30         mov   r11,*stack            ; Save return address
0251                       ;------------------------------------------------------
0252                       ; Get pointer
0253                       ;------------------------------------------------------
0254 7B9A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7B9C 8350 
0255                       ;------------------------------------------------------
0256                       ; Calculate index entry
0257                       ;------------------------------------------------------
0258 7B9E 0A14  56         sla   tmp0,1                ; line number * 2
0259 7BA0 C164  34         mov   @idx.top(tmp0),tmp1   ; Get offset
     7BA2 3000 
0260                       ;------------------------------------------------------
0261                       ; Get SAMS bank
0262                       ;------------------------------------------------------
0263 7BA4 C185  18         mov   tmp1,tmp2
0264 7BA6 09C6  56         srl   tmp2,12               ; Remove offset part
0265               
0266 7BA8 0286  22         ci    tmp2,5                ; SAMS bank 0
     7BAA 0005 
0267 7BAC 1205  14         jle   idx.pointer.get.samsbank0
0268               
0269 7BAE 0226  22         ai    tmp2,-5               ; Get SAMS bank
     7BB0 FFFB 
0270 7BB2 C806  38         mov   tmp2,@outparm2        ; Return SAMS bank
     7BB4 8362 
0271 7BB6 1002  14         jmp   idx.pointer.get.addbase
0272                       ;------------------------------------------------------
0273                       ; SAMS Bank 0 (or only 32K memory expansion)
0274                       ;------------------------------------------------------
0275               idx.pointer.get.samsbank0:
0276 7BB8 04E0  34         clr   @outparm2             ; SAMS bank 0
     7BBA 8362 
0277                       ;------------------------------------------------------
0278                       ; Add base
0279                       ;------------------------------------------------------
0280               idx.pointer.get.addbase:
0281 7BBC 0225  22         ai    tmp1,edb.top          ; Add base of editor buffer
     7BBE A000 
0282 7BC0 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7BC2 8360 
0283                       ;------------------------------------------------------
0284                       ; Exit
0285                       ;------------------------------------------------------
0286               idx.pointer.get.exit:
0287 7BC4 0460  28         b     @poprt                ; Return to caller
     7BC6 612E 
**** **** ****     > tivi.asm.2048
0608               
0609               
0610               ***************************************************************
0611               *               edb - Editor Buffer module
0612               ***************************************************************
0613                       copy  "editorbuffer.asm"
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
0026 7BC8 0649  14         dect  stack
0027 7BCA C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7BCC 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7BCE A002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 7BD0 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7BD2 2300 
0035 7BD4 C804  38         mov   tmp0,@edb.next_free.ptr
     7BD6 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 7BD8 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7BDA 230C 
0038 7BDC 04E0  34         clr   @edb.lines            ; Lines=0
     7BDE 2304 
0039 7BE0 04E0  34         clr   @edb.rle              ; RLE compression off
     7BE2 230E 
0040               
0041               edb.init.exit:
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045 7BE4 0460  28         b     @poprt                ; Return to caller
     7BE6 612E 
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
0070               ********@*****@*********************@**************************
0071               edb.line.pack:
0072 7BE8 0649  14         dect  stack
0073 7BEA C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Get values
0076                       ;------------------------------------------------------
0077 7BEC C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7BEE 220C 
     7BF0 8390 
0078 7BF2 04E0  34         clr   @fb.column
     7BF4 220C 
0079 7BF6 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7BF8 7A74 
0080                       ;------------------------------------------------------
0081                       ; Prepare scan
0082                       ;------------------------------------------------------
0083 7BFA 04C4  14         clr   tmp0                  ; Counter
0084 7BFC C160  34         mov   @fb.current,tmp1      ; Get position
     7BFE 2202 
0085 7C00 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7C02 8392 
0086               
0087                       ;------------------------------------------------------
0088                       ; Scan line for >00 byte termination
0089                       ;------------------------------------------------------
0090               edb.line.pack.scan:
0091 7C04 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0092 7C06 0986  56         srl   tmp2,8                ; Right justify
0093 7C08 1302  14         jeq   edb.line.pack.checklength
0094                                                   ; Stop scan if >00 found
0095 7C0A 0584  14         inc   tmp0                  ; Increase string length
0096 7C0C 10FB  14         jmp   edb.line.pack.scan    ; Next character
0097               
0098                       ;------------------------------------------------------
0099                       ; Handle line placement depending on length
0100                       ;------------------------------------------------------
0101               edb.line.pack.checklength:
0102 7C0E C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7C10 2204 
     7C12 8350 
0103 7C14 A820  54         a     @fb.row,@parm1        ; /
     7C16 2206 
     7C18 8350 
0104               
0105 7C1A C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7C1C 8394 
0106               
0107                       ;------------------------------------------------------
0108                       ; 1. Update index
0109                       ;------------------------------------------------------
0110               edb.line.pack.update_index:
0111 7C1E C820  54         mov   @edb.next_free.ptr,@parm2
     7C20 2308 
     7C22 8352 
0112                                                   ; Block where line will reside
0113               
0114 7C24 04E0  34         clr   @parm3                ; SAMS bank
     7C26 8354 
0115 7C28 06A0  32         bl    @idx.entry.update     ; Update index
     7C2A 7B1C 
0116                                                   ; \ .  parm1 = Line number in editor buffer
0117                                                   ; | .  parm2 = pointer to line in editor buffer
0118                                                   ; / .  parm3 = SAMS bank (0-A)
0119               
0120                       ;------------------------------------------------------
0121                       ; 2. Set line prefix in editor buffer
0122                       ;------------------------------------------------------
0123 7C2C C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7C2E 8392 
0124 7C30 C160  34         mov   @edb.next_free.ptr,tmp1
     7C32 2308 
0125                                                   ; Address of line in editor buffer
0126               
0127 7C34 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     7C36 2308 
0128               
0129 7C38 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     7C3A 8394 
0130 7C3C CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0131 7C3E 1316  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0132               
0133                       ;------------------------------------------------------
0134                       ; 3. Copy line from framebuffer to editor buffer
0135                       ;------------------------------------------------------
0136               edb.line.pack.copyline:
0137 7C40 0286  22         ci    tmp2,2
     7C42 0002 
0138 7C44 1602  14         jne   edb.line.pack.copyline.checkbyte
0139 7C46 C554  38         mov   *tmp0,*tmp1           ; Copy single word
0140 7C48 1007  14         jmp   !
0141               
0142               edb.line.pack.copyline.checkbyte:
0143 7C4A 0286  22         ci    tmp2,1
     7C4C 0001 
0144 7C4E 1602  14         jne   edb.line.pack.copyline.block
0145 7C50 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0146 7C52 1002  14         jmp   !
0147               
0148               edb.line.pack.copyline.block:
0149 7C54 06A0  32         bl    @xpym2m               ; Copy memory block
     7C56 6382 
0150                                                   ;   tmp0 = source
0151                                                   ;   tmp1 = destination
0152                                                   ;   tmp2 = bytes to copy
0153               
0154                       ;------------------------------------------------------
0155                       ; 4. Update pointer to next free line, assure it is even
0156                       ;------------------------------------------------------
0157 7C58 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     7C5A 8394 
     7C5C 2308 
0158                                                   ; Update pointer to next free block
0159               
0160 7C5E C120  34         mov   @edb.next_free.ptr,tmp0
     7C60 2308 
0161 7C62 0244  22         andi  tmp0,1                ; Uneven ?
     7C64 0001 
0162 7C66 1302  14         jeq   edb.line.pack.exit    ; Exit if even
0163 7C68 05A0  34         inc   @edb.next_free.ptr    ; Make it even
     7C6A 2308 
0164                       ;------------------------------------------------------
0165                       ; Exit
0166                       ;------------------------------------------------------
0167               edb.line.pack.exit:
0168 7C6C C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7C6E 8390 
     7C70 220C 
0169 7C72 0460  28         b     @poprt                ; Return to caller
     7C74 612E 
0170               
0171               
0172               
0173               
0174               ***************************************************************
0175               * edb.line.unpack
0176               * Unpack specified line to framebuffer
0177               ***************************************************************
0178               *  bl   @edb.line.unpack
0179               *--------------------------------------------------------------
0180               * INPUT
0181               * @parm1 = Line to unpack from editor buffer
0182               * @parm2 = Target row in frame buffer
0183               *--------------------------------------------------------------
0184               * OUTPUT
0185               * none
0186               *--------------------------------------------------------------
0187               * Register usage
0188               * tmp0,tmp1,tmp2,tmp3
0189               *--------------------------------------------------------------
0190               * Memory usage
0191               * rambuf    = Saved @parm1 of edb.line.unpack
0192               * rambuf+2  = Saved @parm2 of edb.line.unpack
0193               * rambuf+4  = Source memory address in editor buffer
0194               * rambuf+6  = Destination memory address in frame buffer
0195               * rambuf+8  = Length of RLE (decompressed) line
0196               * rambuf+10 = Length of RLE compressed line
0197               ********@*****@*********************@**************************
0198               edb.line.unpack:
0199 7C76 0649  14         dect  stack
0200 7C78 C64B  30         mov   r11,*stack            ; Save return address
0201                       ;------------------------------------------------------
0202                       ; Save parameters
0203                       ;------------------------------------------------------
0204 7C7A C820  54         mov   @parm1,@rambuf
     7C7C 8350 
     7C7E 8390 
0205 7C80 C820  54         mov   @parm2,@rambuf+2
     7C82 8352 
     7C84 8392 
0206                       ;------------------------------------------------------
0207                       ; Calculate offset in frame buffer
0208                       ;------------------------------------------------------
0209 7C86 C120  34         mov   @fb.colsline,tmp0
     7C88 220E 
0210 7C8A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7C8C 8352 
0211 7C8E C1A0  34         mov   @fb.top.ptr,tmp2
     7C90 2200 
0212 7C92 A146  18         a     tmp2,tmp1             ; Add base to offset
0213 7C94 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7C96 8396 
0214                       ;------------------------------------------------------
0215                       ; Get length of line to unpack
0216                       ;------------------------------------------------------
0217 7C98 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7C9A 7CF6 
0218                                                   ; \ .  parm1    = Line number
0219                                                   ; | o  outparm1 = Line length (uncompressed)
0220                                                   ; | o  outparm2 = Line length (compressed)
0221                                                   ; / o  outparm3 = SAMS bank (>0 - >a)
0222               
0223 7C9C C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7C9E 8362 
     7CA0 839A 
0224 7CA2 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7CA4 8360 
     7CA6 8398 
0225 7CA8 1307  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0226               
0227                       ;------------------------------------------------------
0228                       ; Index. Calculate address of entry and get pointer
0229                       ;------------------------------------------------------
0230 7CAA 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7CAC 7B96 
0231                                                   ; \ .  parm1    = Line number
0232                                                   ; | o  outparm1 = Pointer to line
0233                                                   ; / o  outparm2 = SAMS bank
0234               
0235 7CAE 05E0  34         inct  @outparm1             ; Skip line prefix
     7CB0 8360 
0236 7CB2 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7CB4 8360 
     7CB6 8394 
0237               
0238                       ;------------------------------------------------------
0239                       ; Erase chars from last column until column 80
0240                       ;------------------------------------------------------
0241               edb.line.unpack.clear:
0242 7CB8 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7CBA 8396 
0243 7CBC A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7CBE 8398 
0244               
0245 7CC0 04C5  14         clr   tmp1                  ; Fill with >00
0246 7CC2 C1A0  34         mov   @fb.colsline,tmp2
     7CC4 220E 
0247 7CC6 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7CC8 8398 
0248 7CCA 0586  14         inc   tmp2
0249               
0250 7CCC 06A0  32         bl    @xfilm                ; Fill CPU memory
     7CCE 6138 
0251                                                   ; \ .  tmp0 = Target address
0252                                                   ; | .  tmp1 = Byte to fill
0253                                                   ; / .  tmp2 = Repeat count
0254               
0255                       ;------------------------------------------------------
0256                       ; Prepare for unpacking data
0257                       ;------------------------------------------------------
0258               edb.line.unpack.prepare:
0259 7CD0 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     7CD2 8398 
0260 7CD4 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0261 7CD6 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7CD8 8394 
0262 7CDA C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7CDC 8396 
0263                       ;------------------------------------------------------
0264                       ; Either RLE decompress or do normal memory copy
0265                       ;------------------------------------------------------
0266 7CDE C1E0  34         mov   @edb.rle,tmp3
     7CE0 230E 
0267 7CE2 1305  14         jeq   edb.line.unpack.copy.uncompressed
0268                       ;------------------------------------------------------
0269                       ; Uncompress RLE line to frame buffer
0270                       ;------------------------------------------------------
0271 7CE4 C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     7CE6 839A 
0272               
0273 7CE8 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     7CEA 6860 
0274                                                   ; \ .  tmp0 = ROM/RAM source address
0275                                                   ; | .  tmp1 = RAM target address
0276                                                   ; / .  tmp2 = Length of RLE encoded data
0277 7CEC 1002  14         jmp   edb.line.unpack.exit
0278               
0279               edb.line.unpack.copy.uncompressed:
0280                       ;------------------------------------------------------
0281                       ; Copy memory block
0282                       ;------------------------------------------------------
0283 7CEE 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7CF0 6382 
0284                                                   ; \ .  tmp0 = Source address
0285                                                   ; | .  tmp1 = Target address
0286                                                   ; / .  tmp2 = Bytes to copy
0287                       ;------------------------------------------------------
0288                       ; Exit
0289                       ;------------------------------------------------------
0290               edb.line.unpack.exit:
0291 7CF2 0460  28         b     @poprt                ; Return to caller
     7CF4 612E 
0292               
0293               
0294               
0295               
0296               ***************************************************************
0297               * edb.line.getlength
0298               * Get length of specified line
0299               ***************************************************************
0300               *  bl   @edb.line.getlength
0301               *--------------------------------------------------------------
0302               * INPUT
0303               * @parm1 = Line number
0304               *--------------------------------------------------------------
0305               * OUTPUT
0306               * @outparm1 = Length of line (uncompressed)
0307               * @outparm2 = Length of line (compressed)
0308               * @outparm3 = SAMS bank (>0 - >a)
0309               *--------------------------------------------------------------
0310               * Register usage
0311               * tmp0,tmp1,tmp2
0312               ********@*****@*********************@**************************
0313               edb.line.getlength:
0314 7CF6 0649  14         dect  stack
0315 7CF8 C64B  30         mov   r11,*stack            ; Save return address
0316                       ;------------------------------------------------------
0317                       ; Initialisation
0318                       ;------------------------------------------------------
0319 7CFA 04E0  34         clr   @outparm1             ; Reset uncompressed length
     7CFC 8360 
0320 7CFE 04E0  34         clr   @outparm2             ; Reset compressed length
     7D00 8362 
0321 7D02 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7D04 8364 
0322                       ;------------------------------------------------------
0323                       ; Get length
0324                       ;------------------------------------------------------
0325 7D06 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7D08 7B96 
0326                                                   ; \  parm1    = Line number
0327                                                   ; |  outparm1 = Pointer to line
0328                                                   ; /  outparm2 = SAMS bank
0329               
0330 7D0A C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     7D0C 8360 
0331 7D0E 130D  14         jeq   edb.line.getlength.exit
0332                                                   ; Exit early if NULL pointer
0333 7D10 C820  54         mov   @outparm2,@outparm3   ; Save SAMS bank
     7D12 8362 
     7D14 8364 
0334                       ;------------------------------------------------------
0335                       ; Process line prefix
0336                       ;------------------------------------------------------
0337 7D16 04C5  14         clr   tmp1
0338 7D18 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0339 7D1A 06C5  14         swpb  tmp1
0340 7D1C C805  38         mov   tmp1,@outparm2        ; Save length
     7D1E 8362 
0341               
0342 7D20 04C5  14         clr   tmp1
0343 7D22 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0344 7D24 06C5  14         swpb  tmp1
0345 7D26 C805  38         mov   tmp1,@outparm1        ; Save length
     7D28 8360 
0346                       ;------------------------------------------------------
0347                       ; Exit
0348                       ;------------------------------------------------------
0349               edb.line.getlength.exit:
0350 7D2A 0460  28         b     @poprt                ; Return to caller
     7D2C 612E 
0351               
0352               
0353               
0354               
0355               ***************************************************************
0356               * edb.line.getlength2
0357               * Get length of current row (as seen from editor buffer side)
0358               ***************************************************************
0359               *  bl   @edb.line.getlength2
0360               *--------------------------------------------------------------
0361               * INPUT
0362               * @fb.row = Row in frame buffer
0363               *--------------------------------------------------------------
0364               * OUTPUT
0365               * @fb.row.length = Length of row
0366               *--------------------------------------------------------------
0367               * Register usage
0368               * tmp0,tmp1
0369               ********@*****@*********************@**************************
0370               edb.line.getlength2:
0371 7D2E 0649  14         dect  stack
0372 7D30 C64B  30         mov   r11,*stack            ; Save return address
0373                       ;------------------------------------------------------
0374                       ; Get length
0375                       ;------------------------------------------------------
0376 7D32 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7D34 220C 
     7D36 8390 
0377 7D38 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7D3A 2204 
0378 7D3C A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7D3E 2206 
0379 7D40 0A24  56         sla   tmp0,2                ; Line number * 4
0380 7D42 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7D44 3002 
0381 7D46 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7D48 00FF 
0382 7D4A C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7D4C 2208 
0383                       ;------------------------------------------------------
0384                       ; Exit
0385                       ;------------------------------------------------------
0386               edb.line.getlength2.exit:
0387 7D4E 0460  28         b     @poprt                ; Return to caller
     7D50 612E 
0388               
**** **** ****     > tivi.asm.2048
0614               
0615               
0616               ***************************************************************
0617               *               fh - File handling module
0618               ***************************************************************
0619                       copy  "filehandler.asm"
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
0026               ********@*****@*********************@**************************
0027               tfh.file.read:
0028 7D52 0649  14         dect  stack
0029 7D54 C64B  30         mov   r11,*stack            ; Save return address
0030 7D56 C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     7D58 8352 
     7D5A 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 7D5C 04E0  34         clr   @tfh.records          ; Reset records counter
     7D5E 242E 
0035 7D60 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7D62 2434 
0036 7D64 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7D66 2432 
0037 7D68 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 7D6A 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7D6C 242A 
0039 7D6E 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7D70 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 7D72 06A0  32         bl    @hchar
     7D74 6512 
0044 7D76 1D00                   byte 29,0,32,80
     7D78 2050 
0045 7D7A FFFF                   data EOL
0046               
0047 7D7C 06A0  32         bl    @putat
     7D7E 632C 
0048 7D80 1D00                   byte 29,0
0049 7D82 7F94                   data txt_loading      ; Display "Loading...."
0050               
0051 7D84 8820  54         c     @tfh.rleonload,@w$ffff
     7D86 2436 
     7D88 6048 
0052 7D8A 1604  14         jne   !
0053 7D8C 06A0  32         bl    @putat
     7D8E 632C 
0054 7D90 1D44                   byte 29,68
0055 7D92 7FA4                   data txt_rle          ; Display "RLE"
0056               
0057 7D94 06A0  32 !       bl    @at
     7D96 641E 
0058 7D98 1D0B                   byte 29,11            ; Cursor YX position
0059 7D9A C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7D9C 8350 
0060 7D9E 06A0  32         bl    @xutst0               ; Display device/filename
     7DA0 631C 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 7DA2 06A0  32         bl    @cpym2v
     7DA4 6334 
0065 7DA6 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7DA8 7F56 
     7DAA 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 7DAC 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7DAE 0A69 
0071 7DB0 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7DB2 8350 
0072 7DB4 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 7DB6 0986  56         srl   tmp2,8                ; Right justify
0074 7DB8 0586  14         inc   tmp2                  ; Include length byte as well
0075 7DBA 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7DBC 633A 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 7DBE 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7DC0 6EAE 
0080 7DC2 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 7DC4 06A0  32         bl    @file.open
     7DC6 6FFC 
0085 7DC8 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 7DCA 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7DCC 6042 
0087 7DCE 1602  14         jne   tfh.file.read.record
0088 7DD0 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7DD2 7F0A 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 7DD4 05A0  34         inc   @tfh.records          ; Update counter
     7DD6 242E 
0094 7DD8 04E0  34         clr   @tfh.reclen           ; Reset record length
     7DDA 2430 
0095               
0096 7DDC 06A0  32         bl    @file.record.read     ; Read file record
     7DDE 703E 
0097 7DE0 0A60                   data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
0098                                                   ; | o  tmp0 = Status byte
0099                                                   ; | o  tmp1 = Bytes read
0100                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0101               
0102 7DE2 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7DE4 242A 
0103 7DE6 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7DE8 2430 
0104 7DEA C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7DEC 242C 
0105                       ;------------------------------------------------------
0106                       ; 1a: Calculate kilobytes processed
0107                       ;------------------------------------------------------
0108 7DEE A805  38         a     tmp1,@tfh.counter
     7DF0 2434 
0109 7DF2 A160  34         a     @tfh.counter,tmp1
     7DF4 2434 
0110 7DF6 0285  22         ci    tmp1,1024
     7DF8 0400 
0111 7DFA 1106  14         jlt   !
0112 7DFC 05A0  34         inc   @tfh.kilobytes
     7DFE 2432 
0113 7E00 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7E02 FC00 
0114 7E04 C805  38         mov   tmp1,@tfh.counter
     7E06 2434 
0115                       ;------------------------------------------------------
0116                       ; 1b: Load spectra scratchpad layout
0117                       ;------------------------------------------------------
0118 7E08 06A0  32 !       bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7E0A 68AA 
0119 7E0C 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7E0E 6ED0 
0120 7E10 2100                   data scrpad.backup2   ; / >2100->8300
0121                       ;------------------------------------------------------
0122                       ; 1c: Check if a file error occured
0123                       ;------------------------------------------------------
0124               tfh.file.read.check:
0125 7E12 C1A0  34         mov   @tfh.ioresult,tmp2
     7E14 242C 
0126 7E16 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7E18 6042 
0127 7E1A 1377  14         jeq   tfh.file.read.error
0128                                                   ; Yes, so handle file error
0129                       ;------------------------------------------------------
0130                       ; 1d: Decide on copy line from VDP buffer to editor
0131                       ;     buffer (RLE off) or RAM buffer (RLE on)
0132                       ;------------------------------------------------------
0133 7E1C 8820  54         c     @tfh.rleonload,@w$ffff
     7E1E 2436 
     7E20 6048 
0134                                                   ; RLE compression on?
0135 7E22 1314  14         jeq   tfh.file.read.compression
0136                                                   ; Yes, do RLE compression
0137                       ;------------------------------------------------------
0138                       ; Step 2: Process line without doing RLE compression
0139                       ;------------------------------------------------------
0140               tfh.file.read.nocompression:
0141 7E24 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7E26 0960 
0142 7E28 C160  34         mov   @edb.next_free.ptr,tmp1
     7E2A 2308 
0143                                                   ; RAM target in editor buffer
0144               
0145 7E2C C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7E2E 8352 
0146               
0147 7E30 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7E32 2430 
0148 7E34 1337  14         jeq   tfh.file.read.prepindex.emptyline
0149                                                   ; Handle empty line
0150                       ;------------------------------------------------------
0151                       ; 2a: Copy line from VDP to CPU editor buffer
0152                       ;------------------------------------------------------
0153                                                   ; Save line prefix
0154 7E36 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0155 7E38 06C6  14         swpb  tmp2                  ; |
0156 7E3A DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0157 7E3C 06C6  14         swpb  tmp2                  ; /
0158               
0159 7E3E 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7E40 2308 
0160 7E42 A806  38         a     tmp2,@edb.next_free.ptr
     7E44 2308 
0161                                                   ; Add line length
0162               
0163 7E46 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7E48 6360 
0164                                                   ; \ .  tmp0 = VDP source address
0165                                                   ; | .  tmp1 = RAM target address
0166                                                   ; / .  tmp2 = Bytes to copy
0167               
0168 7E4A 1028  14         jmp   tfh.file.read.prepindex
0169                                                   ; Prepare for updating index
0170                       ;------------------------------------------------------
0171                       ; Step 3: Process line and do RLE compression
0172                       ;------------------------------------------------------
0173               tfh.file.read.compression:
0174 7E4C 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7E4E 0960 
0175 7E50 0205  20         li    tmp1,fb.top           ; RAM target address
     7E52 2650 
0176 7E54 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7E56 2430 
0177 7E58 1325  14         jeq   tfh.file.read.prepindex.emptyline
0178                                                   ; Handle empty line
0179               
0180 7E5A 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7E5C 6360 
0181                                                   ; \ .  tmp0 = VDP source address
0182                                                   ; | .  tmp1 = RAM target address
0183                                                   ; / .  tmp2 = Bytes to copy
0184               
0185                       ;------------------------------------------------------
0186                       ; 3a: RLE compression on line
0187                       ;------------------------------------------------------
0188 7E5E 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     7E60 2650 
0189 7E62 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     7E64 26F0 
0190 7E66 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     7E68 2430 
0191               
0192 7E6A 06A0  32         bl    @xcpu2rle             ; RLE compression
     7E6C 67AE 
0193                                                   ; \ .  tmp0  = ROM/RAM source address
0194                                                   ; | .  tmp1  = RAM target address
0195                                                   ; | .  tmp2  = Length uncompressed data
0196                                                   ; / o  waux1 = Length RLE encoded string
0197                       ;------------------------------------------------------
0198                       ; 3b: Set line prefix
0199                       ;------------------------------------------------------
0200 7E6E C160  34         mov   @edb.next_free.ptr,tmp1
     7E70 2308 
0201                                                   ; RAM target address
0202 7E72 C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     7E74 8352 
0203 7E76 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7E78 833C 
0204 7E7A 06C6  14         swpb  tmp2                  ;
0205 7E7C DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0206               
0207 7E7E C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     7E80 2430 
0208 7E82 06C6  14         swpb  tmp2
0209 7E84 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0210 7E86 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     7E88 2308 
0211                       ;------------------------------------------------------
0212                       ; 3c: Copy compressed line to editor buffer
0213                       ;------------------------------------------------------
0214 7E8A 0204  20         li    tmp0,fb.top+160       ; RAM source address
     7E8C 26F0 
0215 7E8E C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7E90 833C 
0216               
0217 7E92 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7E94 6382 
0218                                                   ; \ .  tmp0 = RAM source address
0219                                                   ; | .  tmp1 = RAM target address
0220                                                   ; / .  tmp2 = Bytes to copy
0221               
0222 7E96 A820  54         a     @waux1,@edb.next_free.ptr
     7E98 833C 
     7E9A 2308 
0223                                                   ; Update pointer to next free line
0224                       ;------------------------------------------------------
0225                       ; Step 4: Update index
0226                       ;------------------------------------------------------
0227               tfh.file.read.prepindex:
0228 7E9C C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7E9E 2304 
     7EA0 8350 
0229                                                   ; parm2 = Must allready be set!
0230 7EA2 1007  14         jmp   tfh.file.read.updindex
0231                                                   ; Update index
0232                       ;------------------------------------------------------
0233                       ; 4a: Special handling for empty line
0234                       ;------------------------------------------------------
0235               tfh.file.read.prepindex.emptyline:
0236 7EA4 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7EA6 242E 
     7EA8 8350 
0237 7EAA 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7EAC 8350 
0238 7EAE 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7EB0 8352 
0239                       ;------------------------------------------------------
0240                       ; 4b: Do actual index update
0241                       ;------------------------------------------------------
0242               tfh.file.read.updindex:
0243 7EB2 04E0  34         clr   @parm3
     7EB4 8354 
0244 7EB6 06A0  32         bl    @idx.entry.update     ; Update index
     7EB8 7B1C 
0245                                                   ; \ .  parm1    = Line number in editor buffer
0246                                                   ; | .  parm2    = Pointer to line in editor buffer
0247                                                   ; | .  parm3    = SAMS bank (0-A)
0248                                                   ; / o  outparm1 = Pointer to updated index entry
0249               
0250 7EBA 05A0  34         inc   @edb.lines            ; lines=lines+1
     7EBC 2304 
0251                       ;------------------------------------------------------
0252                       ; Step 5: Display results
0253                       ;------------------------------------------------------
0254               tfh.file.read.display:
0255 7EBE 06A0  32         bl    @putnum
     7EC0 679E 
0256 7EC2 1D49                   byte 29,73            ; Show lines read
0257 7EC4 2304                   data edb.lines,rambuf,>3020
     7EC6 8390 
     7EC8 3020 
0258               
0259 7ECA 8220  34         c     @tfh.kilobytes,tmp4
     7ECC 2432 
0260 7ECE 130C  14         jeq   tfh.file.read.checkmem
0261               
0262 7ED0 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7ED2 2432 
0263               
0264 7ED4 06A0  32         bl    @putnum
     7ED6 679E 
0265 7ED8 1D38                   byte 29,56            ; Show kilobytes read
0266 7EDA 2432                   data tfh.kilobytes,rambuf,>3020
     7EDC 8390 
     7EDE 3020 
0267               
0268 7EE0 06A0  32         bl    @putat
     7EE2 632C 
0269 7EE4 1D3D                   byte 29,61
0270 7EE6 7FA0                   data txt_kb           ; Show "kb" string
0271               
0272               ******************************************************
0273               * Stop reading file if high memory expansion gets full
0274               ******************************************************
0275               tfh.file.read.checkmem:
0276 7EE8 C120  34         mov   @edb.next_free.ptr,tmp0
     7EEA 2308 
0277 7EEC 0284  22         ci    tmp0,>ffa0
     7EEE FFA0 
0278 7EF0 1207  14         jle   tfh.file.read.next
0279 7EF2 1015  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0280                       ;------------------------------------------------------
0281                       ; Next SAMS page
0282                       ;------------------------------------------------------
0283 7EF4 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7EF6 230A 
0284 7EF8 0204  20         li    tmp0,edb.top
     7EFA A000 
0285 7EFC C804  38         mov   tmp0,@edb.next_free.ptr
     7EFE 2308 
0286                                                   ; Reset to top of editor buffer
0287                       ;------------------------------------------------------
0288                       ; Next record
0289                       ;------------------------------------------------------
0290               tfh.file.read.next:
0291 7F00 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7F02 6EAE 
0292 7F04 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0293               
0294 7F06 0460  28         b     @tfh.file.read.record
     7F08 7DD4 
0295                                                   ; Next record
0296                       ;------------------------------------------------------
0297                       ; Error handler
0298                       ;------------------------------------------------------
0299               tfh.file.read.error:
0300 7F0A C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7F0C 242A 
0301 7F0E 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0302 7F10 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7F12 0005 
0303 7F14 1304  14         jeq   tfh.file.read.eof
0304                                                   ; All good. File closed by DSRLNK
0305                       ;------------------------------------------------------
0306                       ; File error occured
0307                       ;------------------------------------------------------
0308 7F16 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7F18 FFCE 
0309 7F1A 06A0  32         bl    @crash                ; / Crash and halt system
     7F1C 604C 
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               tfh.file.read.eof:
0314 7F1E 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7F20 6ED0 
0315 7F22 2100                   data scrpad.backup2   ; / >2100->8300
0316                       ;------------------------------------------------------
0317                       ; Display final results
0318                       ;------------------------------------------------------
0319 7F24 06A0  32         bl    @hchar
     7F26 6512 
0320 7F28 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7F2A 200A 
0321 7F2C FFFF                   data EOL
0322               
0323 7F2E 06A0  32         bl    @putnum
     7F30 679E 
0324 7F32 1D38                   byte 29,56            ; Show kilobytes read
0325 7F34 2432                   data tfh.kilobytes,rambuf,>3020
     7F36 8390 
     7F38 3020 
0326               
0327 7F3A 06A0  32         bl    @putat
     7F3C 632C 
0328 7F3E 1D3D                   byte 29,61
0329 7F40 7FA0                   data txt_kb           ; Show "kb" string
0330               
0331 7F42 06A0  32         bl    @putnum
     7F44 679E 
0332 7F46 1D49                   byte 29,73            ; Show lines read
0333 7F48 242E                   data tfh.records,rambuf,>3020
     7F4A 8390 
     7F4C 3020 
0334               
0335 7F4E 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7F50 2306 
0336               *--------------------------------------------------------------
0337               * Exit
0338               *--------------------------------------------------------------
0339               tfh.file.read_exit:
0340 7F52 0460  28         b     @poprt                ; Return to caller
     7F54 612E 
0341               
0342               
0343               ***************************************************************
0344               * PAB for accessing DV/80 file
0345               ********@*****@*********************@**************************
0346               tfh.file.pab.header:
0347 7F56 0014             byte  io.op.open            ;  0    - OPEN
0348                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0349 7F58 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0350 7F5A 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0351                       byte  00                    ;  5    - Character count
0352 7F5C 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0353 7F5E 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0354                       ;------------------------------------------------------
0355                       ; File descriptor part (variable length)
0356                       ;------------------------------------------------------
0357                       ; byte  12                  ;  9    - File descriptor length
0358                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.2048
0620               
0621               
0622               ***************************************************************
0623               *                      Constants
0624               ***************************************************************
0625               romsat:
0626 7F60 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7F62 000F 
0627               
0628               cursors:
0629 7F64 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7F66 0000 
     7F68 0000 
     7F6A 001C 
0630 7F6C 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7F6E 1010 
     7F70 1010 
     7F72 1000 
0631 7F74 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7F76 1C1C 
     7F78 1C1C 
     7F7A 1C00 
0632               
0633               ***************************************************************
0634               *                       Strings
0635               ***************************************************************
0636               txt_delim
0637 7F7C 012C             byte  1
0638 7F7D ....             text  ','
0639                       even
0640               
0641               txt_marker
0642 7F7E 052A             byte  5
0643 7F7F ....             text  '*EOF*'
0644                       even
0645               
0646               txt_bottom
0647 7F84 0520             byte  5
0648 7F85 ....             text  '  BOT'
0649                       even
0650               
0651               txt_ovrwrite
0652 7F8A 034F             byte  3
0653 7F8B ....             text  'OVR'
0654                       even
0655               
0656               txt_insert
0657 7F8E 0349             byte  3
0658 7F8F ....             text  'INS'
0659                       even
0660               
0661               txt_star
0662 7F92 012A             byte  1
0663 7F93 ....             text  '*'
0664                       even
0665               
0666               txt_loading
0667 7F94 0A4C             byte  10
0668 7F95 ....             text  'Loading...'
0669                       even
0670               
0671               txt_kb
0672 7FA0 026B             byte  2
0673 7FA1 ....             text  'kb'
0674                       even
0675               
0676               txt_rle
0677 7FA4 0352             byte  3
0678 7FA5 ....             text  'RLE'
0679                       even
0680               
0681               txt_lines
0682 7FA8 054C             byte  5
0683 7FA9 ....             text  'Lines'
0684                       even
0685               
0686 7FAE 7FAE     end          data    $
0687               
0688               
0689               fdname0
0690 7FB0 0D44             byte  13
0691 7FB1 ....             text  'DSK1.INVADERS'
0692                       even
0693               
0694               fdname1
0695 7FBE 0F44             byte  15
0696 7FBF ....             text  'DSK1.SPEECHDOCS'
0697                       even
0698               
0699               fdname2
0700 7FCE 0C44             byte  12
0701 7FCF ....             text  'DSK1.XBEADOC'
0702                       even
0703               
0704               fdname3
0705 7FDC 0C44             byte  12
0706 7FDD ....             text  'DSK3.XBEADOC'
0707                       even
0708               
0709               fdname4
0710 7FEA 0C44             byte  12
0711 7FEB ....             text  'DSK3.C99MAN1'
0712                       even
0713               
0714               fdname5
0715 7FF8 0C44             byte  12
0716 7FF9 ....             text  'DSK3.C99MAN2'
0717                       even
0718               
0719               fdname6
0720 8006 0C44             byte  12
0721 8007 ....             text  'DSK3.C99MAN3'
0722                       even
0723               
0724               fdname7
0725 8014 0D44             byte  13
0726 8015 ....             text  'DSK3.C99SPECS'
0727                       even
0728               
0729               fdname8
0730 8022 0D44             byte  13
0731 8023 ....             text  'DSK3.RANDOM#C'
0732                       even
0733               
0734               fdname9
0735 8030 0D44             byte  13
0736 8031 ....             text  'DSK1.INVADERS'
0737                       even
0738               

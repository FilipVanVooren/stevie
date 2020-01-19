XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.2093
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200119-2093
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
0074      0001     skip_cpu_hexsupport     equ  1      ; Skip mkhex, puthex
0075      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0076               *--------------------------------------------------------------
0077               * SPECTRA2 startup options
0078               *--------------------------------------------------------------
0079      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0080      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0081      00F4     spfclr                  equ  >f4    ; Foreground/Background color for font.
0082      0004     spfbck                  equ  >04    ; Screen background color.
0083               *--------------------------------------------------------------
0084               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0085               *--------------------------------------------------------------
0086               ;               equ  >8342          ; >8342-834F **free***
0087      8350     parm1           equ  >8350          ; Function parameter 1
0088      8352     parm2           equ  >8352          ; Function parameter 2
0089      8354     parm3           equ  >8354          ; Function parameter 3
0090      8356     parm4           equ  >8356          ; Function parameter 4
0091      8358     parm5           equ  >8358          ; Function parameter 5
0092      835A     parm6           equ  >835a          ; Function parameter 6
0093      835C     parm7           equ  >835c          ; Function parameter 7
0094      835E     parm8           equ  >835e          ; Function parameter 8
0095      8360     outparm1        equ  >8360          ; Function output parameter 1
0096      8362     outparm2        equ  >8362          ; Function output parameter 2
0097      8364     outparm3        equ  >8364          ; Function output parameter 3
0098      8366     outparm4        equ  >8366          ; Function output parameter 4
0099      8368     outparm5        equ  >8368          ; Function output parameter 5
0100      836A     outparm6        equ  >836a          ; Function output parameter 6
0101      836C     outparm7        equ  >836c          ; Function output parameter 7
0102      836E     outparm8        equ  >836e          ; Function output parameter 8
0103      8370     timers          equ  >8370          ; Timer table
0104      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0105      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0106               *--------------------------------------------------------------
0107               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0108               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0109               *--------------------------------------------------------------
0110      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0111      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0112               *--------------------------------------------------------------
0113               * Frame buffer structure            @>2200-22ff     (256 bytes)
0114               *--------------------------------------------------------------
0115      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0116      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0117      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0118      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0119      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0120      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0121      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0122      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0123      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0124      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0125      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0126      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0127      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0128      221A     fb.end          equ  fb.top.ptr+26  ; Free from here on
0129               *--------------------------------------------------------------
0130               * Editor buffer structure           @>2300-23ff     (256 bytes)
0131               *--------------------------------------------------------------
0132      2300     edb.top.ptr         equ  >2300          ; Pointer to editor buffer
0133      2302     edb.index.ptr       equ  edb.top.ptr+2  ; Pointer to index
0134      2304     edb.lines           equ  edb.top.ptr+4  ; Total lines in editor buffer
0135      2306     edb.dirty           equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0136      2308     edb.next_free.ptr   equ  edb.top.ptr+8  ; Pointer to next free line
0137      230A     edb.next_free.page  equ  edb.top.ptr+10 ; SAMS page of next free line
0138      230C     edb.insmode         equ  edb.top.ptr+12 ; Editor insert mode (>0000 overwrite / >ffff insert)
0139      230E     edb.rle             equ  edb.top.ptr+14 ; RLE compression activated
0140      2310     edb.end             equ  edb.top.ptr+16 ; Free from here on
0141               *--------------------------------------------------------------
0142               * File handling structures          @>2400-24ff     (256 bytes)
0143               *--------------------------------------------------------------
0144      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0145      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0146      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0147      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB, required by level 2 FIO
0148      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0149      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0150      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0151      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0152      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0153      2434     tfh.counter     equ  tfh.top + 52   ; Internal counter used in TiVi file operations
0154      2436     tfh.rleonload   equ  tfh.top + 54   ; RLE compression needed during file load
0155      2438     tfh.membuffer   equ  tfh.top + 56   ; 80 bytes file memory buffer
0156      2488     tfh.end         equ  tfh.top + 136  ; Free from here on
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
0175               * Editor buffer                     @>a000-ffff   (24576 bytes)
0176               *--------------------------------------------------------------
0177      A000     edb.top         equ  >a000          ; Editor buffer high memory
0178      6000     edb.size        equ  24576          ; Editor buffer size
0179               *--------------------------------------------------------------
0180               
0181               
0182               
0183               *--------------------------------------------------------------
0184               * Cartridge header
0185               *--------------------------------------------------------------
0186                       save  >6000,>7fff
0187                       aorg  >6000
0188               
0189 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0190 6006 6010             data  prog0
0191 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0192 6010 0000     prog0   data  0                     ; No more items following
0193 6012 7074             data  runlib
0194               
0196               
0197 6014 1054             byte  16
0198 6015 ....             text  'TIVI 200119-2093'
0199                       even
0200               
0208               *--------------------------------------------------------------
0209               * Include required files
0210               *--------------------------------------------------------------
0211                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0086                       copy  "cpu_crash_handler.asm"    ; CPU program crashed handler
**** **** ****     > cpu_crash_handler.asm
0001               * FILE......: cpu_crash_handler.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *                      CRASH HANDLER
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * crash - CPU program crashed handler
0011               ***************************************************************
0012               *  bl   @crash_handler
0013               ********@*****@*********************@**************************
0014               crash_handler:
0015 604C C80B  38         mov   r11,@>fffe            ; Save address of where crash originated
     604E FFFE 
0016 6050 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6052 8300 
0017 6054 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6056 8302 
0018 6058 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     605A 4A4A 
0019 605C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     605E 707C 
0020               
0021               crash_handler.main:
0022 6060 06A0  32         bl    @putat                ; Show crash message
     6062 62C6 
0023 6064 0000             data  >0000,crash_handler.message
     6066 606C 
0024 6068 0460  28         b     @tmgr                 ; FNCTN-+ to quit
     606A 6F8A 
0025               
0026               crash_handler.message:
0027 606C 2553             byte  37
0028 606D ....             text  'System crashed. Press FNCTN-+ to quit'
0029               
0030               
**** **** ****     > runlib.asm
0087                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6092 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6094 000E 
     6096 0106 
     6098 0204 
     609A 0020 
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
0032 609C 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     609E 000E 
     60A0 0106 
     60A2 00F4 
     60A4 0028 
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
0058 60A6 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     60A8 003F 
     60AA 0240 
     60AC 03F4 
     60AE 0050 
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
0084 60B0 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     60B2 003F 
     60B4 0240 
     60B6 03F4 
     60B8 0050 
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
0013 60BA 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 60BC 16FD             data  >16fd                 ; |         jne   mcloop
0015 60BE 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 60C0 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 60C2 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 60C4 C0F9  30 popr3   mov   *stack+,r3
0039 60C6 C0B9  30 popr2   mov   *stack+,r2
0040 60C8 C079  30 popr1   mov   *stack+,r1
0041 60CA C039  30 popr0   mov   *stack+,r0
0042 60CC C2F9  30 poprt   mov   *stack+,r11
0043 60CE 045B  20         b     *r11
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
0067 60D0 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 60D2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 60D4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 60D6 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 60D8 1602  14         jne   filchk                ; No, continue checking
0075 60DA 06A0  32         bl    @crash_handler        ; Yes, crash
     60DC 604C 
0076               *--------------------------------------------------------------
0077               *       Check: 1 byte fill
0078               *--------------------------------------------------------------
0079 60DE D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60E0 830B 
     60E2 830A 
0080               
0081 60E4 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     60E6 0001 
0082 60E8 1602  14         jne   filchk2
0083 60EA DD05  32         movb  tmp1,*tmp0+
0084 60EC 045B  20         b     *r11                  ; Exit
0085               *--------------------------------------------------------------
0086               *       Check: 2 byte fill
0087               *--------------------------------------------------------------
0088 60EE 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     60F0 0002 
0089 60F2 1603  14         jne   filchk3
0090 60F4 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0091 60F6 DD05  32         movb  tmp1,*tmp0+
0092 60F8 045B  20         b     *r11                  ; Exit
0093               *--------------------------------------------------------------
0094               *       Check: Handle uneven start address
0095               *--------------------------------------------------------------
0096 60FA C1C4  18 filchk3 mov   tmp0,tmp3
0097 60FC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60FE 0001 
0098 6100 1605  14         jne   fil16b
0099 6102 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0100 6104 0606  14         dec   tmp2
0101 6106 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6108 0002 
0102 610A 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0103               *--------------------------------------------------------------
0104               *       Fill memory with 16 bit words
0105               *--------------------------------------------------------------
0106 610C C1C6  18 fil16b  mov   tmp2,tmp3
0107 610E 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6110 0001 
0108 6112 1301  14         jeq   dofill
0109 6114 0606  14         dec   tmp2                  ; Make TMP2 even
0110 6116 CD05  34 dofill  mov   tmp1,*tmp0+
0111 6118 0646  14         dect  tmp2
0112 611A 16FD  14         jne   dofill
0113               *--------------------------------------------------------------
0114               * Fill last byte if ODD
0115               *--------------------------------------------------------------
0116 611C C1C7  18         mov   tmp3,tmp3
0117 611E 1301  14         jeq   fil.$$
0118 6120 DD05  32         movb  tmp1,*tmp0+
0119 6122 045B  20 fil.$$  b     *r11
0120               
0121               
0122               ***************************************************************
0123               * FILV - Fill VRAM with byte
0124               ***************************************************************
0125               *  BL   @FILV
0126               *  DATA P0,P1,P2
0127               *--------------------------------------------------------------
0128               *  P0 = VDP start address
0129               *  P1 = Byte to fill
0130               *  P2 = Number of bytes to fill
0131               *--------------------------------------------------------------
0132               *  BL   @XFILV
0133               *
0134               *  TMP0 = VDP start address
0135               *  TMP1 = Byte to fill
0136               *  TMP2 = Number of bytes to fill
0137               ********@*****@*********************@**************************
0138 6124 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0139 6126 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0140 6128 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0141               *--------------------------------------------------------------
0142               *    Setup VDP write address
0143               *--------------------------------------------------------------
0144 612A 0264  22 xfilv   ori   tmp0,>4000
     612C 4000 
0145 612E 06C4  14         swpb  tmp0
0146 6130 D804  38         movb  tmp0,@vdpa
     6132 8C02 
0147 6134 06C4  14         swpb  tmp0
0148 6136 D804  38         movb  tmp0,@vdpa
     6138 8C02 
0149               *--------------------------------------------------------------
0150               *    Fill bytes in VDP memory
0151               *--------------------------------------------------------------
0152 613A 020F  20         li    r15,vdpw              ; Set VDP write address
     613C 8C00 
0153 613E 06C5  14         swpb  tmp1
0154 6140 C820  54         mov   @filzz,@mcloop        ; Setup move command
     6142 614A 
     6144 8320 
0155 6146 0460  28         b     @mcloop               ; Write data to VDP
     6148 8320 
0156               *--------------------------------------------------------------
0160 614A D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0162               
0163               
0164               
0165               *//////////////////////////////////////////////////////////////
0166               *                  VDP LOW LEVEL FUNCTIONS
0167               *//////////////////////////////////////////////////////////////
0168               
0169               ***************************************************************
0170               * VDWA / VDRA - Setup VDP write or read address
0171               ***************************************************************
0172               *  BL   @VDWA
0173               *
0174               *  TMP0 = VDP destination address for write
0175               *--------------------------------------------------------------
0176               *  BL   @VDRA
0177               *
0178               *  TMP0 = VDP source address for read
0179               ********@*****@*********************@**************************
0180 614C 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     614E 4000 
0181 6150 06C4  14 vdra    swpb  tmp0
0182 6152 D804  38         movb  tmp0,@vdpa
     6154 8C02 
0183 6156 06C4  14         swpb  tmp0
0184 6158 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     615A 8C02 
0185 615C 045B  20         b     *r11                  ; Exit
0186               
0187               ***************************************************************
0188               * VPUTB - VDP put single byte
0189               ***************************************************************
0190               *  BL @VPUTB
0191               *  DATA P0,P1
0192               *--------------------------------------------------------------
0193               *  P0 = VDP target address
0194               *  P1 = Byte to write
0195               ********@*****@*********************@**************************
0196 615E C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0197 6160 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0198               *--------------------------------------------------------------
0199               * Set VDP write address
0200               *--------------------------------------------------------------
0201 6162 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6164 4000 
0202 6166 06C4  14         swpb  tmp0                  ; \
0203 6168 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     616A 8C02 
0204 616C 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0205 616E D804  38         movb  tmp0,@vdpa            ; /
     6170 8C02 
0206               *--------------------------------------------------------------
0207               * Write byte
0208               *--------------------------------------------------------------
0209 6172 06C5  14         swpb  tmp1                  ; LSB to MSB
0210 6174 D7C5  30         movb  tmp1,*r15             ; Write byte
0211 6176 045B  20         b     *r11                  ; Exit
0212               
0213               
0214               ***************************************************************
0215               * VGETB - VDP get single byte
0216               ***************************************************************
0217               *  bl   @vgetb
0218               *  data p0
0219               *--------------------------------------------------------------
0220               *  P0 = VDP source address
0221               *--------------------------------------------------------------
0222               *  bl   @xvgetb
0223               *
0224               *  tmp0 = VDP source address
0225               *--------------------------------------------------------------
0226               *  Output:
0227               *  tmp0 MSB = >00
0228               *  tmp0 LSB = VDP byte read
0229               ********@*****@*********************@**************************
0230 6178 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0231               *--------------------------------------------------------------
0232               * Set VDP read address
0233               *--------------------------------------------------------------
0234 617A 06C4  14 xvgetb  swpb  tmp0                  ; \
0235 617C D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     617E 8C02 
0236 6180 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0237 6182 D804  38         movb  tmp0,@vdpa            ; /
     6184 8C02 
0238               *--------------------------------------------------------------
0239               * Read byte
0240               *--------------------------------------------------------------
0241 6186 D120  34         movb  @vdpr,tmp0            ; Read byte
     6188 8800 
0242 618A 0984  56         srl   tmp0,8                ; Right align
0243 618C 045B  20         b     *r11                  ; Exit
0244               
0245               
0246               ***************************************************************
0247               * VIDTAB - Dump videomode table
0248               ***************************************************************
0249               *  BL   @VIDTAB
0250               *  DATA P0
0251               *--------------------------------------------------------------
0252               *  P0 = Address of video mode table
0253               *--------------------------------------------------------------
0254               *  BL   @XIDTAB
0255               *
0256               *  TMP0 = Address of video mode table
0257               *--------------------------------------------------------------
0258               *  Remarks
0259               *  TMP1 = MSB is the VDP target register
0260               *         LSB is the value to write
0261               ********@*****@*********************@**************************
0262 618E C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0263 6190 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0264               *--------------------------------------------------------------
0265               * Calculate PNT base address
0266               *--------------------------------------------------------------
0267 6192 C144  18         mov   tmp0,tmp1
0268 6194 05C5  14         inct  tmp1
0269 6196 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0270 6198 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     619A FF00 
0271 619C 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0272 619E C805  38         mov   tmp1,@wbase           ; Store calculated base
     61A0 8328 
0273               *--------------------------------------------------------------
0274               * Dump VDP shadow registers
0275               *--------------------------------------------------------------
0276 61A2 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     61A4 8000 
0277 61A6 0206  20         li    tmp2,8
     61A8 0008 
0278 61AA D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     61AC 830B 
0279 61AE 06C5  14         swpb  tmp1
0280 61B0 D805  38         movb  tmp1,@vdpa
     61B2 8C02 
0281 61B4 06C5  14         swpb  tmp1
0282 61B6 D805  38         movb  tmp1,@vdpa
     61B8 8C02 
0283 61BA 0225  22         ai    tmp1,>0100
     61BC 0100 
0284 61BE 0606  14         dec   tmp2
0285 61C0 16F4  14         jne   vidta1                ; Next register
0286 61C2 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     61C4 833A 
0287 61C6 045B  20         b     *r11
0288               
0289               
0290               ***************************************************************
0291               * PUTVR  - Put single VDP register
0292               ***************************************************************
0293               *  BL   @PUTVR
0294               *  DATA P0
0295               *--------------------------------------------------------------
0296               *  P0 = MSB is the VDP target register
0297               *       LSB is the value to write
0298               *--------------------------------------------------------------
0299               *  BL   @PUTVRX
0300               *
0301               *  TMP0 = MSB is the VDP target register
0302               *         LSB is the value to write
0303               ********@*****@*********************@**************************
0304 61C8 C13B  30 putvr   mov   *r11+,tmp0
0305 61CA 0264  22 putvrx  ori   tmp0,>8000
     61CC 8000 
0306 61CE 06C4  14         swpb  tmp0
0307 61D0 D804  38         movb  tmp0,@vdpa
     61D2 8C02 
0308 61D4 06C4  14         swpb  tmp0
0309 61D6 D804  38         movb  tmp0,@vdpa
     61D8 8C02 
0310 61DA 045B  20         b     *r11
0311               
0312               
0313               ***************************************************************
0314               * PUTV01  - Put VDP registers #0 and #1
0315               ***************************************************************
0316               *  BL   @PUTV01
0317               ********@*****@*********************@**************************
0318 61DC C20B  18 putv01  mov   r11,tmp4              ; Save R11
0319 61DE C10E  18         mov   r14,tmp0
0320 61E0 0984  56         srl   tmp0,8
0321 61E2 06A0  32         bl    @putvrx               ; Write VR#0
     61E4 61CA 
0322 61E6 0204  20         li    tmp0,>0100
     61E8 0100 
0323 61EA D820  54         movb  @r14lb,@tmp0lb
     61EC 831D 
     61EE 8309 
0324 61F0 06A0  32         bl    @putvrx               ; Write VR#1
     61F2 61CA 
0325 61F4 0458  20         b     *tmp4                 ; Exit
0326               
0327               
0328               ***************************************************************
0329               * LDFNT - Load TI-99/4A font from GROM into VDP
0330               ***************************************************************
0331               *  BL   @LDFNT
0332               *  DATA P0,P1
0333               *--------------------------------------------------------------
0334               *  P0 = VDP Target address
0335               *  P1 = Font options
0336               *--------------------------------------------------------------
0337               * Uses registers tmp0-tmp4
0338               ********@*****@*********************@**************************
0339 61F6 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0340 61F8 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0341 61FA C11B  26         mov   *r11,tmp0             ; Get P0
0342 61FC 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61FE 7FFF 
0343 6200 2120  38         coc   @wbit0,tmp0
     6202 6046 
0344 6204 1604  14         jne   ldfnt1
0345 6206 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6208 8000 
0346 620A 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     620C 7FFF 
0347               *--------------------------------------------------------------
0348               * Read font table address from GROM into tmp1
0349               *--------------------------------------------------------------
0350 620E C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6210 6278 
0351 6212 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6214 9C02 
0352 6216 06C4  14         swpb  tmp0
0353 6218 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     621A 9C02 
0354 621C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     621E 9800 
0355 6220 06C5  14         swpb  tmp1
0356 6222 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6224 9800 
0357 6226 06C5  14         swpb  tmp1
0358               *--------------------------------------------------------------
0359               * Setup GROM source address from tmp1
0360               *--------------------------------------------------------------
0361 6228 D805  38         movb  tmp1,@grmwa
     622A 9C02 
0362 622C 06C5  14         swpb  tmp1
0363 622E D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6230 9C02 
0364               *--------------------------------------------------------------
0365               * Setup VDP target address
0366               *--------------------------------------------------------------
0367 6232 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0368 6234 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6236 614C 
0369 6238 05C8  14         inct  tmp4                  ; R11=R11+2
0370 623A C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0371 623C 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     623E 7FFF 
0372 6240 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     6242 627A 
0373 6244 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6246 627C 
0374               *--------------------------------------------------------------
0375               * Copy from GROM to VRAM
0376               *--------------------------------------------------------------
0377 6248 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0378 624A 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0379 624C D120  34         movb  @grmrd,tmp0
     624E 9800 
0380               *--------------------------------------------------------------
0381               *   Make font fat
0382               *--------------------------------------------------------------
0383 6250 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6252 6046 
0384 6254 1603  14         jne   ldfnt3                ; No, so skip
0385 6256 D1C4  18         movb  tmp0,tmp3
0386 6258 0917  56         srl   tmp3,1
0387 625A E107  18         soc   tmp3,tmp0
0388               *--------------------------------------------------------------
0389               *   Dump byte to VDP and do housekeeping
0390               *--------------------------------------------------------------
0391 625C D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     625E 8C00 
0392 6260 0606  14         dec   tmp2
0393 6262 16F2  14         jne   ldfnt2
0394 6264 05C8  14         inct  tmp4                  ; R11=R11+2
0395 6266 020F  20         li    r15,vdpw              ; Set VDP write address
     6268 8C00 
0396 626A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     626C 7FFF 
0397 626E 0458  20         b     *tmp4                 ; Exit
0398 6270 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6272 6026 
     6274 8C00 
0399 6276 10E8  14         jmp   ldfnt2
0400               *--------------------------------------------------------------
0401               * Fonts pointer table
0402               *--------------------------------------------------------------
0403 6278 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     627A 0200 
     627C 0000 
0404 627E 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6280 01C0 
     6282 0101 
0405 6284 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6286 02A0 
     6288 0101 
0406 628A 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     628C 00E0 
     628E 0101 
0407               
0408               
0409               
0410               ***************************************************************
0411               * YX2PNT - Get VDP PNT address for current YX cursor position
0412               ***************************************************************
0413               *  BL   @YX2PNT
0414               *--------------------------------------------------------------
0415               *  INPUT
0416               *  @WYX = Cursor YX position
0417               *--------------------------------------------------------------
0418               *  OUTPUT
0419               *  TMP0 = VDP address for entry in Pattern Name Table
0420               *--------------------------------------------------------------
0421               *  Register usage
0422               *  TMP0, R14, R15
0423               ********@*****@*********************@**************************
0424 6290 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0425 6292 C3A0  34         mov   @wyx,r14              ; Get YX
     6294 832A 
0426 6296 098E  56         srl   r14,8                 ; Right justify (remove X)
0427 6298 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     629A 833A 
0428               *--------------------------------------------------------------
0429               * Do rest of calculation with R15 (16 bit part is there)
0430               * Re-use R14
0431               *--------------------------------------------------------------
0432 629C C3A0  34         mov   @wyx,r14              ; Get YX
     629E 832A 
0433 62A0 024E  22         andi  r14,>00ff             ; Remove Y
     62A2 00FF 
0434 62A4 A3CE  18         a     r14,r15               ; pos = pos + X
0435 62A6 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     62A8 8328 
0436               *--------------------------------------------------------------
0437               * Clean up before exit
0438               *--------------------------------------------------------------
0439 62AA C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0440 62AC C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0441 62AE 020F  20         li    r15,vdpw              ; VDP write address
     62B0 8C00 
0442 62B2 045B  20         b     *r11
0443               
0444               
0445               
0446               ***************************************************************
0447               * Put length-byte prefixed string at current YX
0448               ***************************************************************
0449               *  BL   @PUTSTR
0450               *  DATA P0
0451               *
0452               *  P0 = Pointer to string
0453               *--------------------------------------------------------------
0454               *  REMARKS
0455               *  First byte of string must contain length
0456               ********@*****@*********************@**************************
0457 62B4 C17B  30 putstr  mov   *r11+,tmp1
0458 62B6 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0459 62B8 C1CB  18 xutstr  mov   r11,tmp3
0460 62BA 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     62BC 6290 
0461 62BE C2C7  18         mov   tmp3,r11
0462 62C0 0986  56         srl   tmp2,8                ; Right justify length byte
0463 62C2 0460  28         b     @xpym2v               ; Display string
     62C4 62D4 
0464               
0465               
0466               ***************************************************************
0467               * Put length-byte prefixed string at YX
0468               ***************************************************************
0469               *  BL   @PUTAT
0470               *  DATA P0,P1
0471               *
0472               *  P0 = YX position
0473               *  P1 = Pointer to string
0474               *--------------------------------------------------------------
0475               *  REMARKS
0476               *  First byte of string must contain length
0477               ********@*****@*********************@**************************
0478 62C6 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     62C8 832A 
0479 62CA 0460  28         b     @putstr
     62CC 62B4 
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
0020 62CE C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 62D0 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 62D2 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 62D4 0264  22 xpym2v  ori   tmp0,>4000
     62D6 4000 
0027 62D8 06C4  14         swpb  tmp0
0028 62DA D804  38         movb  tmp0,@vdpa
     62DC 8C02 
0029 62DE 06C4  14         swpb  tmp0
0030 62E0 D804  38         movb  tmp0,@vdpa
     62E2 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 62E4 020F  20         li    r15,vdpw              ; Set VDP write address
     62E6 8C00 
0035 62E8 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     62EA 62F2 
     62EC 8320 
0036 62EE 0460  28         b     @mcloop               ; Write data to VDP
     62F0 8320 
0037 62F2 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 62F4 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 62F6 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 62F8 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 62FA 06C4  14 xpyv2m  swpb  tmp0
0027 62FC D804  38         movb  tmp0,@vdpa
     62FE 8C02 
0028 6300 06C4  14         swpb  tmp0
0029 6302 D804  38         movb  tmp0,@vdpa
     6304 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6306 020F  20         li    r15,vdpr              ; Set VDP read address
     6308 8800 
0034 630A C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     630C 6314 
     630E 8320 
0035 6310 0460  28         b     @mcloop               ; Read data from VDP
     6312 8320 
0036 6314 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6316 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6318 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 631A C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 631C C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 631E 1602  14         jne   cpychk                ; No, continue checking
0032 6320 06A0  32         bl    @crash_handler        ; Yes, crash
     6322 604C 
0033               *--------------------------------------------------------------
0034               *    Check: 1 byte copy
0035               *--------------------------------------------------------------
0036 6324 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6326 0001 
0037 6328 1603  14         jne   cpym0                 ; No, continue checking
0038 632A DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0039 632C 04C6  14         clr   tmp2                  ; Reset counter
0040 632E 045B  20         b     *r11                  ; Return to caller
0041               *--------------------------------------------------------------
0042               *    Check: Uneven address handling
0043               *--------------------------------------------------------------
0044 6330 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     6332 7FFF 
0045 6334 C1C4  18         mov   tmp0,tmp3
0046 6336 0247  22         andi  tmp3,1
     6338 0001 
0047 633A 1618  14         jne   cpyodd                ; Odd source address handling
0048 633C C1C5  18 cpym1   mov   tmp1,tmp3
0049 633E 0247  22         andi  tmp3,1
     6340 0001 
0050 6342 1614  14         jne   cpyodd                ; Odd target address handling
0051               *--------------------------------------------------------------
0052               * 8 bit copy
0053               *--------------------------------------------------------------
0054 6344 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6346 6046 
0055 6348 1605  14         jne   cpym3
0056 634A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     634C 6372 
     634E 8320 
0057 6350 0460  28         b     @mcloop               ; Copy memory and exit
     6352 8320 
0058               *--------------------------------------------------------------
0059               * 16 bit copy
0060               *--------------------------------------------------------------
0061 6354 C1C6  18 cpym3   mov   tmp2,tmp3
0062 6356 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6358 0001 
0063 635A 1301  14         jeq   cpym4
0064 635C 0606  14         dec   tmp2                  ; Make TMP2 even
0065 635E CD74  46 cpym4   mov   *tmp0+,*tmp1+
0066 6360 0646  14         dect  tmp2
0067 6362 16FD  14         jne   cpym4
0068               *--------------------------------------------------------------
0069               * Copy last byte if ODD
0070               *--------------------------------------------------------------
0071 6364 C1C7  18         mov   tmp3,tmp3
0072 6366 1301  14         jeq   cpymz
0073 6368 D554  38         movb  *tmp0,*tmp1
0074 636A 045B  20 cpymz   b     *r11                  ; Return to caller
0075               *--------------------------------------------------------------
0076               * Handle odd source/target address
0077               *--------------------------------------------------------------
0078 636C 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     636E 8000 
0079 6370 10E9  14         jmp   cpym2
0080 6372 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0009 6374 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6376 FFBF 
0010 6378 0460  28         b     @putv01
     637A 61DC 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 637C 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     637E 0040 
0018 6380 0460  28         b     @putv01
     6382 61DC 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 6384 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6386 FFDF 
0026 6388 0460  28         b     @putv01
     638A 61DC 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 638C 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     638E 0020 
0034 6390 0460  28         b     @putv01
     6392 61DC 
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
0010 6394 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6396 FFFE 
0011 6398 0460  28         b     @putv01
     639A 61DC 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 639C 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     639E 0001 
0019 63A0 0460  28         b     @putv01
     63A2 61DC 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 63A4 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     63A6 FFFD 
0027 63A8 0460  28         b     @putv01
     63AA 61DC 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 63AC 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     63AE 0002 
0035 63B0 0460  28         b     @putv01
     63B2 61DC 
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
0018 63B4 C83B  50 at      mov   *r11+,@wyx
     63B6 832A 
0019 63B8 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 63BA B820  54 down    ab    @hb$01,@wyx
     63BC 6038 
     63BE 832A 
0028 63C0 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 63C2 7820  54 up      sb    @hb$01,@wyx
     63C4 6038 
     63C6 832A 
0037 63C8 045B  20         b     *r11
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
0049 63CA C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 63CC D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     63CE 832A 
0051 63D0 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     63D2 832A 
0052 63D4 045B  20         b     *r11
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
0021 63D6 C120  34 yx2px   mov   @wyx,tmp0
     63D8 832A 
0022 63DA C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 63DC 06C4  14         swpb  tmp0                  ; Y<->X
0024 63DE 04C5  14         clr   tmp1                  ; Clear before copy
0025 63E0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 63E2 20A0  38         coc   @wbit1,config         ; f18a present ?
     63E4 6044 
0030 63E6 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 63E8 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     63EA 833A 
     63EC 6416 
0032 63EE 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 63F0 0A15  56         sla   tmp1,1                ; X = X * 2
0035 63F2 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 63F4 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     63F6 0500 
0037 63F8 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 63FA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 63FC 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 63FE 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6400 D105  18         movb  tmp1,tmp0
0051 6402 06C4  14         swpb  tmp0                  ; X<->Y
0052 6404 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6406 6046 
0053 6408 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 640A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     640C 6038 
0059 640E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6410 604A 
0060 6412 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6414 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6416 0050            data   80
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
0013 6418 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 641A 06A0  32         bl    @putvr                ; Write once
     641C 61C8 
0015 641E 391C             data  >391c                 ; VR1/57, value 00011100
0016 6420 06A0  32         bl    @putvr                ; Write twice
     6422 61C8 
0017 6424 391C             data  >391c                 ; VR1/57, value 00011100
0018 6426 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 6428 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 642A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     642C 61C8 
0028 642E 391C             data  >391c
0029 6430 0458  20         b     *tmp4                 ; Exit
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
0040 6432 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6434 06A0  32         bl    @cpym2v
     6436 62CE 
0042 6438 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     643A 6476 
     643C 0006 
0043 643E 06A0  32         bl    @putvr
     6440 61C8 
0044 6442 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6444 06A0  32         bl    @putvr
     6446 61C8 
0046 6448 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 644A 0204  20         li    tmp0,>3f00
     644C 3F00 
0052 644E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6450 6150 
0053 6452 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6454 8800 
0054 6456 0984  56         srl   tmp0,8
0055 6458 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     645A 8800 
0056 645C C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 645E 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6460 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6462 BFFF 
0060 6464 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6466 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6468 4000 
0063               f18chk_exit:
0064 646A 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     646C 6124 
0065 646E 3F00             data  >3f00,>00,6
     6470 0000 
     6472 0006 
0066 6474 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6476 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6478 3F00             data  >3f00                 ; 3f02 / 3f00
0073 647A 0340             data  >0340                 ; 3f04   0340  idle
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
0092 647C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 647E 06A0  32         bl    @putvr
     6480 61C8 
0097 6482 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6484 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6486 61C8 
0100 6488 391C             data  >391c                 ; Lock the F18a
0101 648A 0458  20         b     *tmp4                 ; Exit
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
0120 648C C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 648E 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6490 6044 
0122 6492 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6494 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6496 8802 
0127 6498 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     649A 61C8 
0128 649C 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 649E 04C4  14         clr   tmp0
0130 64A0 D120  34         movb  @vdps,tmp0
     64A2 8802 
0131 64A4 0984  56         srl   tmp0,8
0132 64A6 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 64A8 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     64AA 832A 
0018 64AC D17B  28         movb  *r11+,tmp1
0019 64AE 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 64B0 D1BB  28         movb  *r11+,tmp2
0021 64B2 0986  56         srl   tmp2,8                ; Repeat count
0022 64B4 C1CB  18         mov   r11,tmp3
0023 64B6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     64B8 6290 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 64BA 020B  20         li    r11,hchar1
     64BC 64C2 
0028 64BE 0460  28         b     @xfilv                ; Draw
     64C0 612A 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 64C2 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     64C4 6048 
0033 64C6 1302  14         jeq   hchar2                ; Yes, exit
0034 64C8 C2C7  18         mov   tmp3,r11
0035 64CA 10EE  14         jmp   hchar                 ; Next one
0036 64CC 05C7  14 hchar2  inct  tmp3
0037 64CE 0457  20         b     *tmp3                 ; Exit
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
0016 64D0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64D2 6046 
0017 64D4 020C  20         li    r12,>0024
     64D6 0024 
0018 64D8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64DA 6568 
0019 64DC 04C6  14         clr   tmp2
0020 64DE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64E0 04CC  14         clr   r12
0025 64E2 1F08  20         tb    >0008                 ; Shift-key ?
0026 64E4 1302  14         jeq   realk1                ; No
0027 64E6 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64E8 6598 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64EA 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64EC 1302  14         jeq   realk2                ; No
0033 64EE 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64F0 65C8 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64F2 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64F4 1302  14         jeq   realk3                ; No
0039 64F6 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64F8 65F8 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64FA 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64FC 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64FE 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6500 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6502 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6504 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6506 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6508 0006 
0052 650A 0606  14 realk5  dec   tmp2
0053 650C 020C  20         li    r12,>24               ; CRU address for P2-P4
     650E 0024 
0054 6510 06C6  14         swpb  tmp2
0055 6512 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6514 06C6  14         swpb  tmp2
0057 6516 020C  20         li    r12,6                 ; CRU read address
     6518 0006 
0058 651A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 651C 0547  14         inv   tmp3                  ;
0060 651E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6520 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6522 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6524 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6526 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6528 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 652A 0285  22         ci    tmp1,8
     652C 0008 
0069 652E 1AFA  14         jl    realk6
0070 6530 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6532 1BEB  14         jh    realk5                ; No, next column
0072 6534 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6536 C206  18 realk8  mov   tmp2,tmp4
0077 6538 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 653A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 653C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 653E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6540 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6542 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6544 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6546 6046 
0087 6548 1608  14         jne   realka                ; No, continue saving key
0088 654A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     654C 6592 
0089 654E 1A05  14         jl    realka
0090 6550 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6552 6590 
0091 6554 1B02  14         jh    realka                ; No, continue
0092 6556 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6558 E000 
0093 655A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     655C 833C 
0094 655E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6560 6030 
0095 6562 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6564 8C00 
0096 6566 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6568 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     656A 0000 
     656C FF0D 
     656E 203D 
0099 6570 ....             text  'xws29ol.'
0100 6578 ....             text  'ced38ik,'
0101 6580 ....             text  'vrf47ujm'
0102 6588 ....             text  'btg56yhn'
0103 6590 ....             text  'zqa10p;/'
0104 6598 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     659A 0000 
     659C FF0D 
     659E 202B 
0105 65A0 ....             text  'XWS@(OL>'
0106 65A8 ....             text  'CED#*IK<'
0107 65B0 ....             text  'VRF$&UJM'
0108 65B8 ....             text  'BTG%^YHN'
0109 65C0 ....             text  'ZQA!)P:-'
0110 65C8 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65CA 0000 
     65CC FF0D 
     65CE 2005 
0111 65D0 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65D2 0804 
     65D4 0F27 
     65D6 C2B9 
0112 65D8 600B             data  >600b,>0907,>063f,>c1B8
     65DA 0907 
     65DC 063F 
     65DE C1B8 
0113 65E0 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65E2 7B02 
     65E4 015F 
     65E6 C0C3 
0114 65E8 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65EA 7D0E 
     65EC 0CC6 
     65EE BFC4 
0115 65F0 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65F2 7C03 
     65F4 BC22 
     65F6 BDBA 
0116 65F8 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65FA 0000 
     65FC FF0D 
     65FE 209D 
0117 6600 9897             data  >9897,>93b2,>9f8f,>8c9B
     6602 93B2 
     6604 9F8F 
     6606 8C9B 
0118 6608 8385             data  >8385,>84b3,>9e89,>8b80
     660A 84B3 
     660C 9E89 
     660E 8B80 
0119 6610 9692             data  >9692,>86b4,>b795,>8a8D
     6612 86B4 
     6614 B795 
     6616 8A8D 
0120 6618 8294             data  >8294,>87b5,>b698,>888E
     661A 87B5 
     661C B698 
     661E 888E 
0121 6620 9A91             data  >9a91,>81b1,>b090,>9cBB
     6622 81B1 
     6624 B090 
     6626 9CBB 
**** **** ****     > runlib.asm
0173               
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
0019 6628 0207  20 mknum   li    tmp3,5                ; Digit counter
     662A 0005 
0020 662C C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 662E C155  26         mov   *tmp1,tmp1            ; /
0022 6630 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6632 0228  22         ai    tmp4,4                ; Get end of buffer
     6634 0004 
0024 6636 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6638 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 663A 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 663C 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 663E 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6640 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6642 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6644 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6646 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6648 0607  14         dec   tmp3                  ; Decrease counter
0036 664A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 664C 0207  20         li    tmp3,4                ; Check first 4 digits
     664E 0004 
0041 6650 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6652 C11B  26         mov   *r11,tmp0
0043 6654 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6656 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6658 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 665A 05CB  14 mknum3  inct  r11
0047 665C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     665E 6046 
0048 6660 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6662 045B  20         b     *r11                  ; Exit
0050 6664 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6666 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6668 13F8  14         jeq   mknum3                ; Yes, exit
0053 666A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 666C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     666E 7FFF 
0058 6670 C10B  18         mov   r11,tmp0
0059 6672 0224  22         ai    tmp0,-4
     6674 FFFC 
0060 6676 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6678 0206  20         li    tmp2,>0500            ; String length = 5
     667A 0500 
0062 667C 0460  28         b     @xutstr               ; Display string
     667E 62B8 
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
0092 6680 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6682 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6684 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6686 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6688 0207  20         li    tmp3,5                ; Set counter
     668A 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 668C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 668E 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6690 0584  14         inc   tmp0                  ; Next character
0104 6692 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6694 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6696 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6698 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 669A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 669C 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 669E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 66A0 0607  14         dec   tmp3                  ; Last character ?
0120 66A2 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 66A4 045B  20         b     *r11                  ; Return
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
0138 66A6 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     66A8 832A 
0139 66AA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66AC 8000 
0140 66AE 10BC  14         jmp   mknum                 ; Convert number and display
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
0074 66B0 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 66B2 C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 66B4 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 66B6 0649  14         dect  stack
0079 66B8 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 66BA 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 66BC 04C8  14         clr   tmp4                  ; Repeat counter
0086 66BE 04E0  34         clr   @waux1                ; Length of RLE string
     66C0 833C 
0087 66C2 04E0  34         clr   @waux2                ; Address of encoding byte
     66C4 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 66C6 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 66C8 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 66CA 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 66CC 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 66CE C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 66D0 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 66D2 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     66D4 0001 
0105 66D6 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 66D8 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 66DA C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 66DC 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 66DE 06A0  32         bl    @cpu2rle.flush.duplicates
     66E0 672A 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 66E2 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     66E4 833E 
     66E6 833E 
0126 66E8 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 66EA C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     66EC 833E 
0129 66EE 0585  14         inc   tmp1                  ; Skip encoding byte
0130 66F0 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     66F2 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 66F4 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 66F6 05A0  34         inc   @waux1                ; RLE string length += 1
     66F8 833C 
0136 66FA 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 66FC C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     66FE 833E 
     6700 833E 
0145 6702 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 6704 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6706 6744 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 6708 0588  14         inc   tmp4                  ; Increase repeat counter
0155 670A 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 670C 0606  14         dec   tmp2
0162 670E 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 6710 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 6712 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 6714 06A0  32         bl    @cpu2rle.flush.duplicates
     6716 672A 
0175                                                   ; (3.2) Flush pending ...
0176 6718 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 671A C820  54         mov   @waux2,@waux2
     671C 833E 
     671E 833E 
0182 6720 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 6722 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6724 6744 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 6726 0460  28         b     @poprt                ; Return
     6728 60CC 
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
0204 672A 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 672C D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 672E 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 6730 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     6732 8000 
0210 6734 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 6736 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6738 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 673A 05E0  34         inct  @waux1                ; RLE string length += 2
     673C 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 673E 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 6740 04C8  14         clr   tmp4                  ; Clear repeat count
0220 6742 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 6744 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 6746 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6748 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 674A 61E0  34         s     @waux2,tmp3           ; | characters
     674C 833E 
0232 674E 0607  14         dec   tmp3                  ; /
0233               
0234 6750 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 6752 C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     6754 833E 
0236 6756 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6758 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 675A 04E0  34         clr   @waux2                ; Reset address of encoding byte
     675C 833E 
0240 675E 04C8  14         clr   tmp4                  ; Clear before exit
0241 6760 045B  20         b     *r11                  ; Return
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
0031 6762 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 6764 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6766 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6768 0649  14         dect  stack
0036 676A C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 676C D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 676E 0606  14         dec   tmp2                  ; Update length
0043 6770 131E  14         jeq   rle2cpu.exit          ; End of list
0044 6772 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 6774 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6776 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6778 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 677A 0649  14         dect  stack
0055 677C C646  30         mov   tmp2,*stack           ; Push tmp2
0056 677E C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 6780 06A0  32         bl    @xpym2m               ; Block copy to destination
     6782 631C 
0059                                                   ; \  tmp0 = Source address
0060                                                   ; |  tmp1 = Target address
0061                                                   ; /  tmp2 = Bytes to copy
0062               
0063 6784 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6786 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6788 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 678A 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 678C 0649  14         dect  stack
0073 678E C645  30         mov   tmp1,*stack           ; Push tmp1
0074 6790 0649  14         dect  stack
0075 6792 C646  30         mov   tmp2,*stack           ; Push tmp2
0076 6794 0649  14         dect  stack
0077 6796 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6798 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 679A D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 679C 0985  56         srl   tmp1,8                ; Right align
0082               
0083 679E 06A0  32         bl    @xfilm                ; Block fill to destination
     67A0 60D6 
0084                                                   ; \  tmp0 = Target address
0085                                                   ; |  tmp1 = Byte to fill
0086                                                   ; /  tmp2 = Repeat count
0087               
0088 67A2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 67A4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 67A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 67A8 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 67AA C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 67AC 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 67AE 0460  28         b     @poprt                ; Return
     67B0 60CC 
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
0021 67B2 C820  54         mov   @>8300,@>2000
     67B4 8300 
     67B6 2000 
0022 67B8 C820  54         mov   @>8302,@>2002
     67BA 8302 
     67BC 2002 
0023 67BE C820  54         mov   @>8304,@>2004
     67C0 8304 
     67C2 2004 
0024 67C4 C820  54         mov   @>8306,@>2006
     67C6 8306 
     67C8 2006 
0025 67CA C820  54         mov   @>8308,@>2008
     67CC 8308 
     67CE 2008 
0026 67D0 C820  54         mov   @>830A,@>200A
     67D2 830A 
     67D4 200A 
0027 67D6 C820  54         mov   @>830C,@>200C
     67D8 830C 
     67DA 200C 
0028 67DC C820  54         mov   @>830E,@>200E
     67DE 830E 
     67E0 200E 
0029 67E2 C820  54         mov   @>8310,@>2010
     67E4 8310 
     67E6 2010 
0030 67E8 C820  54         mov   @>8312,@>2012
     67EA 8312 
     67EC 2012 
0031 67EE C820  54         mov   @>8314,@>2014
     67F0 8314 
     67F2 2014 
0032 67F4 C820  54         mov   @>8316,@>2016
     67F6 8316 
     67F8 2016 
0033 67FA C820  54         mov   @>8318,@>2018
     67FC 8318 
     67FE 2018 
0034 6800 C820  54         mov   @>831A,@>201A
     6802 831A 
     6804 201A 
0035 6806 C820  54         mov   @>831C,@>201C
     6808 831C 
     680A 201C 
0036 680C C820  54         mov   @>831E,@>201E
     680E 831E 
     6810 201E 
0037 6812 C820  54         mov   @>8320,@>2020
     6814 8320 
     6816 2020 
0038 6818 C820  54         mov   @>8322,@>2022
     681A 8322 
     681C 2022 
0039 681E C820  54         mov   @>8324,@>2024
     6820 8324 
     6822 2024 
0040 6824 C820  54         mov   @>8326,@>2026
     6826 8326 
     6828 2026 
0041 682A C820  54         mov   @>8328,@>2028
     682C 8328 
     682E 2028 
0042 6830 C820  54         mov   @>832A,@>202A
     6832 832A 
     6834 202A 
0043 6836 C820  54         mov   @>832C,@>202C
     6838 832C 
     683A 202C 
0044 683C C820  54         mov   @>832E,@>202E
     683E 832E 
     6840 202E 
0045 6842 C820  54         mov   @>8330,@>2030
     6844 8330 
     6846 2030 
0046 6848 C820  54         mov   @>8332,@>2032
     684A 8332 
     684C 2032 
0047 684E C820  54         mov   @>8334,@>2034
     6850 8334 
     6852 2034 
0048 6854 C820  54         mov   @>8336,@>2036
     6856 8336 
     6858 2036 
0049 685A C820  54         mov   @>8338,@>2038
     685C 8338 
     685E 2038 
0050 6860 C820  54         mov   @>833A,@>203A
     6862 833A 
     6864 203A 
0051 6866 C820  54         mov   @>833C,@>203C
     6868 833C 
     686A 203C 
0052 686C C820  54         mov   @>833E,@>203E
     686E 833E 
     6870 203E 
0053 6872 C820  54         mov   @>8340,@>2040
     6874 8340 
     6876 2040 
0054 6878 C820  54         mov   @>8342,@>2042
     687A 8342 
     687C 2042 
0055 687E C820  54         mov   @>8344,@>2044
     6880 8344 
     6882 2044 
0056 6884 C820  54         mov   @>8346,@>2046
     6886 8346 
     6888 2046 
0057 688A C820  54         mov   @>8348,@>2048
     688C 8348 
     688E 2048 
0058 6890 C820  54         mov   @>834A,@>204A
     6892 834A 
     6894 204A 
0059 6896 C820  54         mov   @>834C,@>204C
     6898 834C 
     689A 204C 
0060 689C C820  54         mov   @>834E,@>204E
     689E 834E 
     68A0 204E 
0061 68A2 C820  54         mov   @>8350,@>2050
     68A4 8350 
     68A6 2050 
0062 68A8 C820  54         mov   @>8352,@>2052
     68AA 8352 
     68AC 2052 
0063 68AE C820  54         mov   @>8354,@>2054
     68B0 8354 
     68B2 2054 
0064 68B4 C820  54         mov   @>8356,@>2056
     68B6 8356 
     68B8 2056 
0065 68BA C820  54         mov   @>8358,@>2058
     68BC 8358 
     68BE 2058 
0066 68C0 C820  54         mov   @>835A,@>205A
     68C2 835A 
     68C4 205A 
0067 68C6 C820  54         mov   @>835C,@>205C
     68C8 835C 
     68CA 205C 
0068 68CC C820  54         mov   @>835E,@>205E
     68CE 835E 
     68D0 205E 
0069 68D2 C820  54         mov   @>8360,@>2060
     68D4 8360 
     68D6 2060 
0070 68D8 C820  54         mov   @>8362,@>2062
     68DA 8362 
     68DC 2062 
0071 68DE C820  54         mov   @>8364,@>2064
     68E0 8364 
     68E2 2064 
0072 68E4 C820  54         mov   @>8366,@>2066
     68E6 8366 
     68E8 2066 
0073 68EA C820  54         mov   @>8368,@>2068
     68EC 8368 
     68EE 2068 
0074 68F0 C820  54         mov   @>836A,@>206A
     68F2 836A 
     68F4 206A 
0075 68F6 C820  54         mov   @>836C,@>206C
     68F8 836C 
     68FA 206C 
0076 68FC C820  54         mov   @>836E,@>206E
     68FE 836E 
     6900 206E 
0077 6902 C820  54         mov   @>8370,@>2070
     6904 8370 
     6906 2070 
0078 6908 C820  54         mov   @>8372,@>2072
     690A 8372 
     690C 2072 
0079 690E C820  54         mov   @>8374,@>2074
     6910 8374 
     6912 2074 
0080 6914 C820  54         mov   @>8376,@>2076
     6916 8376 
     6918 2076 
0081 691A C820  54         mov   @>8378,@>2078
     691C 8378 
     691E 2078 
0082 6920 C820  54         mov   @>837A,@>207A
     6922 837A 
     6924 207A 
0083 6926 C820  54         mov   @>837C,@>207C
     6928 837C 
     692A 207C 
0084 692C C820  54         mov   @>837E,@>207E
     692E 837E 
     6930 207E 
0085 6932 C820  54         mov   @>8380,@>2080
     6934 8380 
     6936 2080 
0086 6938 C820  54         mov   @>8382,@>2082
     693A 8382 
     693C 2082 
0087 693E C820  54         mov   @>8384,@>2084
     6940 8384 
     6942 2084 
0088 6944 C820  54         mov   @>8386,@>2086
     6946 8386 
     6948 2086 
0089 694A C820  54         mov   @>8388,@>2088
     694C 8388 
     694E 2088 
0090 6950 C820  54         mov   @>838A,@>208A
     6952 838A 
     6954 208A 
0091 6956 C820  54         mov   @>838C,@>208C
     6958 838C 
     695A 208C 
0092 695C C820  54         mov   @>838E,@>208E
     695E 838E 
     6960 208E 
0093 6962 C820  54         mov   @>8390,@>2090
     6964 8390 
     6966 2090 
0094 6968 C820  54         mov   @>8392,@>2092
     696A 8392 
     696C 2092 
0095 696E C820  54         mov   @>8394,@>2094
     6970 8394 
     6972 2094 
0096 6974 C820  54         mov   @>8396,@>2096
     6976 8396 
     6978 2096 
0097 697A C820  54         mov   @>8398,@>2098
     697C 8398 
     697E 2098 
0098 6980 C820  54         mov   @>839A,@>209A
     6982 839A 
     6984 209A 
0099 6986 C820  54         mov   @>839C,@>209C
     6988 839C 
     698A 209C 
0100 698C C820  54         mov   @>839E,@>209E
     698E 839E 
     6990 209E 
0101 6992 C820  54         mov   @>83A0,@>20A0
     6994 83A0 
     6996 20A0 
0102 6998 C820  54         mov   @>83A2,@>20A2
     699A 83A2 
     699C 20A2 
0103 699E C820  54         mov   @>83A4,@>20A4
     69A0 83A4 
     69A2 20A4 
0104 69A4 C820  54         mov   @>83A6,@>20A6
     69A6 83A6 
     69A8 20A6 
0105 69AA C820  54         mov   @>83A8,@>20A8
     69AC 83A8 
     69AE 20A8 
0106 69B0 C820  54         mov   @>83AA,@>20AA
     69B2 83AA 
     69B4 20AA 
0107 69B6 C820  54         mov   @>83AC,@>20AC
     69B8 83AC 
     69BA 20AC 
0108 69BC C820  54         mov   @>83AE,@>20AE
     69BE 83AE 
     69C0 20AE 
0109 69C2 C820  54         mov   @>83B0,@>20B0
     69C4 83B0 
     69C6 20B0 
0110 69C8 C820  54         mov   @>83B2,@>20B2
     69CA 83B2 
     69CC 20B2 
0111 69CE C820  54         mov   @>83B4,@>20B4
     69D0 83B4 
     69D2 20B4 
0112 69D4 C820  54         mov   @>83B6,@>20B6
     69D6 83B6 
     69D8 20B6 
0113 69DA C820  54         mov   @>83B8,@>20B8
     69DC 83B8 
     69DE 20B8 
0114 69E0 C820  54         mov   @>83BA,@>20BA
     69E2 83BA 
     69E4 20BA 
0115 69E6 C820  54         mov   @>83BC,@>20BC
     69E8 83BC 
     69EA 20BC 
0116 69EC C820  54         mov   @>83BE,@>20BE
     69EE 83BE 
     69F0 20BE 
0117 69F2 C820  54         mov   @>83C0,@>20C0
     69F4 83C0 
     69F6 20C0 
0118 69F8 C820  54         mov   @>83C2,@>20C2
     69FA 83C2 
     69FC 20C2 
0119 69FE C820  54         mov   @>83C4,@>20C4
     6A00 83C4 
     6A02 20C4 
0120 6A04 C820  54         mov   @>83C6,@>20C6
     6A06 83C6 
     6A08 20C6 
0121 6A0A C820  54         mov   @>83C8,@>20C8
     6A0C 83C8 
     6A0E 20C8 
0122 6A10 C820  54         mov   @>83CA,@>20CA
     6A12 83CA 
     6A14 20CA 
0123 6A16 C820  54         mov   @>83CC,@>20CC
     6A18 83CC 
     6A1A 20CC 
0124 6A1C C820  54         mov   @>83CE,@>20CE
     6A1E 83CE 
     6A20 20CE 
0125 6A22 C820  54         mov   @>83D0,@>20D0
     6A24 83D0 
     6A26 20D0 
0126 6A28 C820  54         mov   @>83D2,@>20D2
     6A2A 83D2 
     6A2C 20D2 
0127 6A2E C820  54         mov   @>83D4,@>20D4
     6A30 83D4 
     6A32 20D4 
0128 6A34 C820  54         mov   @>83D6,@>20D6
     6A36 83D6 
     6A38 20D6 
0129 6A3A C820  54         mov   @>83D8,@>20D8
     6A3C 83D8 
     6A3E 20D8 
0130 6A40 C820  54         mov   @>83DA,@>20DA
     6A42 83DA 
     6A44 20DA 
0131 6A46 C820  54         mov   @>83DC,@>20DC
     6A48 83DC 
     6A4A 20DC 
0132 6A4C C820  54         mov   @>83DE,@>20DE
     6A4E 83DE 
     6A50 20DE 
0133 6A52 C820  54         mov   @>83E0,@>20E0
     6A54 83E0 
     6A56 20E0 
0134 6A58 C820  54         mov   @>83E2,@>20E2
     6A5A 83E2 
     6A5C 20E2 
0135 6A5E C820  54         mov   @>83E4,@>20E4
     6A60 83E4 
     6A62 20E4 
0136 6A64 C820  54         mov   @>83E6,@>20E6
     6A66 83E6 
     6A68 20E6 
0137 6A6A C820  54         mov   @>83E8,@>20E8
     6A6C 83E8 
     6A6E 20E8 
0138 6A70 C820  54         mov   @>83EA,@>20EA
     6A72 83EA 
     6A74 20EA 
0139 6A76 C820  54         mov   @>83EC,@>20EC
     6A78 83EC 
     6A7A 20EC 
0140 6A7C C820  54         mov   @>83EE,@>20EE
     6A7E 83EE 
     6A80 20EE 
0141 6A82 C820  54         mov   @>83F0,@>20F0
     6A84 83F0 
     6A86 20F0 
0142 6A88 C820  54         mov   @>83F2,@>20F2
     6A8A 83F2 
     6A8C 20F2 
0143 6A8E C820  54         mov   @>83F4,@>20F4
     6A90 83F4 
     6A92 20F4 
0144 6A94 C820  54         mov   @>83F6,@>20F6
     6A96 83F6 
     6A98 20F6 
0145 6A9A C820  54         mov   @>83F8,@>20F8
     6A9C 83F8 
     6A9E 20F8 
0146 6AA0 C820  54         mov   @>83FA,@>20FA
     6AA2 83FA 
     6AA4 20FA 
0147 6AA6 C820  54         mov   @>83FC,@>20FC
     6AA8 83FC 
     6AAA 20FC 
0148 6AAC C820  54         mov   @>83FE,@>20FE
     6AAE 83FE 
     6AB0 20FE 
0149 6AB2 045B  20         b     *r11                  ; Return to caller
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
0164 6AB4 C820  54         mov   @>2000,@>8300
     6AB6 2000 
     6AB8 8300 
0165 6ABA C820  54         mov   @>2002,@>8302
     6ABC 2002 
     6ABE 8302 
0166 6AC0 C820  54         mov   @>2004,@>8304
     6AC2 2004 
     6AC4 8304 
0167 6AC6 C820  54         mov   @>2006,@>8306
     6AC8 2006 
     6ACA 8306 
0168 6ACC C820  54         mov   @>2008,@>8308
     6ACE 2008 
     6AD0 8308 
0169 6AD2 C820  54         mov   @>200A,@>830A
     6AD4 200A 
     6AD6 830A 
0170 6AD8 C820  54         mov   @>200C,@>830C
     6ADA 200C 
     6ADC 830C 
0171 6ADE C820  54         mov   @>200E,@>830E
     6AE0 200E 
     6AE2 830E 
0172 6AE4 C820  54         mov   @>2010,@>8310
     6AE6 2010 
     6AE8 8310 
0173 6AEA C820  54         mov   @>2012,@>8312
     6AEC 2012 
     6AEE 8312 
0174 6AF0 C820  54         mov   @>2014,@>8314
     6AF2 2014 
     6AF4 8314 
0175 6AF6 C820  54         mov   @>2016,@>8316
     6AF8 2016 
     6AFA 8316 
0176 6AFC C820  54         mov   @>2018,@>8318
     6AFE 2018 
     6B00 8318 
0177 6B02 C820  54         mov   @>201A,@>831A
     6B04 201A 
     6B06 831A 
0178 6B08 C820  54         mov   @>201C,@>831C
     6B0A 201C 
     6B0C 831C 
0179 6B0E C820  54         mov   @>201E,@>831E
     6B10 201E 
     6B12 831E 
0180 6B14 C820  54         mov   @>2020,@>8320
     6B16 2020 
     6B18 8320 
0181 6B1A C820  54         mov   @>2022,@>8322
     6B1C 2022 
     6B1E 8322 
0182 6B20 C820  54         mov   @>2024,@>8324
     6B22 2024 
     6B24 8324 
0183 6B26 C820  54         mov   @>2026,@>8326
     6B28 2026 
     6B2A 8326 
0184 6B2C C820  54         mov   @>2028,@>8328
     6B2E 2028 
     6B30 8328 
0185 6B32 C820  54         mov   @>202A,@>832A
     6B34 202A 
     6B36 832A 
0186 6B38 C820  54         mov   @>202C,@>832C
     6B3A 202C 
     6B3C 832C 
0187 6B3E C820  54         mov   @>202E,@>832E
     6B40 202E 
     6B42 832E 
0188 6B44 C820  54         mov   @>2030,@>8330
     6B46 2030 
     6B48 8330 
0189 6B4A C820  54         mov   @>2032,@>8332
     6B4C 2032 
     6B4E 8332 
0190 6B50 C820  54         mov   @>2034,@>8334
     6B52 2034 
     6B54 8334 
0191 6B56 C820  54         mov   @>2036,@>8336
     6B58 2036 
     6B5A 8336 
0192 6B5C C820  54         mov   @>2038,@>8338
     6B5E 2038 
     6B60 8338 
0193 6B62 C820  54         mov   @>203A,@>833A
     6B64 203A 
     6B66 833A 
0194 6B68 C820  54         mov   @>203C,@>833C
     6B6A 203C 
     6B6C 833C 
0195 6B6E C820  54         mov   @>203E,@>833E
     6B70 203E 
     6B72 833E 
0196 6B74 C820  54         mov   @>2040,@>8340
     6B76 2040 
     6B78 8340 
0197 6B7A C820  54         mov   @>2042,@>8342
     6B7C 2042 
     6B7E 8342 
0198 6B80 C820  54         mov   @>2044,@>8344
     6B82 2044 
     6B84 8344 
0199 6B86 C820  54         mov   @>2046,@>8346
     6B88 2046 
     6B8A 8346 
0200 6B8C C820  54         mov   @>2048,@>8348
     6B8E 2048 
     6B90 8348 
0201 6B92 C820  54         mov   @>204A,@>834A
     6B94 204A 
     6B96 834A 
0202 6B98 C820  54         mov   @>204C,@>834C
     6B9A 204C 
     6B9C 834C 
0203 6B9E C820  54         mov   @>204E,@>834E
     6BA0 204E 
     6BA2 834E 
0204 6BA4 C820  54         mov   @>2050,@>8350
     6BA6 2050 
     6BA8 8350 
0205 6BAA C820  54         mov   @>2052,@>8352
     6BAC 2052 
     6BAE 8352 
0206 6BB0 C820  54         mov   @>2054,@>8354
     6BB2 2054 
     6BB4 8354 
0207 6BB6 C820  54         mov   @>2056,@>8356
     6BB8 2056 
     6BBA 8356 
0208 6BBC C820  54         mov   @>2058,@>8358
     6BBE 2058 
     6BC0 8358 
0209 6BC2 C820  54         mov   @>205A,@>835A
     6BC4 205A 
     6BC6 835A 
0210 6BC8 C820  54         mov   @>205C,@>835C
     6BCA 205C 
     6BCC 835C 
0211 6BCE C820  54         mov   @>205E,@>835E
     6BD0 205E 
     6BD2 835E 
0212 6BD4 C820  54         mov   @>2060,@>8360
     6BD6 2060 
     6BD8 8360 
0213 6BDA C820  54         mov   @>2062,@>8362
     6BDC 2062 
     6BDE 8362 
0214 6BE0 C820  54         mov   @>2064,@>8364
     6BE2 2064 
     6BE4 8364 
0215 6BE6 C820  54         mov   @>2066,@>8366
     6BE8 2066 
     6BEA 8366 
0216 6BEC C820  54         mov   @>2068,@>8368
     6BEE 2068 
     6BF0 8368 
0217 6BF2 C820  54         mov   @>206A,@>836A
     6BF4 206A 
     6BF6 836A 
0218 6BF8 C820  54         mov   @>206C,@>836C
     6BFA 206C 
     6BFC 836C 
0219 6BFE C820  54         mov   @>206E,@>836E
     6C00 206E 
     6C02 836E 
0220 6C04 C820  54         mov   @>2070,@>8370
     6C06 2070 
     6C08 8370 
0221 6C0A C820  54         mov   @>2072,@>8372
     6C0C 2072 
     6C0E 8372 
0222 6C10 C820  54         mov   @>2074,@>8374
     6C12 2074 
     6C14 8374 
0223 6C16 C820  54         mov   @>2076,@>8376
     6C18 2076 
     6C1A 8376 
0224 6C1C C820  54         mov   @>2078,@>8378
     6C1E 2078 
     6C20 8378 
0225 6C22 C820  54         mov   @>207A,@>837A
     6C24 207A 
     6C26 837A 
0226 6C28 C820  54         mov   @>207C,@>837C
     6C2A 207C 
     6C2C 837C 
0227 6C2E C820  54         mov   @>207E,@>837E
     6C30 207E 
     6C32 837E 
0228 6C34 C820  54         mov   @>2080,@>8380
     6C36 2080 
     6C38 8380 
0229 6C3A C820  54         mov   @>2082,@>8382
     6C3C 2082 
     6C3E 8382 
0230 6C40 C820  54         mov   @>2084,@>8384
     6C42 2084 
     6C44 8384 
0231 6C46 C820  54         mov   @>2086,@>8386
     6C48 2086 
     6C4A 8386 
0232 6C4C C820  54         mov   @>2088,@>8388
     6C4E 2088 
     6C50 8388 
0233 6C52 C820  54         mov   @>208A,@>838A
     6C54 208A 
     6C56 838A 
0234 6C58 C820  54         mov   @>208C,@>838C
     6C5A 208C 
     6C5C 838C 
0235 6C5E C820  54         mov   @>208E,@>838E
     6C60 208E 
     6C62 838E 
0236 6C64 C820  54         mov   @>2090,@>8390
     6C66 2090 
     6C68 8390 
0237 6C6A C820  54         mov   @>2092,@>8392
     6C6C 2092 
     6C6E 8392 
0238 6C70 C820  54         mov   @>2094,@>8394
     6C72 2094 
     6C74 8394 
0239 6C76 C820  54         mov   @>2096,@>8396
     6C78 2096 
     6C7A 8396 
0240 6C7C C820  54         mov   @>2098,@>8398
     6C7E 2098 
     6C80 8398 
0241 6C82 C820  54         mov   @>209A,@>839A
     6C84 209A 
     6C86 839A 
0242 6C88 C820  54         mov   @>209C,@>839C
     6C8A 209C 
     6C8C 839C 
0243 6C8E C820  54         mov   @>209E,@>839E
     6C90 209E 
     6C92 839E 
0244 6C94 C820  54         mov   @>20A0,@>83A0
     6C96 20A0 
     6C98 83A0 
0245 6C9A C820  54         mov   @>20A2,@>83A2
     6C9C 20A2 
     6C9E 83A2 
0246 6CA0 C820  54         mov   @>20A4,@>83A4
     6CA2 20A4 
     6CA4 83A4 
0247 6CA6 C820  54         mov   @>20A6,@>83A6
     6CA8 20A6 
     6CAA 83A6 
0248 6CAC C820  54         mov   @>20A8,@>83A8
     6CAE 20A8 
     6CB0 83A8 
0249 6CB2 C820  54         mov   @>20AA,@>83AA
     6CB4 20AA 
     6CB6 83AA 
0250 6CB8 C820  54         mov   @>20AC,@>83AC
     6CBA 20AC 
     6CBC 83AC 
0251 6CBE C820  54         mov   @>20AE,@>83AE
     6CC0 20AE 
     6CC2 83AE 
0252 6CC4 C820  54         mov   @>20B0,@>83B0
     6CC6 20B0 
     6CC8 83B0 
0253 6CCA C820  54         mov   @>20B2,@>83B2
     6CCC 20B2 
     6CCE 83B2 
0254 6CD0 C820  54         mov   @>20B4,@>83B4
     6CD2 20B4 
     6CD4 83B4 
0255 6CD6 C820  54         mov   @>20B6,@>83B6
     6CD8 20B6 
     6CDA 83B6 
0256 6CDC C820  54         mov   @>20B8,@>83B8
     6CDE 20B8 
     6CE0 83B8 
0257 6CE2 C820  54         mov   @>20BA,@>83BA
     6CE4 20BA 
     6CE6 83BA 
0258 6CE8 C820  54         mov   @>20BC,@>83BC
     6CEA 20BC 
     6CEC 83BC 
0259 6CEE C820  54         mov   @>20BE,@>83BE
     6CF0 20BE 
     6CF2 83BE 
0260 6CF4 C820  54         mov   @>20C0,@>83C0
     6CF6 20C0 
     6CF8 83C0 
0261 6CFA C820  54         mov   @>20C2,@>83C2
     6CFC 20C2 
     6CFE 83C2 
0262 6D00 C820  54         mov   @>20C4,@>83C4
     6D02 20C4 
     6D04 83C4 
0263 6D06 C820  54         mov   @>20C6,@>83C6
     6D08 20C6 
     6D0A 83C6 
0264 6D0C C820  54         mov   @>20C8,@>83C8
     6D0E 20C8 
     6D10 83C8 
0265 6D12 C820  54         mov   @>20CA,@>83CA
     6D14 20CA 
     6D16 83CA 
0266 6D18 C820  54         mov   @>20CC,@>83CC
     6D1A 20CC 
     6D1C 83CC 
0267 6D1E C820  54         mov   @>20CE,@>83CE
     6D20 20CE 
     6D22 83CE 
0268 6D24 C820  54         mov   @>20D0,@>83D0
     6D26 20D0 
     6D28 83D0 
0269 6D2A C820  54         mov   @>20D2,@>83D2
     6D2C 20D2 
     6D2E 83D2 
0270 6D30 C820  54         mov   @>20D4,@>83D4
     6D32 20D4 
     6D34 83D4 
0271 6D36 C820  54         mov   @>20D6,@>83D6
     6D38 20D6 
     6D3A 83D6 
0272 6D3C C820  54         mov   @>20D8,@>83D8
     6D3E 20D8 
     6D40 83D8 
0273 6D42 C820  54         mov   @>20DA,@>83DA
     6D44 20DA 
     6D46 83DA 
0274 6D48 C820  54         mov   @>20DC,@>83DC
     6D4A 20DC 
     6D4C 83DC 
0275 6D4E C820  54         mov   @>20DE,@>83DE
     6D50 20DE 
     6D52 83DE 
0276 6D54 C820  54         mov   @>20E0,@>83E0
     6D56 20E0 
     6D58 83E0 
0277 6D5A C820  54         mov   @>20E2,@>83E2
     6D5C 20E2 
     6D5E 83E2 
0278 6D60 C820  54         mov   @>20E4,@>83E4
     6D62 20E4 
     6D64 83E4 
0279 6D66 C820  54         mov   @>20E6,@>83E6
     6D68 20E6 
     6D6A 83E6 
0280 6D6C C820  54         mov   @>20E8,@>83E8
     6D6E 20E8 
     6D70 83E8 
0281 6D72 C820  54         mov   @>20EA,@>83EA
     6D74 20EA 
     6D76 83EA 
0282 6D78 C820  54         mov   @>20EC,@>83EC
     6D7A 20EC 
     6D7C 83EC 
0283 6D7E C820  54         mov   @>20EE,@>83EE
     6D80 20EE 
     6D82 83EE 
0284 6D84 C820  54         mov   @>20F0,@>83F0
     6D86 20F0 
     6D88 83F0 
0285 6D8A C820  54         mov   @>20F2,@>83F2
     6D8C 20F2 
     6D8E 83F2 
0286 6D90 C820  54         mov   @>20F4,@>83F4
     6D92 20F4 
     6D94 83F4 
0287 6D96 C820  54         mov   @>20F6,@>83F6
     6D98 20F6 
     6D9A 83F6 
0288 6D9C C820  54         mov   @>20F8,@>83F8
     6D9E 20F8 
     6DA0 83F8 
0289 6DA2 C820  54         mov   @>20FA,@>83FA
     6DA4 20FA 
     6DA6 83FA 
0290 6DA8 C820  54         mov   @>20FC,@>83FC
     6DAA 20FC 
     6DAC 83FC 
0291 6DAE C820  54         mov   @>20FE,@>83FE
     6DB0 20FE 
     6DB2 83FE 
0292 6DB4 045B  20         b     *r11                  ; Return to caller
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
0024 6DB6 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6DB8 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6DBA 8300 
0030 6DBC C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6DBE 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6DC0 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6DC2 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6DC4 0606  14         dec   tmp2
0037 6DC6 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6DC8 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6DCA 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6DCC 6DD2 
0043                                                   ; R14=PC
0044 6DCE 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6DD0 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6DD2 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6DD4 6AB4 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6DD6 045B  20         b     *r11                  ; Return to caller
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
0077 6DD8 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6DDA 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6DDC 8300 
0083 6DDE 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6DE0 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6DE2 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6DE4 0606  14         dec   tmp2
0089 6DE6 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6DE8 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6DEA 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6DEC 045B  20         b     *r11                  ; Return to caller
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
0041 6DEE 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6DF0 6DF2             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6DF2 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6DF4 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6DF6 8322 
0049 6DF8 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6DFA 6042 
0050 6DFC C020  34         mov   @>8356,r0             ; get ptr to pab
     6DFE 8356 
0051 6E00 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6E02 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6E04 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6E06 06C0  14         swpb  r0                    ;
0059 6E08 D800  38         movb  r0,@vdpa              ; send low byte
     6E0A 8C02 
0060 6E0C 06C0  14         swpb  r0                    ;
0061 6E0E D800  38         movb  r0,@vdpa              ; send high byte
     6E10 8C02 
0062 6E12 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6E14 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6E16 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6E18 0704  14         seto  r4                    ; init counter
0070 6E1A 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6E1C 2420 
0071 6E1E 0580  14 !       inc   r0                    ; point to next char of name
0072 6E20 0584  14         inc   r4                    ; incr char counter
0073 6E22 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6E24 0007 
0074 6E26 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6E28 80C4  18         c     r4,r3                 ; end of name?
0077 6E2A 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6E2C 06C0  14         swpb  r0                    ;
0082 6E2E D800  38         movb  r0,@vdpa              ; send low byte
     6E30 8C02 
0083 6E32 06C0  14         swpb  r0                    ;
0084 6E34 D800  38         movb  r0,@vdpa              ; send high byte
     6E36 8C02 
0085 6E38 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E3A 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6E3C DC81  32         movb  r1,*r2+               ; move into buffer
0092 6E3E 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6E40 6F02 
0093 6E42 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6E44 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6E46 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6E48 04E0  34         clr   @>83d0
     6E4A 83D0 
0102 6E4C C804  38         mov   r4,@>8354             ; save name length for search
     6E4E 8354 
0103 6E50 0584  14         inc   r4                    ; adjust for dot
0104 6E52 A804  38         a     r4,@>8356             ; point to position after name
     6E54 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6E56 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E58 83E0 
0110 6E5A 04C1  14         clr   r1                    ; version found of dsr
0111 6E5C 020C  20         li    r12,>0f00             ; init cru addr
     6E5E 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6E60 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6E62 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6E64 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6E66 022C  22         ai    r12,>0100             ; next rom to turn on
     6E68 0100 
0125 6E6A 04E0  34         clr   @>83d0                ; clear in case we are done
     6E6C 83D0 
0126 6E6E 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6E70 2000 
0127 6E72 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6E74 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6E76 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6E78 1D00  20         sbo   0                     ; turn on rom
0134 6E7A 0202  20         li    r2,>4000              ; start at beginning of rom
     6E7C 4000 
0135 6E7E 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6E80 6EFE 
0136 6E82 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6E84 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6E86 240A 
0146 6E88 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6E8A C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6E8C 83D2 
0152 6E8E 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6E90 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6E92 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6E94 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6E96 83D2 
0161 6E98 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6E9A C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6E9C 04C5  14         clr   r5                    ; Remove any old stuff
0167 6E9E D160  34         movb  @>8355,r5             ; get length as counter
     6EA0 8355 
0168 6EA2 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6EA4 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6EA6 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6EA8 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6EAA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6EAC 2420 
0175 6EAE 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6EB0 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6EB2 0605  14         dec   r5                    ; loop until full length checked
0179 6EB4 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6EB6 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6EB8 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6EBA 0581  14         inc   r1                    ; next version found
0191 6EBC 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6EBE 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6EC0 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6EC2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6EC4 2400 
0200 6EC6 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6EC8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6ECA 8322 
0202                                                   ; (8 or >a)
0203 6ECC 0281  22         ci    r1,8                  ; was it 8?
     6ECE 0008 
0204 6ED0 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6ED2 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6ED4 8350 
0206                                                   ; Get error byte from @>8350
0207 6ED6 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6ED8 06C0  14         swpb  r0                    ;
0215 6EDA D800  38         movb  r0,@vdpa              ; send low byte
     6EDC 8C02 
0216 6EDE 06C0  14         swpb  r0                    ;
0217 6EE0 D800  38         movb  r0,@vdpa              ; send high byte
     6EE2 8C02 
0218 6EE4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6EE6 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6EE8 09D1  56         srl   r1,13                 ; just keep error bits
0226 6EEA 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6EEC 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6EEE 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6EF0 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6EF2 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6EF4 06C1  14         swpb  r1                    ; put error in hi byte
0239 6EF6 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6EF8 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6EFA 6042 
0241 6EFC 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6EFE AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6F00 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6F02 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6F04 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6F06 C04B  18         mov   r11,r1                ; Save return address
0049 6F08 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6F0A 2428 
0050 6F0C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6F0E 04C5  14         clr   tmp1                  ; io.op.open
0052 6F10 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6F12 6162 
0053               file.open_init:
0054 6F14 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F16 0009 
0055 6F18 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F1A 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6F1C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F1E 6DEE 
0061 6F20 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6F22 1029  14         jmp   file.record.pab.details
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
0090 6F24 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6F26 C04B  18         mov   r11,r1                ; Save return address
0096 6F28 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6F2A 2428 
0097 6F2C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6F2E 0205  20         li    tmp1,io.op.close      ; io.op.close
     6F30 0001 
0099 6F32 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6F34 6162 
0100               file.close_init:
0101 6F36 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F38 0009 
0102 6F3A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F3C 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6F3E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F40 6DEE 
0108 6F42 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6F44 1018  14         jmp   file.record.pab.details
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
0139 6F46 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6F48 C04B  18         mov   r11,r1                ; Save return address
0145 6F4A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6F4C 2428 
0146 6F4E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6F50 0205  20         li    tmp1,io.op.read       ; io.op.read
     6F52 0002 
0148 6F54 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6F56 6162 
0149               file.record.read_init:
0150 6F58 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F5A 0009 
0151 6F5C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F5E 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6F60 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F62 6DEE 
0157 6F64 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6F66 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6F68 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6F6A 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6F6C 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6F6E 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6F70 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6F72 1000  14         nop
0191               
0192               
0193               file.status:
0194 6F74 1000  14         nop
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
0211 6F76 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6F78 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6F7A 2428 
0219 6F7C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F7E 0005 
0220 6F80 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F82 617A 
0221 6F84 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6F86 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6F88 0451  20         b     *r1                   ; Return to caller
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
0020 6F8A 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F8C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F8E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F90 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F92 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F94 6042 
0029 6F96 1602  14         jne   tmgr1a                ; No, so move on
0030 6F98 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F9A 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F9C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F9E 6046 
0035 6FA0 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6FA2 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6FA4 6036 
0048 6FA6 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6FA8 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6FAA 6034 
0050 6FAC 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6FAE 0460  28         b     @kthread              ; Run kernel thread
     6FB0 7028 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6FB2 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6FB4 603A 
0056 6FB6 13EB  14         jeq   tmgr1
0057 6FB8 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6FBA 6038 
0058 6FBC 16E8  14         jne   tmgr1
0059 6FBE C120  34         mov   @wtiusr,tmp0
     6FC0 832E 
0060 6FC2 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6FC4 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6FC6 7026 
0065 6FC8 C10A  18         mov   r10,tmp0
0066 6FCA 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6FCC 00FF 
0067 6FCE 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6FD0 6042 
0068 6FD2 1303  14         jeq   tmgr5
0069 6FD4 0284  22         ci    tmp0,60               ; 1 second reached ?
     6FD6 003C 
0070 6FD8 1002  14         jmp   tmgr6
0071 6FDA 0284  22 tmgr5   ci    tmp0,50
     6FDC 0032 
0072 6FDE 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6FE0 1001  14         jmp   tmgr8
0074 6FE2 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6FE4 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6FE6 832C 
0079 6FE8 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6FEA FF00 
0080 6FEC C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6FEE 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6FF0 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6FF2 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6FF4 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6FF6 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6FF8 830C 
     6FFA 830D 
0089 6FFC 1608  14         jne   tmgr10                ; No, get next slot
0090 6FFE 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     7000 FF00 
0091 7002 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7004 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     7006 8330 
0096 7008 0697  24         bl    *tmp3                 ; Call routine in slot
0097 700A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     700C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 700E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 7010 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7012 8315 
     7014 8314 
0103 7016 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 7018 05C4  14         inct  tmp0                  ; Offset for next slot
0105 701A 10E8  14         jmp   tmgr9                 ; Process next slot
0106 701C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 701E 10F7  14         jmp   tmgr10                ; Process next slot
0108 7020 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     7022 FF00 
0109 7024 10B4  14         jmp   tmgr1
0110 7026 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 7028 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     702A 6036 
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
0041 702C 06A0  32         bl    @realkb               ; Scan full keyboard
     702E 64D0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7030 0460  28         b     @tmgr3                ; Exit
     7032 6FB2 
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
0017 7034 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     7036 832E 
0018 7038 E0A0  34         soc   @wbit7,config         ; Enable user hook
     703A 6038 
0019 703C 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F8E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 703E 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7040 832E 
0029 7042 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     7044 FEFF 
0030 7046 045B  20         b     *r11                  ; Return
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
0017 7048 C13B  30 mkslot  mov   *r11+,tmp0
0018 704A C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 704C C184  18         mov   tmp0,tmp2
0023 704E 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 7050 A1A0  34         a     @wtitab,tmp2          ; Add table base
     7052 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 7054 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 7056 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7058 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 705A 881B  46         c     *r11,@w$ffff          ; End of list ?
     705C 6048 
0035 705E 1301  14         jeq   mkslo1                ; Yes, exit
0036 7060 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 7062 05CB  14 mkslo1  inct  r11
0041 7064 045B  20         b     *r11                  ; Exit
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
0052 7066 C13B  30 clslot  mov   *r11+,tmp0
0053 7068 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 706A A120  34         a     @wtitab,tmp0          ; Add table base
     706C 832C 
0055 706E 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7070 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 7072 045B  20         b     *r11                  ; Exit
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
0247 7074 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     7076 67B2 
0248 7078 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     707A 8302 
0252               *--------------------------------------------------------------
0253               * Alternative entry point
0254               *--------------------------------------------------------------
0255 707C 0300  24 runli1  limi  0                     ; Turn off interrupts
     707E 0000 
0256 7080 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7082 8300 
0257 7084 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7086 83C0 
0258               *--------------------------------------------------------------
0259               * Clear scratch-pad memory from R4 upwards
0260               *--------------------------------------------------------------
0261 7088 0202  20 runli2  li    r2,>8308
     708A 8308 
0262 708C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0263 708E 0282  22         ci    r2,>8400
     7090 8400 
0264 7092 16FC  14         jne   runli3
0265               *--------------------------------------------------------------
0266               * Exit to TI-99/4A title screen ?
0267               *--------------------------------------------------------------
0268               runli3a
0269 7094 0281  22         ci    r1,>ffff              ; Exit flag set ?
     7096 FFFF 
0270 7098 1602  14         jne   runli4                ; No, continue
0271 709A 0420  54         blwp  @0                    ; Yes, bye bye
     709C 0000 
0272               *--------------------------------------------------------------
0273               * Determine if VDP is PAL or NTSC
0274               *--------------------------------------------------------------
0275 709E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     70A0 833C 
0276 70A2 04C1  14         clr   r1                    ; Reset counter
0277 70A4 0202  20         li    r2,10                 ; We test 10 times
     70A6 000A 
0278 70A8 C0E0  34 runli5  mov   @vdps,r3
     70AA 8802 
0279 70AC 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     70AE 6046 
0280 70B0 1302  14         jeq   runli6
0281 70B2 0581  14         inc   r1                    ; Increase counter
0282 70B4 10F9  14         jmp   runli5
0283 70B6 0602  14 runli6  dec   r2                    ; Next test
0284 70B8 16F7  14         jne   runli5
0285 70BA 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     70BC 1250 
0286 70BE 1202  14         jle   runli7                ; No, so it must be NTSC
0287 70C0 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     70C2 6042 
0288               *--------------------------------------------------------------
0289               * Copy machine code to scratchpad (prepare tight loop)
0290               *--------------------------------------------------------------
0291 70C4 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     70C6 60BA 
0292 70C8 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     70CA 8322 
0293 70CC CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0294 70CE CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0295 70D0 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0296               *--------------------------------------------------------------
0297               * Initialize registers, memory, ...
0298               *--------------------------------------------------------------
0299 70D2 04C1  14 runli9  clr   r1
0300 70D4 04C2  14         clr   r2
0301 70D6 04C3  14         clr   r3
0302 70D8 0209  20         li    stack,>8400           ; Set stack
     70DA 8400 
0303 70DC 020F  20         li    r15,vdpw              ; Set VDP write address
     70DE 8C00 
0307               *--------------------------------------------------------------
0308               * Setup video memory
0309               *--------------------------------------------------------------
0311 70E0 0280  22         ci    r0,>4a4a              ; Crash flag set?
     70E2 4A4A 
0312 70E4 1605  14         jne   runlia
0313 70E6 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     70E8 6124 
0314 70EA 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     70EC 0000 
     70EE 3FFF 
0319 70F0 06A0  32 runlia  bl    @filv
     70F2 6124 
0320 70F4 0FC0             data  pctadr,spfclr,16      ; Load color table
     70F6 00F4 
     70F8 0010 
0321               *--------------------------------------------------------------
0322               * Check if there is a F18A present
0323               *--------------------------------------------------------------
0327 70FA 06A0  32         bl    @f18unl               ; Unlock the F18A
     70FC 6418 
0328 70FE 06A0  32         bl    @f18chk               ; Check if F18A is there
     7100 6432 
0329 7102 06A0  32         bl    @f18lck               ; Lock the F18A again
     7104 6428 
0331               *--------------------------------------------------------------
0332               * Check if there is a speech synthesizer attached
0333               *--------------------------------------------------------------
0335               *       <<skipped>>
0339               *--------------------------------------------------------------
0340               * Load video mode table & font
0341               *--------------------------------------------------------------
0342 7106 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7108 618E 
0343 710A 60B0             data  spvmod                ; Equate selected video mode table
0344 710C 0204  20         li    tmp0,spfont           ; Get font option
     710E 000C 
0345 7110 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0346 7112 1304  14         jeq   runlid                ; Yes, skip it
0347 7114 06A0  32         bl    @ldfnt
     7116 61F6 
0348 7118 1100             data  fntadr,spfont         ; Load specified font
     711A 000C 
0349               *--------------------------------------------------------------
0350               * Did a system crash occur before runlib was called?
0351               *--------------------------------------------------------------
0352 711C 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     711E 4A4A 
0353 7120 1602  14         jne   runlie                ; No, continue
0354 7122 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     7124 6060 
0355               *--------------------------------------------------------------
0356               * Branch to main program
0357               *--------------------------------------------------------------
0358 7126 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7128 0040 
0359 712A 0460  28         b     @main                 ; Give control to main program
     712C 712E 
**** **** ****     > tivi.asm.2093
0212               
0213               *--------------------------------------------------------------
0214               * Video mode configuration
0215               *--------------------------------------------------------------
0216      60B0     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0217      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0218      0050     colrow  equ   80                    ; Columns per row
0219      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0220      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0221      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0222      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0223               
0224               
0225               ***************************************************************
0226               * Main
0227               ********@*****@*********************@**************************
0228 712E 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     7130 6044 
0229 7132 1302  14         jeq   main.continue
0230 7134 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     7136 0000 
0231               
0232               main.continue:
0233 7138 06A0  32         bl    @scroff               ; Turn screen off
     713A 6374 
0234 713C 06A0  32         bl    @f18unl               ; Unlock the F18a
     713E 6418 
0235 7140 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     7142 61C8 
0236 7144 3140                   data >3140            ; F18a VR49 (>31), bit 40
0237                       ;------------------------------------------------------
0238                       ; Initialize VDP SIT
0239                       ;------------------------------------------------------
0240 7146 06A0  32         bl    @filv
     7148 6124 
0241 714A 0000                   data >0000,32,31*80   ; Clear VDP SIT
     714C 0020 
     714E 09B0 
0242 7150 06A0  32         bl    @scron                ; Turn screen on
     7152 637C 
0243                       ;------------------------------------------------------
0244                       ; Initialize low + high memory expansion
0245                       ;------------------------------------------------------
0246 7154 06A0  32         bl    @film
     7156 60D0 
0247 7158 2200                   data >2200,00,8*1024-256*2
     715A 0000 
     715C 3E00 
0248                                                   ; Clear part of 8k low-memory
0249               
0250 715E 06A0  32         bl    @film
     7160 60D0 
0251 7162 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     7164 0000 
     7166 6000 
0252                       ;------------------------------------------------------
0253                       ; Setup cursor, screen, etc.
0254                       ;------------------------------------------------------
0255 7168 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     716A 6394 
0256 716C 06A0  32         bl    @s8x8                 ; Small sprite
     716E 63A4 
0257               
0258 7170 06A0  32         bl    @cpym2m
     7172 6316 
0259 7174 7E64                   data romsat,ramsat,4  ; Load sprite SAT
     7176 8380 
     7178 0004 
0260               
0261 717A C820  54         mov   @romsat+2,@fb.curshape
     717C 7E66 
     717E 2210 
0262                                                   ; Save cursor shape & color
0263               
0264 7180 06A0  32         bl    @cpym2v
     7182 62CE 
0265 7184 1800                   data sprpdt,cursors,3*8
     7186 7E68 
     7188 0018 
0266                                                   ; Load sprite cursor patterns
0267               *--------------------------------------------------------------
0268               * Initialize
0269               *--------------------------------------------------------------
0270 718A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     718C 7AD0 
0271 718E 06A0  32         bl    @idx.init             ; Initialize index
     7190 7A0A 
0272 7192 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7194 792E 
0273               
0274                       ;-------------------------------------------------------
0275                       ; Setup editor tasks & hook
0276                       ;-------------------------------------------------------
0277 7196 0204  20         li    tmp0,>0200
     7198 0200 
0278 719A C804  38         mov   tmp0,@btihi           ; Highest slot in use
     719C 8314 
0279               
0280 719E 06A0  32         bl    @at
     71A0 63B4 
0281 71A2 0000             data  >0000                 ; Cursor YX position = >0000
0282               
0283 71A4 0204  20         li    tmp0,timers
     71A6 8370 
0284 71A8 C804  38         mov   tmp0,@wtitab
     71AA 832C 
0285               
0286 71AC 06A0  32         bl    @mkslot
     71AE 7048 
0287 71B0 0001                   data >0001,task0      ; Task 0 - Update screen
     71B2 77A8 
0288 71B4 0101                   data >0101,task1      ; Task 1 - Update cursor position
     71B6 782C 
0289 71B8 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     71BA 783A 
     71BC FFFF 
0290               
0291 71BE 06A0  32         bl    @mkhook
     71C0 7034 
0292 71C2 71C8                   data editor           ; Setup user hook
0293               
0294 71C4 0460  28         b     @tmgr                 ; Start timers and kthread
     71C6 6F8A 
0295               
0296               
0297               ****************************************************************
0298               * Editor - Main loop
0299               ****************************************************************
0300 71C8 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     71CA 6030 
0301 71CC 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0302               *---------------------------------------------------------------
0303               * Identical key pressed ?
0304               *---------------------------------------------------------------
0305 71CE 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     71D0 6030 
0306 71D2 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     71D4 833C 
     71D6 833E 
0307 71D8 1308  14         jeq   ed_wait
0308               *--------------------------------------------------------------
0309               * New key pressed
0310               *--------------------------------------------------------------
0311               ed_new_key
0312 71DA C820  54         mov   @waux1,@waux2         ; Save as previous key
     71DC 833C 
     71DE 833E 
0313 71E0 1045  14         jmp   edkey                 ; Process key
0314               *--------------------------------------------------------------
0315               * Clear keyboard buffer if no key pressed
0316               *--------------------------------------------------------------
0317               ed_clear_kbbuffer
0318 71E2 04E0  34         clr   @waux1
     71E4 833C 
0319 71E6 04E0  34         clr   @waux2
     71E8 833E 
0320               *--------------------------------------------------------------
0321               * Delay to avoid key bouncing
0322               *--------------------------------------------------------------
0323               ed_wait
0324 71EA 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     71EC 0708 
0325                       ;------------------------------------------------------
0326                       ; Delay loop
0327                       ;------------------------------------------------------
0328               ed_wait_loop
0329 71EE 0604  14         dec   tmp0
0330 71F0 16FE  14         jne   ed_wait_loop
0331               *--------------------------------------------------------------
0332               * Exit
0333               *--------------------------------------------------------------
0334 71F2 0460  28 ed_exit b     @hookok               ; Return
     71F4 6F8E 
0335               
0336               
0337               
0338               
0339               
0340               
0341               ***************************************************************
0342               *                Tivi - Editor keyboard actions
0343               ***************************************************************
0344                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 71F6 0D00             data  key_enter,edkey.action.enter          ; New line
     71F8 765A 
0056 71FA 0800             data  key_left,edkey.action.left            ; Move cursor left
     71FC 728E 
0057 71FE 0900             data  key_right,edkey.action.right          ; Move cursor right
     7200 72A4 
0058 7202 0B00             data  key_up,edkey.action.up                ; Move cursor up
     7204 72BC 
0059 7206 0A00             data  key_down,edkey.action.down            ; Move cursor down
     7208 730E 
0060 720A 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     720C 737A 
0061 720E 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     7210 7392 
0062 7212 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     7214 73A6 
0063 7216 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     7218 73F8 
0064 721A 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     721C 7458 
0065 721E 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     7220 74A2 
0066 7222 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     7224 74CE 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 7226 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     7228 74FC 
0071 722A 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     722C 7534 
0072 722E 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     7230 7568 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 7232 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     7234 75C0 
0077 7236 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     7238 76C8 
0078 723A 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     723C 7616 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 723E 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     7240 7718 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 7242 B000             data  key_buf0,edkey.action.buffer0
     7244 7764 
0087 7246 B100             data  key_buf1,edkey.action.buffer1
     7248 776E 
0088 724A B200             data  key_buf2,edkey.action.buffer2
     724C 7774 
0089 724E B300             data  key_buf3,edkey.action.buffer3
     7250 777E 
0090 7252 B400             data  key_buf4,edkey.action.buffer4
     7254 7784 
0091 7256 B500             data  key_buf5,edkey.action.buffer5
     7258 778A 
0092 725A B600             data  key_buf6,edkey.action.buffer6
     725C 7790 
0093 725E B700             data  key_buf7,edkey.action.buffer7
     7260 7796 
0094 7262 9E00             data  key_buf8,edkey.action.buffer8
     7264 779C 
0095 7266 9F00             data  key_buf9,edkey.action.buffer9
     7268 77A2 
0096 726A FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 726C C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     726E 833C 
0104 7270 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     7272 FF00 
0105               
0106 7274 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     7276 71F6 
0107 7278 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 727A 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 727C 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 727E 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 7280 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 7282 05C6  14         inct  tmp2                  ; No, skip action
0118 7284 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 7286 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 7288 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 728A 0460  28         b    @edkey.action.char     ; Add character to buffer
     728C 76D8 
**** **** ****     > tivi.asm.2093
0345                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 728E C120  34         mov   @fb.column,tmp0
     7290 220C 
0010 7292 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 7294 0620  34         dec   @fb.column            ; Column-- in screen buffer
     7296 220C 
0015 7298 0620  34         dec   @wyx                  ; Column-- VDP cursor
     729A 832A 
0016 729C 0620  34         dec   @fb.current
     729E 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 72A0 0460  28 !       b     @ed_wait              ; Back to editor main
     72A2 71EA 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 72A4 8820  54         c     @fb.column,@fb.row.length
     72A6 220C 
     72A8 2208 
0028 72AA 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 72AC 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     72AE 220C 
0033 72B0 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     72B2 832A 
0034 72B4 05A0  34         inc   @fb.current
     72B6 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 72B8 0460  28 !       b     @ed_wait              ; Back to editor main
     72BA 71EA 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 72BC 8820  54         c     @fb.row.dirty,@w$ffff
     72BE 220A 
     72C0 6048 
0049 72C2 1604  14         jne   edkey.action.up.cursor
0050 72C4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72C6 7AF0 
0051 72C8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72CA 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 72CC C120  34         mov   @fb.row,tmp0
     72CE 2206 
0057 72D0 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 72D2 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     72D4 2204 
0060 72D6 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 72D8 0604  14         dec   tmp0                  ; fb.topline--
0066 72DA C804  38         mov   tmp0,@parm1
     72DC 8350 
0067 72DE 06A0  32         bl    @fb.refresh           ; Scroll one line up
     72E0 7998 
0068 72E2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 72E4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     72E6 2206 
0074 72E8 06A0  32         bl    @up                   ; Row-- VDP cursor
     72EA 63C2 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 72EC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     72EE 7C36 
0080 72F0 8820  54         c     @fb.column,@fb.row.length
     72F2 220C 
     72F4 2208 
0081 72F6 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 72F8 C820  54         mov   @fb.row.length,@fb.column
     72FA 2208 
     72FC 220C 
0086 72FE C120  34         mov   @fb.column,tmp0
     7300 220C 
0087 7302 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7304 63CC 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 7306 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7308 797C 
0093 730A 0460  28         b     @ed_wait              ; Back to editor main
     730C 71EA 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 730E 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     7310 2206 
     7312 2304 
0102 7314 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 7316 8820  54         c     @fb.row.dirty,@w$ffff
     7318 220A 
     731A 6048 
0107 731C 1604  14         jne   edkey.action.down.move
0108 731E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7320 7AF0 
0109 7322 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7324 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 7326 C120  34         mov   @fb.topline,tmp0
     7328 2204 
0118 732A A120  34         a     @fb.row,tmp0
     732C 2206 
0119 732E 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     7330 2304 
0120 7332 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 7334 C120  34         mov   @fb.screenrows,tmp0
     7336 2218 
0126 7338 0604  14         dec   tmp0
0127 733A 8120  34         c     @fb.row,tmp0
     733C 2206 
0128 733E 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 7340 C820  54         mov   @fb.topline,@parm1
     7342 2204 
     7344 8350 
0133 7346 05A0  34         inc   @parm1
     7348 8350 
0134 734A 06A0  32         bl    @fb.refresh
     734C 7998 
0135 734E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 7350 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7352 2206 
0141 7354 06A0  32         bl    @down                 ; Row++ VDP cursor
     7356 63BA 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 7358 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     735A 7C36 
0147 735C 8820  54         c     @fb.column,@fb.row.length
     735E 220C 
     7360 2208 
0148 7362 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 7364 C820  54         mov   @fb.row.length,@fb.column
     7366 2208 
     7368 220C 
0153 736A C120  34         mov   @fb.column,tmp0
     736C 220C 
0154 736E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7370 63CC 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 7372 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7374 797C 
0160 7376 0460  28 !       b     @ed_wait              ; Back to editor main
     7378 71EA 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 737A C120  34         mov   @wyx,tmp0
     737C 832A 
0169 737E 0244  22         andi  tmp0,>ff00
     7380 FF00 
0170 7382 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     7384 832A 
0171 7386 04E0  34         clr   @fb.column
     7388 220C 
0172 738A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     738C 797C 
0173 738E 0460  28         b     @ed_wait              ; Back to editor main
     7390 71EA 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 7392 C120  34         mov   @fb.row.length,tmp0
     7394 2208 
0180 7396 C804  38         mov   tmp0,@fb.column
     7398 220C 
0181 739A 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     739C 63CC 
0182 739E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73A0 797C 
0183 73A2 0460  28         b     @ed_wait              ; Back to editor main
     73A4 71EA 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 73A6 C120  34         mov   @fb.column,tmp0
     73A8 220C 
0192 73AA 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 73AC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     73AE 2202 
0197 73B0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 73B2 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 73B4 0605  14         dec   tmp1
0204 73B6 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 73B8 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 73BA D195  26         movb  *tmp1,tmp2            ; Get character
0212 73BC 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 73BE D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 73C0 0986  56         srl   tmp2,8                ; Right justify
0215 73C2 0286  22         ci    tmp2,32               ; Space character found?
     73C4 0020 
0216 73C6 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 73C8 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     73CA 2020 
0222 73CC 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 73CE 0287  22         ci    tmp3,>20ff            ; First character is space
     73D0 20FF 
0225 73D2 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 73D4 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     73D6 220C 
0230 73D8 61C4  18         s     tmp0,tmp3
0231 73DA 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     73DC 0002 
0232 73DE 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 73E0 0585  14         inc   tmp1
0238 73E2 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 73E4 C805  38         mov   tmp1,@fb.current
     73E6 2202 
0244 73E8 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     73EA 220C 
0245 73EC 06A0  32         bl    @xsetx                ; Set VDP cursor X
     73EE 63CC 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 73F0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73F2 797C 
0251 73F4 0460  28 !       b     @ed_wait              ; Back to editor main
     73F6 71EA 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 73F8 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 73FA C120  34         mov   @fb.column,tmp0
     73FC 220C 
0261 73FE 8804  38         c     tmp0,@fb.row.length
     7400 2208 
0262 7402 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 7404 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7406 2202 
0267 7408 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 740A 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 740C 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 740E 0585  14         inc   tmp1
0279 7410 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 7412 8804  38         c     tmp0,@fb.row.length
     7414 2208 
0281 7416 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 7418 D195  26         movb  *tmp1,tmp2            ; Get character
0288 741A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 741C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 741E 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 7420 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7422 FFFF 
0293 7424 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 7426 0286  22         ci    tmp2,32
     7428 0020 
0299 742A 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 742C 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 742E 0286  22         ci    tmp2,32               ; Space character found?
     7430 0020 
0307 7432 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 7434 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7436 2020 
0313 7438 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 743A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     743C 20FF 
0316 743E 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 7440 0585  14         inc   tmp1
0321 7442 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 7444 C805  38         mov   tmp1,@fb.current
     7446 2202 
0327 7448 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     744A 220C 
0328 744C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     744E 63CC 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 7450 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7452 797C 
0334 7454 0460  28 !       b     @ed_wait              ; Back to editor main
     7456 71EA 
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
0346 7458 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     745A 2204 
0347 745C 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 745E 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     7460 2218 
0352 7462 1503  14         jgt   edkey.action.ppage.topline
0353 7464 04E0  34         clr   @fb.topline           ; topline = 0
     7466 2204 
0354 7468 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 746A 6820  54         s     @fb.screenrows,@fb.topline
     746C 2218 
     746E 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 7470 8820  54         c     @fb.row.dirty,@w$ffff
     7472 220A 
     7474 6048 
0365 7476 1604  14         jne   edkey.action.ppage.refresh
0366 7478 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     747A 7AF0 
0367 747C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     747E 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 7480 C820  54         mov   @fb.topline,@parm1
     7482 2204 
     7484 8350 
0373 7486 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7488 7998 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 748A 04E0  34         clr   @fb.row
     748C 2206 
0379 748E 05A0  34         inc   @fb.row               ; Set fb.row=1
     7490 2206 
0380 7492 04E0  34         clr   @fb.column
     7494 220C 
0381 7496 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7498 0100 
0382 749A C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     749C 832A 
0383 749E 0460  28         b     @edkey.action.up      ; Do rest of logic
     74A0 72BC 
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
0394 74A2 C120  34         mov   @fb.topline,tmp0
     74A4 2204 
0395 74A6 A120  34         a     @fb.screenrows,tmp0
     74A8 2218 
0396 74AA 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     74AC 2304 
0397 74AE 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 74B0 A820  54         a     @fb.screenrows,@fb.topline
     74B2 2218 
     74B4 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 74B6 8820  54         c     @fb.row.dirty,@w$ffff
     74B8 220A 
     74BA 6048 
0408 74BC 1604  14         jne   edkey.action.npage.refresh
0409 74BE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     74C0 7AF0 
0410 74C2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     74C4 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 74C6 0460  28         b     @edkey.action.ppage.refresh
     74C8 7480 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 74CA 0460  28         b     @ed_wait              ; Back to editor main
     74CC 71EA 
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
0433 74CE 8820  54         c     @fb.row.dirty,@w$ffff
     74D0 220A 
     74D2 6048 
0434 74D4 1604  14         jne   edkey.action.top.refresh
0435 74D6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     74D8 7AF0 
0436 74DA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     74DC 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 74DE 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     74E0 2204 
0442 74E2 04E0  34         clr   @parm1
     74E4 8350 
0443 74E6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     74E8 7998 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 74EA 04E0  34         clr   @fb.row               ; Editor line 0
     74EC 2206 
0449 74EE 04E0  34         clr   @fb.column            ; Editor column 0
     74F0 220C 
0450 74F2 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 74F4 C804  38         mov   tmp0,@wyx             ;
     74F6 832A 
0452 74F8 0460  28         b     @ed_wait              ; Back to editor main
     74FA 71EA 
**** **** ****     > tivi.asm.2093
0346                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 74FC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     74FE 2306 
0010 7500 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7502 797C 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 7504 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7506 2202 
0015 7508 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     750A 2208 
0016 750C 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 750E 8820  54         c     @fb.column,@fb.row.length
     7510 220C 
     7512 2208 
0022 7514 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 7516 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7518 2202 
0028 751A C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 751C 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 751E DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7520 0606  14         dec   tmp2
0036 7522 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 7524 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7526 220A 
0041 7528 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     752A 2216 
0042 752C 0620  34         dec   @fb.row.length        ; @fb.row.length--
     752E 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7530 0460  28         b     @ed_wait              ; Back to editor main
     7532 71EA 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 7534 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7536 2306 
0055 7538 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     753A 797C 
0056 753C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     753E 2208 
0057 7540 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 7542 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7544 2202 
0063 7546 C1A0  34         mov   @fb.colsline,tmp2
     7548 220E 
0064 754A 61A0  34         s     @fb.column,tmp2
     754C 220C 
0065 754E 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 7550 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 7552 0606  14         dec   tmp2
0072 7554 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 7556 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7558 220A 
0077 755A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     755C 2216 
0078               
0079 755E C820  54         mov   @fb.column,@fb.row.length
     7560 220C 
     7562 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 7564 0460  28         b     @ed_wait              ; Back to editor main
     7566 71EA 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7568 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     756A 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 756C C120  34         mov   @edb.lines,tmp0
     756E 2304 
0097 7570 1604  14         jne   !
0098 7572 04E0  34         clr   @fb.column            ; Column 0
     7574 220C 
0099 7576 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7578 7534 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 757A 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     757C 797C 
0104 757E 04E0  34         clr   @fb.row.dirty         ; Discard current line
     7580 220A 
0105 7582 C820  54         mov   @fb.topline,@parm1
     7584 2204 
     7586 8350 
0106 7588 A820  54         a     @fb.row,@parm1        ; Line number to remove
     758A 2206 
     758C 8350 
0107 758E C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7590 2304 
     7592 8352 
0108 7594 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7596 7A44 
0109 7598 0620  34         dec   @edb.lines            ; One line less in editor buffer
     759A 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 759C C820  54         mov   @fb.topline,@parm1
     759E 2204 
     75A0 8350 
0114 75A2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     75A4 7998 
0115 75A6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     75A8 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 75AA C120  34         mov   @fb.topline,tmp0
     75AC 2204 
0120 75AE A120  34         a     @fb.row,tmp0
     75B0 2206 
0121 75B2 8804  38         c     tmp0,@edb.lines       ; Was last line?
     75B4 2304 
0122 75B6 1202  14         jle   edkey.action.del_line.exit
0123 75B8 0460  28         b     @edkey.action.up      ; One line up
     75BA 72BC 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 75BC 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     75BE 737A 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 75C0 0204  20         li    tmp0,>2000            ; White space
     75C2 2000 
0139 75C4 C804  38         mov   tmp0,@parm1
     75C6 8350 
0140               edkey.action.ins_char:
0141 75C8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     75CA 2306 
0142 75CC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     75CE 797C 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 75D0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     75D2 2202 
0147 75D4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     75D6 2208 
0148 75D8 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 75DA 8820  54         c     @fb.column,@fb.row.length
     75DC 220C 
     75DE 2208 
0154 75E0 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 75E2 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 75E4 61E0  34         s     @fb.column,tmp3
     75E6 220C 
0162 75E8 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 75EA C144  18         mov   tmp0,tmp1
0164 75EC 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 75EE 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     75F0 220C 
0166 75F2 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 75F4 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 75F6 0604  14         dec   tmp0
0173 75F8 0605  14         dec   tmp1
0174 75FA 0606  14         dec   tmp2
0175 75FC 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 75FE D560  46         movb  @parm1,*tmp1
     7600 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 7602 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7604 220A 
0184 7606 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7608 2216 
0185 760A 05A0  34         inc   @fb.row.length        ; @fb.row.length
     760C 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 760E 0460  28         b     @edkey.action.char.overwrite
     7610 76EA 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 7612 0460  28         b     @ed_wait              ; Back to editor main
     7614 71EA 
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
0206 7616 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7618 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 761A 8820  54         c     @fb.row.dirty,@w$ffff
     761C 220A 
     761E 6048 
0211 7620 1604  14         jne   edkey.action.ins_line.insert
0212 7622 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7624 7AF0 
0213 7626 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7628 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 762A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     762C 797C 
0219 762E C820  54         mov   @fb.topline,@parm1
     7630 2204 
     7632 8350 
0220 7634 A820  54         a     @fb.row,@parm1        ; Line number to insert
     7636 2206 
     7638 8350 
0221               
0222 763A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     763C 2304 
     763E 8352 
0223 7640 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7642 7A6E 
0224 7644 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     7646 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 7648 C820  54         mov   @fb.topline,@parm1
     764A 2204 
     764C 8350 
0229 764E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7650 7998 
0230 7652 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7654 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 7656 0460  28         b     @ed_wait              ; Back to editor main
     7658 71EA 
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
0249 765A 8820  54         c     @fb.row.dirty,@w$ffff
     765C 220A 
     765E 6048 
0250 7660 1606  14         jne   edkey.action.enter.upd_counter
0251 7662 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7664 2306 
0252 7666 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7668 7AF0 
0253 766A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     766C 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 766E C120  34         mov   @fb.topline,tmp0
     7670 2204 
0259 7672 A120  34         a     @fb.row,tmp0
     7674 2206 
0260 7676 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7678 2304 
0261 767A 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 767C 05A0  34         inc   @edb.lines            ; Total lines++
     767E 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 7680 C120  34         mov   @fb.screenrows,tmp0
     7682 2218 
0271 7684 0604  14         dec   tmp0
0272 7686 8120  34         c     @fb.row,tmp0
     7688 2206 
0273 768A 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 768C C120  34         mov   @fb.screenrows,tmp0
     768E 2218 
0278 7690 C820  54         mov   @fb.topline,@parm1
     7692 2204 
     7694 8350 
0279 7696 05A0  34         inc   @parm1
     7698 8350 
0280 769A 06A0  32         bl    @fb.refresh
     769C 7998 
0281 769E 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 76A0 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     76A2 2206 
0287 76A4 06A0  32         bl    @down                 ; Row++ VDP cursor
     76A6 63BA 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 76A8 06A0  32         bl    @fb.get.firstnonblank
     76AA 79C2 
0293 76AC C120  34         mov   @outparm1,tmp0
     76AE 8360 
0294 76B0 C804  38         mov   tmp0,@fb.column
     76B2 220C 
0295 76B4 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     76B6 63CC 
0296 76B8 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     76BA 7C36 
0297 76BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     76BE 797C 
0298 76C0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     76C2 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 76C4 0460  28         b     @ed_wait              ; Back to editor main
     76C6 71EA 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 76C8 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     76CA 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 76CC 0204  20         li    tmp0,2000
     76CE 07D0 
0317               edkey.action.ins_onoff.loop:
0318 76D0 0604  14         dec   tmp0
0319 76D2 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 76D4 0460  28         b     @task2.cur_visible    ; Update cursor shape
     76D6 7846 
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
0335 76D8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     76DA 2306 
0336 76DC D805  38         movb  tmp1,@parm1           ; Store character for insert
     76DE 8350 
0337 76E0 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     76E2 230C 
0338 76E4 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 76E6 0460  28         b     @edkey.action.ins_char
     76E8 75C8 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 76EA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     76EC 797C 
0349 76EE C120  34         mov   @fb.current,tmp0      ; Get pointer
     76F0 2202 
0350               
0351 76F2 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     76F4 8350 
0352 76F6 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     76F8 220A 
0353 76FA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     76FC 2216 
0354               
0355 76FE 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7700 220C 
0356 7702 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7704 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 7706 8820  54         c     @fb.column,@fb.row.length
     7708 220C 
     770A 2208 
0361 770C 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 770E C820  54         mov   @fb.column,@fb.row.length
     7710 220C 
     7712 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 7714 0460  28         b     @ed_wait              ; Back to editor main
     7716 71EA 
**** **** ****     > tivi.asm.2093
0347                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 7718 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     771A 647C 
0010 771C 0420  54         blwp  @0                    ; Exit
     771E 0000 
0011               
**** **** ****     > tivi.asm.2093
0348                       copy  "editorkeys_file.asm" ; Actions for file related keys
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
0016 7720 C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     7722 8350 
     7724 8352 
0017 7726 C804  38         mov   tmp0,@parm1           ; Setup file to load
     7728 8350 
0018               
0019 772A 06A0  32         bl    @edb.init             ; Initialize editor buffer
     772C 7AD0 
0020 772E 06A0  32         bl    @idx.init             ; Initialize index
     7730 7A0A 
0021 7732 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7734 792E 
0022 7736 C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     7738 8352 
     773A 230E 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 773C 06A0  32         bl    @filv
     773E 6124 
0027 7740 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7742 0000 
     7744 0004 
0028               
0029 7746 C160  34         mov   @fb.screenrows,tmp1
     7748 2218 
0030 774A 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     774C 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 774E 04C4  14         clr   tmp0                  ; VDP target address
0034 7750 0205  20         li    tmp1,32               ; Character to fill
     7752 0020 
0035               
0036 7754 06A0  32         bl    @xfilv                ; Fill VDP memory
     7756 612A 
0037                                                   ; \ .  tmp0 = VDP target address
0038                                                   ; | .  tmp1 = Byte to fill
0039                                                   ; / .  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 7758 06A0  32         bl    @tfh.file.read        ; Read specified file
     775A 7C5A 
0044                                                   ; \ .  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / .  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 775C 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     775E 2306 
0048 7760 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     7762 74CE 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 7764 0204  20         li   tmp0,fdname0
     7766 7EB4 
0054 7768 0720  34         seto @parm1                 ; RLE encoding on
     776A 8350 
0055 776C 10D9  14         jmp  edkey.action.loadfile
0056                                                   ; Load DIS/VAR 80 file into editor buffer
0057               edkey.action.buffer1:
0058 776E 0204  20         li   tmp0,fdname1
     7770 7EC2 
0059 7772 10D6  14         jmp  edkey.action.loadfile
0060                                                   ; Load DIS/VAR 80 file into editor buffer
0061               
0062               edkey.action.buffer2:
0063 7774 0204  20         li   tmp0,fdname2
     7776 7ED2 
0064 7778 0720  34         seto @parm1                 ; RLE encoding on
     777A 8350 
0065 777C 10D1  14         jmp  edkey.action.loadfile
0066                                                   ; Load DIS/VAR 80 file into editor buffer
0067               
0068               edkey.action.buffer3:
0069 777E 0204  20         li   tmp0,fdname3
     7780 7EE0 
0070 7782 10CE  14         jmp  edkey.action.loadfile
0071                                                   ; Load DIS/VAR 80 file into editor buffer
0072               
0073               edkey.action.buffer4:
0074 7784 0204  20         li   tmp0,fdname4
     7786 7EEE 
0075 7788 10CB  14         jmp  edkey.action.loadfile
0076                                                   ; Load DIS/VAR 80 file into editor buffer
0077               
0078               edkey.action.buffer5:
0079 778A 0204  20         li   tmp0,fdname5
     778C 7EFC 
0080 778E 10C8  14         jmp  edkey.action.loadfile
0081                                                   ; Load DIS/VAR 80 file into editor buffer
0082               
0083               edkey.action.buffer6:
0084 7790 0204  20         li   tmp0,fdname6
     7792 7F0A 
0085 7794 10C5  14         jmp  edkey.action.loadfile
0086                                                   ; Load DIS/VAR 80 file into editor buffer
0087               
0088               edkey.action.buffer7:
0089 7796 0204  20         li   tmp0,fdname7
     7798 7F18 
0090 779A 10C2  14         jmp  edkey.action.loadfile
0091                                                   ; Load DIS/VAR 80 file into editor buffer
0092               
0093               edkey.action.buffer8:
0094 779C 0204  20         li   tmp0,fdname8
     779E 7F26 
0095 77A0 10BF  14         jmp  edkey.action.loadfile
0096                                                   ; Load DIS/VAR 80 file into editor buffer
0097               
0098               edkey.action.buffer9:
0099 77A2 0204  20         li   tmp0,fdname9
     77A4 7F34 
0100 77A6 10BC  14         jmp  edkey.action.loadfile
0101                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.2093
0349               
0350               
0351               
0352               ***************************************************************
0353               * Task 0 - Copy frame buffer to VDP
0354               ***************************************************************
0355 77A8 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     77AA 2216 
0356 77AC 133D  14         jeq   task0.$$              ; No, skip update
0357                       ;------------------------------------------------------
0358                       ; Determine how many rows to copy
0359                       ;------------------------------------------------------
0360 77AE 8820  54         c     @edb.lines,@fb.screenrows
     77B0 2304 
     77B2 2218 
0361 77B4 1103  14         jlt   task0.setrows.small
0362 77B6 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     77B8 2218 
0363 77BA 1003  14         jmp   task0.copy.framebuffer
0364                       ;------------------------------------------------------
0365                       ; Less lines in editor buffer as rows in frame buffer
0366                       ;------------------------------------------------------
0367               task0.setrows.small:
0368 77BC C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     77BE 2304 
0369 77C0 0585  14         inc   tmp1
0370                       ;------------------------------------------------------
0371                       ; Determine area to copy
0372                       ;------------------------------------------------------
0373               task0.copy.framebuffer:
0374 77C2 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     77C4 220E 
0375                                                   ; 16 bit part is in tmp2!
0376 77C6 04C4  14         clr   tmp0                  ; VDP target address
0377 77C8 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     77CA 2200 
0378                       ;------------------------------------------------------
0379                       ; Copy memory block
0380                       ;------------------------------------------------------
0381 77CC 06A0  32         bl    @xpym2v               ; Copy to VDP
     77CE 62D4 
0382                                                   ; tmp0 = VDP target address
0383                                                   ; tmp1 = RAM source address
0384                                                   ; tmp2 = Bytes to copy
0385 77D0 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     77D2 2216 
0386                       ;-------------------------------------------------------
0387                       ; Draw EOF marker at end-of-file
0388                       ;-------------------------------------------------------
0389 77D4 C120  34         mov   @edb.lines,tmp0
     77D6 2304 
0390 77D8 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     77DA 2204 
0391 77DC 0584  14         inc   tmp0                  ; Y++
0392 77DE 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     77E0 2218 
0393 77E2 1222  14         jle   task0.$$
0394                       ;-------------------------------------------------------
0395                       ; Draw EOF marker
0396                       ;-------------------------------------------------------
0397               task0.draw_marker:
0398 77E4 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     77E6 832A 
     77E8 2214 
0399 77EA 0A84  56         sla   tmp0,8                ; X=0
0400 77EC C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     77EE 832A 
0401 77F0 06A0  32         bl    @putstr
     77F2 62B4 
0402 77F4 7E82                   data txt_marker       ; Display *EOF*
0403                       ;-------------------------------------------------------
0404                       ; Draw empty line after (and below) EOF marker
0405                       ;-------------------------------------------------------
0406 77F6 06A0  32         bl    @setx
     77F8 63CA 
0407 77FA 0005                   data  5               ; Cursor after *EOF* string
0408               
0409 77FC C120  34         mov   @wyx,tmp0
     77FE 832A 
0410 7800 0984  56         srl   tmp0,8                ; Right justify
0411 7802 0584  14         inc   tmp0                  ; One time adjust
0412 7804 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7806 2218 
0413 7808 1303  14         jeq   !
0414 780A 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     780C 009B 
0415 780E 1002  14         jmp   task0.draw_marker.line
0416 7810 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     7812 004B 
0417                       ;-------------------------------------------------------
0418                       ; Draw empty line
0419                       ;-------------------------------------------------------
0420               task0.draw_marker.line:
0421 7814 0604  14         dec   tmp0                  ; One time adjust
0422 7816 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7818 6290 
0423 781A 0205  20         li    tmp1,32               ; Character to write (whitespace)
     781C 0020 
0424 781E 06A0  32         bl    @xfilv                ; Write characters
     7820 612A 
0425 7822 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7824 2214 
     7826 832A 
0426               *--------------------------------------------------------------
0427               * Task 0 - Exit
0428               *--------------------------------------------------------------
0429               task0.$$:
0430 7828 0460  28         b     @slotok
     782A 700A 
0431               
0432               
0433               
0434               ***************************************************************
0435               * Task 1 - Copy SAT to VDP
0436               ***************************************************************
0437 782C E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     782E 6046 
0438 7830 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     7832 63D6 
0439 7834 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7836 8380 
0440 7838 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0441               
0442               
0443               ***************************************************************
0444               * Task 2 - Update cursor shape (blink)
0445               ***************************************************************
0446 783A 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     783C 2212 
0447 783E 1303  14         jeq   task2.cur_visible
0448 7840 04E0  34         clr   @ramsat+2              ; Hide cursor
     7842 8382 
0449 7844 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0450               
0451               task2.cur_visible:
0452 7846 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7848 230C 
0453 784A 1303  14         jeq   task2.cur_visible.overwrite_mode
0454                       ;------------------------------------------------------
0455                       ; Cursor in insert mode
0456                       ;------------------------------------------------------
0457               task2.cur_visible.insert_mode:
0458 784C 0204  20         li    tmp0,>000f
     784E 000F 
0459 7850 1002  14         jmp   task2.cur_visible.cursorshape
0460                       ;------------------------------------------------------
0461                       ; Cursor in overwrite mode
0462                       ;------------------------------------------------------
0463               task2.cur_visible.overwrite_mode:
0464 7852 0204  20         li    tmp0,>020f
     7854 020F 
0465                       ;------------------------------------------------------
0466                       ; Set cursor shape
0467                       ;------------------------------------------------------
0468               task2.cur_visible.cursorshape:
0469 7856 C804  38         mov   tmp0,@fb.curshape
     7858 2210 
0470 785A C804  38         mov   tmp0,@ramsat+2
     785C 8382 
0471               
0472               
0473               
0474               
0475               
0476               
0477               
0478               *--------------------------------------------------------------
0479               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0480               *--------------------------------------------------------------
0481               task.sub_copy_ramsat
0482 785E 06A0  32         bl    @cpym2v
     7860 62CE 
0483 7862 2000                   data sprsat,ramsat,4   ; Update sprite
     7864 8380 
     7866 0004 
0484               
0485 7868 C820  54         mov   @wyx,@fb.yxsave
     786A 832A 
     786C 2214 
0486                       ;------------------------------------------------------
0487                       ; Show text editing mode
0488                       ;------------------------------------------------------
0489               task.botline.show_mode
0490 786E C120  34         mov   @edb.insmode,tmp0
     7870 230C 
0491 7872 1605  14         jne   task.botline.show_mode.insert
0492                       ;------------------------------------------------------
0493                       ; Overwrite mode
0494                       ;------------------------------------------------------
0495               task.botline.show_mode.overwrite:
0496 7874 06A0  32         bl    @putat
     7876 62C6 
0497 7878 1D32                   byte  29,50
0498 787A 7E8E                   data  txt_ovrwrite
0499 787C 1004  14         jmp   task.botline.show_changed
0500                       ;------------------------------------------------------
0501                       ; Insert  mode
0502                       ;------------------------------------------------------
0503               task.botline.show_mode.insert:
0504 787E 06A0  32         bl    @putat
     7880 62C6 
0505 7882 1D32                   byte  29,50
0506 7884 7E92                   data  txt_insert
0507                       ;------------------------------------------------------
0508                       ; Show if text was changed in editor buffer
0509                       ;------------------------------------------------------
0510               task.botline.show_changed:
0511 7886 C120  34         mov   @edb.dirty,tmp0
     7888 2306 
0512 788A 1305  14         jeq   task.botline.show_changed.clear
0513                       ;------------------------------------------------------
0514                       ; Show "*"
0515                       ;------------------------------------------------------
0516 788C 06A0  32         bl    @putat
     788E 62C6 
0517 7890 1D36                   byte 29,54
0518 7892 7E96                   data txt_star
0519 7894 1001  14         jmp   task.botline.show_linecol
0520                       ;------------------------------------------------------
0521                       ; Show "line,column"
0522                       ;------------------------------------------------------
0523               task.botline.show_changed.clear:
0524 7896 1000  14         nop
0525               task.botline.show_linecol:
0526 7898 C820  54         mov   @fb.row,@parm1
     789A 2206 
     789C 8350 
0527 789E 06A0  32         bl    @fb.row2line
     78A0 7968 
0528 78A2 05A0  34         inc   @outparm1
     78A4 8360 
0529                       ;------------------------------------------------------
0530                       ; Show line
0531                       ;------------------------------------------------------
0532 78A6 06A0  32         bl    @putnum
     78A8 66A6 
0533 78AA 1D40                   byte  29,64            ; YX
0534 78AC 8360                   data  outparm1,rambuf
     78AE 8390 
0535 78B0 3020                   byte  48               ; ASCII offset
0536                             byte  32               ; Padding character
0537                       ;------------------------------------------------------
0538                       ; Show comma
0539                       ;------------------------------------------------------
0540 78B2 06A0  32         bl    @putat
     78B4 62C6 
0541 78B6 1D45                   byte  29,69
0542 78B8 7E80                   data  txt_delim
0543                       ;------------------------------------------------------
0544                       ; Show column
0545                       ;------------------------------------------------------
0546 78BA 06A0  32         bl    @film
     78BC 60D0 
0547 78BE 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     78C0 0020 
     78C2 000C 
0548               
0549 78C4 C820  54         mov   @fb.column,@waux1
     78C6 220C 
     78C8 833C 
0550 78CA 05A0  34         inc   @waux1                 ; Offset 1
     78CC 833C 
0551               
0552 78CE 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     78D0 6628 
0553 78D2 833C                   data  waux1,rambuf
     78D4 8390 
0554 78D6 3020                   byte  48               ; ASCII offset
0555                             byte  32               ; Fill character
0556               
0557 78D8 06A0  32         bl    @trimnum               ; Trim number to the left
     78DA 6680 
0558 78DC 8390                   data  rambuf,rambuf+6,32
     78DE 8396 
     78E0 0020 
0559               
0560 78E2 0204  20         li    tmp0,>0200
     78E4 0200 
0561 78E6 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     78E8 8396 
0562               
0563 78EA 06A0  32         bl    @putat
     78EC 62C6 
0564 78EE 1D46                   byte 29,70
0565 78F0 8396                   data rambuf+6          ; Show column
0566                       ;------------------------------------------------------
0567                       ; Show lines in buffer unless on last line in file
0568                       ;------------------------------------------------------
0569 78F2 C820  54         mov   @fb.row,@parm1
     78F4 2206 
     78F6 8350 
0570 78F8 06A0  32         bl    @fb.row2line
     78FA 7968 
0571 78FC 8820  54         c     @edb.lines,@outparm1
     78FE 2304 
     7900 8360 
0572 7902 1605  14         jne   task.botline.show_lines_in_buffer
0573               
0574 7904 06A0  32         bl    @putat
     7906 62C6 
0575 7908 1D49                   byte 29,73
0576 790A 7E88                   data txt_bottom
0577               
0578 790C 100B  14         jmp   task.botline.$$
0579                       ;------------------------------------------------------
0580                       ; Show lines in buffer
0581                       ;------------------------------------------------------
0582               task.botline.show_lines_in_buffer:
0583 790E C820  54         mov   @edb.lines,@waux1
     7910 2304 
     7912 833C 
0584 7914 05A0  34         inc   @waux1                 ; Offset 1
     7916 833C 
0585 7918 06A0  32         bl    @putnum
     791A 66A6 
0586 791C 1D49                   byte 29,73             ; YX
0587 791E 833C                   data waux1,rambuf
     7920 8390 
0588 7922 3020                   byte 48
0589                             byte 32
0590                       ;------------------------------------------------------
0591                       ; Exit
0592                       ;------------------------------------------------------
0593               task.botline.$$
0594 7924 C820  54         mov   @fb.yxsave,@wyx
     7926 2214 
     7928 832A 
0595 792A 0460  28         b     @slotok                ; Exit running task
     792C 700A 
0596               
0597               
0598               
0599               ***************************************************************
0600               *                  fb - Framebuffer module
0601               ***************************************************************
0602                       copy  "framebuffer.asm"
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
0024 792E 0649  14         dect  stack
0025 7930 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 7932 0204  20         li    tmp0,fb.top
     7934 2650 
0030 7936 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     7938 2200 
0031 793A 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     793C 2204 
0032 793E 04E0  34         clr   @fb.row               ; Current row=0
     7940 2206 
0033 7942 04E0  34         clr   @fb.column            ; Current column=0
     7944 220C 
0034 7946 0204  20         li    tmp0,80
     7948 0050 
0035 794A C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     794C 220E 
0036 794E 0204  20         li    tmp0,29
     7950 001D 
0037 7952 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     7954 2218 
0038 7956 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7958 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 795A 06A0  32         bl    @film
     795C 60D0 
0043 795E 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7960 0000 
     7962 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7964 0460  28         b     @poprt                ; Return to caller
     7966 60CC 
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
0073 7968 0649  14         dect  stack
0074 796A C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 796C C120  34         mov   @parm1,tmp0
     796E 8350 
0079 7970 A120  34         a     @fb.topline,tmp0
     7972 2204 
0080 7974 C804  38         mov   tmp0,@outparm1
     7976 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 7978 0460  28         b    @poprt                 ; Return to caller
     797A 60CC 
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
0113 797C 0649  14         dect  stack
0114 797E C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7980 C1A0  34         mov   @fb.row,tmp2
     7982 2206 
0119 7984 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7986 220E 
0120 7988 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     798A 220C 
0121 798C A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     798E 2200 
0122 7990 C807  38         mov   tmp3,@fb.current
     7992 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7994 0460  28         b    @poprt                 ; Return to caller
     7996 60CC 
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
0145 7998 0649  14         dect  stack
0146 799A C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 799C C820  54         mov   @parm1,@fb.topline
     799E 8350 
     79A0 2204 
0151 79A2 04E0  34         clr   @parm2                ; Target row in frame buffer
     79A4 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 79A6 06A0  32         bl    @edb.line.unpack      ; Unpack line
     79A8 7B7E 
0157                                                   ; \ .  parm1 = Line to unpack
0158                                                   ; / .  parm2 = Target row in frame buffer
0159               
0160 79AA 05A0  34         inc   @parm1                ; Next line in editor buffer
     79AC 8350 
0161 79AE 05A0  34         inc   @parm2                ; Next row in frame buffer
     79B0 8352 
0162 79B2 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     79B4 8352 
     79B6 2218 
0163 79B8 11F6  14         jlt   fb.refresh.unpack_line
0164 79BA 0720  34         seto  @fb.dirty             ; Refresh screen
     79BC 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit
0169 79BE 0460  28         b    @poprt                 ; Return to caller
     79C0 60CC 
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
0185 79C2 0649  14         dect  stack
0186 79C4 C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 79C6 04E0  34         clr   @fb.column
     79C8 220C 
0191 79CA 06A0  32         bl    @fb.calc_pointer
     79CC 797C 
0192 79CE 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     79D0 7C36 
0193 79D2 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     79D4 2208 
0194 79D6 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 79D8 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     79DA 2202 
0197 79DC 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 79DE D174  28         movb  *tmp0+,tmp1           ; Get character
0203 79E0 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 79E2 0285  22         ci    tmp1,>2000            ; Whitespace?
     79E4 2000 
0206 79E6 1503  14         jgt   fb.get.firstnonblank.match
0207 79E8 0606  14         dec   tmp2                  ; Counter--
0208 79EA 16F9  14         jne   fb.get.firstnonblank.loop
0209 79EC 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match
0214 79EE 6120  34         s     @fb.current,tmp0      ; Calculate column
     79F0 2202 
0215 79F2 0604  14         dec   tmp0
0216 79F4 C804  38         mov   tmp0,@outparm1        ; Save column
     79F6 8360 
0217 79F8 D805  38         movb  tmp1,@outparm2        ; Save character
     79FA 8362 
0218 79FC 1004  14         jmp   fb.get.firstnonblank.$$
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch
0223 79FE 04E0  34         clr   @outparm1             ; X=0
     7A00 8360 
0224 7A02 04E0  34         clr   @outparm2             ; Null
     7A04 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.$$
0229 7A06 0460  28         b    @poprt                 ; Return to caller
     7A08 60CC 
0230               
0231               
0232               
0233               
0234               
0235               
**** **** ****     > tivi.asm.2093
0603               
0604               
0605               ***************************************************************
0606               *              idx - Index management module
0607               ***************************************************************
0608                       copy  "index.asm"
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
0059 7A0A 0649  14         dect  stack
0060 7A0C C64B  30         mov   r11,*stack            ; Save return address
0061                       ;------------------------------------------------------
0062                       ; Initialize
0063                       ;------------------------------------------------------
0064 7A0E 0204  20         li    tmp0,idx.top
     7A10 3000 
0065 7A12 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7A14 2302 
0066                       ;------------------------------------------------------
0067                       ; Create index slot 0
0068                       ;------------------------------------------------------
0069 7A16 06A0  32         bl    @film
     7A18 60D0 
0070 7A1A 3000             data  idx.top,>00,idx.size  ; Clear index
     7A1C 0000 
     7A1E 1000 
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               idx.init.exit:
0075 7A20 0460  28         b     @poprt                ; Return to caller
     7A22 60CC 
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
0097 7A24 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7A26 8350 
0098                       ;------------------------------------------------------
0099                       ; Calculate offset
0100                       ;------------------------------------------------------
0101 7A28 C160  34         mov   @parm2,tmp1
     7A2A 8352 
0102 7A2C 1305  14         jeq   idx.entry.update.save ; Special handling for empty line
0103 7A2E 0225  22         ai    tmp1,-edb.top         ; Substract editor buffer base,
     7A30 6000 
0104                                                   ; we only store the offset
0105               
0106                       ;------------------------------------------------------
0107                       ; Inject SAMS bank into high-nibble MSB of pointer
0108                       ;------------------------------------------------------
0109 7A32 C1A0  34         mov   @parm3,tmp2
     7A34 8354 
0110 7A36 1300  14         jeq   idx.entry.update.save ; Skip for SAMS bank 0
0111               
0112                       ; <still to do>
0113               
0114                       ;------------------------------------------------------
0115                       ; Update index slot
0116                       ;------------------------------------------------------
0117               idx.entry.update.save:
0118 7A38 0A14  56         sla   tmp0,1                ; line number * 2
0119 7A3A C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     7A3C 3000 
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               idx.entry.update.exit:
0124 7A3E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7A40 8360 
0125 7A42 045B  20         b     *r11                  ; Return
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
0145 7A44 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7A46 8350 
0146                       ;------------------------------------------------------
0147                       ; Calculate address of index entry and save pointer
0148                       ;------------------------------------------------------
0149 7A48 0A14  56         sla   tmp0,1                ; line number * 2
0150 7A4A C824  54         mov   @idx.top(tmp0),@outparm1
     7A4C 3000 
     7A4E 8360 
0151                                                   ; Pointer to deleted line
0152                       ;------------------------------------------------------
0153                       ; Prepare for index reorg
0154                       ;------------------------------------------------------
0155 7A50 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7A52 8352 
0156 7A54 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7A56 8350 
0157 7A58 1603  14         jne   idx.entry.delete.reorg
0158                       ;------------------------------------------------------
0159                       ; Special treatment if last line
0160                       ;------------------------------------------------------
0161 7A5A 04E4  34         clr   @idx.top(tmp0)
     7A5C 3000 
0162 7A5E 1006  14         jmp   idx.entry.delete.exit
0163                       ;------------------------------------------------------
0164                       ; Reorganize index entries
0165                       ;------------------------------------------------------
0166               idx.entry.delete.reorg:
0167 7A60 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7A62 3002 
     7A64 3000 
0168 7A66 05C4  14         inct  tmp0                  ; Next index entry
0169 7A68 0606  14         dec   tmp2                  ; tmp2--
0170 7A6A 16FA  14         jne   idx.entry.delete.reorg
0171                                                   ; Loop unless completed
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               idx.entry.delete.exit:
0176 7A6C 045B  20         b     *r11                  ; Return
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
0196 7A6E C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7A70 8352 
0197                       ;------------------------------------------------------
0198                       ; Calculate address of index entry and save pointer
0199                       ;------------------------------------------------------
0200 7A72 0A14  56         sla   tmp0,1                ; line number * 2
0201                       ;------------------------------------------------------
0202                       ; Prepare for index reorg
0203                       ;------------------------------------------------------
0204 7A74 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7A76 8352 
0205 7A78 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7A7A 8350 
0206 7A7C 1606  14         jne   idx.entry.insert.reorg
0207                       ;------------------------------------------------------
0208                       ; Special treatment if last line
0209                       ;------------------------------------------------------
0210 7A7E C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7A80 3000 
     7A82 3002 
0211 7A84 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     7A86 3000 
0212 7A88 1009  14         jmp   idx.entry.insert.$$
0213                       ;------------------------------------------------------
0214                       ; Reorganize index entries
0215                       ;------------------------------------------------------
0216               idx.entry.insert.reorg:
0217 7A8A 05C6  14         inct  tmp2                  ; Adjust one time
0218 7A8C C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7A8E 3000 
     7A90 3002 
0219 7A92 0644  14         dect  tmp0                  ; Previous index entry
0220 7A94 0606  14         dec   tmp2                  ; tmp2--
0221 7A96 16FA  14         jne   -!                    ; Loop unless completed
0222               
0223 7A98 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     7A9A 3004 
0224                       ;------------------------------------------------------
0225                       ; Exit
0226                       ;------------------------------------------------------
0227               idx.entry.insert.$$:
0228 7A9C 045B  20         b     *r11                  ; Return
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
0249 7A9E 0649  14         dect  stack
0250 7AA0 C64B  30         mov   r11,*stack            ; Save return address
0251                       ;------------------------------------------------------
0252                       ; Get pointer
0253                       ;------------------------------------------------------
0254 7AA2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7AA4 8350 
0255                       ;------------------------------------------------------
0256                       ; Calculate index entry
0257                       ;------------------------------------------------------
0258 7AA6 0A14  56         sla   tmp0,1                ; line number * 2
0259 7AA8 C164  34         mov   @idx.top(tmp0),tmp1   ; Get offset
     7AAA 3000 
0260                       ;------------------------------------------------------
0261                       ; Get SAMS bank
0262                       ;------------------------------------------------------
0263 7AAC C185  18         mov   tmp1,tmp2
0264 7AAE 09C6  56         srl   tmp2,12               ; Remove offset part
0265               
0266 7AB0 0286  22         ci    tmp2,5                ; SAMS bank 0
     7AB2 0005 
0267 7AB4 1205  14         jle   idx.pointer.get.samsbank0
0268               
0269 7AB6 0226  22         ai    tmp2,-5               ; Get SAMS bank
     7AB8 FFFB 
0270 7ABA C806  38         mov   tmp2,@outparm2        ; Return SAMS bank
     7ABC 8362 
0271 7ABE 1002  14         jmp   idx.pointer.get.addbase
0272                       ;------------------------------------------------------
0273                       ; SAMS Bank 0 (or only 32K memory expansion)
0274                       ;------------------------------------------------------
0275               idx.pointer.get.samsbank0:
0276 7AC0 04E0  34         clr   @outparm2             ; SAMS bank 0
     7AC2 8362 
0277                       ;------------------------------------------------------
0278                       ; Add base
0279                       ;------------------------------------------------------
0280               idx.pointer.get.addbase:
0281 7AC4 0225  22         ai    tmp1,edb.top          ; Add base of editor buffer
     7AC6 A000 
0282 7AC8 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7ACA 8360 
0283                       ;------------------------------------------------------
0284                       ; Exit
0285                       ;------------------------------------------------------
0286               idx.pointer.get.exit:
0287 7ACC 0460  28         b     @poprt                ; Return to caller
     7ACE 60CC 
**** **** ****     > tivi.asm.2093
0609               
0610               
0611               ***************************************************************
0612               *               edb - Editor Buffer module
0613               ***************************************************************
0614                       copy  "editorbuffer.asm"
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
0026 7AD0 0649  14         dect  stack
0027 7AD2 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7AD4 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7AD6 A002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 7AD8 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7ADA 2300 
0035 7ADC C804  38         mov   tmp0,@edb.next_free.ptr
     7ADE 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 7AE0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7AE2 230C 
0038 7AE4 04E0  34         clr   @edb.lines            ; Lines=0
     7AE6 2304 
0039 7AE8 04E0  34         clr   @edb.rle              ; RLE compression off
     7AEA 230E 
0040               
0041               edb.init.exit:
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045 7AEC 0460  28         b     @poprt                ; Return to caller
     7AEE 60CC 
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
0072 7AF0 0649  14         dect  stack
0073 7AF2 C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Get values
0076                       ;------------------------------------------------------
0077 7AF4 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7AF6 220C 
     7AF8 8390 
0078 7AFA 04E0  34         clr   @fb.column
     7AFC 220C 
0079 7AFE 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7B00 797C 
0080                       ;------------------------------------------------------
0081                       ; Prepare scan
0082                       ;------------------------------------------------------
0083 7B02 04C4  14         clr   tmp0                  ; Counter
0084 7B04 C160  34         mov   @fb.current,tmp1      ; Get position
     7B06 2202 
0085 7B08 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7B0A 8392 
0086               
0087                       ;------------------------------------------------------
0088                       ; Scan line for >00 byte termination
0089                       ;------------------------------------------------------
0090               edb.line.pack.scan:
0091 7B0C D1B5  28         movb  *tmp1+,tmp2           ; Get char
0092 7B0E 0986  56         srl   tmp2,8                ; Right justify
0093 7B10 1302  14         jeq   edb.line.pack.checklength
0094                                                   ; Stop scan if >00 found
0095 7B12 0584  14         inc   tmp0                  ; Increase string length
0096 7B14 10FB  14         jmp   edb.line.pack.scan    ; Next character
0097               
0098                       ;------------------------------------------------------
0099                       ; Handle line placement depending on length
0100                       ;------------------------------------------------------
0101               edb.line.pack.checklength:
0102 7B16 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7B18 2204 
     7B1A 8350 
0103 7B1C A820  54         a     @fb.row,@parm1        ; /
     7B1E 2206 
     7B20 8350 
0104               
0105 7B22 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7B24 8394 
0106               
0107                       ;------------------------------------------------------
0108                       ; 1. Update index
0109                       ;------------------------------------------------------
0110               edb.line.pack.update_index:
0111 7B26 C820  54         mov   @edb.next_free.ptr,@parm2
     7B28 2308 
     7B2A 8352 
0112                                                   ; Block where line will reside
0113               
0114 7B2C 04E0  34         clr   @parm3                ; SAMS bank
     7B2E 8354 
0115 7B30 06A0  32         bl    @idx.entry.update     ; Update index
     7B32 7A24 
0116                                                   ; \ .  parm1 = Line number in editor buffer
0117                                                   ; | .  parm2 = pointer to line in editor buffer
0118                                                   ; / .  parm3 = SAMS bank (0-A)
0119               
0120                       ;------------------------------------------------------
0121                       ; 2. Set line prefix in editor buffer
0122                       ;------------------------------------------------------
0123 7B34 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7B36 8392 
0124 7B38 C160  34         mov   @edb.next_free.ptr,tmp1
     7B3A 2308 
0125                                                   ; Address of line in editor buffer
0126               
0127 7B3C 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     7B3E 2308 
0128               
0129 7B40 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     7B42 8394 
0130 7B44 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0131 7B46 1316  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0132               
0133                       ;------------------------------------------------------
0134                       ; 3. Copy line from framebuffer to editor buffer
0135                       ;------------------------------------------------------
0136               edb.line.pack.copyline:
0137 7B48 0286  22         ci    tmp2,2
     7B4A 0002 
0138 7B4C 1602  14         jne   edb.line.pack.copyline.checkbyte
0139 7B4E C554  38         mov   *tmp0,*tmp1           ; Copy single word
0140 7B50 1007  14         jmp   !
0141               
0142               edb.line.pack.copyline.checkbyte:
0143 7B52 0286  22         ci    tmp2,1
     7B54 0001 
0144 7B56 1602  14         jne   edb.line.pack.copyline.block
0145 7B58 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0146 7B5A 1002  14         jmp   !
0147               
0148               edb.line.pack.copyline.block:
0149 7B5C 06A0  32         bl    @xpym2m               ; Copy memory block
     7B5E 631C 
0150                                                   ;   tmp0 = source
0151                                                   ;   tmp1 = destination
0152                                                   ;   tmp2 = bytes to copy
0153               
0154                       ;------------------------------------------------------
0155                       ; 4. Update pointer to next free line, assure it is even
0156                       ;------------------------------------------------------
0157 7B60 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     7B62 8394 
     7B64 2308 
0158                                                   ; Update pointer to next free block
0159               
0160 7B66 C120  34         mov   @edb.next_free.ptr,tmp0
     7B68 2308 
0161 7B6A 0244  22         andi  tmp0,1                ; Uneven ?
     7B6C 0001 
0162 7B6E 1302  14         jeq   edb.line.pack.exit    ; Exit if even
0163 7B70 05A0  34         inc   @edb.next_free.ptr    ; Make it even
     7B72 2308 
0164                       ;------------------------------------------------------
0165                       ; Exit
0166                       ;------------------------------------------------------
0167               edb.line.pack.exit:
0168 7B74 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7B76 8390 
     7B78 220C 
0169 7B7A 0460  28         b     @poprt                ; Return to caller
     7B7C 60CC 
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
0199 7B7E 0649  14         dect  stack
0200 7B80 C64B  30         mov   r11,*stack            ; Save return address
0201                       ;------------------------------------------------------
0202                       ; Save parameters
0203                       ;------------------------------------------------------
0204 7B82 C820  54         mov   @parm1,@rambuf
     7B84 8350 
     7B86 8390 
0205 7B88 C820  54         mov   @parm2,@rambuf+2
     7B8A 8352 
     7B8C 8392 
0206                       ;------------------------------------------------------
0207                       ; Calculate offset in frame buffer
0208                       ;------------------------------------------------------
0209 7B8E C120  34         mov   @fb.colsline,tmp0
     7B90 220E 
0210 7B92 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7B94 8352 
0211 7B96 C1A0  34         mov   @fb.top.ptr,tmp2
     7B98 2200 
0212 7B9A A146  18         a     tmp2,tmp1             ; Add base to offset
0213 7B9C C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7B9E 8396 
0214                       ;------------------------------------------------------
0215                       ; Get length of line to unpack
0216                       ;------------------------------------------------------
0217 7BA0 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7BA2 7BFE 
0218                                                   ; \ .  parm1    = Line number
0219                                                   ; | o  outparm1 = Line length (uncompressed)
0220                                                   ; | o  outparm2 = Line length (compressed)
0221                                                   ; / o  outparm3 = SAMS bank (>0 - >a)
0222               
0223 7BA4 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7BA6 8362 
     7BA8 839A 
0224 7BAA C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7BAC 8360 
     7BAE 8398 
0225 7BB0 1307  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0226               
0227                       ;------------------------------------------------------
0228                       ; Index. Calculate address of entry and get pointer
0229                       ;------------------------------------------------------
0230 7BB2 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7BB4 7A9E 
0231                                                   ; \ .  parm1    = Line number
0232                                                   ; | o  outparm1 = Pointer to line
0233                                                   ; / o  outparm2 = SAMS bank
0234               
0235 7BB6 05E0  34         inct  @outparm1             ; Skip line prefix
     7BB8 8360 
0236 7BBA C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7BBC 8360 
     7BBE 8394 
0237               
0238                       ;------------------------------------------------------
0239                       ; Erase chars from last column until column 80
0240                       ;------------------------------------------------------
0241               edb.line.unpack.clear:
0242 7BC0 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7BC2 8396 
0243 7BC4 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7BC6 8398 
0244               
0245 7BC8 04C5  14         clr   tmp1                  ; Fill with >00
0246 7BCA C1A0  34         mov   @fb.colsline,tmp2
     7BCC 220E 
0247 7BCE 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7BD0 8398 
0248 7BD2 0586  14         inc   tmp2
0249               
0250 7BD4 06A0  32         bl    @xfilm                ; Fill CPU memory
     7BD6 60D6 
0251                                                   ; \ .  tmp0 = Target address
0252                                                   ; | .  tmp1 = Byte to fill
0253                                                   ; / .  tmp2 = Repeat count
0254               
0255                       ;------------------------------------------------------
0256                       ; Prepare for unpacking data
0257                       ;------------------------------------------------------
0258               edb.line.unpack.prepare:
0259 7BD8 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     7BDA 8398 
0260 7BDC 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0261 7BDE C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7BE0 8394 
0262 7BE2 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7BE4 8396 
0263                       ;------------------------------------------------------
0264                       ; Either RLE decompress or do normal memory copy
0265                       ;------------------------------------------------------
0266 7BE6 C1E0  34         mov   @edb.rle,tmp3
     7BE8 230E 
0267 7BEA 1305  14         jeq   edb.line.unpack.copy.uncompressed
0268                       ;------------------------------------------------------
0269                       ; Uncompress RLE line to frame buffer
0270                       ;------------------------------------------------------
0271 7BEC C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     7BEE 839A 
0272               
0273 7BF0 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     7BF2 6768 
0274                                                   ; \ .  tmp0 = ROM/RAM source address
0275                                                   ; | .  tmp1 = RAM target address
0276                                                   ; / .  tmp2 = Length of RLE encoded data
0277 7BF4 1002  14         jmp   edb.line.unpack.exit
0278               
0279               edb.line.unpack.copy.uncompressed:
0280                       ;------------------------------------------------------
0281                       ; Copy memory block
0282                       ;------------------------------------------------------
0283 7BF6 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7BF8 631C 
0284                                                   ; \ .  tmp0 = Source address
0285                                                   ; | .  tmp1 = Target address
0286                                                   ; / .  tmp2 = Bytes to copy
0287                       ;------------------------------------------------------
0288                       ; Exit
0289                       ;------------------------------------------------------
0290               edb.line.unpack.exit:
0291 7BFA 0460  28         b     @poprt                ; Return to caller
     7BFC 60CC 
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
0314 7BFE 0649  14         dect  stack
0315 7C00 C64B  30         mov   r11,*stack            ; Save return address
0316                       ;------------------------------------------------------
0317                       ; Initialisation
0318                       ;------------------------------------------------------
0319 7C02 04E0  34         clr   @outparm1             ; Reset uncompressed length
     7C04 8360 
0320 7C06 04E0  34         clr   @outparm2             ; Reset compressed length
     7C08 8362 
0321 7C0A 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7C0C 8364 
0322                       ;------------------------------------------------------
0323                       ; Get length
0324                       ;------------------------------------------------------
0325 7C0E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7C10 7A9E 
0326                                                   ; \  parm1    = Line number
0327                                                   ; |  outparm1 = Pointer to line
0328                                                   ; /  outparm2 = SAMS bank
0329               
0330 7C12 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     7C14 8360 
0331 7C16 130D  14         jeq   edb.line.getlength.exit
0332                                                   ; Exit early if NULL pointer
0333 7C18 C820  54         mov   @outparm2,@outparm3   ; Save SAMS bank
     7C1A 8362 
     7C1C 8364 
0334                       ;------------------------------------------------------
0335                       ; Process line prefix
0336                       ;------------------------------------------------------
0337 7C1E 04C5  14         clr   tmp1
0338 7C20 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0339 7C22 06C5  14         swpb  tmp1
0340 7C24 C805  38         mov   tmp1,@outparm2        ; Save length
     7C26 8362 
0341               
0342 7C28 04C5  14         clr   tmp1
0343 7C2A D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0344 7C2C 06C5  14         swpb  tmp1
0345 7C2E C805  38         mov   tmp1,@outparm1        ; Save length
     7C30 8360 
0346                       ;------------------------------------------------------
0347                       ; Exit
0348                       ;------------------------------------------------------
0349               edb.line.getlength.exit:
0350 7C32 0460  28         b     @poprt                ; Return to caller
     7C34 60CC 
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
0371 7C36 0649  14         dect  stack
0372 7C38 C64B  30         mov   r11,*stack            ; Save return address
0373                       ;------------------------------------------------------
0374                       ; Get length
0375                       ;------------------------------------------------------
0376 7C3A C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7C3C 220C 
     7C3E 8390 
0377 7C40 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7C42 2204 
0378 7C44 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7C46 2206 
0379 7C48 0A24  56         sla   tmp0,2                ; Line number * 4
0380 7C4A C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7C4C 3002 
0381 7C4E 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7C50 00FF 
0382 7C52 C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7C54 2208 
0383                       ;------------------------------------------------------
0384                       ; Exit
0385                       ;------------------------------------------------------
0386               edb.line.getlength2.exit:
0387 7C56 0460  28         b     @poprt                ; Return to caller
     7C58 60CC 
0388               
**** **** ****     > tivi.asm.2093
0615               
0616               
0617               ***************************************************************
0618               *               fh - File handling module
0619               ***************************************************************
0620                       copy  "filehandler.asm"
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
0028 7C5A 0649  14         dect  stack
0029 7C5C C64B  30         mov   r11,*stack            ; Save return address
0030 7C5E C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     7C60 8352 
     7C62 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 7C64 04E0  34         clr   @tfh.records          ; Reset records counter
     7C66 242E 
0035 7C68 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7C6A 2434 
0036 7C6C 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7C6E 2432 
0037 7C70 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 7C72 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7C74 242A 
0039 7C76 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7C78 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 7C7A 06A0  32         bl    @hchar
     7C7C 64A8 
0044 7C7E 1D00                   byte 29,0,32,80
     7C80 2050 
0045 7C82 FFFF                   data EOL
0046               
0047 7C84 06A0  32         bl    @putat
     7C86 62C6 
0048 7C88 1D00                   byte 29,0
0049 7C8A 7E98                   data txt_loading      ; Display "Loading...."
0050               
0051 7C8C 8820  54         c     @tfh.rleonload,@w$ffff
     7C8E 2436 
     7C90 6048 
0052 7C92 1604  14         jne   !
0053 7C94 06A0  32         bl    @putat
     7C96 62C6 
0054 7C98 1D44                   byte 29,68
0055 7C9A 7EA8                   data txt_rle          ; Display "RLE"
0056               
0057 7C9C 06A0  32 !       bl    @at
     7C9E 63B4 
0058 7CA0 1D0B                   byte 29,11            ; Cursor YX position
0059 7CA2 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7CA4 8350 
0060 7CA6 06A0  32         bl    @xutst0               ; Display device/filename
     7CA8 62B6 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 7CAA 06A0  32         bl    @cpym2v
     7CAC 62CE 
0065 7CAE 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7CB0 7E5A 
     7CB2 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 7CB4 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7CB6 0A69 
0071 7CB8 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7CBA 8350 
0072 7CBC D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 7CBE 0986  56         srl   tmp2,8                ; Right justify
0074 7CC0 0586  14         inc   tmp2                  ; Include length byte as well
0075 7CC2 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7CC4 62D4 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 7CC6 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7CC8 6DB6 
0080 7CCA 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 7CCC 06A0  32         bl    @file.open
     7CCE 6F04 
0085 7CD0 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 7CD2 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7CD4 6042 
0087 7CD6 1602  14         jne   tfh.file.read.record
0088 7CD8 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7CDA 7E12 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 7CDC 05A0  34         inc   @tfh.records          ; Update counter
     7CDE 242E 
0094 7CE0 04E0  34         clr   @tfh.reclen           ; Reset record length
     7CE2 2430 
0095               
0096 7CE4 06A0  32         bl    @file.record.read     ; Read file record
     7CE6 6F46 
0097 7CE8 0A60                   data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
0098                                                   ; | o  tmp0 = Status byte
0099                                                   ; | o  tmp1 = Bytes read
0100                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0101               
0102 7CEA C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7CEC 242A 
0103 7CEE C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7CF0 2430 
0104 7CF2 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7CF4 242C 
0105                       ;------------------------------------------------------
0106                       ; 1a: Calculate kilobytes processed
0107                       ;------------------------------------------------------
0108 7CF6 A805  38         a     tmp1,@tfh.counter
     7CF8 2434 
0109 7CFA A160  34         a     @tfh.counter,tmp1
     7CFC 2434 
0110 7CFE 0285  22         ci    tmp1,1024
     7D00 0400 
0111 7D02 1106  14         jlt   !
0112 7D04 05A0  34         inc   @tfh.kilobytes
     7D06 2432 
0113 7D08 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7D0A FC00 
0114 7D0C C805  38         mov   tmp1,@tfh.counter
     7D0E 2434 
0115                       ;------------------------------------------------------
0116                       ; 1b: Load spectra scratchpad layout
0117                       ;------------------------------------------------------
0118 7D10 06A0  32 !       bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7D12 67B2 
0119 7D14 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7D16 6DD8 
0120 7D18 2100                   data scrpad.backup2   ; / >2100->8300
0121                       ;------------------------------------------------------
0122                       ; 1c: Check if a file error occured
0123                       ;------------------------------------------------------
0124               tfh.file.read.check:
0125 7D1A C1A0  34         mov   @tfh.ioresult,tmp2
     7D1C 242C 
0126 7D1E 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7D20 6042 
0127 7D22 1377  14         jeq   tfh.file.read.error
0128                                                   ; Yes, so handle file error
0129                       ;------------------------------------------------------
0130                       ; 1d: Decide on copy line from VDP buffer to editor
0131                       ;     buffer (RLE off) or RAM buffer (RLE on)
0132                       ;------------------------------------------------------
0133 7D24 8820  54         c     @tfh.rleonload,@w$ffff
     7D26 2436 
     7D28 6048 
0134                                                   ; RLE compression on?
0135 7D2A 1314  14         jeq   tfh.file.read.compression
0136                                                   ; Yes, do RLE compression
0137                       ;------------------------------------------------------
0138                       ; Step 2: Process line without doing RLE compression
0139                       ;------------------------------------------------------
0140               tfh.file.read.nocompression:
0141 7D2C 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7D2E 0960 
0142 7D30 C160  34         mov   @edb.next_free.ptr,tmp1
     7D32 2308 
0143                                                   ; RAM target in editor buffer
0144               
0145 7D34 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7D36 8352 
0146               
0147 7D38 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7D3A 2430 
0148 7D3C 1337  14         jeq   tfh.file.read.prepindex.emptyline
0149                                                   ; Handle empty line
0150                       ;------------------------------------------------------
0151                       ; 2a: Copy line from VDP to CPU editor buffer
0152                       ;------------------------------------------------------
0153                                                   ; Save line prefix
0154 7D3E DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0155 7D40 06C6  14         swpb  tmp2                  ; |
0156 7D42 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0157 7D44 06C6  14         swpb  tmp2                  ; /
0158               
0159 7D46 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7D48 2308 
0160 7D4A A806  38         a     tmp2,@edb.next_free.ptr
     7D4C 2308 
0161                                                   ; Add line length
0162               
0163 7D4E 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7D50 62FA 
0164                                                   ; \ .  tmp0 = VDP source address
0165                                                   ; | .  tmp1 = RAM target address
0166                                                   ; / .  tmp2 = Bytes to copy
0167               
0168 7D52 1028  14         jmp   tfh.file.read.prepindex
0169                                                   ; Prepare for updating index
0170                       ;------------------------------------------------------
0171                       ; Step 3: Process line and do RLE compression
0172                       ;------------------------------------------------------
0173               tfh.file.read.compression:
0174 7D54 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7D56 0960 
0175 7D58 0205  20         li    tmp1,fb.top           ; RAM target address
     7D5A 2650 
0176 7D5C C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7D5E 2430 
0177 7D60 1325  14         jeq   tfh.file.read.prepindex.emptyline
0178                                                   ; Handle empty line
0179               
0180 7D62 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7D64 62FA 
0181                                                   ; \ .  tmp0 = VDP source address
0182                                                   ; | .  tmp1 = RAM target address
0183                                                   ; / .  tmp2 = Bytes to copy
0184               
0185                       ;------------------------------------------------------
0186                       ; 3a: RLE compression on line
0187                       ;------------------------------------------------------
0188 7D66 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     7D68 2650 
0189 7D6A 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     7D6C 26F0 
0190 7D6E C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     7D70 2430 
0191               
0192 7D72 06A0  32         bl    @xcpu2rle             ; RLE compression
     7D74 66B6 
0193                                                   ; \ .  tmp0  = ROM/RAM source address
0194                                                   ; | .  tmp1  = RAM target address
0195                                                   ; | .  tmp2  = Length uncompressed data
0196                                                   ; / o  waux1 = Length RLE encoded string
0197                       ;------------------------------------------------------
0198                       ; 3b: Set line prefix
0199                       ;------------------------------------------------------
0200 7D76 C160  34         mov   @edb.next_free.ptr,tmp1
     7D78 2308 
0201                                                   ; RAM target address
0202 7D7A C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     7D7C 8352 
0203 7D7E C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7D80 833C 
0204 7D82 06C6  14         swpb  tmp2                  ;
0205 7D84 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0206               
0207 7D86 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     7D88 2430 
0208 7D8A 06C6  14         swpb  tmp2
0209 7D8C DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0210 7D8E 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     7D90 2308 
0211                       ;------------------------------------------------------
0212                       ; 3c: Copy compressed line to editor buffer
0213                       ;------------------------------------------------------
0214 7D92 0204  20         li    tmp0,fb.top+160       ; RAM source address
     7D94 26F0 
0215 7D96 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7D98 833C 
0216               
0217 7D9A 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7D9C 631C 
0218                                                   ; \ .  tmp0 = RAM source address
0219                                                   ; | .  tmp1 = RAM target address
0220                                                   ; / .  tmp2 = Bytes to copy
0221               
0222 7D9E A820  54         a     @waux1,@edb.next_free.ptr
     7DA0 833C 
     7DA2 2308 
0223                                                   ; Update pointer to next free line
0224                       ;------------------------------------------------------
0225                       ; Step 4: Update index
0226                       ;------------------------------------------------------
0227               tfh.file.read.prepindex:
0228 7DA4 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7DA6 2304 
     7DA8 8350 
0229                                                   ; parm2 = Must allready be set!
0230 7DAA 1007  14         jmp   tfh.file.read.updindex
0231                                                   ; Update index
0232                       ;------------------------------------------------------
0233                       ; 4a: Special handling for empty line
0234                       ;------------------------------------------------------
0235               tfh.file.read.prepindex.emptyline:
0236 7DAC C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7DAE 242E 
     7DB0 8350 
0237 7DB2 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7DB4 8350 
0238 7DB6 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7DB8 8352 
0239                       ;------------------------------------------------------
0240                       ; 4b: Do actual index update
0241                       ;------------------------------------------------------
0242               tfh.file.read.updindex:
0243 7DBA 04E0  34         clr   @parm3
     7DBC 8354 
0244 7DBE 06A0  32         bl    @idx.entry.update     ; Update index
     7DC0 7A24 
0245                                                   ; \ .  parm1    = Line number in editor buffer
0246                                                   ; | .  parm2    = Pointer to line in editor buffer
0247                                                   ; | .  parm3    = SAMS bank (0-A)
0248                                                   ; / o  outparm1 = Pointer to updated index entry
0249               
0250 7DC2 05A0  34         inc   @edb.lines            ; lines=lines+1
     7DC4 2304 
0251                       ;------------------------------------------------------
0252                       ; Step 5: Display results
0253                       ;------------------------------------------------------
0254               tfh.file.read.display:
0255 7DC6 06A0  32         bl    @putnum
     7DC8 66A6 
0256 7DCA 1D49                   byte 29,73            ; Show lines read
0257 7DCC 2304                   data edb.lines,rambuf,>3020
     7DCE 8390 
     7DD0 3020 
0258               
0259 7DD2 8220  34         c     @tfh.kilobytes,tmp4
     7DD4 2432 
0260 7DD6 130C  14         jeq   tfh.file.read.checkmem
0261               
0262 7DD8 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7DDA 2432 
0263               
0264 7DDC 06A0  32         bl    @putnum
     7DDE 66A6 
0265 7DE0 1D38                   byte 29,56            ; Show kilobytes read
0266 7DE2 2432                   data tfh.kilobytes,rambuf,>3020
     7DE4 8390 
     7DE6 3020 
0267               
0268 7DE8 06A0  32         bl    @putat
     7DEA 62C6 
0269 7DEC 1D3D                   byte 29,61
0270 7DEE 7EA4                   data txt_kb           ; Show "kb" string
0271               
0272               ******************************************************
0273               * Stop reading file if high memory expansion gets full
0274               ******************************************************
0275               tfh.file.read.checkmem:
0276 7DF0 C120  34         mov   @edb.next_free.ptr,tmp0
     7DF2 2308 
0277 7DF4 0284  22         ci    tmp0,>ffa0
     7DF6 FFA0 
0278 7DF8 1207  14         jle   tfh.file.read.next
0279 7DFA 1013  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0280                       ;------------------------------------------------------
0281                       ; Next SAMS page
0282                       ;------------------------------------------------------
0283 7DFC 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7DFE 230A 
0284 7E00 0204  20         li    tmp0,edb.top
     7E02 A000 
0285 7E04 C804  38         mov   tmp0,@edb.next_free.ptr
     7E06 2308 
0286                                                   ; Reset to top of editor buffer
0287                       ;------------------------------------------------------
0288                       ; Next record
0289                       ;------------------------------------------------------
0290               tfh.file.read.next:
0291 7E08 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7E0A 6DB6 
0292 7E0C 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0293               
0294 7E0E 0460  28         b     @tfh.file.read.record
     7E10 7CDC 
0295                                                   ; Next record
0296                       ;------------------------------------------------------
0297                       ; Error handler
0298                       ;------------------------------------------------------
0299               tfh.file.read.error:
0300 7E12 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7E14 242A 
0301 7E16 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0302 7E18 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7E1A 0005 
0303 7E1C 1302  14         jeq   tfh.file.read.eof
0304                                                   ; All good. File closed by DSRLNK
0305 7E1E 06A0  32         bl    @crash_handler        ; A File error occured. System crashed
     7E20 604C 
0306                       ;------------------------------------------------------
0307                       ; End-Of-File reached
0308                       ;------------------------------------------------------
0309               tfh.file.read.eof:
0310 7E22 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7E24 6DD8 
0311 7E26 2100                   data scrpad.backup2   ; / >2100->8300
0312                       ;------------------------------------------------------
0313                       ; Display final results
0314                       ;------------------------------------------------------
0315 7E28 06A0  32         bl    @hchar
     7E2A 64A8 
0316 7E2C 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7E2E 200A 
0317 7E30 FFFF                   data EOL
0318               
0319 7E32 06A0  32         bl    @putnum
     7E34 66A6 
0320 7E36 1D38                   byte 29,56            ; Show kilobytes read
0321 7E38 2432                   data tfh.kilobytes,rambuf,>3020
     7E3A 8390 
     7E3C 3020 
0322               
0323 7E3E 06A0  32         bl    @putat
     7E40 62C6 
0324 7E42 1D3D                   byte 29,61
0325 7E44 7EA4                   data txt_kb           ; Show "kb" string
0326               
0327 7E46 06A0  32         bl    @putnum
     7E48 66A6 
0328 7E4A 1D49                   byte 29,73            ; Show lines read
0329 7E4C 242E                   data tfh.records,rambuf,>3020
     7E4E 8390 
     7E50 3020 
0330               
0331 7E52 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7E54 2306 
0332               *--------------------------------------------------------------
0333               * Exit
0334               *--------------------------------------------------------------
0335               tfh.file.read_exit:
0336 7E56 0460  28         b     @poprt                ; Return to caller
     7E58 60CC 
0337               
0338               
0339               ***************************************************************
0340               * PAB for accessing DV/80 file
0341               ********@*****@*********************@**************************
0342               tfh.file.pab.header:
0343 7E5A 0014             byte  io.op.open            ;  0    - OPEN
0344                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0345 7E5C 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0346 7E5E 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0347                       byte  00                    ;  5    - Character count
0348 7E60 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0349 7E62 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0350                       ;------------------------------------------------------
0351                       ; File descriptor part (variable length)
0352                       ;------------------------------------------------------
0353                       ; byte  12                  ;  9    - File descriptor length
0354                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.2093
0621               
0622               
0623               ***************************************************************
0624               *                      Constants
0625               ***************************************************************
0626               romsat:
0627 7E64 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7E66 000F 
0628               
0629               cursors:
0630 7E68 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7E6A 0000 
     7E6C 0000 
     7E6E 001C 
0631 7E70 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7E72 1010 
     7E74 1010 
     7E76 1000 
0632 7E78 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7E7A 1C1C 
     7E7C 1C1C 
     7E7E 1C00 
0633               
0634               ***************************************************************
0635               *                       Strings
0636               ***************************************************************
0637               txt_delim
0638 7E80 012C             byte  1
0639 7E81 ....             text  ','
0640                       even
0641               
0642               txt_marker
0643 7E82 052A             byte  5
0644 7E83 ....             text  '*EOF*'
0645                       even
0646               
0647               txt_bottom
0648 7E88 0520             byte  5
0649 7E89 ....             text  '  BOT'
0650                       even
0651               
0652               txt_ovrwrite
0653 7E8E 034F             byte  3
0654 7E8F ....             text  'OVR'
0655                       even
0656               
0657               txt_insert
0658 7E92 0349             byte  3
0659 7E93 ....             text  'INS'
0660                       even
0661               
0662               txt_star
0663 7E96 012A             byte  1
0664 7E97 ....             text  '*'
0665                       even
0666               
0667               txt_loading
0668 7E98 0A4C             byte  10
0669 7E99 ....             text  'Loading...'
0670                       even
0671               
0672               txt_kb
0673 7EA4 026B             byte  2
0674 7EA5 ....             text  'kb'
0675                       even
0676               
0677               txt_rle
0678 7EA8 0352             byte  3
0679 7EA9 ....             text  'RLE'
0680                       even
0681               
0682               txt_lines
0683 7EAC 054C             byte  5
0684 7EAD ....             text  'Lines'
0685                       even
0686               
0687 7EB2 7EB2     end          data    $
0688               
0689               
0690               fdname0
0691 7EB4 0D44             byte  13
0692 7EB5 ....             text  'DSK1.INVADERS'
0693                       even
0694               
0695               fdname1
0696 7EC2 0F44             byte  15
0697 7EC3 ....             text  'DSK1.SPEECHDOCS'
0698                       even
0699               
0700               fdname2
0701 7ED2 0C44             byte  12
0702 7ED3 ....             text  'DSK1.XBEADOC'
0703                       even
0704               
0705               fdname3
0706 7EE0 0C44             byte  12
0707 7EE1 ....             text  'DSK3.XBEADOC'
0708                       even
0709               
0710               fdname4
0711 7EEE 0C44             byte  12
0712 7EEF ....             text  'DSK3.C99MAN1'
0713                       even
0714               
0715               fdname5
0716 7EFC 0C44             byte  12
0717 7EFD ....             text  'DSK3.C99MAN2'
0718                       even
0719               
0720               fdname6
0721 7F0A 0C44             byte  12
0722 7F0B ....             text  'DSK3.C99MAN3'
0723                       even
0724               
0725               fdname7
0726 7F18 0D44             byte  13
0727 7F19 ....             text  'DSK3.C99SPECS'
0728                       even
0729               
0730               fdname8
0731 7F26 0D44             byte  13
0732 7F27 ....             text  'DSK3.RANDOM#C'
0733                       even
0734               
0735               fdname9
0736 7F34 0D44             byte  13
0737 7F35 ....             text  'DSK1.INVADERS'
0738                       even
0739               

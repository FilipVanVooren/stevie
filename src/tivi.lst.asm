XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.6927
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200113-6927
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
0193 6012 7040             data  runlib
0194               
0196               
0197 6014 1054             byte  16
0198 6015 ....             text  'TIVI 200113-6927'
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
0012               *  b  @crash_handler
0013               ********@*****@*********************@**************************
0014               crash_handler:
0015 604C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     604E 8300 
0016 6050 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6052 8302 
0017 6054 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     6056 4A4A 
0018 6058 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     605A 7048 
0019               
0020               crash_handler.main:
0021 605C 06A0  32         bl    @putat                ; Show crash message
     605E 6292 
0022 6060 0000             data  >0000,crash_handler.message
     6062 6068 
0023 6064 0460  28         b     @tmgr                 ; FNCTN-+ to quit
     6066 6F56 
0024               
0025               crash_handler.message:
0026 6068 2553             byte  37
0027 6069 ....             text  'System crashed. Press FNCTN-+ to quit'
0028               
0029               
**** **** ****     > runlib.asm
0087                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 608E 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6090 000E 
     6092 0106 
     6094 0204 
     6096 0020 
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
0032 6098 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     609A 000E 
     609C 0106 
     609E 00F4 
     60A0 0028 
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
0058 60A2 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     60A4 003F 
     60A6 0240 
     60A8 03F4 
     60AA 0050 
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
0084 60AC 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     60AE 003F 
     60B0 0240 
     60B2 03F4 
     60B4 0050 
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
0013 60B6 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 60B8 16FD             data  >16fd                 ; |         jne   mcloop
0015 60BA 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 60BC D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 60BE 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 60C0 C0F9  30 popr3   mov   *stack+,r3
0039 60C2 C0B9  30 popr2   mov   *stack+,r2
0040 60C4 C079  30 popr1   mov   *stack+,r1
0041 60C6 C039  30 popr0   mov   *stack+,r0
0042 60C8 C2F9  30 poprt   mov   *stack+,r11
0043 60CA 045B  20         b     *r11
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
0067 60CC C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 60CE C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 60D0 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 60D2 C1C6  18 xfilm   mov   tmp2,tmp3
0074 60D4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60D6 0001 
0075               
0076 60D8 1301  14         jeq   film1
0077 60DA 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60DC D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60DE 830B 
     60E0 830A 
0079 60E2 CD05  34 film2   mov   tmp1,*tmp0+
0080 60E4 0646  14         dect  tmp2
0081 60E6 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60E8 C1C7  18         mov   tmp3,tmp3
0086 60EA 1301  14         jeq   filmz
0087 60EC D505  30         movb  tmp1,*tmp0
0088 60EE 045B  20 filmz   b     *r11
0089               
0090               
0091               ***************************************************************
0092               * FILV - Fill VRAM with byte
0093               ***************************************************************
0094               *  BL   @FILV
0095               *  DATA P0,P1,P2
0096               *--------------------------------------------------------------
0097               *  P0 = VDP start address
0098               *  P1 = Byte to fill
0099               *  P2 = Number of bytes to fill
0100               *--------------------------------------------------------------
0101               *  BL   @XFILV
0102               *
0103               *  TMP0 = VDP start address
0104               *  TMP1 = Byte to fill
0105               *  TMP2 = Number of bytes to fill
0106               ********@*****@*********************@**************************
0107 60F0 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60F2 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60F4 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60F6 0264  22 xfilv   ori   tmp0,>4000
     60F8 4000 
0114 60FA 06C4  14         swpb  tmp0
0115 60FC D804  38         movb  tmp0,@vdpa
     60FE 8C02 
0116 6100 06C4  14         swpb  tmp0
0117 6102 D804  38         movb  tmp0,@vdpa
     6104 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 6106 020F  20         li    r15,vdpw              ; Set VDP write address
     6108 8C00 
0122 610A 06C5  14         swpb  tmp1
0123 610C C820  54         mov   @filzz,@mcloop        ; Setup move command
     610E 6116 
     6110 8320 
0124 6112 0460  28         b     @mcloop               ; Write data to VDP
     6114 8320 
0125               *--------------------------------------------------------------
0129 6116 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0131               
0132               
0133               
0134               *//////////////////////////////////////////////////////////////
0135               *                  VDP LOW LEVEL FUNCTIONS
0136               *//////////////////////////////////////////////////////////////
0137               
0138               ***************************************************************
0139               * VDWA / VDRA - Setup VDP write or read address
0140               ***************************************************************
0141               *  BL   @VDWA
0142               *
0143               *  TMP0 = VDP destination address for write
0144               *--------------------------------------------------------------
0145               *  BL   @VDRA
0146               *
0147               *  TMP0 = VDP source address for read
0148               ********@*****@*********************@**************************
0149 6118 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     611A 4000 
0150 611C 06C4  14 vdra    swpb  tmp0
0151 611E D804  38         movb  tmp0,@vdpa
     6120 8C02 
0152 6122 06C4  14         swpb  tmp0
0153 6124 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     6126 8C02 
0154 6128 045B  20         b     *r11                  ; Exit
0155               
0156               ***************************************************************
0157               * VPUTB - VDP put single byte
0158               ***************************************************************
0159               *  BL @VPUTB
0160               *  DATA P0,P1
0161               *--------------------------------------------------------------
0162               *  P0 = VDP target address
0163               *  P1 = Byte to write
0164               ********@*****@*********************@**************************
0165 612A C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 612C C17B  30         mov   *r11+,tmp1            ; Get byte to write
0167               *--------------------------------------------------------------
0168               * Set VDP write address
0169               *--------------------------------------------------------------
0170 612E 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6130 4000 
0171 6132 06C4  14         swpb  tmp0                  ; \
0172 6134 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6136 8C02 
0173 6138 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0174 613A D804  38         movb  tmp0,@vdpa            ; /
     613C 8C02 
0175               *--------------------------------------------------------------
0176               * Write byte
0177               *--------------------------------------------------------------
0178 613E 06C5  14         swpb  tmp1                  ; LSB to MSB
0179 6140 D7C5  30         movb  tmp1,*r15             ; Write byte
0180 6142 045B  20         b     *r11                  ; Exit
0181               
0182               
0183               ***************************************************************
0184               * VGETB - VDP get single byte
0185               ***************************************************************
0186               *  bl   @vgetb
0187               *  data p0
0188               *--------------------------------------------------------------
0189               *  P0 = VDP source address
0190               *--------------------------------------------------------------
0191               *  bl   @xvgetb
0192               *
0193               *  tmp0 = VDP source address
0194               *--------------------------------------------------------------
0195               *  Output:
0196               *  tmp0 MSB = >00
0197               *  tmp0 LSB = VDP byte read
0198               ********@*****@*********************@**************************
0199 6144 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0200               *--------------------------------------------------------------
0201               * Set VDP read address
0202               *--------------------------------------------------------------
0203 6146 06C4  14 xvgetb  swpb  tmp0                  ; \
0204 6148 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     614A 8C02 
0205 614C 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0206 614E D804  38         movb  tmp0,@vdpa            ; /
     6150 8C02 
0207               *--------------------------------------------------------------
0208               * Read byte
0209               *--------------------------------------------------------------
0210 6152 D120  34         movb  @vdpr,tmp0            ; Read byte
     6154 8800 
0211 6156 0984  56         srl   tmp0,8                ; Right align
0212 6158 045B  20         b     *r11                  ; Exit
0213               
0214               
0215               ***************************************************************
0216               * VIDTAB - Dump videomode table
0217               ***************************************************************
0218               *  BL   @VIDTAB
0219               *  DATA P0
0220               *--------------------------------------------------------------
0221               *  P0 = Address of video mode table
0222               *--------------------------------------------------------------
0223               *  BL   @XIDTAB
0224               *
0225               *  TMP0 = Address of video mode table
0226               *--------------------------------------------------------------
0227               *  Remarks
0228               *  TMP1 = MSB is the VDP target register
0229               *         LSB is the value to write
0230               ********@*****@*********************@**************************
0231 615A C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0232 615C C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0233               *--------------------------------------------------------------
0234               * Calculate PNT base address
0235               *--------------------------------------------------------------
0236 615E C144  18         mov   tmp0,tmp1
0237 6160 05C5  14         inct  tmp1
0238 6162 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0239 6164 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6166 FF00 
0240 6168 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0241 616A C805  38         mov   tmp1,@wbase           ; Store calculated base
     616C 8328 
0242               *--------------------------------------------------------------
0243               * Dump VDP shadow registers
0244               *--------------------------------------------------------------
0245 616E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6170 8000 
0246 6172 0206  20         li    tmp2,8
     6174 0008 
0247 6176 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6178 830B 
0248 617A 06C5  14         swpb  tmp1
0249 617C D805  38         movb  tmp1,@vdpa
     617E 8C02 
0250 6180 06C5  14         swpb  tmp1
0251 6182 D805  38         movb  tmp1,@vdpa
     6184 8C02 
0252 6186 0225  22         ai    tmp1,>0100
     6188 0100 
0253 618A 0606  14         dec   tmp2
0254 618C 16F4  14         jne   vidta1                ; Next register
0255 618E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6190 833A 
0256 6192 045B  20         b     *r11
0257               
0258               
0259               ***************************************************************
0260               * PUTVR  - Put single VDP register
0261               ***************************************************************
0262               *  BL   @PUTVR
0263               *  DATA P0
0264               *--------------------------------------------------------------
0265               *  P0 = MSB is the VDP target register
0266               *       LSB is the value to write
0267               *--------------------------------------------------------------
0268               *  BL   @PUTVRX
0269               *
0270               *  TMP0 = MSB is the VDP target register
0271               *         LSB is the value to write
0272               ********@*****@*********************@**************************
0273 6194 C13B  30 putvr   mov   *r11+,tmp0
0274 6196 0264  22 putvrx  ori   tmp0,>8000
     6198 8000 
0275 619A 06C4  14         swpb  tmp0
0276 619C D804  38         movb  tmp0,@vdpa
     619E 8C02 
0277 61A0 06C4  14         swpb  tmp0
0278 61A2 D804  38         movb  tmp0,@vdpa
     61A4 8C02 
0279 61A6 045B  20         b     *r11
0280               
0281               
0282               ***************************************************************
0283               * PUTV01  - Put VDP registers #0 and #1
0284               ***************************************************************
0285               *  BL   @PUTV01
0286               ********@*****@*********************@**************************
0287 61A8 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0288 61AA C10E  18         mov   r14,tmp0
0289 61AC 0984  56         srl   tmp0,8
0290 61AE 06A0  32         bl    @putvrx               ; Write VR#0
     61B0 6196 
0291 61B2 0204  20         li    tmp0,>0100
     61B4 0100 
0292 61B6 D820  54         movb  @r14lb,@tmp0lb
     61B8 831D 
     61BA 8309 
0293 61BC 06A0  32         bl    @putvrx               ; Write VR#1
     61BE 6196 
0294 61C0 0458  20         b     *tmp4                 ; Exit
0295               
0296               
0297               ***************************************************************
0298               * LDFNT - Load TI-99/4A font from GROM into VDP
0299               ***************************************************************
0300               *  BL   @LDFNT
0301               *  DATA P0,P1
0302               *--------------------------------------------------------------
0303               *  P0 = VDP Target address
0304               *  P1 = Font options
0305               *--------------------------------------------------------------
0306               * Uses registers tmp0-tmp4
0307               ********@*****@*********************@**************************
0308 61C2 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0309 61C4 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0310 61C6 C11B  26         mov   *r11,tmp0             ; Get P0
0311 61C8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61CA 7FFF 
0312 61CC 2120  38         coc   @wbit0,tmp0
     61CE 6046 
0313 61D0 1604  14         jne   ldfnt1
0314 61D2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     61D4 8000 
0315 61D6 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     61D8 7FFF 
0316               *--------------------------------------------------------------
0317               * Read font table address from GROM into tmp1
0318               *--------------------------------------------------------------
0319 61DA C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     61DC 6244 
0320 61DE D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     61E0 9C02 
0321 61E2 06C4  14         swpb  tmp0
0322 61E4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61E6 9C02 
0323 61E8 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61EA 9800 
0324 61EC 06C5  14         swpb  tmp1
0325 61EE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61F0 9800 
0326 61F2 06C5  14         swpb  tmp1
0327               *--------------------------------------------------------------
0328               * Setup GROM source address from tmp1
0329               *--------------------------------------------------------------
0330 61F4 D805  38         movb  tmp1,@grmwa
     61F6 9C02 
0331 61F8 06C5  14         swpb  tmp1
0332 61FA D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61FC 9C02 
0333               *--------------------------------------------------------------
0334               * Setup VDP target address
0335               *--------------------------------------------------------------
0336 61FE C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0337 6200 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     6202 6118 
0338 6204 05C8  14         inct  tmp4                  ; R11=R11+2
0339 6206 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0340 6208 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     620A 7FFF 
0341 620C C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     620E 6246 
0342 6210 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     6212 6248 
0343               *--------------------------------------------------------------
0344               * Copy from GROM to VRAM
0345               *--------------------------------------------------------------
0346 6214 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0347 6216 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0348 6218 D120  34         movb  @grmrd,tmp0
     621A 9800 
0349               *--------------------------------------------------------------
0350               *   Make font fat
0351               *--------------------------------------------------------------
0352 621C 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     621E 6046 
0353 6220 1603  14         jne   ldfnt3                ; No, so skip
0354 6222 D1C4  18         movb  tmp0,tmp3
0355 6224 0917  56         srl   tmp3,1
0356 6226 E107  18         soc   tmp3,tmp0
0357               *--------------------------------------------------------------
0358               *   Dump byte to VDP and do housekeeping
0359               *--------------------------------------------------------------
0360 6228 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     622A 8C00 
0361 622C 0606  14         dec   tmp2
0362 622E 16F2  14         jne   ldfnt2
0363 6230 05C8  14         inct  tmp4                  ; R11=R11+2
0364 6232 020F  20         li    r15,vdpw              ; Set VDP write address
     6234 8C00 
0365 6236 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6238 7FFF 
0366 623A 0458  20         b     *tmp4                 ; Exit
0367 623C D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     623E 6026 
     6240 8C00 
0368 6242 10E8  14         jmp   ldfnt2
0369               *--------------------------------------------------------------
0370               * Fonts pointer table
0371               *--------------------------------------------------------------
0372 6244 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6246 0200 
     6248 0000 
0373 624A 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     624C 01C0 
     624E 0101 
0374 6250 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6252 02A0 
     6254 0101 
0375 6256 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6258 00E0 
     625A 0101 
0376               
0377               
0378               
0379               ***************************************************************
0380               * YX2PNT - Get VDP PNT address for current YX cursor position
0381               ***************************************************************
0382               *  BL   @YX2PNT
0383               *--------------------------------------------------------------
0384               *  INPUT
0385               *  @WYX = Cursor YX position
0386               *--------------------------------------------------------------
0387               *  OUTPUT
0388               *  TMP0 = VDP address for entry in Pattern Name Table
0389               *--------------------------------------------------------------
0390               *  Register usage
0391               *  TMP0, R14, R15
0392               ********@*****@*********************@**************************
0393 625C C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0394 625E C3A0  34         mov   @wyx,r14              ; Get YX
     6260 832A 
0395 6262 098E  56         srl   r14,8                 ; Right justify (remove X)
0396 6264 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6266 833A 
0397               *--------------------------------------------------------------
0398               * Do rest of calculation with R15 (16 bit part is there)
0399               * Re-use R14
0400               *--------------------------------------------------------------
0401 6268 C3A0  34         mov   @wyx,r14              ; Get YX
     626A 832A 
0402 626C 024E  22         andi  r14,>00ff             ; Remove Y
     626E 00FF 
0403 6270 A3CE  18         a     r14,r15               ; pos = pos + X
0404 6272 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6274 8328 
0405               *--------------------------------------------------------------
0406               * Clean up before exit
0407               *--------------------------------------------------------------
0408 6276 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0409 6278 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0410 627A 020F  20         li    r15,vdpw              ; VDP write address
     627C 8C00 
0411 627E 045B  20         b     *r11
0412               
0413               
0414               
0415               ***************************************************************
0416               * Put length-byte prefixed string at current YX
0417               ***************************************************************
0418               *  BL   @PUTSTR
0419               *  DATA P0
0420               *
0421               *  P0 = Pointer to string
0422               *--------------------------------------------------------------
0423               *  REMARKS
0424               *  First byte of string must contain length
0425               ********@*****@*********************@**************************
0426 6280 C17B  30 putstr  mov   *r11+,tmp1
0427 6282 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0428 6284 C1CB  18 xutstr  mov   r11,tmp3
0429 6286 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6288 625C 
0430 628A C2C7  18         mov   tmp3,r11
0431 628C 0986  56         srl   tmp2,8                ; Right justify length byte
0432 628E 0460  28         b     @xpym2v               ; Display string
     6290 62A0 
0433               
0434               
0435               ***************************************************************
0436               * Put length-byte prefixed string at YX
0437               ***************************************************************
0438               *  BL   @PUTAT
0439               *  DATA P0,P1
0440               *
0441               *  P0 = YX position
0442               *  P1 = Pointer to string
0443               *--------------------------------------------------------------
0444               *  REMARKS
0445               *  First byte of string must contain length
0446               ********@*****@*********************@**************************
0447 6292 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6294 832A 
0448 6296 0460  28         b     @putstr
     6298 6280 
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
0020 629A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 629C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 629E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 62A0 0264  22 xpym2v  ori   tmp0,>4000
     62A2 4000 
0027 62A4 06C4  14         swpb  tmp0
0028 62A6 D804  38         movb  tmp0,@vdpa
     62A8 8C02 
0029 62AA 06C4  14         swpb  tmp0
0030 62AC D804  38         movb  tmp0,@vdpa
     62AE 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 62B0 020F  20         li    r15,vdpw              ; Set VDP write address
     62B2 8C00 
0035 62B4 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     62B6 62BE 
     62B8 8320 
0036 62BA 0460  28         b     @mcloop               ; Write data to VDP
     62BC 8320 
0037 62BE D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 62C0 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 62C2 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 62C4 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 62C6 06C4  14 xpyv2m  swpb  tmp0
0027 62C8 D804  38         movb  tmp0,@vdpa
     62CA 8C02 
0028 62CC 06C4  14         swpb  tmp0
0029 62CE D804  38         movb  tmp0,@vdpa
     62D0 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 62D2 020F  20         li    r15,vdpr              ; Set VDP read address
     62D4 8800 
0034 62D6 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     62D8 62E0 
     62DA 8320 
0035 62DC 0460  28         b     @mcloop               ; Read data from VDP
     62DE 8320 
0036 62E0 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 62E2 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 62E4 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62E6 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62E8 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 62EA 1602  14         jne   cpychk                ; No, continue checking
0032 62EC 0460  28         b     @crash_handler        ; Yes, crash
     62EE 604C 
0033               *--------------------------------------------------------------
0034               *    Check: 1 byte copy
0035               *--------------------------------------------------------------
0036 62F0 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     62F2 0001 
0037 62F4 1603  14         jne   cpym0                 ; No, continue checking
0038 62F6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0039 62F8 04C6  14         clr   tmp2                  ; Reset counter
0040 62FA 045B  20         b     *r11                  ; Return to caller
0041               *--------------------------------------------------------------
0042               *    Check: Uneven address handling
0043               *--------------------------------------------------------------
0044 62FC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62FE 7FFF 
0045 6300 C1C4  18         mov   tmp0,tmp3
0046 6302 0247  22         andi  tmp3,1
     6304 0001 
0047 6306 1618  14         jne   cpyodd                ; Odd source address handling
0048 6308 C1C5  18 cpym1   mov   tmp1,tmp3
0049 630A 0247  22         andi  tmp3,1
     630C 0001 
0050 630E 1614  14         jne   cpyodd                ; Odd target address handling
0051               *--------------------------------------------------------------
0052               * 8 bit copy
0053               *--------------------------------------------------------------
0054 6310 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6312 6046 
0055 6314 1605  14         jne   cpym3
0056 6316 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     6318 633E 
     631A 8320 
0057 631C 0460  28         b     @mcloop               ; Copy memory and exit
     631E 8320 
0058               *--------------------------------------------------------------
0059               * 16 bit copy
0060               *--------------------------------------------------------------
0061 6320 C1C6  18 cpym3   mov   tmp2,tmp3
0062 6322 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6324 0001 
0063 6326 1301  14         jeq   cpym4
0064 6328 0606  14         dec   tmp2                  ; Make TMP2 even
0065 632A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0066 632C 0646  14         dect  tmp2
0067 632E 16FD  14         jne   cpym4
0068               *--------------------------------------------------------------
0069               * Copy last byte if ODD
0070               *--------------------------------------------------------------
0071 6330 C1C7  18         mov   tmp3,tmp3
0072 6332 1301  14         jeq   cpymz
0073 6334 D554  38         movb  *tmp0,*tmp1
0074 6336 045B  20 cpymz   b     *r11                  ; Return to caller
0075               *--------------------------------------------------------------
0076               * Handle odd source/target address
0077               *--------------------------------------------------------------
0078 6338 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     633A 8000 
0079 633C 10E9  14         jmp   cpym2
0080 633E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0009 6340 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6342 FFBF 
0010 6344 0460  28         b     @putv01
     6346 61A8 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 6348 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     634A 0040 
0018 634C 0460  28         b     @putv01
     634E 61A8 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 6350 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6352 FFDF 
0026 6354 0460  28         b     @putv01
     6356 61A8 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6358 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     635A 0020 
0034 635C 0460  28         b     @putv01
     635E 61A8 
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
0010 6360 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6362 FFFE 
0011 6364 0460  28         b     @putv01
     6366 61A8 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 6368 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     636A 0001 
0019 636C 0460  28         b     @putv01
     636E 61A8 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 6370 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6372 FFFD 
0027 6374 0460  28         b     @putv01
     6376 61A8 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 6378 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     637A 0002 
0035 637C 0460  28         b     @putv01
     637E 61A8 
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
0018 6380 C83B  50 at      mov   *r11+,@wyx
     6382 832A 
0019 6384 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6386 B820  54 down    ab    @hb$01,@wyx
     6388 6038 
     638A 832A 
0028 638C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 638E 7820  54 up      sb    @hb$01,@wyx
     6390 6038 
     6392 832A 
0037 6394 045B  20         b     *r11
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
0049 6396 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6398 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     639A 832A 
0051 639C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     639E 832A 
0052 63A0 045B  20         b     *r11
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
0021 63A2 C120  34 yx2px   mov   @wyx,tmp0
     63A4 832A 
0022 63A6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 63A8 06C4  14         swpb  tmp0                  ; Y<->X
0024 63AA 04C5  14         clr   tmp1                  ; Clear before copy
0025 63AC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 63AE 20A0  38         coc   @wbit1,config         ; f18a present ?
     63B0 6044 
0030 63B2 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 63B4 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     63B6 833A 
     63B8 63E2 
0032 63BA 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 63BC 0A15  56         sla   tmp1,1                ; X = X * 2
0035 63BE B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 63C0 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     63C2 0500 
0037 63C4 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 63C6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 63C8 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 63CA 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 63CC D105  18         movb  tmp1,tmp0
0051 63CE 06C4  14         swpb  tmp0                  ; X<->Y
0052 63D0 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     63D2 6046 
0053 63D4 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 63D6 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     63D8 6038 
0059 63DA 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     63DC 604A 
0060 63DE 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 63E0 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 63E2 0050            data   80
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
0013 63E4 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 63E6 06A0  32         bl    @putvr                ; Write once
     63E8 6194 
0015 63EA 391C             data  >391c                 ; VR1/57, value 00011100
0016 63EC 06A0  32         bl    @putvr                ; Write twice
     63EE 6194 
0017 63F0 391C             data  >391c                 ; VR1/57, value 00011100
0018 63F2 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 63F4 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 63F6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63F8 6194 
0028 63FA 391C             data  >391c
0029 63FC 0458  20         b     *tmp4                 ; Exit
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
0040 63FE C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6400 06A0  32         bl    @cpym2v
     6402 629A 
0042 6404 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6406 6442 
     6408 0006 
0043 640A 06A0  32         bl    @putvr
     640C 6194 
0044 640E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6410 06A0  32         bl    @putvr
     6412 6194 
0046 6414 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6416 0204  20         li    tmp0,>3f00
     6418 3F00 
0052 641A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     641C 611C 
0053 641E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6420 8800 
0054 6422 0984  56         srl   tmp0,8
0055 6424 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6426 8800 
0056 6428 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 642A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 642C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     642E BFFF 
0060 6430 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6432 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6434 4000 
0063               f18chk_exit:
0064 6436 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6438 60F0 
0065 643A 3F00             data  >3f00,>00,6
     643C 0000 
     643E 0006 
0066 6440 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6442 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6444 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6446 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6448 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 644A 06A0  32         bl    @putvr
     644C 6194 
0097 644E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6450 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6452 6194 
0100 6454 391C             data  >391c                 ; Lock the F18a
0101 6456 0458  20         b     *tmp4                 ; Exit
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
0120 6458 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 645A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     645C 6044 
0122 645E 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6460 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6462 8802 
0127 6464 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6466 6194 
0128 6468 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 646A 04C4  14         clr   tmp0
0130 646C D120  34         movb  @vdps,tmp0
     646E 8802 
0131 6470 0984  56         srl   tmp0,8
0132 6472 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6474 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6476 832A 
0018 6478 D17B  28         movb  *r11+,tmp1
0019 647A 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 647C D1BB  28         movb  *r11+,tmp2
0021 647E 0986  56         srl   tmp2,8                ; Repeat count
0022 6480 C1CB  18         mov   r11,tmp3
0023 6482 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6484 625C 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6486 020B  20         li    r11,hchar1
     6488 648E 
0028 648A 0460  28         b     @xfilv                ; Draw
     648C 60F6 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 648E 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6490 6048 
0033 6492 1302  14         jeq   hchar2                ; Yes, exit
0034 6494 C2C7  18         mov   tmp3,r11
0035 6496 10EE  14         jmp   hchar                 ; Next one
0036 6498 05C7  14 hchar2  inct  tmp3
0037 649A 0457  20         b     *tmp3                 ; Exit
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
0016 649C 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     649E 6046 
0017 64A0 020C  20         li    r12,>0024
     64A2 0024 
0018 64A4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64A6 6534 
0019 64A8 04C6  14         clr   tmp2
0020 64AA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64AC 04CC  14         clr   r12
0025 64AE 1F08  20         tb    >0008                 ; Shift-key ?
0026 64B0 1302  14         jeq   realk1                ; No
0027 64B2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64B4 6564 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64B6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64B8 1302  14         jeq   realk2                ; No
0033 64BA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64BC 6594 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64BE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64C0 1302  14         jeq   realk3                ; No
0039 64C2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64C4 65C4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64C6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64C8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64CA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64CC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64CE 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64D0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64D2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64D4 0006 
0052 64D6 0606  14 realk5  dec   tmp2
0053 64D8 020C  20         li    r12,>24               ; CRU address for P2-P4
     64DA 0024 
0054 64DC 06C6  14         swpb  tmp2
0055 64DE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64E0 06C6  14         swpb  tmp2
0057 64E2 020C  20         li    r12,6                 ; CRU read address
     64E4 0006 
0058 64E6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64E8 0547  14         inv   tmp3                  ;
0060 64EA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     64EC FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 64EE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 64F0 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 64F2 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 64F4 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 64F6 0285  22         ci    tmp1,8
     64F8 0008 
0069 64FA 1AFA  14         jl    realk6
0070 64FC C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 64FE 1BEB  14         jh    realk5                ; No, next column
0072 6500 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6502 C206  18 realk8  mov   tmp2,tmp4
0077 6504 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6506 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6508 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 650A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 650C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 650E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6510 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6512 6046 
0087 6514 1608  14         jne   realka                ; No, continue saving key
0088 6516 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6518 655E 
0089 651A 1A05  14         jl    realka
0090 651C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     651E 655C 
0091 6520 1B02  14         jh    realka                ; No, continue
0092 6522 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6524 E000 
0093 6526 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6528 833C 
0094 652A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     652C 6030 
0095 652E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6530 8C00 
0096 6532 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6534 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6536 0000 
     6538 FF0D 
     653A 203D 
0099 653C ....             text  'xws29ol.'
0100 6544 ....             text  'ced38ik,'
0101 654C ....             text  'vrf47ujm'
0102 6554 ....             text  'btg56yhn'
0103 655C ....             text  'zqa10p;/'
0104 6564 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6566 0000 
     6568 FF0D 
     656A 202B 
0105 656C ....             text  'XWS@(OL>'
0106 6574 ....             text  'CED#*IK<'
0107 657C ....             text  'VRF$&UJM'
0108 6584 ....             text  'BTG%^YHN'
0109 658C ....             text  'ZQA!)P:-'
0110 6594 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6596 0000 
     6598 FF0D 
     659A 2005 
0111 659C 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     659E 0804 
     65A0 0F27 
     65A2 C2B9 
0112 65A4 600B             data  >600b,>0907,>063f,>c1B8
     65A6 0907 
     65A8 063F 
     65AA C1B8 
0113 65AC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65AE 7B02 
     65B0 015F 
     65B2 C0C3 
0114 65B4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65B6 7D0E 
     65B8 0CC6 
     65BA BFC4 
0115 65BC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65BE 7C03 
     65C0 BC22 
     65C2 BDBA 
0116 65C4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65C6 0000 
     65C8 FF0D 
     65CA 209D 
0117 65CC 9897             data  >9897,>93b2,>9f8f,>8c9B
     65CE 93B2 
     65D0 9F8F 
     65D2 8C9B 
0118 65D4 8385             data  >8385,>84b3,>9e89,>8b80
     65D6 84B3 
     65D8 9E89 
     65DA 8B80 
0119 65DC 9692             data  >9692,>86b4,>b795,>8a8D
     65DE 86B4 
     65E0 B795 
     65E2 8A8D 
0120 65E4 8294             data  >8294,>87b5,>b698,>888E
     65E6 87B5 
     65E8 B698 
     65EA 888E 
0121 65EC 9A91             data  >9a91,>81b1,>b090,>9cBB
     65EE 81B1 
     65F0 B090 
     65F2 9CBB 
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
0019 65F4 0207  20 mknum   li    tmp3,5                ; Digit counter
     65F6 0005 
0020 65F8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 65FA C155  26         mov   *tmp1,tmp1            ; /
0022 65FC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 65FE 0228  22         ai    tmp4,4                ; Get end of buffer
     6600 0004 
0024 6602 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6604 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6606 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6608 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 660A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 660C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 660E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6610 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6612 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6614 0607  14         dec   tmp3                  ; Decrease counter
0036 6616 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6618 0207  20         li    tmp3,4                ; Check first 4 digits
     661A 0004 
0041 661C 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 661E C11B  26         mov   *r11,tmp0
0043 6620 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6622 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6624 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6626 05CB  14 mknum3  inct  r11
0047 6628 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     662A 6046 
0048 662C 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 662E 045B  20         b     *r11                  ; Exit
0050 6630 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6632 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6634 13F8  14         jeq   mknum3                ; Yes, exit
0053 6636 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6638 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     663A 7FFF 
0058 663C C10B  18         mov   r11,tmp0
0059 663E 0224  22         ai    tmp0,-4
     6640 FFFC 
0060 6642 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6644 0206  20         li    tmp2,>0500            ; String length = 5
     6646 0500 
0062 6648 0460  28         b     @xutstr               ; Display string
     664A 6284 
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
0092 664C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 664E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6650 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6652 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6654 0207  20         li    tmp3,5                ; Set counter
     6656 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6658 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 665A 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 665C 0584  14         inc   tmp0                  ; Next character
0104 665E 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6660 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6662 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6664 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6666 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6668 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 666A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 666C 0607  14         dec   tmp3                  ; Last character ?
0120 666E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6670 045B  20         b     *r11                  ; Return
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
0138 6672 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6674 832A 
0139 6676 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6678 8000 
0140 667A 10BC  14         jmp   mknum                 ; Convert number and display
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
0012               *  P2 = Length of uncompressed data
0013               *
0014               *  Output:
0015               *  waux1 = Length of RLE encoded string
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu2rle
0018               *
0019               *  TMP0  = ROM/RAM source address
0020               *  TMP1  = ROM/RAM source address
0021               *  TMP2  = Length of uncompressed data
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
0074 667C C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 667E C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 6680 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 6682 0649  14         dect  stack
0079 6684 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 6686 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 6688 04C8  14         clr   tmp4                  ; Repeat counter
0086 668A 04E0  34         clr   @waux1                ; Length of RLE string
     668C 833C 
0087 668E 04E0  34         clr   @waux2                ; Address of encoding byte
     6690 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 6692 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 6694 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 6696 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 6698 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 669A C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 669C 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 669E 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     66A0 0001 
0105 66A2 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 66A4 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 66A6 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 66A8 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 66AA 06A0  32         bl    @cpu2rle.flush.duplicates
     66AC 66F6 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 66AE C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     66B0 833E 
     66B2 833E 
0126 66B4 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 66B6 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     66B8 833E 
0129 66BA 0585  14         inc   tmp1                  ; Skip encoding byte
0130 66BC 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     66BE 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 66C0 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 66C2 05A0  34         inc   @waux1                ; RLE string length += 1
     66C4 833C 
0136 66C6 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 66C8 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     66CA 833E 
     66CC 833E 
0145 66CE 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 66D0 06A0  32         bl    @cpu2rle.flush.encoding_byte
     66D2 6710 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 66D4 0588  14         inc   tmp4                  ; Increase repeat counter
0155 66D6 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 66D8 0606  14         dec   tmp2
0162 66DA 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 66DC C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 66DE 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 66E0 06A0  32         bl    @cpu2rle.flush.duplicates
     66E2 66F6 
0175                                                   ; (3.2) Flush pending ...
0176 66E4 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 66E6 C820  54         mov   @waux2,@waux2
     66E8 833E 
     66EA 833E 
0182 66EC 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 66EE 06A0  32         bl    @cpu2rle.flush.encoding_byte
     66F0 6710 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 66F2 0460  28         b     @poprt                ; Return
     66F4 60C8 
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
0204 66F6 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 66F8 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 66FA 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 66FC 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     66FE 8000 
0210 6700 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 6702 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6704 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 6706 05E0  34         inct  @waux1                ; RLE string length += 2
     6708 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 670A 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 670C 04C8  14         clr   tmp4                  ; Clear repeat count
0220 670E 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 6710 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 6712 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6714 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 6716 61E0  34         s     @waux2,tmp3           ; | characters
     6718 833E 
0232 671A 0607  14         dec   tmp3                  ; /
0233               
0234 671C 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 671E C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     6720 833E 
0236 6722 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6724 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6726 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6728 833E 
0240 672A 04C8  14         clr   tmp4                  ; Clear before exit
0241 672C 045B  20         b     *r11                  ; Return
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
0031 672E C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 6730 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6732 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6734 0649  14         dect  stack
0036 6736 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6738 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 673A 0606  14         dec   tmp2                  ; Update length
0043 673C 131E  14         jeq   rle2cpu.exit          ; End of list
0044 673E 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 6740 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6742 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6744 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053 6746 0649  14         dect  stack
0054 6748 C646  30         mov   tmp2,*stack           ; Push tmp2
0055               
0056 674A C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057 674C 06A0  32         bl    @xpym2m               ; Block copy to destination
     674E 62E8 
0058 6750 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0059               
0060 6752 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0061               *--------------------------------------------------------------
0062               *    Dump compressed bytes
0063               *--------------------------------------------------------------
0064               rle2cpu.dump_compressed:
0065 6754 0997  56         srl   tmp3,9                ; Use control byte as counter
0066 6756 0606  14         dec   tmp2                  ; Update RLE string length
0067               
0068 6758 0649  14         dect  stack
0069 675A C645  30         mov   tmp1,*stack           ; Push tmp1
0070 675C 0649  14         dect  stack
0071 675E C646  30         mov   tmp2,*stack           ; Push tmp2
0072 6760 0649  14         dect  stack
0073 6762 C647  30         mov   tmp3,*stack           ; Push tmp3
0074               
0075 6764 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0076 6766 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0077 6768 0985  56         srl   tmp1,8                ; Right align
0078 676A 06A0  32         bl    @xfilm                ; Block fill to destination
     676C 60D2 
0079               
0080 676E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0081 6770 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0082 6772 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0083               
0084 6774 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0085               *--------------------------------------------------------------
0086               *    Check if more data to decompress
0087               *--------------------------------------------------------------
0088               rle2cpu.check_if_more:
0089 6776 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0090 6778 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0091               *--------------------------------------------------------------
0092               *    Exit
0093               *--------------------------------------------------------------
0094               rle2cpu.exit:
0095 677A 0460  28         b     @poprt                ; Return
     677C 60C8 
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
0021 677E C820  54         mov   @>8300,@>2000
     6780 8300 
     6782 2000 
0022 6784 C820  54         mov   @>8302,@>2002
     6786 8302 
     6788 2002 
0023 678A C820  54         mov   @>8304,@>2004
     678C 8304 
     678E 2004 
0024 6790 C820  54         mov   @>8306,@>2006
     6792 8306 
     6794 2006 
0025 6796 C820  54         mov   @>8308,@>2008
     6798 8308 
     679A 2008 
0026 679C C820  54         mov   @>830A,@>200A
     679E 830A 
     67A0 200A 
0027 67A2 C820  54         mov   @>830C,@>200C
     67A4 830C 
     67A6 200C 
0028 67A8 C820  54         mov   @>830E,@>200E
     67AA 830E 
     67AC 200E 
0029 67AE C820  54         mov   @>8310,@>2010
     67B0 8310 
     67B2 2010 
0030 67B4 C820  54         mov   @>8312,@>2012
     67B6 8312 
     67B8 2012 
0031 67BA C820  54         mov   @>8314,@>2014
     67BC 8314 
     67BE 2014 
0032 67C0 C820  54         mov   @>8316,@>2016
     67C2 8316 
     67C4 2016 
0033 67C6 C820  54         mov   @>8318,@>2018
     67C8 8318 
     67CA 2018 
0034 67CC C820  54         mov   @>831A,@>201A
     67CE 831A 
     67D0 201A 
0035 67D2 C820  54         mov   @>831C,@>201C
     67D4 831C 
     67D6 201C 
0036 67D8 C820  54         mov   @>831E,@>201E
     67DA 831E 
     67DC 201E 
0037 67DE C820  54         mov   @>8320,@>2020
     67E0 8320 
     67E2 2020 
0038 67E4 C820  54         mov   @>8322,@>2022
     67E6 8322 
     67E8 2022 
0039 67EA C820  54         mov   @>8324,@>2024
     67EC 8324 
     67EE 2024 
0040 67F0 C820  54         mov   @>8326,@>2026
     67F2 8326 
     67F4 2026 
0041 67F6 C820  54         mov   @>8328,@>2028
     67F8 8328 
     67FA 2028 
0042 67FC C820  54         mov   @>832A,@>202A
     67FE 832A 
     6800 202A 
0043 6802 C820  54         mov   @>832C,@>202C
     6804 832C 
     6806 202C 
0044 6808 C820  54         mov   @>832E,@>202E
     680A 832E 
     680C 202E 
0045 680E C820  54         mov   @>8330,@>2030
     6810 8330 
     6812 2030 
0046 6814 C820  54         mov   @>8332,@>2032
     6816 8332 
     6818 2032 
0047 681A C820  54         mov   @>8334,@>2034
     681C 8334 
     681E 2034 
0048 6820 C820  54         mov   @>8336,@>2036
     6822 8336 
     6824 2036 
0049 6826 C820  54         mov   @>8338,@>2038
     6828 8338 
     682A 2038 
0050 682C C820  54         mov   @>833A,@>203A
     682E 833A 
     6830 203A 
0051 6832 C820  54         mov   @>833C,@>203C
     6834 833C 
     6836 203C 
0052 6838 C820  54         mov   @>833E,@>203E
     683A 833E 
     683C 203E 
0053 683E C820  54         mov   @>8340,@>2040
     6840 8340 
     6842 2040 
0054 6844 C820  54         mov   @>8342,@>2042
     6846 8342 
     6848 2042 
0055 684A C820  54         mov   @>8344,@>2044
     684C 8344 
     684E 2044 
0056 6850 C820  54         mov   @>8346,@>2046
     6852 8346 
     6854 2046 
0057 6856 C820  54         mov   @>8348,@>2048
     6858 8348 
     685A 2048 
0058 685C C820  54         mov   @>834A,@>204A
     685E 834A 
     6860 204A 
0059 6862 C820  54         mov   @>834C,@>204C
     6864 834C 
     6866 204C 
0060 6868 C820  54         mov   @>834E,@>204E
     686A 834E 
     686C 204E 
0061 686E C820  54         mov   @>8350,@>2050
     6870 8350 
     6872 2050 
0062 6874 C820  54         mov   @>8352,@>2052
     6876 8352 
     6878 2052 
0063 687A C820  54         mov   @>8354,@>2054
     687C 8354 
     687E 2054 
0064 6880 C820  54         mov   @>8356,@>2056
     6882 8356 
     6884 2056 
0065 6886 C820  54         mov   @>8358,@>2058
     6888 8358 
     688A 2058 
0066 688C C820  54         mov   @>835A,@>205A
     688E 835A 
     6890 205A 
0067 6892 C820  54         mov   @>835C,@>205C
     6894 835C 
     6896 205C 
0068 6898 C820  54         mov   @>835E,@>205E
     689A 835E 
     689C 205E 
0069 689E C820  54         mov   @>8360,@>2060
     68A0 8360 
     68A2 2060 
0070 68A4 C820  54         mov   @>8362,@>2062
     68A6 8362 
     68A8 2062 
0071 68AA C820  54         mov   @>8364,@>2064
     68AC 8364 
     68AE 2064 
0072 68B0 C820  54         mov   @>8366,@>2066
     68B2 8366 
     68B4 2066 
0073 68B6 C820  54         mov   @>8368,@>2068
     68B8 8368 
     68BA 2068 
0074 68BC C820  54         mov   @>836A,@>206A
     68BE 836A 
     68C0 206A 
0075 68C2 C820  54         mov   @>836C,@>206C
     68C4 836C 
     68C6 206C 
0076 68C8 C820  54         mov   @>836E,@>206E
     68CA 836E 
     68CC 206E 
0077 68CE C820  54         mov   @>8370,@>2070
     68D0 8370 
     68D2 2070 
0078 68D4 C820  54         mov   @>8372,@>2072
     68D6 8372 
     68D8 2072 
0079 68DA C820  54         mov   @>8374,@>2074
     68DC 8374 
     68DE 2074 
0080 68E0 C820  54         mov   @>8376,@>2076
     68E2 8376 
     68E4 2076 
0081 68E6 C820  54         mov   @>8378,@>2078
     68E8 8378 
     68EA 2078 
0082 68EC C820  54         mov   @>837A,@>207A
     68EE 837A 
     68F0 207A 
0083 68F2 C820  54         mov   @>837C,@>207C
     68F4 837C 
     68F6 207C 
0084 68F8 C820  54         mov   @>837E,@>207E
     68FA 837E 
     68FC 207E 
0085 68FE C820  54         mov   @>8380,@>2080
     6900 8380 
     6902 2080 
0086 6904 C820  54         mov   @>8382,@>2082
     6906 8382 
     6908 2082 
0087 690A C820  54         mov   @>8384,@>2084
     690C 8384 
     690E 2084 
0088 6910 C820  54         mov   @>8386,@>2086
     6912 8386 
     6914 2086 
0089 6916 C820  54         mov   @>8388,@>2088
     6918 8388 
     691A 2088 
0090 691C C820  54         mov   @>838A,@>208A
     691E 838A 
     6920 208A 
0091 6922 C820  54         mov   @>838C,@>208C
     6924 838C 
     6926 208C 
0092 6928 C820  54         mov   @>838E,@>208E
     692A 838E 
     692C 208E 
0093 692E C820  54         mov   @>8390,@>2090
     6930 8390 
     6932 2090 
0094 6934 C820  54         mov   @>8392,@>2092
     6936 8392 
     6938 2092 
0095 693A C820  54         mov   @>8394,@>2094
     693C 8394 
     693E 2094 
0096 6940 C820  54         mov   @>8396,@>2096
     6942 8396 
     6944 2096 
0097 6946 C820  54         mov   @>8398,@>2098
     6948 8398 
     694A 2098 
0098 694C C820  54         mov   @>839A,@>209A
     694E 839A 
     6950 209A 
0099 6952 C820  54         mov   @>839C,@>209C
     6954 839C 
     6956 209C 
0100 6958 C820  54         mov   @>839E,@>209E
     695A 839E 
     695C 209E 
0101 695E C820  54         mov   @>83A0,@>20A0
     6960 83A0 
     6962 20A0 
0102 6964 C820  54         mov   @>83A2,@>20A2
     6966 83A2 
     6968 20A2 
0103 696A C820  54         mov   @>83A4,@>20A4
     696C 83A4 
     696E 20A4 
0104 6970 C820  54         mov   @>83A6,@>20A6
     6972 83A6 
     6974 20A6 
0105 6976 C820  54         mov   @>83A8,@>20A8
     6978 83A8 
     697A 20A8 
0106 697C C820  54         mov   @>83AA,@>20AA
     697E 83AA 
     6980 20AA 
0107 6982 C820  54         mov   @>83AC,@>20AC
     6984 83AC 
     6986 20AC 
0108 6988 C820  54         mov   @>83AE,@>20AE
     698A 83AE 
     698C 20AE 
0109 698E C820  54         mov   @>83B0,@>20B0
     6990 83B0 
     6992 20B0 
0110 6994 C820  54         mov   @>83B2,@>20B2
     6996 83B2 
     6998 20B2 
0111 699A C820  54         mov   @>83B4,@>20B4
     699C 83B4 
     699E 20B4 
0112 69A0 C820  54         mov   @>83B6,@>20B6
     69A2 83B6 
     69A4 20B6 
0113 69A6 C820  54         mov   @>83B8,@>20B8
     69A8 83B8 
     69AA 20B8 
0114 69AC C820  54         mov   @>83BA,@>20BA
     69AE 83BA 
     69B0 20BA 
0115 69B2 C820  54         mov   @>83BC,@>20BC
     69B4 83BC 
     69B6 20BC 
0116 69B8 C820  54         mov   @>83BE,@>20BE
     69BA 83BE 
     69BC 20BE 
0117 69BE C820  54         mov   @>83C0,@>20C0
     69C0 83C0 
     69C2 20C0 
0118 69C4 C820  54         mov   @>83C2,@>20C2
     69C6 83C2 
     69C8 20C2 
0119 69CA C820  54         mov   @>83C4,@>20C4
     69CC 83C4 
     69CE 20C4 
0120 69D0 C820  54         mov   @>83C6,@>20C6
     69D2 83C6 
     69D4 20C6 
0121 69D6 C820  54         mov   @>83C8,@>20C8
     69D8 83C8 
     69DA 20C8 
0122 69DC C820  54         mov   @>83CA,@>20CA
     69DE 83CA 
     69E0 20CA 
0123 69E2 C820  54         mov   @>83CC,@>20CC
     69E4 83CC 
     69E6 20CC 
0124 69E8 C820  54         mov   @>83CE,@>20CE
     69EA 83CE 
     69EC 20CE 
0125 69EE C820  54         mov   @>83D0,@>20D0
     69F0 83D0 
     69F2 20D0 
0126 69F4 C820  54         mov   @>83D2,@>20D2
     69F6 83D2 
     69F8 20D2 
0127 69FA C820  54         mov   @>83D4,@>20D4
     69FC 83D4 
     69FE 20D4 
0128 6A00 C820  54         mov   @>83D6,@>20D6
     6A02 83D6 
     6A04 20D6 
0129 6A06 C820  54         mov   @>83D8,@>20D8
     6A08 83D8 
     6A0A 20D8 
0130 6A0C C820  54         mov   @>83DA,@>20DA
     6A0E 83DA 
     6A10 20DA 
0131 6A12 C820  54         mov   @>83DC,@>20DC
     6A14 83DC 
     6A16 20DC 
0132 6A18 C820  54         mov   @>83DE,@>20DE
     6A1A 83DE 
     6A1C 20DE 
0133 6A1E C820  54         mov   @>83E0,@>20E0
     6A20 83E0 
     6A22 20E0 
0134 6A24 C820  54         mov   @>83E2,@>20E2
     6A26 83E2 
     6A28 20E2 
0135 6A2A C820  54         mov   @>83E4,@>20E4
     6A2C 83E4 
     6A2E 20E4 
0136 6A30 C820  54         mov   @>83E6,@>20E6
     6A32 83E6 
     6A34 20E6 
0137 6A36 C820  54         mov   @>83E8,@>20E8
     6A38 83E8 
     6A3A 20E8 
0138 6A3C C820  54         mov   @>83EA,@>20EA
     6A3E 83EA 
     6A40 20EA 
0139 6A42 C820  54         mov   @>83EC,@>20EC
     6A44 83EC 
     6A46 20EC 
0140 6A48 C820  54         mov   @>83EE,@>20EE
     6A4A 83EE 
     6A4C 20EE 
0141 6A4E C820  54         mov   @>83F0,@>20F0
     6A50 83F0 
     6A52 20F0 
0142 6A54 C820  54         mov   @>83F2,@>20F2
     6A56 83F2 
     6A58 20F2 
0143 6A5A C820  54         mov   @>83F4,@>20F4
     6A5C 83F4 
     6A5E 20F4 
0144 6A60 C820  54         mov   @>83F6,@>20F6
     6A62 83F6 
     6A64 20F6 
0145 6A66 C820  54         mov   @>83F8,@>20F8
     6A68 83F8 
     6A6A 20F8 
0146 6A6C C820  54         mov   @>83FA,@>20FA
     6A6E 83FA 
     6A70 20FA 
0147 6A72 C820  54         mov   @>83FC,@>20FC
     6A74 83FC 
     6A76 20FC 
0148 6A78 C820  54         mov   @>83FE,@>20FE
     6A7A 83FE 
     6A7C 20FE 
0149 6A7E 045B  20         b     *r11                  ; Return to caller
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
0164 6A80 C820  54         mov   @>2000,@>8300
     6A82 2000 
     6A84 8300 
0165 6A86 C820  54         mov   @>2002,@>8302
     6A88 2002 
     6A8A 8302 
0166 6A8C C820  54         mov   @>2004,@>8304
     6A8E 2004 
     6A90 8304 
0167 6A92 C820  54         mov   @>2006,@>8306
     6A94 2006 
     6A96 8306 
0168 6A98 C820  54         mov   @>2008,@>8308
     6A9A 2008 
     6A9C 8308 
0169 6A9E C820  54         mov   @>200A,@>830A
     6AA0 200A 
     6AA2 830A 
0170 6AA4 C820  54         mov   @>200C,@>830C
     6AA6 200C 
     6AA8 830C 
0171 6AAA C820  54         mov   @>200E,@>830E
     6AAC 200E 
     6AAE 830E 
0172 6AB0 C820  54         mov   @>2010,@>8310
     6AB2 2010 
     6AB4 8310 
0173 6AB6 C820  54         mov   @>2012,@>8312
     6AB8 2012 
     6ABA 8312 
0174 6ABC C820  54         mov   @>2014,@>8314
     6ABE 2014 
     6AC0 8314 
0175 6AC2 C820  54         mov   @>2016,@>8316
     6AC4 2016 
     6AC6 8316 
0176 6AC8 C820  54         mov   @>2018,@>8318
     6ACA 2018 
     6ACC 8318 
0177 6ACE C820  54         mov   @>201A,@>831A
     6AD0 201A 
     6AD2 831A 
0178 6AD4 C820  54         mov   @>201C,@>831C
     6AD6 201C 
     6AD8 831C 
0179 6ADA C820  54         mov   @>201E,@>831E
     6ADC 201E 
     6ADE 831E 
0180 6AE0 C820  54         mov   @>2020,@>8320
     6AE2 2020 
     6AE4 8320 
0181 6AE6 C820  54         mov   @>2022,@>8322
     6AE8 2022 
     6AEA 8322 
0182 6AEC C820  54         mov   @>2024,@>8324
     6AEE 2024 
     6AF0 8324 
0183 6AF2 C820  54         mov   @>2026,@>8326
     6AF4 2026 
     6AF6 8326 
0184 6AF8 C820  54         mov   @>2028,@>8328
     6AFA 2028 
     6AFC 8328 
0185 6AFE C820  54         mov   @>202A,@>832A
     6B00 202A 
     6B02 832A 
0186 6B04 C820  54         mov   @>202C,@>832C
     6B06 202C 
     6B08 832C 
0187 6B0A C820  54         mov   @>202E,@>832E
     6B0C 202E 
     6B0E 832E 
0188 6B10 C820  54         mov   @>2030,@>8330
     6B12 2030 
     6B14 8330 
0189 6B16 C820  54         mov   @>2032,@>8332
     6B18 2032 
     6B1A 8332 
0190 6B1C C820  54         mov   @>2034,@>8334
     6B1E 2034 
     6B20 8334 
0191 6B22 C820  54         mov   @>2036,@>8336
     6B24 2036 
     6B26 8336 
0192 6B28 C820  54         mov   @>2038,@>8338
     6B2A 2038 
     6B2C 8338 
0193 6B2E C820  54         mov   @>203A,@>833A
     6B30 203A 
     6B32 833A 
0194 6B34 C820  54         mov   @>203C,@>833C
     6B36 203C 
     6B38 833C 
0195 6B3A C820  54         mov   @>203E,@>833E
     6B3C 203E 
     6B3E 833E 
0196 6B40 C820  54         mov   @>2040,@>8340
     6B42 2040 
     6B44 8340 
0197 6B46 C820  54         mov   @>2042,@>8342
     6B48 2042 
     6B4A 8342 
0198 6B4C C820  54         mov   @>2044,@>8344
     6B4E 2044 
     6B50 8344 
0199 6B52 C820  54         mov   @>2046,@>8346
     6B54 2046 
     6B56 8346 
0200 6B58 C820  54         mov   @>2048,@>8348
     6B5A 2048 
     6B5C 8348 
0201 6B5E C820  54         mov   @>204A,@>834A
     6B60 204A 
     6B62 834A 
0202 6B64 C820  54         mov   @>204C,@>834C
     6B66 204C 
     6B68 834C 
0203 6B6A C820  54         mov   @>204E,@>834E
     6B6C 204E 
     6B6E 834E 
0204 6B70 C820  54         mov   @>2050,@>8350
     6B72 2050 
     6B74 8350 
0205 6B76 C820  54         mov   @>2052,@>8352
     6B78 2052 
     6B7A 8352 
0206 6B7C C820  54         mov   @>2054,@>8354
     6B7E 2054 
     6B80 8354 
0207 6B82 C820  54         mov   @>2056,@>8356
     6B84 2056 
     6B86 8356 
0208 6B88 C820  54         mov   @>2058,@>8358
     6B8A 2058 
     6B8C 8358 
0209 6B8E C820  54         mov   @>205A,@>835A
     6B90 205A 
     6B92 835A 
0210 6B94 C820  54         mov   @>205C,@>835C
     6B96 205C 
     6B98 835C 
0211 6B9A C820  54         mov   @>205E,@>835E
     6B9C 205E 
     6B9E 835E 
0212 6BA0 C820  54         mov   @>2060,@>8360
     6BA2 2060 
     6BA4 8360 
0213 6BA6 C820  54         mov   @>2062,@>8362
     6BA8 2062 
     6BAA 8362 
0214 6BAC C820  54         mov   @>2064,@>8364
     6BAE 2064 
     6BB0 8364 
0215 6BB2 C820  54         mov   @>2066,@>8366
     6BB4 2066 
     6BB6 8366 
0216 6BB8 C820  54         mov   @>2068,@>8368
     6BBA 2068 
     6BBC 8368 
0217 6BBE C820  54         mov   @>206A,@>836A
     6BC0 206A 
     6BC2 836A 
0218 6BC4 C820  54         mov   @>206C,@>836C
     6BC6 206C 
     6BC8 836C 
0219 6BCA C820  54         mov   @>206E,@>836E
     6BCC 206E 
     6BCE 836E 
0220 6BD0 C820  54         mov   @>2070,@>8370
     6BD2 2070 
     6BD4 8370 
0221 6BD6 C820  54         mov   @>2072,@>8372
     6BD8 2072 
     6BDA 8372 
0222 6BDC C820  54         mov   @>2074,@>8374
     6BDE 2074 
     6BE0 8374 
0223 6BE2 C820  54         mov   @>2076,@>8376
     6BE4 2076 
     6BE6 8376 
0224 6BE8 C820  54         mov   @>2078,@>8378
     6BEA 2078 
     6BEC 8378 
0225 6BEE C820  54         mov   @>207A,@>837A
     6BF0 207A 
     6BF2 837A 
0226 6BF4 C820  54         mov   @>207C,@>837C
     6BF6 207C 
     6BF8 837C 
0227 6BFA C820  54         mov   @>207E,@>837E
     6BFC 207E 
     6BFE 837E 
0228 6C00 C820  54         mov   @>2080,@>8380
     6C02 2080 
     6C04 8380 
0229 6C06 C820  54         mov   @>2082,@>8382
     6C08 2082 
     6C0A 8382 
0230 6C0C C820  54         mov   @>2084,@>8384
     6C0E 2084 
     6C10 8384 
0231 6C12 C820  54         mov   @>2086,@>8386
     6C14 2086 
     6C16 8386 
0232 6C18 C820  54         mov   @>2088,@>8388
     6C1A 2088 
     6C1C 8388 
0233 6C1E C820  54         mov   @>208A,@>838A
     6C20 208A 
     6C22 838A 
0234 6C24 C820  54         mov   @>208C,@>838C
     6C26 208C 
     6C28 838C 
0235 6C2A C820  54         mov   @>208E,@>838E
     6C2C 208E 
     6C2E 838E 
0236 6C30 C820  54         mov   @>2090,@>8390
     6C32 2090 
     6C34 8390 
0237 6C36 C820  54         mov   @>2092,@>8392
     6C38 2092 
     6C3A 8392 
0238 6C3C C820  54         mov   @>2094,@>8394
     6C3E 2094 
     6C40 8394 
0239 6C42 C820  54         mov   @>2096,@>8396
     6C44 2096 
     6C46 8396 
0240 6C48 C820  54         mov   @>2098,@>8398
     6C4A 2098 
     6C4C 8398 
0241 6C4E C820  54         mov   @>209A,@>839A
     6C50 209A 
     6C52 839A 
0242 6C54 C820  54         mov   @>209C,@>839C
     6C56 209C 
     6C58 839C 
0243 6C5A C820  54         mov   @>209E,@>839E
     6C5C 209E 
     6C5E 839E 
0244 6C60 C820  54         mov   @>20A0,@>83A0
     6C62 20A0 
     6C64 83A0 
0245 6C66 C820  54         mov   @>20A2,@>83A2
     6C68 20A2 
     6C6A 83A2 
0246 6C6C C820  54         mov   @>20A4,@>83A4
     6C6E 20A4 
     6C70 83A4 
0247 6C72 C820  54         mov   @>20A6,@>83A6
     6C74 20A6 
     6C76 83A6 
0248 6C78 C820  54         mov   @>20A8,@>83A8
     6C7A 20A8 
     6C7C 83A8 
0249 6C7E C820  54         mov   @>20AA,@>83AA
     6C80 20AA 
     6C82 83AA 
0250 6C84 C820  54         mov   @>20AC,@>83AC
     6C86 20AC 
     6C88 83AC 
0251 6C8A C820  54         mov   @>20AE,@>83AE
     6C8C 20AE 
     6C8E 83AE 
0252 6C90 C820  54         mov   @>20B0,@>83B0
     6C92 20B0 
     6C94 83B0 
0253 6C96 C820  54         mov   @>20B2,@>83B2
     6C98 20B2 
     6C9A 83B2 
0254 6C9C C820  54         mov   @>20B4,@>83B4
     6C9E 20B4 
     6CA0 83B4 
0255 6CA2 C820  54         mov   @>20B6,@>83B6
     6CA4 20B6 
     6CA6 83B6 
0256 6CA8 C820  54         mov   @>20B8,@>83B8
     6CAA 20B8 
     6CAC 83B8 
0257 6CAE C820  54         mov   @>20BA,@>83BA
     6CB0 20BA 
     6CB2 83BA 
0258 6CB4 C820  54         mov   @>20BC,@>83BC
     6CB6 20BC 
     6CB8 83BC 
0259 6CBA C820  54         mov   @>20BE,@>83BE
     6CBC 20BE 
     6CBE 83BE 
0260 6CC0 C820  54         mov   @>20C0,@>83C0
     6CC2 20C0 
     6CC4 83C0 
0261 6CC6 C820  54         mov   @>20C2,@>83C2
     6CC8 20C2 
     6CCA 83C2 
0262 6CCC C820  54         mov   @>20C4,@>83C4
     6CCE 20C4 
     6CD0 83C4 
0263 6CD2 C820  54         mov   @>20C6,@>83C6
     6CD4 20C6 
     6CD6 83C6 
0264 6CD8 C820  54         mov   @>20C8,@>83C8
     6CDA 20C8 
     6CDC 83C8 
0265 6CDE C820  54         mov   @>20CA,@>83CA
     6CE0 20CA 
     6CE2 83CA 
0266 6CE4 C820  54         mov   @>20CC,@>83CC
     6CE6 20CC 
     6CE8 83CC 
0267 6CEA C820  54         mov   @>20CE,@>83CE
     6CEC 20CE 
     6CEE 83CE 
0268 6CF0 C820  54         mov   @>20D0,@>83D0
     6CF2 20D0 
     6CF4 83D0 
0269 6CF6 C820  54         mov   @>20D2,@>83D2
     6CF8 20D2 
     6CFA 83D2 
0270 6CFC C820  54         mov   @>20D4,@>83D4
     6CFE 20D4 
     6D00 83D4 
0271 6D02 C820  54         mov   @>20D6,@>83D6
     6D04 20D6 
     6D06 83D6 
0272 6D08 C820  54         mov   @>20D8,@>83D8
     6D0A 20D8 
     6D0C 83D8 
0273 6D0E C820  54         mov   @>20DA,@>83DA
     6D10 20DA 
     6D12 83DA 
0274 6D14 C820  54         mov   @>20DC,@>83DC
     6D16 20DC 
     6D18 83DC 
0275 6D1A C820  54         mov   @>20DE,@>83DE
     6D1C 20DE 
     6D1E 83DE 
0276 6D20 C820  54         mov   @>20E0,@>83E0
     6D22 20E0 
     6D24 83E0 
0277 6D26 C820  54         mov   @>20E2,@>83E2
     6D28 20E2 
     6D2A 83E2 
0278 6D2C C820  54         mov   @>20E4,@>83E4
     6D2E 20E4 
     6D30 83E4 
0279 6D32 C820  54         mov   @>20E6,@>83E6
     6D34 20E6 
     6D36 83E6 
0280 6D38 C820  54         mov   @>20E8,@>83E8
     6D3A 20E8 
     6D3C 83E8 
0281 6D3E C820  54         mov   @>20EA,@>83EA
     6D40 20EA 
     6D42 83EA 
0282 6D44 C820  54         mov   @>20EC,@>83EC
     6D46 20EC 
     6D48 83EC 
0283 6D4A C820  54         mov   @>20EE,@>83EE
     6D4C 20EE 
     6D4E 83EE 
0284 6D50 C820  54         mov   @>20F0,@>83F0
     6D52 20F0 
     6D54 83F0 
0285 6D56 C820  54         mov   @>20F2,@>83F2
     6D58 20F2 
     6D5A 83F2 
0286 6D5C C820  54         mov   @>20F4,@>83F4
     6D5E 20F4 
     6D60 83F4 
0287 6D62 C820  54         mov   @>20F6,@>83F6
     6D64 20F6 
     6D66 83F6 
0288 6D68 C820  54         mov   @>20F8,@>83F8
     6D6A 20F8 
     6D6C 83F8 
0289 6D6E C820  54         mov   @>20FA,@>83FA
     6D70 20FA 
     6D72 83FA 
0290 6D74 C820  54         mov   @>20FC,@>83FC
     6D76 20FC 
     6D78 83FC 
0291 6D7A C820  54         mov   @>20FE,@>83FE
     6D7C 20FE 
     6D7E 83FE 
0292 6D80 045B  20         b     *r11                  ; Return to caller
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
0024 6D82 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6D84 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6D86 8300 
0030 6D88 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6D8A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D8C 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6D8E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6D90 0606  14         dec   tmp2
0037 6D92 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6D94 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6D96 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6D98 6D9E 
0043                                                   ; R14=PC
0044 6D9A 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6D9C 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6D9E 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6DA0 6A80 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6DA2 045B  20         b     *r11                  ; Return to caller
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
0077 6DA4 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6DA6 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6DA8 8300 
0083 6DAA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6DAC 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6DAE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6DB0 0606  14         dec   tmp2
0089 6DB2 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6DB4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6DB6 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6DB8 045B  20         b     *r11                  ; Return to caller
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
0041 6DBA 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6DBC 6DBE             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6DBE C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6DC0 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6DC2 8322 
0049 6DC4 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6DC6 6042 
0050 6DC8 C020  34         mov   @>8356,r0             ; get ptr to pab
     6DCA 8356 
0051 6DCC C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6DCE 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6DD0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6DD2 06C0  14         swpb  r0                    ;
0059 6DD4 D800  38         movb  r0,@vdpa              ; send low byte
     6DD6 8C02 
0060 6DD8 06C0  14         swpb  r0                    ;
0061 6DDA D800  38         movb  r0,@vdpa              ; send high byte
     6DDC 8C02 
0062 6DDE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6DE0 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6DE2 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6DE4 0704  14         seto  r4                    ; init counter
0070 6DE6 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6DE8 2420 
0071 6DEA 0580  14 !       inc   r0                    ; point to next char of name
0072 6DEC 0584  14         inc   r4                    ; incr char counter
0073 6DEE 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6DF0 0007 
0074 6DF2 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6DF4 80C4  18         c     r4,r3                 ; end of name?
0077 6DF6 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6DF8 06C0  14         swpb  r0                    ;
0082 6DFA D800  38         movb  r0,@vdpa              ; send low byte
     6DFC 8C02 
0083 6DFE 06C0  14         swpb  r0                    ;
0084 6E00 D800  38         movb  r0,@vdpa              ; send high byte
     6E02 8C02 
0085 6E04 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E06 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6E08 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6E0A 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6E0C 6ECE 
0093 6E0E 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6E10 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6E12 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6E14 04E0  34         clr   @>83d0
     6E16 83D0 
0102 6E18 C804  38         mov   r4,@>8354             ; save name length for search
     6E1A 8354 
0103 6E1C 0584  14         inc   r4                    ; adjust for dot
0104 6E1E A804  38         a     r4,@>8356             ; point to position after name
     6E20 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6E22 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E24 83E0 
0110 6E26 04C1  14         clr   r1                    ; version found of dsr
0111 6E28 020C  20         li    r12,>0f00             ; init cru addr
     6E2A 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6E2C C30C  18         mov   r12,r12               ; anything to turn off?
0117 6E2E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6E30 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6E32 022C  22         ai    r12,>0100             ; next rom to turn on
     6E34 0100 
0125 6E36 04E0  34         clr   @>83d0                ; clear in case we are done
     6E38 83D0 
0126 6E3A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6E3C 2000 
0127 6E3E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6E40 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6E42 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6E44 1D00  20         sbo   0                     ; turn on rom
0134 6E46 0202  20         li    r2,>4000              ; start at beginning of rom
     6E48 4000 
0135 6E4A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6E4C 6ECA 
0136 6E4E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6E50 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6E52 240A 
0146 6E54 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6E56 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6E58 83D2 
0152 6E5A 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6E5C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6E5E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6E60 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6E62 83D2 
0161 6E64 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6E66 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6E68 04C5  14         clr   r5                    ; Remove any old stuff
0167 6E6A D160  34         movb  @>8355,r5             ; get length as counter
     6E6C 8355 
0168 6E6E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6E70 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6E72 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6E74 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6E76 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6E78 2420 
0175 6E7A 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6E7C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6E7E 0605  14         dec   r5                    ; loop until full length checked
0179 6E80 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6E82 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6E84 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6E86 0581  14         inc   r1                    ; next version found
0191 6E88 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6E8A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6E8C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6E8E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6E90 2400 
0200 6E92 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6E94 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6E96 8322 
0202                                                   ; (8 or >a)
0203 6E98 0281  22         ci    r1,8                  ; was it 8?
     6E9A 0008 
0204 6E9C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6E9E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6EA0 8350 
0206                                                   ; Get error byte from @>8350
0207 6EA2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6EA4 06C0  14         swpb  r0                    ;
0215 6EA6 D800  38         movb  r0,@vdpa              ; send low byte
     6EA8 8C02 
0216 6EAA 06C0  14         swpb  r0                    ;
0217 6EAC D800  38         movb  r0,@vdpa              ; send high byte
     6EAE 8C02 
0218 6EB0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6EB2 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6EB4 09D1  56         srl   r1,13                 ; just keep error bits
0226 6EB6 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6EB8 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6EBA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6EBC 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6EBE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6EC0 06C1  14         swpb  r1                    ; put error in hi byte
0239 6EC2 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6EC4 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6EC6 6042 
0241 6EC8 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6ECA AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6ECC 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6ECE ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6ED0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6ED2 C04B  18         mov   r11,r1                ; Save return address
0049 6ED4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6ED6 2428 
0050 6ED8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6EDA 04C5  14         clr   tmp1                  ; io.op.open
0052 6EDC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EDE 612E 
0053               file.open_init:
0054 6EE0 0220  22         ai    r0,9                  ; Move to file descriptor length
     6EE2 0009 
0055 6EE4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EE6 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6EE8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EEA 6DBA 
0061 6EEC 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6EEE 1029  14         jmp   file.record.pab.details
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
0090 6EF0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6EF2 C04B  18         mov   r11,r1                ; Save return address
0096 6EF4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6EF6 2428 
0097 6EF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6EFA 0205  20         li    tmp1,io.op.close      ; io.op.close
     6EFC 0001 
0099 6EFE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6F00 612E 
0100               file.close_init:
0101 6F02 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F04 0009 
0102 6F06 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F08 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6F0A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F0C 6DBA 
0108 6F0E 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6F10 1018  14         jmp   file.record.pab.details
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
0139 6F12 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6F14 C04B  18         mov   r11,r1                ; Save return address
0145 6F16 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6F18 2428 
0146 6F1A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6F1C 0205  20         li    tmp1,io.op.read       ; io.op.read
     6F1E 0002 
0148 6F20 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6F22 612E 
0149               file.record.read_init:
0150 6F24 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F26 0009 
0151 6F28 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F2A 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6F2C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F2E 6DBA 
0157 6F30 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6F32 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6F34 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6F36 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6F38 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6F3A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6F3C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6F3E 1000  14         nop
0191               
0192               
0193               file.status:
0194 6F40 1000  14         nop
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
0211 6F42 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6F44 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6F46 2428 
0219 6F48 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F4A 0005 
0220 6F4C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F4E 6146 
0221 6F50 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6F52 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6F54 0451  20         b     *r1                   ; Return to caller
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
0020 6F56 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F58 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F5A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F5C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F5E 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F60 6042 
0029 6F62 1602  14         jne   tmgr1a                ; No, so move on
0030 6F64 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F66 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F68 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F6A 6046 
0035 6F6C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F6E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F70 6036 
0048 6F72 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F74 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F76 6034 
0050 6F78 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F7A 0460  28         b     @kthread              ; Run kernel thread
     6F7C 6FF4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F7E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F80 603A 
0056 6F82 13EB  14         jeq   tmgr1
0057 6F84 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F86 6038 
0058 6F88 16E8  14         jne   tmgr1
0059 6F8A C120  34         mov   @wtiusr,tmp0
     6F8C 832E 
0060 6F8E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F90 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F92 6FF2 
0065 6F94 C10A  18         mov   r10,tmp0
0066 6F96 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F98 00FF 
0067 6F9A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F9C 6042 
0068 6F9E 1303  14         jeq   tmgr5
0069 6FA0 0284  22         ci    tmp0,60               ; 1 second reached ?
     6FA2 003C 
0070 6FA4 1002  14         jmp   tmgr6
0071 6FA6 0284  22 tmgr5   ci    tmp0,50
     6FA8 0032 
0072 6FAA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6FAC 1001  14         jmp   tmgr8
0074 6FAE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6FB0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6FB2 832C 
0079 6FB4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6FB6 FF00 
0080 6FB8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6FBA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6FBC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6FBE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6FC0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6FC2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6FC4 830C 
     6FC6 830D 
0089 6FC8 1608  14         jne   tmgr10                ; No, get next slot
0090 6FCA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6FCC FF00 
0091 6FCE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6FD0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6FD2 8330 
0096 6FD4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6FD6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6FD8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6FDA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6FDC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6FDE 8315 
     6FE0 8314 
0103 6FE2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FE4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FE6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FE8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FEA 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FEC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FEE FF00 
0109 6FF0 10B4  14         jmp   tmgr1
0110 6FF2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6FF4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FF6 6036 
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
0041 6FF8 06A0  32         bl    @realkb               ; Scan full keyboard
     6FFA 649C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FFC 0460  28         b     @tmgr3                ; Exit
     6FFE 6F7E 
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
0017 7000 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     7002 832E 
0018 7004 E0A0  34         soc   @wbit7,config         ; Enable user hook
     7006 6038 
0019 7008 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F5A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 700A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     700C 832E 
0029 700E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     7010 FEFF 
0030 7012 045B  20         b     *r11                  ; Return
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
0017 7014 C13B  30 mkslot  mov   *r11+,tmp0
0018 7016 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 7018 C184  18         mov   tmp0,tmp2
0023 701A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 701C A1A0  34         a     @wtitab,tmp2          ; Add table base
     701E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 7020 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 7022 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7024 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7026 881B  46         c     *r11,@w$ffff          ; End of list ?
     7028 6048 
0035 702A 1301  14         jeq   mkslo1                ; Yes, exit
0036 702C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 702E 05CB  14 mkslo1  inct  r11
0041 7030 045B  20         b     *r11                  ; Exit
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
0052 7032 C13B  30 clslot  mov   *r11+,tmp0
0053 7034 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7036 A120  34         a     @wtitab,tmp0          ; Add table base
     7038 832C 
0055 703A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 703C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 703E 045B  20         b     *r11                  ; Exit
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
0247 7040 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     7042 677E 
0248 7044 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7046 8302 
0252               *--------------------------------------------------------------
0253               * Alternative entry point
0254               *--------------------------------------------------------------
0255 7048 0300  24 runli1  limi  0                     ; Turn off interrupts
     704A 0000 
0256 704C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     704E 8300 
0257 7050 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7052 83C0 
0258               *--------------------------------------------------------------
0259               * Clear scratch-pad memory from R4 upwards
0260               *--------------------------------------------------------------
0261 7054 0202  20 runli2  li    r2,>8308
     7056 8308 
0262 7058 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0263 705A 0282  22         ci    r2,>8400
     705C 8400 
0264 705E 16FC  14         jne   runli3
0265               *--------------------------------------------------------------
0266               * Exit to TI-99/4A title screen ?
0267               *--------------------------------------------------------------
0268               runli3a
0269 7060 0281  22         ci    r1,>ffff              ; Exit flag set ?
     7062 FFFF 
0270 7064 1602  14         jne   runli4                ; No, continue
0271 7066 0420  54         blwp  @0                    ; Yes, bye bye
     7068 0000 
0272               *--------------------------------------------------------------
0273               * Determine if VDP is PAL or NTSC
0274               *--------------------------------------------------------------
0275 706A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     706C 833C 
0276 706E 04C1  14         clr   r1                    ; Reset counter
0277 7070 0202  20         li    r2,10                 ; We test 10 times
     7072 000A 
0278 7074 C0E0  34 runli5  mov   @vdps,r3
     7076 8802 
0279 7078 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     707A 6046 
0280 707C 1302  14         jeq   runli6
0281 707E 0581  14         inc   r1                    ; Increase counter
0282 7080 10F9  14         jmp   runli5
0283 7082 0602  14 runli6  dec   r2                    ; Next test
0284 7084 16F7  14         jne   runli5
0285 7086 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7088 1250 
0286 708A 1202  14         jle   runli7                ; No, so it must be NTSC
0287 708C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     708E 6042 
0288               *--------------------------------------------------------------
0289               * Copy machine code to scratchpad (prepare tight loop)
0290               *--------------------------------------------------------------
0291 7090 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     7092 60B6 
0292 7094 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     7096 8322 
0293 7098 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0294 709A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0295 709C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0296               *--------------------------------------------------------------
0297               * Initialize registers, memory, ...
0298               *--------------------------------------------------------------
0299 709E 04C1  14 runli9  clr   r1
0300 70A0 04C2  14         clr   r2
0301 70A2 04C3  14         clr   r3
0302 70A4 0209  20         li    stack,>8400           ; Set stack
     70A6 8400 
0303 70A8 020F  20         li    r15,vdpw              ; Set VDP write address
     70AA 8C00 
0307               *--------------------------------------------------------------
0308               * Setup video memory
0309               *--------------------------------------------------------------
0311 70AC 0280  22         ci    r0,>4a4a              ; Crash flag set?
     70AE 4A4A 
0312 70B0 1605  14         jne   runlia
0313 70B2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     70B4 60F0 
0314 70B6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     70B8 0000 
     70BA 3FFF 
0319 70BC 06A0  32 runlia  bl    @filv
     70BE 60F0 
0320 70C0 0FC0             data  pctadr,spfclr,16      ; Load color table
     70C2 00F4 
     70C4 0010 
0321               *--------------------------------------------------------------
0322               * Check if there is a F18A present
0323               *--------------------------------------------------------------
0327 70C6 06A0  32         bl    @f18unl               ; Unlock the F18A
     70C8 63E4 
0328 70CA 06A0  32         bl    @f18chk               ; Check if F18A is there
     70CC 63FE 
0329 70CE 06A0  32         bl    @f18lck               ; Lock the F18A again
     70D0 63F4 
0331               *--------------------------------------------------------------
0332               * Check if there is a speech synthesizer attached
0333               *--------------------------------------------------------------
0335               *       <<skipped>>
0339               *--------------------------------------------------------------
0340               * Load video mode table & font
0341               *--------------------------------------------------------------
0342 70D2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70D4 615A 
0343 70D6 60AC             data  spvmod                ; Equate selected video mode table
0344 70D8 0204  20         li    tmp0,spfont           ; Get font option
     70DA 000C 
0345 70DC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0346 70DE 1304  14         jeq   runlid                ; Yes, skip it
0347 70E0 06A0  32         bl    @ldfnt
     70E2 61C2 
0348 70E4 1100             data  fntadr,spfont         ; Load specified font
     70E6 000C 
0349               *--------------------------------------------------------------
0350               * Did a system crash occur before runlib was called?
0351               *--------------------------------------------------------------
0352 70E8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70EA 4A4A 
0353 70EC 1602  14         jne   runlie                ; No, continue
0354 70EE 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     70F0 605C 
0355               *--------------------------------------------------------------
0356               * Branch to main program
0357               *--------------------------------------------------------------
0358 70F2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70F4 0040 
0359 70F6 0460  28         b     @main                 ; Give control to main program
     70F8 70FA 
**** **** ****     > tivi.asm.6927
0212               
0213               *--------------------------------------------------------------
0214               * Video mode configuration
0215               *--------------------------------------------------------------
0216      60AC     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
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
0228 70FA 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     70FC 6044 
0229 70FE 1302  14         jeq   main.continue
0230 7100 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     7102 0000 
0231               
0232               main.continue:
0233 7104 06A0  32         bl    @scroff               ; Turn screen off
     7106 6340 
0234 7108 06A0  32         bl    @f18unl               ; Unlock the F18a
     710A 63E4 
0235 710C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     710E 6194 
0236 7110 3140                   data >3140            ; F18a VR49 (>31), bit 40
0237                       ;------------------------------------------------------
0238                       ; Initialize VDP SIT
0239                       ;------------------------------------------------------
0240 7112 06A0  32         bl    @filv
     7114 60F0 
0241 7116 0000                   data >0000,32,31*80   ; Clear VDP SIT
     7118 0020 
     711A 09B0 
0242 711C 06A0  32         bl    @scron                ; Turn screen on
     711E 6348 
0243                       ;------------------------------------------------------
0244                       ; Initialize low + high memory expansion
0245                       ;------------------------------------------------------
0246 7120 06A0  32         bl    @film
     7122 60CC 
0247 7124 2200                   data >2200,00,8*1024-256*2
     7126 0000 
     7128 3E00 
0248                                                   ; Clear part of 8k low-memory
0249               
0250 712A 06A0  32         bl    @film
     712C 60CC 
0251 712E A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     7130 0000 
     7132 6000 
0252                       ;------------------------------------------------------
0253                       ; Setup cursor, screen, etc.
0254                       ;------------------------------------------------------
0255 7134 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     7136 6360 
0256 7138 06A0  32         bl    @s8x8                 ; Small sprite
     713A 6370 
0257               
0258 713C 06A0  32         bl    @cpym2m
     713E 62E2 
0259 7140 7DE6                   data romsat,ramsat,4  ; Load sprite SAT
     7142 8380 
     7144 0004 
0260               
0261 7146 C820  54         mov   @romsat+2,@fb.curshape
     7148 7DE8 
     714A 2210 
0262                                                   ; Save cursor shape & color
0263               
0264 714C 06A0  32         bl    @cpym2v
     714E 629A 
0265 7150 1800                   data sprpdt,cursors,3*8
     7152 7DEA 
     7154 0018 
0266                                                   ; Load sprite cursor patterns
0267               *--------------------------------------------------------------
0268               * Initialize
0269               *--------------------------------------------------------------
0270 7156 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7158 7A8A 
0271 715A 06A0  32         bl    @idx.init             ; Initialize index
     715C 79C6 
0272 715E 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7160 78EA 
0273               
0274                       ;-------------------------------------------------------
0275                       ; Setup editor tasks & hook
0276                       ;-------------------------------------------------------
0277 7162 0204  20         li    tmp0,>0200
     7164 0200 
0278 7166 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     7168 8314 
0279               
0280 716A 06A0  32         bl    @at
     716C 6380 
0281 716E 0000             data  >0000                 ; Cursor YX position = >0000
0282               
0283 7170 0204  20         li    tmp0,timers
     7172 8370 
0284 7174 C804  38         mov   tmp0,@wtitab
     7176 832C 
0285               
0286 7178 06A0  32         bl    @mkslot
     717A 7014 
0287 717C 0001                   data >0001,task0      ; Task 0 - Update screen
     717E 7764 
0288 7180 0101                   data >0101,task1      ; Task 1 - Update cursor position
     7182 77E8 
0289 7184 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     7186 77F6 
     7188 FFFF 
0290               
0291 718A 06A0  32         bl    @mkhook
     718C 7000 
0292 718E 7194                   data editor           ; Setup user hook
0293               
0294 7190 0460  28         b     @tmgr                 ; Start timers and kthread
     7192 6F56 
0295               
0296               
0297               ****************************************************************
0298               * Editor - Main loop
0299               ****************************************************************
0300 7194 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7196 6030 
0301 7198 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0302               *---------------------------------------------------------------
0303               * Identical key pressed ?
0304               *---------------------------------------------------------------
0305 719A 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     719C 6030 
0306 719E 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     71A0 833C 
     71A2 833E 
0307 71A4 1308  14         jeq   ed_wait
0308               *--------------------------------------------------------------
0309               * New key pressed
0310               *--------------------------------------------------------------
0311               ed_new_key
0312 71A6 C820  54         mov   @waux1,@waux2         ; Save as previous key
     71A8 833C 
     71AA 833E 
0313 71AC 1045  14         jmp   edkey                 ; Process key
0314               *--------------------------------------------------------------
0315               * Clear keyboard buffer if no key pressed
0316               *--------------------------------------------------------------
0317               ed_clear_kbbuffer
0318 71AE 04E0  34         clr   @waux1
     71B0 833C 
0319 71B2 04E0  34         clr   @waux2
     71B4 833E 
0320               *--------------------------------------------------------------
0321               * Delay to avoid key bouncing
0322               *--------------------------------------------------------------
0323               ed_wait
0324 71B6 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     71B8 0708 
0325                       ;------------------------------------------------------
0326                       ; Delay loop
0327                       ;------------------------------------------------------
0328               ed_wait_loop
0329 71BA 0604  14         dec   tmp0
0330 71BC 16FE  14         jne   ed_wait_loop
0331               *--------------------------------------------------------------
0332               * Exit
0333               *--------------------------------------------------------------
0334 71BE 0460  28 ed_exit b     @hookok               ; Return
     71C0 6F5A 
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
0055 71C2 0D00             data  key_enter,edkey.action.enter          ; New line
     71C4 7626 
0056 71C6 0800             data  key_left,edkey.action.left            ; Move cursor left
     71C8 725A 
0057 71CA 0900             data  key_right,edkey.action.right          ; Move cursor right
     71CC 7270 
0058 71CE 0B00             data  key_up,edkey.action.up                ; Move cursor up
     71D0 7288 
0059 71D2 0A00             data  key_down,edkey.action.down            ; Move cursor down
     71D4 72DA 
0060 71D6 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     71D8 7346 
0061 71DA 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     71DC 735E 
0062 71DE 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     71E0 7372 
0063 71E2 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     71E4 73C4 
0064 71E6 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     71E8 7424 
0065 71EA 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     71EC 746E 
0066 71EE 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     71F0 749A 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 71F2 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     71F4 74C8 
0071 71F6 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     71F8 7500 
0072 71FA 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     71FC 7534 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 71FE 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     7200 758C 
0077 7202 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     7204 7694 
0078 7206 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     7208 75E2 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 720A 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     720C 76E4 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 720E B000             data  key_buf0,edkey.action.buffer0
     7210 7728 
0087 7212 B100             data  key_buf1,edkey.action.buffer1
     7214 772E 
0088 7216 B200             data  key_buf2,edkey.action.buffer2
     7218 7734 
0089 721A B300             data  key_buf3,edkey.action.buffer3
     721C 773A 
0090 721E B400             data  key_buf4,edkey.action.buffer4
     7220 7740 
0091 7222 B500             data  key_buf5,edkey.action.buffer5
     7224 7746 
0092 7226 B600             data  key_buf6,edkey.action.buffer6
     7228 774C 
0093 722A B700             data  key_buf7,edkey.action.buffer7
     722C 7752 
0094 722E 9E00             data  key_buf8,edkey.action.buffer8
     7230 7758 
0095 7232 9F00             data  key_buf9,edkey.action.buffer9
     7234 775E 
0096 7236 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 7238 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     723A 833C 
0104 723C 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     723E FF00 
0105               
0106 7240 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     7242 71C2 
0107 7244 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 7246 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 7248 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 724A 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 724C 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 724E 05C6  14         inct  tmp2                  ; No, skip action
0118 7250 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 7252 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 7254 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 7256 0460  28         b    @edkey.action.char     ; Add character to buffer
     7258 76A4 
**** **** ****     > tivi.asm.6927
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
0009 725A C120  34         mov   @fb.column,tmp0
     725C 220C 
0010 725E 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 7260 0620  34         dec   @fb.column            ; Column-- in screen buffer
     7262 220C 
0015 7264 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7266 832A 
0016 7268 0620  34         dec   @fb.current
     726A 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 726C 0460  28 !       b     @ed_wait              ; Back to editor main
     726E 71B6 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 7270 8820  54         c     @fb.column,@fb.row.length
     7272 220C 
     7274 2208 
0028 7276 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 7278 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     727A 220C 
0033 727C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     727E 832A 
0034 7280 05A0  34         inc   @fb.current
     7282 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 7284 0460  28 !       b     @ed_wait              ; Back to editor main
     7286 71B6 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 7288 8820  54         c     @fb.row.dirty,@w$ffff
     728A 220A 
     728C 6048 
0049 728E 1604  14         jne   edkey.action.up.cursor
0050 7290 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7292 7AA6 
0051 7294 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7296 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 7298 C120  34         mov   @fb.row,tmp0
     729A 2206 
0057 729C 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 729E C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     72A0 2204 
0060 72A2 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 72A4 0604  14         dec   tmp0                  ; fb.topline--
0066 72A6 C804  38         mov   tmp0,@parm1
     72A8 8350 
0067 72AA 06A0  32         bl    @fb.refresh           ; Scroll one line up
     72AC 7954 
0068 72AE 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 72B0 0620  34         dec   @fb.row               ; Row-- in screen buffer
     72B2 2206 
0074 72B4 06A0  32         bl    @up                   ; Row-- VDP cursor
     72B6 638E 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 72B8 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     72BA 7BC0 
0080 72BC 8820  54         c     @fb.column,@fb.row.length
     72BE 220C 
     72C0 2208 
0081 72C2 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 72C4 C820  54         mov   @fb.row.length,@fb.column
     72C6 2208 
     72C8 220C 
0086 72CA C120  34         mov   @fb.column,tmp0
     72CC 220C 
0087 72CE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     72D0 6398 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 72D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72D4 7938 
0093 72D6 0460  28         b     @ed_wait              ; Back to editor main
     72D8 71B6 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 72DA 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     72DC 2206 
     72DE 2304 
0102 72E0 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 72E2 8820  54         c     @fb.row.dirty,@w$ffff
     72E4 220A 
     72E6 6048 
0107 72E8 1604  14         jne   edkey.action.down.move
0108 72EA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72EC 7AA6 
0109 72EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72F0 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 72F2 C120  34         mov   @fb.topline,tmp0
     72F4 2204 
0118 72F6 A120  34         a     @fb.row,tmp0
     72F8 2206 
0119 72FA 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     72FC 2304 
0120 72FE 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 7300 C120  34         mov   @fb.screenrows,tmp0
     7302 2218 
0126 7304 0604  14         dec   tmp0
0127 7306 8120  34         c     @fb.row,tmp0
     7308 2206 
0128 730A 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 730C C820  54         mov   @fb.topline,@parm1
     730E 2204 
     7310 8350 
0133 7312 05A0  34         inc   @parm1
     7314 8350 
0134 7316 06A0  32         bl    @fb.refresh
     7318 7954 
0135 731A 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 731C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     731E 2206 
0141 7320 06A0  32         bl    @down                 ; Row++ VDP cursor
     7322 6386 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 7324 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7326 7BC0 
0147 7328 8820  54         c     @fb.column,@fb.row.length
     732A 220C 
     732C 2208 
0148 732E 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 7330 C820  54         mov   @fb.row.length,@fb.column
     7332 2208 
     7334 220C 
0153 7336 C120  34         mov   @fb.column,tmp0
     7338 220C 
0154 733A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     733C 6398 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 733E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7340 7938 
0160 7342 0460  28 !       b     @ed_wait              ; Back to editor main
     7344 71B6 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 7346 C120  34         mov   @wyx,tmp0
     7348 832A 
0169 734A 0244  22         andi  tmp0,>ff00
     734C FF00 
0170 734E C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     7350 832A 
0171 7352 04E0  34         clr   @fb.column
     7354 220C 
0172 7356 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7358 7938 
0173 735A 0460  28         b     @ed_wait              ; Back to editor main
     735C 71B6 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 735E C120  34         mov   @fb.row.length,tmp0
     7360 2208 
0180 7362 C804  38         mov   tmp0,@fb.column
     7364 220C 
0181 7366 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7368 6398 
0182 736A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     736C 7938 
0183 736E 0460  28         b     @ed_wait              ; Back to editor main
     7370 71B6 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 7372 C120  34         mov   @fb.column,tmp0
     7374 220C 
0192 7376 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 7378 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     737A 2202 
0197 737C 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 737E 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 7380 0605  14         dec   tmp1
0204 7382 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 7384 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 7386 D195  26         movb  *tmp1,tmp2            ; Get character
0212 7388 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 738A D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 738C 0986  56         srl   tmp2,8                ; Right justify
0215 738E 0286  22         ci    tmp2,32               ; Space character found?
     7390 0020 
0216 7392 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 7394 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7396 2020 
0222 7398 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 739A 0287  22         ci    tmp3,>20ff            ; First character is space
     739C 20FF 
0225 739E 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 73A0 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     73A2 220C 
0230 73A4 61C4  18         s     tmp0,tmp3
0231 73A6 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     73A8 0002 
0232 73AA 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 73AC 0585  14         inc   tmp1
0238 73AE 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 73B0 C805  38         mov   tmp1,@fb.current
     73B2 2202 
0244 73B4 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     73B6 220C 
0245 73B8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     73BA 6398 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 73BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73BE 7938 
0251 73C0 0460  28 !       b     @ed_wait              ; Back to editor main
     73C2 71B6 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 73C4 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 73C6 C120  34         mov   @fb.column,tmp0
     73C8 220C 
0261 73CA 8804  38         c     tmp0,@fb.row.length
     73CC 2208 
0262 73CE 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 73D0 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     73D2 2202 
0267 73D4 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 73D6 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 73D8 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 73DA 0585  14         inc   tmp1
0279 73DC 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 73DE 8804  38         c     tmp0,@fb.row.length
     73E0 2208 
0281 73E2 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 73E4 D195  26         movb  *tmp1,tmp2            ; Get character
0288 73E6 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 73E8 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 73EA 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 73EC 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     73EE FFFF 
0293 73F0 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 73F2 0286  22         ci    tmp2,32
     73F4 0020 
0299 73F6 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 73F8 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 73FA 0286  22         ci    tmp2,32               ; Space character found?
     73FC 0020 
0307 73FE 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 7400 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7402 2020 
0313 7404 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 7406 0287  22         ci    tmp3,>20ff            ; First characer is space?
     7408 20FF 
0316 740A 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 740C 0585  14         inc   tmp1
0321 740E 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 7410 C805  38         mov   tmp1,@fb.current
     7412 2202 
0327 7414 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7416 220C 
0328 7418 06A0  32         bl    @xsetx                ; Set VDP cursor X
     741A 6398 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 741C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     741E 7938 
0334 7420 0460  28 !       b     @ed_wait              ; Back to editor main
     7422 71B6 
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
0346 7424 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     7426 2204 
0347 7428 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 742A 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     742C 2218 
0352 742E 1503  14         jgt   edkey.action.ppage.topline
0353 7430 04E0  34         clr   @fb.topline           ; topline = 0
     7432 2204 
0354 7434 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 7436 6820  54         s     @fb.screenrows,@fb.topline
     7438 2218 
     743A 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 743C 8820  54         c     @fb.row.dirty,@w$ffff
     743E 220A 
     7440 6048 
0365 7442 1604  14         jne   edkey.action.ppage.refresh
0366 7444 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7446 7AA6 
0367 7448 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     744A 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 744C C820  54         mov   @fb.topline,@parm1
     744E 2204 
     7450 8350 
0373 7452 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7454 7954 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 7456 04E0  34         clr   @fb.row
     7458 2206 
0379 745A 05A0  34         inc   @fb.row               ; Set fb.row=1
     745C 2206 
0380 745E 04E0  34         clr   @fb.column
     7460 220C 
0381 7462 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7464 0100 
0382 7466 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7468 832A 
0383 746A 0460  28         b     @edkey.action.up      ; Do rest of logic
     746C 7288 
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
0394 746E C120  34         mov   @fb.topline,tmp0
     7470 2204 
0395 7472 A120  34         a     @fb.screenrows,tmp0
     7474 2218 
0396 7476 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7478 2304 
0397 747A 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 747C A820  54         a     @fb.screenrows,@fb.topline
     747E 2218 
     7480 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 7482 8820  54         c     @fb.row.dirty,@w$ffff
     7484 220A 
     7486 6048 
0408 7488 1604  14         jne   edkey.action.npage.refresh
0409 748A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     748C 7AA6 
0410 748E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7490 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 7492 0460  28         b     @edkey.action.ppage.refresh
     7494 744C 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 7496 0460  28         b     @ed_wait              ; Back to editor main
     7498 71B6 
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
0433 749A 8820  54         c     @fb.row.dirty,@w$ffff
     749C 220A 
     749E 6048 
0434 74A0 1604  14         jne   edkey.action.top.refresh
0435 74A2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     74A4 7AA6 
0436 74A6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     74A8 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 74AA 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     74AC 2204 
0442 74AE 04E0  34         clr   @parm1
     74B0 8350 
0443 74B2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     74B4 7954 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 74B6 04E0  34         clr   @fb.row               ; Editor line 0
     74B8 2206 
0449 74BA 04E0  34         clr   @fb.column            ; Editor column 0
     74BC 220C 
0450 74BE 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 74C0 C804  38         mov   tmp0,@wyx             ;
     74C2 832A 
0452 74C4 0460  28         b     @ed_wait              ; Back to editor main
     74C6 71B6 
**** **** ****     > tivi.asm.6927
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
0009 74C8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     74CA 2306 
0010 74CC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74CE 7938 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 74D0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     74D2 2202 
0015 74D4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     74D6 2208 
0016 74D8 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 74DA 8820  54         c     @fb.column,@fb.row.length
     74DC 220C 
     74DE 2208 
0022 74E0 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 74E2 C120  34         mov   @fb.current,tmp0      ; Get pointer
     74E4 2202 
0028 74E6 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 74E8 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 74EA DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 74EC 0606  14         dec   tmp2
0036 74EE 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 74F0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     74F2 220A 
0041 74F4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     74F6 2216 
0042 74F8 0620  34         dec   @fb.row.length        ; @fb.row.length--
     74FA 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 74FC 0460  28         b     @ed_wait              ; Back to editor main
     74FE 71B6 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 7500 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7502 2306 
0055 7504 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7506 7938 
0056 7508 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     750A 2208 
0057 750C 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 750E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7510 2202 
0063 7512 C1A0  34         mov   @fb.colsline,tmp2
     7514 220E 
0064 7516 61A0  34         s     @fb.column,tmp2
     7518 220C 
0065 751A 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 751C DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 751E 0606  14         dec   tmp2
0072 7520 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 7522 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7524 220A 
0077 7526 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7528 2216 
0078               
0079 752A C820  54         mov   @fb.column,@fb.row.length
     752C 220C 
     752E 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 7530 0460  28         b     @ed_wait              ; Back to editor main
     7532 71B6 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7534 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7536 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 7538 C120  34         mov   @edb.lines,tmp0
     753A 2304 
0097 753C 1604  14         jne   !
0098 753E 04E0  34         clr   @fb.column            ; Column 0
     7540 220C 
0099 7542 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7544 7500 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 7546 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7548 7938 
0104 754A 04E0  34         clr   @fb.row.dirty         ; Discard current line
     754C 220A 
0105 754E C820  54         mov   @fb.topline,@parm1
     7550 2204 
     7552 8350 
0106 7554 A820  54         a     @fb.row,@parm1        ; Line number to remove
     7556 2206 
     7558 8350 
0107 755A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     755C 2304 
     755E 8352 
0108 7560 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7562 79FE 
0109 7564 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7566 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7568 C820  54         mov   @fb.topline,@parm1
     756A 2204 
     756C 8350 
0114 756E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7570 7954 
0115 7572 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7574 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 7576 C120  34         mov   @fb.topline,tmp0
     7578 2204 
0120 757A A120  34         a     @fb.row,tmp0
     757C 2206 
0121 757E 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7580 2304 
0122 7582 1202  14         jle   edkey.action.del_line.exit
0123 7584 0460  28         b     @edkey.action.up      ; One line up
     7586 7288 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 7588 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     758A 7346 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 758C 0204  20         li    tmp0,>2000            ; White space
     758E 2000 
0139 7590 C804  38         mov   tmp0,@parm1
     7592 8350 
0140               edkey.action.ins_char:
0141 7594 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7596 2306 
0142 7598 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     759A 7938 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 759C C120  34         mov   @fb.current,tmp0      ; Get pointer
     759E 2202 
0147 75A0 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     75A2 2208 
0148 75A4 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 75A6 8820  54         c     @fb.column,@fb.row.length
     75A8 220C 
     75AA 2208 
0154 75AC 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 75AE C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 75B0 61E0  34         s     @fb.column,tmp3
     75B2 220C 
0162 75B4 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 75B6 C144  18         mov   tmp0,tmp1
0164 75B8 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 75BA 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     75BC 220C 
0166 75BE 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 75C0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 75C2 0604  14         dec   tmp0
0173 75C4 0605  14         dec   tmp1
0174 75C6 0606  14         dec   tmp2
0175 75C8 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 75CA D560  46         movb  @parm1,*tmp1
     75CC 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 75CE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     75D0 220A 
0184 75D2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     75D4 2216 
0185 75D6 05A0  34         inc   @fb.row.length        ; @fb.row.length
     75D8 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 75DA 0460  28         b     @edkey.action.char.overwrite
     75DC 76B6 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 75DE 0460  28         b     @ed_wait              ; Back to editor main
     75E0 71B6 
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
0206 75E2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     75E4 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 75E6 8820  54         c     @fb.row.dirty,@w$ffff
     75E8 220A 
     75EA 6048 
0211 75EC 1604  14         jne   edkey.action.ins_line.insert
0212 75EE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     75F0 7AA6 
0213 75F2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     75F4 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 75F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     75F8 7938 
0219 75FA C820  54         mov   @fb.topline,@parm1
     75FC 2204 
     75FE 8350 
0220 7600 A820  54         a     @fb.row,@parm1        ; Line number to insert
     7602 2206 
     7604 8350 
0221               
0222 7606 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7608 2304 
     760A 8352 
0223 760C 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     760E 7A28 
0224 7610 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     7612 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 7614 C820  54         mov   @fb.topline,@parm1
     7616 2204 
     7618 8350 
0229 761A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     761C 7954 
0230 761E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7620 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 7622 0460  28         b     @ed_wait              ; Back to editor main
     7624 71B6 
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
0249 7626 8820  54         c     @fb.row.dirty,@w$ffff
     7628 220A 
     762A 6048 
0250 762C 1606  14         jne   edkey.action.enter.upd_counter
0251 762E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7630 2306 
0252 7632 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7634 7AA6 
0253 7636 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7638 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 763A C120  34         mov   @fb.topline,tmp0
     763C 2204 
0259 763E A120  34         a     @fb.row,tmp0
     7640 2206 
0260 7642 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7644 2304 
0261 7646 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 7648 05A0  34         inc   @edb.lines            ; Total lines++
     764A 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 764C C120  34         mov   @fb.screenrows,tmp0
     764E 2218 
0271 7650 0604  14         dec   tmp0
0272 7652 8120  34         c     @fb.row,tmp0
     7654 2206 
0273 7656 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 7658 C120  34         mov   @fb.screenrows,tmp0
     765A 2218 
0278 765C C820  54         mov   @fb.topline,@parm1
     765E 2204 
     7660 8350 
0279 7662 05A0  34         inc   @parm1
     7664 8350 
0280 7666 06A0  32         bl    @fb.refresh
     7668 7954 
0281 766A 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 766C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     766E 2206 
0287 7670 06A0  32         bl    @down                 ; Row++ VDP cursor
     7672 6386 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 7674 06A0  32         bl    @fb.get.firstnonblank
     7676 797E 
0293 7678 C120  34         mov   @outparm1,tmp0
     767A 8360 
0294 767C C804  38         mov   tmp0,@fb.column
     767E 220C 
0295 7680 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     7682 6398 
0296 7684 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7686 7BC0 
0297 7688 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     768A 7938 
0298 768C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     768E 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 7690 0460  28         b     @ed_wait              ; Back to editor main
     7692 71B6 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 7694 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7696 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7698 0204  20         li    tmp0,2000
     769A 07D0 
0317               edkey.action.ins_onoff.loop:
0318 769C 0604  14         dec   tmp0
0319 769E 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 76A0 0460  28         b     @task2.cur_visible    ; Update cursor shape
     76A2 7802 
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
0335 76A4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     76A6 2306 
0336 76A8 D805  38         movb  tmp1,@parm1           ; Store character for insert
     76AA 8350 
0337 76AC C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     76AE 230C 
0338 76B0 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 76B2 0460  28         b     @edkey.action.ins_char
     76B4 7594 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 76B6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     76B8 7938 
0349 76BA C120  34         mov   @fb.current,tmp0      ; Get pointer
     76BC 2202 
0350               
0351 76BE D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     76C0 8350 
0352 76C2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     76C4 220A 
0353 76C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     76C8 2216 
0354               
0355 76CA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     76CC 220C 
0356 76CE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     76D0 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 76D2 8820  54         c     @fb.column,@fb.row.length
     76D4 220C 
     76D6 2208 
0361 76D8 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 76DA C820  54         mov   @fb.column,@fb.row.length
     76DC 220C 
     76DE 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 76E0 0460  28         b     @ed_wait              ; Back to editor main
     76E2 71B6 
**** **** ****     > tivi.asm.6927
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
0009 76E4 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     76E6 6448 
0010 76E8 0420  54         blwp  @0                    ; Exit
     76EA 0000 
0011               
**** **** ****     > tivi.asm.6927
0348                       copy  "editorkeys_file.asm" ; Actions for file related keys
**** **** ****     > editorkeys_file.asm
0001               * FILE......: editorkeys_fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load DV/80 text file into editor
0007               *---------------------------------------------------------------
0008               * Input
0009               * tmp0  = Pointer to length-prefixed string containing device
0010               *         and filename
0011               * parm1 = >FFFF for RLE compression on load, otherwise >0000
0012               *---------------------------------------------------------------
0013               edkey.action.loadfile:
0014 76EC C804  38         mov   tmp0,@parm1           ; Setup file to load
     76EE 8350 
0015 76F0 04E0  34         clr   @parm2                ; NO RLE COMPRESSION
     76F2 8352 
0016               
0017 76F4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     76F6 7A8A 
0018 76F8 06A0  32         bl    @idx.init             ; Initialize index
     76FA 79C6 
0019 76FC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     76FE 78EA 
0020                       ;-------------------------------------------------------
0021                       ; Clear VDP screen buffer
0022                       ;-------------------------------------------------------
0023 7700 06A0  32         bl    @filv
     7702 60F0 
0024 7704 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7706 0000 
     7708 0004 
0025               
0026 770A C160  34         mov   @fb.screenrows,tmp1
     770C 2218 
0027 770E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7710 220E 
0028                                                   ; 16 bit part is in tmp2!
0029               
0030 7712 04C4  14         clr   tmp0                  ; VDP target address
0031 7714 0205  20         li    tmp1,32               ; Character to fill
     7716 0020 
0032 7718 06A0  32         bl    @xfilv                ; Fill VDP
     771A 60F6 
0033                                                   ; tmp0 = VDP target address
0034                                                   ; tmp1 = Byte to fill
0035                                                   ; tmp2 = Bytes to copy
0036                       ;-------------------------------------------------------
0037                       ; Read DV80 file and display
0038                       ;-------------------------------------------------------
0039 771C 06A0  32         bl    @tfh.file.read        ; Read specified file
     771E 7BE4 
0040               
0041 7720 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     7722 2306 
0042 7724 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     7726 749A 
0043               
0044               
0045               
0046               edkey.action.buffer0:
0047 7728 0204  20         li   tmp0,fdname0
     772A 7E36 
0048 772C 10DF  14         jmp  edkey.action.loadfile
0049                                                   ; Load DIS/VAR 80 file into editor buffer
0050               edkey.action.buffer1:
0051 772E 0204  20         li   tmp0,fdname1
     7730 7E44 
0052 7732 10DC  14         jmp  edkey.action.loadfile
0053                                                   ; Load DIS/VAR 80 file into editor buffer
0054               
0055               edkey.action.buffer2:
0056 7734 0204  20         li   tmp0,fdname2
     7736 7E54 
0057 7738 10D9  14         jmp  edkey.action.loadfile
0058                                                   ; Load DIS/VAR 80 file into editor buffer
0059               
0060               edkey.action.buffer3:
0061 773A 0204  20         li   tmp0,fdname3
     773C 7E62 
0062 773E 10D6  14         jmp  edkey.action.loadfile
0063                                                   ; Load DIS/VAR 80 file into editor buffer
0064               
0065               edkey.action.buffer4:
0066 7740 0204  20         li   tmp0,fdname4
     7742 7E70 
0067 7744 10D3  14         jmp  edkey.action.loadfile
0068                                                   ; Load DIS/VAR 80 file into editor buffer
0069               
0070               edkey.action.buffer5:
0071 7746 0204  20         li   tmp0,fdname5
     7748 7E7E 
0072 774A 10D0  14         jmp  edkey.action.loadfile
0073                                                   ; Load DIS/VAR 80 file into editor buffer
0074               
0075               edkey.action.buffer6:
0076 774C 0204  20         li   tmp0,fdname6
     774E 7E8C 
0077 7750 10CD  14         jmp  edkey.action.loadfile
0078                                                   ; Load DIS/VAR 80 file into editor buffer
0079               
0080               edkey.action.buffer7:
0081 7752 0204  20         li   tmp0,fdname7
     7754 7E9A 
0082 7756 10CA  14         jmp  edkey.action.loadfile
0083                                                   ; Load DIS/VAR 80 file into editor buffer
0084               
0085               edkey.action.buffer8:
0086 7758 0204  20         li   tmp0,fdname8
     775A 7EA8 
0087 775C 10C7  14         jmp  edkey.action.loadfile
0088                                                   ; Load DIS/VAR 80 file into editor buffer
0089               
0090               edkey.action.buffer9:
0091 775E 0204  20         li   tmp0,fdname9
     7760 7EB6 
0092 7762 10C4  14         jmp  edkey.action.loadfile
0093                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.6927
0349               
0350               
0351               
0352               ***************************************************************
0353               * Task 0 - Copy frame buffer to VDP
0354               ***************************************************************
0355 7764 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7766 2216 
0356 7768 133D  14         jeq   task0.$$              ; No, skip update
0357                       ;------------------------------------------------------
0358                       ; Determine how many rows to copy
0359                       ;------------------------------------------------------
0360 776A 8820  54         c     @edb.lines,@fb.screenrows
     776C 2304 
     776E 2218 
0361 7770 1103  14         jlt   task0.setrows.small
0362 7772 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7774 2218 
0363 7776 1003  14         jmp   task0.copy.framebuffer
0364                       ;------------------------------------------------------
0365                       ; Less lines in editor buffer as rows in frame buffer
0366                       ;------------------------------------------------------
0367               task0.setrows.small:
0368 7778 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     777A 2304 
0369 777C 0585  14         inc   tmp1
0370                       ;------------------------------------------------------
0371                       ; Determine area to copy
0372                       ;------------------------------------------------------
0373               task0.copy.framebuffer:
0374 777E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7780 220E 
0375                                                   ; 16 bit part is in tmp2!
0376 7782 04C4  14         clr   tmp0                  ; VDP target address
0377 7784 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7786 2200 
0378                       ;------------------------------------------------------
0379                       ; Copy memory block
0380                       ;------------------------------------------------------
0381 7788 06A0  32         bl    @xpym2v               ; Copy to VDP
     778A 62A0 
0382                                                   ; tmp0 = VDP target address
0383                                                   ; tmp1 = RAM source address
0384                                                   ; tmp2 = Bytes to copy
0385 778C 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     778E 2216 
0386                       ;-------------------------------------------------------
0387                       ; Draw EOF marker at end-of-file
0388                       ;-------------------------------------------------------
0389 7790 C120  34         mov   @edb.lines,tmp0
     7792 2304 
0390 7794 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7796 2204 
0391 7798 0584  14         inc   tmp0                  ; Y++
0392 779A 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     779C 2218 
0393 779E 1222  14         jle   task0.$$
0394                       ;-------------------------------------------------------
0395                       ; Draw EOF marker
0396                       ;-------------------------------------------------------
0397               task0.draw_marker:
0398 77A0 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     77A2 832A 
     77A4 2214 
0399 77A6 0A84  56         sla   tmp0,8                ; X=0
0400 77A8 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     77AA 832A 
0401 77AC 06A0  32         bl    @putstr
     77AE 6280 
0402 77B0 7E04                   data txt_marker       ; Display *EOF*
0403                       ;-------------------------------------------------------
0404                       ; Draw empty line after (and below) EOF marker
0405                       ;-------------------------------------------------------
0406 77B2 06A0  32         bl    @setx
     77B4 6396 
0407 77B6 0005                   data  5               ; Cursor after *EOF* string
0408               
0409 77B8 C120  34         mov   @wyx,tmp0
     77BA 832A 
0410 77BC 0984  56         srl   tmp0,8                ; Right justify
0411 77BE 0584  14         inc   tmp0                  ; One time adjust
0412 77C0 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     77C2 2218 
0413 77C4 1303  14         jeq   !
0414 77C6 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     77C8 009B 
0415 77CA 1002  14         jmp   task0.draw_marker.line
0416 77CC 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     77CE 004B 
0417                       ;-------------------------------------------------------
0418                       ; Draw empty line
0419                       ;-------------------------------------------------------
0420               task0.draw_marker.line:
0421 77D0 0604  14         dec   tmp0                  ; One time adjust
0422 77D2 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     77D4 625C 
0423 77D6 0205  20         li    tmp1,32               ; Character to write (whitespace)
     77D8 0020 
0424 77DA 06A0  32         bl    @xfilv                ; Write characters
     77DC 60F6 
0425 77DE C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     77E0 2214 
     77E2 832A 
0426               *--------------------------------------------------------------
0427               * Task 0 - Exit
0428               *--------------------------------------------------------------
0429               task0.$$:
0430 77E4 0460  28         b     @slotok
     77E6 6FD6 
0431               
0432               
0433               
0434               ***************************************************************
0435               * Task 1 - Copy SAT to VDP
0436               ***************************************************************
0437 77E8 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     77EA 6046 
0438 77EC 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     77EE 63A2 
0439 77F0 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     77F2 8380 
0440 77F4 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0441               
0442               
0443               ***************************************************************
0444               * Task 2 - Update cursor shape (blink)
0445               ***************************************************************
0446 77F6 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     77F8 2212 
0447 77FA 1303  14         jeq   task2.cur_visible
0448 77FC 04E0  34         clr   @ramsat+2              ; Hide cursor
     77FE 8382 
0449 7800 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0450               
0451               task2.cur_visible:
0452 7802 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7804 230C 
0453 7806 1303  14         jeq   task2.cur_visible.overwrite_mode
0454                       ;------------------------------------------------------
0455                       ; Cursor in insert mode
0456                       ;------------------------------------------------------
0457               task2.cur_visible.insert_mode:
0458 7808 0204  20         li    tmp0,>000f
     780A 000F 
0459 780C 1002  14         jmp   task2.cur_visible.cursorshape
0460                       ;------------------------------------------------------
0461                       ; Cursor in overwrite mode
0462                       ;------------------------------------------------------
0463               task2.cur_visible.overwrite_mode:
0464 780E 0204  20         li    tmp0,>020f
     7810 020F 
0465                       ;------------------------------------------------------
0466                       ; Set cursor shape
0467                       ;------------------------------------------------------
0468               task2.cur_visible.cursorshape:
0469 7812 C804  38         mov   tmp0,@fb.curshape
     7814 2210 
0470 7816 C804  38         mov   tmp0,@ramsat+2
     7818 8382 
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
0482 781A 06A0  32         bl    @cpym2v
     781C 629A 
0483 781E 2000                   data sprsat,ramsat,4   ; Update sprite
     7820 8380 
     7822 0004 
0484               
0485 7824 C820  54         mov   @wyx,@fb.yxsave
     7826 832A 
     7828 2214 
0486                       ;------------------------------------------------------
0487                       ; Show text editing mode
0488                       ;------------------------------------------------------
0489               task.botline.show_mode
0490 782A C120  34         mov   @edb.insmode,tmp0
     782C 230C 
0491 782E 1605  14         jne   task.botline.show_mode.insert
0492                       ;------------------------------------------------------
0493                       ; Overwrite mode
0494                       ;------------------------------------------------------
0495               task.botline.show_mode.overwrite:
0496 7830 06A0  32         bl    @putat
     7832 6292 
0497 7834 1D32                   byte  29,50
0498 7836 7E10                   data  txt_ovrwrite
0499 7838 1004  14         jmp   task.botline.show_changed
0500                       ;------------------------------------------------------
0501                       ; Insert  mode
0502                       ;------------------------------------------------------
0503               task.botline.show_mode.insert:
0504 783A 06A0  32         bl    @putat
     783C 6292 
0505 783E 1D32                   byte  29,50
0506 7840 7E14                   data  txt_insert
0507                       ;------------------------------------------------------
0508                       ; Show if text was changed in editor buffer
0509                       ;------------------------------------------------------
0510               task.botline.show_changed:
0511 7842 C120  34         mov   @edb.dirty,tmp0
     7844 2306 
0512 7846 1305  14         jeq   task.botline.show_changed.clear
0513                       ;------------------------------------------------------
0514                       ; Show "*"
0515                       ;------------------------------------------------------
0516 7848 06A0  32         bl    @putat
     784A 6292 
0517 784C 1D36                   byte 29,54
0518 784E 7E18                   data txt_star
0519 7850 1001  14         jmp   task.botline.show_linecol
0520                       ;------------------------------------------------------
0521                       ; Show "line,column"
0522                       ;------------------------------------------------------
0523               task.botline.show_changed.clear:
0524 7852 1000  14         nop
0525               task.botline.show_linecol:
0526 7854 C820  54         mov   @fb.row,@parm1
     7856 2206 
     7858 8350 
0527 785A 06A0  32         bl    @fb.row2line
     785C 7924 
0528 785E 05A0  34         inc   @outparm1
     7860 8360 
0529                       ;------------------------------------------------------
0530                       ; Show line
0531                       ;------------------------------------------------------
0532 7862 06A0  32         bl    @putnum
     7864 6672 
0533 7866 1D40                   byte  29,64            ; YX
0534 7868 8360                   data  outparm1,rambuf
     786A 8390 
0535 786C 3020                   byte  48               ; ASCII offset
0536                             byte  32               ; Padding character
0537                       ;------------------------------------------------------
0538                       ; Show comma
0539                       ;------------------------------------------------------
0540 786E 06A0  32         bl    @putat
     7870 6292 
0541 7872 1D45                   byte  29,69
0542 7874 7E02                   data  txt_delim
0543                       ;------------------------------------------------------
0544                       ; Show column
0545                       ;------------------------------------------------------
0546 7876 06A0  32         bl    @film
     7878 60CC 
0547 787A 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     787C 0020 
     787E 000C 
0548               
0549 7880 C820  54         mov   @fb.column,@waux1
     7882 220C 
     7884 833C 
0550 7886 05A0  34         inc   @waux1                 ; Offset 1
     7888 833C 
0551               
0552 788A 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     788C 65F4 
0553 788E 833C                   data  waux1,rambuf
     7890 8390 
0554 7892 3020                   byte  48               ; ASCII offset
0555                             byte  32               ; Fill character
0556               
0557 7894 06A0  32         bl    @trimnum               ; Trim number to the left
     7896 664C 
0558 7898 8390                   data  rambuf,rambuf+6,32
     789A 8396 
     789C 0020 
0559               
0560 789E 0204  20         li    tmp0,>0200
     78A0 0200 
0561 78A2 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     78A4 8396 
0562               
0563 78A6 06A0  32         bl    @putat
     78A8 6292 
0564 78AA 1D46                   byte 29,70
0565 78AC 8396                   data rambuf+6          ; Show column
0566                       ;------------------------------------------------------
0567                       ; Show lines in buffer unless on last line in file
0568                       ;------------------------------------------------------
0569 78AE C820  54         mov   @fb.row,@parm1
     78B0 2206 
     78B2 8350 
0570 78B4 06A0  32         bl    @fb.row2line
     78B6 7924 
0571 78B8 8820  54         c     @edb.lines,@outparm1
     78BA 2304 
     78BC 8360 
0572 78BE 1605  14         jne   task.botline.show_lines_in_buffer
0573               
0574 78C0 06A0  32         bl    @putat
     78C2 6292 
0575 78C4 1D49                   byte 29,73
0576 78C6 7E0A                   data txt_bottom
0577               
0578 78C8 100B  14         jmp   task.botline.$$
0579                       ;------------------------------------------------------
0580                       ; Show lines in buffer
0581                       ;------------------------------------------------------
0582               task.botline.show_lines_in_buffer:
0583 78CA C820  54         mov   @edb.lines,@waux1
     78CC 2304 
     78CE 833C 
0584 78D0 05A0  34         inc   @waux1                 ; Offset 1
     78D2 833C 
0585 78D4 06A0  32         bl    @putnum
     78D6 6672 
0586 78D8 1D49                   byte 29,73             ; YX
0587 78DA 833C                   data waux1,rambuf
     78DC 8390 
0588 78DE 3020                   byte 48
0589                             byte 32
0590                       ;------------------------------------------------------
0591                       ; Exit
0592                       ;------------------------------------------------------
0593               task.botline.$$
0594 78E0 C820  54         mov   @fb.yxsave,@wyx
     78E2 2214 
     78E4 832A 
0595 78E6 0460  28         b     @slotok                ; Exit running task
     78E8 6FD6 
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
0024 78EA 0649  14         dect  stack
0025 78EC C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 78EE 0204  20         li    tmp0,fb.top
     78F0 2650 
0030 78F2 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     78F4 2200 
0031 78F6 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     78F8 2204 
0032 78FA 04E0  34         clr   @fb.row               ; Current row=0
     78FC 2206 
0033 78FE 04E0  34         clr   @fb.column            ; Current column=0
     7900 220C 
0034 7902 0204  20         li    tmp0,80
     7904 0050 
0035 7906 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     7908 220E 
0036 790A 0204  20         li    tmp0,29
     790C 001D 
0037 790E C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     7910 2218 
0038 7912 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     7914 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 7916 06A0  32         bl    @film
     7918 60CC 
0043 791A 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     791C 0000 
     791E 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7920 0460  28         b     @poprt                ; Return to caller
     7922 60C8 
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
0073 7924 0649  14         dect  stack
0074 7926 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 7928 C120  34         mov   @parm1,tmp0
     792A 8350 
0079 792C A120  34         a     @fb.topline,tmp0
     792E 2204 
0080 7930 C804  38         mov   tmp0,@outparm1
     7932 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 7934 0460  28         b    @poprt                 ; Return to caller
     7936 60C8 
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
0113 7938 0649  14         dect  stack
0114 793A C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 793C C1A0  34         mov   @fb.row,tmp2
     793E 2206 
0119 7940 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7942 220E 
0120 7944 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     7946 220C 
0121 7948 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     794A 2200 
0122 794C C807  38         mov   tmp3,@fb.current
     794E 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7950 0460  28         b    @poprt                 ; Return to caller
     7952 60C8 
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
0145 7954 0649  14         dect  stack
0146 7956 C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7958 C820  54         mov   @parm1,@fb.topline
     795A 8350 
     795C 2204 
0151 795E 04E0  34         clr   @parm2                ; Target row in frame buffer
     7960 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 7962 06A0  32         bl    @edb.line.unpack
     7964 7B34 
0157 7966 05A0  34         inc   @parm1                ; Next line in editor buffer
     7968 8350 
0158 796A 05A0  34         inc   @parm2                ; Next row in frame buffer
     796C 8352 
0159 796E 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7970 8352 
     7972 2218 
0160 7974 11F6  14         jlt   fb.refresh.unpack_line
0161 7976 0720  34         seto  @fb.dirty             ; Refresh screen
     7978 2216 
0162                       ;------------------------------------------------------
0163                       ; Exit
0164                       ;------------------------------------------------------
0165               fb.refresh.exit
0166 797A 0460  28         b    @poprt                 ; Return to caller
     797C 60C8 
0167               
0168               
0169               
0170               
0171               ***************************************************************
0172               * fb.get.firstnonblank
0173               * Get column of first non-blank character in specified line
0174               ***************************************************************
0175               * bl @fb.get.firstnonblank
0176               *--------------------------------------------------------------
0177               * OUTPUT
0178               * @outparm1 = Column containing first non-blank character
0179               * @outparm2 = Character
0180               ********@*****@*********************@**************************
0181               fb.get.firstnonblank
0182 797E 0649  14         dect  stack
0183 7980 C64B  30         mov   r11,*stack            ; Save return address
0184                       ;------------------------------------------------------
0185                       ; Prepare for scanning
0186                       ;------------------------------------------------------
0187 7982 04E0  34         clr   @fb.column
     7984 220C 
0188 7986 06A0  32         bl    @fb.calc_pointer
     7988 7938 
0189 798A 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     798C 7BC0 
0190 798E C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7990 2208 
0191 7992 1313  14         jeq   fb.get.firstnonblank.nomatch
0192                                                   ; Exit if empty line
0193 7994 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7996 2202 
0194 7998 04C5  14         clr   tmp1
0195                       ;------------------------------------------------------
0196                       ; Scan line for non-blank character
0197                       ;------------------------------------------------------
0198               fb.get.firstnonblank.loop:
0199 799A D174  28         movb  *tmp0+,tmp1           ; Get character
0200 799C 130E  14         jeq   fb.get.firstnonblank.nomatch
0201                                                   ; Exit if empty line
0202 799E 0285  22         ci    tmp1,>2000            ; Whitespace?
     79A0 2000 
0203 79A2 1503  14         jgt   fb.get.firstnonblank.match
0204 79A4 0606  14         dec   tmp2                  ; Counter--
0205 79A6 16F9  14         jne   fb.get.firstnonblank.loop
0206 79A8 1008  14         jmp   fb.get.firstnonblank.nomatch
0207                       ;------------------------------------------------------
0208                       ; Non-blank character found
0209                       ;------------------------------------------------------
0210               fb.get.firstnonblank.match
0211 79AA 6120  34         s     @fb.current,tmp0      ; Calculate column
     79AC 2202 
0212 79AE 0604  14         dec   tmp0
0213 79B0 C804  38         mov   tmp0,@outparm1        ; Save column
     79B2 8360 
0214 79B4 D805  38         movb  tmp1,@outparm2        ; Save character
     79B6 8362 
0215 79B8 1004  14         jmp   fb.get.firstnonblank.$$
0216                       ;------------------------------------------------------
0217                       ; No non-blank character found
0218                       ;------------------------------------------------------
0219               fb.get.firstnonblank.nomatch
0220 79BA 04E0  34         clr   @outparm1             ; X=0
     79BC 8360 
0221 79BE 04E0  34         clr   @outparm2             ; Null
     79C0 8362 
0222                       ;------------------------------------------------------
0223                       ; Exit
0224                       ;------------------------------------------------------
0225               fb.get.firstnonblank.$$
0226 79C2 0460  28         b    @poprt                 ; Return to caller
     79C4 60C8 
0227               
0228               
0229               
0230               
0231               
0232               
**** **** ****     > tivi.asm.6927
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
0059 79C6 0649  14         dect  stack
0060 79C8 C64B  30         mov   r11,*stack            ; Save return address
0061                       ;------------------------------------------------------
0062                       ; Initialize
0063                       ;------------------------------------------------------
0064 79CA 0204  20         li    tmp0,idx.top
     79CC 3000 
0065 79CE C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     79D0 2302 
0066                       ;------------------------------------------------------
0067                       ; Create index slot 0
0068                       ;------------------------------------------------------
0069 79D2 06A0  32         bl    @film
     79D4 60CC 
0070 79D6 3000             data  idx.top,>00,idx.size  ; Clear index
     79D8 0000 
     79DA 1000 
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               idx.init.exit:
0075 79DC 0460  28         b     @poprt                ; Return to caller
     79DE 60C8 
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
0097 79E0 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     79E2 8350 
0098                       ;------------------------------------------------------
0099                       ; Calculate offset
0100                       ;------------------------------------------------------
0101 79E4 C160  34         mov   @parm2,tmp1
     79E6 8352 
0102 79E8 0225  22         ai    tmp1,-edb.top         ; Substract editor buffer base,
     79EA 6000 
0103                                                   ; we only store the offset
0104               
0105                       ;------------------------------------------------------
0106                       ; Inject SAMS bank into high-nibble MSB of pointer
0107                       ;------------------------------------------------------
0108 79EC C1A0  34         mov   @parm3,tmp2
     79EE 8354 
0109 79F0 1300  14         jeq   idx.entry.update.save ; Skip for SAMS bank 0
0110               
0111                       ; <still to do>
0112               
0113                       ;------------------------------------------------------
0114                       ; Update index slot
0115                       ;------------------------------------------------------
0116               idx.entry.update.save:
0117 79F2 0A14  56         sla   tmp0,1                ; line number * 2
0118 79F4 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     79F6 3000 
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               idx.entry.update.exit:
0123 79F8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     79FA 8360 
0124 79FC 045B  20         b     *r11                  ; Return
0125               
0126               
0127               ***************************************************************
0128               * idx.entry.delete
0129               * Delete index entry - Close gap created by delete
0130               ***************************************************************
0131               * bl @idx.entry.delete
0132               *--------------------------------------------------------------
0133               * INPUT
0134               * @parm1    = Line number in editor buffer to delete
0135               * @parm2    = Line number of last line to check for reorg
0136               *--------------------------------------------------------------
0137               * OUTPUT
0138               * @outparm1 = Pointer to deleted line (for undo)
0139               *--------------------------------------------------------------
0140               * Register usage
0141               * tmp0,tmp2
0142               *--------------------------------------------------------------
0143               idx.entry.delete:
0144 79FE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7A00 8350 
0145                       ;------------------------------------------------------
0146                       ; Calculate address of index entry and save pointer
0147                       ;------------------------------------------------------
0148 7A02 0A14  56         sla   tmp0,1                ; line number * 2
0149 7A04 C824  54         mov   @idx.top(tmp0),@outparm1
     7A06 3000 
     7A08 8360 
0150                                                   ; Pointer to deleted line
0151                       ;------------------------------------------------------
0152                       ; Prepare for index reorg
0153                       ;------------------------------------------------------
0154 7A0A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7A0C 8352 
0155 7A0E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7A10 8350 
0156 7A12 1603  14         jne   idx.entry.delete.reorg
0157                       ;------------------------------------------------------
0158                       ; Special treatment if last line
0159                       ;------------------------------------------------------
0160 7A14 04E4  34         clr   @idx.top(tmp0)
     7A16 3000 
0161 7A18 1006  14         jmp   idx.entry.delete.exit
0162                       ;------------------------------------------------------
0163                       ; Reorganize index entries
0164                       ;------------------------------------------------------
0165               idx.entry.delete.reorg:
0166 7A1A C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7A1C 3002 
     7A1E 3000 
0167 7A20 05C4  14         inct  tmp0                  ; Next index entry
0168 7A22 0606  14         dec   tmp2                  ; tmp2--
0169 7A24 16FA  14         jne   idx.entry.delete.reorg
0170                                                   ; Loop unless completed
0171                       ;------------------------------------------------------
0172                       ; Exit
0173                       ;------------------------------------------------------
0174               idx.entry.delete.exit:
0175 7A26 045B  20         b     *r11                  ; Return
0176               
0177               
0178               ***************************************************************
0179               * idx.entry.insert
0180               * Insert index entry
0181               ***************************************************************
0182               * bl @idx.entry.insert
0183               *--------------------------------------------------------------
0184               * INPUT
0185               * @parm1    = Line number in editor buffer to insert
0186               * @parm2    = Line number of last line to check for reorg
0187               *--------------------------------------------------------------
0188               * OUTPUT
0189               * NONE
0190               *--------------------------------------------------------------
0191               * Register usage
0192               * tmp0,tmp2
0193               *--------------------------------------------------------------
0194               idx.entry.insert:
0195 7A28 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7A2A 8352 
0196                       ;------------------------------------------------------
0197                       ; Calculate address of index entry and save pointer
0198                       ;------------------------------------------------------
0199 7A2C 0A14  56         sla   tmp0,1                ; line number * 2
0200                       ;------------------------------------------------------
0201                       ; Prepare for index reorg
0202                       ;------------------------------------------------------
0203 7A2E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7A30 8352 
0204 7A32 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7A34 8350 
0205 7A36 1606  14         jne   idx.entry.insert.reorg
0206                       ;------------------------------------------------------
0207                       ; Special treatment if last line
0208                       ;------------------------------------------------------
0209 7A38 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7A3A 3000 
     7A3C 3002 
0210 7A3E 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     7A40 3000 
0211 7A42 1009  14         jmp   idx.entry.insert.$$
0212                       ;------------------------------------------------------
0213                       ; Reorganize index entries
0214                       ;------------------------------------------------------
0215               idx.entry.insert.reorg:
0216 7A44 05C6  14         inct  tmp2                  ; Adjust one time
0217 7A46 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7A48 3000 
     7A4A 3002 
0218 7A4C 0644  14         dect  tmp0                  ; Previous index entry
0219 7A4E 0606  14         dec   tmp2                  ; tmp2--
0220 7A50 16FA  14         jne   -!                    ; Loop unless completed
0221               
0222 7A52 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     7A54 3004 
0223                       ;------------------------------------------------------
0224                       ; Exit
0225                       ;------------------------------------------------------
0226               idx.entry.insert.$$:
0227 7A56 045B  20         b     *r11                  ; Return
0228               
0229               
0230               
0231               ***************************************************************
0232               * idx.pointer.get
0233               * Get pointer to editor buffer line content
0234               ***************************************************************
0235               * bl @idx.pointer.get
0236               *--------------------------------------------------------------
0237               * INPUT
0238               * @parm1 = Line number in editor buffer
0239               *--------------------------------------------------------------
0240               * OUTPUT
0241               * @outparm1 = Pointer to editor buffer line content
0242               * @outparm2 = SAMS bank (>0 - >a)
0243               *--------------------------------------------------------------
0244               * Register usage
0245               * tmp0,tmp1,tmp2
0246               *--------------------------------------------------------------
0247               idx.pointer.get:
0248 7A58 0649  14         dect  stack
0249 7A5A C64B  30         mov   r11,*stack            ; Save return address
0250                       ;------------------------------------------------------
0251                       ; Get pointer
0252                       ;------------------------------------------------------
0253 7A5C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7A5E 8350 
0254                       ;------------------------------------------------------
0255                       ; Calculate index entry
0256                       ;------------------------------------------------------
0257 7A60 0A14  56         sla   tmp0,1                ; line number * 2
0258 7A62 C164  34         mov   @idx.top(tmp0),tmp1   ; Get offset
     7A64 3000 
0259                       ;------------------------------------------------------
0260                       ; Get SAMS bank
0261                       ;------------------------------------------------------
0262 7A66 C185  18         mov   tmp1,tmp2
0263 7A68 09C6  56         srl   tmp2,12               ; Remove offset part
0264               
0265 7A6A 0286  22         ci    tmp2,5                ; SAMS bank 0
     7A6C 0005 
0266 7A6E 1205  14         jle   idx.pointer.get.samsbank0
0267               
0268 7A70 0226  22         ai    tmp2,-5               ; Get SAMS bank
     7A72 FFFB 
0269 7A74 C806  38         mov   tmp2,@outparm2        ; Return SAMS bank
     7A76 8362 
0270 7A78 1002  14         jmp   idx.pointer.get.addbase
0271                       ;------------------------------------------------------
0272                       ; SAMS Bank 0 (or only 32K memory expansion)
0273                       ;------------------------------------------------------
0274               idx.pointer.get.samsbank0:
0275 7A7A 04E0  34         clr   @outparm2             ; SAMS bank 0
     7A7C 8362 
0276                       ;------------------------------------------------------
0277                       ; Add base
0278                       ;------------------------------------------------------
0279               idx.pointer.get.addbase:
0280 7A7E 0225  22         ai    tmp1,edb.top          ; Add base of editor buffer
     7A80 A000 
0281 7A82 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7A84 8360 
0282                       ;------------------------------------------------------
0283                       ; Exit
0284                       ;------------------------------------------------------
0285               idx.pointer.get.exit:
0286 7A86 0460  28         b     @poprt                ; Return to caller
     7A88 60C8 
**** **** ****     > tivi.asm.6927
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
0026 7A8A 0649  14         dect  stack
0027 7A8C C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7A8E 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7A90 A002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 7A92 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7A94 2300 
0035 7A96 C804  38         mov   tmp0,@edb.next_free.ptr
     7A98 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 7A9A 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7A9C 230C 
0038 7A9E 04E0  34         clr   @edb.lines            ; Lines=0
     7AA0 2304 
0039               
0040               edb.init.exit:
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044 7AA2 0460  28         b     @poprt                ; Return to caller
     7AA4 60C8 
0045               
0046               
0047               
0048               ***************************************************************
0049               * edb.line.pack
0050               * Pack current line in framebuffer
0051               ***************************************************************
0052               *  bl   @edb.line.pack
0053               *--------------------------------------------------------------
0054               * INPUT
0055               * @fb.top       = Address of top row in frame buffer
0056               * @fb.row       = Current row in frame buffer
0057               * @fb.column    = Current column in frame buffer
0058               * @fb.colsline  = Columns per line in frame buffer
0059               *--------------------------------------------------------------
0060               * OUTPUT
0061               *--------------------------------------------------------------
0062               * Register usage
0063               * tmp0,tmp1,tmp2
0064               *--------------------------------------------------------------
0065               * Memory usage
0066               * rambuf   = Saved @fb.column
0067               * rambuf+2 = Saved beginning of row
0068               * rambuf+4 = Saved length of row
0069               ********@*****@*********************@**************************
0070               edb.line.pack:
0071 7AA6 0649  14         dect  stack
0072 7AA8 C64B  30         mov   r11,*stack            ; Save return address
0073                       ;------------------------------------------------------
0074                       ; Get values
0075                       ;------------------------------------------------------
0076 7AAA C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7AAC 220C 
     7AAE 8390 
0077 7AB0 04E0  34         clr   @fb.column
     7AB2 220C 
0078 7AB4 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7AB6 7938 
0079                       ;------------------------------------------------------
0080                       ; Prepare scan
0081                       ;------------------------------------------------------
0082 7AB8 04C4  14         clr   tmp0                  ; Counter
0083 7ABA C160  34         mov   @fb.current,tmp1      ; Get position
     7ABC 2202 
0084 7ABE C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7AC0 8392 
0085               
0086                       ;------------------------------------------------------
0087                       ; Scan line for >00 byte termination
0088                       ;------------------------------------------------------
0089               edb.line.pack.scan:
0090 7AC2 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0091 7AC4 0986  56         srl   tmp2,8                ; Right justify
0092 7AC6 1302  14         jeq   edb.line.pack.checklength
0093                                                   ; Stop scan if >00 found
0094 7AC8 0584  14         inc   tmp0                  ; Increase string length
0095 7ACA 10FB  14         jmp   edb.line.pack.scan    ; Next character
0096               
0097                       ;------------------------------------------------------
0098                       ; Handle line placement depending on length
0099                       ;------------------------------------------------------
0100               edb.line.pack.checklength:
0101 7ACC C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7ACE 2204 
     7AD0 8350 
0102 7AD2 A820  54         a     @fb.row,@parm1        ; /
     7AD4 2206 
     7AD6 8350 
0103               
0104 7AD8 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7ADA 8394 
0105               
0106                       ;------------------------------------------------------
0107                       ; 1. Update index
0108                       ;------------------------------------------------------
0109               edb.line.pack.update_index:
0110 7ADC C820  54         mov   @edb.next_free.ptr,@parm2
     7ADE 2308 
     7AE0 8352 
0111                                                   ; Block where line will reside
0112               
0113 7AE2 04E0  34         clr   @parm3                ; SAMS bank
     7AE4 8354 
0114 7AE6 06A0  32         bl    @idx.entry.update     ; parm1 (line number) = fb.topline + fb.row
     7AE8 79E0 
0115                                                   ; parm2 (pointer)     = pointer to line in editor buffer
0116                                                   ; parm3 (SAMS bank)   = 0
0117               
0118                       ;------------------------------------------------------
0119                       ; 2. Set line prefix in editor buffer
0120                       ;------------------------------------------------------
0121 7AEA C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7AEC 8392 
0122 7AEE C160  34         mov   @edb.next_free.ptr,tmp1
     7AF0 2308 
0123                                                   ; Address of line in editor buffer
0124               
0125 7AF2 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     7AF4 2308 
0126               
0127 7AF6 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     7AF8 8394 
0128 7AFA CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0129 7AFC 1316  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0130               
0131                       ;------------------------------------------------------
0132                       ; 3. Copy line from framebuffer to editor buffer
0133                       ;------------------------------------------------------
0134               edb.line.pack.copyline:
0135 7AFE 0286  22         ci    tmp2,2
     7B00 0002 
0136 7B02 1602  14         jne   edb.line.pack.copyline.checkbyte
0137 7B04 C554  38         mov   *tmp0,*tmp1           ; Copy single word
0138 7B06 1007  14         jmp   !
0139               
0140               edb.line.pack.copyline.checkbyte:
0141 7B08 0286  22         ci    tmp2,1
     7B0A 0001 
0142 7B0C 1602  14         jne   edb.line.pack.copyline.block
0143 7B0E D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0144 7B10 1002  14         jmp   !
0145               
0146               edb.line.pack.copyline.block:
0147 7B12 06A0  32         bl    @xpym2m               ; Copy memory block
     7B14 62E8 
0148                                                   ;   tmp0 = source
0149                                                   ;   tmp1 = destination
0150                                                   ;   tmp2 = bytes to copy
0151               
0152                       ;------------------------------------------------------
0153                       ; 4. Update pointer to next free line, assure it is even
0154                       ;------------------------------------------------------
0155 7B16 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     7B18 8394 
     7B1A 2308 
0156                                                   ; Update pointer to next free block
0157               
0158 7B1C C120  34         mov   @edb.next_free.ptr,tmp0
     7B1E 2308 
0159 7B20 0244  22         andi  tmp0,1                ; Uneven ?
     7B22 0001 
0160 7B24 1302  14         jeq   edb.line.pack.exit    ; Exit if even
0161 7B26 05A0  34         inc   @edb.next_free.ptr    ; Make it even
     7B28 2308 
0162                       ;------------------------------------------------------
0163                       ; Exit
0164                       ;------------------------------------------------------
0165               edb.line.pack.exit:
0166 7B2A C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7B2C 8390 
     7B2E 220C 
0167 7B30 0460  28         b     @poprt                ; Return to caller
     7B32 60C8 
0168               
0169               
0170               
0171               
0172               ***************************************************************
0173               * edb.line.unpack
0174               * Unpack specified line to framebuffer
0175               ***************************************************************
0176               *  bl   @edb.line.unpack
0177               *--------------------------------------------------------------
0178               * INPUT
0179               * @parm1 = Line to unpack from editor buffer
0180               * @parm2 = Target row in frame buffer
0181               *--------------------------------------------------------------
0182               * OUTPUT
0183               * none
0184               *--------------------------------------------------------------
0185               * Register usage
0186               * tmp0,tmp1,tmp2
0187               *--------------------------------------------------------------
0188               * Memory usage
0189               * rambuf   = Saved @parm1 of edb.line.unpack
0190               * rambuf+2 = Saved @parm2 of edb.line.unpack
0191               * rambuf+4 = Source memory address in editor buffer
0192               * rambuf+6 = Destination memory address in frame buffer
0193               * rambuf+8 = Length of unpacked line
0194               ********@*****@*********************@**************************
0195               edb.line.unpack:
0196 7B34 0649  14         dect  stack
0197 7B36 C64B  30         mov   r11,*stack            ; Save return address
0198                       ;------------------------------------------------------
0199                       ; Save parameters
0200                       ;------------------------------------------------------
0201 7B38 C820  54         mov   @parm1,@rambuf
     7B3A 8350 
     7B3C 8390 
0202 7B3E C820  54         mov   @parm2,@rambuf+2
     7B40 8352 
     7B42 8392 
0203                       ;------------------------------------------------------
0204                       ; Calculate offset in frame buffer
0205                       ;------------------------------------------------------
0206 7B44 C120  34         mov   @fb.colsline,tmp0
     7B46 220E 
0207 7B48 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7B4A 8352 
0208 7B4C C1A0  34         mov   @fb.top.ptr,tmp2
     7B4E 2200 
0209 7B50 A146  18         a     tmp2,tmp1             ; Add base to offset
0210 7B52 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7B54 8396 
0211               
0212               
0213                       ;------------------------------------------------------
0214                       ; Get length of line to unpack
0215                       ;------------------------------------------------------
0216 7B56 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7B58 7B9C 
0217                                                   ; parm1 = Line number
0218               
0219 7B5A C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7B5C 8360 
     7B5E 8398 
0220 7B60 1307  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0221               
0222                       ;------------------------------------------------------
0223                       ; Index. Calculate address of entry and get pointer
0224                       ;------------------------------------------------------
0225 7B62 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     7B64 7A58 
0226                                                   ; parm1 = Line number
0227               
0228               
0229 7B66 05E0  34         inct  @outparm1             ; Skip line prefix
     7B68 8360 
0230 7B6A C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7B6C 8360 
     7B6E 8394 
0231               
0232                       ;------------------------------------------------------
0233                       ; Erase chars from last column until column 80
0234                       ;------------------------------------------------------
0235               edb.line.unpack.clear:
0236 7B70 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7B72 8396 
0237 7B74 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7B76 8398 
0238               
0239 7B78 04C5  14         clr   tmp1                  ; Fill with >00
0240 7B7A C1A0  34         mov   @fb.colsline,tmp2
     7B7C 220E 
0241 7B7E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7B80 8398 
0242               
0243 7B82 06A0  32         bl    @xfilm                ; tmp0 = Target address
     7B84 60D2 
0244                                                   ; tmp1 = Byte to fill
0245                                                   ; tmp2 = Repeat count
0246               
0247                       ;------------------------------------------------------
0248                       ; Copy line from editor buffer to frame buffer
0249                       ;------------------------------------------------------
0250               edb.line.unpack.copy:
0251 7B86 C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     7B88 8398 
0252 7B8A 1306  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0253               
0254 7B8C C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7B8E 8394 
0255 7B90 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7B92 8396 
0256                       ;------------------------------------------------------
0257                       ; Copy memory block
0258                       ;------------------------------------------------------
0259 7B94 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7B96 62E8 
0260                                                   ;   tmp0 = Source address
0261                                                   ;   tmp1 = Target address
0262                                                   ;   tmp2 = Bytes to copy
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266               edb.line.unpack.exit:
0267 7B98 0460  28         b     @poprt                ; Return to caller
     7B9A 60C8 
0268               
0269               
0270               
0271               
0272               ***************************************************************
0273               * edb.line.getlength
0274               * Get length of specified line
0275               ***************************************************************
0276               *  bl   @edb.line.getlength
0277               *--------------------------------------------------------------
0278               * INPUT
0279               * @parm1 = Line number
0280               *--------------------------------------------------------------
0281               * OUTPUT
0282               * @outparm1 = Length of line
0283               * @outparm2 = SAMS bank (>0 - >a)
0284               *--------------------------------------------------------------
0285               * Register usage
0286               * tmp0,tmp1
0287               ********@*****@*********************@**************************
0288               edb.line.getlength:
0289 7B9C 0649  14         dect  stack
0290 7B9E C64B  30         mov   r11,*stack            ; Save return address
0291                       ;------------------------------------------------------
0292                       ; Initialisation
0293                       ;------------------------------------------------------
0294 7BA0 04E0  34         clr   @outparm1             ; Reset length
     7BA2 8360 
0295 7BA4 04E0  34         clr   @outparm2             ; Reset SAMS bank
     7BA6 8362 
0296                       ;------------------------------------------------------
0297                       ; Get length
0298                       ;------------------------------------------------------
0299 7BA8 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7BAA 7A58 
0300 7BAC C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     7BAE 8360 
0301 7BB0 1305  14         jeq   edb.line.getlength.exit
0302                                                   ; Exit early if NULL pointer
0303               
0304                       ;------------------------------------------------------
0305                       ; Process line prefix
0306                       ;------------------------------------------------------
0307 7BB2 C154  26         mov   *tmp0,tmp1            ; Get line prefix
0308 7BB4 0245  22         andi  tmp1,>00ff            ; Get rid of MSB
     7BB6 00FF 
0309 7BB8 C805  38         mov   tmp1,@outparm1        ; Save line length
     7BBA 8360 
0310                       ;------------------------------------------------------
0311                       ; Exit
0312                       ;------------------------------------------------------
0313               edb.line.getlength.exit:
0314 7BBC 0460  28         b     @poprt                ; Return to caller
     7BBE 60C8 
0315               
0316               
0317               
0318               
0319               ***************************************************************
0320               * edb.line.getlength2
0321               * Get length of current row (as seen from editor buffer side)
0322               ***************************************************************
0323               *  bl   @edb.line.getlength2
0324               *--------------------------------------------------------------
0325               * INPUT
0326               * @fb.row = Row in frame buffer
0327               *--------------------------------------------------------------
0328               * OUTPUT
0329               * @fb.row.length = Length of row
0330               *--------------------------------------------------------------
0331               * Register usage
0332               * tmp0,tmp1
0333               ********@*****@*********************@**************************
0334               edb.line.getlength2:
0335 7BC0 0649  14         dect  stack
0336 7BC2 C64B  30         mov   r11,*stack            ; Save return address
0337                       ;------------------------------------------------------
0338                       ; Get length
0339                       ;------------------------------------------------------
0340 7BC4 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7BC6 220C 
     7BC8 8390 
0341 7BCA C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7BCC 2204 
0342 7BCE A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7BD0 2206 
0343 7BD2 0A24  56         sla   tmp0,2                ; Line number * 4
0344 7BD4 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7BD6 3002 
0345 7BD8 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7BDA 00FF 
0346 7BDC C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7BDE 2208 
0347                       ;------------------------------------------------------
0348                       ; Exit
0349                       ;------------------------------------------------------
0350               edb.line.getlength2.exit:
0351 7BE0 0460  28         b     @poprt                ; Return to caller
     7BE2 60C8 
0352               
**** **** ****     > tivi.asm.6927
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
0017               * parm2 = RLE compression on (>FFFF) or off >0000)
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
0028 7BE4 0649  14         dect  stack
0029 7BE6 C64B  30         mov   r11,*stack            ; Save return address
0030 7BE8 C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     7BEA 8352 
     7BEC 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 7BEE 04E0  34         clr   @tfh.records          ; Reset records counter
     7BF0 242E 
0035 7BF2 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7BF4 2434 
0036 7BF6 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7BF8 2432 
0037 7BFA 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 7BFC 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7BFE 242A 
0039 7C00 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7C02 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 7C04 06A0  32         bl    @hchar
     7C06 6474 
0044 7C08 1D00                   byte 29,0,32,80
     7C0A 2050 
0045 7C0C FFFF                   data EOL
0046               
0047 7C0E 06A0  32         bl    @putat
     7C10 6292 
0048 7C12 1D00                   byte 29,0
0049 7C14 7E1A                   data txt_loading      ; Display "Loading...."
0050               
0051 7C16 8820  54         c     @tfh.rleonload,@w$ffff
     7C18 2436 
     7C1A 6048 
0052 7C1C 1604  14         jne   !
0053 7C1E 06A0  32         bl    @putat
     7C20 6292 
0054 7C22 1D44                   byte 29,68
0055 7C24 7E2A                   data txt_rle          ; Display "RLE"
0056               
0057 7C26 06A0  32 !       bl    @at
     7C28 6380 
0058 7C2A 1D0B                   byte 29,11            ; Cursor YX position
0059 7C2C C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7C2E 8350 
0060 7C30 06A0  32         bl    @xutst0               ; Display device/filename
     7C32 6282 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 7C34 06A0  32         bl    @cpym2v
     7C36 629A 
0065 7C38 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7C3A 7DDC 
     7C3C 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 7C3E 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7C40 0A69 
0071 7C42 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7C44 8350 
0072 7C46 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 7C48 0986  56         srl   tmp2,8                ; Right justify
0074 7C4A 0586  14         inc   tmp2                  ; Include length byte as well
0075 7C4C 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7C4E 62A0 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 7C50 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7C52 6D82 
0080 7C54 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 7C56 06A0  32         bl    @file.open
     7C58 6ED0 
0085 7C5A 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 7C5C 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7C5E 6042 
0087 7C60 1602  14         jne   tfh.file.read.record
0088 7C62 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7C64 7D94 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 7C66 05A0  34         inc   @tfh.records          ; Update counter
     7C68 242E 
0094 7C6A 04E0  34         clr   @tfh.reclen           ; Reset record length
     7C6C 2430 
0095               
0096 7C6E 06A0  32         bl    @file.record.read     ; Read record
     7C70 6F12 
0097 7C72 0A60                   data tfh.vpab         ; tmp0=Status byte
0098                                                   ; tmp1=Bytes read
0099                                                   ; tmp2=Status register contents upon DSRLNK return
0100               
0101 7C74 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7C76 242A 
0102 7C78 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7C7A 2430 
0103 7C7C C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7C7E 242C 
0104                       ;------------------------------------------------------
0105                       ; 1a: Calculate kilobytes processed
0106                       ;------------------------------------------------------
0107 7C80 A805  38         a     tmp1,@tfh.counter
     7C82 2434 
0108 7C84 A160  34         a     @tfh.counter,tmp1
     7C86 2434 
0109 7C88 0285  22         ci    tmp1,1024
     7C8A 0400 
0110 7C8C 1106  14         jlt   !
0111 7C8E 05A0  34         inc   @tfh.kilobytes
     7C90 2432 
0112 7C92 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7C94 FC00 
0113 7C96 C805  38         mov   tmp1,@tfh.counter
     7C98 2434 
0114                       ;------------------------------------------------------
0115                       ; 1b: Load spectra scratchpad layout
0116                       ;------------------------------------------------------
0117 7C9A 06A0  32 !       bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7C9C 677E 
0118 7C9E 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7CA0 6DA4 
0119 7CA2 2100                   data scrpad.backup2   ; / >2100->8300
0120                       ;------------------------------------------------------
0121                       ; 1c: Check if a file error occured
0122                       ;------------------------------------------------------
0123               tfh.file.read.check:
0124 7CA4 C1A0  34         mov   @tfh.ioresult,tmp2
     7CA6 242C 
0125 7CA8 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7CAA 6042 
0126 7CAC 1373  14         jeq   tfh.file.read.error
0127                                                   ; Yes, so handle file error
0128                       ;------------------------------------------------------
0129                       ; 1d: Decide on copy line from VDP buffer to editor
0130                       ;     buffer (RLE off) or RAM buffer (RLE on)
0131                       ;------------------------------------------------------
0132 7CAE 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7CB0 0960 
0133               
0134 7CB2 8820  54         c     @tfh.rleonload,@w$ffff
     7CB4 2436 
     7CB6 6048 
0135                                                   ; RLE compression on?
0136 7CB8 1303  14         jeq   !                     ; Yes, do RLE compression
0137 7CBA C160  34         mov   @edb.next_free.ptr,tmp1
     7CBC 2308 
0138                                                   ; RAM target address (RLE off)
0139 7CBE 1002  14         jmp   tfh.file.read.check.emptyline
0140               
0141 7CC0 0205  20 !       li    tmp1,fb.top           ; RAM target address (RLE on)
     7CC2 2650 
0142                       ;------------------------------------------------------
0143                       ; Step 1e: Copy line from VDP to CPU memory
0144                       ;------------------------------------------------------
0145               tfh.file.read.check.emptyline:
0146 7CC4 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7CC6 2430 
0147 7CC8 1334  14         jeq   tfh.file.read.emptyline
0148                                                   ; Handle empty line
0149               
0150 7CCA C806  38         mov   tmp2,@edb.next_free.ptr
     7CCC 2308 
0151 7CCE 05E0  34         inct  @edb.next_free.ptr    ; Save line length in line prefix
     7CD0 2308 
0152               
0153 7CD2 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7CD4 62C6 
0154                                                   ;   tmp0 = VDP source address
0155                                                   ;   tmp1 = RAM target address
0156                                                   ;   tmp2 = Bytes to copy
0157                       ;------------------------------------------------------
0158                       ; Step 2: Check if RLE compression wanted
0159                       ;------------------------------------------------------
0160 7CD6 8820  54         c     @tfh.rleonload,@w$ffff
     7CD8 2436 
     7CDA 6048 
0161                                                   ; RLE compression on?
0162 7CDC 1303  14         jeq   tfh.file.read.rle_compress
0163                                                   ; Yes, do RLE compression
0164                       ;------------------------------------------------------
0165                       ; Step 2a: No RLE compression on line
0166                       ;------------------------------------------------------
0167 7CDE C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7CE0 2430 
0168 7CE2 100A  14         jmp   tfh.file.read.addline.normal
0169                       ;------------------------------------------------------
0170                       ; Step 2b: RLE compression on line => compress
0171                       ;------------------------------------------------------
0172               tfh.file.read.rle_compress:
0173                       ;bl    @film                ; DEBUG ONLY
0174                       ;      data fb.top+160,>00,80*2
0175               
0176 7CE4 0204  20         li    tmp0,fb.top           ; RAM source address
     7CE6 2650 
0177 7CE8 0205  20         li    tmp1,fb.top+160       ; RAM target address
     7CEA 26F0 
0178 7CEC C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     7CEE 2430 
0179 7CF0 06A0  32         bl    @xcpu2rle             ; RLE encode
     7CF2 6682 
0180 7CF4 C1A0  34         mov   @waux1,tmp2           ; Number of RLE compressed bytes to copy
     7CF6 833C 
0181               
0182                       ;------------------------------------------------------
0183                       ; Step 2c: Set line prefix
0184                       ;------------------------------------------------------
0185               tfh.file.read.addline.normal:
0186               
0187 7CF8 C1E0  34         mov   @tfh.reclen,tmp3      ; \ Line prefix MSB is "real" length if RLE encoded.
     7CFA 2430 
0188 7CFC 06C7  14         swpb  tmp3                  ; | Line prefix LSB is "compressed" length if RLE encoded,
0189 7CFE D187  18         movb  tmp3,tmp2             ; / otherwise normal length.
0190               
0191 7D00 C160  34         mov   @edb.next_free.ptr,tmp1
     7D02 2308 
0192                                                   ; RAM target address in editor buffer
0193 7D04 C546  30         mov   tmp2,*tmp1            ; Save line prefix
0194 7D06 05E0  34         inct  @edb.next_free.ptr    ; Add offset
     7D08 2308 
0195 7D0A 0246  22         andi  tmp2,>00ff            ; Get rid of MSB
     7D0C 00FF 
0196               
0197 7D0E C805  38         mov   tmp1,@parm2           ; parm2 = Pointer to line in editor buffer
     7D10 8352 
0198               
0199 7D12 A806  38         a     tmp2,@edb.next_free.ptr
     7D14 2308 
0200                                                   ; Update pointer to next free line
0201               
0202                       ;------------------------------------------------------
0203                       ; 2e: Copy compressed line to editor buffer
0204                       ;------------------------------------------------------
0205 7D16 8820  54         c     @tfh.rleonload,@w$ffff
     7D18 2436 
     7D1A 6048 
0206                                                   ; RLE compression on?
0207 7D1C 1604  14         jne   tfh.file.read.prepindex
0208 7D1E 0204  20         li    tmp0,fb.top+160       ; RAM source address
     7D20 26F0 
0209 7D22 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7D24 62E8 
0210                                                   ;   tmp0 = RAM source address
0211                                                   ;   tmp1 = RAM target address
0212                                                   ;   tmp2 = Bytes to copy
0213                       ;------------------------------------------------------
0214                       ; Step 3: Prepare for index update
0215                       ;------------------------------------------------------
0216               tfh.file.read.prepindex:
0217 7D26 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7D28 242E 
     7D2A 8350 
0218 7D2C 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7D2E 8350 
0219                                                   ; parm2 = Already set
0220 7D30 1007  14         jmp   tfh.file.read.updindex
0221                                                   ; Update index
0222                       ;------------------------------------------------------
0223                       ; Special handling for empty line
0224                       ;------------------------------------------------------
0225               tfh.file.read.emptyline:
0226 7D32 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7D34 242E 
     7D36 8350 
0227 7D38 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7D3A 8350 
0228 7D3C 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7D3E 8352 
0229                       ;------------------------------------------------------
0230                       ; Step 5: Update index
0231                       ;------------------------------------------------------
0232               tfh.file.read.updindex:
0233 7D40 06A0  32         bl    @idx.entry.update     ; Update index
     7D42 79E0 
0234                                                   ;   parm1 = Line number in editor buffer
0235                                                   ;   parm2 = Pointer to line in editor buffer
0236               
0237 7D44 05A0  34         inc   @edb.lines            ; lines=lines+1
     7D46 2304 
0238                       ;------------------------------------------------------
0239                       ; 5a: Display results
0240                       ;------------------------------------------------------
0241               tfh.file.read.display:
0242 7D48 06A0  32         bl    @putnum
     7D4A 6672 
0243 7D4C 1D49                   byte 29,73            ; Show lines read
0244 7D4E 2304                   data edb.lines,rambuf,>3020
     7D50 8390 
     7D52 3020 
0245               
0246 7D54 8220  34         c     @tfh.kilobytes,tmp4
     7D56 2432 
0247 7D58 130C  14         jeq   tfh.file.read.checkmem
0248               
0249 7D5A C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7D5C 2432 
0250               
0251 7D5E 06A0  32         bl    @putnum
     7D60 6672 
0252 7D62 1D38                   byte 29,56            ; Show kilobytes read
0253 7D64 2432                   data tfh.kilobytes,rambuf,>3020
     7D66 8390 
     7D68 3020 
0254               
0255 7D6A 06A0  32         bl    @putat
     7D6C 6292 
0256 7D6E 1D3D                   byte 29,61
0257 7D70 7E26                   data txt_kb           ; Show "kb" string
0258               
0259               ******************************************************
0260               * Stop reading file if high memory expansion gets full
0261               ******************************************************
0262               tfh.file.read.checkmem:
0263 7D72 C120  34         mov   @edb.next_free.ptr,tmp0
     7D74 2308 
0264 7D76 0284  22         ci    tmp0,>ffa0
     7D78 FFA0 
0265 7D7A 1207  14         jle   tfh.file.read.next
0266 7D7C 1013  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0267                       ;------------------------------------------------------
0268                       ; Next SAMS page
0269                       ;------------------------------------------------------
0270 7D7E 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7D80 230A 
0271 7D82 0204  20         li    tmp0,edb.top
     7D84 A000 
0272 7D86 C804  38         mov   tmp0,@edb.next_free.ptr
     7D88 2308 
0273                                                   ; Reset to top of editor buffer
0274                       ;------------------------------------------------------
0275                       ; Next record
0276                       ;------------------------------------------------------
0277               tfh.file.read.next:
0278 7D8A 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7D8C 6D82 
0279 7D8E 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0280               
0281 7D90 0460  28         b     @tfh.file.read.record
     7D92 7C66 
0282                                                   ; Next record
0283                       ;------------------------------------------------------
0284                       ; Error handler
0285                       ;------------------------------------------------------
0286               tfh.file.read.error:
0287 7D94 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7D96 242A 
0288 7D98 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0289 7D9A 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7D9C 0005 
0290 7D9E 1302  14         jeq   tfh.file.read.eof
0291                                                   ; All good. File closed by DSRLNK
0292 7DA0 0460  28         b     @crash_handler        ; A File error occured. System crashed
     7DA2 604C 
0293                       ;------------------------------------------------------
0294                       ; End-Of-File reached
0295                       ;------------------------------------------------------
0296               tfh.file.read.eof:
0297 7DA4 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7DA6 6DA4 
0298 7DA8 2100                   data scrpad.backup2   ; / >2100->8300
0299                       ;------------------------------------------------------
0300                       ; Display final results
0301                       ;------------------------------------------------------
0302 7DAA 06A0  32         bl    @hchar
     7DAC 6474 
0303 7DAE 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7DB0 200A 
0304 7DB2 FFFF                   data EOL
0305               
0306 7DB4 06A0  32         bl    @putnum
     7DB6 6672 
0307 7DB8 1D38                   byte 29,56            ; Show kilobytes read
0308 7DBA 2432                   data tfh.kilobytes,rambuf,>3020
     7DBC 8390 
     7DBE 3020 
0309               
0310 7DC0 06A0  32         bl    @putat
     7DC2 6292 
0311 7DC4 1D3D                   byte 29,61
0312 7DC6 7E26                   data txt_kb           ; Show "kb" string
0313               
0314 7DC8 06A0  32         bl    @putnum
     7DCA 6672 
0315 7DCC 1D49                   byte 29,73            ; Show lines read
0316 7DCE 242E                   data tfh.records,rambuf,>3020
     7DD0 8390 
     7DD2 3020 
0317               
0318 7DD4 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7DD6 2306 
0319               *--------------------------------------------------------------
0320               * Exit
0321               *--------------------------------------------------------------
0322               tfh.file.read_exit:
0323 7DD8 0460  28         b     @poprt                ; Return to caller
     7DDA 60C8 
0324               
0325               
0326               ***************************************************************
0327               * PAB for accessing DV/80 file
0328               ********@*****@*********************@**************************
0329               tfh.file.pab.header:
0330 7DDC 0014             byte  io.op.open            ;  0    - OPEN
0331                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0332 7DDE 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0333 7DE0 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0334                       byte  00                    ;  5    - Character count
0335 7DE2 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0336 7DE4 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0337                       ;------------------------------------------------------
0338                       ; File descriptor part (variable length)
0339                       ;------------------------------------------------------
0340                       ; byte  12                  ;  9    - File descriptor length
0341                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.6927
0621               
0622               
0623               ***************************************************************
0624               *                      Constants
0625               ***************************************************************
0626               romsat:
0627 7DE6 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7DE8 000F 
0628               
0629               cursors:
0630 7DEA 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7DEC 0000 
     7DEE 0000 
     7DF0 001C 
0631 7DF2 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7DF4 1010 
     7DF6 1010 
     7DF8 1000 
0632 7DFA 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7DFC 1C1C 
     7DFE 1C1C 
     7E00 1C00 
0633               
0634               ***************************************************************
0635               *                       Strings
0636               ***************************************************************
0637               txt_delim
0638 7E02 012C             byte  1
0639 7E03 ....             text  ','
0640                       even
0641               
0642               txt_marker
0643 7E04 052A             byte  5
0644 7E05 ....             text  '*EOF*'
0645                       even
0646               
0647               txt_bottom
0648 7E0A 0520             byte  5
0649 7E0B ....             text  '  BOT'
0650                       even
0651               
0652               txt_ovrwrite
0653 7E10 034F             byte  3
0654 7E11 ....             text  'OVR'
0655                       even
0656               
0657               txt_insert
0658 7E14 0349             byte  3
0659 7E15 ....             text  'INS'
0660                       even
0661               
0662               txt_star
0663 7E18 012A             byte  1
0664 7E19 ....             text  '*'
0665                       even
0666               
0667               txt_loading
0668 7E1A 0A4C             byte  10
0669 7E1B ....             text  'Loading...'
0670                       even
0671               
0672               txt_kb
0673 7E26 026B             byte  2
0674 7E27 ....             text  'kb'
0675                       even
0676               
0677               txt_rle
0678 7E2A 0352             byte  3
0679 7E2B ....             text  'RLE'
0680                       even
0681               
0682               txt_lines
0683 7E2E 054C             byte  5
0684 7E2F ....             text  'Lines'
0685                       even
0686               
0687 7E34 7E34     end          data    $
0688               
0689               
0690               fdname0
0691 7E36 0D44             byte  13
0692 7E37 ....             text  'DSK1.INVADERS'
0693                       even
0694               
0695               fdname1
0696 7E44 0F44             byte  15
0697 7E45 ....             text  'DSK1.SPEECHDOCS'
0698                       even
0699               
0700               fdname2
0701 7E54 0C44             byte  12
0702 7E55 ....             text  'DSK1.XBEADOC'
0703                       even
0704               
0705               fdname3
0706 7E62 0C44             byte  12
0707 7E63 ....             text  'DSK3.XBEADOC'
0708                       even
0709               
0710               fdname4
0711 7E70 0C44             byte  12
0712 7E71 ....             text  'DSK3.C99MAN1'
0713                       even
0714               
0715               fdname5
0716 7E7E 0C44             byte  12
0717 7E7F ....             text  'DSK3.C99MAN2'
0718                       even
0719               
0720               fdname6
0721 7E8C 0C44             byte  12
0722 7E8D ....             text  'DSK3.C99MAN3'
0723                       even
0724               
0725               fdname7
0726 7E9A 0D44             byte  13
0727 7E9B ....             text  'DSK3.C99SPECS'
0728                       even
0729               
0730               fdname8
0731 7EA8 0D44             byte  13
0732 7EA9 ....             text  'DSK3.RANDOM#C'
0733                       even
0734               
0735               fdname9
0736 7EB6 0D44             byte  13
0737 7EB7 ....             text  'DSK3.RNDTST#C'
0738                       even
0739               

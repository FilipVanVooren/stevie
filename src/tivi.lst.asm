XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.25485
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200126-25485
0009               *--------------------------------------------------------------
0010               * TI-99/4a Advanced Editor & IDE
0011               *--------------------------------------------------------------
0012               * TiVi memory layout
0013               *
0014               * Mem range   Bytes    Hex    Purpose
0015               * =========   =====   ====    ==================================
0016               * 8300-83ff     256   >0100   scrpad spectra2 layout
0017               * 2000-20ff     256   >0100   scrpad backup 1: GPL layout
0018               * 2100-21ff     256   >0100   scrpad backup 2: paged out spectra2
0019               * 2200-22ff     256   >0100   TiVi frame buffer structure
0020               * 2300-23ff     256   >0100   TiVi editor buffer structure
0021               * 2400-24ff     256   >0100   TiVi file handling structure
0022               * 2500-25ff     256   >0100   Free for future use
0023               * 2600-264f      80   >0050   Free for future use
0024               * 2650-2faf    2400   >0960   Frame buffer 80x30
0025               * 2fb0-2fff     160   >00a0   Free for future use
0026               * 3000-3fff    4096   >1000   Index for 2048 lines
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
0181               *--------------------------------------------------------------
0182               * Cartridge header
0183               *--------------------------------------------------------------
0184                       save  >6000,>7fff
0185                       aorg  >6000
0186               
0187 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0188 6006 6010             data  prog0
0189 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0190 6010 0000     prog0   data  0                     ; No more items following
0191 6012 6C10             data  runlib
0192               
0194               
0195 6014 1154             byte  17
0196 6015 ....             text  'TIVI 200126-25485'
0197                       even
0198               
0206               *--------------------------------------------------------------
0207               * Include required files
0208               *--------------------------------------------------------------
0209                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     609E 6C18 
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
     60AA 6744 
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
     60BE 6744 
0078 60C0 0115                   byte 1,21             ; \ .  p0 = YX position
0079 60C2 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0080 60C4 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0081 60C6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0082                                                   ; /         LSB offset for ASCII digit 0-9
0083                       ;------------------------------------------------------
0084                       ; Kernel takes over
0085                       ;------------------------------------------------------
0086 60C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CA 6B26 
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
0008               ***************************************************************
0009               * sams.bank - Switch SAMS memory bank
0010               ***************************************************************
0011               *  bl   @sams.bank
0012               *       data P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = SAMS bank number
0015               *  P1 = Memory address
0016               *--------------------------------------------------------------
0017               *  bl   @xsams.bank
0018               *
0019               *  tmp0 = SAMS bank number
0020               *  tmp1 = Memory address
0021               *--------------------------------------------------------------
0022               *  Register usage
0023               *  r0, tmp0, tmp1, r12
0024               *--------------------------------------------------------------
0025               *  Address      p1/tmp1        Paged area
0026               *  =======      =======        ==========
0027               *  >4004        >04            >2000-2fff
0028               *  >4006        >06            >3000-4fff
0029               *  >4014        >14            >a000-afff
0030               *  >4016        >16            >b000-bfff
0031               *  >4018        >18            >c000-cfff
0032               *  >401a        >1a            >d000-dfff
0033               *  >401c        >1c            >e000-efff
0034               *  >401e        >1e            >f000-ffff
0035               *  Others       Others         Inactive
0036               ********|*****|*********************|**************************
0037               sams.bank:
0038 63E2 C13B  30         mov   *r11+,tmp0            ; Get p0
0039 63E4 C17B  30         mov   *r11+,tmp1            ; Get p1
0040               xsams.bank:
0041               *--------------------------------------------------------------
0042               * Determine SAMS bank
0043               *--------------------------------------------------------------
0044 63E6 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0045 63E8 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0046               *--------------------------------------------------------------
0047               * Switch to specified SAMS bank
0048               *--------------------------------------------------------------
0049               sams.bank.switch:
0050 63EA 020C  20         li    r12,>1e00             ; SAMS CRU address
     63EC 1E00 
0051 63EE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0052 63F0 06C0  14         swpb  r0                    ; LSB to MSB
0053 63F2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0054 63F4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     63F6 4000 
0055 63F8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0056               *--------------------------------------------------------------
0057               * Exit
0058               *--------------------------------------------------------------
0059               sams.bank.exit:
0060 63FA 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               
0065               *--------------------------------------------------------------
0066               * Enable SAMS mapping mode
0067               *--------------------------------------------------------------
0068               sams.mapping.on:
0069 63FC 020C  20         li    r12,>1e00             ; SAMS CRU address
     63FE 1E00 
0070 6400 1D01  20         sbo   1                     ; Enable SAMS mapper
0071 6402 1003  14         jmp   sams.mapping.exit
0072               *--------------------------------------------------------------
0073               * Disable SAMS mapping mode
0074               *--------------------------------------------------------------
0075               sams.mapping.off:
0076 6404 020C  20         li    r12,>1e00             ; SAMS CRU address
     6406 1E00 
0077 6408 1E01  20         sbz   1                     ; Disable SAMS mapper
0078               *--------------------------------------------------------------
0079               * Exit
0080               *--------------------------------------------------------------
0081               sams.mapping.exit:
0082 640A 045B  20         b     *r11                  ; Return to caller
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
0009 640C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     640E FFBF 
0010 6410 0460  28         b     @putv01
     6412 6246 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6414 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6416 0040 
0018 6418 0460  28         b     @putv01
     641A 6246 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 641C 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     641E FFDF 
0026 6420 0460  28         b     @putv01
     6422 6246 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6424 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6426 0020 
0034 6428 0460  28         b     @putv01
     642A 6246 
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
0010 642C 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     642E FFFE 
0011 6430 0460  28         b     @putv01
     6432 6246 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6434 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6436 0001 
0019 6438 0460  28         b     @putv01
     643A 6246 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 643C 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     643E FFFD 
0027 6440 0460  28         b     @putv01
     6442 6246 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6444 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6446 0002 
0035 6448 0460  28         b     @putv01
     644A 6246 
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
0018 644C C83B  50 at      mov   *r11+,@wyx
     644E 832A 
0019 6450 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6452 B820  54 down    ab    @hb$01,@wyx
     6454 6038 
     6456 832A 
0028 6458 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 645A 7820  54 up      sb    @hb$01,@wyx
     645C 6038 
     645E 832A 
0037 6460 045B  20         b     *r11
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
0049 6462 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6464 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6466 832A 
0051 6468 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     646A 832A 
0052 646C 045B  20         b     *r11
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
0021 646E C120  34 yx2px   mov   @wyx,tmp0
     6470 832A 
0022 6472 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6474 06C4  14         swpb  tmp0                  ; Y<->X
0024 6476 04C5  14         clr   tmp1                  ; Clear before copy
0025 6478 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 647A 20A0  38         coc   @wbit1,config         ; f18a present ?
     647C 6044 
0030 647E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6480 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6482 833A 
     6484 64AE 
0032 6486 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6488 0A15  56         sla   tmp1,1                ; X = X * 2
0035 648A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 648C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     648E 0500 
0037 6490 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6492 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6494 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6496 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6498 D105  18         movb  tmp1,tmp0
0051 649A 06C4  14         swpb  tmp0                  ; X<->Y
0052 649C 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     649E 6046 
0053 64A0 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 64A2 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     64A4 6038 
0059 64A6 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     64A8 604A 
0060 64AA 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 64AC 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 64AE 0050            data   80
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
0013 64B0 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 64B2 06A0  32         bl    @putvr                ; Write once
     64B4 6232 
0015 64B6 391C             data  >391c                 ; VR1/57, value 00011100
0016 64B8 06A0  32         bl    @putvr                ; Write twice
     64BA 6232 
0017 64BC 391C             data  >391c                 ; VR1/57, value 00011100
0018 64BE 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 64C0 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 64C2 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     64C4 6232 
0028 64C6 391C             data  >391c
0029 64C8 0458  20         b     *tmp4                 ; Exit
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
0040 64CA C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 64CC 06A0  32         bl    @cpym2v
     64CE 6338 
0042 64D0 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     64D2 650E 
     64D4 0006 
0043 64D6 06A0  32         bl    @putvr
     64D8 6232 
0044 64DA 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 64DC 06A0  32         bl    @putvr
     64DE 6232 
0046 64E0 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 64E2 0204  20         li    tmp0,>3f00
     64E4 3F00 
0052 64E6 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     64E8 61BA 
0053 64EA D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     64EC 8800 
0054 64EE 0984  56         srl   tmp0,8
0055 64F0 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     64F2 8800 
0056 64F4 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 64F6 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 64F8 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     64FA BFFF 
0060 64FC 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 64FE 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6500 4000 
0063               f18chk_exit:
0064 6502 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6504 618E 
0065 6506 3F00             data  >3f00,>00,6
     6508 0000 
     650A 0006 
0066 650C 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 650E 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6510 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6512 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6514 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6516 06A0  32         bl    @putvr
     6518 6232 
0097 651A 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 651C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     651E 6232 
0100 6520 391C             data  >391c                 ; Lock the F18a
0101 6522 0458  20         b     *tmp4                 ; Exit
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
0120 6524 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 6526 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6528 6044 
0122 652A 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 652C C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     652E 8802 
0127 6530 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6532 6232 
0128 6534 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6536 04C4  14         clr   tmp0
0130 6538 D120  34         movb  @vdps,tmp0
     653A 8802 
0131 653C 0984  56         srl   tmp0,8
0132 653E 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6540 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6542 832A 
0018 6544 D17B  28         movb  *r11+,tmp1
0019 6546 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6548 D1BB  28         movb  *r11+,tmp2
0021 654A 0986  56         srl   tmp2,8                ; Repeat count
0022 654C C1CB  18         mov   r11,tmp3
0023 654E 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6550 62FA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6552 020B  20         li    r11,hchar1
     6554 655A 
0028 6556 0460  28         b     @xfilv                ; Draw
     6558 6194 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 655A 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     655C 6048 
0033 655E 1302  14         jeq   hchar2                ; Yes, exit
0034 6560 C2C7  18         mov   tmp3,r11
0035 6562 10EE  14         jmp   hchar                 ; Next one
0036 6564 05C7  14 hchar2  inct  tmp3
0037 6566 0457  20         b     *tmp3                 ; Exit
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
0016 6568 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     656A 6046 
0017 656C 020C  20         li    r12,>0024
     656E 0024 
0018 6570 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6572 6600 
0019 6574 04C6  14         clr   tmp2
0020 6576 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6578 04CC  14         clr   r12
0025 657A 1F08  20         tb    >0008                 ; Shift-key ?
0026 657C 1302  14         jeq   realk1                ; No
0027 657E 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6580 6630 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6582 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6584 1302  14         jeq   realk2                ; No
0033 6586 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6588 6660 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 658A 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 658C 1302  14         jeq   realk3                ; No
0039 658E 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6590 6690 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6592 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6594 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6596 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6598 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     659A 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 659C 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 659E 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     65A0 0006 
0052 65A2 0606  14 realk5  dec   tmp2
0053 65A4 020C  20         li    r12,>24               ; CRU address for P2-P4
     65A6 0024 
0054 65A8 06C6  14         swpb  tmp2
0055 65AA 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 65AC 06C6  14         swpb  tmp2
0057 65AE 020C  20         li    r12,6                 ; CRU read address
     65B0 0006 
0058 65B2 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 65B4 0547  14         inv   tmp3                  ;
0060 65B6 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     65B8 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 65BA 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 65BC 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 65BE 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 65C0 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 65C2 0285  22         ci    tmp1,8
     65C4 0008 
0069 65C6 1AFA  14         jl    realk6
0070 65C8 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 65CA 1BEB  14         jh    realk5                ; No, next column
0072 65CC 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 65CE C206  18 realk8  mov   tmp2,tmp4
0077 65D0 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 65D2 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 65D4 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 65D6 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 65D8 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 65DA D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 65DC 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     65DE 6046 
0087 65E0 1608  14         jne   realka                ; No, continue saving key
0088 65E2 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     65E4 662A 
0089 65E6 1A05  14         jl    realka
0090 65E8 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     65EA 6628 
0091 65EC 1B02  14         jh    realka                ; No, continue
0092 65EE 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     65F0 E000 
0093 65F2 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     65F4 833C 
0094 65F6 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     65F8 6030 
0095 65FA 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     65FC 8C00 
0096 65FE 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 6600 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6602 0000 
     6604 FF0D 
     6606 203D 
0099 6608 ....             text  'xws29ol.'
0100 6610 ....             text  'ced38ik,'
0101 6618 ....             text  'vrf47ujm'
0102 6620 ....             text  'btg56yhn'
0103 6628 ....             text  'zqa10p;/'
0104 6630 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6632 0000 
     6634 FF0D 
     6636 202B 
0105 6638 ....             text  'XWS@(OL>'
0106 6640 ....             text  'CED#*IK<'
0107 6648 ....             text  'VRF$&UJM'
0108 6650 ....             text  'BTG%^YHN'
0109 6658 ....             text  'ZQA!)P:-'
0110 6660 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6662 0000 
     6664 FF0D 
     6666 2005 
0111 6668 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     666A 0804 
     666C 0F27 
     666E C2B9 
0112 6670 600B             data  >600b,>0907,>063f,>c1B8
     6672 0907 
     6674 063F 
     6676 C1B8 
0113 6678 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     667A 7B02 
     667C 015F 
     667E C0C3 
0114 6680 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6682 7D0E 
     6684 0CC6 
     6686 BFC4 
0115 6688 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     668A 7C03 
     668C BC22 
     668E BDBA 
0116 6690 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6692 0000 
     6694 FF0D 
     6696 209D 
0117 6698 9897             data  >9897,>93b2,>9f8f,>8c9B
     669A 93B2 
     669C 9F8F 
     669E 8C9B 
0118 66A0 8385             data  >8385,>84b3,>9e89,>8b80
     66A2 84B3 
     66A4 9E89 
     66A6 8B80 
0119 66A8 9692             data  >9692,>86b4,>b795,>8a8D
     66AA 86B4 
     66AC B795 
     66AE 8A8D 
0120 66B0 8294             data  >8294,>87b5,>b698,>888E
     66B2 87B5 
     66B4 B698 
     66B6 888E 
0121 66B8 9A91             data  >9a91,>81b1,>b090,>9cBB
     66BA 81B1 
     66BC B090 
     66BE 9CBB 
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
0023 66C0 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 66C2 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     66C4 8340 
0025 66C6 04E0  34         clr   @waux1
     66C8 833C 
0026 66CA 04E0  34         clr   @waux2
     66CC 833E 
0027 66CE 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     66D0 833C 
0028 66D2 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 66D4 0205  20         li    tmp1,4                ; 4 nibbles
     66D6 0004 
0033 66D8 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 66DA 0246  22         andi  tmp2,>000f            ; Only keep LSN
     66DC 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 66DE 0286  22         ci    tmp2,>000a
     66E0 000A 
0039 66E2 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 66E4 C21B  26         mov   *r11,tmp4
0045 66E6 0988  56         srl   tmp4,8                ; Right justify
0046 66E8 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     66EA FFF6 
0047 66EC 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 66EE C21B  26         mov   *r11,tmp4
0054 66F0 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     66F2 00FF 
0055               
0056 66F4 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 66F6 06C6  14         swpb  tmp2
0058 66F8 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 66FA 0944  56         srl   tmp0,4                ; Next nibble
0060 66FC 0605  14         dec   tmp1
0061 66FE 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6700 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6702 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6704 C160  34         mov   @waux3,tmp1           ; Get pointer
     6706 8340 
0067 6708 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 670A 0585  14         inc   tmp1                  ; Next byte, not word!
0069 670C C120  34         mov   @waux2,tmp0
     670E 833E 
0070 6710 06C4  14         swpb  tmp0
0071 6712 DD44  32         movb  tmp0,*tmp1+
0072 6714 06C4  14         swpb  tmp0
0073 6716 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6718 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     671A 8340 
0078 671C D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     671E 603C 
0079 6720 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6722 C120  34         mov   @waux1,tmp0
     6724 833C 
0084 6726 06C4  14         swpb  tmp0
0085 6728 DD44  32         movb  tmp0,*tmp1+
0086 672A 06C4  14         swpb  tmp0
0087 672C DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 672E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6730 6046 
0092 6732 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6734 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6736 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6738 7FFF 
0098 673A C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     673C 8340 
0099 673E 0460  28         b     @xutst0               ; Display string
     6740 6320 
0100 6742 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6744 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6746 832A 
0122 6748 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     674A 8000 
0123 674C 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 674E 0207  20 mknum   li    tmp3,5                ; Digit counter
     6750 0005 
0020 6752 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6754 C155  26         mov   *tmp1,tmp1            ; /
0022 6756 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6758 0228  22         ai    tmp4,4                ; Get end of buffer
     675A 0004 
0024 675C 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     675E 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6760 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6762 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6764 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6766 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6768 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 676A C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 676C 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 676E 0607  14         dec   tmp3                  ; Decrease counter
0036 6770 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6772 0207  20         li    tmp3,4                ; Check first 4 digits
     6774 0004 
0041 6776 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6778 C11B  26         mov   *r11,tmp0
0043 677A 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 677C 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 677E 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6780 05CB  14 mknum3  inct  r11
0047 6782 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6784 6046 
0048 6786 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6788 045B  20         b     *r11                  ; Exit
0050 678A DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 678C 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 678E 13F8  14         jeq   mknum3                ; Yes, exit
0053 6790 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6792 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6794 7FFF 
0058 6796 C10B  18         mov   r11,tmp0
0059 6798 0224  22         ai    tmp0,-4
     679A FFFC 
0060 679C C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 679E 0206  20         li    tmp2,>0500            ; String length = 5
     67A0 0500 
0062 67A2 0460  28         b     @xutstr               ; Display string
     67A4 6322 
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
0092 67A6 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 67A8 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 67AA C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 67AC 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 67AE 0207  20         li    tmp3,5                ; Set counter
     67B0 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 67B2 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 67B4 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 67B6 0584  14         inc   tmp0                  ; Next character
0104 67B8 0607  14         dec   tmp3                  ; Last digit reached ?
0105 67BA 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 67BC 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 67BE 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 67C0 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 67C2 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 67C4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 67C6 0607  14         dec   tmp3                  ; Last character ?
0120 67C8 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 67CA 045B  20         b     *r11                  ; Return
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
0138 67CC C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     67CE 832A 
0139 67D0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     67D2 8000 
0140 67D4 10BC  14         jmp   mknum                 ; Convert number and display
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
0074 67D6 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 67D8 C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 67DA C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 67DC 0649  14         dect  stack
0079 67DE C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 67E0 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 67E2 04C8  14         clr   tmp4                  ; Repeat counter
0086 67E4 04E0  34         clr   @waux1                ; Length of RLE string
     67E6 833C 
0087 67E8 04E0  34         clr   @waux2                ; Address of encoding byte
     67EA 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 67EC 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 67EE D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 67F0 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 67F2 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 67F4 C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 67F6 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 67F8 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     67FA 0001 
0105 67FC 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 67FE 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 6800 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 6802 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 6804 06A0  32         bl    @cpu2rle.flush.duplicates
     6806 6850 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 6808 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     680A 833E 
     680C 833E 
0126 680E 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 6810 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     6812 833E 
0129 6814 0585  14         inc   tmp1                  ; Skip encoding byte
0130 6816 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     6818 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 681A DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 681C 05A0  34         inc   @waux1                ; RLE string length += 1
     681E 833C 
0136 6820 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 6822 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     6824 833E 
     6826 833E 
0145 6828 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 682A 06A0  32         bl    @cpu2rle.flush.encoding_byte
     682C 686A 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 682E 0588  14         inc   tmp4                  ; Increase repeat counter
0155 6830 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 6832 0606  14         dec   tmp2
0162 6834 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 6836 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 6838 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 683A 06A0  32         bl    @cpu2rle.flush.duplicates
     683C 6850 
0175                                                   ; (3.2) Flush pending ...
0176 683E 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 6840 C820  54         mov   @waux2,@waux2
     6842 833E 
     6844 833E 
0182 6846 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 6848 06A0  32         bl    @cpu2rle.flush.encoding_byte
     684A 686A 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 684C 0460  28         b     @poprt                ; Return
     684E 6132 
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
0204 6850 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 6852 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 6854 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 6856 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     6858 8000 
0210 685A DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 685C 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 685E DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 6860 05E0  34         inct  @waux1                ; RLE string length += 2
     6862 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 6864 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 6866 04C8  14         clr   tmp4                  ; Clear repeat count
0220 6868 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 686A 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 686C C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 686E C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 6870 61E0  34         s     @waux2,tmp3           ; | characters
     6872 833E 
0232 6874 0607  14         dec   tmp3                  ; /
0233               
0234 6876 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 6878 C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     687A 833E 
0236 687C D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 687E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6880 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6882 833E 
0240 6884 04C8  14         clr   tmp4                  ; Clear before exit
0241 6886 045B  20         b     *r11                  ; Return
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
0031 6888 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 688A C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 688C C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 688E 0649  14         dect  stack
0036 6890 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6892 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 6894 0606  14         dec   tmp2                  ; Update length
0043 6896 131E  14         jeq   rle2cpu.exit          ; End of list
0044 6898 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 689A 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 689C 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 689E 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 68A0 0649  14         dect  stack
0055 68A2 C646  30         mov   tmp2,*stack           ; Push tmp2
0056 68A4 C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 68A6 06A0  32         bl    @xpym2m               ; Block copy to destination
     68A8 6386 
0059                                                   ; \ .  tmp0 = Source address
0060                                                   ; | .  tmp1 = Target address
0061                                                   ; / .  tmp2 = Bytes to copy
0062               
0063 68AA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 68AC 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 68AE 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 68B0 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 68B2 0649  14         dect  stack
0073 68B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0074 68B6 0649  14         dect  stack
0075 68B8 C646  30         mov   tmp2,*stack           ; Push tmp2
0076 68BA 0649  14         dect  stack
0077 68BC C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 68BE C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 68C0 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 68C2 0985  56         srl   tmp1,8                ; Right align
0082               
0083 68C4 06A0  32         bl    @xfilm                ; Block fill to destination
     68C6 613C 
0084                                                   ; \ .  tmp0 = Target address
0085                                                   ; | .  tmp1 = Byte to fill
0086                                                   ; / .  tmp2 = Repeat count
0087               
0088 68C8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 68CA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 68CC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 68CE A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 68D0 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 68D2 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 68D4 0460  28         b     @poprt                ; Return
     68D6 6132 
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
0020 68D8 C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     68DA 2000 
0021 68DC C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     68DE 2002 
0022 68E0 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     68E2 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 68E4 0200  20         li    r0,>8306              ; Scratpad source address
     68E6 8306 
0027 68E8 0201  20         li    r1,>2006              ; RAM target address
     68EA 2006 
0028 68EC 0202  20         li    r2,62                 ; Loop counter
     68EE 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 68F0 CC70  46         mov   *r0+,*r1+
0034 68F2 CC70  46         mov   *r0+,*r1+
0035 68F4 0642  14         dect  r2
0036 68F6 16FC  14         jne   cpu.scrpad.backup.copy
0037 68F8 C820  54         mov   @>83fe,@>20fe         ; Copy last word
     68FA 83FE 
     68FC 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 68FE C020  34         mov   @>2000,r0             ; Restore r0
     6900 2000 
0042 6902 C060  34         mov   @>2002,r1             ; Restore r1
     6904 2002 
0043 6906 C0A0  34         mov   @>2004,r2             ; Restore r2
     6908 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 690A 045B  20         b     *r11                  ; Return to caller
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
0066 690C C820  54         mov   @>2000,@>8300
     690E 2000 
     6910 8300 
0067 6912 C820  54         mov   @>2002,@>8302
     6914 2002 
     6916 8302 
0068 6918 C820  54         mov   @>2004,@>8304
     691A 2004 
     691C 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 691E C800  38         mov   r0,@>2000
     6920 2000 
0073 6922 C801  38         mov   r1,@>2002
     6924 2002 
0074 6926 C802  38         mov   r2,@>2004
     6928 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 692A 0200  20         li    r0,>2006
     692C 2006 
0079 692E 0201  20         li    r1,>8306
     6930 8306 
0080 6932 0202  20         li    r2,62
     6934 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 6936 CC70  46         mov   *r0+,*r1+
0086 6938 CC70  46         mov   *r0+,*r1+
0087 693A 0642  14         dect  r2
0088 693C 16FC  14         jne   cpu.scrpad.restore.copy
0089 693E C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6940 20FE 
     6942 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 6944 C020  34         mov   @>2000,r0             ; Restore r0
     6946 2000 
0094 6948 C060  34         mov   @>2002,r1             ; Restore r1
     694A 2002 
0095 694C C0A0  34         mov   @>2004,r2             ; Restore r2
     694E 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6950 045B  20         b     *r11                  ; Return to caller
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
0013               *  DATA p0
0014               *  P0 = CPU memory destination
0015               *--------------------------------------------------------------
0016               *  bl   @memx.scrpad.pgout
0017               *  TMP1 = CPU memory destination
0018               *--------------------------------------------------------------
0019               *  Register usage
0020               *  tmp0-tmp2 = Used as temporary registers
0021               *  tmp3      = Copy of CPU memory destination
0022               ********|*****|*********************|**************************
0023               cpu.scrpad.pgout:
0024 6952 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xcpu.scrpad.pgout:
0029 6954 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6956 8300 
0030 6958 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 695A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     695C 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 695E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6960 0606  14         dec   tmp2
0037 6962 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6964 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6966 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6968 696E 
0043                                                   ; R14=PC
0044 696A 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 696C 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               cpu.scrpad.pgout.after.rtwp:
0054 696E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6970 690C 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cpu.scrpad.pgout.$$:
0060 6972 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               ***************************************************************
0064               * cpu.scrpad.pgin - Page in scratchpad memory
0065               ***************************************************************
0066               *  bl   @cpu.scrpad.pgin
0067               *  DATA p0
0068               *  P0 = CPU memory source
0069               *--------------------------------------------------------------
0070               *  bl   @memx.scrpad.pgin
0071               *  TMP1 = CPU memory source
0072               *--------------------------------------------------------------
0073               *  Register usage
0074               *  tmp0-tmp2 = Used as temporary registers
0075               ********|*****|*********************|**************************
0076               cpu.scrpad.pgin:
0077 6974 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xcpu.scrpad.pgin:
0082 6976 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6978 8300 
0083 697A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     697C 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 697E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6980 0606  14         dec   tmp2
0089 6982 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6984 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6986 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               cpu.scrpad.pgin.$$:
0098 6988 045B  20         b     *r11                  ; Return to caller
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
0041 698A 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 698C 698E             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 698E C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6990 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6992 8322 
0049 6994 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6996 6042 
0050 6998 C020  34         mov   @>8356,r0             ; get ptr to pab
     699A 8356 
0051 699C C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 699E 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     69A0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 69A2 06C0  14         swpb  r0                    ;
0059 69A4 D800  38         movb  r0,@vdpa              ; send low byte
     69A6 8C02 
0060 69A8 06C0  14         swpb  r0                    ;
0061 69AA D800  38         movb  r0,@vdpa              ; send high byte
     69AC 8C02 
0062 69AE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     69B0 8800 
0063                       ;---------------------------; Inline VSBR end
0064 69B2 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 69B4 0704  14         seto  r4                    ; init counter
0070 69B6 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     69B8 2420 
0071 69BA 0580  14 !       inc   r0                    ; point to next char of name
0072 69BC 0584  14         inc   r4                    ; incr char counter
0073 69BE 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     69C0 0007 
0074 69C2 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 69C4 80C4  18         c     r4,r3                 ; end of name?
0077 69C6 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 69C8 06C0  14         swpb  r0                    ;
0082 69CA D800  38         movb  r0,@vdpa              ; send low byte
     69CC 8C02 
0083 69CE 06C0  14         swpb  r0                    ;
0084 69D0 D800  38         movb  r0,@vdpa              ; send high byte
     69D2 8C02 
0085 69D4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     69D6 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 69D8 DC81  32         movb  r1,*r2+               ; move into buffer
0092 69DA 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     69DC 6A9E 
0093 69DE 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 69E0 C104  18         mov   r4,r4                 ; Check if length = 0
0099 69E2 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 69E4 04E0  34         clr   @>83d0
     69E6 83D0 
0102 69E8 C804  38         mov   r4,@>8354             ; save name length for search
     69EA 8354 
0103 69EC 0584  14         inc   r4                    ; adjust for dot
0104 69EE A804  38         a     r4,@>8356             ; point to position after name
     69F0 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 69F2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     69F4 83E0 
0110 69F6 04C1  14         clr   r1                    ; version found of dsr
0111 69F8 020C  20         li    r12,>0f00             ; init cru addr
     69FA 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 69FC C30C  18         mov   r12,r12               ; anything to turn off?
0117 69FE 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6A00 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6A02 022C  22         ai    r12,>0100             ; next rom to turn on
     6A04 0100 
0125 6A06 04E0  34         clr   @>83d0                ; clear in case we are done
     6A08 83D0 
0126 6A0A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6A0C 2000 
0127 6A0E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6A10 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6A12 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6A14 1D00  20         sbo   0                     ; turn on rom
0134 6A16 0202  20         li    r2,>4000              ; start at beginning of rom
     6A18 4000 
0135 6A1A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6A1C 6A9A 
0136 6A1E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6A20 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6A22 240A 
0146 6A24 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6A26 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6A28 83D2 
0152 6A2A 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6A2C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6A2E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6A30 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6A32 83D2 
0161 6A34 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6A36 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6A38 04C5  14         clr   r5                    ; Remove any old stuff
0167 6A3A D160  34         movb  @>8355,r5             ; get length as counter
     6A3C 8355 
0168 6A3E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6A40 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6A42 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6A44 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6A46 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6A48 2420 
0175 6A4A 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6A4C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6A4E 0605  14         dec   r5                    ; loop until full length checked
0179 6A50 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6A52 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6A54 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6A56 0581  14         inc   r1                    ; next version found
0191 6A58 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6A5A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6A5C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6A5E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6A60 2400 
0200 6A62 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6A64 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6A66 8322 
0202                                                   ; (8 or >a)
0203 6A68 0281  22         ci    r1,8                  ; was it 8?
     6A6A 0008 
0204 6A6C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6A6E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6A70 8350 
0206                                                   ; Get error byte from @>8350
0207 6A72 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6A74 06C0  14         swpb  r0                    ;
0215 6A76 D800  38         movb  r0,@vdpa              ; send low byte
     6A78 8C02 
0216 6A7A 06C0  14         swpb  r0                    ;
0217 6A7C D800  38         movb  r0,@vdpa              ; send high byte
     6A7E 8C02 
0218 6A80 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6A82 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6A84 09D1  56         srl   r1,13                 ; just keep error bits
0226 6A86 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6A88 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6A8A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6A8C 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6A8E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6A90 06C1  14         swpb  r1                    ; put error in hi byte
0239 6A92 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6A94 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6A96 6042 
0241 6A98 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6A9A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6A9C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6A9E ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6AA0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6AA2 C04B  18         mov   r11,r1                ; Save return address
0049 6AA4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6AA6 2428 
0050 6AA8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6AAA 04C5  14         clr   tmp1                  ; io.op.open
0052 6AAC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6AAE 61CC 
0053               file.open_init:
0054 6AB0 0220  22         ai    r0,9                  ; Move to file descriptor length
     6AB2 0009 
0055 6AB4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6AB6 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6AB8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6ABA 698A 
0061 6ABC 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6ABE 1029  14         jmp   file.record.pab.details
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
0090 6AC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6AC2 C04B  18         mov   r11,r1                ; Save return address
0096 6AC4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6AC6 2428 
0097 6AC8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6ACA 0205  20         li    tmp1,io.op.close      ; io.op.close
     6ACC 0001 
0099 6ACE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6AD0 61CC 
0100               file.close_init:
0101 6AD2 0220  22         ai    r0,9                  ; Move to file descriptor length
     6AD4 0009 
0102 6AD6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6AD8 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6ADA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6ADC 698A 
0108 6ADE 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6AE0 1018  14         jmp   file.record.pab.details
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
0139 6AE2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6AE4 C04B  18         mov   r11,r1                ; Save return address
0145 6AE6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6AE8 2428 
0146 6AEA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6AEC 0205  20         li    tmp1,io.op.read       ; io.op.read
     6AEE 0002 
0148 6AF0 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6AF2 61CC 
0149               file.record.read_init:
0150 6AF4 0220  22         ai    r0,9                  ; Move to file descriptor length
     6AF6 0009 
0151 6AF8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6AFA 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6AFC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6AFE 698A 
0157 6B00 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6B02 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6B04 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6B06 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6B08 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6B0A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6B0C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6B0E 1000  14         nop
0191               
0192               
0193               file.status:
0194 6B10 1000  14         nop
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
0211 6B12 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6B14 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6B16 2428 
0219 6B18 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6B1A 0005 
0220 6B1C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6B1E 61E4 
0221 6B20 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6B22 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6B24 0451  20         b     *r1                   ; Return to caller
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
0020 6B26 0300  24 tmgr    limi  0                     ; No interrupt processing
     6B28 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6B2A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6B2C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6B2E 2360  38         coc   @wbit2,r13            ; C flag on ?
     6B30 6042 
0029 6B32 1602  14         jne   tmgr1a                ; No, so move on
0030 6B34 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6B36 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6B38 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6B3A 6046 
0035 6B3C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6B3E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6B40 6036 
0048 6B42 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6B44 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6B46 6034 
0050 6B48 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6B4A 0460  28         b     @kthread              ; Run kernel thread
     6B4C 6BC4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6B4E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6B50 603A 
0056 6B52 13EB  14         jeq   tmgr1
0057 6B54 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6B56 6038 
0058 6B58 16E8  14         jne   tmgr1
0059 6B5A C120  34         mov   @wtiusr,tmp0
     6B5C 832E 
0060 6B5E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6B60 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6B62 6BC2 
0065 6B64 C10A  18         mov   r10,tmp0
0066 6B66 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6B68 00FF 
0067 6B6A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6B6C 6042 
0068 6B6E 1303  14         jeq   tmgr5
0069 6B70 0284  22         ci    tmp0,60               ; 1 second reached ?
     6B72 003C 
0070 6B74 1002  14         jmp   tmgr6
0071 6B76 0284  22 tmgr5   ci    tmp0,50
     6B78 0032 
0072 6B7A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6B7C 1001  14         jmp   tmgr8
0074 6B7E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6B80 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6B82 832C 
0079 6B84 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6B86 FF00 
0080 6B88 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6B8A 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6B8C 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6B8E 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6B90 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6B92 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6B94 830C 
     6B96 830D 
0089 6B98 1608  14         jne   tmgr10                ; No, get next slot
0090 6B9A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6B9C FF00 
0091 6B9E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6BA0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6BA2 8330 
0096 6BA4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6BA6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6BA8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6BAA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6BAC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6BAE 8315 
     6BB0 8314 
0103 6BB2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6BB4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6BB6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6BB8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6BBA 10F7  14         jmp   tmgr10                ; Process next slot
0108 6BBC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6BBE FF00 
0109 6BC0 10B4  14         jmp   tmgr1
0110 6BC2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6BC4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6BC6 6036 
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
0041 6BC8 06A0  32         bl    @realkb               ; Scan full keyboard
     6BCA 6568 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6BCC 0460  28         b     @tmgr3                ; Exit
     6BCE 6B4E 
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
0017 6BD0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6BD2 832E 
0018 6BD4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6BD6 6038 
0019 6BD8 045B  20 mkhoo1  b     *r11                  ; Return
0020      6B2A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6BDA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6BDC 832E 
0029 6BDE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6BE0 FEFF 
0030 6BE2 045B  20         b     *r11                  ; Return
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
0017 6BE4 C13B  30 mkslot  mov   *r11+,tmp0
0018 6BE6 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6BE8 C184  18         mov   tmp0,tmp2
0023 6BEA 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6BEC A1A0  34         a     @wtitab,tmp2          ; Add table base
     6BEE 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6BF0 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6BF2 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6BF4 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6BF6 881B  46         c     *r11,@w$ffff          ; End of list ?
     6BF8 6048 
0035 6BFA 1301  14         jeq   mkslo1                ; Yes, exit
0036 6BFC 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6BFE 05CB  14 mkslo1  inct  r11
0041 6C00 045B  20         b     *r11                  ; Exit
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
0052 6C02 C13B  30 clslot  mov   *r11+,tmp0
0053 6C04 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6C06 A120  34         a     @wtitab,tmp0          ; Add table base
     6C08 832C 
0055 6C0A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6C0C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6C0E 045B  20         b     *r11                  ; Exit
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
0250 6C10 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6C12 68D8 
0251 6C14 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6C16 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6C18 0300  24 runli1  limi  0                     ; Turn off interrupts
     6C1A 0000 
0259 6C1C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6C1E 8300 
0260 6C20 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6C22 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6C24 0202  20 runli2  li    r2,>8308
     6C26 8308 
0265 6C28 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6C2A 0282  22         ci    r2,>8400
     6C2C 8400 
0267 6C2E 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6C30 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6C32 FFFF 
0273 6C34 1602  14         jne   runli4                ; No, continue
0274 6C36 0420  54         blwp  @0                    ; Yes, bye bye
     6C38 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6C3A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6C3C 833C 
0279 6C3E 04C1  14         clr   r1                    ; Reset counter
0280 6C40 0202  20         li    r2,10                 ; We test 10 times
     6C42 000A 
0281 6C44 C0E0  34 runli5  mov   @vdps,r3
     6C46 8802 
0282 6C48 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6C4A 6046 
0283 6C4C 1302  14         jeq   runli6
0284 6C4E 0581  14         inc   r1                    ; Increase counter
0285 6C50 10F9  14         jmp   runli5
0286 6C52 0602  14 runli6  dec   r2                    ; Next test
0287 6C54 16F7  14         jne   runli5
0288 6C56 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6C58 1250 
0289 6C5A 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6C5C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6C5E 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6C60 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6C62 6120 
0295 6C64 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6C66 8322 
0296 6C68 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6C6A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6C6C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6C6E 04C1  14 runli9  clr   r1
0303 6C70 04C2  14         clr   r2
0304 6C72 04C3  14         clr   r3
0305 6C74 0209  20         li    stack,>8400           ; Set stack
     6C76 8400 
0306 6C78 020F  20         li    r15,vdpw              ; Set VDP write address
     6C7A 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6C7C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6C7E 4A4A 
0315 6C80 1605  14         jne   runlia
0316 6C82 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6C84 618E 
0317 6C86 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6C88 0000 
     6C8A 3FFF 
0322 6C8C 06A0  32 runlia  bl    @filv
     6C8E 618E 
0323 6C90 0FC0             data  pctadr,spfclr,16      ; Load color table
     6C92 00F4 
     6C94 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6C96 06A0  32         bl    @f18unl               ; Unlock the F18A
     6C98 64B0 
0331 6C9A 06A0  32         bl    @f18chk               ; Check if F18A is there
     6C9C 64CA 
0332 6C9E 06A0  32         bl    @f18lck               ; Lock the F18A again
     6CA0 64C0 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6CA2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6CA4 61F8 
0346 6CA6 6116             data  spvmod                ; Equate selected video mode table
0347 6CA8 0204  20         li    tmp0,spfont           ; Get font option
     6CAA 000C 
0348 6CAC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6CAE 1304  14         jeq   runlid                ; Yes, skip it
0350 6CB0 06A0  32         bl    @ldfnt
     6CB2 6260 
0351 6CB4 1100             data  fntadr,spfont         ; Load specified font
     6CB6 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6CB8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6CBA 4A4A 
0356 6CBC 1602  14         jne   runlie                ; No, continue
0357 6CBE 0460  28         b     @crash.main           ; Yes, back to crash handler
     6CC0 60A0 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6CC2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6CC4 0040 
0362 6CC6 0460  28         b     @main                 ; Give control to main program
     6CC8 6CCA 
**** **** ****     > tivi.asm.25485
0210               
0211               *--------------------------------------------------------------
0212               * Video mode configuration
0213               *--------------------------------------------------------------
0214      6116     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0215      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0216      0050     colrow  equ   80                    ; Columns per row
0217      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0218      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0219      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0220      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0221               
0222               
0223               ***************************************************************
0224               * Main
0225               ********|*****|*********************|**************************
0226 6CCA 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6CCC 6044 
0227 6CCE 1302  14         jeq   main.continue
0228 6CD0 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6CD2 0000 
0229               
0230               main.continue:
0231 6CD4 06A0  32         bl    @scroff               ; Turn screen off
     6CD6 640C 
0232 6CD8 06A0  32         bl    @f18unl               ; Unlock the F18a
     6CDA 64B0 
0233 6CDC 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6CDE 6232 
0234 6CE0 3140                   data >3140            ; F18a VR49 (>31), bit 40
0235                       ;------------------------------------------------------
0236                       ; Initialize VDP SIT
0237                       ;------------------------------------------------------
0238 6CE2 06A0  32         bl    @filv
     6CE4 618E 
0239 6CE6 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6CE8 0020 
     6CEA 09B0 
0240 6CEC 06A0  32         bl    @scron                ; Turn screen on
     6CEE 6414 
0241                       ;------------------------------------------------------
0242                       ; Initialize low + high memory expansion
0243                       ;------------------------------------------------------
0244 6CF0 06A0  32         bl    @film
     6CF2 6136 
0245 6CF4 2200                   data >2200,00,8*1024-256*2
     6CF6 0000 
     6CF8 3E00 
0246                                                   ; Clear part of 8k low-memory
0247               
0248 6CFA 06A0  32         bl    @film
     6CFC 6136 
0249 6CFE A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6D00 0000 
     6D02 6000 
0250                       ;------------------------------------------------------
0251                       ; Setup cursor, screen, etc.
0252                       ;------------------------------------------------------
0253 6D04 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6D06 642C 
0254 6D08 06A0  32         bl    @s8x8                 ; Small sprite
     6D0A 643C 
0255               
0256 6D0C 06A0  32         bl    @cpym2m
     6D0E 6380 
0257 6D10 7A00                   data romsat,ramsat,4  ; Load sprite SAT
     6D12 8380 
     6D14 0004 
0258               
0259 6D16 C820  54         mov   @romsat+2,@fb.curshape
     6D18 7A02 
     6D1A 2210 
0260                                                   ; Save cursor shape & color
0261               
0262 6D1C 06A0  32         bl    @cpym2v
     6D1E 6338 
0263 6D20 1800                   data sprpdt,cursors,3*8
     6D22 7A04 
     6D24 0018 
0264                                                   ; Load sprite cursor patterns
0265               *--------------------------------------------------------------
0266               * Initialize
0267               *--------------------------------------------------------------
0268 6D26 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6D28 7674 
0269 6D2A 06A0  32         bl    @idx.init             ; Initialize index
     6D2C 75AE 
0270 6D2E 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6D30 74D2 
0271               
0272 6D32 06A0  32         bl    @sams.mapping.on      ; Turn SAMS mapping mode on
     6D34 63FC 
0273               
0274 6D36 06A0  32         bl    @sams.bank            ; \ Switch to SAMS bank
     6D38 63E2 
0275 6D3A 0001                   data 1,>a000          ; | .  p0 = SAMS bank 1
     6D3C A000 
0276                                                   ; / .  p1 = Memory range >a000-afff
0277               
0278 6D3E 06A0  32         bl    @sams.mapping.off     ; Turn SAMS mapping mode off
     6D40 6404 
0279               
0280                       ;-------------------------------------------------------
0281                       ; Setup editor tasks & hook
0282                       ;-------------------------------------------------------
0283 6D42 0204  20         li    tmp0,>0200
     6D44 0200 
0284 6D46 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6D48 8314 
0285               
0286 6D4A 06A0  32         bl    @at
     6D4C 644C 
0287 6D4E 0000             data  >0000                 ; Cursor YX position = >0000
0288               
0289 6D50 0204  20         li    tmp0,timers
     6D52 8370 
0290 6D54 C804  38         mov   tmp0,@wtitab
     6D56 832C 
0291               
0292 6D58 06A0  32         bl    @mkslot
     6D5A 6BE4 
0293 6D5C 0001                   data >0001,task0      ; Task 0 - Update screen
     6D5E 734C 
0294 6D60 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6D62 73D0 
0295 6D64 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6D66 73DE 
     6D68 FFFF 
0296               
0297 6D6A 06A0  32         bl    @mkhook
     6D6C 6BD0 
0298 6D6E 6D74                   data editor           ; Setup user hook
0299               
0300 6D70 0460  28         b     @tmgr                 ; Start timers and kthread
     6D72 6B26 
0301               
0302               
0303               ****************************************************************
0304               * Editor - Main loop
0305               ****************************************************************
0306 6D74 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6D76 6030 
0307 6D78 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0308               *---------------------------------------------------------------
0309               * Identical key pressed ?
0310               *---------------------------------------------------------------
0311 6D7A 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6D7C 6030 
0312 6D7E 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6D80 833C 
     6D82 833E 
0313 6D84 1308  14         jeq   ed_wait
0314               *--------------------------------------------------------------
0315               * New key pressed
0316               *--------------------------------------------------------------
0317               ed_new_key
0318 6D86 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6D88 833C 
     6D8A 833E 
0319 6D8C 1045  14         jmp   edkey                 ; Process key
0320               *--------------------------------------------------------------
0321               * Clear keyboard buffer if no key pressed
0322               *--------------------------------------------------------------
0323               ed_clear_kbbuffer
0324 6D8E 04E0  34         clr   @waux1
     6D90 833C 
0325 6D92 04E0  34         clr   @waux2
     6D94 833E 
0326               *--------------------------------------------------------------
0327               * Delay to avoid key bouncing
0328               *--------------------------------------------------------------
0329               ed_wait
0330 6D96 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6D98 0708 
0331                       ;------------------------------------------------------
0332                       ; Delay loop
0333                       ;------------------------------------------------------
0334               ed_wait_loop
0335 6D9A 0604  14         dec   tmp0
0336 6D9C 16FE  14         jne   ed_wait_loop
0337               *--------------------------------------------------------------
0338               * Exit
0339               *--------------------------------------------------------------
0340 6D9E 0460  28 ed_exit b     @hookok               ; Return
     6DA0 6B2A 
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
0055 6DA2 0D00             data  key_enter,edkey.action.enter          ; New line
     6DA4 7206 
0056 6DA6 0800             data  key_left,edkey.action.left            ; Move cursor left
     6DA8 6E3A 
0057 6DAA 0900             data  key_right,edkey.action.right          ; Move cursor right
     6DAC 6E50 
0058 6DAE 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6DB0 6E68 
0059 6DB2 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6DB4 6EBA 
0060 6DB6 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6DB8 6F26 
0061 6DBA 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6DBC 6F3E 
0062 6DBE 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6DC0 6F52 
0063 6DC2 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6DC4 6FA4 
0064 6DC6 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6DC8 7004 
0065 6DCA 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6DCC 704E 
0066 6DCE 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6DD0 707A 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 6DD2 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6DD4 70A8 
0071 6DD6 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6DD8 70E0 
0072 6DDA 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6DDC 7114 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 6DDE 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6DE0 716C 
0077 6DE2 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6DE4 7274 
0078 6DE6 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6DE8 71C2 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 6DEA 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6DEC 72C4 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 6DEE B000             data  key_buf0,edkey.action.buffer0
     6DF0 7310 
0087 6DF2 B100             data  key_buf1,edkey.action.buffer1
     6DF4 7316 
0088 6DF6 B200             data  key_buf2,edkey.action.buffer2
     6DF8 731C 
0089 6DFA B300             data  key_buf3,edkey.action.buffer3
     6DFC 7322 
0090 6DFE B400             data  key_buf4,edkey.action.buffer4
     6E00 7328 
0091 6E02 B500             data  key_buf5,edkey.action.buffer5
     6E04 732E 
0092 6E06 B600             data  key_buf6,edkey.action.buffer6
     6E08 7334 
0093 6E0A B700             data  key_buf7,edkey.action.buffer7
     6E0C 733A 
0094 6E0E 9E00             data  key_buf8,edkey.action.buffer8
     6E10 7340 
0095 6E12 9F00             data  key_buf9,edkey.action.buffer9
     6E14 7346 
0096 6E16 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 6E18 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6E1A 833C 
0104 6E1C 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6E1E FF00 
0105               
0106 6E20 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6E22 6DA2 
0107 6E24 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 6E26 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 6E28 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 6E2A 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 6E2C 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 6E2E 05C6  14         inct  tmp2                  ; No, skip action
0118 6E30 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 6E32 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 6E34 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 6E36 0460  28         b    @edkey.action.char     ; Add character to buffer
     6E38 7284 
**** **** ****     > tivi.asm.25485
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
0009 6E3A C120  34         mov   @fb.column,tmp0
     6E3C 220C 
0010 6E3E 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6E40 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6E42 220C 
0015 6E44 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6E46 832A 
0016 6E48 0620  34         dec   @fb.current
     6E4A 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6E4C 0460  28 !       b     @ed_wait              ; Back to editor main
     6E4E 6D96 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6E50 8820  54         c     @fb.column,@fb.row.length
     6E52 220C 
     6E54 2208 
0028 6E56 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6E58 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6E5A 220C 
0033 6E5C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6E5E 832A 
0034 6E60 05A0  34         inc   @fb.current
     6E62 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6E64 0460  28 !       b     @ed_wait              ; Back to editor main
     6E66 6D96 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6E68 8820  54         c     @fb.row.dirty,@w$ffff
     6E6A 220A 
     6E6C 6048 
0049 6E6E 1604  14         jne   edkey.action.up.cursor
0050 6E70 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6E72 7694 
0051 6E74 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6E76 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6E78 C120  34         mov   @fb.row,tmp0
     6E7A 2206 
0057 6E7C 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6E7E C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6E80 2204 
0060 6E82 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6E84 0604  14         dec   tmp0                  ; fb.topline--
0066 6E86 C804  38         mov   tmp0,@parm1
     6E88 8350 
0067 6E8A 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6E8C 753C 
0068 6E8E 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6E90 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6E92 2206 
0074 6E94 06A0  32         bl    @up                   ; Row-- VDP cursor
     6E96 645A 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6E98 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6E9A 77D4 
0080 6E9C 8820  54         c     @fb.column,@fb.row.length
     6E9E 220C 
     6EA0 2208 
0081 6EA2 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6EA4 C820  54         mov   @fb.row.length,@fb.column
     6EA6 2208 
     6EA8 220C 
0086 6EAA C120  34         mov   @fb.column,tmp0
     6EAC 220C 
0087 6EAE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6EB0 6464 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6EB2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6EB4 7520 
0093 6EB6 0460  28         b     @ed_wait              ; Back to editor main
     6EB8 6D96 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6EBA 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6EBC 2206 
     6EBE 2304 
0102 6EC0 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6EC2 8820  54         c     @fb.row.dirty,@w$ffff
     6EC4 220A 
     6EC6 6048 
0107 6EC8 1604  14         jne   edkey.action.down.move
0108 6ECA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6ECC 7694 
0109 6ECE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6ED0 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6ED2 C120  34         mov   @fb.topline,tmp0
     6ED4 2204 
0118 6ED6 A120  34         a     @fb.row,tmp0
     6ED8 2206 
0119 6EDA 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6EDC 2304 
0120 6EDE 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6EE0 C120  34         mov   @fb.screenrows,tmp0
     6EE2 2218 
0126 6EE4 0604  14         dec   tmp0
0127 6EE6 8120  34         c     @fb.row,tmp0
     6EE8 2206 
0128 6EEA 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6EEC C820  54         mov   @fb.topline,@parm1
     6EEE 2204 
     6EF0 8350 
0133 6EF2 05A0  34         inc   @parm1
     6EF4 8350 
0134 6EF6 06A0  32         bl    @fb.refresh
     6EF8 753C 
0135 6EFA 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6EFC 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6EFE 2206 
0141 6F00 06A0  32         bl    @down                 ; Row++ VDP cursor
     6F02 6452 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6F04 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F06 77D4 
0147 6F08 8820  54         c     @fb.column,@fb.row.length
     6F0A 220C 
     6F0C 2208 
0148 6F0E 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 6F10 C820  54         mov   @fb.row.length,@fb.column
     6F12 2208 
     6F14 220C 
0153 6F16 C120  34         mov   @fb.column,tmp0
     6F18 220C 
0154 6F1A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F1C 6464 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 6F1E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F20 7520 
0160 6F22 0460  28 !       b     @ed_wait              ; Back to editor main
     6F24 6D96 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 6F26 C120  34         mov   @wyx,tmp0
     6F28 832A 
0169 6F2A 0244  22         andi  tmp0,>ff00
     6F2C FF00 
0170 6F2E C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6F30 832A 
0171 6F32 04E0  34         clr   @fb.column
     6F34 220C 
0172 6F36 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F38 7520 
0173 6F3A 0460  28         b     @ed_wait              ; Back to editor main
     6F3C 6D96 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 6F3E C120  34         mov   @fb.row.length,tmp0
     6F40 2208 
0180 6F42 C804  38         mov   tmp0,@fb.column
     6F44 220C 
0181 6F46 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6F48 6464 
0182 6F4A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F4C 7520 
0183 6F4E 0460  28         b     @ed_wait              ; Back to editor main
     6F50 6D96 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 6F52 C120  34         mov   @fb.column,tmp0
     6F54 220C 
0192 6F56 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 6F58 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6F5A 2202 
0197 6F5C 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 6F5E 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 6F60 0605  14         dec   tmp1
0204 6F62 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 6F64 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 6F66 D195  26         movb  *tmp1,tmp2            ; Get character
0212 6F68 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 6F6A D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 6F6C 0986  56         srl   tmp2,8                ; Right justify
0215 6F6E 0286  22         ci    tmp2,32               ; Space character found?
     6F70 0020 
0216 6F72 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 6F74 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6F76 2020 
0222 6F78 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 6F7A 0287  22         ci    tmp3,>20ff            ; First character is space
     6F7C 20FF 
0225 6F7E 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 6F80 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6F82 220C 
0230 6F84 61C4  18         s     tmp0,tmp3
0231 6F86 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6F88 0002 
0232 6F8A 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 6F8C 0585  14         inc   tmp1
0238 6F8E 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 6F90 C805  38         mov   tmp1,@fb.current
     6F92 2202 
0244 6F94 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6F96 220C 
0245 6F98 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F9A 6464 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 6F9C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F9E 7520 
0251 6FA0 0460  28 !       b     @ed_wait              ; Back to editor main
     6FA2 6D96 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 6FA4 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 6FA6 C120  34         mov   @fb.column,tmp0
     6FA8 220C 
0261 6FAA 8804  38         c     tmp0,@fb.row.length
     6FAC 2208 
0262 6FAE 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 6FB0 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6FB2 2202 
0267 6FB4 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 6FB6 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 6FB8 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 6FBA 0585  14         inc   tmp1
0279 6FBC 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 6FBE 8804  38         c     tmp0,@fb.row.length
     6FC0 2208 
0281 6FC2 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 6FC4 D195  26         movb  *tmp1,tmp2            ; Get character
0288 6FC6 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 6FC8 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 6FCA 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 6FCC 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6FCE FFFF 
0293 6FD0 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 6FD2 0286  22         ci    tmp2,32
     6FD4 0020 
0299 6FD6 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 6FD8 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 6FDA 0286  22         ci    tmp2,32               ; Space character found?
     6FDC 0020 
0307 6FDE 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 6FE0 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6FE2 2020 
0313 6FE4 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 6FE6 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6FE8 20FF 
0316 6FEA 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 6FEC 0585  14         inc   tmp1
0321 6FEE 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 6FF0 C805  38         mov   tmp1,@fb.current
     6FF2 2202 
0327 6FF4 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6FF6 220C 
0328 6FF8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FFA 6464 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 6FFC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FFE 7520 
0334 7000 0460  28 !       b     @ed_wait              ; Back to editor main
     7002 6D96 
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
0346 7004 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     7006 2204 
0347 7008 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 700A 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     700C 2218 
0352 700E 1503  14         jgt   edkey.action.ppage.topline
0353 7010 04E0  34         clr   @fb.topline           ; topline = 0
     7012 2204 
0354 7014 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 7016 6820  54         s     @fb.screenrows,@fb.topline
     7018 2218 
     701A 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 701C 8820  54         c     @fb.row.dirty,@w$ffff
     701E 220A 
     7020 6048 
0365 7022 1604  14         jne   edkey.action.ppage.refresh
0366 7024 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7026 7694 
0367 7028 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     702A 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 702C C820  54         mov   @fb.topline,@parm1
     702E 2204 
     7030 8350 
0373 7032 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7034 753C 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 7036 04E0  34         clr   @fb.row
     7038 2206 
0379 703A 05A0  34         inc   @fb.row               ; Set fb.row=1
     703C 2206 
0380 703E 04E0  34         clr   @fb.column
     7040 220C 
0381 7042 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7044 0100 
0382 7046 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7048 832A 
0383 704A 0460  28         b     @edkey.action.up      ; Do rest of logic
     704C 6E68 
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
0394 704E C120  34         mov   @fb.topline,tmp0
     7050 2204 
0395 7052 A120  34         a     @fb.screenrows,tmp0
     7054 2218 
0396 7056 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7058 2304 
0397 705A 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 705C A820  54         a     @fb.screenrows,@fb.topline
     705E 2218 
     7060 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 7062 8820  54         c     @fb.row.dirty,@w$ffff
     7064 220A 
     7066 6048 
0408 7068 1604  14         jne   edkey.action.npage.refresh
0409 706A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     706C 7694 
0410 706E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7070 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 7072 0460  28         b     @edkey.action.ppage.refresh
     7074 702C 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 7076 0460  28         b     @ed_wait              ; Back to editor main
     7078 6D96 
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
0433 707A 8820  54         c     @fb.row.dirty,@w$ffff
     707C 220A 
     707E 6048 
0434 7080 1604  14         jne   edkey.action.top.refresh
0435 7082 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7084 7694 
0436 7086 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7088 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 708A 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     708C 2204 
0442 708E 04E0  34         clr   @parm1
     7090 8350 
0443 7092 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7094 753C 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 7096 04E0  34         clr   @fb.row               ; Editor line 0
     7098 2206 
0449 709A 04E0  34         clr   @fb.column            ; Editor column 0
     709C 220C 
0450 709E 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 70A0 C804  38         mov   tmp0,@wyx             ;
     70A2 832A 
0452 70A4 0460  28         b     @ed_wait              ; Back to editor main
     70A6 6D96 
**** **** ****     > tivi.asm.25485
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
0009 70A8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70AA 2306 
0010 70AC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70AE 7520 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 70B0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     70B2 2202 
0015 70B4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     70B6 2208 
0016 70B8 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 70BA 8820  54         c     @fb.column,@fb.row.length
     70BC 220C 
     70BE 2208 
0022 70C0 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 70C2 C120  34         mov   @fb.current,tmp0      ; Get pointer
     70C4 2202 
0028 70C6 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 70C8 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 70CA DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 70CC 0606  14         dec   tmp2
0036 70CE 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 70D0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     70D2 220A 
0041 70D4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     70D6 2216 
0042 70D8 0620  34         dec   @fb.row.length        ; @fb.row.length--
     70DA 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 70DC 0460  28         b     @ed_wait              ; Back to editor main
     70DE 6D96 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 70E0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70E2 2306 
0055 70E4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70E6 7520 
0056 70E8 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     70EA 2208 
0057 70EC 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 70EE C120  34         mov   @fb.current,tmp0      ; Get pointer
     70F0 2202 
0063 70F2 C1A0  34         mov   @fb.colsline,tmp2
     70F4 220E 
0064 70F6 61A0  34         s     @fb.column,tmp2
     70F8 220C 
0065 70FA 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 70FC DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 70FE 0606  14         dec   tmp2
0072 7100 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 7102 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7104 220A 
0077 7106 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7108 2216 
0078               
0079 710A C820  54         mov   @fb.column,@fb.row.length
     710C 220C 
     710E 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 7110 0460  28         b     @ed_wait              ; Back to editor main
     7112 6D96 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7114 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7116 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 7118 C120  34         mov   @edb.lines,tmp0
     711A 2304 
0097 711C 1604  14         jne   !
0098 711E 04E0  34         clr   @fb.column            ; Column 0
     7120 220C 
0099 7122 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7124 70E0 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 7126 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7128 7520 
0104 712A 04E0  34         clr   @fb.row.dirty         ; Discard current line
     712C 220A 
0105 712E C820  54         mov   @fb.topline,@parm1
     7130 2204 
     7132 8350 
0106 7134 A820  54         a     @fb.row,@parm1        ; Line number to remove
     7136 2206 
     7138 8350 
0107 713A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     713C 2304 
     713E 8352 
0108 7140 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7142 75E8 
0109 7144 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7146 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7148 C820  54         mov   @fb.topline,@parm1
     714A 2204 
     714C 8350 
0114 714E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7150 753C 
0115 7152 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7154 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 7156 C120  34         mov   @fb.topline,tmp0
     7158 2204 
0120 715A A120  34         a     @fb.row,tmp0
     715C 2206 
0121 715E 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7160 2304 
0122 7162 1202  14         jle   edkey.action.del_line.exit
0123 7164 0460  28         b     @edkey.action.up      ; One line up
     7166 6E68 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 7168 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     716A 6F26 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 716C 0204  20         li    tmp0,>2000            ; White space
     716E 2000 
0139 7170 C804  38         mov   tmp0,@parm1
     7172 8350 
0140               edkey.action.ins_char:
0141 7174 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7176 2306 
0142 7178 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     717A 7520 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 717C C120  34         mov   @fb.current,tmp0      ; Get pointer
     717E 2202 
0147 7180 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7182 2208 
0148 7184 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 7186 8820  54         c     @fb.column,@fb.row.length
     7188 220C 
     718A 2208 
0154 718C 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 718E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 7190 61E0  34         s     @fb.column,tmp3
     7192 220C 
0162 7194 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 7196 C144  18         mov   tmp0,tmp1
0164 7198 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 719A 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     719C 220C 
0166 719E 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 71A0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 71A2 0604  14         dec   tmp0
0173 71A4 0605  14         dec   tmp1
0174 71A6 0606  14         dec   tmp2
0175 71A8 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 71AA D560  46         movb  @parm1,*tmp1
     71AC 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 71AE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     71B0 220A 
0184 71B2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71B4 2216 
0185 71B6 05A0  34         inc   @fb.row.length        ; @fb.row.length
     71B8 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 71BA 0460  28         b     @edkey.action.char.overwrite
     71BC 7296 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 71BE 0460  28         b     @ed_wait              ; Back to editor main
     71C0 6D96 
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
0206 71C2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71C4 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 71C6 8820  54         c     @fb.row.dirty,@w$ffff
     71C8 220A 
     71CA 6048 
0211 71CC 1604  14         jne   edkey.action.ins_line.insert
0212 71CE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     71D0 7694 
0213 71D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     71D4 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 71D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71D8 7520 
0219 71DA C820  54         mov   @fb.topline,@parm1
     71DC 2204 
     71DE 8350 
0220 71E0 A820  54         a     @fb.row,@parm1        ; Line number to insert
     71E2 2206 
     71E4 8350 
0221               
0222 71E6 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71E8 2304 
     71EA 8352 
0223 71EC 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     71EE 7612 
0224 71F0 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     71F2 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 71F4 C820  54         mov   @fb.topline,@parm1
     71F6 2204 
     71F8 8350 
0229 71FA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71FC 753C 
0230 71FE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7200 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 7202 0460  28         b     @ed_wait              ; Back to editor main
     7204 6D96 
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
0249 7206 8820  54         c     @fb.row.dirty,@w$ffff
     7208 220A 
     720A 6048 
0250 720C 1606  14         jne   edkey.action.enter.upd_counter
0251 720E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7210 2306 
0252 7212 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7214 7694 
0253 7216 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7218 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 721A C120  34         mov   @fb.topline,tmp0
     721C 2204 
0259 721E A120  34         a     @fb.row,tmp0
     7220 2206 
0260 7222 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7224 2304 
0261 7226 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 7228 05A0  34         inc   @edb.lines            ; Total lines++
     722A 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 722C C120  34         mov   @fb.screenrows,tmp0
     722E 2218 
0271 7230 0604  14         dec   tmp0
0272 7232 8120  34         c     @fb.row,tmp0
     7234 2206 
0273 7236 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 7238 C120  34         mov   @fb.screenrows,tmp0
     723A 2218 
0278 723C C820  54         mov   @fb.topline,@parm1
     723E 2204 
     7240 8350 
0279 7242 05A0  34         inc   @parm1
     7244 8350 
0280 7246 06A0  32         bl    @fb.refresh
     7248 753C 
0281 724A 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 724C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     724E 2206 
0287 7250 06A0  32         bl    @down                 ; Row++ VDP cursor
     7252 6452 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 7254 06A0  32         bl    @fb.get.firstnonblank
     7256 7566 
0293 7258 C120  34         mov   @outparm1,tmp0
     725A 8360 
0294 725C C804  38         mov   tmp0,@fb.column
     725E 220C 
0295 7260 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     7262 6464 
0296 7264 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7266 77D4 
0297 7268 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     726A 7520 
0298 726C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     726E 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 7270 0460  28         b     @ed_wait              ; Back to editor main
     7272 6D96 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 7274 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7276 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7278 0204  20         li    tmp0,2000
     727A 07D0 
0317               edkey.action.ins_onoff.loop:
0318 727C 0604  14         dec   tmp0
0319 727E 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 7280 0460  28         b     @task2.cur_visible    ; Update cursor shape
     7282 73EA 
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
0335 7284 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7286 2306 
0336 7288 D805  38         movb  tmp1,@parm1           ; Store character for insert
     728A 8350 
0337 728C C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     728E 230C 
0338 7290 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 7292 0460  28         b     @edkey.action.ins_char
     7294 7174 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 7296 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7298 7520 
0349 729A C120  34         mov   @fb.current,tmp0      ; Get pointer
     729C 2202 
0350               
0351 729E D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     72A0 8350 
0352 72A2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     72A4 220A 
0353 72A6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72A8 2216 
0354               
0355 72AA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     72AC 220C 
0356 72AE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     72B0 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 72B2 8820  54         c     @fb.column,@fb.row.length
     72B4 220C 
     72B6 2208 
0361 72B8 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 72BA C820  54         mov   @fb.column,@fb.row.length
     72BC 220C 
     72BE 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 72C0 0460  28         b     @ed_wait              ; Back to editor main
     72C2 6D96 
**** **** ****     > tivi.asm.25485
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
0009 72C4 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     72C6 6514 
0010 72C8 0420  54         blwp  @0                    ; Exit
     72CA 0000 
0011               
**** **** ****     > tivi.asm.25485
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
0016 72CC C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     72CE 8350 
     72D0 8352 
0017 72D2 C804  38         mov   tmp0,@parm1           ; Setup file to load
     72D4 8350 
0018               
0019 72D6 06A0  32         bl    @edb.init             ; Initialize editor buffer
     72D8 7674 
0020 72DA 06A0  32         bl    @idx.init             ; Initialize index
     72DC 75AE 
0021 72DE 06A0  32         bl    @fb.init              ; Initialize framebuffer
     72E0 74D2 
0022 72E2 C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     72E4 8352 
     72E6 230E 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 72E8 06A0  32         bl    @filv
     72EA 618E 
0027 72EC 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     72EE 0000 
     72F0 0004 
0028               
0029 72F2 C160  34         mov   @fb.screenrows,tmp1
     72F4 2218 
0030 72F6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     72F8 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 72FA 04C4  14         clr   tmp0                  ; VDP target address
0034 72FC 0205  20         li    tmp1,32               ; Character to fill
     72FE 0020 
0035               
0036 7300 06A0  32         bl    @xfilv                ; Fill VDP memory
     7302 6194 
0037                                                   ; \ .  tmp0 = VDP target address
0038                                                   ; | .  tmp1 = Byte to fill
0039                                                   ; / .  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 7304 06A0  32         bl    @tfh.file.read        ; Read specified file
     7306 77F2 
0044                                                   ; \ .  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / .  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 7308 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     730A 2306 
0048 730C 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     730E 707A 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 7310 0204  20         li   tmp0,fdname0
     7312 7A50 
0054 7314 10DB  14         jmp  edkey.action.loadfile
0055                                                   ; Load DIS/VAR 80 file into editor buffer
0056               edkey.action.buffer1:
0057 7316 0204  20         li   tmp0,fdname1
     7318 7A5E 
0058 731A 10D8  14         jmp  edkey.action.loadfile
0059                                                   ; Load DIS/VAR 80 file into editor buffer
0060               
0061               edkey.action.buffer2:
0062 731C 0204  20         li   tmp0,fdname2
     731E 7A6E 
0063 7320 10D5  14         jmp  edkey.action.loadfile
0064                                                   ; Load DIS/VAR 80 file into editor buffer
0065               
0066               edkey.action.buffer3:
0067 7322 0204  20         li   tmp0,fdname3
     7324 7A7C 
0068 7326 10D2  14         jmp  edkey.action.loadfile
0069                                                   ; Load DIS/VAR 80 file into editor buffer
0070               
0071               edkey.action.buffer4:
0072 7328 0204  20         li   tmp0,fdname4
     732A 7A8A 
0073 732C 10CF  14         jmp  edkey.action.loadfile
0074                                                   ; Load DIS/VAR 80 file into editor buffer
0075               
0076               edkey.action.buffer5:
0077 732E 0204  20         li   tmp0,fdname5
     7330 7A98 
0078 7332 10CC  14         jmp  edkey.action.loadfile
0079                                                   ; Load DIS/VAR 80 file into editor buffer
0080               
0081               edkey.action.buffer6:
0082 7334 0204  20         li   tmp0,fdname6
     7336 7AA6 
0083 7338 10C9  14         jmp  edkey.action.loadfile
0084                                                   ; Load DIS/VAR 80 file into editor buffer
0085               
0086               edkey.action.buffer7:
0087 733A 0204  20         li   tmp0,fdname7
     733C 7AB4 
0088 733E 10C6  14         jmp  edkey.action.loadfile
0089                                                   ; Load DIS/VAR 80 file into editor buffer
0090               
0091               edkey.action.buffer8:
0092 7340 0204  20         li   tmp0,fdname8
     7342 7AC2 
0093 7344 10C3  14         jmp  edkey.action.loadfile
0094                                                   ; Load DIS/VAR 80 file into editor buffer
0095               
0096               edkey.action.buffer9:
0097 7346 0204  20         li   tmp0,fdname9
     7348 7AD0 
0098 734A 10C0  14         jmp  edkey.action.loadfile
0099                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.25485
0355               
0356               
0357               
0358               ***************************************************************
0359               * Task 0 - Copy frame buffer to VDP
0360               ***************************************************************
0361 734C C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     734E 2216 
0362 7350 133D  14         jeq   task0.$$              ; No, skip update
0363                       ;------------------------------------------------------
0364                       ; Determine how many rows to copy
0365                       ;------------------------------------------------------
0366 7352 8820  54         c     @edb.lines,@fb.screenrows
     7354 2304 
     7356 2218 
0367 7358 1103  14         jlt   task0.setrows.small
0368 735A C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     735C 2218 
0369 735E 1003  14         jmp   task0.copy.framebuffer
0370                       ;------------------------------------------------------
0371                       ; Less lines in editor buffer as rows in frame buffer
0372                       ;------------------------------------------------------
0373               task0.setrows.small:
0374 7360 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7362 2304 
0375 7364 0585  14         inc   tmp1
0376                       ;------------------------------------------------------
0377                       ; Determine area to copy
0378                       ;------------------------------------------------------
0379               task0.copy.framebuffer:
0380 7366 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7368 220E 
0381                                                   ; 16 bit part is in tmp2!
0382 736A 04C4  14         clr   tmp0                  ; VDP target address
0383 736C C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     736E 2200 
0384                       ;------------------------------------------------------
0385                       ; Copy memory block
0386                       ;------------------------------------------------------
0387 7370 06A0  32         bl    @xpym2v               ; Copy to VDP
     7372 633E 
0388                                                   ; tmp0 = VDP target address
0389                                                   ; tmp1 = RAM source address
0390                                                   ; tmp2 = Bytes to copy
0391 7374 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7376 2216 
0392                       ;-------------------------------------------------------
0393                       ; Draw EOF marker at end-of-file
0394                       ;-------------------------------------------------------
0395 7378 C120  34         mov   @edb.lines,tmp0
     737A 2304 
0396 737C 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     737E 2204 
0397 7380 0584  14         inc   tmp0                  ; Y++
0398 7382 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7384 2218 
0399 7386 1222  14         jle   task0.$$
0400                       ;-------------------------------------------------------
0401                       ; Draw EOF marker
0402                       ;-------------------------------------------------------
0403               task0.draw_marker:
0404 7388 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     738A 832A 
     738C 2214 
0405 738E 0A84  56         sla   tmp0,8                ; X=0
0406 7390 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7392 832A 
0407 7394 06A0  32         bl    @putstr
     7396 631E 
0408 7398 7A1E                   data txt_marker       ; Display *EOF*
0409                       ;-------------------------------------------------------
0410                       ; Draw empty line after (and below) EOF marker
0411                       ;-------------------------------------------------------
0412 739A 06A0  32         bl    @setx
     739C 6462 
0413 739E 0005                   data  5               ; Cursor after *EOF* string
0414               
0415 73A0 C120  34         mov   @wyx,tmp0
     73A2 832A 
0416 73A4 0984  56         srl   tmp0,8                ; Right justify
0417 73A6 0584  14         inc   tmp0                  ; One time adjust
0418 73A8 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     73AA 2218 
0419 73AC 1303  14         jeq   !
0420 73AE 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     73B0 009B 
0421 73B2 1002  14         jmp   task0.draw_marker.line
0422 73B4 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     73B6 004B 
0423                       ;-------------------------------------------------------
0424                       ; Draw empty line
0425                       ;-------------------------------------------------------
0426               task0.draw_marker.line:
0427 73B8 0604  14         dec   tmp0                  ; One time adjust
0428 73BA 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     73BC 62FA 
0429 73BE 0205  20         li    tmp1,32               ; Character to write (whitespace)
     73C0 0020 
0430 73C2 06A0  32         bl    @xfilv                ; Write characters
     73C4 6194 
0431 73C6 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     73C8 2214 
     73CA 832A 
0432               *--------------------------------------------------------------
0433               * Task 0 - Exit
0434               *--------------------------------------------------------------
0435               task0.$$:
0436 73CC 0460  28         b     @slotok
     73CE 6BA6 
0437               
0438               
0439               
0440               ***************************************************************
0441               * Task 1 - Copy SAT to VDP
0442               ***************************************************************
0443 73D0 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     73D2 6046 
0444 73D4 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     73D6 646E 
0445 73D8 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     73DA 8380 
0446 73DC 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0447               
0448               
0449               ***************************************************************
0450               * Task 2 - Update cursor shape (blink)
0451               ***************************************************************
0452 73DE 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     73E0 2212 
0453 73E2 1303  14         jeq   task2.cur_visible
0454 73E4 04E0  34         clr   @ramsat+2              ; Hide cursor
     73E6 8382 
0455 73E8 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0456               
0457               task2.cur_visible:
0458 73EA C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     73EC 230C 
0459 73EE 1303  14         jeq   task2.cur_visible.overwrite_mode
0460                       ;------------------------------------------------------
0461                       ; Cursor in insert mode
0462                       ;------------------------------------------------------
0463               task2.cur_visible.insert_mode:
0464 73F0 0204  20         li    tmp0,>000f
     73F2 000F 
0465 73F4 1002  14         jmp   task2.cur_visible.cursorshape
0466                       ;------------------------------------------------------
0467                       ; Cursor in overwrite mode
0468                       ;------------------------------------------------------
0469               task2.cur_visible.overwrite_mode:
0470 73F6 0204  20         li    tmp0,>020f
     73F8 020F 
0471                       ;------------------------------------------------------
0472                       ; Set cursor shape
0473                       ;------------------------------------------------------
0474               task2.cur_visible.cursorshape:
0475 73FA C804  38         mov   tmp0,@fb.curshape
     73FC 2210 
0476 73FE C804  38         mov   tmp0,@ramsat+2
     7400 8382 
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
0488 7402 06A0  32         bl    @cpym2v
     7404 6338 
0489 7406 2000                   data sprsat,ramsat,4   ; Update sprite
     7408 8380 
     740A 0004 
0490               
0491 740C C820  54         mov   @wyx,@fb.yxsave
     740E 832A 
     7410 2214 
0492                       ;------------------------------------------------------
0493                       ; Show text editing mode
0494                       ;------------------------------------------------------
0495               task.botline.show_mode
0496 7412 C120  34         mov   @edb.insmode,tmp0
     7414 230C 
0497 7416 1605  14         jne   task.botline.show_mode.insert
0498                       ;------------------------------------------------------
0499                       ; Overwrite mode
0500                       ;------------------------------------------------------
0501               task.botline.show_mode.overwrite:
0502 7418 06A0  32         bl    @putat
     741A 6330 
0503 741C 1D32                   byte  29,50
0504 741E 7A2A                   data  txt_ovrwrite
0505 7420 1004  14         jmp   task.botline.show_changed
0506                       ;------------------------------------------------------
0507                       ; Insert  mode
0508                       ;------------------------------------------------------
0509               task.botline.show_mode.insert:
0510 7422 06A0  32         bl    @putat
     7424 6330 
0511 7426 1D32                   byte  29,50
0512 7428 7A2E                   data  txt_insert
0513                       ;------------------------------------------------------
0514                       ; Show if text was changed in editor buffer
0515                       ;------------------------------------------------------
0516               task.botline.show_changed:
0517 742A C120  34         mov   @edb.dirty,tmp0
     742C 2306 
0518 742E 1305  14         jeq   task.botline.show_changed.clear
0519                       ;------------------------------------------------------
0520                       ; Show "*"
0521                       ;------------------------------------------------------
0522 7430 06A0  32         bl    @putat
     7432 6330 
0523 7434 1D36                   byte 29,54
0524 7436 7A32                   data txt_star
0525 7438 1001  14         jmp   task.botline.show_linecol
0526                       ;------------------------------------------------------
0527                       ; Show "line,column"
0528                       ;------------------------------------------------------
0529               task.botline.show_changed.clear:
0530 743A 1000  14         nop
0531               task.botline.show_linecol:
0532 743C C820  54         mov   @fb.row,@parm1
     743E 2206 
     7440 8350 
0533 7442 06A0  32         bl    @fb.row2line
     7444 750C 
0534 7446 05A0  34         inc   @outparm1
     7448 8360 
0535                       ;------------------------------------------------------
0536                       ; Show line
0537                       ;------------------------------------------------------
0538 744A 06A0  32         bl    @putnum
     744C 67CC 
0539 744E 1D40                   byte  29,64            ; YX
0540 7450 8360                   data  outparm1,rambuf
     7452 8390 
0541 7454 3020                   byte  48               ; ASCII offset
0542                             byte  32               ; Padding character
0543                       ;------------------------------------------------------
0544                       ; Show comma
0545                       ;------------------------------------------------------
0546 7456 06A0  32         bl    @putat
     7458 6330 
0547 745A 1D45                   byte  29,69
0548 745C 7A1C                   data  txt_delim
0549                       ;------------------------------------------------------
0550                       ; Show column
0551                       ;------------------------------------------------------
0552 745E 06A0  32         bl    @film
     7460 6136 
0553 7462 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7464 0020 
     7466 000C 
0554               
0555 7468 C820  54         mov   @fb.column,@waux1
     746A 220C 
     746C 833C 
0556 746E 05A0  34         inc   @waux1                 ; Offset 1
     7470 833C 
0557               
0558 7472 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7474 674E 
0559 7476 833C                   data  waux1,rambuf
     7478 8390 
0560 747A 3020                   byte  48               ; ASCII offset
0561                             byte  32               ; Fill character
0562               
0563 747C 06A0  32         bl    @trimnum               ; Trim number to the left
     747E 67A6 
0564 7480 8390                   data  rambuf,rambuf+6,32
     7482 8396 
     7484 0020 
0565               
0566 7486 0204  20         li    tmp0,>0200
     7488 0200 
0567 748A D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     748C 8396 
0568               
0569 748E 06A0  32         bl    @putat
     7490 6330 
0570 7492 1D46                   byte 29,70
0571 7494 8396                   data rambuf+6          ; Show column
0572                       ;------------------------------------------------------
0573                       ; Show lines in buffer unless on last line in file
0574                       ;------------------------------------------------------
0575 7496 C820  54         mov   @fb.row,@parm1
     7498 2206 
     749A 8350 
0576 749C 06A0  32         bl    @fb.row2line
     749E 750C 
0577 74A0 8820  54         c     @edb.lines,@outparm1
     74A2 2304 
     74A4 8360 
0578 74A6 1605  14         jne   task.botline.show_lines_in_buffer
0579               
0580 74A8 06A0  32         bl    @putat
     74AA 6330 
0581 74AC 1D49                   byte 29,73
0582 74AE 7A24                   data txt_bottom
0583               
0584 74B0 100B  14         jmp   task.botline.$$
0585                       ;------------------------------------------------------
0586                       ; Show lines in buffer
0587                       ;------------------------------------------------------
0588               task.botline.show_lines_in_buffer:
0589 74B2 C820  54         mov   @edb.lines,@waux1
     74B4 2304 
     74B6 833C 
0590 74B8 05A0  34         inc   @waux1                 ; Offset 1
     74BA 833C 
0591 74BC 06A0  32         bl    @putnum
     74BE 67CC 
0592 74C0 1D49                   byte 29,73             ; YX
0593 74C2 833C                   data waux1,rambuf
     74C4 8390 
0594 74C6 3020                   byte 48
0595                             byte 32
0596                       ;------------------------------------------------------
0597                       ; Exit
0598                       ;------------------------------------------------------
0599               task.botline.$$
0600 74C8 C820  54         mov   @fb.yxsave,@wyx
     74CA 2214 
     74CC 832A 
0601 74CE 0460  28         b     @slotok                ; Exit running task
     74D0 6BA6 
0602               
0603               
0604               
0605               ***************************************************************
0606               *                  fb - Framebuffer module
0607               ***************************************************************
0608                       copy  "framebuffer.asm"
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
0024 74D2 0649  14         dect  stack
0025 74D4 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 74D6 0204  20         li    tmp0,fb.top
     74D8 2650 
0030 74DA C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     74DC 2200 
0031 74DE 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     74E0 2204 
0032 74E2 04E0  34         clr   @fb.row               ; Current row=0
     74E4 2206 
0033 74E6 04E0  34         clr   @fb.column            ; Current column=0
     74E8 220C 
0034 74EA 0204  20         li    tmp0,80
     74EC 0050 
0035 74EE C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     74F0 220E 
0036 74F2 0204  20         li    tmp0,29
     74F4 001D 
0037 74F6 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     74F8 2218 
0038 74FA 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     74FC 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 74FE 06A0  32         bl    @film
     7500 6136 
0043 7502 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     7504 0000 
     7506 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 7508 0460  28         b     @poprt                ; Return to caller
     750A 6132 
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
0073 750C 0649  14         dect  stack
0074 750E C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 7510 C120  34         mov   @parm1,tmp0
     7512 8350 
0079 7514 A120  34         a     @fb.topline,tmp0
     7516 2204 
0080 7518 C804  38         mov   tmp0,@outparm1
     751A 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 751C 0460  28         b    @poprt                 ; Return to caller
     751E 6132 
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
0113 7520 0649  14         dect  stack
0114 7522 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7524 C1A0  34         mov   @fb.row,tmp2
     7526 2206 
0119 7528 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     752A 220E 
0120 752C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     752E 220C 
0121 7530 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7532 2200 
0122 7534 C807  38         mov   tmp3,@fb.current
     7536 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7538 0460  28         b    @poprt                 ; Return to caller
     753A 6132 
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
0145 753C 0649  14         dect  stack
0146 753E C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7540 C820  54         mov   @parm1,@fb.topline
     7542 8350 
     7544 2204 
0151 7546 04E0  34         clr   @parm2                ; Target row in frame buffer
     7548 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 754A 06A0  32         bl    @edb.line.unpack      ; Unpack line
     754C 771C 
0157                                                   ; \ .  parm1 = Line to unpack
0158                                                   ; / .  parm2 = Target row in frame buffer
0159               
0160 754E 05A0  34         inc   @parm1                ; Next line in editor buffer
     7550 8350 
0161 7552 05A0  34         inc   @parm2                ; Next row in frame buffer
     7554 8352 
0162 7556 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7558 8352 
     755A 2218 
0163 755C 11F6  14         jlt   fb.refresh.unpack_line
0164 755E 0720  34         seto  @fb.dirty             ; Refresh screen
     7560 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit
0169 7562 0460  28         b    @poprt                 ; Return to caller
     7564 6132 
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
0185 7566 0649  14         dect  stack
0186 7568 C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 756A 04E0  34         clr   @fb.column
     756C 220C 
0191 756E 06A0  32         bl    @fb.calc_pointer
     7570 7520 
0192 7572 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7574 77D4 
0193 7576 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7578 2208 
0194 757A 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 757C C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     757E 2202 
0197 7580 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 7582 D174  28         movb  *tmp0+,tmp1           ; Get character
0203 7584 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 7586 0285  22         ci    tmp1,>2000            ; Whitespace?
     7588 2000 
0206 758A 1503  14         jgt   fb.get.firstnonblank.match
0207 758C 0606  14         dec   tmp2                  ; Counter--
0208 758E 16F9  14         jne   fb.get.firstnonblank.loop
0209 7590 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match
0214 7592 6120  34         s     @fb.current,tmp0      ; Calculate column
     7594 2202 
0215 7596 0604  14         dec   tmp0
0216 7598 C804  38         mov   tmp0,@outparm1        ; Save column
     759A 8360 
0217 759C D805  38         movb  tmp1,@outparm2        ; Save character
     759E 8362 
0218 75A0 1004  14         jmp   fb.get.firstnonblank.$$
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch
0223 75A2 04E0  34         clr   @outparm1             ; X=0
     75A4 8360 
0224 75A6 04E0  34         clr   @outparm2             ; Null
     75A8 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.$$
0229 75AA 0460  28         b    @poprt                 ; Return to caller
     75AC 6132 
0230               
0231               
0232               
0233               
0234               
0235               
**** **** ****     > tivi.asm.25485
0609               
0610               
0611               ***************************************************************
0612               *              idx - Index management module
0613               ***************************************************************
0614                       copy  "index.asm"
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
0059 75AE 0649  14         dect  stack
0060 75B0 C64B  30         mov   r11,*stack            ; Save return address
0061                       ;------------------------------------------------------
0062                       ; Initialize
0063                       ;------------------------------------------------------
0064 75B2 0204  20         li    tmp0,idx.top
     75B4 3000 
0065 75B6 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     75B8 2302 
0066                       ;------------------------------------------------------
0067                       ; Create index slot 0
0068                       ;------------------------------------------------------
0069 75BA 06A0  32         bl    @film
     75BC 6136 
0070 75BE 3000             data  idx.top,>00,idx.size  ; Clear index
     75C0 0000 
     75C2 1000 
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               idx.init.exit:
0075 75C4 0460  28         b     @poprt                ; Return to caller
     75C6 6132 
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
0097 75C8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     75CA 8350 
0098                       ;------------------------------------------------------
0099                       ; Calculate offset
0100                       ;------------------------------------------------------
0101 75CC C160  34         mov   @parm2,tmp1
     75CE 8352 
0102 75D0 1305  14         jeq   idx.entry.update.save ; Special handling for empty line
0103 75D2 0225  22         ai    tmp1,-edb.top         ; Substract editor buffer base,
     75D4 6000 
0104                                                   ; we only store the offset
0105               
0106                       ;------------------------------------------------------
0107                       ; Inject SAMS bank into high-nibble MSB of pointer
0108                       ;------------------------------------------------------
0109 75D6 C1A0  34         mov   @parm3,tmp2
     75D8 8354 
0110 75DA 1300  14         jeq   idx.entry.update.save ; Skip for SAMS bank 0
0111               
0112                       ; <still to do>
0113               
0114                       ;------------------------------------------------------
0115                       ; Update index slot
0116                       ;------------------------------------------------------
0117               idx.entry.update.save:
0118 75DC 0A14  56         sla   tmp0,1                ; line number * 2
0119 75DE C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     75E0 3000 
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               idx.entry.update.exit:
0124 75E2 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     75E4 8360 
0125 75E6 045B  20         b     *r11                  ; Return
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
0145 75E8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     75EA 8350 
0146                       ;------------------------------------------------------
0147                       ; Calculate address of index entry and save pointer
0148                       ;------------------------------------------------------
0149 75EC 0A14  56         sla   tmp0,1                ; line number * 2
0150 75EE C824  54         mov   @idx.top(tmp0),@outparm1
     75F0 3000 
     75F2 8360 
0151                                                   ; Pointer to deleted line
0152                       ;------------------------------------------------------
0153                       ; Prepare for index reorg
0154                       ;------------------------------------------------------
0155 75F4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75F6 8352 
0156 75F8 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75FA 8350 
0157 75FC 1603  14         jne   idx.entry.delete.reorg
0158                       ;------------------------------------------------------
0159                       ; Special treatment if last line
0160                       ;------------------------------------------------------
0161 75FE 04E4  34         clr   @idx.top(tmp0)
     7600 3000 
0162 7602 1006  14         jmp   idx.entry.delete.exit
0163                       ;------------------------------------------------------
0164                       ; Reorganize index entries
0165                       ;------------------------------------------------------
0166               idx.entry.delete.reorg:
0167 7604 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7606 3002 
     7608 3000 
0168 760A 05C4  14         inct  tmp0                  ; Next index entry
0169 760C 0606  14         dec   tmp2                  ; tmp2--
0170 760E 16FA  14         jne   idx.entry.delete.reorg
0171                                                   ; Loop unless completed
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               idx.entry.delete.exit:
0176 7610 045B  20         b     *r11                  ; Return
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
0196 7612 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7614 8352 
0197                       ;------------------------------------------------------
0198                       ; Calculate address of index entry and save pointer
0199                       ;------------------------------------------------------
0200 7616 0A14  56         sla   tmp0,1                ; line number * 2
0201                       ;------------------------------------------------------
0202                       ; Prepare for index reorg
0203                       ;------------------------------------------------------
0204 7618 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     761A 8352 
0205 761C 61A0  34         s     @parm1,tmp2           ; Calculate loop
     761E 8350 
0206 7620 1606  14         jne   idx.entry.insert.reorg
0207                       ;------------------------------------------------------
0208                       ; Special treatment if last line
0209                       ;------------------------------------------------------
0210 7622 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7624 3000 
     7626 3002 
0211 7628 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     762A 3000 
0212 762C 1009  14         jmp   idx.entry.insert.$$
0213                       ;------------------------------------------------------
0214                       ; Reorganize index entries
0215                       ;------------------------------------------------------
0216               idx.entry.insert.reorg:
0217 762E 05C6  14         inct  tmp2                  ; Adjust one time
0218 7630 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7632 3000 
     7634 3002 
0219 7636 0644  14         dect  tmp0                  ; Previous index entry
0220 7638 0606  14         dec   tmp2                  ; tmp2--
0221 763A 16FA  14         jne   -!                    ; Loop unless completed
0222               
0223 763C 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     763E 3004 
0224                       ;------------------------------------------------------
0225                       ; Exit
0226                       ;------------------------------------------------------
0227               idx.entry.insert.$$:
0228 7640 045B  20         b     *r11                  ; Return
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
0249 7642 0649  14         dect  stack
0250 7644 C64B  30         mov   r11,*stack            ; Save return address
0251                       ;------------------------------------------------------
0252                       ; Get pointer
0253                       ;------------------------------------------------------
0254 7646 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7648 8350 
0255                       ;------------------------------------------------------
0256                       ; Calculate index entry
0257                       ;------------------------------------------------------
0258 764A 0A14  56         sla   tmp0,1                ; line number * 2
0259 764C C164  34         mov   @idx.top(tmp0),tmp1   ; Get offset
     764E 3000 
0260                       ;------------------------------------------------------
0261                       ; Get SAMS bank
0262                       ;------------------------------------------------------
0263 7650 C185  18         mov   tmp1,tmp2
0264 7652 09C6  56         srl   tmp2,12               ; Remove offset part
0265               
0266 7654 0286  22         ci    tmp2,5                ; SAMS bank 0
     7656 0005 
0267 7658 1205  14         jle   idx.pointer.get.samsbank0
0268               
0269 765A 0226  22         ai    tmp2,-5               ; Get SAMS bank
     765C FFFB 
0270 765E C806  38         mov   tmp2,@outparm2        ; Return SAMS bank
     7660 8362 
0271 7662 1002  14         jmp   idx.pointer.get.addbase
0272                       ;------------------------------------------------------
0273                       ; SAMS Bank 0 (or only 32K memory expansion)
0274                       ;------------------------------------------------------
0275               idx.pointer.get.samsbank0:
0276 7664 04E0  34         clr   @outparm2             ; SAMS bank 0
     7666 8362 
0277                       ;------------------------------------------------------
0278                       ; Add base
0279                       ;------------------------------------------------------
0280               idx.pointer.get.addbase:
0281 7668 0225  22         ai    tmp1,edb.top          ; Add base of editor buffer
     766A A000 
0282 766C C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     766E 8360 
0283                       ;------------------------------------------------------
0284                       ; Exit
0285                       ;------------------------------------------------------
0286               idx.pointer.get.exit:
0287 7670 0460  28         b     @poprt                ; Return to caller
     7672 6132 
**** **** ****     > tivi.asm.25485
0615               
0616               
0617               ***************************************************************
0618               *               edb - Editor Buffer module
0619               ***************************************************************
0620                       copy  "editorbuffer.asm"
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
0026 7674 0649  14         dect  stack
0027 7676 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7678 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     767A A002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 767C C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     767E 2300 
0035 7680 C804  38         mov   tmp0,@edb.next_free.ptr
     7682 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 7684 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7686 230C 
0038 7688 04E0  34         clr   @edb.lines            ; Lines=0
     768A 2304 
0039 768C 04E0  34         clr   @edb.rle              ; RLE compression off
     768E 230E 
0040               
0041               edb.init.exit:
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045 7690 0460  28         b     @poprt                ; Return to caller
     7692 6132 
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
0072 7694 0649  14         dect  stack
0073 7696 C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Get values
0076                       ;------------------------------------------------------
0077 7698 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     769A 220C 
     769C 8390 
0078 769E 04E0  34         clr   @fb.column
     76A0 220C 
0079 76A2 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     76A4 7520 
0080                       ;------------------------------------------------------
0081                       ; Prepare scan
0082                       ;------------------------------------------------------
0083 76A6 04C4  14         clr   tmp0                  ; Counter
0084 76A8 C160  34         mov   @fb.current,tmp1      ; Get position
     76AA 2202 
0085 76AC C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     76AE 8392 
0086               
0087                       ;------------------------------------------------------
0088                       ; Scan line for >00 byte termination
0089                       ;------------------------------------------------------
0090               edb.line.pack.scan:
0091 76B0 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0092 76B2 0986  56         srl   tmp2,8                ; Right justify
0093 76B4 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0094 76B6 0584  14         inc   tmp0                  ; Increase string length
0095 76B8 10FB  14         jmp   edb.line.pack.scan    ; Next character
0096               
0097                       ;------------------------------------------------------
0098                       ; Prepare for storing line
0099                       ;------------------------------------------------------
0100               edb.line.pack.prepare:
0101 76BA C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     76BC 2204 
     76BE 8350 
0102 76C0 A820  54         a     @fb.row,@parm1        ; /
     76C2 2206 
     76C4 8350 
0103               
0104 76C6 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     76C8 8394 
0105               
0106                       ;------------------------------------------------------
0107                       ; 1. Update index
0108                       ;------------------------------------------------------
0109               edb.line.pack.update_index:
0110 76CA C820  54         mov   @edb.next_free.ptr,@parm2
     76CC 2308 
     76CE 8352 
0111                                                   ; Block where line will reside
0112               
0113 76D0 04E0  34         clr   @parm3                ; SAMS bank
     76D2 8354 
0114 76D4 06A0  32         bl    @idx.entry.update     ; Update index
     76D6 75C8 
0115                                                   ; \ .  parm1 = Line number in editor buffer
0116                                                   ; | .  parm2 = pointer to line in editor buffer
0117                                                   ; / .  parm3 = SAMS bank (0-A)
0118               
0119                       ;------------------------------------------------------
0120                       ; 2. Set line prefix in editor buffer
0121                       ;------------------------------------------------------
0122 76D8 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     76DA 8392 
0123 76DC C160  34         mov   @edb.next_free.ptr,tmp1
     76DE 2308 
0124                                                   ; Address of line in editor buffer
0125               
0126 76E0 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     76E2 2308 
0127               
0128 76E4 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     76E6 8394 
0129 76E8 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0130 76EA 06C6  14         swpb  tmp2
0131 76EC DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0132 76EE 06C6  14         swpb  tmp2
0133 76F0 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0134               
0135                       ;------------------------------------------------------
0136                       ; 3. Copy line from framebuffer to editor buffer
0137                       ;------------------------------------------------------
0138               edb.line.pack.copyline:
0139 76F2 0286  22         ci    tmp2,2
     76F4 0002 
0140 76F6 1603  14         jne   edb.line.pack.copyline.checkbyte
0141 76F8 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0142 76FA DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0143 76FC 1007  14         jmp   !
0144               edb.line.pack.copyline.checkbyte:
0145 76FE 0286  22         ci    tmp2,1
     7700 0001 
0146 7702 1602  14         jne   edb.line.pack.copyline.block
0147 7704 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0148 7706 1002  14         jmp   !
0149               edb.line.pack.copyline.block:
0150 7708 06A0  32         bl    @xpym2m               ; Copy memory block
     770A 6386 
0151                                                   ;   tmp0 = source
0152                                                   ;   tmp1 = destination
0153                                                   ;   tmp2 = bytes to copy
0154               
0155 770C A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     770E 8394 
     7710 2308 
0156                                                   ; Update pointer to next free line
0157               
0158                       ;------------------------------------------------------
0159                       ; Exit
0160                       ;------------------------------------------------------
0161               edb.line.pack.exit:
0162 7712 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7714 8390 
     7716 220C 
0163 7718 0460  28         b     @poprt                ; Return to caller
     771A 6132 
0164               
0165               
0166               
0167               
0168               ***************************************************************
0169               * edb.line.unpack
0170               * Unpack specified line to framebuffer
0171               ***************************************************************
0172               *  bl   @edb.line.unpack
0173               *--------------------------------------------------------------
0174               * INPUT
0175               * @parm1 = Line to unpack from editor buffer
0176               * @parm2 = Target row in frame buffer
0177               *--------------------------------------------------------------
0178               * OUTPUT
0179               * none
0180               *--------------------------------------------------------------
0181               * Register usage
0182               * tmp0,tmp1,tmp2,tmp3
0183               *--------------------------------------------------------------
0184               * Memory usage
0185               * rambuf    = Saved @parm1 of edb.line.unpack
0186               * rambuf+2  = Saved @parm2 of edb.line.unpack
0187               * rambuf+4  = Source memory address in editor buffer
0188               * rambuf+6  = Destination memory address in frame buffer
0189               * rambuf+8  = Length of RLE (decompressed) line
0190               * rambuf+10 = Length of RLE compressed line
0191               ********|*****|*********************|**************************
0192               edb.line.unpack:
0193 771C 0649  14         dect  stack
0194 771E C64B  30         mov   r11,*stack            ; Save return address
0195                       ;------------------------------------------------------
0196                       ; Save parameters
0197                       ;------------------------------------------------------
0198 7720 C820  54         mov   @parm1,@rambuf
     7722 8350 
     7724 8390 
0199 7726 C820  54         mov   @parm2,@rambuf+2
     7728 8352 
     772A 8392 
0200                       ;------------------------------------------------------
0201                       ; Calculate offset in frame buffer
0202                       ;------------------------------------------------------
0203 772C C120  34         mov   @fb.colsline,tmp0
     772E 220E 
0204 7730 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7732 8352 
0205 7734 C1A0  34         mov   @fb.top.ptr,tmp2
     7736 2200 
0206 7738 A146  18         a     tmp2,tmp1             ; Add base to offset
0207 773A C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     773C 8396 
0208                       ;------------------------------------------------------
0209                       ; Get length of line to unpack
0210                       ;------------------------------------------------------
0211 773E 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7740 779C 
0212                                                   ; \ .  parm1    = Line number
0213                                                   ; | o  outparm1 = Line length (uncompressed)
0214                                                   ; | o  outparm2 = Line length (compressed)
0215                                                   ; / o  outparm3 = SAMS bank (>0 - >a)
0216               
0217 7742 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     7744 8362 
     7746 839A 
0218 7748 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     774A 8360 
     774C 8398 
0219 774E 1307  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0220               
0221                       ;------------------------------------------------------
0222                       ; Index. Calculate address of entry and get pointer
0223                       ;------------------------------------------------------
0224 7750 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7752 7642 
0225                                                   ; \ .  parm1    = Line number
0226                                                   ; | o  outparm1 = Pointer to line
0227                                                   ; / o  outparm2 = SAMS bank
0228               
0229 7754 05E0  34         inct  @outparm1             ; Skip line prefix
     7756 8360 
0230 7758 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     775A 8360 
     775C 8394 
0231               
0232                       ;------------------------------------------------------
0233                       ; Erase chars from last column until column 80
0234                       ;------------------------------------------------------
0235               edb.line.unpack.clear:
0236 775E C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7760 8396 
0237 7762 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7764 8398 
0238               
0239 7766 04C5  14         clr   tmp1                  ; Fill with >00
0240 7768 C1A0  34         mov   @fb.colsline,tmp2
     776A 220E 
0241 776C 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     776E 8398 
0242 7770 0586  14         inc   tmp2
0243               
0244 7772 06A0  32         bl    @xfilm                ; Fill CPU memory
     7774 613C 
0245                                                   ; \ .  tmp0 = Target address
0246                                                   ; | .  tmp1 = Byte to fill
0247                                                   ; / .  tmp2 = Repeat count
0248               
0249                       ;------------------------------------------------------
0250                       ; Prepare for unpacking data
0251                       ;------------------------------------------------------
0252               edb.line.unpack.prepare:
0253 7776 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     7778 8398 
0254 777A 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0255 777C C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     777E 8394 
0256 7780 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7782 8396 
0257                       ;------------------------------------------------------
0258                       ; Either RLE decompress or do normal memory copy
0259                       ;------------------------------------------------------
0260 7784 C1E0  34         mov   @edb.rle,tmp3
     7786 230E 
0261 7788 1305  14         jeq   edb.line.unpack.copy.uncompressed
0262                       ;------------------------------------------------------
0263                       ; Uncompress RLE line to frame buffer
0264                       ;------------------------------------------------------
0265 778A C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     778C 839A 
0266               
0267 778E 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     7790 688E 
0268                                                   ; \ .  tmp0 = ROM/RAM source address
0269                                                   ; | .  tmp1 = RAM target address
0270                                                   ; / .  tmp2 = Length of RLE encoded data
0271 7792 1002  14         jmp   edb.line.unpack.exit
0272               
0273               edb.line.unpack.copy.uncompressed:
0274                       ;------------------------------------------------------
0275                       ; Copy memory block
0276                       ;------------------------------------------------------
0277 7794 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7796 6386 
0278                                                   ; \ .  tmp0 = Source address
0279                                                   ; | .  tmp1 = Target address
0280                                                   ; / .  tmp2 = Bytes to copy
0281                       ;------------------------------------------------------
0282                       ; Exit
0283                       ;------------------------------------------------------
0284               edb.line.unpack.exit:
0285 7798 0460  28         b     @poprt                ; Return to caller
     779A 6132 
0286               
0287               
0288               
0289               
0290               ***************************************************************
0291               * edb.line.getlength
0292               * Get length of specified line
0293               ***************************************************************
0294               *  bl   @edb.line.getlength
0295               *--------------------------------------------------------------
0296               * INPUT
0297               * @parm1 = Line number
0298               *--------------------------------------------------------------
0299               * OUTPUT
0300               * @outparm1 = Length of line (uncompressed)
0301               * @outparm2 = Length of line (compressed)
0302               * @outparm3 = SAMS bank (>0 - >a)
0303               *--------------------------------------------------------------
0304               * Register usage
0305               * tmp0,tmp1,tmp2
0306               ********|*****|*********************|**************************
0307               edb.line.getlength:
0308 779C 0649  14         dect  stack
0309 779E C64B  30         mov   r11,*stack            ; Save return address
0310                       ;------------------------------------------------------
0311                       ; Initialisation
0312                       ;------------------------------------------------------
0313 77A0 04E0  34         clr   @outparm1             ; Reset uncompressed length
     77A2 8360 
0314 77A4 04E0  34         clr   @outparm2             ; Reset compressed length
     77A6 8362 
0315 77A8 04E0  34         clr   @outparm3             ; Reset SAMS bank
     77AA 8364 
0316                       ;------------------------------------------------------
0317                       ; Get length
0318                       ;------------------------------------------------------
0319 77AC 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     77AE 7642 
0320                                                   ; \  parm1    = Line number
0321                                                   ; |  outparm1 = Pointer to line
0322                                                   ; /  outparm2 = SAMS bank
0323               
0324 77B0 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     77B2 8360 
0325 77B4 130D  14         jeq   edb.line.getlength.exit
0326                                                   ; Exit early if NULL pointer
0327 77B6 C820  54         mov   @outparm2,@outparm3   ; Save SAMS bank
     77B8 8362 
     77BA 8364 
0328                       ;------------------------------------------------------
0329                       ; Process line prefix
0330                       ;------------------------------------------------------
0331 77BC 04C5  14         clr   tmp1
0332 77BE D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0333 77C0 06C5  14         swpb  tmp1
0334 77C2 C805  38         mov   tmp1,@outparm2        ; Save length
     77C4 8362 
0335               
0336 77C6 04C5  14         clr   tmp1
0337 77C8 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0338 77CA 06C5  14         swpb  tmp1
0339 77CC C805  38         mov   tmp1,@outparm1        ; Save length
     77CE 8360 
0340                       ;------------------------------------------------------
0341                       ; Exit
0342                       ;------------------------------------------------------
0343               edb.line.getlength.exit:
0344 77D0 0460  28         b     @poprt                ; Return to caller
     77D2 6132 
0345               
0346               
0347               
0348               
0349               ***************************************************************
0350               * edb.line.getlength2
0351               * Get length of current row (as seen from editor buffer side)
0352               ***************************************************************
0353               *  bl   @edb.line.getlength2
0354               *--------------------------------------------------------------
0355               * INPUT
0356               * @fb.row = Row in frame buffer
0357               *--------------------------------------------------------------
0358               * OUTPUT
0359               * @fb.row.length = Length of row
0360               *--------------------------------------------------------------
0361               * Register usage
0362               * tmp0
0363               ********|*****|*********************|**************************
0364               edb.line.getlength2:
0365 77D4 0649  14         dect  stack
0366 77D6 C64B  30         mov   r11,*stack            ; Save return address
0367                       ;------------------------------------------------------
0368                       ; Calculate line in editor buffer
0369                       ;------------------------------------------------------
0370 77D8 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     77DA 2204 
0371 77DC A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     77DE 2206 
0372                       ;------------------------------------------------------
0373                       ; Get length
0374                       ;------------------------------------------------------
0375 77E0 C804  38         mov   tmp0,@parm1
     77E2 8350 
0376 77E4 06A0  32         bl    @edb.line.getlength
     77E6 779C 
0377 77E8 C820  54         mov   @outparm1,@fb.row.length
     77EA 8360 
     77EC 2208 
0378                                                   ; Save row length
0379                       ;------------------------------------------------------
0380                       ; Exit
0381                       ;------------------------------------------------------
0382               edb.line.getlength2.exit:
0383 77EE 0460  28         b     @poprt                ; Return to caller
     77F0 6132 
0384               
**** **** ****     > tivi.asm.25485
0621               
0622               
0623               ***************************************************************
0624               *               fh - File handling module
0625               ***************************************************************
0626                       copy  "filehandler.asm"
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
0028 77F2 0649  14         dect  stack
0029 77F4 C64B  30         mov   r11,*stack            ; Save return address
0030 77F6 C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     77F8 8352 
     77FA 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 77FC 04E0  34         clr   @tfh.records          ; Reset records counter
     77FE 242E 
0035 7800 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7802 2434 
0036 7804 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7806 2432 
0037 7808 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 780A 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     780C 242A 
0039 780E 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7810 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 7812 06A0  32         bl    @hchar
     7814 6540 
0044 7816 1D00                   byte 29,0,32,80
     7818 2050 
0045 781A FFFF                   data EOL
0046               
0047 781C 06A0  32         bl    @putat
     781E 6330 
0048 7820 1D00                   byte 29,0
0049 7822 7A34                   data txt_loading      ; Display "Loading...."
0050               
0051 7824 8820  54         c     @tfh.rleonload,@w$ffff
     7826 2436 
     7828 6048 
0052 782A 1604  14         jne   !
0053 782C 06A0  32         bl    @putat
     782E 6330 
0054 7830 1D44                   byte 29,68
0055 7832 7A44                   data txt_rle          ; Display "RLE"
0056               
0057 7834 06A0  32 !       bl    @at
     7836 644C 
0058 7838 1D0B                   byte 29,11            ; Cursor YX position
0059 783A C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     783C 8350 
0060 783E 06A0  32         bl    @xutst0               ; Display device/filename
     7840 6320 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 7842 06A0  32         bl    @cpym2v
     7844 6338 
0065 7846 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7848 79F6 
     784A 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 784C 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     784E 0A69 
0071 7850 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7852 8350 
0072 7854 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 7856 0986  56         srl   tmp2,8                ; Right justify
0074 7858 0586  14         inc   tmp2                  ; Include length byte as well
0075 785A 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     785C 633E 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 785E 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7860 6952 
0080 7862 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 7864 06A0  32         bl    @file.open
     7866 6AA0 
0085 7868 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 786A 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     786C 6042 
0087 786E 1602  14         jne   tfh.file.read.record
0088 7870 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7872 79AA 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 7874 05A0  34         inc   @tfh.records          ; Update counter
     7876 242E 
0094 7878 04E0  34         clr   @tfh.reclen           ; Reset record length
     787A 2430 
0095               
0096 787C 06A0  32         bl    @file.record.read     ; Read file record
     787E 6AE2 
0097 7880 0A60                   data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
0098                                                   ; | o  tmp0 = Status byte
0099                                                   ; | o  tmp1 = Bytes read
0100                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0101               
0102 7882 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7884 242A 
0103 7886 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7888 2430 
0104 788A C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     788C 242C 
0105                       ;------------------------------------------------------
0106                       ; 1a: Calculate kilobytes processed
0107                       ;------------------------------------------------------
0108 788E A805  38         a     tmp1,@tfh.counter
     7890 2434 
0109 7892 A160  34         a     @tfh.counter,tmp1
     7894 2434 
0110 7896 0285  22         ci    tmp1,1024
     7898 0400 
0111 789A 1106  14         jlt   !
0112 789C 05A0  34         inc   @tfh.kilobytes
     789E 2432 
0113 78A0 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     78A2 FC00 
0114 78A4 C805  38         mov   tmp1,@tfh.counter
     78A6 2434 
0115                       ;------------------------------------------------------
0116                       ; 1b: Load spectra scratchpad layout
0117                       ;------------------------------------------------------
0118 78A8 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     78AA 68D8 
0119 78AC 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     78AE 6974 
0120 78B0 2100                   data scrpad.backup2   ; / >2100->8300
0121                       ;------------------------------------------------------
0122                       ; 1c: Check if a file error occured
0123                       ;------------------------------------------------------
0124               tfh.file.read.check:
0125 78B2 C1A0  34         mov   @tfh.ioresult,tmp2
     78B4 242C 
0126 78B6 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     78B8 6042 
0127 78BA 1377  14         jeq   tfh.file.read.error
0128                                                   ; Yes, so handle file error
0129                       ;------------------------------------------------------
0130                       ; 1d: Decide on copy line from VDP buffer to editor
0131                       ;     buffer (RLE off) or RAM buffer (RLE on)
0132                       ;------------------------------------------------------
0133 78BC 8820  54         c     @tfh.rleonload,@w$ffff
     78BE 2436 
     78C0 6048 
0134                                                   ; RLE compression on?
0135 78C2 1314  14         jeq   tfh.file.read.compression
0136                                                   ; Yes, do RLE compression
0137                       ;------------------------------------------------------
0138                       ; Step 2: Process line without doing RLE compression
0139                       ;------------------------------------------------------
0140               tfh.file.read.nocompression:
0141 78C4 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     78C6 0960 
0142 78C8 C160  34         mov   @edb.next_free.ptr,tmp1
     78CA 2308 
0143                                                   ; RAM target in editor buffer
0144               
0145 78CC C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     78CE 8352 
0146               
0147 78D0 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     78D2 2430 
0148 78D4 1337  14         jeq   tfh.file.read.prepindex.emptyline
0149                                                   ; Handle empty line
0150                       ;------------------------------------------------------
0151                       ; 2a: Copy line from VDP to CPU editor buffer
0152                       ;------------------------------------------------------
0153                                                   ; Save line prefix
0154 78D6 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0155 78D8 06C6  14         swpb  tmp2                  ; |
0156 78DA DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0157 78DC 06C6  14         swpb  tmp2                  ; /
0158               
0159 78DE 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     78E0 2308 
0160 78E2 A806  38         a     tmp2,@edb.next_free.ptr
     78E4 2308 
0161                                                   ; Add line length
0162               
0163 78E6 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     78E8 6364 
0164                                                   ; \ .  tmp0 = VDP source address
0165                                                   ; | .  tmp1 = RAM target address
0166                                                   ; / .  tmp2 = Bytes to copy
0167               
0168 78EA 1028  14         jmp   tfh.file.read.prepindex
0169                                                   ; Prepare for updating index
0170                       ;------------------------------------------------------
0171                       ; Step 3: Process line and do RLE compression
0172                       ;------------------------------------------------------
0173               tfh.file.read.compression:
0174 78EC 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     78EE 0960 
0175 78F0 0205  20         li    tmp1,fb.top           ; RAM target address
     78F2 2650 
0176 78F4 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     78F6 2430 
0177 78F8 1325  14         jeq   tfh.file.read.prepindex.emptyline
0178                                                   ; Handle empty line
0179               
0180 78FA 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     78FC 6364 
0181                                                   ; \ .  tmp0 = VDP source address
0182                                                   ; | .  tmp1 = RAM target address
0183                                                   ; / .  tmp2 = Bytes to copy
0184               
0185                       ;------------------------------------------------------
0186                       ; 3a: RLE compression on line
0187                       ;------------------------------------------------------
0188 78FE 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     7900 2650 
0189 7902 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     7904 26F0 
0190 7906 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     7908 2430 
0191               
0192 790A 06A0  32         bl    @xcpu2rle             ; RLE compression
     790C 67DC 
0193                                                   ; \ .  tmp0  = ROM/RAM source address
0194                                                   ; | .  tmp1  = RAM target address
0195                                                   ; | .  tmp2  = Length uncompressed data
0196                                                   ; / o  waux1 = Length RLE encoded string
0197                       ;------------------------------------------------------
0198                       ; 3b: Set line prefix
0199                       ;------------------------------------------------------
0200 790E C160  34         mov   @edb.next_free.ptr,tmp1
     7910 2308 
0201                                                   ; RAM target address
0202 7912 C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     7914 8352 
0203 7916 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7918 833C 
0204 791A 06C6  14         swpb  tmp2                  ;
0205 791C DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0206               
0207 791E C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     7920 2430 
0208 7922 06C6  14         swpb  tmp2
0209 7924 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0210 7926 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     7928 2308 
0211                       ;------------------------------------------------------
0212                       ; 3c: Copy compressed line to editor buffer
0213                       ;------------------------------------------------------
0214 792A 0204  20         li    tmp0,fb.top+160       ; RAM source address
     792C 26F0 
0215 792E C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     7930 833C 
0216               
0217 7932 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7934 6386 
0218                                                   ; \ .  tmp0 = RAM source address
0219                                                   ; | .  tmp1 = RAM target address
0220                                                   ; / .  tmp2 = Bytes to copy
0221               
0222 7936 A820  54         a     @waux1,@edb.next_free.ptr
     7938 833C 
     793A 2308 
0223                                                   ; Update pointer to next free line
0224                       ;------------------------------------------------------
0225                       ; Step 4: Update index
0226                       ;------------------------------------------------------
0227               tfh.file.read.prepindex:
0228 793C C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     793E 2304 
     7940 8350 
0229                                                   ; parm2 = Must allready be set!
0230 7942 1007  14         jmp   tfh.file.read.updindex
0231                                                   ; Update index
0232                       ;------------------------------------------------------
0233                       ; 4a: Special handling for empty line
0234                       ;------------------------------------------------------
0235               tfh.file.read.prepindex.emptyline:
0236 7944 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7946 242E 
     7948 8350 
0237 794A 0620  34         dec   @parm1                ;         Adjust for base 0 index
     794C 8350 
0238 794E 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7950 8352 
0239                       ;------------------------------------------------------
0240                       ; 4b: Do actual index update
0241                       ;------------------------------------------------------
0242               tfh.file.read.updindex:
0243 7952 04E0  34         clr   @parm3
     7954 8354 
0244 7956 06A0  32         bl    @idx.entry.update     ; Update index
     7958 75C8 
0245                                                   ; \ .  parm1    = Line number in editor buffer
0246                                                   ; | .  parm2    = Pointer to line in editor buffer
0247                                                   ; | .  parm3    = SAMS bank (0-A)
0248                                                   ; / o  outparm1 = Pointer to updated index entry
0249               
0250 795A 05A0  34         inc   @edb.lines            ; lines=lines+1
     795C 2304 
0251                       ;------------------------------------------------------
0252                       ; Step 5: Display results
0253                       ;------------------------------------------------------
0254               tfh.file.read.display:
0255 795E 06A0  32         bl    @putnum
     7960 67CC 
0256 7962 1D49                   byte 29,73            ; Show lines read
0257 7964 2304                   data edb.lines,rambuf,>3020
     7966 8390 
     7968 3020 
0258               
0259 796A 8220  34         c     @tfh.kilobytes,tmp4
     796C 2432 
0260 796E 130C  14         jeq   tfh.file.read.checkmem
0261               
0262 7970 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7972 2432 
0263               
0264 7974 06A0  32         bl    @putnum
     7976 67CC 
0265 7978 1D38                   byte 29,56            ; Show kilobytes read
0266 797A 2432                   data tfh.kilobytes,rambuf,>3020
     797C 8390 
     797E 3020 
0267               
0268 7980 06A0  32         bl    @putat
     7982 6330 
0269 7984 1D3D                   byte 29,61
0270 7986 7A40                   data txt_kb           ; Show "kb" string
0271               
0272               ******************************************************
0273               * Stop reading file if high memory expansion gets full
0274               ******************************************************
0275               tfh.file.read.checkmem:
0276 7988 C120  34         mov   @edb.next_free.ptr,tmp0
     798A 2308 
0277 798C 0284  22         ci    tmp0,>ffa0
     798E FFA0 
0278 7990 1207  14         jle   tfh.file.read.next
0279 7992 1015  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0280                       ;------------------------------------------------------
0281                       ; Next SAMS page
0282                       ;------------------------------------------------------
0283 7994 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7996 230A 
0284 7998 0204  20         li    tmp0,edb.top
     799A A000 
0285 799C C804  38         mov   tmp0,@edb.next_free.ptr
     799E 2308 
0286                                                   ; Reset to top of editor buffer
0287                       ;------------------------------------------------------
0288                       ; Next record
0289                       ;------------------------------------------------------
0290               tfh.file.read.next:
0291 79A0 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     79A2 6952 
0292 79A4 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0293               
0294 79A6 0460  28         b     @tfh.file.read.record
     79A8 7874 
0295                                                   ; Next record
0296                       ;------------------------------------------------------
0297                       ; Error handler
0298                       ;------------------------------------------------------
0299               tfh.file.read.error:
0300 79AA C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     79AC 242A 
0301 79AE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0302 79B0 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     79B2 0005 
0303 79B4 1304  14         jeq   tfh.file.read.eof
0304                                                   ; All good. File closed by DSRLNK
0305                       ;------------------------------------------------------
0306                       ; File error occured
0307                       ;------------------------------------------------------
0308 79B6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     79B8 FFCE 
0309 79BA 06A0  32         bl    @crash                ; / Crash and halt system
     79BC 604C 
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               tfh.file.read.eof:
0314 79BE 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     79C0 6974 
0315 79C2 2100                   data scrpad.backup2   ; / >2100->8300
0316                       ;------------------------------------------------------
0317                       ; Display final results
0318                       ;------------------------------------------------------
0319 79C4 06A0  32         bl    @hchar
     79C6 6540 
0320 79C8 1D00                   byte 29,0,32,10       ; Erase loading indicator
     79CA 200A 
0321 79CC FFFF                   data EOL
0322               
0323 79CE 06A0  32         bl    @putnum
     79D0 67CC 
0324 79D2 1D38                   byte 29,56            ; Show kilobytes read
0325 79D4 2432                   data tfh.kilobytes,rambuf,>3020
     79D6 8390 
     79D8 3020 
0326               
0327 79DA 06A0  32         bl    @putat
     79DC 6330 
0328 79DE 1D3D                   byte 29,61
0329 79E0 7A40                   data txt_kb           ; Show "kb" string
0330               
0331 79E2 06A0  32         bl    @putnum
     79E4 67CC 
0332 79E6 1D49                   byte 29,73            ; Show lines read
0333 79E8 242E                   data tfh.records,rambuf,>3020
     79EA 8390 
     79EC 3020 
0334               
0335 79EE 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     79F0 2306 
0336               *--------------------------------------------------------------
0337               * Exit
0338               *--------------------------------------------------------------
0339               tfh.file.read_exit:
0340 79F2 0460  28         b     @poprt                ; Return to caller
     79F4 6132 
0341               
0342               
0343               ***************************************************************
0344               * PAB for accessing DV/80 file
0345               ********|*****|*********************|**************************
0346               tfh.file.pab.header:
0347 79F6 0014             byte  io.op.open            ;  0    - OPEN
0348                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0349 79F8 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0350 79FA 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0351                       byte  00                    ;  5    - Character count
0352 79FC 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0353 79FE 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0354                       ;------------------------------------------------------
0355                       ; File descriptor part (variable length)
0356                       ;------------------------------------------------------
0357                       ; byte  12                  ;  9    - File descriptor length
0358                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.25485
0627               
0628               
0629               ***************************************************************
0630               *                      Constants
0631               ***************************************************************
0632               romsat:
0633 7A00 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7A02 000F 
0634               
0635               cursors:
0636 7A04 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7A06 0000 
     7A08 0000 
     7A0A 001C 
0637 7A0C 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7A0E 1010 
     7A10 1010 
     7A12 1000 
0638 7A14 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7A16 1C1C 
     7A18 1C1C 
     7A1A 1C00 
0639               
0640               ***************************************************************
0641               *                       Strings
0642               ***************************************************************
0643               txt_delim
0644 7A1C 012C             byte  1
0645 7A1D ....             text  ','
0646                       even
0647               
0648               txt_marker
0649 7A1E 052A             byte  5
0650 7A1F ....             text  '*EOF*'
0651                       even
0652               
0653               txt_bottom
0654 7A24 0520             byte  5
0655 7A25 ....             text  '  BOT'
0656                       even
0657               
0658               txt_ovrwrite
0659 7A2A 034F             byte  3
0660 7A2B ....             text  'OVR'
0661                       even
0662               
0663               txt_insert
0664 7A2E 0349             byte  3
0665 7A2F ....             text  'INS'
0666                       even
0667               
0668               txt_star
0669 7A32 012A             byte  1
0670 7A33 ....             text  '*'
0671                       even
0672               
0673               txt_loading
0674 7A34 0A4C             byte  10
0675 7A35 ....             text  'Loading...'
0676                       even
0677               
0678               txt_kb
0679 7A40 026B             byte  2
0680 7A41 ....             text  'kb'
0681                       even
0682               
0683               txt_rle
0684 7A44 0352             byte  3
0685 7A45 ....             text  'RLE'
0686                       even
0687               
0688               txt_lines
0689 7A48 054C             byte  5
0690 7A49 ....             text  'Lines'
0691                       even
0692               
0693 7A4E 7A4E     end          data    $
0694               
0695               
0696               fdname0
0697 7A50 0D44             byte  13
0698 7A51 ....             text  'DSK1.INVADERS'
0699                       even
0700               
0701               fdname1
0702 7A5E 0F44             byte  15
0703 7A5F ....             text  'DSK1.SPEECHDOCS'
0704                       even
0705               
0706               fdname2
0707 7A6E 0C44             byte  12
0708 7A6F ....             text  'DSK1.XBEADOC'
0709                       even
0710               
0711               fdname3
0712 7A7C 0C44             byte  12
0713 7A7D ....             text  'DSK3.XBEADOC'
0714                       even
0715               
0716               fdname4
0717 7A8A 0C44             byte  12
0718 7A8B ....             text  'DSK3.C99MAN1'
0719                       even
0720               
0721               fdname5
0722 7A98 0C44             byte  12
0723 7A99 ....             text  'DSK3.C99MAN2'
0724                       even
0725               
0726               fdname6
0727 7AA6 0C44             byte  12
0728 7AA7 ....             text  'DSK3.C99MAN3'
0729                       even
0730               
0731               fdname7
0732 7AB4 0D44             byte  13
0733 7AB5 ....             text  'DSK3.C99SPECS'
0734                       even
0735               
0736               fdname8
0737 7AC2 0D44             byte  13
0738 7AC3 ....             text  'DSK3.RANDOM#C'
0739                       even
0740               
0741               fdname9
0742 7AD0 0D44             byte  13
0743 7AD1 ....             text  'DSK1.INVADERS'
0744                       even
0745               
0746               
0747               
0748               ***************************************************************
0749               *                  Sanity check on ROM size
0750               ***************************************************************
0754 7ADE 7ADE              data $   ; ROM size OK.

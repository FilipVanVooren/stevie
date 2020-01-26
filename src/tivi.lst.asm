XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.16324
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200126-16324
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
0191 6012 6BE6             data  runlib
0192               
0194               
0195 6014 1154             byte  17
0196 6015 ....             text  'TIVI 200126-16324'
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
0077                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
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
0026               ********|*****|*********************|**************************
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
     609E 6BEE 
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
     60AA 671A 
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
     60BE 671A 
0078 60C0 0115                   byte 1,21             ; \ .  p0 = YX position
0079 60C2 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0080 60C4 8390                   data rambuf           ; | .  p2 = Pointer to ram buffer
0081 60C6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0082                                                   ; /         LSB offset for ASCII digit 0-9
0083                       ;------------------------------------------------------
0084                       ; Kernel takes over
0085                       ;------------------------------------------------------
0086 60C8 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CA 6AFC 
0087               
0088 60CC 1553     crash.msg.crashed      byte 21
0089 60CD ....                            text 'System crashed near >'
0090               
0091 60E2 1543     crash.msg.caller       byte 21
0092 60E3 ....                            text 'Caller address near >'
**** **** ****     > runlib.asm
0087                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0008               ********|*****|*********************|**************************
0009 63E2 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     63E4 FFBF 
0010 63E6 0460  28         b     @putv01
     63E8 6246 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 63EA 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     63EC 0040 
0018 63EE 0460  28         b     @putv01
     63F0 6246 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 63F2 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     63F4 FFDF 
0026 63F6 0460  28         b     @putv01
     63F8 6246 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 63FA 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     63FC 0020 
0034 63FE 0460  28         b     @putv01
     6400 6246 
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
0009               ********|*****|*********************|**************************
0010 6402 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6404 FFFE 
0011 6406 0460  28         b     @putv01
     6408 6246 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 640A 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     640C 0001 
0019 640E 0460  28         b     @putv01
     6410 6246 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6412 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6414 FFFD 
0027 6416 0460  28         b     @putv01
     6418 6246 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 641A 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     641C 0002 
0035 641E 0460  28         b     @putv01
     6420 6246 
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
0017               ********|*****|*********************|**************************
0018 6422 C83B  50 at      mov   *r11+,@wyx
     6424 832A 
0019 6426 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6428 B820  54 down    ab    @hb$01,@wyx
     642A 6038 
     642C 832A 
0028 642E 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6430 7820  54 up      sb    @hb$01,@wyx
     6432 6038 
     6434 832A 
0037 6436 045B  20         b     *r11
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
0049 6438 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 643A D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     643C 832A 
0051 643E C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6440 832A 
0052 6442 045B  20         b     *r11
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
0020               ********|*****|*********************|**************************
0021 6444 C120  34 yx2px   mov   @wyx,tmp0
     6446 832A 
0022 6448 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 644A 06C4  14         swpb  tmp0                  ; Y<->X
0024 644C 04C5  14         clr   tmp1                  ; Clear before copy
0025 644E D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6450 20A0  38         coc   @wbit1,config         ; f18a present ?
     6452 6044 
0030 6454 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6456 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6458 833A 
     645A 6484 
0032 645C 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 645E 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6460 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6462 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6464 0500 
0037 6466 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6468 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 646A 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 646C 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 646E D105  18         movb  tmp1,tmp0
0051 6470 06C4  14         swpb  tmp0                  ; X<->Y
0052 6472 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6474 6046 
0053 6476 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6478 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     647A 6038 
0059 647C 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     647E 604A 
0060 6480 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6482 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6484 0050            data   80
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
0012               ********|*****|*********************|**************************
0013 6486 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6488 06A0  32         bl    @putvr                ; Write once
     648A 6232 
0015 648C 391C             data  >391c                 ; VR1/57, value 00011100
0016 648E 06A0  32         bl    @putvr                ; Write twice
     6490 6232 
0017 6492 391C             data  >391c                 ; VR1/57, value 00011100
0018 6494 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6496 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6498 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     649A 6232 
0028 649C 391C             data  >391c
0029 649E 0458  20         b     *tmp4                 ; Exit
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
0040 64A0 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 64A2 06A0  32         bl    @cpym2v
     64A4 6338 
0042 64A6 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     64A8 64E4 
     64AA 0006 
0043 64AC 06A0  32         bl    @putvr
     64AE 6232 
0044 64B0 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 64B2 06A0  32         bl    @putvr
     64B4 6232 
0046 64B6 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 64B8 0204  20         li    tmp0,>3f00
     64BA 3F00 
0052 64BC 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     64BE 61BA 
0053 64C0 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     64C2 8800 
0054 64C4 0984  56         srl   tmp0,8
0055 64C6 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     64C8 8800 
0056 64CA C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 64CC 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 64CE 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     64D0 BFFF 
0060 64D2 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 64D4 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     64D6 4000 
0063               f18chk_exit:
0064 64D8 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     64DA 618E 
0065 64DC 3F00             data  >3f00,>00,6
     64DE 0000 
     64E0 0006 
0066 64E2 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 64E4 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 64E6 3F00             data  >3f00                 ; 3f02 / 3f00
0073 64E8 0340             data  >0340                 ; 3f04   0340  idle
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
0092 64EA C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 64EC 06A0  32         bl    @putvr
     64EE 6232 
0097 64F0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 64F2 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     64F4 6232 
0100 64F6 391C             data  >391c                 ; Lock the F18a
0101 64F8 0458  20         b     *tmp4                 ; Exit
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
0120 64FA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 64FC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     64FE 6044 
0122 6500 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6502 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6504 8802 
0127 6506 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6508 6232 
0128 650A 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 650C 04C4  14         clr   tmp0
0130 650E D120  34         movb  @vdps,tmp0
     6510 8802 
0131 6512 0984  56         srl   tmp0,8
0132 6514 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0016               ********|*****|*********************|**************************
0017 6516 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     6518 832A 
0018 651A D17B  28         movb  *r11+,tmp1
0019 651C 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 651E D1BB  28         movb  *r11+,tmp2
0021 6520 0986  56         srl   tmp2,8                ; Repeat count
0022 6522 C1CB  18         mov   r11,tmp3
0023 6524 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6526 62FA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 6528 020B  20         li    r11,hchar1
     652A 6530 
0028 652C 0460  28         b     @xfilv                ; Draw
     652E 6194 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6530 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6532 6048 
0033 6534 1302  14         jeq   hchar2                ; Yes, exit
0034 6536 C2C7  18         mov   tmp3,r11
0035 6538 10EE  14         jmp   hchar                 ; Next one
0036 653A 05C7  14 hchar2  inct  tmp3
0037 653C 0457  20         b     *tmp3                 ; Exit
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
0015               ********|*****|*********************|**************************
0016 653E 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6540 6046 
0017 6542 020C  20         li    r12,>0024
     6544 0024 
0018 6546 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6548 65D6 
0019 654A 04C6  14         clr   tmp2
0020 654C 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 654E 04CC  14         clr   r12
0025 6550 1F08  20         tb    >0008                 ; Shift-key ?
0026 6552 1302  14         jeq   realk1                ; No
0027 6554 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6556 6606 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6558 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 655A 1302  14         jeq   realk2                ; No
0033 655C 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     655E 6636 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6560 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6562 1302  14         jeq   realk3                ; No
0039 6564 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6566 6666 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6568 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 656A 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 656C 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 656E E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6570 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6572 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6574 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6576 0006 
0052 6578 0606  14 realk5  dec   tmp2
0053 657A 020C  20         li    r12,>24               ; CRU address for P2-P4
     657C 0024 
0054 657E 06C6  14         swpb  tmp2
0055 6580 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6582 06C6  14         swpb  tmp2
0057 6584 020C  20         li    r12,6                 ; CRU read address
     6586 0006 
0058 6588 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 658A 0547  14         inv   tmp3                  ;
0060 658C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     658E FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6590 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6592 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6594 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6596 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6598 0285  22         ci    tmp1,8
     659A 0008 
0069 659C 1AFA  14         jl    realk6
0070 659E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 65A0 1BEB  14         jh    realk5                ; No, next column
0072 65A2 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 65A4 C206  18 realk8  mov   tmp2,tmp4
0077 65A6 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 65A8 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 65AA A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 65AC D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 65AE 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 65B0 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 65B2 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     65B4 6046 
0087 65B6 1608  14         jne   realka                ; No, continue saving key
0088 65B8 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     65BA 6600 
0089 65BC 1A05  14         jl    realka
0090 65BE 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     65C0 65FE 
0091 65C2 1B02  14         jh    realka                ; No, continue
0092 65C4 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     65C6 E000 
0093 65C8 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     65CA 833C 
0094 65CC E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     65CE 6030 
0095 65D0 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     65D2 8C00 
0096 65D4 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 65D6 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     65D8 0000 
     65DA FF0D 
     65DC 203D 
0099 65DE ....             text  'xws29ol.'
0100 65E6 ....             text  'ced38ik,'
0101 65EE ....             text  'vrf47ujm'
0102 65F6 ....             text  'btg56yhn'
0103 65FE ....             text  'zqa10p;/'
0104 6606 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6608 0000 
     660A FF0D 
     660C 202B 
0105 660E ....             text  'XWS@(OL>'
0106 6616 ....             text  'CED#*IK<'
0107 661E ....             text  'VRF$&UJM'
0108 6626 ....             text  'BTG%^YHN'
0109 662E ....             text  'ZQA!)P:-'
0110 6636 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6638 0000 
     663A FF0D 
     663C 2005 
0111 663E 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6640 0804 
     6642 0F27 
     6644 C2B9 
0112 6646 600B             data  >600b,>0907,>063f,>c1B8
     6648 0907 
     664A 063F 
     664C C1B8 
0113 664E 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6650 7B02 
     6652 015F 
     6654 C0C3 
0114 6656 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6658 7D0E 
     665A 0CC6 
     665C BFC4 
0115 665E 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6660 7C03 
     6662 BC22 
     6664 BDBA 
0116 6666 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6668 0000 
     666A FF0D 
     666C 209D 
0117 666E 9897             data  >9897,>93b2,>9f8f,>8c9B
     6670 93B2 
     6672 9F8F 
     6674 8C9B 
0118 6676 8385             data  >8385,>84b3,>9e89,>8b80
     6678 84B3 
     667A 9E89 
     667C 8B80 
0119 667E 9692             data  >9692,>86b4,>b795,>8a8D
     6680 86B4 
     6682 B795 
     6684 8A8D 
0120 6686 8294             data  >8294,>87b5,>b698,>888E
     6688 87B5 
     668A B698 
     668C 888E 
0121 668E 9A91             data  >9a91,>81b1,>b090,>9cBB
     6690 81B1 
     6692 B090 
     6694 9CBB 
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
0022               ********|*****|*********************|**************************
0023 6696 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6698 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     669A 8340 
0025 669C 04E0  34         clr   @waux1
     669E 833C 
0026 66A0 04E0  34         clr   @waux2
     66A2 833E 
0027 66A4 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     66A6 833C 
0028 66A8 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 66AA 0205  20         li    tmp1,4                ; 4 nibbles
     66AC 0004 
0033 66AE C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 66B0 0246  22         andi  tmp2,>000f            ; Only keep LSN
     66B2 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 66B4 0286  22         ci    tmp2,>000a
     66B6 000A 
0039 66B8 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 66BA C21B  26         mov   *r11,tmp4
0045 66BC 0988  56         srl   tmp4,8                ; Right justify
0046 66BE 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     66C0 FFF6 
0047 66C2 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 66C4 C21B  26         mov   *r11,tmp4
0054 66C6 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     66C8 00FF 
0055               
0056 66CA A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 66CC 06C6  14         swpb  tmp2
0058 66CE DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 66D0 0944  56         srl   tmp0,4                ; Next nibble
0060 66D2 0605  14         dec   tmp1
0061 66D4 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 66D6 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     66D8 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 66DA C160  34         mov   @waux3,tmp1           ; Get pointer
     66DC 8340 
0067 66DE 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 66E0 0585  14         inc   tmp1                  ; Next byte, not word!
0069 66E2 C120  34         mov   @waux2,tmp0
     66E4 833E 
0070 66E6 06C4  14         swpb  tmp0
0071 66E8 DD44  32         movb  tmp0,*tmp1+
0072 66EA 06C4  14         swpb  tmp0
0073 66EC DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 66EE C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     66F0 8340 
0078 66F2 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     66F4 603C 
0079 66F6 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 66F8 C120  34         mov   @waux1,tmp0
     66FA 833C 
0084 66FC 06C4  14         swpb  tmp0
0085 66FE DD44  32         movb  tmp0,*tmp1+
0086 6700 06C4  14         swpb  tmp0
0087 6702 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6704 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6706 6046 
0092 6708 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 670A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 670C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     670E 7FFF 
0098 6710 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6712 8340 
0099 6714 0460  28         b     @xutst0               ; Display string
     6716 6320 
0100 6718 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 671A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     671C 832A 
0122 671E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6720 8000 
0123 6722 10B9  14         jmp   mkhex                 ; Convert number and display
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
0018               ********|*****|*********************|**************************
0019 6724 0207  20 mknum   li    tmp3,5                ; Digit counter
     6726 0005 
0020 6728 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 672A C155  26         mov   *tmp1,tmp1            ; /
0022 672C C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 672E 0228  22         ai    tmp4,4                ; Get end of buffer
     6730 0004 
0024 6732 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6734 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6736 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6738 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 673A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 673C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 673E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6740 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6742 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6744 0607  14         dec   tmp3                  ; Decrease counter
0036 6746 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6748 0207  20         li    tmp3,4                ; Check first 4 digits
     674A 0004 
0041 674C 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 674E C11B  26         mov   *r11,tmp0
0043 6750 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6752 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6754 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6756 05CB  14 mknum3  inct  r11
0047 6758 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     675A 6046 
0048 675C 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 675E 045B  20         b     *r11                  ; Exit
0050 6760 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6762 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6764 13F8  14         jeq   mknum3                ; Yes, exit
0053 6766 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6768 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     676A 7FFF 
0058 676C C10B  18         mov   r11,tmp0
0059 676E 0224  22         ai    tmp0,-4
     6770 FFFC 
0060 6772 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6774 0206  20         li    tmp2,>0500            ; String length = 5
     6776 0500 
0062 6778 0460  28         b     @xutstr               ; Display string
     677A 6322 
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
0092 677C C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 677E C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6780 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6782 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6784 0207  20         li    tmp3,5                ; Set counter
     6786 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6788 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 678A 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 678C 0584  14         inc   tmp0                  ; Next character
0104 678E 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6790 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6792 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6794 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6796 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6798 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 679A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 679C 0607  14         dec   tmp3                  ; Last character ?
0120 679E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 67A0 045B  20         b     *r11                  ; Return
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
0138 67A2 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     67A4 832A 
0139 67A6 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     67A8 8000 
0140 67AA 10BC  14         jmp   mknum                 ; Convert number and display
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
0072               ********|*****|*********************|**************************
0073               cpu2rle:
0074 67AC C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 67AE C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 67B0 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 67B2 0649  14         dect  stack
0079 67B4 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 67B6 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 67B8 04C8  14         clr   tmp4                  ; Repeat counter
0086 67BA 04E0  34         clr   @waux1                ; Length of RLE string
     67BC 833C 
0087 67BE 04E0  34         clr   @waux2                ; Address of encoding byte
     67C0 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 67C2 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 67C4 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 67C6 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 67C8 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 67CA C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 67CC 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 67CE 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     67D0 0001 
0105 67D2 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 67D4 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 67D6 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 67D8 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 67DA 06A0  32         bl    @cpu2rle.flush.duplicates
     67DC 6826 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 67DE C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     67E0 833E 
     67E2 833E 
0126 67E4 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 67E6 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     67E8 833E 
0129 67EA 0585  14         inc   tmp1                  ; Skip encoding byte
0130 67EC 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     67EE 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 67F0 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 67F2 05A0  34         inc   @waux1                ; RLE string length += 1
     67F4 833C 
0136 67F6 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 67F8 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     67FA 833E 
     67FC 833E 
0145 67FE 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 6800 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6802 6840 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 6804 0588  14         inc   tmp4                  ; Increase repeat counter
0155 6806 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 6808 0606  14         dec   tmp2
0162 680A 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 680C C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 680E 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 6810 06A0  32         bl    @cpu2rle.flush.duplicates
     6812 6826 
0175                                                   ; (3.2) Flush pending ...
0176 6814 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 6816 C820  54         mov   @waux2,@waux2
     6818 833E 
     681A 833E 
0182 681C 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 681E 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6820 6840 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 6822 0460  28         b     @poprt                ; Return
     6824 6132 
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
0204 6826 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 6828 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 682A 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 682C 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     682E 8000 
0210 6830 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 6832 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6834 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 6836 05E0  34         inct  @waux1                ; RLE string length += 2
     6838 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 683A 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 683C 04C8  14         clr   tmp4                  ; Clear repeat count
0220 683E 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 6840 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 6842 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6844 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 6846 61E0  34         s     @waux2,tmp3           ; | characters
     6848 833E 
0232 684A 0607  14         dec   tmp3                  ; /
0233               
0234 684C 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 684E C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     6850 833E 
0236 6852 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6854 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6856 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6858 833E 
0240 685A 04C8  14         clr   tmp4                  ; Clear before exit
0241 685C 045B  20         b     *r11                  ; Return
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
0029               ********|*****|*********************|**************************
0030               rle2cpu:
0031 685E C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 6860 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6862 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6864 0649  14         dect  stack
0036 6866 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6868 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 686A 0606  14         dec   tmp2                  ; Update length
0043 686C 131E  14         jeq   rle2cpu.exit          ; End of list
0044 686E 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 6870 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6872 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6874 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 6876 0649  14         dect  stack
0055 6878 C646  30         mov   tmp2,*stack           ; Push tmp2
0056 687A C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 687C 06A0  32         bl    @xpym2m               ; Block copy to destination
     687E 6386 
0059                                                   ; \ .  tmp0 = Source address
0060                                                   ; | .  tmp1 = Target address
0061                                                   ; / .  tmp2 = Bytes to copy
0062               
0063 6880 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6882 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6884 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 6886 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 6888 0649  14         dect  stack
0073 688A C645  30         mov   tmp1,*stack           ; Push tmp1
0074 688C 0649  14         dect  stack
0075 688E C646  30         mov   tmp2,*stack           ; Push tmp2
0076 6890 0649  14         dect  stack
0077 6892 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6894 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 6896 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 6898 0985  56         srl   tmp1,8                ; Right align
0082               
0083 689A 06A0  32         bl    @xfilm                ; Block fill to destination
     689C 613C 
0084                                                   ; \ .  tmp0 = Target address
0085                                                   ; | .  tmp1 = Byte to fill
0086                                                   ; / .  tmp2 = Repeat count
0087               
0088 689E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 68A0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 68A2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 68A4 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 68A6 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 68A8 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 68AA 0460  28         b     @poprt                ; Return
     68AC 6132 
**** **** ****     > runlib.asm
0193               
0197               
0201               
0203                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0020 68AE C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     68B0 2000 
0021 68B2 C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     68B4 2002 
0022 68B6 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     68B8 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 68BA 0200  20         li    r0,>8306              ; Scratpad source address
     68BC 8306 
0027 68BE 0201  20         li    r1,>2006              ; RAM target address
     68C0 2006 
0028 68C2 0202  20         li    r2,62                 ; Loop counter
     68C4 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 68C6 CC70  46         mov   *r0+,*r1+
0034 68C8 CC70  46         mov   *r0+,*r1+
0035 68CA 0642  14         dect  r2
0036 68CC 16FC  14         jne   cpu.scrpad.backup.copy
0037 68CE C820  54         mov   @>83fe,@>20fe         ; Copy last word
     68D0 83FE 
     68D2 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 68D4 C020  34         mov   @>2000,r0             ; Restore r0
     68D6 2000 
0042 68D8 C060  34         mov   @>2002,r1             ; Restore r1
     68DA 2002 
0043 68DC C0A0  34         mov   @>2004,r2             ; Restore r2
     68DE 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 68E0 045B  20         b     *r11                  ; Return to caller
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
0066 68E2 C820  54         mov   @>2000,@>8300
     68E4 2000 
     68E6 8300 
0067 68E8 C820  54         mov   @>2002,@>8302
     68EA 2002 
     68EC 8302 
0068 68EE C820  54         mov   @>2004,@>8304
     68F0 2004 
     68F2 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 68F4 C800  38         mov   r0,@>2000
     68F6 2000 
0073 68F8 C801  38         mov   r1,@>2002
     68FA 2002 
0074 68FC C802  38         mov   r2,@>2004
     68FE 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 6900 0200  20         li    r0,>2006
     6902 2006 
0079 6904 0201  20         li    r1,>8306
     6906 8306 
0080 6908 0202  20         li    r2,62
     690A 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 690C CC70  46         mov   *r0+,*r1+
0086 690E CC70  46         mov   *r0+,*r1+
0087 6910 0642  14         dect  r2
0088 6912 16FC  14         jne   cpu.scrpad.restore.copy
0089 6914 C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6916 20FE 
     6918 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 691A C020  34         mov   @>2000,r0             ; Restore r0
     691C 2000 
0094 691E C060  34         mov   @>2002,r1             ; Restore r1
     6920 2002 
0095 6922 C0A0  34         mov   @>2004,r2             ; Restore r2
     6924 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6926 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0204                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 6928 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xcpu.scrpad.pgout:
0029 692A 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     692C 8300 
0030 692E C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6930 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6932 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6934 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6936 0606  14         dec   tmp2
0037 6938 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 693A C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 693C 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     693E 6944 
0043                                                   ; R14=PC
0044 6940 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6942 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               cpu.scrpad.pgout.after.rtwp:
0054 6944 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6946 68E2 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cpu.scrpad.pgout.$$:
0060 6948 045B  20         b     *r11                  ; Return to caller
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
0077 694A C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xcpu.scrpad.pgin:
0082 694C 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     694E 8300 
0083 6950 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6952 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6954 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6956 0606  14         dec   tmp2
0089 6958 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 695A 02E0  18         lwpi  >8300                 ; Activate copied workspace
     695C 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               cpu.scrpad.pgin.$$:
0098 695E 045B  20         b     *r11                  ; Return to caller
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
0209                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0041 6960 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6962 6964             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6964 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6966 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6968 8322 
0049 696A 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     696C 6042 
0050 696E C020  34         mov   @>8356,r0             ; get ptr to pab
     6970 8356 
0051 6972 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6974 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6976 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6978 06C0  14         swpb  r0                    ;
0059 697A D800  38         movb  r0,@vdpa              ; send low byte
     697C 8C02 
0060 697E 06C0  14         swpb  r0                    ;
0061 6980 D800  38         movb  r0,@vdpa              ; send high byte
     6982 8C02 
0062 6984 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6986 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6988 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 698A 0704  14         seto  r4                    ; init counter
0070 698C 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     698E 2420 
0071 6990 0580  14 !       inc   r0                    ; point to next char of name
0072 6992 0584  14         inc   r4                    ; incr char counter
0073 6994 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6996 0007 
0074 6998 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 699A 80C4  18         c     r4,r3                 ; end of name?
0077 699C 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 699E 06C0  14         swpb  r0                    ;
0082 69A0 D800  38         movb  r0,@vdpa              ; send low byte
     69A2 8C02 
0083 69A4 06C0  14         swpb  r0                    ;
0084 69A6 D800  38         movb  r0,@vdpa              ; send high byte
     69A8 8C02 
0085 69AA D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     69AC 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 69AE DC81  32         movb  r1,*r2+               ; move into buffer
0092 69B0 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     69B2 6A74 
0093 69B4 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 69B6 C104  18         mov   r4,r4                 ; Check if length = 0
0099 69B8 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 69BA 04E0  34         clr   @>83d0
     69BC 83D0 
0102 69BE C804  38         mov   r4,@>8354             ; save name length for search
     69C0 8354 
0103 69C2 0584  14         inc   r4                    ; adjust for dot
0104 69C4 A804  38         a     r4,@>8356             ; point to position after name
     69C6 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 69C8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     69CA 83E0 
0110 69CC 04C1  14         clr   r1                    ; version found of dsr
0111 69CE 020C  20         li    r12,>0f00             ; init cru addr
     69D0 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 69D2 C30C  18         mov   r12,r12               ; anything to turn off?
0117 69D4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 69D6 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 69D8 022C  22         ai    r12,>0100             ; next rom to turn on
     69DA 0100 
0125 69DC 04E0  34         clr   @>83d0                ; clear in case we are done
     69DE 83D0 
0126 69E0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     69E2 2000 
0127 69E4 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 69E6 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     69E8 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 69EA 1D00  20         sbo   0                     ; turn on rom
0134 69EC 0202  20         li    r2,>4000              ; start at beginning of rom
     69EE 4000 
0135 69F0 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     69F2 6A70 
0136 69F4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 69F6 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     69F8 240A 
0146 69FA 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 69FC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     69FE 83D2 
0152 6A00 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6A02 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6A04 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6A06 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6A08 83D2 
0161 6A0A 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6A0C C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6A0E 04C5  14         clr   r5                    ; Remove any old stuff
0167 6A10 D160  34         movb  @>8355,r5             ; get length as counter
     6A12 8355 
0168 6A14 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6A16 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6A18 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6A1A 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6A1C 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6A1E 2420 
0175 6A20 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6A22 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6A24 0605  14         dec   r5                    ; loop until full length checked
0179 6A26 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6A28 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6A2A 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6A2C 0581  14         inc   r1                    ; next version found
0191 6A2E 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6A30 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6A32 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6A34 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6A36 2400 
0200 6A38 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6A3A C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6A3C 8322 
0202                                                   ; (8 or >a)
0203 6A3E 0281  22         ci    r1,8                  ; was it 8?
     6A40 0008 
0204 6A42 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6A44 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6A46 8350 
0206                                                   ; Get error byte from @>8350
0207 6A48 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6A4A 06C0  14         swpb  r0                    ;
0215 6A4C D800  38         movb  r0,@vdpa              ; send low byte
     6A4E 8C02 
0216 6A50 06C0  14         swpb  r0                    ;
0217 6A52 D800  38         movb  r0,@vdpa              ; send high byte
     6A54 8C02 
0218 6A56 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6A58 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6A5A 09D1  56         srl   r1,13                 ; just keep error bits
0226 6A5C 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6A5E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6A60 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6A62 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6A64 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6A66 06C1  14         swpb  r1                    ; put error in hi byte
0239 6A68 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6A6A F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6A6C 6042 
0241 6A6E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6A70 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6A72 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6A74 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6A76 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6A78 C04B  18         mov   r11,r1                ; Save return address
0049 6A7A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6A7C 2428 
0050 6A7E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6A80 04C5  14         clr   tmp1                  ; io.op.open
0052 6A82 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6A84 61CC 
0053               file.open_init:
0054 6A86 0220  22         ai    r0,9                  ; Move to file descriptor length
     6A88 0009 
0055 6A8A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6A8C 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6A8E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6A90 6960 
0061 6A92 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6A94 1029  14         jmp   file.record.pab.details
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
0090 6A96 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6A98 C04B  18         mov   r11,r1                ; Save return address
0096 6A9A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6A9C 2428 
0097 6A9E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6AA0 0205  20         li    tmp1,io.op.close      ; io.op.close
     6AA2 0001 
0099 6AA4 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6AA6 61CC 
0100               file.close_init:
0101 6AA8 0220  22         ai    r0,9                  ; Move to file descriptor length
     6AAA 0009 
0102 6AAC C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6AAE 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6AB0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6AB2 6960 
0108 6AB4 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6AB6 1018  14         jmp   file.record.pab.details
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
0139 6AB8 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6ABA C04B  18         mov   r11,r1                ; Save return address
0145 6ABC C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6ABE 2428 
0146 6AC0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6AC2 0205  20         li    tmp1,io.op.read       ; io.op.read
     6AC4 0002 
0148 6AC6 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6AC8 61CC 
0149               file.record.read_init:
0150 6ACA 0220  22         ai    r0,9                  ; Move to file descriptor length
     6ACC 0009 
0151 6ACE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6AD0 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6AD2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6AD4 6960 
0157 6AD6 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6AD8 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6ADA 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6ADC 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6ADE 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6AE0 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6AE2 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6AE4 1000  14         nop
0191               
0192               
0193               file.status:
0194 6AE6 1000  14         nop
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
0211 6AE8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6AEA C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6AEC 2428 
0219 6AEE 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6AF0 0005 
0220 6AF2 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6AF4 61E4 
0221 6AF6 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6AF8 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6AFA 0451  20         b     *r1                   ; Return to caller
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
0019               ********|*****|*********************|**************************
0020 6AFC 0300  24 tmgr    limi  0                     ; No interrupt processing
     6AFE 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6B00 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6B02 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6B04 2360  38         coc   @wbit2,r13            ; C flag on ?
     6B06 6042 
0029 6B08 1602  14         jne   tmgr1a                ; No, so move on
0030 6B0A E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6B0C 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6B0E 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6B10 6046 
0035 6B12 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6B14 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6B16 6036 
0048 6B18 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6B1A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6B1C 6034 
0050 6B1E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6B20 0460  28         b     @kthread              ; Run kernel thread
     6B22 6B9A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6B24 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6B26 603A 
0056 6B28 13EB  14         jeq   tmgr1
0057 6B2A 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6B2C 6038 
0058 6B2E 16E8  14         jne   tmgr1
0059 6B30 C120  34         mov   @wtiusr,tmp0
     6B32 832E 
0060 6B34 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6B36 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6B38 6B98 
0065 6B3A C10A  18         mov   r10,tmp0
0066 6B3C 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6B3E 00FF 
0067 6B40 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6B42 6042 
0068 6B44 1303  14         jeq   tmgr5
0069 6B46 0284  22         ci    tmp0,60               ; 1 second reached ?
     6B48 003C 
0070 6B4A 1002  14         jmp   tmgr6
0071 6B4C 0284  22 tmgr5   ci    tmp0,50
     6B4E 0032 
0072 6B50 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6B52 1001  14         jmp   tmgr8
0074 6B54 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6B56 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6B58 832C 
0079 6B5A 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6B5C FF00 
0080 6B5E C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6B60 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6B62 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6B64 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6B66 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6B68 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6B6A 830C 
     6B6C 830D 
0089 6B6E 1608  14         jne   tmgr10                ; No, get next slot
0090 6B70 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6B72 FF00 
0091 6B74 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6B76 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6B78 8330 
0096 6B7A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6B7C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6B7E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6B80 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6B82 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6B84 8315 
     6B86 8314 
0103 6B88 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6B8A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6B8C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6B8E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6B90 10F7  14         jmp   tmgr10                ; Process next slot
0108 6B92 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6B94 FF00 
0109 6B96 10B4  14         jmp   tmgr1
0110 6B98 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0014               ********|*****|*********************|**************************
0015 6B9A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6B9C 6036 
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
0041 6B9E 06A0  32         bl    @realkb               ; Scan full keyboard
     6BA0 653E 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6BA2 0460  28         b     @tmgr3                ; Exit
     6BA4 6B24 
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
0016               ********|*****|*********************|**************************
0017 6BA6 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6BA8 832E 
0018 6BAA E0A0  34         soc   @wbit7,config         ; Enable user hook
     6BAC 6038 
0019 6BAE 045B  20 mkhoo1  b     *r11                  ; Return
0020      6B00     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6BB0 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6BB2 832E 
0029 6BB4 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6BB6 FEFF 
0030 6BB8 045B  20         b     *r11                  ; Return
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
0016               ********|*****|*********************|**************************
0017 6BBA C13B  30 mkslot  mov   *r11+,tmp0
0018 6BBC C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6BBE C184  18         mov   tmp0,tmp2
0023 6BC0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6BC2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6BC4 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6BC6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6BC8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6BCA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6BCC 881B  46         c     *r11,@w$ffff          ; End of list ?
     6BCE 6048 
0035 6BD0 1301  14         jeq   mkslo1                ; Yes, exit
0036 6BD2 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6BD4 05CB  14 mkslo1  inct  r11
0041 6BD6 045B  20         b     *r11                  ; Exit
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
0052 6BD8 C13B  30 clslot  mov   *r11+,tmp0
0053 6BDA 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6BDC A120  34         a     @wtitab,tmp0          ; Add table base
     6BDE 832C 
0055 6BE0 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6BE2 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6BE4 045B  20         b     *r11                  ; Exit
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
0245               ********|*****|*********************|**************************
0247 6BE6 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6BE8 68AE 
0248 6BEA 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6BEC 8302 
0252               *--------------------------------------------------------------
0253               * Alternative entry point
0254               *--------------------------------------------------------------
0255 6BEE 0300  24 runli1  limi  0                     ; Turn off interrupts
     6BF0 0000 
0256 6BF2 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6BF4 8300 
0257 6BF6 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6BF8 83C0 
0258               *--------------------------------------------------------------
0259               * Clear scratch-pad memory from R4 upwards
0260               *--------------------------------------------------------------
0261 6BFA 0202  20 runli2  li    r2,>8308
     6BFC 8308 
0262 6BFE 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0263 6C00 0282  22         ci    r2,>8400
     6C02 8400 
0264 6C04 16FC  14         jne   runli3
0265               *--------------------------------------------------------------
0266               * Exit to TI-99/4A title screen ?
0267               *--------------------------------------------------------------
0268               runli3a
0269 6C06 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6C08 FFFF 
0270 6C0A 1602  14         jne   runli4                ; No, continue
0271 6C0C 0420  54         blwp  @0                    ; Yes, bye bye
     6C0E 0000 
0272               *--------------------------------------------------------------
0273               * Determine if VDP is PAL or NTSC
0274               *--------------------------------------------------------------
0275 6C10 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6C12 833C 
0276 6C14 04C1  14         clr   r1                    ; Reset counter
0277 6C16 0202  20         li    r2,10                 ; We test 10 times
     6C18 000A 
0278 6C1A C0E0  34 runli5  mov   @vdps,r3
     6C1C 8802 
0279 6C1E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6C20 6046 
0280 6C22 1302  14         jeq   runli6
0281 6C24 0581  14         inc   r1                    ; Increase counter
0282 6C26 10F9  14         jmp   runli5
0283 6C28 0602  14 runli6  dec   r2                    ; Next test
0284 6C2A 16F7  14         jne   runli5
0285 6C2C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6C2E 1250 
0286 6C30 1202  14         jle   runli7                ; No, so it must be NTSC
0287 6C32 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6C34 6042 
0288               *--------------------------------------------------------------
0289               * Copy machine code to scratchpad (prepare tight loop)
0290               *--------------------------------------------------------------
0291 6C36 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6C38 6120 
0292 6C3A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6C3C 8322 
0293 6C3E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0294 6C40 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0295 6C42 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0296               *--------------------------------------------------------------
0297               * Initialize registers, memory, ...
0298               *--------------------------------------------------------------
0299 6C44 04C1  14 runli9  clr   r1
0300 6C46 04C2  14         clr   r2
0301 6C48 04C3  14         clr   r3
0302 6C4A 0209  20         li    stack,>8400           ; Set stack
     6C4C 8400 
0303 6C4E 020F  20         li    r15,vdpw              ; Set VDP write address
     6C50 8C00 
0307               *--------------------------------------------------------------
0308               * Setup video memory
0309               *--------------------------------------------------------------
0311 6C52 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6C54 4A4A 
0312 6C56 1605  14         jne   runlia
0313 6C58 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6C5A 618E 
0314 6C5C 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6C5E 0000 
     6C60 3FFF 
0319 6C62 06A0  32 runlia  bl    @filv
     6C64 618E 
0320 6C66 0FC0             data  pctadr,spfclr,16      ; Load color table
     6C68 00F4 
     6C6A 0010 
0321               *--------------------------------------------------------------
0322               * Check if there is a F18A present
0323               *--------------------------------------------------------------
0327 6C6C 06A0  32         bl    @f18unl               ; Unlock the F18A
     6C6E 6486 
0328 6C70 06A0  32         bl    @f18chk               ; Check if F18A is there
     6C72 64A0 
0329 6C74 06A0  32         bl    @f18lck               ; Lock the F18A again
     6C76 6496 
0331               *--------------------------------------------------------------
0332               * Check if there is a speech synthesizer attached
0333               *--------------------------------------------------------------
0335               *       <<skipped>>
0339               *--------------------------------------------------------------
0340               * Load video mode table & font
0341               *--------------------------------------------------------------
0342 6C78 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6C7A 61F8 
0343 6C7C 6116             data  spvmod                ; Equate selected video mode table
0344 6C7E 0204  20         li    tmp0,spfont           ; Get font option
     6C80 000C 
0345 6C82 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0346 6C84 1304  14         jeq   runlid                ; Yes, skip it
0347 6C86 06A0  32         bl    @ldfnt
     6C88 6260 
0348 6C8A 1100             data  fntadr,spfont         ; Load specified font
     6C8C 000C 
0349               *--------------------------------------------------------------
0350               * Did a system crash occur before runlib was called?
0351               *--------------------------------------------------------------
0352 6C8E 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6C90 4A4A 
0353 6C92 1602  14         jne   runlie                ; No, continue
0354 6C94 0460  28         b     @crash.main           ; Yes, back to crash handler
     6C96 60A0 
0355               *--------------------------------------------------------------
0356               * Branch to main program
0357               *--------------------------------------------------------------
0358 6C98 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6C9A 0040 
0359 6C9C 0460  28         b     @main                 ; Give control to main program
     6C9E 6CA0 
**** **** ****     > tivi.asm.16324
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
0226 6CA0 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6CA2 6044 
0227 6CA4 1302  14         jeq   main.continue
0228 6CA6 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6CA8 0000 
0229               
0230               main.continue:
0231 6CAA 06A0  32         bl    @scroff               ; Turn screen off
     6CAC 63E2 
0232 6CAE 06A0  32         bl    @f18unl               ; Unlock the F18a
     6CB0 6486 
0233 6CB2 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6CB4 6232 
0234 6CB6 3140                   data >3140            ; F18a VR49 (>31), bit 40
0235                       ;------------------------------------------------------
0236                       ; Initialize VDP SIT
0237                       ;------------------------------------------------------
0238 6CB8 06A0  32         bl    @filv
     6CBA 618E 
0239 6CBC 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6CBE 0020 
     6CC0 09B0 
0240 6CC2 06A0  32         bl    @scron                ; Turn screen on
     6CC4 63EA 
0241                       ;------------------------------------------------------
0242                       ; Initialize low + high memory expansion
0243                       ;------------------------------------------------------
0244 6CC6 06A0  32         bl    @film
     6CC8 6136 
0245 6CCA 2200                   data >2200,00,8*1024-256*2
     6CCC 0000 
     6CCE 3E00 
0246                                                   ; Clear part of 8k low-memory
0247               
0248 6CD0 06A0  32         bl    @film
     6CD2 6136 
0249 6CD4 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6CD6 0000 
     6CD8 6000 
0250                       ;------------------------------------------------------
0251                       ; Setup cursor, screen, etc.
0252                       ;------------------------------------------------------
0253 6CDA 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6CDC 6402 
0254 6CDE 06A0  32         bl    @s8x8                 ; Small sprite
     6CE0 6412 
0255               
0256 6CE2 06A0  32         bl    @cpym2m
     6CE4 6380 
0257 6CE6 79C6                   data romsat,ramsat,4  ; Load sprite SAT
     6CE8 8380 
     6CEA 0004 
0258               
0259 6CEC C820  54         mov   @romsat+2,@fb.curshape
     6CEE 79C8 
     6CF0 2210 
0260                                                   ; Save cursor shape & color
0261               
0262 6CF2 06A0  32         bl    @cpym2v
     6CF4 6338 
0263 6CF6 1800                   data sprpdt,cursors,3*8
     6CF8 79CA 
     6CFA 0018 
0264                                                   ; Load sprite cursor patterns
0265               *--------------------------------------------------------------
0266               * Initialize
0267               *--------------------------------------------------------------
0268 6CFC 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6CFE 763A 
0269 6D00 06A0  32         bl    @idx.init             ; Initialize index
     6D02 7574 
0270 6D04 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6D06 7498 
0271               
0272                       ;-------------------------------------------------------
0273                       ; Setup editor tasks & hook
0274                       ;-------------------------------------------------------
0275 6D08 0204  20         li    tmp0,>0200
     6D0A 0200 
0276 6D0C C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6D0E 8314 
0277               
0278 6D10 06A0  32         bl    @at
     6D12 6422 
0279 6D14 0000             data  >0000                 ; Cursor YX position = >0000
0280               
0281 6D16 0204  20         li    tmp0,timers
     6D18 8370 
0282 6D1A C804  38         mov   tmp0,@wtitab
     6D1C 832C 
0283               
0284 6D1E 06A0  32         bl    @mkslot
     6D20 6BBA 
0285 6D22 0001                   data >0001,task0      ; Task 0 - Update screen
     6D24 7312 
0286 6D26 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6D28 7396 
0287 6D2A 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6D2C 73A4 
     6D2E FFFF 
0288               
0289 6D30 06A0  32         bl    @mkhook
     6D32 6BA6 
0290 6D34 6D3A                   data editor           ; Setup user hook
0291               
0292 6D36 0460  28         b     @tmgr                 ; Start timers and kthread
     6D38 6AFC 
0293               
0294               
0295               ****************************************************************
0296               * Editor - Main loop
0297               ****************************************************************
0298 6D3A 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6D3C 6030 
0299 6D3E 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0300               *---------------------------------------------------------------
0301               * Identical key pressed ?
0302               *---------------------------------------------------------------
0303 6D40 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6D42 6030 
0304 6D44 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6D46 833C 
     6D48 833E 
0305 6D4A 1308  14         jeq   ed_wait
0306               *--------------------------------------------------------------
0307               * New key pressed
0308               *--------------------------------------------------------------
0309               ed_new_key
0310 6D4C C820  54         mov   @waux1,@waux2         ; Save as previous key
     6D4E 833C 
     6D50 833E 
0311 6D52 1045  14         jmp   edkey                 ; Process key
0312               *--------------------------------------------------------------
0313               * Clear keyboard buffer if no key pressed
0314               *--------------------------------------------------------------
0315               ed_clear_kbbuffer
0316 6D54 04E0  34         clr   @waux1
     6D56 833C 
0317 6D58 04E0  34         clr   @waux2
     6D5A 833E 
0318               *--------------------------------------------------------------
0319               * Delay to avoid key bouncing
0320               *--------------------------------------------------------------
0321               ed_wait
0322 6D5C 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6D5E 0708 
0323                       ;------------------------------------------------------
0324                       ; Delay loop
0325                       ;------------------------------------------------------
0326               ed_wait_loop
0327 6D60 0604  14         dec   tmp0
0328 6D62 16FE  14         jne   ed_wait_loop
0329               *--------------------------------------------------------------
0330               * Exit
0331               *--------------------------------------------------------------
0332 6D64 0460  28 ed_exit b     @hookok               ; Return
     6D66 6B00 
0333               
0334               
0335               
0336               
0337               
0338               
0339               ***************************************************************
0340               *                Tivi - Editor keyboard actions
0341               ***************************************************************
0342                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 6D68 0D00             data  key_enter,edkey.action.enter          ; New line
     6D6A 71CC 
0056 6D6C 0800             data  key_left,edkey.action.left            ; Move cursor left
     6D6E 6E00 
0057 6D70 0900             data  key_right,edkey.action.right          ; Move cursor right
     6D72 6E16 
0058 6D74 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6D76 6E2E 
0059 6D78 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6D7A 6E80 
0060 6D7C 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6D7E 6EEC 
0061 6D80 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6D82 6F04 
0062 6D84 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6D86 6F18 
0063 6D88 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6D8A 6F6A 
0064 6D8C 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6D8E 6FCA 
0065 6D90 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6D92 7014 
0066 6D94 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6D96 7040 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 6D98 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6D9A 706E 
0071 6D9C 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6D9E 70A6 
0072 6DA0 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6DA2 70DA 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 6DA4 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6DA6 7132 
0077 6DA8 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6DAA 723A 
0078 6DAC 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6DAE 7188 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 6DB0 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6DB2 728A 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 6DB4 B000             data  key_buf0,edkey.action.buffer0
     6DB6 72D6 
0087 6DB8 B100             data  key_buf1,edkey.action.buffer1
     6DBA 72DC 
0088 6DBC B200             data  key_buf2,edkey.action.buffer2
     6DBE 72E2 
0089 6DC0 B300             data  key_buf3,edkey.action.buffer3
     6DC2 72E8 
0090 6DC4 B400             data  key_buf4,edkey.action.buffer4
     6DC6 72EE 
0091 6DC8 B500             data  key_buf5,edkey.action.buffer5
     6DCA 72F4 
0092 6DCC B600             data  key_buf6,edkey.action.buffer6
     6DCE 72FA 
0093 6DD0 B700             data  key_buf7,edkey.action.buffer7
     6DD2 7300 
0094 6DD4 9E00             data  key_buf8,edkey.action.buffer8
     6DD6 7306 
0095 6DD8 9F00             data  key_buf9,edkey.action.buffer9
     6DDA 730C 
0096 6DDC FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 6DDE C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6DE0 833C 
0104 6DE2 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6DE4 FF00 
0105               
0106 6DE6 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6DE8 6D68 
0107 6DEA 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 6DEC 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 6DEE 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 6DF0 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 6DF2 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 6DF4 05C6  14         inct  tmp2                  ; No, skip action
0118 6DF6 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 6DF8 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 6DFA 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 6DFC 0460  28         b    @edkey.action.char     ; Add character to buffer
     6DFE 724A 
**** **** ****     > tivi.asm.16324
0343                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6E00 C120  34         mov   @fb.column,tmp0
     6E02 220C 
0010 6E04 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6E06 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6E08 220C 
0015 6E0A 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6E0C 832A 
0016 6E0E 0620  34         dec   @fb.current
     6E10 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6E12 0460  28 !       b     @ed_wait              ; Back to editor main
     6E14 6D5C 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6E16 8820  54         c     @fb.column,@fb.row.length
     6E18 220C 
     6E1A 2208 
0028 6E1C 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6E1E 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6E20 220C 
0033 6E22 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6E24 832A 
0034 6E26 05A0  34         inc   @fb.current
     6E28 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6E2A 0460  28 !       b     @ed_wait              ; Back to editor main
     6E2C 6D5C 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6E2E 8820  54         c     @fb.row.dirty,@w$ffff
     6E30 220A 
     6E32 6048 
0049 6E34 1604  14         jne   edkey.action.up.cursor
0050 6E36 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6E38 765A 
0051 6E3A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6E3C 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6E3E C120  34         mov   @fb.row,tmp0
     6E40 2206 
0057 6E42 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6E44 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6E46 2204 
0060 6E48 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6E4A 0604  14         dec   tmp0                  ; fb.topline--
0066 6E4C C804  38         mov   tmp0,@parm1
     6E4E 8350 
0067 6E50 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6E52 7502 
0068 6E54 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6E56 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6E58 2206 
0074 6E5A 06A0  32         bl    @up                   ; Row-- VDP cursor
     6E5C 6430 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6E5E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6E60 779A 
0080 6E62 8820  54         c     @fb.column,@fb.row.length
     6E64 220C 
     6E66 2208 
0081 6E68 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6E6A C820  54         mov   @fb.row.length,@fb.column
     6E6C 2208 
     6E6E 220C 
0086 6E70 C120  34         mov   @fb.column,tmp0
     6E72 220C 
0087 6E74 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6E76 643A 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6E78 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6E7A 74E6 
0093 6E7C 0460  28         b     @ed_wait              ; Back to editor main
     6E7E 6D5C 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6E80 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6E82 2206 
     6E84 2304 
0102 6E86 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6E88 8820  54         c     @fb.row.dirty,@w$ffff
     6E8A 220A 
     6E8C 6048 
0107 6E8E 1604  14         jne   edkey.action.down.move
0108 6E90 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6E92 765A 
0109 6E94 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6E96 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6E98 C120  34         mov   @fb.topline,tmp0
     6E9A 2204 
0118 6E9C A120  34         a     @fb.row,tmp0
     6E9E 2206 
0119 6EA0 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6EA2 2304 
0120 6EA4 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6EA6 C120  34         mov   @fb.screenrows,tmp0
     6EA8 2218 
0126 6EAA 0604  14         dec   tmp0
0127 6EAC 8120  34         c     @fb.row,tmp0
     6EAE 2206 
0128 6EB0 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6EB2 C820  54         mov   @fb.topline,@parm1
     6EB4 2204 
     6EB6 8350 
0133 6EB8 05A0  34         inc   @parm1
     6EBA 8350 
0134 6EBC 06A0  32         bl    @fb.refresh
     6EBE 7502 
0135 6EC0 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6EC2 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6EC4 2206 
0141 6EC6 06A0  32         bl    @down                 ; Row++ VDP cursor
     6EC8 6428 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6ECA 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6ECC 779A 
0147 6ECE 8820  54         c     @fb.column,@fb.row.length
     6ED0 220C 
     6ED2 2208 
0148 6ED4 1207  14         jle   edkey.action.down.exit  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 6ED6 C820  54         mov   @fb.row.length,@fb.column
     6ED8 2208 
     6EDA 220C 
0153 6EDC C120  34         mov   @fb.column,tmp0
     6EDE 220C 
0154 6EE0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6EE2 643A 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.exit:
0159 6EE4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6EE6 74E6 
0160 6EE8 0460  28 !       b     @ed_wait              ; Back to editor main
     6EEA 6D5C 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 6EEC C120  34         mov   @wyx,tmp0
     6EEE 832A 
0169 6EF0 0244  22         andi  tmp0,>ff00
     6EF2 FF00 
0170 6EF4 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6EF6 832A 
0171 6EF8 04E0  34         clr   @fb.column
     6EFA 220C 
0172 6EFC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6EFE 74E6 
0173 6F00 0460  28         b     @ed_wait              ; Back to editor main
     6F02 6D5C 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 6F04 C120  34         mov   @fb.row.length,tmp0
     6F06 2208 
0180 6F08 C804  38         mov   tmp0,@fb.column
     6F0A 220C 
0181 6F0C 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6F0E 643A 
0182 6F10 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F12 74E6 
0183 6F14 0460  28         b     @ed_wait              ; Back to editor main
     6F16 6D5C 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 6F18 C120  34         mov   @fb.column,tmp0
     6F1A 220C 
0192 6F1C 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 6F1E C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6F20 2202 
0197 6F22 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 6F24 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 6F26 0605  14         dec   tmp1
0204 6F28 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 6F2A 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 6F2C D195  26         movb  *tmp1,tmp2            ; Get character
0212 6F2E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 6F30 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 6F32 0986  56         srl   tmp2,8                ; Right justify
0215 6F34 0286  22         ci    tmp2,32               ; Space character found?
     6F36 0020 
0216 6F38 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 6F3A 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6F3C 2020 
0222 6F3E 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 6F40 0287  22         ci    tmp3,>20ff            ; First character is space
     6F42 20FF 
0225 6F44 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 6F46 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6F48 220C 
0230 6F4A 61C4  18         s     tmp0,tmp3
0231 6F4C 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6F4E 0002 
0232 6F50 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 6F52 0585  14         inc   tmp1
0238 6F54 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 6F56 C805  38         mov   tmp1,@fb.current
     6F58 2202 
0244 6F5A C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6F5C 220C 
0245 6F5E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F60 643A 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.exit:
0250 6F62 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F64 74E6 
0251 6F66 0460  28 !       b     @ed_wait              ; Back to editor main
     6F68 6D5C 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 6F6A 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 6F6C C120  34         mov   @fb.column,tmp0
     6F6E 220C 
0261 6F70 8804  38         c     tmp0,@fb.row.length
     6F72 2208 
0262 6F74 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 6F76 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6F78 2202 
0267 6F7A 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 6F7C 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 6F7E 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 6F80 0585  14         inc   tmp1
0279 6F82 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 6F84 8804  38         c     tmp0,@fb.row.length
     6F86 2208 
0281 6F88 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 6F8A D195  26         movb  *tmp1,tmp2            ; Get character
0288 6F8C 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 6F8E D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 6F90 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 6F92 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6F94 FFFF 
0293 6F96 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 6F98 0286  22         ci    tmp2,32
     6F9A 0020 
0299 6F9C 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 6F9E 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 6FA0 0286  22         ci    tmp2,32               ; Space character found?
     6FA2 0020 
0307 6FA4 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 6FA6 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6FA8 2020 
0313 6FAA 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 6FAC 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6FAE 20FF 
0316 6FB0 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 6FB2 0585  14         inc   tmp1
0321 6FB4 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 6FB6 C805  38         mov   tmp1,@fb.current
     6FB8 2202 
0327 6FBA C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6FBC 220C 
0328 6FBE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FC0 643A 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.exit:
0333 6FC2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FC4 74E6 
0334 6FC6 0460  28 !       b     @ed_wait              ; Back to editor main
     6FC8 6D5C 
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
0346 6FCA C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6FCC 2204 
0347 6FCE 1316  14         jeq   edkey.action.ppage.exit
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 6FD0 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     6FD2 2218 
0352 6FD4 1503  14         jgt   edkey.action.ppage.topline
0353 6FD6 04E0  34         clr   @fb.topline           ; topline = 0
     6FD8 2204 
0354 6FDA 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 6FDC 6820  54         s     @fb.screenrows,@fb.topline
     6FDE 2218 
     6FE0 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 6FE2 8820  54         c     @fb.row.dirty,@w$ffff
     6FE4 220A 
     6FE6 6048 
0365 6FE8 1604  14         jne   edkey.action.ppage.refresh
0366 6FEA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6FEC 765A 
0367 6FEE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6FF0 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 6FF2 C820  54         mov   @fb.topline,@parm1
     6FF4 2204 
     6FF6 8350 
0373 6FF8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6FFA 7502 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.exit:
0378 6FFC 04E0  34         clr   @fb.row
     6FFE 2206 
0379 7000 05A0  34         inc   @fb.row               ; Set fb.row=1
     7002 2206 
0380 7004 04E0  34         clr   @fb.column
     7006 220C 
0381 7008 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     700A 0100 
0382 700C C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     700E 832A 
0383 7010 0460  28         b     @edkey.action.up      ; Do rest of logic
     7012 6E2E 
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
0394 7014 C120  34         mov   @fb.topline,tmp0
     7016 2204 
0395 7018 A120  34         a     @fb.screenrows,tmp0
     701A 2218 
0396 701C 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     701E 2304 
0397 7020 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 7022 A820  54         a     @fb.screenrows,@fb.topline
     7024 2218 
     7026 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 7028 8820  54         c     @fb.row.dirty,@w$ffff
     702A 220A 
     702C 6048 
0408 702E 1604  14         jne   edkey.action.npage.refresh
0409 7030 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7032 765A 
0410 7034 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7036 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 7038 0460  28         b     @edkey.action.ppage.refresh
     703A 6FF2 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 703C 0460  28         b     @ed_wait              ; Back to editor main
     703E 6D5C 
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
0433 7040 8820  54         c     @fb.row.dirty,@w$ffff
     7042 220A 
     7044 6048 
0434 7046 1604  14         jne   edkey.action.top.refresh
0435 7048 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     704A 765A 
0436 704C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     704E 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 7050 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     7052 2204 
0442 7054 04E0  34         clr   @parm1
     7056 8350 
0443 7058 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     705A 7502 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 705C 04E0  34         clr   @fb.row               ; Editor line 0
     705E 2206 
0449 7060 04E0  34         clr   @fb.column            ; Editor column 0
     7062 220C 
0450 7064 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 7066 C804  38         mov   tmp0,@wyx             ;
     7068 832A 
0452 706A 0460  28         b     @ed_wait              ; Back to editor main
     706C 6D5C 
**** **** ****     > tivi.asm.16324
0344                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 706E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7070 2306 
0010 7072 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7074 74E6 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 7076 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7078 2202 
0015 707A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     707C 2208 
0016 707E 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7080 8820  54         c     @fb.column,@fb.row.length
     7082 220C 
     7084 2208 
0022 7086 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 7088 C120  34         mov   @fb.current,tmp0      ; Get pointer
     708A 2202 
0028 708C C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 708E 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7090 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7092 0606  14         dec   tmp2
0036 7094 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 7096 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7098 220A 
0041 709A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     709C 2216 
0042 709E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     70A0 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 70A2 0460  28         b     @ed_wait              ; Back to editor main
     70A4 6D5C 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 70A6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70A8 2306 
0055 70AA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70AC 74E6 
0056 70AE C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     70B0 2208 
0057 70B2 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 70B4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     70B6 2202 
0063 70B8 C1A0  34         mov   @fb.colsline,tmp2
     70BA 220E 
0064 70BC 61A0  34         s     @fb.column,tmp2
     70BE 220C 
0065 70C0 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 70C2 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 70C4 0606  14         dec   tmp2
0072 70C6 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 70C8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     70CA 220A 
0077 70CC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     70CE 2216 
0078               
0079 70D0 C820  54         mov   @fb.column,@fb.row.length
     70D2 220C 
     70D4 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 70D6 0460  28         b     @ed_wait              ; Back to editor main
     70D8 6D5C 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 70DA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     70DC 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 70DE C120  34         mov   @edb.lines,tmp0
     70E0 2304 
0097 70E2 1604  14         jne   !
0098 70E4 04E0  34         clr   @fb.column            ; Column 0
     70E6 220C 
0099 70E8 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     70EA 70A6 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 70EC 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70EE 74E6 
0104 70F0 04E0  34         clr   @fb.row.dirty         ; Discard current line
     70F2 220A 
0105 70F4 C820  54         mov   @fb.topline,@parm1
     70F6 2204 
     70F8 8350 
0106 70FA A820  54         a     @fb.row,@parm1        ; Line number to remove
     70FC 2206 
     70FE 8350 
0107 7100 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7102 2304 
     7104 8352 
0108 7106 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7108 75AE 
0109 710A 0620  34         dec   @edb.lines            ; One line less in editor buffer
     710C 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 710E C820  54         mov   @fb.topline,@parm1
     7110 2204 
     7112 8350 
0114 7114 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7116 7502 
0115 7118 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     711A 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 711C C120  34         mov   @fb.topline,tmp0
     711E 2204 
0120 7120 A120  34         a     @fb.row,tmp0
     7122 2206 
0121 7124 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7126 2304 
0122 7128 1202  14         jle   edkey.action.del_line.exit
0123 712A 0460  28         b     @edkey.action.up      ; One line up
     712C 6E2E 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 712E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7130 6EEC 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 7132 0204  20         li    tmp0,>2000            ; White space
     7134 2000 
0139 7136 C804  38         mov   tmp0,@parm1
     7138 8350 
0140               edkey.action.ins_char:
0141 713A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     713C 2306 
0142 713E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7140 74E6 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 7142 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7144 2202 
0147 7146 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7148 2208 
0148 714A 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 714C 8820  54         c     @fb.column,@fb.row.length
     714E 220C 
     7150 2208 
0154 7152 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 7154 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 7156 61E0  34         s     @fb.column,tmp3
     7158 220C 
0162 715A A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 715C C144  18         mov   tmp0,tmp1
0164 715E 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7160 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7162 220C 
0166 7164 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 7166 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 7168 0604  14         dec   tmp0
0173 716A 0605  14         dec   tmp1
0174 716C 0606  14         dec   tmp2
0175 716E 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 7170 D560  46         movb  @parm1,*tmp1
     7172 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 7174 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7176 220A 
0184 7178 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     717A 2216 
0185 717C 05A0  34         inc   @fb.row.length        ; @fb.row.length
     717E 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7180 0460  28         b     @edkey.action.char.overwrite
     7182 725C 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 7184 0460  28         b     @ed_wait              ; Back to editor main
     7186 6D5C 
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
0206 7188 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     718A 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 718C 8820  54         c     @fb.row.dirty,@w$ffff
     718E 220A 
     7190 6048 
0211 7192 1604  14         jne   edkey.action.ins_line.insert
0212 7194 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7196 765A 
0213 7198 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     719A 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 719C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     719E 74E6 
0219 71A0 C820  54         mov   @fb.topline,@parm1
     71A2 2204 
     71A4 8350 
0220 71A6 A820  54         a     @fb.row,@parm1        ; Line number to insert
     71A8 2206 
     71AA 8350 
0221               
0222 71AC C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71AE 2304 
     71B0 8352 
0223 71B2 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     71B4 75D8 
0224 71B6 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     71B8 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 71BA C820  54         mov   @fb.topline,@parm1
     71BC 2204 
     71BE 8350 
0229 71C0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71C2 7502 
0230 71C4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71C6 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 71C8 0460  28         b     @ed_wait              ; Back to editor main
     71CA 6D5C 
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
0249 71CC 8820  54         c     @fb.row.dirty,@w$ffff
     71CE 220A 
     71D0 6048 
0250 71D2 1606  14         jne   edkey.action.enter.upd_counter
0251 71D4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71D6 2306 
0252 71D8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     71DA 765A 
0253 71DC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     71DE 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 71E0 C120  34         mov   @fb.topline,tmp0
     71E2 2204 
0259 71E4 A120  34         a     @fb.row,tmp0
     71E6 2206 
0260 71E8 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     71EA 2304 
0261 71EC 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 71EE 05A0  34         inc   @edb.lines            ; Total lines++
     71F0 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 71F2 C120  34         mov   @fb.screenrows,tmp0
     71F4 2218 
0271 71F6 0604  14         dec   tmp0
0272 71F8 8120  34         c     @fb.row,tmp0
     71FA 2206 
0273 71FC 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 71FE C120  34         mov   @fb.screenrows,tmp0
     7200 2218 
0278 7202 C820  54         mov   @fb.topline,@parm1
     7204 2204 
     7206 8350 
0279 7208 05A0  34         inc   @parm1
     720A 8350 
0280 720C 06A0  32         bl    @fb.refresh
     720E 7502 
0281 7210 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 7212 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7214 2206 
0287 7216 06A0  32         bl    @down                 ; Row++ VDP cursor
     7218 6428 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 721A 06A0  32         bl    @fb.get.firstnonblank
     721C 752C 
0293 721E C120  34         mov   @outparm1,tmp0
     7220 8360 
0294 7222 C804  38         mov   tmp0,@fb.column
     7224 220C 
0295 7226 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     7228 643A 
0296 722A 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     722C 779A 
0297 722E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7230 74E6 
0298 7232 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7234 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 7236 0460  28         b     @ed_wait              ; Back to editor main
     7238 6D5C 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 723A 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     723C 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 723E 0204  20         li    tmp0,2000
     7240 07D0 
0317               edkey.action.ins_onoff.loop:
0318 7242 0604  14         dec   tmp0
0319 7244 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 7246 0460  28         b     @task2.cur_visible    ; Update cursor shape
     7248 73B0 
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
0335 724A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     724C 2306 
0336 724E D805  38         movb  tmp1,@parm1           ; Store character for insert
     7250 8350 
0337 7252 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7254 230C 
0338 7256 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 7258 0460  28         b     @edkey.action.ins_char
     725A 713A 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 725C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     725E 74E6 
0349 7260 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7262 2202 
0350               
0351 7264 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7266 8350 
0352 7268 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     726A 220A 
0353 726C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     726E 2216 
0354               
0355 7270 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7272 220C 
0356 7274 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7276 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 7278 8820  54         c     @fb.column,@fb.row.length
     727A 220C 
     727C 2208 
0361 727E 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7280 C820  54         mov   @fb.column,@fb.row.length
     7282 220C 
     7284 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 7286 0460  28         b     @ed_wait              ; Back to editor main
     7288 6D5C 
**** **** ****     > tivi.asm.16324
0345                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 728A 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     728C 64EA 
0010 728E 0420  54         blwp  @0                    ; Exit
     7290 0000 
0011               
**** **** ****     > tivi.asm.16324
0346                       copy  "editorkeys_file.asm" ; Actions for file related keys
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
0016 7292 C820  54         mov   @parm1,@parm2         ; RLE compression on/off
     7294 8350 
     7296 8352 
0017 7298 C804  38         mov   tmp0,@parm1           ; Setup file to load
     729A 8350 
0018               
0019 729C 06A0  32         bl    @edb.init             ; Initialize editor buffer
     729E 763A 
0020 72A0 06A0  32         bl    @idx.init             ; Initialize index
     72A2 7574 
0021 72A4 06A0  32         bl    @fb.init              ; Initialize framebuffer
     72A6 7498 
0022 72A8 C820  54         mov   @parm2,@edb.rle       ; Save RLE compression
     72AA 8352 
     72AC 230E 
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 72AE 06A0  32         bl    @filv
     72B0 618E 
0027 72B2 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     72B4 0000 
     72B6 0004 
0028               
0029 72B8 C160  34         mov   @fb.screenrows,tmp1
     72BA 2218 
0030 72BC 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     72BE 220E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033 72C0 04C4  14         clr   tmp0                  ; VDP target address
0034 72C2 0205  20         li    tmp1,32               ; Character to fill
     72C4 0020 
0035               
0036 72C6 06A0  32         bl    @xfilv                ; Fill VDP memory
     72C8 6194 
0037                                                   ; \ .  tmp0 = VDP target address
0038                                                   ; | .  tmp1 = Byte to fill
0039                                                   ; / .  tmp2 = Bytes to copy
0040                       ;-------------------------------------------------------
0041                       ; Read DV80 file and display
0042                       ;-------------------------------------------------------
0043 72CA 06A0  32         bl    @tfh.file.read        ; Read specified file
     72CC 77B8 
0044                                                   ; \ .  parm1 = Pointer to length prefixed file descriptor
0045                                                   ; / .  parm2 = RLE compression on (>FFFF) or off (>0000)
0046               
0047 72CE 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     72D0 2306 
0048 72D2 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     72D4 7040 
0049               
0050               
0051               
0052               edkey.action.buffer0:
0053 72D6 0204  20         li   tmp0,fdname0
     72D8 7A16 
0054 72DA 10DB  14         jmp  edkey.action.loadfile
0055                                                   ; Load DIS/VAR 80 file into editor buffer
0056               edkey.action.buffer1:
0057 72DC 0204  20         li   tmp0,fdname1
     72DE 7A24 
0058 72E0 10D8  14         jmp  edkey.action.loadfile
0059                                                   ; Load DIS/VAR 80 file into editor buffer
0060               
0061               edkey.action.buffer2:
0062 72E2 0204  20         li   tmp0,fdname2
     72E4 7A34 
0063 72E6 10D5  14         jmp  edkey.action.loadfile
0064                                                   ; Load DIS/VAR 80 file into editor buffer
0065               
0066               edkey.action.buffer3:
0067 72E8 0204  20         li   tmp0,fdname3
     72EA 7A42 
0068 72EC 10D2  14         jmp  edkey.action.loadfile
0069                                                   ; Load DIS/VAR 80 file into editor buffer
0070               
0071               edkey.action.buffer4:
0072 72EE 0204  20         li   tmp0,fdname4
     72F0 7A50 
0073 72F2 10CF  14         jmp  edkey.action.loadfile
0074                                                   ; Load DIS/VAR 80 file into editor buffer
0075               
0076               edkey.action.buffer5:
0077 72F4 0204  20         li   tmp0,fdname5
     72F6 7A5E 
0078 72F8 10CC  14         jmp  edkey.action.loadfile
0079                                                   ; Load DIS/VAR 80 file into editor buffer
0080               
0081               edkey.action.buffer6:
0082 72FA 0204  20         li   tmp0,fdname6
     72FC 7A6C 
0083 72FE 10C9  14         jmp  edkey.action.loadfile
0084                                                   ; Load DIS/VAR 80 file into editor buffer
0085               
0086               edkey.action.buffer7:
0087 7300 0204  20         li   tmp0,fdname7
     7302 7A7A 
0088 7304 10C6  14         jmp  edkey.action.loadfile
0089                                                   ; Load DIS/VAR 80 file into editor buffer
0090               
0091               edkey.action.buffer8:
0092 7306 0204  20         li   tmp0,fdname8
     7308 7A88 
0093 730A 10C3  14         jmp  edkey.action.loadfile
0094                                                   ; Load DIS/VAR 80 file into editor buffer
0095               
0096               edkey.action.buffer9:
0097 730C 0204  20         li   tmp0,fdname9
     730E 7A96 
0098 7310 10C0  14         jmp  edkey.action.loadfile
0099                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.16324
0347               
0348               
0349               
0350               ***************************************************************
0351               * Task 0 - Copy frame buffer to VDP
0352               ***************************************************************
0353 7312 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7314 2216 
0354 7316 133D  14         jeq   task0.$$              ; No, skip update
0355                       ;------------------------------------------------------
0356                       ; Determine how many rows to copy
0357                       ;------------------------------------------------------
0358 7318 8820  54         c     @edb.lines,@fb.screenrows
     731A 2304 
     731C 2218 
0359 731E 1103  14         jlt   task0.setrows.small
0360 7320 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7322 2218 
0361 7324 1003  14         jmp   task0.copy.framebuffer
0362                       ;------------------------------------------------------
0363                       ; Less lines in editor buffer as rows in frame buffer
0364                       ;------------------------------------------------------
0365               task0.setrows.small:
0366 7326 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7328 2304 
0367 732A 0585  14         inc   tmp1
0368                       ;------------------------------------------------------
0369                       ; Determine area to copy
0370                       ;------------------------------------------------------
0371               task0.copy.framebuffer:
0372 732C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     732E 220E 
0373                                                   ; 16 bit part is in tmp2!
0374 7330 04C4  14         clr   tmp0                  ; VDP target address
0375 7332 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7334 2200 
0376                       ;------------------------------------------------------
0377                       ; Copy memory block
0378                       ;------------------------------------------------------
0379 7336 06A0  32         bl    @xpym2v               ; Copy to VDP
     7338 633E 
0380                                                   ; tmp0 = VDP target address
0381                                                   ; tmp1 = RAM source address
0382                                                   ; tmp2 = Bytes to copy
0383 733A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     733C 2216 
0384                       ;-------------------------------------------------------
0385                       ; Draw EOF marker at end-of-file
0386                       ;-------------------------------------------------------
0387 733E C120  34         mov   @edb.lines,tmp0
     7340 2304 
0388 7342 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7344 2204 
0389 7346 0584  14         inc   tmp0                  ; Y++
0390 7348 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     734A 2218 
0391 734C 1222  14         jle   task0.$$
0392                       ;-------------------------------------------------------
0393                       ; Draw EOF marker
0394                       ;-------------------------------------------------------
0395               task0.draw_marker:
0396 734E C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7350 832A 
     7352 2214 
0397 7354 0A84  56         sla   tmp0,8                ; X=0
0398 7356 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7358 832A 
0399 735A 06A0  32         bl    @putstr
     735C 631E 
0400 735E 79E4                   data txt_marker       ; Display *EOF*
0401                       ;-------------------------------------------------------
0402                       ; Draw empty line after (and below) EOF marker
0403                       ;-------------------------------------------------------
0404 7360 06A0  32         bl    @setx
     7362 6438 
0405 7364 0005                   data  5               ; Cursor after *EOF* string
0406               
0407 7366 C120  34         mov   @wyx,tmp0
     7368 832A 
0408 736A 0984  56         srl   tmp0,8                ; Right justify
0409 736C 0584  14         inc   tmp0                  ; One time adjust
0410 736E 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7370 2218 
0411 7372 1303  14         jeq   !
0412 7374 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7376 009B 
0413 7378 1002  14         jmp   task0.draw_marker.line
0414 737A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     737C 004B 
0415                       ;-------------------------------------------------------
0416                       ; Draw empty line
0417                       ;-------------------------------------------------------
0418               task0.draw_marker.line:
0419 737E 0604  14         dec   tmp0                  ; One time adjust
0420 7380 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7382 62FA 
0421 7384 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7386 0020 
0422 7388 06A0  32         bl    @xfilv                ; Write characters
     738A 6194 
0423 738C C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     738E 2214 
     7390 832A 
0424               *--------------------------------------------------------------
0425               * Task 0 - Exit
0426               *--------------------------------------------------------------
0427               task0.$$:
0428 7392 0460  28         b     @slotok
     7394 6B7C 
0429               
0430               
0431               
0432               ***************************************************************
0433               * Task 1 - Copy SAT to VDP
0434               ***************************************************************
0435 7396 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     7398 6046 
0436 739A 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     739C 6444 
0437 739E C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     73A0 8380 
0438 73A2 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0439               
0440               
0441               ***************************************************************
0442               * Task 2 - Update cursor shape (blink)
0443               ***************************************************************
0444 73A4 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     73A6 2212 
0445 73A8 1303  14         jeq   task2.cur_visible
0446 73AA 04E0  34         clr   @ramsat+2              ; Hide cursor
     73AC 8382 
0447 73AE 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0448               
0449               task2.cur_visible:
0450 73B0 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     73B2 230C 
0451 73B4 1303  14         jeq   task2.cur_visible.overwrite_mode
0452                       ;------------------------------------------------------
0453                       ; Cursor in insert mode
0454                       ;------------------------------------------------------
0455               task2.cur_visible.insert_mode:
0456 73B6 0204  20         li    tmp0,>000f
     73B8 000F 
0457 73BA 1002  14         jmp   task2.cur_visible.cursorshape
0458                       ;------------------------------------------------------
0459                       ; Cursor in overwrite mode
0460                       ;------------------------------------------------------
0461               task2.cur_visible.overwrite_mode:
0462 73BC 0204  20         li    tmp0,>020f
     73BE 020F 
0463                       ;------------------------------------------------------
0464                       ; Set cursor shape
0465                       ;------------------------------------------------------
0466               task2.cur_visible.cursorshape:
0467 73C0 C804  38         mov   tmp0,@fb.curshape
     73C2 2210 
0468 73C4 C804  38         mov   tmp0,@ramsat+2
     73C6 8382 
0469               
0470               
0471               
0472               
0473               
0474               
0475               
0476               *--------------------------------------------------------------
0477               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0478               *--------------------------------------------------------------
0479               task.sub_copy_ramsat
0480 73C8 06A0  32         bl    @cpym2v
     73CA 6338 
0481 73CC 2000                   data sprsat,ramsat,4   ; Update sprite
     73CE 8380 
     73D0 0004 
0482               
0483 73D2 C820  54         mov   @wyx,@fb.yxsave
     73D4 832A 
     73D6 2214 
0484                       ;------------------------------------------------------
0485                       ; Show text editing mode
0486                       ;------------------------------------------------------
0487               task.botline.show_mode
0488 73D8 C120  34         mov   @edb.insmode,tmp0
     73DA 230C 
0489 73DC 1605  14         jne   task.botline.show_mode.insert
0490                       ;------------------------------------------------------
0491                       ; Overwrite mode
0492                       ;------------------------------------------------------
0493               task.botline.show_mode.overwrite:
0494 73DE 06A0  32         bl    @putat
     73E0 6330 
0495 73E2 1D32                   byte  29,50
0496 73E4 79F0                   data  txt_ovrwrite
0497 73E6 1004  14         jmp   task.botline.show_changed
0498                       ;------------------------------------------------------
0499                       ; Insert  mode
0500                       ;------------------------------------------------------
0501               task.botline.show_mode.insert:
0502 73E8 06A0  32         bl    @putat
     73EA 6330 
0503 73EC 1D32                   byte  29,50
0504 73EE 79F4                   data  txt_insert
0505                       ;------------------------------------------------------
0506                       ; Show if text was changed in editor buffer
0507                       ;------------------------------------------------------
0508               task.botline.show_changed:
0509 73F0 C120  34         mov   @edb.dirty,tmp0
     73F2 2306 
0510 73F4 1305  14         jeq   task.botline.show_changed.clear
0511                       ;------------------------------------------------------
0512                       ; Show "*"
0513                       ;------------------------------------------------------
0514 73F6 06A0  32         bl    @putat
     73F8 6330 
0515 73FA 1D36                   byte 29,54
0516 73FC 79F8                   data txt_star
0517 73FE 1001  14         jmp   task.botline.show_linecol
0518                       ;------------------------------------------------------
0519                       ; Show "line,column"
0520                       ;------------------------------------------------------
0521               task.botline.show_changed.clear:
0522 7400 1000  14         nop
0523               task.botline.show_linecol:
0524 7402 C820  54         mov   @fb.row,@parm1
     7404 2206 
     7406 8350 
0525 7408 06A0  32         bl    @fb.row2line
     740A 74D2 
0526 740C 05A0  34         inc   @outparm1
     740E 8360 
0527                       ;------------------------------------------------------
0528                       ; Show line
0529                       ;------------------------------------------------------
0530 7410 06A0  32         bl    @putnum
     7412 67A2 
0531 7414 1D40                   byte  29,64            ; YX
0532 7416 8360                   data  outparm1,rambuf
     7418 8390 
0533 741A 3020                   byte  48               ; ASCII offset
0534                             byte  32               ; Padding character
0535                       ;------------------------------------------------------
0536                       ; Show comma
0537                       ;------------------------------------------------------
0538 741C 06A0  32         bl    @putat
     741E 6330 
0539 7420 1D45                   byte  29,69
0540 7422 79E2                   data  txt_delim
0541                       ;------------------------------------------------------
0542                       ; Show column
0543                       ;------------------------------------------------------
0544 7424 06A0  32         bl    @film
     7426 6136 
0545 7428 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     742A 0020 
     742C 000C 
0546               
0547 742E C820  54         mov   @fb.column,@waux1
     7430 220C 
     7432 833C 
0548 7434 05A0  34         inc   @waux1                 ; Offset 1
     7436 833C 
0549               
0550 7438 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     743A 6724 
0551 743C 833C                   data  waux1,rambuf
     743E 8390 
0552 7440 3020                   byte  48               ; ASCII offset
0553                             byte  32               ; Fill character
0554               
0555 7442 06A0  32         bl    @trimnum               ; Trim number to the left
     7444 677C 
0556 7446 8390                   data  rambuf,rambuf+6,32
     7448 8396 
     744A 0020 
0557               
0558 744C 0204  20         li    tmp0,>0200
     744E 0200 
0559 7450 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7452 8396 
0560               
0561 7454 06A0  32         bl    @putat
     7456 6330 
0562 7458 1D46                   byte 29,70
0563 745A 8396                   data rambuf+6          ; Show column
0564                       ;------------------------------------------------------
0565                       ; Show lines in buffer unless on last line in file
0566                       ;------------------------------------------------------
0567 745C C820  54         mov   @fb.row,@parm1
     745E 2206 
     7460 8350 
0568 7462 06A0  32         bl    @fb.row2line
     7464 74D2 
0569 7466 8820  54         c     @edb.lines,@outparm1
     7468 2304 
     746A 8360 
0570 746C 1605  14         jne   task.botline.show_lines_in_buffer
0571               
0572 746E 06A0  32         bl    @putat
     7470 6330 
0573 7472 1D49                   byte 29,73
0574 7474 79EA                   data txt_bottom
0575               
0576 7476 100B  14         jmp   task.botline.$$
0577                       ;------------------------------------------------------
0578                       ; Show lines in buffer
0579                       ;------------------------------------------------------
0580               task.botline.show_lines_in_buffer:
0581 7478 C820  54         mov   @edb.lines,@waux1
     747A 2304 
     747C 833C 
0582 747E 05A0  34         inc   @waux1                 ; Offset 1
     7480 833C 
0583 7482 06A0  32         bl    @putnum
     7484 67A2 
0584 7486 1D49                   byte 29,73             ; YX
0585 7488 833C                   data waux1,rambuf
     748A 8390 
0586 748C 3020                   byte 48
0587                             byte 32
0588                       ;------------------------------------------------------
0589                       ; Exit
0590                       ;------------------------------------------------------
0591               task.botline.$$
0592 748E C820  54         mov   @fb.yxsave,@wyx
     7490 2214 
     7492 832A 
0593 7494 0460  28         b     @slotok                ; Exit running task
     7496 6B7C 
0594               
0595               
0596               
0597               ***************************************************************
0598               *                  fb - Framebuffer module
0599               ***************************************************************
0600                       copy  "framebuffer.asm"
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
0024 7498 0649  14         dect  stack
0025 749A C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 749C 0204  20         li    tmp0,fb.top
     749E 2650 
0030 74A0 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     74A2 2200 
0031 74A4 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     74A6 2204 
0032 74A8 04E0  34         clr   @fb.row               ; Current row=0
     74AA 2206 
0033 74AC 04E0  34         clr   @fb.column            ; Current column=0
     74AE 220C 
0034 74B0 0204  20         li    tmp0,80
     74B2 0050 
0035 74B4 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     74B6 220E 
0036 74B8 0204  20         li    tmp0,29
     74BA 001D 
0037 74BC C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     74BE 2218 
0038 74C0 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     74C2 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 74C4 06A0  32         bl    @film
     74C6 6136 
0043 74C8 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     74CA 0000 
     74CC 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 74CE 0460  28         b     @poprt                ; Return to caller
     74D0 6132 
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
0073 74D2 0649  14         dect  stack
0074 74D4 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 74D6 C120  34         mov   @parm1,tmp0
     74D8 8350 
0079 74DA A120  34         a     @fb.topline,tmp0
     74DC 2204 
0080 74DE C804  38         mov   tmp0,@outparm1
     74E0 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 74E2 0460  28         b    @poprt                 ; Return to caller
     74E4 6132 
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
0113 74E6 0649  14         dect  stack
0114 74E8 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 74EA C1A0  34         mov   @fb.row,tmp2
     74EC 2206 
0119 74EE 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     74F0 220E 
0120 74F2 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     74F4 220C 
0121 74F6 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     74F8 2200 
0122 74FA C807  38         mov   tmp3,@fb.current
     74FC 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 74FE 0460  28         b    @poprt                 ; Return to caller
     7500 6132 
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
0145 7502 0649  14         dect  stack
0146 7504 C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7506 C820  54         mov   @parm1,@fb.topline
     7508 8350 
     750A 2204 
0151 750C 04E0  34         clr   @parm2                ; Target row in frame buffer
     750E 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 7510 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7512 76E2 
0157                                                   ; \ .  parm1 = Line to unpack
0158                                                   ; / .  parm2 = Target row in frame buffer
0159               
0160 7514 05A0  34         inc   @parm1                ; Next line in editor buffer
     7516 8350 
0161 7518 05A0  34         inc   @parm2                ; Next row in frame buffer
     751A 8352 
0162 751C 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     751E 8352 
     7520 2218 
0163 7522 11F6  14         jlt   fb.refresh.unpack_line
0164 7524 0720  34         seto  @fb.dirty             ; Refresh screen
     7526 2216 
0165                       ;------------------------------------------------------
0166                       ; Exit
0167                       ;------------------------------------------------------
0168               fb.refresh.exit
0169 7528 0460  28         b    @poprt                 ; Return to caller
     752A 6132 
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
0185 752C 0649  14         dect  stack
0186 752E C64B  30         mov   r11,*stack            ; Save return address
0187                       ;------------------------------------------------------
0188                       ; Prepare for scanning
0189                       ;------------------------------------------------------
0190 7530 04E0  34         clr   @fb.column
     7532 220C 
0191 7534 06A0  32         bl    @fb.calc_pointer
     7536 74E6 
0192 7538 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     753A 779A 
0193 753C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     753E 2208 
0194 7540 1313  14         jeq   fb.get.firstnonblank.nomatch
0195                                                   ; Exit if empty line
0196 7542 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7544 2202 
0197 7546 04C5  14         clr   tmp1
0198                       ;------------------------------------------------------
0199                       ; Scan line for non-blank character
0200                       ;------------------------------------------------------
0201               fb.get.firstnonblank.loop:
0202 7548 D174  28         movb  *tmp0+,tmp1           ; Get character
0203 754A 130E  14         jeq   fb.get.firstnonblank.nomatch
0204                                                   ; Exit if empty line
0205 754C 0285  22         ci    tmp1,>2000            ; Whitespace?
     754E 2000 
0206 7550 1503  14         jgt   fb.get.firstnonblank.match
0207 7552 0606  14         dec   tmp2                  ; Counter--
0208 7554 16F9  14         jne   fb.get.firstnonblank.loop
0209 7556 1008  14         jmp   fb.get.firstnonblank.nomatch
0210                       ;------------------------------------------------------
0211                       ; Non-blank character found
0212                       ;------------------------------------------------------
0213               fb.get.firstnonblank.match
0214 7558 6120  34         s     @fb.current,tmp0      ; Calculate column
     755A 2202 
0215 755C 0604  14         dec   tmp0
0216 755E C804  38         mov   tmp0,@outparm1        ; Save column
     7560 8360 
0217 7562 D805  38         movb  tmp1,@outparm2        ; Save character
     7564 8362 
0218 7566 1004  14         jmp   fb.get.firstnonblank.$$
0219                       ;------------------------------------------------------
0220                       ; No non-blank character found
0221                       ;------------------------------------------------------
0222               fb.get.firstnonblank.nomatch
0223 7568 04E0  34         clr   @outparm1             ; X=0
     756A 8360 
0224 756C 04E0  34         clr   @outparm2             ; Null
     756E 8362 
0225                       ;------------------------------------------------------
0226                       ; Exit
0227                       ;------------------------------------------------------
0228               fb.get.firstnonblank.$$
0229 7570 0460  28         b    @poprt                 ; Return to caller
     7572 6132 
0230               
0231               
0232               
0233               
0234               
0235               
**** **** ****     > tivi.asm.16324
0601               
0602               
0603               ***************************************************************
0604               *              idx - Index management module
0605               ***************************************************************
0606                       copy  "index.asm"
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
0059 7574 0649  14         dect  stack
0060 7576 C64B  30         mov   r11,*stack            ; Save return address
0061                       ;------------------------------------------------------
0062                       ; Initialize
0063                       ;------------------------------------------------------
0064 7578 0204  20         li    tmp0,idx.top
     757A 3000 
0065 757C C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     757E 2302 
0066                       ;------------------------------------------------------
0067                       ; Create index slot 0
0068                       ;------------------------------------------------------
0069 7580 06A0  32         bl    @film
     7582 6136 
0070 7584 3000             data  idx.top,>00,idx.size  ; Clear index
     7586 0000 
     7588 1000 
0071                       ;------------------------------------------------------
0072                       ; Exit
0073                       ;------------------------------------------------------
0074               idx.init.exit:
0075 758A 0460  28         b     @poprt                ; Return to caller
     758C 6132 
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
0097 758E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7590 8350 
0098                       ;------------------------------------------------------
0099                       ; Calculate offset
0100                       ;------------------------------------------------------
0101 7592 C160  34         mov   @parm2,tmp1
     7594 8352 
0102 7596 1305  14         jeq   idx.entry.update.save ; Special handling for empty line
0103 7598 0225  22         ai    tmp1,-edb.top         ; Substract editor buffer base,
     759A 6000 
0104                                                   ; we only store the offset
0105               
0106                       ;------------------------------------------------------
0107                       ; Inject SAMS bank into high-nibble MSB of pointer
0108                       ;------------------------------------------------------
0109 759C C1A0  34         mov   @parm3,tmp2
     759E 8354 
0110 75A0 1300  14         jeq   idx.entry.update.save ; Skip for SAMS bank 0
0111               
0112                       ; <still to do>
0113               
0114                       ;------------------------------------------------------
0115                       ; Update index slot
0116                       ;------------------------------------------------------
0117               idx.entry.update.save:
0118 75A2 0A14  56         sla   tmp0,1                ; line number * 2
0119 75A4 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     75A6 3000 
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               idx.entry.update.exit:
0124 75A8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     75AA 8360 
0125 75AC 045B  20         b     *r11                  ; Return
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
0145 75AE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     75B0 8350 
0146                       ;------------------------------------------------------
0147                       ; Calculate address of index entry and save pointer
0148                       ;------------------------------------------------------
0149 75B2 0A14  56         sla   tmp0,1                ; line number * 2
0150 75B4 C824  54         mov   @idx.top(tmp0),@outparm1
     75B6 3000 
     75B8 8360 
0151                                                   ; Pointer to deleted line
0152                       ;------------------------------------------------------
0153                       ; Prepare for index reorg
0154                       ;------------------------------------------------------
0155 75BA C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75BC 8352 
0156 75BE 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75C0 8350 
0157 75C2 1603  14         jne   idx.entry.delete.reorg
0158                       ;------------------------------------------------------
0159                       ; Special treatment if last line
0160                       ;------------------------------------------------------
0161 75C4 04E4  34         clr   @idx.top(tmp0)
     75C6 3000 
0162 75C8 1006  14         jmp   idx.entry.delete.exit
0163                       ;------------------------------------------------------
0164                       ; Reorganize index entries
0165                       ;------------------------------------------------------
0166               idx.entry.delete.reorg:
0167 75CA C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     75CC 3002 
     75CE 3000 
0168 75D0 05C4  14         inct  tmp0                  ; Next index entry
0169 75D2 0606  14         dec   tmp2                  ; tmp2--
0170 75D4 16FA  14         jne   idx.entry.delete.reorg
0171                                                   ; Loop unless completed
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               idx.entry.delete.exit:
0176 75D6 045B  20         b     *r11                  ; Return
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
0196 75D8 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     75DA 8352 
0197                       ;------------------------------------------------------
0198                       ; Calculate address of index entry and save pointer
0199                       ;------------------------------------------------------
0200 75DC 0A14  56         sla   tmp0,1                ; line number * 2
0201                       ;------------------------------------------------------
0202                       ; Prepare for index reorg
0203                       ;------------------------------------------------------
0204 75DE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75E0 8352 
0205 75E2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75E4 8350 
0206 75E6 1606  14         jne   idx.entry.insert.reorg
0207                       ;------------------------------------------------------
0208                       ; Special treatment if last line
0209                       ;------------------------------------------------------
0210 75E8 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     75EA 3000 
     75EC 3002 
0211 75EE 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     75F0 3000 
0212 75F2 1009  14         jmp   idx.entry.insert.$$
0213                       ;------------------------------------------------------
0214                       ; Reorganize index entries
0215                       ;------------------------------------------------------
0216               idx.entry.insert.reorg:
0217 75F4 05C6  14         inct  tmp2                  ; Adjust one time
0218 75F6 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     75F8 3000 
     75FA 3002 
0219 75FC 0644  14         dect  tmp0                  ; Previous index entry
0220 75FE 0606  14         dec   tmp2                  ; tmp2--
0221 7600 16FA  14         jne   -!                    ; Loop unless completed
0222               
0223 7602 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     7604 3004 
0224                       ;------------------------------------------------------
0225                       ; Exit
0226                       ;------------------------------------------------------
0227               idx.entry.insert.$$:
0228 7606 045B  20         b     *r11                  ; Return
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
0249 7608 0649  14         dect  stack
0250 760A C64B  30         mov   r11,*stack            ; Save return address
0251                       ;------------------------------------------------------
0252                       ; Get pointer
0253                       ;------------------------------------------------------
0254 760C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     760E 8350 
0255                       ;------------------------------------------------------
0256                       ; Calculate index entry
0257                       ;------------------------------------------------------
0258 7610 0A14  56         sla   tmp0,1                ; line number * 2
0259 7612 C164  34         mov   @idx.top(tmp0),tmp1   ; Get offset
     7614 3000 
0260                       ;------------------------------------------------------
0261                       ; Get SAMS bank
0262                       ;------------------------------------------------------
0263 7616 C185  18         mov   tmp1,tmp2
0264 7618 09C6  56         srl   tmp2,12               ; Remove offset part
0265               
0266 761A 0286  22         ci    tmp2,5                ; SAMS bank 0
     761C 0005 
0267 761E 1205  14         jle   idx.pointer.get.samsbank0
0268               
0269 7620 0226  22         ai    tmp2,-5               ; Get SAMS bank
     7622 FFFB 
0270 7624 C806  38         mov   tmp2,@outparm2        ; Return SAMS bank
     7626 8362 
0271 7628 1002  14         jmp   idx.pointer.get.addbase
0272                       ;------------------------------------------------------
0273                       ; SAMS Bank 0 (or only 32K memory expansion)
0274                       ;------------------------------------------------------
0275               idx.pointer.get.samsbank0:
0276 762A 04E0  34         clr   @outparm2             ; SAMS bank 0
     762C 8362 
0277                       ;------------------------------------------------------
0278                       ; Add base
0279                       ;------------------------------------------------------
0280               idx.pointer.get.addbase:
0281 762E 0225  22         ai    tmp1,edb.top          ; Add base of editor buffer
     7630 A000 
0282 7632 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7634 8360 
0283                       ;------------------------------------------------------
0284                       ; Exit
0285                       ;------------------------------------------------------
0286               idx.pointer.get.exit:
0287 7636 0460  28         b     @poprt                ; Return to caller
     7638 6132 
**** **** ****     > tivi.asm.16324
0607               
0608               
0609               ***************************************************************
0610               *               edb - Editor Buffer module
0611               ***************************************************************
0612                       copy  "editorbuffer.asm"
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
0026 763A 0649  14         dect  stack
0027 763C C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 763E 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     7640 A002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 7642 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7644 2300 
0035 7646 C804  38         mov   tmp0,@edb.next_free.ptr
     7648 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037 764A 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     764C 230C 
0038 764E 04E0  34         clr   @edb.lines            ; Lines=0
     7650 2304 
0039 7652 04E0  34         clr   @edb.rle              ; RLE compression off
     7654 230E 
0040               
0041               edb.init.exit:
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045 7656 0460  28         b     @poprt                ; Return to caller
     7658 6132 
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
0072 765A 0649  14         dect  stack
0073 765C C64B  30         mov   r11,*stack            ; Save return address
0074                       ;------------------------------------------------------
0075                       ; Get values
0076                       ;------------------------------------------------------
0077 765E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7660 220C 
     7662 8390 
0078 7664 04E0  34         clr   @fb.column
     7666 220C 
0079 7668 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     766A 74E6 
0080                       ;------------------------------------------------------
0081                       ; Prepare scan
0082                       ;------------------------------------------------------
0083 766C 04C4  14         clr   tmp0                  ; Counter
0084 766E C160  34         mov   @fb.current,tmp1      ; Get position
     7670 2202 
0085 7672 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7674 8392 
0086               
0087                       ;------------------------------------------------------
0088                       ; Scan line for >00 byte termination
0089                       ;------------------------------------------------------
0090               edb.line.pack.scan:
0091 7676 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0092 7678 0986  56         srl   tmp2,8                ; Right justify
0093 767A 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0094 767C 0584  14         inc   tmp0                  ; Increase string length
0095 767E 10FB  14         jmp   edb.line.pack.scan    ; Next character
0096               
0097                       ;------------------------------------------------------
0098                       ; Prepare for storing line
0099                       ;------------------------------------------------------
0100               edb.line.pack.prepare:
0101 7680 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7682 2204 
     7684 8350 
0102 7686 A820  54         a     @fb.row,@parm1        ; /
     7688 2206 
     768A 8350 
0103               
0104 768C C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     768E 8394 
0105               
0106                       ;------------------------------------------------------
0107                       ; 1. Update index
0108                       ;------------------------------------------------------
0109               edb.line.pack.update_index:
0110 7690 C820  54         mov   @edb.next_free.ptr,@parm2
     7692 2308 
     7694 8352 
0111                                                   ; Block where line will reside
0112               
0113 7696 04E0  34         clr   @parm3                ; SAMS bank
     7698 8354 
0114 769A 06A0  32         bl    @idx.entry.update     ; Update index
     769C 758E 
0115                                                   ; \ .  parm1 = Line number in editor buffer
0116                                                   ; | .  parm2 = pointer to line in editor buffer
0117                                                   ; / .  parm3 = SAMS bank (0-A)
0118               
0119                       ;------------------------------------------------------
0120                       ; 2. Set line prefix in editor buffer
0121                       ;------------------------------------------------------
0122 769E C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     76A0 8392 
0123 76A2 C160  34         mov   @edb.next_free.ptr,tmp1
     76A4 2308 
0124                                                   ; Address of line in editor buffer
0125               
0126 76A6 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     76A8 2308 
0127               
0128 76AA C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     76AC 8394 
0129 76AE 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0130 76B0 06C6  14         swpb  tmp2
0131 76B2 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0132 76B4 06C6  14         swpb  tmp2
0133 76B6 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0134               
0135                       ;------------------------------------------------------
0136                       ; 3. Copy line from framebuffer to editor buffer
0137                       ;------------------------------------------------------
0138               edb.line.pack.copyline:
0139 76B8 0286  22         ci    tmp2,2
     76BA 0002 
0140 76BC 1603  14         jne   edb.line.pack.copyline.checkbyte
0141 76BE DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0142 76C0 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0143 76C2 1007  14         jmp   !
0144               edb.line.pack.copyline.checkbyte:
0145 76C4 0286  22         ci    tmp2,1
     76C6 0001 
0146 76C8 1602  14         jne   edb.line.pack.copyline.block
0147 76CA D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0148 76CC 1002  14         jmp   !
0149               edb.line.pack.copyline.block:
0150 76CE 06A0  32         bl    @xpym2m               ; Copy memory block
     76D0 6386 
0151                                                   ;   tmp0 = source
0152                                                   ;   tmp1 = destination
0153                                                   ;   tmp2 = bytes to copy
0154               
0155 76D2 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     76D4 8394 
     76D6 2308 
0156                                                   ; Update pointer to next free line
0157               
0158                       ;------------------------------------------------------
0159                       ; Exit
0160                       ;------------------------------------------------------
0161               edb.line.pack.exit:
0162 76D8 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     76DA 8390 
     76DC 220C 
0163 76DE 0460  28         b     @poprt                ; Return to caller
     76E0 6132 
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
0193 76E2 0649  14         dect  stack
0194 76E4 C64B  30         mov   r11,*stack            ; Save return address
0195                       ;------------------------------------------------------
0196                       ; Save parameters
0197                       ;------------------------------------------------------
0198 76E6 C820  54         mov   @parm1,@rambuf
     76E8 8350 
     76EA 8390 
0199 76EC C820  54         mov   @parm2,@rambuf+2
     76EE 8352 
     76F0 8392 
0200                       ;------------------------------------------------------
0201                       ; Calculate offset in frame buffer
0202                       ;------------------------------------------------------
0203 76F2 C120  34         mov   @fb.colsline,tmp0
     76F4 220E 
0204 76F6 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     76F8 8352 
0205 76FA C1A0  34         mov   @fb.top.ptr,tmp2
     76FC 2200 
0206 76FE A146  18         a     tmp2,tmp1             ; Add base to offset
0207 7700 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7702 8396 
0208                       ;------------------------------------------------------
0209                       ; Get length of line to unpack
0210                       ;------------------------------------------------------
0211 7704 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7706 7762 
0212                                                   ; \ .  parm1    = Line number
0213                                                   ; | o  outparm1 = Line length (uncompressed)
0214                                                   ; | o  outparm2 = Line length (compressed)
0215                                                   ; / o  outparm3 = SAMS bank (>0 - >a)
0216               
0217 7708 C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     770A 8362 
     770C 839A 
0218 770E C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     7710 8360 
     7712 8398 
0219 7714 1307  14         jeq   edb.line.unpack.clear ; Skip index processing if empty line anyway
0220               
0221                       ;------------------------------------------------------
0222                       ; Index. Calculate address of entry and get pointer
0223                       ;------------------------------------------------------
0224 7716 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7718 7608 
0225                                                   ; \ .  parm1    = Line number
0226                                                   ; | o  outparm1 = Pointer to line
0227                                                   ; / o  outparm2 = SAMS bank
0228               
0229 771A 05E0  34         inct  @outparm1             ; Skip line prefix
     771C 8360 
0230 771E C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7720 8360 
     7722 8394 
0231               
0232                       ;------------------------------------------------------
0233                       ; Erase chars from last column until column 80
0234                       ;------------------------------------------------------
0235               edb.line.unpack.clear:
0236 7724 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7726 8396 
0237 7728 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     772A 8398 
0238               
0239 772C 04C5  14         clr   tmp1                  ; Fill with >00
0240 772E C1A0  34         mov   @fb.colsline,tmp2
     7730 220E 
0241 7732 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7734 8398 
0242 7736 0586  14         inc   tmp2
0243               
0244 7738 06A0  32         bl    @xfilm                ; Fill CPU memory
     773A 613C 
0245                                                   ; \ .  tmp0 = Target address
0246                                                   ; | .  tmp1 = Byte to fill
0247                                                   ; / .  tmp2 = Repeat count
0248               
0249                       ;------------------------------------------------------
0250                       ; Prepare for unpacking data
0251                       ;------------------------------------------------------
0252               edb.line.unpack.prepare:
0253 773C C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     773E 8398 
0254 7740 130E  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0255 7742 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7744 8394 
0256 7746 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7748 8396 
0257                       ;------------------------------------------------------
0258                       ; Either RLE decompress or do normal memory copy
0259                       ;------------------------------------------------------
0260 774A C1E0  34         mov   @edb.rle,tmp3
     774C 230E 
0261 774E 1305  14         jeq   edb.line.unpack.copy.uncompressed
0262                       ;------------------------------------------------------
0263                       ; Uncompress RLE line to frame buffer
0264                       ;------------------------------------------------------
0265 7750 C1A0  34         mov   @rambuf+10,tmp2       ; Line compressed length
     7752 839A 
0266               
0267 7754 06A0  32         bl    @xrle2cpu             ; RLE decompress to CPU memory
     7756 6864 
0268                                                   ; \ .  tmp0 = ROM/RAM source address
0269                                                   ; | .  tmp1 = RAM target address
0270                                                   ; / .  tmp2 = Length of RLE encoded data
0271 7758 1002  14         jmp   edb.line.unpack.exit
0272               
0273               edb.line.unpack.copy.uncompressed:
0274                       ;------------------------------------------------------
0275                       ; Copy memory block
0276                       ;------------------------------------------------------
0277 775A 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     775C 6386 
0278                                                   ; \ .  tmp0 = Source address
0279                                                   ; | .  tmp1 = Target address
0280                                                   ; / .  tmp2 = Bytes to copy
0281                       ;------------------------------------------------------
0282                       ; Exit
0283                       ;------------------------------------------------------
0284               edb.line.unpack.exit:
0285 775E 0460  28         b     @poprt                ; Return to caller
     7760 6132 
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
0308 7762 0649  14         dect  stack
0309 7764 C64B  30         mov   r11,*stack            ; Save return address
0310                       ;------------------------------------------------------
0311                       ; Initialisation
0312                       ;------------------------------------------------------
0313 7766 04E0  34         clr   @outparm1             ; Reset uncompressed length
     7768 8360 
0314 776A 04E0  34         clr   @outparm2             ; Reset compressed length
     776C 8362 
0315 776E 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7770 8364 
0316                       ;------------------------------------------------------
0317                       ; Get length
0318                       ;------------------------------------------------------
0319 7772 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7774 7608 
0320                                                   ; \  parm1    = Line number
0321                                                   ; |  outparm1 = Pointer to line
0322                                                   ; /  outparm2 = SAMS bank
0323               
0324 7776 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     7778 8360 
0325 777A 130D  14         jeq   edb.line.getlength.exit
0326                                                   ; Exit early if NULL pointer
0327 777C C820  54         mov   @outparm2,@outparm3   ; Save SAMS bank
     777E 8362 
     7780 8364 
0328                       ;------------------------------------------------------
0329                       ; Process line prefix
0330                       ;------------------------------------------------------
0331 7782 04C5  14         clr   tmp1
0332 7784 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0333 7786 06C5  14         swpb  tmp1
0334 7788 C805  38         mov   tmp1,@outparm2        ; Save length
     778A 8362 
0335               
0336 778C 04C5  14         clr   tmp1
0337 778E D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0338 7790 06C5  14         swpb  tmp1
0339 7792 C805  38         mov   tmp1,@outparm1        ; Save length
     7794 8360 
0340                       ;------------------------------------------------------
0341                       ; Exit
0342                       ;------------------------------------------------------
0343               edb.line.getlength.exit:
0344 7796 0460  28         b     @poprt                ; Return to caller
     7798 6132 
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
0365 779A 0649  14         dect  stack
0366 779C C64B  30         mov   r11,*stack            ; Save return address
0367                       ;------------------------------------------------------
0368                       ; Calculate line in editor buffer
0369                       ;------------------------------------------------------
0370 779E C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     77A0 2204 
0371 77A2 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     77A4 2206 
0372                       ;------------------------------------------------------
0373                       ; Get length
0374                       ;------------------------------------------------------
0375 77A6 C804  38         mov   tmp0,@parm1
     77A8 8350 
0376 77AA 06A0  32         bl    @edb.line.getlength
     77AC 7762 
0377 77AE C820  54         mov   @outparm1,@fb.row.length
     77B0 8360 
     77B2 2208 
0378                                                   ; Save row length
0379                       ;------------------------------------------------------
0380                       ; Exit
0381                       ;------------------------------------------------------
0382               edb.line.getlength2.exit:
0383 77B4 0460  28         b     @poprt                ; Return to caller
     77B6 6132 
0384               
**** **** ****     > tivi.asm.16324
0613               
0614               
0615               ***************************************************************
0616               *               fh - File handling module
0617               ***************************************************************
0618                       copy  "filehandler.asm"
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
0028 77B8 0649  14         dect  stack
0029 77BA C64B  30         mov   r11,*stack            ; Save return address
0030 77BC C820  54         mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
     77BE 8352 
     77C0 2436 
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 77C2 04E0  34         clr   @tfh.records          ; Reset records counter
     77C4 242E 
0035 77C6 04E0  34         clr   @tfh.counter          ; Clear internal counter
     77C8 2434 
0036 77CA 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     77CC 2432 
0037 77CE 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0038 77D0 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     77D2 242A 
0039 77D4 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     77D6 242C 
0040                       ;------------------------------------------------------
0041                       ; Show loading indicators and file descriptor
0042                       ;------------------------------------------------------
0043 77D8 06A0  32         bl    @hchar
     77DA 6516 
0044 77DC 1D00                   byte 29,0,32,80
     77DE 2050 
0045 77E0 FFFF                   data EOL
0046               
0047 77E2 06A0  32         bl    @putat
     77E4 6330 
0048 77E6 1D00                   byte 29,0
0049 77E8 79FA                   data txt_loading      ; Display "Loading...."
0050               
0051 77EA 8820  54         c     @tfh.rleonload,@w$ffff
     77EC 2436 
     77EE 6048 
0052 77F0 1604  14         jne   !
0053 77F2 06A0  32         bl    @putat
     77F4 6330 
0054 77F6 1D44                   byte 29,68
0055 77F8 7A0A                   data txt_rle          ; Display "RLE"
0056               
0057 77FA 06A0  32 !       bl    @at
     77FC 6422 
0058 77FE 1D0B                   byte 29,11            ; Cursor YX position
0059 7800 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7802 8350 
0060 7804 06A0  32         bl    @xutst0               ; Display device/filename
     7806 6320 
0061                       ;------------------------------------------------------
0062                       ; Copy PAB header to VDP
0063                       ;------------------------------------------------------
0064 7808 06A0  32         bl    @cpym2v
     780A 6338 
0065 780C 0A60                   data tfh.vpab,tfh.file.pab.header,9
     780E 79BC 
     7810 0009 
0066                                                   ; Copy PAB header to VDP
0067                       ;------------------------------------------------------
0068                       ; Append file descriptor to PAB header in VDP
0069                       ;------------------------------------------------------
0070 7812 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7814 0A69 
0071 7816 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7818 8350 
0072 781A D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0073 781C 0986  56         srl   tmp2,8                ; Right justify
0074 781E 0586  14         inc   tmp2                  ; Include length byte as well
0075 7820 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7822 633E 
0076                       ;------------------------------------------------------
0077                       ; Load GPL scratchpad layout
0078                       ;------------------------------------------------------
0079 7824 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7826 6928 
0080 7828 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0081                       ;------------------------------------------------------
0082                       ; Open file
0083                       ;------------------------------------------------------
0084 782A 06A0  32         bl    @file.open
     782C 6A76 
0085 782E 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0086 7830 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7832 6042 
0087 7834 1602  14         jne   tfh.file.read.record
0088 7836 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7838 7970 
0089                       ;------------------------------------------------------
0090                       ; Step 1: Read file record
0091                       ;------------------------------------------------------
0092               tfh.file.read.record:
0093 783A 05A0  34         inc   @tfh.records          ; Update counter
     783C 242E 
0094 783E 04E0  34         clr   @tfh.reclen           ; Reset record length
     7840 2430 
0095               
0096 7842 06A0  32         bl    @file.record.read     ; Read file record
     7844 6AB8 
0097 7846 0A60                   data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
0098                                                   ; | o  tmp0 = Status byte
0099                                                   ; | o  tmp1 = Bytes read
0100                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0101               
0102 7848 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     784A 242A 
0103 784C C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     784E 2430 
0104 7850 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7852 242C 
0105                       ;------------------------------------------------------
0106                       ; 1a: Calculate kilobytes processed
0107                       ;------------------------------------------------------
0108 7854 A805  38         a     tmp1,@tfh.counter
     7856 2434 
0109 7858 A160  34         a     @tfh.counter,tmp1
     785A 2434 
0110 785C 0285  22         ci    tmp1,1024
     785E 0400 
0111 7860 1106  14         jlt   !
0112 7862 05A0  34         inc   @tfh.kilobytes
     7864 2432 
0113 7866 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7868 FC00 
0114 786A C805  38         mov   tmp1,@tfh.counter
     786C 2434 
0115                       ;------------------------------------------------------
0116                       ; 1b: Load spectra scratchpad layout
0117                       ;------------------------------------------------------
0118 786E 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     7870 68AE 
0119 7872 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7874 694A 
0120 7876 2100                   data scrpad.backup2   ; / >2100->8300
0121                       ;------------------------------------------------------
0122                       ; 1c: Check if a file error occured
0123                       ;------------------------------------------------------
0124               tfh.file.read.check:
0125 7878 C1A0  34         mov   @tfh.ioresult,tmp2
     787A 242C 
0126 787C 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     787E 6042 
0127 7880 1377  14         jeq   tfh.file.read.error
0128                                                   ; Yes, so handle file error
0129                       ;------------------------------------------------------
0130                       ; 1d: Decide on copy line from VDP buffer to editor
0131                       ;     buffer (RLE off) or RAM buffer (RLE on)
0132                       ;------------------------------------------------------
0133 7882 8820  54         c     @tfh.rleonload,@w$ffff
     7884 2436 
     7886 6048 
0134                                                   ; RLE compression on?
0135 7888 1314  14         jeq   tfh.file.read.compression
0136                                                   ; Yes, do RLE compression
0137                       ;------------------------------------------------------
0138                       ; Step 2: Process line without doing RLE compression
0139                       ;------------------------------------------------------
0140               tfh.file.read.nocompression:
0141 788A 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     788C 0960 
0142 788E C160  34         mov   @edb.next_free.ptr,tmp1
     7890 2308 
0143                                                   ; RAM target in editor buffer
0144               
0145 7892 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7894 8352 
0146               
0147 7896 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7898 2430 
0148 789A 1337  14         jeq   tfh.file.read.prepindex.emptyline
0149                                                   ; Handle empty line
0150                       ;------------------------------------------------------
0151                       ; 2a: Copy line from VDP to CPU editor buffer
0152                       ;------------------------------------------------------
0153                                                   ; Save line prefix
0154 789C DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0155 789E 06C6  14         swpb  tmp2                  ; |
0156 78A0 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0157 78A2 06C6  14         swpb  tmp2                  ; /
0158               
0159 78A4 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     78A6 2308 
0160 78A8 A806  38         a     tmp2,@edb.next_free.ptr
     78AA 2308 
0161                                                   ; Add line length
0162               
0163 78AC 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     78AE 6364 
0164                                                   ; \ .  tmp0 = VDP source address
0165                                                   ; | .  tmp1 = RAM target address
0166                                                   ; / .  tmp2 = Bytes to copy
0167               
0168 78B0 1028  14         jmp   tfh.file.read.prepindex
0169                                                   ; Prepare for updating index
0170                       ;------------------------------------------------------
0171                       ; Step 3: Process line and do RLE compression
0172                       ;------------------------------------------------------
0173               tfh.file.read.compression:
0174 78B2 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     78B4 0960 
0175 78B6 0205  20         li    tmp1,fb.top           ; RAM target address
     78B8 2650 
0176 78BA C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     78BC 2430 
0177 78BE 1325  14         jeq   tfh.file.read.prepindex.emptyline
0178                                                   ; Handle empty line
0179               
0180 78C0 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     78C2 6364 
0181                                                   ; \ .  tmp0 = VDP source address
0182                                                   ; | .  tmp1 = RAM target address
0183                                                   ; / .  tmp2 = Bytes to copy
0184               
0185                       ;------------------------------------------------------
0186                       ; 3a: RLE compression on line
0187                       ;------------------------------------------------------
0188 78C4 0204  20         li    tmp0,fb.top           ; RAM source of uncompressed line
     78C6 2650 
0189 78C8 0205  20         li    tmp1,fb.top+160       ; RAM target for compressed line
     78CA 26F0 
0190 78CC C1A0  34         mov   @tfh.reclen,tmp2      ; Length of string
     78CE 2430 
0191               
0192 78D0 06A0  32         bl    @xcpu2rle             ; RLE compression
     78D2 67B2 
0193                                                   ; \ .  tmp0  = ROM/RAM source address
0194                                                   ; | .  tmp1  = RAM target address
0195                                                   ; | .  tmp2  = Length uncompressed data
0196                                                   ; / o  waux1 = Length RLE encoded string
0197                       ;------------------------------------------------------
0198                       ; 3b: Set line prefix
0199                       ;------------------------------------------------------
0200 78D4 C160  34         mov   @edb.next_free.ptr,tmp1
     78D6 2308 
0201                                                   ; RAM target address
0202 78D8 C805  38         mov   tmp1,@parm2           ; Pointer to line in editor buffer
     78DA 8352 
0203 78DC C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     78DE 833C 
0204 78E0 06C6  14         swpb  tmp2                  ;
0205 78E2 DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0206               
0207 78E4 C1A0  34         mov   @tfh.reclen,tmp2      ; Length of uncompressed string
     78E6 2430 
0208 78E8 06C6  14         swpb  tmp2
0209 78EA DD46  32         movb  tmp2,*tmp1+           ; Length byte to line prefix
0210 78EC 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced
     78EE 2308 
0211                       ;------------------------------------------------------
0212                       ; 3c: Copy compressed line to editor buffer
0213                       ;------------------------------------------------------
0214 78F0 0204  20         li    tmp0,fb.top+160       ; RAM source address
     78F2 26F0 
0215 78F4 C1A0  34         mov   @waux1,tmp2           ; Length of RLE compressed string
     78F6 833C 
0216               
0217 78F8 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     78FA 6386 
0218                                                   ; \ .  tmp0 = RAM source address
0219                                                   ; | .  tmp1 = RAM target address
0220                                                   ; / .  tmp2 = Bytes to copy
0221               
0222 78FC A820  54         a     @waux1,@edb.next_free.ptr
     78FE 833C 
     7900 2308 
0223                                                   ; Update pointer to next free line
0224                       ;------------------------------------------------------
0225                       ; Step 4: Update index
0226                       ;------------------------------------------------------
0227               tfh.file.read.prepindex:
0228 7902 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7904 2304 
     7906 8350 
0229                                                   ; parm2 = Must allready be set!
0230 7908 1007  14         jmp   tfh.file.read.updindex
0231                                                   ; Update index
0232                       ;------------------------------------------------------
0233                       ; 4a: Special handling for empty line
0234                       ;------------------------------------------------------
0235               tfh.file.read.prepindex.emptyline:
0236 790A C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     790C 242E 
     790E 8350 
0237 7910 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7912 8350 
0238 7914 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7916 8352 
0239                       ;------------------------------------------------------
0240                       ; 4b: Do actual index update
0241                       ;------------------------------------------------------
0242               tfh.file.read.updindex:
0243 7918 04E0  34         clr   @parm3
     791A 8354 
0244 791C 06A0  32         bl    @idx.entry.update     ; Update index
     791E 758E 
0245                                                   ; \ .  parm1    = Line number in editor buffer
0246                                                   ; | .  parm2    = Pointer to line in editor buffer
0247                                                   ; | .  parm3    = SAMS bank (0-A)
0248                                                   ; / o  outparm1 = Pointer to updated index entry
0249               
0250 7920 05A0  34         inc   @edb.lines            ; lines=lines+1
     7922 2304 
0251                       ;------------------------------------------------------
0252                       ; Step 5: Display results
0253                       ;------------------------------------------------------
0254               tfh.file.read.display:
0255 7924 06A0  32         bl    @putnum
     7926 67A2 
0256 7928 1D49                   byte 29,73            ; Show lines read
0257 792A 2304                   data edb.lines,rambuf,>3020
     792C 8390 
     792E 3020 
0258               
0259 7930 8220  34         c     @tfh.kilobytes,tmp4
     7932 2432 
0260 7934 130C  14         jeq   tfh.file.read.checkmem
0261               
0262 7936 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7938 2432 
0263               
0264 793A 06A0  32         bl    @putnum
     793C 67A2 
0265 793E 1D38                   byte 29,56            ; Show kilobytes read
0266 7940 2432                   data tfh.kilobytes,rambuf,>3020
     7942 8390 
     7944 3020 
0267               
0268 7946 06A0  32         bl    @putat
     7948 6330 
0269 794A 1D3D                   byte 29,61
0270 794C 7A06                   data txt_kb           ; Show "kb" string
0271               
0272               ******************************************************
0273               * Stop reading file if high memory expansion gets full
0274               ******************************************************
0275               tfh.file.read.checkmem:
0276 794E C120  34         mov   @edb.next_free.ptr,tmp0
     7950 2308 
0277 7952 0284  22         ci    tmp0,>ffa0
     7954 FFA0 
0278 7956 1207  14         jle   tfh.file.read.next
0279 7958 1015  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0280                       ;------------------------------------------------------
0281                       ; Next SAMS page
0282                       ;------------------------------------------------------
0283 795A 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     795C 230A 
0284 795E 0204  20         li    tmp0,edb.top
     7960 A000 
0285 7962 C804  38         mov   tmp0,@edb.next_free.ptr
     7964 2308 
0286                                                   ; Reset to top of editor buffer
0287                       ;------------------------------------------------------
0288                       ; Next record
0289                       ;------------------------------------------------------
0290               tfh.file.read.next:
0291 7966 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7968 6928 
0292 796A 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0293               
0294 796C 0460  28         b     @tfh.file.read.record
     796E 783A 
0295                                                   ; Next record
0296                       ;------------------------------------------------------
0297                       ; Error handler
0298                       ;------------------------------------------------------
0299               tfh.file.read.error:
0300 7970 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7972 242A 
0301 7974 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0302 7976 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7978 0005 
0303 797A 1304  14         jeq   tfh.file.read.eof
0304                                                   ; All good. File closed by DSRLNK
0305                       ;------------------------------------------------------
0306                       ; File error occured
0307                       ;------------------------------------------------------
0308 797C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     797E FFCE 
0309 7980 06A0  32         bl    @crash                ; / Crash and halt system
     7982 604C 
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               tfh.file.read.eof:
0314 7984 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7986 694A 
0315 7988 2100                   data scrpad.backup2   ; / >2100->8300
0316                       ;------------------------------------------------------
0317                       ; Display final results
0318                       ;------------------------------------------------------
0319 798A 06A0  32         bl    @hchar
     798C 6516 
0320 798E 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7990 200A 
0321 7992 FFFF                   data EOL
0322               
0323 7994 06A0  32         bl    @putnum
     7996 67A2 
0324 7998 1D38                   byte 29,56            ; Show kilobytes read
0325 799A 2432                   data tfh.kilobytes,rambuf,>3020
     799C 8390 
     799E 3020 
0326               
0327 79A0 06A0  32         bl    @putat
     79A2 6330 
0328 79A4 1D3D                   byte 29,61
0329 79A6 7A06                   data txt_kb           ; Show "kb" string
0330               
0331 79A8 06A0  32         bl    @putnum
     79AA 67A2 
0332 79AC 1D49                   byte 29,73            ; Show lines read
0333 79AE 242E                   data tfh.records,rambuf,>3020
     79B0 8390 
     79B2 3020 
0334               
0335 79B4 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     79B6 2306 
0336               *--------------------------------------------------------------
0337               * Exit
0338               *--------------------------------------------------------------
0339               tfh.file.read_exit:
0340 79B8 0460  28         b     @poprt                ; Return to caller
     79BA 6132 
0341               
0342               
0343               ***************************************************************
0344               * PAB for accessing DV/80 file
0345               ********|*****|*********************|**************************
0346               tfh.file.pab.header:
0347 79BC 0014             byte  io.op.open            ;  0    - OPEN
0348                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0349 79BE 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0350 79C0 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0351                       byte  00                    ;  5    - Character count
0352 79C2 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0353 79C4 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0354                       ;------------------------------------------------------
0355                       ; File descriptor part (variable length)
0356                       ;------------------------------------------------------
0357                       ; byte  12                  ;  9    - File descriptor length
0358                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.16324
0619               
0620               
0621               ***************************************************************
0622               *                      Constants
0623               ***************************************************************
0624               romsat:
0625 79C6 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     79C8 000F 
0626               
0627               cursors:
0628 79CA 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     79CC 0000 
     79CE 0000 
     79D0 001C 
0629 79D2 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     79D4 1010 
     79D6 1010 
     79D8 1000 
0630 79DA 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     79DC 1C1C 
     79DE 1C1C 
     79E0 1C00 
0631               
0632               ***************************************************************
0633               *                       Strings
0634               ***************************************************************
0635               txt_delim
0636 79E2 012C             byte  1
0637 79E3 ....             text  ','
0638                       even
0639               
0640               txt_marker
0641 79E4 052A             byte  5
0642 79E5 ....             text  '*EOF*'
0643                       even
0644               
0645               txt_bottom
0646 79EA 0520             byte  5
0647 79EB ....             text  '  BOT'
0648                       even
0649               
0650               txt_ovrwrite
0651 79F0 034F             byte  3
0652 79F1 ....             text  'OVR'
0653                       even
0654               
0655               txt_insert
0656 79F4 0349             byte  3
0657 79F5 ....             text  'INS'
0658                       even
0659               
0660               txt_star
0661 79F8 012A             byte  1
0662 79F9 ....             text  '*'
0663                       even
0664               
0665               txt_loading
0666 79FA 0A4C             byte  10
0667 79FB ....             text  'Loading...'
0668                       even
0669               
0670               txt_kb
0671 7A06 026B             byte  2
0672 7A07 ....             text  'kb'
0673                       even
0674               
0675               txt_rle
0676 7A0A 0352             byte  3
0677 7A0B ....             text  'RLE'
0678                       even
0679               
0680               txt_lines
0681 7A0E 054C             byte  5
0682 7A0F ....             text  'Lines'
0683                       even
0684               
0685 7A14 7A14     end          data    $
0686               
0687               
0688               fdname0
0689 7A16 0D44             byte  13
0690 7A17 ....             text  'DSK1.INVADERS'
0691                       even
0692               
0693               fdname1
0694 7A24 0F44             byte  15
0695 7A25 ....             text  'DSK1.SPEECHDOCS'
0696                       even
0697               
0698               fdname2
0699 7A34 0C44             byte  12
0700 7A35 ....             text  'DSK1.XBEADOC'
0701                       even
0702               
0703               fdname3
0704 7A42 0C44             byte  12
0705 7A43 ....             text  'DSK3.XBEADOC'
0706                       even
0707               
0708               fdname4
0709 7A50 0C44             byte  12
0710 7A51 ....             text  'DSK3.C99MAN1'
0711                       even
0712               
0713               fdname5
0714 7A5E 0C44             byte  12
0715 7A5F ....             text  'DSK3.C99MAN2'
0716                       even
0717               
0718               fdname6
0719 7A6C 0C44             byte  12
0720 7A6D ....             text  'DSK3.C99MAN3'
0721                       even
0722               
0723               fdname7
0724 7A7A 0D44             byte  13
0725 7A7B ....             text  'DSK3.C99SPECS'
0726                       even
0727               
0728               fdname8
0729 7A88 0D44             byte  13
0730 7A89 ....             text  'DSK3.RANDOM#C'
0731                       even
0732               
0733               fdname9
0734 7A96 0D44             byte  13
0735 7A97 ....             text  'DSK1.INVADERS'
0736                       even
0737               
0738               
0739               
0740               ***************************************************************
0741               *                  Sanity check on ROM size
0742               ***************************************************************
0746 7AA4 7AA4              data $   ; ROM size OK.

XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.28024
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 191227-28024
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
0025               * 3000-3fff    4096   >0000   Index
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
0132      2300     edb.top.ptr     equ  >2300          ; Pointer to editor buffer
0133      2302     edb.index.ptr   equ  edb.top.ptr+2  ; Pointer to index
0134      2304     edb.lines       equ  edb.top.ptr+4  ; Total lines in editor buffer
0135      2306     edb.dirty       equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0136      2308     edb.next_free   equ  edb.top.ptr+8  ; Pointer to next free line
0137      230A     edb.insmode     equ  edb.top.ptr+10 ; Editor insert mode (>0000 overwrite / >ffff insert)
0138      230C     edb.end         equ  edb.top.ptr+12 ; Free from here on
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
0152      2436     tfh.membuffer   equ  tfh.top + 54   ; 80 bytes file memory buffer
0153      2486     tfh.end         equ  tfh.top + 134  ; Free from here on
0154      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0155      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0156               *--------------------------------------------------------------
0157               * Free for future use               @>2500-264f     (336 bytes)
0158               *--------------------------------------------------------------
0159      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0160      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0161               *--------------------------------------------------------------
0162               * Frame buffer                      @>2650-2fff    (2480 bytes)
0163               *--------------------------------------------------------------
0164      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0165      09B0     fb.size         equ  2480           ; Frame buffer size
0166               *--------------------------------------------------------------
0167               * Index                             @>3000-3fff    (4096 bytes)
0168               *--------------------------------------------------------------
0169      3000     idx.top         equ  >3000          ; Top of index
0170      1000     idx.size        equ  4096           ; Index size
0171               *--------------------------------------------------------------
0172               * Editor buffer                     @>a000-ffff   (24576 bytes)
0173               *--------------------------------------------------------------
0174      A000     edb.top         equ  >a000          ; Editor buffer high memory
0175      6000     edb.size        equ  24576          ; Editor buffer size
0176               *--------------------------------------------------------------
0177               
0178               
0179               
0180               *--------------------------------------------------------------
0181               * Cartridge header
0182               *--------------------------------------------------------------
0183                       save  >6000,>7fff
0184                       aorg  >6000
0185               
0186 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0187 6006 6010             data  prog0
0188 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0189 6010 0000     prog0   data  0                     ; No more items following
0190 6012 6F32             data  runlib
0191               
0193               
0194 6014 1154             byte  17
0195 6015 ....             text  'TIVI 191227-28024'
0196                       even
0197               
0205               *--------------------------------------------------------------
0206               * Include required files
0207               *--------------------------------------------------------------
0208                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0011               *                      2010-2019 by Filip Van Vooren
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
0038               * skip_vdp_rle_decompress   equ  1  ; Skip RLE decompress to VRAM
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
0055               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0056               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0057               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0058               *
0059               * == Kernel/Multitasking
0060               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0061               * skip_mem_paging           equ  1  ; Skip support for memory paging
0062               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0063               *
0064               * == Startup behaviour
0065               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0066               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0067               *******************************************************************************
0068               
0069               *//////////////////////////////////////////////////////////////
0070               *                       RUNLIB SETUP
0071               *//////////////////////////////////////////////////////////////
0072               
0073                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
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
0074                       copy  "equ_registers.asm"        ; Equates for runlib registers
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
0075                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
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
0076                       copy  "equ_param.asm"            ; Equates for runlib parameters
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
0077               
0081               
0082                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
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
0083                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0084                       copy  "cpu_crash_handler.asm"    ; CPU program crashed handler
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
     605A 6F3A 
0019               
0020               crash_handler.main:
0021 605C 06A0  32         bl    @putat                ; Show crash message
     605E 6292 
0022 6060 0000             data  >0000,crash_handler.message
     6062 6068 
0023 6064 0460  28         b     @tmgr                 ; FNCTN-+ to quit
     6066 6E48 
0024               
0025               crash_handler.message:
0026 6068 2553             byte  37
0027 6069 ....             text  'System crashed. Press FNCTN-+ to quit'
0028               
0029               
**** **** ****     > runlib.asm
0085                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0086                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0087               
0089                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0091               
0093                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0095               
0097                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0031 62EA 1602  14         jne   cpym0
0032 62EC 0460  28         b     @crash_handler        ; Yes, crash
     62EE 604C 
0033 62F0 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62F2 7FFF 
0034 62F4 C1C4  18         mov   tmp0,tmp3
0035 62F6 0247  22         andi  tmp3,1
     62F8 0001 
0036 62FA 1618  14         jne   cpyodd                ; Odd source address handling
0037 62FC C1C5  18 cpym1   mov   tmp1,tmp3
0038 62FE 0247  22         andi  tmp3,1
     6300 0001 
0039 6302 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 6304 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     6306 6046 
0044 6308 1605  14         jne   cpym3
0045 630A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     630C 6332 
     630E 8320 
0046 6310 0460  28         b     @mcloop               ; Copy memory and exit
     6312 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 6314 C1C6  18 cpym3   mov   tmp2,tmp3
0051 6316 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6318 0001 
0052 631A 1301  14         jeq   cpym4
0053 631C 0606  14         dec   tmp2                  ; Make TMP2 even
0054 631E CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 6320 0646  14         dect  tmp2
0056 6322 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 6324 C1C7  18         mov   tmp3,tmp3
0061 6326 1301  14         jeq   cpymz
0062 6328 D554  38         movb  *tmp0,*tmp1
0063 632A 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 632C 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bit 0
     632E 8000 
0068 6330 10E9  14         jmp   cpym2
0069 6332 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0099               
0103               
0107               
0111               
0113                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 6334 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6336 FFBF 
0010 6338 0460  28         b     @putv01
     633A 61A8 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 633C 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     633E 0040 
0018 6340 0460  28         b     @putv01
     6342 61A8 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 6344 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6346 FFDF 
0026 6348 0460  28         b     @putv01
     634A 61A8 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 634C 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     634E 0020 
0034 6350 0460  28         b     @putv01
     6352 61A8 
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 6354 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6356 FFFE 
0011 6358 0460  28         b     @putv01
     635A 61A8 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 635C 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     635E 0001 
0019 6360 0460  28         b     @putv01
     6362 61A8 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 6364 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6366 FFFD 
0027 6368 0460  28         b     @putv01
     636A 61A8 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 636C 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     636E 0002 
0035 6370 0460  28         b     @putv01
     6372 61A8 
**** **** ****     > runlib.asm
0119               
0121                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 6374 C83B  50 at      mov   *r11+,@wyx
     6376 832A 
0019 6378 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 637A B820  54 down    ab    @hb$01,@wyx
     637C 6038 
     637E 832A 
0028 6380 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6382 7820  54 up      sb    @hb$01,@wyx
     6384 6038 
     6386 832A 
0037 6388 045B  20         b     *r11
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
0049 638A C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 638C D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     638E 832A 
0051 6390 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6392 832A 
0052 6394 045B  20         b     *r11
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0021 6396 C120  34 yx2px   mov   @wyx,tmp0
     6398 832A 
0022 639A C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 639C 06C4  14         swpb  tmp0                  ; Y<->X
0024 639E 04C5  14         clr   tmp1                  ; Clear before copy
0025 63A0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 63A2 20A0  38         coc   @wbit1,config         ; f18a present ?
     63A4 6044 
0030 63A6 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 63A8 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     63AA 833A 
     63AC 63D6 
0032 63AE 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 63B0 0A15  56         sla   tmp1,1                ; X = X * 2
0035 63B2 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 63B4 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     63B6 0500 
0037 63B8 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 63BA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 63BC 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 63BE 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 63C0 D105  18         movb  tmp1,tmp0
0051 63C2 06C4  14         swpb  tmp0                  ; X<->Y
0052 63C4 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     63C6 6046 
0053 63C8 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 63CA 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     63CC 6038 
0059 63CE 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     63D0 604A 
0060 63D2 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 63D4 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 63D6 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0127               
0131               
0135               
0137                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 63D8 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 63DA 06A0  32         bl    @putvr                ; Write once
     63DC 6194 
0015 63DE 391C             data  >391c                 ; VR1/57, value 00011100
0016 63E0 06A0  32         bl    @putvr                ; Write twice
     63E2 6194 
0017 63E4 391C             data  >391c                 ; VR1/57, value 00011100
0018 63E6 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 63E8 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 63EA 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63EC 6194 
0028 63EE 391C             data  >391c
0029 63F0 0458  20         b     *tmp4                 ; Exit
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
0040 63F2 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 63F4 06A0  32         bl    @cpym2v
     63F6 629A 
0042 63F8 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     63FA 6436 
     63FC 0006 
0043 63FE 06A0  32         bl    @putvr
     6400 6194 
0044 6402 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6404 06A0  32         bl    @putvr
     6406 6194 
0046 6408 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 640A 0204  20         li    tmp0,>3f00
     640C 3F00 
0052 640E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6410 611C 
0053 6412 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6414 8800 
0054 6416 0984  56         srl   tmp0,8
0055 6418 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     641A 8800 
0056 641C C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 641E 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6420 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6422 BFFF 
0060 6424 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6426 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6428 4000 
0063               f18chk_exit:
0064 642A 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     642C 60F0 
0065 642E 3F00             data  >3f00,>00,6
     6430 0000 
     6432 0006 
0066 6434 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6436 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6438 3F00             data  >3f00                 ; 3f02 / 3f00
0073 643A 0340             data  >0340                 ; 3f04   0340  idle
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
0092 643C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 643E 06A0  32         bl    @putvr
     6440 6194 
0097 6442 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6444 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6446 6194 
0100 6448 391C             data  >391c                 ; Lock the F18a
0101 644A 0458  20         b     *tmp4                 ; Exit
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
0120 644C C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 644E 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6450 6044 
0122 6452 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6454 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6456 8802 
0127 6458 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     645A 6194 
0128 645C 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 645E 04C4  14         clr   tmp0
0130 6460 D120  34         movb  @vdps,tmp0
     6462 8802 
0131 6464 0984  56         srl   tmp0,8
0132 6466 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0139               
0141                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 6468 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     646A 832A 
0018 646C D17B  28         movb  *r11+,tmp1
0019 646E 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6470 D1BB  28         movb  *r11+,tmp2
0021 6472 0986  56         srl   tmp2,8                ; Repeat count
0022 6474 C1CB  18         mov   r11,tmp3
0023 6476 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6478 625C 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 647A 020B  20         li    r11,hchar1
     647C 6482 
0028 647E 0460  28         b     @xfilv                ; Draw
     6480 60F6 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6482 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6484 6048 
0033 6486 1302  14         jeq   hchar2                ; Yes, exit
0034 6488 C2C7  18         mov   tmp3,r11
0035 648A 10EE  14         jmp   hchar                 ; Next one
0036 648C 05C7  14 hchar2  inct  tmp3
0037 648E 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0143               
0147               
0151               
0155               
0159               
0163               
0167               
0171               
0173                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 6490 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6492 6046 
0017 6494 020C  20         li    r12,>0024
     6496 0024 
0018 6498 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     649A 6528 
0019 649C 04C6  14         clr   tmp2
0020 649E 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64A0 04CC  14         clr   r12
0025 64A2 1F08  20         tb    >0008                 ; Shift-key ?
0026 64A4 1302  14         jeq   realk1                ; No
0027 64A6 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64A8 6558 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64AA 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64AC 1302  14         jeq   realk2                ; No
0033 64AE 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64B0 6588 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64B2 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64B4 1302  14         jeq   realk3                ; No
0039 64B6 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64B8 65B8 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64BA 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64BC 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64BE 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64C0 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64C2 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64C4 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64C6 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64C8 0006 
0052 64CA 0606  14 realk5  dec   tmp2
0053 64CC 020C  20         li    r12,>24               ; CRU address for P2-P4
     64CE 0024 
0054 64D0 06C6  14         swpb  tmp2
0055 64D2 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64D4 06C6  14         swpb  tmp2
0057 64D6 020C  20         li    r12,6                 ; CRU read address
     64D8 0006 
0058 64DA 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64DC 0547  14         inv   tmp3                  ;
0060 64DE 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     64E0 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 64E2 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 64E4 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 64E6 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 64E8 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 64EA 0285  22         ci    tmp1,8
     64EC 0008 
0069 64EE 1AFA  14         jl    realk6
0070 64F0 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 64F2 1BEB  14         jh    realk5                ; No, next column
0072 64F4 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 64F6 C206  18 realk8  mov   tmp2,tmp4
0077 64F8 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 64FA A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 64FC A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 64FE D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6500 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6502 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6504 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6506 6046 
0087 6508 1608  14         jne   realka                ; No, continue saving key
0088 650A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     650C 6552 
0089 650E 1A05  14         jl    realka
0090 6510 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6512 6550 
0091 6514 1B02  14         jh    realka                ; No, continue
0092 6516 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6518 E000 
0093 651A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     651C 833C 
0094 651E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6520 6030 
0095 6522 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6524 8C00 
0096 6526 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6528 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     652A 0000 
     652C FF0D 
     652E 203D 
0099 6530 ....             text  'xws29ol.'
0100 6538 ....             text  'ced38ik,'
0101 6540 ....             text  'vrf47ujm'
0102 6548 ....             text  'btg56yhn'
0103 6550 ....             text  'zqa10p;/'
0104 6558 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     655A 0000 
     655C FF0D 
     655E 202B 
0105 6560 ....             text  'XWS@(OL>'
0106 6568 ....             text  'CED#*IK<'
0107 6570 ....             text  'VRF$&UJM'
0108 6578 ....             text  'BTG%^YHN'
0109 6580 ....             text  'ZQA!)P:-'
0110 6588 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     658A 0000 
     658C FF0D 
     658E 2005 
0111 6590 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6592 0804 
     6594 0F27 
     6596 C2B9 
0112 6598 600B             data  >600b,>0907,>063f,>c1B8
     659A 0907 
     659C 063F 
     659E C1B8 
0113 65A0 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65A2 7B02 
     65A4 015F 
     65A6 C0C3 
0114 65A8 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65AA 7D0E 
     65AC 0CC6 
     65AE BFC4 
0115 65B0 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65B2 7C03 
     65B4 BC22 
     65B6 BDBA 
0116 65B8 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65BA 0000 
     65BC FF0D 
     65BE 209D 
0117 65C0 9897             data  >9897,>93b2,>9f8f,>8c9B
     65C2 93B2 
     65C4 9F8F 
     65C6 8C9B 
0118 65C8 8385             data  >8385,>84b3,>9e89,>8b80
     65CA 84B3 
     65CC 9E89 
     65CE 8B80 
0119 65D0 9692             data  >9692,>86b4,>b795,>8a8D
     65D2 86B4 
     65D4 B795 
     65D6 8A8D 
0120 65D8 8294             data  >8294,>87b5,>b698,>888E
     65DA 87B5 
     65DC B698 
     65DE 888E 
0121 65E0 9A91             data  >9a91,>81b1,>b090,>9cBB
     65E2 81B1 
     65E4 B090 
     65E6 9CBB 
**** **** ****     > runlib.asm
0175               
0179               
0181                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 65E8 0207  20 mknum   li    tmp3,5                ; Digit counter
     65EA 0005 
0020 65EC C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 65EE C155  26         mov   *tmp1,tmp1            ; /
0022 65F0 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 65F2 0228  22         ai    tmp4,4                ; Get end of buffer
     65F4 0004 
0024 65F6 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     65F8 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 65FA 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 65FC 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 65FE 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6600 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6602 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6604 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6606 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6608 0607  14         dec   tmp3                  ; Decrease counter
0036 660A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 660C 0207  20         li    tmp3,4                ; Check first 4 digits
     660E 0004 
0041 6610 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6612 C11B  26         mov   *r11,tmp0
0043 6614 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6616 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6618 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 661A 05CB  14 mknum3  inct  r11
0047 661C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     661E 6046 
0048 6620 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6622 045B  20         b     *r11                  ; Exit
0050 6624 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6626 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6628 13F8  14         jeq   mknum3                ; Yes, exit
0053 662A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 662C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     662E 7FFF 
0058 6630 C10B  18         mov   r11,tmp0
0059 6632 0224  22         ai    tmp0,-4
     6634 FFFC 
0060 6636 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6638 0206  20         li    tmp2,>0500            ; String length = 5
     663A 0500 
0062 663C 0460  28         b     @xutstr               ; Display string
     663E 6284 
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
0092 6640 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6642 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6644 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6646 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6648 0207  20         li    tmp3,5                ; Set counter
     664A 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 664C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 664E 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6650 0584  14         inc   tmp0                  ; Next character
0104 6652 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6654 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6656 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6658 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 665A DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 665C 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 665E DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6660 0607  14         dec   tmp3                  ; Last character ?
0120 6662 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6664 045B  20         b     *r11                  ; Return
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
0138 6666 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6668 832A 
0139 666A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     666C 8000 
0140 666E 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0183               
0187               
0191               
0193                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0021 6670 C820  54         mov   @>8300,@>2000
     6672 8300 
     6674 2000 
0022 6676 C820  54         mov   @>8302,@>2002
     6678 8302 
     667A 2002 
0023 667C C820  54         mov   @>8304,@>2004
     667E 8304 
     6680 2004 
0024 6682 C820  54         mov   @>8306,@>2006
     6684 8306 
     6686 2006 
0025 6688 C820  54         mov   @>8308,@>2008
     668A 8308 
     668C 2008 
0026 668E C820  54         mov   @>830A,@>200A
     6690 830A 
     6692 200A 
0027 6694 C820  54         mov   @>830C,@>200C
     6696 830C 
     6698 200C 
0028 669A C820  54         mov   @>830E,@>200E
     669C 830E 
     669E 200E 
0029 66A0 C820  54         mov   @>8310,@>2010
     66A2 8310 
     66A4 2010 
0030 66A6 C820  54         mov   @>8312,@>2012
     66A8 8312 
     66AA 2012 
0031 66AC C820  54         mov   @>8314,@>2014
     66AE 8314 
     66B0 2014 
0032 66B2 C820  54         mov   @>8316,@>2016
     66B4 8316 
     66B6 2016 
0033 66B8 C820  54         mov   @>8318,@>2018
     66BA 8318 
     66BC 2018 
0034 66BE C820  54         mov   @>831A,@>201A
     66C0 831A 
     66C2 201A 
0035 66C4 C820  54         mov   @>831C,@>201C
     66C6 831C 
     66C8 201C 
0036 66CA C820  54         mov   @>831E,@>201E
     66CC 831E 
     66CE 201E 
0037 66D0 C820  54         mov   @>8320,@>2020
     66D2 8320 
     66D4 2020 
0038 66D6 C820  54         mov   @>8322,@>2022
     66D8 8322 
     66DA 2022 
0039 66DC C820  54         mov   @>8324,@>2024
     66DE 8324 
     66E0 2024 
0040 66E2 C820  54         mov   @>8326,@>2026
     66E4 8326 
     66E6 2026 
0041 66E8 C820  54         mov   @>8328,@>2028
     66EA 8328 
     66EC 2028 
0042 66EE C820  54         mov   @>832A,@>202A
     66F0 832A 
     66F2 202A 
0043 66F4 C820  54         mov   @>832C,@>202C
     66F6 832C 
     66F8 202C 
0044 66FA C820  54         mov   @>832E,@>202E
     66FC 832E 
     66FE 202E 
0045 6700 C820  54         mov   @>8330,@>2030
     6702 8330 
     6704 2030 
0046 6706 C820  54         mov   @>8332,@>2032
     6708 8332 
     670A 2032 
0047 670C C820  54         mov   @>8334,@>2034
     670E 8334 
     6710 2034 
0048 6712 C820  54         mov   @>8336,@>2036
     6714 8336 
     6716 2036 
0049 6718 C820  54         mov   @>8338,@>2038
     671A 8338 
     671C 2038 
0050 671E C820  54         mov   @>833A,@>203A
     6720 833A 
     6722 203A 
0051 6724 C820  54         mov   @>833C,@>203C
     6726 833C 
     6728 203C 
0052 672A C820  54         mov   @>833E,@>203E
     672C 833E 
     672E 203E 
0053 6730 C820  54         mov   @>8340,@>2040
     6732 8340 
     6734 2040 
0054 6736 C820  54         mov   @>8342,@>2042
     6738 8342 
     673A 2042 
0055 673C C820  54         mov   @>8344,@>2044
     673E 8344 
     6740 2044 
0056 6742 C820  54         mov   @>8346,@>2046
     6744 8346 
     6746 2046 
0057 6748 C820  54         mov   @>8348,@>2048
     674A 8348 
     674C 2048 
0058 674E C820  54         mov   @>834A,@>204A
     6750 834A 
     6752 204A 
0059 6754 C820  54         mov   @>834C,@>204C
     6756 834C 
     6758 204C 
0060 675A C820  54         mov   @>834E,@>204E
     675C 834E 
     675E 204E 
0061 6760 C820  54         mov   @>8350,@>2050
     6762 8350 
     6764 2050 
0062 6766 C820  54         mov   @>8352,@>2052
     6768 8352 
     676A 2052 
0063 676C C820  54         mov   @>8354,@>2054
     676E 8354 
     6770 2054 
0064 6772 C820  54         mov   @>8356,@>2056
     6774 8356 
     6776 2056 
0065 6778 C820  54         mov   @>8358,@>2058
     677A 8358 
     677C 2058 
0066 677E C820  54         mov   @>835A,@>205A
     6780 835A 
     6782 205A 
0067 6784 C820  54         mov   @>835C,@>205C
     6786 835C 
     6788 205C 
0068 678A C820  54         mov   @>835E,@>205E
     678C 835E 
     678E 205E 
0069 6790 C820  54         mov   @>8360,@>2060
     6792 8360 
     6794 2060 
0070 6796 C820  54         mov   @>8362,@>2062
     6798 8362 
     679A 2062 
0071 679C C820  54         mov   @>8364,@>2064
     679E 8364 
     67A0 2064 
0072 67A2 C820  54         mov   @>8366,@>2066
     67A4 8366 
     67A6 2066 
0073 67A8 C820  54         mov   @>8368,@>2068
     67AA 8368 
     67AC 2068 
0074 67AE C820  54         mov   @>836A,@>206A
     67B0 836A 
     67B2 206A 
0075 67B4 C820  54         mov   @>836C,@>206C
     67B6 836C 
     67B8 206C 
0076 67BA C820  54         mov   @>836E,@>206E
     67BC 836E 
     67BE 206E 
0077 67C0 C820  54         mov   @>8370,@>2070
     67C2 8370 
     67C4 2070 
0078 67C6 C820  54         mov   @>8372,@>2072
     67C8 8372 
     67CA 2072 
0079 67CC C820  54         mov   @>8374,@>2074
     67CE 8374 
     67D0 2074 
0080 67D2 C820  54         mov   @>8376,@>2076
     67D4 8376 
     67D6 2076 
0081 67D8 C820  54         mov   @>8378,@>2078
     67DA 8378 
     67DC 2078 
0082 67DE C820  54         mov   @>837A,@>207A
     67E0 837A 
     67E2 207A 
0083 67E4 C820  54         mov   @>837C,@>207C
     67E6 837C 
     67E8 207C 
0084 67EA C820  54         mov   @>837E,@>207E
     67EC 837E 
     67EE 207E 
0085 67F0 C820  54         mov   @>8380,@>2080
     67F2 8380 
     67F4 2080 
0086 67F6 C820  54         mov   @>8382,@>2082
     67F8 8382 
     67FA 2082 
0087 67FC C820  54         mov   @>8384,@>2084
     67FE 8384 
     6800 2084 
0088 6802 C820  54         mov   @>8386,@>2086
     6804 8386 
     6806 2086 
0089 6808 C820  54         mov   @>8388,@>2088
     680A 8388 
     680C 2088 
0090 680E C820  54         mov   @>838A,@>208A
     6810 838A 
     6812 208A 
0091 6814 C820  54         mov   @>838C,@>208C
     6816 838C 
     6818 208C 
0092 681A C820  54         mov   @>838E,@>208E
     681C 838E 
     681E 208E 
0093 6820 C820  54         mov   @>8390,@>2090
     6822 8390 
     6824 2090 
0094 6826 C820  54         mov   @>8392,@>2092
     6828 8392 
     682A 2092 
0095 682C C820  54         mov   @>8394,@>2094
     682E 8394 
     6830 2094 
0096 6832 C820  54         mov   @>8396,@>2096
     6834 8396 
     6836 2096 
0097 6838 C820  54         mov   @>8398,@>2098
     683A 8398 
     683C 2098 
0098 683E C820  54         mov   @>839A,@>209A
     6840 839A 
     6842 209A 
0099 6844 C820  54         mov   @>839C,@>209C
     6846 839C 
     6848 209C 
0100 684A C820  54         mov   @>839E,@>209E
     684C 839E 
     684E 209E 
0101 6850 C820  54         mov   @>83A0,@>20A0
     6852 83A0 
     6854 20A0 
0102 6856 C820  54         mov   @>83A2,@>20A2
     6858 83A2 
     685A 20A2 
0103 685C C820  54         mov   @>83A4,@>20A4
     685E 83A4 
     6860 20A4 
0104 6862 C820  54         mov   @>83A6,@>20A6
     6864 83A6 
     6866 20A6 
0105 6868 C820  54         mov   @>83A8,@>20A8
     686A 83A8 
     686C 20A8 
0106 686E C820  54         mov   @>83AA,@>20AA
     6870 83AA 
     6872 20AA 
0107 6874 C820  54         mov   @>83AC,@>20AC
     6876 83AC 
     6878 20AC 
0108 687A C820  54         mov   @>83AE,@>20AE
     687C 83AE 
     687E 20AE 
0109 6880 C820  54         mov   @>83B0,@>20B0
     6882 83B0 
     6884 20B0 
0110 6886 C820  54         mov   @>83B2,@>20B2
     6888 83B2 
     688A 20B2 
0111 688C C820  54         mov   @>83B4,@>20B4
     688E 83B4 
     6890 20B4 
0112 6892 C820  54         mov   @>83B6,@>20B6
     6894 83B6 
     6896 20B6 
0113 6898 C820  54         mov   @>83B8,@>20B8
     689A 83B8 
     689C 20B8 
0114 689E C820  54         mov   @>83BA,@>20BA
     68A0 83BA 
     68A2 20BA 
0115 68A4 C820  54         mov   @>83BC,@>20BC
     68A6 83BC 
     68A8 20BC 
0116 68AA C820  54         mov   @>83BE,@>20BE
     68AC 83BE 
     68AE 20BE 
0117 68B0 C820  54         mov   @>83C0,@>20C0
     68B2 83C0 
     68B4 20C0 
0118 68B6 C820  54         mov   @>83C2,@>20C2
     68B8 83C2 
     68BA 20C2 
0119 68BC C820  54         mov   @>83C4,@>20C4
     68BE 83C4 
     68C0 20C4 
0120 68C2 C820  54         mov   @>83C6,@>20C6
     68C4 83C6 
     68C6 20C6 
0121 68C8 C820  54         mov   @>83C8,@>20C8
     68CA 83C8 
     68CC 20C8 
0122 68CE C820  54         mov   @>83CA,@>20CA
     68D0 83CA 
     68D2 20CA 
0123 68D4 C820  54         mov   @>83CC,@>20CC
     68D6 83CC 
     68D8 20CC 
0124 68DA C820  54         mov   @>83CE,@>20CE
     68DC 83CE 
     68DE 20CE 
0125 68E0 C820  54         mov   @>83D0,@>20D0
     68E2 83D0 
     68E4 20D0 
0126 68E6 C820  54         mov   @>83D2,@>20D2
     68E8 83D2 
     68EA 20D2 
0127 68EC C820  54         mov   @>83D4,@>20D4
     68EE 83D4 
     68F0 20D4 
0128 68F2 C820  54         mov   @>83D6,@>20D6
     68F4 83D6 
     68F6 20D6 
0129 68F8 C820  54         mov   @>83D8,@>20D8
     68FA 83D8 
     68FC 20D8 
0130 68FE C820  54         mov   @>83DA,@>20DA
     6900 83DA 
     6902 20DA 
0131 6904 C820  54         mov   @>83DC,@>20DC
     6906 83DC 
     6908 20DC 
0132 690A C820  54         mov   @>83DE,@>20DE
     690C 83DE 
     690E 20DE 
0133 6910 C820  54         mov   @>83E0,@>20E0
     6912 83E0 
     6914 20E0 
0134 6916 C820  54         mov   @>83E2,@>20E2
     6918 83E2 
     691A 20E2 
0135 691C C820  54         mov   @>83E4,@>20E4
     691E 83E4 
     6920 20E4 
0136 6922 C820  54         mov   @>83E6,@>20E6
     6924 83E6 
     6926 20E6 
0137 6928 C820  54         mov   @>83E8,@>20E8
     692A 83E8 
     692C 20E8 
0138 692E C820  54         mov   @>83EA,@>20EA
     6930 83EA 
     6932 20EA 
0139 6934 C820  54         mov   @>83EC,@>20EC
     6936 83EC 
     6938 20EC 
0140 693A C820  54         mov   @>83EE,@>20EE
     693C 83EE 
     693E 20EE 
0141 6940 C820  54         mov   @>83F0,@>20F0
     6942 83F0 
     6944 20F0 
0142 6946 C820  54         mov   @>83F2,@>20F2
     6948 83F2 
     694A 20F2 
0143 694C C820  54         mov   @>83F4,@>20F4
     694E 83F4 
     6950 20F4 
0144 6952 C820  54         mov   @>83F6,@>20F6
     6954 83F6 
     6956 20F6 
0145 6958 C820  54         mov   @>83F8,@>20F8
     695A 83F8 
     695C 20F8 
0146 695E C820  54         mov   @>83FA,@>20FA
     6960 83FA 
     6962 20FA 
0147 6964 C820  54         mov   @>83FC,@>20FC
     6966 83FC 
     6968 20FC 
0148 696A C820  54         mov   @>83FE,@>20FE
     696C 83FE 
     696E 20FE 
0149 6970 045B  20         b     *r11                  ; Return to caller
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
0164 6972 C820  54         mov   @>2000,@>8300
     6974 2000 
     6976 8300 
0165 6978 C820  54         mov   @>2002,@>8302
     697A 2002 
     697C 8302 
0166 697E C820  54         mov   @>2004,@>8304
     6980 2004 
     6982 8304 
0167 6984 C820  54         mov   @>2006,@>8306
     6986 2006 
     6988 8306 
0168 698A C820  54         mov   @>2008,@>8308
     698C 2008 
     698E 8308 
0169 6990 C820  54         mov   @>200A,@>830A
     6992 200A 
     6994 830A 
0170 6996 C820  54         mov   @>200C,@>830C
     6998 200C 
     699A 830C 
0171 699C C820  54         mov   @>200E,@>830E
     699E 200E 
     69A0 830E 
0172 69A2 C820  54         mov   @>2010,@>8310
     69A4 2010 
     69A6 8310 
0173 69A8 C820  54         mov   @>2012,@>8312
     69AA 2012 
     69AC 8312 
0174 69AE C820  54         mov   @>2014,@>8314
     69B0 2014 
     69B2 8314 
0175 69B4 C820  54         mov   @>2016,@>8316
     69B6 2016 
     69B8 8316 
0176 69BA C820  54         mov   @>2018,@>8318
     69BC 2018 
     69BE 8318 
0177 69C0 C820  54         mov   @>201A,@>831A
     69C2 201A 
     69C4 831A 
0178 69C6 C820  54         mov   @>201C,@>831C
     69C8 201C 
     69CA 831C 
0179 69CC C820  54         mov   @>201E,@>831E
     69CE 201E 
     69D0 831E 
0180 69D2 C820  54         mov   @>2020,@>8320
     69D4 2020 
     69D6 8320 
0181 69D8 C820  54         mov   @>2022,@>8322
     69DA 2022 
     69DC 8322 
0182 69DE C820  54         mov   @>2024,@>8324
     69E0 2024 
     69E2 8324 
0183 69E4 C820  54         mov   @>2026,@>8326
     69E6 2026 
     69E8 8326 
0184 69EA C820  54         mov   @>2028,@>8328
     69EC 2028 
     69EE 8328 
0185 69F0 C820  54         mov   @>202A,@>832A
     69F2 202A 
     69F4 832A 
0186 69F6 C820  54         mov   @>202C,@>832C
     69F8 202C 
     69FA 832C 
0187 69FC C820  54         mov   @>202E,@>832E
     69FE 202E 
     6A00 832E 
0188 6A02 C820  54         mov   @>2030,@>8330
     6A04 2030 
     6A06 8330 
0189 6A08 C820  54         mov   @>2032,@>8332
     6A0A 2032 
     6A0C 8332 
0190 6A0E C820  54         mov   @>2034,@>8334
     6A10 2034 
     6A12 8334 
0191 6A14 C820  54         mov   @>2036,@>8336
     6A16 2036 
     6A18 8336 
0192 6A1A C820  54         mov   @>2038,@>8338
     6A1C 2038 
     6A1E 8338 
0193 6A20 C820  54         mov   @>203A,@>833A
     6A22 203A 
     6A24 833A 
0194 6A26 C820  54         mov   @>203C,@>833C
     6A28 203C 
     6A2A 833C 
0195 6A2C C820  54         mov   @>203E,@>833E
     6A2E 203E 
     6A30 833E 
0196 6A32 C820  54         mov   @>2040,@>8340
     6A34 2040 
     6A36 8340 
0197 6A38 C820  54         mov   @>2042,@>8342
     6A3A 2042 
     6A3C 8342 
0198 6A3E C820  54         mov   @>2044,@>8344
     6A40 2044 
     6A42 8344 
0199 6A44 C820  54         mov   @>2046,@>8346
     6A46 2046 
     6A48 8346 
0200 6A4A C820  54         mov   @>2048,@>8348
     6A4C 2048 
     6A4E 8348 
0201 6A50 C820  54         mov   @>204A,@>834A
     6A52 204A 
     6A54 834A 
0202 6A56 C820  54         mov   @>204C,@>834C
     6A58 204C 
     6A5A 834C 
0203 6A5C C820  54         mov   @>204E,@>834E
     6A5E 204E 
     6A60 834E 
0204 6A62 C820  54         mov   @>2050,@>8350
     6A64 2050 
     6A66 8350 
0205 6A68 C820  54         mov   @>2052,@>8352
     6A6A 2052 
     6A6C 8352 
0206 6A6E C820  54         mov   @>2054,@>8354
     6A70 2054 
     6A72 8354 
0207 6A74 C820  54         mov   @>2056,@>8356
     6A76 2056 
     6A78 8356 
0208 6A7A C820  54         mov   @>2058,@>8358
     6A7C 2058 
     6A7E 8358 
0209 6A80 C820  54         mov   @>205A,@>835A
     6A82 205A 
     6A84 835A 
0210 6A86 C820  54         mov   @>205C,@>835C
     6A88 205C 
     6A8A 835C 
0211 6A8C C820  54         mov   @>205E,@>835E
     6A8E 205E 
     6A90 835E 
0212 6A92 C820  54         mov   @>2060,@>8360
     6A94 2060 
     6A96 8360 
0213 6A98 C820  54         mov   @>2062,@>8362
     6A9A 2062 
     6A9C 8362 
0214 6A9E C820  54         mov   @>2064,@>8364
     6AA0 2064 
     6AA2 8364 
0215 6AA4 C820  54         mov   @>2066,@>8366
     6AA6 2066 
     6AA8 8366 
0216 6AAA C820  54         mov   @>2068,@>8368
     6AAC 2068 
     6AAE 8368 
0217 6AB0 C820  54         mov   @>206A,@>836A
     6AB2 206A 
     6AB4 836A 
0218 6AB6 C820  54         mov   @>206C,@>836C
     6AB8 206C 
     6ABA 836C 
0219 6ABC C820  54         mov   @>206E,@>836E
     6ABE 206E 
     6AC0 836E 
0220 6AC2 C820  54         mov   @>2070,@>8370
     6AC4 2070 
     6AC6 8370 
0221 6AC8 C820  54         mov   @>2072,@>8372
     6ACA 2072 
     6ACC 8372 
0222 6ACE C820  54         mov   @>2074,@>8374
     6AD0 2074 
     6AD2 8374 
0223 6AD4 C820  54         mov   @>2076,@>8376
     6AD6 2076 
     6AD8 8376 
0224 6ADA C820  54         mov   @>2078,@>8378
     6ADC 2078 
     6ADE 8378 
0225 6AE0 C820  54         mov   @>207A,@>837A
     6AE2 207A 
     6AE4 837A 
0226 6AE6 C820  54         mov   @>207C,@>837C
     6AE8 207C 
     6AEA 837C 
0227 6AEC C820  54         mov   @>207E,@>837E
     6AEE 207E 
     6AF0 837E 
0228 6AF2 C820  54         mov   @>2080,@>8380
     6AF4 2080 
     6AF6 8380 
0229 6AF8 C820  54         mov   @>2082,@>8382
     6AFA 2082 
     6AFC 8382 
0230 6AFE C820  54         mov   @>2084,@>8384
     6B00 2084 
     6B02 8384 
0231 6B04 C820  54         mov   @>2086,@>8386
     6B06 2086 
     6B08 8386 
0232 6B0A C820  54         mov   @>2088,@>8388
     6B0C 2088 
     6B0E 8388 
0233 6B10 C820  54         mov   @>208A,@>838A
     6B12 208A 
     6B14 838A 
0234 6B16 C820  54         mov   @>208C,@>838C
     6B18 208C 
     6B1A 838C 
0235 6B1C C820  54         mov   @>208E,@>838E
     6B1E 208E 
     6B20 838E 
0236 6B22 C820  54         mov   @>2090,@>8390
     6B24 2090 
     6B26 8390 
0237 6B28 C820  54         mov   @>2092,@>8392
     6B2A 2092 
     6B2C 8392 
0238 6B2E C820  54         mov   @>2094,@>8394
     6B30 2094 
     6B32 8394 
0239 6B34 C820  54         mov   @>2096,@>8396
     6B36 2096 
     6B38 8396 
0240 6B3A C820  54         mov   @>2098,@>8398
     6B3C 2098 
     6B3E 8398 
0241 6B40 C820  54         mov   @>209A,@>839A
     6B42 209A 
     6B44 839A 
0242 6B46 C820  54         mov   @>209C,@>839C
     6B48 209C 
     6B4A 839C 
0243 6B4C C820  54         mov   @>209E,@>839E
     6B4E 209E 
     6B50 839E 
0244 6B52 C820  54         mov   @>20A0,@>83A0
     6B54 20A0 
     6B56 83A0 
0245 6B58 C820  54         mov   @>20A2,@>83A2
     6B5A 20A2 
     6B5C 83A2 
0246 6B5E C820  54         mov   @>20A4,@>83A4
     6B60 20A4 
     6B62 83A4 
0247 6B64 C820  54         mov   @>20A6,@>83A6
     6B66 20A6 
     6B68 83A6 
0248 6B6A C820  54         mov   @>20A8,@>83A8
     6B6C 20A8 
     6B6E 83A8 
0249 6B70 C820  54         mov   @>20AA,@>83AA
     6B72 20AA 
     6B74 83AA 
0250 6B76 C820  54         mov   @>20AC,@>83AC
     6B78 20AC 
     6B7A 83AC 
0251 6B7C C820  54         mov   @>20AE,@>83AE
     6B7E 20AE 
     6B80 83AE 
0252 6B82 C820  54         mov   @>20B0,@>83B0
     6B84 20B0 
     6B86 83B0 
0253 6B88 C820  54         mov   @>20B2,@>83B2
     6B8A 20B2 
     6B8C 83B2 
0254 6B8E C820  54         mov   @>20B4,@>83B4
     6B90 20B4 
     6B92 83B4 
0255 6B94 C820  54         mov   @>20B6,@>83B6
     6B96 20B6 
     6B98 83B6 
0256 6B9A C820  54         mov   @>20B8,@>83B8
     6B9C 20B8 
     6B9E 83B8 
0257 6BA0 C820  54         mov   @>20BA,@>83BA
     6BA2 20BA 
     6BA4 83BA 
0258 6BA6 C820  54         mov   @>20BC,@>83BC
     6BA8 20BC 
     6BAA 83BC 
0259 6BAC C820  54         mov   @>20BE,@>83BE
     6BAE 20BE 
     6BB0 83BE 
0260 6BB2 C820  54         mov   @>20C0,@>83C0
     6BB4 20C0 
     6BB6 83C0 
0261 6BB8 C820  54         mov   @>20C2,@>83C2
     6BBA 20C2 
     6BBC 83C2 
0262 6BBE C820  54         mov   @>20C4,@>83C4
     6BC0 20C4 
     6BC2 83C4 
0263 6BC4 C820  54         mov   @>20C6,@>83C6
     6BC6 20C6 
     6BC8 83C6 
0264 6BCA C820  54         mov   @>20C8,@>83C8
     6BCC 20C8 
     6BCE 83C8 
0265 6BD0 C820  54         mov   @>20CA,@>83CA
     6BD2 20CA 
     6BD4 83CA 
0266 6BD6 C820  54         mov   @>20CC,@>83CC
     6BD8 20CC 
     6BDA 83CC 
0267 6BDC C820  54         mov   @>20CE,@>83CE
     6BDE 20CE 
     6BE0 83CE 
0268 6BE2 C820  54         mov   @>20D0,@>83D0
     6BE4 20D0 
     6BE6 83D0 
0269 6BE8 C820  54         mov   @>20D2,@>83D2
     6BEA 20D2 
     6BEC 83D2 
0270 6BEE C820  54         mov   @>20D4,@>83D4
     6BF0 20D4 
     6BF2 83D4 
0271 6BF4 C820  54         mov   @>20D6,@>83D6
     6BF6 20D6 
     6BF8 83D6 
0272 6BFA C820  54         mov   @>20D8,@>83D8
     6BFC 20D8 
     6BFE 83D8 
0273 6C00 C820  54         mov   @>20DA,@>83DA
     6C02 20DA 
     6C04 83DA 
0274 6C06 C820  54         mov   @>20DC,@>83DC
     6C08 20DC 
     6C0A 83DC 
0275 6C0C C820  54         mov   @>20DE,@>83DE
     6C0E 20DE 
     6C10 83DE 
0276 6C12 C820  54         mov   @>20E0,@>83E0
     6C14 20E0 
     6C16 83E0 
0277 6C18 C820  54         mov   @>20E2,@>83E2
     6C1A 20E2 
     6C1C 83E2 
0278 6C1E C820  54         mov   @>20E4,@>83E4
     6C20 20E4 
     6C22 83E4 
0279 6C24 C820  54         mov   @>20E6,@>83E6
     6C26 20E6 
     6C28 83E6 
0280 6C2A C820  54         mov   @>20E8,@>83E8
     6C2C 20E8 
     6C2E 83E8 
0281 6C30 C820  54         mov   @>20EA,@>83EA
     6C32 20EA 
     6C34 83EA 
0282 6C36 C820  54         mov   @>20EC,@>83EC
     6C38 20EC 
     6C3A 83EC 
0283 6C3C C820  54         mov   @>20EE,@>83EE
     6C3E 20EE 
     6C40 83EE 
0284 6C42 C820  54         mov   @>20F0,@>83F0
     6C44 20F0 
     6C46 83F0 
0285 6C48 C820  54         mov   @>20F2,@>83F2
     6C4A 20F2 
     6C4C 83F2 
0286 6C4E C820  54         mov   @>20F4,@>83F4
     6C50 20F4 
     6C52 83F4 
0287 6C54 C820  54         mov   @>20F6,@>83F6
     6C56 20F6 
     6C58 83F6 
0288 6C5A C820  54         mov   @>20F8,@>83F8
     6C5C 20F8 
     6C5E 83F8 
0289 6C60 C820  54         mov   @>20FA,@>83FA
     6C62 20FA 
     6C64 83FA 
0290 6C66 C820  54         mov   @>20FC,@>83FC
     6C68 20FC 
     6C6A 83FC 
0291 6C6C C820  54         mov   @>20FE,@>83FE
     6C6E 20FE 
     6C70 83FE 
0292 6C72 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0194                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 6C74 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6C76 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6C78 8300 
0030 6C7A C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6C7C 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6C7E 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6C80 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6C82 0606  14         dec   tmp2
0037 6C84 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6C86 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6C88 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6C8A 6C90 
0043                                                   ; R14=PC
0044 6C8C 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6C8E 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6C90 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6C92 6972 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6C94 045B  20         b     *r11                  ; Return to caller
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
0077 6C96 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6C98 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6C9A 8300 
0083 6C9C 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6C9E 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6CA0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6CA2 0606  14         dec   tmp2
0089 6CA4 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6CA6 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6CA8 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6CAA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0196               
0198                       copy  "equ_fio.asm"              ; File I/O equates
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
0199                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
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
0041 6CAC 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6CAE 6CB0             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6CB0 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6CB2 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6CB4 8322 
0049 6CB6 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6CB8 6042 
0050 6CBA C020  34         mov   @>8356,r0             ; get ptr to pab
     6CBC 8356 
0051 6CBE C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6CC0 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6CC2 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6CC4 06C0  14         swpb  r0                    ;
0059 6CC6 D800  38         movb  r0,@vdpa              ; send low byte
     6CC8 8C02 
0060 6CCA 06C0  14         swpb  r0                    ;
0061 6CCC D800  38         movb  r0,@vdpa              ; send high byte
     6CCE 8C02 
0062 6CD0 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6CD2 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6CD4 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6CD6 0704  14         seto  r4                    ; init counter
0070 6CD8 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6CDA 2420 
0071 6CDC 0580  14 !       inc   r0                    ; point to next char of name
0072 6CDE 0584  14         inc   r4                    ; incr char counter
0073 6CE0 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6CE2 0007 
0074 6CE4 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6CE6 80C4  18         c     r4,r3                 ; end of name?
0077 6CE8 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6CEA 06C0  14         swpb  r0                    ;
0082 6CEC D800  38         movb  r0,@vdpa              ; send low byte
     6CEE 8C02 
0083 6CF0 06C0  14         swpb  r0                    ;
0084 6CF2 D800  38         movb  r0,@vdpa              ; send high byte
     6CF4 8C02 
0085 6CF6 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CF8 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6CFA DC81  32         movb  r1,*r2+               ; move into buffer
0092 6CFC 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6CFE 6DC0 
0093 6D00 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6D02 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6D04 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6D06 04E0  34         clr   @>83d0
     6D08 83D0 
0102 6D0A C804  38         mov   r4,@>8354             ; save name length for search
     6D0C 8354 
0103 6D0E 0584  14         inc   r4                    ; adjust for dot
0104 6D10 A804  38         a     r4,@>8356             ; point to position after name
     6D12 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6D14 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6D16 83E0 
0110 6D18 04C1  14         clr   r1                    ; version found of dsr
0111 6D1A 020C  20         li    r12,>0f00             ; init cru addr
     6D1C 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6D1E C30C  18         mov   r12,r12               ; anything to turn off?
0117 6D20 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6D22 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6D24 022C  22         ai    r12,>0100             ; next rom to turn on
     6D26 0100 
0125 6D28 04E0  34         clr   @>83d0                ; clear in case we are done
     6D2A 83D0 
0126 6D2C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D2E 2000 
0127 6D30 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6D32 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6D34 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6D36 1D00  20         sbo   0                     ; turn on rom
0134 6D38 0202  20         li    r2,>4000              ; start at beginning of rom
     6D3A 4000 
0135 6D3C 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6D3E 6DBC 
0136 6D40 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6D42 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6D44 240A 
0146 6D46 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6D48 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6D4A 83D2 
0152 6D4C 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6D4E C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6D50 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6D52 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6D54 83D2 
0161 6D56 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6D58 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6D5A 04C5  14         clr   r5                    ; Remove any old stuff
0167 6D5C D160  34         movb  @>8355,r5             ; get length as counter
     6D5E 8355 
0168 6D60 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6D62 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6D64 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6D66 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6D68 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D6A 2420 
0175 6D6C 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6D6E 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6D70 0605  14         dec   r5                    ; loop until full length checked
0179 6D72 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6D74 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6D76 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6D78 0581  14         inc   r1                    ; next version found
0191 6D7A 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6D7C 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6D7E 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6D80 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6D82 2400 
0200 6D84 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6D86 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6D88 8322 
0202                                                   ; (8 or >a)
0203 6D8A 0281  22         ci    r1,8                  ; was it 8?
     6D8C 0008 
0204 6D8E 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6D90 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6D92 8350 
0206                                                   ; Get error byte from @>8350
0207 6D94 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6D96 06C0  14         swpb  r0                    ;
0215 6D98 D800  38         movb  r0,@vdpa              ; send low byte
     6D9A 8C02 
0216 6D9C 06C0  14         swpb  r0                    ;
0217 6D9E D800  38         movb  r0,@vdpa              ; send high byte
     6DA0 8C02 
0218 6DA2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DA4 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6DA6 09D1  56         srl   r1,13                 ; just keep error bits
0226 6DA8 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6DAA 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6DAC 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6DAE 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6DB0 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6DB2 06C1  14         swpb  r1                    ; put error in hi byte
0239 6DB4 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6DB6 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6DB8 6042 
0241 6DBA 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6DBC AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6DBE 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6DC0 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
**** **** ****     > runlib.asm
0200                       copy  "fio_level2.asm"           ; File I/O level 2 support
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
0043 6DC2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6DC4 C04B  18         mov   r11,r1                ; Save return address
0049 6DC6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6DC8 2428 
0050 6DCA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6DCC 04C5  14         clr   tmp1                  ; io.op.open
0052 6DCE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6DD0 612E 
0053               file.open_init:
0054 6DD2 0220  22         ai    r0,9                  ; Move to file descriptor length
     6DD4 0009 
0055 6DD6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DD8 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6DDA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DDC 6CAC 
0061 6DDE 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6DE0 1029  14         jmp   file.record.pab.details
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
0090 6DE2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6DE4 C04B  18         mov   r11,r1                ; Save return address
0096 6DE6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6DE8 2428 
0097 6DEA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6DEC 0205  20         li    tmp1,io.op.close      ; io.op.close
     6DEE 0001 
0099 6DF0 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6DF2 612E 
0100               file.close_init:
0101 6DF4 0220  22         ai    r0,9                  ; Move to file descriptor length
     6DF6 0009 
0102 6DF8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DFA 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6DFC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DFE 6CAC 
0108 6E00 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6E02 1018  14         jmp   file.record.pab.details
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
0139 6E04 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6E06 C04B  18         mov   r11,r1                ; Save return address
0145 6E08 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6E0A 2428 
0146 6E0C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6E0E 0205  20         li    tmp1,io.op.read       ; io.op.read
     6E10 0002 
0148 6E12 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6E14 612E 
0149               file.record.read_init:
0150 6E16 0220  22         ai    r0,9                  ; Move to file descriptor length
     6E18 0009 
0151 6E1A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6E1C 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6E1E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6E20 6CAC 
0157 6E22 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6E24 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6E26 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6E28 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6E2A 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6E2C 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6E2E 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6E30 1000  14         nop
0191               
0192               
0193               file.status:
0194 6E32 1000  14         nop
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
0211 6E34 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6E36 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6E38 2428 
0219 6E3A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6E3C 0005 
0220 6E3E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6E40 6146 
0221 6E42 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6E44 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6E46 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0202               
0203               
0204               
0205               *//////////////////////////////////////////////////////////////
0206               *                            TIMERS
0207               *//////////////////////////////////////////////////////////////
0208               
0209                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 6E48 0300  24 tmgr    limi  0                     ; No interrupt processing
     6E4A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6E4C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6E4E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6E50 2360  38         coc   @wbit2,r13            ; C flag on ?
     6E52 6042 
0029 6E54 1602  14         jne   tmgr1a                ; No, so move on
0030 6E56 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6E58 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6E5A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6E5C 6046 
0035 6E5E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6E60 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6E62 6036 
0048 6E64 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6E66 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6E68 6034 
0050 6E6A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6E6C 0460  28         b     @kthread              ; Run kernel thread
     6E6E 6EE6 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6E70 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6E72 603A 
0056 6E74 13EB  14         jeq   tmgr1
0057 6E76 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6E78 6038 
0058 6E7A 16E8  14         jne   tmgr1
0059 6E7C C120  34         mov   @wtiusr,tmp0
     6E7E 832E 
0060 6E80 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6E82 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6E84 6EE4 
0065 6E86 C10A  18         mov   r10,tmp0
0066 6E88 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6E8A 00FF 
0067 6E8C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6E8E 6042 
0068 6E90 1303  14         jeq   tmgr5
0069 6E92 0284  22         ci    tmp0,60               ; 1 second reached ?
     6E94 003C 
0070 6E96 1002  14         jmp   tmgr6
0071 6E98 0284  22 tmgr5   ci    tmp0,50
     6E9A 0032 
0072 6E9C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6E9E 1001  14         jmp   tmgr8
0074 6EA0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6EA2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6EA4 832C 
0079 6EA6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6EA8 FF00 
0080 6EAA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6EAC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6EAE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6EB0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6EB2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6EB4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6EB6 830C 
     6EB8 830D 
0089 6EBA 1608  14         jne   tmgr10                ; No, get next slot
0090 6EBC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6EBE FF00 
0091 6EC0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6EC2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6EC4 8330 
0096 6EC6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6EC8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6ECA 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6ECC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6ECE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6ED0 8315 
     6ED2 8314 
0103 6ED4 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6ED6 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6ED8 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6EDA 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6EDC 10F7  14         jmp   tmgr10                ; Process next slot
0108 6EDE 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6EE0 FF00 
0109 6EE2 10B4  14         jmp   tmgr1
0110 6EE4 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0210                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 6EE6 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6EE8 6036 
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
0041 6EEA 06A0  32         bl    @realkb               ; Scan full keyboard
     6EEC 6490 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6EEE 0460  28         b     @tmgr3                ; Exit
     6EF0 6E70 
**** **** ****     > runlib.asm
0211                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 6EF2 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6EF4 832E 
0018 6EF6 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6EF8 6038 
0019 6EFA 045B  20 mkhoo1  b     *r11                  ; Return
0020      6E4C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6EFC 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6EFE 832E 
0029 6F00 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6F02 FEFF 
0030 6F04 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0212               
0214                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 6F06 C13B  30 mkslot  mov   *r11+,tmp0
0018 6F08 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6F0A C184  18         mov   tmp0,tmp2
0023 6F0C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6F0E A1A0  34         a     @wtitab,tmp2          ; Add table base
     6F10 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6F12 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6F14 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6F16 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6F18 881B  46         c     *r11,@w$ffff          ; End of list ?
     6F1A 6048 
0035 6F1C 1301  14         jeq   mkslo1                ; Yes, exit
0036 6F1E 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6F20 05CB  14 mkslo1  inct  r11
0041 6F22 045B  20         b     *r11                  ; Exit
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
0052 6F24 C13B  30 clslot  mov   *r11+,tmp0
0053 6F26 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6F28 A120  34         a     @wtitab,tmp0          ; Add table base
     6F2A 832C 
0055 6F2C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6F2E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6F30 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0216               
0217               
0218               
0219               *//////////////////////////////////////////////////////////////
0220               *                    RUNLIB INITIALISATION
0221               *//////////////////////////////////////////////////////////////
0222               
0223               ***************************************************************
0224               *  RUNLIB - Runtime library initalisation
0225               ***************************************************************
0226               *  B  @RUNLIB
0227               *--------------------------------------------------------------
0228               *  REMARKS
0229               *  if R0 in WS1 equals >4a4a we were called from the system
0230               *  crash handler so we return there after initialisation.
0231               
0232               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0233               *  after clearing scratchpad memory. This has higher priority
0234               *  as crash handler flag R0.
0235               ********@*****@*********************@**************************
0237 6F32 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     6F34 6670 
0238 6F36 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6F38 8302 
0242               *--------------------------------------------------------------
0243               * Alternative entry point
0244               *--------------------------------------------------------------
0245 6F3A 0300  24 runli1  limi  0                     ; Turn off interrupts
     6F3C 0000 
0246 6F3E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6F40 8300 
0247 6F42 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6F44 83C0 
0248               *--------------------------------------------------------------
0249               * Clear scratch-pad memory from R4 upwards
0250               *--------------------------------------------------------------
0251 6F46 0202  20 runli2  li    r2,>8308
     6F48 8308 
0252 6F4A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0253 6F4C 0282  22         ci    r2,>8400
     6F4E 8400 
0254 6F50 16FC  14         jne   runli3
0255               *--------------------------------------------------------------
0256               * Exit to TI-99/4A title screen ?
0257               *--------------------------------------------------------------
0258               runli3a
0259 6F52 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6F54 FFFF 
0260 6F56 1602  14         jne   runli4                ; No, continue
0261 6F58 0420  54         blwp  @0                    ; Yes, bye bye
     6F5A 0000 
0262               *--------------------------------------------------------------
0263               * Determine if VDP is PAL or NTSC
0264               *--------------------------------------------------------------
0265 6F5C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6F5E 833C 
0266 6F60 04C1  14         clr   r1                    ; Reset counter
0267 6F62 0202  20         li    r2,10                 ; We test 10 times
     6F64 000A 
0268 6F66 C0E0  34 runli5  mov   @vdps,r3
     6F68 8802 
0269 6F6A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6F6C 6046 
0270 6F6E 1302  14         jeq   runli6
0271 6F70 0581  14         inc   r1                    ; Increase counter
0272 6F72 10F9  14         jmp   runli5
0273 6F74 0602  14 runli6  dec   r2                    ; Next test
0274 6F76 16F7  14         jne   runli5
0275 6F78 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6F7A 1250 
0276 6F7C 1202  14         jle   runli7                ; No, so it must be NTSC
0277 6F7E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6F80 6042 
0278               *--------------------------------------------------------------
0279               * Copy machine code to scratchpad (prepare tight loop)
0280               *--------------------------------------------------------------
0281 6F82 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6F84 60B6 
0282 6F86 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6F88 8322 
0283 6F8A CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0284 6F8C CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0285 6F8E CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0286               *--------------------------------------------------------------
0287               * Initialize registers, memory, ...
0288               *--------------------------------------------------------------
0289 6F90 04C1  14 runli9  clr   r1
0290 6F92 04C2  14         clr   r2
0291 6F94 04C3  14         clr   r3
0292 6F96 0209  20         li    stack,>8400           ; Set stack
     6F98 8400 
0293 6F9A 020F  20         li    r15,vdpw              ; Set VDP write address
     6F9C 8C00 
0297               *--------------------------------------------------------------
0298               * Setup video memory
0299               *--------------------------------------------------------------
0301 6F9E 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6FA0 4A4A 
0302 6FA2 1605  14         jne   runlia
0303 6FA4 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6FA6 60F0 
0304 6FA8 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6FAA 0000 
     6FAC 3FFF 
0309 6FAE 06A0  32 runlia  bl    @filv
     6FB0 60F0 
0310 6FB2 0FC0             data  pctadr,spfclr,16      ; Load color table
     6FB4 00F4 
     6FB6 0010 
0311               *--------------------------------------------------------------
0312               * Check if there is a F18A present
0313               *--------------------------------------------------------------
0317 6FB8 06A0  32         bl    @f18unl               ; Unlock the F18A
     6FBA 63D8 
0318 6FBC 06A0  32         bl    @f18chk               ; Check if F18A is there
     6FBE 63F2 
0319 6FC0 06A0  32         bl    @f18lck               ; Lock the F18A again
     6FC2 63E8 
0321               *--------------------------------------------------------------
0322               * Check if there is a speech synthesizer attached
0323               *--------------------------------------------------------------
0325               *       <<skipped>>
0329               *--------------------------------------------------------------
0330               * Load video mode table & font
0331               *--------------------------------------------------------------
0332 6FC4 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6FC6 615A 
0333 6FC8 60AC             data  spvmod                ; Equate selected video mode table
0334 6FCA 0204  20         li    tmp0,spfont           ; Get font option
     6FCC 000C 
0335 6FCE 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0336 6FD0 1304  14         jeq   runlid                ; Yes, skip it
0337 6FD2 06A0  32         bl    @ldfnt
     6FD4 61C2 
0338 6FD6 1100             data  fntadr,spfont         ; Load specified font
     6FD8 000C 
0339               *--------------------------------------------------------------
0340               * Did a system crash occur before runlib was called?
0341               *--------------------------------------------------------------
0342 6FDA 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6FDC 4A4A 
0343 6FDE 1602  14         jne   runlie                ; No, continue
0344 6FE0 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     6FE2 605C 
0345               *--------------------------------------------------------------
0346               * Branch to main program
0347               *--------------------------------------------------------------
0348 6FE4 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6FE6 0040 
0349 6FE8 0460  28         b     @main                 ; Give control to main program
     6FEA 6FEC 
**** **** ****     > tivi.asm.28024
0209               
0210               *--------------------------------------------------------------
0211               * Video mode configuration
0212               *--------------------------------------------------------------
0213      60AC     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0214      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0215      0050     colrow  equ   80                    ; Columns per row
0216      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0217      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0218      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0219      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0220               
0221               
0222               ***************************************************************
0223               * Main
0224               ********@*****@*********************@**************************
0225 6FEC 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6FEE 6044 
0226 6FF0 1302  14         jeq   main.continue
0227 6FF2 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6FF4 0000 
0228               
0229               main.continue:
0230 6FF6 06A0  32         bl    @scroff               ; Turn screen off
     6FF8 6334 
0231 6FFA 06A0  32         bl    @f18unl               ; Unlock the F18a
     6FFC 63D8 
0232 6FFE 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     7000 6194 
0233 7002 3140                   data >3140            ; F18a VR49 (>31), bit 40
0234                       ;------------------------------------------------------
0235                       ; Initialize VDP SIT
0236                       ;------------------------------------------------------
0237 7004 06A0  32         bl    @filv
     7006 60F0 
0238 7008 0000                   data >0000,32,31*80   ; Clear VDP SIT
     700A 0020 
     700C 09B0 
0239 700E 06A0  32         bl    @scron                ; Turn screen on
     7010 633C 
0240                       ;------------------------------------------------------
0241                       ; Initialize low + high memory expansion
0242                       ;------------------------------------------------------
0243 7012 06A0  32         bl    @film
     7014 60CC 
0244 7016 2200                   data >2200,00,8*1024-256*2
     7018 0000 
     701A 3E00 
0245                                                   ; Clear part of 8k low-memory
0246               
0247 701C 06A0  32         bl    @film
     701E 60CC 
0248 7020 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     7022 0000 
     7024 6000 
0249                       ;------------------------------------------------------
0250                       ; Setup cursor, screen, etc.
0251                       ;------------------------------------------------------
0252 7026 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     7028 6354 
0253 702A 06A0  32         bl    @s8x8                 ; Small sprite
     702C 6364 
0254               
0255 702E 06A0  32         bl    @cpym2m
     7030 62E2 
0256 7032 7C5E                   data romsat,ramsat,4  ; Load sprite SAT
     7034 8380 
     7036 0004 
0257               
0258 7038 C820  54         mov   @romsat+2,@fb.curshape
     703A 7C60 
     703C 2210 
0259                                                   ; Save cursor shape & color
0260               
0261 703E 06A0  32         bl    @cpym2v
     7040 629A 
0262 7042 1800                   data sprpdt,cursors,3*8
     7044 7C62 
     7046 0018 
0263                                                   ; Load sprite cursor patterns
0264               *--------------------------------------------------------------
0265               * Initialize
0266               *--------------------------------------------------------------
0267 7048 06A0  32         bl    @edb.init             ; Initialize editor buffer
     704A 7962 
0268 704C 06A0  32         bl    @idx.init             ; Initialize index
     704E 7882 
0269 7050 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7052 77A6 
0270               
0271                       ;-------------------------------------------------------
0272                       ; Setup editor tasks & hook
0273                       ;-------------------------------------------------------
0274 7054 0204  20         li    tmp0,>0200
     7056 0200 
0275 7058 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     705A 8314 
0276               
0277 705C 06A0  32         bl    @at
     705E 6374 
0278 7060 0000             data  >0000                 ; Cursor YX position = >0000
0279               
0280 7062 0204  20         li    tmp0,timers
     7064 8370 
0281 7066 C804  38         mov   tmp0,@wtitab
     7068 832C 
0282               
0283 706A 06A0  32         bl    @mkslot
     706C 6F06 
0284 706E 0001                   data >0001,task0      ; Task 0 - Update screen
     7070 7632 
0285 7072 0101                   data >0101,task1      ; Task 1 - Update cursor position
     7074 76B6 
0286 7076 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     7078 76C4 
     707A FFFF 
0287               
0288 707C 06A0  32         bl    @mkhook
     707E 6EF2 
0289 7080 7086                   data editor           ; Setup user hook
0290               
0291 7082 0460  28         b     @tmgr                 ; Start timers and kthread
     7084 6E48 
0292               
0293               
0294               ****************************************************************
0295               * Editor - Main loop
0296               ****************************************************************
0297 7086 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7088 6030 
0298 708A 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0299               *---------------------------------------------------------------
0300               * Identical key pressed ?
0301               *---------------------------------------------------------------
0302 708C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     708E 6030 
0303 7090 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7092 833C 
     7094 833E 
0304 7096 1308  14         jeq   ed_wait
0305               *--------------------------------------------------------------
0306               * New key pressed
0307               *--------------------------------------------------------------
0308               ed_new_key
0309 7098 C820  54         mov   @waux1,@waux2         ; Save as previous key
     709A 833C 
     709C 833E 
0310 709E 1045  14         jmp   edkey                 ; Process key
0311               *--------------------------------------------------------------
0312               * Clear keyboard buffer if no key pressed
0313               *--------------------------------------------------------------
0314               ed_clear_kbbuffer
0315 70A0 04E0  34         clr   @waux1
     70A2 833C 
0316 70A4 04E0  34         clr   @waux2
     70A6 833E 
0317               *--------------------------------------------------------------
0318               * Delay to avoid key bouncing
0319               *--------------------------------------------------------------
0320               ed_wait
0321 70A8 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     70AA 0708 
0322                       ;------------------------------------------------------
0323                       ; Delay loop
0324                       ;------------------------------------------------------
0325               ed_wait_loop
0326 70AC 0604  14         dec   tmp0
0327 70AE 16FE  14         jne   ed_wait_loop
0328               *--------------------------------------------------------------
0329               * Exit
0330               *--------------------------------------------------------------
0331 70B0 0460  28 ed_exit b     @hookok               ; Return
     70B2 6E4C 
0332               
0333               
0334               
0335               
0336               
0337               
0338               ***************************************************************
0339               *                Tivi - Editor keyboard actions
0340               ***************************************************************
0341                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 70B4 0D00             data  key_enter,edkey.action.enter          ; New line
     70B6 7504 
0056 70B8 0800             data  key_left,edkey.action.left            ; Move cursor left
     70BA 714C 
0057 70BC 0900             data  key_right,edkey.action.right          ; Move cursor right
     70BE 7162 
0058 70C0 0B00             data  key_up,edkey.action.up                ; Move cursor up
     70C2 717A 
0059 70C4 0A00             data  key_down,edkey.action.down            ; Move cursor down
     70C6 71CC 
0060 70C8 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     70CA 7238 
0061 70CC 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     70CE 7250 
0062 70D0 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     70D2 7264 
0063 70D4 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     70D6 72B6 
0064 70D8 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     70DA 7316 
0065 70DC 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     70DE 7360 
0066 70E0 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     70E2 738C 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 70E4 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     70E6 73BA 
0071 70E8 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     70EA 73EE 
0072 70EC 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     70EE 741E 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 70F0 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     70F2 7472 
0077 70F4 B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     70F6 756E 
0078 70F8 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     70FA 74C4 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 70FC 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     70FE 75BA 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 7100 B000             data  key_buf0,edkey.action.buffer0
     7102 75F6 
0087 7104 B100             data  key_buf1,edkey.action.buffer1
     7106 75FC 
0088 7108 B200             data  key_buf2,edkey.action.buffer2
     710A 7602 
0089 710C B300             data  key_buf3,edkey.action.buffer3
     710E 7608 
0090 7110 B400             data  key_buf4,edkey.action.buffer4
     7112 760E 
0091 7114 B500             data  key_buf5,edkey.action.buffer5
     7116 7614 
0092 7118 B600             data  key_buf6,edkey.action.buffer6
     711A 761A 
0093 711C B700             data  key_buf7,edkey.action.buffer7
     711E 7620 
0094 7120 9E00             data  key_buf8,edkey.action.buffer8
     7122 7626 
0095 7124 9F00             data  key_buf9,edkey.action.buffer9
     7126 762C 
0096 7128 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 712A C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     712C 833C 
0104 712E 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     7130 FF00 
0105               
0106 7132 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     7134 70B4 
0107 7136 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 7138 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 713A 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 713C 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 713E 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 7140 05C6  14         inct  tmp2                  ; No, skip action
0118 7142 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 7144 C196  26         mov  *tmp2,tmp2             ; Get action address
0122 7146 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 7148 0460  28         b    @edkey.action.char     ; Add character to buffer
     714A 757E 
**** **** ****     > tivi.asm.28024
0342                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 714C C120  34         mov   @fb.column,tmp0
     714E 220C 
0010 7150 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 7152 0620  34         dec   @fb.column            ; Column-- in screen buffer
     7154 220C 
0015 7156 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7158 832A 
0016 715A 0620  34         dec   @fb.current
     715C 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 715E 0460  28 !       b     @ed_wait              ; Back to editor main
     7160 70A8 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 7162 8820  54         c     @fb.column,@fb.row.length
     7164 220C 
     7166 2208 
0028 7168 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 716A 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     716C 220C 
0033 716E 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7170 832A 
0034 7172 05A0  34         inc   @fb.current
     7174 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 7176 0460  28 !       b     @ed_wait              ; Back to editor main
     7178 70A8 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 717A 8820  54         c     @fb.row.dirty,@w$ffff
     717C 220A 
     717E 6048 
0049 7180 1604  14         jne   edkey.action.up.cursor
0050 7182 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7184 797E 
0051 7186 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7188 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 718A C120  34         mov   @fb.row,tmp0
     718C 2206 
0057 718E 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 7190 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     7192 2204 
0060 7194 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 7196 0604  14         dec   tmp0                  ; fb.topline--
0066 7198 C804  38         mov   tmp0,@parm1
     719A 8350 
0067 719C 06A0  32         bl    @fb.refresh           ; Scroll one line up
     719E 7810 
0068 71A0 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 71A2 0620  34         dec   @fb.row               ; Row-- in screen buffer
     71A4 2206 
0074 71A6 06A0  32         bl    @up                   ; Row-- VDP cursor
     71A8 6382 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 71AA 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     71AC 7AB2 
0080 71AE 8820  54         c     @fb.column,@fb.row.length
     71B0 220C 
     71B2 2208 
0081 71B4 1207  14         jle   edkey.action.up.$$
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 71B6 C820  54         mov   @fb.row.length,@fb.column
     71B8 2208 
     71BA 220C 
0086 71BC C120  34         mov   @fb.column,tmp0
     71BE 220C 
0087 71C0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     71C2 638C 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.$$:
0092 71C4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71C6 77F4 
0093 71C8 0460  28         b     @ed_wait              ; Back to editor main
     71CA 70A8 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 71CC 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     71CE 2206 
     71D0 2304 
0102 71D2 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 71D4 8820  54         c     @fb.row.dirty,@w$ffff
     71D6 220A 
     71D8 6048 
0107 71DA 1604  14         jne   edkey.action.down.move
0108 71DC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     71DE 797E 
0109 71E0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     71E2 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 71E4 C120  34         mov   @fb.topline,tmp0
     71E6 2204 
0118 71E8 A120  34         a     @fb.row,tmp0
     71EA 2206 
0119 71EC 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     71EE 2304 
0120 71F0 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 71F2 C120  34         mov   @fb.screenrows,tmp0
     71F4 2218 
0126 71F6 0604  14         dec   tmp0
0127 71F8 8120  34         c     @fb.row,tmp0
     71FA 2206 
0128 71FC 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 71FE C820  54         mov   @fb.topline,@parm1
     7200 2204 
     7202 8350 
0133 7204 05A0  34         inc   @parm1
     7206 8350 
0134 7208 06A0  32         bl    @fb.refresh
     720A 7810 
0135 720C 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 720E 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7210 2206 
0141 7212 06A0  32         bl    @down                 ; Row++ VDP cursor
     7214 637A 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 7216 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7218 7AB2 
0147 721A 8820  54         c     @fb.column,@fb.row.length
     721C 220C 
     721E 2208 
0148 7220 1207  14         jle   edkey.action.down.$$  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 7222 C820  54         mov   @fb.row.length,@fb.column
     7224 2208 
     7226 220C 
0153 7228 C120  34         mov   @fb.column,tmp0
     722A 220C 
0154 722C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     722E 638C 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.$$:
0159 7230 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7232 77F4 
0160 7234 0460  28 !       b     @ed_wait              ; Back to editor main
     7236 70A8 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 7238 C120  34         mov   @wyx,tmp0
     723A 832A 
0169 723C 0244  22         andi  tmp0,>ff00
     723E FF00 
0170 7240 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     7242 832A 
0171 7244 04E0  34         clr   @fb.column
     7246 220C 
0172 7248 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     724A 77F4 
0173 724C 0460  28         b     @ed_wait              ; Back to editor main
     724E 70A8 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 7250 C120  34         mov   @fb.row.length,tmp0
     7252 2208 
0180 7254 C804  38         mov   tmp0,@fb.column
     7256 220C 
0181 7258 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     725A 638C 
0182 725C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     725E 77F4 
0183 7260 0460  28         b     @ed_wait              ; Back to editor main
     7262 70A8 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 7264 C120  34         mov   @fb.column,tmp0
     7266 220C 
0192 7268 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 726A C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     726C 2202 
0197 726E 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 7270 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 7272 0605  14         dec   tmp1
0204 7274 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 7276 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 7278 D195  26         movb  *tmp1,tmp2            ; Get character
0212 727A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 727C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 727E 0986  56         srl   tmp2,8                ; Right justify
0215 7280 0286  22         ci    tmp2,32               ; Space character found?
     7282 0020 
0216 7284 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 7286 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7288 2020 
0222 728A 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 728C 0287  22         ci    tmp3,>20ff            ; First character is space
     728E 20FF 
0225 7290 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 7292 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     7294 220C 
0230 7296 61C4  18         s     tmp0,tmp3
0231 7298 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     729A 0002 
0232 729C 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 729E 0585  14         inc   tmp1
0238 72A0 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 72A2 C805  38         mov   tmp1,@fb.current
     72A4 2202 
0244 72A6 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     72A8 220C 
0245 72AA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     72AC 638C 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.$$:
0250 72AE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72B0 77F4 
0251 72B2 0460  28 !       b     @ed_wait              ; Back to editor main
     72B4 70A8 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 72B6 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 72B8 C120  34         mov   @fb.column,tmp0
     72BA 220C 
0261 72BC 8804  38         c     tmp0,@fb.row.length
     72BE 2208 
0262 72C0 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 72C2 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     72C4 2202 
0267 72C6 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 72C8 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 72CA 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 72CC 0585  14         inc   tmp1
0279 72CE 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 72D0 8804  38         c     tmp0,@fb.row.length
     72D2 2208 
0281 72D4 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 72D6 D195  26         movb  *tmp1,tmp2            ; Get character
0288 72D8 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 72DA D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 72DC 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 72DE 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     72E0 FFFF 
0293 72E2 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 72E4 0286  22         ci    tmp2,32
     72E6 0020 
0299 72E8 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 72EA 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 72EC 0286  22         ci    tmp2,32               ; Space character found?
     72EE 0020 
0307 72F0 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 72F2 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     72F4 2020 
0313 72F6 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 72F8 0287  22         ci    tmp3,>20ff            ; First characer is space?
     72FA 20FF 
0316 72FC 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 72FE 0585  14         inc   tmp1
0321 7300 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 7302 C805  38         mov   tmp1,@fb.current
     7304 2202 
0327 7306 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7308 220C 
0328 730A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     730C 638C 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.$$:
0333 730E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7310 77F4 
0334 7312 0460  28 !       b     @ed_wait              ; Back to editor main
     7314 70A8 
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
0346 7316 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     7318 2204 
0347 731A 1316  14         jeq   edkey.action.ppage.$$
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 731C 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     731E 2218 
0352 7320 1503  14         jgt   edkey.action.ppage.topline
0353 7322 04E0  34         clr   @fb.topline           ; topline = 0
     7324 2204 
0354 7326 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 7328 6820  54         s     @fb.screenrows,@fb.topline
     732A 2218 
     732C 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 732E 8820  54         c     @fb.row.dirty,@w$ffff
     7330 220A 
     7332 6048 
0365 7334 1604  14         jne   edkey.action.ppage.refresh
0366 7336 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7338 797E 
0367 733A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     733C 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 733E C820  54         mov   @fb.topline,@parm1
     7340 2204 
     7342 8350 
0373 7344 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7346 7810 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.$$:
0378 7348 04E0  34         clr   @fb.row
     734A 2206 
0379 734C 05A0  34         inc   @fb.row               ; Set fb.row=1
     734E 2206 
0380 7350 04E0  34         clr   @fb.column
     7352 220C 
0381 7354 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7356 0100 
0382 7358 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     735A 832A 
0383 735C 0460  28         b     @edkey.action.up      ; Do rest of logic
     735E 717A 
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
0394 7360 C120  34         mov   @fb.topline,tmp0
     7362 2204 
0395 7364 A120  34         a     @fb.screenrows,tmp0
     7366 2218 
0396 7368 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     736A 2304 
0397 736C 150D  14         jgt   edkey.action.npage.$$
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 736E A820  54         a     @fb.screenrows,@fb.topline
     7370 2218 
     7372 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 7374 8820  54         c     @fb.row.dirty,@w$ffff
     7376 220A 
     7378 6048 
0408 737A 1604  14         jne   edkey.action.npage.refresh
0409 737C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     737E 797E 
0410 7380 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7382 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 7384 0460  28         b     @edkey.action.ppage.refresh
     7386 733E 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.$$:
0421 7388 0460  28         b     @ed_wait              ; Back to editor main
     738A 70A8 
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
0433 738C 8820  54         c     @fb.row.dirty,@w$ffff
     738E 220A 
     7390 6048 
0434 7392 1604  14         jne   edkey.action.top.refresh
0435 7394 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7396 797E 
0436 7398 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     739A 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 739C 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     739E 2204 
0442 73A0 04E0  34         clr   @parm1
     73A2 8350 
0443 73A4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     73A6 7810 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.$$:
0448 73A8 04E0  34         clr   @fb.row               ; Editor line 0
     73AA 2206 
0449 73AC 04E0  34         clr   @fb.column            ; Editor column 0
     73AE 220C 
0450 73B0 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 73B2 C804  38         mov   tmp0,@wyx             ;
     73B4 832A 
0452 73B6 0460  28         b     @ed_wait              ; Back to editor main
     73B8 70A8 
**** **** ****     > tivi.asm.28024
0343                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 73BA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73BC 77F4 
0010                       ;-------------------------------------------------------
0011                       ; Sanity check 1
0012                       ;-------------------------------------------------------
0013 73BE C120  34         mov   @fb.current,tmp0      ; Get pointer
     73C0 2202 
0014 73C2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     73C4 2208 
0015 73C6 1311  14         jeq   edkey.action.del_char.$$
0016                                                   ; Exit if empty line
0017                       ;-------------------------------------------------------
0018                       ; Sanity check 2
0019                       ;-------------------------------------------------------
0020 73C8 8820  54         c     @fb.column,@fb.row.length
     73CA 220C 
     73CC 2208 
0021 73CE 130D  14         jeq   edkey.action.del_char.$$
0022                                                   ; Exit if at EOL
0023                       ;-------------------------------------------------------
0024                       ; Prepare for delete operation
0025                       ;-------------------------------------------------------
0026 73D0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     73D2 2202 
0027 73D4 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0028 73D6 0585  14         inc   tmp1
0029                       ;-------------------------------------------------------
0030                       ; Loop until end of line
0031                       ;-------------------------------------------------------
0032               edkey.action.del_char_loop:
0033 73D8 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0034 73DA 0606  14         dec   tmp2
0035 73DC 16FD  14         jne   edkey.action.del_char_loop
0036                       ;-------------------------------------------------------
0037                       ; Save variables
0038                       ;-------------------------------------------------------
0039 73DE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     73E0 220A 
0040 73E2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     73E4 2216 
0041 73E6 0620  34         dec   @fb.row.length        ; @fb.row.length--
     73E8 2208 
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               edkey.action.del_char.$$:
0046 73EA 0460  28         b     @ed_wait              ; Back to editor main
     73EC 70A8 
0047               
0048               
0049               *---------------------------------------------------------------
0050               * Delete until end of line
0051               *---------------------------------------------------------------
0052               edkey.action.del_eol:
0053 73EE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73F0 77F4 
0054 73F2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     73F4 2208 
0055 73F6 1311  14         jeq   edkey.action.del_eol.$$
0056                                                   ; Exit if empty line
0057                       ;-------------------------------------------------------
0058                       ; Prepare for erase operation
0059                       ;-------------------------------------------------------
0060 73F8 C120  34         mov   @fb.current,tmp0      ; Get pointer
     73FA 2202 
0061 73FC C1A0  34         mov   @fb.colsline,tmp2
     73FE 220E 
0062 7400 61A0  34         s     @fb.column,tmp2
     7402 220C 
0063 7404 04C5  14         clr   tmp1
0064                       ;-------------------------------------------------------
0065                       ; Loop until last column in frame buffer
0066                       ;-------------------------------------------------------
0067               edkey.action.del_eol_loop:
0068 7406 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0069 7408 0606  14         dec   tmp2
0070 740A 16FD  14         jne   edkey.action.del_eol_loop
0071                       ;-------------------------------------------------------
0072                       ; Save variables
0073                       ;-------------------------------------------------------
0074 740C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     740E 220A 
0075 7410 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7412 2216 
0076               
0077 7414 C820  54         mov   @fb.column,@fb.row.length
     7416 220C 
     7418 2208 
0078                                                   ; Set new row length
0079                       ;-------------------------------------------------------
0080                       ; Exit
0081                       ;-------------------------------------------------------
0082               edkey.action.del_eol.$$:
0083 741A 0460  28         b     @ed_wait              ; Back to editor main
     741C 70A8 
0084               
0085               
0086               *---------------------------------------------------------------
0087               * Delete current line
0088               *---------------------------------------------------------------
0089               edkey.action.del_line:
0090                       ;-------------------------------------------------------
0091                       ; Special treatment if only 1 line in file
0092                       ;-------------------------------------------------------
0093 741E C120  34         mov   @edb.lines,tmp0
     7420 2304 
0094 7422 1604  14         jne   !
0095 7424 04E0  34         clr   @fb.column            ; Column 0
     7426 220C 
0096 7428 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     742A 73EE 
0097                       ;-------------------------------------------------------
0098                       ; Delete entry in index
0099                       ;-------------------------------------------------------
0100 742C 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     742E 77F4 
0101 7430 04E0  34         clr   @fb.row.dirty         ; Discard current line
     7432 220A 
0102 7434 C820  54         mov   @fb.topline,@parm1
     7436 2204 
     7438 8350 
0103 743A A820  54         a     @fb.row,@parm1        ; Line number to remove
     743C 2206 
     743E 8350 
0104 7440 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7442 2304 
     7444 8352 
0105 7446 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     7448 78BC 
0106 744A 0620  34         dec   @edb.lines            ; One line less in editor buffer
     744C 2304 
0107                       ;-------------------------------------------------------
0108                       ; Refresh frame buffer and physical screen
0109                       ;-------------------------------------------------------
0110 744E C820  54         mov   @fb.topline,@parm1
     7450 2204 
     7452 8350 
0111 7454 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7456 7810 
0112 7458 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     745A 2216 
0113                       ;-------------------------------------------------------
0114                       ; Special treatment if current line was last line
0115                       ;-------------------------------------------------------
0116 745C C120  34         mov   @fb.topline,tmp0
     745E 2204 
0117 7460 A120  34         a     @fb.row,tmp0
     7462 2206 
0118 7464 8804  38         c     tmp0,@edb.lines       ; Was last line?
     7466 2304 
0119 7468 1202  14         jle   edkey.action.del_line.$$
0120 746A 0460  28         b     @edkey.action.up      ; One line up
     746C 717A 
0121                       ;-------------------------------------------------------
0122                       ; Exit
0123                       ;-------------------------------------------------------
0124               edkey.action.del_line.$$:
0125 746E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7470 7238 
0126               
0127               
0128               
0129               *---------------------------------------------------------------
0130               * Insert character
0131               *
0132               * @parm1 = high byte has character to insert
0133               *---------------------------------------------------------------
0134               edkey.action.ins_char.ws
0135 7472 0204  20         li    tmp0,>2000            ; White space
     7474 2000 
0136 7476 C804  38         mov   tmp0,@parm1
     7478 8350 
0137               edkey.action.ins_char:
0138 747A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     747C 77F4 
0139                       ;-------------------------------------------------------
0140                       ; Sanity check 1 - Empty line
0141                       ;-------------------------------------------------------
0142 747E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7480 2202 
0143 7482 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7484 2208 
0144 7486 131A  14         jeq   edkey.action.ins_char.sanity
0145                                                   ; Add character in overwrite mode
0146                       ;-------------------------------------------------------
0147                       ; Sanity check 2 - EOL
0148                       ;-------------------------------------------------------
0149 7488 8820  54         c     @fb.column,@fb.row.length
     748A 220C 
     748C 2208 
0150 748E 1316  14         jeq   edkey.action.ins_char.sanity
0151                                                   ; Add character in overwrite mode
0152                       ;-------------------------------------------------------
0153                       ; Prepare for insert operation
0154                       ;-------------------------------------------------------
0155               edkey.action.skipsanity:
0156 7490 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0157 7492 61E0  34         s     @fb.column,tmp3
     7494 220C 
0158 7496 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0159 7498 C144  18         mov   tmp0,tmp1
0160 749A 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0161 749C 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     749E 220C 
0162 74A0 0586  14         inc   tmp2
0163                       ;-------------------------------------------------------
0164                       ; Loop from end of line until current character
0165                       ;-------------------------------------------------------
0166               edkey.action.ins_char_loop:
0167 74A2 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0168 74A4 0604  14         dec   tmp0
0169 74A6 0605  14         dec   tmp1
0170 74A8 0606  14         dec   tmp2
0171 74AA 16FB  14         jne   edkey.action.ins_char_loop
0172                       ;-------------------------------------------------------
0173                       ; Set specified character on current position
0174                       ;-------------------------------------------------------
0175 74AC D560  46         movb  @parm1,*tmp1
     74AE 8350 
0176                       ;-------------------------------------------------------
0177                       ; Save variables
0178                       ;-------------------------------------------------------
0179 74B0 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     74B2 220A 
0180 74B4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     74B6 2216 
0181 74B8 05A0  34         inc   @fb.row.length        ; @fb.row.length
     74BA 2208 
0182                       ;-------------------------------------------------------
0183                       ; Add character in overwrite mode
0184                       ;-------------------------------------------------------
0185               edkey.action.ins_char.sanity
0186 74BC 0460  28         b     @edkey.action.char.overwrite
     74BE 758C 
0187                       ;-------------------------------------------------------
0188                       ; Exit
0189                       ;-------------------------------------------------------
0190               edkey.action.ins_char.$$:
0191 74C0 0460  28         b     @ed_wait              ; Back to editor main
     74C2 70A8 
0192               
0193               
0194               
0195               
0196               
0197               
0198               *---------------------------------------------------------------
0199               * Insert new line
0200               *---------------------------------------------------------------
0201               edkey.action.ins_line:
0202                       ;-------------------------------------------------------
0203                       ; Crunch current line if dirty
0204                       ;-------------------------------------------------------
0205 74C4 8820  54         c     @fb.row.dirty,@w$ffff
     74C6 220A 
     74C8 6048 
0206 74CA 1604  14         jne   edkey.action.ins_line.insert
0207 74CC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     74CE 797E 
0208 74D0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     74D2 220A 
0209                       ;-------------------------------------------------------
0210                       ; Insert entry in index
0211                       ;-------------------------------------------------------
0212               edkey.action.ins_line.insert:
0213 74D4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74D6 77F4 
0214 74D8 C820  54         mov   @fb.topline,@parm1
     74DA 2204 
     74DC 8350 
0215 74DE A820  54         a     @fb.row,@parm1        ; Line number to insert
     74E0 2206 
     74E2 8350 
0216               
0217 74E4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     74E6 2304 
     74E8 8352 
0218 74EA 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     74EC 78F2 
0219 74EE 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     74F0 2304 
0220                       ;-------------------------------------------------------
0221                       ; Refresh frame buffer and physical screen
0222                       ;-------------------------------------------------------
0223 74F2 C820  54         mov   @fb.topline,@parm1
     74F4 2204 
     74F6 8350 
0224 74F8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     74FA 7810 
0225 74FC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     74FE 2216 
0226                       ;-------------------------------------------------------
0227                       ; Exit
0228                       ;-------------------------------------------------------
0229               edkey.action.ins_line.$$:
0230 7500 0460  28         b     @ed_wait              ; Back to editor main
     7502 70A8 
0231               
0232               
0233               
0234               
0235               
0236               
0237               *---------------------------------------------------------------
0238               * Enter
0239               *---------------------------------------------------------------
0240               edkey.action.enter:
0241                       ;-------------------------------------------------------
0242                       ; Crunch current line if dirty
0243                       ;-------------------------------------------------------
0244 7504 8820  54         c     @fb.row.dirty,@w$ffff
     7506 220A 
     7508 6048 
0245 750A 1604  14         jne   edkey.action.enter.upd_counter
0246 750C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     750E 797E 
0247 7510 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7512 220A 
0248                       ;-------------------------------------------------------
0249                       ; Update line counter
0250                       ;-------------------------------------------------------
0251               edkey.action.enter.upd_counter:
0252 7514 C120  34         mov   @fb.topline,tmp0
     7516 2204 
0253 7518 A120  34         a     @fb.row,tmp0
     751A 2206 
0254 751C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     751E 2304 
0255 7520 1602  14         jne   edkey.action.newline  ; No, continue newline
0256 7522 05A0  34         inc   @edb.lines            ; Total lines++
     7524 2304 
0257                       ;-------------------------------------------------------
0258                       ; Process newline
0259                       ;-------------------------------------------------------
0260               edkey.action.newline:
0261                       ;-------------------------------------------------------
0262                       ; Scroll 1 line if cursor at bottom row of screen
0263                       ;-------------------------------------------------------
0264 7526 C120  34         mov   @fb.screenrows,tmp0
     7528 2218 
0265 752A 0604  14         dec   tmp0
0266 752C 8120  34         c     @fb.row,tmp0
     752E 2206 
0267 7530 110A  14         jlt   edkey.action.newline.down
0268                       ;-------------------------------------------------------
0269                       ; Scroll
0270                       ;-------------------------------------------------------
0271 7532 C120  34         mov   @fb.screenrows,tmp0
     7534 2218 
0272 7536 C820  54         mov   @fb.topline,@parm1
     7538 2204 
     753A 8350 
0273 753C 05A0  34         inc   @parm1
     753E 8350 
0274 7540 06A0  32         bl    @fb.refresh
     7542 7810 
0275 7544 1004  14         jmp   edkey.action.newline.rest
0276                       ;-------------------------------------------------------
0277                       ; Move cursor down a row, there are still rows left
0278                       ;-------------------------------------------------------
0279               edkey.action.newline.down:
0280 7546 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7548 2206 
0281 754A 06A0  32         bl    @down                 ; Row++ VDP cursor
     754C 637A 
0282                       ;-------------------------------------------------------
0283                       ; Set VDP cursor and save variables
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.rest:
0286 754E 06A0  32         bl    @fb.get.firstnonblank
     7550 783A 
0287 7552 C120  34         mov   @outparm1,tmp0
     7554 8360 
0288 7556 C804  38         mov   tmp0,@fb.column
     7558 220C 
0289 755A 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     755C 638C 
0290 755E 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7560 7AB2 
0291 7562 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7564 77F4 
0292 7566 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7568 2216 
0293                       ;-------------------------------------------------------
0294                       ; Exit
0295                       ;-------------------------------------------------------
0296               edkey.action.newline.$$:
0297 756A 0460  28         b     @ed_wait              ; Back to editor main
     756C 70A8 
0298               
0299               
0300               
0301               
0302               *---------------------------------------------------------------
0303               * Toggle insert/overwrite mode
0304               *---------------------------------------------------------------
0305               edkey.action.ins_onoff:
0306 756E 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7570 230A 
0307                       ;-------------------------------------------------------
0308                       ; Delay
0309                       ;-------------------------------------------------------
0310 7572 0204  20         li    tmp0,2000
     7574 07D0 
0311               edkey.action.ins_onoff.loop:
0312 7576 0604  14         dec   tmp0
0313 7578 16FE  14         jne   edkey.action.ins_onoff.loop
0314                       ;-------------------------------------------------------
0315                       ; Exit
0316                       ;-------------------------------------------------------
0317               edkey.action.ins_onoff.$$:
0318 757A 0460  28         b     @task2.cur_visible    ; Update cursor shape
     757C 76D0 
0319               
0320               
0321               
0322               
0323               
0324               
0325               *---------------------------------------------------------------
0326               * Process character
0327               *---------------------------------------------------------------
0328               edkey.action.char:
0329 757E D805  38         movb  tmp1,@parm1           ; Store character for insert
     7580 8350 
0330 7582 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7584 230A 
0331 7586 1302  14         jeq   edkey.action.char.overwrite
0332                       ;-------------------------------------------------------
0333                       ; Insert mode
0334                       ;-------------------------------------------------------
0335               edkey.action.char.insert:
0336 7588 0460  28         b     @edkey.action.ins_char
     758A 747A 
0337                       ;-------------------------------------------------------
0338                       ; Overwrite mode
0339                       ;-------------------------------------------------------
0340               edkey.action.char.overwrite:
0341 758C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     758E 77F4 
0342 7590 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7592 2202 
0343               
0344 7594 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7596 8350 
0345 7598 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     759A 220A 
0346 759C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     759E 2216 
0347               
0348 75A0 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     75A2 220C 
0349 75A4 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     75A6 832A 
0350                       ;-------------------------------------------------------
0351                       ; Update line length in frame buffer
0352                       ;-------------------------------------------------------
0353 75A8 8820  54         c     @fb.column,@fb.row.length
     75AA 220C 
     75AC 2208 
0354 75AE 1103  14         jlt   edkey.action.char.$$  ; column < length line ? Skip further processing
0355 75B0 C820  54         mov   @fb.column,@fb.row.length
     75B2 220C 
     75B4 2208 
0356                       ;-------------------------------------------------------
0357                       ; Exit
0358                       ;-------------------------------------------------------
0359               edkey.action.char.$$:
0360 75B6 0460  28         b     @ed_wait              ; Back to editor main
     75B8 70A8 
**** **** ****     > tivi.asm.28024
0344                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 75BA 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     75BC 643C 
0010 75BE 0420  54         blwp  @0                    ; Exit
     75C0 0000 
0011               
**** **** ****     > tivi.asm.28024
0345                       copy  "editorkeys_file.asm" ; Actions for file related keys
**** **** ****     > editorkeys_file.asm
0001               * FILE......: editorkeys_fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load DV/80 text file into editor
0007               *---------------------------------------------------------------
0008               * Input
0009               * @tmp0 = Pointer to length-prefixed string containing device
0010               *         and filename
0011               *---------------------------------------------------------------
0012               edkey.action.loadfile:
0013 75C2 C804  38         mov   tmp0,@parm1           ; Setup file to load
     75C4 8350 
0014               
0015 75C6 06A0  32         bl    @edb.init             ; Initialize editor buffer
     75C8 7962 
0016 75CA 06A0  32         bl    @idx.init             ; Initialize index
     75CC 7882 
0017 75CE 06A0  32         bl    @fb.init              ; Initialize framebuffer
     75D0 77A6 
0018                       ;-------------------------------------------------------
0019                       ; Clear VDP screen buffer
0020                       ;-------------------------------------------------------
0021 75D2 06A0  32         bl    @filv
     75D4 60F0 
0022 75D6 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     75D8 0000 
     75DA 0004 
0023               
0024 75DC C160  34         mov   @fb.screenrows,tmp1
     75DE 2218 
0025 75E0 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     75E2 220E 
0026                                                   ; 16 bit part is in tmp2!
0027               
0028 75E4 04C4  14         clr   tmp0                  ; VDP target address
0029 75E6 0205  20         li    tmp1,32               ; Character to fill
     75E8 0020 
0030 75EA 06A0  32         bl    @xfilv                ; Fill VDP
     75EC 60F6 
0031                                                   ; tmp0 = VDP target address
0032                                                   ; tmp1 = Byte to fill
0033                                                   ; tmp2 = Bytes to copy
0034                       ;-------------------------------------------------------
0035                       ; Read DV80 file and display
0036                       ;-------------------------------------------------------
0037 75EE 06A0  32         bl    @tfh.file.read        ; Read specified file
     75F0 7AD6 
0038 75F2 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     75F4 738C 
0039               
0040               
0041               
0042               edkey.action.buffer0:
0043 75F6 0204  20         li   tmp0,fdname0
     75F8 7CA8 
0044 75FA 10E3  14         jmp  edkey.action.loadfile
0045                                                   ; Load DIS/VAR 80 file into editor buffer
0046               edkey.action.buffer1:
0047 75FC 0204  20         li   tmp0,fdname1
     75FE 7CB4 
0048 7600 10E0  14         jmp  edkey.action.loadfile
0049                                                   ; Load DIS/VAR 80 file into editor buffer
0050               
0051               edkey.action.buffer2:
0052 7602 0204  20         li   tmp0,fdname2
     7604 7CC4 
0053 7606 10DD  14         jmp  edkey.action.loadfile
0054                                                   ; Load DIS/VAR 80 file into editor buffer
0055               
0056               edkey.action.buffer3:
0057 7608 0204  20         li   tmp0,fdname3
     760A 7CD2 
0058 760C 10DA  14         jmp  edkey.action.loadfile
0059                                                   ; Load DIS/VAR 80 file into editor buffer
0060               
0061               edkey.action.buffer4:
0062 760E 0204  20         li   tmp0,fdname4
     7610 7CE0 
0063 7612 10D7  14         jmp  edkey.action.loadfile
0064                                                   ; Load DIS/VAR 80 file into editor buffer
0065               
0066               edkey.action.buffer5:
0067 7614 0204  20         li   tmp0,fdname5
     7616 7CEE 
0068 7618 10D4  14         jmp  edkey.action.loadfile
0069                                                   ; Load DIS/VAR 80 file into editor buffer
0070               
0071               edkey.action.buffer6:
0072 761A 0204  20         li   tmp0,fdname6
     761C 7CFC 
0073 761E 10D1  14         jmp  edkey.action.loadfile
0074                                                   ; Load DIS/VAR 80 file into editor buffer
0075               
0076               edkey.action.buffer7:
0077 7620 0204  20         li   tmp0,fdname7
     7622 7D0A 
0078 7624 10CE  14         jmp  edkey.action.loadfile
0079                                                   ; Load DIS/VAR 80 file into editor buffer
0080               
0081               edkey.action.buffer8:
0082 7626 0204  20         li   tmp0,fdname8
     7628 7D18 
0083 762A 10CB  14         jmp  edkey.action.loadfile
0084                                                   ; Load DIS/VAR 80 file into editor buffer
0085               
0086               edkey.action.buffer9:
0087 762C 0204  20         li   tmp0,fdname9
     762E 7D26 
0088 7630 10C8  14         jmp  edkey.action.loadfile
0089                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.28024
0346               
0347               
0348               
0349               ***************************************************************
0350               * Task 0 - Copy frame buffer to VDP
0351               ***************************************************************
0352 7632 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7634 2216 
0353 7636 133D  14         jeq   task0.$$              ; No, skip update
0354                       ;------------------------------------------------------
0355                       ; Determine how many rows to copy
0356                       ;------------------------------------------------------
0357 7638 8820  54         c     @edb.lines,@fb.screenrows
     763A 2304 
     763C 2218 
0358 763E 1103  14         jlt   task0.setrows.small
0359 7640 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7642 2218 
0360 7644 1003  14         jmp   task0.copy.framebuffer
0361                       ;------------------------------------------------------
0362                       ; Less lines in editor buffer as rows in frame buffer
0363                       ;------------------------------------------------------
0364               task0.setrows.small:
0365 7646 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7648 2304 
0366 764A 0585  14         inc   tmp1
0367                       ;------------------------------------------------------
0368                       ; Determine area to copy
0369                       ;------------------------------------------------------
0370               task0.copy.framebuffer:
0371 764C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     764E 220E 
0372                                                   ; 16 bit part is in tmp2!
0373 7650 04C4  14         clr   tmp0                  ; VDP target address
0374 7652 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7654 2200 
0375                       ;------------------------------------------------------
0376                       ; Copy memory block
0377                       ;------------------------------------------------------
0378 7656 06A0  32         bl    @xpym2v               ; Copy to VDP
     7658 62A0 
0379                                                   ; tmp0 = VDP target address
0380                                                   ; tmp1 = RAM source address
0381                                                   ; tmp2 = Bytes to copy
0382 765A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     765C 2216 
0383                       ;-------------------------------------------------------
0384                       ; Draw EOF marker at end-of-file
0385                       ;-------------------------------------------------------
0386 765E C120  34         mov   @edb.lines,tmp0
     7660 2304 
0387 7662 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7664 2204 
0388 7666 0584  14         inc   tmp0                  ; Y++
0389 7668 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     766A 2218 
0390 766C 1222  14         jle   task0.$$
0391                       ;-------------------------------------------------------
0392                       ; Draw EOF marker
0393                       ;-------------------------------------------------------
0394               task0.draw_marker:
0395 766E C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7670 832A 
     7672 2214 
0396 7674 0A84  56         sla   tmp0,8                ; X=0
0397 7676 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7678 832A 
0398 767A 06A0  32         bl    @putstr
     767C 6280 
0399 767E 7C7C                   data txt_marker       ; Display *EOF*
0400                       ;-------------------------------------------------------
0401                       ; Draw empty line after (and below) EOF marker
0402                       ;-------------------------------------------------------
0403 7680 06A0  32         bl    @setx
     7682 638A 
0404 7684 0005                   data  5               ; Cursor after *EOF* string
0405               
0406 7686 C120  34         mov   @wyx,tmp0
     7688 832A 
0407 768A 0984  56         srl   tmp0,8                ; Right justify
0408 768C 0584  14         inc   tmp0                  ; One time adjust
0409 768E 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7690 2218 
0410 7692 1303  14         jeq   !
0411 7694 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7696 009B 
0412 7698 1002  14         jmp   task0.draw_marker.line
0413 769A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     769C 004B 
0414                       ;-------------------------------------------------------
0415                       ; Draw empty line
0416                       ;-------------------------------------------------------
0417               task0.draw_marker.line:
0418 769E 0604  14         dec   tmp0                  ; One time adjust
0419 76A0 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     76A2 625C 
0420 76A4 0205  20         li    tmp1,32               ; Character to write (whitespace)
     76A6 0020 
0421 76A8 06A0  32         bl    @xfilv                ; Write characters
     76AA 60F6 
0422 76AC C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     76AE 2214 
     76B0 832A 
0423               *--------------------------------------------------------------
0424               * Task 0 - Exit
0425               *--------------------------------------------------------------
0426               task0.$$:
0427 76B2 0460  28         b     @slotok
     76B4 6EC8 
0428               
0429               
0430               
0431               ***************************************************************
0432               * Task 1 - Copy SAT to VDP
0433               ***************************************************************
0434 76B6 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     76B8 6046 
0435 76BA 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     76BC 6396 
0436 76BE C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     76C0 8380 
0437 76C2 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0438               
0439               
0440               ***************************************************************
0441               * Task 2 - Update cursor shape (blink)
0442               ***************************************************************
0443 76C4 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     76C6 2212 
0444 76C8 1303  14         jeq   task2.cur_visible
0445 76CA 04E0  34         clr   @ramsat+2              ; Hide cursor
     76CC 8382 
0446 76CE 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0447               
0448               task2.cur_visible:
0449 76D0 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     76D2 230A 
0450 76D4 1303  14         jeq   task2.cur_visible.overwrite_mode
0451                       ;------------------------------------------------------
0452                       ; Cursor in insert mode
0453                       ;------------------------------------------------------
0454               task2.cur_visible.insert_mode:
0455 76D6 0204  20         li    tmp0,>000f
     76D8 000F 
0456 76DA 1002  14         jmp   task2.cur_visible.cursorshape
0457                       ;------------------------------------------------------
0458                       ; Cursor in overwrite mode
0459                       ;------------------------------------------------------
0460               task2.cur_visible.overwrite_mode:
0461 76DC 0204  20         li    tmp0,>020f
     76DE 020F 
0462                       ;------------------------------------------------------
0463                       ; Set cursor shape
0464                       ;------------------------------------------------------
0465               task2.cur_visible.cursorshape:
0466 76E0 C804  38         mov   tmp0,@fb.curshape
     76E2 2210 
0467 76E4 C804  38         mov   tmp0,@ramsat+2
     76E6 8382 
0468               
0469               
0470               
0471               
0472               
0473               
0474               
0475               *--------------------------------------------------------------
0476               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0477               *--------------------------------------------------------------
0478               task.sub_copy_ramsat
0479 76E8 06A0  32         bl    @cpym2v
     76EA 629A 
0480 76EC 2000                   data sprsat,ramsat,4   ; Update sprite
     76EE 8380 
     76F0 0004 
0481               
0482 76F2 C820  54         mov   @wyx,@fb.yxsave
     76F4 832A 
     76F6 2214 
0483                       ;------------------------------------------------------
0484                       ; Show text editing mode
0485                       ;------------------------------------------------------
0486               task.botline.show_mode
0487 76F8 C120  34         mov   @edb.insmode,tmp0
     76FA 230A 
0488 76FC 1605  14         jne   task.botline.show_mode.insert
0489                       ;------------------------------------------------------
0490                       ; Overwrite mode
0491                       ;------------------------------------------------------
0492               task.botline.show_mode.overwrite:
0493 76FE 06A0  32         bl    @putat
     7700 6292 
0494 7702 1D32                   byte  29,50
0495 7704 7C88                   data  txt_ovrwrite
0496 7706 1004  14         jmp   task.botline.show_linecol
0497                       ;------------------------------------------------------
0498                       ; Insert  mode
0499                       ;------------------------------------------------------
0500               task.botline.show_mode.insert
0501 7708 06A0  32         bl    @putat
     770A 6292 
0502 770C 1D32                   byte  29,50
0503 770E 7C8C                   data  txt_insert
0504                       ;------------------------------------------------------
0505                       ; Show "line,column"
0506                       ;------------------------------------------------------
0507               task.botline.show_linecol:
0508 7710 C820  54         mov   @fb.row,@parm1
     7712 2206 
     7714 8350 
0509 7716 06A0  32         bl    @fb.row2line
     7718 77E0 
0510 771A 05A0  34         inc   @outparm1
     771C 8360 
0511                       ;------------------------------------------------------
0512                       ; Show line
0513                       ;------------------------------------------------------
0514 771E 06A0  32         bl    @putnum
     7720 6666 
0515 7722 1D40                   byte  29,64            ; YX
0516 7724 8360                   data  outparm1,rambuf
     7726 8390 
0517 7728 3020                   byte  48               ; ASCII offset
0518                             byte  32               ; Padding character
0519                       ;------------------------------------------------------
0520                       ; Show comma
0521                       ;------------------------------------------------------
0522 772A 06A0  32         bl    @putat
     772C 6292 
0523 772E 1D45                   byte  29,69
0524 7730 7C7A                   data  txt_delim
0525                       ;------------------------------------------------------
0526                       ; Show column
0527                       ;------------------------------------------------------
0528 7732 06A0  32         bl    @film
     7734 60CC 
0529 7736 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7738 0020 
     773A 000C 
0530               
0531 773C C820  54         mov   @fb.column,@waux1
     773E 220C 
     7740 833C 
0532 7742 05A0  34         inc   @waux1                 ; Offset 1
     7744 833C 
0533               
0534 7746 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7748 65E8 
0535 774A 833C                   data  waux1,rambuf
     774C 8390 
0536 774E 3020                   byte  48               ; ASCII offset
0537                             byte  32               ; Fill character
0538               
0539 7750 06A0  32         bl    @trimnum               ; Trim number to the left
     7752 6640 
0540 7754 8390                   data  rambuf,rambuf+6,32
     7756 8396 
     7758 0020 
0541               
0542 775A 0204  20         li    tmp0,>0200
     775C 0200 
0543 775E D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7760 8396 
0544               
0545 7762 06A0  32         bl    @putat
     7764 6292 
0546 7766 1D46                   byte 29,70
0547 7768 8396                   data rambuf+6          ; Show column
0548                       ;------------------------------------------------------
0549                       ; Show lines in buffer unless on last line in file
0550                       ;------------------------------------------------------
0551 776A C820  54         mov   @fb.row,@parm1
     776C 2206 
     776E 8350 
0552 7770 06A0  32         bl    @fb.row2line
     7772 77E0 
0553 7774 8820  54         c     @edb.lines,@outparm1
     7776 2304 
     7778 8360 
0554 777A 1605  14         jne   task.botline.show_lines_in_buffer
0555               
0556 777C 06A0  32         bl    @putat
     777E 6292 
0557 7780 1D49                   byte 29,73
0558 7782 7C82                   data txt_bottom
0559               
0560 7784 100B  14         jmp   task.botline.$$
0561                       ;------------------------------------------------------
0562                       ; Show lines in buffer
0563                       ;------------------------------------------------------
0564               task.botline.show_lines_in_buffer:
0565 7786 C820  54         mov   @edb.lines,@waux1
     7788 2304 
     778A 833C 
0566 778C 05A0  34         inc   @waux1                 ; Offset 1
     778E 833C 
0567 7790 06A0  32         bl    @putnum
     7792 6666 
0568 7794 1D49                   byte 29,73             ; YX
0569 7796 833C                   data waux1,rambuf
     7798 8390 
0570 779A 3020                   byte 48
0571                             byte 32
0572                       ;------------------------------------------------------
0573                       ; Exit
0574                       ;------------------------------------------------------
0575               task.botline.$$
0576 779C C820  54         mov   @fb.yxsave,@wyx
     779E 2214 
     77A0 832A 
0577 77A2 0460  28         b     @slotok                ; Exit running task
     77A4 6EC8 
0578               
0579               
0580               
0581               ***************************************************************
0582               *                  fb - Framebuffer module
0583               ***************************************************************
0584                       copy  "framebuffer.asm"
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
0024 77A6 0649  14         dect  stack
0025 77A8 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 77AA 0204  20         li    tmp0,fb.top
     77AC 2650 
0030 77AE C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     77B0 2200 
0031 77B2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     77B4 2204 
0032 77B6 04E0  34         clr   @fb.row               ; Current row=0
     77B8 2206 
0033 77BA 04E0  34         clr   @fb.column            ; Current column=0
     77BC 220C 
0034 77BE 0204  20         li    tmp0,80
     77C0 0050 
0035 77C2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     77C4 220E 
0036 77C6 0204  20         li    tmp0,29
     77C8 001D 
0037 77CA C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     77CC 2218 
0038 77CE 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     77D0 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 77D2 06A0  32         bl    @film
     77D4 60CC 
0043 77D6 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     77D8 0000 
     77DA 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 77DC 0460  28         b     @poprt                ; Return to caller
     77DE 60C8 
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
0073 77E0 0649  14         dect  stack
0074 77E2 C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 77E4 C120  34         mov   @parm1,tmp0
     77E6 8350 
0079 77E8 A120  34         a     @fb.topline,tmp0
     77EA 2204 
0080 77EC C804  38         mov   tmp0,@outparm1
     77EE 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 77F0 0460  28         b    @poprt                 ; Return to caller
     77F2 60C8 
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
0113 77F4 0649  14         dect  stack
0114 77F6 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 77F8 C1A0  34         mov   @fb.row,tmp2
     77FA 2206 
0119 77FC 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     77FE 220E 
0120 7800 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     7802 220C 
0121 7804 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7806 2200 
0122 7808 C807  38         mov   tmp3,@fb.current
     780A 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 780C 0460  28         b    @poprt                 ; Return to caller
     780E 60C8 
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
0145 7810 0649  14         dect  stack
0146 7812 C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7814 C820  54         mov   @parm1,@fb.topline
     7816 8350 
     7818 2204 
0151 781A 04E0  34         clr   @parm2                ; Target row in frame buffer
     781C 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 781E 06A0  32         bl    @edb.line.unpack
     7820 7A16 
0157 7822 05A0  34         inc   @parm1                ; Next line in editor buffer
     7824 8350 
0158 7826 05A0  34         inc   @parm2                ; Next row in frame buffer
     7828 8352 
0159 782A 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     782C 8352 
     782E 2218 
0160 7830 11F6  14         jlt   fb.refresh.unpack_line
0161 7832 0720  34         seto  @fb.dirty             ; Refresh screen
     7834 2216 
0162                       ;------------------------------------------------------
0163                       ; Exit
0164                       ;------------------------------------------------------
0165               fb.refresh.$$
0166 7836 0460  28         b    @poprt                 ; Return to caller
     7838 60C8 
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
0182 783A 0649  14         dect  stack
0183 783C C64B  30         mov   r11,*stack            ; Save return address
0184                       ;------------------------------------------------------
0185                       ; Prepare for scanning
0186                       ;------------------------------------------------------
0187 783E 04E0  34         clr   @fb.column
     7840 220C 
0188 7842 06A0  32         bl    @fb.calc_pointer
     7844 77F4 
0189 7846 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7848 7AB2 
0190 784A C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     784C 2208 
0191 784E 1313  14         jeq   fb.get.firstnonblank.nomatch
0192                                                   ; Exit if empty line
0193 7850 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7852 2202 
0194 7854 04C5  14         clr   tmp1
0195                       ;------------------------------------------------------
0196                       ; Scan line for non-blank character
0197                       ;------------------------------------------------------
0198               fb.get.firstnonblank.loop:
0199 7856 D174  28         movb  *tmp0+,tmp1           ; Get character
0200 7858 130E  14         jeq   fb.get.firstnonblank.nomatch
0201                                                   ; Exit if empty line
0202 785A 0285  22         ci    tmp1,>2000            ; Whitespace?
     785C 2000 
0203 785E 1503  14         jgt   fb.get.firstnonblank.match
0204 7860 0606  14         dec   tmp2                  ; Counter--
0205 7862 16F9  14         jne   fb.get.firstnonblank.loop
0206 7864 1008  14         jmp   fb.get.firstnonblank.nomatch
0207                       ;------------------------------------------------------
0208                       ; Non-blank character found
0209                       ;------------------------------------------------------
0210               fb.get.firstnonblank.match
0211 7866 6120  34         s     @fb.current,tmp0      ; Calculate column
     7868 2202 
0212 786A 0604  14         dec   tmp0
0213 786C C804  38         mov   tmp0,@outparm1        ; Save column
     786E 8360 
0214 7870 D805  38         movb  tmp1,@outparm2        ; Save character
     7872 8362 
0215 7874 1004  14         jmp   fb.get.firstnonblank.$$
0216                       ;------------------------------------------------------
0217                       ; No non-blank character found
0218                       ;------------------------------------------------------
0219               fb.get.firstnonblank.nomatch
0220 7876 04E0  34         clr   @outparm1             ; X=0
     7878 8360 
0221 787A 04E0  34         clr   @outparm2             ; Null
     787C 8362 
0222                       ;------------------------------------------------------
0223                       ; Exit
0224                       ;------------------------------------------------------
0225               fb.get.firstnonblank.$$
0226 787E 0460  28         b    @poprt                 ; Return to caller
     7880 60C8 
0227               
0228               
0229               
0230               
0231               
0232               
**** **** ****     > tivi.asm.28024
0585               
0586               
0587               ***************************************************************
0588               *              idx - Index management module
0589               ***************************************************************
0590                       copy  "index.asm"
**** **** ****     > index.asm
0001               * FILE......: index.asm
0002               * Purpose...: TiVi Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * idx.init
0011               * Initialize index
0012               ***************************************************************
0013               * bl @idx.init
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
0025               * Each index slot entry 4 bytes each
0026               *  Word 0: pointer to string (no length byte)
0027               *  Word 1: MSB=Packed length, LSB=Unpacked length
0028               ***************************************************************
0029               idx.init:
0030 7882 0649  14         dect  stack
0031 7884 C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Initialize
0034                       ;------------------------------------------------------
0035 7886 0204  20         li    tmp0,idx.top
     7888 3000 
0036 788A C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     788C 2302 
0037                       ;------------------------------------------------------
0038                       ; Create index slot 0
0039                       ;------------------------------------------------------
0040 788E 06A0  32         bl    @film
     7890 60CC 
0041 7892 3000             data  idx.top,>00,idx.size  ; Clear index
     7894 0000 
     7896 1000 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               idx.init.$$:
0046 7898 0460  28         b     @poprt                ; Return to caller
     789A 60C8 
0047               
0048               
0049               
0050               ***************************************************************
0051               * idx.entry.update
0052               * Update index entry - Each entry corresponds to a line
0053               ***************************************************************
0054               * bl @idx.entry.update
0055               *--------------------------------------------------------------
0056               * INPUT
0057               * @parm1    = Line number in editor buffer
0058               * @parm2    = Pointer to line in editor buffer
0059               *             (or line content if length <= 2)
0060               * @parm3    = Length of line
0061               *--------------------------------------------------------------
0062               * OUTPUT
0063               * @outparm1 = Pointer to updated index entry
0064               *--------------------------------------------------------------
0065               * Register usage
0066               * tmp0,tmp1,tmp2
0067               *--------------------------------------------------------------
0068               idx.entry.update:
0069 789C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     789E 8350 
0070                       ;------------------------------------------------------
0071                       ; Calculate address of index entry and update
0072                       ;------------------------------------------------------
0073 78A0 0A24  56         sla   tmp0,2                ; line number * 4
0074 78A2 C920  54         mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
     78A4 8352 
     78A6 3000 
0075                       ;------------------------------------------------------
0076                       ; Set packed / unpacked length of string and update
0077                       ;------------------------------------------------------
0078 78A8 C160  34         mov   @parm3,tmp1           ; Set unpacked length
     78AA 8354 
0079 78AC C185  18         mov   tmp1,tmp2
0080 78AE 06C6  14         swpb  tmp2
0081 78B0 D146  18         movb  tmp2,tmp1             ; Set packed length (identical for now!)
0082 78B2 C905  38         mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> Lengths
     78B4 3002 
0083                       ;------------------------------------------------------
0084                       ; Exit
0085                       ;------------------------------------------------------
0086               idx.entry.update.$$:
0087 78B6 C804  38         mov   tmp0,@outparm1        ; Pointer to update index entry
     78B8 8360 
0088 78BA 045B  20         b     *r11                  ; Return
0089               
0090               
0091               ***************************************************************
0092               * idx.entry.delete
0093               * Delete index entry - Close gap created by delete
0094               ***************************************************************
0095               * bl @idx.entry.delete
0096               *--------------------------------------------------------------
0097               * INPUT
0098               * @parm1    = Line number in editor buffer to delete
0099               * @parm2    = Line number of last line to check for reorg
0100               *--------------------------------------------------------------
0101               * OUTPUT
0102               * @outparm1 = Pointer to deleted line (for undo)
0103               *--------------------------------------------------------------
0104               * Register usage
0105               * tmp0,tmp2
0106               *--------------------------------------------------------------
0107               idx.entry.delete:
0108 78BC C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     78BE 8350 
0109                       ;------------------------------------------------------
0110                       ; Calculate address of index entry and save pointer
0111                       ;------------------------------------------------------
0112 78C0 0A24  56         sla   tmp0,2                ; line number * 4
0113 78C2 C824  54         mov   @idx.top(tmp0),@outparm1
     78C4 3000 
     78C6 8360 
0114                                                   ; Pointer to deleted line
0115                       ;------------------------------------------------------
0116                       ; Prepare for index reorg
0117                       ;------------------------------------------------------
0118 78C8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     78CA 8352 
0119 78CC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     78CE 8350 
0120 78D0 1605  14         jne   idx.entry.delete.reorg
0121                       ;------------------------------------------------------
0122                       ; Special treatment if last line
0123                       ;------------------------------------------------------
0124 78D2 0724  34         seto  @idx.top+0(tmp0)
     78D4 3000 
0125 78D6 04E4  34         clr   @idx.top+2(tmp0)
     78D8 3002 
0126 78DA 100A  14         jmp   idx.entry.delete.$$
0127                       ;------------------------------------------------------
0128                       ; Reorganize index entries
0129                       ;------------------------------------------------------
0130               idx.entry.delete.reorg:
0131 78DC C924  54         mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
     78DE 3004 
     78E0 3000 
0132 78E2 C924  54         mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
     78E4 3006 
     78E6 3002 
0133 78E8 0224  22         ai    tmp0,4                ; Next index entry
     78EA 0004 
0134               
0135 78EC 0606  14         dec   tmp2                  ; tmp2--
0136 78EE 16F6  14         jne   idx.entry.delete.reorg
0137                                                   ; Loop unless completed
0138                       ;------------------------------------------------------
0139                       ; Exit
0140                       ;------------------------------------------------------
0141               idx.entry.delete.$$:
0142 78F0 045B  20         b     *r11                  ; Return
0143               
0144               
0145               ***************************************************************
0146               * idx.entry.insert
0147               * Insert index entry
0148               ***************************************************************
0149               * bl @idx.entry.insert
0150               *--------------------------------------------------------------
0151               * INPUT
0152               * @parm1    = Line number in editor buffer to insert
0153               * @parm2    = Line number of last line to check for reorg
0154               *--------------------------------------------------------------
0155               * OUTPUT
0156               * NONE
0157               *--------------------------------------------------------------
0158               * Register usage
0159               * tmp0,tmp2
0160               *--------------------------------------------------------------
0161               idx.entry.insert:
0162 78F2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     78F4 8352 
0163                       ;------------------------------------------------------
0164                       ; Calculate address of index entry and save pointer
0165                       ;------------------------------------------------------
0166 78F6 0A24  56         sla   tmp0,2                ; line number * 4
0167                       ;------------------------------------------------------
0168                       ; Prepare for index reorg
0169                       ;------------------------------------------------------
0170 78F8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     78FA 8352 
0171 78FC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     78FE 8350 
0172 7900 160B  14         jne   idx.entry.insert.reorg
0173                       ;------------------------------------------------------
0174                       ; Special treatment if last line
0175                       ;------------------------------------------------------
0176 7902 C924  54         mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     7904 3000 
     7906 3004 
0177 7908 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     790A 3002 
     790C 3006 
0178 790E 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
     7910 3000 
0179 7912 04E4  34         clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
     7914 3002 
0180 7916 100F  14         jmp   idx.entry.insert.$$
0181                       ;------------------------------------------------------
0182                       ; Reorganize index entries
0183                       ;------------------------------------------------------
0184               idx.entry.insert.reorg:
0185 7918 05C6  14         inct  tmp2                  ; Adjust one time
0186 791A C924  54 !       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     791C 3000 
     791E 3004 
0187 7920 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7922 3002 
     7924 3006 
0188 7926 0224  22         ai    tmp0,-4               ; Previous index entry
     7928 FFFC 
0189               
0190 792A 0606  14         dec   tmp2                  ; tmp2--
0191 792C 16F6  14         jne   -!                    ; Loop unless completed
0192 792E 04E4  34         clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
     7930 3008 
0193 7932 04E4  34         clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
     7934 300A 
0194                       ;------------------------------------------------------
0195                       ; Exit
0196                       ;------------------------------------------------------
0197               idx.entry.insert.$$:
0198 7936 045B  20         b     *r11                  ; Return
0199               
0200               
0201               
0202               ***************************************************************
0203               * idx.pointer.get
0204               * Get pointer to editor buffer line content
0205               ***************************************************************
0206               * bl @idx.pointer.get
0207               *--------------------------------------------------------------
0208               * INPUT
0209               * @parm1 = Line number in editor buffer
0210               *--------------------------------------------------------------
0211               * OUTPUT
0212               * @outparm1 = Pointer to editor buffer line content
0213               * @outparm2 = Line length
0214               *--------------------------------------------------------------
0215               * Register usage
0216               * tmp0,tmp1,tmp2
0217               *--------------------------------------------------------------
0218               idx.pointer.get:
0219 7938 0649  14         dect  stack
0220 793A C64B  30         mov   r11,*stack            ; Save return address
0221                       ;------------------------------------------------------
0222                       ; Get pointer
0223                       ;------------------------------------------------------
0224 793C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     793E 8350 
0225                       ;------------------------------------------------------
0226                       ; Calculate index entry
0227                       ;------------------------------------------------------
0228 7940 0A24  56         sla   tmp0,2                     ; line number * 4
0229 7942 C824  54         mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
     7944 3000 
     7946 8360 
0230                       ;------------------------------------------------------
0231                       ; Get SAMS page
0232                       ;------------------------------------------------------
0233 7948 C164  34         mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
     794A 3002 
0234 794C 0985  56         srl   tmp1,8                ; Right justify
0235 794E C805  38         mov   tmp1,@outparm2
     7950 8362 
0236                       ;------------------------------------------------------
0237                       ; Get line length
0238                       ;------------------------------------------------------
0239 7952 C164  34         mov   @idx.top+2(tmp0),tmp1
     7954 3002 
0240 7956 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     7958 00FF 
0241 795A C805  38         mov   tmp1,@outparm3
     795C 8364 
0242                       ;------------------------------------------------------
0243                       ; Exit
0244                       ;------------------------------------------------------
0245               idx.pointer.get.$$:
0246 795E 0460  28         b     @poprt                ; Return to caller
     7960 60C8 
**** **** ****     > tivi.asm.28024
0591               
0592               
0593               ***************************************************************
0594               *               edb - Editor Buffer module
0595               ***************************************************************
0596                       copy  "editorbuffer.asm"
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
0026 7962 0649  14         dect  stack
0027 7964 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7966 0204  20         li    tmp0,edb.top
     7968 A000 
0032 796A C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     796C 2300 
0033 796E C804  38         mov   tmp0,@edb.next_free   ; Set pointer to next free line in editor buffer
     7970 2308 
0034 7972 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7974 230A 
0035 7976 04E0  34         clr   @edb.lines            ; Lines=0
     7978 2304 
0036               
0037               edb.init.$$:
0038                       ;------------------------------------------------------
0039                       ; Exit
0040                       ;------------------------------------------------------
0041 797A 0460  28         b     @poprt                ; Return to caller
     797C 60C8 
0042               
0043               
0044               
0045               ***************************************************************
0046               * edb.line.pack
0047               * Pack current line in framebuffer
0048               ***************************************************************
0049               *  bl   @edb.line.pack
0050               *--------------------------------------------------------------
0051               * INPUT
0052               * @fb.top       = Address of top row in frame buffer
0053               * @fb.row       = Current row in frame buffer
0054               * @fb.column    = Current column in frame buffer
0055               * @fb.colsline  = Columns per line in frame buffer
0056               *--------------------------------------------------------------
0057               * OUTPUT
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * tmp0,tmp1,tmp2
0061               *--------------------------------------------------------------
0062               * Memory usage
0063               * rambuf   = Saved @fb.column
0064               * rambuf+2 = Saved beginning of row
0065               * rambuf+4 = Saved length of row
0066               ********@*****@*********************@**************************
0067               edb.line.pack:
0068 797E 0649  14         dect  stack
0069 7980 C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Get values
0072                       ;------------------------------------------------------
0073 7982 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7984 220C 
     7986 8390 
0074 7988 04E0  34         clr   @fb.column
     798A 220C 
0075 798C 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     798E 77F4 
0076                       ;------------------------------------------------------
0077                       ; Prepare scan
0078                       ;------------------------------------------------------
0079 7990 04C4  14         clr   tmp0                  ; Counter
0080 7992 C160  34         mov   @fb.current,tmp1      ; Get position
     7994 2202 
0081 7996 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7998 8392 
0082                       ;------------------------------------------------------
0083                       ; Scan line for >00 byte termination
0084                       ;------------------------------------------------------
0085               edb.line.pack.scan:
0086 799A D1B5  28         movb  *tmp1+,tmp2           ; Get char
0087 799C 0986  56         srl   tmp2,8                ; Right justify
0088 799E 1302  14         jeq   edb.line.pack.checklength
0089                                                   ; Stop scan if >00 found
0090 79A0 0584  14         inc   tmp0                  ; Increase string length
0091 79A2 10FB  14         jmp   edb.line.pack.scan    ; Next character
0092                       ;------------------------------------------------------
0093                       ; Handle line placement depending on length
0094                       ;------------------------------------------------------
0095               edb.line.pack.checklength:
0096 79A4 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     79A6 2204 
     79A8 8350 
0097 79AA A820  54         a     @fb.row,@parm1        ; /
     79AC 2206 
     79AE 8350 
0098               
0099 79B0 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     79B2 8394 
0100 79B4 1507  14         jgt   edb.line.pack.checklength2
0101                       ;------------------------------------------------------
0102                       ; Special handling if empty line (length=0)
0103                       ;------------------------------------------------------
0104 79B6 04E0  34         clr   @parm2                ; Clear line content
     79B8 8352 
0105               
0106 79BA 04E0  34         clr   @parm3                ; Set length of line
     79BC 8354 
0107 79BE 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     79C0 789C 
0108                                                   ; parm2=line content
0109                                                   ; parm3=line length
0110               
0111 79C2 1024  14         jmp   edb.line.pack.$$      ; Exit
0112                       ;------------------------------------------------------
0113                       ; Put line content in index itself if line length <= 2
0114                       ;------------------------------------------------------
0115               edb.line.pack.checklength2:
0116 79C4 0284  22         ci    tmp0,2
     79C6 0002 
0117 79C8 150D  14         jgt   edb.line.pack.idx.normal
0118               
0119 79CA 04E0  34         clr   @parm2
     79CC 8352 
0120 79CE C160  34         mov   @rambuf+2,tmp1
     79D0 8392 
0121 79D2 D835  48         movb  *tmp1+,@parm2         ; Copy 1st charcter
     79D4 8352 
0122 79D6 D835  48         movb  *tmp1+,@parm2+1       ; Copy 2nd charcter
     79D8 8353 
0123               
0124 79DA C804  38         mov   tmp0,@parm3           ; Set length of line
     79DC 8354 
0125 79DE 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     79E0 789C 
0126                                                   ; parm2=line content
0127                                                   ; parm3=line length
0128               
0129 79E2 1014  14         jmp   edb.line.pack.$$      ; Exit
0130                       ;------------------------------------------------------
0131                       ; Update index and store line in editor buffer
0132                       ;------------------------------------------------------
0133               edb.line.pack.idx.normal:
0134 79E4 C820  54         mov   @edb.next_free,@parm2 ; Block where packed string will reside
     79E6 2308 
     79E8 8352 
0135 79EA C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     79EC 8394 
0136               
0137 79EE C804  38         mov   tmp0,@parm3           ; Set length of line
     79F0 8354 
0138 79F2 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     79F4 789C 
0139                                                   ; parm2=pointer to line in editor buffer
0140                                                   ; parm3=line length
0141                       ;------------------------------------------------------
0142                       ; Pack line from framebuffer to editor buffer
0143                       ;------------------------------------------------------
0144 79F6 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     79F8 8392 
0145 79FA C160  34         mov   @edb.next_free,tmp1   ; Destination for memory copy
     79FC 2308 
0146 79FE C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     7A00 8394 
0147                       ;------------------------------------------------------
0148                       ; Copy memory block
0149                       ;------------------------------------------------------
0150               edb.line.pack.idx.normal.copy:
0151 7A02 06A0  32         bl    @xpym2m               ; Copy memory block
     7A04 62E8 
0152                                                   ;   tmp0 = source
0153                                                   ;   tmp1 = destination
0154                                                   ;   tmp2 = bytes to copy
0155 7A06 A820  54         a     @rambuf+4,@edb.next_free
     7A08 8394 
     7A0A 2308 
0156                                                   ; Update pointer to next free block
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               edb.line.pack.$$:
0161 7A0C C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7A0E 8390 
     7A10 220C 
0162 7A12 0460  28         b     @poprt                ; Return to caller
     7A14 60C8 
0163               
0164               
0165               ***************************************************************
0166               * edb.line.unpack
0167               * Unpack specified line to framebuffer
0168               ***************************************************************
0169               *  bl   @edb.line.unpack
0170               *--------------------------------------------------------------
0171               * INPUT
0172               * @parm1 = Line to unpack from editor buffer
0173               * @parm2 = Target row in frame buffer
0174               *--------------------------------------------------------------
0175               * OUTPUT
0176               * none
0177               *--------------------------------------------------------------
0178               * Register usage
0179               * tmp0,tmp1,tmp2
0180               *--------------------------------------------------------------
0181               * Memory usage
0182               * rambuf   = Saved @parm1 of edb.line.unpack
0183               * rambuf+2 = Saved @parm2 of edb.line.unpack
0184               * rambuf+4 = Source memory address in editor buffer
0185               * rambuf+6 = Destination memory address in frame buffer
0186               * rambuf+8 = Length of unpacked line
0187               ********@*****@*********************@**************************
0188               edb.line.unpack:
0189 7A16 0649  14         dect  stack
0190 7A18 C64B  30         mov   r11,*stack            ; Save return address
0191                       ;------------------------------------------------------
0192                       ; Save parameters
0193                       ;------------------------------------------------------
0194 7A1A C820  54         mov   @parm1,@rambuf
     7A1C 8350 
     7A1E 8390 
0195 7A20 C820  54         mov   @parm2,@rambuf+2
     7A22 8352 
     7A24 8392 
0196                       ;------------------------------------------------------
0197                       ; Calculate offset in frame buffer
0198                       ;------------------------------------------------------
0199 7A26 C120  34         mov   @fb.colsline,tmp0
     7A28 220E 
0200 7A2A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7A2C 8352 
0201 7A2E C1A0  34         mov   @fb.top.ptr,tmp2
     7A30 2200 
0202 7A32 A146  18         a     tmp2,tmp1             ; Add base to offset
0203 7A34 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7A36 8396 
0204                       ;------------------------------------------------------
0205                       ; Get length of line to unpack
0206                       ;------------------------------------------------------
0207 7A38 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7A3A 7A92 
0208                                                   ; parm1 = Line number
0209 7A3C C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7A3E 8360 
     7A40 8398 
0210                       ;------------------------------------------------------
0211                       ; Index. Calculate address of entry and get pointer
0212                       ;------------------------------------------------------
0213 7A42 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     7A44 7938 
0214                                                   ; parm1 = Line number
0215 7A46 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address in editor buffer
     7A48 8360 
     7A4A 8394 
0216                       ;------------------------------------------------------
0217                       ; Clear end of future row in framebuffer
0218                       ;------------------------------------------------------
0219               edb.line.unpack.clear:
0220 7A4C C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7A4E 8396 
0221 7A50 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7A52 8398 
0222 7A54 4120  34         szc   @wbit1,tmp0           ; (1) Make address even (faster fill MOV)
     7A56 6044 
0223 7A58 04C5  14         clr   tmp1                  ; Fill with >00
0224 7A5A C1A0  34         mov   @fb.colsline,tmp2
     7A5C 220E 
0225 7A5E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7A60 8398 
0226 7A62 0586  14         inc   tmp2                  ; Compensate due to (1)
0227 7A64 06A0  32         bl    @xfilm                ; Clear rest of row
     7A66 60D2 
0228                       ;------------------------------------------------------
0229                       ; Copy line from editor buffer to frame buffer
0230                       ;------------------------------------------------------
0231               edb.line.unpack.copy:
0232 7A68 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7A6A 8394 
0233                                                   ; or line content itself if line length <= 2.
0234               
0235 7A6C C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7A6E 8396 
0236 7A70 C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     7A72 8398 
0237                       ;------------------------------------------------------
0238                       ; Special treatment for lines with length <= 2
0239                       ;------------------------------------------------------
0240 7A74 130C  14         jeq   edb.line.unpack.$$    ; Exit if length = 0
0241 7A76 0286  22         ci    tmp2,2
     7A78 0002 
0242 7A7A 1306  14         jeq   edb.line.unpack.copy.word
0243 7A7C 0286  22         ci    tmp2,1
     7A7E 0001 
0244 7A80 1305  14         jeq   edb.line.unpack.copy.byte
0245                       ;------------------------------------------------------
0246                       ; Copy memory block
0247                       ;------------------------------------------------------
0248 7A82 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7A84 62E8 
0249                                                   ;   tmp0 = Source address
0250                                                   ;   tmp1 = Target address
0251                                                   ;   tmp2 = Bytes to copy
0252 7A86 1003  14         jmp   edb.line.unpack.$$
0253                       ;------------------------------------------------------
0254                       ; Copy single word (could be on uneven address!)
0255                       ;------------------------------------------------------
0256               edb.line.unpack.copy.word:
0257 7A88 C544  30         mov   tmp0,*tmp1            ; Copy word
0258 7A8A 1001  14         jmp   edb.line.unpack.$$
0259               edb.line.unpack.copy.byte:
0260 7A8C DD44  32         movb  tmp0,*tmp1+           ; Copy byte
0261                       ;------------------------------------------------------
0262                       ; Exit
0263                       ;------------------------------------------------------
0264               edb.line.unpack.$$:
0265 7A8E 0460  28         b     @poprt                ; Return to caller
     7A90 60C8 
0266               
0267               
0268               
0269               
0270               ***************************************************************
0271               * edb.line.getlength
0272               * Get length of specified line
0273               ***************************************************************
0274               *  bl   @edb.line.getlength
0275               *--------------------------------------------------------------
0276               * INPUT
0277               * @parm1 = Line number
0278               *--------------------------------------------------------------
0279               * OUTPUT
0280               * @outparm1 = Length of line
0281               *--------------------------------------------------------------
0282               * Register usage
0283               * tmp0,tmp1
0284               ********@*****@*********************@**************************
0285               edb.line.getlength:
0286 7A92 0649  14         dect  stack
0287 7A94 C64B  30         mov   r11,*stack            ; Save return address
0288                       ;------------------------------------------------------
0289                       ; Get length
0290                       ;------------------------------------------------------
0291 7A96 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7A98 220C 
     7A9A 8390 
0292 7A9C C120  34         mov   @parm1,tmp0           ; Get specified line
     7A9E 8350 
0293 7AA0 0A24  56         sla   tmp0,2                ; Line number * 4
0294 7AA2 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7AA4 3002 
0295 7AA6 0245  22         andi  tmp1,>00ff            ; Get rid of packed length
     7AA8 00FF 
0296 7AAA C805  38         mov   tmp1,@outparm1        ; Save line length
     7AAC 8360 
0297                       ;------------------------------------------------------
0298                       ; Exit
0299                       ;------------------------------------------------------
0300               edb.line.getlength.$$:
0301 7AAE 0460  28         b     @poprt                ; Return to caller
     7AB0 60C8 
0302               
0303               
0304               
0305               
0306               ***************************************************************
0307               * edb.line.getlength2
0308               * Get length of current row (as seen from editor buffer side)
0309               ***************************************************************
0310               *  bl   @edb.line.getlength2
0311               *--------------------------------------------------------------
0312               * INPUT
0313               * @fb.row = Row in frame buffer
0314               *--------------------------------------------------------------
0315               * OUTPUT
0316               * @fb.row.length = Length of row
0317               *--------------------------------------------------------------
0318               * Register usage
0319               * tmp0,tmp1
0320               ********@*****@*********************@**************************
0321               edb.line.getlength2:
0322 7AB2 0649  14         dect  stack
0323 7AB4 C64B  30         mov   r11,*stack            ; Save return address
0324                       ;------------------------------------------------------
0325                       ; Get length
0326                       ;------------------------------------------------------
0327 7AB6 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7AB8 220C 
     7ABA 8390 
0328 7ABC C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7ABE 2204 
0329 7AC0 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7AC2 2206 
0330 7AC4 0A24  56         sla   tmp0,2                ; Line number * 4
0331 7AC6 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7AC8 3002 
0332 7ACA 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7ACC 00FF 
0333 7ACE C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7AD0 2208 
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               edb.line.getlength2.$$:
0338 7AD2 0460  28         b     @poprt                ; Return to caller
     7AD4 60C8 
0339               
**** **** ****     > tivi.asm.28024
0597               
0598               
0599               ***************************************************************
0600               *               fh - File handling module
0601               ***************************************************************
0602                       copy  "filehandler.asm"
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
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0, tmp1, tmp2, tmp4
0022               *--------------------------------------------------------------
0023               * Memory usage
0024               ********@*****@*********************@**************************
0025               tfh.file.read:
0026 7AD6 0649  14         dect  stack
0027 7AD8 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialisation
0030                       ;------------------------------------------------------
0031 7ADA 04E0  34         clr   @tfh.records          ; Reset records counter
     7ADC 242E 
0032 7ADE 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7AE0 2434 
0033 7AE2 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7AE4 2432 
0034 7AE6 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0035 7AE8 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7AEA 242A 
0036 7AEC 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7AEE 242C 
0037                       ;------------------------------------------------------
0038                       ; Show loading indicator and file descriptor
0039                       ;------------------------------------------------------
0040 7AF0 06A0  32         bl    @hchar
     7AF2 6468 
0041 7AF4 1D00                   byte 29,0,32,80
     7AF6 2050 
0042 7AF8 FFFF                   data EOL
0043               
0044 7AFA 06A0  32         bl    @putat
     7AFC 6292 
0045 7AFE 1D00                   byte 29,0
0046 7B00 7C90                   data txt_loading      ; Display "Loading...."
0047               
0048 7B02 06A0  32         bl    @at
     7B04 6374 
0049 7B06 1D0B                   byte 29,11            ; Cursor YX position
0050 7B08 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7B0A 8350 
0051 7B0C 06A0  32         bl    @xutst0               ; Display device/filename
     7B0E 6282 
0052               
0053                       ;------------------------------------------------------
0054                       ; Copy PAB header to VDP
0055                       ;------------------------------------------------------
0056 7B10 06A0  32         bl    @cpym2v
     7B12 629A 
0057 7B14 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7B16 7C54 
     7B18 0009 
0058                                                   ; Copy PAB header to VDP
0059                       ;------------------------------------------------------
0060                       ; Append file descriptor to PAB header in VDP
0061                       ;------------------------------------------------------
0062 7B1A 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7B1C 0A69 
0063 7B1E C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7B20 8350 
0064 7B22 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0065 7B24 0986  56         srl   tmp2,8                ; Right justify
0066 7B26 0586  14         inc   tmp2                  ; Include length byte as well
0067 7B28 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7B2A 62A0 
0068                       ;------------------------------------------------------
0069                       ; Load GPL scratchpad layout
0070                       ;------------------------------------------------------
0071 7B2C 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7B2E 6C74 
0072 7B30 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0073                       ;------------------------------------------------------
0074                       ; Open file
0075                       ;------------------------------------------------------
0076 7B32 06A0  32         bl    @file.open
     7B34 6DC2 
0077 7B36 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0078 7B38 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7B3A 6042 
0079 7B3C 1367  14         jeq   tfh.file.read.error
0080                                                   ; Yes, IO error occured
0081                       ;------------------------------------------------------
0082                       ; Read file record
0083                       ;------------------------------------------------------
0084               tfh.file.read.record:
0085 7B3E 05A0  34         inc   @tfh.records          ; Update counter
     7B40 242E 
0086 7B42 04E0  34         clr   @tfh.reclen           ; Reset record length
     7B44 2430 
0087               
0088 7B46 06A0  32         bl    @file.record.read     ; Read record
     7B48 6E04 
0089 7B4A 0A60                   data tfh.vpab         ; tmp0=Status byte
0090                                                   ; tmp1=Bytes read
0091                                                   ; tmp2=Status register contents upon DSRLNK return
0092               
0093 7B4C C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7B4E 242A 
0094 7B50 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7B52 2430 
0095 7B54 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7B56 242C 
0096                       ;------------------------------------------------------
0097                       ; Calculate kilobytes processed
0098                       ;------------------------------------------------------
0099 7B58 A805  38         a     tmp1,@tfh.counter
     7B5A 2434 
0100 7B5C A160  34         a     @tfh.counter,tmp1
     7B5E 2434 
0101 7B60 0285  22         ci    tmp1,1024
     7B62 0400 
0102 7B64 1106  14         jlt   !
0103 7B66 05A0  34         inc   @tfh.kilobytes
     7B68 2432 
0104 7B6A 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7B6C FC00 
0105 7B6E C805  38         mov   tmp1,@tfh.counter
     7B70 2434 
0106                       ;------------------------------------------------------
0107                       ; Load spectra scratchpad layout
0108                       ;------------------------------------------------------
0109 7B72 06A0  32 !       bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7B74 6670 
0110 7B76 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7B78 6C96 
0111 7B7A 2100                   data scrpad.backup2   ; / >2100->8300
0112                       ;------------------------------------------------------
0113                       ; Check if a file error occured
0114                       ;------------------------------------------------------
0115               tfh.file.read.check:
0116 7B7C C1A0  34         mov   @tfh.ioresult,tmp2
     7B7E 242C 
0117 7B80 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7B82 6042 
0118 7B84 1343  14         jeq   tfh.file.read.error
0119                                                   ; Yes, so handle file error
0120                       ;------------------------------------------------------
0121                       ; Prepare for copying record from VDP
0122                       ;------------------------------------------------------
0123 7B86 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7B88 2430 
0124               
0125 7B8A 131B  14         jeq   tfh.file.read.emptyline
0126                                                   ; Special handling for empty line
0127               
0128 7B8C 0286  22         ci    tmp2,2                ; Check line length
     7B8E 0002 
0129 7B90 1503  14         jgt   tfh.file.read.addline.normal
0130                       ;------------------------------------------------------
0131                       ; Handle line with length <= 2
0132                       ;------------------------------------------------------
0133 7B92 0205  20         li    tmp1,parm2            ; Store line content in @parm2 itself
     7B94 8352 
0134 7B96 1008  14         jmp   tfh.file.read.addline.vcopy
0135                       ;------------------------------------------------------
0136                       ; Handle line with length > 2
0137                       ;------------------------------------------------------
0138               tfh.file.read.addline.normal:
0139 7B98 C160  34         mov   @edb.next_free,tmp1   ; RAM target address in editor buffer
     7B9A 2308 
0140 7B9C C820  54         mov   @edb.next_free,@parm2 ; parm2 = Pointer to line in editor buffer
     7B9E 2308 
     7BA0 8352 
0141 7BA2 A820  54         a     @tfh.reclen,@edb.next_free
     7BA4 2430 
     7BA6 2308 
0142                                                   ; Update pointer to next free line
0143                       ;------------------------------------------------------
0144                       ; Copy record from VDP record buffer to editor buffer
0145                       ;------------------------------------------------------
0146               tfh.file.read.addline.vcopy:
0147 7BA8 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7BAA 0960 
0148 7BAC 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7BAE 62C6 
0149                                                   ;   tmp0 = VDP source address
0150                                                   ;   tmp1 = RAM target address
0151                                                   ;   tmp2 = Bytes to copy
0152                       ;------------------------------------------------------
0153                       ; Prepare for index update
0154                       ;------------------------------------------------------
0155               tfh.file.read.prepindex:
0156 7BB0 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7BB2 242E 
     7BB4 8350 
0157 7BB6 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7BB8 8350 
0158                                                   ; parm2 = Already set
0159 7BBA C820  54         mov   @tfh.reclen,@parm3    ; parm3 = Line length
     7BBC 2430 
     7BBE 8354 
0160 7BC0 1009  14         jmp   tfh.file.read.updindex
0161                                                   ; Update index
0162                       ;------------------------------------------------------
0163                       ; Special handling for empty line
0164                       ;------------------------------------------------------
0165               tfh.file.read.emptyline:
0166 7BC2 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7BC4 242E 
     7BC6 8350 
0167 7BC8 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7BCA 8350 
0168 7BCC 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7BCE 8352 
0169 7BD0 04E0  34         clr   @parm3                ; parm3 = Line length
     7BD2 8354 
0170                       ;------------------------------------------------------
0171                       ; Update index
0172                       ;------------------------------------------------------
0173               tfh.file.read.updindex:
0174 7BD4 06A0  32         bl    @idx.entry.update     ; Update index
     7BD6 789C 
0175                                                   ;   parm1 = Line number in editor buffer
0176                                                   ;   parm2 = Pointer to line in editor buffer
0177                                                   ;           (or line content if length <= 2)
0178                                                   ;   parm3 = Length of line
0179               
0180 7BD8 05A0  34         inc   @edb.lines            ; lines=lines+1
     7BDA 2304 
0181                       ;------------------------------------------------------
0182                       ; Display results
0183                       ;------------------------------------------------------
0184               tfh.file.read.display:
0185 7BDC 8220  34         c     @tfh.kilobytes,tmp4
     7BDE 2432 
0186 7BE0 130C  14         jeq   tfh.file.read.checkmem
0187               
0188 7BE2 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7BE4 2432 
0189               
0190 7BE6 06A0  32         bl    @putnum
     7BE8 6666 
0191 7BEA 1D38                   byte 29,56            ; Show kilobytes read
0192 7BEC 2432                   data tfh.kilobytes,rambuf,>3020
     7BEE 8390 
     7BF0 3020 
0193               
0194 7BF2 06A0  32         bl    @putat
     7BF4 6292 
0195 7BF6 1D3D                   byte 29,61
0196 7BF8 7C9C                   data txt_kb           ; Show "kb" string
0197               
0198               ******************************************************
0199               * Stop reading file if high memory expansion gets full
0200               ******************************************************
0201               tfh.file.read.checkmem:
0202 7BFA C120  34         mov   @edb.next_free,tmp0
     7BFC 2308 
0203 7BFE 0284  22         ci    tmp0,>ffa0
     7C00 FFA0 
0204 7C02 150C  14         jgt   tfh.file.read.eof
0205                       ;------------------------------------------------------
0206                       ; Next record
0207                       ;------------------------------------------------------
0208 7C04 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7C06 6C74 
0209 7C08 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0210               
0211 7C0A 1099  14         jmp   tfh.file.read.record
0212                                                   ; Next record
0213                       ;------------------------------------------------------
0214                       ; Error handler
0215                       ;------------------------------------------------------
0216               tfh.file.read.error:
0217 7C0C C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7C0E 242A 
0218 7C10 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0219 7C12 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7C14 0005 
0220 7C16 1302  14         jeq   tfh.file.read.eof
0221                                                   ; All good. File closed by DSRLNK
0222 7C18 0460  28         b     @crash_handler        ; A File error occured. System crashed
     7C1A 604C 
0223                       ;------------------------------------------------------
0224                       ; End-Of-File reached
0225                       ;------------------------------------------------------
0226               tfh.file.read.eof:
0227 7C1C 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7C1E 6C96 
0228 7C20 2100                   data scrpad.backup2   ; / >2100->8300
0229                       ;------------------------------------------------------
0230                       ; Display final results
0231                       ;------------------------------------------------------
0232 7C22 06A0  32         bl    @hchar
     7C24 6468 
0233 7C26 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7C28 200A 
0234 7C2A FFFF                   data EOL
0235               
0236 7C2C 06A0  32         bl    @putnum
     7C2E 6666 
0237 7C30 1D38                   byte 29,56            ; Show kilobytes read
0238 7C32 2432                   data tfh.kilobytes,rambuf,>3020
     7C34 8390 
     7C36 3020 
0239               
0240 7C38 06A0  32         bl    @putat
     7C3A 6292 
0241 7C3C 1D3D                   byte 29,61
0242 7C3E 7C9C                   data txt_kb           ; Show "kb" string
0243               
0244 7C40 06A0  32         bl    @putnum
     7C42 6666 
0245 7C44 1D49                   byte 29,73            ; Show lines read
0246 7C46 242E                   data tfh.records,rambuf,>3020
     7C48 8390 
     7C4A 3020 
0247               
0248 7C4C 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7C4E 2306 
0249               *--------------------------------------------------------------
0250               * Exit
0251               *--------------------------------------------------------------
0252               tfh.file.read_exit:
0253 7C50 0460  28         b     @poprt                ; Return to caller
     7C52 60C8 
0254               
0255               
0256               ***************************************************************
0257               * PAB for accessing DV/80 file
0258               ********@*****@*********************@**************************
0259               tfh.file.pab.header:
0260 7C54 0014             byte  io.op.open            ;  0    - OPEN
0261                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0262 7C56 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0263 7C58 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0264                       byte  00                    ;  5    - Character count
0265 7C5A 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0266 7C5C 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0267                       ;------------------------------------------------------
0268                       ; File descriptor part (variable length)
0269                       ;------------------------------------------------------
0270                       ; byte  12                  ;  9    - File descriptor length
0271                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.28024
0603               
0604               
0605               ***************************************************************
0606               *                      Constants
0607               ***************************************************************
0608               romsat:
0609 7C5E 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7C60 000F 
0610               
0611               cursors:
0612 7C62 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7C64 0000 
     7C66 0000 
     7C68 001C 
0613 7C6A 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7C6C 1010 
     7C6E 1010 
     7C70 1000 
0614 7C72 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7C74 1C1C 
     7C76 1C1C 
     7C78 1C00 
0615               
0616               ***************************************************************
0617               *                       Strings
0618               ***************************************************************
0619               txt_delim
0620 7C7A 012C             byte  1
0621 7C7B ....             text  ','
0622                       even
0623               
0624               txt_marker
0625 7C7C 052A             byte  5
0626 7C7D ....             text  '*EOF*'
0627                       even
0628               
0629               txt_bottom
0630 7C82 0520             byte  5
0631 7C83 ....             text  '  BOT'
0632                       even
0633               
0634               txt_ovrwrite
0635 7C88 034F             byte  3
0636 7C89 ....             text  'OVR'
0637                       even
0638               
0639               txt_insert
0640 7C8C 0349             byte  3
0641 7C8D ....             text  'INS'
0642                       even
0643               
0644               txt_loading
0645 7C90 0A4C             byte  10
0646 7C91 ....             text  'Loading...'
0647                       even
0648               
0649               txt_kb
0650 7C9C 026B             byte  2
0651 7C9D ....             text  'kb'
0652                       even
0653               
0654               txt_lines
0655 7CA0 054C             byte  5
0656 7CA1 ....             text  'Lines'
0657                       even
0658               
0659 7CA6 7CA6     end          data    $
0660               
0661               
0662               fdname0
0663 7CA8 0A44             byte  10
0664 7CA9 ....             text  'DSK3.CONIO'
0665                       even
0666               
0667               fdname1
0668 7CB4 0F44             byte  15
0669 7CB5 ....             text  'DSK1.SPEECHDOCS'
0670                       even
0671               
0672               fdname2
0673 7CC4 0C44             byte  12
0674 7CC5 ....             text  'DSK1.XBEADOC'
0675                       even
0676               
0677               fdname3
0678 7CD2 0C44             byte  12
0679 7CD3 ....             text  'DSK3.XBEADOC'
0680                       even
0681               
0682               fdname4
0683 7CE0 0C44             byte  12
0684 7CE1 ....             text  'DSK3.C99MAN1'
0685                       even
0686               
0687               fdname5
0688 7CEE 0C44             byte  12
0689 7CEF ....             text  'DSK3.C99MAN2'
0690                       even
0691               
0692               fdname6
0693 7CFC 0C44             byte  12
0694 7CFD ....             text  'DSK3.C99MAN3'
0695                       even
0696               
0697               fdname7
0698 7D0A 0D44             byte  13
0699 7D0B ....             text  'DSK3.C99SPECS'
0700                       even
0701               
0702               fdname8
0703 7D18 0D44             byte  13
0704 7D19 ....             text  'DSK3.RANDOM#C'
0705                       even
0706               
0707               fdname9
0708 7D26 0D44             byte  13
0709 7D27 ....             text  'DSK3.RNDTST#C'
0710                       even
0711               

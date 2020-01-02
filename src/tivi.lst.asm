XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.30645
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200102-30645
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
0025               * 3000-3fff    4096   >1000   Index
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
0139      230E     edb.end             equ  edb.top.ptr+14 ; Free from here on
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
0153      2436     tfh.membuffer   equ  tfh.top + 54   ; 80 bytes file memory buffer
0154      2486     tfh.end         equ  tfh.top + 134  ; Free from here on
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
0173               * Editor buffer                     @>a000-ffff   (24576 bytes)
0174               *--------------------------------------------------------------
0175      A000     edb.top         equ  >a000          ; Editor buffer high memory
0176      6000     edb.size        equ  24576          ; Editor buffer size
0177               *--------------------------------------------------------------
0178               
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
0191 6012 701C             data  runlib
0192               
0194               
0195 6014 1154             byte  17
0196 6015 ....             text  'TIVI 200102-30645'
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
0054               * skip_rle_compress         equ  1  ; Skip RLE compression functions
0055               * skip_rle_decompress       equ  1  ; Skip RLE decompression functions
0056               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0057               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0058               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0059               *
0060               * == Kernel/Multitasking
0061               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0062               * skip_mem_paging           equ  1  ; Skip support for memory paging
0063               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0064               *
0065               * == Startup behaviour
0066               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0067               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0068               *******************************************************************************
0069               
0070               *//////////////////////////////////////////////////////////////
0071               *                       RUNLIB SETUP
0072               *//////////////////////////////////////////////////////////////
0073               
0074                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
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
0075                       copy  "equ_registers.asm"        ; Equates for runlib registers
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
0076                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
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
0077                       copy  "equ_param.asm"            ; Equates for runlib parameters
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
0078               
0082               
0083                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
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
0084                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0085                       copy  "cpu_crash_handler.asm"    ; CPU program crashed handler
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
     605A 7024 
0019               
0020               crash_handler.main:
0021 605C 06A0  32         bl    @putat                ; Show crash message
     605E 6292 
0022 6060 0000             data  >0000,crash_handler.message
     6062 6068 
0023 6064 0460  28         b     @tmgr                 ; FNCTN-+ to quit
     6066 6F32 
0024               
0025               crash_handler.message:
0026 6068 2553             byte  37
0027 6069 ....             text  'System crashed. Press FNCTN-+ to quit'
0028               
0029               
**** **** ****     > runlib.asm
0086                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0087                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0088               
0090                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0092               
0094                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0096               
0098                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0100               
0104               
0108               
0110                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
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
0112               
0114                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0116               
0118                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0120               
0122                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0124               
0128               
0132               
0134                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0136               
0138                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0140               
0144               
0148               
0152               
0156               
0160               
0164               
0168               
0170                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0172               
0176               
0178                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0180               
0184               
0186                       copy  "rle_compress.asm"         ; RLE compression support
**** **** ****     > rle_compress.asm
0001               * FILE......: rle_compress.asm
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
0036               *  Implementation workflow:
0037               *  (1) Scan string from left to right:
0038               *      (1.1) Compare lookahead char with current char
0039               *      (1.2) If it's not a repeated character:
0040               *            (1.2.1) Check if any pending repeated character
0041               *            (1.2.2) If yes, flush pending to output buffer (=RLE encode)
0042               *            (1.2.3) Track address of future encoding byte
0043               *            (1.2.4) Append data byte to output buffer and jump to (2)
0044               *
0045               *      (1.3) If it's a repeated character:
0046               *            (1.3.1) Check if any pending non-repeated character
0047               *            (1.3.2) If yes, set encoding byte before first data byte
0048               *            (1.3.3) Increase repetition counter and jump to (2)
0049               *
0050               *  (2) Process next character
0051               *      (2.1) Jump back to (1.1) unless end of string reached
0052               *
0053               *  (3) End of string reached:
0054               *      (3.1) Check if pending repeated character
0055               *      (3.2) If yes, flush to output buffer (=RLE encode) and exit
0056               *      (3.3) Check if pending non-repeated character
0057               *      (3.4) If yes, set encoding byte before first data byte
0058               *
0059               *  (4) Exit
0060               *--------------------------------------------------------------
0061               
0062               
0063               ********@*****@*********************@**************************
0064               cpu2rle:
0065 6670 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0066 6672 C17B  30         mov   *r11+,tmp1            ; RAM target address
0067 6674 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0068               xcpu2rle:
0069 6676 C80B  38         mov   r11,@waux3            ; Save return address
     6678 8340 
0070               *--------------------------------------------------------------
0071               *   Initialisation
0072               *--------------------------------------------------------------
0073               cup2rle.init:
0074 667A 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0075 667C 04C8  14         clr   tmp4                  ; Repetition counter
0076 667E 04E0  34         clr   @waux1                ; Length of RLE string
     6680 833C 
0077 6682 04E0  34         clr   @waux2                ; Address of encoding byte
     6684 833E 
0078               *--------------------------------------------------------------
0079               *   (1.1) Scan string
0080               *--------------------------------------------------------------
0081               cpu2rle.scan:
0082 6686 0987  56         srl   tmp3,8                ; Save old character in LSB
0083 6688 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0084 668A 91D4  26         cb    *tmp0,tmp3            ; Compare lookahead with current
0085 668C 130F  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0086               *--------------------------------------------------------------
0087               *   (1.2) No duplicate
0088               *--------------------------------------------------------------
0089               cpu2rle.scan.nodup:
0090                       ;------------------------------------------------------
0091                       ; (1.2.1) First check if any pending duplicates
0092                       ;------------------------------------------------------
0093 668E C208  18         mov   tmp4,tmp4
0094 6690 1613  14         jne   cpu2rle.scan.flush_dup
0095                                                   ; Yes, flush pending duplicates
0096                       ;------------------------------------------------------
0097                       ; (1.2.3) Track address of encoding byte
0098                       ;------------------------------------------------------
0099               cpu2rle.scan.nodup.rest:
0100 6692 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     6694 833E 
     6696 833E 
0101 6698 1605  14         jne   !                     ; / Yes, so don't fetch again!
0102               
0103 669A C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     669C 833E 
0104 669E 0585  14         inc   tmp1                  ; Skip encoding byte
0105 66A0 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     66A2 833C 
0106                       ;------------------------------------------------------
0107                       ; (1.2.4) Write data byte to output buffer
0108                       ;------------------------------------------------------
0109 66A4 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0110 66A6 05A0  34         inc   @waux1                ; RLE string length += 1
     66A8 833C 
0111 66AA 101A  14         jmp   cpu2rle.scan.next     ; Next character
0112               *--------------------------------------------------------------
0113               *   (1.3) Duplicate
0114               *--------------------------------------------------------------
0115               cpu2rle.scan.dup:
0116                       ;------------------------------------------------------
0117                       ; (1.3.1) First check if any pending non-duplicates
0118                       ;------------------------------------------------------
0119 66AC C820  54         mov   @waux2,@waux2
     66AE 833E 
     66B0 833E 
0120 66B2 160B  14         jne   cpu2rle.scan.flush_nodup
0121                                                   ; Set encoding byte before 1st data byte
0122                       ;------------------------------------------------------
0123                       ; (1.3.3) Now process duplicate character
0124                       ;------------------------------------------------------
0125               cpu2rle.scan.dup.rest:
0126 66B4 0588  14         inc   tmp4                  ; Increase repetition counter
0127 66B6 1014  14         jmp   cpu2rle.scan.next     ; Scan next character
0128               
0129               
0130               *--------------------------------------------------------------
0131               *   (1.2.2) Flush duplicate to output buffer (=RLE encode)
0132               *--------------------------------------------------------------
0133               cpu2rle.scan.flush_dup:
0134 66B8 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0135 66BA 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0136 66BC 0268  22         ori   tmp4,8000             ; Set high bit in MSB
     66BE 1F40 
0137 66C0 CD48  34         mov   tmp4,*tmp1+           ; RLE word to output buffer
0138 66C2 04C8  14         clr   tmp4                  ; Reset repetition counter
0139 66C4 05E0  34         inct  @waux1                ; RLE string length += 2
     66C6 833C 
0140 66C8 10E4  14         jmp   cpu2rle.scan.nodup.rest
0141               *--------------------------------------------------------------
0142               *   (1.3.2) Set encoding byte before first data byte
0143               *--------------------------------------------------------------
0144               cpu2rle.scan.flush_nodup:
0145 66CA C205  18         mov   tmp1,tmp4             ; \ Calculate length of non-repeated
0146 66CC 6220  34         s     @waux2,tmp4           ; | characters. Short on registers
     66CE 833E 
0147 66D0 0608  14         dec   tmp4                  ; / so abusing tmp4
0148               
0149 66D2 0A88  56         sla   tmp4,8                ; \
0150 66D4 D808  38         movb  tmp4,@waux2           ; / Set encoding byte
     66D6 833E 
0151               
0152 66D8 04E0  34         clr   @waux2                ; Reset address of encoding byte
     66DA 833E 
0153 66DC 04C8  14         clr   tmp4                  ; Clear before using again
0154 66DE 10EA  14         jmp   cpu2rle.scan.dup.rest
0155               
0156               *--------------------------------------------------------------
0157               *   (2) Next character
0158               *--------------------------------------------------------------
0159               cpu2rle.scan.next:
0160 66E0 0606  14         dec   tmp2
0161 66E2 15D1  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0162               *--------------------------------------------------------------
0163               *   (3) End of string reached
0164               *--------------------------------------------------------------
0165               cpu2rle.eos.pending_dup:
0166                       ;------------------------------------------------------
0167                       ; (3.1) End of string. Pending duplicates left?
0168                       ;------------------------------------------------------
0169 66E4 C208  18         mov   tmp4,tmp4             ; Duplicates left?
0170 66E6 1308  14         jeq   cpu2rle.eos.pending_nodup
0171                                                   ; No, check no-duplicates
0172                       ;------------------------------------------------------
0173                       ; (3.2) Yes, flush pending duplicates to output buffer
0174                       ;------------------------------------------------------
0175               cpu2rle.eos.flush_dup:
0176 66E8 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0177 66EA 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0178 66EC 0268  22         ori   tmp4,8000             ; Set high bit in MSB
     66EE 1F40 
0179 66F0 CD48  34         mov   tmp4,*tmp1+           ; RLE encoded to output buffer
0180 66F2 05E0  34         inct  @waux1                ; RLE string length += 2
     66F4 833C 
0181 66F6 100B  14         jmp   cpu2rle.$$            ; Exit
0182                       ;------------------------------------------------------
0183                       ; (3.3) End of string. Pending non-duplicates left?
0184                       ;------------------------------------------------------
0185               cpu2rle.eos.pending_nodup:
0186 66F8 C820  54         mov   @waux2,@waux2
     66FA 833E 
     66FC 833E 
0187 66FE 1307  14         jeq   cpu2rle.$$            ; No, so exit
0188                       ;------------------------------------------------------
0189                       ; (3.4) Yes, Set encoding byte before first data byte
0190                       ;------------------------------------------------------
0191 6700 C205  18         mov   tmp1,tmp4             ; \ Calculate length of non-repeated
0192 6702 6220  34         s     @waux2,tmp4           ; | characters. Short on registers
     6704 833E 
0193 6706 0608  14         dec   tmp4                  ; / so abusing tmp4
0194               
0195 6708 0A88  56         sla   tmp4,8                ; \
0196 670A D808  38         movb  tmp4,@waux2           ; / Set encoding byte
     670C 833E 
0197               *--------------------------------------------------------------
0198               *   (4) Exit
0199               *--------------------------------------------------------------
0200               cpu2rle.$$:
0201 670E C2E0  34         mov   @waux3,r11            ; Get return address
     6710 8340 
0202 6712 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0188               
0190                       copy  "rle_decompress.asm"       ; RLE decompression support
**** **** ****     > rle_decompress.asm
0001               * FILE......: rle_decompress.asm
0002               * Purpose...: RLE decompression support
0003               
0004               ***************************************************************
0005               * RLE2V - RLE decompress to VRAM memory
0006               ***************************************************************
0007               *  BL   @RLE2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = ROM/RAM source address
0011               *  P1 = VDP target address
0012               *  P2 = Length of RLE encoded data
0013               *--------------------------------------------------------------
0014               *  BL @RLE2VX
0015               *
0016               *  TMP0     = VDP target address
0017               *  TMP2 (!) = ROM/RAM source address
0018               *  TMP3 (!) = Length of RLE encoded data
0019               *--------------------------------------------------------------
0020               *  Detail on RLE compression format:
0021               *  - If high bit is set, remaining 7 bits indicate to copy
0022               *    the next byte that many times.
0023               *  - If high bit is clear, remaining 7 bits indicate how many
0024               *    data bytes (non-repeated) follow.
0025               ********@*****@*********************@**************************
0026 6714 C1BB  30 rle2v   mov   *r11+,tmp2            ; ROM/RAM source address
0027 6716 C13B  30         mov   *r11+,tmp0            ; VDP target address
0028 6718 C1FB  30         mov   *r11+,tmp3            ; Length of RLE encoded data
0029 671A C80B  38         mov   r11,@waux1            ; Save return address
     671C 833C 
0030 671E 06A0  32 rle2vx  bl    @vdwa                 ; Setup VDP address from TMP0
     6720 6118 
0031 6722 C106  18         mov   tmp2,tmp0             ; We can safely reuse TMP0 now
0032 6724 D1B4  28 rle2v0  movb  *tmp0+,tmp2           ; Get control byte into TMP2
0033 6726 0607  14         dec   tmp3                  ; Update length
0034 6728 1314  14         jeq   rle2vz                ; End of list
0035 672A 0A16  56         sla   tmp2,1                ; Check bit 0 of control byte
0036 672C 1808  14         joc   rle2v2                ; Yes, next byte is compressed
0037               *--------------------------------------------------------------
0038               *    Dump uncompressed bytes
0039               *--------------------------------------------------------------
0040 672E C820  54 rle2v1  mov   @rledat,@mcloop       ; Setup machine code (MOVB *TMP0+,*R15)
     6730 6758 
     6732 8320 
0041 6734 0996  56         srl   tmp2,9                ; Use control byte as counter
0042 6736 61C6  18         s     tmp2,tmp3             ; Update length
0043 6738 06A0  32         bl    @mcloop               ; Write data to VDP
     673A 8320 
0044 673C 1008  14         jmp   rle2v3
0045               *--------------------------------------------------------------
0046               *    Dump compressed bytes
0047               *--------------------------------------------------------------
0048 673E C820  54 rle2v2  mov   @filzz,@mcloop        ; Setup machine code(MOVB TMP1,*R15)
     6740 6116 
     6742 8320 
0049 6744 0996  56         srl   tmp2,9                ; Use control byte as counter
0050 6746 0607  14         dec   tmp3                  ; Update length
0051 6748 D174  28         movb  *tmp0+,tmp1           ; Byte to fill
0052 674A 06A0  32         bl    @mcloop               ; Write data to VDP
     674C 8320 
0053               *--------------------------------------------------------------
0054               *    Check if more data to decompress
0055               *--------------------------------------------------------------
0056 674E C1C7  18 rle2v3  mov   tmp3,tmp3             ; Length counter = 0 ?
0057 6750 16E9  14         jne   rle2v0                ; Not yet, process data
0058               *--------------------------------------------------------------
0059               *    Exit
0060               *--------------------------------------------------------------
0061 6752 C2E0  34 rle2vz  mov   @waux1,r11
     6754 833C 
0062 6756 045B  20         b     *r11                  ; Return
0063 6758 D7F4     rledat  data  >d7f4                 ; MOVB *TMP0+,*R15
**** **** ****     > runlib.asm
0192               
0196               
0198                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0021 675A C820  54         mov   @>8300,@>2000
     675C 8300 
     675E 2000 
0022 6760 C820  54         mov   @>8302,@>2002
     6762 8302 
     6764 2002 
0023 6766 C820  54         mov   @>8304,@>2004
     6768 8304 
     676A 2004 
0024 676C C820  54         mov   @>8306,@>2006
     676E 8306 
     6770 2006 
0025 6772 C820  54         mov   @>8308,@>2008
     6774 8308 
     6776 2008 
0026 6778 C820  54         mov   @>830A,@>200A
     677A 830A 
     677C 200A 
0027 677E C820  54         mov   @>830C,@>200C
     6780 830C 
     6782 200C 
0028 6784 C820  54         mov   @>830E,@>200E
     6786 830E 
     6788 200E 
0029 678A C820  54         mov   @>8310,@>2010
     678C 8310 
     678E 2010 
0030 6790 C820  54         mov   @>8312,@>2012
     6792 8312 
     6794 2012 
0031 6796 C820  54         mov   @>8314,@>2014
     6798 8314 
     679A 2014 
0032 679C C820  54         mov   @>8316,@>2016
     679E 8316 
     67A0 2016 
0033 67A2 C820  54         mov   @>8318,@>2018
     67A4 8318 
     67A6 2018 
0034 67A8 C820  54         mov   @>831A,@>201A
     67AA 831A 
     67AC 201A 
0035 67AE C820  54         mov   @>831C,@>201C
     67B0 831C 
     67B2 201C 
0036 67B4 C820  54         mov   @>831E,@>201E
     67B6 831E 
     67B8 201E 
0037 67BA C820  54         mov   @>8320,@>2020
     67BC 8320 
     67BE 2020 
0038 67C0 C820  54         mov   @>8322,@>2022
     67C2 8322 
     67C4 2022 
0039 67C6 C820  54         mov   @>8324,@>2024
     67C8 8324 
     67CA 2024 
0040 67CC C820  54         mov   @>8326,@>2026
     67CE 8326 
     67D0 2026 
0041 67D2 C820  54         mov   @>8328,@>2028
     67D4 8328 
     67D6 2028 
0042 67D8 C820  54         mov   @>832A,@>202A
     67DA 832A 
     67DC 202A 
0043 67DE C820  54         mov   @>832C,@>202C
     67E0 832C 
     67E2 202C 
0044 67E4 C820  54         mov   @>832E,@>202E
     67E6 832E 
     67E8 202E 
0045 67EA C820  54         mov   @>8330,@>2030
     67EC 8330 
     67EE 2030 
0046 67F0 C820  54         mov   @>8332,@>2032
     67F2 8332 
     67F4 2032 
0047 67F6 C820  54         mov   @>8334,@>2034
     67F8 8334 
     67FA 2034 
0048 67FC C820  54         mov   @>8336,@>2036
     67FE 8336 
     6800 2036 
0049 6802 C820  54         mov   @>8338,@>2038
     6804 8338 
     6806 2038 
0050 6808 C820  54         mov   @>833A,@>203A
     680A 833A 
     680C 203A 
0051 680E C820  54         mov   @>833C,@>203C
     6810 833C 
     6812 203C 
0052 6814 C820  54         mov   @>833E,@>203E
     6816 833E 
     6818 203E 
0053 681A C820  54         mov   @>8340,@>2040
     681C 8340 
     681E 2040 
0054 6820 C820  54         mov   @>8342,@>2042
     6822 8342 
     6824 2042 
0055 6826 C820  54         mov   @>8344,@>2044
     6828 8344 
     682A 2044 
0056 682C C820  54         mov   @>8346,@>2046
     682E 8346 
     6830 2046 
0057 6832 C820  54         mov   @>8348,@>2048
     6834 8348 
     6836 2048 
0058 6838 C820  54         mov   @>834A,@>204A
     683A 834A 
     683C 204A 
0059 683E C820  54         mov   @>834C,@>204C
     6840 834C 
     6842 204C 
0060 6844 C820  54         mov   @>834E,@>204E
     6846 834E 
     6848 204E 
0061 684A C820  54         mov   @>8350,@>2050
     684C 8350 
     684E 2050 
0062 6850 C820  54         mov   @>8352,@>2052
     6852 8352 
     6854 2052 
0063 6856 C820  54         mov   @>8354,@>2054
     6858 8354 
     685A 2054 
0064 685C C820  54         mov   @>8356,@>2056
     685E 8356 
     6860 2056 
0065 6862 C820  54         mov   @>8358,@>2058
     6864 8358 
     6866 2058 
0066 6868 C820  54         mov   @>835A,@>205A
     686A 835A 
     686C 205A 
0067 686E C820  54         mov   @>835C,@>205C
     6870 835C 
     6872 205C 
0068 6874 C820  54         mov   @>835E,@>205E
     6876 835E 
     6878 205E 
0069 687A C820  54         mov   @>8360,@>2060
     687C 8360 
     687E 2060 
0070 6880 C820  54         mov   @>8362,@>2062
     6882 8362 
     6884 2062 
0071 6886 C820  54         mov   @>8364,@>2064
     6888 8364 
     688A 2064 
0072 688C C820  54         mov   @>8366,@>2066
     688E 8366 
     6890 2066 
0073 6892 C820  54         mov   @>8368,@>2068
     6894 8368 
     6896 2068 
0074 6898 C820  54         mov   @>836A,@>206A
     689A 836A 
     689C 206A 
0075 689E C820  54         mov   @>836C,@>206C
     68A0 836C 
     68A2 206C 
0076 68A4 C820  54         mov   @>836E,@>206E
     68A6 836E 
     68A8 206E 
0077 68AA C820  54         mov   @>8370,@>2070
     68AC 8370 
     68AE 2070 
0078 68B0 C820  54         mov   @>8372,@>2072
     68B2 8372 
     68B4 2072 
0079 68B6 C820  54         mov   @>8374,@>2074
     68B8 8374 
     68BA 2074 
0080 68BC C820  54         mov   @>8376,@>2076
     68BE 8376 
     68C0 2076 
0081 68C2 C820  54         mov   @>8378,@>2078
     68C4 8378 
     68C6 2078 
0082 68C8 C820  54         mov   @>837A,@>207A
     68CA 837A 
     68CC 207A 
0083 68CE C820  54         mov   @>837C,@>207C
     68D0 837C 
     68D2 207C 
0084 68D4 C820  54         mov   @>837E,@>207E
     68D6 837E 
     68D8 207E 
0085 68DA C820  54         mov   @>8380,@>2080
     68DC 8380 
     68DE 2080 
0086 68E0 C820  54         mov   @>8382,@>2082
     68E2 8382 
     68E4 2082 
0087 68E6 C820  54         mov   @>8384,@>2084
     68E8 8384 
     68EA 2084 
0088 68EC C820  54         mov   @>8386,@>2086
     68EE 8386 
     68F0 2086 
0089 68F2 C820  54         mov   @>8388,@>2088
     68F4 8388 
     68F6 2088 
0090 68F8 C820  54         mov   @>838A,@>208A
     68FA 838A 
     68FC 208A 
0091 68FE C820  54         mov   @>838C,@>208C
     6900 838C 
     6902 208C 
0092 6904 C820  54         mov   @>838E,@>208E
     6906 838E 
     6908 208E 
0093 690A C820  54         mov   @>8390,@>2090
     690C 8390 
     690E 2090 
0094 6910 C820  54         mov   @>8392,@>2092
     6912 8392 
     6914 2092 
0095 6916 C820  54         mov   @>8394,@>2094
     6918 8394 
     691A 2094 
0096 691C C820  54         mov   @>8396,@>2096
     691E 8396 
     6920 2096 
0097 6922 C820  54         mov   @>8398,@>2098
     6924 8398 
     6926 2098 
0098 6928 C820  54         mov   @>839A,@>209A
     692A 839A 
     692C 209A 
0099 692E C820  54         mov   @>839C,@>209C
     6930 839C 
     6932 209C 
0100 6934 C820  54         mov   @>839E,@>209E
     6936 839E 
     6938 209E 
0101 693A C820  54         mov   @>83A0,@>20A0
     693C 83A0 
     693E 20A0 
0102 6940 C820  54         mov   @>83A2,@>20A2
     6942 83A2 
     6944 20A2 
0103 6946 C820  54         mov   @>83A4,@>20A4
     6948 83A4 
     694A 20A4 
0104 694C C820  54         mov   @>83A6,@>20A6
     694E 83A6 
     6950 20A6 
0105 6952 C820  54         mov   @>83A8,@>20A8
     6954 83A8 
     6956 20A8 
0106 6958 C820  54         mov   @>83AA,@>20AA
     695A 83AA 
     695C 20AA 
0107 695E C820  54         mov   @>83AC,@>20AC
     6960 83AC 
     6962 20AC 
0108 6964 C820  54         mov   @>83AE,@>20AE
     6966 83AE 
     6968 20AE 
0109 696A C820  54         mov   @>83B0,@>20B0
     696C 83B0 
     696E 20B0 
0110 6970 C820  54         mov   @>83B2,@>20B2
     6972 83B2 
     6974 20B2 
0111 6976 C820  54         mov   @>83B4,@>20B4
     6978 83B4 
     697A 20B4 
0112 697C C820  54         mov   @>83B6,@>20B6
     697E 83B6 
     6980 20B6 
0113 6982 C820  54         mov   @>83B8,@>20B8
     6984 83B8 
     6986 20B8 
0114 6988 C820  54         mov   @>83BA,@>20BA
     698A 83BA 
     698C 20BA 
0115 698E C820  54         mov   @>83BC,@>20BC
     6990 83BC 
     6992 20BC 
0116 6994 C820  54         mov   @>83BE,@>20BE
     6996 83BE 
     6998 20BE 
0117 699A C820  54         mov   @>83C0,@>20C0
     699C 83C0 
     699E 20C0 
0118 69A0 C820  54         mov   @>83C2,@>20C2
     69A2 83C2 
     69A4 20C2 
0119 69A6 C820  54         mov   @>83C4,@>20C4
     69A8 83C4 
     69AA 20C4 
0120 69AC C820  54         mov   @>83C6,@>20C6
     69AE 83C6 
     69B0 20C6 
0121 69B2 C820  54         mov   @>83C8,@>20C8
     69B4 83C8 
     69B6 20C8 
0122 69B8 C820  54         mov   @>83CA,@>20CA
     69BA 83CA 
     69BC 20CA 
0123 69BE C820  54         mov   @>83CC,@>20CC
     69C0 83CC 
     69C2 20CC 
0124 69C4 C820  54         mov   @>83CE,@>20CE
     69C6 83CE 
     69C8 20CE 
0125 69CA C820  54         mov   @>83D0,@>20D0
     69CC 83D0 
     69CE 20D0 
0126 69D0 C820  54         mov   @>83D2,@>20D2
     69D2 83D2 
     69D4 20D2 
0127 69D6 C820  54         mov   @>83D4,@>20D4
     69D8 83D4 
     69DA 20D4 
0128 69DC C820  54         mov   @>83D6,@>20D6
     69DE 83D6 
     69E0 20D6 
0129 69E2 C820  54         mov   @>83D8,@>20D8
     69E4 83D8 
     69E6 20D8 
0130 69E8 C820  54         mov   @>83DA,@>20DA
     69EA 83DA 
     69EC 20DA 
0131 69EE C820  54         mov   @>83DC,@>20DC
     69F0 83DC 
     69F2 20DC 
0132 69F4 C820  54         mov   @>83DE,@>20DE
     69F6 83DE 
     69F8 20DE 
0133 69FA C820  54         mov   @>83E0,@>20E0
     69FC 83E0 
     69FE 20E0 
0134 6A00 C820  54         mov   @>83E2,@>20E2
     6A02 83E2 
     6A04 20E2 
0135 6A06 C820  54         mov   @>83E4,@>20E4
     6A08 83E4 
     6A0A 20E4 
0136 6A0C C820  54         mov   @>83E6,@>20E6
     6A0E 83E6 
     6A10 20E6 
0137 6A12 C820  54         mov   @>83E8,@>20E8
     6A14 83E8 
     6A16 20E8 
0138 6A18 C820  54         mov   @>83EA,@>20EA
     6A1A 83EA 
     6A1C 20EA 
0139 6A1E C820  54         mov   @>83EC,@>20EC
     6A20 83EC 
     6A22 20EC 
0140 6A24 C820  54         mov   @>83EE,@>20EE
     6A26 83EE 
     6A28 20EE 
0141 6A2A C820  54         mov   @>83F0,@>20F0
     6A2C 83F0 
     6A2E 20F0 
0142 6A30 C820  54         mov   @>83F2,@>20F2
     6A32 83F2 
     6A34 20F2 
0143 6A36 C820  54         mov   @>83F4,@>20F4
     6A38 83F4 
     6A3A 20F4 
0144 6A3C C820  54         mov   @>83F6,@>20F6
     6A3E 83F6 
     6A40 20F6 
0145 6A42 C820  54         mov   @>83F8,@>20F8
     6A44 83F8 
     6A46 20F8 
0146 6A48 C820  54         mov   @>83FA,@>20FA
     6A4A 83FA 
     6A4C 20FA 
0147 6A4E C820  54         mov   @>83FC,@>20FC
     6A50 83FC 
     6A52 20FC 
0148 6A54 C820  54         mov   @>83FE,@>20FE
     6A56 83FE 
     6A58 20FE 
0149 6A5A 045B  20         b     *r11                  ; Return to caller
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
0164 6A5C C820  54         mov   @>2000,@>8300
     6A5E 2000 
     6A60 8300 
0165 6A62 C820  54         mov   @>2002,@>8302
     6A64 2002 
     6A66 8302 
0166 6A68 C820  54         mov   @>2004,@>8304
     6A6A 2004 
     6A6C 8304 
0167 6A6E C820  54         mov   @>2006,@>8306
     6A70 2006 
     6A72 8306 
0168 6A74 C820  54         mov   @>2008,@>8308
     6A76 2008 
     6A78 8308 
0169 6A7A C820  54         mov   @>200A,@>830A
     6A7C 200A 
     6A7E 830A 
0170 6A80 C820  54         mov   @>200C,@>830C
     6A82 200C 
     6A84 830C 
0171 6A86 C820  54         mov   @>200E,@>830E
     6A88 200E 
     6A8A 830E 
0172 6A8C C820  54         mov   @>2010,@>8310
     6A8E 2010 
     6A90 8310 
0173 6A92 C820  54         mov   @>2012,@>8312
     6A94 2012 
     6A96 8312 
0174 6A98 C820  54         mov   @>2014,@>8314
     6A9A 2014 
     6A9C 8314 
0175 6A9E C820  54         mov   @>2016,@>8316
     6AA0 2016 
     6AA2 8316 
0176 6AA4 C820  54         mov   @>2018,@>8318
     6AA6 2018 
     6AA8 8318 
0177 6AAA C820  54         mov   @>201A,@>831A
     6AAC 201A 
     6AAE 831A 
0178 6AB0 C820  54         mov   @>201C,@>831C
     6AB2 201C 
     6AB4 831C 
0179 6AB6 C820  54         mov   @>201E,@>831E
     6AB8 201E 
     6ABA 831E 
0180 6ABC C820  54         mov   @>2020,@>8320
     6ABE 2020 
     6AC0 8320 
0181 6AC2 C820  54         mov   @>2022,@>8322
     6AC4 2022 
     6AC6 8322 
0182 6AC8 C820  54         mov   @>2024,@>8324
     6ACA 2024 
     6ACC 8324 
0183 6ACE C820  54         mov   @>2026,@>8326
     6AD0 2026 
     6AD2 8326 
0184 6AD4 C820  54         mov   @>2028,@>8328
     6AD6 2028 
     6AD8 8328 
0185 6ADA C820  54         mov   @>202A,@>832A
     6ADC 202A 
     6ADE 832A 
0186 6AE0 C820  54         mov   @>202C,@>832C
     6AE2 202C 
     6AE4 832C 
0187 6AE6 C820  54         mov   @>202E,@>832E
     6AE8 202E 
     6AEA 832E 
0188 6AEC C820  54         mov   @>2030,@>8330
     6AEE 2030 
     6AF0 8330 
0189 6AF2 C820  54         mov   @>2032,@>8332
     6AF4 2032 
     6AF6 8332 
0190 6AF8 C820  54         mov   @>2034,@>8334
     6AFA 2034 
     6AFC 8334 
0191 6AFE C820  54         mov   @>2036,@>8336
     6B00 2036 
     6B02 8336 
0192 6B04 C820  54         mov   @>2038,@>8338
     6B06 2038 
     6B08 8338 
0193 6B0A C820  54         mov   @>203A,@>833A
     6B0C 203A 
     6B0E 833A 
0194 6B10 C820  54         mov   @>203C,@>833C
     6B12 203C 
     6B14 833C 
0195 6B16 C820  54         mov   @>203E,@>833E
     6B18 203E 
     6B1A 833E 
0196 6B1C C820  54         mov   @>2040,@>8340
     6B1E 2040 
     6B20 8340 
0197 6B22 C820  54         mov   @>2042,@>8342
     6B24 2042 
     6B26 8342 
0198 6B28 C820  54         mov   @>2044,@>8344
     6B2A 2044 
     6B2C 8344 
0199 6B2E C820  54         mov   @>2046,@>8346
     6B30 2046 
     6B32 8346 
0200 6B34 C820  54         mov   @>2048,@>8348
     6B36 2048 
     6B38 8348 
0201 6B3A C820  54         mov   @>204A,@>834A
     6B3C 204A 
     6B3E 834A 
0202 6B40 C820  54         mov   @>204C,@>834C
     6B42 204C 
     6B44 834C 
0203 6B46 C820  54         mov   @>204E,@>834E
     6B48 204E 
     6B4A 834E 
0204 6B4C C820  54         mov   @>2050,@>8350
     6B4E 2050 
     6B50 8350 
0205 6B52 C820  54         mov   @>2052,@>8352
     6B54 2052 
     6B56 8352 
0206 6B58 C820  54         mov   @>2054,@>8354
     6B5A 2054 
     6B5C 8354 
0207 6B5E C820  54         mov   @>2056,@>8356
     6B60 2056 
     6B62 8356 
0208 6B64 C820  54         mov   @>2058,@>8358
     6B66 2058 
     6B68 8358 
0209 6B6A C820  54         mov   @>205A,@>835A
     6B6C 205A 
     6B6E 835A 
0210 6B70 C820  54         mov   @>205C,@>835C
     6B72 205C 
     6B74 835C 
0211 6B76 C820  54         mov   @>205E,@>835E
     6B78 205E 
     6B7A 835E 
0212 6B7C C820  54         mov   @>2060,@>8360
     6B7E 2060 
     6B80 8360 
0213 6B82 C820  54         mov   @>2062,@>8362
     6B84 2062 
     6B86 8362 
0214 6B88 C820  54         mov   @>2064,@>8364
     6B8A 2064 
     6B8C 8364 
0215 6B8E C820  54         mov   @>2066,@>8366
     6B90 2066 
     6B92 8366 
0216 6B94 C820  54         mov   @>2068,@>8368
     6B96 2068 
     6B98 8368 
0217 6B9A C820  54         mov   @>206A,@>836A
     6B9C 206A 
     6B9E 836A 
0218 6BA0 C820  54         mov   @>206C,@>836C
     6BA2 206C 
     6BA4 836C 
0219 6BA6 C820  54         mov   @>206E,@>836E
     6BA8 206E 
     6BAA 836E 
0220 6BAC C820  54         mov   @>2070,@>8370
     6BAE 2070 
     6BB0 8370 
0221 6BB2 C820  54         mov   @>2072,@>8372
     6BB4 2072 
     6BB6 8372 
0222 6BB8 C820  54         mov   @>2074,@>8374
     6BBA 2074 
     6BBC 8374 
0223 6BBE C820  54         mov   @>2076,@>8376
     6BC0 2076 
     6BC2 8376 
0224 6BC4 C820  54         mov   @>2078,@>8378
     6BC6 2078 
     6BC8 8378 
0225 6BCA C820  54         mov   @>207A,@>837A
     6BCC 207A 
     6BCE 837A 
0226 6BD0 C820  54         mov   @>207C,@>837C
     6BD2 207C 
     6BD4 837C 
0227 6BD6 C820  54         mov   @>207E,@>837E
     6BD8 207E 
     6BDA 837E 
0228 6BDC C820  54         mov   @>2080,@>8380
     6BDE 2080 
     6BE0 8380 
0229 6BE2 C820  54         mov   @>2082,@>8382
     6BE4 2082 
     6BE6 8382 
0230 6BE8 C820  54         mov   @>2084,@>8384
     6BEA 2084 
     6BEC 8384 
0231 6BEE C820  54         mov   @>2086,@>8386
     6BF0 2086 
     6BF2 8386 
0232 6BF4 C820  54         mov   @>2088,@>8388
     6BF6 2088 
     6BF8 8388 
0233 6BFA C820  54         mov   @>208A,@>838A
     6BFC 208A 
     6BFE 838A 
0234 6C00 C820  54         mov   @>208C,@>838C
     6C02 208C 
     6C04 838C 
0235 6C06 C820  54         mov   @>208E,@>838E
     6C08 208E 
     6C0A 838E 
0236 6C0C C820  54         mov   @>2090,@>8390
     6C0E 2090 
     6C10 8390 
0237 6C12 C820  54         mov   @>2092,@>8392
     6C14 2092 
     6C16 8392 
0238 6C18 C820  54         mov   @>2094,@>8394
     6C1A 2094 
     6C1C 8394 
0239 6C1E C820  54         mov   @>2096,@>8396
     6C20 2096 
     6C22 8396 
0240 6C24 C820  54         mov   @>2098,@>8398
     6C26 2098 
     6C28 8398 
0241 6C2A C820  54         mov   @>209A,@>839A
     6C2C 209A 
     6C2E 839A 
0242 6C30 C820  54         mov   @>209C,@>839C
     6C32 209C 
     6C34 839C 
0243 6C36 C820  54         mov   @>209E,@>839E
     6C38 209E 
     6C3A 839E 
0244 6C3C C820  54         mov   @>20A0,@>83A0
     6C3E 20A0 
     6C40 83A0 
0245 6C42 C820  54         mov   @>20A2,@>83A2
     6C44 20A2 
     6C46 83A2 
0246 6C48 C820  54         mov   @>20A4,@>83A4
     6C4A 20A4 
     6C4C 83A4 
0247 6C4E C820  54         mov   @>20A6,@>83A6
     6C50 20A6 
     6C52 83A6 
0248 6C54 C820  54         mov   @>20A8,@>83A8
     6C56 20A8 
     6C58 83A8 
0249 6C5A C820  54         mov   @>20AA,@>83AA
     6C5C 20AA 
     6C5E 83AA 
0250 6C60 C820  54         mov   @>20AC,@>83AC
     6C62 20AC 
     6C64 83AC 
0251 6C66 C820  54         mov   @>20AE,@>83AE
     6C68 20AE 
     6C6A 83AE 
0252 6C6C C820  54         mov   @>20B0,@>83B0
     6C6E 20B0 
     6C70 83B0 
0253 6C72 C820  54         mov   @>20B2,@>83B2
     6C74 20B2 
     6C76 83B2 
0254 6C78 C820  54         mov   @>20B4,@>83B4
     6C7A 20B4 
     6C7C 83B4 
0255 6C7E C820  54         mov   @>20B6,@>83B6
     6C80 20B6 
     6C82 83B6 
0256 6C84 C820  54         mov   @>20B8,@>83B8
     6C86 20B8 
     6C88 83B8 
0257 6C8A C820  54         mov   @>20BA,@>83BA
     6C8C 20BA 
     6C8E 83BA 
0258 6C90 C820  54         mov   @>20BC,@>83BC
     6C92 20BC 
     6C94 83BC 
0259 6C96 C820  54         mov   @>20BE,@>83BE
     6C98 20BE 
     6C9A 83BE 
0260 6C9C C820  54         mov   @>20C0,@>83C0
     6C9E 20C0 
     6CA0 83C0 
0261 6CA2 C820  54         mov   @>20C2,@>83C2
     6CA4 20C2 
     6CA6 83C2 
0262 6CA8 C820  54         mov   @>20C4,@>83C4
     6CAA 20C4 
     6CAC 83C4 
0263 6CAE C820  54         mov   @>20C6,@>83C6
     6CB0 20C6 
     6CB2 83C6 
0264 6CB4 C820  54         mov   @>20C8,@>83C8
     6CB6 20C8 
     6CB8 83C8 
0265 6CBA C820  54         mov   @>20CA,@>83CA
     6CBC 20CA 
     6CBE 83CA 
0266 6CC0 C820  54         mov   @>20CC,@>83CC
     6CC2 20CC 
     6CC4 83CC 
0267 6CC6 C820  54         mov   @>20CE,@>83CE
     6CC8 20CE 
     6CCA 83CE 
0268 6CCC C820  54         mov   @>20D0,@>83D0
     6CCE 20D0 
     6CD0 83D0 
0269 6CD2 C820  54         mov   @>20D2,@>83D2
     6CD4 20D2 
     6CD6 83D2 
0270 6CD8 C820  54         mov   @>20D4,@>83D4
     6CDA 20D4 
     6CDC 83D4 
0271 6CDE C820  54         mov   @>20D6,@>83D6
     6CE0 20D6 
     6CE2 83D6 
0272 6CE4 C820  54         mov   @>20D8,@>83D8
     6CE6 20D8 
     6CE8 83D8 
0273 6CEA C820  54         mov   @>20DA,@>83DA
     6CEC 20DA 
     6CEE 83DA 
0274 6CF0 C820  54         mov   @>20DC,@>83DC
     6CF2 20DC 
     6CF4 83DC 
0275 6CF6 C820  54         mov   @>20DE,@>83DE
     6CF8 20DE 
     6CFA 83DE 
0276 6CFC C820  54         mov   @>20E0,@>83E0
     6CFE 20E0 
     6D00 83E0 
0277 6D02 C820  54         mov   @>20E2,@>83E2
     6D04 20E2 
     6D06 83E2 
0278 6D08 C820  54         mov   @>20E4,@>83E4
     6D0A 20E4 
     6D0C 83E4 
0279 6D0E C820  54         mov   @>20E6,@>83E6
     6D10 20E6 
     6D12 83E6 
0280 6D14 C820  54         mov   @>20E8,@>83E8
     6D16 20E8 
     6D18 83E8 
0281 6D1A C820  54         mov   @>20EA,@>83EA
     6D1C 20EA 
     6D1E 83EA 
0282 6D20 C820  54         mov   @>20EC,@>83EC
     6D22 20EC 
     6D24 83EC 
0283 6D26 C820  54         mov   @>20EE,@>83EE
     6D28 20EE 
     6D2A 83EE 
0284 6D2C C820  54         mov   @>20F0,@>83F0
     6D2E 20F0 
     6D30 83F0 
0285 6D32 C820  54         mov   @>20F2,@>83F2
     6D34 20F2 
     6D36 83F2 
0286 6D38 C820  54         mov   @>20F4,@>83F4
     6D3A 20F4 
     6D3C 83F4 
0287 6D3E C820  54         mov   @>20F6,@>83F6
     6D40 20F6 
     6D42 83F6 
0288 6D44 C820  54         mov   @>20F8,@>83F8
     6D46 20F8 
     6D48 83F8 
0289 6D4A C820  54         mov   @>20FA,@>83FA
     6D4C 20FA 
     6D4E 83FA 
0290 6D50 C820  54         mov   @>20FC,@>83FC
     6D52 20FC 
     6D54 83FC 
0291 6D56 C820  54         mov   @>20FE,@>83FE
     6D58 20FE 
     6D5A 83FE 
0292 6D5C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0199                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 6D5E C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6D60 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6D62 8300 
0030 6D64 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6D66 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D68 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6D6A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6D6C 0606  14         dec   tmp2
0037 6D6E 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6D70 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6D72 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6D74 6D7A 
0043                                                   ; R14=PC
0044 6D76 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6D78 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6D7A 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6D7C 6A5C 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6D7E 045B  20         b     *r11                  ; Return to caller
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
0077 6D80 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6D82 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6D84 8300 
0083 6D86 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D88 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6D8A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6D8C 0606  14         dec   tmp2
0089 6D8E 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6D90 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6D92 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6D94 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0201               
0203                       copy  "equ_fio.asm"              ; File I/O equates
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
0204                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
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
0041 6D96 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6D98 6D9A             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6D9A C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6D9C C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6D9E 8322 
0049 6DA0 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6DA2 6042 
0050 6DA4 C020  34         mov   @>8356,r0             ; get ptr to pab
     6DA6 8356 
0051 6DA8 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6DAA 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6DAC FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6DAE 06C0  14         swpb  r0                    ;
0059 6DB0 D800  38         movb  r0,@vdpa              ; send low byte
     6DB2 8C02 
0060 6DB4 06C0  14         swpb  r0                    ;
0061 6DB6 D800  38         movb  r0,@vdpa              ; send high byte
     6DB8 8C02 
0062 6DBA D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6DBC 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6DBE 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6DC0 0704  14         seto  r4                    ; init counter
0070 6DC2 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6DC4 2420 
0071 6DC6 0580  14 !       inc   r0                    ; point to next char of name
0072 6DC8 0584  14         inc   r4                    ; incr char counter
0073 6DCA 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6DCC 0007 
0074 6DCE 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6DD0 80C4  18         c     r4,r3                 ; end of name?
0077 6DD2 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6DD4 06C0  14         swpb  r0                    ;
0082 6DD6 D800  38         movb  r0,@vdpa              ; send low byte
     6DD8 8C02 
0083 6DDA 06C0  14         swpb  r0                    ;
0084 6DDC D800  38         movb  r0,@vdpa              ; send high byte
     6DDE 8C02 
0085 6DE0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DE2 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6DE4 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6DE6 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6DE8 6EAA 
0093 6DEA 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6DEC C104  18         mov   r4,r4                 ; Check if length = 0
0099 6DEE 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6DF0 04E0  34         clr   @>83d0
     6DF2 83D0 
0102 6DF4 C804  38         mov   r4,@>8354             ; save name length for search
     6DF6 8354 
0103 6DF8 0584  14         inc   r4                    ; adjust for dot
0104 6DFA A804  38         a     r4,@>8356             ; point to position after name
     6DFC 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6DFE 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6E00 83E0 
0110 6E02 04C1  14         clr   r1                    ; version found of dsr
0111 6E04 020C  20         li    r12,>0f00             ; init cru addr
     6E06 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6E08 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6E0A 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6E0C 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6E0E 022C  22         ai    r12,>0100             ; next rom to turn on
     6E10 0100 
0125 6E12 04E0  34         clr   @>83d0                ; clear in case we are done
     6E14 83D0 
0126 6E16 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6E18 2000 
0127 6E1A 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6E1C C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6E1E 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6E20 1D00  20         sbo   0                     ; turn on rom
0134 6E22 0202  20         li    r2,>4000              ; start at beginning of rom
     6E24 4000 
0135 6E26 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6E28 6EA6 
0136 6E2A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6E2C A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6E2E 240A 
0146 6E30 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6E32 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6E34 83D2 
0152 6E36 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6E38 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6E3A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6E3C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6E3E 83D2 
0161 6E40 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6E42 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6E44 04C5  14         clr   r5                    ; Remove any old stuff
0167 6E46 D160  34         movb  @>8355,r5             ; get length as counter
     6E48 8355 
0168 6E4A 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6E4C 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6E4E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6E50 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6E52 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6E54 2420 
0175 6E56 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6E58 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6E5A 0605  14         dec   r5                    ; loop until full length checked
0179 6E5C 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6E5E C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6E60 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6E62 0581  14         inc   r1                    ; next version found
0191 6E64 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6E66 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6E68 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6E6A 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6E6C 2400 
0200 6E6E C009  18         mov   r9,r0                 ; point to flag in pab
0201 6E70 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6E72 8322 
0202                                                   ; (8 or >a)
0203 6E74 0281  22         ci    r1,8                  ; was it 8?
     6E76 0008 
0204 6E78 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6E7A D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6E7C 8350 
0206                                                   ; Get error byte from @>8350
0207 6E7E 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6E80 06C0  14         swpb  r0                    ;
0215 6E82 D800  38         movb  r0,@vdpa              ; send low byte
     6E84 8C02 
0216 6E86 06C0  14         swpb  r0                    ;
0217 6E88 D800  38         movb  r0,@vdpa              ; send high byte
     6E8A 8C02 
0218 6E8C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E8E 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6E90 09D1  56         srl   r1,13                 ; just keep error bits
0226 6E92 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6E94 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6E96 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E98 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6E9A 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6E9C 06C1  14         swpb  r1                    ; put error in hi byte
0239 6E9E D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6EA0 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6EA2 6042 
0241 6EA4 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6EA6 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6EA8 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6EAA ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
**** **** ****     > runlib.asm
0205                       copy  "fio_level2.asm"           ; File I/O level 2 support
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
0043 6EAC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6EAE C04B  18         mov   r11,r1                ; Save return address
0049 6EB0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6EB2 2428 
0050 6EB4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6EB6 04C5  14         clr   tmp1                  ; io.op.open
0052 6EB8 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EBA 612E 
0053               file.open_init:
0054 6EBC 0220  22         ai    r0,9                  ; Move to file descriptor length
     6EBE 0009 
0055 6EC0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EC2 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6EC4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EC6 6D96 
0061 6EC8 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6ECA 1029  14         jmp   file.record.pab.details
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
0090 6ECC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6ECE C04B  18         mov   r11,r1                ; Save return address
0096 6ED0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6ED2 2428 
0097 6ED4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6ED6 0205  20         li    tmp1,io.op.close      ; io.op.close
     6ED8 0001 
0099 6EDA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EDC 612E 
0100               file.close_init:
0101 6EDE 0220  22         ai    r0,9                  ; Move to file descriptor length
     6EE0 0009 
0102 6EE2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EE4 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6EE6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EE8 6D96 
0108 6EEA 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6EEC 1018  14         jmp   file.record.pab.details
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
0139 6EEE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6EF0 C04B  18         mov   r11,r1                ; Save return address
0145 6EF2 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6EF4 2428 
0146 6EF6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6EF8 0205  20         li    tmp1,io.op.read       ; io.op.read
     6EFA 0002 
0148 6EFC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EFE 612E 
0149               file.record.read_init:
0150 6F00 0220  22         ai    r0,9                  ; Move to file descriptor length
     6F02 0009 
0151 6F04 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6F06 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6F08 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6F0A 6D96 
0157 6F0C 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6F0E 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6F10 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6F12 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6F14 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6F16 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6F18 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6F1A 1000  14         nop
0191               
0192               
0193               file.status:
0194 6F1C 1000  14         nop
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
0211 6F1E 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6F20 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6F22 2428 
0219 6F24 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6F26 0005 
0220 6F28 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6F2A 6146 
0221 6F2C C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6F2E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6F30 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0207               
0208               
0209               
0210               *//////////////////////////////////////////////////////////////
0211               *                            TIMERS
0212               *//////////////////////////////////////////////////////////////
0213               
0214                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 6F32 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F34 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F36 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F38 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F3A 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F3C 6042 
0029 6F3E 1602  14         jne   tmgr1a                ; No, so move on
0030 6F40 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F42 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F44 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F46 6046 
0035 6F48 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F4A 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F4C 6036 
0048 6F4E 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F50 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F52 6034 
0050 6F54 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F56 0460  28         b     @kthread              ; Run kernel thread
     6F58 6FD0 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F5A 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F5C 603A 
0056 6F5E 13EB  14         jeq   tmgr1
0057 6F60 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F62 6038 
0058 6F64 16E8  14         jne   tmgr1
0059 6F66 C120  34         mov   @wtiusr,tmp0
     6F68 832E 
0060 6F6A 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F6C 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F6E 6FCE 
0065 6F70 C10A  18         mov   r10,tmp0
0066 6F72 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F74 00FF 
0067 6F76 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F78 6042 
0068 6F7A 1303  14         jeq   tmgr5
0069 6F7C 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F7E 003C 
0070 6F80 1002  14         jmp   tmgr6
0071 6F82 0284  22 tmgr5   ci    tmp0,50
     6F84 0032 
0072 6F86 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F88 1001  14         jmp   tmgr8
0074 6F8A 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F8C C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F8E 832C 
0079 6F90 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F92 FF00 
0080 6F94 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F96 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F98 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F9A 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F9C C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F9E 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6FA0 830C 
     6FA2 830D 
0089 6FA4 1608  14         jne   tmgr10                ; No, get next slot
0090 6FA6 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6FA8 FF00 
0091 6FAA C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6FAC C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6FAE 8330 
0096 6FB0 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6FB2 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6FB4 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6FB6 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6FB8 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6FBA 8315 
     6FBC 8314 
0103 6FBE 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6FC0 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6FC2 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6FC4 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6FC6 10F7  14         jmp   tmgr10                ; Process next slot
0108 6FC8 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6FCA FF00 
0109 6FCC 10B4  14         jmp   tmgr1
0110 6FCE 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0215                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 6FD0 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FD2 6036 
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
0041 6FD4 06A0  32         bl    @realkb               ; Scan full keyboard
     6FD6 6490 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FD8 0460  28         b     @tmgr3                ; Exit
     6FDA 6F5A 
**** **** ****     > runlib.asm
0216                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 6FDC C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FDE 832E 
0018 6FE0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FE2 6038 
0019 6FE4 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F36     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6FE6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FE8 832E 
0029 6FEA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FEC FEFF 
0030 6FEE 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0217               
0219                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 6FF0 C13B  30 mkslot  mov   *r11+,tmp0
0018 6FF2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6FF4 C184  18         mov   tmp0,tmp2
0023 6FF6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6FF8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6FFA 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6FFC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6FFE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7000 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7002 881B  46         c     *r11,@w$ffff          ; End of list ?
     7004 6048 
0035 7006 1301  14         jeq   mkslo1                ; Yes, exit
0036 7008 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 700A 05CB  14 mkslo1  inct  r11
0041 700C 045B  20         b     *r11                  ; Exit
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
0052 700E C13B  30 clslot  mov   *r11+,tmp0
0053 7010 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7012 A120  34         a     @wtitab,tmp0          ; Add table base
     7014 832C 
0055 7016 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7018 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 701A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0221               
0222               
0223               
0224               *//////////////////////////////////////////////////////////////
0225               *                    RUNLIB INITIALISATION
0226               *//////////////////////////////////////////////////////////////
0227               
0228               ***************************************************************
0229               *  RUNLIB - Runtime library initalisation
0230               ***************************************************************
0231               *  B  @RUNLIB
0232               *--------------------------------------------------------------
0233               *  REMARKS
0234               *  if R0 in WS1 equals >4a4a we were called from the system
0235               *  crash handler so we return there after initialisation.
0236               
0237               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0238               *  after clearing scratchpad memory. This has higher priority
0239               *  as crash handler flag R0.
0240               ********@*****@*********************@**************************
0242 701C 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     701E 675A 
0243 7020 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7022 8302 
0247               *--------------------------------------------------------------
0248               * Alternative entry point
0249               *--------------------------------------------------------------
0250 7024 0300  24 runli1  limi  0                     ; Turn off interrupts
     7026 0000 
0251 7028 02E0  18         lwpi  ws1                   ; Activate workspace 1
     702A 8300 
0252 702C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     702E 83C0 
0253               *--------------------------------------------------------------
0254               * Clear scratch-pad memory from R4 upwards
0255               *--------------------------------------------------------------
0256 7030 0202  20 runli2  li    r2,>8308
     7032 8308 
0257 7034 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0258 7036 0282  22         ci    r2,>8400
     7038 8400 
0259 703A 16FC  14         jne   runli3
0260               *--------------------------------------------------------------
0261               * Exit to TI-99/4A title screen ?
0262               *--------------------------------------------------------------
0263               runli3a
0264 703C 0281  22         ci    r1,>ffff              ; Exit flag set ?
     703E FFFF 
0265 7040 1602  14         jne   runli4                ; No, continue
0266 7042 0420  54         blwp  @0                    ; Yes, bye bye
     7044 0000 
0267               *--------------------------------------------------------------
0268               * Determine if VDP is PAL or NTSC
0269               *--------------------------------------------------------------
0270 7046 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7048 833C 
0271 704A 04C1  14         clr   r1                    ; Reset counter
0272 704C 0202  20         li    r2,10                 ; We test 10 times
     704E 000A 
0273 7050 C0E0  34 runli5  mov   @vdps,r3
     7052 8802 
0274 7054 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7056 6046 
0275 7058 1302  14         jeq   runli6
0276 705A 0581  14         inc   r1                    ; Increase counter
0277 705C 10F9  14         jmp   runli5
0278 705E 0602  14 runli6  dec   r2                    ; Next test
0279 7060 16F7  14         jne   runli5
0280 7062 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7064 1250 
0281 7066 1202  14         jle   runli7                ; No, so it must be NTSC
0282 7068 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     706A 6042 
0283               *--------------------------------------------------------------
0284               * Copy machine code to scratchpad (prepare tight loop)
0285               *--------------------------------------------------------------
0286 706C 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     706E 60B6 
0287 7070 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     7072 8322 
0288 7074 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0289 7076 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0290 7078 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0291               *--------------------------------------------------------------
0292               * Initialize registers, memory, ...
0293               *--------------------------------------------------------------
0294 707A 04C1  14 runli9  clr   r1
0295 707C 04C2  14         clr   r2
0296 707E 04C3  14         clr   r3
0297 7080 0209  20         li    stack,>8400           ; Set stack
     7082 8400 
0298 7084 020F  20         li    r15,vdpw              ; Set VDP write address
     7086 8C00 
0302               *--------------------------------------------------------------
0303               * Setup video memory
0304               *--------------------------------------------------------------
0306 7088 0280  22         ci    r0,>4a4a              ; Crash flag set?
     708A 4A4A 
0307 708C 1605  14         jne   runlia
0308 708E 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7090 60F0 
0309 7092 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     7094 0000 
     7096 3FFF 
0314 7098 06A0  32 runlia  bl    @filv
     709A 60F0 
0315 709C 0FC0             data  pctadr,spfclr,16      ; Load color table
     709E 00F4 
     70A0 0010 
0316               *--------------------------------------------------------------
0317               * Check if there is a F18A present
0318               *--------------------------------------------------------------
0322 70A2 06A0  32         bl    @f18unl               ; Unlock the F18A
     70A4 63D8 
0323 70A6 06A0  32         bl    @f18chk               ; Check if F18A is there
     70A8 63F2 
0324 70AA 06A0  32         bl    @f18lck               ; Lock the F18A again
     70AC 63E8 
0326               *--------------------------------------------------------------
0327               * Check if there is a speech synthesizer attached
0328               *--------------------------------------------------------------
0330               *       <<skipped>>
0334               *--------------------------------------------------------------
0335               * Load video mode table & font
0336               *--------------------------------------------------------------
0337 70AE 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     70B0 615A 
0338 70B2 60AC             data  spvmod                ; Equate selected video mode table
0339 70B4 0204  20         li    tmp0,spfont           ; Get font option
     70B6 000C 
0340 70B8 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0341 70BA 1304  14         jeq   runlid                ; Yes, skip it
0342 70BC 06A0  32         bl    @ldfnt
     70BE 61C2 
0343 70C0 1100             data  fntadr,spfont         ; Load specified font
     70C2 000C 
0344               *--------------------------------------------------------------
0345               * Did a system crash occur before runlib was called?
0346               *--------------------------------------------------------------
0347 70C4 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     70C6 4A4A 
0348 70C8 1602  14         jne   runlie                ; No, continue
0349 70CA 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     70CC 605C 
0350               *--------------------------------------------------------------
0351               * Branch to main program
0352               *--------------------------------------------------------------
0353 70CE 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     70D0 0040 
0354 70D2 0460  28         b     @main                 ; Give control to main program
     70D4 70D6 
**** **** ****     > tivi.asm.30645
0210               
0211               *--------------------------------------------------------------
0212               * Video mode configuration
0213               *--------------------------------------------------------------
0214      60AC     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
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
0225               ********@*****@*********************@**************************
0226 70D6 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     70D8 6044 
0227 70DA 1302  14         jeq   main.continue
0228 70DC 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     70DE 0000 
0229               
0230               main.continue:
0231 70E0 06A0  32         bl    @scroff               ; Turn screen off
     70E2 6334 
0232 70E4 06A0  32         bl    @f18unl               ; Unlock the F18a
     70E6 63D8 
0233 70E8 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     70EA 6194 
0234 70EC 3140                   data >3140            ; F18a VR49 (>31), bit 40
0235                       ;------------------------------------------------------
0236                       ; Initialize VDP SIT
0237                       ;------------------------------------------------------
0238 70EE 06A0  32         bl    @filv
     70F0 60F0 
0239 70F2 0000                   data >0000,32,31*80   ; Clear VDP SIT
     70F4 0020 
     70F6 09B0 
0240 70F8 06A0  32         bl    @scron                ; Turn screen on
     70FA 633C 
0241                       ;------------------------------------------------------
0242                       ; Initialize low + high memory expansion
0243                       ;------------------------------------------------------
0244 70FC 06A0  32         bl    @film
     70FE 60CC 
0245 7100 2200                   data >2200,00,8*1024-256*2
     7102 0000 
     7104 3E00 
0246                                                   ; Clear part of 8k low-memory
0247               
0248 7106 06A0  32         bl    @film
     7108 60CC 
0249 710A A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     710C 0000 
     710E 6000 
0250                       ;------------------------------------------------------
0251                       ; Setup cursor, screen, etc.
0252                       ;------------------------------------------------------
0253 7110 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     7112 6354 
0254 7114 06A0  32         bl    @s8x8                 ; Small sprite
     7116 6364 
0255               
0256 7118 06A0  32         bl    @cpym2m
     711A 62E2 
0257 711C 7DB2                   data romsat,ramsat,4  ; Load sprite SAT
     711E 8380 
     7120 0004 
0258               
0259 7122 C820  54         mov   @romsat+2,@fb.curshape
     7124 7DB4 
     7126 2210 
0260                                                   ; Save cursor shape & color
0261               
0262 7128 06A0  32         bl    @cpym2v
     712A 629A 
0263 712C 1800                   data sprpdt,cursors,3*8
     712E 7DB6 
     7130 0018 
0264                                                   ; Load sprite cursor patterns
0265               *--------------------------------------------------------------
0266               * Initialize
0267               *--------------------------------------------------------------
0268 7132 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7134 7A80 
0269 7136 06A0  32         bl    @idx.init             ; Initialize index
     7138 799E 
0270 713A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     713C 78C2 
0271               
0272                       ;-------------------------------------------------------
0273                       ; Setup editor tasks & hook
0274                       ;-------------------------------------------------------
0275 713E 0204  20         li    tmp0,>0200
     7140 0200 
0276 7142 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     7144 8314 
0277               
0278 7146 06A0  32         bl    @at
     7148 6374 
0279 714A 0000             data  >0000                 ; Cursor YX position = >0000
0280               
0281 714C 0204  20         li    tmp0,timers
     714E 8370 
0282 7150 C804  38         mov   tmp0,@wtitab
     7152 832C 
0283               
0284 7154 06A0  32         bl    @mkslot
     7156 6FF0 
0285 7158 0001                   data >0001,task0      ; Task 0 - Update screen
     715A 773C 
0286 715C 0101                   data >0101,task1      ; Task 1 - Update cursor position
     715E 77C0 
0287 7160 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     7162 77CE 
     7164 FFFF 
0288               
0289 7166 06A0  32         bl    @mkhook
     7168 6FDC 
0290 716A 7170                   data editor           ; Setup user hook
0291               
0292 716C 0460  28         b     @tmgr                 ; Start timers and kthread
     716E 6F32 
0293               
0294               
0295               ****************************************************************
0296               * Editor - Main loop
0297               ****************************************************************
0298 7170 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7172 6030 
0299 7174 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0300               *---------------------------------------------------------------
0301               * Identical key pressed ?
0302               *---------------------------------------------------------------
0303 7176 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7178 6030 
0304 717A 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     717C 833C 
     717E 833E 
0305 7180 1308  14         jeq   ed_wait
0306               *--------------------------------------------------------------
0307               * New key pressed
0308               *--------------------------------------------------------------
0309               ed_new_key
0310 7182 C820  54         mov   @waux1,@waux2         ; Save as previous key
     7184 833C 
     7186 833E 
0311 7188 1045  14         jmp   edkey                 ; Process key
0312               *--------------------------------------------------------------
0313               * Clear keyboard buffer if no key pressed
0314               *--------------------------------------------------------------
0315               ed_clear_kbbuffer
0316 718A 04E0  34         clr   @waux1
     718C 833C 
0317 718E 04E0  34         clr   @waux2
     7190 833E 
0318               *--------------------------------------------------------------
0319               * Delay to avoid key bouncing
0320               *--------------------------------------------------------------
0321               ed_wait
0322 7192 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     7194 0708 
0323                       ;------------------------------------------------------
0324                       ; Delay loop
0325                       ;------------------------------------------------------
0326               ed_wait_loop
0327 7196 0604  14         dec   tmp0
0328 7198 16FE  14         jne   ed_wait_loop
0329               *--------------------------------------------------------------
0330               * Exit
0331               *--------------------------------------------------------------
0332 719A 0460  28 ed_exit b     @hookok               ; Return
     719C 6F36 
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
0055 719E 0D00             data  key_enter,edkey.action.enter          ; New line
     71A0 7602 
0056 71A2 0800             data  key_left,edkey.action.left            ; Move cursor left
     71A4 7236 
0057 71A6 0900             data  key_right,edkey.action.right          ; Move cursor right
     71A8 724C 
0058 71AA 0B00             data  key_up,edkey.action.up                ; Move cursor up
     71AC 7264 
0059 71AE 0A00             data  key_down,edkey.action.down            ; Move cursor down
     71B0 72B6 
0060 71B2 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     71B4 7322 
0061 71B6 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     71B8 733A 
0062 71BA 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     71BC 734E 
0063 71BE 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     71C0 73A0 
0064 71C2 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     71C4 7400 
0065 71C6 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     71C8 744A 
0066 71CA 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     71CC 7476 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 71CE 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     71D0 74A4 
0071 71D2 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     71D4 74DC 
0072 71D6 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     71D8 7510 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 71DA 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     71DC 7568 
0077 71DE B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     71E0 7670 
0078 71E2 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     71E4 75BE 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 71E6 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     71E8 76C0 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 71EA B000             data  key_buf0,edkey.action.buffer0
     71EC 7700 
0087 71EE B100             data  key_buf1,edkey.action.buffer1
     71F0 7706 
0088 71F2 B200             data  key_buf2,edkey.action.buffer2
     71F4 770C 
0089 71F6 B300             data  key_buf3,edkey.action.buffer3
     71F8 7712 
0090 71FA B400             data  key_buf4,edkey.action.buffer4
     71FC 7718 
0091 71FE B500             data  key_buf5,edkey.action.buffer5
     7200 771E 
0092 7202 B600             data  key_buf6,edkey.action.buffer6
     7204 7724 
0093 7206 B700             data  key_buf7,edkey.action.buffer7
     7208 772A 
0094 720A 9E00             data  key_buf8,edkey.action.buffer8
     720C 7730 
0095 720E 9F00             data  key_buf9,edkey.action.buffer9
     7210 7736 
0096 7212 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 7214 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     7216 833C 
0104 7218 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     721A FF00 
0105               
0106 721C 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     721E 719E 
0107 7220 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 7222 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 7224 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 7226 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 7228 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 722A 05C6  14         inct  tmp2                  ; No, skip action
0118 722C 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 722E C196  26         mov  *tmp2,tmp2             ; Get action address
0122 7230 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 7232 0460  28         b    @edkey.action.char     ; Add character to buffer
     7234 7680 
**** **** ****     > tivi.asm.30645
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
0009 7236 C120  34         mov   @fb.column,tmp0
     7238 220C 
0010 723A 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 723C 0620  34         dec   @fb.column            ; Column-- in screen buffer
     723E 220C 
0015 7240 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7242 832A 
0016 7244 0620  34         dec   @fb.current
     7246 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 7248 0460  28 !       b     @ed_wait              ; Back to editor main
     724A 7192 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 724C 8820  54         c     @fb.column,@fb.row.length
     724E 220C 
     7250 2208 
0028 7252 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 7254 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7256 220C 
0033 7258 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     725A 832A 
0034 725C 05A0  34         inc   @fb.current
     725E 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 7260 0460  28 !       b     @ed_wait              ; Back to editor main
     7262 7192 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 7264 8820  54         c     @fb.row.dirty,@w$ffff
     7266 220A 
     7268 6048 
0049 726A 1604  14         jne   edkey.action.up.cursor
0050 726C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     726E 7A9C 
0051 7270 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7272 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 7274 C120  34         mov   @fb.row,tmp0
     7276 2206 
0057 7278 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 727A C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     727C 2204 
0060 727E 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 7280 0604  14         dec   tmp0                  ; fb.topline--
0066 7282 C804  38         mov   tmp0,@parm1
     7284 8350 
0067 7286 06A0  32         bl    @fb.refresh           ; Scroll one line up
     7288 792C 
0068 728A 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 728C 0620  34         dec   @fb.row               ; Row-- in screen buffer
     728E 2206 
0074 7290 06A0  32         bl    @up                   ; Row-- VDP cursor
     7292 6382 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 7294 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7296 7BD0 
0080 7298 8820  54         c     @fb.column,@fb.row.length
     729A 220C 
     729C 2208 
0081 729E 1207  14         jle   edkey.action.up.$$
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 72A0 C820  54         mov   @fb.row.length,@fb.column
     72A2 2208 
     72A4 220C 
0086 72A6 C120  34         mov   @fb.column,tmp0
     72A8 220C 
0087 72AA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     72AC 638C 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.$$:
0092 72AE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72B0 7910 
0093 72B2 0460  28         b     @ed_wait              ; Back to editor main
     72B4 7192 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 72B6 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     72B8 2206 
     72BA 2304 
0102 72BC 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 72BE 8820  54         c     @fb.row.dirty,@w$ffff
     72C0 220A 
     72C2 6048 
0107 72C4 1604  14         jne   edkey.action.down.move
0108 72C6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72C8 7A9C 
0109 72CA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72CC 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 72CE C120  34         mov   @fb.topline,tmp0
     72D0 2204 
0118 72D2 A120  34         a     @fb.row,tmp0
     72D4 2206 
0119 72D6 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     72D8 2304 
0120 72DA 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 72DC C120  34         mov   @fb.screenrows,tmp0
     72DE 2218 
0126 72E0 0604  14         dec   tmp0
0127 72E2 8120  34         c     @fb.row,tmp0
     72E4 2206 
0128 72E6 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 72E8 C820  54         mov   @fb.topline,@parm1
     72EA 2204 
     72EC 8350 
0133 72EE 05A0  34         inc   @parm1
     72F0 8350 
0134 72F2 06A0  32         bl    @fb.refresh
     72F4 792C 
0135 72F6 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 72F8 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     72FA 2206 
0141 72FC 06A0  32         bl    @down                 ; Row++ VDP cursor
     72FE 637A 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 7300 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7302 7BD0 
0147 7304 8820  54         c     @fb.column,@fb.row.length
     7306 220C 
     7308 2208 
0148 730A 1207  14         jle   edkey.action.down.$$  ; Exit
0149                       ;-------------------------------------------------------
0150                       ; Adjust cursor column position
0151                       ;-------------------------------------------------------
0152 730C C820  54         mov   @fb.row.length,@fb.column
     730E 2208 
     7310 220C 
0153 7312 C120  34         mov   @fb.column,tmp0
     7314 220C 
0154 7316 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7318 638C 
0155                       ;-------------------------------------------------------
0156                       ; Exit
0157                       ;-------------------------------------------------------
0158               edkey.action.down.$$:
0159 731A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     731C 7910 
0160 731E 0460  28 !       b     @ed_wait              ; Back to editor main
     7320 7192 
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Cursor beginning of line
0166               *---------------------------------------------------------------
0167               edkey.action.home:
0168 7322 C120  34         mov   @wyx,tmp0
     7324 832A 
0169 7326 0244  22         andi  tmp0,>ff00
     7328 FF00 
0170 732A C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     732C 832A 
0171 732E 04E0  34         clr   @fb.column
     7330 220C 
0172 7332 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7334 7910 
0173 7336 0460  28         b     @ed_wait              ; Back to editor main
     7338 7192 
0174               
0175               *---------------------------------------------------------------
0176               * Cursor end of line
0177               *---------------------------------------------------------------
0178               edkey.action.end:
0179 733A C120  34         mov   @fb.row.length,tmp0
     733C 2208 
0180 733E C804  38         mov   tmp0,@fb.column
     7340 220C 
0181 7342 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7344 638C 
0182 7346 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7348 7910 
0183 734A 0460  28         b     @ed_wait              ; Back to editor main
     734C 7192 
0184               
0185               
0186               
0187               *---------------------------------------------------------------
0188               * Cursor beginning of word or previous word
0189               *---------------------------------------------------------------
0190               edkey.action.pword:
0191 734E C120  34         mov   @fb.column,tmp0
     7350 220C 
0192 7352 1324  14         jeq   !                     ; column=0 ? Skip further processing
0193                       ;-------------------------------------------------------
0194                       ; Prepare 2 char buffer
0195                       ;-------------------------------------------------------
0196 7354 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7356 2202 
0197 7358 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0198 735A 1003  14         jmp   edkey.action.pword_scan_char
0199                       ;-------------------------------------------------------
0200                       ; Scan backwards to first character following space
0201                       ;-------------------------------------------------------
0202               edkey.action.pword_scan
0203 735C 0605  14         dec   tmp1
0204 735E 0604  14         dec   tmp0                  ; Column-- in screen buffer
0205 7360 1315  14         jeq   edkey.action.pword_done
0206                                                   ; Column=0 ? Skip further processing
0207                       ;-------------------------------------------------------
0208                       ; Check character
0209                       ;-------------------------------------------------------
0210               edkey.action.pword_scan_char
0211 7362 D195  26         movb  *tmp1,tmp2            ; Get character
0212 7364 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0213 7366 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0214 7368 0986  56         srl   tmp2,8                ; Right justify
0215 736A 0286  22         ci    tmp2,32               ; Space character found?
     736C 0020 
0216 736E 16F6  14         jne   edkey.action.pword_scan
0217                                                   ; No space found, try again
0218                       ;-------------------------------------------------------
0219                       ; Space found, now look closer
0220                       ;-------------------------------------------------------
0221 7370 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7372 2020 
0222 7374 13F3  14         jeq   edkey.action.pword_scan
0223                                                   ; Yes, so continue scanning
0224 7376 0287  22         ci    tmp3,>20ff            ; First character is space
     7378 20FF 
0225 737A 13F0  14         jeq   edkey.action.pword_scan
0226                       ;-------------------------------------------------------
0227                       ; Check distance travelled
0228                       ;-------------------------------------------------------
0229 737C C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     737E 220C 
0230 7380 61C4  18         s     tmp0,tmp3
0231 7382 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7384 0002 
0232 7386 11EA  14         jlt   edkey.action.pword_scan
0233                                                   ; Didn't move enough so keep on scanning
0234                       ;--------------------------------------------------------
0235                       ; Set cursor following space
0236                       ;--------------------------------------------------------
0237 7388 0585  14         inc   tmp1
0238 738A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0239                       ;-------------------------------------------------------
0240                       ; Save position and position hardware cursor
0241                       ;-------------------------------------------------------
0242               edkey.action.pword_done:
0243 738C C805  38         mov   tmp1,@fb.current
     738E 2202 
0244 7390 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7392 220C 
0245 7394 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7396 638C 
0246                       ;-------------------------------------------------------
0247                       ; Exit
0248                       ;-------------------------------------------------------
0249               edkey.action.pword.$$:
0250 7398 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     739A 7910 
0251 739C 0460  28 !       b     @ed_wait              ; Back to editor main
     739E 7192 
0252               
0253               
0254               
0255               *---------------------------------------------------------------
0256               * Cursor next word
0257               *---------------------------------------------------------------
0258               edkey.action.nword:
0259 73A0 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0260 73A2 C120  34         mov   @fb.column,tmp0
     73A4 220C 
0261 73A6 8804  38         c     tmp0,@fb.row.length
     73A8 2208 
0262 73AA 1428  14         jhe   !                     ; column=last char ? Skip further processing
0263                       ;-------------------------------------------------------
0264                       ; Prepare 2 char buffer
0265                       ;-------------------------------------------------------
0266 73AC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     73AE 2202 
0267 73B0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0268 73B2 1006  14         jmp   edkey.action.nword_scan_char
0269                       ;-------------------------------------------------------
0270                       ; Multiple spaces mode
0271                       ;-------------------------------------------------------
0272               edkey.action.nword_ms:
0273 73B4 0708  14         seto  tmp4                  ; Set multiple spaces mode
0274                       ;-------------------------------------------------------
0275                       ; Scan forward to first character following space
0276                       ;-------------------------------------------------------
0277               edkey.action.nword_scan
0278 73B6 0585  14         inc   tmp1
0279 73B8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0280 73BA 8804  38         c     tmp0,@fb.row.length
     73BC 2208 
0281 73BE 1316  14         jeq   edkey.action.nword_done
0282                                                   ; Column=last char ? Skip further processing
0283                       ;-------------------------------------------------------
0284                       ; Check character
0285                       ;-------------------------------------------------------
0286               edkey.action.nword_scan_char
0287 73C0 D195  26         movb  *tmp1,tmp2            ; Get character
0288 73C2 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0289 73C4 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0290 73C6 0986  56         srl   tmp2,8                ; Right justify
0291               
0292 73C8 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     73CA FFFF 
0293 73CC 1604  14         jne   edkey.action.nword_scan_char_other
0294                       ;-------------------------------------------------------
0295                       ; Special handling if multiple spaces found
0296                       ;-------------------------------------------------------
0297               edkey.action.nword_scan_char_ms:
0298 73CE 0286  22         ci    tmp2,32
     73D0 0020 
0299 73D2 160C  14         jne   edkey.action.nword_done
0300                                                   ; Exit if non-space found
0301 73D4 10F0  14         jmp   edkey.action.nword_scan
0302                       ;-------------------------------------------------------
0303                       ; Normal handling
0304                       ;-------------------------------------------------------
0305               edkey.action.nword_scan_char_other:
0306 73D6 0286  22         ci    tmp2,32               ; Space character found?
     73D8 0020 
0307 73DA 16ED  14         jne   edkey.action.nword_scan
0308                                                   ; No space found, try again
0309                       ;-------------------------------------------------------
0310                       ; Space found, now look closer
0311                       ;-------------------------------------------------------
0312 73DC 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     73DE 2020 
0313 73E0 13E9  14         jeq   edkey.action.nword_ms
0314                                                   ; Yes, so continue scanning
0315 73E2 0287  22         ci    tmp3,>20ff            ; First characer is space?
     73E4 20FF 
0316 73E6 13E7  14         jeq   edkey.action.nword_scan
0317                       ;--------------------------------------------------------
0318                       ; Set cursor following space
0319                       ;--------------------------------------------------------
0320 73E8 0585  14         inc   tmp1
0321 73EA 0584  14         inc   tmp0                  ; Column++ in screen buffer
0322                       ;-------------------------------------------------------
0323                       ; Save position and position hardware cursor
0324                       ;-------------------------------------------------------
0325               edkey.action.nword_done:
0326 73EC C805  38         mov   tmp1,@fb.current
     73EE 2202 
0327 73F0 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     73F2 220C 
0328 73F4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     73F6 638C 
0329                       ;-------------------------------------------------------
0330                       ; Exit
0331                       ;-------------------------------------------------------
0332               edkey.action.nword.$$:
0333 73F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73FA 7910 
0334 73FC 0460  28 !       b     @ed_wait              ; Back to editor main
     73FE 7192 
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
0346 7400 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     7402 2204 
0347 7404 1316  14         jeq   edkey.action.ppage.$$
0348                       ;-------------------------------------------------------
0349                       ; Special treatment top page
0350                       ;-------------------------------------------------------
0351 7406 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     7408 2218 
0352 740A 1503  14         jgt   edkey.action.ppage.topline
0353 740C 04E0  34         clr   @fb.topline           ; topline = 0
     740E 2204 
0354 7410 1003  14         jmp   edkey.action.ppage.crunch
0355                       ;-------------------------------------------------------
0356                       ; Adjust topline
0357                       ;-------------------------------------------------------
0358               edkey.action.ppage.topline:
0359 7412 6820  54         s     @fb.screenrows,@fb.topline
     7414 2218 
     7416 2204 
0360                       ;-------------------------------------------------------
0361                       ; Crunch current row if dirty
0362                       ;-------------------------------------------------------
0363               edkey.action.ppage.crunch:
0364 7418 8820  54         c     @fb.row.dirty,@w$ffff
     741A 220A 
     741C 6048 
0365 741E 1604  14         jne   edkey.action.ppage.refresh
0366 7420 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7422 7A9C 
0367 7424 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7426 220A 
0368                       ;-------------------------------------------------------
0369                       ; Refresh page
0370                       ;-------------------------------------------------------
0371               edkey.action.ppage.refresh:
0372 7428 C820  54         mov   @fb.topline,@parm1
     742A 2204 
     742C 8350 
0373 742E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7430 792C 
0374                       ;-------------------------------------------------------
0375                       ; Exit
0376                       ;-------------------------------------------------------
0377               edkey.action.ppage.$$:
0378 7432 04E0  34         clr   @fb.row
     7434 2206 
0379 7436 05A0  34         inc   @fb.row               ; Set fb.row=1
     7438 2206 
0380 743A 04E0  34         clr   @fb.column
     743C 220C 
0381 743E 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7440 0100 
0382 7442 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7444 832A 
0383 7446 0460  28         b     @edkey.action.up      ; Do rest of logic
     7448 7264 
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
0394 744A C120  34         mov   @fb.topline,tmp0
     744C 2204 
0395 744E A120  34         a     @fb.screenrows,tmp0
     7450 2218 
0396 7452 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7454 2304 
0397 7456 150D  14         jgt   edkey.action.npage.$$
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 7458 A820  54         a     @fb.screenrows,@fb.topline
     745A 2218 
     745C 2204 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 745E 8820  54         c     @fb.row.dirty,@w$ffff
     7460 220A 
     7462 6048 
0408 7464 1604  14         jne   edkey.action.npage.refresh
0409 7466 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7468 7A9C 
0410 746A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     746C 220A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 746E 0460  28         b     @edkey.action.ppage.refresh
     7470 7428 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.$$:
0421 7472 0460  28         b     @ed_wait              ; Back to editor main
     7474 7192 
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
0433 7476 8820  54         c     @fb.row.dirty,@w$ffff
     7478 220A 
     747A 6048 
0434 747C 1604  14         jne   edkey.action.top.refresh
0435 747E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7480 7A9C 
0436 7482 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7484 220A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 7486 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     7488 2204 
0442 748A 04E0  34         clr   @parm1
     748C 8350 
0443 748E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7490 792C 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.$$:
0448 7492 04E0  34         clr   @fb.row               ; Editor line 0
     7494 2206 
0449 7496 04E0  34         clr   @fb.column            ; Editor column 0
     7498 220C 
0450 749A 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0451 749C C804  38         mov   tmp0,@wyx             ;
     749E 832A 
0452 74A0 0460  28         b     @ed_wait              ; Back to editor main
     74A2 7192 
**** **** ****     > tivi.asm.30645
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
0009 74A4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     74A6 2306 
0010 74A8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74AA 7910 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 74AC C120  34         mov   @fb.current,tmp0      ; Get pointer
     74AE 2202 
0015 74B0 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     74B2 2208 
0016 74B4 1311  14         jeq   edkey.action.del_char.$$
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 74B6 8820  54         c     @fb.column,@fb.row.length
     74B8 220C 
     74BA 2208 
0022 74BC 130D  14         jeq   edkey.action.del_char.$$
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 74BE C120  34         mov   @fb.current,tmp0      ; Get pointer
     74C0 2202 
0028 74C2 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 74C4 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 74C6 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 74C8 0606  14         dec   tmp2
0036 74CA 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 74CC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     74CE 220A 
0041 74D0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     74D2 2216 
0042 74D4 0620  34         dec   @fb.row.length        ; @fb.row.length--
     74D6 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.$$:
0047 74D8 0460  28         b     @ed_wait              ; Back to editor main
     74DA 7192 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 74DC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     74DE 2306 
0055 74E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74E2 7910 
0056 74E4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     74E6 2208 
0057 74E8 1311  14         jeq   edkey.action.del_eol.$$
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 74EA C120  34         mov   @fb.current,tmp0      ; Get pointer
     74EC 2202 
0063 74EE C1A0  34         mov   @fb.colsline,tmp2
     74F0 220E 
0064 74F2 61A0  34         s     @fb.column,tmp2
     74F4 220C 
0065 74F6 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 74F8 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 74FA 0606  14         dec   tmp2
0072 74FC 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 74FE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7500 220A 
0077 7502 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7504 2216 
0078               
0079 7506 C820  54         mov   @fb.column,@fb.row.length
     7508 220C 
     750A 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.$$:
0085 750C 0460  28         b     @ed_wait              ; Back to editor main
     750E 7192 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 7510 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7512 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 7514 C120  34         mov   @edb.lines,tmp0
     7516 2304 
0097 7518 1604  14         jne   !
0098 751A 04E0  34         clr   @fb.column            ; Column 0
     751C 220C 
0099 751E 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     7520 74DC 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 7522 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7524 7910 
0104 7526 04E0  34         clr   @fb.row.dirty         ; Discard current line
     7528 220A 
0105 752A C820  54         mov   @fb.topline,@parm1
     752C 2204 
     752E 8350 
0106 7530 A820  54         a     @fb.row,@parm1        ; Line number to remove
     7532 2206 
     7534 8350 
0107 7536 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7538 2304 
     753A 8352 
0108 753C 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     753E 79DA 
0109 7540 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7542 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7544 C820  54         mov   @fb.topline,@parm1
     7546 2204 
     7548 8350 
0114 754A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     754C 792C 
0115 754E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7550 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 7552 C120  34         mov   @fb.topline,tmp0
     7554 2204 
0120 7556 A120  34         a     @fb.row,tmp0
     7558 2206 
0121 755A 8804  38         c     tmp0,@edb.lines       ; Was last line?
     755C 2304 
0122 755E 1202  14         jle   edkey.action.del_line.$$
0123 7560 0460  28         b     @edkey.action.up      ; One line up
     7562 7264 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.$$:
0128 7564 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7566 7322 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 7568 0204  20         li    tmp0,>2000            ; White space
     756A 2000 
0139 756C C804  38         mov   tmp0,@parm1
     756E 8350 
0140               edkey.action.ins_char:
0141 7570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7572 2306 
0142 7574 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7576 7910 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 7578 C120  34         mov   @fb.current,tmp0      ; Get pointer
     757A 2202 
0147 757C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     757E 2208 
0148 7580 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 7582 8820  54         c     @fb.column,@fb.row.length
     7584 220C 
     7586 2208 
0154 7588 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 758A C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 758C 61E0  34         s     @fb.column,tmp3
     758E 220C 
0162 7590 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 7592 C144  18         mov   tmp0,tmp1
0164 7594 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7596 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7598 220C 
0166 759A 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 759C D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 759E 0604  14         dec   tmp0
0173 75A0 0605  14         dec   tmp1
0174 75A2 0606  14         dec   tmp2
0175 75A4 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 75A6 D560  46         movb  @parm1,*tmp1
     75A8 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 75AA 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     75AC 220A 
0184 75AE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     75B0 2216 
0185 75B2 05A0  34         inc   @fb.row.length        ; @fb.row.length
     75B4 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 75B6 0460  28         b     @edkey.action.char.overwrite
     75B8 7692 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.$$:
0195 75BA 0460  28         b     @ed_wait              ; Back to editor main
     75BC 7192 
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
0206 75BE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     75C0 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 75C2 8820  54         c     @fb.row.dirty,@w$ffff
     75C4 220A 
     75C6 6048 
0211 75C8 1604  14         jne   edkey.action.ins_line.insert
0212 75CA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     75CC 7A9C 
0213 75CE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     75D0 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 75D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     75D4 7910 
0219 75D6 C820  54         mov   @fb.topline,@parm1
     75D8 2204 
     75DA 8350 
0220 75DC A820  54         a     @fb.row,@parm1        ; Line number to insert
     75DE 2206 
     75E0 8350 
0221               
0222 75E2 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     75E4 2304 
     75E6 8352 
0223 75E8 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     75EA 7A10 
0224 75EC 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     75EE 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 75F0 C820  54         mov   @fb.topline,@parm1
     75F2 2204 
     75F4 8350 
0229 75F6 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     75F8 792C 
0230 75FA 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     75FC 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.$$:
0235 75FE 0460  28         b     @ed_wait              ; Back to editor main
     7600 7192 
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
0249 7602 8820  54         c     @fb.row.dirty,@w$ffff
     7604 220A 
     7606 6048 
0250 7608 1606  14         jne   edkey.action.enter.upd_counter
0251 760A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     760C 2306 
0252 760E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7610 7A9C 
0253 7612 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7614 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 7616 C120  34         mov   @fb.topline,tmp0
     7618 2204 
0259 761A A120  34         a     @fb.row,tmp0
     761C 2206 
0260 761E 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7620 2304 
0261 7622 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 7624 05A0  34         inc   @edb.lines            ; Total lines++
     7626 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 7628 C120  34         mov   @fb.screenrows,tmp0
     762A 2218 
0271 762C 0604  14         dec   tmp0
0272 762E 8120  34         c     @fb.row,tmp0
     7630 2206 
0273 7632 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 7634 C120  34         mov   @fb.screenrows,tmp0
     7636 2218 
0278 7638 C820  54         mov   @fb.topline,@parm1
     763A 2204 
     763C 8350 
0279 763E 05A0  34         inc   @parm1
     7640 8350 
0280 7642 06A0  32         bl    @fb.refresh
     7644 792C 
0281 7646 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 7648 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     764A 2206 
0287 764C 06A0  32         bl    @down                 ; Row++ VDP cursor
     764E 637A 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 7650 06A0  32         bl    @fb.get.firstnonblank
     7652 7956 
0293 7654 C120  34         mov   @outparm1,tmp0
     7656 8360 
0294 7658 C804  38         mov   tmp0,@fb.column
     765A 220C 
0295 765C 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     765E 638C 
0296 7660 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7662 7BD0 
0297 7664 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7666 7910 
0298 7668 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     766A 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.$$:
0303 766C 0460  28         b     @ed_wait              ; Back to editor main
     766E 7192 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 7670 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7672 230C 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7674 0204  20         li    tmp0,2000
     7676 07D0 
0317               edkey.action.ins_onoff.loop:
0318 7678 0604  14         dec   tmp0
0319 767A 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.$$:
0324 767C 0460  28         b     @task2.cur_visible    ; Update cursor shape
     767E 77DA 
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
0335 7680 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7682 2306 
0336 7684 D805  38         movb  tmp1,@parm1           ; Store character for insert
     7686 8350 
0337 7688 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     768A 230C 
0338 768C 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 768E 0460  28         b     @edkey.action.ins_char
     7690 7570 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 7692 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7694 7910 
0349 7696 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7698 2202 
0350               
0351 769A D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     769C 8350 
0352 769E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     76A0 220A 
0353 76A2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     76A4 2216 
0354               
0355 76A6 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     76A8 220C 
0356 76AA 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     76AC 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 76AE 8820  54         c     @fb.column,@fb.row.length
     76B0 220C 
     76B2 2208 
0361 76B4 1103  14         jlt   edkey.action.char.$$  ; column < length line ? Skip further processing
0362 76B6 C820  54         mov   @fb.column,@fb.row.length
     76B8 220C 
     76BA 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.$$:
0367 76BC 0460  28         b     @ed_wait              ; Back to editor main
     76BE 7192 
**** **** ****     > tivi.asm.30645
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
0009 76C0 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     76C2 643C 
0010 76C4 0420  54         blwp  @0                    ; Exit
     76C6 0000 
0011               
**** **** ****     > tivi.asm.30645
0346                       copy  "editorkeys_file.asm" ; Actions for file related keys
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
0013 76C8 C804  38         mov   tmp0,@parm1           ; Setup file to load
     76CA 8350 
0014               
0015 76CC 06A0  32         bl    @edb.init             ; Initialize editor buffer
     76CE 7A80 
0016 76D0 06A0  32         bl    @idx.init             ; Initialize index
     76D2 799E 
0017 76D4 06A0  32         bl    @fb.init              ; Initialize framebuffer
     76D6 78C2 
0018                       ;-------------------------------------------------------
0019                       ; Clear VDP screen buffer
0020                       ;-------------------------------------------------------
0021 76D8 06A0  32         bl    @filv
     76DA 60F0 
0022 76DC 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     76DE 0000 
     76E0 0004 
0023               
0024 76E2 C160  34         mov   @fb.screenrows,tmp1
     76E4 2218 
0025 76E6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     76E8 220E 
0026                                                   ; 16 bit part is in tmp2!
0027               
0028 76EA 04C4  14         clr   tmp0                  ; VDP target address
0029 76EC 0205  20         li    tmp1,32               ; Character to fill
     76EE 0020 
0030 76F0 06A0  32         bl    @xfilv                ; Fill VDP
     76F2 60F6 
0031                                                   ; tmp0 = VDP target address
0032                                                   ; tmp1 = Byte to fill
0033                                                   ; tmp2 = Bytes to copy
0034                       ;-------------------------------------------------------
0035                       ; Read DV80 file and display
0036                       ;-------------------------------------------------------
0037 76F4 06A0  32         bl    @tfh.file.read        ; Read specified file
     76F6 7BF4 
0038 76F8 04E0  34         clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
     76FA 2306 
0039 76FC 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     76FE 7476 
0040               
0041               
0042               
0043               edkey.action.buffer0:
0044 7700 0204  20         li   tmp0,fdname0
     7702 7DFE 
0045 7704 10E1  14         jmp  edkey.action.loadfile
0046                                                   ; Load DIS/VAR 80 file into editor buffer
0047               edkey.action.buffer1:
0048 7706 0204  20         li   tmp0,fdname1
     7708 7E0C 
0049 770A 10DE  14         jmp  edkey.action.loadfile
0050                                                   ; Load DIS/VAR 80 file into editor buffer
0051               
0052               edkey.action.buffer2:
0053 770C 0204  20         li   tmp0,fdname2
     770E 7E1C 
0054 7710 10DB  14         jmp  edkey.action.loadfile
0055                                                   ; Load DIS/VAR 80 file into editor buffer
0056               
0057               edkey.action.buffer3:
0058 7712 0204  20         li   tmp0,fdname3
     7714 7E2A 
0059 7716 10D8  14         jmp  edkey.action.loadfile
0060                                                   ; Load DIS/VAR 80 file into editor buffer
0061               
0062               edkey.action.buffer4:
0063 7718 0204  20         li   tmp0,fdname4
     771A 7E38 
0064 771C 10D5  14         jmp  edkey.action.loadfile
0065                                                   ; Load DIS/VAR 80 file into editor buffer
0066               
0067               edkey.action.buffer5:
0068 771E 0204  20         li   tmp0,fdname5
     7720 7E46 
0069 7722 10D2  14         jmp  edkey.action.loadfile
0070                                                   ; Load DIS/VAR 80 file into editor buffer
0071               
0072               edkey.action.buffer6:
0073 7724 0204  20         li   tmp0,fdname6
     7726 7E54 
0074 7728 10CF  14         jmp  edkey.action.loadfile
0075                                                   ; Load DIS/VAR 80 file into editor buffer
0076               
0077               edkey.action.buffer7:
0078 772A 0204  20         li   tmp0,fdname7
     772C 7E62 
0079 772E 10CC  14         jmp  edkey.action.loadfile
0080                                                   ; Load DIS/VAR 80 file into editor buffer
0081               
0082               edkey.action.buffer8:
0083 7730 0204  20         li   tmp0,fdname8
     7732 7E70 
0084 7734 10C9  14         jmp  edkey.action.loadfile
0085                                                   ; Load DIS/VAR 80 file into editor buffer
0086               
0087               edkey.action.buffer9:
0088 7736 0204  20         li   tmp0,fdname9
     7738 7E7E 
0089 773A 10C6  14         jmp  edkey.action.loadfile
0090                                                   ; Load DIS/VAR 80 file into editor buffer
**** **** ****     > tivi.asm.30645
0347               
0348               
0349               
0350               ***************************************************************
0351               * Task 0 - Copy frame buffer to VDP
0352               ***************************************************************
0353 773C C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     773E 2216 
0354 7740 133D  14         jeq   task0.$$              ; No, skip update
0355                       ;------------------------------------------------------
0356                       ; Determine how many rows to copy
0357                       ;------------------------------------------------------
0358 7742 8820  54         c     @edb.lines,@fb.screenrows
     7744 2304 
     7746 2218 
0359 7748 1103  14         jlt   task0.setrows.small
0360 774A C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     774C 2218 
0361 774E 1003  14         jmp   task0.copy.framebuffer
0362                       ;------------------------------------------------------
0363                       ; Less lines in editor buffer as rows in frame buffer
0364                       ;------------------------------------------------------
0365               task0.setrows.small:
0366 7750 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7752 2304 
0367 7754 0585  14         inc   tmp1
0368                       ;------------------------------------------------------
0369                       ; Determine area to copy
0370                       ;------------------------------------------------------
0371               task0.copy.framebuffer:
0372 7756 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7758 220E 
0373                                                   ; 16 bit part is in tmp2!
0374 775A 04C4  14         clr   tmp0                  ; VDP target address
0375 775C C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     775E 2200 
0376                       ;------------------------------------------------------
0377                       ; Copy memory block
0378                       ;------------------------------------------------------
0379 7760 06A0  32         bl    @xpym2v               ; Copy to VDP
     7762 62A0 
0380                                                   ; tmp0 = VDP target address
0381                                                   ; tmp1 = RAM source address
0382                                                   ; tmp2 = Bytes to copy
0383 7764 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7766 2216 
0384                       ;-------------------------------------------------------
0385                       ; Draw EOF marker at end-of-file
0386                       ;-------------------------------------------------------
0387 7768 C120  34         mov   @edb.lines,tmp0
     776A 2304 
0388 776C 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     776E 2204 
0389 7770 0584  14         inc   tmp0                  ; Y++
0390 7772 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7774 2218 
0391 7776 1222  14         jle   task0.$$
0392                       ;-------------------------------------------------------
0393                       ; Draw EOF marker
0394                       ;-------------------------------------------------------
0395               task0.draw_marker:
0396 7778 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     777A 832A 
     777C 2214 
0397 777E 0A84  56         sla   tmp0,8                ; X=0
0398 7780 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7782 832A 
0399 7784 06A0  32         bl    @putstr
     7786 6280 
0400 7788 7DD0                   data txt_marker       ; Display *EOF*
0401                       ;-------------------------------------------------------
0402                       ; Draw empty line after (and below) EOF marker
0403                       ;-------------------------------------------------------
0404 778A 06A0  32         bl    @setx
     778C 638A 
0405 778E 0005                   data  5               ; Cursor after *EOF* string
0406               
0407 7790 C120  34         mov   @wyx,tmp0
     7792 832A 
0408 7794 0984  56         srl   tmp0,8                ; Right justify
0409 7796 0584  14         inc   tmp0                  ; One time adjust
0410 7798 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     779A 2218 
0411 779C 1303  14         jeq   !
0412 779E 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     77A0 009B 
0413 77A2 1002  14         jmp   task0.draw_marker.line
0414 77A4 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     77A6 004B 
0415                       ;-------------------------------------------------------
0416                       ; Draw empty line
0417                       ;-------------------------------------------------------
0418               task0.draw_marker.line:
0419 77A8 0604  14         dec   tmp0                  ; One time adjust
0420 77AA 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     77AC 625C 
0421 77AE 0205  20         li    tmp1,32               ; Character to write (whitespace)
     77B0 0020 
0422 77B2 06A0  32         bl    @xfilv                ; Write characters
     77B4 60F6 
0423 77B6 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     77B8 2214 
     77BA 832A 
0424               *--------------------------------------------------------------
0425               * Task 0 - Exit
0426               *--------------------------------------------------------------
0427               task0.$$:
0428 77BC 0460  28         b     @slotok
     77BE 6FB2 
0429               
0430               
0431               
0432               ***************************************************************
0433               * Task 1 - Copy SAT to VDP
0434               ***************************************************************
0435 77C0 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     77C2 6046 
0436 77C4 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     77C6 6396 
0437 77C8 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     77CA 8380 
0438 77CC 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0439               
0440               
0441               ***************************************************************
0442               * Task 2 - Update cursor shape (blink)
0443               ***************************************************************
0444 77CE 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     77D0 2212 
0445 77D2 1303  14         jeq   task2.cur_visible
0446 77D4 04E0  34         clr   @ramsat+2              ; Hide cursor
     77D6 8382 
0447 77D8 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0448               
0449               task2.cur_visible:
0450 77DA C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     77DC 230C 
0451 77DE 1303  14         jeq   task2.cur_visible.overwrite_mode
0452                       ;------------------------------------------------------
0453                       ; Cursor in insert mode
0454                       ;------------------------------------------------------
0455               task2.cur_visible.insert_mode:
0456 77E0 0204  20         li    tmp0,>000f
     77E2 000F 
0457 77E4 1002  14         jmp   task2.cur_visible.cursorshape
0458                       ;------------------------------------------------------
0459                       ; Cursor in overwrite mode
0460                       ;------------------------------------------------------
0461               task2.cur_visible.overwrite_mode:
0462 77E6 0204  20         li    tmp0,>020f
     77E8 020F 
0463                       ;------------------------------------------------------
0464                       ; Set cursor shape
0465                       ;------------------------------------------------------
0466               task2.cur_visible.cursorshape:
0467 77EA C804  38         mov   tmp0,@fb.curshape
     77EC 2210 
0468 77EE C804  38         mov   tmp0,@ramsat+2
     77F0 8382 
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
0480 77F2 06A0  32         bl    @cpym2v
     77F4 629A 
0481 77F6 2000                   data sprsat,ramsat,4   ; Update sprite
     77F8 8380 
     77FA 0004 
0482               
0483 77FC C820  54         mov   @wyx,@fb.yxsave
     77FE 832A 
     7800 2214 
0484                       ;------------------------------------------------------
0485                       ; Show text editing mode
0486                       ;------------------------------------------------------
0487               task.botline.show_mode
0488 7802 C120  34         mov   @edb.insmode,tmp0
     7804 230C 
0489 7806 1605  14         jne   task.botline.show_mode.insert
0490                       ;------------------------------------------------------
0491                       ; Overwrite mode
0492                       ;------------------------------------------------------
0493               task.botline.show_mode.overwrite:
0494 7808 06A0  32         bl    @putat
     780A 6292 
0495 780C 1D32                   byte  29,50
0496 780E 7DDC                   data  txt_ovrwrite
0497 7810 1004  14         jmp   task.botline.show_changed
0498                       ;------------------------------------------------------
0499                       ; Insert  mode
0500                       ;------------------------------------------------------
0501               task.botline.show_mode.insert:
0502 7812 06A0  32         bl    @putat
     7814 6292 
0503 7816 1D32                   byte  29,50
0504 7818 7DE0                   data  txt_insert
0505                       ;------------------------------------------------------
0506                       ; Show if text was changed in editor buffer
0507                       ;------------------------------------------------------
0508               task.botline.show_changed:
0509 781A C120  34         mov   @edb.dirty,tmp0
     781C 2306 
0510 781E 1305  14         jeq   task.botline.show_changed.clear
0511                       ;------------------------------------------------------
0512                       ; Show "*"
0513                       ;------------------------------------------------------
0514 7820 06A0  32         bl    @putat
     7822 6292 
0515 7824 1D36                   byte 29,54
0516 7826 7DE4                   data txt_star
0517 7828 1001  14         jmp   task.botline.show_linecol
0518                       ;------------------------------------------------------
0519                       ; Show "line,column"
0520                       ;------------------------------------------------------
0521               task.botline.show_changed.clear:
0522 782A 1000  14         nop
0523               task.botline.show_linecol:
0524 782C C820  54         mov   @fb.row,@parm1
     782E 2206 
     7830 8350 
0525 7832 06A0  32         bl    @fb.row2line
     7834 78FC 
0526 7836 05A0  34         inc   @outparm1
     7838 8360 
0527                       ;------------------------------------------------------
0528                       ; Show line
0529                       ;------------------------------------------------------
0530 783A 06A0  32         bl    @putnum
     783C 6666 
0531 783E 1D40                   byte  29,64            ; YX
0532 7840 8360                   data  outparm1,rambuf
     7842 8390 
0533 7844 3020                   byte  48               ; ASCII offset
0534                             byte  32               ; Padding character
0535                       ;------------------------------------------------------
0536                       ; Show comma
0537                       ;------------------------------------------------------
0538 7846 06A0  32         bl    @putat
     7848 6292 
0539 784A 1D45                   byte  29,69
0540 784C 7DCE                   data  txt_delim
0541                       ;------------------------------------------------------
0542                       ; Show column
0543                       ;------------------------------------------------------
0544 784E 06A0  32         bl    @film
     7850 60CC 
0545 7852 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7854 0020 
     7856 000C 
0546               
0547 7858 C820  54         mov   @fb.column,@waux1
     785A 220C 
     785C 833C 
0548 785E 05A0  34         inc   @waux1                 ; Offset 1
     7860 833C 
0549               
0550 7862 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7864 65E8 
0551 7866 833C                   data  waux1,rambuf
     7868 8390 
0552 786A 3020                   byte  48               ; ASCII offset
0553                             byte  32               ; Fill character
0554               
0555 786C 06A0  32         bl    @trimnum               ; Trim number to the left
     786E 6640 
0556 7870 8390                   data  rambuf,rambuf+6,32
     7872 8396 
     7874 0020 
0557               
0558 7876 0204  20         li    tmp0,>0200
     7878 0200 
0559 787A D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     787C 8396 
0560               
0561 787E 06A0  32         bl    @putat
     7880 6292 
0562 7882 1D46                   byte 29,70
0563 7884 8396                   data rambuf+6          ; Show column
0564                       ;------------------------------------------------------
0565                       ; Show lines in buffer unless on last line in file
0566                       ;------------------------------------------------------
0567 7886 C820  54         mov   @fb.row,@parm1
     7888 2206 
     788A 8350 
0568 788C 06A0  32         bl    @fb.row2line
     788E 78FC 
0569 7890 8820  54         c     @edb.lines,@outparm1
     7892 2304 
     7894 8360 
0570 7896 1605  14         jne   task.botline.show_lines_in_buffer
0571               
0572 7898 06A0  32         bl    @putat
     789A 6292 
0573 789C 1D49                   byte 29,73
0574 789E 7DD6                   data txt_bottom
0575               
0576 78A0 100B  14         jmp   task.botline.$$
0577                       ;------------------------------------------------------
0578                       ; Show lines in buffer
0579                       ;------------------------------------------------------
0580               task.botline.show_lines_in_buffer:
0581 78A2 C820  54         mov   @edb.lines,@waux1
     78A4 2304 
     78A6 833C 
0582 78A8 05A0  34         inc   @waux1                 ; Offset 1
     78AA 833C 
0583 78AC 06A0  32         bl    @putnum
     78AE 6666 
0584 78B0 1D49                   byte 29,73             ; YX
0585 78B2 833C                   data waux1,rambuf
     78B4 8390 
0586 78B6 3020                   byte 48
0587                             byte 32
0588                       ;------------------------------------------------------
0589                       ; Exit
0590                       ;------------------------------------------------------
0591               task.botline.$$
0592 78B8 C820  54         mov   @fb.yxsave,@wyx
     78BA 2214 
     78BC 832A 
0593 78BE 0460  28         b     @slotok                ; Exit running task
     78C0 6FB2 
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
0022               ********@*****@*********************@**************************
0023               fb.init
0024 78C2 0649  14         dect  stack
0025 78C4 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 78C6 0204  20         li    tmp0,fb.top
     78C8 2650 
0030 78CA C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     78CC 2200 
0031 78CE 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     78D0 2204 
0032 78D2 04E0  34         clr   @fb.row               ; Current row=0
     78D4 2206 
0033 78D6 04E0  34         clr   @fb.column            ; Current column=0
     78D8 220C 
0034 78DA 0204  20         li    tmp0,80
     78DC 0050 
0035 78DE C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     78E0 220E 
0036 78E2 0204  20         li    tmp0,29
     78E4 001D 
0037 78E6 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     78E8 2218 
0038 78EA 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     78EC 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 78EE 06A0  32         bl    @film
     78F0 60CC 
0043 78F2 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     78F4 0000 
     78F6 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 78F8 0460  28         b     @poprt                ; Return to caller
     78FA 60C8 
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
0073 78FC 0649  14         dect  stack
0074 78FE C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 7900 C120  34         mov   @parm1,tmp0
     7902 8350 
0079 7904 A120  34         a     @fb.topline,tmp0
     7906 2204 
0080 7908 C804  38         mov   tmp0,@outparm1
     790A 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 790C 0460  28         b    @poprt                 ; Return to caller
     790E 60C8 
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
0113 7910 0649  14         dect  stack
0114 7912 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7914 C1A0  34         mov   @fb.row,tmp2
     7916 2206 
0119 7918 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     791A 220E 
0120 791C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     791E 220C 
0121 7920 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7922 2200 
0122 7924 C807  38         mov   tmp3,@fb.current
     7926 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7928 0460  28         b    @poprt                 ; Return to caller
     792A 60C8 
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
0145 792C 0649  14         dect  stack
0146 792E C64B  30         mov   r11,*stack            ; Save return address
0147                       ;------------------------------------------------------
0148                       ; Setup starting position in index
0149                       ;------------------------------------------------------
0150 7930 C820  54         mov   @parm1,@fb.topline
     7932 8350 
     7934 2204 
0151 7936 04E0  34         clr   @parm2                ; Target row in frame buffer
     7938 8352 
0152                       ;------------------------------------------------------
0153                       ; Unpack line to frame buffer
0154                       ;------------------------------------------------------
0155               fb.refresh.unpack_line:
0156 793A 06A0  32         bl    @edb.line.unpack
     793C 7B34 
0157 793E 05A0  34         inc   @parm1                ; Next line in editor buffer
     7940 8350 
0158 7942 05A0  34         inc   @parm2                ; Next row in frame buffer
     7944 8352 
0159 7946 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7948 8352 
     794A 2218 
0160 794C 11F6  14         jlt   fb.refresh.unpack_line
0161 794E 0720  34         seto  @fb.dirty             ; Refresh screen
     7950 2216 
0162                       ;------------------------------------------------------
0163                       ; Exit
0164                       ;------------------------------------------------------
0165               fb.refresh.$$
0166 7952 0460  28         b    @poprt                 ; Return to caller
     7954 60C8 
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
0182 7956 0649  14         dect  stack
0183 7958 C64B  30         mov   r11,*stack            ; Save return address
0184                       ;------------------------------------------------------
0185                       ; Prepare for scanning
0186                       ;------------------------------------------------------
0187 795A 04E0  34         clr   @fb.column
     795C 220C 
0188 795E 06A0  32         bl    @fb.calc_pointer
     7960 7910 
0189 7962 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7964 7BD0 
0190 7966 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7968 2208 
0191 796A 1313  14         jeq   fb.get.firstnonblank.nomatch
0192                                                   ; Exit if empty line
0193 796C C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     796E 2202 
0194 7970 04C5  14         clr   tmp1
0195                       ;------------------------------------------------------
0196                       ; Scan line for non-blank character
0197                       ;------------------------------------------------------
0198               fb.get.firstnonblank.loop:
0199 7972 D174  28         movb  *tmp0+,tmp1           ; Get character
0200 7974 130E  14         jeq   fb.get.firstnonblank.nomatch
0201                                                   ; Exit if empty line
0202 7976 0285  22         ci    tmp1,>2000            ; Whitespace?
     7978 2000 
0203 797A 1503  14         jgt   fb.get.firstnonblank.match
0204 797C 0606  14         dec   tmp2                  ; Counter--
0205 797E 16F9  14         jne   fb.get.firstnonblank.loop
0206 7980 1008  14         jmp   fb.get.firstnonblank.nomatch
0207                       ;------------------------------------------------------
0208                       ; Non-blank character found
0209                       ;------------------------------------------------------
0210               fb.get.firstnonblank.match
0211 7982 6120  34         s     @fb.current,tmp0      ; Calculate column
     7984 2202 
0212 7986 0604  14         dec   tmp0
0213 7988 C804  38         mov   tmp0,@outparm1        ; Save column
     798A 8360 
0214 798C D805  38         movb  tmp1,@outparm2        ; Save character
     798E 8362 
0215 7990 1004  14         jmp   fb.get.firstnonblank.$$
0216                       ;------------------------------------------------------
0217                       ; No non-blank character found
0218                       ;------------------------------------------------------
0219               fb.get.firstnonblank.nomatch
0220 7992 04E0  34         clr   @outparm1             ; X=0
     7994 8360 
0221 7996 04E0  34         clr   @outparm2             ; Null
     7998 8362 
0222                       ;------------------------------------------------------
0223                       ; Exit
0224                       ;------------------------------------------------------
0225               fb.get.firstnonblank.$$
0226 799A 0460  28         b    @poprt                 ; Return to caller
     799C 60C8 
0227               
0228               
0229               
0230               
0231               
0232               
**** **** ****     > tivi.asm.30645
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
0030 799E 0649  14         dect  stack
0031 79A0 C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Initialize
0034                       ;------------------------------------------------------
0035 79A2 0204  20         li    tmp0,idx.top
     79A4 3000 
0036 79A6 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     79A8 2302 
0037                       ;------------------------------------------------------
0038                       ; Create index slot 0
0039                       ;------------------------------------------------------
0040 79AA 06A0  32         bl    @film
     79AC 60CC 
0041 79AE 3000             data  idx.top,>00,idx.size  ; Clear index
     79B0 0000 
     79B2 1000 
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               idx.init.$$:
0046 79B4 0460  28         b     @poprt                ; Return to caller
     79B6 60C8 
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
0061               * @parm4    = SAMS bank
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * @outparm1 = Pointer to updated index entry
0065               *--------------------------------------------------------------
0066               * Register usage
0067               * tmp0,tmp1,tmp2
0068               *--------------------------------------------------------------
0069               idx.entry.update:
0070 79B8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     79BA 8350 
0071                       ;------------------------------------------------------
0072                       ; Calculate address of index entry and update
0073                       ;------------------------------------------------------
0074 79BC 0A24  56         sla   tmp0,2                ; line number * 4
0075 79BE C920  54         mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
     79C0 8352 
     79C2 3000 
0076                       ;------------------------------------------------------
0077                       ; Put SAMS bank and length of string into index
0078                       ;------------------------------------------------------
0079 79C4 C160  34         mov   @parm3,tmp1           ; Put line length in LSB tmp1
     79C6 8354 
0080               
0081 79C8 C1A0  34         mov   @parm4,tmp2           ; \
     79CA 8356 
0082 79CC 06C6  14         swpb  tmp2                  ; | Put SAMS bank in MSB tmp1
0083 79CE D146  18         movb  tmp2,tmp1             ; /
0084               
0085 79D0 C905  38         mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> SAMS Bank/Length
     79D2 3002 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               idx.entry.update.$$:
0090 79D4 C804  38         mov   tmp0,@outparm1        ; Pointer to update index entry
     79D6 8360 
0091 79D8 045B  20         b     *r11                  ; Return
0092               
0093               
0094               ***************************************************************
0095               * idx.entry.delete
0096               * Delete index entry - Close gap created by delete
0097               ***************************************************************
0098               * bl @idx.entry.delete
0099               *--------------------------------------------------------------
0100               * INPUT
0101               * @parm1    = Line number in editor buffer to delete
0102               * @parm2    = Line number of last line to check for reorg
0103               *--------------------------------------------------------------
0104               * OUTPUT
0105               * @outparm1 = Pointer to deleted line (for undo)
0106               *--------------------------------------------------------------
0107               * Register usage
0108               * tmp0,tmp2
0109               *--------------------------------------------------------------
0110               idx.entry.delete:
0111 79DA C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     79DC 8350 
0112                       ;------------------------------------------------------
0113                       ; Calculate address of index entry and save pointer
0114                       ;------------------------------------------------------
0115 79DE 0A24  56         sla   tmp0,2                ; line number * 4
0116 79E0 C824  54         mov   @idx.top(tmp0),@outparm1
     79E2 3000 
     79E4 8360 
0117                                                   ; Pointer to deleted line
0118                       ;------------------------------------------------------
0119                       ; Prepare for index reorg
0120                       ;------------------------------------------------------
0121 79E6 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     79E8 8352 
0122 79EA 61A0  34         s     @parm1,tmp2           ; Calculate loop
     79EC 8350 
0123 79EE 1605  14         jne   idx.entry.delete.reorg
0124                       ;------------------------------------------------------
0125                       ; Special treatment if last line
0126                       ;------------------------------------------------------
0127 79F0 0724  34         seto  @idx.top+0(tmp0)
     79F2 3000 
0128 79F4 04E4  34         clr   @idx.top+2(tmp0)
     79F6 3002 
0129 79F8 100A  14         jmp   idx.entry.delete.$$
0130                       ;------------------------------------------------------
0131                       ; Reorganize index entries
0132                       ;------------------------------------------------------
0133               idx.entry.delete.reorg:
0134 79FA C924  54         mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
     79FC 3004 
     79FE 3000 
0135 7A00 C924  54         mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
     7A02 3006 
     7A04 3002 
0136 7A06 0224  22         ai    tmp0,4                ; Next index entry
     7A08 0004 
0137               
0138 7A0A 0606  14         dec   tmp2                  ; tmp2--
0139 7A0C 16F6  14         jne   idx.entry.delete.reorg
0140                                                   ; Loop unless completed
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               idx.entry.delete.$$:
0145 7A0E 045B  20         b     *r11                  ; Return
0146               
0147               
0148               ***************************************************************
0149               * idx.entry.insert
0150               * Insert index entry
0151               ***************************************************************
0152               * bl @idx.entry.insert
0153               *--------------------------------------------------------------
0154               * INPUT
0155               * @parm1    = Line number in editor buffer to insert
0156               * @parm2    = Line number of last line to check for reorg
0157               *--------------------------------------------------------------
0158               * OUTPUT
0159               * NONE
0160               *--------------------------------------------------------------
0161               * Register usage
0162               * tmp0,tmp2
0163               *--------------------------------------------------------------
0164               idx.entry.insert:
0165 7A10 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7A12 8352 
0166                       ;------------------------------------------------------
0167                       ; Calculate address of index entry and save pointer
0168                       ;------------------------------------------------------
0169 7A14 0A24  56         sla   tmp0,2                ; line number * 4
0170                       ;------------------------------------------------------
0171                       ; Prepare for index reorg
0172                       ;------------------------------------------------------
0173 7A16 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7A18 8352 
0174 7A1A 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7A1C 8350 
0175 7A1E 160B  14         jne   idx.entry.insert.reorg
0176                       ;------------------------------------------------------
0177                       ; Special treatment if last line
0178                       ;------------------------------------------------------
0179 7A20 C924  54         mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     7A22 3000 
     7A24 3004 
0180 7A26 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7A28 3002 
     7A2A 3006 
0181 7A2C 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
     7A2E 3000 
0182 7A30 04E4  34         clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
     7A32 3002 
0183 7A34 100F  14         jmp   idx.entry.insert.$$
0184                       ;------------------------------------------------------
0185                       ; Reorganize index entries
0186                       ;------------------------------------------------------
0187               idx.entry.insert.reorg:
0188 7A36 05C6  14         inct  tmp2                  ; Adjust one time
0189 7A38 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     7A3A 3000 
     7A3C 3004 
0190 7A3E C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7A40 3002 
     7A42 3006 
0191 7A44 0224  22         ai    tmp0,-4               ; Previous index entry
     7A46 FFFC 
0192               
0193 7A48 0606  14         dec   tmp2                  ; tmp2--
0194 7A4A 16F6  14         jne   -!                    ; Loop unless completed
0195 7A4C 04E4  34         clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
     7A4E 3008 
0196 7A50 04E4  34         clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
     7A52 300A 
0197                       ;------------------------------------------------------
0198                       ; Exit
0199                       ;------------------------------------------------------
0200               idx.entry.insert.$$:
0201 7A54 045B  20         b     *r11                  ; Return
0202               
0203               
0204               
0205               ***************************************************************
0206               * idx.pointer.get
0207               * Get pointer to editor buffer line content
0208               ***************************************************************
0209               * bl @idx.pointer.get
0210               *--------------------------------------------------------------
0211               * INPUT
0212               * @parm1 = Line number in editor buffer
0213               *--------------------------------------------------------------
0214               * OUTPUT
0215               * @outparm1 = Pointer to editor buffer line content
0216               * @outparm2 = Line length
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * tmp0,tmp1,tmp2
0220               *--------------------------------------------------------------
0221               idx.pointer.get:
0222 7A56 0649  14         dect  stack
0223 7A58 C64B  30         mov   r11,*stack            ; Save return address
0224                       ;------------------------------------------------------
0225                       ; Get pointer
0226                       ;------------------------------------------------------
0227 7A5A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7A5C 8350 
0228                       ;------------------------------------------------------
0229                       ; Calculate index entry
0230                       ;------------------------------------------------------
0231 7A5E 0A24  56         sla   tmp0,2                     ; line number * 4
0232 7A60 C824  54         mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
     7A62 3000 
     7A64 8360 
0233                       ;------------------------------------------------------
0234                       ; Get SAMS page
0235                       ;------------------------------------------------------
0236 7A66 C164  34         mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
     7A68 3002 
0237 7A6A 0985  56         srl   tmp1,8                ; Right justify
0238 7A6C C805  38         mov   tmp1,@outparm2
     7A6E 8362 
0239                       ;------------------------------------------------------
0240                       ; Get line length
0241                       ;------------------------------------------------------
0242 7A70 C164  34         mov   @idx.top+2(tmp0),tmp1
     7A72 3002 
0243 7A74 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     7A76 00FF 
0244 7A78 C805  38         mov   tmp1,@outparm3
     7A7A 8364 
0245                       ;------------------------------------------------------
0246                       ; Exit
0247                       ;------------------------------------------------------
0248               idx.pointer.get.$$:
0249 7A7C 0460  28         b     @poprt                ; Return to caller
     7A7E 60C8 
**** **** ****     > tivi.asm.30645
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
0026 7A80 0649  14         dect  stack
0027 7A82 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7A84 0204  20         li    tmp0,edb.top
     7A86 A000 
0032 7A88 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7A8A 2300 
0033 7A8C C804  38         mov   tmp0,@edb.next_free.ptr
     7A8E 2308 
0034                                                   ; Set pointer to next free line in editor buffer
0035 7A90 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7A92 230C 
0036 7A94 04E0  34         clr   @edb.lines            ; Lines=0
     7A96 2304 
0037               
0038               edb.init.$$:
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042 7A98 0460  28         b     @poprt                ; Return to caller
     7A9A 60C8 
0043               
0044               
0045               
0046               ***************************************************************
0047               * edb.line.pack
0048               * Pack current line in framebuffer
0049               ***************************************************************
0050               *  bl   @edb.line.pack
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * @fb.top       = Address of top row in frame buffer
0054               * @fb.row       = Current row in frame buffer
0055               * @fb.column    = Current column in frame buffer
0056               * @fb.colsline  = Columns per line in frame buffer
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               *--------------------------------------------------------------
0060               * Register usage
0061               * tmp0,tmp1,tmp2
0062               *--------------------------------------------------------------
0063               * Memory usage
0064               * rambuf   = Saved @fb.column
0065               * rambuf+2 = Saved beginning of row
0066               * rambuf+4 = Saved length of row
0067               ********@*****@*********************@**************************
0068               edb.line.pack:
0069 7A9C 0649  14         dect  stack
0070 7A9E C64B  30         mov   r11,*stack            ; Save return address
0071                       ;------------------------------------------------------
0072                       ; Get values
0073                       ;------------------------------------------------------
0074 7AA0 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7AA2 220C 
     7AA4 8390 
0075 7AA6 04E0  34         clr   @fb.column
     7AA8 220C 
0076 7AAA 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7AAC 7910 
0077                       ;------------------------------------------------------
0078                       ; Prepare scan
0079                       ;------------------------------------------------------
0080 7AAE 04C4  14         clr   tmp0                  ; Counter
0081 7AB0 C160  34         mov   @fb.current,tmp1      ; Get position
     7AB2 2202 
0082 7AB4 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7AB6 8392 
0083                       ;------------------------------------------------------
0084                       ; Scan line for >00 byte termination
0085                       ;------------------------------------------------------
0086               edb.line.pack.scan:
0087 7AB8 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0088 7ABA 0986  56         srl   tmp2,8                ; Right justify
0089 7ABC 1302  14         jeq   edb.line.pack.checklength
0090                                                   ; Stop scan if >00 found
0091 7ABE 0584  14         inc   tmp0                  ; Increase string length
0092 7AC0 10FB  14         jmp   edb.line.pack.scan    ; Next character
0093                       ;------------------------------------------------------
0094                       ; Handle line placement depending on length
0095                       ;------------------------------------------------------
0096               edb.line.pack.checklength:
0097 7AC2 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     7AC4 2204 
     7AC6 8350 
0098 7AC8 A820  54         a     @fb.row,@parm1        ; /
     7ACA 2206 
     7ACC 8350 
0099               
0100 7ACE C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     7AD0 8394 
0101 7AD2 1507  14         jgt   edb.line.pack.checklength2
0102                       ;------------------------------------------------------
0103                       ; Special handling if empty line (length=0)
0104                       ;------------------------------------------------------
0105 7AD4 04E0  34         clr   @parm2                ; Clear line content
     7AD6 8352 
0106               
0107 7AD8 04E0  34         clr   @parm3                ; Set length of line
     7ADA 8354 
0108 7ADC 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     7ADE 79B8 
0109                                                   ; parm2=line content
0110                                                   ; parm3=line length
0111               
0112 7AE0 1024  14         jmp   edb.line.pack.$$      ; Exit
0113                       ;------------------------------------------------------
0114                       ; Put line content in index itself if line length <= 2
0115                       ;------------------------------------------------------
0116               edb.line.pack.checklength2:
0117 7AE2 0284  22         ci    tmp0,2
     7AE4 0002 
0118 7AE6 150D  14         jgt   edb.line.pack.idx.normal
0119               
0120 7AE8 04E0  34         clr   @parm2
     7AEA 8352 
0121 7AEC C160  34         mov   @rambuf+2,tmp1
     7AEE 8392 
0122 7AF0 D835  48         movb  *tmp1+,@parm2         ; Copy 1st charcter
     7AF2 8352 
0123 7AF4 D835  48         movb  *tmp1+,@parm2+1       ; Copy 2nd charcter
     7AF6 8353 
0124               
0125 7AF8 C804  38         mov   tmp0,@parm3           ; Set length of line
     7AFA 8354 
0126 7AFC 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     7AFE 79B8 
0127                                                   ; parm2=line content
0128                                                   ; parm3=line length
0129               
0130 7B00 1014  14         jmp   edb.line.pack.$$      ; Exit
0131                       ;------------------------------------------------------
0132                       ; Update index and store line in editor buffer
0133                       ;------------------------------------------------------
0134               edb.line.pack.idx.normal:
0135 7B02 C820  54         mov   @edb.next_free.ptr,@parm2
     7B04 2308 
     7B06 8352 
0136                                                   ; Block where packed string will reside
0137 7B08 C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     7B0A 8394 
0138               
0139 7B0C C804  38         mov   tmp0,@parm3           ; Set length of line
     7B0E 8354 
0140 7B10 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     7B12 79B8 
0141                                                   ; parm2=pointer to line in editor buffer
0142                                                   ; parm3=line length
0143                       ;------------------------------------------------------
0144                       ; Pack line from framebuffer to editor buffer
0145                       ;------------------------------------------------------
0146 7B14 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7B16 8392 
0147 7B18 C160  34         mov   @edb.next_free.ptr,tmp1
     7B1A 2308 
0148                                                   ; Destination for memory copy
0149 7B1C C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     7B1E 8394 
0150                       ;------------------------------------------------------
0151                       ; Copy memory block
0152                       ;------------------------------------------------------
0153               edb.line.pack.idx.normal.copy:
0154 7B20 06A0  32         bl    @xpym2m               ; Copy memory block
     7B22 62E8 
0155                                                   ;   tmp0 = source
0156                                                   ;   tmp1 = destination
0157                                                   ;   tmp2 = bytes to copy
0158 7B24 A820  54         a     @rambuf+4,@edb.next_free.ptr
     7B26 8394 
     7B28 2308 
0159                                                   ; Update pointer to next free block
0160                       ;------------------------------------------------------
0161                       ; Exit
0162                       ;------------------------------------------------------
0163               edb.line.pack.$$:
0164 7B2A C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7B2C 8390 
     7B2E 220C 
0165 7B30 0460  28         b     @poprt                ; Return to caller
     7B32 60C8 
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
0182               * tmp0,tmp1,tmp2
0183               *--------------------------------------------------------------
0184               * Memory usage
0185               * rambuf   = Saved @parm1 of edb.line.unpack
0186               * rambuf+2 = Saved @parm2 of edb.line.unpack
0187               * rambuf+4 = Source memory address in editor buffer
0188               * rambuf+6 = Destination memory address in frame buffer
0189               * rambuf+8 = Length of unpacked line
0190               ********@*****@*********************@**************************
0191               edb.line.unpack:
0192 7B34 0649  14         dect  stack
0193 7B36 C64B  30         mov   r11,*stack            ; Save return address
0194                       ;------------------------------------------------------
0195                       ; Save parameters
0196                       ;------------------------------------------------------
0197 7B38 C820  54         mov   @parm1,@rambuf
     7B3A 8350 
     7B3C 8390 
0198 7B3E C820  54         mov   @parm2,@rambuf+2
     7B40 8352 
     7B42 8392 
0199                       ;------------------------------------------------------
0200                       ; Calculate offset in frame buffer
0201                       ;------------------------------------------------------
0202 7B44 C120  34         mov   @fb.colsline,tmp0
     7B46 220E 
0203 7B48 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7B4A 8352 
0204 7B4C C1A0  34         mov   @fb.top.ptr,tmp2
     7B4E 2200 
0205 7B50 A146  18         a     tmp2,tmp1             ; Add base to offset
0206 7B52 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7B54 8396 
0207                       ;------------------------------------------------------
0208                       ; Get length of line to unpack
0209                       ;------------------------------------------------------
0210 7B56 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7B58 7BB0 
0211                                                   ; parm1 = Line number
0212 7B5A C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7B5C 8360 
     7B5E 8398 
0213                       ;------------------------------------------------------
0214                       ; Index. Calculate address of entry and get pointer
0215                       ;------------------------------------------------------
0216 7B60 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     7B62 7A56 
0217                                                   ; parm1 = Line number
0218 7B64 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address in editor buffer
     7B66 8360 
     7B68 8394 
0219                       ;------------------------------------------------------
0220                       ; Clear end of future row in framebuffer
0221                       ;------------------------------------------------------
0222               edb.line.unpack.clear:
0223 7B6A C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7B6C 8396 
0224 7B6E A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7B70 8398 
0225 7B72 4120  34         szc   @wbit1,tmp0           ; (1) Make address even (faster fill MOV)
     7B74 6044 
0226 7B76 04C5  14         clr   tmp1                  ; Fill with >00
0227 7B78 C1A0  34         mov   @fb.colsline,tmp2
     7B7A 220E 
0228 7B7C 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7B7E 8398 
0229 7B80 0586  14         inc   tmp2                  ; Compensate due to (1)
0230 7B82 06A0  32         bl    @xfilm                ; Clear rest of row
     7B84 60D2 
0231                       ;------------------------------------------------------
0232                       ; Copy line from editor buffer to frame buffer
0233                       ;------------------------------------------------------
0234               edb.line.unpack.copy:
0235 7B86 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7B88 8394 
0236                                                   ; or line content itself if line length <= 2.
0237               
0238 7B8A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7B8C 8396 
0239 7B8E C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     7B90 8398 
0240                       ;------------------------------------------------------
0241                       ; Special treatment for lines with length <= 2
0242                       ;------------------------------------------------------
0243 7B92 130C  14         jeq   edb.line.unpack.$$    ; Exit if length = 0
0244 7B94 0286  22         ci    tmp2,2
     7B96 0002 
0245 7B98 1306  14         jeq   edb.line.unpack.copy.word
0246 7B9A 0286  22         ci    tmp2,1
     7B9C 0001 
0247 7B9E 1305  14         jeq   edb.line.unpack.copy.byte
0248                       ;------------------------------------------------------
0249                       ; Copy memory block
0250                       ;------------------------------------------------------
0251 7BA0 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7BA2 62E8 
0252                                                   ;   tmp0 = Source address
0253                                                   ;   tmp1 = Target address
0254                                                   ;   tmp2 = Bytes to copy
0255 7BA4 1003  14         jmp   edb.line.unpack.$$
0256                       ;------------------------------------------------------
0257                       ; Copy single word (could be on uneven address!)
0258                       ;------------------------------------------------------
0259               edb.line.unpack.copy.word:
0260 7BA6 C544  30         mov   tmp0,*tmp1            ; Copy word
0261 7BA8 1001  14         jmp   edb.line.unpack.$$
0262               edb.line.unpack.copy.byte:
0263 7BAA DD44  32         movb  tmp0,*tmp1+           ; Copy byte
0264                       ;------------------------------------------------------
0265                       ; Exit
0266                       ;------------------------------------------------------
0267               edb.line.unpack.$$:
0268 7BAC 0460  28         b     @poprt                ; Return to caller
     7BAE 60C8 
0269               
0270               
0271               
0272               
0273               ***************************************************************
0274               * edb.line.getlength
0275               * Get length of specified line
0276               ***************************************************************
0277               *  bl   @edb.line.getlength
0278               *--------------------------------------------------------------
0279               * INPUT
0280               * @parm1 = Line number
0281               *--------------------------------------------------------------
0282               * OUTPUT
0283               * @outparm1 = Length of line
0284               *--------------------------------------------------------------
0285               * Register usage
0286               * tmp0,tmp1
0287               ********@*****@*********************@**************************
0288               edb.line.getlength:
0289 7BB0 0649  14         dect  stack
0290 7BB2 C64B  30         mov   r11,*stack            ; Save return address
0291                       ;------------------------------------------------------
0292                       ; Get length
0293                       ;------------------------------------------------------
0294 7BB4 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7BB6 220C 
     7BB8 8390 
0295 7BBA C120  34         mov   @parm1,tmp0           ; Get specified line
     7BBC 8350 
0296 7BBE 0A24  56         sla   tmp0,2                ; Line number * 4
0297 7BC0 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7BC2 3002 
0298 7BC4 0245  22         andi  tmp1,>00ff            ; Get rid of packed length
     7BC6 00FF 
0299 7BC8 C805  38         mov   tmp1,@outparm1        ; Save line length
     7BCA 8360 
0300                       ;------------------------------------------------------
0301                       ; Exit
0302                       ;------------------------------------------------------
0303               edb.line.getlength.$$:
0304 7BCC 0460  28         b     @poprt                ; Return to caller
     7BCE 60C8 
0305               
0306               
0307               
0308               
0309               ***************************************************************
0310               * edb.line.getlength2
0311               * Get length of current row (as seen from editor buffer side)
0312               ***************************************************************
0313               *  bl   @edb.line.getlength2
0314               *--------------------------------------------------------------
0315               * INPUT
0316               * @fb.row = Row in frame buffer
0317               *--------------------------------------------------------------
0318               * OUTPUT
0319               * @fb.row.length = Length of row
0320               *--------------------------------------------------------------
0321               * Register usage
0322               * tmp0,tmp1
0323               ********@*****@*********************@**************************
0324               edb.line.getlength2:
0325 7BD0 0649  14         dect  stack
0326 7BD2 C64B  30         mov   r11,*stack            ; Save return address
0327                       ;------------------------------------------------------
0328                       ; Get length
0329                       ;------------------------------------------------------
0330 7BD4 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7BD6 220C 
     7BD8 8390 
0331 7BDA C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7BDC 2204 
0332 7BDE A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7BE0 2206 
0333 7BE2 0A24  56         sla   tmp0,2                ; Line number * 4
0334 7BE4 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7BE6 3002 
0335 7BE8 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7BEA 00FF 
0336 7BEC C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7BEE 2208 
0337                       ;------------------------------------------------------
0338                       ; Exit
0339                       ;------------------------------------------------------
0340               edb.line.getlength2.$$:
0341 7BF0 0460  28         b     @poprt                ; Return to caller
     7BF2 60C8 
0342               
**** **** ****     > tivi.asm.30645
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
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0, tmp1, tmp2, tmp4
0022               *--------------------------------------------------------------
0023               * The frame buffer is temporarily used for compressing the line
0024               * before it is moved to the editor buffer
0025               ********@*****@*********************@**************************
0026               tfh.file.read:
0027 7BF4 0649  14         dect  stack
0028 7BF6 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialisation
0031                       ;------------------------------------------------------
0032 7BF8 04E0  34         clr   @tfh.records          ; Reset records counter
     7BFA 242E 
0033 7BFC 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7BFE 2434 
0034 7C00 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     7C02 2432 
0035 7C04 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0036 7C06 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7C08 242A 
0037 7C0A 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7C0C 242C 
0038                       ;------------------------------------------------------
0039                       ; Show loading indicator and file descriptor
0040                       ;------------------------------------------------------
0041 7C0E 06A0  32         bl    @hchar
     7C10 6468 
0042 7C12 1D00                   byte 29,0,32,80
     7C14 2050 
0043 7C16 FFFF                   data EOL
0044               
0045 7C18 06A0  32         bl    @putat
     7C1A 6292 
0046 7C1C 1D00                   byte 29,0
0047 7C1E 7DE6                   data txt_loading      ; Display "Loading...."
0048               
0049 7C20 06A0  32         bl    @at
     7C22 6374 
0050 7C24 1D0B                   byte 29,11            ; Cursor YX position
0051 7C26 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7C28 8350 
0052 7C2A 06A0  32         bl    @xutst0               ; Display device/filename
     7C2C 6282 
0053               
0054                       ;------------------------------------------------------
0055                       ; Copy PAB header to VDP
0056                       ;------------------------------------------------------
0057 7C2E 06A0  32         bl    @cpym2v
     7C30 629A 
0058 7C32 0A60                   data tfh.vpab,tfh.file.pab.header,9
     7C34 7DA8 
     7C36 0009 
0059                                                   ; Copy PAB header to VDP
0060                       ;------------------------------------------------------
0061                       ; Append file descriptor to PAB header in VDP
0062                       ;------------------------------------------------------
0063 7C38 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     7C3A 0A69 
0064 7C3C C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7C3E 8350 
0065 7C40 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0066 7C42 0986  56         srl   tmp2,8                ; Right justify
0067 7C44 0586  14         inc   tmp2                  ; Include length byte as well
0068 7C46 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     7C48 62A0 
0069                       ;------------------------------------------------------
0070                       ; Load GPL scratchpad layout
0071                       ;------------------------------------------------------
0072 7C4A 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7C4C 6D5E 
0073 7C4E 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0074                       ;------------------------------------------------------
0075                       ; Open file
0076                       ;------------------------------------------------------
0077 7C50 06A0  32         bl    @file.open
     7C52 6EAC 
0078 7C54 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0079 7C56 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7C58 6042 
0080 7C5A 1602  14         jne   tfh.file.read.record
0081 7C5C 0460  28         b     @tfh.file.read.error  ; Yes, IO error occured
     7C5E 7D60 
0082                       ;------------------------------------------------------
0083                       ; Step 1: Read file record
0084                       ;------------------------------------------------------
0085               tfh.file.read.record:
0086 7C60 05A0  34         inc   @tfh.records          ; Update counter
     7C62 242E 
0087 7C64 04E0  34         clr   @tfh.reclen           ; Reset record length
     7C66 2430 
0088               
0089 7C68 06A0  32         bl    @file.record.read     ; Read record
     7C6A 6EEE 
0090 7C6C 0A60                   data tfh.vpab         ; tmp0=Status byte
0091                                                   ; tmp1=Bytes read
0092                                                   ; tmp2=Status register contents upon DSRLNK return
0093               
0094 7C6E C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7C70 242A 
0095 7C72 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7C74 2430 
0096 7C76 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7C78 242C 
0097                       ;------------------------------------------------------
0098                       ; 1a: Calculate kilobytes processed
0099                       ;------------------------------------------------------
0100 7C7A A805  38         a     tmp1,@tfh.counter
     7C7C 2434 
0101 7C7E A160  34         a     @tfh.counter,tmp1
     7C80 2434 
0102 7C82 0285  22         ci    tmp1,1024
     7C84 0400 
0103 7C86 1106  14         jlt   !
0104 7C88 05A0  34         inc   @tfh.kilobytes
     7C8A 2432 
0105 7C8C 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7C8E FC00 
0106 7C90 C805  38         mov   tmp1,@tfh.counter
     7C92 2434 
0107                       ;------------------------------------------------------
0108                       ; 1b: Load spectra scratchpad layout
0109                       ;------------------------------------------------------
0110 7C94 06A0  32 !       bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7C96 675A 
0111 7C98 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7C9A 6D80 
0112 7C9C 2100                   data scrpad.backup2   ; / >2100->8300
0113                       ;------------------------------------------------------
0114                       ; 1c: Check if a file error occured
0115                       ;------------------------------------------------------
0116               tfh.file.read.check:
0117 7C9E C1A0  34         mov   @tfh.ioresult,tmp2
     7CA0 242C 
0118 7CA2 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7CA4 6042 
0119 7CA6 135C  14         jeq   tfh.file.read.error
0120                                                   ; Yes, so handle file error
0121                       ;------------------------------------------------------
0122                       ; 1d: Copy line from VDP buffer to RAM buffer
0123                       ;------------------------------------------------------
0124 7CA8 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7CAA 0960 
0125 7CAC 0205  20         li    tmp1,fb.top           ; RAM target address
     7CAE 2650 
0126 7CB0 C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7CB2 2430 
0127 7CB4 1320  14         jeq   tfh.file.read.emptyline
0128                                                   ; Handle empty line
0129               
0130 7CB6 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7CB8 62C6 
0131                                                   ;   tmp0 = VDP source address
0132                                                   ;   tmp1 = RAM target address
0133                                                   ;   tmp2 = Bytes to copy
0134                       ;------------------------------------------------------
0135                       ; Step 2: Compress line and copy to editor buffer
0136                       ;------------------------------------------------------
0137                       ; Decompress stuff goes here
0138                       ;------------------------------------------------------
0139                       ; 2a: Handle line with length <= 2
0140                       ;------------------------------------------------------
0141 7CBA C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7CBC 2430 
0142 7CBE 0286  22         ci    tmp2,2                ; Check line length
     7CC0 0002 
0143 7CC2 1506  14         jgt   tfh.file.read.addline.normal
0144                       ;------------------------------------------------------
0145                       ; 2b: Store line content in index itself
0146                       ;------------------------------------------------------
0147 7CC4 0204  20         li    tmp0,fb.top
     7CC6 2650 
0148 7CC8 0205  20         li    tmp1,parm2            ; Line content into @parm2
     7CCA 8352 
0149 7CCC C554  38         mov   *tmp0,*tmp1           ; Copy line as word (even if only 1 byte)
0150 7CCE 100A  14         jmp   tfh.file.read.prepindex
0151                       ;------------------------------------------------------
0152                       ; 2b: Handle line with length > 2
0153                       ;------------------------------------------------------
0154               tfh.file.read.addline.normal:
0155 7CD0 C160  34         mov   @edb.next_free.ptr,tmp1
     7CD2 2308 
0156                                                   ; RAM target address in editor buffer
0157 7CD4 C805  38         mov   tmp1,@parm2           ; parm2 = Pointer to line in editor buffer
     7CD6 8352 
0158               
0159 7CD8 A806  38         a     tmp2,@edb.next_free.ptr
     7CDA 2308 
0160                                                   ; Update pointer to next free line
0161                       ;------------------------------------------------------
0162                       ; 2c: Copy (compressed) line to editor buffer
0163                       ;------------------------------------------------------
0164               tfh.file.read.addline.copy:
0165 7CDC 0204  20         li    tmp0,fb.top           ; RAM source address
     7CDE 2650 
0166 7CE0 06A0  32         bl    @xpym2m               ; Copy memory block from CPU to CPU
     7CE2 62E8 
0167                                                   ;   tmp0 = RAM source address
0168                                                   ;   tmp1 = RAM target address
0169                                                   ;   tmp2 = Bytes to copy
0170                       ;------------------------------------------------------
0171                       ; Step 4: Prepare for index update
0172                       ;------------------------------------------------------
0173               tfh.file.read.prepindex:
0174 7CE4 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7CE6 242E 
     7CE8 8350 
0175 7CEA 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7CEC 8350 
0176                                                   ; parm2 = Already set
0177 7CEE C820  54         mov   @tfh.reclen,@parm3    ; parm3 = Line length
     7CF0 2430 
     7CF2 8354 
0178 7CF4 1009  14         jmp   tfh.file.read.updindex
0179                                                   ; Update index
0180                       ;------------------------------------------------------
0181                       ; Special handling for empty line
0182                       ;------------------------------------------------------
0183               tfh.file.read.emptyline:
0184 7CF6 C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7CF8 242E 
     7CFA 8350 
0185 7CFC 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7CFE 8350 
0186 7D00 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7D02 8352 
0187 7D04 04E0  34         clr   @parm3                ; parm3 = Line length
     7D06 8354 
0188                       ;------------------------------------------------------
0189                       ; Step 5: Update index
0190                       ;------------------------------------------------------
0191               tfh.file.read.updindex:
0192 7D08 C820  54         mov   @edb.next_free.page,@parm4
     7D0A 230A 
     7D0C 8356 
0193                                                   ; SAMS page where line will reside
0194               
0195 7D0E 06A0  32         bl    @idx.entry.update     ; Update index
     7D10 79B8 
0196                                                   ;   parm1 = Line number in editor buffer
0197                                                   ;   parm2 = Pointer to line in editor buffer
0198                                                   ;           (or line content if length <= 2)
0199                                                   ;   parm3 = Length of line
0200                                                   ;   parm4 = SAMS page
0201               
0202 7D12 05A0  34         inc   @edb.lines            ; lines=lines+1
     7D14 2304 
0203                       ;------------------------------------------------------
0204                       ; 5a: Display results
0205                       ;------------------------------------------------------
0206               tfh.file.read.display:
0207 7D16 06A0  32         bl    @putnum
     7D18 6666 
0208 7D1A 1D49                   byte 29,73            ; Show lines read
0209 7D1C 2304                   data edb.lines,rambuf,>3020
     7D1E 8390 
     7D20 3020 
0210               
0211 7D22 8220  34         c     @tfh.kilobytes,tmp4
     7D24 2432 
0212 7D26 130C  14         jeq   tfh.file.read.checkmem
0213               
0214 7D28 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7D2A 2432 
0215               
0216 7D2C 06A0  32         bl    @putnum
     7D2E 6666 
0217 7D30 1D38                   byte 29,56            ; Show kilobytes read
0218 7D32 2432                   data tfh.kilobytes,rambuf,>3020
     7D34 8390 
     7D36 3020 
0219               
0220 7D38 06A0  32         bl    @putat
     7D3A 6292 
0221 7D3C 1D3D                   byte 29,61
0222 7D3E 7DF2                   data txt_kb           ; Show "kb" string
0223               
0224               ******************************************************
0225               * Stop reading file if high memory expansion gets full
0226               ******************************************************
0227               tfh.file.read.checkmem:
0228 7D40 C120  34         mov   @edb.next_free.ptr,tmp0
     7D42 2308 
0229 7D44 0284  22         ci    tmp0,>ffa0
     7D46 FFA0 
0230 7D48 1207  14         jle   tfh.file.read.next
0231               
0232 7D4A 1012  14         jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
0233                       ;------------------------------------------------------
0234                       ; Next SAMS page
0235                       ;------------------------------------------------------
0236 7D4C 05A0  34         inc   @edb.next_free.page   ; Next SAMS page
     7D4E 230A 
0237 7D50 0204  20         li    tmp0,edb.top
     7D52 A000 
0238 7D54 C804  38         mov   tmp0,@edb.next_free.ptr
     7D56 2308 
0239                                                   ; Reset to top of editor buffer
0240                       ;------------------------------------------------------
0241                       ; Next record
0242                       ;------------------------------------------------------
0243               tfh.file.read.next:
0244 7D58 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7D5A 6D5E 
0245 7D5C 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0246               
0247 7D5E 1080  14         jmp   tfh.file.read.record
0248                                                   ; Next record
0249                       ;------------------------------------------------------
0250                       ; Error handler
0251                       ;------------------------------------------------------
0252               tfh.file.read.error:
0253 7D60 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7D62 242A 
0254 7D64 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0255 7D66 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7D68 0005 
0256 7D6A 1302  14         jeq   tfh.file.read.eof
0257                                                   ; All good. File closed by DSRLNK
0258 7D6C 0460  28         b     @crash_handler        ; A File error occured. System crashed
     7D6E 604C 
0259                       ;------------------------------------------------------
0260                       ; End-Of-File reached
0261                       ;------------------------------------------------------
0262               tfh.file.read.eof:
0263 7D70 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7D72 6D80 
0264 7D74 2100                   data scrpad.backup2   ; / >2100->8300
0265                       ;------------------------------------------------------
0266                       ; Display final results
0267                       ;------------------------------------------------------
0268 7D76 06A0  32         bl    @hchar
     7D78 6468 
0269 7D7A 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7D7C 200A 
0270 7D7E FFFF                   data EOL
0271               
0272 7D80 06A0  32         bl    @putnum
     7D82 6666 
0273 7D84 1D38                   byte 29,56            ; Show kilobytes read
0274 7D86 2432                   data tfh.kilobytes,rambuf,>3020
     7D88 8390 
     7D8A 3020 
0275               
0276 7D8C 06A0  32         bl    @putat
     7D8E 6292 
0277 7D90 1D3D                   byte 29,61
0278 7D92 7DF2                   data txt_kb           ; Show "kb" string
0279               
0280 7D94 06A0  32         bl    @putnum
     7D96 6666 
0281 7D98 1D49                   byte 29,73            ; Show lines read
0282 7D9A 242E                   data tfh.records,rambuf,>3020
     7D9C 8390 
     7D9E 3020 
0283               
0284 7DA0 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7DA2 2306 
0285               *--------------------------------------------------------------
0286               * Exit
0287               *--------------------------------------------------------------
0288               tfh.file.read_exit:
0289 7DA4 0460  28         b     @poprt                ; Return to caller
     7DA6 60C8 
0290               
0291               
0292               ***************************************************************
0293               * PAB for accessing DV/80 file
0294               ********@*****@*********************@**************************
0295               tfh.file.pab.header:
0296 7DA8 0014             byte  io.op.open            ;  0    - OPEN
0297                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0298 7DAA 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0299 7DAC 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0300                       byte  00                    ;  5    - Character count
0301 7DAE 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0302 7DB0 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0303                       ;------------------------------------------------------
0304                       ; File descriptor part (variable length)
0305                       ;------------------------------------------------------
0306                       ; byte  12                  ;  9    - File descriptor length
0307                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.30645
0619               
0620               
0621               ***************************************************************
0622               *                      Constants
0623               ***************************************************************
0624               romsat:
0625 7DB2 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7DB4 000F 
0626               
0627               cursors:
0628 7DB6 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7DB8 0000 
     7DBA 0000 
     7DBC 001C 
0629 7DBE 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7DC0 1010 
     7DC2 1010 
     7DC4 1000 
0630 7DC6 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7DC8 1C1C 
     7DCA 1C1C 
     7DCC 1C00 
0631               
0632               ***************************************************************
0633               *                       Strings
0634               ***************************************************************
0635               txt_delim
0636 7DCE 012C             byte  1
0637 7DCF ....             text  ','
0638                       even
0639               
0640               txt_marker
0641 7DD0 052A             byte  5
0642 7DD1 ....             text  '*EOF*'
0643                       even
0644               
0645               txt_bottom
0646 7DD6 0520             byte  5
0647 7DD7 ....             text  '  BOT'
0648                       even
0649               
0650               txt_ovrwrite
0651 7DDC 034F             byte  3
0652 7DDD ....             text  'OVR'
0653                       even
0654               
0655               txt_insert
0656 7DE0 0349             byte  3
0657 7DE1 ....             text  'INS'
0658                       even
0659               
0660               txt_star
0661 7DE4 012A             byte  1
0662 7DE5 ....             text  '*'
0663                       even
0664               
0665               txt_loading
0666 7DE6 0A4C             byte  10
0667 7DE7 ....             text  'Loading...'
0668                       even
0669               
0670               txt_kb
0671 7DF2 026B             byte  2
0672 7DF3 ....             text  'kb'
0673                       even
0674               
0675               txt_lines
0676 7DF6 054C             byte  5
0677 7DF7 ....             text  'Lines'
0678                       even
0679               
0680 7DFC 7DFC     end          data    $
0681               
0682               
0683               fdname0
0684 7DFE 0D44             byte  13
0685 7DFF ....             text  'DSK1.INVADERS'
0686                       even
0687               
0688               fdname1
0689 7E0C 0F44             byte  15
0690 7E0D ....             text  'DSK1.SPEECHDOCS'
0691                       even
0692               
0693               fdname2
0694 7E1C 0C44             byte  12
0695 7E1D ....             text  'DSK1.XBEADOC'
0696                       even
0697               
0698               fdname3
0699 7E2A 0C44             byte  12
0700 7E2B ....             text  'DSK3.XBEADOC'
0701                       even
0702               
0703               fdname4
0704 7E38 0C44             byte  12
0705 7E39 ....             text  'DSK3.C99MAN1'
0706                       even
0707               
0708               fdname5
0709 7E46 0C44             byte  12
0710 7E47 ....             text  'DSK3.C99MAN2'
0711                       even
0712               
0713               fdname6
0714 7E54 0C44             byte  12
0715 7E55 ....             text  'DSK3.C99MAN3'
0716                       even
0717               
0718               fdname7
0719 7E62 0D44             byte  13
0720 7E63 ....             text  'DSK3.C99SPECS'
0721                       even
0722               
0723               fdname8
0724 7E70 0D44             byte  13
0725 7E71 ....             text  'DSK3.RANDOM#C'
0726                       even
0727               
0728               fdname9
0729 7E7E 0D44             byte  13
0730 7E7F ....             text  'DSK3.RNDTST#C'
0731                       even
0732               

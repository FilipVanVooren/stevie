XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.14086
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2020 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 200209-14086
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
0080      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0081      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0082      00F4     spfclr                  equ  >f4    ; Foreground/Background color for font.
0083      0004     spfbck                  equ  >04    ; Screen background color.
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
0140      230E     edb.end             equ  edb.top.ptr+14 ; Free from here on
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
0154      2436     tfh.fname.ptr   equ  tfh.top + 54   ; Pointer to device and filename
0155      2438     tfh.sams.page   equ  tfh.top + 56   ; Current SAMS page during file operation
0156      243A     tfh.sams.hpage  equ  tfh.top + 58   ; Highest SAMS page in use so far for file operation
0157      243C     tfh.callback1   equ  tfh.top + 60   ; Pointer to callback function 1
0158      243E     tfh.callback2   equ  tfh.top + 62   ; Pointer to callback function 2
0159      2440     tfh.callback3   equ  tfh.top + 64   ; Pointer to callback function 3
0160      2442     tfh.callback4   equ  tfh.top + 66   ; Pointer to callback function 4
0161      2444     tfh.rleonload   equ  tfh.top + 68   ; RLE compression needed during file load
0162      2446     tfh.membuffer   equ  tfh.top + 70   ; 80 bytes file memory buffer
0163      2496     tfh.end         equ  tfh.top + 150  ; Free from here on
0164      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0165      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0166               *--------------------------------------------------------------
0167               * Free for future use               @>2500-264f     (336 bytes)
0168               *--------------------------------------------------------------
0169      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0170      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0171               *--------------------------------------------------------------
0172               * Frame buffer                      @>2650-2fff    (2480 bytes)
0173               *--------------------------------------------------------------
0174      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0175      09B0     fb.size         equ  2480           ; Frame buffer size
0176               *--------------------------------------------------------------
0177               * Index                             @>3000-3fff    (4096 bytes)
0178               *--------------------------------------------------------------
0179      3000     idx.top         equ  >3000          ; Top of index
0180      1000     idx.size        equ  4096           ; Index size
0181               *--------------------------------------------------------------
0182               * SAMS shadow index                 @>a000-afff    (4096 bytes)
0183               *--------------------------------------------------------------
0184      A000     idx.shadow.top  equ  >a000          ; Top of shadow index
0185      1000     idx.shadow.size equ  4096           ; Shadow index size
0186               *--------------------------------------------------------------
0187               * Editor buffer                     @>b000-bfff    (4096 bytes)
0188               *                                   @>c000-cfff    (4096 bytes)
0189               *                                   @>d000-dfff    (4096 bytes)
0190               *                                   @>e000-efff    (4096 bytes)
0191               *                                   @>f000-ffff    (4096 bytes)
0192               *--------------------------------------------------------------
0193      B000     edb.top         equ  >b000          ; Editor buffer high memory
0194      4F9C     edb.size        equ  20380          ; Editor buffer size
0195               *--------------------------------------------------------------
0196               
0197               
0198               *--------------------------------------------------------------
0199               * Cartridge header
0200               *--------------------------------------------------------------
0201                       save  >6000,>7fff
0202                       aorg  >6000
0203               
0204 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0205 6006 6010             data  prog0
0206 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0207 6010 0000     prog0   data  0                     ; No more items following
0208 6012 6CD6             data  runlib
0209               
0211               
0212 6014 1154             byte  17
0213 6015 ....             text  'TIVI 200209-14086'
0214                       even
0215               
0223               *--------------------------------------------------------------
0224               * Include required files
0225               *--------------------------------------------------------------
0226                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     609E 6CDE 
0056               *--------------------------------------------------------------
0057               *    Show diagnostics after system reset
0058               *--------------------------------------------------------------
0059               cpu.crash.main:
0060                       ;------------------------------------------------------
0061                       ; Show crashed message
0062                       ;------------------------------------------------------
0063 60A0 06A0  32         bl    @putat                ; Show crash message
     60A2 641E 
0064 60A4 0000                   data >0000,cpu.crash.msg.crashed
     60A6 618A 
0065               
0066 60A8 06A0  32         bl    @puthex               ; Put hex value on screen
     60AA 690C 
0067 60AC 0015                   byte 0,21             ; \ i  p0 = YX position
0068 60AE FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0069 60B0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0070 60B2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0071                                                   ; /         LSB offset for ASCII digit 0-9
0072                       ;------------------------------------------------------
0073                       ; Show caller details
0074                       ;------------------------------------------------------
0075 60B4 06A0  32         bl    @putat                ; Show caller message
     60B6 641E 
0076 60B8 0100                   data >0100,cpu.crash.msg.caller
     60BA 61A0 
0077               
0078 60BC 06A0  32         bl    @puthex               ; Put hex value on screen
     60BE 690C 
0079 60C0 0115                   byte 1,21             ; \ i  p0 = YX position
0080 60C2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0081 60C4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0082 60C6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0083                                                   ; /         LSB offset for ASCII digit 0-9
0084                       ;------------------------------------------------------
0085                       ; Show registers R0 - R15
0086                       ;------------------------------------------------------
0087 60C8 06A0  32         bl    @at                   ; Put cursor at YX
     60CA 6614 
0088 60CC 0304                   byte 3,4              ; \ i p0 = YX position
0089                                                   ; /
0090               
0091 60CE 0204  20         li    tmp0,>ffe0            ; Crash registers >ffe0 - >ffff
     60D0 FFE0 
0092 60D2 04C6  14         clr   tmp2                  ; Loop counter
0093               
0094               cpu.crash.showreg:
0095 60D4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0096               
0097 60D6 0649  14         dect  stack
0098 60D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0099 60DA 0649  14         dect  stack
0100 60DC C645  30         mov   tmp1,*stack           ; Push tmp1
0101 60DE 0649  14         dect  stack
0102 60E0 C646  30         mov   tmp2,*stack           ; Push tmp2
0103                       ;------------------------------------------------------
0104                       ; Display crash register number
0105                       ;------------------------------------------------------
0106 60E2 C046  18         mov   tmp2,r1               ; Save register number
0107               
0108 60E4 06A0  32         bl    @mknum
     60E6 6916 
0109 60E8 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0110 60EA 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0111 60EC 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113               
0114 60EE 06A0  32         bl    @setx                 ; Set cursor X position
     60F0 662A 
0115 60F2 0000                   data 0                ; \ i  p0 =  Cursor Y position
0116                                                   ; /
0117               
0118 60F4 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     60F6 640C 
0119 60F8 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0120                                                   ; /
0121               
0122 60FA 06A0  32         bl    @setx                 ; Set cursor X position
     60FC 662A 
0123 60FE 0002                   data 2                ; \ i  p0 =  Cursor Y position
0124                                                   ; /
0125               
0126 6100 0281  22         ci    r1,10
     6102 000A 
0127 6104 1102  14         jlt   !
0128 6106 0620  34         dec   @wyx                  ; x=x-1
     6108 832A 
0129               
0130 610A 06A0  32 !       bl    @putstr
     610C 640C 
0131 610E 61B6                   data cpu.crash.msg.r
0132               
0133 6110 06A0  32         bl    @mknum
     6112 6916 
0134 6114 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0135 6116 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0136 6118 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0137                                                   ; /         LSB offset for ASCII digit 0-9
0138               
0139                       ;------------------------------------------------------
0140                       ; Display crash register content
0141                       ;------------------------------------------------------
0142 611A 06A0  32         bl    @mkhex                ; Convert hex word to string
     611C 6888 
0143 611E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0144 6120 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 6122 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148               
0149 6124 06A0  32         bl    @setx                 ; Set cursor X position
     6126 662A 
0150 6128 0006                   data 6                ; \ i  p0 =  Cursor Y position
0151                                                   ; /
0152               
0153 612A 06A0  32         bl    @putstr
     612C 640C 
0154 612E 61B8                   data cpu.crash.msg.marker
0155               
0156 6130 06A0  32         bl    @setx                 ; Set cursor X position
     6132 662A 
0157 6134 0007                   data 7                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 6136 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6138 640C 
0161 613A 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0162                                                   ; /
0163               
0164 613C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0165 613E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0166 6140 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0167               
0168 6142 06A0  32         bl    @down                 ; y=y+1
     6144 661A 
0169               
0170 6146 0586  14         inc   tmp2
0171 6148 0286  22         ci    tmp2,15
     614A 000F 
0172 614C 12C3  14         jle   cpu.crash.showreg     ; Show next register
0173                       ;------------------------------------------------------
0174                       ; Display temp variable markers
0175                       ;------------------------------------------------------
0176 614E 06A0  32         bl    @putat
     6150 641E 
0177 6152 050F                   byte 5,15
0178 6154 61BA                   data cpu.crash.msg.config
0179 6156 06A0  32         bl    @putat
     6158 641E 
0180 615A 070F                   byte 7,15
0181 615C 61C8                   data cpu.crash.msg.tmp0
0182 615E 06A0  32         bl    @putat
     6160 641E 
0183 6162 080F                   byte 8,15
0184 6164 61CE                   data cpu.crash.msg.tmp1
0185 6166 06A0  32         bl    @putat
     6168 641E 
0186 616A 090F                   byte 9,15
0187 616C 61D4                   data cpu.crash.msg.tmp2
0188 616E 06A0  32         bl    @putat
     6170 641E 
0189 6172 0A0F                   byte 10,15
0190 6174 61DA                   data cpu.crash.msg.tmp3
0191 6176 06A0  32         bl    @putat
     6178 641E 
0192 617A 0B0F                   byte 11,15
0193 617C 61E0                   data cpu.crash.msg.tmp4
0194 617E 06A0  32         bl    @putat
     6180 641E 
0195 6182 0C0F                   byte 12,15
0196 6184 61C2                   data cpu.crash.msg.stack
0197                       ;------------------------------------------------------
0198                       ; Kernel takes over
0199                       ;------------------------------------------------------
0200 6186 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6188 6BEC 
0201               
0202               
0203 618A 1553     cpu.crash.msg.crashed      byte 21
0204 618B ....                                text 'System crashed near >'
0205               
0206 61A0 1543     cpu.crash.msg.caller       byte 21
0207 61A1 ....                                text 'Caller address near >'
0208               
0209 61B6 0152     cpu.crash.msg.r            byte 1
0210 61B7 ....                                text 'R'
0211               
0212 61B8 013E     cpu.crash.msg.marker       byte 1
0213 61B9 ....                                text '>'
0214               
0215 61BA 0663     cpu.crash.msg.config       byte 6
0216 61BB ....                                text 'config'
0217                                          even
0218               
0219 61C2 0573     cpu.crash.msg.stack        byte 5
0220 61C3 ....                                text 'stack'
0221                                          even
0222               
0223 61C8 0474     cpu.crash.msg.tmp0         byte 4
0224 61C9 ....                                text 'tmp0'
0225                                          even
0226               
0227 61CE 0474     cpu.crash.msg.tmp1         byte 4
0228 61CF ....                                text 'tmp1'
0229                                          even
0230               
0231 61D4 0474     cpu.crash.msg.tmp2         byte 4
0232 61D5 ....                                text 'tmp2'
0233                                          even
0234               
0235 61DA 0474     cpu.crash.msg.tmp3         byte 4
0236 61DB ....                                text 'tmp3'
0237                                          even
0238               
0239 61E0 0474     cpu.crash.msg.tmp4         byte 4
0240 61E1 ....                                text 'tmp4'
0241                                          even
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 61E6 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     61E8 000E 
     61EA 0106 
     61EC 0204 
     61EE 0020 
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
0032 61F0 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     61F2 000E 
     61F4 0106 
     61F6 00F4 
     61F8 0028 
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
0058 61FA 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     61FC 003F 
     61FE 0240 
     6200 03F4 
     6202 0050 
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
0084 6204 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6206 003F 
     6208 0240 
     620A 03F4 
     620C 0050 
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
0013 620E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6210 16FD             data  >16fd                 ; |         jne   mcloop
0015 6212 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6214 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6216 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6218 C0F9  30 popr3   mov   *stack+,r3
0039 621A C0B9  30 popr2   mov   *stack+,r2
0040 621C C079  30 popr1   mov   *stack+,r1
0041 621E C039  30 popr0   mov   *stack+,r0
0042 6220 C2F9  30 poprt   mov   *stack+,r11
0043 6222 045B  20         b     *r11
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
0067 6224 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6226 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6228 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 622A C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 622C 1604  14         jne   filchk                ; No, continue checking
0075               
0076 622E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6230 FFCE 
0077 6232 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6234 604C 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 6236 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     6238 830B 
     623A 830A 
0082               
0083 623C 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     623E 0001 
0084 6240 1602  14         jne   filchk2
0085 6242 DD05  32         movb  tmp1,*tmp0+
0086 6244 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 6246 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     6248 0002 
0091 624A 1603  14         jne   filchk3
0092 624C DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 624E DD05  32         movb  tmp1,*tmp0+
0094 6250 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 6252 C1C4  18 filchk3 mov   tmp0,tmp3
0099 6254 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6256 0001 
0100 6258 1605  14         jne   fil16b
0101 625A DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 625C 0606  14         dec   tmp2
0103 625E 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6260 0002 
0104 6262 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 6264 C1C6  18 fil16b  mov   tmp2,tmp3
0109 6266 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6268 0001 
0110 626A 1301  14         jeq   dofill
0111 626C 0606  14         dec   tmp2                  ; Make TMP2 even
0112 626E CD05  34 dofill  mov   tmp1,*tmp0+
0113 6270 0646  14         dect  tmp2
0114 6272 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 6274 C1C7  18         mov   tmp3,tmp3
0119 6276 1301  14         jeq   fil.$$
0120 6278 DD05  32         movb  tmp1,*tmp0+
0121 627A 045B  20 fil.$$  b     *r11
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
0140 627C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 627E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 6280 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6282 0264  22 xfilv   ori   tmp0,>4000
     6284 4000 
0147 6286 06C4  14         swpb  tmp0
0148 6288 D804  38         movb  tmp0,@vdpa
     628A 8C02 
0149 628C 06C4  14         swpb  tmp0
0150 628E D804  38         movb  tmp0,@vdpa
     6290 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 6292 020F  20         li    r15,vdpw              ; Set VDP write address
     6294 8C00 
0155 6296 06C5  14         swpb  tmp1
0156 6298 C820  54         mov   @filzz,@mcloop        ; Setup move command
     629A 62A2 
     629C 8320 
0157 629E 0460  28         b     @mcloop               ; Write data to VDP
     62A0 8320 
0158               *--------------------------------------------------------------
0162 62A2 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 62A4 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62A6 4000 
0183 62A8 06C4  14 vdra    swpb  tmp0
0184 62AA D804  38         movb  tmp0,@vdpa
     62AC 8C02 
0185 62AE 06C4  14         swpb  tmp0
0186 62B0 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     62B2 8C02 
0187 62B4 045B  20         b     *r11                  ; Exit
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
0198 62B6 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 62B8 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 62BA 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     62BC 4000 
0204 62BE 06C4  14         swpb  tmp0                  ; \
0205 62C0 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     62C2 8C02 
0206 62C4 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 62C6 D804  38         movb  tmp0,@vdpa            ; /
     62C8 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 62CA 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 62CC D7C5  30         movb  tmp1,*r15             ; Write byte
0213 62CE 045B  20         b     *r11                  ; Exit
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
0232 62D0 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 62D2 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 62D4 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     62D6 8C02 
0238 62D8 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 62DA D804  38         movb  tmp0,@vdpa            ; /
     62DC 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 62DE D120  34         movb  @vdpr,tmp0            ; Read byte
     62E0 8800 
0244 62E2 0984  56         srl   tmp0,8                ; Right align
0245 62E4 045B  20         b     *r11                  ; Exit
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
0264 62E6 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 62E8 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 62EA C144  18         mov   tmp0,tmp1
0270 62EC 05C5  14         inct  tmp1
0271 62EE D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 62F0 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     62F2 FF00 
0273 62F4 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 62F6 C805  38         mov   tmp1,@wbase           ; Store calculated base
     62F8 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 62FA 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     62FC 8000 
0279 62FE 0206  20         li    tmp2,8
     6300 0008 
0280 6302 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6304 830B 
0281 6306 06C5  14         swpb  tmp1
0282 6308 D805  38         movb  tmp1,@vdpa
     630A 8C02 
0283 630C 06C5  14         swpb  tmp1
0284 630E D805  38         movb  tmp1,@vdpa
     6310 8C02 
0285 6312 0225  22         ai    tmp1,>0100
     6314 0100 
0286 6316 0606  14         dec   tmp2
0287 6318 16F4  14         jne   vidta1                ; Next register
0288 631A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     631C 833A 
0289 631E 045B  20         b     *r11
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
0306 6320 C13B  30 putvr   mov   *r11+,tmp0
0307 6322 0264  22 putvrx  ori   tmp0,>8000
     6324 8000 
0308 6326 06C4  14         swpb  tmp0
0309 6328 D804  38         movb  tmp0,@vdpa
     632A 8C02 
0310 632C 06C4  14         swpb  tmp0
0311 632E D804  38         movb  tmp0,@vdpa
     6330 8C02 
0312 6332 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 6334 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 6336 C10E  18         mov   r14,tmp0
0322 6338 0984  56         srl   tmp0,8
0323 633A 06A0  32         bl    @putvrx               ; Write VR#0
     633C 6322 
0324 633E 0204  20         li    tmp0,>0100
     6340 0100 
0325 6342 D820  54         movb  @r14lb,@tmp0lb
     6344 831D 
     6346 8309 
0326 6348 06A0  32         bl    @putvrx               ; Write VR#1
     634A 6322 
0327 634C 0458  20         b     *tmp4                 ; Exit
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
0341 634E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 6350 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 6352 C11B  26         mov   *r11,tmp0             ; Get P0
0344 6354 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6356 7FFF 
0345 6358 2120  38         coc   @wbit0,tmp0
     635A 6046 
0346 635C 1604  14         jne   ldfnt1
0347 635E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6360 8000 
0348 6362 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6364 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 6366 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6368 63D0 
0353 636A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     636C 9C02 
0354 636E 06C4  14         swpb  tmp0
0355 6370 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6372 9C02 
0356 6374 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     6376 9800 
0357 6378 06C5  14         swpb  tmp1
0358 637A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     637C 9800 
0359 637E 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 6380 D805  38         movb  tmp1,@grmwa
     6382 9C02 
0364 6384 06C5  14         swpb  tmp1
0365 6386 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     6388 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 638A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 638C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     638E 62A4 
0371 6390 05C8  14         inct  tmp4                  ; R11=R11+2
0372 6392 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 6394 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     6396 7FFF 
0374 6398 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     639A 63D2 
0375 639C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     639E 63D4 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 63A0 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 63A2 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 63A4 D120  34         movb  @grmrd,tmp0
     63A6 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 63A8 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63AA 6046 
0386 63AC 1603  14         jne   ldfnt3                ; No, so skip
0387 63AE D1C4  18         movb  tmp0,tmp3
0388 63B0 0917  56         srl   tmp3,1
0389 63B2 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 63B4 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     63B6 8C00 
0394 63B8 0606  14         dec   tmp2
0395 63BA 16F2  14         jne   ldfnt2
0396 63BC 05C8  14         inct  tmp4                  ; R11=R11+2
0397 63BE 020F  20         li    r15,vdpw              ; Set VDP write address
     63C0 8C00 
0398 63C2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63C4 7FFF 
0399 63C6 0458  20         b     *tmp4                 ; Exit
0400 63C8 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     63CA 6026 
     63CC 8C00 
0401 63CE 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 63D0 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     63D2 0200 
     63D4 0000 
0406 63D6 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     63D8 01C0 
     63DA 0101 
0407 63DC 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     63DE 02A0 
     63E0 0101 
0408 63E2 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     63E4 00E0 
     63E6 0101 
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
0426 63E8 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 63EA C3A0  34         mov   @wyx,r14              ; Get YX
     63EC 832A 
0428 63EE 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 63F0 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     63F2 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 63F4 C3A0  34         mov   @wyx,r14              ; Get YX
     63F6 832A 
0435 63F8 024E  22         andi  r14,>00ff             ; Remove Y
     63FA 00FF 
0436 63FC A3CE  18         a     r14,r15               ; pos = pos + X
0437 63FE A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6400 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6402 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 6404 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 6406 020F  20         li    r15,vdpw              ; VDP write address
     6408 8C00 
0444 640A 045B  20         b     *r11
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
0459 640C C17B  30 putstr  mov   *r11+,tmp1
0460 640E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 6410 C1CB  18 xutstr  mov   r11,tmp3
0462 6412 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6414 63E8 
0463 6416 C2C7  18         mov   tmp3,r11
0464 6418 0986  56         srl   tmp2,8                ; Right justify length byte
0465 641A 0460  28         b     @xpym2v               ; Display string
     641C 642C 
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
0480 641E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6420 832A 
0481 6422 0460  28         b     @putstr
     6424 640C 
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
0020 6426 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6428 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 642A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 642C 0264  22 xpym2v  ori   tmp0,>4000
     642E 4000 
0027 6430 06C4  14         swpb  tmp0
0028 6432 D804  38         movb  tmp0,@vdpa
     6434 8C02 
0029 6436 06C4  14         swpb  tmp0
0030 6438 D804  38         movb  tmp0,@vdpa
     643A 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 643C 020F  20         li    r15,vdpw              ; Set VDP write address
     643E 8C00 
0035 6440 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6442 644A 
     6444 8320 
0036 6446 0460  28         b     @mcloop               ; Write data to VDP
     6448 8320 
0037 644A D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 644C C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 644E C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6450 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6452 06C4  14 xpyv2m  swpb  tmp0
0027 6454 D804  38         movb  tmp0,@vdpa
     6456 8C02 
0028 6458 06C4  14         swpb  tmp0
0029 645A D804  38         movb  tmp0,@vdpa
     645C 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 645E 020F  20         li    r15,vdpr              ; Set VDP read address
     6460 8800 
0034 6462 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6464 646C 
     6466 8320 
0035 6468 0460  28         b     @mcloop               ; Read data from VDP
     646A 8320 
0036 646C DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 646E C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6470 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6472 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 6474 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 6476 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 6478 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     647A FFCE 
0034 647C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     647E 604C 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6480 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6482 0001 
0039 6484 1603  14         jne   cpym0                 ; No, continue checking
0040 6486 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 6488 04C6  14         clr   tmp2                  ; Reset counter
0042 648A 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 648C 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     648E 7FFF 
0047 6490 C1C4  18         mov   tmp0,tmp3
0048 6492 0247  22         andi  tmp3,1
     6494 0001 
0049 6496 1618  14         jne   cpyodd                ; Odd source address handling
0050 6498 C1C5  18 cpym1   mov   tmp1,tmp3
0051 649A 0247  22         andi  tmp3,1
     649C 0001 
0052 649E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 64A0 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     64A2 6046 
0057 64A4 1605  14         jne   cpym3
0058 64A6 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     64A8 64CE 
     64AA 8320 
0059 64AC 0460  28         b     @mcloop               ; Copy memory and exit
     64AE 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 64B0 C1C6  18 cpym3   mov   tmp2,tmp3
0064 64B2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     64B4 0001 
0065 64B6 1301  14         jeq   cpym4
0066 64B8 0606  14         dec   tmp2                  ; Make TMP2 even
0067 64BA CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 64BC 0646  14         dect  tmp2
0069 64BE 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 64C0 C1C7  18         mov   tmp3,tmp3
0074 64C2 1301  14         jeq   cpymz
0075 64C4 D554  38         movb  *tmp0,*tmp1
0076 64C6 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 64C8 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     64CA 8000 
0081 64CC 10E9  14         jmp   cpym2
0082 64CE DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 64D0 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 64D2 0649  14         dect  stack
0065 64D4 C64B  30         mov   r11,*stack            ; Push return address
0066 64D6 0649  14         dect  stack
0067 64D8 C640  30         mov   r0,*stack             ; Push r0
0068 64DA 0649  14         dect  stack
0069 64DC C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 64DE 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 64E0 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 64E2 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     64E4 4000 
0077 64E6 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     64E8 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 64EA 020C  20         li    r12,>1e00             ; SAMS CRU address
     64EC 1E00 
0082 64EE 04C0  14         clr   r0
0083 64F0 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 64F2 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 64F4 D100  18         movb  r0,tmp0
0086 64F6 0984  56         srl   tmp0,8                ; Right align
0087 64F8 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     64FA 833C 
0088 64FC 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 64FE C339  30         mov   *stack+,r12           ; Pop r12
0094 6500 C039  30         mov   *stack+,r0            ; Pop r0
0095 6502 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 6504 045B  20         b     *r11                  ; Return to caller
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
0131 6506 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6508 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 650A 0649  14         dect  stack
0135 650C C64B  30         mov   r11,*stack            ; Push return address
0136 650E 0649  14         dect  stack
0137 6510 C640  30         mov   r0,*stack             ; Push r0
0138 6512 0649  14         dect  stack
0139 6514 C64C  30         mov   r12,*stack            ; Push r12
0140 6516 0649  14         dect  stack
0141 6518 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 651A 0649  14         dect  stack
0143 651C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 651E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 6520 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 6522 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     6524 001E 
0153 6526 150A  14         jgt   !
0154 6528 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     652A 0004 
0155 652C 1107  14         jlt   !
0156 652E 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     6530 0012 
0157 6532 1508  14         jgt   sams.page.set.switch_page
0158 6534 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     6536 0006 
0159 6538 1501  14         jgt   !
0160 653A 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 653C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     653E FFCE 
0165 6540 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6542 604C 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 6544 020C  20         li    r12,>1e00             ; SAMS CRU address
     6546 1E00 
0171 6548 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 654A 06C0  14         swpb  r0                    ; LSB to MSB
0173 654C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 654E D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     6550 4000 
0175 6552 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 6554 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 6556 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 6558 C339  30         mov   *stack+,r12           ; Pop r12
0183 655A C039  30         mov   *stack+,r0            ; Pop r0
0184 655C C2F9  30         mov   *stack+,r11           ; Pop return address
0185 655E 045B  20         b     *r11                  ; Return to caller
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
0199 6560 020C  20         li    r12,>1e00             ; SAMS CRU address
     6562 1E00 
0200 6564 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 6566 045B  20         b     *r11                  ; Return to caller
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
0222 6568 020C  20         li    r12,>1e00             ; SAMS CRU address
     656A 1E00 
0223 656C 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 656E 045B  20         b     *r11                  ; Return to caller
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
0255 6570 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 6572 0649  14         dect  stack
0258 6574 C64B  30         mov   r11,*stack            ; Save return address
0259 6576 0649  14         dect  stack
0260 6578 C644  30         mov   tmp0,*stack           ; Save tmp0
0261 657A 0649  14         dect  stack
0262 657C C645  30         mov   tmp1,*stack           ; Save tmp1
0263 657E 0649  14         dect  stack
0264 6580 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 6582 0649  14         dect  stack
0266 6584 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 6586 0206  20         li    tmp2,8                ; Set loop counter
     6588 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 658A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 658C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 658E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     6590 650A 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 6592 0606  14         dec   tmp2                  ; Next iteration
0283 6594 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 6596 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6598 6560 
0289                                                   ; / activating changes.
0290               
0291 659A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 659C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 659E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 65A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 65A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 65A4 045B  20         b     *r11                  ; Return to caller
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
0313 65A6 0649  14         dect  stack
0314 65A8 C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 65AA 06A0  32         bl    @sams.layout
     65AC 6570 
0319 65AE 65B4                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.exit:
0324 65B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 65B2 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 65B4 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     65B6 0002 
0331 65B8 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     65BA 0003 
0332 65BC A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     65BE 000A 
0333 65C0 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     65C2 000B 
0334 65C4 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     65C6 000C 
0335 65C8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     65CA 000D 
0336 65CC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     65CE 000E 
0337 65D0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     65D2 000F 
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
0009 65D4 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     65D6 FFBF 
0010 65D8 0460  28         b     @putv01
     65DA 6334 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 65DC 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     65DE 0040 
0018 65E0 0460  28         b     @putv01
     65E2 6334 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 65E4 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     65E6 FFDF 
0026 65E8 0460  28         b     @putv01
     65EA 6334 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 65EC 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     65EE 0020 
0034 65F0 0460  28         b     @putv01
     65F2 6334 
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
0010 65F4 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     65F6 FFFE 
0011 65F8 0460  28         b     @putv01
     65FA 6334 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 65FC 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     65FE 0001 
0019 6600 0460  28         b     @putv01
     6602 6334 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 6604 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6606 FFFD 
0027 6608 0460  28         b     @putv01
     660A 6334 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 660C 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     660E 0002 
0035 6610 0460  28         b     @putv01
     6612 6334 
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
0018 6614 C83B  50 at      mov   *r11+,@wyx
     6616 832A 
0019 6618 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 661A B820  54 down    ab    @hb$01,@wyx
     661C 6038 
     661E 832A 
0028 6620 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6622 7820  54 up      sb    @hb$01,@wyx
     6624 6038 
     6626 832A 
0037 6628 045B  20         b     *r11
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
0049 662A C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 662C D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     662E 832A 
0051 6630 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6632 832A 
0052 6634 045B  20         b     *r11
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
0021 6636 C120  34 yx2px   mov   @wyx,tmp0
     6638 832A 
0022 663A C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 663C 06C4  14         swpb  tmp0                  ; Y<->X
0024 663E 04C5  14         clr   tmp1                  ; Clear before copy
0025 6640 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6642 20A0  38         coc   @wbit1,config         ; f18a present ?
     6644 6044 
0030 6646 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6648 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     664A 833A 
     664C 6676 
0032 664E 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6650 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6652 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6654 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6656 0500 
0037 6658 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 665A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 665C 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 665E 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6660 D105  18         movb  tmp1,tmp0
0051 6662 06C4  14         swpb  tmp0                  ; X<->Y
0052 6664 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6666 6046 
0053 6668 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 666A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     666C 6038 
0059 666E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6670 604A 
0060 6672 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6674 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6676 0050            data   80
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
0013 6678 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 667A 06A0  32         bl    @putvr                ; Write once
     667C 6320 
0015 667E 391C             data  >391c                 ; VR1/57, value 00011100
0016 6680 06A0  32         bl    @putvr                ; Write twice
     6682 6320 
0017 6684 391C             data  >391c                 ; VR1/57, value 00011100
0018 6686 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6688 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 668A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     668C 6320 
0028 668E 391C             data  >391c
0029 6690 0458  20         b     *tmp4                 ; Exit
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
0040 6692 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6694 06A0  32         bl    @cpym2v
     6696 6426 
0042 6698 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     669A 66D6 
     669C 0006 
0043 669E 06A0  32         bl    @putvr
     66A0 6320 
0044 66A2 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 66A4 06A0  32         bl    @putvr
     66A6 6320 
0046 66A8 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 66AA 0204  20         li    tmp0,>3f00
     66AC 3F00 
0052 66AE 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     66B0 62A8 
0053 66B2 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     66B4 8800 
0054 66B6 0984  56         srl   tmp0,8
0055 66B8 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     66BA 8800 
0056 66BC C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 66BE 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 66C0 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     66C2 BFFF 
0060 66C4 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 66C6 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     66C8 4000 
0063               f18chk_exit:
0064 66CA 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     66CC 627C 
0065 66CE 3F00             data  >3f00,>00,6
     66D0 0000 
     66D2 0006 
0066 66D4 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 66D6 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 66D8 3F00             data  >3f00                 ; 3f02 / 3f00
0073 66DA 0340             data  >0340                 ; 3f04   0340  idle
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
0092 66DC C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 66DE 06A0  32         bl    @putvr
     66E0 6320 
0097 66E2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 66E4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     66E6 6320 
0100 66E8 391C             data  >391c                 ; Lock the F18a
0101 66EA 0458  20         b     *tmp4                 ; Exit
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
0120 66EC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 66EE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     66F0 6044 
0122 66F2 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 66F4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     66F6 8802 
0127 66F8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     66FA 6320 
0128 66FC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 66FE 04C4  14         clr   tmp0
0130 6700 D120  34         movb  @vdps,tmp0
     6702 8802 
0131 6704 0984  56         srl   tmp0,8
0132 6706 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 6708 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     670A 832A 
0018 670C D17B  28         movb  *r11+,tmp1
0019 670E 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6710 D1BB  28         movb  *r11+,tmp2
0021 6712 0986  56         srl   tmp2,8                ; Repeat count
0022 6714 C1CB  18         mov   r11,tmp3
0023 6716 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6718 63E8 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 671A 020B  20         li    r11,hchar1
     671C 6722 
0028 671E 0460  28         b     @xfilv                ; Draw
     6720 6282 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6722 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6724 6048 
0033 6726 1302  14         jeq   hchar2                ; Yes, exit
0034 6728 C2C7  18         mov   tmp3,r11
0035 672A 10EE  14         jmp   hchar                 ; Next one
0036 672C 05C7  14 hchar2  inct  tmp3
0037 672E 0457  20         b     *tmp3                 ; Exit
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
0016 6730 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6732 6046 
0017 6734 020C  20         li    r12,>0024
     6736 0024 
0018 6738 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     673A 67C8 
0019 673C 04C6  14         clr   tmp2
0020 673E 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6740 04CC  14         clr   r12
0025 6742 1F08  20         tb    >0008                 ; Shift-key ?
0026 6744 1302  14         jeq   realk1                ; No
0027 6746 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6748 67F8 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 674A 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 674C 1302  14         jeq   realk2                ; No
0033 674E 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6750 6828 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6752 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6754 1302  14         jeq   realk3                ; No
0039 6756 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6758 6858 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 675A 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 675C 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 675E 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6760 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6762 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6764 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6766 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6768 0006 
0052 676A 0606  14 realk5  dec   tmp2
0053 676C 020C  20         li    r12,>24               ; CRU address for P2-P4
     676E 0024 
0054 6770 06C6  14         swpb  tmp2
0055 6772 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6774 06C6  14         swpb  tmp2
0057 6776 020C  20         li    r12,6                 ; CRU read address
     6778 0006 
0058 677A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 677C 0547  14         inv   tmp3                  ;
0060 677E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6780 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6782 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6784 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6786 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6788 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 678A 0285  22         ci    tmp1,8
     678C 0008 
0069 678E 1AFA  14         jl    realk6
0070 6790 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6792 1BEB  14         jh    realk5                ; No, next column
0072 6794 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6796 C206  18 realk8  mov   tmp2,tmp4
0077 6798 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 679A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 679C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 679E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 67A0 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 67A2 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 67A4 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     67A6 6046 
0087 67A8 1608  14         jne   realka                ; No, continue saving key
0088 67AA 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     67AC 67F2 
0089 67AE 1A05  14         jl    realka
0090 67B0 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     67B2 67F0 
0091 67B4 1B02  14         jh    realka                ; No, continue
0092 67B6 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     67B8 E000 
0093 67BA C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     67BC 833C 
0094 67BE E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     67C0 6030 
0095 67C2 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     67C4 8C00 
0096 67C6 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 67C8 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     67CA 0000 
     67CC FF0D 
     67CE 203D 
0099 67D0 ....             text  'xws29ol.'
0100 67D8 ....             text  'ced38ik,'
0101 67E0 ....             text  'vrf47ujm'
0102 67E8 ....             text  'btg56yhn'
0103 67F0 ....             text  'zqa10p;/'
0104 67F8 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     67FA 0000 
     67FC FF0D 
     67FE 202B 
0105 6800 ....             text  'XWS@(OL>'
0106 6808 ....             text  'CED#*IK<'
0107 6810 ....             text  'VRF$&UJM'
0108 6818 ....             text  'BTG%^YHN'
0109 6820 ....             text  'ZQA!)P:-'
0110 6828 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     682A 0000 
     682C FF0D 
     682E 2005 
0111 6830 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6832 0804 
     6834 0F27 
     6836 C2B9 
0112 6838 600B             data  >600b,>0907,>063f,>c1B8
     683A 0907 
     683C 063F 
     683E C1B8 
0113 6840 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6842 7B02 
     6844 015F 
     6846 C0C3 
0114 6848 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     684A 7D0E 
     684C 0CC6 
     684E BFC4 
0115 6850 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6852 7C03 
     6854 BC22 
     6856 BDBA 
0116 6858 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     685A 0000 
     685C FF0D 
     685E 209D 
0117 6860 9897             data  >9897,>93b2,>9f8f,>8c9B
     6862 93B2 
     6864 9F8F 
     6866 8C9B 
0118 6868 8385             data  >8385,>84b3,>9e89,>8b80
     686A 84B3 
     686C 9E89 
     686E 8B80 
0119 6870 9692             data  >9692,>86b4,>b795,>8a8D
     6872 86B4 
     6874 B795 
     6876 8A8D 
0120 6878 8294             data  >8294,>87b5,>b698,>888E
     687A 87B5 
     687C B698 
     687E 888E 
0121 6880 9A91             data  >9a91,>81b1,>b090,>9cBB
     6882 81B1 
     6884 B090 
     6886 9CBB 
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
0023 6888 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 688A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     688C 8340 
0025 688E 04E0  34         clr   @waux1
     6890 833C 
0026 6892 04E0  34         clr   @waux2
     6894 833E 
0027 6896 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6898 833C 
0028 689A C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 689C 0205  20         li    tmp1,4                ; 4 nibbles
     689E 0004 
0033 68A0 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 68A2 0246  22         andi  tmp2,>000f            ; Only keep LSN
     68A4 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 68A6 0286  22         ci    tmp2,>000a
     68A8 000A 
0039 68AA 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 68AC C21B  26         mov   *r11,tmp4
0045 68AE 0988  56         srl   tmp4,8                ; Right justify
0046 68B0 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     68B2 FFF6 
0047 68B4 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 68B6 C21B  26         mov   *r11,tmp4
0054 68B8 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     68BA 00FF 
0055               
0056 68BC A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 68BE 06C6  14         swpb  tmp2
0058 68C0 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 68C2 0944  56         srl   tmp0,4                ; Next nibble
0060 68C4 0605  14         dec   tmp1
0061 68C6 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 68C8 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     68CA BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 68CC C160  34         mov   @waux3,tmp1           ; Get pointer
     68CE 8340 
0067 68D0 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 68D2 0585  14         inc   tmp1                  ; Next byte, not word!
0069 68D4 C120  34         mov   @waux2,tmp0
     68D6 833E 
0070 68D8 06C4  14         swpb  tmp0
0071 68DA DD44  32         movb  tmp0,*tmp1+
0072 68DC 06C4  14         swpb  tmp0
0073 68DE DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 68E0 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     68E2 8340 
0078 68E4 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     68E6 603C 
0079 68E8 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 68EA C120  34         mov   @waux1,tmp0
     68EC 833C 
0084 68EE 06C4  14         swpb  tmp0
0085 68F0 DD44  32         movb  tmp0,*tmp1+
0086 68F2 06C4  14         swpb  tmp0
0087 68F4 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 68F6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     68F8 6046 
0092 68FA 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 68FC 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 68FE 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6900 7FFF 
0098 6902 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6904 8340 
0099 6906 0460  28         b     @xutst0               ; Display string
     6908 640E 
0100 690A 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 690C C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     690E 832A 
0122 6910 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6912 8000 
0123 6914 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 6916 0207  20 mknum   li    tmp3,5                ; Digit counter
     6918 0005 
0020 691A C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 691C C155  26         mov   *tmp1,tmp1            ; /
0022 691E C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6920 0228  22         ai    tmp4,4                ; Get end of buffer
     6922 0004 
0024 6924 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6926 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6928 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 692A 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 692C 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 692E B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6930 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6932 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6934 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6936 0607  14         dec   tmp3                  ; Decrease counter
0036 6938 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 693A 0207  20         li    tmp3,4                ; Check first 4 digits
     693C 0004 
0041 693E 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6940 C11B  26         mov   *r11,tmp0
0043 6942 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6944 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6946 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6948 05CB  14 mknum3  inct  r11
0047 694A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     694C 6046 
0048 694E 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6950 045B  20         b     *r11                  ; Exit
0050 6952 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6954 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6956 13F8  14         jeq   mknum3                ; Yes, exit
0053 6958 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 695A 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     695C 7FFF 
0058 695E C10B  18         mov   r11,tmp0
0059 6960 0224  22         ai    tmp0,-4
     6962 FFFC 
0060 6964 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6966 0206  20         li    tmp2,>0500            ; String length = 5
     6968 0500 
0062 696A 0460  28         b     @xutstr               ; Display string
     696C 6410 
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
0092 696E C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6970 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6972 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6974 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6976 0207  20         li    tmp3,5                ; Set counter
     6978 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 697A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 697C 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 697E 0584  14         inc   tmp0                  ; Next character
0104 6980 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6982 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6984 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6986 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6988 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 698A 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 698C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 698E 0607  14         dec   tmp3                  ; Last character ?
0120 6990 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6992 045B  20         b     *r11                  ; Return
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
0138 6994 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6996 832A 
0139 6998 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     699A 8000 
0140 699C 10BC  14         jmp   mknum                 ; Convert number and display
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
0020 699E C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     69A0 2000 
0021 69A2 C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     69A4 2002 
0022 69A6 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     69A8 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 69AA 0200  20         li    r0,>8306              ; Scratpad source address
     69AC 8306 
0027 69AE 0201  20         li    r1,>2006              ; RAM target address
     69B0 2006 
0028 69B2 0202  20         li    r2,62                 ; Loop counter
     69B4 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 69B6 CC70  46         mov   *r0+,*r1+
0034 69B8 CC70  46         mov   *r0+,*r1+
0035 69BA 0642  14         dect  r2
0036 69BC 16FC  14         jne   cpu.scrpad.backup.copy
0037 69BE C820  54         mov   @>83fe,@>20fe         ; Copy last word
     69C0 83FE 
     69C2 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 69C4 C020  34         mov   @>2000,r0             ; Restore r0
     69C6 2000 
0042 69C8 C060  34         mov   @>2002,r1             ; Restore r1
     69CA 2002 
0043 69CC C0A0  34         mov   @>2004,r2             ; Restore r2
     69CE 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 69D0 045B  20         b     *r11                  ; Return to caller
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
0066 69D2 C820  54         mov   @>2000,@>8300
     69D4 2000 
     69D6 8300 
0067 69D8 C820  54         mov   @>2002,@>8302
     69DA 2002 
     69DC 8302 
0068 69DE C820  54         mov   @>2004,@>8304
     69E0 2004 
     69E2 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 69E4 C800  38         mov   r0,@>2000
     69E6 2000 
0073 69E8 C801  38         mov   r1,@>2002
     69EA 2002 
0074 69EC C802  38         mov   r2,@>2004
     69EE 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 69F0 0200  20         li    r0,>2006
     69F2 2006 
0079 69F4 0201  20         li    r1,>8306
     69F6 8306 
0080 69F8 0202  20         li    r2,62
     69FA 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 69FC CC70  46         mov   *r0+,*r1+
0086 69FE CC70  46         mov   *r0+,*r1+
0087 6A00 0642  14         dect  r2
0088 6A02 16FC  14         jne   cpu.scrpad.restore.copy
0089 6A04 C820  54         mov   @>20fe,@>83fe         ; Copy last word
     6A06 20FE 
     6A08 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 6A0A C020  34         mov   @>2000,r0             ; Restore r0
     6A0C 2000 
0094 6A0E C060  34         mov   @>2002,r1             ; Restore r1
     6A10 2002 
0095 6A12 C0A0  34         mov   @>2004,r2             ; Restore r2
     6A14 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 6A16 045B  20         b     *r11                  ; Return to caller
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
0025 6A18 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 6A1A 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6A1C 8300 
0031 6A1E C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 6A20 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A22 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6A24 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6A26 0606  14         dec   tmp2
0038 6A28 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6A2A C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6A2C 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     6A2E 6A34 
0044                                                   ; R14=PC
0045 6A30 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 6A32 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 6A34 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     6A36 69D2 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 6A38 045B  20         b     *r11                  ; Return to caller
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
0078 6A3A C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 6A3C 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6A3E 8300 
0084 6A40 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6A42 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 6A44 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 6A46 0606  14         dec   tmp2
0090 6A48 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 6A4A 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6A4C 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 6A4E 045B  20         b     *r11                  ; Return to caller
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
0041 6A50 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6A52 6A54             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6A54 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6A56 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6A58 8322 
0049 6A5A 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6A5C 6042 
0050 6A5E C020  34         mov   @>8356,r0             ; get ptr to pab
     6A60 8356 
0051 6A62 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6A64 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6A66 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6A68 06C0  14         swpb  r0                    ;
0059 6A6A D800  38         movb  r0,@vdpa              ; send low byte
     6A6C 8C02 
0060 6A6E 06C0  14         swpb  r0                    ;
0061 6A70 D800  38         movb  r0,@vdpa              ; send high byte
     6A72 8C02 
0062 6A74 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6A76 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6A78 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6A7A 0704  14         seto  r4                    ; init counter
0070 6A7C 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6A7E 2420 
0071 6A80 0580  14 !       inc   r0                    ; point to next char of name
0072 6A82 0584  14         inc   r4                    ; incr char counter
0073 6A84 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6A86 0007 
0074 6A88 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6A8A 80C4  18         c     r4,r3                 ; end of name?
0077 6A8C 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6A8E 06C0  14         swpb  r0                    ;
0082 6A90 D800  38         movb  r0,@vdpa              ; send low byte
     6A92 8C02 
0083 6A94 06C0  14         swpb  r0                    ;
0084 6A96 D800  38         movb  r0,@vdpa              ; send high byte
     6A98 8C02 
0085 6A9A D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6A9C 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6A9E DC81  32         movb  r1,*r2+               ; move into buffer
0092 6AA0 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6AA2 6B64 
0093 6AA4 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6AA6 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6AA8 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6AAA 04E0  34         clr   @>83d0
     6AAC 83D0 
0102 6AAE C804  38         mov   r4,@>8354             ; save name length for search
     6AB0 8354 
0103 6AB2 0584  14         inc   r4                    ; adjust for dot
0104 6AB4 A804  38         a     r4,@>8356             ; point to position after name
     6AB6 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6AB8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6ABA 83E0 
0110 6ABC 04C1  14         clr   r1                    ; version found of dsr
0111 6ABE 020C  20         li    r12,>0f00             ; init cru addr
     6AC0 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6AC2 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6AC4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6AC6 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6AC8 022C  22         ai    r12,>0100             ; next rom to turn on
     6ACA 0100 
0125 6ACC 04E0  34         clr   @>83d0                ; clear in case we are done
     6ACE 83D0 
0126 6AD0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6AD2 2000 
0127 6AD4 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6AD6 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6AD8 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6ADA 1D00  20         sbo   0                     ; turn on rom
0134 6ADC 0202  20         li    r2,>4000              ; start at beginning of rom
     6ADE 4000 
0135 6AE0 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6AE2 6B60 
0136 6AE4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6AE6 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6AE8 240A 
0146 6AEA 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6AEC C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6AEE 83D2 
0152 6AF0 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6AF2 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6AF4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6AF6 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6AF8 83D2 
0161 6AFA 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6AFC C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6AFE 04C5  14         clr   r5                    ; Remove any old stuff
0167 6B00 D160  34         movb  @>8355,r5             ; get length as counter
     6B02 8355 
0168 6B04 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6B06 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6B08 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6B0A 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6B0C 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6B0E 2420 
0175 6B10 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6B12 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6B14 0605  14         dec   r5                    ; loop until full length checked
0179 6B16 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6B18 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6B1A 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6B1C 0581  14         inc   r1                    ; next version found
0191 6B1E 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6B20 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6B22 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6B24 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6B26 2400 
0200 6B28 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6B2A C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6B2C 8322 
0202                                                   ; (8 or >a)
0203 6B2E 0281  22         ci    r1,8                  ; was it 8?
     6B30 0008 
0204 6B32 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6B34 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6B36 8350 
0206                                                   ; Get error byte from @>8350
0207 6B38 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6B3A 06C0  14         swpb  r0                    ;
0215 6B3C D800  38         movb  r0,@vdpa              ; send low byte
     6B3E 8C02 
0216 6B40 06C0  14         swpb  r0                    ;
0217 6B42 D800  38         movb  r0,@vdpa              ; send high byte
     6B44 8C02 
0218 6B46 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6B48 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6B4A 09D1  56         srl   r1,13                 ; just keep error bits
0226 6B4C 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6B4E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6B50 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6B52 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6B54 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6B56 06C1  14         swpb  r1                    ; put error in hi byte
0239 6B58 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6B5A F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6B5C 6042 
0241 6B5E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6B60 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6B62 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6B64 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6B66 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6B68 C04B  18         mov   r11,r1                ; Save return address
0049 6B6A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B6C 2428 
0050 6B6E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6B70 04C5  14         clr   tmp1                  ; io.op.open
0052 6B72 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B74 62BA 
0053               file.open_init:
0054 6B76 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B78 0009 
0055 6B7A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B7C 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6B7E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6B80 6A50 
0061 6B82 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6B84 1029  14         jmp   file.record.pab.details
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
0090 6B86 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6B88 C04B  18         mov   r11,r1                ; Save return address
0096 6B8A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6B8C 2428 
0097 6B8E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6B90 0205  20         li    tmp1,io.op.close      ; io.op.close
     6B92 0001 
0099 6B94 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6B96 62BA 
0100               file.close_init:
0101 6B98 0220  22         ai    r0,9                  ; Move to file descriptor length
     6B9A 0009 
0102 6B9C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6B9E 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6BA0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BA2 6A50 
0108 6BA4 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6BA6 1018  14         jmp   file.record.pab.details
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
0139 6BA8 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6BAA C04B  18         mov   r11,r1                ; Save return address
0145 6BAC C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6BAE 2428 
0146 6BB0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6BB2 0205  20         li    tmp1,io.op.read       ; io.op.read
     6BB4 0002 
0148 6BB6 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6BB8 62BA 
0149               file.record.read_init:
0150 6BBA 0220  22         ai    r0,9                  ; Move to file descriptor length
     6BBC 0009 
0151 6BBE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6BC0 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6BC2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6BC4 6A50 
0157 6BC6 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6BC8 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6BCA 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6BCC 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6BCE 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6BD0 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6BD2 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6BD4 1000  14         nop
0191               
0192               
0193               file.status:
0194 6BD6 1000  14         nop
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
0211 6BD8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6BDA C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6BDC 2428 
0219 6BDE 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6BE0 0005 
0220 6BE2 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6BE4 62D2 
0221 6BE6 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6BE8 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6BEA 0451  20         b     *r1                   ; Return to caller
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
0020 6BEC 0300  24 tmgr    limi  0                     ; No interrupt processing
     6BEE 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6BF0 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6BF2 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6BF4 2360  38         coc   @wbit2,r13            ; C flag on ?
     6BF6 6042 
0029 6BF8 1602  14         jne   tmgr1a                ; No, so move on
0030 6BFA E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6BFC 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6BFE 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6C00 6046 
0035 6C02 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6C04 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6C06 6036 
0048 6C08 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6C0A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6C0C 6034 
0050 6C0E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6C10 0460  28         b     @kthread              ; Run kernel thread
     6C12 6C8A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6C14 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6C16 603A 
0056 6C18 13EB  14         jeq   tmgr1
0057 6C1A 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6C1C 6038 
0058 6C1E 16E8  14         jne   tmgr1
0059 6C20 C120  34         mov   @wtiusr,tmp0
     6C22 832E 
0060 6C24 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6C26 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6C28 6C88 
0065 6C2A C10A  18         mov   r10,tmp0
0066 6C2C 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6C2E 00FF 
0067 6C30 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6C32 6042 
0068 6C34 1303  14         jeq   tmgr5
0069 6C36 0284  22         ci    tmp0,60               ; 1 second reached ?
     6C38 003C 
0070 6C3A 1002  14         jmp   tmgr6
0071 6C3C 0284  22 tmgr5   ci    tmp0,50
     6C3E 0032 
0072 6C40 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C42 1001  14         jmp   tmgr8
0074 6C44 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C46 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C48 832C 
0079 6C4A 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6C4C FF00 
0080 6C4E C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6C50 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6C52 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6C54 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6C56 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6C58 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6C5A 830C 
     6C5C 830D 
0089 6C5E 1608  14         jne   tmgr10                ; No, get next slot
0090 6C60 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6C62 FF00 
0091 6C64 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6C66 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6C68 8330 
0096 6C6A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6C6C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6C6E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6C70 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6C72 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6C74 8315 
     6C76 8314 
0103 6C78 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6C7A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6C7C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6C7E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6C80 10F7  14         jmp   tmgr10                ; Process next slot
0108 6C82 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6C84 FF00 
0109 6C86 10B4  14         jmp   tmgr1
0110 6C88 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6C8A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6C8C 6036 
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
0041 6C8E 06A0  32         bl    @realkb               ; Scan full keyboard
     6C90 6730 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6C92 0460  28         b     @tmgr3                ; Exit
     6C94 6C14 
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
0017 6C96 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6C98 832E 
0018 6C9A E0A0  34         soc   @wbit7,config         ; Enable user hook
     6C9C 6038 
0019 6C9E 045B  20 mkhoo1  b     *r11                  ; Return
0020      6BF0     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 6CA0 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6CA2 832E 
0029 6CA4 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6CA6 FEFF 
0030 6CA8 045B  20         b     *r11                  ; Return
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
0017 6CAA C13B  30 mkslot  mov   *r11+,tmp0
0018 6CAC C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6CAE C184  18         mov   tmp0,tmp2
0023 6CB0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6CB2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6CB4 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6CB6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6CB8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6CBA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6CBC 881B  46         c     *r11,@w$ffff          ; End of list ?
     6CBE 6048 
0035 6CC0 1301  14         jeq   mkslo1                ; Yes, exit
0036 6CC2 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6CC4 05CB  14 mkslo1  inct  r11
0041 6CC6 045B  20         b     *r11                  ; Exit
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
0052 6CC8 C13B  30 clslot  mov   *r11+,tmp0
0053 6CCA 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6CCC A120  34         a     @wtitab,tmp0          ; Add table base
     6CCE 832C 
0055 6CD0 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6CD2 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6CD4 045B  20         b     *r11                  ; Exit
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
0250 6CD6 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     6CD8 699E 
0251 6CDA 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6CDC 8302 
0255               *--------------------------------------------------------------
0256               * Alternative entry point
0257               *--------------------------------------------------------------
0258 6CDE 0300  24 runli1  limi  0                     ; Turn off interrupts
     6CE0 0000 
0259 6CE2 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6CE4 8300 
0260 6CE6 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6CE8 83C0 
0261               *--------------------------------------------------------------
0262               * Clear scratch-pad memory from R4 upwards
0263               *--------------------------------------------------------------
0264 6CEA 0202  20 runli2  li    r2,>8308
     6CEC 8308 
0265 6CEE 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0266 6CF0 0282  22         ci    r2,>8400
     6CF2 8400 
0267 6CF4 16FC  14         jne   runli3
0268               *--------------------------------------------------------------
0269               * Exit to TI-99/4A title screen ?
0270               *--------------------------------------------------------------
0271               runli3a
0272 6CF6 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6CF8 FFFF 
0273 6CFA 1602  14         jne   runli4                ; No, continue
0274 6CFC 0420  54         blwp  @0                    ; Yes, bye bye
     6CFE 0000 
0275               *--------------------------------------------------------------
0276               * Determine if VDP is PAL or NTSC
0277               *--------------------------------------------------------------
0278 6D00 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6D02 833C 
0279 6D04 04C1  14         clr   r1                    ; Reset counter
0280 6D06 0202  20         li    r2,10                 ; We test 10 times
     6D08 000A 
0281 6D0A C0E0  34 runli5  mov   @vdps,r3
     6D0C 8802 
0282 6D0E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6D10 6046 
0283 6D12 1302  14         jeq   runli6
0284 6D14 0581  14         inc   r1                    ; Increase counter
0285 6D16 10F9  14         jmp   runli5
0286 6D18 0602  14 runli6  dec   r2                    ; Next test
0287 6D1A 16F7  14         jne   runli5
0288 6D1C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6D1E 1250 
0289 6D20 1202  14         jle   runli7                ; No, so it must be NTSC
0290 6D22 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6D24 6042 
0291               *--------------------------------------------------------------
0292               * Copy machine code to scratchpad (prepare tight loop)
0293               *--------------------------------------------------------------
0294 6D26 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6D28 620E 
0295 6D2A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6D2C 8322 
0296 6D2E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0297 6D30 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0298 6D32 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0299               *--------------------------------------------------------------
0300               * Initialize registers, memory, ...
0301               *--------------------------------------------------------------
0302 6D34 04C1  14 runli9  clr   r1
0303 6D36 04C2  14         clr   r2
0304 6D38 04C3  14         clr   r3
0305 6D3A 0209  20         li    stack,>8400           ; Set stack
     6D3C 8400 
0306 6D3E 020F  20         li    r15,vdpw              ; Set VDP write address
     6D40 8C00 
0310               *--------------------------------------------------------------
0311               * Setup video memory
0312               *--------------------------------------------------------------
0314 6D42 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6D44 4A4A 
0315 6D46 1605  14         jne   runlia
0316 6D48 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6D4A 627C 
0317 6D4C 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6D4E 0000 
     6D50 3FFF 
0322 6D52 06A0  32 runlia  bl    @filv
     6D54 627C 
0323 6D56 0FC0             data  pctadr,spfclr,16      ; Load color table
     6D58 00F4 
     6D5A 0010 
0324               *--------------------------------------------------------------
0325               * Check if there is a F18A present
0326               *--------------------------------------------------------------
0330 6D5C 06A0  32         bl    @f18unl               ; Unlock the F18A
     6D5E 6678 
0331 6D60 06A0  32         bl    @f18chk               ; Check if F18A is there
     6D62 6692 
0332 6D64 06A0  32         bl    @f18lck               ; Lock the F18A again
     6D66 6688 
0334               *--------------------------------------------------------------
0335               * Check if there is a speech synthesizer attached
0336               *--------------------------------------------------------------
0338               *       <<skipped>>
0342               *--------------------------------------------------------------
0343               * Load video mode table & font
0344               *--------------------------------------------------------------
0345 6D68 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6D6A 62E6 
0346 6D6C 6204             data  spvmod                ; Equate selected video mode table
0347 6D6E 0204  20         li    tmp0,spfont           ; Get font option
     6D70 000C 
0348 6D72 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0349 6D74 1304  14         jeq   runlid                ; Yes, skip it
0350 6D76 06A0  32         bl    @ldfnt
     6D78 634E 
0351 6D7A 1100             data  fntadr,spfont         ; Load specified font
     6D7C 000C 
0352               *--------------------------------------------------------------
0353               * Did a system crash occur before runlib was called?
0354               *--------------------------------------------------------------
0355 6D7E 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6D80 4A4A 
0356 6D82 1602  14         jne   runlie                ; No, continue
0357 6D84 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     6D86 60A0 
0358               *--------------------------------------------------------------
0359               * Branch to main program
0360               *--------------------------------------------------------------
0361 6D88 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6D8A 0040 
0362 6D8C 0460  28         b     @main                 ; Give control to main program
     6D8E 6D90 
**** **** ****     > tivi.asm.14086
0227               
0228               *--------------------------------------------------------------
0229               * Video mode configuration
0230               *--------------------------------------------------------------
0231      6204     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0232      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0233      0050     colrow  equ   80                    ; Columns per row
0234      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0235      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0236      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0237      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0238               
0239               
0240               ***************************************************************
0241               * Main
0242               ********|*****|*********************|**************************
0243 6D90 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6D92 6044 
0244 6D94 1302  14         jeq   main.continue
0245 6D96 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6D98 0000 
0246               
0247               main.continue:
0248 6D9A 06A0  32         bl    @scroff               ; Turn screen off
     6D9C 65D4 
0249 6D9E 06A0  32         bl    @f18unl               ; Unlock the F18a
     6DA0 6678 
0250 6DA2 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6DA4 6320 
0251 6DA6 3140                   data >3140            ; F18a VR49 (>31), bit 40
0252                       ;------------------------------------------------------
0253                       ; Initialize VDP SIT
0254                       ;------------------------------------------------------
0255 6DA8 06A0  32         bl    @filv
     6DAA 627C 
0256 6DAC 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6DAE 0020 
     6DB0 09B0 
0257 6DB2 06A0  32         bl    @scron                ; Turn screen on
     6DB4 65DC 
0258                       ;------------------------------------------------------
0259                       ; Initialize low + high memory expansion
0260                       ;------------------------------------------------------
0261 6DB6 06A0  32         bl    @film
     6DB8 6224 
0262 6DBA 2200                   data >2200,00,8*1024-256*2
     6DBC 0000 
     6DBE 3E00 
0263                                                   ; Clear part of 8k low-memory
0264               
0265 6DC0 06A0  32         bl    @film
     6DC2 6224 
0266 6DC4 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6DC6 0000 
     6DC8 6000 
0267                       ;------------------------------------------------------
0268                       ; Load SAMS default memory layout
0269                       ;------------------------------------------------------
0270 6DCA 06A0  32         bl    @mem.setup.sams.layout
     6DCC 7550 
0271                                                   ; Initialize SAMS layout
0272                       ;------------------------------------------------------
0273                       ; Setup cursor, screen, etc.
0274                       ;------------------------------------------------------
0275 6DCE 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6DD0 65F4 
0276 6DD2 06A0  32         bl    @s8x8                 ; Small sprite
     6DD4 6604 
0277               
0278 6DD6 06A0  32         bl    @cpym2m
     6DD8 646E 
0279 6DDA 7C8A                   data romsat,ramsat,4  ; Load sprite SAT
     6DDC 8380 
     6DDE 0004 
0280               
0281 6DE0 C820  54         mov   @romsat+2,@fb.curshape
     6DE2 7C8C 
     6DE4 2210 
0282                                                   ; Save cursor shape & color
0283               
0284 6DE6 06A0  32         bl    @cpym2v
     6DE8 6426 
0285 6DEA 1800                   data sprpdt,cursors,3*8
     6DEC 7C8E 
     6DEE 0018 
0286                                                   ; Load sprite cursor patterns
0287               *--------------------------------------------------------------
0288               * Initialize
0289               *--------------------------------------------------------------
0290 6DF0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6DF2 77A2 
0291 6DF4 06A0  32         bl    @idx.init             ; Initialize index
     6DF6 76CA 
0292 6DF8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6DFA 75B2 
0293                       ;-------------------------------------------------------
0294                       ; Setup editor tasks & hook
0295                       ;-------------------------------------------------------
0296 6DFC 0204  20         li    tmp0,>0200
     6DFE 0200 
0297 6E00 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6E02 8314 
0298               
0299 6E04 06A0  32         bl    @at
     6E06 6614 
0300 6E08 0000             data  >0000                 ; Cursor YX position = >0000
0301               
0302 6E0A 0204  20         li    tmp0,timers
     6E0C 8370 
0303 6E0E C804  38         mov   tmp0,@wtitab
     6E10 832C 
0304               
0305 6E12 06A0  32         bl    @mkslot
     6E14 6CAA 
0306 6E16 0001                   data >0001,task0      ; Task 0 - Update screen
     6E18 73CA 
0307 6E1A 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6E1C 744E 
0308 6E1E 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6E20 745C 
     6E22 FFFF 
0309               
0310 6E24 06A0  32         bl    @mkhook
     6E26 6C96 
0311 6E28 6E2E                   data editor           ; Setup user hook
0312               
0313 6E2A 0460  28         b     @tmgr                 ; Start timers and kthread
     6E2C 6BEC 
0314               
0315               
0316               ****************************************************************
0317               * Editor - Main loop
0318               ****************************************************************
0319 6E2E 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6E30 6030 
0320 6E32 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0321               *---------------------------------------------------------------
0322               * Identical key pressed ?
0323               *---------------------------------------------------------------
0324 6E34 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6E36 6030 
0325 6E38 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6E3A 833C 
     6E3C 833E 
0326 6E3E 1308  14         jeq   ed_wait
0327               *--------------------------------------------------------------
0328               * New key pressed
0329               *--------------------------------------------------------------
0330               ed_new_key
0331 6E40 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6E42 833C 
     6E44 833E 
0332 6E46 1045  14         jmp   edkey                 ; Process key
0333               *--------------------------------------------------------------
0334               * Clear keyboard buffer if no key pressed
0335               *--------------------------------------------------------------
0336               ed_clear_kbbuffer
0337 6E48 04E0  34         clr   @waux1
     6E4A 833C 
0338 6E4C 04E0  34         clr   @waux2
     6E4E 833E 
0339               *--------------------------------------------------------------
0340               * Delay to avoid key bouncing
0341               *--------------------------------------------------------------
0342               ed_wait
0343 6E50 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6E52 0708 
0344                       ;------------------------------------------------------
0345                       ; Delay loop
0346                       ;------------------------------------------------------
0347               ed_wait_loop
0348 6E54 0604  14         dec   tmp0
0349 6E56 16FE  14         jne   ed_wait_loop
0350               *--------------------------------------------------------------
0351               * Exit
0352               *--------------------------------------------------------------
0353 6E58 0460  28 ed_exit b     @hookok               ; Return
     6E5A 6BF0 
0354               
0355               
0356               
0357               
0358               
0359               
0360               ***************************************************************
0361               *                Tivi - Editor keyboard actions
0362               ***************************************************************
0363                       copy  "editorkeys_init.asm" ; Initialisation & setup
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
0055 6E5C 0D00             data  key_enter,edkey.action.enter          ; New line
     6E5E 72C0 
0056 6E60 0800             data  key_left,edkey.action.left            ; Move cursor left
     6E62 6EF4 
0057 6E64 0900             data  key_right,edkey.action.right          ; Move cursor right
     6E66 6F0A 
0058 6E68 0B00             data  key_up,edkey.action.up                ; Move cursor up
     6E6A 6F22 
0059 6E6C 0A00             data  key_down,edkey.action.down            ; Move cursor down
     6E6E 6F74 
0060 6E70 8100             data  key_home,edkey.action.home            ; Move cursor to line begin
     6E72 6FE0 
0061 6E74 8600             data  key_end,edkey.action.end              ; Move cursor to line end
     6E76 6FF8 
0062 6E78 9300             data  key_pword,edkey.action.pword          ; Move cursor previous word
     6E7A 700C 
0063 6E7C 8400             data  key_nword,edkey.action.nword          ; Move cursor next word
     6E7E 705E 
0064 6E80 8500             data  key_ppage,edkey.action.ppage          ; Move cursor previous page
     6E82 70BE 
0065 6E84 9800             data  key_npage,edkey.action.npage          ; Move cursor next page
     6E86 7108 
0066 6E88 9400             data  key_tpage,edkey.action.top            ; Move cursor to top of file
     6E8A 7134 
0067                       ;-------------------------------------------------------
0068                       ; Modifier keys - Delete
0069                       ;-------------------------------------------------------
0070 6E8C 0300             data  key_del_char,edkey.action.del_char    ; Delete character
     6E8E 7162 
0071 6E90 8B00             data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
     6E92 719A 
0072 6E94 0700             data  key_del_line,edkey.action.del_line    ; Delete current line
     6E96 71CE 
0073                       ;-------------------------------------------------------
0074                       ; Modifier keys - Insert
0075                       ;-------------------------------------------------------
0076 6E98 0400             data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
     6E9A 7226 
0077 6E9C B900             data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
     6E9E 732E 
0078 6EA0 0E00             data  key_ins_line,edkey.action.ins_line    ; Insert new line
     6EA2 727C 
0079                       ;-------------------------------------------------------
0080                       ; Other action keys
0081                       ;-------------------------------------------------------
0082 6EA4 0500             data  key_quit1,edkey.action.quit           ; Quit TiVi
     6EA6 737E 
0083                       ;-------------------------------------------------------
0084                       ; Editor/File buffer keys
0085                       ;-------------------------------------------------------
0086 6EA8 B000             data  key_buf0,edkey.action.buffer0
     6EAA 7386 
0087 6EAC B100             data  key_buf1,edkey.action.buffer1
     6EAE 738C 
0088 6EB0 B200             data  key_buf2,edkey.action.buffer2
     6EB2 7392 
0089 6EB4 B300             data  key_buf3,edkey.action.buffer3
     6EB6 7398 
0090 6EB8 B400             data  key_buf4,edkey.action.buffer4
     6EBA 739E 
0091 6EBC B500             data  key_buf5,edkey.action.buffer5
     6EBE 73A4 
0092 6EC0 B600             data  key_buf6,edkey.action.buffer6
     6EC2 73AA 
0093 6EC4 B700             data  key_buf7,edkey.action.buffer7
     6EC6 73B0 
0094 6EC8 9E00             data  key_buf8,edkey.action.buffer8
     6ECA 73B6 
0095 6ECC 9F00             data  key_buf9,edkey.action.buffer9
     6ECE 73BC 
0096 6ED0 FFFF             data  >ffff                                 ; EOL
0097               
0098               
0099               
0100               ****************************************************************
0101               * Editor - Process key
0102               ****************************************************************
0103 6ED2 C160  34 edkey   mov   @waux1,tmp1           ; Get key value
     6ED4 833C 
0104 6ED6 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6ED8 FF00 
0105               
0106 6EDA 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6EDC 6E5C 
0107 6EDE 0707  14         seto  tmp3                  ; EOL marker
0108                       ;-------------------------------------------------------
0109                       ; Iterate over keyboard map for matching key
0110                       ;-------------------------------------------------------
0111               edkey.check_next_key:
0112 6EE0 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0113 6EE2 1306  14         jeq   edkey.do_action.set   ; Yes, so go add letter
0114               
0115 6EE4 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0116 6EE6 1302  14         jeq   edkey.do_action       ; Yes, do action
0117 6EE8 05C6  14         inct  tmp2                  ; No, skip action
0118 6EEA 10FA  14         jmp   edkey.check_next_key  ; Next key
0119               
0120               edkey.do_action:
0121 6EEC C196  26         mov  *tmp2,tmp2             ; Get action address
0122 6EEE 0456  20         b    *tmp2                  ; Process key action
0123               edkey.do_action.set:
0124 6EF0 0460  28         b    @edkey.action.char     ; Add character to buffer
     6EF2 733E 
**** **** ****     > tivi.asm.14086
0364                       copy  "editorkeys_mov.asm"  ; Actions for movement keys
**** **** ****     > editorkeys_mov.asm
0001               * FILE......: editorkeys_mov.asm
0002               * Purpose...: Actions for movement keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6EF4 C120  34         mov   @fb.column,tmp0
     6EF6 220C 
0010 6EF8 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6EFA 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6EFC 220C 
0015 6EFE 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6F00 832A 
0016 6F02 0620  34         dec   @fb.current
     6F04 2202 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6F06 0460  28 !       b     @ed_wait              ; Back to editor main
     6F08 6E50 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6F0A 8820  54         c     @fb.column,@fb.row.length
     6F0C 220C 
     6F0E 2208 
0028 6F10 1406  14         jhe   !                     ; column > length line ? Skip further processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6F12 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6F14 220C 
0033 6F16 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6F18 832A 
0034 6F1A 05A0  34         inc   @fb.current
     6F1C 2202 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6F1E 0460  28 !       b     @ed_wait              ; Back to editor main
     6F20 6E50 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6F22 8820  54         c     @fb.row.dirty,@w$ffff
     6F24 220A 
     6F26 6048 
0049 6F28 1604  14         jne   edkey.action.up.cursor
0050 6F2A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F2C 77C2 
0051 6F2E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F30 220A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6F32 C120  34         mov   @fb.row,tmp0
     6F34 2206 
0057 6F36 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row>0
0059 6F38 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6F3A 2204 
0060 6F3C 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 6F3E 0604  14         dec   tmp0                  ; fb.topline--
0066 6F40 C804  38         mov   tmp0,@parm1
     6F42 8350 
0067 6F44 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F46 761C 
0068 6F48 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 6F4A 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F4C 2206 
0074 6F4E 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F50 6622 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 6F52 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F54 793C 
0080 6F56 8820  54         c     @fb.column,@fb.row.length
     6F58 220C 
     6F5A 2208 
0081 6F5C 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 6F5E C820  54         mov   @fb.row.length,@fb.column
     6F60 2208 
     6F62 220C 
0086 6F64 C120  34         mov   @fb.column,tmp0
     6F66 220C 
0087 6F68 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F6A 662C 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 6F6C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F6E 7600 
0093 6F70 0460  28         b     @ed_wait              ; Back to editor main
     6F72 6E50 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 6F74 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6F76 2206 
     6F78 2304 
0102 6F7A 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6F7C 8820  54         c     @fb.row.dirty,@w$ffff
     6F7E 220A 
     6F80 6048 
0107 6F82 1604  14         jne   edkey.action.down.move
0108 6F84 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F86 77C2 
0109 6F88 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F8A 220A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6F8C C120  34         mov   @fb.topline,tmp0
     6F8E 2204 
0118 6F90 A120  34         a     @fb.row,tmp0
     6F92 2206 
0119 6F94 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6F96 2304 
0120 6F98 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6F9A C120  34         mov   @fb.screenrows,tmp0
     6F9C 2218 
0126 6F9E 0604  14         dec   tmp0
0127 6FA0 8120  34         c     @fb.row,tmp0
     6FA2 2206 
0128 6FA4 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6FA6 C820  54         mov   @fb.topline,@parm1
     6FA8 2204 
     6FAA 8350 
0133 6FAC 05A0  34         inc   @parm1
     6FAE 8350 
0134 6FB0 06A0  32         bl    @fb.refresh
     6FB2 761C 
0135 6FB4 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6FB6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6FB8 2206 
0141 6FBA 06A0  32         bl    @down                 ; Row++ VDP cursor
     6FBC 661A 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6FBE 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6FC0 793C 
0147               
0148 6FC2 8820  54         c     @fb.column,@fb.row.length
     6FC4 220C 
     6FC6 2208 
0149 6FC8 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 6FCA C820  54         mov   @fb.row.length,@fb.column
     6FCC 2208 
     6FCE 220C 
0155 6FD0 C120  34         mov   @fb.column,tmp0
     6FD2 220C 
0156 6FD4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FD6 662C 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6FD8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FDA 7600 
0162 6FDC 0460  28 !       b     @ed_wait              ; Back to editor main
     6FDE 6E50 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 6FE0 C120  34         mov   @wyx,tmp0
     6FE2 832A 
0171 6FE4 0244  22         andi  tmp0,>ff00
     6FE6 FF00 
0172 6FE8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6FEA 832A 
0173 6FEC 04E0  34         clr   @fb.column
     6FEE 220C 
0174 6FF0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FF2 7600 
0175 6FF4 0460  28         b     @ed_wait              ; Back to editor main
     6FF6 6E50 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 6FF8 C120  34         mov   @fb.row.length,tmp0
     6FFA 2208 
0182 6FFC C804  38         mov   tmp0,@fb.column
     6FFE 220C 
0183 7000 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7002 662C 
0184 7004 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7006 7600 
0185 7008 0460  28         b     @ed_wait              ; Back to editor main
     700A 6E50 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 700C C120  34         mov   @fb.column,tmp0
     700E 220C 
0194 7010 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 7012 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7014 2202 
0199 7016 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 7018 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 701A 0605  14         dec   tmp1
0206 701C 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 701E 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 7020 D195  26         movb  *tmp1,tmp2            ; Get character
0214 7022 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 7024 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 7026 0986  56         srl   tmp2,8                ; Right justify
0217 7028 0286  22         ci    tmp2,32               ; Space character found?
     702A 0020 
0218 702C 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 702E 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7030 2020 
0224 7032 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 7034 0287  22         ci    tmp3,>20ff            ; First character is space
     7036 20FF 
0227 7038 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 703A C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     703C 220C 
0232 703E 61C4  18         s     tmp0,tmp3
0233 7040 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7042 0002 
0234 7044 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 7046 0585  14         inc   tmp1
0240 7048 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 704A C805  38         mov   tmp1,@fb.current
     704C 2202 
0246 704E C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7050 220C 
0247 7052 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7054 662C 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 7056 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7058 7600 
0253 705A 0460  28 !       b     @ed_wait              ; Back to editor main
     705C 6E50 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 705E 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 7060 C120  34         mov   @fb.column,tmp0
     7062 220C 
0263 7064 8804  38         c     tmp0,@fb.row.length
     7066 2208 
0264 7068 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 706A C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     706C 2202 
0269 706E 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 7070 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 7072 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 7074 0585  14         inc   tmp1
0281 7076 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 7078 8804  38         c     tmp0,@fb.row.length
     707A 2208 
0283 707C 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 707E D195  26         movb  *tmp1,tmp2            ; Get character
0290 7080 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 7082 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 7084 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 7086 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7088 FFFF 
0295 708A 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 708C 0286  22         ci    tmp2,32
     708E 0020 
0301 7090 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 7092 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 7094 0286  22         ci    tmp2,32               ; Space character found?
     7096 0020 
0309 7098 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 709A 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     709C 2020 
0315 709E 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 70A0 0287  22         ci    tmp3,>20ff            ; First characer is space?
     70A2 20FF 
0318 70A4 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 70A6 0585  14         inc   tmp1
0323 70A8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 70AA C805  38         mov   tmp1,@fb.current
     70AC 2202 
0329 70AE C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     70B0 220C 
0330 70B2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70B4 662C 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 70B6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70B8 7600 
0336 70BA 0460  28 !       b     @ed_wait              ; Back to editor main
     70BC 6E50 
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
0348 70BE C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     70C0 2204 
0349 70C2 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 70C4 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     70C6 2218 
0354 70C8 1503  14         jgt   edkey.action.ppage.topline
0355 70CA 04E0  34         clr   @fb.topline           ; topline = 0
     70CC 2204 
0356 70CE 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 70D0 6820  54         s     @fb.screenrows,@fb.topline
     70D2 2218 
     70D4 2204 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 70D6 8820  54         c     @fb.row.dirty,@w$ffff
     70D8 220A 
     70DA 6048 
0367 70DC 1604  14         jne   edkey.action.ppage.refresh
0368 70DE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70E0 77C2 
0369 70E2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70E4 220A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 70E6 C820  54         mov   @fb.topline,@parm1
     70E8 2204 
     70EA 8350 
0375 70EC 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     70EE 761C 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 70F0 04E0  34         clr   @fb.row
     70F2 2206 
0381 70F4 05A0  34         inc   @fb.row               ; Set fb.row=1
     70F6 2206 
0382 70F8 04E0  34         clr   @fb.column
     70FA 220C 
0383 70FC 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     70FE 0100 
0384 7100 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     7102 832A 
0385 7104 0460  28         b     @edkey.action.up      ; Do rest of logic
     7106 6F22 
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
0396 7108 C120  34         mov   @fb.topline,tmp0
     710A 2204 
0397 710C A120  34         a     @fb.screenrows,tmp0
     710E 2218 
0398 7110 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7112 2304 
0399 7114 150D  14         jgt   edkey.action.npage.exit
0400                       ;-------------------------------------------------------
0401                       ; Adjust topline
0402                       ;-------------------------------------------------------
0403               edkey.action.npage.topline:
0404 7116 A820  54         a     @fb.screenrows,@fb.topline
     7118 2218 
     711A 2204 
0405                       ;-------------------------------------------------------
0406                       ; Crunch current row if dirty
0407                       ;-------------------------------------------------------
0408               edkey.action.npage.crunch:
0409 711C 8820  54         c     @fb.row.dirty,@w$ffff
     711E 220A 
     7120 6048 
0410 7122 1604  14         jne   edkey.action.npage.refresh
0411 7124 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7126 77C2 
0412 7128 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     712A 220A 
0413                       ;-------------------------------------------------------
0414                       ; Refresh page
0415                       ;-------------------------------------------------------
0416               edkey.action.npage.refresh:
0417 712C 0460  28         b     @edkey.action.ppage.refresh
     712E 70E6 
0418                                                   ; Same logic as previous page
0419                       ;-------------------------------------------------------
0420                       ; Exit
0421                       ;-------------------------------------------------------
0422               edkey.action.npage.exit:
0423 7130 0460  28         b     @ed_wait              ; Back to editor main
     7132 6E50 
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
0435 7134 8820  54         c     @fb.row.dirty,@w$ffff
     7136 220A 
     7138 6048 
0436 713A 1604  14         jne   edkey.action.top.refresh
0437 713C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     713E 77C2 
0438 7140 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7142 220A 
0439                       ;-------------------------------------------------------
0440                       ; Refresh page
0441                       ;-------------------------------------------------------
0442               edkey.action.top.refresh:
0443 7144 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     7146 2204 
0444 7148 04E0  34         clr   @parm1
     714A 8350 
0445 714C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     714E 761C 
0446                       ;-------------------------------------------------------
0447                       ; Exit
0448                       ;-------------------------------------------------------
0449               edkey.action.top.exit:
0450 7150 04E0  34         clr   @fb.row               ; Editor line 0
     7152 2206 
0451 7154 04E0  34         clr   @fb.column            ; Editor column 0
     7156 220C 
0452 7158 04C4  14         clr   tmp0                  ; Set VDP cursor on line 0, column 0
0453 715A C804  38         mov   tmp0,@wyx             ;
     715C 832A 
0454 715E 0460  28         b     @ed_wait              ; Back to editor main
     7160 6E50 
**** **** ****     > tivi.asm.14086
0365                       copy  "editorkeys_mod.asm"  ; Actions for modifier keys
**** **** ****     > editorkeys_mod.asm
0001               * FILE......: editorkeys_mod.asm
0002               * Purpose...: Actions for modifier keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 7162 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7164 2306 
0010 7166 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7168 7600 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 716A C120  34         mov   @fb.current,tmp0      ; Get pointer
     716C 2202 
0015 716E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7170 2208 
0016 7172 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 7174 8820  54         c     @fb.column,@fb.row.length
     7176 220C 
     7178 2208 
0022 717A 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 717C C120  34         mov   @fb.current,tmp0      ; Get pointer
     717E 2202 
0028 7180 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 7182 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 7184 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 7186 0606  14         dec   tmp2
0036 7188 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 718A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     718C 220A 
0041 718E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7190 2216 
0042 7192 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7194 2208 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 7196 0460  28         b     @ed_wait              ; Back to editor main
     7198 6E50 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 719A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     719C 2306 
0055 719E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71A0 7600 
0056 71A2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     71A4 2208 
0057 71A6 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 71A8 C120  34         mov   @fb.current,tmp0      ; Get pointer
     71AA 2202 
0063 71AC C1A0  34         mov   @fb.colsline,tmp2
     71AE 220E 
0064 71B0 61A0  34         s     @fb.column,tmp2
     71B2 220C 
0065 71B4 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 71B6 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 71B8 0606  14         dec   tmp2
0072 71BA 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 71BC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     71BE 220A 
0077 71C0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71C2 2216 
0078               
0079 71C4 C820  54         mov   @fb.column,@fb.row.length
     71C6 220C 
     71C8 2208 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 71CA 0460  28         b     @ed_wait              ; Back to editor main
     71CC 6E50 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 71CE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     71D0 2306 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 71D2 C120  34         mov   @edb.lines,tmp0
     71D4 2304 
0097 71D6 1604  14         jne   !
0098 71D8 04E0  34         clr   @fb.column            ; Column 0
     71DA 220C 
0099 71DC 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     71DE 719A 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 71E0 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71E2 7600 
0104 71E4 04E0  34         clr   @fb.row.dirty         ; Discard current line
     71E6 220A 
0105 71E8 C820  54         mov   @fb.topline,@parm1
     71EA 2204 
     71EC 8350 
0106 71EE A820  54         a     @fb.row,@parm1        ; Line number to remove
     71F0 2206 
     71F2 8350 
0107 71F4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71F6 2304 
     71F8 8352 
0108 71FA 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     71FC 770C 
0109 71FE 0620  34         dec   @edb.lines            ; One line less in editor buffer
     7200 2304 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 7202 C820  54         mov   @fb.topline,@parm1
     7204 2204 
     7206 8350 
0114 7208 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     720A 761C 
0115 720C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     720E 2216 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 7210 C120  34         mov   @fb.topline,tmp0
     7212 2204 
0120 7214 A120  34         a     @fb.row,tmp0
     7216 2206 
0121 7218 8804  38         c     tmp0,@edb.lines       ; Was last line?
     721A 2304 
0122 721C 1202  14         jle   edkey.action.del_line.exit
0123 721E 0460  28         b     @edkey.action.up      ; One line up
     7220 6F22 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 7222 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     7224 6FE0 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws
0138 7226 0204  20         li    tmp0,>2000            ; White space
     7228 2000 
0139 722A C804  38         mov   tmp0,@parm1
     722C 8350 
0140               edkey.action.ins_char:
0141 722E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7230 2306 
0142 7232 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7234 7600 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 7236 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7238 2202 
0147 723A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     723C 2208 
0148 723E 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 7240 8820  54         c     @fb.column,@fb.row.length
     7242 220C 
     7244 2208 
0154 7246 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 7248 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 724A 61E0  34         s     @fb.column,tmp3
     724C 220C 
0162 724E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 7250 C144  18         mov   tmp0,tmp1
0164 7252 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 7254 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7256 220C 
0166 7258 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 725A D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 725C 0604  14         dec   tmp0
0173 725E 0605  14         dec   tmp1
0174 7260 0606  14         dec   tmp2
0175 7262 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 7264 D560  46         movb  @parm1,*tmp1
     7266 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 7268 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     726A 220A 
0184 726C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     726E 2216 
0185 7270 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7272 2208 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 7274 0460  28         b     @edkey.action.char.overwrite
     7276 7350 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 7278 0460  28         b     @ed_wait              ; Back to editor main
     727A 6E50 
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
0206 727C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     727E 2306 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 7280 8820  54         c     @fb.row.dirty,@w$ffff
     7282 220A 
     7284 6048 
0211 7286 1604  14         jne   edkey.action.ins_line.insert
0212 7288 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     728A 77C2 
0213 728C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     728E 220A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 7290 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7292 7600 
0219 7294 C820  54         mov   @fb.topline,@parm1
     7296 2204 
     7298 8350 
0220 729A A820  54         a     @fb.row,@parm1        ; Line number to insert
     729C 2206 
     729E 8350 
0221               
0222 72A0 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72A2 2304 
     72A4 8352 
0223 72A6 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     72A8 7740 
0224 72AA 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     72AC 2304 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 72AE C820  54         mov   @fb.topline,@parm1
     72B0 2204 
     72B2 8350 
0229 72B4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     72B6 761C 
0230 72B8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72BA 2216 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 72BC 0460  28         b     @ed_wait              ; Back to editor main
     72BE 6E50 
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
0249 72C0 8820  54         c     @fb.row.dirty,@w$ffff
     72C2 220A 
     72C4 6048 
0250 72C6 1606  14         jne   edkey.action.enter.upd_counter
0251 72C8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     72CA 2306 
0252 72CC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72CE 77C2 
0253 72D0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72D2 220A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 72D4 C120  34         mov   @fb.topline,tmp0
     72D6 2204 
0259 72D8 A120  34         a     @fb.row,tmp0
     72DA 2206 
0260 72DC 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     72DE 2304 
0261 72E0 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 72E2 05A0  34         inc   @edb.lines            ; Total lines++
     72E4 2304 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 72E6 C120  34         mov   @fb.screenrows,tmp0
     72E8 2218 
0271 72EA 0604  14         dec   tmp0
0272 72EC 8120  34         c     @fb.row,tmp0
     72EE 2206 
0273 72F0 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 72F2 C120  34         mov   @fb.screenrows,tmp0
     72F4 2218 
0278 72F6 C820  54         mov   @fb.topline,@parm1
     72F8 2204 
     72FA 8350 
0279 72FC 05A0  34         inc   @parm1
     72FE 8350 
0280 7300 06A0  32         bl    @fb.refresh
     7302 761C 
0281 7304 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 7306 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     7308 2206 
0287 730A 06A0  32         bl    @down                 ; Row++ VDP cursor
     730C 661A 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 730E 06A0  32         bl    @fb.get.firstnonblank
     7310 7682 
0293 7312 C120  34         mov   @outparm1,tmp0
     7314 8360 
0294 7316 C804  38         mov   tmp0,@fb.column
     7318 220C 
0295 731A 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     731C 662C 
0296 731E 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     7320 793C 
0297 7322 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7324 7600 
0298 7326 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7328 2216 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 732A 0460  28         b     @ed_wait              ; Back to editor main
     732C 6E50 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 732E 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     7330 230A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 7332 0204  20         li    tmp0,2000
     7334 07D0 
0317               edkey.action.ins_onoff.loop:
0318 7336 0604  14         dec   tmp0
0319 7338 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 733A 0460  28         b     @task2.cur_visible    ; Update cursor shape
     733C 7468 
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
0335 733E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     7340 2306 
0336 7342 D805  38         movb  tmp1,@parm1           ; Store character for insert
     7344 8350 
0337 7346 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7348 230A 
0338 734A 1302  14         jeq   edkey.action.char.overwrite
0339                       ;-------------------------------------------------------
0340                       ; Insert mode
0341                       ;-------------------------------------------------------
0342               edkey.action.char.insert:
0343 734C 0460  28         b     @edkey.action.ins_char
     734E 722E 
0344                       ;-------------------------------------------------------
0345                       ; Overwrite mode
0346                       ;-------------------------------------------------------
0347               edkey.action.char.overwrite:
0348 7350 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7352 7600 
0349 7354 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7356 2202 
0350               
0351 7358 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     735A 8350 
0352 735C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     735E 220A 
0353 7360 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7362 2216 
0354               
0355 7364 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7366 220C 
0356 7368 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     736A 832A 
0357                       ;-------------------------------------------------------
0358                       ; Update line length in frame buffer
0359                       ;-------------------------------------------------------
0360 736C 8820  54         c     @fb.column,@fb.row.length
     736E 220C 
     7370 2208 
0361 7372 1103  14         jlt   edkey.action.char.exit  ; column < length line ? Skip further processing
0362 7374 C820  54         mov   @fb.column,@fb.row.length
     7376 220C 
     7378 2208 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 737A 0460  28         b     @ed_wait              ; Back to editor main
     737C 6E50 
**** **** ****     > tivi.asm.14086
0366                       copy  "editorkeys_misc.asm" ; Actions for miscelanneous keys
**** **** ****     > editorkeys_misc.asm
0001               * FILE......: editorkeys_aux.asm
0002               * Purpose...: Actions for miscelanneous keys
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 737E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7380 66DC 
0010 7382 0420  54         blwp  @0                    ; Exit
     7384 0000 
0011               
**** **** ****     > tivi.asm.14086
0367                       copy  "editorkeys_file.asm" ; Actions for file related keys
**** **** ****     > editorkeys_file.asm
0001               * FILE......: editorkeys_fíle.asm
0002               * Purpose...: File related actions (load file, save file, ...)
0003               
0004               
0005               edkey.action.buffer0:
0006 7386 0204  20         li   tmp0,fdname0
     7388 7CE8 
0007 738A 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 738C 0204  20         li   tmp0,fdname1
     738E 7CF6 
0010 7390 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 7392 0204  20         li   tmp0,fdname2
     7394 7D06 
0013 7396 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 7398 0204  20         li   tmp0,fdname3
     739A 7D14 
0016 739C 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 739E 0204  20         li   tmp0,fdname4
     73A0 7D22 
0019 73A2 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 73A4 0204  20         li   tmp0,fdname5
     73A6 7D30 
0022 73A8 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 73AA 0204  20         li   tmp0,fdname6
     73AC 7D3E 
0025 73AE 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 73B0 0204  20         li   tmp0,fdname7
     73B2 7D4C 
0028 73B4 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 73B6 0204  20         li   tmp0,fdname8
     73B8 7D5A 
0031 73BA 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 73BC 0204  20         li   tmp0,fdname9
     73BE 7D68 
0034 73C0 1000  14         jmp  edkey.action.rest
0035               edkey.action.rest:
0036 73C2 06A0  32         bl   @fm.loadfile           ; Load DIS/VAR 80 file into editor buffer
     73C4 7B6A 
0037 73C6 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     73C8 7134 
**** **** ****     > tivi.asm.14086
0368               
0369               
0370               
0371               ***************************************************************
0372               * Task 0 - Copy frame buffer to VDP
0373               ***************************************************************
0374 73CA C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     73CC 2216 
0375 73CE 133D  14         jeq   task0.$$              ; No, skip update
0376                       ;------------------------------------------------------
0377                       ; Determine how many rows to copy
0378                       ;------------------------------------------------------
0379 73D0 8820  54         c     @edb.lines,@fb.screenrows
     73D2 2304 
     73D4 2218 
0380 73D6 1103  14         jlt   task0.setrows.small
0381 73D8 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     73DA 2218 
0382 73DC 1003  14         jmp   task0.copy.framebuffer
0383                       ;------------------------------------------------------
0384                       ; Less lines in editor buffer as rows in frame buffer
0385                       ;------------------------------------------------------
0386               task0.setrows.small:
0387 73DE C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     73E0 2304 
0388 73E2 0585  14         inc   tmp1
0389                       ;------------------------------------------------------
0390                       ; Determine area to copy
0391                       ;------------------------------------------------------
0392               task0.copy.framebuffer:
0393 73E4 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     73E6 220E 
0394                                                   ; 16 bit part is in tmp2!
0395 73E8 04C4  14         clr   tmp0                  ; VDP target address
0396 73EA C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     73EC 2200 
0397                       ;------------------------------------------------------
0398                       ; Copy memory block
0399                       ;------------------------------------------------------
0400 73EE 06A0  32         bl    @xpym2v               ; Copy to VDP
     73F0 642C 
0401                                                   ; tmp0 = VDP target address
0402                                                   ; tmp1 = RAM source address
0403                                                   ; tmp2 = Bytes to copy
0404 73F2 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     73F4 2216 
0405                       ;-------------------------------------------------------
0406                       ; Draw EOF marker at end-of-file
0407                       ;-------------------------------------------------------
0408 73F6 C120  34         mov   @edb.lines,tmp0
     73F8 2304 
0409 73FA 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     73FC 2204 
0410 73FE 0584  14         inc   tmp0                  ; Y++
0411 7400 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7402 2218 
0412 7404 1222  14         jle   task0.$$
0413                       ;-------------------------------------------------------
0414                       ; Draw EOF marker
0415                       ;-------------------------------------------------------
0416               task0.draw_marker:
0417 7406 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7408 832A 
     740A 2214 
0418 740C 0A84  56         sla   tmp0,8                ; X=0
0419 740E C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7410 832A 
0420 7412 06A0  32         bl    @putstr
     7414 640C 
0421 7416 7CA8                   data txt_marker       ; Display *EOF*
0422                       ;-------------------------------------------------------
0423                       ; Draw empty line after (and below) EOF marker
0424                       ;-------------------------------------------------------
0425 7418 06A0  32         bl    @setx
     741A 662A 
0426 741C 0005                   data  5               ; Cursor after *EOF* string
0427               
0428 741E C120  34         mov   @wyx,tmp0
     7420 832A 
0429 7422 0984  56         srl   tmp0,8                ; Right justify
0430 7424 0584  14         inc   tmp0                  ; One time adjust
0431 7426 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7428 2218 
0432 742A 1303  14         jeq   !
0433 742C 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     742E 009B 
0434 7430 1002  14         jmp   task0.draw_marker.line
0435 7432 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     7434 004B 
0436                       ;-------------------------------------------------------
0437                       ; Draw empty line
0438                       ;-------------------------------------------------------
0439               task0.draw_marker.line:
0440 7436 0604  14         dec   tmp0                  ; One time adjust
0441 7438 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     743A 63E8 
0442 743C 0205  20         li    tmp1,32               ; Character to write (whitespace)
     743E 0020 
0443 7440 06A0  32         bl    @xfilv                ; Write characters
     7442 6282 
0444 7444 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     7446 2214 
     7448 832A 
0445               *--------------------------------------------------------------
0446               * Task 0 - Exit
0447               *--------------------------------------------------------------
0448               task0.$$:
0449 744A 0460  28         b     @slotok
     744C 6C6C 
0450               
0451               
0452               
0453               ***************************************************************
0454               * Task 1 - Copy SAT to VDP
0455               ***************************************************************
0456 744E E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     7450 6046 
0457 7452 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     7454 6636 
0458 7456 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     7458 8380 
0459 745A 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0460               
0461               
0462               ***************************************************************
0463               * Task 2 - Update cursor shape (blink)
0464               ***************************************************************
0465 745C 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     745E 2212 
0466 7460 1303  14         jeq   task2.cur_visible
0467 7462 04E0  34         clr   @ramsat+2              ; Hide cursor
     7464 8382 
0468 7466 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0469               
0470               task2.cur_visible:
0471 7468 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     746A 230A 
0472 746C 1303  14         jeq   task2.cur_visible.overwrite_mode
0473                       ;------------------------------------------------------
0474                       ; Cursor in insert mode
0475                       ;------------------------------------------------------
0476               task2.cur_visible.insert_mode:
0477 746E 0204  20         li    tmp0,>000f
     7470 000F 
0478 7472 1002  14         jmp   task2.cur_visible.cursorshape
0479                       ;------------------------------------------------------
0480                       ; Cursor in overwrite mode
0481                       ;------------------------------------------------------
0482               task2.cur_visible.overwrite_mode:
0483 7474 0204  20         li    tmp0,>020f
     7476 020F 
0484                       ;------------------------------------------------------
0485                       ; Set cursor shape
0486                       ;------------------------------------------------------
0487               task2.cur_visible.cursorshape:
0488 7478 C804  38         mov   tmp0,@fb.curshape
     747A 2210 
0489 747C C804  38         mov   tmp0,@ramsat+2
     747E 8382 
0490               
0491               
0492               
0493               
0494               
0495               
0496               
0497               *--------------------------------------------------------------
0498               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0499               *--------------------------------------------------------------
0500               task.sub_copy_ramsat:
0501 7480 06A0  32         bl    @cpym2v
     7482 6426 
0502 7484 2000                   data sprsat,ramsat,4   ; Update sprite
     7486 8380 
     7488 0004 
0503               
0504 748A C820  54         mov   @wyx,@fb.yxsave
     748C 832A 
     748E 2214 
0505                       ;------------------------------------------------------
0506                       ; Show text editing mode
0507                       ;------------------------------------------------------
0508               task.botline.show_mode:
0509 7490 C120  34         mov   @edb.insmode,tmp0
     7492 230A 
0510 7494 1605  14         jne   task.botline.show_mode.insert
0511                       ;------------------------------------------------------
0512                       ; Overwrite mode
0513                       ;------------------------------------------------------
0514               task.botline.show_mode.overwrite:
0515 7496 06A0  32         bl    @putat
     7498 641E 
0516 749A 1D32                   byte  29,50
0517 749C 7CB4                   data  txt_ovrwrite
0518 749E 1004  14         jmp   task.botline.show_changed
0519                       ;------------------------------------------------------
0520                       ; Insert  mode
0521                       ;------------------------------------------------------
0522               task.botline.show_mode.insert:
0523 74A0 06A0  32         bl    @putat
     74A2 641E 
0524 74A4 1D32                   byte  29,50
0525 74A6 7CB8                   data  txt_insert
0526                       ;------------------------------------------------------
0527                       ; Show if text was changed in editor buffer
0528                       ;------------------------------------------------------
0529               task.botline.show_changed:
0530 74A8 C120  34         mov   @edb.dirty,tmp0
     74AA 2306 
0531 74AC 1305  14         jeq   task.botline.show_changed.clear
0532                       ;------------------------------------------------------
0533                       ; Show "*"
0534                       ;------------------------------------------------------
0535 74AE 06A0  32         bl    @putat
     74B0 641E 
0536 74B2 1D36                   byte 29,54
0537 74B4 7CBC                   data txt_star
0538 74B6 1001  14         jmp   task.botline.show_linecol
0539                       ;------------------------------------------------------
0540                       ; Show "line,column"
0541                       ;------------------------------------------------------
0542               task.botline.show_changed.clear:
0543 74B8 1000  14         nop
0544               task.botline.show_linecol:
0545 74BA C820  54         mov   @fb.row,@parm1
     74BC 2206 
     74BE 8350 
0546 74C0 06A0  32         bl    @fb.row2line
     74C2 75EC 
0547 74C4 05A0  34         inc   @outparm1
     74C6 8360 
0548                       ;------------------------------------------------------
0549                       ; Show line
0550                       ;------------------------------------------------------
0551 74C8 06A0  32         bl    @putnum
     74CA 6994 
0552 74CC 1D40                   byte  29,64            ; YX
0553 74CE 8360                   data  outparm1,rambuf
     74D0 8390 
0554 74D2 3020                   byte  48               ; ASCII offset
0555                             byte  32               ; Padding character
0556                       ;------------------------------------------------------
0557                       ; Show comma
0558                       ;------------------------------------------------------
0559 74D4 06A0  32         bl    @putat
     74D6 641E 
0560 74D8 1D45                   byte  29,69
0561 74DA 7CA6                   data  txt_delim
0562                       ;------------------------------------------------------
0563                       ; Show column
0564                       ;------------------------------------------------------
0565 74DC 06A0  32         bl    @film
     74DE 6224 
0566 74E0 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     74E2 0020 
     74E4 000C 
0567               
0568 74E6 C820  54         mov   @fb.column,@waux1
     74E8 220C 
     74EA 833C 
0569 74EC 05A0  34         inc   @waux1                 ; Offset 1
     74EE 833C 
0570               
0571 74F0 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     74F2 6916 
0572 74F4 833C                   data  waux1,rambuf
     74F6 8390 
0573 74F8 3020                   byte  48               ; ASCII offset
0574                             byte  32               ; Fill character
0575               
0576 74FA 06A0  32         bl    @trimnum               ; Trim number to the left
     74FC 696E 
0577 74FE 8390                   data  rambuf,rambuf+6,32
     7500 8396 
     7502 0020 
0578               
0579 7504 0204  20         li    tmp0,>0200
     7506 0200 
0580 7508 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     750A 8396 
0581               
0582 750C 06A0  32         bl    @putat
     750E 641E 
0583 7510 1D46                   byte 29,70
0584 7512 8396                   data rambuf+6          ; Show column
0585                       ;------------------------------------------------------
0586                       ; Show lines in buffer unless on last line in file
0587                       ;------------------------------------------------------
0588 7514 C820  54         mov   @fb.row,@parm1
     7516 2206 
     7518 8350 
0589 751A 06A0  32         bl    @fb.row2line
     751C 75EC 
0590 751E 8820  54         c     @edb.lines,@outparm1
     7520 2304 
     7522 8360 
0591 7524 1605  14         jne   task.botline.show_lines_in_buffer
0592               
0593 7526 06A0  32         bl    @putat
     7528 641E 
0594 752A 1D49                   byte 29,73
0595 752C 7CAE                   data txt_bottom
0596               
0597 752E 100B  14         jmp   task.botline.$$
0598                       ;------------------------------------------------------
0599                       ; Show lines in buffer
0600                       ;------------------------------------------------------
0601               task.botline.show_lines_in_buffer:
0602 7530 C820  54         mov   @edb.lines,@waux1
     7532 2304 
     7534 833C 
0603 7536 05A0  34         inc   @waux1                 ; Offset 1
     7538 833C 
0604 753A 06A0  32         bl    @putnum
     753C 6994 
0605 753E 1D49                   byte 29,73             ; YX
0606 7540 833C                   data waux1,rambuf
     7542 8390 
0607 7544 3020                   byte 48
0608                             byte 32
0609                       ;------------------------------------------------------
0610                       ; Exit
0611                       ;------------------------------------------------------
0612               task.botline.$$
0613 7546 C820  54         mov   @fb.yxsave,@wyx
     7548 2214 
     754A 832A 
0614 754C 0460  28         b     @slotok                ; Exit running task
     754E 6C6C 
0615               
0616               
0617               
0618               ***************************************************************
0619               *              mem - Memory Management module
0620               ***************************************************************
0621                       copy  "memory.asm"
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
0021 7550 0649  14         dect  stack
0022 7552 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 7554 06A0  32         bl    @sams.layout
     7556 6570 
0027 7558 755E                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 755A C2F9  30         mov   *stack+,r11           ; Pop r11
0033 755C 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 755E 2000             data  >2000,>0000           ; >2000-2fff, SAMS page >00
     7560 0000 
0039 7562 3000             data  >3000,>0001           ; >3000-3fff, SAMS page >01
     7564 0001 
0040 7566 A000             data  >a000,>0002           ; >a000-afff, SAMS page >02
     7568 0002 
0041 756A B000             data  >b000,>0003           ; >b000-bfff, SAMS page >03
     756C 0003 
0042 756E C000             data  >c000,>0004           ; >c000-cfff, SAMS page >04
     7570 0004 
0043 7572 D000             data  >d000,>0005           ; >d000-dfff, SAMS page >05
     7574 0005 
0044 7576 E000             data  >e000,>0006           ; >e000-efff, SAMS page >06
     7578 0006 
0045 757A F000             data  >f000,>0007           ; >f000-ffff, SAMS page >07
     757C 0007 
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
0070 757E C13B  30         mov   *r11+,tmp0            ; Get p0
0071               xmem.edb.sams.pagein:
0072 7580 0649  14         dect  stack
0073 7582 C64B  30         mov   r11,*stack            ; Save return address
0074 7584 0649  14         dect  stack
0075 7586 C644  30         mov   tmp0,*stack           ; Save tmp0
0076 7588 0649  14         dect  stack
0077 758A C645  30         mov   tmp1,*stack           ; Save tmp1
0078                       ;------------------------------------------------------
0079                       ; Sanity check
0080                       ;------------------------------------------------------
0081 758C 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     758E 2304 
0082 7590 1104  14         jlt   mem.edb.sams.pagein.lookup
0083                                                   ; All checks passed, continue
0084                                                   ;--------------------------
0085                                                   ; Sanity check failed
0086                                                   ;--------------------------
0087 7592 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7594 FFCE 
0088 7596 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7598 604C 
0089                       ;------------------------------------------------------
0090                       ; Lookup SAMS page for line in parm1
0091                       ;------------------------------------------------------
0092               mem.edb.sams.pagein.lookup:
0093 759A 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     759C 7784 
0094                                                   ; \ i  parm1    = Line number
0095                                                   ; | o  outparm1 = Pointer to line
0096                                                   ; / o  outparm2 = SAMS page
0097               
0098 759E C120  34         mov   @outparm2,tmp0        ; SAMS page
     75A0 8362 
0099 75A2 C160  34         mov   @outparm1,tmp1        ; Memory address
     75A4 8360 
0100                       ;------------------------------------------------------
0101                       ; Activate SAMS page where specified line is stored
0102                       ;------------------------------------------------------
0103 75A6 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     75A8 650A 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               mem.edb.sams.pagein.exit
0110 75AA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 75AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 75AE C2F9  30         mov   *stack+,r11           ; Pop r11
0113 75B0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi.asm.14086
0622               
0623               ***************************************************************
0624               *                 fb - Framebuffer module
0625               ***************************************************************
0626                       copy  "framebuffer.asm"
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
0024 75B2 0649  14         dect  stack
0025 75B4 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 75B6 0204  20         li    tmp0,fb.top
     75B8 2650 
0030 75BA C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     75BC 2200 
0031 75BE 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     75C0 2204 
0032 75C2 04E0  34         clr   @fb.row               ; Current row=0
     75C4 2206 
0033 75C6 04E0  34         clr   @fb.column            ; Current column=0
     75C8 220C 
0034 75CA 0204  20         li    tmp0,80
     75CC 0050 
0035 75CE C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     75D0 220E 
0036 75D2 0204  20         li    tmp0,29
     75D4 001D 
0037 75D6 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     75D8 2218 
0038 75DA 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     75DC 2216 
0039                       ;------------------------------------------------------
0040                       ; Clear frame buffer
0041                       ;------------------------------------------------------
0042 75DE 06A0  32         bl    @film
     75E0 6224 
0043 75E2 2650             data  fb.top,>00,fb.size    ; Clear it all the way
     75E4 0000 
     75E6 09B0 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               fb.init.$$
0048 75E8 0460  28         b     @poprt                ; Return to caller
     75EA 6220 
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
0073 75EC 0649  14         dect  stack
0074 75EE C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Calculate line in editor buffer
0077                       ;------------------------------------------------------
0078 75F0 C120  34         mov   @parm1,tmp0
     75F2 8350 
0079 75F4 A120  34         a     @fb.topline,tmp0
     75F6 2204 
0080 75F8 C804  38         mov   tmp0,@outparm1
     75FA 8360 
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               fb.row2line$$:
0085 75FC 0460  28         b    @poprt                 ; Return to caller
     75FE 6220 
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
0113 7600 0649  14         dect  stack
0114 7602 C64B  30         mov   r11,*stack            ; Save return address
0115                       ;------------------------------------------------------
0116                       ; Calculate pointer
0117                       ;------------------------------------------------------
0118 7604 C1A0  34         mov   @fb.row,tmp2
     7606 2206 
0119 7608 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     760A 220E 
0120 760C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     760E 220C 
0121 7610 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7612 2200 
0122 7614 C807  38         mov   tmp3,@fb.current
     7616 2202 
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               fb.calc_pointer.$$
0127 7618 0460  28         b    @poprt                 ; Return to caller
     761A 6220 
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
0148 761C 0649  14         dect  stack
0149 761E C64B  30         mov   r11,*stack            ; Push return address
0150 7620 0649  14         dect  stack
0151 7622 C644  30         mov   tmp0,*stack           ; Push tmp0
0152 7624 0649  14         dect  stack
0153 7626 C645  30         mov   tmp1,*stack           ; Push tmp1
0154 7628 0649  14         dect  stack
0155 762A C646  30         mov   tmp2,*stack           ; Push tmp2
0156                       ;------------------------------------------------------
0157                       ; Setup starting position in index
0158                       ;------------------------------------------------------
0159 762C C820  54         mov   @parm1,@fb.topline
     762E 8350 
     7630 2204 
0160 7632 04E0  34         clr   @parm2                ; Target row in frame buffer
     7634 8352 
0161                       ;------------------------------------------------------
0162                       ; Unpack line to frame buffer
0163                       ;------------------------------------------------------
0164               fb.refresh.unpack_line:
0165 7636 06A0  32         bl    @edb.line.unpack      ; Unpack line
     7638 7852 
0166                                                   ; \ i  parm1 = Line to unpack
0167                                                   ; / i  parm2 = Target row in frame buffer
0168               
0169 763A 05A0  34         inc   @parm1                ; Next line in editor buffer
     763C 8350 
0170 763E 05A0  34         inc   @parm2                ; Next row in frame buffer
     7640 8352 
0171                       ;------------------------------------------------------
0172                       ; Last row in editor buffer reached ?
0173                       ;------------------------------------------------------
0174 7642 8820  54         c     @parm1,@edb.lines
     7644 8350 
     7646 2304 
0175 7648 1111  14         jlt   !                     ; no, do next check
0176               
0177                       ;------------------------------------------------------
0178                       ; Erase until end of frame buffer
0179                       ;------------------------------------------------------
0180 764A C120  34         mov   @parm2,tmp0           ; Current row
     764C 8352 
0181 764E C160  34         mov   @fb.screenrows,tmp1   ; Rows framebuffer
     7650 2218 
0182 7652 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0183 7654 3960  72         mpy   @fb.colsline,tmp1     ; columns per row * tmp1 (Result in tmp2!)
     7656 220E 
0184               
0185 7658 3920  72         mpy   @fb.colsline,tmp0     ; Offset = columns per row * tmp0 (Result in tmp1!)
     765A 220E 
0186 765C A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     765E 2200 
0187               
0188 7660 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0189 7662 0205  20         li    tmp1,32               ; Clear with space
     7664 0020 
0190               
0191 7666 06A0  32         bl    @xfilm                ; \ Fill memory
     7668 622A 
0192                                                   ; | i  tmp0 = Memory start address
0193                                                   ; | i  tmp1 = Byte to fill
0194                                                   ; / i  tmp2 = Number of bytes to fill
0195 766A 1004  14         jmp   fb.refresh.exit
0196                       ;------------------------------------------------------
0197                       ; Bottom row in frame buffer reached ?
0198                       ;------------------------------------------------------
0199 766C 8820  54 !       c     @parm2,@fb.screenrows
     766E 8352 
     7670 2218 
0200 7672 11E1  14         jlt   fb.refresh.unpack_line
0201                                                   ; No, unpack next line
0202                       ;------------------------------------------------------
0203                       ; Exit
0204                       ;------------------------------------------------------
0205               fb.refresh.exit:
0206 7674 0720  34         seto  @fb.dirty             ; Refresh screen
     7676 2216 
0207 7678 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0208 767A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0209 767C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0210 767E C2F9  30         mov   *stack+,r11           ; Pop r11
0211 7680 045B  20         b     *r11                  ; Return to caller
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
0225 7682 0649  14         dect  stack
0226 7684 C64B  30         mov   r11,*stack            ; Save return address
0227                       ;------------------------------------------------------
0228                       ; Prepare for scanning
0229                       ;------------------------------------------------------
0230 7686 04E0  34         clr   @fb.column
     7688 220C 
0231 768A 06A0  32         bl    @fb.calc_pointer
     768C 7600 
0232 768E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7690 793C 
0233 7692 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7694 2208 
0234 7696 1313  14         jeq   fb.get.firstnonblank.nomatch
0235                                                   ; Exit if empty line
0236 7698 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     769A 2202 
0237 769C 04C5  14         clr   tmp1
0238                       ;------------------------------------------------------
0239                       ; Scan line for non-blank character
0240                       ;------------------------------------------------------
0241               fb.get.firstnonblank.loop:
0242 769E D174  28         movb  *tmp0+,tmp1           ; Get character
0243 76A0 130E  14         jeq   fb.get.firstnonblank.nomatch
0244                                                   ; Exit if empty line
0245 76A2 0285  22         ci    tmp1,>2000            ; Whitespace?
     76A4 2000 
0246 76A6 1503  14         jgt   fb.get.firstnonblank.match
0247 76A8 0606  14         dec   tmp2                  ; Counter--
0248 76AA 16F9  14         jne   fb.get.firstnonblank.loop
0249 76AC 1008  14         jmp   fb.get.firstnonblank.nomatch
0250                       ;------------------------------------------------------
0251                       ; Non-blank character found
0252                       ;------------------------------------------------------
0253               fb.get.firstnonblank.match:
0254 76AE 6120  34         s     @fb.current,tmp0      ; Calculate column
     76B0 2202 
0255 76B2 0604  14         dec   tmp0
0256 76B4 C804  38         mov   tmp0,@outparm1        ; Save column
     76B6 8360 
0257 76B8 D805  38         movb  tmp1,@outparm2        ; Save character
     76BA 8362 
0258 76BC 1004  14         jmp   fb.get.firstnonblank.exit
0259                       ;------------------------------------------------------
0260                       ; No non-blank character found
0261                       ;------------------------------------------------------
0262               fb.get.firstnonblank.nomatch:
0263 76BE 04E0  34         clr   @outparm1             ; X=0
     76C0 8360 
0264 76C2 04E0  34         clr   @outparm2             ; Null
     76C4 8362 
0265                       ;------------------------------------------------------
0266                       ; Exit
0267                       ;------------------------------------------------------
0268               fb.get.firstnonblank.exit:
0269 76C6 0460  28         b    @poprt                 ; Return to caller
     76C8 6220 
**** **** ****     > tivi.asm.14086
0627               
0628               ***************************************************************
0629               *              idx - Index management module
0630               ***************************************************************
0631                       copy  "index.asm"
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
0048 76CA 0649  14         dect  stack
0049 76CC C64B  30         mov   r11,*stack            ; Save return address
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 76CE 0204  20         li    tmp0,idx.top
     76D0 3000 
0054 76D2 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     76D4 2302 
0055                       ;------------------------------------------------------
0056                       ; Clear index
0057                       ;------------------------------------------------------
0058 76D6 06A0  32         bl    @film
     76D8 6224 
0059 76DA 3000             data  idx.top,>00,idx.size  ; Clear main index
     76DC 0000 
     76DE 1000 
0060               
0061 76E0 06A0  32         bl    @film
     76E2 6224 
0062 76E4 A000             data  idx.shadow.top,>00,idx.shadow.size
     76E6 0000 
     76E8 1000 
0063                                                   ; Clear shadow index
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               idx.init.exit:
0068 76EA 0460  28         b     @poprt                ; Return to caller
     76EC 6220 
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
0090 76EE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76F0 8350 
0091                       ;------------------------------------------------------
0092                       ; Calculate offset
0093                       ;------------------------------------------------------
0094 76F2 C160  34         mov   @parm2,tmp1
     76F4 8352 
0095 76F6 1302  14         jeq   idx.entry.update.save ; Special handling for empty line
0096               
0097                       ;------------------------------------------------------
0098                       ; SAMS bank
0099                       ;------------------------------------------------------
0100 76F8 C1A0  34         mov   @parm3,tmp2           ; Get SAMS page
     76FA 8354 
0101               
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 76FC 0A14  56         sla   tmp0,1                ; line number * 2
0107 76FE C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
     7700 3000 
0108 7702 C906  38         mov   tmp2,@idx.shadow.top(tmp0)
     7704 A000 
0109                                                   ; Update SAMS page
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.update.exit:
0114 7706 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     7708 8360 
0115 770A 045B  20         b     *r11                  ; Return
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
0135 770C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     770E 8350 
0136                       ;------------------------------------------------------
0137                       ; Calculate address of index entry and save pointer
0138                       ;------------------------------------------------------
0139 7710 0A14  56         sla   tmp0,1                ; line number * 2
0140 7712 C824  54         mov   @idx.top(tmp0),@outparm1
     7714 3000 
     7716 8360 
0141                                                   ; Pointer to deleted line
0142                       ;------------------------------------------------------
0143                       ; Prepare for index reorg
0144                       ;------------------------------------------------------
0145 7718 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     771A 8352 
0146 771C 61A0  34         s     @parm1,tmp2           ; Calculate loop
     771E 8350 
0147 7720 1601  14         jne   idx.entry.delete.reorg
0148                       ;------------------------------------------------------
0149                       ; Special treatment if last line
0150                       ;------------------------------------------------------
0151 7722 1009  14         jmp   idx.entry.delete.lastline
0152                       ;------------------------------------------------------
0153                       ; Reorganize index entries
0154                       ;------------------------------------------------------
0155               idx.entry.delete.reorg:
0156 7724 C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     7726 3002 
     7728 3000 
0157 772A C924  54         mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
     772C A002 
     772E A000 
0158 7730 05C4  14         inct  tmp0                  ; Next index entry
0159 7732 0606  14         dec   tmp2                  ; tmp2--
0160 7734 16F7  14         jne   idx.entry.delete.reorg
0161                                                   ; Loop unless completed
0162                       ;------------------------------------------------------
0163                       ; Last line
0164                       ;------------------------------------------------------
0165               idx.entry.delete.lastline
0166 7736 04E4  34         clr   @idx.top(tmp0)
     7738 3000 
0167 773A 04E4  34         clr   @idx.shadow.top(tmp0)
     773C A000 
0168                       ;------------------------------------------------------
0169                       ; Exit
0170                       ;------------------------------------------------------
0171               idx.entry.delete.exit:
0172 773E 045B  20         b     *r11                  ; Return
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
0192 7740 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     7742 8352 
0193                       ;------------------------------------------------------
0194                       ; Calculate address of index entry and save pointer
0195                       ;------------------------------------------------------
0196 7744 0A14  56         sla   tmp0,1                ; line number * 2
0197                       ;------------------------------------------------------
0198                       ; Prepare for index reorg
0199                       ;------------------------------------------------------
0200 7746 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7748 8352 
0201 774A 61A0  34         s     @parm1,tmp2           ; Calculate loop
     774C 8350 
0202 774E 160B  14         jne   idx.entry.insert.reorg
0203                       ;------------------------------------------------------
0204                       ; Special treatment if last line
0205                       ;------------------------------------------------------
0206 7750 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     7752 3000 
     7754 3002 
0207                                                   ; Move pointer
0208 7756 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     7758 3000 
0209               
0210 775A C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     775C A000 
     775E A002 
0211                                                   ; Move SAMS page
0212 7760 04E4  34         clr   @idx.shadow.top+0(tmp0)
     7762 A000 
0213                                                   ; Clear new index entry
0214 7764 100E  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 7766 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 7768 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     776A 3000 
     776C 3002 
0222                                                   ; Move pointer
0223               
0224 776E C924  54         mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
     7770 A000 
     7772 A002 
0225                                                   ; Move SAMS page
0226               
0227 7774 0644  14         dect  tmp0                  ; Previous index entry
0228 7776 0606  14         dec   tmp2                  ; tmp2--
0229 7778 16F7  14         jne   -!                    ; Loop unless completed
0230               
0231 777A 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     777C 3004 
0232 777E 04E4  34         clr   @idx.shadow.top+4(tmp0)
     7780 A004 
0233                                                   ; Clear new index entry
0234                       ;------------------------------------------------------
0235                       ; Exit
0236                       ;------------------------------------------------------
0237               idx.entry.insert.exit:
0238 7782 045B  20         b     *r11                  ; Return
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
0259 7784 0649  14         dect  stack
0260 7786 C64B  30         mov   r11,*stack            ; Save return address
0261                       ;------------------------------------------------------
0262                       ; Get pointer
0263                       ;------------------------------------------------------
0264 7788 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     778A 8350 
0265                       ;------------------------------------------------------
0266                       ; Calculate index entry
0267                       ;------------------------------------------------------
0268 778C 0A14  56         sla   tmp0,1                ; line number * 2
0269 778E C164  34         mov   @idx.top(tmp0),tmp1   ; Get pointer
     7790 3000 
0270 7792 C1A4  34         mov   @idx.shadow.top(tmp0),tmp2
     7794 A000 
0271                                                   ; Get SAMS page
0272                       ;------------------------------------------------------
0273                       ; Return parameter
0274                       ;------------------------------------------------------
0275               idx.pointer.get.parm:
0276 7796 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     7798 8360 
0277 779A C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     779C 8362 
0278                       ;------------------------------------------------------
0279                       ; Exit
0280                       ;------------------------------------------------------
0281               idx.pointer.get.exit:
0282 779E 0460  28         b     @poprt                ; Return to caller
     77A0 6220 
**** **** ****     > tivi.asm.14086
0632               
0633               ***************************************************************
0634               *               edb - Editor Buffer module
0635               ***************************************************************
0636                       copy  "editorbuffer.asm"
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
0026 77A2 0649  14         dect  stack
0027 77A4 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 77A6 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     77A8 B002 
0032                                                   ; with null pointer (has offset 0)
0033               
0034 77AA C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     77AC 2300 
0035 77AE C804  38         mov   tmp0,@edb.next_free.ptr
     77B0 2308 
0036                                                   ; Set pointer to next free line in editor buffer
0037               
0038 77B2 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     77B4 230A 
0039 77B6 04E0  34         clr   @edb.lines            ; Lines=0
     77B8 2304 
0040 77BA 04E0  34         clr   @edb.rle              ; RLE compression off
     77BC 230C 
0041               
0042               
0043               edb.init.exit:
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047 77BE 0460  28         b     @poprt                ; Return to caller
     77C0 6220 
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
0074 77C2 0649  14         dect  stack
0075 77C4 C64B  30         mov   r11,*stack            ; Save return address
0076                       ;------------------------------------------------------
0077                       ; Get values
0078                       ;------------------------------------------------------
0079 77C6 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     77C8 220C 
     77CA 8390 
0080 77CC 04E0  34         clr   @fb.column
     77CE 220C 
0081 77D0 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     77D2 7600 
0082                       ;------------------------------------------------------
0083                       ; Prepare scan
0084                       ;------------------------------------------------------
0085 77D4 04C4  14         clr   tmp0                  ; Counter
0086 77D6 C160  34         mov   @fb.current,tmp1      ; Get position
     77D8 2202 
0087 77DA C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     77DC 8392 
0088               
0089                       ;------------------------------------------------------
0090                       ; Scan line for >00 byte termination
0091                       ;------------------------------------------------------
0092               edb.line.pack.scan:
0093 77DE D1B5  28         movb  *tmp1+,tmp2           ; Get char
0094 77E0 0986  56         srl   tmp2,8                ; Right justify
0095 77E2 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0096 77E4 0584  14         inc   tmp0                  ; Increase string length
0097 77E6 10FB  14         jmp   edb.line.pack.scan    ; Next character
0098               
0099                       ;------------------------------------------------------
0100                       ; Prepare for storing line
0101                       ;------------------------------------------------------
0102               edb.line.pack.prepare:
0103 77E8 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     77EA 2204 
     77EC 8350 
0104 77EE A820  54         a     @fb.row,@parm1        ; /
     77F0 2206 
     77F2 8350 
0105               
0106 77F4 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     77F6 8394 
0107               
0108                       ;------------------------------------------------------
0109                       ; 1. Update index
0110                       ;------------------------------------------------------
0111               edb.line.pack.update_index:
0112 77F8 C120  34         mov   @edb.next_free.ptr,tmp0
     77FA 2308 
0113 77FC C804  38         mov   tmp0,@parm2           ; Block where line will reside
     77FE 8352 
0114               
0115 7800 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     7802 64D2 
0116                                                   ; \ i  tmp0  = Memory address
0117                                                   ; | o  waux1 = SAMS page number
0118                                                   ; / o  waux2 = Address of SAMS register
0119               
0120 7804 C820  54         mov   @waux1,@parm3         ; Save SAMS page number
     7806 833C 
     7808 8354 
0121               
0122 780A 06A0  32         bl    @idx.entry.update     ; Update index
     780C 76EE 
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
0140 780E C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     7810 8392 
0141 7812 C160  34         mov   @edb.next_free.ptr,tmp1
     7814 2308 
0142                                                   ; Address of line in editor buffer
0143               
0144 7816 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     7818 2308 
0145               
0146 781A C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     781C 8394 
0147 781E 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0148 7820 06C6  14         swpb  tmp2
0149 7822 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0150 7824 06C6  14         swpb  tmp2
0151 7826 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0152               
0153                       ;------------------------------------------------------
0154                       ; 4. Copy line from framebuffer to editor buffer
0155                       ;------------------------------------------------------
0156               edb.line.pack.copyline:
0157 7828 0286  22         ci    tmp2,2
     782A 0002 
0158 782C 1603  14         jne   edb.line.pack.copyline.checkbyte
0159 782E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0160 7830 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0161 7832 1007  14         jmp   !
0162               edb.line.pack.copyline.checkbyte:
0163 7834 0286  22         ci    tmp2,1
     7836 0001 
0164 7838 1602  14         jne   edb.line.pack.copyline.block
0165 783A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0166 783C 1002  14         jmp   !
0167               edb.line.pack.copyline.block:
0168 783E 06A0  32         bl    @xpym2m               ; Copy memory block
     7840 6474 
0169                                                   ; \ i  tmp0 = source
0170                                                   ; | i  tmp1 = destination
0171                                                   ; / i  tmp2 = bytes to copy
0172               
0173 7842 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     7844 8394 
     7846 2308 
0174                                                   ; Update pointer to next free line
0175               
0176                       ;------------------------------------------------------
0177                       ; Exit
0178                       ;------------------------------------------------------
0179               edb.line.pack.exit:
0180 7848 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     784A 8390 
     784C 220C 
0181 784E 0460  28         b     @poprt                ; Return to caller
     7850 6220 
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
0193               * @parm1 = Line to unpack in editor buffer
0194               * @parm2 = Target row in frame buffer
0195               *--------------------------------------------------------------
0196               * OUTPUT
0197               * none
0198               *--------------------------------------------------------------
0199               * Register usage
0200               * tmp0,tmp1,tmp2,tmp3,tmp4
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
0211 7852 0649  14         dect  stack
0212 7854 C64B  30         mov   r11,*stack            ; Save return address
0213                       ;------------------------------------------------------
0214                       ; Sanity check
0215                       ;------------------------------------------------------
0216 7856 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     7858 8350 
     785A 2304 
0217 785C 1104  14         jlt   !
0218 785E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7860 FFCE 
0219 7862 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7864 604C 
0220                       ;------------------------------------------------------
0221                       ; Save parameters
0222                       ;------------------------------------------------------
0223 7866 C820  54 !       mov   @parm1,@rambuf
     7868 8350 
     786A 8390 
0224 786C C820  54         mov   @parm2,@rambuf+2
     786E 8352 
     7870 8392 
0225                       ;------------------------------------------------------
0226                       ; Calculate offset in frame buffer
0227                       ;------------------------------------------------------
0228 7872 C120  34         mov   @fb.colsline,tmp0
     7874 220E 
0229 7876 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7878 8352 
0230 787A C1A0  34         mov   @fb.top.ptr,tmp2
     787C 2200 
0231 787E A146  18         a     tmp2,tmp1             ; Add base to offset
0232 7880 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7882 8396 
0233                       ;------------------------------------------------------
0234                       ; Get pointer to line & page-in editor buffer page
0235                       ;------------------------------------------------------
0236 7884 C120  34         mov   @parm1,tmp0
     7886 8350 
0237 7888 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     788A 7580 
0238                                                   ; \ i  tmp0     = Line number
0239                                                   ; | o  outparm1 = Pointer to line
0240                                                   ; / o  outparm2 = SAMS page
0241               
0242 788C 05E0  34         inct  @outparm1             ; Skip line prefix
     788E 8360 
0243 7890 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     7892 8360 
     7894 8394 
0244                       ;------------------------------------------------------
0245                       ; Get length of line to unpack
0246                       ;------------------------------------------------------
0247 7896 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7898 7904 
0248                                                   ; \ i  parm1    = Line number
0249                                                   ; | o  outparm1 = Line length (uncompressed)
0250                                                   ; | o  outparm2 = Line length (compressed)
0251                                                   ; / o  outparm3 = SAMS page
0252               
0253 789A C820  54         mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
     789C 8362 
     789E 839A 
0254 78A0 C820  54         mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
     78A2 8360 
     78A4 8398 
0255 78A6 1310  14         jeq   edb.line.unpack.clear ; Skip "split line" check if empty line anyway
0256                       ;------------------------------------------------------
0257                       ; Handle possible "line split" between 2 consecutive pages
0258                       ;------------------------------------------------------
0259 78A8 C120  34         mov     @rambuf+4,tmp0      ; Pointer to line
     78AA 8394 
0260 78AC C144  18         mov     tmp0,tmp1           ; Pointer to line
0261 78AE A160  34         a       @rambuf+8,tmp1      ; Add length of line
     78B0 8398 
0262               
0263 78B2 0244  22         andi    tmp0,>f000          ; Only keep high nibble
     78B4 F000 
0264 78B6 0245  22         andi    tmp1,>f000          ; Only keep high nibble
     78B8 F000 
0265 78BA 8144  18         c       tmp0,tmp1           ; Same segment?
0266 78BC 1305  14         jeq     edb.line.unpack.clear
0267                                                   ; Yes, so skip
0268               
0269 78BE C120  34         mov     @outparm3,tmp0      ; Get SAMS page
     78C0 8364 
0270 78C2 0584  14         inc     tmp0                ; Next sams page
0271               
0272 78C4 06A0  32         bl      @xsams.page.set     ; \ Set SAMS memory page
     78C6 650A 
0273                                                   ; | i  tmp0 = SAMS page number
0274                                                   ; / i  tmp1 = Memory Address
0275               
0276                       ;------------------------------------------------------
0277                       ; Erase chars from last column until column 80
0278                       ;------------------------------------------------------
0279               edb.line.unpack.clear:
0280 78C8 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     78CA 8396 
0281 78CC A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     78CE 8398 
0282               
0283 78D0 04C5  14         clr   tmp1                  ; Fill with >00
0284 78D2 C1A0  34         mov   @fb.colsline,tmp2
     78D4 220E 
0285 78D6 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     78D8 8398 
0286 78DA 0586  14         inc   tmp2
0287               
0288 78DC 06A0  32         bl    @xfilm                ; Fill CPU memory
     78DE 622A 
0289                                                   ; \ i  tmp0 = Target address
0290                                                   ; | i  tmp1 = Byte to fill
0291                                                   ; / i  tmp2 = Repeat count
0292                       ;------------------------------------------------------
0293                       ; Prepare for unpacking data
0294                       ;------------------------------------------------------
0295               edb.line.unpack.prepare:
0296 78E0 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     78E2 8398 
0297 78E4 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0298 78E6 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     78E8 8394 
0299 78EA C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     78EC 8396 
0300                       ;------------------------------------------------------
0301                       ; Check before copy
0302                       ;------------------------------------------------------
0303               edb.line.unpack.copy.uncompressed:
0304 78EE 0286  22         ci    tmp2,80               ; Check line length;
     78F0 0050 
0305 78F2 1204  14         jle   !
0306 78F4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     78F6 FFCE 
0307 78F8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     78FA 604C 
0308                       ;------------------------------------------------------
0309                       ; Copy memory block
0310                       ;------------------------------------------------------
0311 78FC 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     78FE 6474 
0312                                                   ; \ i  tmp0 = Source address
0313                                                   ; | i  tmp1 = Target address
0314                                                   ; / i  tmp2 = Bytes to copy
0315                       ;------------------------------------------------------
0316                       ; Exit
0317                       ;------------------------------------------------------
0318               edb.line.unpack.exit:
0319 7900 0460  28         b     @poprt                ; Return to caller
     7902 6220 
0320               
0321               
0322               
0323               
0324               ***************************************************************
0325               * edb.line.getlength
0326               * Get length of specified line
0327               ***************************************************************
0328               *  bl   @edb.line.getlength
0329               *--------------------------------------------------------------
0330               * INPUT
0331               * @parm1 = Line number
0332               *--------------------------------------------------------------
0333               * OUTPUT
0334               * @outparm1 = Length of line (uncompressed)
0335               * @outparm2 = Length of line (compressed)
0336               * @outparm3 = SAMS page
0337               *--------------------------------------------------------------
0338               * Register usage
0339               * tmp0,tmp1,tmp2
0340               ********|*****|*********************|**************************
0341               edb.line.getlength:
0342 7904 0649  14         dect  stack
0343 7906 C64B  30         mov   r11,*stack            ; Save return address
0344                       ;------------------------------------------------------
0345                       ; Initialisation
0346                       ;------------------------------------------------------
0347 7908 04E0  34         clr   @outparm1             ; Reset uncompressed length
     790A 8360 
0348 790C 04E0  34         clr   @outparm2             ; Reset compressed length
     790E 8362 
0349 7910 04E0  34         clr   @outparm3             ; Reset SAMS bank
     7912 8364 
0350                       ;------------------------------------------------------
0351                       ; Get length
0352                       ;------------------------------------------------------
0353 7914 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     7916 7784 
0354                                                   ; \ i  parm1    = Line number
0355                                                   ; | o  outparm1 = Pointer to line
0356                                                   ; / o  outparm2 = SAMS page
0357               
0358 7918 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     791A 8360 
0359 791C 130D  14         jeq   edb.line.getlength.exit
0360                                                   ; Exit early if NULL pointer
0361 791E C820  54         mov   @outparm2,@outparm3   ; Save SAMS page
     7920 8362 
     7922 8364 
0362                       ;------------------------------------------------------
0363                       ; Process line prefix
0364                       ;------------------------------------------------------
0365 7924 04C5  14         clr   tmp1
0366 7926 D174  28         movb  *tmp0+,tmp1           ; Get compressed length
0367 7928 06C5  14         swpb  tmp1
0368 792A C805  38         mov   tmp1,@outparm2        ; Save length
     792C 8362 
0369               
0370 792E 04C5  14         clr   tmp1
0371 7930 D174  28         movb  *tmp0+,tmp1           ; Get uncompressed length
0372 7932 06C5  14         swpb  tmp1
0373 7934 C805  38         mov   tmp1,@outparm1        ; Save length
     7936 8360 
0374                       ;------------------------------------------------------
0375                       ; Exit
0376                       ;------------------------------------------------------
0377               edb.line.getlength.exit:
0378 7938 0460  28         b     @poprt                ; Return to caller
     793A 6220 
0379               
0380               
0381               
0382               
0383               ***************************************************************
0384               * edb.line.getlength2
0385               * Get length of current row (as seen from editor buffer side)
0386               ***************************************************************
0387               *  bl   @edb.line.getlength2
0388               *--------------------------------------------------------------
0389               * INPUT
0390               * @fb.row = Row in frame buffer
0391               *--------------------------------------------------------------
0392               * OUTPUT
0393               * @fb.row.length = Length of row
0394               *--------------------------------------------------------------
0395               * Register usage
0396               * tmp0
0397               ********|*****|*********************|**************************
0398               edb.line.getlength2:
0399 793C 0649  14         dect  stack
0400 793E C64B  30         mov   r11,*stack            ; Save return address
0401                       ;------------------------------------------------------
0402                       ; Calculate line in editor buffer
0403                       ;------------------------------------------------------
0404 7940 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7942 2204 
0405 7944 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7946 2206 
0406                       ;------------------------------------------------------
0407                       ; Get length
0408                       ;------------------------------------------------------
0409 7948 C804  38         mov   tmp0,@parm1
     794A 8350 
0410 794C 06A0  32         bl    @edb.line.getlength
     794E 7904 
0411 7950 C820  54         mov   @outparm1,@fb.row.length
     7952 8360 
     7954 2208 
0412                                                   ; Save row length
0413                       ;------------------------------------------------------
0414                       ; Exit
0415                       ;------------------------------------------------------
0416               edb.line.getlength2.exit:
0417 7956 0460  28         b     @poprt                ; Return to caller
     7958 6220 
0418               
**** **** ****     > tivi.asm.14086
0637               
0638               ***************************************************************
0639               *               fh - File handling modules
0640               ***************************************************************
0641                       copy  "filereader_sams.asm"
**** **** ****     > filereader_sams.asm
0001               * FILE......: filereader_sams.asm
0002               * Purpose...: File read module with SAMS support
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
0031 795A 0649  14         dect  stack
0032 795C C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 795E 04E0  34         clr   @tfh.rleonload        ; No RLE compression!
     7960 2444 
0037 7962 04E0  34         clr   @tfh.records          ; Reset records counter
     7964 242E 
0038 7966 04E0  34         clr   @tfh.counter          ; Clear internal counter
     7968 2434 
0039 796A 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     796C 2432 
0040 796E 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 7970 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     7972 242A 
0042 7974 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     7976 242C 
0043               
0044 7978 0204  20         li    tmp0,3
     797A 0003 
0045 797C C804  38         mov   tmp0,@tfh.sams.page   ; Set current SAMS page
     797E 2438 
0046 7980 C804  38         mov   tmp0,@tfh.sams.hpage  ; Set highest SAMS page in use
     7982 243A 
0047                       ;------------------------------------------------------
0048                       ; Save parameters / callback functions
0049                       ;------------------------------------------------------
0050 7984 C820  54         mov   @parm1,@tfh.fname.ptr ; Pointer to file descriptor
     7986 8350 
     7988 2436 
0051 798A C820  54         mov   @parm2,@tfh.callback1 ; Loading indicator 1
     798C 8352 
     798E 243C 
0052 7990 C820  54         mov   @parm3,@tfh.callback2 ; Loading indicator 2
     7992 8354 
     7994 243E 
0053 7996 C820  54         mov   @parm4,@tfh.callback3 ; Loading indicator 3
     7998 8356 
     799A 2440 
0054 799C C820  54         mov   @parm5,@tfh.callback4 ; File I/O error handler
     799E 8358 
     79A0 2442 
0055                       ;------------------------------------------------------
0056                       ; Sanity check
0057                       ;------------------------------------------------------
0058 79A2 C120  34         mov   @tfh.callback1,tmp0
     79A4 243C 
0059 79A6 0284  22         ci    tmp0,>6000            ; Insane address ?
     79A8 6000 
0060 79AA 1114  14         jlt   !                     ; Yes, crash!
0061               
0062 79AC 0284  22         ci    tmp0,>7fff            ; Insane address ?
     79AE 7FFF 
0063 79B0 1511  14         jgt   !                     ; Yes, crash!
0064               
0065 79B2 C120  34         mov   @tfh.callback2,tmp0
     79B4 243E 
0066 79B6 0284  22         ci    tmp0,>6000            ; Insane address ?
     79B8 6000 
0067 79BA 110C  14         jlt   !                     ; Yes, crash!
0068               
0069 79BC 0284  22         ci    tmp0,>7fff            ; Insane address ?
     79BE 7FFF 
0070 79C0 1509  14         jgt   !                     ; Yes, crash!
0071               
0072 79C2 C120  34         mov   @tfh.callback3,tmp0
     79C4 2440 
0073 79C6 0284  22         ci    tmp0,>6000            ; Insane address ?
     79C8 6000 
0074 79CA 1104  14         jlt   !                     ; Yes, crash!
0075               
0076 79CC 0284  22         ci    tmp0,>7fff            ; Insane address ?
     79CE 7FFF 
0077 79D0 1501  14         jgt   !                     ; Yes, crash!
0078               
0079 79D2 1004  14         jmp   tfh.file.read.sams.load1
0080                                                   ; All checks passed, continue.
0081               
0082                                                   ;--------------------------
0083                                                   ; Sanity check failed
0084                                                   ;--------------------------
0085 79D4 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     79D6 FFCE 
0086 79D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     79DA 604C 
0087                       ;------------------------------------------------------
0088                       ; Show "loading indicator 1"
0089                       ;------------------------------------------------------
0090               tfh.file.read.sams.load1:
0091 79DC C120  34         mov   @tfh.callback1,tmp0
     79DE 243C 
0092 79E0 0694  24         bl    *tmp0                 ; Run callback function
0093                       ;------------------------------------------------------
0094                       ; Copy PAB header to VDP
0095                       ;------------------------------------------------------
0096               tfh.file.read.sams.pabheader:
0097 79E2 06A0  32         bl    @cpym2v
     79E4 6426 
0098 79E6 0A60                   data tfh.vpab,tfh.file.pab.header,9
     79E8 7B60 
     79EA 0009 
0099                                                   ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101                       ; Append file descriptor to PAB header in VDP
0102                       ;------------------------------------------------------
0103 79EC 0204  20         li    tmp0,tfh.vpab + 9     ; VDP destination
     79EE 0A69 
0104 79F0 C160  34         mov   @tfh.fname.ptr,tmp1   ; Get pointer to file descriptor
     79F2 2436 
0105 79F4 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0106 79F6 0986  56         srl   tmp2,8                ; Right justify
0107 79F8 0586  14         inc   tmp2                  ; Include length byte as well
0108 79FA 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     79FC 642C 
0109                       ;------------------------------------------------------
0110                       ; Load GPL scratchpad layout
0111                       ;------------------------------------------------------
0112 79FE 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7A00 6A18 
0113 7A02 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0114                       ;------------------------------------------------------
0115                       ; Open file
0116                       ;------------------------------------------------------
0117 7A04 06A0  32         bl    @file.open
     7A06 6B66 
0118 7A08 0A60                   data tfh.vpab         ; Pass file descriptor to DSRLNK
0119 7A0A 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7A0C 6042 
0120 7A0E 1602  14         jne   tfh.file.read.sams.record
0121 7A10 0460  28         b     @tfh.file.read.sams.error
     7A12 7B2A 
0122                                                   ; Yes, IO error occured
0123                       ;------------------------------------------------------
0124                       ; Step 1: Read file record
0125                       ;------------------------------------------------------
0126               tfh.file.read.sams.record:
0127 7A14 05A0  34         inc   @tfh.records          ; Update counter
     7A16 242E 
0128 7A18 04E0  34         clr   @tfh.reclen           ; Reset record length
     7A1A 2430 
0129               
0130 7A1C 06A0  32         bl    @file.record.read     ; Read file record
     7A1E 6BA8 
0131 7A20 0A60                   data tfh.vpab         ; \ i  p0   = Address of PAB in VDP RAM (without +9 offset!)
0132                                                   ; | o  tmp0 = Status byte
0133                                                   ; | o  tmp1 = Bytes read
0134                                                   ; / o  tmp2 = Status register contents upon DSRLNK return
0135               
0136 7A22 C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7A24 242A 
0137 7A26 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7A28 2430 
0138 7A2A C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7A2C 242C 
0139                       ;------------------------------------------------------
0140                       ; 1a: Calculate kilobytes processed
0141                       ;------------------------------------------------------
0142 7A2E A805  38         a     tmp1,@tfh.counter
     7A30 2434 
0143 7A32 A160  34         a     @tfh.counter,tmp1
     7A34 2434 
0144 7A36 0285  22         ci    tmp1,1024
     7A38 0400 
0145 7A3A 1106  14         jlt   !
0146 7A3C 05A0  34         inc   @tfh.kilobytes
     7A3E 2432 
0147 7A40 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7A42 FC00 
0148 7A44 C805  38         mov   tmp1,@tfh.counter
     7A46 2434 
0149                       ;------------------------------------------------------
0150                       ; 1b: Load spectra scratchpad layout
0151                       ;------------------------------------------------------
0152 7A48 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
     7A4A 699E 
0153 7A4C 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7A4E 6A3A 
0154 7A50 2100                   data scrpad.backup2   ; / >2100->8300
0155                       ;------------------------------------------------------
0156                       ; 1c: Check if a file error occured
0157                       ;------------------------------------------------------
0158               tfh.file.read.sams.check_fioerr:
0159 7A52 C1A0  34         mov   @tfh.ioresult,tmp2
     7A54 242C 
0160 7A56 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7A58 6042 
0161 7A5A 1602  14         jne   tfh.file.read.sams.check_setpage
0162                                                   ; No, goto (1d)
0163 7A5C 0460  28         b     @tfh.file.read.sams.error
     7A5E 7B2A 
0164                                                   ; Yes, so handle file error
0165                       ;------------------------------------------------------
0166                       ; 1d: Check if SAMS page needs to be set
0167                       ;------------------------------------------------------
0168               tfh.file.read.sams.check_setpage:
0169 7A60 C120  34         mov   @edb.next_free.ptr,tmp0
     7A62 2308 
0170 7A64 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     7A66 64D2 
0171                                                   ; \ i  tmp0  = Memory address
0172                                                   ; | o  waux1 = SAMS page number
0173                                                   ; / o  waux2 = Address of SAMS register
0174               
0175 7A68 C120  34         mov   @waux1,tmp0           ; Save SAMS page number
     7A6A 833C 
0176 7A6C 8804  38         c     tmp0,@tfh.sams.page   ; Compare page with current SAMS page
     7A6E 2438 
0177 7A70 1310  14         jeq   tfh.file.read.sams.nocompression
0178                                                   ; Same, skip to (2)
0179                       ;------------------------------------------------------
0180                       ; 1e: Increase SAMS page if necessary
0181                       ;------------------------------------------------------
0182 7A72 8804  38         c     tmp0,@tfh.sams.hpage  ; Compare page with highest SAMS page
     7A74 243A 
0183 7A76 1502  14         jgt   tfh.file.read.sams.switch
0184                                                   ; Switch page
0185 7A78 0224  22         ai    tmp0,5                ; Next range >b000 - ffff
     7A7A 0005 
0186                       ;------------------------------------------------------
0187                       ; 1f: Switch to SAMS page
0188                       ;------------------------------------------------------
0189               tfh.file.read.sams.switch:
0190 7A7C C160  34         mov   @edb.next_free.ptr,tmp1
     7A7E 2308 
0191                                                   ; Beginning of line
0192               
0193 7A80 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7A82 650A 
0194                                                   ; \ i  tmp0 = SAMS page number
0195                                                   ; / i  tmp1 = Memory address
0196               
0197 7A84 C804  38         mov   tmp0,@tfh.sams.page   ; Save current SAMS page
     7A86 2438 
0198               
0199 7A88 8804  38         c     tmp0,@tfh.sams.hpage  ; Current SAMS page > highest SAMS page?
     7A8A 243A 
0200 7A8C 1202  14         jle   tfh.file.read.sams.nocompression
0201                                                   ; No, skip to (2)
0202 7A8E C804  38         mov   tmp0,@tfh.sams.hpage  ; Update highest SAMS page
     7A90 243A 
0203                       ;------------------------------------------------------
0204                       ; Step 2: Process line (without RLE compression)
0205                       ;------------------------------------------------------
0206               tfh.file.read.sams.nocompression:
0207 7A92 0204  20         li    tmp0,tfh.vrecbuf      ; VDP source address
     7A94 0960 
0208 7A96 C160  34         mov   @edb.next_free.ptr,tmp1
     7A98 2308 
0209                                                   ; RAM target in editor buffer
0210               
0211 7A9A C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7A9C 8352 
0212               
0213 7A9E C1A0  34         mov   @tfh.reclen,tmp2      ; Number of bytes to copy
     7AA0 2430 
0214 7AA2 1324  14         jeq   tfh.file.read.sams.prepindex.emptyline
0215                                                   ; Handle empty line
0216                       ;------------------------------------------------------
0217                       ; 2a: Copy line from VDP to CPU editor buffer
0218                       ;------------------------------------------------------
0219                                                   ; Save line prefix
0220 7AA4 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0221 7AA6 06C6  14         swpb  tmp2                  ; |
0222 7AA8 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0223 7AAA 06C6  14         swpb  tmp2                  ; /
0224               
0225 7AAC 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7AAE 2308 
0226 7AB0 A806  38         a     tmp2,@edb.next_free.ptr
     7AB2 2308 
0227                                                   ; Add line length
0228                       ;------------------------------------------------------
0229                       ; 2b: Handle line split accross 2 consecutive SAMS pages
0230                       ;------------------------------------------------------
0231 7AB4 C1C4  18         mov   tmp0,tmp3             ; Backup tmp0
0232 7AB6 C205  18         mov   tmp1,tmp4             ; Backup tmp1
0233               
0234 7AB8 C105  18         mov   tmp1,tmp0             ; Get pointer to beginning of line
0235 7ABA 09C4  56         srl   tmp0,12               ; Only keep high-nibble
0236               
0237 7ABC C160  34         mov   @edb.next_free.ptr,tmp1
     7ABE 2308 
0238                                                   ; Get pointer to next line (aka end of line)
0239 7AC0 09C5  56         srl   tmp1,12               ; Only keep high-nibble
0240               
0241 7AC2 8144  18         c     tmp0,tmp1             ; Are they in the same segment?
0242 7AC4 1307  14         jeq   !                     ; Yes, skip setting SAMS page
0243               
0244 7AC6 C120  34         mov   @tfh.sams.page,tmp0   ; Get current SAMS page
     7AC8 2438 
0245 7ACA 0584  14         inc   tmp0                  ; Increase SAMS page
0246 7ACC C160  34         mov   @edb.next_free.ptr,tmp1
     7ACE 2308 
0247                                                   ; Get pointer to next line (aka end of line)
0248               
0249 7AD0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7AD2 650A 
0250                                                   ; \ i  tmp0 = SAMS page number
0251                                                   ; / i  tmp1 = Memory address
0252               
0253 7AD4 C148  18 !       mov   tmp4,tmp1             ; Restore tmp1
0254 7AD6 C107  18         mov   tmp3,tmp0             ; Restore tmp0
0255                       ;------------------------------------------------------
0256                       ; 2c: Do actual copy
0257                       ;------------------------------------------------------
0258 7AD8 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7ADA 6452 
0259                                                   ; \ i  tmp0 = VDP source address
0260                                                   ; | i  tmp1 = RAM target address
0261                                                   ; / i  tmp2 = Bytes to copy
0262               
0263 7ADC 1000  14         jmp   tfh.file.read.sams.prepindex
0264                                                   ; Prepare for updating index
0265                       ;------------------------------------------------------
0266                       ; Step 4: Update index
0267                       ;------------------------------------------------------
0268               tfh.file.read.sams.prepindex:
0269 7ADE C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7AE0 2304 
     7AE2 8350 
0270                                                   ; parm2 = Must allready be set!
0271 7AE4 C820  54         mov   @tfh.sams.page,@parm3 ; parm3 = SAMS page number
     7AE6 2438 
     7AE8 8354 
0272               
0273 7AEA 1009  14         jmp   tfh.file.read.sams.updindex
0274                                                   ; Update index
0275                       ;------------------------------------------------------
0276                       ; 4a: Special handling for empty line
0277                       ;------------------------------------------------------
0278               tfh.file.read.sams.prepindex.emptyline:
0279 7AEC C820  54         mov   @tfh.records,@parm1   ; parm1 = Line number
     7AEE 242E 
     7AF0 8350 
0280 7AF2 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7AF4 8350 
0281 7AF6 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7AF8 8352 
0282 7AFA 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7AFC 8354 
0283                       ;------------------------------------------------------
0284                       ; 4b: Do actual index update
0285                       ;------------------------------------------------------
0286               tfh.file.read.sams.updindex:
0287 7AFE 06A0  32         bl    @idx.entry.update     ; Update index
     7B00 76EE 
0288                                                   ; \ i  parm1    = Line number in editor buffer
0289                                                   ; | i  parm2    = Pointer to line in editor buffer
0290                                                   ; | i  parm3    = SAMS page
0291                                                   ; / o  outparm1 = Pointer to updated index entry
0292               
0293 7B02 05A0  34         inc   @edb.lines            ; lines=lines+1
     7B04 2304 
0294                       ;------------------------------------------------------
0295                       ; Step 5: Display results
0296                       ;------------------------------------------------------
0297               tfh.file.read.sams.display:
0298 7B06 C120  34         mov   @tfh.callback2,tmp0   ; Get pointer to "Loading indicator 2"
     7B08 243E 
0299 7B0A 0694  24         bl    *tmp0                 ; Run callback function
0300                       ;------------------------------------------------------
0301                       ; Step 6: Check if reaching memory high-limit >ffa0
0302                       ;------------------------------------------------------
0303               tfh.file.read.sams.checkmem:
0304 7B0C C120  34         mov   @edb.next_free.ptr,tmp0
     7B0E 2308 
0305 7B10 0284  22         ci    tmp0,>ffa0
     7B12 FFA0 
0306 7B14 1205  14         jle   tfh.file.read.sams.next
0307                       ;------------------------------------------------------
0308                       ; 6a: Address range b000-ffff full, switch SAMS pages
0309                       ;------------------------------------------------------
0310 7B16 0204  20         li    tmp0,edb.top+2        ; Reset to top of editor buffer
     7B18 B002 
0311 7B1A C804  38         mov   tmp0,@edb.next_free.ptr
     7B1C 2308 
0312               
0313 7B1E 1000  14         jmp   tfh.file.read.sams.next
0314                       ;------------------------------------------------------
0315                       ; 6b: Next record
0316                       ;------------------------------------------------------
0317               tfh.file.read.sams.next:
0318 7B20 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7B22 6A18 
0319 7B24 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0320               
0321 7B26 0460  28         b     @tfh.file.read.sams.record
     7B28 7A14 
0322                                                   ; Next record
0323                       ;------------------------------------------------------
0324                       ; Error handler
0325                       ;------------------------------------------------------
0326               tfh.file.read.sams.error:
0327 7B2A C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7B2C 242A 
0328 7B2E 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0329 7B30 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7B32 0005 
0330 7B34 1309  14         jeq   tfh.file.read.sams.eof
0331                                                   ; All good. File closed by DSRLNK
0332                       ;------------------------------------------------------
0333                       ; File error occured
0334                       ;------------------------------------------------------
0335 7B36 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7B38 6A3A 
0336 7B3A 2100                   data scrpad.backup2   ; / >2100->8300
0337               
0338 7B3C 06A0  32         bl    @mem.setup.sams.layout
     7B3E 7550 
0339                                                   ; Restore SAMS default memory layout
0340               
0341 7B40 C120  34         mov   @tfh.callback4,tmp0   ; Get pointer to "File I/O error handler"
     7B42 2442 
0342 7B44 0694  24         bl    *tmp0                 ; Run callback function
0343 7B46 100A  14         jmp   tfh.file.read.sams.exit
0344                       ;------------------------------------------------------
0345                       ; End-Of-File reached
0346                       ;------------------------------------------------------
0347               tfh.file.read.sams.eof:
0348 7B48 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7B4A 6A3A 
0349 7B4C 2100                   data scrpad.backup2   ; / >2100->8300
0350               
0351 7B4E 06A0  32         bl    @mem.setup.sams.layout
     7B50 7550 
0352                                                   ; Restore SAMS default memory layout
0353                       ;------------------------------------------------------
0354                       ; Show "loading indicator 3" (final)
0355                       ;------------------------------------------------------
0356 7B52 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     7B54 2306 
0357               
0358 7B56 C120  34         mov   @tfh.callback3,tmp0   ; Get pointer to "Loading indicator 3"
     7B58 2440 
0359 7B5A 0694  24         bl    *tmp0                 ; Run callback function
0360               *--------------------------------------------------------------
0361               * Exit
0362               *--------------------------------------------------------------
0363               tfh.file.read.sams.exit:
0364 7B5C 0460  28         b     @poprt                ; Return to caller
     7B5E 6220 
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
0375 7B60 0014             byte  io.op.open            ;  0    - OPEN
0376                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0377 7B62 0960             data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
0378 7B64 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0379                       byte  00                    ;  5    - Character count
0380 7B66 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0381 7B68 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0382                       ;------------------------------------------------------
0383                       ; File descriptor part (variable length)
0384                       ;------------------------------------------------------
0385                       ; byte  12                  ;  9    - File descriptor length
0386                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name)
**** **** ****     > tivi.asm.14086
0642               
0643               ***************************************************************
0644               *               fm - File manager modules
0645               ***************************************************************
0646                       copy  "filemanager_loadfile.asm"
**** **** ****     > filemanager_loadfile.asm
0001               * FILE......: filemanager_loadfile.asm
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
0014 7B6A 0649  14         dect  stack
0015 7B6C C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 7B6E C804  38         mov   tmp0,@parm1           ; Setup file to load
     7B70 8350 
0018 7B72 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7B74 77A2 
0019 7B76 06A0  32         bl    @idx.init             ; Initialize index
     7B78 76CA 
0020 7B7A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     7B7C 75B2 
0021                       ;-------------------------------------------------------
0022                       ; Clear VDP screen buffer
0023                       ;-------------------------------------------------------
0024 7B7E 06A0  32         bl    @filv
     7B80 627C 
0025 7B82 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7B84 0000 
     7B86 0004 
0026               
0027 7B88 C160  34         mov   @fb.screenrows,tmp1
     7B8A 2218 
0028 7B8C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7B8E 220E 
0029                                                   ; 16 bit part is in tmp2!
0030               
0031 7B90 04C4  14         clr   tmp0                  ; VDP target address
0032 7B92 0205  20         li    tmp1,32               ; Character to fill
     7B94 0020 
0033               
0034 7B96 06A0  32         bl    @xfilv                ; Fill VDP memory
     7B98 6282 
0035                                                   ; \ i  tmp0 = VDP target address
0036                                                   ; | i  tmp1 = Byte to fill
0037                                                   ; / i  tmp2 = Bytes to copy
0038                       ;-------------------------------------------------------
0039                       ; Read DV80 file and display
0040                       ;-------------------------------------------------------
0041 7B9A 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     7B9C 7BC6 
0042 7B9E C804  38         mov   tmp0,@parm2           ; Register callback 1
     7BA0 8352 
0043               
0044 7BA2 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     7BA4 7BFE 
0045 7BA6 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7BA8 8354 
0046               
0047 7BAA 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     7BAC 7C30 
0048 7BAE C804  38         mov   tmp0,@parm4           ; Register callback 3
     7BB0 8356 
0049               
0050 7BB2 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     7BB4 7C62 
0051 7BB6 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7BB8 8358 
0052               
0053 7BBA 06A0  32         bl    @tfh.file.read.sams   ; Read specified file with SAMS support
     7BBC 795A 
0054                                                   ; \ i  parm1 = Pointer to length prefixed file descriptor
0055                                                   ; | i  parm2 = Pointer to callback function "loading indicator 1"
0056                                                   ; | i  parm3 = Pointer to callback function "loading indicator 2"
0057                                                   ; | i  parm4 = Pointer to callback function "loading indicator 3"
0058                                                   ; / i  parm5 = Pointer to callback function "File I/O error handler"
0059               
0060 7BBE 04E0  34         clr   @edb.dirty            ; Editor buffer fully replaced, no longer dirty
     7BC0 2306 
0061               *--------------------------------------------------------------
0062               * Exit
0063               *--------------------------------------------------------------
0064               fm.loadfile.exit:
0065 7BC2 0460  28         b     @poprt                ; Return to caller
     7BC4 6220 
0066               
0067               
0068               
0069               *---------------------------------------------------------------
0070               * Callback function "Show loading indicator 1"
0071               *---------------------------------------------------------------
0072               * Is expected to be passed as parm2 to @tfh.file.read
0073               *---------------------------------------------------------------
0074               fm.loadfile.callback.indicator1:
0075 7BC6 0649  14         dect  stack
0076 7BC8 C64B  30         mov   r11,*stack            ; Save return address
0077                       ;------------------------------------------------------
0078                       ; Show loading indicators and file descriptor
0079                       ;------------------------------------------------------
0080 7BCA 06A0  32         bl    @hchar
     7BCC 6708 
0081 7BCE 1D00                   byte 29,0,32,80
     7BD0 2050 
0082 7BD2 FFFF                   data EOL
0083               
0084 7BD4 06A0  32         bl    @putat
     7BD6 641E 
0085 7BD8 1D00                   byte 29,0
0086 7BDA 7CBE                   data txt_loading      ; Display "Loading...."
0087               
0088 7BDC 8820  54         c     @tfh.rleonload,@w$ffff
     7BDE 2444 
     7BE0 6048 
0089 7BE2 1604  14         jne   !
0090 7BE4 06A0  32         bl    @putat
     7BE6 641E 
0091 7BE8 1D44                   byte 29,68
0092 7BEA 7CCE                   data txt_rle          ; Display "RLE"
0093               
0094 7BEC 06A0  32 !       bl    @at
     7BEE 6614 
0095 7BF0 1D0B                   byte 29,11            ; Cursor YX position
0096 7BF2 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7BF4 8350 
0097 7BF6 06A0  32         bl    @xutst0               ; Display device/filename
     7BF8 640E 
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101               fm.loadfile.callback.indicator1.exit:
0102 7BFA 0460  28         b     @poprt                ; Return to caller
     7BFC 6220 
0103               
0104               
0105               
0106               
0107               *---------------------------------------------------------------
0108               * Callback function "Show loading indicator 2"
0109               *---------------------------------------------------------------
0110               * Is expected to be passed as parm3 to @tfh.file.read
0111               *---------------------------------------------------------------
0112               fm.loadfile.callback.indicator2:
0113 7BFE 0649  14         dect  stack
0114 7C00 C64B  30         mov   r11,*stack            ; Save return address
0115               
0116 7C02 06A0  32         bl    @putnum
     7C04 6994 
0117 7C06 1D49                   byte 29,73            ; Show lines read
0118 7C08 2304                   data edb.lines,rambuf,>3020
     7C0A 8390 
     7C0C 3020 
0119               
0120 7C0E 8220  34         c     @tfh.kilobytes,tmp4
     7C10 2432 
0121 7C12 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0122               
0123 7C14 C220  34         mov   @tfh.kilobytes,tmp4   ; Save for compare
     7C16 2432 
0124               
0125 7C18 06A0  32         bl    @putnum
     7C1A 6994 
0126 7C1C 1D38                   byte 29,56            ; Show kilobytes read
0127 7C1E 2432                   data tfh.kilobytes,rambuf,>3020
     7C20 8390 
     7C22 3020 
0128               
0129 7C24 06A0  32         bl    @putat
     7C26 641E 
0130 7C28 1D3D                   byte 29,61
0131 7C2A 7CCA                   data txt_kb           ; Show "kb" string
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135               fm.loadfile.callback.indicator2.exit:
0136 7C2C 0460  28         b     @poprt                ; Return to caller
     7C2E 6220 
0137               
0138               
0139               
0140               
0141               
0142               *---------------------------------------------------------------
0143               * Callback function "Show loading indicator 3"
0144               *---------------------------------------------------------------
0145               * Is expected to be passed as parm4 to @tfh.file.read
0146               *---------------------------------------------------------------
0147               fm.loadfile.callback.indicator3:
0148 7C30 0649  14         dect  stack
0149 7C32 C64B  30         mov   r11,*stack            ; Save return address
0150               
0151               
0152 7C34 06A0  32         bl    @hchar
     7C36 6708 
0153 7C38 1D00                   byte 29,0,32,10       ; Erase loading indicator
     7C3A 200A 
0154 7C3C FFFF                   data EOL
0155               
0156 7C3E 06A0  32         bl    @putnum
     7C40 6994 
0157 7C42 1D38                   byte 29,56            ; Show kilobytes read
0158 7C44 2432                   data tfh.kilobytes,rambuf,>3020
     7C46 8390 
     7C48 3020 
0159               
0160 7C4A 06A0  32         bl    @putat
     7C4C 641E 
0161 7C4E 1D3D                   byte 29,61
0162 7C50 7CCA                   data txt_kb           ; Show "kb" string
0163               
0164 7C52 06A0  32         bl    @putnum
     7C54 6994 
0165 7C56 1D49                   byte 29,73            ; Show lines read
0166 7C58 242E                   data tfh.records,rambuf,>3020
     7C5A 8390 
     7C5C 3020 
0167                       ;------------------------------------------------------
0168                       ; Exit
0169                       ;------------------------------------------------------
0170               fm.loadfile.callback.indicator3.exit:
0171 7C5E 0460  28         b     @poprt                ; Return to caller
     7C60 6220 
0172               
0173               
0174               
0175               *---------------------------------------------------------------
0176               * Callback function "File I/O error handler"
0177               *---------------------------------------------------------------
0178               * Is expected to be passed as parm5 to @tfh.file.read
0179               *---------------------------------------------------------------
0180               fm.loadfile.callback.fioerr:
0181 7C62 0649  14         dect  stack
0182 7C64 C64B  30         mov   r11,*stack            ; Save return address
0183               
0184               
0185 7C66 06A0  32         bl    @hchar
     7C68 6708 
0186 7C6A 1D00                   byte 29,0,32,30       ; Erase loading indicator
     7C6C 201E 
0187 7C6E FFFF                   data EOL
0188               
0189 7C70 06A0  32         bl    @putat
     7C72 641E 
0190 7C74 1D00                   byte 29,0             ; Display message
0191 7C76 7CD8                   data txt_ioerr
0192               
0193 7C78 06A0  32         bl    @at                   ; Position cursor
     7C7A 6614 
0194 7C7C 1D0D                   byte 29,13
0195               
0196 7C7E C160  34         mov   @tfh.fname.ptr,tmp1   ; Get file descriptor
     7C80 2436 
0197 7C82 06A0  32         bl    @xutst0               ; Show file descriptor
     7C84 640E 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               fm.loadfile.callback.fioerr.exit:
0202 7C86 0460  28         b     @poprt                ; Return to caller
     7C88 6220 
**** **** ****     > tivi.asm.14086
0647               
0648               
0649               ***************************************************************
0650               *                      Constants
0651               ***************************************************************
0652               romsat:
0653 7C8A 0303             data >0303,>000f              ; Cursor YX, initial shape and colour
     7C8C 000F 
0654               
0655               cursors:
0656 7C8E 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7C90 0000 
     7C92 0000 
     7C94 001C 
0657 7C96 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7C98 1010 
     7C9A 1010 
     7C9C 1000 
0658 7C9E 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7CA0 1C1C 
     7CA2 1C1C 
     7CA4 1C00 
0659               
0660               ***************************************************************
0661               *                       Strings
0662               ***************************************************************
0663               txt_delim
0664 7CA6 012C             byte  1
0665 7CA7 ....             text  ','
0666                       even
0667               
0668               txt_marker
0669 7CA8 052A             byte  5
0670 7CA9 ....             text  '*EOF*'
0671                       even
0672               
0673               txt_bottom
0674 7CAE 0520             byte  5
0675 7CAF ....             text  '  BOT'
0676                       even
0677               
0678               txt_ovrwrite
0679 7CB4 034F             byte  3
0680 7CB5 ....             text  'OVR'
0681                       even
0682               
0683               txt_insert
0684 7CB8 0349             byte  3
0685 7CB9 ....             text  'INS'
0686                       even
0687               
0688               txt_star
0689 7CBC 012A             byte  1
0690 7CBD ....             text  '*'
0691                       even
0692               
0693               txt_loading
0694 7CBE 0A4C             byte  10
0695 7CBF ....             text  'Loading...'
0696                       even
0697               
0698               txt_kb
0699 7CCA 026B             byte  2
0700 7CCB ....             text  'kb'
0701                       even
0702               
0703               txt_rle
0704 7CCE 0352             byte  3
0705 7CCF ....             text  'RLE'
0706                       even
0707               
0708               txt_lines
0709 7CD2 054C             byte  5
0710 7CD3 ....             text  'Lines'
0711                       even
0712               
0713               txt_ioerr
0714 7CD8 0C4C             byte  12
0715 7CD9 ....             text  'Load failed:'
0716                       even
0717               
0718 7CE6 7CE6     end          data    $
0719               
0720               
0721               fdname0
0722 7CE8 0D44             byte  13
0723 7CE9 ....             text  'DSK1.INVADERS'
0724                       even
0725               
0726               fdname1
0727 7CF6 0F44             byte  15
0728 7CF7 ....             text  'DSK1.SPEECHDOCS'
0729                       even
0730               
0731               fdname2
0732 7D06 0C44             byte  12
0733 7D07 ....             text  'DSK1.XBEADOC'
0734                       even
0735               
0736               fdname3
0737 7D14 0C44             byte  12
0738 7D15 ....             text  'DSK3.XBEADOC'
0739                       even
0740               
0741               fdname4
0742 7D22 0C44             byte  12
0743 7D23 ....             text  'DSK3.C99MAN1'
0744                       even
0745               
0746               fdname5
0747 7D30 0C44             byte  12
0748 7D31 ....             text  'DSK3.C99MAN2'
0749                       even
0750               
0751               fdname6
0752 7D3E 0C44             byte  12
0753 7D3F ....             text  'DSK3.C99MAN3'
0754                       even
0755               
0756               fdname7
0757 7D4C 0D44             byte  13
0758 7D4D ....             text  'DSK3.C99SPECS'
0759                       even
0760               
0761               fdname8
0762 7D5A 0D44             byte  13
0763 7D5B ....             text  'DSK3.RANDOM#C'
0764                       even
0765               
0766               fdname9
0767 7D68 0D44             byte  13
0768 7D69 ....             text  'DSK1.INVADERS'
0769                       even
0770               
0771               
0772               
0773               ***************************************************************
0774               *                  Sanity check on ROM size
0775               ***************************************************************
0779 7D76 7D76              data $   ; ROM size OK.
